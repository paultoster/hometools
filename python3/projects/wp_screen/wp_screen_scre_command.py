
import os, sys, copy, time


t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import wp_screen.wp_screen_gui as wp_screen_gui
import wp_screen.wp_screen_katalog_command as wp_screen_katalog_command
import wp_screen.wp_screen_sigset as wp_screen_sigset
import wp_screen.wp_screen_sigset_command as wp_screen_sigset_command
import wp_screen.wp_screen_tab as wp_screen_tab
import wp_screen.wp_screen_tab_command as wp_screen_tab_command
import wp_screen.wp_screen_plotdef_command as wp_screen_plotdef_command
# import wp_screen_scre_build_signal
# import wp_screen_scre_build_fmttab
import wp_screen.wp_screen_scre as wp_screen_scre
import wp_screen.wp_screen_scre_plot as wp_screen_scre_plot

import tools.hfkt_def as hdef
import tools.hfkt_file_path as hfp
import tools.sgui as sgui
import tools.hfkt_io as hio
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


    auswahl_title = "Screen-Namen editieren"
    abfrage_liste = ["edit(values)","add", "delete", "rename","copy","build","ende"]
    i_edit = 0
    i_add = 1
    i_delete = 2
    i_rename = 3
    i_copy = 4
    i_build = 5
    i_ende = 6

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
                if STATUS != hdef.OKAY and ERRTEXT != "":
                    t = f"scre_command rename: {ERRTEXT}"
                    rd.log.write_err(t, screen=rd.par.LOG_SCREEN_OUT)
                    sgui.anzeige_text(t, textcolor='orange')
                    reset_status()
                # end if
            # end if
        elif indexAbfrage == i_copy:
            if (index < 0) or (index >= n_auswahl_liste):
                t = "scre_command copy: index out of range or not set"
                rd.log.write_err(t, screen=rd.par.LOG_SCREEN_OUT)
                sgui.anzeige_text(t, textcolor='orange')
            else:
                scre_copy(rd, index)
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
                    reset_status()
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


    abfrage_liste = ["katalog","sigset", "tab","plotdef","end"]

    title = f"scre: \"{rd.scre["scre"]}\"; Ändere katalog, signalset, tabelle"

    index_katalog = 0
    index_sigset  = 1
    index_tab     = 2
    index_plotdef = 3
    index_end     = 4


    runflag = True
    while (runflag):

        if STATUS != hdef.OKAY:

            sgui.anzeige_text(ERRTEXT, textcolor='red')
            reset_status()
        # end if

        ddict = copy.copy(rd.scre["scre_dict"])

        (ddict_mod, changed_key_liste,index_abfrage) = wp_screen_gui.scre_dict_abfrage(rd.gui, ddict,
                                                                              title=title,
                                                                              abfrage_liste=abfrage_liste)

        if (wp_screen_gui.get_status() != hdef.OK):
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


            katalog = wp_screen_katalog_command.get_katalog_auswahl(rd)

            if wp_screen_katalog_command.get_status() != hdef.OKAY:
                STATUS = wp_screen_katalog_command.get_status()
                ERRTEXT = wp_screen_katalog_command.get_errtext()
                wp_screen_katalog_command.reset_status()
                runflag = True
            # end if

            if katalog != None:
                rd.scre["scre_dict"][rd.par.SCRE_KATALOG] = katalog
                wp_screen_scre.scre_dict_save(rd)
                if STATUS != hdef.OKAY:
                    return
                # end if
            # end if
        elif index_abfrage == index_sigset:

            sigset = wp_screen_sigset_command.get_sigset_auswahl(rd)

            if wp_screen_sigset.get_status() != hdef.OKAY:
                STATUS = wp_screen_sigset.get_status()
                ERRTEXT = wp_screen_sigset.get_errtext()
                wp_screen_sigset.reset_status()
                runflag = True
            # end if

            if sigset != None:
                rd.scre["scre_dict"][rd.par.SCRE_SIGSET] = sigset
                wp_screen_scre.scre_dict_save(rd)
                if STATUS != hdef.OKAY:
                    return
                # end if
            # end if
        elif index_abfrage == index_tab:

            tab = wp_screen_tab_command.get_tab_auswahl(rd)

            if wp_screen_tab.get_status() != hdef.OKAY:
                STATUS = wp_screen_tab.get_status()
                ERRTEXT = wp_screen_tab.get_errtext()
                wp_screen_tab.reset_status()
                runflag = True
            # end if

            if tab != None:
                rd.scre["scre_dict"][rd.par.SCRE_TAB] = tab
                wp_screen_scre.scre_dict_save(rd)
                if STATUS != hdef.OKAY:
                    return
                # end if
            # end if

        elif index_abfrage == index_plotdef:

            plotdef = wp_screen_plotdef_command.get_plotdef_auswahl(rd)

            if wp_screen_plotdef_command.get_status() != hdef.OKAY:
                STATUS = wp_screen_plotdef_command.get_status()
                ERRTEXT = wp_screen_plotdef_command.get_errtext()
                wp_screen_plotdef_command.reset_status()
                runflag = True
            # end if


            if plotdef != None:
                rd.scre["scre_dict"][rd.par.SCRE_PLOTDEF] = plotdef
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


    wp_screen_scre.add_screname(rd, liste_ergebnis[0])

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

    alter_name = rd.scre["scre_liste"][index]
    liste_abfrage = ["screname"]
    title = "Umbenennen Screen-Name "
    liste_vorgabe = [alter_name]
    (liste_ergebnis, status) = wp_screen_gui.eingabe_n_zeilen(rd.gui, liste_abfrage,
                                                              liste_vorgabe=liste_vorgabe, title=title)

    if (status != hdef.OKAY) or (liste_ergebnis == []):
        return

    text = liste_ergebnis[0]
    # entfernt Leerzeichen, Tabulator (\t), Zeilenumbrüche (\n), geschützte Leerzeichen (\xa0)
    neuer_name = "".join(text.split()).replace(" ", "")

    if neuer_name != rd.scre["scre_liste"][index]:
        alter_file_name = wp_screen_scre.scre_dict_set_filename(rd, alter_name)
        neuer_file_name = wp_screen_scre.scre_dict_set_filename(rd, neuer_name)

        status = hfp.rename_file(alter_file_name,neuer_file_name)
        if status != hdef.OKAY:
            global STATUS, ERRTEXT
            STATUS = hdef.NOT_OKAY
            ERRTEXT = f"Datei {alter_file_name} konnte nicht in {neuer_file_name} umbenannt werden"
            return
        # end if
        rd.scre["scre_liste"][index] = neuer_name
        rd.scre["scre_liste_jsonobj"].save(rd.scre["scre_liste"])
    # end if
    return
# end def
def scre_copy(rd, index):
    liste_abfrage = ["newscrename"]
    title = "Copy Screen-Name "
    liste_vorgabe = [rd.scre["scre_liste"][index]]

    runflag = True
    while runflag:
        (liste_ergebnis, status) = wp_screen_gui.eingabe_n_zeilen(rd.gui, liste_abfrage,
                                                                liste_vorgabe=liste_vorgabe, title=title)

        if (status != hdef.OKAY) or (liste_ergebnis == []):
            return

        text = liste_ergebnis[0]
        # entfernt Leerzeichen, Tabulator (\t), Zeilenumbrüche (\n), geschützte Leerzeichen (\xa0)
        scre = "".join(text.split()).replace(" ", "")

        if scre in rd.scre["scre_liste"]:
            t = f"copyname: {scre}  ist bereits in Liste {rd.scre["scre_liste"]} "
            rd.log.write_err(t, screen=rd.par.LOG_SCREEN_OUT)
            sgui.anzeige_text(t, textcolor='red')
        else:
            wp_screen_scre.copy_screname_screliste(rd, rd.scre["scre_liste"][index],scre)
            runflag = False
        # end if
    return


def scre_show_screen(rd,index):
    """
    :param rd:
    :param index:
    :return: scre_show_screen(rd,index)
    """
    global STATUS, ERRTEXT

    start_cpu = time.process_time()
    start_real = time.perf_counter()

    rd.scre["scre"] = rd.scre["scre_liste"][index]
    wp_screen_scre.scre_dict_read(rd)
    if get_status() != hdef.OKAY:
        return

    # 0. Check sigliste against tabliste
    if not wp_screen_scre.check_sigset_against_tabset(rd,rd.scre["scre"],rd.scre["scre_dict"]):
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"scre_show_screen build: Error in check_sigset_against_tabset \n errtext = {wp_screen_scre.get_errtext()}"
        wp_screen_scre.reset_status()
        return

    # 1. build alll signals
    wp_screen_scre.scre_build_sigset(rd, rd.scre["scre"], rd.scre["scre_dict"])
    if wp_screen_scre.get_status() != hdef.OKAY:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"scre_show_screen build: Error in scre_build_sigset \n errtext = {wp_screen_scre.get_errtext()}"
        wp_screen_scre.reset_status()
        return
    # end if

    # 2. build rawtable
    wp_screen_scre.scre_build_rawtable(rd, rd.scre["scre_dict"])
    if wp_screen_scre.get_status() != hdef.OKAY:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"scre_show_screen build: Error in scre_build_rawtable \n errtext = {wp_screen_scre.get_errtext()}"
        wp_screen_scre.reset_status()
        return
    # end if

    # 3. build fmttable
    wp_screen_scre.scre_build_fmttable(rd, rd.scre["scre_dict"])
    if wp_screen_scre.get_status() != hdef.OKAY:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"scre_command build: Error in scre_build \n errtext = {wp_screen_scre.get_errtext()}"
        wp_screen_scre.reset_status()
        return
    # end if

    end_cpu = time.process_time()
    end_real = time.perf_counter()

    rd.log.write_info(f"Reine CPU-Prozesszeit: {end_cpu - start_cpu:.6f} Sekunden", screen=rd.par.LOG_SCREEN_OUT)
    rd.log.write_info(f"Echte vergangene Zeit: {end_real - start_real:.6f} Sekunden", screen=rd.par.LOG_SCREEN_OUT)

    abfrage_liste = ["plot","excel","ende"]
    index_plot = 0
    index_excel = 1
    index_ende = 2

    runflag = True
    while runflag:

        (status,errtext, indexAbfrage,index) = wp_screen_gui.scre_sheet_show(rd.gui,
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
        elif indexAbfrage == index_plot:
            if index < 0:
                rd.log.write_info("Keine wp ausgewählt")
                runflag = True
            else:

                ttable = rd.scre["ttable"]

                index_isin_liste = rd.scre["ttable_index_sorted_liste"][index]
                wp_name          = rd.scre["ttable_name_notsorted_liste"][index_isin_liste]

                wp_screen_scre_plot.plot_scre(rd,rd.scre["scre"],rd.scre["scre_dict"],index_isin_liste,wp_name)

                if wp_screen_scre_plot.get_status() != hdef.OKAY:
                    STATUS = wp_screen_scre_plot.get_status()
                    ERRTEXT = wp_screen_scre_plot.get_errtext()
                    wp_screen_scre_plot.reset_status()
                    t = f"scre_show_screen: Plotten ging schief:{ERRTEXT}"
                    wp_screen_gui.anzeige_text(rd.gui,t, title="",textcolor='red')
                    rd.log.write_info(t)
                # end if
                runflag = True
        else: # indexAbfrage == index_excel

            print(rd.scre["ttable"].table)
            print(rd.scre["ttable"].n)
            print(rd.scre["color_dict_liste"])

            color_table = []
            for irow,data_liste in enumerate(rd.scre["ttable"].table):

                row_color_dict_liste = []
                for ddict in rd.scre["color_dict_liste"]:
                    if ddict["row"] == irow:
                        row_color_dict_liste.append(ddict)
                    # end if
                # end dfor

                color_liste = []
                for icol in range(len(data_liste)):

                    nflag = True
                    for ddict in row_color_dict_liste:
                        if ddict["col"] == icol:
                            nflag = False
                            color = sgui.get_tkinter_color_hexcode(ddict["bg"])
                            break
                        # end if
                    # end ofr
                    if nflag:
                        color = '#ffffff' # white
                    # end if

                    color_liste.append(color)

                # end ofr

                color_table.append(color_liste)
            # end for

            excel_filename = os.path.join(rd.ini["store_path"],rd.scre["scre"] + '.xlsx')
            status = hio.write_excel_file_ttable(excel_filename,rd.scre["ttable"],color_table)

            if status != hdef.OKAY:
                STATUS = hdef.NOT_OKAY
                ERRTEXT = f"Excelfile: {excel_filename} konnte nicht erstellt werden"
                runflag = False
            else:
                runflag = True
                os.startfile(excel_filename)
        # end if
    # end while
    return
# end def
