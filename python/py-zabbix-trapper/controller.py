# v1.3
# Core application engine orchestrating runtime execution and loading local config.json

from email.policy import default
import json
import time
from pathlib import Path
# internal modules
import app_logger as app_logger
import worker_zabbix_trapper as worker_zabbix_trapper
import worker_file as worker_file

# Retrieve the shared logger instance during module initialization
logger = app_logger.AppLogger().get()


class Controller:
    """Manages application lifecycle, configuration loading, and primary workload execution."""

    def __init__(self):
        # Attach logger and initialize configuration state flags
        self.logger = logger
        self.valid_config = False
        self.config_file_path = None
        self.config = self._load_config()
        self.file_worker = None
        self.zabbix_worker = None

    def _load_config(self) -> dict:
        """Reads and parses 'config.json' from the current working directory.

        Returns a dictionary containing configuration parameters, or an empty 
        dictionary if the file is missing or invalid. Sets self.valid_config to True 
        on successful parsing.
        """
        # Resolve config file path relative to the current working directory
        config_file = Path.cwd() / "config.json"
        # get the path
        self.config_file_path = Path.cwd() / "config.json"

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

    def zabbix_config(self):
        """Returns the Zabbix configuration dictionary."""
        self.logger.info("Retrieving Zabbix configuration...")
        conf = self.get_config("zabbix", {})
        self.logger.info("Zabbix Configuration initialized.")
        return conf

    def file_config(self):
        """Returns the file configuration dictionary."""
        self.logger.info("Retrieving file configuration...")
        conf = self.get_config("file", {})
        self.logger.info("File Configuration initialized.")
        return conf

    def init_file_and_zabbix_workers(self):
        # Move worker initialization out of the loop into the placeholder
        # Move instantiation of worker classes into init_file_and_zabbix_workers()
        # self.file_worker =
        # self.zabbix_worker =
        pass

    def _setup_runtime_parameters(self):
        # Current Issue: Extracting dictionary fields like file_path, file_separator, zabbix_server, and zabbix_port clutters the entry flow of run()
        pass

    def run(self):
        """Executes the core application workload and iteration loops."""
        do_run = True
        self.logger.info("Do work is: %s", do_run)
        # Warn operator if execution is proceeding with missing or invalid configuration
        if not self.valid_config:
            self.logger.warning(
                "Starting application with invalid or missing configuration."
            )

        self.logger.info(
            "Application is running with multiple available configurations to choose from: %s", self.get_config_keys()
        )
        # do logic to read file and send traps to Zabbix server
        self.logger.info("Read a file")

        # we now have a dictionary with the file configuration
        file_json = self.file_config()
        file_path = file_json["file_path"]
        file_separator = file_json["file_separator"]
        file_encoding = file_json["file_encoding"]
        self.logger.info("File path: %s", file_path)
        self.logger.info("File separator: %s", file_separator)
        self.logger.info("File encoding: %s", file_encoding)

        # zabbix we need
        zabbix_json = self.zabbix_config()
        zabbix_server = zabbix_json["zabbix_server"]
        zabbix_port = zabbix_json["port"]
        self.logger.info(
            "Zabbix server: view configuration in %s", self.config_file_path)
        self.logger.info("Zabbix port: %s", zabbix_port)

        # we need to make it run in a loop
        while do_run:
            # instance file object
            worker_file_template = worker_file.FileWorker(file_json)
            data = worker_file_template.read_file(
                file_path, file_separator, file_encoding)

            # instance zabbix object
            worker_zabbix_template = worker_zabbix_trapper.ZabbixTrapperWorker(
                self.zabbix_config())

            if data is None:
                pass
            else:
                logger.info("Data try send to zabbix: %s", data)

            if worker_file_template.get_monitoring_file_exists():
                # iterate over each item and send them
                for d in data:
                    worker_zabbix_template.send_trap(
                        zabbix_server, zabbix_port, d[0], d[1], d[2])
            else:
                self.logger.error(
                    "The file with monitoring data does not exists, nothing to send.")

            # sleep for 10 sec
            self.logger.info(
                "Sleep for 30 seconds while we wait for new updates in the the text file: %s", file_path)
            time.sleep(30)

        #
        # self.logger.info("Send traps to Zabbix server")

        # self.logger.info("Worker logic executed successfully.")
