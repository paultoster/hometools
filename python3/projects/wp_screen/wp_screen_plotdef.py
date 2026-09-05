
import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import wp_screen_gui

import tools.hfkt_def as hdef
import tools.hfkt_pickle as hfkt_pickle
import tools.hfkt_list as hlist
import tools.hfkt_type as htype

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
def plotdef_set(rd):
    # Signalset-Liste Json-Liste einladen
    if rd.plot["plotdef_liste_jsonobj"] is None:
        rd.plot["plotdef_liste_filename"] = os.path.join(rd.ini["store_path"],
                                                       rd.ini["plotdef_liste_file_name"] + ".json")

        rd.plot["plotdef_liste_jsonobj"] = hfkt_pickle.DataJson(rd.plot["plotdef_liste_filename"])
    # end if

    rd.plot["plotdef_liste"] = rd.plot["plotdef_liste_jsonobj"].read_and_get_data()

    if rd.plot["plotdef_liste_jsonobj"].get_status() == hdef.NOT_FOUND:
        rd.plot["plotdef_liste"] = []
    elif rd.plot["plotdef_liste_jsonobj"].get_status() != hdef.OKAY:
        rd.log.write_err(rd.plot["plotdef_liste_jsonobj"].get_errtext(), screen=rd.par.LOG_SCREEN_OUT)
        return
    # end if
    return

def plotdef_dict_read(rd):
    """

    :param rd:
    :return: plotdef_dict_read(rd)
    """
    rd.plot["plotdef_dict_filename"] = os.path.join(rd.ini["store_path"],
                                                  rd.ini["plotdef_dict_pre_file_name"] + rd.plot["plotdef"] + ".json")

    if rd.plot["plotdef_dict_jsonobj"] is not None:
        del rd.plot["plotdef_dict_jsonobj"]
    # end if
    rd.plot["plotdef_dict_jsonobj"] = hfkt_pickle.DataJson(rd.plot["plotdef_dict_filename"])

    rd.plot["plotdef_dict"] = rd.plot["plotdef_dict_jsonobj"].read_and_get_data()

    if rd.plot["plotdef_dict_jsonobj"].get_status() == hdef.NOT_FOUND:
        rd.plot["plotdef_dict"] = {}
    elif rd.plot["plotdef_dict_jsonobj"].get_status() != hdef.OKAY:
        rd.log.write_err(rd.plot["plotdef_dict_jsonobj"].get_errtext(), screen=rd.par.LOG_SCREEN_OUT)
        global STATUS, ERRTEXT
        STATUS = rd.plot["plotdef_dict_jsonobj"].get_status()
        ERRTEXT = rd.plot["plotdef_dict_jsonobj"].get_errtext()
        rd.plot["plotdef_dict_jsonobj"].reset_status()
        # end if
    return

# end def
# -----------------------------------------------------------
# Externe Funktionen
# ------------------------------------------------------------
def get_plotdef_auswahl(rd):
    plotdef_set(rd)

    (index, _) = wp_screen_gui.listen_abfrage(rd.gui, rd.plot["plotdef_liste"], auswahl_title="Auswahl Plotdef-Set")

    if index >= 0:
        plotdef = rd.plot["plotdef_liste"][index]

    else:
        plotdef = None
    # end if

    return plotdef

# end def
def exist_plotdef(rd, plotdef):
    if plotdef in rd.plot["plotdef_liste"]:
        return True
    else:
        return False
    # end if

# end def
def get_plotdef_dict(rd, plotdef):
    if plotdef in rd.plot["plotdef_liste"]:

        rd.plot["plotdef"] = plotdef
        plotdef_dict_read(rd)
    else:
        rd.plot["plotdef_dict"] = {}
    # end if
    return rd.plot["plotdef_dict"]

# end def
def get_plotdef_werte_dict_liste(rd, plotdef_dict):
    """
    :param rd:
    :param plotdef_dict:
    :return: (okay,infotext,plotdef_werte_dict_liste) = get_plotdef_werte_dict_liste(rd,plotdef_dict)
    """
    (okay, infotext) = wp_screen_plotdef_check.check(rd, plotdef_dict)

    return (okay, infotext, rd.plot["plotdef_werte_dict_liste"])
# end def
