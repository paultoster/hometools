
import os, sys, copy

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import wp_screen_gui
import wp_screen_tab_check

import tools.hfkt_def as hdef
import tools.hfkt_pickle as hfkt_pickle
# import tools.hfkt_tvar as htvar
# import tools.hfkt_type as htype

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

    tab_command(rd)

    return
# end def
def tab_command(rd):


    auswahl_title = "Tabellen-Namen editieren"
    abfrage_liste = ["edit(tabelle)","add", "delete", "rename","ende"]
    i_edit = 0
    i_add = 1
    i_delete = 2
    i_rename = 3
    i_ende = 4

    runflag = True

    while runflag:

        auswahl_liste = rd.tab["tab_liste"]
        n_auswahl_liste = len(auswahl_liste)

        (index, indexAbfrage) = wp_screen_gui.listen_abfrage(rd.gui, auswahl_liste, auswahl_title, abfrage_liste)

        if (indexAbfrage < 0) or (indexAbfrage == i_ende):
            runflag = False
        elif indexAbfrage == i_edit:
            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("tab_command edit: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                tab_edit_command(rd, index)
                if get_status() != hdef.OKAY:
                    runflag = False
            # end if
        elif indexAbfrage == i_add:
            tab_add(rd)
        elif indexAbfrage == i_delete:
            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("tab_command delete: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                tab_del(rd, index)
            # end if
        else:  # if indexAbfrage == i_rename:
            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("tab_command rename: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                tab_rename(rd, index)
            # end if
    # end while
    return
# end def
def tab_add(rd):
    """

    :param rd:
    :return: tab_add(rd)
    """

    liste_abfrage = ["tabname"]
    title = "neuem Tabellen-Name eingeben"
    (liste_ergebnis, status) = wp_screen_gui.eingabe_n_zeilen(rd.gui, liste_abfrage,
                                                              liste_vorgabe=None, title=title)

    if (status != hdef.OKAY) or (liste_ergebnis == []):
        return

    text = liste_ergebnis[0]
    # entfernt Leerzeichen, Tabulator (\t), Zeilenumbrüche (\n), geschützte Leerzeichen (\xa0)
    tabname = "".join(text.split()).replace(" ", "")

    if tabname not in rd.tab["tab_liste"]:
        rd.log.write_info(f"{tabname = } wurde der tab_liste hinzugefügt")
    else:
        rd.log.write_info(f"{tabname = } gibt es schon in Liste")
        return
    # end if

    rd.tab["tab_liste"].append(tabname)

    rd.tab["tab_liste_jsonobj"].save(rd.tab["tab_liste"])

    return
# end def
def tab_del(rd,index):
    """
    :param rd:

    :param index:
    :return: return
    """
    flag = wp_screen_gui.janein_abfrage(rd.gui, f"Soll wirklich das Element {index = } name = \"{rd.tab["tab_liste"][index]}\" gelöscht werden?",
                                    "Löschen ja/nein")
    if flag:
        del rd.tab["tab_liste"][index]
        rd.tab["tab_liste_jsonobj"].save(rd.tab["tab_liste"])
    # end if


    return
# end def
def tab_rename(rd, index):

    liste_abfrage = ["tabname"]
    title = "Umbenennen Tabellen-Name "
    liste_vorgabe = [rd.tab["tab_liste"][index]]
    (liste_ergebnis, status) = wp_screen_gui.eingabe_n_zeilen(rd.gui, liste_abfrage,
                                                              liste_vorgabe=liste_vorgabe, title=title)

    if (status != hdef.OKAY) or (liste_ergebnis == []):
        return

    text = liste_ergebnis[0]
    # entfernt Leerzeichen, Tabulator (\t), Zeilenumbrüche (\n), geschützte Leerzeichen (\xa0)
    tab = "".join(text.split()).replace(" ", "")

    if tab != rd.tab["tab_liste"][index]:
        rd.tab["tab_liste"][index] = tab
        rd.tab["tab_liste_jsonobj"].save(rd.tab["tab_liste"])
    # end if
    return
# end def
def tab_edit_command(rd, index):

    rd.tab["tab"] = rd.tab["tab_liste"][index]

    tab_dict_read(rd)

    if get_status() != hdef.OKAY:
        return


    abfrage_liste = ["update(value)","modiy(dict)", "add(var)", "delete(var)","hilfe","end"]

    title = f"tab: \"{rd.tab["tab"]}\"; dictionary der Tabellenzuordnung key => TabellenSpaltenname value => Vorschrift"

    index_update = 0
    index_modify = 1
    index_add = 2
    index_delete = 3
    # index_hilfe = 4
    index_end = 5


    runflag = True
    while (runflag):

        ddict = rd.tab["tab_dict"]

        if len(ddict.keys()) == 0:
            ddict["Name"]="bi:name(str,white)"

        (ddict_mod, changed_key_liste,index_abfrage) = wp_screen_gui.tab_dict_abfrage(rd.gui, rd.tab["tab_dict"],
                                                                              title=title,
                                                                              abfrage_liste=abfrage_liste)
        if (wp_screen_gui.get_status() != hdef.OK):
            STATUS = wp_screen_gui.get_status()
            ERRTEXT = wp_screen_gui.get_errtext()
            wp_screen_gui.reset_status()
            return
        # end if

        if (len(ddict_mod.keys()) == 1) and ("leer" in ddict_mod.keys()):
            ddict_mod = rd.tab["tab_dict"]
            changed_key_liste = []
        # end if

        # Beenden
        # ----------------------------
        if (index_abfrage == -1) or (index_abfrage == index_end):

            runflag = False
        elif (index_abfrage == -1) or (index_abfrage == index_update):

            if len(changed_key_liste) > 0:
                tab_edit_update(rd, ddict_mod,changed_key_liste)
                if get_status() != hdef.OKAY:
                    return
                # end if
            # end if
        elif index_abfrage == index_modify:

            tab_edit_modify(rd)
            if get_status() != hdef.OKAY:
                return
            # end if
        elif index_abfrage == index_add:

            tab_edit_add(rd)
            if get_status() != hdef.OKAY:
                return
            # end if
        elif index_abfrage == index_delete:

            tab_edit_delete(rd)
        else: # index_abfrage == index_hilfe
            tab_edit_hilfe(rd)

    # end while
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
        STATUS = rd.tab["tab_dict_jsonobj"].get_status()
        ERRTEXT = rd.tab["tab_dict_jsonobj"].get_errtext()
        rd.tab["tab_dict_jsonobj"].reset_status()
        # end if
    return
# end def
def tab_edit_update(rd, ddict_mod,changed_key_liste):

    # Check modified dictionary
    (okay,infotext) = wp_screen_tab_check.check(rd,ddict_mod)
    if wp_screen_tab_check.get_status() != hdef.OKAY:
        STATUS = wp_screen_tab_check.get_status()
        ERRTEXT = wp_screen_tab_check.get_errtext()
        wp_screen_tab_check.reset_status()
        return
    # end if

    if okay != hdef.OKAY:
        wp_screen_gui.janein_abfrage(rd.gui,f"Fehler in tabelle {infotext = }","")
        return
    else:

        rd.tab["tab_dict"] = ddict_mod
        rd.tab["tab_dict_jsonobj"].save(rd.tab["tab_dict"])
        if rd.tab["tab_dict_jsonobj"].get_status() != hdef.OKAY:
            STATUS = rd.tab["tab_dict_jsonobj"].get_status()
            ERRTEXT = rd.tab["tab_dict_jsonobj"].get_errtext()
            rd.tab["tab_dict_jsonobj"].reset_status()
            return
        # end if
    # end if

    return
# end def
def tab_edit_modify(rd):
    """

    :param rd:
    :return:
    """
    dict_mod = wp_screen_gui.tab_dict_modify(rd.gui,
                                                   rd.tab["tab"],
                                                   rd.tab["tab_dict"],)

    # Check modified dictionary
    (okay,infotext) = wp_screen_tab_check.check(rd,dict_mod)

    if okay != hdef.OKAY:
        wp_screen_gui.janein_abfrage(rd.gui,f"Fehler in tab {infotext = }","")
        return
    else:

        rd.tab["tab_dict"] = dict_mod
        rd.tab["tab_dict_jsonobj"].save(rd.tab["tab_dict"])
        if rd.tab["tab_dict_jsonobj"].get_status() != hdef.OKAY:
            STATUS = rd.tab["tab_dict_jsonobj"].get_status()
            ERRTEXT = rd.tab["tab_dict_jsonobj"].get_errtext()
            rd.tab["tab_dict_jsonobj"].reset_status()
            return
        # end if
    # end if
    return
# end def
def tab_edit_add(rd):
    """

    :param rd:
    :return: return
    """
    liste_abfrage = ["TabellenSpaltenName=key"]
    title = f"neuer TabellenSpaltenName eingeben für tab = {rd.tab["tab"]}"
    (liste_ergebnis, status) = wp_screen_gui.eingabe_n_zeilen(rd.gui, liste_abfrage,
                                                              liste_vorgabe=None, title=title)

    if (status != hdef.OKAY) or (liste_ergebnis == []):
        return

    text = liste_ergebnis[0]
    # entfernt Leerzeichen, Tabulator (\t), Zeilenumbrüche (\n), geschützte Leerzeichen (\xa0)
    signalname = "".join(text.split()).replace(" ", "")

    rd.tab["tab_dict"][signalname] = "0"

    rd.tab["tab_dict_jsonobj"].save(rd.tab["tab_dict"])
    if rd.tab["tab_dict_jsonobj"].get_status() != hdef.OKAY:
        STATUS = rd.tab["tab_dict_jsonobj"].get_status()
        ERRTEXT = rd.tab["tab_dict_jsonobj"].get_errtext()
        rd.tab["tab_dict_jsonobj"].reset_status()
        return
    # end if

    return
# end def
def tab_edit_delete(rd):
    """

    :param rd:
    :return: return
    """

    auswahl_liste = list(rd.tab["tab_dict"].keys())
    auswahl_title = "wähle ein TabellenSpaltenName aus"
    (index, indexAbfrage) = wp_screen_gui.listen_abfrage(rd.gui, auswahl_liste, auswahl_title)

    if indexAbfrage == -1:
        return
    else:
        dict_mod = copy.copy(rd.tab["tab_dict"])
        signame = auswahl_liste[index]

        del dict_mod[signame]

        # Check modified dictionary
        (okay,infotext) = wp_screen_tab_check.check(rd,dict_mod)

        if okay != hdef.OKAY:
            wp_screen_gui.janein_abfrage(rd.gui,f"Fehler in tab {infotext = }","")
            return
        else:

            rd.tab["tab_dict"] = dict_mod
            rd.tab["tab_dict_jsonobj"].save(rd.tab["tab_dict"])
            if rd.tab["tab_dict_jsonobj"].get_status() != hdef.OKAY:
                STATUS = rd.tab["tab_dict_jsonobj"].get_status()
                ERRTEXT = rd.tab["tab_dict_jsonobj"].get_errtext()
                rd.tab["tab_dict_jsonobj"].reset_status()
                return
            # end if
        # end if
    # end if
    return
# end def
def tab_edit_hilfe(rd):
    """

    :param rd:
    :return:
    """
    infotext = wp_screen_tab_check.hilfe(rd)


    wp_screen_gui.anzeige_text(rd.gui, f"Hilfe für tab tabbelenSpaltenName = Kontext, für Kontext kann stehe:\n{infotext}", "Hilfe syntax tab")
    return
