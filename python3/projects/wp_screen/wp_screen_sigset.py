
import os, sys, copy

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import wp_screen.wp_screen_gui as wp_screen_gui
import wp_screen.wp_screen_sigset_check as wp_screen_sigset_check
import wp_screen.wp_screen_sigset_command as wp_screen_sigset_command

import tools.hfkt_def as hdef
import tools.hfkt_io as hio

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

def sigset_start(rd):

    sigset_set(rd)
    if get_status() != hdef.OKAY:
        return
    # end if

    wp_screen_sigset_command.sigset_command(rd)
    if wp_screen_sigset_command.get_status() != hdef.OKAY:
        global STATUS, ERRTEXT
        STATUS = wp_screen_sigset_command.get_status()
        ERRTEXT = wp_screen_sigset_command.get_errtext()
        wp_screen_sigset_command.reset_status()
    # end def
    return
# end def
def sigset_set(rd):
    # Signalset-Liste Json-Liste einladen
    if rd.sig["sigset_liste_jsonobj"] is None:

        rd.sig["sigset_liste_filename"] = os.path.join(rd.ini["store_path"],
                                rd.ini["sigset_liste_file_name"]+".json")

        rd.sig["sigset_liste_jsonobj"] = hio.DataJson(rd.sig["sigset_liste_filename"])
    # end if

    rd.sig["sigset_liste"] = rd.sig["sigset_liste_jsonobj"].read_and_get_data()

    if rd.sig["sigset_liste_jsonobj"].get_status() == hdef.NOT_FOUND:
        rd.sig["sigset_liste"] = []
    elif rd.sig["sigset_liste_jsonobj"].get_status() != hdef.OKAY:
        rd.log.write_err(rd.sig["sigset_liste_jsonobj"].get_errtext(), screen=rd.par.LOG_SCREEN_OUT)
        return
    # end if
    return
def sigset_dict_read(rd):
    """

    :param rd:
    :return: sigset_dict_read(rd)
    """
    rd.sig["sigset_dict_filename"] = os.path.join(rd.ini["store_path"],
                            rd.ini["sigset_dict_pre_file_name"] + rd.sig["sigset"] + ".json")

    if rd.sig["sigset_dict_jsonobj"] is not None:
        del rd.sig["sigset_dict_jsonobj"]
    # end if
    rd.sig["sigset_dict_jsonobj"] = hio.DataJson(rd.sig["sigset_dict_filename"])

    rd.sig["sigset_dict"] = rd.sig["sigset_dict_jsonobj"].read_and_get_data()

    if rd.sig["sigset_dict_jsonobj"].get_status() == hdef.NOT_FOUND:
        rd.sig["sigset_dict_jsonobj"].reset_status()
        rd.sig["sigset_dict"] = {}
    elif rd.sig["sigset_dict_jsonobj"].get_status() != hdef.OKAY:
        rd.log.write_err(rd.sig["sigset_dict_jsonobj"].get_errtext(), screen=rd.par.LOG_SCREEN_OUT)
        global STATUS, ERRTEXT
        STATUS = rd.sig["sigset_dict_jsonobj"].get_status()
        ERRTEXT = rd.sig["sigset_dict_jsonobj"].get_errtext()
        rd.sig["sigset_dict_jsonobj"].reset_status()
        # end if
    return
# end def
#-----------------------------------------------------------
# Externe Funktionen
#------------------------------------------------------------
def get_sigset_auswahl(rd):
    sigset_set(rd)

    (index, _) = wp_screen_gui.listen_abfrage(rd.gui, rd.sig["sigset_liste"], auswahl_title="Auswahl Siganl-Set")

    if index >= 0:
        sigset = rd.sig["sigset_liste"][index]

    else:
        sigset = None
    # end if

    return sigset
# end def
def exist_sigset(rd,sigset):
    if sigset in rd.sig["sigset_liste"]:
        return True
    else:
        return False
    # end if
# end def
def get_sigset_dict(rd, sigset):
    if sigset in rd.sig["sigset_liste"]:

        rd.sig["sigset"] = sigset
        sigset_dict_read(rd)
    else:
        rd.sig["sigset_dict"] = {}
    # end if
    return rd.sig["sigset_dict"]
# end def
def get_sigset_werte_dict_liste(rd,sigset_dict):
    """
    :param rd:
    :param sigset_dict:
    :return: (okay,infotext,sigset_werte_dict_liste) = get_sigset_werte_dict_liste(rd,sigset_dict)
    """
    (okay,infotext) = wp_screen_sigset_check.check(rd,sigset_dict)

    return (okay,infotext,rd.sig["sigset_werte_dict_liste"])
# end def
def add_dict(rd,sigsetname,sigsetdict):
    """
    :param rd:
    :param sigaetname:
    :param sigsetdict:
    :return:
    """

    global STATUS, ERRTEXT

    sigset_set(rd)

    rd.sig["sigset"] = add_sigsetname(rd, sigsetname)

    sigset_dict_read(rd)
    if STATUS != hdef.OKAY:
        del_sigsetname(rd, sigsetname)
        return

    modify_dict(rd, sigsetdict)
    if STATUS != hdef.OKAY:
        del_sigsetname(rd, sigsetname)
        return

    return
# end if
def add_sigsetname(rd,sigsetname):
    """
    :param rd:
    :param sigsetname:
    :return: sigset
    """

    # entfernt Leerzeichen, Tabulator (\t), Zeilenumbrüche (\n), geschützte Leerzeichen (\xa0)
    sigset = "".join(sigsetname.split()).replace(" ", "")

    if sigset not in rd.sig["sigset_liste"]:

        rd.sig["sigset_liste"].append(sigset)
        rd.sig["sigset_liste_jsonobj"].save(rd.sig["sigset_liste"])

        rd.log.write_info(f"{sigset = } wurde der sigset_liste hinzugefügt")
    else:
        rd.log.write_info(f"{sigset = } gibt es schon in Liste")
    # end if

    return sigset
# end def
def del_sigsetname(rd,sigsetname):
    """
    :param rd:
    :param sigsetname:
    :return:
    """

    if sigsetname in rd.sig["sigset_liste"]:
        index = rd.sig["sigset_liste"].index(sigsetname)
        del rd.sig["sigset_liste"][index]
        rd.sig["sigset_liste_jsonobj"].save(rd.sig["sigset_liste"])
    # end if
    return
# end def
def modify_dict(rd, dict_mod):
    """
    :param rd:
    :param dict_mod:
    :return:
    """

    global STATUS, ERRTEXT

    # Check modified dictionary
    (status,infotext) = wp_screen_sigset_check.check(rd,dict_mod)

    if status != hdef.OKAY:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"wp_screen_sigset_check.check: Mit dict: {dict_mod} => {infotext = }"
        return
    # end if

    rd.sig["sigset_dict"] = dict_mod
    rd.sig["sigset_dict_jsonobj"].save(rd.sig["sigset_dict"])
    if rd.sig["sigset_dict_jsonobj"].get_status() != hdef.OKAY:
        STATUS = rd.sig["sigset_dict_jsonobj"].get_status()
        ERRTEXT = rd.sig["sigset_dict_jsonobj"].get_errtext()
        rd.sig["sigset_dict_jsonobj"].reset_status()
        return
    # end if

    return
# end def