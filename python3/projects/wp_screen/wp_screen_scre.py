
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
import wp_screen_scre_build_rawtab

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
def scre_build_sigset(rd,scre_dict):

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
    n = len(isin_liste)
    for i,isin in enumerate(isin_liste):

        rd.scre["scre_isin_dataclass_filename_dict"][isin] = wp_screen_scre_build_signal.get_dataclass_filename(rd, isin)

        if not wp_screen_scre_build_signal.proof_if_data_uptodate(rd,isin):


            wp_screen_scre_build_signal.scre_build_signal(rd, isin, sigset_werte_dict_liste)

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
def scre_build_rawtable(rd, scre_dict, dat):
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

    # 2. Raw-Tabelle bilden:
    #----------------------
    header_list = wp_screen_scre_build_fmttab.build_header_list(tab_werte_dict_liste)

    for i,isin in enumerate(isin_liste):

        (data_liste,type_list) = wp_screen_scre_build_rawtab.scre_build_rawtab(rd, isin, tab_werte_dict_liste,dat)
        if wp_screen_scre_build_rawtab.get_status() != hdef.OKAY:
            STATUS = hdef.NOT_OKAY
            ERRTEXT = wp_screen_scre_build_rawtab.get_errtext()
            wp_screen_scre_build_rawtab.reset_status()
            return None
        # end if

        if i == 0:
            ttable = htvar.build_table(header_list, [], type_list)
        # end if
        ttable = htvar.add_data_set_to_table(ttable, data_liste)

    # end for

    # 2. Vergleichende Werte in Tabelle bilden:
    #----------------------
    ttable = wp_screen_scre_build_rawtab.scre_build_values_over_rawtab(rd,ttable,tab_werte_dict_liste,isin_liste,dat)
    if wp_screen_scre_build_rawtab.get_status() != hdef.OKAY:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = wp_screen_scre_build_signal.get_errtext()
        return ttable
    # end if

    rd.scre["ttable_raw"] = ttable

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
