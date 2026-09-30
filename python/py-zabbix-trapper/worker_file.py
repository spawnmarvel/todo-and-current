
import app_logger as app_logger

# Retrieve the shared logger instance during module initialization
logger = app_logger.AppLogger().get()


class FileWorker:
    """Worker class for handling file operations."""

    def __init__(self, config):
        self.config = config
        self.logger = logger
        logger.info(
            "FileWorker initialized.")
        self.file_exists = False

    def read_file(self, file_path, separator, encoding):
        """Read data from a file and return it as a list of tuples."""
        data = []
        try:
            with open(file_path, 'r', encoding=encoding) as file:
                for line in file:
                    parts = line.strip().split(separator)
                    if len(parts) == 3:
                            data.append((parts[0], parts[1], parts[2]))
                    self.file_exists = True
            # iterate through the data and log each entry for debugging purposes
            for f in data:
                self.logger.info("File data read: %s", str(f))
            return data
        except Exception as ex:
            self.logger.error("The file with monitoring data does not exists %s ", str(file_path))
    
    def get_monitoring_file_exists(self):
        return self.file_exists
    
    def write_file(self, file_path, data):
        """Write data to the specified file."""
        # Implement the logic to write data to the file
        pass
