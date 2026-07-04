
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
