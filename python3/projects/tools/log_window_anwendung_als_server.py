
import tkinter as tk
from tkinter.scrolledtext import ScrolledText
import socket
import threading
import os, sys

# -------------------------------------------------------------------------------
# print(f" {__file__ = }")
t_path, _ = os.path.split(__file__)
if len(t_path) > 0:
    tools_path = t_path + "\\.."
else:
    tools_path = ".."
# end if

if tools_path not in sys.path:
    # print("sys.path.append(tools_path)")
    sys.path.append(tools_path)
# endif
# print(f" {tools_path = }")

from tools import hfkt_def as hfkt_def

# if (t_path == os.getcwd()):
#
#     import hfkt_def as hfkt_def
# else:
#     p_list = os.path.normpath(t_path).split(os.sep)
#     if (len(p_list) > 1): p_list = p_list[: -1]
#     t_path = ""
#     for i, item in enumerate(p_list): t_path += item + os.sep
#     if (os.path.normpath(t_path) not in sys.path): sys.path.append(t_path)
#
#     from tools import hfkt_def as hfkt_def
# # end if

# ----------------------------
class LogWindow:
    def __init__(self):

        self.running = True
        self.line_counter = 0
        self.fg_color = 'black'

        self.root = tk.Tk()
        self.root.title("Log-Fenster")
        self.root.geometry("700x400")

        self.text = ScrolledText(self.root, state="disabled")
        self.text.pack(fill="both", expand=True)

    def write(self, msg):

        msg_list = msg.split("\n")
        for msg in msg_list:
            self.line_counter += 1
            msg_len = len(msg)
            self.text.config(state="normal",fg='black',bg="white")
            self.text.insert(tk.END, msg + "\n")
            self.text.see(tk.END)
            self.text.config(state="disabled")

            if self.fg_color != "black":
                tag_name = f"tag_{self.line_counter}"
                start_col = f"{self.line_counter}.0"
                end_col = f"{self.line_counter}.{msg_len}"
                self.text.tag_add(tag_name, start_col, end_col)
                self.text.tag_configure(tag_name, background="white", foreground=self.fg_color)
            # endif

    def run(self):
        self.root.mainloop()

    def server(self):

        s = socket.socket()
        s.bind((hfkt_def.LOG_HOST, hfkt_def.LOG_PORT))
        s.listen(1)

        while self.running:
            conn, addr = s.accept()
            data = conn.recv(4096).decode("utf-8")

            if data == hfkt_def.EXIT_TOKEN:
                conn.close()
                s.close()
                self.root.after(0, self.shutdown)
                return
            # end if

            if data:
                if data == hfkt_def.COLOR_BLUE_TOKEN:
                    self.fg_color = 'blue'
                elif data == hfkt_def.COLOR_GREEN_TOKEN:
                    self.fg_color = 'green'
                elif data == hfkt_def.COLOR_RED_TOKEN:
                    self.fg_color = 'red'
                elif data == hfkt_def.COLOR_BLACK_TOKEN:
                    self.fg_color = 'black'
                else:
                    self.root.after(0, self.write, data)
                # endif
            # endif
            conn.close()

    def shutdown(self):
        self.running = False
        self.root.destroy()


# ----------------------------
# Start
# ----------------------------
log_window = LogWindow()


threading.Thread(target=log_window.server, daemon=True).start()

log_window.run()