
import os, sys, time

import numpy as np

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import wp_screen.wp_screen_gui as wp_screen_gui
import wp_screen.wp_screen_katalog as wp_screen_katalog
import wp_screen.wp_screen_sigset as wp_screen_sigset
import wp_screen.wp_screen_tab as wp_screen_tab
import wp_screen.wp_screen_plotdef as wp_screen_plotdef_command
import wp_screen.wp_screen_scre_command as wp_screen_scre_command
import wp_screen.wp_screen_scre_build_signal as wp_screen_scre_build_signal
import wp_screen.wp_screen_scre_build_fmttab as wp_screen_scre_build_fmttab
import wp_screen.wp_screen_scre_build_rawtab as wp_screen_scre_build_rawtab

import tools.hfkt_def as hdef
import tools.hfkt_io as hio
import tools.hfkt_np_fkt as hnpfkt
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
def scre_start(rd):

    scre_set(rd)
    if get_status() != hdef.OKAY:
        return
    # end if

    wp_screen_scre_command.scre_command(rd)
    if wp_screen_scre_command.get_status() != hdef.OKAY:
        global STATUS, ERRTEXT
        STATUS = wp_screen_scre_command.get_status()
        ERRTEXT = wp_screen_scre_command.get_errtext()
        wp_screen_scre_command.reset_status()
    # end def

    return
# end def
def scre_set(rd):
    # Signalset-Liste Json-Liste einladen
    if rd.scre["scre_liste_jsonobj"] is None:

        rd.scre["scre_liste_filename"] = os.path.join(rd.ini["store_path"],
                                rd.ini["scre_liste_file_name"]+".json")

        rd.scre["scre_liste_jsonobj"] = hio.DataJson(rd.scre["scre_liste_filename"])
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
    if (len(ddict[rd.par.SCRE_PLOTDEF])>0) and not wp_screen_plotdef.exist_plotdef(rd,ddict[rd.par.SCRE_PLOTDEF]):
        flag = False
        INFOTEXT = INFOTEXT + "\n" + f"tab: {ddict[rd.par.SCRE_PLOTDEF]} gibt es nicht im Tabellen-Set"
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
    rd.scre["scre_dict_jsonobj"] = hio.DataJson(rd.scre["scre_dict_filename"])

    rd.scre["scre_dict"] = rd.scre["scre_dict_jsonobj"].read_and_get_data()

    if rd.scre["scre_dict_jsonobj"].get_status() == hdef.NOT_FOUND:
        rd.scre["scre_dict"] = {rd.par.SCRE_KATALOG:"",rd.par.SCRE_SIGSET:"",rd.par.SCRE_TAB:"",rd.par.SCRE_PLOTDEF:""}
        rd.scre["scre_dict_jsonobj"].reset_status()
    elif rd.scre["scre_dict_jsonobj"].get_status() != hdef.OKAY:
        rd.log.write_err(rd.scre["scre_dict_jsonobj"].get_errtext(), screen=rd.par.LOG_SCREEN_OUT)
        global STATUS, ERRTEXT
        STATUS = rd.scre["scre_dict_jsonobj"].get_status()
        ERRTEXT = rd.scre["scre_dict_jsonobj"].get_errtext()
        rd.scre["scre_dict_jsonobj"].reset_status()
        # end if
    else:
        if rd.par.SCRE_KATALOG not in rd.scre["scre_dict"].keys():
            rd.scre["scre_dict"][rd.par.SCRE_KATALOG] = ""
        if rd.par.SCRE_SIGSET not in rd.scre["scre_dict"].keys():
            rd.scre["scre_dict"][rd.par.SCRE_SIGSET] = ""
        if rd.par.SCRE_TAB not in rd.scre["scre_dict"].keys():
            rd.scre["scre_dict"][rd.par.SCRE_TAB] = ""
        if rd.par.SCRE_PLOTDEF not in rd.scre["scre_dict"].keys():
            rd.scre["scre_dict"][rd.par.SCRE_PLOTDEF] = ""

    rd.scre["scre_dict_jsonobj"].reset_status()
    return
# end def
def scre_dict_save(rd):
    global STATUS, ERRTEXT

    if rd.scre["scre_dict_jsonobj"] is None:
        rd.scre["scre_dict_jsonobj"] = hio.DataJson(rd.scre["scre_dict_filename"])
    # end if


    rd.scre["scre_dict_jsonobj"].save(rd.scre["scre_dict"])
    if rd.scre["scre_dict_jsonobj"].get_status() != hdef.OKAY:
        STATUS = rd.scre["scre_dict_jsonobj"].get_status()
        ERRTEXT = rd.scre["scre_dict_jsonobj"].get_errtext()
        rd.scre["scre_dict_jsonobj"].reset_status()
        return
    return
# end def
def scre_build_sigset(rd,scre,scre_dict):

    global STATUS, ERRTEXT

    katalog = scre_dict[rd.par.SCRE_KATALOG]
    sigset = scre_dict[rd.par.SCRE_SIGSET]

    isin_liste = wp_screen_katalog.get_katalog_isin_liste(rd,katalog)
    sigset_dict = wp_screen_sigset.get_sigset_dict(rd,sigset)

    (status, infotext, sigset_werte_dict_liste) = wp_screen_sigset.get_sigset_werte_dict_liste(rd, sigset_dict)
    if status != hdef.OKAY:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = infotext
        return
    # end if

    # Signale aus sigset bilden:
    #------------------------------
    # reset isin-dataclass dict (vielleicht richtig löschen, einzeln)
    rd.scre["scre_isin_dataclass_filename_dict"] = {}
    n = len(isin_liste)
    for i,isin in enumerate(isin_liste):


        rd.scre["scre_isin_dataclass_filename_dict"][isin] = wp_screen_scre_build_signal.get_dataclass_filename(rd, scre, isin)

        if not wp_screen_scre_build_signal.proof_if_data_uptodate(rd,scre,isin):

            time.sleep(5)

            wp_screen_scre_build_signal.scre_build_signal(rd, scre,isin, sigset_werte_dict_liste)

            rd.log.write_info(f"{i+1}/{n}: Update sigset for isin = {isin}, {wp_screen_scre_build_signal.get_infotext()}",
                              screen=rd.par.LOG_SCREEN_OUT)

            if wp_screen_scre_build_signal.get_status() != hdef.OKAY:
                STATUS = hdef.NOT_OKAY
                ERRTEXT = wp_screen_scre_build_signal.get_errtext()
                wp_screen_scre_build_signal.reset_status()
                return
            # end if
            wp_screen_scre_build_signal.reset_status()
        else:
            rd.log.write_info(f"{i+1}/{n}: No Update sigset for isin = {isin}",screen=rd.par.LOG_SCREEN_OUT)
        # end if
    # end for

    return
# end if
def scre_build_rawtable(rd, scre_dict, dat = -1,days_wp_exit= -1):
    """
    rawtable = scre_build_rawtable(rd, scre_dict)
    """
    global STATUS, ERRTEXT

    katalog = scre_dict[rd.par.SCRE_KATALOG]
    tab = scre_dict[rd.par.SCRE_TAB]

    isin_liste = wp_screen_katalog.get_katalog_isin_liste(rd, katalog)
    tab_dict = wp_screen_tab.get_tab_dict(rd,tab)

    (status, infotext, tab_werte_dict_liste) = wp_screen_tab.get_tab_werte_dict_liste(rd, tab_dict)
    if status != hdef.OKAY:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = infotext
        return None
    # end if

    # Raw-Tabelle bilden:
    #----------------------
    header_list = wp_screen_scre_build_fmttab.build_header_list(tab_werte_dict_liste)

    build_table_flag = True
    next_isin_liste = []
    for i,isin in enumerate(isin_liste):

        (data_liste,type_list) = wp_screen_scre_build_rawtab.scre_build_rawtab(rd, isin, tab_werte_dict_liste,dat,days_wp_exit)
        if wp_screen_scre_build_rawtab.get_status() != hdef.OKAY:
            STATUS = hdef.NOT_OKAY
            ERRTEXT = wp_screen_scre_build_rawtab.get_errtext()
            wp_screen_scre_build_rawtab.reset_status()
            return None
        # end if

        if (len(data_liste) > 0):

            if build_table_flag:
                ttable = htvar.build_table(header_list, [], type_list)
                build_table_flag = False
            # end if
            ttable = htvar.add_data_set_to_table(ttable, data_liste)
            next_isin_liste.append(isin)
        # end if
    # end for

    # Vergleichende Werte in Tabelle bilden und sortieren:
    #--------------------------------------------------------
    if not build_table_flag:
        (ttable,index_sorted_liste) = wp_screen_scre_build_rawtab.scre_build_values_over_rawtab(rd,
                                                                                                ttable,
                                                                                                tab_werte_dict_liste,
                                                                                                next_isin_liste,
                                                                                                dat,
                                                                                                days_wp_exit)
        if wp_screen_scre_build_rawtab.get_status() != hdef.OKAY:
            STATUS = hdef.NOT_OKAY
            ERRTEXT = wp_screen_scre_build_signal.get_errtext()
            return ttable
        # end if
    else:
        type_list = ["" for h in header_list]
        ttable = htvar.build_table(header_list, [], type_list)
        index_sorted_liste = []
    # end if
    rd.scre["ttable_raw"] = ttable
    rd.scre["ttable_index_sorted_liste"] = index_sorted_liste

    # Finde Name wenn möglich
    #------------------------
    flag = False
    namelist = ["Name","name"]
    for name in namelist:
        if htvar.check_name_from_table(ttable,name):
            icol = htvar.get_index_from_table(ttable, name)
            flag = True
            break
        # end if
    # end for
    name_notsorted_liste = ['' for i in range(len(index_sorted_liste))]
    if flag:
        for i in range(len(index_sorted_liste)):
            name = htvar.get_val_from_table(ttable,i,icol)
            name_notsorted_liste[index_sorted_liste[i]] = name
        # end for
    # end if
    rd.scre["ttable_name_notsorted_liste"] = name_notsorted_liste

    return ttable
# end def
def scre_build_fmttable(rd,scre_dict):

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

    (status, infotext, tab_werte_dict_liste) = wp_screen_tab.get_tab_werte_dict_liste(rd, tab_dict)
    if status != hdef.OKAY:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = infotext
        return
    # end if

    # formatierte Tabelle bilden:
    #------------------------------
    #
    rd.scre["ttable"] = None
    rd.scre["color_dict_liste"] = []

    type_list = wp_screen_scre_build_fmttab.build_type_list(tab_werte_dict_liste)

    status = hdef.OKAY
    if "ttable_raw" in rd.scre.keys():
        if rd.scre["ttable_raw"] is None:
            status = hdef.NOT_OKAY
        # end if
    else:
        status = hdef.NOT_OKAY
    # end if
    if status != hdef.OKAY:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"scre_build_fmttable: rd.scre[\"ttable_raw\"] ist nicht vorhanden oder None"
        return
    # end if

    ttable_raw = rd.scre["ttable_raw"]
    header_list = ttable_raw.names
    ttable = htvar.build_table(header_list, [], type_list)


    color_dict_liste = []
    for irow,data_set in enumerate(ttable_raw.table):

        (data_liste,color_dict_list0) = wp_screen_scre_build_fmttab.scre_build_fmttable_data(rd, irow, data_set, header_list, tab_werte_dict_liste, type_list)
        if wp_screen_scre_build_fmttab.get_status() != hdef.OKAY:
            STATUS = hdef.NOT_OKAY
            ERRTEXT = wp_screen_scre_build_fmttab.get_errtext()
            return
        # end if

        ttable = htvar.add_data_set_to_table(ttable,data_liste)
        color_dict_liste += color_dict_list0

    # end for

    rd.scre["ttable"] = ttable
    rd.scre["color_dict_liste"] = color_dict_liste
    return
# end def
def setup_scre_name(rd,scre_name):
    global STATUS, ERRTEXT

    if scre_name not in rd.scre["scre_liste"]:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"Error wp_screen_base.build_scre_sigset({scre_name}) screen name nicht in Liste gefunden liste: {rd.scre["scre_liste"]}"
        return
    # end if

    index = rd.scre["scre_liste"].index(scre_name)

    rd.scre["scre"] = rd.scre["scre_liste"][index]
    scre_dict_read(rd)

    if get_status() != hdef.OKAY:
        return
    # end if
    return
# end def
def del_screname(rd,screname):
    """
    :param rd:
    :param screname:
    :return:
    """
    if screname in rd.scre["scre_liste"]:
        index = rd.scre["scre_liste"].index(screname)
        del rd.scre["scre_liste"][index]
        rd.scre["scre_liste_jsonobj"].save(rd.scre["scre_liste"])
    # end if
    return
# end def

def add_dict(rd,screname,scre_dict):
    """
    :param rd:
    :param tabname:
    :param tab_dict:
    :return:
    """

    global STATUS, ERRTEXT

    add_screname(rd,screname)
    setup_scre_name(rd,screname)
    if STATUS != hdef.OKAY:
        del_screname(rd, screname)
        return

    modify_dict(rd, scre_dict)
    if STATUS != hdef.OKAY:
        del_screname(rd, screname)
        return

    return
# end if
def add_screname(rd,screname):
    """
    :param rd:
    :param screname:
    :return: tab
    """

    # entfernt Leerzeichen, Tabulator (\t), Zeilenumbrüche (\n), geschützte Leerzeichen (\xa0)
    scre = "".join(screname.split()).replace(" ", "")

    if scre not in rd.scre["scre_liste"]:

        rd.scre["scre_liste"].append(scre)
        rd.scre["scre_liste_jsonobj"].save(rd.scre["scre_liste"])

        rd.log.write_info(f"{scre = } wurde der scre_liste hinzugefügt")
    else:
        rd.log.write_info(f"{scre = } gibt es schon in Liste")
    # end if

    return scre
# end def

def modify_dict(rd, dict_mod):
    """
    :param rd:
    :param dict_mod:
    :return:
    """

    global STATUS, ERRTEXT

    # Check modified dictionary
    check(rd,dict_mod)
    if STATUS != hdef.OKAY:
        return
    # end if

    rd.scre["scre_dict"] = dict_mod
    rd.scre["scre_dict_jsonobj"].save(rd.scre["scre_dict"])
    if rd.scre["scre_dict_jsonobj"].get_status() != hdef.OKAY:
        STATUS = rd.scre["scre_dict_jsonobj"].get_status()
        ERRTEXT = rd.scre["scre_dict_jsonobj"].get_errtext()
        rd.scre["scre_dict_jsonobj"].reset_status()
        return
    # end if

    return
# end def
def check(rd,dict_mod):
    """
    :param rd:
    :param dict_mod:
    :return:

    """
    global STATUS, ERRTEXT
    if rd.par.SCRE_KATALOG not in dict_mod.keys():
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"wp_screen_scre.check: Key {rd.par.SCRE_KATALOG} nicht in dict: {dict_mod} "
        return
    # end if
    if rd.par.SCRE_SIGSET not in dict_mod.keys():
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"wp_screen_scre.check: Key {rd.par.SCRE_SIGSET} nicht in dict: {dict_mod} "
        return
    # end if
    if rd.par.SCRE_TAB not in dict_mod.keys():
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"wp_screen_scre.check: Key {rd.par.SCRE_TAB} nicht in dict: {dict_mod} "
        return
    # end if
    if rd.par.SCRE_PLOTDEF not in dict_mod.keys():
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"wp_screen_scre.check: Key {rd.par.SCRE_PLOTDEF} nicht in dict: {dict_mod} "
        return
    # end if

    return
# end def
def proof_end_dat_of_wp(rd,scre_name, scre_dict,end_dat):
    """
    :param rd:
    :param scre_name:
    :param scre_dict:
    :param end_dat:
    :return:
    """

    global STATUS, ERRTEXT,INFOTEXT

    katalog = scre_dict[rd.par.SCRE_KATALOG]

    isin_liste = wp_screen_katalog.get_katalog_isin_liste(rd, katalog)

    indices_updated = False

    for isin in isin_liste:

        if not proof_end_dat_of_wp_isin(rd,isin,end_dat):

            if not indices_updated:
                (status, errtext, infotext) = rd.wpfunc.update_indices()
                if len(infotext):
                    INFOTEXT += infotext
                # endif
                if status != hdef.OKAY:
                    STATUS = hdef.NOT_OKAY
                    ERRTEXT = errtext
                    rd.wpfunc.reset_status()
                    return
                # end if
                rd.wpfunc.reset_status()
                indices_updated = True
            # end if

            (status, errtext, infotext) = rd.wpfunc.update_price_volume(isin)

            if len(infotext):
                INFOTEXT += infotext
            # endif
            if status != hdef.OKAY:
                STATUS = hdef.NOT_OKAY
                ERRTEXT = errtext
                rd.wpfunc.reset_status()
                return
            # end if
            rd.wpfunc.reset_status()
        # end if
    # end for

    return
# end def
def proof_end_dat_of_wp_isin(rd,isin,end_dat):
    """

    :param rd:
    :param isin:
    :return:
    """

    global STATUS, ERRTEXT

    # Kursdaten für vorggegbene isin holen
    (first, last) = rd.wpfunc.get_first_and_last_dat_price_volume_np_obj(isin,"dat")

    if last is None:
        return False
    elif end_dat < last:
        return True
    else:
        return False
    # end if
# end def
def scre_get_array_from_sigset(rd,
                               isin,
                               scre,
                               sig_name,
                               datstart,
                               datend):
    """
    :param rd:
    :param scre:
    :param scre_dict:
    :param sig_name:
    :param datstart:
    :param datend:
    :return: np_array = scre_get_array_from_sigset(rd,isin,scre,sig_name,datstart,datend)
    """

    global STATUS, ERRTEXT, INFOTEXT

    np_data_obj = wp_screen_scre_build_rawtab.get_np_data_obj(rd,isin)

    if np_data_obj is None:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"wp_screen_scre.scre_get_min_max_from_sigset: Signal konnte nicht gefunden werden scre: {scre} sig_name: {sig_name} "
        return (None,None)
    # end if

    np_dat_array = np_data_obj.get_data(rd.par.SIG_STORE_DATUM)

    if np_dat_array is None:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"wp_screen_scre.scre_get_min_max_from_sigset: Signal konnte nicht in np_dat_obj gefunden werden scre: {scre} sig_name: {rd.par.SIG_STORE_DATUM}"
        return (None, None)
    # end if

    (istart,d) = hnpfkt.find_index_d(np_dat_array,datstart)
    if d > 0.5:
        istart += 1

    (iend,d) = hnpfkt.find_index_d(np_dat_array,datend)
    if d > 0.5:
        iend += 1


    np_array = np_data_obj.get_data(sig_name)

    if np_array is None:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"wp_screen_scre.scre_get_min_max_from_sigset: Signal konnte nicht in np_dat_obj gefunden werden scre: {scre} sig_name: {sig_name}"
        return (None, None)
    # end if

    np_part_array = np_array[istart:iend+1]

    return np_part_array
# end def
def scre_get_min_max_from_sigset(rd,
                                 isin,
                                 scre,
                                 sig_name,
                                 datstart,
                                 datend):
    """
    :param rd:
    :param scre:
    :param scre_dict:
    :param sig_name:
    :param datstart:
    :param datend:
    :return: (valmin, valmax) = scre_get_min_max_from_sigset(rd,isin,scre,sig_name,datstart,datend)
    """
    global STATUS, ERRTEXT, INFOTEXT

    np_part_array = scre_get_array_from_sigset(rd,
                                               isin,
                                               scre,
                                               sig_name,
                                               datstart,
                                               datend)

    if STATUS != hdef.OKAY:
        return (None,None)

    valmin = np.min(np_part_array)
    valmax = np.max(np_part_array)

    return (valmin,valmax)
# end def



