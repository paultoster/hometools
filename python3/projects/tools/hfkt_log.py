# -*- coding: utf8 -*-
#
# log: Logfile und terminal ausgabe
#
#  class log mit
#  log.write(text="",screen=0/1)       write text to cue / screen
#  log.write_e(text="",screen=0/1)     write with endl
#  log.write_err(text="",screen=0/1)   write as an error
#  log.write_warn(text="",screen=0/1)  write as  warning
#
# verionen:
# 0.0
#

import os
import sys
# import pathlib
import logging
import datetime
import tkinter as tk
import subprocess
import socket
import time



# -------------------------------------------------------------------------------
t_path, _ = os.path.split(__file__)
if (t_path == os.getcwd()):

    import hfkt_def as hfkt_def
    import hfkt as h
else:
    p_list = os.path.normpath(t_path).split(os.sep)
    if (len(p_list) > 1): p_list = p_list[: -1]
    t_path = ""
    for i, item in enumerate(p_list): t_path += item + os.sep
    if (os.path.normpath(t_path) not in sys.path): sys.path.append(t_path)

    from tools import hfkt_def as hfkt_def
    from tools import hfkt as h
# end if

# endif--------------------------------------------------------------------------
class log:
    NO_SCREEN = 0
    PRINT_SCREEN = 1
    GUI_SCREEN = 2

    HOST = hfkt_def.LOG_HOST
    PORT = hfkt_def.LOG_PORT

    EXIT_TOKEN        = hfkt_def.EXIT_TOKEN
    COLOR_GREEN_TOKEN = hfkt_def.COLOR_GREEN_TOKEN
    COLOR_RED_TOKEN   = hfkt_def.COLOR_RED_TOKEN
    COLOR_BLUE_TOKEN  = hfkt_def.COLOR_BLUE_TOKEN
    COLOR_BLACK_TOKEN = hfkt_def.COLOR_BLACK_TOKEN


    NOT_OKAY = hfkt_def.NOT_OKAY
    OKAY     = hfkt_def.OKAY

    def __init__(self, log_file=None, consol_func=None,log_window=None):
        """ Log-Datei oeffnen
        """
        self.state = hfkt_def.OKAY
        self.errtext = ""
        self.logfile_out_flag = False
        self.log_message = []

        # Logfile-Name
        # -------------
        if (not log_file):
            self.log_file = datetime.datetime.now().strftime("Log_%Y%m%d_%H%M.log")
        else:
            self.log_file = log_file

        # console
        self.consol_func = consol_func

        # build own gui and write in log-message as long as log is open
        self.log_window = log_window
        self.log_window_open = False

        (path, body, ext) = h.file_split(self.log_file)

        if (len(path) == 0):
            path = os.path.abspath(os.curdir)
            self.log_file = os.path.join(path, self.log_file)

        self.open()

        # if self.log_window:
        #    self.build_log_window()

    # -----------------------------------------------------------------------------
    def __del__(self):
        self.close()


    # -----------------------------------------------------------------------------
    def open(self):
        # Log-File öffnen
        # ----------------
        try:
            # Logger konfigurieren
            self.logger = logging.getLogger()
            self.logger.setLevel(logging.INFO)

            # Fenster anzeigen
            # formatter = logging.Formatter("%(asctime)s - %(message)s")
            formatter = logging.Formatter(
                fmt="%(asctime)s:%(levelname)s:%(message)s",
                datefmt="%Y%m%d:%H%M%S"
            )
            # Datei speichern
            file_handler = logging.FileHandler(self.log_file, mode="w", encoding="utf-8")
            file_handler.setFormatter(formatter)
            self.logger.addHandler(file_handler)

            if self.consol_func != None:
                console_handler = logging.StreamHandler()
                console_handler.setFormatter(formatter)

                self.logger.addHandler(console_handler)
            # end if

            self.logfile_out_flag = True

        except IOError:
            self.errtext = "IO-error of opening log_file <%s>" % self.log_file
            print(self.errtext)
            self.state = hfkt_def.NOT_OK
            self.logfile_out_flag = False
            # self.fid = 0

        try:
            if self.log_window != None:

                self.log_process = subprocess.Popen(["python", "log_window_anwendung_als_server.py"])

                self.log_window_open = True

        except:

            self.errtext = "IO-error of opening subprocess python log_window_anwendung_einszweidrei.py"
            print(self.errtext)
            self.state = hfkt_def.NOT_OK
            self.log_window_open = False


    # -----------------------------------------------------------------------------
    def close(self):
        if (self.logfile_out_flag):
            try:

                handlers = self.logger.handlers[:]
                for handler in handlers:
                    self.logger.removeHandler(handler)
                    handler.close()
                # end for
                self.logfile_out_flag = False
            except IOError:
                print("IO-error of close log_file <%s>" % self.log_file)

        if self.log_window_open:
            self.log_window_set(self.EXIT_TOKEN)
            # time.sleep(1)
            # self.log_process.terminate()
            self.log_window_open = False

    # -----------------------------------------------------------------------------
    def write(self, text, screen=0, title=None):

        # type
        if title == "error":
            type = logging.ERROR
        elif title == "warn":
            type = logging.WARN
        elif title == "info":
            type = logging.INFO
        else:
            type = logging.INFO
        # end if

        # log-message in Datei schreiben
        if self.logfile_out_flag:
            self.logger.log(type, text)
        # en dif

        # log-message in Buffer schreiben
        self.log_message.append(text)

        # log-message auf den Bildschirm schreiben
        if self.log_window_open:
            if type == logging.INFO:
                self.log_window_set(self.COLOR_BLACK_TOKEN)
            elif type == logging.WARN:
                self.log_window_set(self.COLOR_BLUE_TOKEN)
            else:
                self.log_window_set(self.COLOR_RED_TOKEN)
            # end if
            # time.sleep(3)
            self.log_window_set(text)
        # end if
    # enddef
    # -----------------------------------------------------------------------------
    def write_e(self, text, screen=0, title=None):

        self.write(text, screen, title=title)

    # -----------------------------------------------------------------------------
    def write_err(self, text, screen=0, title="error"):

        self.write(text, screen, title=title)

    # -----------------------------------------------------------------------------
    def write_warn(self, text, screen=0, title="warn"):

        self.write(text, screen, title=title)

    # -----------------------------------------------------------------------------
    def write_info(self, text, screen=0, title="info"):

        self.write(text, screen, title=title)

    # -----------------------------------------------------------------------------
    def get_next_message(self):
        """
        nächsten Wert des Message-Buffers auslesen
        return Textzeile oder None
        """
        if (len(self.log_message)):
            t = self.log_message[0]
            self.log_message = self.log_message[1:]
        else:
            t = None
        return t

    # -----------------------------------------------------------------------------
    # def build_log_window(self):
    #
    #     self.root = tk.Tk()
    #     self.S = tk.Scrollbar(self.root)
    #     self.T = tk.Text(self.root, height=40, width=200)
    #     self.S.pack(side=tk.RIGHT, fill=tk.Y)
    #     self.T.pack(side=tk.LEFT, fill=tk.Y)
    #     self.S.config(command=self.T.yview)
    #     self.T.config(yscrollcommand=self.S.set)
    #     tk.mainloop()
    #     self.log_window_open = True

    def log_window_set(self,msg):
        try:
            s = socket.socket()
            s.connect((self.HOST, self.PORT))
            s.send(msg.encode("utf-8"))
            s.close()
        except:
            pass


###########################################################################
# testen mit main
###########################################################################
if __name__ == '__main__':
    log_obj = log(consol_func=True,log_window=True)

    log_obj.write_err("Ein Fehler")
    log_obj.write_warn("Als Warnung")
    log_obj.write_info("Zur Info")

    log_obj.close()
    exit(0)

