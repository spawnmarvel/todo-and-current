# v1.3
# Core application engine orchestrating runtime execution and loading local config.json

from email.policy import default
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
                    "Successfully loaded application configuration from %s", config_file
                )
                self.valid_config = True
                return data
        except Exception as ex:
            # Log any JSON parsing or file access errors without crashing execution
            self.logger.error("Failed to parse config.json: %s", str(ex))
            return {}

    def get_config(self, key_path: str, default=None):
        """Retrieves nested keys using dot notation (e.g., 'amqp.host' or 'database.port')."""
        keys = key_path.split(".")
        val = self.config

        for key in keys:
            if isinstance(val, dict) and key in val:
                val = val[key]
            else:
                return default
        return val

    def get_config_keys(self, key_path: str = "", default=None) -> list:
        """Retrieves clean dictionary keys at a nested path (e.g., 'amqp' or 'database').
    Excludes metadata/comment keys starting with '$'.
    """
        # Handle top-level keys lookup
        if not key_path:
            if isinstance(self.config, dict):
                return [k for k in self.config.keys() if not k.startswith("$")]
            return default

        keys = key_path.split(".")
        val = self.config

        for key in keys:
            if isinstance(val, dict) and key in val:
                val = val[key]
            else:
                return default

        # Extract keys and filter out metadata/comments starting with '$'
        if isinstance(val, dict):
            return [k for k in val.keys() if not k.startswith("$")]

        return default

    def amqp_config(self):
        """Returns the AMQP configuration dictionary."""
        self.logger.info("Retrieving AMQP configuration...")
        conf = self.get_config("amqp", {})
        self.logger.info("AMQP Configuration: %s", conf)
        return conf

    def database_config(self):
        """Returns the database configuration dictionary."""
        self.logger.info("Retrieving database configuration...")
        conf = self.get_config("database", {})
        self.logger.info("Database Configuration: %s", conf)
        return conf

    def zabbix_config(self):
        """Returns the Zabbix configuration dictionary."""
        self.logger.info("Retrieving Zabbix configuration...")
        conf = self.get_config("zabbix", {})
        self.logger.info("Zabbix Configuration: %s", conf)
        return conf

    def file_config(self):
        """Returns the file configuration dictionary."""
        self.logger.info("Retrieving file configuration...")
        conf = self.get_config("file", {})
        self.logger.info("File Configuration: %s", conf)
        return conf

    def run(self):
        """Executes the core application workload and iteration loops."""
        # Warn operator if execution is proceeding with missing or invalid configuration
        if not self.valid_config:
            self.logger.warning(
                "Starting application with invalid or missing configuration."
            )

        self.logger.info(
            "Application is running with multiple available configurations to choose from: %s", self.get_config_keys()
        )

        # load and validate configuration sections for AMQP, database, Zabbix, and file settings, example with database_config
        self.database_config()
        for i in range(10):
            self.logger.info("Application loop step %d/...", i + 1)
            # time.sleep(4)
