########file test.py##########################################
# !/usr/bin/env python  obj = abfrage_liste_class(liste,title=title)
#
# ------------------------------------------------------------------------------------------------------
# full_file_name = eingabe_file( file_types="*", comment="Waehle oder benenne neue Datei", start_dir=None)
#
# File auswaehlen
# Um ein neues File zu generieren mit folgenden Parameter
# file_types = "*.c *.h"      Filetypen (auch feste namen möglich "abc.py")
# start_dir  = "d:\\abc"	Anfangspfad
# comment    = "Suche Datei"  Windows Leisten text
#
#
# ------------------------------------------------------------------------------------------------------
# index = sgui.abfrage_liste_index(liste)
# index = sgui.abfrage_liste_index(liste,"Title")
#
# listeAnzeige = ["Materialname","Materialmesseinheit","Materialabrechnungseinheit"]
# index = sgui.abfrage_liste_index(listeAnzeige)
#
#  index = -1       Cancel
#  index = 0 ... 2  Index Liste
#
# ------------------------------------------------------------------------------------------------------
# indexListe = sgui.abfrage_liste_indexListe(liste)
# indexListe = sgui.abfrage_liste_indexListe(liste,"Title")
#
# listeAnzeige = ["Materialname","Materialmesseinheit","Materialabrechnungseinheit"]
# indexListe = sgui.abfrage_liste_indexListe(listeAnzeige)
#
#  indexListe = [-1]       Cancel
#  indexListe = [0,2]      Index Liste zwei Elemente
#
# ------------------------------------------------------------------------------------------------------
# (index,indexAbfrage) = sgui.abfrage_liste_index_abfrage_index(liste,listeAbfrage):
# (indexListe,indexAbfrage) = sgui.abfrage_liste_indexListe_abfrage_index(liste,listeAbfrage):
#
# z.B. liste = ["alpha","beta","gamma"] , listeAbfrage = ["Ok","Cancel","Aendern"]
#
# idex       = -1
# indexListe 0 [-1]  keinen Wert
#
#
# ------------------------------------------------------------------------------------------------------
# list =  abfrage_n_eingabezeilen(liste,vorgabe_liste=None,title=None)
#
#   Gui Abfrage verschiedener Eingaben vorgabe_liste als default-Wert
#   z.B.
#   listeAnzeige = ["Materialname","Materialmesseinheit","Materialabrechnungseinheit"]
#   listeErgebnis = sgui.abfrage_n_eingabezeilen(listeAnzeige)
#
#   oder mit Vorgabewert
#
#   listeAnzeige = ["Materialname","Materialmesseinheit","Materialabrechnungseinheit"]
#   listeWerte   = ["Kaffee","kg","Tassen"]
#   title        = "MAterialauswahl"
#   listeErgebnis = sgui.abfrage_n_eingabezeilen(liste=listeAnzeige, vorgabe_liste=listeWerte,title=title)
# oder
# mit
# Vorgabe
# listeAnzeige = ["Materialname", "Materialmesseinheit", "Materialabrechnungseinheit"]
# listeDefault = ["Kaffee", "kg", "Tassen"]
# listeErgebnis = sgui.abfrage_n_eingabezeilen(liste=listeAnzeige, vorgabe_liste=listeDefault, title="Materialbestimmung")
# oder
# mit
# eintelnen
# Comboboxen
# listeAnzeige = [["Materialname", ["Kaffee", "Tee", "Eis"]], "Materialmesseinheit", "Materialabrechnungseinheit"]
# listeDefault = ["Tee", "kg", "Tassen"]
# listeErgebnis = sgui.abfrage_n_eingabezeilen(liste=listeAnzeige, vorgabe_liste=listeDefault, title="Materialbestimmung")
#
# if listeErgebnis is empty cancel was clicked
#
#   bei cancel Rückgabe leer List
# ------------------------------------------------------------------------------------------------------
# (data_set,indexAbfrage) = sgui.abfrage_tabelle(header_liste,data_set):  default   listeAbfrage = ["okay"]
# (data_set,indexAbfrage) = sgui.abfrage_tabelle(header_liste,data_set,data_index_liste):    listeAbfrage = ["okay"]
# (data_set,indexAbfrage) = sgui.abfrage_tabelle(header_liste,data_set,data_index_liste,listeAbfrage):
#
# (data_set, indexAbfrage, irow,data_changed_pos_list) = sgui.abfrage_tabelle_get_row(header_liste, data_set):    listeAbfrage = ["okay"]
# (data_set, indexAbfrage, irow,data_changed_pos_list) = sgui.abfrage_tabelle_get_row(header_liste, data_set,
#                                                               data_index_liste):    listeAbfrage = ["okay"]
# (data_set, indexAbfrage, irow,data_changed_pos_list) = sgui.abfrage_tabelle_get_row(header_liste, data_set, data_index_liste, listeAbfrage):
#
# z.B. header_liste     = ["alpha","beta","gamma"]                       Die Name der Bestandteile eines dat-items
#      data_set         = [[0.1,0.1,0.2],[0.2,0.5,0.2], .... ]           Date-set liste mit Zeilen-Liste, Zeilenliste entspricht dr Headerliste
#      data_index_liste = [1,2, ... ]                                    (default:None) indiizes zu den jeweiligen Daten packet
#      listeAbfrage     = ["Ok","Cancel","Aendern"]                      (default: None) Abfrage möglichkeiten indexAbfrage zeigt dann den Wert
#
# gibt den geänderten data_set zurück
# data_index_liste
#
#
# ------------------------------------------------------------------------------------------------------
# flag = sgui.abfrage_janein(text="Soll abgebrochen werden")
# flag = sgui.abfrage_janein(text="Soll abgebrochen werden",title="Abbruch j/n")
#
#  flag      True/False
#
# ------------------------------------------------------------------------------------------------------
#  sgui.anzeige_text(texteingabe,title=None,textcolor='black')
#  Zeigt Text an mit Okay Button
#  Farben 'black','red','blue','green'...
#
# ------------------------------------------------------------------------------------------------------
# dir = abfrage_dir(comment=None,start_dir=None)
#
#  gui um Pfad auszuwählen
#
#
#
# ------------------------------------------------------------------------------------------------------
# selected_file = eingabe_file(file_types="*",comment="Waehle oder benenne neue Datei",start_dir=None)
#
#     eingabe_file (FileSelectBox) um ein neues File zu generieren
#     mit folgenden Parameter
#     file_types = "*.c *.h"      Filetypen (auch feste namen m�glich "abc.py")
#     start_dir  = "d:\\abc"	Anfangspfad
#     comment    = "Suche Datei"  Windows Leisten text
#     return selected_file or None
#
# ------------------------------------------------------------------------------------------------------
# items = abfrage_listbox(liste,smode):
#     """ Listenabfrage Auswahl eines oder mehrere items aus einer Liste
#         Beispiel:
#         liste       Liste von auszuw�hlend
#         smode       "s" singlemode, nur ein item darf ausgew�hlt werden
#                     "e" extended mehrere items
#         Beispiel
#         liste = ["Dieter","Roland","Dirk"]
#         items = abfrage_listbox(liste,"s")
#         for item in items:
#             print "\nName: %s" % liste[item]
# ------------------------------------------------------------------------------------------------------
# filename = abfrage_file(file_types="*.*",comment=None,start_dir=None):
# ------------------------------------------------------------------------------------------------------

import tkinter as Tk
# import tkinter.filedialog
from tkinter.filedialog import askopenfilename
from tkinter import ttk
import tkinter.messagebox
import os
import sys
import types
# import tkinter.ttk
import string
import copy

# -------------------------------------------------------------------------------
t_path, _ = os.path.split(__file__)
if (t_path == os.getcwd()):
    
    import sstr
    import hfkt as h
    import hfkt_def as hdef
    import hfkt_type as htype
    import hfkt_list as hlist
    import hfkt_tvar as htvar
    
    import sgui_class_abfrage_n_eingabezeilen as sclass_ane
    import sgui_abfrage_tabelle_class as stabelle_class
else:
    p_list = os.path.normpath(t_path).split(os.sep)
    if (len(p_list) > 1): p_list = p_list[: -1]
    t_path = ""
    for i, item in enumerate(p_list): t_path += item + os.sep
    if (os.path.normpath(t_path) not in sys.path): sys.path.append(t_path)
    
    from tools import sstr
    from tools import hfkt as h
    from tools import hfkt_def as hdef
    from tools import hfkt_type as htype
    from tools import hfkt_list as hlist
    from tools import hfkt_tvar as htvar
    from tools import sgui_class_abfrage_n_eingabezeilen as sclass_ane
    from tools import sgui_abfrage_tabelle_class as stabelle_class

# endif--------------------------------------------------------------------------

OK = 1
NOT_OK = 0
TCL_ALL_EVENTS = 0

GUI_GEOMETRY_WIDTH_BASE = 800
GUI_GEOMETRY_HEIGHT_BASE = 600
GUI_ICON_FILE_BASE = "SGUI.ico"


# ===============================================================================
# ========================== abfrage_liste ======================================
# ===============================================================================
def abfrage_liste_index(liste, title=None):
    obj = abfrage_liste_class(liste, title=title)
    index = obj.index
    del obj
    return index


def abfrage_liste_indexListe(liste, title=None):
    obj = abfrage_liste_class(liste, title=title)
    indexListe = obj.indexListe
    del obj
    return indexListe


def abfrage_liste_index_abfrage_index(liste, listeAbfrage, title=None):
    obj = abfrage_liste_class(liste, listeAbfrage, title)
    index = obj.index
    indexAbfrage = obj.indexAbfrage
    del obj
    return (index, indexAbfrage)


def abfrage_liste_indexListe_abfrage_index(liste, listeAbfrage, title=None):
    obj = abfrage_liste_class(liste, listeAbfrage, title)
    indexListe = obj.indexListe
    indexAbfrage = obj.indexAbfrage
    del obj
    return (indexListe, indexAbfrage)


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
    GUI_GEOMETRY_WIDTH = GUI_GEOMETRY_WIDTH_BASE
    GUI_GEOMETRY_HEIGHT = GUI_GEOMETRY_HEIGHT_BASE
    GUI_GEOMETRY_POSX = 0
    GUI_GEOMETRY_POSY = 0
    GUI_ICON_FILE = GUI_ICON_FILE_BASE
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
    def __init__(self, liste, listeAbfrage=None, title=None):
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

# -------------------------------------------------------------------------------
# ------------------------ entry pop up -----------------------------------------
class EntryPopup(ttk.Entry):
    def __init__(self, root, tree, iid, column, text, **kw):
        super().__init__(root, **kw)
        self.tv = tree  # reference to parent window's treeview
        self.iid = iid  # row id
        self.column = column

        self.insert(0, text)
        self['exportselection'] = False  # Prevents selected text from being copied to
        # clipboard when widget loses focus
        self.focus_force()  # Set focus to the Entry widget
        self.select_all()  # Highlight all text within the entry widget
        self.bind("<Return>", self.on_return)  # Enter key bind
        self.bind("<Control-a>", self.select_all)  # CTRL + A key bind
        self.bind("<Escape>", lambda *ignore: self.destroy())  # ESC key bind

    def on_return(self, event):
        '''Insert text into treeview, and delete the entry popup'''
        rowid = self.tv.focus()  # Find row id of the cell which was clicked
        vals = self.tv.item(rowid, 'values')  # Returns a tuple of all values from the row with id, "rowid"
        vals = list(vals)  # Convert the values to a list so it becomes mutable
        vals[self.column] = self.get()  # Update values with the new text from the entry widget
        self.tv.item(rowid, values=vals)  # Update the Treeview cell with updated row values
        self.destroy()  # Destroy the Entry Widget

    def select_all(self, *ignore):
        ''' Set selection on the whole text '''
        self.selection_range(0, 'end')
        return 'break'  # returns 'break' to interrupt default key-bindings


# ------------------------ entry pop up -----------------------------------------
# -------------------------------------------------------------------------------
#
#
# ===============================================================================
# ========================== abfrage_tabelle2 =====================================
#
# gibt den geänderten data_set zurück
# Input:
#
# must be set
# ddict_inp["ttable"] = ttable
# or
# ddict_inp["header_liste"] = header_liste
# ddict_inp["data_set_lliste"] = data_set = [a0,a1,a2,..., an],[b0,b1,b2,...,bn], ...  [z0,z1,z2,...,zn]]
#
# optional
# ddict_inp["title"] = 'Tabelle'
# ddict_inp["row_color_dliste"] = ['','black','','red',...]
# ddict_inp["abfrage_liste"] = ["okay","cancel","end","edit",...]
# ddict_inp["auswahl_filter_col_liste"] = ["headername1","headername3"] oder [0,2]
# ddict_inp["GUI_GEOMETRY_WIDTH"] = 1000
# ddict_inp["GUI_GEOMETRY_HEIGHT"] = 600
# ddict_inp["GUI_ICON_FILE"] = file.icon
# ddict_inp["GUI_TITLE"] = text
#
# Ouput:
#
# return ddict_out
# mit
# ddict_out["data_set"]                     return modified data set
# dindex of ddict_inp["abfrage_liste"] if clicked otherwise -1
# ddict_out["irow_select"]                  selcted row if click otherwise -1
# ddict_out["status"]                       status
# ddict_out["errtext"]                      errtext
# ddict_out["data_change_irow_icol_liste"]  list of (irow,icol) from data whih were changed
# ddict_out["data_change_flag"]             are dates changed


def abfrage_tabelle(ddict_inp):
    
    
    obj = stabelle_class.abfrage_tabelle_class(ddict_inp)

    ddict_out = {}
    ddict_out["status"] = obj.status
    ddict_out["errtext"] = obj.errtext
    
    if obj.status == hdef.OKAY:

        if obj.use_ttable:
            ddict_out["ttable"] = htvar.build_table(obj.header_liste,obj.data_set,obj.ttable_type_liste)
        else:
            ddict_out["data_set"] = obj.data_set
        # end if
        ddict_out["index_abfrage"] = obj.index_abfrage
        ddict_out["irow_select"] = obj.current_row
        ddict_out["data_change_irow_icol_liste"] = obj.data_change_irow_icol_liste
        ddict_out["data_change_flag"] = obj.data_change_flag
    # end if
    del obj
    return ddict_out
# end def
# ========================== abfrage_tabelle2 ======================================
# ===============================================================================

# ===============================================================================
# ========================== abfrage_dict =======================================
def abfrage_dict(ddict,title=None):
    DATA_FLOAT = 0
    DATA_INTEGER = 1
    DATA_STRING = 2

    liste = []
    vorgabe_liste = []
    type_liste = []
    index_liste = []
    key_liste = []
    changed_key_liste = []
    for key in ddict.keys():
        if isinstance(ddict[key],str):
            liste.append(f"{key}")
            vorgabe_liste.append(ddict[key])
            type_liste.append(DATA_STRING)
            index_liste.append(-1)
            key_liste.append(key)
        elif isinstance(ddict[key],int):
            liste.append(f"{key}")
            vorgabe_liste.append(str(ddict[key]))
            type_liste.append(DATA_INTEGER)
            index_liste.append(-1)
            key_liste.append(key)
        elif isinstance(ddict[key],float):
            liste.append(f"{key}")
            vorgabe_liste.append(str(ddict[key]))
            type_liste.append(DATA_FLOAT)
            index_liste.append(-1)
            key_liste.append(key)
        elif isinstance(ddict[key],list):
            flag = True
            sub_liste = []
            sub_vorgabe_liste = []
            sub_type_liste = []
            sub_index_liste = []
            sub_key_liste = []
            for i,item in enumerate(ddict[key]):
                if isinstance(item,list):
                    flag = False
                    break
                elif isinstance(item, str):
                    sub_liste.append(f"{key}_{i}")
                    sub_vorgabe_liste.append(item)
                    sub_type_liste.append(DATA_STRING)
                    sub_index_liste.append(i)
                    sub_key_liste.append(key)
                elif isinstance(item, int):
                    sub_liste.append(f"{key}_{i}")
                    sub_vorgabe_liste.append(str(item))
                    sub_type_liste.append(DATA_INTEGER)
                    sub_index_liste.append(i)
                    sub_key_liste.append(key)
                elif isinstance(item, float):
                    sub_liste.append(f"{key}_{i}")
                    sub_vorgabe_liste.append(str(item))
                    sub_type_liste.append(DATA_FLOAT)
                    sub_index_liste.append(i)
                    sub_key_liste.append(key)
                # end
            # end ofr
            if flag:
                liste += sub_liste
                vorgabe_liste += sub_vorgabe_liste
                type_liste += sub_type_liste
                index_liste += sub_index_liste
                key_liste += sub_key_liste
            # end if
        # end if
    # end for
    if len(liste) > 0:
        obj = sclass_ane.abfrage_n_eingabezeilen_class(liste=liste, vorgabe_liste=vorgabe_liste, title=title)
        liste_ausgabe = obj.eingabeListe
        del obj

        if len(liste_ausgabe) == len(liste):

            for i,value in enumerate(liste_ausgabe):
                key = key_liste[i]
                if index_liste[i] < 0:
                    if type_liste[i] == DATA_STRING:
                        if ddict[key] != value:
                            ddict[key] = value
                            changed_key_liste.append(key)
                        # end if
                    elif type_liste[i] == DATA_FLOAT:
                        try:
                            val = float(value)
                            if ddict[key] != val:
                                ddict[key] = val
                                changed_key_liste.append(key)
                            # end if
                        except:
                            print(f"ddict[ {key} = {value} could not be transfered into float")
                        # end try
                    elif type_liste[i] == DATA_INTEGER:
                        try:
                            val = int(value)
                            if ddict[key] != val:
                                ddict[key] = val
                                changed_key_liste.append(key)
                            # end if
                        except:
                            print(f"ddict[ {key} = {value} could not be transfered into int")
                        # end try
                else:
                    index = index_liste[i]
                    if type_liste[i] == DATA_STRING:
                        
                        if ddict[key][index] != value:
                            ddict[key][index] = value
                            if key not in changed_key_liste.keys():
                                changed_key_liste.append(key)
                        # end if
                    elif type_liste[i] == DATA_FLOAT:
                        try:
                            val = float(value)
                            if ddict[key][index] != val:
                                ddict[key][index] = val
                                if key not in changed_key_liste.keys():
                                    changed_key_liste.append(key)
                            # end if
                        except:
                            print(f"ddict[ {key} = {value} could not be transfered into float")
                        # end try
                    elif type_liste[i] == DATA_INTEGER:
                        try:
                            val = int(value)
                            if ddict[key][index] != val:
                                ddict[key][index] = val
                                if key not in changed_key_liste.keys():
                                    changed_key_liste.append(key)
                            # end if
                        except:
                            print(f"ddict[ {key} = {value} could not be transfered into int")
                        # end try
                    # end if
                # end if
            # end for
        # end if
    # end if
    return (ddict,changed_key_liste)
# end def
# ========================== abfrage_dict =======================================
# ===============================================================================


# ===============================================================================
# ========================== abfrage_n_eingabezeilen ============================
def abfrage_n_eingabezeilen(liste, vorgabe_liste=None, title=None):
    """
      Gui Abfrage verschiedener Eingaben
      z.B.
      listeAnzeige = ["Materialname","Materialmesseinheit","Materialabrechnungseinheit"]
      listeErgebnis = sgui.abfrage_n_eingabezeilen(listeAnzeige)
      oder mit Vorgabe
      listeAnzeige = ["Materialname","Materialmesseinheit","Materialabrechnungseinheit"]
      listeDefault = ["Kaffee","kg","Tassen"]
      listeErgebnis = sgui.abfrage_n_eingabezeilen(liste=listeAnzeige,vorgabe_liste=listeDefault,title="Materialbestimmung")
      oder mit eintelnen Comboboxen
      listeAnzeige = [["Materialname",["Kaffee","Tee","Eis"]],"Materialmesseinheit","Materialabrechnungseinheit"]
      listeDefault = ["Tee","kg","Tassen"]
      listeErgebnis = sgui.abfrage_n_eingabezeilen(liste=listeAnzeige,vorgabe_liste=listeDefault,title="Materialbestimmung")
      
      if listeErgebnis is empty cancel was clicked
      
    """
    obj = sclass_ane.abfrage_n_eingabezeilen_class(liste=liste, vorgabe_liste=vorgabe_liste, title=title)
    liste = obj.eingabeListe
    del obj
    return liste
# end def

def abfrage_n_eingabezeilen_dict(ddict):
    """
      Gui Abfrage verschiedener Eingaben
      z.B.
      listeAnzeige = ["Materialname","Materialmesseinheit","Materialabrechnungseinheit"]
      oder mit eintelnen Comboboxen
      listeAnzeige = [["Materialname",["Kaffee","Tee","Eis"]],"Materialmesseinheit","Materialabrechnungseinheit"]
      listeErgebnis = sgui.abfrage_n_eingabezeilen(listeAnzeige)
      oder mit Vorgabe
      listeAnzeige = ["Materialname","Materialmesseinheit","Materialabrechnungseinheit"]
      listeDefault = ["Kaffee","kg","Tassen"]
      
      ddict = {}
      ddict["liste_abfrage"] = listeAnzeige
      optional
      ddict["liste_vorgabe"] = listeDefault
      ddict["title"] = "Materialbestimmung"
      ddict["liste_immutable"] = [0,0,1]              Wenn eins dann wird die Vorgabe gezeigt aber nicht änderbar
      
      if listeErgebnis is empty cancel was clicked

    """
    
    if "liste_abfrage" not in ddict.keys():
        raise Exception(f"dictionary ddict hat keine key: \"liste_abfrage\" ")
    # end if
    
    if"liste_vorgabe" in ddict.keys():
        vorgabe_liste = ddict["liste_vorgabe"]
    else:
        vorgabe_liste = None
    # end if

    if"title" in ddict.keys():
        title = ddict["title"]
    else:
        title = None
    # end if

    if"liste_immutable" in ddict.keys():
        liste_immutable = ddict["liste_immutable"]
    else:
        liste_immutable = None
    # end if

    obj = sclass_ane.abfrage_n_eingabezeilen_class(liste=ddict["liste_abfrage"], vorgabe_liste=vorgabe_liste, title=title, liste_immutable=liste_immutable)
    liste = obj.eingabeListe
    del obj
    return liste


# end def


# ========================== abfrage_n_eingabezeilen ============================
# ===============================================================================

# ===============================================================================
# ========================== abfrage_janein ============================
def abfrage_janein(text=None, title=None):
    """
      Gui Abfrage Ja-Nein
      return True  (Ja)
             False (Nein)
    """
    obj = abfrage_janein_class(text=text, title=title)
    flagJa = obj.flagJa
    del obj
    
    if (flagJa):
        return True
    else:
        return False


class abfrage_janein_class:
    """
      Gui Abfrage Ja-Nein Frage
      z.B.
  
    """
    GUI_GEOMETRY_WIDTH = GUI_GEOMETRY_WIDTH_BASE
    GUI_GEOMETRY_HEIGHT = GUI_GEOMETRY_HEIGHT_BASE
    GUI_GEOMETRY_POSX = 0
    GUI_GEOMETRY_POSY = 0
    GUI_ICON_FILE = GUI_ICON_FILE_BASE
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


# ========================== anzeige_text ========================================
# ===============================================================================
def anzeige_text(texteingabe, title=None, textcolor='black'):
    text_liste = []
    
    if (isinstance(texteingabe, str)):
        text_liste = texteingabe.split('\n')
    elif (isinstance(texteingabe, list)):
        text_liste = texteingabe
    
    obj = anzeige_text_class(text_liste, title, textcolor)
    
    del obj


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
    GUI_GEOMETRY_WIDTH = GUI_GEOMETRY_WIDTH_BASE
    GUI_GEOMETRY_HEIGHT = GUI_GEOMETRY_HEIGHT_BASE
    GUI_GEOMETRY_POSX = 0
    GUI_GEOMETRY_POSY = 0
    GUI_ICON_FILE = GUI_ICON_FILE_BASE
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
    def __init__(self, text_liste, title=None, textcolor='black'):
        """
        """
        self.status = hdef.OKAY
        self.str_liste = []
        self.index_liste = []
        self.str_auswahl_liste = []
        self.index_auswahl_liste = []
        self.indexListe = []
        self.abfrage_liste = [u'okay']
        self.index = -1
        self.act_frame_id = 0
        self.title = u"Anzeigee"
        self.textcolor = textcolor
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
            b_back = Tk.Button(gr_buts, text=name, command=self.exitMenu)  # lambda m=method: self.populateMethod(m))
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


# ========================== abfrage_dir ========================================
# ===============================================================================
def abfrage_dir(comment=None, start_dir=None):
    """ gui f�r Pfad auszuw�hlen """
    import traceback
    
    global dirlist
    
    try:
        root = tkinter.ttk.Tk()
        dirlist = DirList(root, start_dir, comment)
        dirlist.mainloop()
        if (dirlist.dlist_dir == ""):
            dirname = None
        else:
            dirname = dirlist.dlist_dir + "\\"
        dirlist.destroy()
        
        if (not os.path.exists(dirname) and dirname):
            
            comment = "Soll das Verzeichnis <%s> angelegt werden??" % dirname
            if (abfrage_ok_box(comment)):
                os.makedirs(dirname)
            else:
                dirname = None
    
    
    except:
        t, v, tb = sys.exc_info()
        dirname = None
        text = "Error running the demo script:\n"
        for line in traceback.format_exception(t, v, tb):
            text = text + line + '\n'
            d = tkinter.messagebox.showerror('tkinter.ttk Demo Error', text)
    return dirname


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
            self.root.tk.dooneevent(TCL_ALL_EVENTS)
        # self.root.tk.dooneevent(TCL_DONT_WAIT)
    
    def destroy(self):
        self.root.destroy()


# ========================== eingabe_file ========================================
# ===============================================================================
def eingabe_file(file_types="*", comment="Waehle oder benenne neue Datei", start_dir=None):
    """
    eingabe_file (FileSelectBox) um ein neues File zu generieren
                                mit folgenden Parameter
    file_types = "*.c *.h"      Filetypen (auch feste namen m�glich "abc.py")
    start_dir  = "d:\\abc"	Anfangspfad
    comment    = "Suche Datei"  Windows Leisten text
    return selected_file or None
    """
    selected_file = None
    count = 0
    while (count < 10):
        count = count + 1
        root = tkinter.ttk.Tk()
        f = SFileSelectBox(root, file_types, comment, start_dir)
        f.mainloop()
        f.destroy()
        print(f.SELECTED_FILE)
        selected_file = f.SELECTED_FILE
        del f
        
        if (os.path.exists(selected_file)):
            
            if (abfrage_ok_box(text="Die Datei <%s> existiert bereits" % selected_file) == OK):
                return selected_file
        else:
            return selected_file


class SFileSelectBox:
    TCL_ALL_EVENTS = 0
    SELECTED_FILE = ""
    
    def __init__(self, w, file_types=None, text=None, start_dir=None):
        
        self.root = w
        self.exit_flag = False
        
        z = w.winfo_toplevel()
        
        # Extension
        if (not file_types or not isinstance(file_types, str)):
            file_types = "*.*"
        
        # Comment
        if (text and isinstance(text, str)):
            z.wm_title(text)
        else:
            z.wm_title("Waehle eine Datei aus")
        
        # Start Directory
        if (not start_dir or not isinstance(start_dir, str)):
            start_dir = os.getcwd()
        
        top = tkinter.ttk.Frame(w \
                                , relief=Tk.FLAT \
                                , bd=20 \
                                )
        
        top.fselect = tkinter.ttk.FileSelectBox(top \
                                                , dir=start_dir \
                                                , pattern=file_types \
                                                )
        
        top.okbtn = tkinter.ttk.Button(top \
                                       , text='Ok' \
                                       , width=10 \
                                       , command=lambda x=top: self.okcmd(x) \
                                       )
        
        top.quitbtn = tkinter.ttk.Button(top \
                                         , text='Quit' \
                                         , width=10 \
                                         , command=lambda x=top: self.quitcmd(x) \
                                         )
        
        top.pack(expand='yes' \
                 , fill='both' \
                 , side=tkinter.ttk.TOP \
                 )
        
        top.fselect.pack(expand=1 \
                         , fill=tkinter.ttk.BOTH \
                         , padx=4 \
                         , pady=4 \
                         , side=tkinter.ttk.LEFT \
                         )
        
        top.okbtn.pack(side=tkinter.ttk.BOTTOM)
        
        top.quitbtn.pack(side=tkinter.ttk.BOTTOM)
        
        z.wm_protocol("WM_DELETE_WINDOW" \
                      , lambda x=top: self.quitcmd(x) \
                      )
    
    def okcmd(self, top):
        self.SELECTED_FILE = top.fselect.cget('value')
        self.exit_flag = True
    
    def quitcmd(self, top):
        self.SELECTED_FILE = ""
        self.exit_flag = True
    
    def mainloop(self):
        while not self.exit_flag:
            self.root.tk.dooneevent(TCL_ALL_EVENTS)
    
    def destroy(self):
        self.root.destroy()


# ========================== abfrage_listbox ========================================
# ===============================================================================
def abfrage_listbox(liste, smode):
    """ Listenabfrage Auswahl eines oder mehrere items aus einer Liste
        Beispiel:
        liste       Liste von auszuw�hlend
        smode       "S" singlemode, nur ein item darf ausgew�hlt werden
                    "E" extended mehrere items
        Beispiel
        liste = ["Dieter","Roland","Dirk"]
        items = abfrage_listbox(liste,"s")
        for item in items:
            print "\nName: %s" % liste[item]
    """
    
    t = slistbox(liste=liste, smode=smode)
    t.tk.mainloop()
    
    items = t.items
    # t.tk.destroy()
    
    return items


class slistbox:
    def __init__(self, liste, smode="E"):
        self.tk = Tk.Tk()
        self.name = "Listbox"
        self.items = []
        
        # liste auf H�he und Breite auswerten
        lh = len(liste)
        lw = 0
        for item in liste:
            lw = max(lw, len(item))
        if lh > 30:
            lh1 = 30
            hscroll = 1
        else:
            lh1 = lh
            hscroll = 0
        
        if (smode == "S" or smode == "s"):
            selectm = Tk.SINGLE
        else:
            selectm = Tk.EXTENDED
        
        # Listbox erstellen
        if hscroll > 0:  # mit vertikal Scrollbar
            
            hscrollbar = Tk.Scrollbar(self.tk)
            hscrollbar.pack(side=Tk.RIGHT, fill=Tk.Y)
            self.listbox = Tk.Listbox(self.tk, height=lh1, width=30
                                      , selectmode=selectm
                                      , yscrollcommand=hscrollbar.set)
            self.listbox.pack(side=Tk.LEFT, fill=Tk.Y)
            hscrollbar.config(command=self.listbox.yview)
        
        else:  # ohne Scrollbar
            self.listbox = Tk.Listbox(self.tk, height=lh1, width=30
                                      , selectmode=selectm)
            self.listbox.pack()
        
        # Bindung zum Beenden
        self.listbox.bind_all('<Return>', self.get_items_and_close)
        
        # Listbox f�llen
        for item in liste:
            self.listbox.insert('end', item)
    
    def get_items_and_close(self, event):
        
        # items abfragen
        items = self.listbox.curselection()
        
        # wegen alter Version transformieren
        try:
            items = map(string.atoi, items)
        except ValueError:
            pass
        
        # items an struktur �bergeben
        for i in items:
            self.items.append(int(i))
        
        # widget l�schen
        return


# ========================== abfrage_ok_box ========================================
# ===============================================================================
def abfrage_ok_box(text="Ist das okay"):
    root = Tk.Tk()
    f = SOkCancelBox(root, text)
    f.mainloop()
    f.destroy()
    return f.OK_FLAG


class SOkCancelBox:
    TCL_ALL_EVENTS = 0
    
    def __init__(self, w, comment=None):
        
        self.root = w
        self.exit_flag = False
        self.OK_FLAG = False
        
        z = w.winfo_toplevel()
        
        # Comment
        if (comment and isinstance(comment, str)):
            pass
        else:
            comment = "Ok oder Cancel"
        
        top = tkinter.ttk.Frame(w \
                                , relief=tkinter.ttk.FLAT \
                                , bd=20 \
                                )
        
        ##        top.label = tkinter.ttk.Label(w, padx=20, pady=10, bd=1, relief=tkinter.ttk.RAISED,
        ##		    anchor=tkinter.ttk.CENTER, text=comment)
        top.label = tkinter.ttk.Label(top, bd=1, relief=tkinter.ttk.RAISED,
                                      anchor=tkinter.ttk.CENTER, text=comment)
        
        top.okbtn = tkinter.ttk.Button(top \
                                       , text='Ok' \
                                       , width=10 \
                                       , command=lambda x=top: self.okcmd(x) \
                                       )
        
        top.quitbtn = tkinter.ttk.Button(top \
                                         , text='Cancel' \
                                         , width=10 \
                                         , command=lambda x=top: self.quitcmd(x) \
                                         )
        
        top.pack(expand='yes' \
                 , fill='both' \
                 , side=tkinter.ttk.TOP \
                 )
        
        top.label.pack(side=tkinter.ttk.TOP)
        top.okbtn.pack(side=tkinter.ttk.BOTTOM)
        
        top.quitbtn.pack(side=tkinter.ttk.BOTTOM)
        
        z.wm_protocol("WM_DELETE_WINDOW" \
                      , lambda x=top: self.quitcmd(x) \
                      )
    
    def okcmd(self, top):
        self.OK_FLAG = True
        self.exit_flag = True
    
    def quitcmd(self, top):
        self.OK_FLAG = False
        self.exit_flag = True
    
    def mainloop(self):
        while not self.exit_flag:
            self.root.tk.dooneevent(TCL_ALL_EVENTS)
    
    def destroy(self):
        self.root.destroy()


#
# ========================== abfrage_liste_scroll ========================================
# ===============================================================================

def abfrage_liste_scroll(liste, comment=None, cols=70, rows=20, multi=0):
    """ Listenabfrage Auswahl eines items aus einer Liste
        wobei auf dem Bildschirm gescrollt wird (da lange und gro�)
        Wenn kein Wert zur�ckgegeben, dann okay = 0
        Es werden die Werte in einer Liste zur�ckgegeben, wenn multi=1
        Es k�nnen mehrere Werte getrennt mit Komma eingeben werden.
        Es wird nur ein Wert zur�ckgegeben, wenn multi=0 (default)

        Beispiel:
        liste = (("","Ueberschrift"),
                 ("a","Daten einladen/anlegen"),
                 ("b","Daten speichern"),
                 ("c","Daten speichern"))
        (val,okay) = abfrage_liste(liste,cols=70,rows=20,multi=0)

        EIngabe a   => val = "a", okay = 1

        val = abfrage_liste(liste,cols=70,rows=20,multi=0)
        Eingabe a,c => val = ["a","c"]
        oder Beispiel:
        liste = ("Daten einladen/anlegen",
                 "Daten speichern",
                 "Daten speichern")
        val = abfrage_liste(liste,cols=70,rows=20)

        EIngabe 1   => val = 0, okay = 1

    """
    icount = 0
    if (not h.is_list(liste[0]) \
        and not h.is_tuple(liste[0])):
        
        nliste = []
        ic = 0
        for item in liste:
            ic = ic + 1
            nliste.append(["%i" % ic, item])
        liste = nliste
    ##        print "abfrage_liste.error: liste hat nicht das korrekte Format"
    ##        print liste
    ##        return None
    
    # alles in eine Liste formatieren
    lliste = []
    if (comment):
        t = comment
        while len(t) > 0:
            idum = min(cols, len(t))
            tdum = t[0:idum]
            lliste.append(tdum)
            t = t[idum:len(t)]
    
    auswahl_liste = []
    for i in range(len(liste)):
        
        if (isinstance(liste[i][0], str)):
            tdum = "%3s" % liste[i][0]
        elif (isinstance(liste[i][0], int)):
            tdum = "%3i" % liste[i][0]
        elif (isinstance(liste[i][0], float)):
            tdum = "%3f" % liste[i][0]
        else:
            print("abfrage_liste_scroll.error: liste[i][0] hat nicht das korrekte Format")
            print(liste[i][0])
            return None, 0
        auswahl_liste.append(sstr.elim_ae(tdum, ' '))
        if (len(tdum) > 0):
            tdum = tdum + ":"
        else:
            tdum = tdum + " "
        
        t = liste[i][1]
        
        while len(t) > 0:
            if (len(tdum) >= cols):
                lliste.append(tdum)
                tdum = "    "
            l1 = min(cols - len(tdum), len(t))
            tdum = tdum + t[0:l1]
            t = t[l1:len(t)]
        lliste.append(tdum)
    
    end_sign = "e"
    while (end_sign in auswahl_liste):
        end_sign = end_sign + "e"
    
    iact = 0
    inp = "-"
    l1 = len(lliste)
    while (True):
        
        if (inp == "+"):
            iact = min(iact + rows - 1, max(0, l1 - rows + 1))
        if (inp == "-"):
            iact = max(0, iact - rows + 1)
        
        ic = iact
        ie = max(min(l1, iact + rows - 1), 0)
        while (ic < ie):
            print(lliste[ic])
            ic = ic + 1
        if (l1 > rows - 1):
            if (multi):
                inp = input("<+,-," + end_sign + ",Wert(e)(,)> : ")
            else:
                inp = input("<+,-," + end_sign + ",Wert> : ")
        else:
            if (multi):
                inp = input("<" + end_sign + ",Wert(e)(,)> : ")
            else:
                inp = input("<" + end_sign + ",Wert> : ")
        
        if (inp == end_sign):
            return None, 0
        
        if (not (l1 > rows - 1 and (inp == "+" or inp == "-"))):
            if (multi):
                linp = inp.split(",")
                liste = []
                for inp in linp:
                    if (inp in auswahl_liste and len(inp) > 0):
                        for i in range(len(auswahl_liste)):
                            if (inp == auswahl_liste[i]):
                                liste.append(inp)
                if (len(liste) > 0):
                    return liste, 1
            else:
                if (inp in auswahl_liste and len(inp) > 0):
                    for i in range(len(auswahl_liste)):
                        if (inp == auswahl_liste[i]):
                            return inp, 1


#
# ========================== abfrage_liste_scroll ========================================
# ===============================================================================
def abfrage_liste(liste, comment=None):
    """ Listenabfrage Auswahl eines items aus einer Liste
        Beispiel:
        liste = (("0","Daten einladen/anlegen"),
                 ("1","Daten speichern"),
                 ("","Ist nur Kommenatr"))
        val = abfrage_liste(liste)
    """
    icount = 0
    if (not h.is_list(liste[0]) \
        and not h.is_tuple(liste[0])):
        
        print("abfrage_liste.error: liste hat nicht das korrekte Format")
        print(liste)
        return None
    else:
        print(" ")
        if (comment):
            print(comment)
            print(" ")
        while icount < 10:
            icount = icount + 1
            for i in range(0, len(liste), 1):
                
                if (isinstance(liste[i][0], str)):
                    print("%3s  %s" % (liste[i][0], liste[i][1]))
                elif (isinstance(liste[i][0], int)):
                    print("%3i  %s" % (liste[i][0], liste[i][1]))
                elif (isinstance(liste[i][0], float)):
                    print("%3f  %s" % (liste[i][0], liste[i][1]))
                else:
                    print("abfrage_liste.error: liste[i][0] hat nicht das korrekte Format")
                    print(liste[i][0])
                    return None
            
            x = input("\nAuswahl : ")
            
            if (len(x) > 0):
                
                for i in range(0, len(liste), 1):
                    
                    if (isinstance(liste[i][0], str)):
                        if x == liste[i][0]:
                            return x
                    elif (isinstance(liste[i][0], int)):
                        if int(x) == liste[i][0]:
                            return int(x)
                    elif (isinstance(liste[i][0], float)):
                        if (abs(float(x) - liste[i][0]) < 1.0e-10):
                            return float(x)
            
            print("\nFalsche Eingabe: %s " % x)
        return None
    return None


#
# ========================== eingabe_int ========================================
# ===============================================================================
def eingabe_int(comment):
    """ Eingabe von einem int-Wert mit Kommentar abgefragt """
    ival = int(0)
    io_flag = 0
    c = comment + " : "
    while (io_flag == 0):
        x = raw_input(c)
        if (len(x) == 0):
            ival = int(0)
        else:
            try:
                ival = int(x)
                io_flag = 1
            except ValueError:
                print("\n Falsche Eingabe, nochmal !!!")
    
    return ival


# ========================== eingabe_float ========================================
# ===============================================================================
def eingabe_float(comment):
    """ Eingabe von einem float-Wert mit Kommentar abgefragt """
    fval = float(0)
    io_flag = 0
    c = comment + " : "
    while (io_flag == 0):
        x = raw_input(c)
        if (len(x) == 0):
            fval = float(0)
        else:
            try:
                fval = float(x)
                io_flag = 1
            except ValueError:
                print("\n Falsche Eingabe, nochmal !!!")
    
    return fval


# ========================== eingabe_jn ========================================
# ===============================================================================

def eingabe_jn(comment, default=None):
    """ Eingabe von einem ja oder nein-Wert mit Kommentar abgefragt
        comment: Kommentar
        default: True oder "ja", False oder "nein"
    """
    if (default != None):
        if (isinstance(default, bool)):
            if (default):
                def_sign = 'j'
            else:
                def_sign = 'n'
        elif (isinstance(default, str)):
            if (default[0] == 'j' or default[0] == 'J' or \
                default[0] == 'y' or default[0] == 'Y'):
                def_sign = 'j'
            else:
                def_sign = 'n'
        else:
            def_sign = 'n'
    
    if (default != None):
        frage = "j/n <def:%s> : " % def_sign
    else:
        frage = "j/n : "
    
    io_flag = 0
    while (io_flag == 0):
        print(comment)
        x = raw_input(frage)
        if (len(x) == 0):
            if (default != None):
                x = def_sign
            else:
                x = 'p'
        if (x[0] == 'j' or x[0] == 'J' or \
            x[0] == 'y' or x[0] == 'Y'):
            
            erg = True
            io_flag = 1
        elif (x[0] == 'n' or x[0] == 'N'):
            erg = False
            io_flag = 1
        else:
            print("\n Falsche Eingabe, nochmal !!!")
    
    return erg


def abfrage_ok_box(text="Ist das okay"):
    root = tkinter.ttk.Tk()
    f = SOkCancelBox(root, text)
    f.mainloop()
    f.destroy()
    return f.OK_FLAG


def abfrage_dir(comment=None, start_dir=None):
    """ gui f�r Pfad auszuw�hlen """
    import traceback
    
    global dirlist
    
    try:
        root = tkinter.ttk.Tk()
        dirlist = DirList(root, start_dir, comment)
        dirlist.mainloop()
        if (dirlist.dlist_dir == ""):
            dirname = None
        else:
            dirname = dirlist.dlist_dir + "\\"
        dirlist.destroy()
        
        if (not os.path.exists(dirname) and dirname):
            
            comment = "Soll das Verzeichnis <%s> angelegt werden??" % dirname
            if (abfrage_ok_box(comment)):
                os.makedirs(dirname)
            else:
                dirname = None
    
    
    except:
        t, v, tb = sys.exc_info()
        dirname = None
        text = "Error running the demo script:\n"
        for line in traceback.format_exception(t, v, tb):
            text = text + line + '\n'
            d = tkinter.messagebox.showerror('tkinter.ttk Demo Error', text)
    return dirname


def abfrage_sub_dir(comment=None, start_dir=None):
    """ gui f�r Unterpfad von start_dir auszuw�hlen """
    import traceback
    
    global dirlist
    
    if (not os.path.exists(start_dir)):
        print("Das angegebene Start-Verzeichnis <%s> exsistiert nicht !!!" % start_dir)
        return None
    
    dirname = None
    dir_not_found = True
    while dir_not_found:
        try:
            root = tkinter.ttk.Tk()
            dirlist = DirList(root, start_dir, comment, True)
            dirlist.mainloop()
            
            if (dirlist.quit_flag):
                dirlist.destroy()
                return None
            
            if (dirlist.dlist_dir == ""):
                dirname = None
            else:
                dirname = dirlist.dlist_dir + "\\"
            dirlist.destroy()
        except:
            t, v, tb = sys.exc_info()
            dirname = None
            text = "Error running the demo script:\n"
            for line in traceback.format_exception(t, v, tb):
                text = text + line + '\n'
                d = tkinter.messagebox.showerror('tkinter.ttk Demo Error', text)
        
        dirname1 = sstr.change_max(dirname, "\\", "/")
        start_dir1 = sstr.change_max(start_dir, "\\", "/")
        if ((not os.path.exists(dirname)) or \
            (not dirname) or \
            (sstr.such(sstr.change_max(string.lower(dirname), "\\", "/"), \
                       sstr.change_max(string.lower(start_dir), "\\", "/"), "vs") != 0)):
            
            print("Verzeichnis <%s> liegt nicht in der start_dir <%s>" \
                  % (dirname, start_dir))
        else:
            dir_not_found = False
    
    return dirname


# ========================== abfrage_file ========================================
# ===============================================================================
def abfrage_file(file_types="*.*", comment=None, start_dir=None):
    """
    abfrage_file (FileSelectBox) um ein bestehendes Fiele einzuladen mit folgenden Parameter
    file_types = "*.c *.h"      Filetypen (auch feste namen m�glich "abc.py")
    start_dir  = "d:\\abc"	Anfangspfad
    comment    = "Suche Datei"  Windows Leisten text
    """
    # root = tkinter.ttk.Tk()
    # f = SFileSelectBox(root,file_types,comment,start_dir)
    # f.mainloop()
    # f.destroy()
    # return f.SELECTED_FILE
    
    if (not comment):
        comment = "search a file"
    
    if (not start_dir):
        start_dir = "D:/"
    
    ft = ("", file_types)
    
    root = tkinter.Tk()
    
    name = askopenfilename(parent=root,
                           initialdir=start_dir,
                           filetypes=(ft, ("All Files", "*.*")),
                           title=comment
                           )
    
    root.destroy()
    
    return name


def eingabe_file(file_types="*", comment="Waehle oder benenne neue Datei", start_dir=None):
    """
    eingabe_file (FileSelectBox) um ein neues File zu generieren
                                mit folgenden Parameter
    file_types = "*.c *.h"      Filetypen (auch feste namen m�glich "abc.py")
    start_dir  = "d:\\abc"	Anfangspfad
    comment    = "Suche Datei"  Windows Leisten text
    return selected_file or None
    """
    selected_file = None
    count = 0
    while (count < 10):
        count = count + 1
        root = tkinter.ttk.Tk()
        f = SFileSelectBox(root, file_types, comment, start_dir)
        f.mainloop()
        f.destroy()
        print(f.SELECTED_FILE)
        selected_file = f.SELECTED_FILE
        del f
        
        if (os.path.exists(selected_file)):
            
            if (abfrage_ok_box(text="Die Datei <%s> existiert bereits" % selected_file) == OK):
                return selected_file
        else:
            return selected_file


def eingabe_int(comment):
    """ Eingabe von einem int-Wert mit Kommentar abgefragt """
    ival = int(0)
    io_flag = 0
    c = comment + " : "
    while (io_flag == 0):
        x = raw_input(c)
        if (len(x) == 0):
            ival = int(0)
        else:
            try:
                ival = int(x)
                io_flag = 1
            except ValueError:
                print("\n Falsche Eingabe, nochmal !!!")
    
    return ival


def eingabe_string(comment):
    """ Eingabe von string-Wert mit Kommentar abgefragt """
    strval = ""
    io_flag = 0
    c = comment + " : "
    while (io_flag == 0):
        x = raw_input(c)
        if (len(x) > 0):
            try:
                strval = x
                io_flag = 1
            except ValueError:
                print("\n Falsche Eingabe, nochmal !!!")
    
    return strval


# ========================== eingabe_float ========================================
# ===============================================================================
def eingabe_float(comment):
    """ Eingabe von einem float-Wert mit Kommentar abgefragt """
    fval = float(0)
    io_flag = 0
    c = comment + " : "
    while (io_flag == 0):
        x = raw_input(c)
        if (len(x) == 0):
            fval = float(0)
        else:
            try:
                fval = float(x)
                io_flag = 1
            except ValueError:
                print("\n Falsche Eingabe, nochmal !!!")
    
    return fval


# ========================== eingabe_jn ========================================
# ===============================================================================
def eingabe_jn(comment, default=None):
    """ Eingabe von einem ja oder nein-Wert mit Kommentar abgefragt
        comment: Kommentar
        default: True oder "ja", False oder "nein"
        R�ckgabe True (ja) oder False (nein)
    """
    if (default != None):
        if (isinstance(default, bool)):
            if (default):
                def_sign = 'j'
            else:
                def_sign = 'n'
        elif (isinstance(default, str)):
            if (default[0] == 'j' or default[0] == 'J' or \
                default[0] == 'y' or default[0] == 'Y'):
                def_sign = 'j'
            else:
                def_sign = 'n'
        else:
            def_sign = 'n'
    
    if (default != None):
        frage = "j/n <def:%s> : " % def_sign
    else:
        frage = "j/n : "
    
    io_flag = 0
    while (io_flag == 0):
        print(comment)
        x = input(frage)
        if (len(x) == 0):
            if (default != None):
                x = def_sign
            else:
                x = 'p'
        if (x[0] == 'j' or x[0] == 'J' or \
            x[0] == 'y' or x[0] == 'Y'):
            
            erg = True
            io_flag = 1
        elif (x[0] == 'n' or x[0] == 'N'):
            erg = False
            io_flag = 1
        else:
            print("\n Falsche Eingabe, nochmal !!!")
    
    return erg


# ========================== abfrage_file ========================================
# ===============================================================================
def abfrage_file(file_types="*.*", comment=None, start_dir=None, default_extension=None, file_names=None):
    """
    filename = abfrage_file (FileSelectBox) um ein bestehendes Fiele einzuladen mit folgenden Parameter
    file_types = ["*.c","*.h"]      Filetypen (auch feste namen möglich "abc.py")
    comment    = "Suche Datei"  Windows Leisten text
    start_dir  = "d:\\abc"	Anfangspfad
    default_extension = "txt"
    file_names = ["C-Files","H-Files"]
  
    """
    ##    root = tkinter.ttk.Tk()
    ##    f = SFileSelectBox(root,file_types,comment,start_dir)
    ##    f.mainloop()
    ##    f.destroy()
    ##    return f.SELECTED_FILE
    
    if (default_extension and h.such(default_extension, ".", "vs") != 0):
        default_extension = "." + default_extension
    
    if (isinstance(file_types, str)):
        file_types = [file_types]
    
    format_liste = []
    if (file_names and isinstance(file_names, str)):
        file_names = [file_names]
    for i in range(len(file_types)):
        if (file_names and i < len(file_names)):
            format_liste.append([file_types[i], file_names[i]])
        else:
            format_liste.append((file_types[i], file_types[i]))
    
    root = tkinter.Tk()
    name = tkinter.filedialog.askopenfilename(master=root,
                                              defaultextension=default_extension,
                                              filetypes=format_liste,
                                              initialdir=start_dir,
                                              title=comment)
    root.destroy()
    name = h.change(name, "/", os.sep)
    
    return name


# enddef

if __name__ == '__main__':
    
    ddict_inp = {}
    ddict_inp["header_liste"] = ["Datum", "Markt", "Kosten", "Datum2", "Markt2", "Kosten2"]
    ddict_inp["data_set_lliste"] = [["1.2.2010", "Rewe", 10.15, "1.2.2010", "Rewe", 10.15]
                             , ["2.2.2010", "Penny", 20.15, "1.2.2010", "Rewe", 10.15]
                             , ["3.2.2010", "Netto", 30.15, "1.2.2010", "Rewe", 10.15]
                             , ["4.2.2010", "Lidl", 40.15, "1.2.2010", "Rewe", 10.15]
                             , ["5.2.2010", "Lidl", 50.15, "1.2.2010", "Rewe", 10.15]
                             , ["6.2.2010", "Rewe", 60.15, "1.2.2010", "Rewe", 10.15]
                             , ["7.2.2010", "Rewe", 70.15, "1.2.2010", "Rewe", 10.15]
                                        ]
    ddict_inp["title"] = 'Markt-Tabelle'
    ddict_inp["row_color_dliste"] = ['', 'grey', '', 'red','', 'grey', '', 'blue']
    ddict_inp["abfrage_liste"] = ["okay", "cancel", "end", "edit"]
    ddict_inp["auswahl_filter_col_liste"] = ["Markt", "Markt2"]
    
    (ddict_inp,changed_key_liste) = abfrage_dict(ddict_inp, title="modify dictionary")

    ddict_out = abfrage_tabelle(ddict_inp)

    print(ddict_out.keys())
    print(f"data_set = {ddict_out['data_set']}")
    print(f"index_abfrage = {ddict_out['index_abfrage']}")
    print(f"irow_select = {ddict_out['irow_select']}")
    print(f"status = {ddict_out['status']}")
    print(f"errtext = \"{ddict_out['errtext']}\"")
    """

    header_liste = ["Datuam", "Markt", "Kosten"]
    data_set = [["1.2.2010", "Rewe", 10.15, "1.2.2010", "Rewe", 10.15]
        , ["1.2.2010", "Rewe", 10.15, "1.2.2010", "Rewe", 10.15]
        , ["1.2.2010", "Rewe", 10.15, "1.2.2010", "Rewe", 10.15]
        , ["1.2.2010", "Rewe", 10.15, "1.2.2010", "Rewe", 10.15]
        , ["1.2.2010", "Rewe", 10.15, "1.2.2010", "Rewe", 10.15]
        , ["1.2.2010", "Rewe", 10.15, "1.2.2010", "Rewe", 10.15]
        , ["1.2.2010", "Rewe", 10.15, "1.2.2010", "Rewe", 10.15]
                ]
    # data = ['1.2.2010', 'Rewe', '10,15']
    # for i in range(100):
    #  data_set.append(data)
    
    index_data_liste = [1, 2, 3, 4, 5, 6, 7]
    
    (data_set_out, index) = abfrage_tabelle(header_liste=header_liste, data_set=data_set,
                                            data_index_liste=index_data_liste)
    
    print(data_set)
    print(data_set_out)
    
    texteingabe = []
    for i in range(30):
      texteingabe.append("ösqodh23odhodhoh")
      texteingabe.append("ABCDEFGHIJ")
      texteingabe.append("abcdefghij")
    t       = "Vorsicht"
    anzeige_text(texteingabe,title=t,textcolor='green')
    """
    # listeAnzeige = ["Materialname","Materialmesseinheit","Materialabrechnungseinheit","Materialname","Materialmesseinheit","Materialabrechnungseinheit","Materialname","Materialmesseinheit","Materialabrechnungseinheit","Materialname","Materialmesseinheit","Materialabrechnungseinheit","Materialname","Materialmesseinheit","Materialabrechnungseinheit"]
    # #listeAnzeige = ["Materialname","Materialmesseinheit","Materialabrechnungseinheit"]
    # listeErgebnis = abfrage_n_eingabezeilen(listeAnzeige)
    # print(listeErgebnis)

##    liste=[]
##    for i in range(0,10,1):
##        liste.append("abcdef "+chr(65+i))
##        # print ("%s" % liste[i])
##
##
##    [index,indexAbfrage] = abfrage_liste_index(liste)
##    print index
##    print indexAbfrage

###################################################################
