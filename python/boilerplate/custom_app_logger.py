# v1.0
# Configures stream and file loggers based on runtime configuration

import logging
from os import path
from logging.config import fileConfig

# packet modules
import custom_app_logger as custom_app_logger
import custom_application as cust_app
logger = custom_app_logger.AppLogger().get()


class AppLogger:
    def __init__(self):
        log_file_path = path.join(path.dirname(
            path.abspath(__file__)), 'logging_config.ini')
        fileConfig(log_file_path)
        self.logger = logger

    def get(self):
        """ Returns the actual logger from logging module """
        return self.logger
