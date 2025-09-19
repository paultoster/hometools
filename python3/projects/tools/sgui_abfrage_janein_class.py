import tkinter as Tk
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
    from tools import hfkt_def as hdef
    # from tools import hfkt_type as htype
    # from tools import hfkt_list as hlist
    # from tools import hfkt_tvar as htvar
    # from tools import sgui_class_abfrage_n_eingabezeilen as sclass_ane
    from tools import sgui_def as sdef

# endif--------------------------------------------------------------------------

class abfrage_janein_class:
    """
      Gui Abfrage Ja-Nein Frage
      z.B.

    """
    GUI_GEOMETRY_WIDTH = sdef.GUI_GEOMETRY_WIDTH_BASE
    GUI_GEOMETRY_HEIGHT = sdef.GUI_GEOMETRY_HEIGHT_BASE
    GUI_GEOMETRY_POSX = 0
    GUI_GEOMETRY_POSY = 0
    GUI_ICON_FILE = sdef.GUI_ICON_FILE_BASE
    GUI_TITLE = "J/N"
    
    GUI_LISTE_ID = 0
    
    status = hdef.OKAY
    act_frame_id = 0
    Gui_rahmen = [None]
    flagJa = False
    
    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    def __init__(self, text=None, title=None):
        """
        """
        self.status = hdef.OKAY
        self.act_frame_id = 0
        self.title = u"Eingabe"
        self.text = u"Ist das Okay?"
        
        # Text:
        if (text and isinstance(text, str)):
            self.text = text
        # endif
        
        # Titel:
        if (title and isinstance(title, str)):
            self.title = title
        # endif
        
        # TK-Grafik anlegen
        # ------------------
        self.root = Tk.Tk()
        self.root.protocol("WM_DELETE_WINDOW", self.exitMenu)
        geo = str(self.GUI_GEOMETRY_WIDTH) + "x" + str(self.GUI_GEOMETRY_HEIGHT)
        self.root.geometry(geo)
        if (os.path.isfile(self.GUI_ICON_FILE)):
            self.root.wm_iconbitmap(self.GUI_ICON_FILE)
        self.root.title(self.GUI_TITLE)
        
        # Gui anlegen
        # --------------
        self.createJaNeinGui()
        
        # Menue anlegen
        # --------------
        # self.createMenu()
        self.makeJaNeinGui()
        self.flag_mainloop = True
        
        self.root.mainloop()
    
    def __del__(self):
        if (self.flag_mainloop):
            self.root.destroy()
            self.flag_mainloop = False
    
    def exitMenu(self):
        ''' Beenden der Gui
        '''
        # Vor Beenden Speichern abfragen
        # ans = tkinter.messagebox.askyesno(parent=self.root,title='Sichern', message='Soll Datenbasis gesichert werden')
        # if( ans ): self.base.save_db_file()
        
        if (self.flag_mainloop):
            self.root.destroy()
            self.flag_mainloop = False
    
    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    def createJaNeinGui(self):
        ''' Gui f�r Eingabe
        '''
        self.Gui_rahmen[self.GUI_LISTE_ID] = Tk.LabelFrame(self.root, bd=2, text=self.title,
                                                           font=('Verdana', 10, 'bold'))
        
        gr_entry = Tk.Frame(self.Gui_rahmen[self.GUI_LISTE_ID], relief=Tk.GROOVE, bd=2)
        gr_entry.pack(pady=5)
        
        self.gr_text_a = Tk.Text(gr_entry, width=120, height=16, font=('Verdana', 15, 'bold'))
        self.gr_text_a.pack(side=Tk.LEFT, pady=1, padx=1)
        
        gr_buts = Tk.Frame(self.Gui_rahmen[self.GUI_LISTE_ID], relief=Tk.GROOVE, bd=2)
        gr_buts.pack(fill=Tk.X, pady=5)
        
        b_back = Tk.Button(gr_buts, text='Ja(Yes)', command=self.getEntry)
        b_back.pack(side=Tk.LEFT, pady=4, padx=2)
        
        b_edit = Tk.Button(gr_buts, text='Nein(No)', command=self.exitMenu)
        b_edit.pack(side=Tk.LEFT, pady=4, padx=2)
    
    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    def makeJaNeinGui(self):
        ''' Eingabe-Gui f�llen
        '''
        
        self.gr_text_a.insert(Tk.END, self.text)
        self.setActFrameID(self.GUI_LISTE_ID)
    
    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    def getEntry(self):
        '''
        '''
        # Ist Ja
        self.flagJa = True
        
        self.exitMenu()
    
    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    def setActFrameID(self, id):
        ''' Setzt Gui mit ID
        '''
        if (self.act_frame_id == self.GUI_LISTE_ID):
            self.Gui_rahmen[self.GUI_LISTE_ID].pack_forget()
        
        self.act_frame_id = id
        if (self.act_frame_id == self.GUI_LISTE_ID):
            self.Gui_rahmen[self.GUI_LISTE_ID].pack(expand=1, fill=Tk.BOTH)

