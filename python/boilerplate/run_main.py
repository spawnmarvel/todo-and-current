# v1.0
# Main entry point instantiating configuration, logger, and application instance


import time
import datetime as d
import signal
import sys
import os
import multiprocessing

# packet modules
import custom_app_logger as custom_app_logger
import custom_application as cust_app
logger = custom_app_logger.AppLogger().get()

MAIN_PID = None
"""
    Docker sends SIGTERM on stop, after 10 sec it sends kill
"""


def handler_stop_signals(signum, frame):
    logger.info("Got Signal:" + str(signum) + " " + str(frame))
    logger.info("The SIGTERM(15) signal is a generic signal used to terminate a program. SIGTERM provides an elegance way to kill program")
    time.sleep(2)
    logger.info("Starting to stop, throw exception to main for clean up")
    raise KeyboardInterrupt()


# signal.signal(signal.SIGINT, handler_stop_signals) # (SIGINT): interrupt the session from the dialogue station
# (SIGTERM): terminate the process in a soft way
signal.signal(signal.SIGTERM, handler_stop_signals)
# https://stackabuse.com/handling-unix-signals-in-python/

if __name__ == "__main__":
    """
    Main loop
    """
    logger.info("Module version above")
    logger.info("*******************")
    logger.info("*******************")
    screen_data = "Main module started " + str(d.datetime.now())
    logger.info(screen_data)
    worker = cust_app.CustomApplication()
    worker.run()

    try:
        MAIN_PID = os.getpid()
        logger.info("Main PID: " + str(MAIN_PID))

    except (KeyboardInterrupt, SystemExit) as ex:
        time.sleep(1)
        logger.info("Clean up done")
        logger.info("Stopped, bye, bye")
        sys.exit(0)
