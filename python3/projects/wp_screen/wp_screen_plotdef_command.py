
import os, sys, copy

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import wp_screen_gui
import wp_screen_plotdef
import wp_screen_plotdef_check

import tools.hfkt_def as hdef
# import tools.hfkt_pickle as hfkt_pickle
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
def plotdef_command(rd):


    auswahl_title = "Plotdef-Namen editieren"
    abfrage_liste = ["edit(plotdef)","add", "delete", "rename","ende"]
    i_edit = 0
    i_add = 1
    i_delete = 2
    i_rename = 3
    i_ende = 4

    runflag = True

    while runflag:

        auswahl_liste = rd.plot["plotdef_liste"]
        n_auswahl_liste = len(auswahl_liste)

        (index, indexAbfrage) = wp_screen_gui.listen_abfrage(rd.gui, auswahl_liste, auswahl_title, abfrage_liste)

        if (indexAbfrage < 0) or (indexAbfrage == i_ende):
            runflag = False
        elif indexAbfrage == i_edit:
            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("plotdef_command edit: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                plotdef_edit_command(rd, index)
                if get_status() != hdef.OKAY:
                    runflag = False
            # end if
        elif indexAbfrage == i_add:
            plotdef_add(rd)
        elif indexAbfrage == i_delete:
            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("plotdef_command delete: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                plotdef_del(rd, index)
            # end if
        else:  # if indexAbfrage == i_rename:
            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("plotdef_command rename: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                plotdef_rename(rd, index)
            # end if
    # end while
    return
# end def
def plotdef_add(rd):
    """

    :param rd:
    :return: plotdef_add(rd)
    """

    liste_abfrage = ["plotdefname"]
    title = "neuem Plotdef-Set-Name eingeben"
    (liste_ergebnis, status) = wp_screen_gui.eingabe_n_zeilen(rd.gui, liste_abfrage,
                                                              liste_vorgabe=None, title=title)

    if (status != hdef.OKAY) or (liste_ergebnis == []):
        return

    text = liste_ergebnis[0]
    # entfernt Leerzeichen, Tabulator (\t), Zeilenumbrüche (\n), geschützte Leerzeichen (\xa0)
    plotdefname = "".join(text.split()).replace(" ", "")

    if plotdefname not in rd.plot["plotdef_liste"]:
        rd.log.write_info(f"{plotdefname = } wurde der plotdef_liste hinzugefügt")
    else:
        rd.log.write_info(f"{plotdefname = } gibt es schon in Liste")
        return
    # end if

    rd.plot["plotdef_liste"].append(plotdefname)

    rd.plot["plotdef_liste_jsonobj"].save(rd.plot["plotdef_liste"])

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

    liste_abfrage = ["plotdefname"]
    title = "Umbenennen Plotdef-Set-Name "
    liste_vorgabe = [rd.plot["plotdef_liste"][index]]
    (liste_ergebnis, status) = wp_screen_gui.eingabe_n_zeilen(rd.gui, liste_abfrage,
                                                              liste_vorgabe=liste_vorgabe, title=title)

    if (status != hdef.OKAY) or (liste_ergebnis == []):
        return

    text = liste_ergebnis[0]
    # entfernt Leerzeichen, Tabulator (\t), Zeilenumbrüche (\n), geschützte Leerzeichen (\xa0)
    plotdef = "".join(text.split()).replace(" ", "")

    if plotdef != rd.plot["plotdef_liste"][index]:
        rd.plot["plotdef_liste"][index] = plotdef
        rd.plot["plotdef_liste_jsonobj"].save(rd.plot["plotdef_liste"])
    # end if
    return
# end def
def plotdef_edit_command(rd, index):

    rd.plot["plotdef"] = rd.plot["plotdef_liste"][index]

    wp_screen_plotdef.plot_dict_read(rd)

    if get_status() != hdef.OKAY:
        return


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
            global STATUS, ERRTEXT
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

            plotdef_edit_modify(rd)
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
    global STATUS, ERRTEXT
    # Check modified dictionary
    (okay,infotext) = wp_screen_plotdef_check.check(rd,ddict_mod)
    if wp_screen_plotdef_check.get_status() != hdef.OKAY:

        STATUS = wp_screen_plotdef_check.get_status()
        ERRTEXT = wp_screen_plotdef_check.get_errtext()
        wp_screen_plotdef_check.reset_status()
        return
    # end if

    if okay != hdef.OKAY:
        wp_screen_gui.janein_abfrage(rd.gui,f"Fehler in plotdef {infotext = }","")
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
def plotdef_edit_modify(rd):
    """

    :param rd:
    :return:
    """
    dict_mod = wp_screen_gui.plotdef_dict_modify(rd.gui,
                                                   rd.plot["plotdef"],
                                                   rd.plot["plotdef_dict"],)

    # Check modified dictionary
    (okay,infotext) = wp_screen_plotdef_check.check(rd,dict_mod)

    if okay != hdef.OKAY:
        wp_screen_gui.janein_abfrage(rd.gui,f"Fehler in plotdef {infotext = }","")
        return
    else:

        rd.plot["plotdef_dict"] = dict_mod
        rd.plot["plotdef_dict_jsonobj"].save(rd.plot["plotdef_dict"])
        if rd.plot["plotdef_dict_jsonobj"].get_status() != hdef.OKAY:
            global STATUS, ERRTEXT
            STATUS = rd.plot["plotdef_dict_jsonobj"].get_status()
            ERRTEXT = rd.plot["plotdef_dict_jsonobj"].get_errtext()
            rd.plot["plotdef_dict_jsonobj"].reset_status()
            return
        # end if
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
        (okay,infotext) = wp_screen_plotdef_check.check(rd,dict_mod)

        if okay != hdef.OKAY:
            wp_screen_gui.janein_abfrage(rd.gui,f"Fehler in plodef {infotext = }","")
            return
        else:

            rd.plot["plotdef_dict"] = dict_mod
            rd.plot["plotdef_dict_jsonobj"].save(rd.plot["plotdef_dict"])
            if rd.plot["plotdef_dict_jsonobj"].get_status() != hdef.OKAY:
                global STATUS, ERRTEXT
                STATUS = rd.plot["plotdef_dict_jsonobj"].get_status()
                ERRTEXT = rd.plot["plotdef_dict_jsonobj"].get_errtext()
                rd.plot["plotdef_dict_jsonobj"].reset_status()
                return
            # end if
        # end if
    # end if
    return
# end def
def plotdef_edit_hilfe(rd):
    """

    :param rd:
    :return:
    """
    infotext = wp_screen_plotdef_check.hilfe(rd)


    wp_screen_gui.anzeige_text(rd.gui, infotext, "Hilfe syntax plotdef")
    return
