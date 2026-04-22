import tkinter as tk
from tkinter.scrolledtext import ScrolledText
import socket
import threading

HOST = "127.0.0.1"
PORT = 5001

running = True

root = tk.Tk()
root.title("Log-Fenster")
root.geometry("700x400")

text = ScrolledText(root)
text.pack(fill="both", expand=True)

logfile = open("log.txt", "a", encoding="utf-8")


def add_log(msg):
    text.insert(tk.END, msg + "\n")
    text.see(tk.END)
    logfile.write(msg + "\n")
    logfile.flush()


def shutdown():
    global running
    running = False
    logfile.close()
    root.destroy()


def server():
    global running

    s = socket.socket()
    s.bind((HOST, PORT))
    s.listen(1)

    while running:
        conn, addr = s.accept()
        data = conn.recv(4096).decode("utf-8")

        if data == "__EXIT__":
            conn.close()
            s.close()
            root.after(0, shutdown)
            return

        if data:
            root.after(0, add_log, data)

        conn.close()


threading.Thread(target=server, daemon=True).start()

root.mainloop()