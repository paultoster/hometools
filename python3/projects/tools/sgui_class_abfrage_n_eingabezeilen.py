import os
import sys
import tkinter as Tk
from tkinter import ttk

from xlwt.ExcelFormulaLexer import false_pattern

# -------------------------------------------------------------------------------
t_path, _ = os.path.split(__file__)
if (t_path == os.getcwd()):
    
    import hfkt_def as hdef
    import sgui_def as sdef
else:
    p_list = os.path.normpath(t_path).split(os.sep)
    if (len(p_list) > 1): p_list = p_list[: -1]
    t_path = ""
    for i, item in enumerate(p_list): t_path += item + os.sep
    if (os.path.normpath(t_path) not in sys.path): sys.path.append(t_path)
    
    from tools import hfkt_def as hdef
    from tools import sgui_def as sdef


# endif--------------------------------------------------------------------------


class abfrage_n_eingabezeilen_class:
    """
      Gui Abfrage verschiedener Eingaben
      z.B.
      liste = ["Materialname","Materialmesseinheit","Materialabrechnungseinheit"]
      obj   = sgui.abfrage_n_eingabezeilen_class(liste)

      R�ckgabe:
      obj.eingabeListe Liste mit Eingabe
    """
    GUI_ICON_FILE = sdef.GUI_ICON_FILE_BASE
    GUI_TITLE = "Eingabe"
    
    GUI_LISTE_ID = 0
    
    status = hdef.OKAY
    str_liste = []
    combo_input_llist = []
    combo_tk_list = []
    eingabeListe = []
    act_frame_id = 0
    StringVarListe = []
    Gui_rahmen = [None]
    
    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    def __init__(self, liste, vorgabe_liste=None, title=None,liste_immutable=None,geometry_list=None):
        """
        """
        self.status = hdef.OKAY
        self.str_liste = []
        self.combo_input_llist = []
        self.combo_tk_list = []
        self.eingabeListe = []
        self.immutable_liste = []
        self.act_frame_id = 0
        self.StringVarListe = []
        self.title = u"Eingabe"
        self.GUI_GEOMETRY_WIDTH = sdef.GUI_GEOMETRY_WIDTH_BASE
        self.GUI_GEOMETRY_HEIGHT = sdef.GUI_GEOMETRY_HEIGHT_BASE
        self.GUI_GEOMETRY_POSX = 0
        self.GUI_GEOMETRY_POSY = 0
        
        # liste in string-liste wandeln
        for item in liste:
            
            if isinstance(item, list):
                if len(item) > 1:
                    if isinstance(item[0], str):
                        self.str_liste.append(item[0])
                    else:
                        raise Exception(
                            f"abfrage_n_eingabezeilen_class: item[0] = {item[0]} of input liste is not a string")
                    # end if
                    if isinstance(item[1], list):
                        self.combo_input_llist.append(item[1])
                    else:
                        raise Exception(
                            f"abfrage_n_eingabezeilen_class: item[0] = {item[1]} of input liste is not a list")
                    # end if
                # end if
            elif isinstance(item, str):
                self.str_liste.append(item)
                self.combo_input_llist.append(None)
            elif (isinstance(item, float)):
                self.str_liste.append("%f" % item)
                self.combo_input_llist.append(None)
            elif (isinstance(item, int)):
                self.str_liste.append("%i" % item)
                self.combo_input_llist.append(None)
            # endif
            self.eingabeListe.append("")
        # endfor
        
        if (vorgabe_liste):
            n = min(len(self.eingabeListe), len(vorgabe_liste))
            for i in range(n):
                item = vorgabe_liste[i]
                if (isinstance(item, str)):
                    self.eingabeListe[i] = item
                elif (isinstance(item, float)):
                    self.eingabeListe[i] = "%f" % item
                elif (isinstance(item, int)):
                    self.eingabeListe[i] = "%i" % item
                # endif
            # endfor
        # endif
        
        if liste_immutable:
            for i in range(min(len(liste_immutable),len(self.eingabeListe))):
                if liste_immutable[i]:
                    self.immutable_liste.append(True)
                else:
                    self.immutable_liste.append(False)
                # end if
            # end for
            
            if len(self.immutable_liste) < len(self.eingabeListe):
                for i in range(len(self.immutable_liste),len(self.eingabeListe)):
                    self.immutable_liste.append(False)
                # end for
            # end if
        else:
            for i in range(len(self.eingabeListe)):
                self.immutable_liste.append(False)
            # end for
        # end if
        
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
        self.createEingabeGui()
        
        # Menue anlegen
        # --------------
        # self.createMenu()
        self.makeEingabeGui()
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
    
    def cancelMenu(self):
        ''' Cancel der Gui
        '''
        self.eingabeListe = []
        self.exitMenu()
    
    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    def createEingabeGui(self):
        ''' Gui f�r Eingabe
        '''
        self.Gui_rahmen[self.GUI_LISTE_ID] = Tk.LabelFrame(self.root, bd=2, text=self.title,
                                                           font=('Verdana', 10, 'bold'))
        
        gr_canvas = Tk.Frame(self.Gui_rahmen[self.GUI_LISTE_ID])
        gr_canvas.pack(expand=1, fill=Tk.BOTH)
        
        # Listbox
        self.listGui_Canvas = Tk.Canvas(gr_canvas)
        # Scrollbar
        scroll_canvas = Tk.Scrollbar(gr_canvas, orient="vertical", command=self.listGui_Canvas.yview)
        self.listGui_Canvas.configure(yscrollcommand=scroll_canvas.set)
        
        scroll_canvas.pack(side=Tk.RIGHT, fill=Tk.Y)
        self.listGui_Canvas.pack(fill=Tk.BOTH, expand=1)
        
        frame = Tk.Frame(self.listGui_Canvas)
        self.listGui_Canvas.create_window((0, 0), window=frame, anchor='nw')
        frame.bind("<Configure>", self.myfunction)
        
        for i in range(len(self.str_liste)):
            item = self.str_liste[i]
            combo_input_liste = self.combo_input_llist[i]
            vorg = self.eingabeListe[i]
            immut = self.immutable_liste[i]
            
            gr_entry = Tk.Frame(frame, relief=Tk.GROOVE, bd=2)
            gr_entry.pack(pady=5, fill=Tk.X)
            
            # label links oben mit text Filte
            label_a = Tk.Label(gr_entry, text=item + ":", font=('Verdana', 11, 'bold'))
            label_a.pack(side=Tk.LEFT, pady=1, padx=1)
            
            # entry StringVar f�r die Eingabe
            stringVarFiltText = Tk.StringVar()
            stringVarFiltText.set(vorg)
            self.StringVarListe.append(stringVarFiltText)
            
            if immut:
                label_b = Tk.Label(gr_entry, text=vorg, font=('Verdana', 11, 'bold'))
                label_b.pack(side=Tk.RIGHT, pady=1, padx=1)
                self.combo_tk_list.append(None)
            elif not combo_input_liste:
                # entry Aufruf
                entry_a = Tk.Entry(gr_entry, width=(80), textvariable=stringVarFiltText)
                entry_a.pack(side=Tk.RIGHT, pady=1, padx=1)
                self.combo_tk_list.append(None)
            else:
                combo_a = ttk.Combobox(gr_entry, state="readonly")
                combo_a['values'] = combo_input_liste
                if vorg in combo_input_liste:
                    index = combo_input_liste.index(vorg)
                else:
                    index = 0
                # end if
                combo_a.current(index)
                combo_a.pack(side=Tk.RIGHT, pady=1, padx=1)
                self.combo_tk_list.append(combo_a)
            # end if
        # endfor
        
        gr_buts = Tk.Frame(gr_canvas, relief=Tk.GROOVE, bd=2)
        gr_buts.pack(fill=Tk.X, pady=5)
        
        b_back = Tk.Button(gr_buts, text='Okay', command=self.getEntry)
        b_back.pack(side=Tk.LEFT, pady=4, padx=2)
        
        b_edit = Tk.Button(gr_buts, text='Cancel', command=self.cancelMenu)
        b_edit.pack(side=Tk.LEFT, pady=4, padx=2)
    
    def myfunction(self, event):
        self.listGui_Canvas.configure(scrollregion=self.listGui_Canvas.bbox("all"))
    
    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    def makeEingabeGui(self):
        ''' Eingabe-Gui f�llen
        '''
        
        self.setActFrameID(self.GUI_LISTE_ID)
    
    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    def getEntry(self):
        ''' eine Gruppe ausw�hlen �ber selection, wenn nicht dann weiter
            aktuellen Namen verwenden
            Ergebnis wird in self.actual_group_name gespeichert
            R�ckgabewert:
            Wenn self.actual_group_name belegt ist, dann True
            ansonasten False
        '''
        # Nimmt den aktuellen Cursorstellung
        self.eingabeListe = []
        
        for index, item in enumerate(self.StringVarListe):
            if not self.combo_tk_list[index]:
                tt = item.get()
            else:
                tt = self.combo_tk_list[index].get()
            # endif
            self.eingabeListe.append(tt)
        # endfor
        
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
