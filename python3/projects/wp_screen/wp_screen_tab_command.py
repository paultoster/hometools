
import os, sys, copy
import json

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import wp_screen.wp_screen_gui as wp_screen_gui
import wp_screen.wp_screen_tab_check as wp_screen_tab_check
import wp_screen.wp_screen_tab as wp_screen_tab


import tools.hfkt_def as hdef
import tools.sgui as sgui
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

def tab_command(rd,flagselect=False):


    auswahl_title = "Tabellen-Namen editieren"
    if flagselect:
        abfrage_liste = ["select","edit(tabelle)","modify","add", "delete", "rename","copy","hilfe","ende"]
        i_select = 0
        i_edit = 1
        i_modify = 2
        i_add = 3
        i_delete = 4
        i_rename = 5
        i_copy = 6
        index_hilfe = 7
        i_ende = 8
    else:
        abfrage_liste = ["edit(tabelle)","modify","add", "delete", "rename","copy","hilfe","ende"]
        i_select = 110
        i_edit = 0
        i_modify = 1
        i_add = 2
        i_delete = 3
        i_rename = 4
        i_copy = 5
        index_hilfe = 6
        i_ende = 7
    # end if

    runflag = True

    while runflag:

        auswahl_liste = rd.tab["tab_liste"]
        n_auswahl_liste = len(auswahl_liste)

        (index, indexAbfrage) = wp_screen_gui.listen_abfrage(rd.gui, auswahl_liste, auswahl_title, abfrage_liste)

        if (indexAbfrage < 0) or (indexAbfrage == i_ende):

            runflag = False

        elif indexAbfrage == i_select:

            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("tab_command select: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                tab = rd.tab["tab_liste"][index]
                return tab
            # end if

        elif indexAbfrage == i_edit:

            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("tab_command edit: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                tab_edit_command(rd, index)
                if get_status() != hdef.OKAY:
                    runflag = False
            # end if
        elif indexAbfrage == i_modify:

            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("tab_command modify: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                tab_edit_modify(rd,index)
                if get_status() != hdef.OKAY:
                    return None
                # end if
            # end if

        elif indexAbfrage == i_add:

            tab_add(rd)

        elif indexAbfrage == i_delete:

            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("tab_command delete: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                tab_del(rd, index)
            # end if

        elif indexAbfrage == i_rename:

            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("tab_command rename: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                tab_rename(rd, index)
            # end if
        elif indexAbfrage == i_copy:

            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("tab_command copy: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                tab_copy(rd, index)
            # end if
        else: # index_abfrage == i_hilfe
            tab_edit_hilfe(rd)
    # end while
    return None
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

    # text = liste_ergebnis[0]
    _ = wp_screen_tab.add_tabname(rd, liste_ergebnis[0])

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
        wp_screen_tab.del_tabname(rd, rd.tab["tab_liste"][index])

    # end if

    return
# end def
def tab_rename(rd, index):

    global STATUS, ERRTEXT

    tab_old = rd.tab["tab_liste"][index]
    liste_abfrage = ["tabname"]
    title = "Umbenennen Tabellen-Name "
    liste_vorgabe = [tab_old]
    (liste_ergebnis, status) = wp_screen_gui.eingabe_n_zeilen(rd.gui, liste_abfrage,
                                                              liste_vorgabe=liste_vorgabe, title=title)

    if (status != hdef.OKAY) or (liste_ergebnis == []):
        return

    text = liste_ergebnis[0]
    # entfernt Leerzeichen, Tabulator (\t), Zeilenumbrüche (\n), geschützte Leerzeichen (\xa0)
    tab = "".join(text.split()).replace(" ", "")

    if tab != rd.tab["tab_liste"][index]:
        wp_screen_tab.rename_tab_tab_dict(rd, tab_old, tab)
        if wp_screen_tab.get_status() != hdef.OKAY:
            STATUS = wp_screen_tab.get_status()
            ERRTEXT = wp_screen_tab.get_errtext()
            wp_screen_tab.reset_status()
            return
        # end if

    # end if
    return
# end def
def tab_copy(rd, index):

    tab_old = rd.tab["tab_liste"][index]
    liste_abfrage = ["newtabname"]
    liste_vorgabe = [tab_old]
    title = "Copy Tab-Name "
    (liste_ergebnis, status) = wp_screen_gui.eingabe_n_zeilen(rd.gui, liste_abfrage,
                                                              liste_vorgabe=liste_vorgabe, title=title)
    if (status != hdef.OKAY) or (liste_ergebnis == []):
        return None

    text = liste_ergebnis[0]
    # entfernt Leerzeichen, Tabulator (\t), Zeilenumbrüche (\n), geschützte Leerzeichen (\xa0)
    tab_new = "".join(text.split()).replace(" ", "")

    if tab_new in rd.tab["tab_liste"]:
        t = f"copyname: {tab_new}  ist bereits in Liste {rd.tab["tab_liste"]} "
        rd.log.write_err(t, screen=rd.par.LOG_SCREEN_OUT)
        sgui.anzeige_text(t, textcolor='red')
    else:
        wp_screen_tab.copy_tab_tab_dict(rd, tab_old, tab_new)


    # end if

# end def

def tab_edit_command(rd, index):

    global STATUS, ERRTEXT

    rd.tab["tab"] = rd.tab["tab_liste"][index]

    wp_screen_tab.tab_dict_read(rd)

    if wp_screen_tab.get_status() != hdef.OKAY:
        STATUS = wp_screen_tab.get_status()
        ERRTEXT = wp_screen_tab.get_errtext()
        wp_screen_tab.reset_status()
        return
    # end if

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

            tab_edit_modify(rd,index)
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
def tab_edit_update(rd, ddict_mod,changed_key_liste):
    global STATUS, ERRTEXT
    rd.tab["tab_dict"] = ddict_mod

    # Check modified dictionary
    # rd.sig["tab_werte_dict_liste"] wird erstellt
    (okay,infotext) = wp_screen_tab_check.check(rd,ddict_mod)
    if wp_screen_tab_check.get_status() != hdef.OKAY:

        STATUS = wp_screen_tab_check.get_status()
        ERRTEXT = wp_screen_tab_check.get_errtext()
        wp_screen_tab_check.reset_status()
        return
    # end if

    if okay != hdef.OKAY:
        wp_screen_gui.anzeige_text(rd.gui,f"Fehler in tabelle {infotext = }","")
        return
    else:


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
def tab_edit_modify(rd,index):
    """

    :param rd:
    :return:
    """
    rd.tab["tab"] = rd.tab["tab_liste"][index]

    wp_screen_tab.tab_dict_read(rd)


    dict_mod = wp_screen_gui.tab_dict_modify(rd.gui,
                                                   rd.tab["tab"],
                                                   rd.tab["tab_dict"])

    wp_screen_tab.modify_dict(rd, dict_mod)

    if wp_screen_tab.get_status() != hdef.OKAY:
        STATUS = wp_screen_tab.get_status()
        ERRTEXT = wp_screen_tab.get_errtext() + wp_screen_tab.get_infotext()
        wp_screen_gui.janein_abfrage(rd.gui, f"Fehler in sigset {ERRTEXT = }", "")
        wp_screen_tab.reset_status()
        return
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

    rd.tab["tab_dict"][signalname] = ""

    rd.tab["tab_dict_jsonobj"].save(rd.tab["tab_dict"])
    if rd.tab["tab_dict_jsonobj"].get_status() != hdef.OKAY:
        global STATUS, ERRTEXT
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
                global STATUS, ERRTEXT
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


    wp_screen_gui.anzeige_text(rd.gui, infotext, "Hilfe syntax tab")
    return
# end def
# def get_tab_auswahl(rd):
#
#     wp_screen_tab.tab_set(rd)
#
#     if wp_screen_tab.get_status() != hdef.OKAY:
#         global STATUS, ERRTEXT
#         STATUS = wp_screen_tab.get_status()
#         ERRTEXT = wp_screen_tab.get_errtext()
#         wp_screen_tab.reset_status()
#         return None
#     # end if
#
#     abfrage_liste = ["select", "show", "ende"]
#
#     while True:
#         (index, indexAbfrage) = wp_screen_gui.listen_abfrage(rd.gui,
#                                                              rd.tab["tab_liste"],
#                                                              auswahl_title="Auswahl Tabellen-Set",
#                                                              abfrage_liste=abfrage_liste)
#
#         if (index < 0) or (indexAbfrage == 2):
#             return None
#         elif indexAbfrage == 0:
#             if index >= 0:
#                 tab = rd.tab["tab_liste"][index]
#                 return tab
#             # end if
#         else:
#             if index >= 0:
#                 tab = rd.tab["tab_liste"][index]
#                 tab_dict = wp_screen_tab.get_tab_dict(rd, tab)
#                 texteingabe = json.dumps(tab_dict, indent=2)
#                 wp_screen_gui.anzeige_text(rd.gui, texteingabe, title=None, textcolor='black')
#             # end if
#         # end if
#     # end while
# # end def
