# v1.3
# Core application engine orchestrating runtime execution and loading local config.json

import json
import time
from pathlib import Path
# internal modules
import custom_app_logger as custom_app_logger

# Retrieve the shared logger instance during module initialization
logger = custom_app_logger.CustomAppLogger().get()


class CustomApplication:
    """Manages application lifecycle, configuration loading, and primary workload execution."""

    def __init__(self):
        # Attach logger and initialize configuration state flags
        self.logger = logger
        self.valid_config = False
        self.config = self._load_config()

    def _load_config(self) -> dict:
        """Reads and parses 'config.json' from the current working directory.

        Returns a dictionary containing configuration parameters, or an empty 
        dictionary if the file is missing or invalid. Sets self.valid_config to True 
        on successful parsing.
        """
        # Resolve config file path relative to the current working directory
        config_file = Path.cwd() / "config.json"

        # Check if config.json exists before attempting to read
        if not config_file.exists():
            self.logger.warning("config.json not found in %s", Path.cwd())
            return {}

        # Safely open and parse the JSON file
        try:
            with open(config_file, "r", encoding="utf-8") as f:
                data = json.load(f)
                self.logger.info(
                    "Successfully loaded configuration from %s", config_file
                )
                self.valid_config = True
                return data
        except Exception as ex:
            # Log any JSON parsing or file access errors without crashing execution
            self.logger.error("Failed to parse config.json: %s", str(ex))
            return {}

    def run(self):
        """Executes the core application workload and iteration loops."""
        # Warn operator if execution is proceeding with missing or invalid configuration
        if not self.valid_config:
            self.logger.warning(
                "Starting application with invalid or missing configuration."
            )

        self.logger.info(
            "Application is running with configuration: %s", self.config
        )

        # Main application execution loop
        for i in range(10):
            self.logger.info("Application loop step %d/...", i + 1)
            time.sleep(4)
