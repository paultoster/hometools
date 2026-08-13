
# ===============================================================================
# ========================== plot =====================================
#
# ddict_out = plot_mit_radiobuttons(ddict_inp)
#
# Erstelt mit matplotlib eib Plot mit zusätzlichen Radiobutton-abfragen
#
# ddict_inp["title"] = "title"
# ddict_inp["auswahl_liste"] = ["entscheidung1","entscheidung2",...]
# ddict_inp["index_default_auswahl"] = 1
#
# ddict_inp["plot_x_np_array"] = x-array
# ddict_inp["plot_y_np_array"] = y-array
# ddict_inp["plot_x_is_date"] = 1/0
# ddict_inp["plot_x_name"] = "namea"
# ddict_inp["plot_y_name"] = "nameb"
#
# ddict_inp["plo_title"] = "plot_title"
# ddict_inp["plo_x_label"] = "namex"
# ddict_inp["plot_y_label"] = "namey"
# ddict_inp["plot_legend"] = 1/0
#
# Ouput:
#
# return ddict_out
# mit
# ddict_out["index"]                        selected index von asuwahl_liste
# ddict_out["status"]                       status
# ddict_out["errtext"]                      errtext
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

import numpy as np
import matplotlib as mpl

from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg

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
        self.status = hdef.OKAY
        self.errtext = ""
        self.auswahl_liste = []
        self.index = -1
        # ddict_inp["header_liste"] = header_liste
        # ---------------------------------------------------------------

        # ddict_inp["title"] = "title"
        # ---------------------------------------------------------------
        key = "title"
        if (key not in ddict_inp.keys()) or (not isinstance(ddict_inp[key], str)):
            self.title = u"Plot"
        else:
            self.title = ddict_inp[key]
        # end if

        # ddict_inp["auswahl_liste"] = ["entscheidung1","entscheidung2",...]
        # ---------------------------------------------------------------
        key = "auswahl_liste"
        if (key not in ddict_inp.keys()) or (not isinstance(ddict_inp[key], list)):
            self.auswahl_liste = []
        else:
            self.auswahl_liste = ddict_inp[key]
        # end if

        self.auswahl_title = "Bitte auswählen"


        # ddict_inp["index_default_auswahl"] = 1
        key = "index_default_auswahl"
        if (key not in ddict_inp.keys()) or (not isinstance(ddict_inp[key], int)):
            self.index_default_auswahl = 0
        else:
            self.index_default_auswahl = ddict_inp[key]

        #
        # ddict_inp["plot_x_np_array"] = x-array
        key = "plot_x_np_array"
        if (key not in ddict_inp.keys()):
            self.plot_x_np_array = None
        else:
            self.plot_x_np_array = ddict_inp[key]
        # end if

        if isinstance(self.plot_x_np_array,list):
            self.plot_x_np_array = np.array(self.plot_x_np_array)
        # end if

        # ddict_inp["plot_y_np_array"] = y-array
        key = "plot_y_np_array"
        if (key not in ddict_inp.keys()):
            self.plot_y_np_array = None
        else:
            self.plot_y_np_array = ddict_inp[key]
        # end if

        if isinstance(self.plot_y_np_array, list):
            self.plot_y_np_array = np.array(self.plot_y_np_array)
        # end if

        # ddict_inp["plot_x_is_date"] = 1/0
        key = "plot_x_is_date"
        if (key not in ddict_inp.keys()) or (not isinstance(ddict_inp[key], int)):
            self.plot_x_is_date = 0
        else:
            self.plot_x_is_date = ddict_inp[key]

        # ddict_inp["plot_x_name"] = "namea"
        key = "plot_x_name"
        if (key not in ddict_inp.keys()) or (not isinstance(ddict_inp[key], str)):
            self.plot_x_name = u"x-werte"
        else:
            self.plot_x_name = ddict_inp[key]
        # end if

        # ddict_inp["plot_y_name"] = "nameb"
        key = "plot_y_name"
        if (key not in ddict_inp.keys()) or (not isinstance(ddict_inp[key], str)):
            self.plot_y_name = u"y-werte"
        else:
            self.plot_y_name = ddict_inp[key]
        # end if
        #
        # ddict_inp["plo_title"] = "plot_title"
        key = "plot_title"
        if (key not in ddict_inp.keys()) or (not isinstance(ddict_inp[key], str)):
            self.plot_title = u""
        else:
            self.plot_title = ddict_inp[key]
        # end if

        # ddict_inp["plo_x_label"] = "namex"
        key = "plo_x_label"
        if (key not in ddict_inp.keys()) or (not isinstance(ddict_inp[key], str)):
            self.plo_x_label = u""
        else:
            self.plo_x_label = ddict_inp[key]
        # end if

        # ddict_inp["plot_y_label"] = "namey"
        key = "plo_y_label"
        if (key not in ddict_inp.keys()) or (not isinstance(ddict_inp[key], str)):
            self.plo_y_label = u""
        else:
            self.plo_y_label = ddict_inp[key]
        # end if

        # ddict_inp["plot_legend"] = 1/0
        key = "plot_legend"
        if (key not in ddict_inp.keys()) or (not isinstance(ddict_inp[key], int)):
            self.plot_legend = 0
        else:
            self.plot_legend = ddict_inp[key]
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
        if len(self.auswahl_liste):
            self.createRadioButtonGui()

        self.createPlotGui()

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

    def createRadioButtonGui(self):

        self.RadioButton_Frame = Tk.Frame(self.root, relief=Tk.GROOVE, bd=2)
        self.RadioButton_Frame.pack(fill=Tk.X, pady=5)

        self.RadioButton_Auswahl = Tk.StringVar(value="")

        self.RadioButton_Label = Tk.Label(self.RadioButton_Frame, text=f"{self.auswahl_title}:")
        self.RadioButton_Label.pack(padx=10, pady=10)

        self.RadioButton_Liste = []
        for i,name in enumerate(self.auswahl_liste):
            b_back = Tk.Radiobutton(self.RadioButton_Frame,
                                    text = str(name),
                                    variable = self.RadioButton_Auswahl,
                                    value = i)
            b_back.pack(padx=5, pady=5)
            # b_back.pack(side=Tk.LEFT, pady=4, padx=2)
            self.RadioButton_Liste.append(b_back)
        # endfor

        self.RadioButton_Auswahl.set(self.index_default_auswahl)

        self.RadioButton_Button = Tk.Button(self.RadioButton_Frame, text="OK", command=self.exitMenu)
        self.RadioButton_Button.pack(pady=10)

    # end def
    def createPlotGui(self):
        ''' Gui für Tabelle
        '''

        self.PlotGui_Frame = Tk.Frame(self.root)
        self.PlotGui_Frame.pack(expand=1, fill=Tk.BOTH)

        # Matplotlib-Figur erzeugen
        fig = mpl.figure(figsize=(5, 4), dpi=100)
        ax = fig.add_subplot(111)

        if self.plot_x_is_date > 0:
            ax.xaxis.set_major_formatter(mpl.figure.dates.DateFormatter('%d.%m.%Y'))
            ax.xaxis.set_major_locator(mpl.dates.MonthLocator())
        # end if

        ax.plot(self.plot_x_np_array, self.plot_y_np_array)

        if len(self.plot_title):
            ax.set_title(self.plot_title)
        if len(self.plot_x_name):
            ax.set_xlabel(self.plot_x_name)
        if len(self.plot_y_name):
            ax.set_ylabel(self.plot_y_name)

        self.PlotGui_Canvas = FigureCanvasTkAgg(fig, master=self.PlotGui_Frame)
        self.PlotGui_Canvas.draw()
        self.PlotGui_Canvas.get_tk_widget().pack(side=Tk.TOP, fill=Tk.BOTH, expand=True)

    # end def
    def exitMenu(self):
        ''' Beenden der Gui
        '''
        # Vor Beenden Speichern abfragen
        # ans = tkinter.messagebox.askyesno(parent=self.root,title='Sichern', message='Soll Datenbasis gesichert werden')
        # if( ans ): self.base.save_db_file()

        if len(self.auswahl_liste):
            self.index = self.RadioButton_Auswahl.get()

        if (self.flag_mainloop):
            self.GUI_GEOMETRY_HEIGHT = self.root.winfo_height()
            self.GUI_GEOMETRY_WIDTH = self.root.winfo_width()
            self.GUI_GEOMETRY_POSX = self.root.winfo_x()
            self.GUI_GEOMETRY_POSY = self.root.winfo_y()
            self.root.destroy()
            self.flag_mainloop = False

    # end def
# end class