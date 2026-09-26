# v1.8
# Configures stream and file loggers using a Singleton pattern to prevent duplicate initialization

import configparser
import logging
import sys
from os import path
from logging.config import fileConfig


class CustomAppLogger:
    """Configures application logging from an INI file with strict syntax verification, singleton pattern, and stdout fallback."""

    _instance = None  # Singleton instance handle

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(CustomAppLogger, cls).__new__(cls)
            cls._instance._initialized = False
        return cls._instance

    def __init__(self):
        # Guard against duplicate initialization if CustomAppLogger() is called multiple times
        if self._initialized:
            return

        self.valid_logging_config = False

        log_file_path = path.join(
            path.dirname(path.abspath(__file__)), 'logging_config.ini'
        )

        try:
            # Pre-validate INI syntax and eval args expressions prior to calling fileConfig
            self._verify_ini_file(log_file_path)

            # Load logging setup from validated INI file
            fileConfig(log_file_path, disable_existing_loggers=False)
            self.logger = logging.getLogger()
            self.valid_logging_config = True

            # Log successful initialization of logging configuration (emitted exactly once)
            self.logger.info("*******************")
            self.logger.info(
                "Successfully loaded logging configuration from %s", log_file_path)

        except Exception as ex:
            # Fallback configuration if logging_config.ini fails validation, parsing, or is missing
            logging.basicConfig(
                level=logging.INFO,
                format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
                handlers=[logging.StreamHandler(sys.stdout)]
            )
            self.logger = logging.getLogger()
            self.valid_logging_config = False
            self.logger.error(
                "Failed to load logging config from '%s': %s. Falling back to basicConfig.",
                log_file_path,
                str(ex)
            )

        self._initialized = True

    def _verify_ini_file(self, file_path: str) -> None:
        """Parses and evaluates all handler args in the INI file to detect invalid syntax or malformed expressions."""
        if not path.exists(file_path):
            raise FileNotFoundError(
                f"Logging configuration file missing: {file_path}")

        parser = configparser.ConfigParser()
        parsed_files = parser.read(file_path, encoding="utf-8")
        if not parsed_files:
            raise ValueError(f"Could not parse INI file: {file_path}")

        # Check required INI sections
        required_sections = ["loggers", "handlers", "formatters"]
        for section in required_sections:
            if not parser.has_section(section):
                raise ValueError(
                    f"Missing required section '[{section}]' in {file_path}")

        # Validate and test-eval every 'args' key under handlers
        for section_name in parser.sections():
            if section_name.startswith("handler_") and parser.has_option(section_name, "args"):
                raw_args = parser.get(section_name, "args")
                try:
                    # Evaluate args in a controlled environment with sys imported
                    eval_result = eval(raw_args, {"sys": sys})
                    if not isinstance(eval_result, tuple):
                        raise TypeError(
                            f"Section [{section_name}] 'args' must evaluate to a tuple")
                except Exception as eval_err:
                    raise ValueError(
                        f"Invalid 'args' expression in section [{section_name}]: '{raw_args}'. Error: {eval_err}"
                    )

    def get(self):
        """Returns the actual logger instance from logging module."""
        return self.logger

    def is_valid_config(self) -> bool:
        """Returns True if logging_config.ini was successfully validated and loaded, False otherwise."""
        return self.valid_logging_config
