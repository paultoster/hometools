
import os, sys
import tomllib

from hfkt_log import log

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import wp_screen_gui

import tools.hfkt_def as hdef
import tools.hfkt_pickle as hfkt_pickle

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
def katalog_start(rd):


    filename = rd.ini["katalog_liste_file_name"]
    jsonobj = hfkt_pickle.DataJson(filename)

    rd.kat["katalog_liste"] = jsonobj.read_and_get_data()

    if jsonobj.get_status() == hdef.NOT_FOUND:
        rd.kat["katalog_liste"] = []
    elif jsonobj.get_status() != hdef.OKAY:
        rd.log.write_err(jsonobj.get_errtext(),screen=1)
        return
    # end if

    katalog = katalog_command(rd)

    if len(katalog) == 0:
        return

    return
# end def
def katalog_command(rd):
    auswahl_liste =
    auswahl_title =
    abfrage_liste =



    runflag = True

    while runflag:

        (index, indexAbfrage) = wp_screen_gui.listen_abfrage(rd.gui, auswahl_liste, auswahl_title, abfrage_liste)


    # end while

    katalog_liste_mod = wp_screen_gui.katalog_liste_edit_abfrage(rd.gui,rd.kat["katalog_liste"])



    return
# end def

# end def