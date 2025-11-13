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
    import hfkt_list as hlist
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
    from tools import hfkt_list as hlist
    # from tools import hfkt_tvar as htvar
    # from tools import sgui_class_abfrage_n_eingabezeilen as sclass_ane
    from tools import sgui_def as sdef

# endif--------------------------------------------------------------------------

# =============================================================================
# =============================================================================
# =============================================================================
class anzeige_text_class:
    """
      Gui Anzeige eines Textes mit einem Button für okay
      z.B.
      obj   = sgui.anzeige_text(text_liste,title)

      Rückgabe: keine

    """
    GUI_ICON_FILE = sdef.GUI_ICON_FILE_BASE
    GUI_TITLE = "Anzeige"
    
    GUI_LISTE_ID = 0
    
    status = hdef.OKAY
    str_liste = []
    index_liste = []
    str_auswahl_liste = []
    index_auswahl_liste = []
    indexListe = []
    index = -1
    indexAbfrage = -1
    act_frame_id = 0
    Gui_rahmen = [None]
    
    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    def __init__(self, text_liste, title=None, textcolor='black',use_cancel_button=False,geometry_list=None):
        """
        """
        self.status = hdef.OKAY
        self.str_liste = []
        self.str_liste_out = []
        self.index_liste = []
        self.str_auswahl_liste = []
        self.index_auswahl_liste = []
        self.indexListe = []
        self.index = -1
        self.act_frame_id = 0
        self.title = u"Anzeigee"
        self.textcolor = textcolor
        if use_cancel_button:
            self.abfrage_liste = [u'okay',u'cancel']
        else:
            self.abfrage_liste = [u'okay']
        
        self.GUI_GEOMETRY_WIDTH = sdef.GUI_GEOMETRY_WIDTH_BASE
        self.GUI_GEOMETRY_HEIGHT = sdef.GUI_GEOMETRY_HEIGHT_BASE
        self.GUI_GEOMETRY_POSX = 0
        self.GUI_GEOMETRY_POSY = 0
        
        # liste in string-liste wandeln
        index = 0
        for item in text_liste:
            if (isinstance(item, str)):
                self.str_liste.append(item)
            elif (isinstance(item, float)):
                self.str_liste.append("%f" % item)
            elif (isinstance(item, int)):
                self.str_liste.append("%i" % item)
            # endif
            self.index_liste.append(index)
            index += 1
        # endfor
        
        # Titel:
        if (title and isinstance(title, str)):
            self.title = title
        # endif
        
        if isinstance(geometry_list,list):
            if len(geometry_list):
                self.GUI_GEOMETRY_WIDTH = geometry_list[0]
            if len(geometry_list) > 1:
                self.GUI_GEOMETRY_HEIGHT = geometry_list[1]
            if len(geometry_list) > 2:
                self.GUI_GEOMETRY_POSX = geometry_list[2]
            if len(geometry_list) > 3:
                self.GUI_GEOMETRY_POSY = geometry_list[3]

        # TK-Grafik anlegen
        # ------------------
        self.root = Tk.Tk()
        self.root.protocol("WM_DELETE_WINDOW", self.exitMenu)
        # geo = str(self.GUI_GEOMETRY_WIDTH)+"x"+str(self.GUI_GEOMETRY_HEIGHT)
        # self.root.geometry(geo)
        self.root.wm_geometry("%dx%d+%d+%d" % (
            self.GUI_GEOMETRY_WIDTH, self.GUI_GEOMETRY_HEIGHT, self.GUI_GEOMETRY_POSX, self.GUI_GEOMETRY_POSY))
        
        if (os.path.isfile(self.GUI_ICON_FILE)):
            self.root.wm_iconbitmap(self.GUI_ICON_FILE)
        self.root.title(self.GUI_TITLE)
        
        # Gui anlegen
        # --------------
        self.createAnzeigeGui()
        
        # Menue anlegen
        # --------------
        # self.createMenu()
        self.makeAnzeigeGui()
        self.flag_mainloop = True
        
        self.root.mainloop()
    
    def __del__(self):
        if (self.flag_mainloop):
            self.GUI_GEOMETRY_HEIGHT = self.root.winfo_height()
            self.GUI_GEOMETRY_WIDTH = self.root.winfo_width()
            self.GUI_GEOMETRY_POSX  = self.root.winfo_x()
            self.GUI_GEOMETRY_POSY  = self.root.winfo_y()
            self.root.destroy()
            self.flag_mainloop = False
    
    def exitMenu(self,button_name):
        ''' Beenden der Gui
        '''
        # Vor Beenden Speichern abfragen
        # ans = tkinter.messagebox.askyesno(parent=self.root,title='Sichern', message='Soll Datenbasis gesichert werden')
        # if( ans ): self.base.save_db_file()
        
        if button_name == u'okay':
        
            tstr = self.listGui_Anzeige.get('1.0',Tk.END)
            self.str_liste_out = hlist.split_str_into_list(tstr,'\n',True)
        else:
            self.str_liste_out = []
        
        if (self.flag_mainloop):
            self.GUI_GEOMETRY_HEIGHT = self.root.winfo_height()
            self.GUI_GEOMETRY_WIDTH = self.root.winfo_width()
            self.GUI_GEOMETRY_POSX  = self.root.winfo_x()
            self.GUI_GEOMETRY_POSY  = self.root.winfo_y()
            self.root.destroy()
            self.flag_mainloop = False
    
    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    def createAnzeigeGui(self):
        ''' Gui für Anzeige
        '''
        # äusserer Rahmen
        self.Gui_rahmen[self.GUI_LISTE_ID] = Tk.LabelFrame(self.root, bd=2, text=self.title,
                                                           font=('Verdana', 10, 'bold'))
        self.Gui_rahmen[self.GUI_LISTE_ID].pack(expand=1, fill=Tk.BOTH)
        
        # Rahmen Textanzeige
        gr_anzeige = Tk.Frame(self.Gui_rahmen[self.GUI_LISTE_ID])
        gr_anzeige.pack(expand=1, fill=Tk.BOTH)
        
        # Scrollbar
        scroll_text = Tk.Scrollbar(gr_anzeige)
        scroll_text.pack(side=Tk.RIGHT, fill=Tk.Y)
        
        # Textfeld
        self.listGui_Anzeige = Tk.Text(gr_anzeige, padx=4, pady=4, font=('Verdana', 12, 'bold'),
                                       yscrollcommand=scroll_text.set, fg=self.textcolor)
        self.listGui_Anzeige.pack(side=Tk.TOP, expand=1, fill=Tk.BOTH)
        
        scroll_text.config(command=self.listGui_Anzeige.yview)
        
        # ! scroll_box.config(command=self.listGui_AnzeigeBox.yview)
        gr_buts = Tk.Frame(self.Gui_rahmen[self.GUI_LISTE_ID], relief=Tk.GROOVE, bd=2)
        gr_buts.pack(fill=Tk.X, pady=5)
        
        self.Button = []
        for name in self.abfrage_liste:
            b_back = Tk.Button(gr_buts, text=name, command=lambda m=name: self.exitMenu(m))  # lambda m=method: self.populateMethod(m))
            b_back.pack(side=Tk.LEFT, pady=4, padx=2)  # side=Tk.LEFT,pady=4,padx=2
            self.Button.append(b_back)
    
    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    def makeAnzeigeGui(self):
        ''' Anzeige-Gui füllen
        '''
        
        # delete listbox
        (n, m) = self.listGui_Anzeige.size()
        if (n > 0 and m > 0): self.listGui_Anzeige.delete(n, m)
        
        if (len(self.str_liste) > 0):
            for item in self.str_liste:
                self.listGui_Anzeige.insert(Tk.END, item)
                self.listGui_Anzeige.insert(Tk.END, "\n")
        else:
            text = 'keine Ausgabe vorhanden'
            self.listGui_Anzeige.insert(Tk.END, text)
        
        self.setActFrameID(self.GUI_LISTE_ID)
    
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
        # endif
    # enddef

# endclass
