
import os, sys, copy

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import wp_screen_gui
import wp_screen_sigset_check

import tools.hfkt_def as hdef
import tools.hfkt_pickle as hfkt_pickle
import tools.hfkt_tvar as htvar
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

def sigset_set(rd):
    # Signalset-Liste Json-Liste einladen
    if rd.sig["sigset_liste_jsonobj"] is None:

        rd.sig["sigset_liste_filename"] = os.path.join(rd.ini["store_path"],
                                rd.ini["sigset_liste_file_name"]+".json")

        rd.sig["sigset_liste_jsonobj"] = hfkt_pickle.DataJson(rd.sig["sigset_liste_filename"])
    # end if

    rd.sig["sigset_liste"] = rd.sig["sigset_liste_jsonobj"].read_and_get_data()

    if rd.sig["sigset_liste_jsonobj"].get_status() == hdef.NOT_FOUND:
        rd.sig["sigset_liste"] = []
    elif rd.sig["sigset_liste_jsonobj"].get_status() != hdef.OKAY:
        rd.log.write_err(rd.sig["sigset_liste_jsonobj"].get_errtext(), screen=rd.par.LOG_SCREEN_OUT)
        return
    # end if
    return
def sigset_start(rd):

    sigset_set(rd)
    if get_status() != hdef.OKAY:
        return
    # end if

    sigset_command(rd)

    return
# end def
def sigset_command(rd):


    auswahl_title = "Sigset-Namen editieren"
    abfrage_liste = ["edit(signale)","add", "delete", "rename","ende"]
    i_edit = 0
    i_add = 1
    i_delete = 2
    i_rename = 3
    i_ende = 4

    runflag = True

    while runflag:

        auswahl_liste = rd.sig["sigset_liste"]
        n_auswahl_liste = len(auswahl_liste)

        (index, indexAbfrage) = wp_screen_gui.listen_abfrage(rd.gui, auswahl_liste, auswahl_title, abfrage_liste)

        if (indexAbfrage < 0) or (indexAbfrage == i_ende):
            runflag = False
        elif indexAbfrage == i_edit:
            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("sigset_command edit: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                sigset_edit_command(rd, index)
                if get_status() != hdef.OKAY:
                    runflag = False
            # end if
        elif indexAbfrage == i_add:
            sigset_add(rd)
        elif indexAbfrage == i_delete:
            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("sigset_command delete: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                sigset_del(rd, index)
            # end if
        else:  # if indexAbfrage == i_rename:
            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("sigset_command rename: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                sigset_rename(rd, index)
            # end if
    # end while
    return
# end def
def sigset_add(rd):
    """

    :param rd:
    :return: sigset_add(rd)
    """

    liste_abfrage = ["sigsetname"]
    title = "neuem Signal-Set-Name eingeben"
    (liste_ergebnis, status) = wp_screen_gui.eingabe_n_zeilen(rd.gui, liste_abfrage,
                                                              liste_vorgabe=None, title=title)

    if (status != hdef.OKAY) or (liste_ergebnis == []):
        return

    text = liste_ergebnis[0]
    # entfernt Leerzeichen, Tabulator (\t), Zeilenumbrüche (\n), geschützte Leerzeichen (\xa0)
    sigsetname = "".join(text.split()).replace(" ", "")

    if sigsetname not in rd.sig["sigset_liste"]:
        rd.log.write_info(f"{sigsetname = } wurde der sigset_liste hinzugefügt")
    else:
        rd.log.write_info(f"{sigsetname = } gibt es schon in Liste")
        return
    # end if

    rd.sig["sigset_liste"].append(sigsetname)

    rd.sig["sigset_liste_jsonobj"].save(rd.sig["sigset_liste"])

    return
# end def
def sigset_del(rd,index):
    """
    :param rd:

    :param index:
    :return: return
    """
    flag = wp_screen_gui.janein_abfrage(rd.gui, f"Soll wirklich das Element {index = } name = \"{rd.sig["sigset_liste"][index]}\" gelöscht werden?",
                                    "Löschen ja/nein")
    if flag:
        del rd.sig["sigset_liste"][index]
        rd.sig["sigset_liste_jsonobj"].save(rd.sig["sigset_liste"])
    # end if


    return
# end def
def sigset_rename(rd, index):

    liste_abfrage = ["sigsetname"]
    title = "Umbenennen Signal-Set-Name "
    liste_vorgabe = [rd.sig["sigset_liste"][index]]
    (liste_ergebnis, status) = wp_screen_gui.eingabe_n_zeilen(rd.gui, liste_abfrage,
                                                              liste_vorgabe=liste_vorgabe, title=title)

    if (status != hdef.OKAY) or (liste_ergebnis == []):
        return

    text = liste_ergebnis[0]
    # entfernt Leerzeichen, Tabulator (\t), Zeilenumbrüche (\n), geschützte Leerzeichen (\xa0)
    sigset = "".join(text.split()).replace(" ", "")

    if sigset != rd.sig["sigset_liste"][index]:
        rd.sig["sigset_liste"][index] = sigset
        rd.sig["sigset_liste_jsonobj"].save(rd.sig["sigset_liste"])
    # end if
    return
# end def
def sigset_edit_command(rd, index):

    rd.sig["sigset"] = rd.sig["sigset_liste"][index]

    sigset_dict_read(rd)

    if get_status() != hdef.OKAY:
        return


    abfrage_liste = ["update(value)","modiy(dict)", "add(var)", "delete(var)","hilfe","end"]

    title = f"sigset: \"{rd.sig["sigset"]}\"; dictionary der Signalzuordnung key => Signalname value => Vorschrift"

    index_update = 0
    index_modify = 1
    index_add = 2
    index_delete = 3
    # index_hilfe = 4
    index_end = 5


    runflag = True
    while (runflag):

        ddict = rd.sig["sigset_dict"]

        if len(ddict.keys()) == 0:
            ddict["leer"]="0"

        (ddict_mod, changed_key_liste,index_abfrage) = wp_screen_gui.sigset_dict_abfrage(rd.gui, rd.sig["sigset_dict"],
                                                                              title=title,
                                                                              abfrage_liste=abfrage_liste)
        if (wp_screen_gui.get_status() != hdef.OK):
            global STATUS, ERRTEXT
            STATUS = wp_screen_gui.get_status()
            ERRTEXT = wp_screen_gui.get_errtext()
            wp_screen_gui.reset_status()
            return
        # end if

        if (len(ddict_mod.keys()) == 1) and ("leer" in ddict_mod.keys()):
            ddict_mod = rd.sig["sigset_dict"]
            changed_key_liste = []
        # end if

        # Beenden
        # ----------------------------
        if (index_abfrage == -1) or (index_abfrage == index_end):

            runflag = False
        elif (index_abfrage == -1) or (index_abfrage == index_update):

            if len(changed_key_liste) > 0:
                sigset_edit_update(rd, ddict_mod,changed_key_liste)
                if get_status() != hdef.OKAY:
                    return
                # end if
            # end if
        elif index_abfrage == index_modify:

            sigset_edit_modify(rd)
            if get_status() != hdef.OKAY:
                return
            # end if
        elif index_abfrage == index_add:

            sigset_edit_add(rd)
            if get_status() != hdef.OKAY:
                return
            # end if
        elif index_abfrage == index_delete:

            sigset_edit_delete(rd)
        else: # index_abfrage == index_hilfe
            sigset_edit_hilfe(rd)

    # end while
    return
# end def
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
    rd.sig["sigset_dict_jsonobj"] = hfkt_pickle.DataJson(rd.sig["sigset_dict_filename"])

    rd.sig["sigset_dict"] = rd.sig["sigset_dict_jsonobj"].read_and_get_data()

    if rd.sig["sigset_dict_jsonobj"].get_status() == hdef.NOT_FOUND:
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
def sigset_edit_update(rd, ddict_mod,changed_key_liste):
    global STATUS, ERRTEXT
    # Check modified dictionary
    (okay,infotext) = wp_screen_sigset_check.check(rd,ddict_mod)
    if wp_screen_sigset_check.get_status() != hdef.OKAY:

        STATUS = wp_screen_sigset_check.get_status()
        ERRTEXT = wp_screen_sigset_check.get_errtext()
        wp_screen_sigset_check.reset_status()
        return
    # end if

    if okay != hdef.OKAY:
        wp_screen_gui.janein_abfrage(rd.gui,f"Fehler in sigalset {infotext = }","")
        return
    else:

        rd.sig["sigset_dict"] = ddict_mod
        rd.sig["sigset_dict_jsonobj"].save(rd.sig["sigset_dict"])
        if rd.sig["sigset_dict_jsonobj"].get_status() != hdef.OKAY:
            STATUS = rd.sig["sigset_dict_jsonobj"].get_status()
            ERRTEXT = rd.sig["sigset_dict_jsonobj"].get_errtext()
            rd.sig["sigset_dict_jsonobj"].reset_status()
            return
        # end if
    # end if

    return
# end def
def sigset_edit_modify(rd):
    """

    :param rd:
    :return:
    """
    dict_mod = wp_screen_gui.sigset_dict_modify(rd.gui,
                                                   rd.sig["sigset"],
                                                   rd.sig["sigset_dict"],)

    # Check modified dictionary
    (okay,infotext) = wp_screen_sigset_check.check(rd,dict_mod)

    if okay != hdef.OKAY:
        wp_screen_gui.janein_abfrage(rd.gui,f"Fehler in sigset {infotext = }","")
        return
    else:

        rd.sig["sigset_dict"] = dict_mod
        rd.sig["sigset_dict_jsonobj"].save(rd.sig["sigset_dict"])
        if rd.sig["sigset_dict_jsonobj"].get_status() != hdef.OKAY:
            global STATUS, ERRTEXT
            STATUS = rd.sig["sigset_dict_jsonobj"].get_status()
            ERRTEXT = rd.sig["sigset_dict_jsonobj"].get_errtext()
            rd.sig["sigset_dict_jsonobj"].reset_status()
            return
        # end if
    # end if
    return
# end def
def sigset_edit_add(rd):
    """

    :param rd:
    :return: return
    """
    liste_abfrage = ["signalname=key"]
    title = f"neuer Signalname eingeben für sigset = {rd.sig["sigset"]}"
    (liste_ergebnis, status) = wp_screen_gui.eingabe_n_zeilen(rd.gui, liste_abfrage,
                                                              liste_vorgabe=None, title=title)

    if (status != hdef.OKAY) or (liste_ergebnis == []):
        return

    text = liste_ergebnis[0]
    # entfernt Leerzeichen, Tabulator (\t), Zeilenumbrüche (\n), geschützte Leerzeichen (\xa0)
    signalname = "".join(text.split()).replace(" ", "")

    rd.sig["sigset_dict"][signalname] = "0"

    rd.sig["sigset_dict_jsonobj"].save(rd.sig["sigset_dict"])
    if rd.sig["sigset_dict_jsonobj"].get_status() != hdef.OKAY:
        global STATUS, ERRTEXT
        STATUS = rd.sig["sigset_dict_jsonobj"].get_status()
        ERRTEXT = rd.sig["sigset_dict_jsonobj"].get_errtext()
        rd.sig["sigset_dict_jsonobj"].reset_status()
        return
    # end if

    return
# end def
def sigset_edit_delete(rd):
    """

    :param rd:
    :return: return
    """

    auswahl_liste = list(rd.sig["sigset_dict"].keys())
    auswahl_title = "wähle ein Signalnamen aus"
    (index, indexAbfrage) = wp_screen_gui.listen_abfrage(rd.gui, auswahl_liste, auswahl_title)

    if indexAbfrage == -1:
        return
    else:
        dict_mod = copy.copy(rd.sig["sigset_dict"])
        signame = auswahl_liste[index]

        del dict_mod[signame]

        # Check modified dictionary
        (okay,infotext) = wp_screen_sigset_check.check(rd,dict_mod)

        if okay != hdef.OKAY:
            wp_screen_gui.janein_abfrage(rd.gui,f"Fehler in sigalset {infotext = }","")
            return
        else:

            rd.sig["sigset_dict"] = dict_mod
            rd.sig["sigset_dict_jsonobj"].save(rd.sig["sigset_dict"])
            if rd.sig["sigset_dict_jsonobj"].get_status() != hdef.OKAY:
                global STATUS, ERRTEXT
                STATUS = rd.sig["sigset_dict_jsonobj"].get_status()
                ERRTEXT = rd.sig["sigset_dict_jsonobj"].get_errtext()
                rd.sig["sigset_dict_jsonobj"].reset_status()
                return
            # end if
        # end if
    # end if
    return
# end def
def sigset_edit_hilfe(rd):
    """

    :param rd:
    :return:
    """
    infotext = wp_screen_sigset_check.hilfe(rd)


    wp_screen_gui.anzeige_text(rd.gui, f"Hilfe für sigalset signalxy = Kontext, für Kontext kann stehe:\n{infotext}", "Hilfe syntax sigset")
    return
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
