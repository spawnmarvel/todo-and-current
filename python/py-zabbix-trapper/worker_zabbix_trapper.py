
# v1.0
# Worker class for handling Zabbix trapper operations using bundled zabbix_sender.exe

import subprocess
from pathlib import Path

import app_logger as app_logger

# Retrieve the shared logger instance during module initialization
logger = app_logger.AppLogger().get()


class ZabbixTrapperWorker:
    """Worker class for handling Zabbix trapper operations."""

    def __init__(self, config):
        self.config = config
        self.logger = logger
        logger.info(
            "ZabbixTrapperWorker initialized.")

        # Resolves binary path inside the local 'bin' subdirectory
        self.binary_path = Path.cwd() / "bin" / "zabbix_sender.exe"

    def connect(self):
        """Verifies that the bin/zabbix_sender.exe binary exists and is executable."""
        if not self.binary_path.exists():
            self.logger.error(
                "zabbix_sender.exe binary not found at %s", self.binary_path)
            return False

        self.logger.info(
            "Zabbix sender binary located successfully at %s", self.binary_path)
        return True

    def get_version(self) -> str:
        """Executes zabbix_sender.exe -V and returns version information."""
        if not self.binary_path.exists():
            self.logger.error(
                "zabbix_sender.exe binary not found at %s", self.binary_path)
            return ""

        cmd = [str(self.binary_path), "-V"]

        try:
            # Combine stdout and stderr to capture version banner from both streams
            result = subprocess.run(
                cmd,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                text=True,
                timeout=5,
                check=False
            )

            raw_output = result.stdout.strip() if result.stdout else ""

            if raw_output:
                # Get the first non-empty line of output
                lines = [line.strip()
                         for line in raw_output.splitlines() if line.strip()]
                version_line = lines[0] if lines else "Unknown"
                self.logger.debug("Zabbix Sender Raw Output: %s",
                                  raw_output.replace("\n", " | "))
                self.logger.info("Zabbix Sender Version: %s", version_line)
                return version_line
            else:
                self.logger.warning(
                    "zabbix_sender.exe -V executed but returned empty output.")
                return ""

        except Exception as ex:
            self.logger.error(
                "Error executing zabbix_sender.exe -V: %s", str(ex))
            return ""

    def send_trap(self, zabbix_server, port, host, key, value):
        """Send a trap to the Zabbix server."""
        # Implement the logic to send a trap to the Zabbix server
        self.logger.info(
            "Try send trapper data recieved:  %s %s %s", host, key, value)

        # navigate to bin and start use zabbix_sender.exe args
        if (self.connect()):
            self.logger.info("Zabbix binary init.")
            self.get_version()

            # Construct zabbix_sender.exe command arguments
            # bin\zabbix_sender.exe -z <server> -p <port> -s <host> -k <key> -o <value>
            cmd = [
                str(self.binary_path),
                "-z", str(zabbix_server),
                "-p", str(port),
                "-s", str(host),
                "-k", str(key),
                "-o", str(value)
            ]
            try:
                self.logger.info("Executing command: %s", " ".join(cmd))

                # Run binary via subprocess
                result = subprocess.run(
                    cmd,
                    capture_output=True,
                    text=True,
                    timeout=10,
                    check=False
                )

                if result.returncode == 0:
                    # Extract first line (e.g., "zabbix_sender (Zabbix) 7.0.0")
                    self.logger.info(
                        "Zabbix sender success output: %s", result.stdout.strip())
                    return True
                else:
                    self.logger.warning(
                        "Zabbix sender returned non-zero exit code %d. stdout: %s | stderr: %s",
                        result.returncode,
                        result.stdout.strip(),
                        result.stderr.strip()
                    )
                    return False

            except Exception as ex:
                self.logger.error(
                    "Failed to execute zabbix_sender.exe: %s", str(ex))
                return False

        else:
            self.logger.error(
                "Cannot send trap: zabbix_sender.exe missing at %s", self.binary_path)
