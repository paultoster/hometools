import tkinter as tk
from tkinter.filedialog import askopenfilename, asksaveasfilename

from dataclasses import dataclass, field
from typing import List
import os, sys

tools_path = os.getcwd() + "\\.."
if( tools_path not in sys.path ):
    sys.path.append(tools_path)

from hfkt import hfkt_file_path as hf

import small_vector_graphic as s
import small_vector_graphic_defines as d



@dataclass
class CBaseData:
    '''Store all base datas'''
    filepathname: str = ''
    command_liste: List[s.c.CBasic] = field(default_factory=list)
    # line_text_liste: List[str] = field(default_factory=list)
    x0: float = 0.0
    y0: float = 0.0


BaseData = CBaseData()



window = tk.Tk()
window.title("Text Editor")

screen_width = int(window.winfo_screenwidth()*d.EDITOR_SCREEN_SIZE_WIDTH_FACTOR)
screen_height = int(window.winfo_screenheight()*d.EDITOR_SCREEN_SIZE_HEIGHT_FACTOR)

geometry = f"{screen_width}x{screen_height}"

window.geometry(geometry)

txt = tk.Text(window, fg='purple', bg='light yellow', font='Calibri 14',width=screen_width,height=screen_height)
txt.pack(padx=5, pady=5)
#txt.place(x=0, y=0)

def open_file(filename=None):

    if( not filename ):
      filepath = askopenfilename(filetypes=[("Text file", "*.txt"),("All Files","*.*")])
      if not filepath:
        return
      #endif
    else:
      filepath = hf.set_pfe(os.getcwd(),filename)
      if( not os.path.isfile(filepath)):
        return
      #endif
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

    if(len(BaseData.filepathname)):
      filepath = BaseData.filepathname

      with open(filepath, mode='w', encoding='utf-8') as output_file:
          text = txt.get('1.0', tk.END)
          output_file.write(text)
          window.title(f'Simple Text Editor - {filepath}')
    else:
      save_as_file()
    #endif
def make_exit():

    result = tk.messagebox.askquestion(title="Save File?", message="Save File")
    if( result == 'yes'):
      if(len(BaseData.filepathname)):
        save_file()
      else:
        save_as_file()
    #endif
    window.destroy()


def proof_graph():

    text = txt.get('1.0', tk.END)

    input_liste = text.split("\n")

    (okay,errtext,BaseData.command_liste) = s.build_and_proof_input(input_liste)


    if( okay ):
      tk.messagebox.showinfo(title="InfoProofCommand",message="Commands are okay")
    else:
      tk.messagebox.showerror(title="ErrorWhileBuildAndProofCommand",message=errtext)
    #endif

    # print(f"{BaseData.command_liste}")
#enddef
def paint_graph():

    text = txt.get('1.0', tk.END)

    input_liste = text.split("\n")

    (okay,errtext,BaseData.command_liste) = s.build_and_proof_input(input_liste)

    if( not okay ):
      tk.messagebox.showerror(title="ErrorWhileBuildAndProofCommand",message=errtext)
    else:
      (okay,errtext) = s.paint_command_liste(BaseData.command_liste)
      if( not okay ):
        tk.messagebox.showerror(title="ErrorWhilePaintCommandList",message=errtext)
      #endif
    #endif


    # print(f"{BaseData.command_liste}")
#enddef

menu = tk.Menu(window)
window.config(menu=menu)
filemenu = tk.Menu(menu)
graphmenu = tk.Menu(menu)

menu.add_cascade(label='File', menu=filemenu)
filemenu.add_command(label='Open', command=open_file)
filemenu.add_command(label='Save As...', command=save_as_file)
filemenu.add_command(label='Save', command=save_file)
filemenu.add_command(label='Exit', command=make_exit)

menu.add_cascade(label='Graph', menu=graphmenu)
graphmenu.add_command(label='Proof',command=proof_graph)
graphmenu.add_command(label='Paint',command=paint_graph)

# open File by default
if( len(d.IMPORT_FILE_BY_DEFAULT) ):
  open_file(d.IMPORT_FILE_BY_DEFAULT)
#endif
window.mainloop()



##
##from tkinter import *
##from PIL import Image, ImageTk
##from io import BytesIO
##root = Tk()
##cv = Canvas(root)
##cv.create_rectangle(10,10,50,50, fill='green')
##cv.pack()
##
##cv.update()
### Get the EPS corresponding to the canvas
##eps = cv.postscript(colormode='color')
##
### Save canvas as "in-memory" EPS and pass to PIL without writing to disk
##im = Image.open(BytesIO(bytes(eps,'ascii')))
##im.save('result.png')
##
##root.mainloop()