# v1.2.0
# Web and local file extractor supporting HTTP/HTTPS URLs and local file:/// URIs.

from pathlib import Path
from urllib.parse import unquote, urljoin, urlparse
import urllib.request
import requests
from bs4 import BeautifulSoup


class LocalAndWebTextExtractor:
    """Handles crawling, text extraction, and saving results for both web URLs and local file URIs."""

    def __init__(self, root_uri: str, output_filename: str = "extracted_text.txt", timeout: int = 10):
        self.root_uri = root_uri
        self.output_path = Path.cwd() / output_filename
        self.timeout = timeout
        self.headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
        }
        self.visited_uris = set()

    def _is_local(self, uri: str) -> bool:
        """Determines if the URI targets a local file path."""
        return uri.startswith("file://") or Path(uri).exists()

    def _get_local_path(self, uri: str) -> Path:
        """Converts a file:// URI or string path into a resolved Path object."""
        if uri.startswith("file://"):
            parsed = urlparse(uri)
            # Unquote percent-encoded spaces (%20) and trim leading slash on Windows
            raw_path = unquote(parsed.path)
            if raw_path.startswith("/") and len(raw_path) > 2 and raw_path[2] == ":":
                raw_path = raw_path[1:]
            return Path(raw_path)
        return Path(uri)

    def fetch_html_content(self, uri: str) -> str:
        """Fetches raw HTML string from either a local file path or an HTTP URL."""
        if self._is_local(uri):
            local_path = self._get_local_path(uri)
            if not local_path.exists():
                raise FileNotFoundError(f"Local file not found: {local_path}")
            with open(local_path, "r", encoding="utf-8", errors="ignore") as f:
                return f.read()
        else:
            response = requests.get(
                uri, headers=self.headers, timeout=self.timeout)
            response.raise_for_status()
            return response.text

    def fetch_and_extract_text(self, uri: str) -> str:
        """Parses HTML content and extracts clean body text."""
        try:
            html_content = self.fetch_html_content(uri)
            soup = BeautifulSoup(html_content, "html.parser")

            # Remove scripts, styles, and navigational elements
            for element in soup(["script", "style", "noscript", "header", "footer"]):
                element.decompose()

            return soup.get_text(separator=" ", strip=True)

        except Exception as ex:
            return f"[Error fetching {uri}: {ex}]"

    def discover_sub_links(self, uri: str) -> list:
        """Discovers internal links within the page or local HTML folder."""
        sub_links = set()
        try:
            html_content = self.fetch_html_content(uri)
            soup = BeautifulSoup(html_content, "html.parser")

            for anchor in soup.find_all("a", href=True):
                href = anchor["href"].strip()

                # Ignore mailto, javascript, or pure anchor targets
                if href.startswith(("javascript:", "mailto:", "#")):
                    continue

                full_link = urljoin(uri, href)

                # Strip fragment hashes (#section)
                parsed = urlparse(full_link)
                clean_link = parsed._replace(fragment="").geturl()

                if self._is_local(uri):
                    # Ensure sub-file exists locally
                    target_path = self._get_local_path(clean_link)
                    if target_path.exists() and target_path.suffix.lower() in (".html", ".htm"):
                        sub_links.add(target_path.as_uri())
                else:
                    sub_links.add(clean_link)

        except Exception:
            pass

        return sorted(list(sub_links))

    def run(self):
        """Executes processing and outputs results to local text file."""
        print(f"Starting extraction for: {self.root_uri}")
        print(f"Output saved to: {self.output_path}\n")

        with open(self.output_path, "w", encoding="utf-8") as file:
            # 1. Process Root URI
            root_text = self.fetch_and_extract_text(self.root_uri)
            file.write(f"=== Page: {self.root_uri} ===\n{root_text}\n\n")
            self.visited_uris.add(self.root_uri)
            print(f"Processed root: {self.root_uri}")

            # 2. Discover Sub-links
            sub_links = self.discover_sub_links(self.root_uri)

            # 3. Process Sub-links
            for link in sub_links:
                if link not in self.visited_uris:
                    self.visited_uris.add(link)
                    sub_text = self.fetch_and_extract_text(link)

                    if sub_text and not sub_text.startswith("[Error"):
                        # file.write(f"=== Page: {link} ===\n{sub_text}\n\n")
                        file.write(f"\n{sub_text}\n")
                        print(f"Processed link: {link}")

        print(f"\nExtraction complete! Saved to: {self.output_path}")


if __name__ == "__main__":
    target = r"file:///C:/Users/lima/OneDrive%20-%20company/Prog_ludo_Help_Files_Windows_CHM_FORMAT/decomp/html/index.html"
    extractor = LocalAndWebTextExtractor(root_uri=target)
    extractor.run()
