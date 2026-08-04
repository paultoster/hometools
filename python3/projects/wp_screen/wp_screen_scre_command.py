
import os, sys, copy


t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import wp_screen_gui
import wp_screen_katalog
import wp_screen_sigset
import wp_screen_tab
import wp_screen_scre_build_signal
import wp_screen_scre_build_fmttab
import wp_screen_scre

import tools.hfkt_def as hdef
import tools.hfkt_pickle as hfkt_pickle
import tools.sgui as sgui
import tools.hfkt_tvar as htvar
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

def scre_command(rd):

    wp_screen_scre.scre_set(rd)
    if get_status() != hdef.OKAY:
        return
    # end if

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
def scre_edit_command(rd, index):

    global STATUS, ERRTEXT, INFOTEXT
    rd.scre["scre"] = rd.scre["scre_liste"][index]

    wp_screen_scre.scre_dict_read(rd)

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

            if wp_screen_scre.scre_check_changes(rd, ddict_mod):
                rd.scre["scre_dict"] = ddict_mod
                wp_screen_scre.scre_dict_save(rd)
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
                wp_screen_scre.scre_dict_save(rd)
                if STATUS != hdef.OKAY:
                    return
                # end if
            # end if
        elif index_abfrage == index_sigset:

            sigset = wp_screen_sigset.get_sigset_auswahl(rd)

            if sigset != None:
                rd.scre["scre_dict"][rd.par.SCRE_SIGSET] = sigset
                wp_screen_scre.scre_dict_save(rd)
                if STATUS != hdef.OKAY:
                    return
                # end if
            # end if
        elif index_abfrage == index_tab:

            tab = wp_screen_tab.get_tab_auswahl(rd)

            if tab != None:
                rd.scre["scre_dict"][rd.par.SCRE_TAB] = tab
                wp_screen_scre.scre_dict_save(rd)
                if STATUS != hdef.OKAY:
                    return
                # end if
            # end if
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
def scre_show_screen(rd,index):
    """
    :param rd:
    :param index:
    :return: scre_show_screen(rd,index)
    """
    global STATUS, ERRTEXT


    rd.scre["scre"] = rd.scre["scre_liste"][index]
    wp_screen_scre.scre_dict_read(rd)
    if get_status() != hdef.OKAY:
        return

    # 1. build alll signals
    wp_screen_scre.scre_build_sigset(rd, rd.scre["scre_dict"])
    if wp_screen_scre.get_status() != hdef.OKAY:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"scre_show_screen build: Error in scre_build_sigset \n errtext = {wp_screen_scre.get_errtext()}"
        wp_screen_scre.reset_status()
        return
    # end if

    # 2. build rawtable
    wp_screen_scre.scre_build_rawtable(rd, rd.scre["scre_dict"],-1)
    if wp_screen_scre.get_status() != hdef.OKAY:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"scre_show_screen build: Error in scre_build_rawtable \n errtext = {wp_screen_scre.get_errtext()}"
        wp_screen_scre.reset_status()
        return
    # end if



    wp_screen_scre.scre_build_fmttable(rd, rd.scre["scre_dict"])
    if wp_screen_scre.get_status() != hdef.OKAY:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"scre_command build: Error in scre_build \n errtext = {wp_screen_scre.get_errtext()}"
        wp_screen_scre.reset_status()
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
