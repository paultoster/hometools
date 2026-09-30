
import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

# Hilfsfunktionen
import tools.sgui as sgui

import tools.hfkt_tvar as htvar
import tools.hfkt_type as htype
import tools.hfkt_def as hdef

STATUS   = hdef.OKAY
ERRTEXT  = ""
INFOTEXT = ""


def get_status():
    global STATUS
    return STATUS
def get_errtext():
    global ERRTEXT
    return ERRTEXT
def get_infotext():
    global INFOTEXT
    return INFOTEXT
def reset_status():
    global STATUS
    global ERRTEXT
    global INFOTEXT
    STATUS = hdef.OKAY
    ERRTEXT = ""
    INFOTEXT = ""
# end def


def janein_abfrage(gui, ausgabe_text, ausgabe_title):
    flag = gui.abfrage_janein(text=ausgabe_text, title=ausgabe_title)
    return flag


# end def
def listen_abfrage(gui, auswahl_liste, auswahl_title, abfrage_liste=None):
    if abfrage_liste == None:
        index = gui.abfrage_liste_index(auswahl_liste, auswahl_title)
        indexAbfrage = 0
    else:
        [index, indexAbfrage] = gui.abfrage_liste_index_abfrage_index(auswahl_liste, abfrage_liste, auswahl_title)
    # end if
    return (index, indexAbfrage)
# enddef
def anzeige_text(gui,texteingabe, title=None,textcolor='black'):
    gui.anzeige_text(texteingabe, title=title, textcolor=textcolor,textfont="Consolas")
    return
# end def
def listen_abfrage(gui, auswahl_liste, auswahl_title, abfrage_liste=None):
    if abfrage_liste == None:
        index = gui.abfrage_liste_index(auswahl_liste, auswahl_title)
        indexAbfrage = 0
    else:
        [index, indexAbfrage] = gui.abfrage_liste_index_abfrage_index(auswahl_liste, abfrage_liste, auswahl_title)
    # end if
    return (index, indexAbfrage)
# enddef
def katalog_liste_edit_abfrage(gui, katalog_liste):
    '''

    :param gui:
    :param katalog_liste:
    :return: reg_list_mod = konto_regel_edit_abfrage(gui, reg_list)
    '''
    title = "Katalog-Liste editieren"
    katalog_liste_mod = gui.modify_variable(katalog_liste, title)

    return katalog_liste
# end def
def eingabe_n_zeilen(gui, liste_abfrage,
                          liste_vorgabe=None, title=None):
    '''


    :param liste_abfrage:
    :param liste_vorgabe:
    :oaram title
    :return: (liste_ergebnis,status) = eingabe_n_zeilen(gui,liste_abfrage,liste_vorgabe,title)
    '''

    if title is None:
        title = "Eingabe"
    # end if

    ddict = {}
    ddict["liste_abfrage"] = liste_abfrage
    ddict["title"] = title
    # dict["liste_immutable"] = immutable_liste

    ddict["liste_vorgabe"] = liste_vorgabe

    new_data_list = gui.abfrage_n_eingabezeilen_dict(ddict)

    if len(new_data_list) == 0:
        return ([], hdef.NOT_OK)
    # end if

    return (new_data_list, hdef.OKAY)

# end def
def katalog_dict_table_abfrage(gui, ttable, abfrage_liste,title = None):
    """

    :param gui:
    :param ttable:
    :param abfrage_liste:
    :return:
    """
    dict_inp = {}
    dict_inp["ttable"] = ttable
    dict_inp["abfrage_liste"] = abfrage_liste
    dict_inp["auswahl_filter_col_liste"] = ttable.names
    if title:
        dict_inp["title"] = title
    # end if

    dict_out = gui.abfrage_tabelle(dict_inp)

    if dict_out["status"] != hdef.OKAY:
        STATUS = dict_out["status"]
        ERRTEXT = dict_out["errtext"]
        return
    # end if

    return ( dict_out["ttable"],
             dict_out["index_abfrage"],
             dict_out["irow_select"],
             dict_out["data_change_irow_icol_liste"])
# end def
def katalog_gruppe_isin_dict_modify(gui, katalog, isin_liste):
    '''

    :param gui:
    :param katalog:
    :param isin_liste:
    :return: isin_list_mod = katalog_isin_liste_modify(gui, katalog, isin_liste)
    '''
    title = f"Von Katalog {katalog} isin-Liste editieren"
    isin_list_mod = gui.modify_variable(isin_liste, title)

    return isin_list_mod
# end def
def sigset_dict_abfrage(gui, ddict, title = None,abfrage_liste=None):
    """

    :param gui:
    :param ddict:
    :return: (ddict,changed_key_liste) = sigset_dict_abfrage(gui, ddict, title = None)
    """

    (ddict,changed_key_liste,index_abfrage) = gui.abfrage_dict2(ddict,title=title,abfrage_liste=abfrage_liste)

    return (ddict,changed_key_liste,index_abfrage)

# end def
def sigset_dict_modify(gui, sigset, ddict):
    '''

    :param gui:
    :param katalog:
    :param isin_liste:
    :return: isin_list_mod = katalog_isin_liste_modify(gui, katalog, isin_liste)
    '''
    title = f"Von Signalset: {sigset} signal-dict editieren"
    sigset_dict_mod = gui.modify_variable(ddict, title)

    return sigset_dict_mod
# end def
def tab_dict_abfrage(gui, ddict, title = None,abfrage_liste=None):
    """

    :param gui:
    :param ddict:
    :return: (ddict,changed_key_liste) = tab_dict_abfrage(gui, ddict, title = None)
    """

    (ddict,changed_key_liste,index_abfrage) = gui.abfrage_dict2(ddict,title=title,abfrage_liste=abfrage_liste)

    return (ddict,changed_key_liste,index_abfrage)

# end def
def tab_dict_modify(gui, tab, ddict):
    '''

    :param gui:
    :param katalog:
    :param isin_liste:
    :return: isin_list_mod = katalog_isin_liste_modify(gui, katalog, isin_liste)
    '''
    title = f"Von Tabellendef: {tab} TabellenSpaltenNamen-dict editieren"
    sigset_dict_mod = gui.modify_variable(ddict, title)

    return sigset_dict_mod
# end def
def plotdef_dict_abfrage(gui, ddict, title = None,abfrage_liste=None):
    """

    :param gui:
    :param ddict:
    :return: (ddict,changed_key_liste) = tab_dict_abfrage(gui, ddict, title = None)
    """

    (ddict,changed_key_liste,index_abfrage) = gui.abfrage_dict2(ddict,title=title,abfrage_liste=abfrage_liste)

    return (ddict,changed_key_liste,index_abfrage)

# end def

def plotdef_dict_modify(gui, tab, ddict):
    '''

    :param gui:
    :param katalog:
    :param isin_liste:
    :return: isin_list_mod = katalog_isin_liste_modify(gui, katalog, isin_liste)
    '''
    title = f"Von Tabellendef: {tab} TabellenSpaltenNamen-dict editieren"
    sigset_dict_mod = gui.modify_variable(ddict, title)

    return sigset_dict_mod
# end def
def scre_dict_abfrage(gui, ddict, title = None,abfrage_liste=None):
    """

    :param gui:
    :param ddict:
    :return: (ddict,changed_key_liste) = tab_dict_abfrage(gui, ddict, title = None)
    """

    (ddict,changed_key_liste,index_abfrage) = gui.abfrage_dict2(ddict,title=title,abfrage_liste=abfrage_liste)

    return (ddict,changed_key_liste,index_abfrage)

# end
def scre_sheet_show(gui, ttable, abfrage_liste,color_dict_liste,title=None):


    dict_inp = {}
    dict_inp["ttable"] = ttable
    dict_inp["row_col_color_cell_dict_liste"] = color_dict_liste
    dict_inp["abfrage_liste"] = abfrage_liste

    if title:
        dict_inp["title"] = title
    # end if

    dict_out = gui.abfrage_sheet(dict_inp)

    if dict_out["status"] != hdef.OKAY:
        return (dict_out["status"], dict_out["errtext"], [], -1, -1)
    # end if

    return (dict_out["status"], dict_out["errtext"], dict_out["index_abfrage"], dict_out["irow_select"])
# end def
def matplot_date_data(gui, ddict):
    """
        dict_input["plot"] = ddict["rows"] = 1  (defaultwert, Anzahl der senkrechten Plots)
                         ddict["cols"] = 1  (defaultwert, Anzahl der waagrechten Plots)
                         ddict["sharex"] = False  (defaultwert, True, 'col', Für alle eine x-Achse)
                         ddict["sharey"] = False  (defaultwert, True, 'row', Für alle eine y-Achse)
                         ddict["width"] = 30 (default, Plot Breite in cm)
                         ddict["height"] = 30 (default, Plot Breite in cm)
                         ddict["hspace"] = 0.05 Anteil Zwischenraum höhe
                         ddict["wspace"] = 0.05 Anteil Zwischenraum breite
                         ddict["left"] = 0.05 in Anteilen linke Position Diagramm
                         ddict["right"] = 0.95
                         ddict["top"] = 0.9
                         ddict["bottom"] = 0.1
                         ddict["title"] = text
                         ddict["title_add_date_range"] = False (default,True)
                         ddict["subplot_list"] = [dict_subplot1, dict_subplot2, dict_subplot3] Liste von dictionaries

                         dict_subplot1["name"]   = "subplot1"  (default)
                         dict_subplot1["title"]   = "title"
                         dict_subplot1["xlabel"]   = "xname""
                         dict_subplot1["ylabel"]   = "yname"
                         dict_subplot1["height_rows"] = 1 (default, Wieviele Reihen im Verhältnis zu den anderen Diagrammen soll es einenehmen, Ganzzahl)
                         dict_subplot1["grid"] = True (default, False)
                         dict_subplot1["legend"] = "upper left","upper center","upper right","center left","center","center right","lower left","lower center","lower right"
                         dict_subplot1["data_list"]   = [dict_data1, dictr_data2, ...]

                         dict_data1["xdat"] = np.array([secs1,secs2, ...])
                         dict_data1["y"]   = np.array([val1,val2, ...])
                         dict_data1["color"]   = 'k', (default,'b', 'g', 'r', 'c', 'm', 'y', 'k', 'w', ...)
                         dict_data1["linewidth"]    = 1 (default)
                         dict_data1["linestyle"]    = '-' (default, '--', '-.', ':', '')
                         dict_data1["marker"]    = '' (default, '.', 'o', 'd', 'v', '^', '>', '<', ...)
                         dict_data1["label"]    = 'linex' (default)

    """

    dict_input = {}
    dict_input["plot"] = ddict

    sgui.matplot_date_data(dict_input)