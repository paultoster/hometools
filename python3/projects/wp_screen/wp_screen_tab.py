
import os, sys, copy

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import wp_screen_gui
import wp_screen_tab_check
import wp_screen_tab_command

import tools.hfkt_def as hdef
import tools.hfkt_pickle as hfkt_pickle
# import tools.hfkt_tvar as htvar
# import tools.hfkt_type as htype

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

def tab_set(rd):
    # Signalset-Liste Json-Liste einladen
    if rd.tab["tab_liste_jsonobj"] is None:

        rd.tab["tab_liste_filename"] = os.path.join(rd.ini["store_path"],
                                rd.ini["tab_liste_file_name"]+".json")

        rd.tab["tab_liste_jsonobj"] = hfkt_pickle.DataJson(rd.tab["tab_liste_filename"])
    # end if

    rd.tab["tab_liste"] = rd.tab["tab_liste_jsonobj"].read_and_get_data()

    if rd.tab["tab_liste_jsonobj"].get_status() == hdef.NOT_FOUND:
        rd.tab["tab_liste"] = []
    elif rd.tab["tab_liste_jsonobj"].get_status() != hdef.OKAY:
        rd.log.write_err(rd.tab["tab_liste_jsonobj"].get_errtext(), screen=rd.par.LOG_SCREEN_OUT)
        return
    # end if
    return
def tab_start(rd):

    tab_set(rd)
    if get_status() != hdef.OKAY:
        return
    # end if

    wp_screen_tab_command.tab_command(rd)
    if wp_screen_tab_command.get_status() != hdef.OKAY:
        global STATUS, ERRTEXT
        STATUS = wp_screen_tab_command.get_status()
        ERRTEXT = wp_screen_tab_command.get_errtext()
        wp_screen_tab_command.reset_status()
    # end def

    return
# end def
def tab_dict_read(rd):
    """

    :param rd:
    :return: tab_dict_read(rd)
    """
    rd.tab["tab_dict_filename"] = os.path.join(rd.ini["store_path"],
                            rd.ini["tab_dict_pre_file_name"] + rd.tab["tab"] + ".json")

    if rd.tab["tab_dict_jsonobj"] is not None:
        del rd.tab["tab_dict_jsonobj"]
    # end if
    rd.tab["tab_dict_jsonobj"] = hfkt_pickle.DataJson(rd.tab["tab_dict_filename"])

    rd.tab["tab_dict"] = rd.tab["tab_dict_jsonobj"].read_and_get_data()

    if rd.tab["tab_dict_jsonobj"].get_status() == hdef.NOT_FOUND:
        rd.tab["tab_dict"] = {}
    elif rd.tab["tab_dict_jsonobj"].get_status() != hdef.OKAY:
        rd.log.write_err(rd.tab["tab_dict_jsonobj"].get_errtext(), screen=rd.par.LOG_SCREEN_OUT)
        global STATUS, ERRTEXT
        STATUS = rd.tab["tab_dict_jsonobj"].get_status()
        ERRTEXT = rd.tab["tab_dict_jsonobj"].get_errtext()
        rd.tab["tab_dict_jsonobj"].reset_status()
        # end if
    return
# end def
#-----------------------------------------------------------
# Externe Funktionen
#------------------------------------------------------------
def get_tab_auswahl(rd):

    tab_set(rd)

    (index, _) = wp_screen_gui.listen_abfrage(rd.gui, rd.tab["tab_liste"], auswahl_title="Auswahl Tabellen-Set")

    if index >= 0:
        tab = rd.tab["tab_liste"][index]

    else:
        tab = None
    # end if

    return tab
# end def
def exist_tab(rd,tab):
    if tab in rd.tab["tab_liste"]:
        return True
    else:
        return False
    # end if
# end def
def get_tab_dict(rd, tab):
    if tab in rd.tab["tab_liste"]:

        rd.tab["tab"] = tab
        tab_dict_read(rd)
    else:
        rd.tab["tab_dict"] = {}
    # end if
    return rd.tab["tab_dict"]
# end def
def get_tab_werte_dict_liste(rd,tab_dict):
    """
    :param rd:
    :param sigset_dict:
    :return: (okay,infotext,sigset_werte_dict_liste) = get_sigset_werte_dict_liste(rd,sigset_dict)
    """
    (okay,infotext) = wp_screen_tab_check.check(rd,tab_dict)

    return (okay,infotext,rd.tab["tab_werte_dict_liste"])
# end def

