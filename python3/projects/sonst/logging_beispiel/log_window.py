import tkinter as tk
from tkinter.scrolledtext import ScrolledText
import socket
import threading
import logging

HOST = "127.0.0.1"
PORT = 5001



# root = tk.Tk()
# root.title("Log-Fenster")
# root.geometry("700x400")
#
# text = ScrolledText(root)
# text.pack(fill="both", expand=True)
#
# logfile = open("log.txt", "a", encoding="utf-8")


# ----------------------------
class LogWindow:
    def __init__(self):

        self.running = True
        self.counter = 0

        self.root = tk.Tk()
        self.root.title("Log-Fenster")
        self.root.geometry("700x400")

        self.text = ScrolledText(self.root, state="disabled")
        self.text.pack(fill="both", expand=True)

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
        file_handler = logging.FileHandler("log_test.txt", encoding="utf-8")
        # file_handler = logging.FileHandler("log_test.txt",mode="a", encoding="utf-8")
        file_handler.setFormatter(formatter)

        self.logger.addHandler(file_handler)


        # Console
        console_handler = logging.StreamHandler()
        console_handler.setFormatter(formatter)

        self.logger.addHandler(console_handler)

    def write(self, msg):
        self.text.config(state="normal",fg="red",bg="white")
        self.text.insert(tk.END, msg + "\n")
        self.text.see(tk.END)
        self.text.config(state="disabled")




    def run(self):
        self.root.mainloop()

    def server(self):

        s = socket.socket()
        s.bind((HOST, PORT))
        s.listen(1)

        while self.running:
            conn, addr = s.accept()
            data = conn.recv(4096).decode("utf-8")

            if data == "__EXIT__":
                conn.close()
                s.close()
                self.root.after(0, self.shutdown)
                return

            if data:
                self.root.after(0, self.add_log, data)

            conn.close()

    def add_log(self,msg):
        self.write(msg)
        self.counter += 1
        if self.counter % 2 == 0:
            self.logger.log(logging.INFO, msg)
        else:
            self.logger.log(logging.ERROR, msg)


    def shutdown(self):
        global running
        self.running = False
        self.root.destroy()

# # ----------------------------
# # Logging Handler fürs Fenster
# # ----------------------------
# class TextHandler(logging.Handler):
#     def __init__(self, log_window):
#         super().__init__()
#         self.log_window = log_window
#
#     def emit(self, record):
#         msg = self.format(record)
#
#         # Threadsafe ins GUI schreiben
#         self.log_window.root.after(0, self.log_window.write, msg)


# ----------------------------
# Start
# ----------------------------
log_window = LogWindow()

# Fenster anzeigen
# text_handler = TextHandler(log_window)
# text_handler.setFormatter(log_window.formatter)
# log_window.logger.addHandler(text_handler)

threading.Thread(target=log_window.server, daemon=True).start()

log_window.run()