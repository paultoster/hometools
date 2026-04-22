import tkinter as tk
import subprocess
import socket
import time

HOST = "127.0.0.1"
PORT = 5001

log_process = subprocess.Popen(["python", "log_window.py"])


def log(msg):
    try:
        s = socket.socket()
        s.connect((HOST, PORT))
        s.send(msg.encode("utf-8"))
        s.close()
    except:
        pass


def close_all():
    log("__EXIT__")
    root.destroy()


root = tk.Tk()
root.title("Hauptprogramm")
root.geometry("400x300")

def start_job():
    for i in range(10):
        log(f"Schritt {i}")
        root.update()
        time.sleep(1)

button1 = tk.Button(root, text="Start", command=start_job)
button1.pack(pady=50)

button2 = tk.Button(root, text="Beenden", command=close_all)
button2.pack(pady=50)

root.protocol("WM_DELETE_WINDOW", close_all)

root.mainloop()