# v1.3
# Main entry point managing application lifecycle, logger verification, and SIGTERM handling

import datetime as d
import os
import signal
import sys
import time

# Internal module imports (no instantiation at top-level import time)
import custom_app_logger as custom_application_logger
import custom_application as custom_application

MAIN_PID = None
logger = None


def handler_stop_signals(signum, frame):
    """Signal handler for graceful shutdown on receiving OS termination signals."""
    if logger:
        logger.info("Got Signal: %s %s", str(signum), str(frame))
        logger.info("SIGTERM received. Terminating process gracefully...")
    time.sleep(1)
    raise KeyboardInterrupt()


if __name__ == "__main__":
    # Instantiate logger wrapper after starting main execution
    logger_wrapper = custom_application_logger.CustomAppLogger()
    logger = logger_wrapper.get()

    # Register SIGTERM handler
    signal.signal(signal.SIGTERM, handler_stop_signals)

    # Log startup banner and timestamp FIRST
    logger.info("*******************")
    logger.info("Main module started %s", str(d.datetime.now()))
    logger.info("*******************")

    try:
        MAIN_PID = os.getpid()
        logger.info("Main PID: %s", str(MAIN_PID))

        worker = custom_application.CustomApplication()
        worker.run()

        # Check worker application configuration validity
        if not worker.valid_config:
            logger.warning("Application finished with invalid configuration")
            time.sleep(1)
            logger.info("Stopping application due to invalid configuration")
            logger.info("Stopped, bye, bye")
            sys.exit(0)

        # Check logger INI configuration validity via wrapper instance method
        if not logger_wrapper.is_valid_config():
            logger.warning("Logger finished with invalid configuration")
            time.sleep(1)
            logger.info(
                "Stopping application due to invalid logger configuration")
            logger.info("Stopped, bye, bye")
            sys.exit(0)

        logger.info("Application finished successfully")

    except (KeyboardInterrupt, SystemExit):
        time.sleep(1)
        if logger:
            logger.info(
                "Stopping application due to SIGTERM or KeyboardInterrupt")
            logger.info("Clean up done")
            logger.info("Stopped, bye, bye")
        sys.exit(0)
