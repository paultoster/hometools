
import os, sys, copy

import hfkt_tvar

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import wp_screen_gui
import wp_screen_katalog
import wp_screen_sigset
import wp_screen_tab
import wp_screen_scre_build
import wp_screen_scre_tab

import tools.hfkt_def as hdef
import tools.hfkt_pickle as hfkt_pickle
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

def scre_set(rd):
    # Signalset-Liste Json-Liste einladen
    if rd.scre["scre_liste_jsonobj"] is None:

        rd.scre["scre_liste_filename"] = os.path.join(rd.ini["store_path"],
                                rd.ini["scre_liste_file_name"]+".json")

        rd.scre["scre_liste_jsonobj"] = hfkt_pickle.DataJson(rd.scre["scre_liste_filename"])
    # end if

    rd.scre["scre_liste"] = rd.scre["scre_liste_jsonobj"].read_and_get_data()

    if rd.scre["scre_liste_jsonobj"].get_status() == hdef.NOT_FOUND:
        rd.scre["scre_liste_jsonobj"].reset_status()
        rd.scre["scre_liste"] = []
    elif rd.scre["scre_liste_jsonobj"].get_status() != hdef.OKAY:
        rd.log.write_err(rd.scre["scre_liste_jsonobj"].get_errtext(), screen=rd.par.LOG_SCREEN_OUT)
        rd.scre["scre_liste_jsonobj"].reset_status()
        return
    # end if
    return
def scre_start(rd):

    scre_set(rd)
    if get_status() != hdef.OKAY:
        return
    # end if

    scre_command(rd)

    return
# end def
def scre_command(rd):


    auswahl_title = "Screen-Namen editieren"
    abfrage_liste = ["edit(values)","add", "delete", "rename","build","ende"]
    i_edit = 0
    i_add = 1
    i_delete = 2
    i_rename = 3
    i_build = 4
    i_ende = 5

    runflag = True

    while runflag:

        auswahl_liste = rd.scre["scre_liste"]
        n_auswahl_liste = len(auswahl_liste)

        (index, indexAbfrage) = wp_screen_gui.listen_abfrage(rd.gui, auswahl_liste, auswahl_title, abfrage_liste)

        if (indexAbfrage < 0) or (indexAbfrage == i_ende):
            runflag = False
        elif indexAbfrage == i_edit:
            if (index < 0) or (index >= n_auswahl_liste):
                t = "scre_command edit: index out of range or not set"
                rd.log.write_err(t, screen=rd.par.LOG_SCREEN_OUT)
                sgui.anzeige_text(t, textcolor='orange')
            else:
                scre_edit_command(rd, index)
                if get_status() != hdef.OKAY:
                    runflag = False
            # end if
        elif indexAbfrage == i_add:
            scre_add(rd)
        elif indexAbfrage == i_delete:
            if (index < 0) or (index >= n_auswahl_liste):
                t = "scre_command delete: index out of range or not set"
                rd.log.write_err(t, screen=rd.par.LOG_SCREEN_OUT)
                sgui.anzeige_text(t, textcolor='orange')
            else:
                scre_del(rd, index)
            # end if
        elif indexAbfrage == i_rename:
            if (index < 0) or (index >= n_auswahl_liste):
                t = "scre_command rename: index out of range or not set"
                rd.log.write_err(t, screen=rd.par.LOG_SCREEN_OUT)
                sgui.anzeige_text(t, textcolor='orange')
            else:
                scre_rename(rd, index)
            # end if
        else: # indexAbfrage == i_build:

            if (index < 0) or (index >= n_auswahl_liste):
                t = "scre_command build: index out of range or not set"
                rd.log.write_err(t, screen=rd.par.LOG_SCREEN_OUT)
                sgui.anzeige_text(t, textcolor='orange')
            else:

                scre_show_screen(rd,index)

                if STATUS != hdef.OKAY:
                    t = f"scre_command build: Error in scre_show_screen \n errtext = {ERRTEXT}"
                    rd.log.write_err(t, screen=rd.par.LOG_SCREEN_OUT)
                    sgui.anzeige_text(t, textcolor='red')
                    runflag = True
                else:
                    runflag = False
                # end if

    # end while
    return
# end def
def scre_add(rd):
    """

    :param rd:
    :return: scre_add(rd)
    """

    liste_abfrage = ["screname"]
    title = "neuem Screen-Name eingeben"
    (liste_ergebnis, status) = wp_screen_gui.eingabe_n_zeilen(rd.gui, liste_abfrage,
                                                              liste_vorgabe=None, title=title)

    if (status != hdef.OKAY) or (liste_ergebnis == []):
        return

    text = liste_ergebnis[0]
    # entfernt Leerzeichen, Tabulator (\t), Zeilenumbrüche (\n), geschützte Leerzeichen (\xa0)
    screname = "".join(text.split()).replace(" ", "")

    if screname not in rd.scre["scre_liste"]:
        rd.log.write_info(f"{screname = } wurde der scre_liste hinzugefügt")
    else:
        rd.log.write_info(f"{screname = } gibt es schon in Liste")
        return
    # end if

    rd.scre["scre_liste"].append(screname)

    rd.scre["scre_liste_jsonobj"].save(rd.scre["scre_liste"])

    return
# end def
def scre_del(rd,index):
    """
    :param rd:

    :param index:
    :return: return
    """
    flag = wp_screen_gui.janein_abfrage(rd.gui, f"Soll wirklich das Element {index = } name = \"{rd.scre["scre_liste"][index]}\" gelöscht werden?",
                                    "Löschen ja/nein")
    if flag:
        del rd.scre["scre_liste"][index]
        rd.scre["scre_liste_jsonobj"].save(rd.scre["scre_liste"])
    # end if


    return
# end def
def scre_rename(rd, index):

    liste_abfrage = ["screname"]
    title = "Umbenennen Screen-Name "
    liste_vorgabe = [rd.scre["scre_liste"][index]]
    (liste_ergebnis, status) = wp_screen_gui.eingabe_n_zeilen(rd.gui, liste_abfrage,
                                                              liste_vorgabe=liste_vorgabe, title=title)

    if (status != hdef.OKAY) or (liste_ergebnis == []):
        return

    text = liste_ergebnis[0]
    # entfernt Leerzeichen, Tabulator (\t), Zeilenumbrüche (\n), geschützte Leerzeichen (\xa0)
    scre = "".join(text.split()).replace(" ", "")

    if scre != rd.scre["scre_liste"][index]:
        rd.scre["scre_liste"][index] = scre
        rd.scre["scre_liste_jsonobj"].save(rd.scre["scre_liste"])
    # end if
    return
# end def
def scre_edit_command(rd, index):

    global STATUS, ERRTEXT, INFOTEXT
    rd.scre["scre"] = rd.scre["scre_liste"][index]

    scre_dict_read(rd)

    if get_status() != hdef.OKAY:
        return


    abfrage_liste = ["katalog","sigset", "tab","end"]

    title = f"scre: \"{rd.scre["scre"]}\"; Ändere katalog, signalset, tabelle"

    index_katalog = 0
    index_sigset  = 1
    index_tab     = 2
    index_end     = 3


    runflag = True
    while (runflag):

        ddict = copy.copy(rd.scre["scre_dict"])

        (ddict_mod, changed_key_liste,index_abfrage) = wp_screen_gui.scre_dict_abfrage(rd.gui, ddict,
                                                                              title=title,
                                                                              abfrage_liste=abfrage_liste)

        if (wp_screen_gui.get_status() != hdef.OK):
            global STATUS, ERRTEXT
            STATUS = wp_screen_gui.get_status()
            ERRTEXT = wp_screen_gui.get_errtext()
            wp_screen_gui.reset_status()
            return
        # end if


        if len(changed_key_liste) > 0:

            if scre_check_changes(rd, ddict_mod):
                rd.scre["scre_dict"] = ddict_mod
                scre_dict_save(rd)
                if STATUS != hdef.OKAY:
                    return
                # end if
            else:
                t = f"Info scre_update_changes(rd,ddict_mod): {INFOTEXT}"
                sgui.anzeige_text(t, textcolor='orange')
                rd.log.write_info(t, screen=rd.par.LOG_SCREEN_OUT)
                reset_status()
            # end if

        # end if


        # Beenden
        # ----------------------------
        if (index_abfrage == -1) or (index_abfrage == index_end):

            runflag = False
        elif (index_abfrage == index_katalog):


            katalog = wp_screen_katalog.get_katalog_auswahl(rd)

            if katalog != None:
                rd.scre["scre_dict"][rd.par.SCRE_KATALOG] = katalog
                scre_dict_save(rd)
                if STATUS != hdef.OKAY:
                    return
                # end if
            # end if
        elif index_abfrage == index_sigset:

            sigset = wp_screen_sigset.get_sigset_auswahl(rd)

            if sigset != None:
                rd.scre["scre_dict"][rd.par.SCRE_SIGSET] = sigset
                scre_dict_save(rd)
                if STATUS != hdef.OKAY:
                    return
                # end if
            # end if
        elif index_abfrage == index_tab:

            tab = wp_screen_tab.get_tab_auswahl(rd)

            if tab != None:
                rd.scre["scre_dict"][rd.par.SCRE_TAB] = tab
                scre_dict_save(rd)
                if STATUS != hdef.OKAY:
                    return
                # end if
            # end if
        # end if
    # end while
    return
# end def
def scre_check_changes(rd, ddict):
    global INFOTEXT
    flag = True

    if (len(ddict[rd.par.SCRE_KATALOG])>0) and not wp_screen_katalog.exist_katalog(rd,ddict[rd.par.SCRE_KATALOG]):
        flag = False
        INFOTEXT = INFOTEXT + "\n" + f"katalog: {ddict[rd.par.SCRE_KATALOG]} gibt es nicht im Katalog-Set"
    # end if
    if (len(ddict[rd.par.SCRE_SIGSET])>0) and not wp_screen_sigset.exist_sigset(rd,ddict[rd.par.SCRE_SIGSET]):
        flag = False
        INFOTEXT = INFOTEXT + "\n" + f"sigset: {ddict[rd.par.SCRE_SIGSET]} gibt es nicht im Signal-Set"
    # end if
    if (len(ddict[rd.par.SCRE_TAB])>0) and not wp_screen_tab.exist_tab(rd,ddict[rd.par.SCRE_TAB]):
        flag = False
        INFOTEXT = INFOTEXT + "\n" + f"tab: {ddict[rd.par.SCRE_TAB]} gibt es nicht im Tabellen-Set"
    # end if
    return flag
# end def
def scre_dict_read(rd):
    """

    :param rd:
    :return: scre_dict_read(rd)
    """
    rd.scre["scre_dict_filename"] = os.path.join(rd.ini["store_path"],
                            rd.ini["scre_dict_pre_file_name"] + rd.scre["scre"] + ".json")

    if rd.scre["scre_dict_jsonobj"] is not None:
        del rd.scre["scre_dict_jsonobj"]
    # end if
    rd.scre["scre_dict_jsonobj"] = hfkt_pickle.DataJson(rd.scre["scre_dict_filename"])

    rd.scre["scre_dict"] = rd.scre["scre_dict_jsonobj"].read_and_get_data()

    if rd.scre["scre_dict_jsonobj"].get_status() == hdef.NOT_FOUND:
        rd.scre["scre_dict"] = {rd.par.SCRE_KATALOG:"",rd.par.SCRE_SIGSET:"",rd.par.SCRE_TAB:""}
        rd.scre["scre_dict_jsonobj"].reset_status()
    elif rd.scre["scre_dict_jsonobj"].get_status() != hdef.OKAY:
        rd.log.write_err(rd.scre["scre_dict_jsonobj"].get_errtext(), screen=rd.par.LOG_SCREEN_OUT)
        global STATUS, ERRTEXT
        STATUS = rd.scre["scre_dict_jsonobj"].get_status()
        ERRTEXT = rd.scre["scre_dict_jsonobj"].get_errtext()
        rd.scre["scre_dict_jsonobj"].reset_status()
        # end if
    return
# end def
def scre_dict_save(rd):
    global STATUS, ERRTEXT

    if rd.scre["scre_dict_jsonobj"] is None:
        rd.scre["scre_dict_jsonobj"] = hfkt_pickle.DataJson(rd.scre["scre_dict_filename"])
    # end if


    rd.scre["scre_dict_jsonobj"].save(rd.scre["scre_dict"])
    if rd.scre["scre_dict_jsonobj"].get_status() != hdef.OKAY:
        STATUS = rd.scre["scre_dict_jsonobj"].get_status()
        ERRTEXT = rd.scre["scre_dict_jsonobj"].get_errtext()
        rd.scre["scre_dict_jsonobj"].reset_status()
        return
    return
# end def
def scre_show_screen(rd,index):
    """
    :param rd:
    :param index:
    :return: scre_show_screen(rd,index)
    """
    global STATUS, ERRTEXT


    rd.scre["scre"] = rd.scre["scre_liste"][index]
    scre_dict_read(rd)
    if get_status() != hdef.OKAY:
        return

    scre_build(rd, rd.scre["scre_dict"])

    if STATUS != hdef.OKAY:
        ERRTEXT = f"scre_command build: Error in scre_build \n errtext = {ERRTEXT}"
        return
    # end if

    abfrage_liste = ["plot","ende"]
    index_plot = 0
    index_ende = 1

    runflag = True
    while runflag:

        (status,errtext,index, indexAbfrage) = wp_screen_gui.scre_sheet_show(rd.gui,
                                                              rd.scre["ttable"],
                                                              abfrage_liste,
                                                              rd.scre["color_dict_liste"],
                                                              f"Screen Gruppe: {rd.scre["scre"]}")

        if status != hdef.OKAY:
            STATUS = status
            ERRTEXT = errtext
            return
        # end if

        if (indexAbfrage < 0) or (indexAbfrage == index_ende):
            runflag = False
        else: # indexAbfrage == index_plot
            print( "plot")
            rundflag = True
        # end if
    # end while
    return
# end def
def scre_build(rd,scre_dict):

    global STATUS, ERRTEXT

    katalog = scre_dict[rd.par.SCRE_KATALOG]
    sigset = scre_dict[rd.par.SCRE_SIGSET]
    tab = scre_dict[rd.par.SCRE_TAB]

    isin_liste = wp_screen_katalog.get_katalog_isin_liste(rd,katalog)
    sigset_dict = wp_screen_sigset.get_sigset_dict(rd,sigset)
    tab_dict = wp_screen_tab.get_tab_dict(rd,tab)

    (status, infotext, sigset_werte_dict_liste) = wp_screen_sigset.get_sigset_werte_dict_liste(rd, sigset_dict)
    if status != hdef.OKAY:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = infotext
        return
    # end if

    # 1. Signale aus sigset bilden:
    #------------------------------
    # reset isin-dataclass dict (vielleicht richtig löschen, einzeln)
    rd.scre["scre_isin_dataclass_filename_dict"] = {}

    for isin in isin_liste:
        wp_screen_scre_build.scre_build_signal(rd,isin,sigset_dict,sigset_werte_dict_liste)
        if wp_screen_scre_build.get_status() != hdef.OKAY:
            STATUS = hdef.NOT_OKAY
            ERRTEXT = wp_screen_scre_build.get_errtext()
            return
        # end if
    # end for

    # 2. Tabelle bilden:
    #------------------------------
    #
    rd.scre["ttable"] = None
    rd.scre["color_dict_liste"] = []

    (status, infotext, tab_werte_dict_liste) = wp_screen_tab.get_tab_werte_dict_liste(rd, tab_dict)
    if status != hdef.OKAY:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = infotext
        return
    # end if

    (heade_list,type_list) = wp_screen_scre_tab.build_header_list_type_list(tab_dict,tab_werte_dict_liste)

    ttable = hfkt_tvar.build_table(heade_list, [], type_list)

    color_dict_liste = []
    for irow,isin in enumerate(isin_liste):

        (data_liste,color_dict) = wp_screen_scre_tab.scre_build_data(rd,irow,isin,tab_dict,tab_werte_dict_liste,type_list)
        if wp_screen_scre_tab.get_status() != hdef.OKAY:
            STATUS = hdef.NOT_OKAY
            ERRTEXT = wp_screen_scre_tab.get_errtext()
            return
        # end if

        ttable = hfkt_tvar.add_date_set_to_table(ttable,data_liste)
        if color_dict is not None:
            color_dict_liste.append(color_dict)
        # end if
    # end for

    rd.scre["ttable"] = ttable
    rd.scre["color_dict_liste"] = color_dict_liste
    return
# end def

