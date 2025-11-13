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

class abfrage_liste_class:
    """
      Gui Abfrgae einer Liste, es können Buttons erstellt werden
      der Abfrage von listeAbfrage (default ['okay','cancel'])
      z.B.
      liste = ["abc","def","ghi",jkl"]
      listeAbfrage = ["cancel","gut"]
      obj   = sgui.abfrage_liste(liste,listeAbfrage)

      Rückgabe:
      obj.index        erster Index
      obj.indexListe   Liste mit index zu vorgegebenen Liste
      obj.indexAbfrage index der Abfrage Liste

    """
    GUI_ICON_FILE = sdef.GUI_ICON_FILE_BASE
    GUI_TITLE = "Liste"
    
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
    def __init__(self, liste, listeAbfrage=None, title=None,geometry_list=None):
        """
        """
        self.status = hdef.OKAY
        self.str_liste = []
        self.index_liste = []
        self.str_auswahl_liste = []
        self.index_auswahl_liste = []
        self.indexListe = []
        self.abfrage_liste = [u'okay', u'cancel']
        self.index = -1
        self.act_frame_id = 0
        self.title = u"Liste"
        self.GUI_GEOMETRY_WIDTH = sdef.GUI_GEOMETRY_WIDTH_BASE
        self.GUI_GEOMETRY_HEIGHT = sdef.GUI_GEOMETRY_HEIGHT_BASE
        self.GUI_GEOMETRY_POSX = 0
        self.GUI_GEOMETRY_POSY = 0
        
        # liste in string-liste wandeln
        index = 0
        for item in liste:
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
        
        # Liste der Abfrage buttons
        if (listeAbfrage):
            self.abfrage_liste = []
            for item in listeAbfrage:
                if (isinstance(item, str)):
                    self.abfrage_liste.append(item)
                elif (isinstance(item, float)):
                    self.abfrage_liste.append("%f" % item)
                elif (isinstance(item, int)):
                    self.abfrage_liste.append("%i" % item)
                # endif
        # endif
        
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

        # Auswahlliste wird auf gesamte Liste gesetzt
        self.str_auswahl_liste = self.str_liste
        self.index_auswahl_liste = self.index_liste
        
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
        self.createListGui()
        
        # Menue anlegen
        # --------------
        # self.createMenu()
        self.makeListGui()
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
    
    def exitMenu(self):
        ''' Beenden der Gui
        '''
        # Vor Beenden Speichern abfragen
        # ans = tkinter.messagebox.askyesno(parent=self.root,title='Sichern', message='Soll Datenbasis gesichert werden')
        # if( ans ): self.base.save_db_file()
        
        if (self.flag_mainloop):
            self.GUI_GEOMETRY_HEIGHT = self.root.winfo_height()
            self.GUI_GEOMETRY_WIDTH = self.root.winfo_width()
            self.GUI_GEOMETRY_POSX  = self.root.winfo_x()
            self.GUI_GEOMETRY_POSY  = self.root.winfo_y()
            self.root.destroy()
            self.flag_mainloop = False
    
    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    def createListGui(self):
        ''' Gui für Liste
        '''
        self.Gui_rahmen[self.GUI_LISTE_ID] = Tk.LabelFrame(self.root, bd=2, text=self.title,
                                                           font=('Verdana', 10, 'bold'))
        
        gr_entry = Tk.Frame(self.Gui_rahmen[self.GUI_LISTE_ID], relief=Tk.GROOVE, bd=2)
        gr_entry.pack(pady=5)
        
        # label links oben mit text Filte
        label_a = Tk.Label(gr_entry, text='Filter:', font=('Verdana', 10, 'bold'))
        label_a.pack(side=Tk.LEFT, pady=1, padx=1)
        
        # entry StringVar fuer die Eingabe
        self.StringVarFiltText = Tk.StringVar()
        self.StringVarFiltText.set("")
        self.StringVarFiltText.trace("w", self.runDoFilter)
        
        # entry Aufruf
        entry_a = Tk.Entry(gr_entry, width=(100), textvariable=self.StringVarFiltText)
        entry_a.pack(side=Tk.LEFT, pady=1, padx=1)
        
        ##    button_a = Tk.Button(gr_entry,text='do', command=self.runDoFilter)
        ##    button_a.pack(side=Tk.RIGHT,pady=1,padx=1)
        
        gr_listbox = Tk.Frame(self.Gui_rahmen[self.GUI_LISTE_ID])
        gr_listbox.pack(expand=1, fill=Tk.BOTH)
        
        # Scrollbar
        scroll_listbox = Tk.Scrollbar(gr_listbox)
        scroll_listbox.pack(side=Tk.RIGHT, fill=Tk.Y)
        
        # Listbox
        self.listGui_ListBox = Tk.Listbox(gr_listbox, selectmode=Tk.EXTENDED, yscrollcommand=scroll_listbox.set,
                                          font=('Verdana', 15, 'bold'))
        self.listGui_ListBox.bind("<Double-1>", self.SelectOnDoubleClick)
        self.listGui_ListBox.pack(fill=Tk.BOTH, expand=1)
        
        scroll_listbox.config(command=self.listGui_ListBox.yview)
        
        gr_buts = Tk.Frame(self.Gui_rahmen[self.GUI_LISTE_ID], relief=Tk.GROOVE, bd=2)
        gr_buts.pack(fill=Tk.X, pady=5)
        
        self.Button = []
        for name in self.abfrage_liste:
            b_back = Tk.Button(gr_buts, text=name,
                               command=lambda m=name: self.selectListGui(m))  # lambda m=method: self.populateMethod(m))
            b_back.pack(side=Tk.LEFT, pady=4, padx=2)
            self.Button.append(b_back)
    
    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    def runDoFilter(self, *dummy):
        
        tt = self.StringVarFiltText.get()
        
        self.str_auswahl_liste = []
        self.index_auswahl_liste = []
        
        for i in range(0, len(self.str_liste), 1):
            
            ii = self.str_liste[i].find(tt)
            if (ii > -1):
                self.str_auswahl_liste.append(self.str_liste[i])
                self.index_auswahl_liste.append(self.index_liste[i])
            # endif
        # endfor
        
        self.makeListGui()
    
    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    def makeListGui(self):
        ''' list-Gui f�llen
        '''
        
        # delete listbox
        n = self.listGui_ListBox.size()
        if (n > 0): self.listGui_ListBox.delete(0, n)
        
        self.listGui_ListBox.pack(expand=1, fill=Tk.BOTH)
        
        # Gruppenname aktualisieren
        # self.selectListGui()
        # fill listbox
        
        if (len(self.str_auswahl_liste) > 0):
            for item in self.str_auswahl_liste:
                self.listGui_ListBox.insert(Tk.END, item)
        else:
            text = 'keine Liste vorhanden'
            self.listGui_ListBox.insert(Tk.END, text)
        
        self.setActFrameID(self.GUI_LISTE_ID)
    
    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    def selectListGui(self, button_name):
        ''' eine Gruppe ausw�hlen �ber selection, wenn nicht dann weiter
            aktuellen Namen verwenden
            Ergebnis wird in self.actual_group_name gespeichert
            R�ckgabewert:
            Wenn self.actual_group_name belegt ist, dann True
            ansonasten False
        '''
        # Nimmt den aktuellen Cursorstellung
        self.indexListe = []
        
        select = self.listGui_ListBox.curselection()
        
        if (len(select) > 0):
            for i in range(0, len(select), 1):
                ii = select[i]
                if (ii < len(self.index_auswahl_liste)):
                    self.indexListe.append(self.index_auswahl_liste[ii])
                # endif
            # endfor
            if (len(self.indexListe) > 0):
                self.index = self.indexListe[0]
        # endif
        flag = False
        icount = 0
        for name in self.abfrage_liste:
            if (name == button_name):
                flag = True
                self.indexAbfrage = icount
                break
            icount += 1
            # endif
        # endfor
        
        self.exitMenu()
    
    def SelectOnDoubleClick(self, event):
        ''' eine Gruppe ausw�hlen �ber selection, wenn nicht dann weiter
            aktuellen Namen verwenden
            Ergebnis wird in self.actual_group_name gespeichert
            R�ckgabewert:
            Wenn self.actual_group_name belegt ist, dann True
            ansonasten False
        '''
        # Nimmt den aktuellen Cursorstellung
        self.indexListe = []
        
        select = self.listGui_ListBox.curselection()
        
        if (len(select) > 0):
            flag_select = True
            for i in range(0, len(select), 1):
                ii = select[i]
                if (ii < len(self.index_auswahl_liste)):
                    self.indexListe.append(self.index_auswahl_liste[ii])
                # endif
            # endfor
            if (len(self.indexListe) > 0):
                self.index = self.indexListe[0]
        else:
            flag_select = False
        # endif
        
        # default setzen erster
        self.indexAbfrage = 0
        
        if (flag_select): self.exitMenu()
    
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

# ========================== abfrage_liste ======================================
# ===============================================================================

