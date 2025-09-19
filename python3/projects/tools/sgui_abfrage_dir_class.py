# import tkinter as Tk
# from tkinter.filedialog import askopenfilename
from tkinter import ttk
import tkinter.messagebox
import os
import sys

# -------------------------------------------------------------------------------
t_path, _ = os.path.split(__file__)
if (t_path == os.getcwd()):
    
    # import sstr
    # import hfkt as h
    import hfkt_def as hdef
    # import hfkt_type as htype
    # import hfkt_list as hlist
    # import hfkt_tvar as htvar
    import sgui_def as sdef
    # import sgui_class_abfrage_n_eingabezeilen as sclass_ane
else:
    p_list = os.path.normpath(t_path).split(os.sep)
    if (len(p_list) > 1): p_list = p_list[: -1]
    t_path = ""
    for i, item in enumerate(p_list): t_path += item + os.sep
    if (os.path.normpath(t_path) not in sys.path): sys.path.append(t_path)
    
    # from tools import sstr
    # from tools import hfkt as h
    # from tools import hfkt_def as hdef
    # from tools import hfkt_type as htype
    # from tools import hfkt_list as hlist
    # from tools import hfkt_tvar as htvar
    # from tools import sgui_class_abfrage_n_eingabezeilen as sclass_ane
    from tools import sgui_def as sdef

# endif--------------------------------------------------------------------------

class DirList:
    def __init__(self, w, master_dir=None, comment=None, no_new_dir_flag=False):
        self.root = w
        self.exit = -1
        self.quit_flag = False
        if master_dir:
            dir_start = master_dir
        else:
            dir_start = "C:\\"
        
        ## print dir_start
        if not os.path.exists(dir_start):
            dir_start = "C:\\"
        
        z = w.winfo_toplevel()
        if (comment):
            z.wm_title(comment)
        else:
            z.wm_title("choose dir")
        
        # Create the tixDirList and the tixLabelEntry widgets on the on the top
        # of the dialog box
        
        # bg = root.tk.eval('tix option get bg')
        # adding bg=bg crashes Windows pythonw tk8.3.3 Python 2.1.0
        
        top = tkinter.ttk.Frame(w, relief=RAISED, bd=1)
        
        # Create the DirList widget. By default it will show the current
        # directory
        #
        #
        top.dir = tkinter.ttk.DirList(top)
        top.dir.chdir(dir_start)
        top.dir.hlist['width'] = 40
        
        # When the user presses the ".." button, the selected directory
        # is "transferred" into the entry widget
        #
        top.btn = tkinter.ttk.Button(top, text="  >>  ", pady=0)
        
        # We use a LabelEntry to hold the installation directory. The user
        # can choose from the DirList widget, or he can type in the directory
        # manually
        #
        if (not no_new_dir_flag):
            label_text = "chosen Directory (and add name for new dir):"
        else:
            label_text = "chosen Directory:"
        top.ent = tkinter.ttk.LabelEntry(top, label=label_text,
                                         labelside='top',
                                         options='''
                                  entry.width 50
                                  label.anchor w
                                  ''')
        self.entry = top.ent.subwidget_list["entry"]
        
        font = self.root.tk.eval('tix option get fixed_font')
        # font = self.root.master.tix_option_get('fixed_font')
        top.ent.entry['font'] = font
        
        self.dlist_dir = copy.copy("")
        
        # This should work setting the entry's textvariable
        top.ent.entry['textvariable'] = self.dlist_dir
        top.btn['command'] = lambda dir=top.dir, ent=top.ent, self=self: \
            self.copy_name(dir, ent)
        
        # top.ent.entry.insert(0,'tix'+`self`)
        top.ent.entry.bind('<Return>', lambda dir=top.dir, ent=top.ent, self=self: self.okcmd(dir, ent))
        
        top.pack(expand='yes', fill='both', side=TOP)
        top.dir.pack(expand=1, fill=BOTH, padx=4, pady=4, side=LEFT)
        top.btn.pack(anchor='s', padx=4, pady=4, side=LEFT)
        top.ent.pack(expand=1, fill=X, anchor='s', padx=4, pady=4, side=LEFT)
        
        # Use a ButtonBox to hold the buttons.
        #
        box = tkinter.ttk.ButtonBox(w, orientation='horizontal')
        ##        box.add ('ok', text='Ok', underline=0, width=6,
        ##                     command = lambda self=self: self.okcmd () )
        box.add('ok', text='Ok', underline=0, width=6,
                command=lambda dir=top.dir, ent=top.ent, self=self: self.okcmd(dir, ent))
        box.add('cancel', text='Cancel', underline=0, width=6,
                command=lambda self=self: self.quitcmd())
        
        box.pack(anchor='s', fill='x', side=BOTTOM)
        z.wm_protocol("WM_DELETE_WINDOW", lambda self=self: self.quitcmd())
    
    def copy_name(self, dir, ent):
        # This should work as it is the entry's textvariable
        self.dlist_dir = dir.cget('value')
        # but it isn't so I'll do it manually
        ent.entry.delete(0, 'end')
        ent.entry.insert(0, self.dlist_dir)
    
    ##    def okcmd (self):
    ##        # tixDemo:Status "You have selected the directory" + $self.dlist_dir
    ##
    ##        self.quitcmd()
    def okcmd(self, dir, ent):
        # tixDemo:Status "You have selected the directory" + $self.dlist_dir
        
        value = self.entry.get()
        if len(value) > 0:
            self.dlist_dir = value
        else:
            self.dlist_dir = dir.cget('value')
        
        # but it isn't so I'll do it manually
        ent.entry.delete(0, 'end')
        ent.entry.insert(0, self.dlist_dir)
        
        self.exit = 0
    
    def quitcmd(self):
        # self.root.destroy()
        #        print "quit"
        self.exit = 0
        self.quit_flag = True
    
    def mainloop(self):
        while self.exit < 0:
            self.root.tk.dooneevent(sdef.TCL_ALL_EVENTS)
        # self.root.tk.dooneevent(TCL_DONT_WAIT)
    
    def destroy(self):
        self.root.destroy()


