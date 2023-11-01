import tkinter as tk
from tkinter.filedialog import askopenfilename, asksaveasfilename

from dataclasses import dataclass, field
from typing import List

import small_vector_graphic as s

@dataclass
class CBaseData:
    '''Store all base datas'''
    filepathname: str = ''
    command_liste: List[s.c.CBasic] = field(default_factory=list)
    x0: float = 0.0
    y0: float = 0.0


BaseData = CBaseData()



window = tk.Tk()
window.title("Text Editor")

txt = tk.Text(window, fg='purple', bg='light yellow', font='Calibri 14')
txt.pack()

def open_file():
    filepath = askopenfilename(filetypes=[("Text file", "*.txt"),("All Files","*.*")])
    if not filepath:
        return
    #endif

    txt.delete("1.0",tk.END)

    with open(filepath, mode='r', encoding='utf-8') as input_file:
        text = input_file.read()
        txt.insert(tk.END, text)
        window.title(f'Simple Text Editor - {filepath}')
    #endwith

    BaseData.filepathname = filepath

def save_as_file():

    filepath = asksaveasfilename(defaultextension='.txt', filetypes=[("Text Files","*.txt"),("All Files","*.*")])
    if not filepath:
        return

    with open(filepath, mode='w', encoding='utf-8') as output_file:
        text = txt.get('1.0', tk.END)
        output_file.write(text)
        window.title(f'Simple Text Editor - {filepath}')

    BaseData.filepathname = filepath

def save_file():

    filepath = BaseData.filepathname

    with open(filepath, mode='w', encoding='utf-8') as output_file:
        text = txt.get('1.0', tk.END)
        output_file.write(text)
        window.title(f'Simple Text Editor - {filepath}')

def proof_graph():

    text = txt.get('1.0', tk.END)

    input_liste = text.split("\n")

    (flag,errtext,BaseData.command_liste) = s.build_and_proof_input(input_liste)


    if( not flag ):
       tk.messagebox.showerror(title="ErrorWhileBuildAndProofCommand",message=errtext)
    #endif

    # print(f"{BaseData.command_liste}")


menu = tk.Menu(window)
window.config(menu=menu)
filemenu = tk.Menu(menu)
graphmenu = tk.Menu(menu)

menu.add_cascade(label='File', menu=filemenu)
filemenu.add_command(label='Open', command=open_file)
filemenu.add_command(label='Save As...', command=save_as_file)
filemenu.add_command(label='Save', command=save_file)
menu.add_cascade(label='Graph', menu=graphmenu)
graphmenu.add_command(label='Proof',command=proof_graph)

window.mainloop()