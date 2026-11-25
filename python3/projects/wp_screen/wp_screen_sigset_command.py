
import os, sys, copy
import json

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import wp_screen.wp_screen_gui as wp_screen_gui
import wp_screen.wp_screen_sigset as wp_screen_sigset
import wp_screen.wp_screen_sigset_check as wp_screen_sigset_check

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
def sigset_command(rd,flagselect=False):
    global STATUS
    global ERRTEXT
    auswahl_title = "Sigset-Namen editieren"
    if flagselect:
        abfrage_liste = ["select","edit(signale)","modify","add", "delete", "rename","copy","hilfe","ende"]
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
        abfrage_liste = ["edit(signale)","modify","add", "delete", "rename","copy","hilfe","ende"]
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

        auswahl_liste = rd.sig["sigset_liste"]
        n_auswahl_liste = len(auswahl_liste)

        (index, indexAbfrage) = wp_screen_gui.listen_abfrage(rd.gui, auswahl_liste, auswahl_title, abfrage_liste)

        if (indexAbfrage < 0) or (indexAbfrage == i_ende):

            runflag = False

        elif indexAbfrage == i_select:

            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("sigset_command select: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                sigset = rd.sig["sigset_liste"][index]
                return sigset
            # end if
        elif indexAbfrage == i_edit:

            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("sigset_command edit: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                sigset_edit_command(rd, index)
                if get_status() != hdef.OKAY:
                    runflag = False
            # end if
        elif indexAbfrage == i_modify:

            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("sigset_command modify: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:

                sigset_edit_modify(rd,index)
                if get_status() != hdef.OKAY:
                    return None
                # end if
            # end if

        elif indexAbfrage == i_add:

            sigset_add(rd)

        elif indexAbfrage == i_delete:

            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("sigset_command delete: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                sigset_del(rd, index)
            # end if

        elif indexAbfrage == i_rename:

            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("sigset_command rename: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                sigset_rename(rd, index)
            # end if

        elif indexAbfrage == i_copy:

            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("sigset_command rename: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                sigset_copy(rd, index)
            # end if

        else: # index_abfrage == index_hilfe
            sigset_edit_hilfe(rd)
    # end while
    return None
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

    #text = liste_ergebnis[0]
    _ = wp_screen_sigset.add_sigsetname(rd,liste_ergebnis[0])

    return
# end def
def sigset_del(rd,index):
    """
    :param rd:

    :param index:
    :return: return
    """

    sigset = rd.sig["sigset_liste"][index]

    flag = wp_screen_gui.janein_abfrage(rd.gui, f"Soll wirklich das Element {index = } name = \"{sigset}\" gelöscht werden?",
                                    "Löschen ja/nein")
    if flag:
        wp_screen_sigset.del_sigsetname(rd, sigset)

    # end if


    return
# end def
def sigset_rename(rd, index):

    old_sigset_name = rd.sig["sigset_liste"][index]
    liste_abfrage = ["sigsetname"]
    title = "Umbenennen Signal-Set-Name "
    liste_vorgabe = [old_sigset_name]
    (liste_ergebnis, status) = wp_screen_gui.eingabe_n_zeilen(rd.gui, liste_abfrage,
                                                              liste_vorgabe=liste_vorgabe, title=title)

    if (status != hdef.OKAY) or (liste_ergebnis == []):
        return

    text = liste_ergebnis[0]
    # entfernt Leerzeichen, Tabulator (\t), Zeilenumbrüche (\n), geschützte Leerzeichen (\xa0)
    sigset = "".join(text.split()).replace(" ", "")

    if sigset != rd.sig["sigset_liste"][index]:

        wp_screen_sigset.rename_sigset_sigset_dict(rd, old_sigset_name, sigset)

        if wp_screen_sigset.get_status() != hdef.OKAY:
            STATUS = wp_screen_sigset.get_status()
            ERRTEXT = wp_screen_sigset.get_errtext()
            wp_screen_sigset.reset_status()
            return

    # end if
    return
# end def
def sigset_copy(rd, index):

    sigset = rd.sig["sigset_liste"][index]
    liste_abfrage = ["newsigsetname"]
    liste_vorgabe = [sigset]
    title = "Copy Sigset-Name "
    (liste_ergebnis, status) = wp_screen_gui.eingabe_n_zeilen(rd.gui, liste_abfrage,
                                                              liste_vorgabe=liste_vorgabe, title=title)
    if (status != hdef.OKAY) or (liste_ergebnis == []):
        return None

    text = liste_ergebnis[0]
    # entfernt Leerzeichen, Tabulator (\t), Zeilenumbrüche (\n), geschützte Leerzeichen (\xa0)
    sigset_new = "".join(text.split()).replace(" ", "")

    if sigset_new in rd.sig["sigset_liste"]:
        t = f"copyname: {sigset_new}  ist bereits in Liste {rd.sig["sigset_liste"]} "
        rd.log.write_err(t, screen=rd.par.LOG_SCREEN_OUT)
        sgui.anzeige_text(t, textcolor='red')
    else:
        wp_screen_sigset.copy_sigset_sigset_dict(rd, sigset, sigset_new)
    # end if

# end def
def sigset_edit_command(rd, index):

    global STATUS,ERRTEXT

    rd.sig["sigset"] = rd.sig["sigset_liste"][index]

    wp_screen_sigset.sigset_dict_read(rd)

    if wp_screen_sigset.get_status() != hdef.OKAY:
        STATUS = wp_screen_sigset.get_status()
        ERRTEXT = wp_screen_sigset.get_errtext()
        wp_screen_sigset.reset_status()
        return
    # end if

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

            sigset_edit_modify(rd,index)
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
def sigset_edit_modify(rd,index):
    """

    :param rd:
    :return:
    """

    global STATUS, ERRTEXT

    rd.sig["sigset"] = rd.sig["sigset_liste"][index]

    wp_screen_sigset.sigset_dict_read(rd)

    if wp_screen_sigset.get_status() != hdef.OKAY:
        STATUS = wp_screen_sigset.get_status()
        ERRTEXT = wp_screen_sigset.get_errtext()
        wp_screen_sigset.reset_status()
        return
    # end if

    dict_mod = wp_screen_gui.sigset_dict_modify(rd.gui,
                                                   rd.sig["sigset"],
                                                   rd.sig["sigset_dict"],)
    wp_screen_sigset.modify_dict(rd, dict_mod)

    if wp_screen_sigset.get_status() != hdef.OKAY:
        STATUS = wp_screen_sigset.get_status()
        ERRTEXT = wp_screen_sigset.get_errtext() + wp_screen_sigset.get_infotext()
        wp_screen_gui.janein_abfrage(rd.gui, f"Fehler in sigset {ERRTEXT = }", "")
        wp_screen_sigset.reset_status()
        return
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


    wp_screen_gui.anzeige_text(rd.gui, infotext, "Hilfe syntax sigset")
    return
# def get_sigset_auswahl(rd):
#
#     wp_screen_sigset.sigset_set(rd)
#
#     if wp_screen_sigset.get_status() != hdef.OKAY:
#         global STATUS, ERRTEXT
#         STATUS = wp_screen_sigset.get_status()
#         ERRTEXT = wp_screen_sigset.get_errtext()
#         wp_screen_sigset.reset_status()
#         return None
#     # end if
#
#
#     abfrage_liste = ["select", "show", "rename","copy", "modify","ende"]
#
#     i_select = 0
#     i_show = 1
#     i_rename = 2
#     i_copy = 3
#     i_modify = 4
#     i_ende = 5
#
#     while True:
#         (index, indexAbfrage) = wp_screen_gui.listen_abfrage(rd.gui,
#                                                              rd.sig["sigset_liste"],
#                                                              auswahl_title="Auswahl Siganl-Set",
#                                                              abfrage_liste=abfrage_liste)
#         if (index < 0) or (indexAbfrage == i_ende):
#             return None
#         elif indexAbfrage == i_select:
#
#             if index >= 0:
#                 sigset = rd.sig["sigset_liste"][index]
#                 return sigset
#             # end if
#         elif indexAbfrage == i_show:
#             if index >= 0:
#                 sigset = rd.sig["sigset_liste"][index]
#                 sigset_dict = wp_screen_sigset.get_sigset_dict(rd, sigset)
#                 texteingabe = json.dumps(sigset_dict, indent=2)
#                 wp_screen_gui.anzeige_text(rd.gui, texteingabe, title=None, textcolor='black')
#             # end if
#         elif indexAbfrage == i_rename:
#             if index >= 0:
#                 sigset = rd.sig["sigset_liste"][index]
#                 liste_abfrage = ["newsigsetname"]
#                 liste_vorgabe = [sigset]
#                 title = "Rename Sigset-Name "
#                 (liste_ergebnis, status) = wp_screen_gui.eingabe_n_zeilen(rd.gui, liste_abfrage,
#                                                                           liste_vorgabe=liste_vorgabe, title=title)
#                 if (status != hdef.OKAY) or (liste_ergebnis == []):
#                     return None
#
#                 text = liste_ergebnis[0]
#                 # entfernt Leerzeichen, Tabulator (\t), Zeilenumbrüche (\n), geschützte Leerzeichen (\xa0)
#                 sigset_new = "".join(text.split()).replace(" ", "")
#
#                 if sigset_new in rd.sig["sigset_liste"]:
#                     t = f"rename: {sigset_new}  ist bereits in Liste {rd.kat["katalog_liste"]} "
#                     rd.log.write_err(t, screen=rd.par.LOG_SCREEN_OUT)
#                     sgui.anzeige_text(t, textcolor='red')
#                 else:
#                     wp_screen_sigset.rename_sigset_sigset_dict(rd, sigset, sigset_new)
#                 # end if
#             # end if
#         elif indexAbfrage == i_copy:
#             if index >= 0:
#                 sigset = rd.sig["sigset_liste"][index]
#                 liste_abfrage = ["newsigsetname"]
#                 liste_vorgabe = [sigset]
#                 title = "Copy Sigset-Name "
#                 (liste_ergebnis, status) = wp_screen_gui.eingabe_n_zeilen(rd.gui, liste_abfrage,
#                                                                           liste_vorgabe=liste_vorgabe, title=title)
#                 if (status != hdef.OKAY) or (liste_ergebnis == []):
#                     return None
#
#                 text = liste_ergebnis[0]
#                 # entfernt Leerzeichen, Tabulator (\t), Zeilenumbrüche (\n), geschützte Leerzeichen (\xa0)
#                 sigset_new = "".join(text.split()).replace(" ", "")
#
#                 if sigset_new in rd.sig["sigset_liste"]:
#                     t = f"copyname: {sigset_new}  ist bereits in Liste {rd.kat["katalog_liste"]} "
#                     rd.log.write_err(t, screen=rd.par.LOG_SCREEN_OUT)
#                     sgui.anzeige_text(t, textcolor='red')
#                 else:
#                     wp_screen_sigset.copy_sigset_sigset_dict(rd, sigset, sigset_new)
#                 # end if
#             # end if
#         else: # i_modify
#             if index >= 0:
#                 rd.sig["sigset"] = rd.sig["sigset_liste"][index]
#                 wp_screen_sigset.sigset_dict_read(rd)
#                 if wp_screen_sigset.get_status() != hdef.OKAY:
#
#                     STATUS = wp_screen_sigset.get_status()
#                     ERRTEXT = wp_screen_sigset.get_errtext()
#                     wp_screen_sigset.reset_status()
#                     return None
#                 # end if
#
#                 sigset_edit_modify(rd)
#                 if get_status() != hdef.OKAY:
#                     return None
#                 # end if
#             # end if
#
#         # end if
#     # end while
# # end def
