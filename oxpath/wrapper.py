"""
    Python Wrapper Script
    Author: hendrik.adam@smail.th-koeln.de
"""
import os
import time
import threading
import subprocess
import logging
import hashlib
import signal
from shutil import move

# We do not collect the signals from the child process, so we tell him that it can die after running
signal.signal(signal.SIGCHLD, signal.SIG_IGN)

files_processing = []
logging.basicConfig(level=logging.DEBUG, format='[*] %(asctime)s - %(threadName)s-%(thread)s: %(message)s')

class Processor(threading.Thread):
    def __init__(self, file, hash):
        self._file = file
        self._hash = hash
        threading.Thread.__init__(self)
        thread = threading.Thread(target=self.run, args=(), name="ProcessorThread")
        thread.daemon = True
        thread.start()

    def run(self):
        logging.debug("Processing File: " + self._file)
        try:
            if not os.path.isfile("/usr/src/oxpath/oxpath-cli.jar"):
                logging.debug("OXpath missing - check your configuration")
            else:
                ret = subprocess.check_call("java -jar /usr/src/oxpath/oxpath-cli.jar -q /usr/src/oxpath/input/"+self._file+" -f xml -o /usr/src/oxpath/output/" + self._file +"_output.xml -xvfb -d 99 -mval", shell=True)
                logging.debug("Returning: " + str(ret))
                if ret:
                    logging.debug("Processing of file failed!")
                else:
                    move("/usr/src/oxpath/input/"+self._file, "/usr/src/oxpath/output/"+self._file)
                    logging.debug("Finished processing - file moved")
            files_processing.remove(self._hash)

        except Exception as e:
            logging.debug("Error processing file " + str(e))


def isCurrentlyProcessing(hash):
    if hash in files_processing:
        logging.debug("File is already processing")
        return True
    return False

"""
    Source: https://stackoverflow.com/questions/3431825/generating-an-md5-checksum-of-a-file
"""
def md5(fname):
    hash_md5 = hashlib.md5()
    with open(fname, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()

def scanInputFolder():
    for file in os.listdir("/usr/src/oxpath/input"):
        if file:
            logging.debug("Found: " + file)
            hash = md5("/usr/src/oxpath/input/"+file)
            logging.debug("Hash of File: " + hash)
            if not isCurrentlyProcessing(hash):
                files_processing.append(hash)
                Processor(file, hash)

def main():
    logging.debug("Wrapper started")
    while True:
        scanInputFolder()
        time.sleep(60)

if __name__ == "__main__":
    main()
