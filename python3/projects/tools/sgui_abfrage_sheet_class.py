
# ===============================================================================
# ========================== abfrage_sheet =====================================
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
#
# oder optional
# ddict_inp["row_col_color_cell_dict_liste"] = [{'row':i,'col':j,'fg':'black','bg':'red'},{'row':i,'col':j,'fg':'','bg':'red'},...]
# fg default is 'black' und bg default is 'white'
#
# ddict_inp["abfrage_liste"] = ["okay","cancel","end","edit",...]
# ddict_inp["auswahl_filter_col_liste"] = ["headername1","headername3"] oder [0,2]
# ddict_inp["auswahl_dat_filter"] = "Datum" oder 0
# ddict_inp["default_dat_filter"] = "Datum" oder 0
# ddict_inp["GUI_GEOMETRY_WIDTH"] = 1000
# ddict_inp["GUI_GEOMETRY_HEIGHT"] = 600
# ddict_inp["GUI_GEOMETRY_POSX"] = 100
# ddict_inp["GUI_GEOMETRY_POSY"] = 100
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
# ddict_out["GUI_GEOMETRY_WIDTH"]
# ddict_out["GUI_GEOMETRY_HEIGHT"]
# ddict_out["GUI_GEOMETRY_POSX"]
# ddict_out["GUI_GEOMETRY_POSY"]
#
# bei verwendung ddict_inp["auswahl_filter_col_liste"]
# 1) der String kann kann geteilt werden mit ";"
# Z.B. mit "Nummer;Zahl" sucht sowohl "Nummer" als auch "Zahl"
# 2) wird bei string immer nur der gesammte string einer Zelle gesucht,
# Wenn ! vorangestellt ist, dann wird nur der Teil gesucht (wenn größer 3 Zeichen)
# z.B. "!Num"   sucht alles in der Spalte mit Num
#

import tkinter as Tk
from tkinter import ttk
from tkinter import font as tkfont
from tksheet import Sheet

import os
import sys

# -------------------------------------------------------------------------------
t_path, _ = os.path.split(__file__)
if (t_path == os.getcwd()):

    import hfkt_def as hdef
    import hfkt_type as htype
    import hfkt_list as hlist
    import hfkt_tvar as htvar
    import sgui_def as sdef
    import sgui_class_abfrage_n_eingabezeilen as sclass_ane
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
    from tools import sgui_def as sdef

# endif--------------------------------------------------------------------------

class abfrage_sheet_class:
    """

    """
    DATA_FLOAT = 0
    DATA_INTEGER = 1
    DATA_STRING = 2

    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    def __init__(self, ddict_inp):
        """
        """
        self.toggle = True
        self.status = hdef.OKAY
        self.errtext = ""
        self.str_auswahl_liste = []
        self.index_auswahl_liste = []
        self.index = -1
        self.current_row = -1
        self.current_col = -1
        self.index_abfrage = -1
        self.combo_box = None
        self.double_click_row_list = []
        self.double_click_col_list = []
        self.double_click_text_list = []
        self.flag_changed_by_double_click = False
        self.flag_make_tab_gui = False
        self.data_change_irow_icol_liste = []
        self.data_change_flag = False
        self.flag_mainloop = False
        # ddict_inp["header_liste"] = header_liste
        # ---------------------------------------------------------------

        # Benutzung tvar: ttable
        key = "ttable"
        if key in ddict_inp.keys():
            ttable = ddict_inp[key]
            if not htvar.is_table(ttable):
                self.status = hdef.NOT_OKAY
                self.errtext = f" ddict_inp[{key}] = {ddict_inp[key]}\" is not a ttable from htvar"
                return
            # end if
            self.use_ttable   = True
            self.header_liste = htvar.get_names(ttable)
            self.nheader      = ttable.n
            self.data_set     = htvar.get_table(ttable)
            self.ndata        = ttable.ntable
            self.ttable_type_liste   = htvar.get_types(ttable)
        # ursprüngliche Zuordnung
        else:
            self.use_ttable = False

            key = "header_liste"
            if key not in ddict_inp.keys():
                self.status = hdef.NOT_OKAY
                self.errtext = f"\"{key}\" is not in input dictionary"
                return
            elif not isinstance(ddict_inp[key], list):
                self.status = hdef.NOT_OKAY
                self.errtext = f" ddict_inp[{key}] = {ddict_inp[key]}\" is not a list"
                return
            # endif
            self.header_liste = ddict_inp[key]
            self.nheader = len(self.header_liste)

            # ddict_inp["data_set_lliste"]
            # ---------------------------------------------------------------
            key = "data_set_lliste"
            if key not in ddict_inp.keys():
                self.status = hdef.NOT_OKAY
                self.errtext = f"\"{key}\" is not in input dictionary"
                return
            elif not isinstance(ddict_inp[key], list):
                self.status = hdef.NOT_OKAY
                self.errtext = f" ddict_inp[{key}] = {ddict_inp[key]}\" is not a list"
                return
            # endif

            self.ndata = len(ddict_inp[key])
            self.data_set = []
            for data in ddict_inp[key]:
                if len(data) > self.nheader:
                    data = data[0:self.nheader]
                elif len(data) < self.nheader:
                    for i in range(len(data), self.nheader):
                        data.append('')
                    # end for
                # end if
                self.data_set.append(data)
            # end for
        # end if

        # ddict_inp["title"]
        # ---------------------------------------------------------------
        key = "title"
        if (key not in ddict_inp.keys()) or (not isinstance(ddict_inp[key], str)):
            self.title = u"Tabelle"
        else:
            self.title = ddict_inp[key]
        # end if

        # ddict_inp["row_col_color_cell_dict_liste"] = [{'row':i,'col':j,'fg':'black','bg':'red'},{'row':i,'col':j,'fg':'','bg':'red'},...]
        key = "row_col_color_cell_dict_liste"
        if (key not in ddict_inp.keys()) or (not isinstance(ddict_inp[key], list)):
            row_col_color_cell_dict_liste = []
        else:
            row_col_color_cell_dict_liste = ddict_inp[key]
        # end if
        self.row_col_color_cell_dict_liste = []
        for ddict in row_col_color_cell_dict_liste:

            if ("row" in ddict.keys()) and ("col" in ddict.keys()):

                if "fg" not in ddict.keys():
                    ddict["fg"] = ""
                # end if

                if "bg" not in ddict.keys():
                    ddict["bg"] = ""
                # end if

                self.row_col_color_cell_dict_liste.append(ddict)
            # end if
        # end for

        # ddict_inp["row_color_dliste"]
        # ---------------------------------------------------------------
        key = "row_color_dliste"
        if (key not in ddict_inp.keys()) or (not isinstance(ddict_inp[key], list)):
            self.row_color_list = ['' for i in range(self.ndata)]
        else:
            self.row_color_list = ddict_inp[key]
        # end if

        if len(self.row_color_list) < self.ndata:
            for i in range(len(self.row_color_list), self.ndata):
                self.row_color_list.append('')
            # end ofr
        elif len(self.row_color_list) > self.ndata:
            self.row_color_list = self.row_color_list[0:self.ndata]
        # end if

        # self.row_color_list  in self.row_col_color_cell_dict_liste überführen
        irow_jcol_lliste = []
        for ddict in self.row_col_color_cell_dict_liste:
            item =(ddict["row"],ddict["col"])
            irow_jcol_lliste.append(item)
        # end for

        for irow,row_color in enumerate(self.row_color_list):
            if (len(row_color) > 0) and (irow < self.ndata):
                for jcol in range(self.nheader):
                    item = (irow,jcol)
                    if item in irow_jcol_lliste:
                        index = irow_jcol_lliste.index(item)
                        self.row_col_color_cell_dict_liste[index]['bg'] = row_color
                    else:
                        ddict = {"row":irow,"col":jcol,"fg":"","bg":row_color}
                        self.row_col_color_cell_dict_liste.append(ddict)
                    # end if
                # end for
            # end if
        # end for

        # ddict_inp["abfrage_liste"] = ["okay","cancel","end","edit",...]
        # ---------------------------------------------------------------
        key = "abfrage_liste"
        if (key not in ddict_inp.keys()) or (not isinstance(ddict_inp[key], list)):
            self.abfrage_liste = ['okay']
        else:
            self.abfrage_liste = ddict_inp[key]
        # end if

        # ddict_inp["auswahl_dat_filter"]
        # ddict_inp["default_dat_filter"]
        self.auswahl_dat_filter = ""
        self.icol_dat_filter = -1
        if "auswahl_dat_filter" in ddict_inp.keys():
            item = ddict_inp["auswahl_dat_filter"]
            if isinstance(item, str):

                self.auswahl_dat_filter = item
                if item in self.header_liste:
                    self.icol_dat_filter = self.header_liste.index(item)

            elif isinstance(item, int):
                self.auswahl_dat_filter = self.header_liste[item]
                self.icol_dat_filter = item
            elif isinstance(item, float):
                self.auswahl_dat_filter = self.header_liste[int(item)]
                self.icol_dat_filter = int(item)
            # end if
        # end if

        self.default_dat_filter = ""
        if "default_dat_filter" in ddict_inp.keys():
            self.default_dat_filter = ddict_inp["default_dat_filter"]

        # ddict_inp["auswahl_filter_col_liste"] = ["headername1", "headername3"] oder [0, 2]
        # ---------------------------------------------------------------
        self.auswahl_filter_liste = []
        self.combo_input_liste = []
        key = "auswahl_filter_col_liste"
        if (key in ddict_inp.keys()) and (isinstance(ddict_inp[key], list)):
            self.auswahl_filter_liste = []
            self.combo_input_liste = []
            for item in ddict_inp[key]:

                if isinstance(item ,str):
                    try:
                        index = self.header_liste.index(item)
                        self.auswahl_filter_liste.append(index)
                        self.combo_input_liste.append(item)
                    except:
                        pass
                elif isinstance(item, int):
                    if item < self.nheader:
                        self.auswahl_filter_liste.append(item)
                        self.combo_input_liste.append(str(item))
                    # end if
                elif isinstance(item, float):
                    if item < self.nheader:
                        self.auswahl_filter_liste.append(int(item))
                        self.combo_input_liste.append(str(item))
                    # end if
                # end if
            # end for
        # end if

        # ddict_inp["GUI_GEOMETRY_WIDTH"] = 1000
        # ---------------------------------------------------------------
        key = "GUI_GEOMETRY_WIDTH"
        if key not in ddict_inp.keys() or (not isinstance(ddict_inp[key], int)):
            self.GUI_GEOMETRY_WIDTH = sdef.GUI_GEOMETRY_WIDTH_BASE
        else:
            self.GUI_GEOMETRY_WIDTH = ddict_inp[key]
        # end if

        # ddict_inp["GUI_GEOMETRY_HEIGHT"] = 600
        # ---------------------------------------------------------------
        key = "GUI_GEOMETRY_HEIGHT"
        if key not in ddict_inp.keys() or (not isinstance(ddict_inp[key], int)):
            self.GUI_GEOMETRY_HEIGHT = sdef.GUI_GEOMETRY_HEIGHT_BASE
        else:
            self.GUI_GEOMETRY_HEIGHT = ddict_inp[key]
        # end if

        # ddict_inp["GUI_GEOMETRY_POSX"] = 0
        # ---------------------------------------------------------------
        key = "GUI_GEOMETRY_POSX"
        if key not in ddict_inp.keys() or (not isinstance(ddict_inp[key], int)):
            self.GUI_GEOMETRY_POSX = 0
        else:
            self.GUI_GEOMETRY_POSX = ddict_inp[key]
        # end if

        # ddict_inp["GUI_GEOMETRY_POSY"] = 0
        # ---------------------------------------------------------------
        key = "GUI_GEOMETRY_POSY"
        if key not in ddict_inp.keys() or (not isinstance(ddict_inp[key], int)):
            self.GUI_GEOMETRY_POSY = 0
        else:
            self.GUI_GEOMETRY_POSY = ddict_inp[key]
        # end if

        # ddict_inp["GUI_ICON_FILE"]
        # ---------------------------------------------------------------
        key = "GUI_ICON_FILE"
        if key not in ddict_inp.keys() or (not isinstance(ddict_inp[key], str)):
            self.GUI_ICON_FILE = sdef.GUI_ICON_FILE_BASE
        else:
            self.GUI_ICON_FILE = ddict_inp[key]
        # end if

        # ddict_inp["GUI_TITLE"]
        # ---------------------------------------------------------------
        key = "GUI_TITLE"
        if (key not in ddict_inp.keys()) or (not isinstance(ddict_inp[key], str)):
            self.GUI_TITLE = "Tabelle"
        else:
            self.GUI_TITLE = ddict_inp[key]
        # end if

        # ---------------------------------------------------------------
        # ---------------------------------------------------------------
        # ---------------------------------------------------------------
        # self.index_liste
        # ---------------------------------------------------------------
        self.index_liste = [i for i in range(self.ndata)]

        # make a copy for hold values
        self.index_liste_hold = self.index_liste
        self.data_set_hold = self.data_set
        self.ndata_hold = self.ndata

        # self.type_liste
        # ---------------------------------------------------------------
        # proof first data set for type
        if len(self.data_set) > 0:
            data = self.data_set[0]
            self.type_liste = []
            for item in data:
                if (isinstance(item, float)):
                    self.type_liste.append(self.DATA_FLOAT)
                elif (isinstance(item, int)):
                    self.type_liste.append(self.DATA_INTEGER)
                else:
                    self.type_liste.append(self.DATA_STRING)
                # endif
            # endfor
        else:
            self.type_liste = [self.DATA_STRING for item in self.header_liste]
        # endif

        # ---------------------------------------------------------------
        # ---------------------------------------------------------------
        # ---------------------------------------------------------------
        # TK-Grafik anlegen
        # ------------------
        self.root = Tk.Tk()
        self.root.protocol("WM_DELETE_WINDOW", self.exitMenu)
        self.root.wm_geometry(
            "%dx%d+%d+%d" % (self.GUI_GEOMETRY_WIDTH, self.GUI_GEOMETRY_HEIGHT, self.GUI_GEOMETRY_POSX,
                             self.GUI_GEOMETRY_POSY))

        if (os.path.isfile(self.GUI_ICON_FILE)):
            self.root.wm_iconbitmap(self.GUI_ICON_FILE)
        self.root.title(self.GUI_TITLE)

        # Gui anlegen
        # --------------
        self.createButtonGui()

        if (len(self.default_dat_filter) > 0) or (len(self.combo_input_liste) > 0):
            self.FilterFrame = Tk.Frame(self.root)
            self.FilterFrame.pack(padx=10,pady=10)

            if len(self.default_dat_filter) > 0:
                self.createFilterDat()
            if len(self.combo_input_liste) > 0:
                self.createFilter()

        self.createSheetGui()

        self.addDataSheetGui()



        if len(self.default_dat_filter) > 0:
            self.runFilter()

        # Menue anlegen
        # --------------
        # self.createMenu()
        # self.makeTabGui()
        # self.autofitTabGui()
        self.flag_mainloop = True

        self.root.mainloop()

    def __del__(self):
        if (self.flag_mainloop):
            self.GUI_GEOMETRY_HEIGHT = self.root.winfo_height()
            self.GUI_GEOMETRY_WIDTH = self.root.winfo_width()
            self.GUI_GEOMETRY_POSX = self.root.winfo_x()
            self.GUI_GEOMETRY_POSY = self.root.winfo_y()
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
            self.GUI_GEOMETRY_POSX = self.root.winfo_x()
            self.GUI_GEOMETRY_POSY = self.root.winfo_y()
            self.root.destroy()
            self.flag_mainloop = False

    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    # def createFrame(self):
    #     self.frame = Tk.LabelFrame(self.root, bd=2, text=self.title, font=('Verdana', 10, 'bold'))
    #     gr_entry = Tk.Frame(self.frame, relief=Tk.GROOVE, bd=2)
    #     gr_entry.pack(pady=5)

    def createFilterDat(self):

        # gr_entry = Tk.Frame(self.root, relief=Tk.GROOVE, bd=2)
        # gr_entry.pack(fill=Tk.X, pady=5)

        # label links oben mit text Filter
        label_a = Tk.Label(self.FilterFrame, text=f"DatFilter: {self.auswahl_dat_filter}", font=('Verdana', 10, 'bold'))
        label_a.pack(side=Tk.LEFT, pady=1, padx=1)

        # entry StringVar fuer die Eingabe
        self.StringVarDatFiltText = Tk.StringVar()
        self.StringVarDatFiltText.set(self.default_dat_filter)
        self.StringVarDatFiltText.trace("w", self.runFilter)

        # entry Aufruf
        entry_a = Tk.Entry(self.FilterFrame, width=(100), textvariable=self.StringVarDatFiltText)
        entry_a.pack(side=Tk.LEFT, pady=1, padx=1)

    def createFilter(self):

        # gr_entry = Tk.Frame(self.root, relief=Tk.GROOVE, bd=2)
        # gr_entry.pack(fill=Tk.X, pady=5)

        self.combo_box = ttk.Combobox(self.FilterFrame, state="readonly")
        self.combo_box['values'] = self.combo_input_liste
        self.combo_box.current(0)
        self.combo_box.pack(side=Tk.LEFT, pady=1, padx=1)

        # label links oben mit text Filter
        label_a = Tk.Label(self.FilterFrame, text='Filter:', font=('Verdana', 10, 'bold'))
        label_a.pack(side=Tk.LEFT, pady=1, padx=1)

        # entry StringVar fuer die Eingabe
        self.StringVarFiltText = Tk.StringVar()
        self.StringVarFiltText.set("")
        self.StringVarFiltText.trace("w", self.runFilter)

        # entry Aufruf
        entry_a = Tk.Entry(self.FilterFrame, width=(100), textvariable=self.StringVarFiltText)
        entry_a.pack(side=Tk.LEFT, pady=1, padx=1)

    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    def createSheetGui(self):
        ''' Gui für Tabelle
        '''

        self.tabGui_Frame = Tk.Frame(self.root)
        self.tabGui_Frame.pack(expand=1, fill=Tk.BOTH)


        # heading
        # ----------------------------------------------------------------
        self.tabGui_SheetBox = Sheet(self.tabGui_Frame,
                                     data= [[]],
                                     headers=self.header_liste)  # , show="headings"



        # self.tabGui_SheetBox.bind("<Double-1>", self.SelectOnDoubleClick)
        # self.tabGui_SheetBox.bind('<ButtonRelease-1>', self.selectItem)

        self.tabGui_SheetBox.pack(fill=Tk.BOTH, expand=1)

        self.tabGui_SheetBox.enable_bindings("single_select",  # "single_select" or "toggle_select"
                                            "drag_select",  # enables shift click selection as well
                                            "column_drag_and_drop",
                                            "row_drag_and_drop",
                                            "column_select",
                                            "row_select",
                                            "column_width_resize",
                                            "double_click_column_resize",
                                            # "row_width_resize",
                                            # "column_height_resize",
                                            "arrowkeys",
                                            "row_height_resize",
                                            "double_click_row_resize",
                                            "right_click_popup_menu",
                                            "rc_select",
                                            "rc_insert_column",
                                            "rc_delete_column",
                                            "rc_insert_row",
                                            "rc_delete_row",
                                            "copy",
                                            "cut",
                                            "paste",
                                            "delete",
                                            "undo",
                                            "edit_cell")

        self.tabGui_SheetBox.extra_bindings("cell_select", self.zeile_geklickt)

    # end def
    def addDataSheetGui(self):


        self.tabGui_SheetBox.total_rows(len(self.index_liste))

        for i, data in enumerate(self.data_set):
            # index = max(0,i-1)
            self.tabGui_SheetBox.set_row_data(r=i,values=data)
            self.flag_make_tab_gui = True
       # endfor



        self.tabGui_SheetBox.set_index_data(self.index_liste)


    def createButtonGui(self):
        self.Button_Frame = Tk.Frame(self.root, relief=Tk.GROOVE, bd=2)
        self.Button_Frame.pack(fill=Tk.X, pady=5)

        self.Button_Liste = []
        for name in self.abfrage_liste:
            b_back = Tk.Button(self.Button_Frame, text=name,
                               command=lambda m=name: self.Button_Fkt(m))  # lambda m=method: self.populateMethod(m))
            b_back.pack(side=Tk.LEFT, pady=4, padx=2)
            self.Button_Liste.append(b_back)
        # endfor

    # end def
    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    # def makeTabGui(self):
    #     ''' list-Gui f llen
    #     '''
    #
    #     # delete tabbox
    #     # n = self.    tabGui_TabBox.size()
    #     # if( n > 0 ): self.    tabGui_TabBox.delete(0, n)
    #
    #     self.tabGui_TabBox.pack(expand=1, fill=Tk.BOTH)
    #
    #     if self.flag_make_tab_gui:
    #         for i in self.tabGui_TabBox.get_children():
    #             self.tabGui_TabBox.delete(i)
    #         # end for
    #         self.flag_make_tab_gui = False
    #     # end if
    #
    #     # Gruppenname aktualisieren
    #     # self.select    tabGui()
    #     # fill listbox
    #     # Insert sample data into the Treeview
    #     if (len(self.index_liste) == self.ndata):
    #         for i, data in enumerate(self.data_set):
    #             index = self.index_liste[i]
    #             self.tabGui_TabBox.insert(parent="", index="end", iid=self.index_liste[i], text=index,
    #                                       values=data, tags=(f"{index}",))
    #             self.flag_make_tab_gui = True
    #         # endfor
    #     else:
    #         for i, data in enumerate(self.data_set):
    #             self.tabGui_TabBox.insert("", "end", values=data, tags=(f"{i}",))
    #             self.flag_make_tab_gui = True
    #         # endfor
    #     # endif
    #
    #     self.frame.pack(expand=1, fill=Tk.BOTH)
    #     return
    #
    # # end def
    # def autofitTabGui(self):
    #
    #     f = tkfont.nametofont("TkDefaultFont")
    #
    #     for col in self.tabGui_TabBox["columns"]:
    #         max_width = f.measure(self.tabGui_TabBox.heading(col)["text"])
    #
    #         for item in self.tabGui_TabBox.get_children():
    #             text = str(self.tabGui_TabBox.set(item, col))
    #             max_width = max(max_width, f.measure(text))
    #         # end for
    #         self.tabGui_TabBox.column(col, width=max_width + 20)
    #     # end for
    #     return
    #
    # # end def
    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    def zeile_geklickt(self, a):

        currently_selected = self.tabGui_SheetBox.get_currently_selected()
        if currently_selected:
            self.current_row = currently_selected.row
            self.current_col = currently_selected.column

    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    def Button_Fkt(self, button_name=None):
        ''' eine Gruppe ausw hlen  ber selection, wenn nicht dann weiter
            aktuellen Namen verwenden
            Ergebnis wird in self.actual_group_name gespeichert
            R ckgabewert:
            Wenn self.actual_group_name belegt ist, dann True
            ansonasten False
        '''

        # index Zuweisung nach Button
        icount = 0
        self.index_abfrage = -1
        for name in self.abfrage_liste:
            if button_name is None:
                self.index_abfrage = 0
                break
            elif name == button_name:
                self.index_abfrage = icount
                break
            icount += 1
            # endif
        # endfor

        # read data set
        self.data_set = []
        for irow in range(len(self.index_liste)):
            index = self.index_liste[irow]
            data_hold = self.data_set_hold[index]
            line =  self.tabGui_SheetBox.get_row_data(irow)
            data = []
            for i, value in enumerate(line):
                if self.use_ttable:  # use of ttable with types
                    (okay, val) = htype.type_proof(value, self.ttable_type_liste[i])
                    if okay == hdef.OKAY:
                        data.append(val)
                    else:  # alter Wert
                        data.append(data_hold[i])
                    # end if
                else:
                    if (self.type_liste[i] == self.DATA_INTEGER):
                        (okay, val) = htype.type_proof(value, 'int')
                        if okay == hdef.OKAY:
                            data.append(val)
                        else:  # zeigt dann Fehler an
                            data.append(int(value))
                    elif (self.type_liste[i] == self.DATA_FLOAT):
                        (okay, val) = htype.type_proof(value, 'float')
                        if okay == hdef.OKAY:
                            data.append(val)
                        else:  # zeigt dann Fehler an
                            data.append(float(value))
                    else:
                        data.append(str(value))
                    # endif
                # end if
                # endfor
            self.data_set.append(data)
        # endfor
        for irow, index in enumerate(self.index_liste):
            data_hold = self.data_set_hold[index]
            data = self.data_set[irow]
            for jcol, d in enumerate(data):
                if (data_hold[jcol] != d):
                    try:
                        if self.use_ttable:
                            self.data_set_hold[index][jcol] = d  # Weil es oben schon gewandelt wurde  !
                        else:
                            if (self.type_liste[jcol] == self.DATA_INTEGER):
                                self.data_set_hold[index][jcol] = int(d)
                            elif (self.type_liste[j] == self.DATA_FLOAT):
                                self.data_set_hold[index][jcol] = float(d)
                            else:
                                self.data_set_hold[index][jcol] = str(d)
                            # endif
                            # self.data_set_hold[index][jcol] = d
                        # end if

                        self.data_change_irow_icol_liste.append((index, jcol))
                        self.data_change_flag = True
                    except:
                        pass
                # end if
            # end for
        # end for
        self.data_set = self.data_set_hold
        self.index_liste = self.index_liste_hold
        self.ndata = self.ndata_hold

        self.exitMenu()
    # end def
    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    def runFilter(self, *dummy):

        # 1. DatFilter
        # -------------

        if self.icol_dat_filter >= 0:

            tt = self.StringVarDatFiltText.get()
            valliste = tt.split(';')

            if (len(valliste) == 1) and len(valliste[0]) == 0:

                self.index_liste_dat = self.index_liste_hold
                self.data_set_dat = self.data_set_hold
                self.ndata_dat = len(self.data_set_dat)
            else:

                type = self.type_liste[self.icol_dat_filter]
                cliste = hlist.get_clist_from_llist(self.data_set_hold, self.icol_dat_filter)

                iliste = []
                exceptflag = False
                for tval in valliste:
                    try:
                        diliste = []
                        if type == self.DATA_STRING:

                            if len(tval) > 0:
                                diliste = hlist.such_in_liste(cliste, tval, regel="n")
                            # end if

                        elif type == self.DATA_FLOAT:
                            fval = float(tval)
                            if fval in cliste:
                                diliste = hlist.such_in_liste(cliste, fval, regel="e")
                            # end if
                        else:  # if type == self.DATA_FLOAT:
                            ival = int(tval)
                            if ival in cliste:
                                diliste = hlist.such_in_liste(cliste, ival, regel="e")
                            # end if
                        # end if
                        iliste += diliste
                    except:
                        exceptflag = True
                        break
                    # end try
                # end for
                iliste = sorted(list(set(iliste)))

                if exceptflag or (len(iliste) == 0):
                    self.index_liste_dat = self.index_liste_hold
                    self.data_set_dat = self.data_set_hold
                    self.ndata_dat = len(self.data_set_dat)
                else:

                    self.index_liste_dat = hlist.get_condensed_list_by_index_list(self.index_liste_hold, iliste)
                    self.data_set_dat = hlist.get_condensed_list_by_index_list(self.data_set_hold, iliste)
                    self.ndata_dat = len(self.data_set_dat)
                    # end if
            # end if
        else:
            self.index_liste_dat = self.index_liste_hold
            self.data_set_dat = self.data_set_hold
            self.ndata_dat = len(self.data_set_dat)
        # end if

        # 2. Filter
        # ----------

        tt = self.StringVarFiltText.get()
        valliste = tt.split(';')

        if (len(valliste) == 1) and len(valliste[0]) == 0:

            self.index_liste = self.index_liste_dat
            self.data_set = self.data_set_dat
            self.ndata = len(self.data_set)
        else:

            header = self.combo_box.get()
            # print(f"tt={tt} hedaer={header}")

            if header not in self.header_liste:
                return
            # end if

            icol = self.header_liste.index(header)
            cliste = hlist.get_clist_from_llist(self.data_set_dat, icol)
            # cliste = list(set(cliste))

            type = self.type_liste[icol]

            iliste = []
            for tval in valliste:

                try:
                    diliste = []
                    if type == self.DATA_STRING:

                        if tval[0] == '!':  # Erkennung, dass nur der folgende str (wenn größer 0)
                            # als Teil gefunden werden muss
                            ttval = tval[1:]

                            if len(ttval) > 0:
                                diliste = hlist.such_in_liste(cliste, ttval, regel="n")
                            # end if
                        else:
                            if tval in cliste:
                                diliste = hlist.such_in_liste(cliste, tval, regel="e")
                            # end if
                        # end if
                    elif type == self.DATA_FLOAT:
                        fval = float(tval)
                        if fval in cliste:
                            diliste = hlist.such_in_liste(cliste, fval, regel="e")
                        # end if
                    else:  # if type == self.DATA_FLOAT:
                        ival = int(tval)
                        if ival in cliste:
                            diliste = hlist.such_in_liste(cliste, ival, regel="e")
                        # end if
                    # end if
                    iliste += diliste
                except:
                    return
                # end try
            # end for
            iliste = sorted(list(set(iliste)))

            if len(iliste) == 0:
                return
            # end if

            self.index_liste = hlist.get_condensed_list_by_index_list(self.index_liste_dat, iliste)
            self.data_set = hlist.get_condensed_list_by_index_list(self.data_set_dat, iliste)
            self.ndata = len(self.data_set)
        # end if

        self.addDataSheetGui()

    # end def
    def SelectOnDoubleClick(self, event):
        '''Executed, when a row is double-clicked'''
        # close previous popups
        try:  # in case there was no previous popup
            self.entryPopup.destroy()
        except AttributeError:
            pass

        # what row and column was clicked on
        rowid = self.tabGui_TabBox.identify_row(event.y)
        column = self.tabGui_TabBox.identify_column(event.x)

        # return if the header was double clicked
        if not rowid:
            return

        # get cell position and cell dimensions
        x, y, width, height = self.tabGui_TabBox.bbox(rowid, column)
        # print(x, y, width, height)

        # y-axis offset
        pady = height // 2

        # place Entry Widget
        text = self.tabGui_TabBox.item(rowid, 'values')[int(column[1:]) - 1]

        # save text
        (status, columnid) = htype.type_proof(column, 'int')
        if columnid:
            columnid -= 1
        # end if
        if status == hdef.OKAY:
            self.double_click_row_list.append(int(rowid))
            self.double_click_col_list.append(columnid)
            self.double_click_text_list.append(text)
            self.flag_changed_by_double_click = True
        # end if

        self.entryPopup = EntryPopup(self.root, self.tabGui_TabBox, rowid, int(column[1:]) - 1, text)
        self.entryPopup.place(x=x, y=y + pady, width=width, height=height, anchor='w')

        # if self.flag_changed_by_double_click: self.selectTabGui()



# end class
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


