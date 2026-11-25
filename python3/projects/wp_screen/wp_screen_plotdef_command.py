
import os, sys, copy
import json

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import wp_screen.wp_screen_gui as wp_screen_gui
import wp_screen.wp_screen_plotdef as wp_screen_plotdef
import wp_screen.wp_screen_plotdef_check as wp_screen_plotdef_check

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
def plotdef_command(rd,flagselect=False):


    auswahl_title = "Plotdef-Namen editieren"
    if flagselect:
        abfrage_liste = ["select","edit(plotdef)","modify","add", "delete", "rename","copy","hilfe","ende"]
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
        abfrage_liste = ["edit(plotdef)","modify","add", "delete", "rename","copy","hilfe","ende"]
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

        auswahl_liste = rd.plot["plotdef_liste"]
        n_auswahl_liste = len(auswahl_liste)

        (index, indexAbfrage) = wp_screen_gui.listen_abfrage(rd.gui, auswahl_liste, auswahl_title, abfrage_liste)

        if (indexAbfrage < 0) or (indexAbfrage == i_ende):

            runflag = False

        elif indexAbfrage == i_select:

            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("plotdef_command select: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                plotdef = rd.plot["plotdef_liste"][index]
                return plotdef
            # end if

        elif indexAbfrage == i_edit:

            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("plotdef_command edit: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                plotdef_edit_command(rd, index)
                if get_status() != hdef.OKAY:
                    runflag = False
            # end if
        elif indexAbfrage == i_modify:

            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("plotdef_command modify: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                plotdef_edit_modify(rd,index)
                if get_status() != hdef.OKAY:
                    return None
                # end if
            # end if

        elif indexAbfrage == i_add:

            plotdef_add(rd)

        elif indexAbfrage == i_delete:

            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("plotdef_command delete: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                plotdef_del(rd, index)
            # end if

        elif indexAbfrage == i_rename:

            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("plotdef_command rename: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                plotdef_rename(rd, index)
            # end if

        elif indexAbfrage == i_copy:

            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("plotdef_command copy: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                plotdef_copy(rd, index)
            # end if

        else: # index_abfrage == i_hilfe

            plotdef_edit_hilfe(rd)
    # end while
    return None
# end def
def plotdef_add(rd):
    """

    :param rd:
    :return: plotdef_add(rd)
    """

    plotdefname = None
    while plotdefname is None:
        liste_abfrage = ["plotdefname"]
        title = "neuem Plotdef-Set-Name eingeben"
        (liste_ergebnis, status) = wp_screen_gui.eingabe_n_zeilen(rd.gui, liste_abfrage,
                                                                  liste_vorgabe=None, title=title)

        if (status != hdef.OKAY) or (liste_ergebnis == []):
            return

        text = liste_ergebnis[0]

        plotdefname = wp_screen_plotdef.add_plotdef_name(rd,text)

    return
# end def
def plotdef_del(rd,index):
    """
    :param rd:

    :param index:
    :return: return
    """
    flag = wp_screen_gui.janein_abfrage(rd.gui, f"Soll wirklich das Element {index = } name = \"{rd.plot["plotdef_liste"][index]}\" gelöscht werden?",
                                    "Löschen ja/nein")
    if flag:
        del rd.plot["plotdef_liste"][index]
        rd.plot["plotdef_liste_jsonobj"].save(rd.plot["plotdef_liste"])
    # end if


    return
# end def
def plotdef_rename(rd, index):

    global STATUS, ERRTEXT

    plotdef_old = rd.plot["plotdef_liste"][index]
    liste_abfrage = ["plotdefname"]
    title = "Umbenennen Plotdef-Set-Name "
    liste_vorgabe = [plotdef_old]
    (liste_ergebnis, status) = wp_screen_gui.eingabe_n_zeilen(rd.gui, liste_abfrage,
                                                              liste_vorgabe=liste_vorgabe, title=title)

    if (status != hdef.OKAY) or (liste_ergebnis == []):
        return

    text = liste_ergebnis[0]
    # entfernt Leerzeichen, Tabulator (\t), Zeilenumbrüche (\n), geschützte Leerzeichen (\xa0)
    plotdef = "".join(text.split()).replace(" ", "")

    if plotdef != rd.plot["plotdef_liste"][index]:

        wp_screen_plotdef.rename_plotdef_plotdef_dict(rd,plotdef_old, plotdef)
        if wp_screen_plotdef.get_status() != hdef.OKAY:
            STATUS = wp_screen_plotdef.get_status()
            ERRTEXT = wp_screen_plotdef.get_errtext()
            wp_screen_plotdef.reset_status()
            return
        # end if

    # end if
    return
# end def
def plotdef_copy(rd, index):

    plotdef_old = rd.plot["plotdef_liste"][index]
    liste_abfrage = ["newplotdefname"]
    liste_vorgabe = [plotdef_old]
    title = "Copy Plotdef-Name "
    (liste_ergebnis, status) = wp_screen_gui.eingabe_n_zeilen(rd.gui, liste_abfrage,
                                                              liste_vorgabe=liste_vorgabe, title=title)
    if (status != hdef.OKAY) or (liste_ergebnis == []):
        return None

    text = liste_ergebnis[0]
    # entfernt Leerzeichen, Tabulator (\t), Zeilenumbrüche (\n), geschützte Leerzeichen (\xa0)
    plotdef_new = "".join(text.split()).replace(" ", "")

    if plotdef_new in rd.plot["plotdef_liste"]:
        t = f"copyname: {plotdef_new}  ist bereits in Liste {rd.plot["plotdef_liste"]} "
        rd.log.write_err(t, screen=rd.par.LOG_SCREEN_OUT)
        sgui.anzeige_text(t, textcolor='red')
    else:
        wp_screen_plotdef.copy_plotdef_plotdef_dict(rd, plotdef_old, plotdef_new)


    # end if

# end def

def plotdef_edit_command(rd, index):

    global STATUS, ERRTEXT

    rd.plot["plotdef"] = rd.plot["plotdef_liste"][index]

    wp_screen_plotdef.plotdef_dict_read(rd)
    if wp_screen_plotdef.get_status() != hdef.OKAY:
        STATUS = wp_screen_plotdef.get_status()
        ERRTEXT = wp_screen_plotdef.get_errtext()
        wp_screen_plotdef.reset_status()
        return
    # end if


    abfrage_liste = ["update(value)","modiy(dict)", "add(var)", "delete(var)","hilfe","end"]

    title = f"plotdef: \"{rd.plot["plotdef"]}\"; dictionary der Plotdefzuordnung key => Signalname value => Vorschrift"

    index_update = 0
    index_modify = 1
    index_add = 2
    index_delete = 3
    # index_hilfe = 4
    index_end = 5


    runflag = True
    while (runflag):

        ddict = rd.plot["plotdef_dict"]

        if len(ddict.keys()) == 0:
            ddict["leer"]="0"

        (ddict_mod, changed_key_liste,index_abfrage) = wp_screen_gui.plotdef_dict_abfrage(rd.gui, rd.plot["plotdef_dict"],
                                                                              title=title,
                                                                              abfrage_liste=abfrage_liste)
        if (wp_screen_gui.get_status() != hdef.OK):

            STATUS = wp_screen_gui.get_status()
            ERRTEXT = wp_screen_gui.get_errtext()
            wp_screen_gui.reset_status()
            return
        # end if

        if (len(ddict_mod.keys()) == 1) and ("leer" in ddict_mod.keys()):
            ddict_mod = rd.plot["plotdef_dict"]
            changed_key_liste = []
        # end if

        # Beenden
        # ----------------------------
        if (index_abfrage == -1) or (index_abfrage == index_end):

            runflag = False
        elif (index_abfrage == -1) or (index_abfrage == index_update):

            if len(changed_key_liste) > 0:
                plotdef_edit_update(rd, ddict_mod,changed_key_liste)
                if get_status() != hdef.OKAY:
                    return
                # end if
            # end if
        elif index_abfrage == index_modify:

            plotdef_edit_modify(rd,index)
            if get_status() != hdef.OKAY:
                return
            # end if
        elif index_abfrage == index_add:

            plotdef_edit_add(rd)
            if get_status() != hdef.OKAY:
                return
            # end if
        elif index_abfrage == index_delete:

            plotdef_edit_delete(rd)
        else: # index_abfrage == index_hilfe
            plotdef_edit_hilfe(rd)

    # end while
    return
# end def
def plotdef_edit_update(rd, ddict_mod,changed_key_liste):
    global STATUS, ERRTEXT, INFOTEXT
    # Check modified dictionary
    wp_screen_plotdef_check.check(rd,ddict_mod)
    if wp_screen_plotdef_check.get_status() != hdef.OKAY:

        STATUS = wp_screen_plotdef_check.get_status()
        INFOTEXT = wp_screen_plotdef_check.get_infotext()
        ERRTEXT = wp_screen_plotdef_check.get_errtext()
        wp_screen_plotdef_check.reset_status()
        return
    # end if

    if STATUS != hdef.OKAY:
        wp_screen_gui.janein_abfrage(rd.gui,f"Fehler in plotdef {INFOTEXT = }","")
        return
    else:

        rd.plot["plotdef_dict"] = ddict_mod
        rd.plot["plotdef_dict_jsonobj"].save(rd.plot["plotdef_dict"])
        if rd.plot["plotdef_dict_jsonobj"].get_status() != hdef.OKAY:
            STATUS = rd.plot["plotdef_dict_jsonobj"].get_status()
            ERRTEXT = rd.plot["plotdef_dict_jsonobj"].get_errtext()
            rd.plot["plotdef_dict_jsonobj"].reset_status()
            return
        # end if
    # end if

    return
# end def
def plotdef_edit_modify(rd,index):
    """

    :param rd:
    :return:
    """

    global INFOTEXT, STATUS, ERRTEXT

    rd.plot["plotdef"] = rd.plot["plotdef_liste"][index]

    wp_screen_plotdef.plotdef_dict_read(rd)

    dict_mod = wp_screen_gui.plotdef_dict_modify(rd.gui,
                                                   rd.plot["plotdef"],
                                                   rd.plot["plotdef_dict"],)

    # Check modified dictionary
    wp_screen_plotdef_check.check(rd,dict_mod)

    if wp_screen_plotdef_check.get_status() != hdef.OKAY:

        STATUS = wp_screen_plotdef_check.get_status()
        ERRTEXT = wp_screen_plotdef_check.get_errtext()
        INFOTEXT = wp_screen_plotdef_check.get_infotext()
        wp_screen_gui.anzeige_text(rd.gui, f"Fehler in plotdef {INFOTEXT = }", title="", textcolor='red')
        wp_screen_plotdef_check.reset_status()
        return
    # end if

    rd.plot["plotdef_dict"] = dict_mod
    rd.plot["plotdef_dict_jsonobj"].save(rd.plot["plotdef_dict"])
    if rd.plot["plotdef_dict_jsonobj"].get_status() != hdef.OKAY:
        STATUS = rd.plot["plotdef_dict_jsonobj"].get_status()
        ERRTEXT = rd.plot["plotdef_dict_jsonobj"].get_errtext()
        rd.plot["plotdef_dict_jsonobj"].reset_status()
        return
    # end if
    return
# end def
def plotdef_edit_add(rd):
    """

    :param rd:
    :return: return
    """
    liste_abfrage = ["plotdefname=key"]
    title = f"neuer Plotdefname eingeben für plotdef = {rd.plot["plotdef"]}"
    (liste_ergebnis, status) = wp_screen_gui.eingabe_n_zeilen(rd.gui, liste_abfrage,
                                                              liste_vorgabe=None, title=title)

    if (status != hdef.OKAY) or (liste_ergebnis == []):
        return

    text = liste_ergebnis[0]
    # entfernt Leerzeichen, Tabulator (\t), Zeilenumbrüche (\n), geschützte Leerzeichen (\xa0)
    plotdefname = "".join(text.split()).replace(" ", "")

    rd.plot["plotdef_dict"][plotdefname] = "0"

    rd.plot["plotdef_dict_jsonobj"].save(rd.plot["plotdef_dict"])
    if rd.plot["plotdef_dict_jsonobj"].get_status() != hdef.OKAY:
        global STATUS, ERRTEXT
        STATUS = rd.plot["plotdef_dict_jsonobj"].get_status()
        ERRTEXT = rd.plot["plotdef_dict_jsonobj"].get_errtext()
        rd.plot["plotdef_dict_jsonobj"].reset_status()
        return
    # end if

    return
# end def
def plotdef_edit_delete(rd):
    """

    :param rd:
    :return: return
    """
    global STATUS, ERRTEXT, INFOTEXT

    auswahl_liste = list(rd.plot["plotdef_dict"].keys())
    auswahl_title = "wähle ein Plotdefnamen aus"
    (index, indexAbfrage) = wp_screen_gui.listen_abfrage(rd.gui, auswahl_liste, auswahl_title)

    if indexAbfrage == -1:
        return
    else:
        dict_mod = copy.copy(rd.plot["plotdef_dict"])
        plodefname = auswahl_liste[index]

        del dict_mod[plodefname]

        # Check modified dictionary
        wp_screen_plotdef_check.check(rd,dict_mod)

        if wp_screen_plotdef_check.get_status() != hdef.OKAY:
            STATUS = wp_screen_plotdef_check.get_status()
            ERRTEXT = wp_screen_plotdef_check.get_errtext()
            INFOTEXT = wp_screen_plotdef_check.get_infotext()
            wp_screen_gui.anzeige_text(rd.gui, f"Fehler in plotdef {INFOTEXT = }", title="", textcolor='red')
            wp_screen_plotdef_check.reset_status()
            return
        # end if

        rd.plot["plotdef_dict"] = dict_mod
        rd.plot["plotdef_dict_jsonobj"].save(rd.plot["plotdef_dict"])
        if rd.plot["plotdef_dict_jsonobj"].get_status() != hdef.OKAY:
            STATUS = rd.plot["plotdef_dict_jsonobj"].get_status()
            ERRTEXT = rd.plot["plotdef_dict_jsonobj"].get_errtext()
            rd.plot["plotdef_dict_jsonobj"].reset_status()
            return
        # end if
    # end if
    return
# end def
# def get_plotdef_auswahl(rd):
#
#     wp_screen_plotdef.plotdef_set(rd)
#
#     if wp_screen_plotdef.get_status() != hdef.OKAY:
#         global STATUS, ERRTEXT
#         STATUS = wp_screen_plotdef.get_status()
#         ERRTEXT = wp_screen_plotdef.get_errtext()
#         wp_screen_plotdef.reset_status()
#         return None
#     # end if
#
#     abfrage_liste = ["select", "show", "ende"]
#
#     while True:
#
#         (index, indexAbfrage) = wp_screen_gui.listen_abfrage(rd.gui,
#                                                              rd.plot["plotdef_liste"],
#                                                              auswahl_title="Auswahl Plotdef-Set",
#                                                              abfrage_liste=abfrage_liste)
#
#         if (index < 0) or (indexAbfrage == 2):
#             return None
#         elif indexAbfrage == 0:
#             if index >= 0:
#                 plotdef = rd.plot["plotdef_liste"][index]
#                 return plotdef
#             # end if
#         else:
#             if index >= 0:
#                 plotdef = rd.plot["plotdef_liste"][index]
#                 plotdef_dict = wp_screen_plotdef.get_plotdef_dict(rd, plotdef)
#                 texteingabe = json.dumps(plotdef_dict, indent=2)
#                 wp_screen_gui.anzeige_text(rd.gui, texteingabe, title=None, textcolor='black')
#             # end if
#         # end if
#     # end while
#
#
# # end def

def plotdef_edit_hilfe(rd):
    """

    :param rd:
    :return:
    """
    infotext = wp_screen_plotdef_check.hilfe(rd)


    wp_screen_gui.anzeige_text(rd.gui, infotext, "Hilfe syntax plotdef")
    return
