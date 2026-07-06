
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
    return STATUS
def get_errtext():
    return ERRTEXT
def get_infotext():
    return INFOTEXT
def reset_status():
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
def katalog_isin_abfrage(gui, ttable, abfrage_liste,title = None):
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
def katalog_isin_liste_modify(gui, katalog, isin_liste):
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
def signalset_dict_abfrage(gui, ddict, title = None,abfrage_liste=None):
    """

    :param gui:
    :param ddict:
    :return: (ddict,changed_key_liste) = signalset_dict_abfrage(gui, ddict, title = None)
    """

    (ddict,changed_key_liste,index_abfrage) = gui.abfrage_dict2(ddict,title=title,abfrage_liste=abfrage_liste)

    return (ddict,changed_key_liste,index_abfrage)

# end def
def signalset_dict_modify(gui, signalset, ddict):
    '''

    :param gui:
    :param katalog:
    :param isin_liste:
    :return: isin_list_mod = katalog_isin_liste_modify(gui, katalog, isin_liste)
    '''
    title = f"Von Signalset: {signalset} signal-dict editieren"
    sigset_dict_mod = gui.modify_variable(ddict, title)

    return sigset_dict_mod
# end def


