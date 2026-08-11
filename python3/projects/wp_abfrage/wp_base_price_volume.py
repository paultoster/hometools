
import os, sys
import numpy as np
import copy


t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_file_path as hfp
import tools.hfkt_type as htype
import tools.hfkt_str as hstr
import tools.hfkt_io as hio


from wp_abfrage import wp_storage
from wp_abfrage import wp_fkt

from wp_abfrage import wp_np_dataclass as wp_np_dc
from wp_abfrage import wp_base
from wp_abfrage import wp_playwright as wp_pw
from wp_abfrage import wp_yahoofinance as wp_yf
from wp_abfrage import wp_eodhd
from wp_abfrage import wp_requests as wp_req
from wp_abfrage import wp_bearbeiten as wp_bearb


def update(wb_obj,isin_liste):
    """
        (status,errtext,infotext) = wp_base_price_volume.update(wb_obj,isin_liste)
    """
    infotext = ""

    # Get basic_info_dict in a list
    (status, errtext, isin_info_dict_liste) = wb_obj.get_basic_info(isin_liste)
    if status != hdef.OKAY:
        return (status, errtext,infotext)

    n = len(isin_info_dict_liste)

    for i,info_dict in enumerate(isin_info_dict_liste):

        wp_dict = copy.copy(info_dict)

        wp_dict["i"] = i
        wp_dict["n"] = n

        wp_dict["np_obj"] = wp_bearb.read_price_volumen_np_data(wp_dict["isin"])

        wp_dict = proof_is_upgedated(wp_dict)

        # 1. ariva_requests
        if not wp_dict["updated"]:
            (status, errtext, infotext,wp_dict) = update_start_to_end_dat_ariva_requests(wb_obj, wp_dict)
            if status != hdef.OKAY:
                return (status, errtext,infotext)
            # end if

        # 2. Yahoo
        if not wp_dict["updated"]:
            (status, errtext, infotext,wp_dict) = update_start_to_end_dat_yahoo(wb_obj, wp_dict)
            if status != hdef.OKAY:
                return (status, errtext,infotext)
            # end if

        # 3. eodhd
        if not wp_dict["updated"]:
            (status, errtext, infotext,wp_dict) = update_start_to_end_dat_eodhd(wb_obj, wp_dict)
            if status != hdef.OKAY:
                return (status, errtext,infotext)
            # end if

        # save for updated np_objs
        if wp_dict["updated"] and (wp_dict["update_type"] != "file"):
            np_obj = wp_dict["np_obj"]
            np_obj.save()
            wp_dict["np_obj"] = None
            del np_obj
        # end if
    # end for
    return (status,errtext,infotext)
# end if
def proof(wb_obj,isin_liste):
    """
        (status,errtext,infotext) = wp_base_price_volume.update(wb_obj,isin_liste)
    """
    infotext = ""

    # Get basic_info_dict in a list
    (status, errtext, isin_info_dict_liste) = wb_obj.get_basic_info(isin_liste)
    if status != hdef.OKAY:
        return (status, errtext,infotext)

    n = len(isin_info_dict_liste)

    for i,info_dict in enumerate(isin_info_dict_liste):

        wp_dict = copy.copy(info_dict)

        wp_dict["i"] = i
        wp_dict["n"] = n

        wp_dict["np_obj"] = wp_bearb.read_price_volumen_np_data(wp_dict["isin"])

        wp_dict["changed"] = False

        # Prüfe np_obj
        (status, errtext, infotext, wp_dict) = proof_np_obj_liste_data(wb_obj, wp_dict)
        if status != hdef.OKAY:
            return (status, errtext, infotext)
        # end if

        if wp_dict["changed"]:
            np_obj = wp_dict["np_obj"]
            np_obj.save()
            wp_dict["changed"] = False

        # proof wp_dict
        (status, errtext, infotext, wp_dict) = proof_wp_dict(wb_obj, wp_dict)

        if wp_dict["changed"]:

            (status, errtext, basic_info_dict) = wb_obj.filter_basic_info_from_wp_dict(wp_dict)
            if status != hdef.OKAY:
                return (status, errtext, infotext)
            # end if

            (status, errtext) = wb_obj.save_basic_info(wp_dict["isin"],basic_info_dict)
            if status != hdef.OKAY:
                return (status, errtext, infotext)
            # end if
        # end if

        if wp_dict["np_obj"] is not None:
            np_obj = wp_dict["np_obj"]
            wp_dict["np_obj"] = None
            del np_obj

    # end for
    return (status,errtext,infotext)
# end if
def make_backup(wb_obj,isin_liste,move_flag):


    if len(isin_liste) == 0:
        (status, errtext, isin_liste) = wb_obj.get_basic_info_isin_liste()
        if status != hdef.OKAY:
            return (status, errtext)
        # end if
    # end if

    (status, errtext, backup_dir) = wp_bearb.make_backup_build_new_dir_price_volume(wb_obj)
    if status != hdef.OKAY:
        return (status, errtext)
    #  end if

    (status, errtext, filename_list) = wb_obj.get_exist_filenames_of_privce_volume(isin_liste)
    if status != hdef.OKAY:
        return (status, errtext)
    #  end if

    for file_name in filename_list:

        if move_flag:
            status = hfp.move_file(file_name, backup_dir)
            if status != hdef.OKAY:
                errtext = f"file {file_name = } was moved into {backup_dir = }"
        # end if
        else:
            wb_obj.log.write_info(f"copy {file_name = } into {backup_dir = }")
            (status, errtext) = hfp.make_backup_file(file_name, backup_dir, no_act_date=True)
        # end if

        if status != hdef.OKAY:
            return (status, errtext)
        # end if
    # end for

    # end for

    return (status, errtext)

# end if
def build_ariva_isin_csv(wb_obj,isin_ariva_liste=[]):
    """
        build isin-Liste für Power Act als csv-Datei

        Schreibt in wb_obj.base_ddict["avira_price_isin_liste_csv_filebasename"} mit dem Pfad wb_obj.base_ddict["avira_price_volume_csv_store_path"]

    """
    infotext =  ""
    # Get basic_info_dict in a list
    (status, errtext, isin_liste) = wb_obj.get_basic_info_isin_liste()
    if status != hdef.OKAY:
        return (status, errtext,infotext)
    (status, errtext, isin_info_dict_liste) = wb_obj.get_basic_info(isin_liste)
    if status != hdef.OKAY:
        return (status, errtext,infotext)

    isin_ariva_llist = []
    wegschreib_flag_list = []
    for isin_info_dict in isin_info_dict_liste:

        wp_dict = copy.copy(isin_info_dict)

        (status, errtext, wp_dict) = get_np_obj(wb_obj, wp_dict)
        if status != hdef.OKAY:
            return (status, errtext, infotext)
        # end if

        # erstes Datum zum Suchen aus ini
        start_dat_ini_file = htype.type_transform_direct(wb_obj.base_ddict["price_volumen_first_dat"], "datStrP", "dat")
        # Erscheinungsdatum des wp
        if len(wp_dict["start_dat_str"]) == 0:
            start_dat_wp = start_dat_ini_file
        else:
            start_dat_wp = htype.type_transform_direct(wp_dict["start_dat_str"], "datStrP", "dat")
        # end if

        # Wenn wp_dict["start_ariva_dat_str"] nehme dieses Datum
        if len(wp_dict["start_ariva_dat_str"]) > 0:

            start_dat_wp = htype.type_transform_direct(wp_dict["start_ariva_dat_str"], "datStrP", "dat")
        # end if



            # Start Datum
        halfrange = 12 * 60 * 60
        if wp_dict["isin"] in isin_ariva_liste:
            wegschreib_flag_list.append(True)
            isin_ariva_llist.append([wp_dict["isin"]])
        elif wp_dict["first_dat"] == -1:
            wegschreib_flag_list.append(False)
            isin_ariva_llist.append([wp_dict["isin"]])
        elif wp_dict["first_dat"] > start_dat_wp + halfrange:
            wegschreib_flag_list.append(False)
            isin_ariva_llist.append([wp_dict["isin"]])
        # end if
    # end for



    if len(isin_ariva_llist) > 0:

        filename = os.path.join(wb_obj.base_ddict["avira_price_volume_csv_store_path"],
                                wb_obj.base_ddict["avira_price_isin_liste_csv_filebasename"]+".csv")


        status = hio.write_csv_file_header_data(filename, ["isin"], isin_ariva_llist, delim=";")
        if status != hdef.OKAY:
            errtext = f"write_csv_file_header_data: File {filename} konnte nicht geschrieben werden"
            return (status, errtext, infotext)
        # end if

        liste_move = []
        liste_backup = []
        for flag,isin in zip(wegschreib_flag_list,isin_ariva_liste):

            if flag:
                liste_move.append(isin)
            else:
                liste_backup.append(isin)
            # end if
        # end for
        if len(liste_move)>0:
            (status, errtext) = make_backup(wb_obj, liste_move, True)

        if (status == hdef.OKAY) and (len(liste_backup)>0):
            (status, errtext) = make_backup(wb_obj, liste_backup, False)


    else:
        wb_obj.log.write_info("No update necessary len(isin_ariva_llist) == 0")
    # end if

    return (status, errtext, infotext)
# end def
def update_ariva_csv(wb_obj):
    """
        updated prive-volumen aus csv-Daten
        a) ariva-Daten  csv-Datei ist aufgevaut:  wb_obj.base_ddict["avira_price_volume_csv_pre_fie_name"]
                                                  + wkn
                                                  + wb_obj.base_ddict["avira_price_volume_csv_post_fie_name"].csv

        wb_obj.base_ddict["avira_price_volume_csv_delete"] = 1 löscht Datei nach einlesen
        wb_obj.base_ddict["avira_price_volume_csv_is_master"] = 1 nimmt alle Daten aus csv und füllt Datenbestand auf

    """

    # 1 ariva-csv
    (status,errtext,infotext,csv_lliste) = get_csv_ariva_csv_lliste(wb_obj)
    if status != hdef.OKAY:
        return (status, errtext, infotext)

    for csv_file,wkn in csv_lliste:

        wb_obj.log.write_info(f"Start read file {csv_file}")

        (status, errtext, infotext) = read_csv_ariva_file(wb_obj,csv_file,wkn)

        if status != hdef.OKAY:
            return (status, errtext, infotext)
        # end if

    # end for

    return (status, errtext, infotext)
# end def
def get_act(wb_obj,isin_liste,pricetype,dattype):
    """
    (status,errtext,price,dat) = wp_base_price_volume.get_act(wb_obj,isin,pricetype,dattype)
    (status,errtext,price_liste,dat_liste) = wp_base_price_volume.get_act(wb_obj,isin_liste,pricetype,dattype)
    """

    if isinstance(isin_liste,list):
        flag_liste = True
    else:
        flag_liste = False
        isin_liste = [isin_liste]

    price_liste = [None for i in isin_liste]
    dat_liste   = [None for i in isin_liste]

    # Get basic_info_dict in a list
    (status, errtext, isin_info_dict_liste) = wb_obj.get_basic_info(isin_liste)
    if status != hdef.OKAY:
        if flag_liste:
            return (status, errtext,price_liste,dat_liste)
        else:
            return (status, errtext,price_liste[0],dat_liste[0])
        # end if
    # end if

    for i,isin_info_dict in enumerate(isin_info_dict_liste):

        wp_dict = copy.copy(isin_info_dict)

        wp_dict["np_obj"] = wp_bearb.read_price_volumen_np_data(wp_dict["isin"])

        if wp_dict["np_obj"] is not None:
            (wp_dict["first_dat"], wp_dict["last_dat"]) = wp_dict["np_obj"].get_first_last_dat("dat")
        else:
            wp_dict["first_dat"] = -1
            wp_dict["last_dat"] = -1
        # end if

        price = 0.
        dat   = 0
        if (wp_dict["np_obj"] is not None):
            if len(wp_dict["np_obj"].dat_np_array) > 0:
                price = wp_dict["np_obj"].end_np_array[-1]
                dat = wp_dict["np_obj"].dat_np_array[-1]
            # end if
        # end if

        price_liste[i] = htype.type_transform_direct(price,"euro",pricetype)
        dat_liste[i] = htype.type_transform_direct(dat,"dat",dattype)

        if wp_dict["np_obj"] is not None:
            del wp_dict["np_obj"]
    # end for
    if flag_liste:
        return (status, errtext,price_liste,dat_liste)
    else:
        return (status, errtext,price_liste[0],dat_liste[0])
    # end if
# end def
def get_act_np_obj(wb_obj, isin):
    """
    lade die no_obj-Datei und übergebe eine Kopie

    (status, errtext, np_obj) = get_act_np_obj(wb_obj, isin)
    """
    (status, errtext, wp_dict) = wb_obj.get_basic_info(isin)
    if status != hdef.OKAY:
        return (status, errtext,None)
    # end if

    np_obj = wp_bearb.read_price_volumen_np_data(wp_dict["isin"])

    return (status, errtext,np_obj)
# end def
# def get_np_obj_liste(wb_obj,wp_dict_liste):
#     """
#         (status, errtext, wp_dict_liste) = get_np_obj_liste(wb_obj,wp_dict_liste)
#
#         build  wp_dict_liste mit:
#             wp_dict_liste[i]["np_obj"]
#             wp_dict_liste[i]["first_dat"]
#             wp_dict_liste[i]["last_dat"]
#             wp_dict_liste[i]["start_dat"]
#             wp_dict_liste[i]["start_display_dat"]
#             wp_dict_liste[i]["end_dat"]
#             wp_dict_liste[i]["end_display_dat"]
#             wp_dict_liste[i]["updated"] = False
#             wp_dict_liste[i]["update_type"] = "file"
#             wp_dict_liste[i]["np_obj_new"] = None
#     """
#     status = hdef.OKAY
#     errtext = ""
#
#     for i,wp_dict in enumerate(wp_dict_liste):
#
#         (status, errtext, wp_dict) = get_np_obj(wb_obj, wp_dict)
#
#         if status != hdef.OKAY:
#             return (status, errtext, wp_dict_liste)
#
#         (status, errtext, wp_dict) = get_update_dict_values(wb_obj, wp_dict)
#
#         if status != hdef.OKAY:
#             return (status, errtext, wp_dict_liste)
#
#         wp_dict_liste[i] = wp_dict
#     # end for
#     return (status, errtext, wp_dict_liste)
# # end def
def get_np_obj(wb_obj,wp_dict):
    """
        (status, errtext, wp_dict) = get_np_obj(wb_obj,wp_dict)

        build  wp_dict mit:
            wp_dict["np_obj"]
            wp_dict["first_dat"]
            wp_dict["last_dat"]
    """

    wp_dict["np_obj"] = wp_bearb.read_price_volumen_np_data(wp_dict["isin"])

    if wp_dict["np_obj"] is not None:
        (wp_dict["first_dat"], wp_dict["last_dat"]) = wp_dict["np_obj"].get_first_last_dat("dat")
    else:
        wp_dict["first_dat"] = -1
        wp_dict["last_dat"] = -1
    # end if

    return (status, errtext, wp_dict)
# end def
def proof_is_upgedated(wb_obj,wp_dict):
    """
    wp_dict = proof_is_upgedated(wb_obj,wp_dict)
    """
    status = hdef.OKAY
    errtext = ""
    halfrange = 12 * 60 * 60


    # Was ist der letzte aktuelle Handelsdatum
    end_dat_time_list = wp_fkt.letzter_beendeter_handelstag_dat_list(wb_obj.base_ddict["boerse"])
    end_display_dat = htype.type_transform_direct(end_dat_time_list, "datTimeList", "datStrP")
    end_dat = htype.type_transform_direct(end_display_dat, "datStrP", "dat")

    wp_dict["end_dat"] = end_dat
    wp_dict["end_display_dat"] = end_display_dat

    if wp_dict["np_obj"] is None:

        wp_dict["first_dat"] = -1
        wp_dict["last_dat"] = -1

        wp_dict["start_dat"]         = htype.type_transform_direct(wb_obj.base_ddict["price_volumen_first_dat"], "datStrP", "dat")
        wp_dict["start_display_dat"] = htype.type_transform_direct(wp_dict["start_dat"] , "dat", "datStrP")

        wp_dict["updated"] = False
        wp_dict["update_type"] = ""
        wp_dict["np_obj_new"] = None

    else:

        (wp_dict["first_dat"],wp_dict["last_dat"]) = wp_dict["np_obj"].get_first_last_dat("dat")

        if wp_dict["last_dat"] < 0:
            start_dat = htype.type_transform_direct(wb_obj.base_ddict["price_volumen_first_dat"], "datStrP", "dat")
        else:
            start_dat = wp_dict["last_dat"]

        try:
            start_display_dat = htype.type_transform_direct(start_dat, "dat", "datStrP")
        except:
            start_display_dat = ""

        wp_dict["start_dat"] = start_dat
        wp_dict["start_display_dat"] = start_display_dat


        if end_dat >= start_dat + halfrange:

            wp_dict["updated"] = False
            wp_dict["update_type"] = ""
            wp_dict["np_obj_new"] = None
        else:
            wp_dict["updated"] = True
            wp_dict["update_type"] = "file"
            wp_dict["np_obj_new"] = wp_dict["np_obj"]
        # end if

    # end if

    return (status, errtext, wp_dict)
# end def
def get_update_dict_values(wb_obj, wp_dict):
    """
        build  wp_dict mit:
            wp_dict["start_dat"]
            wp_dict["start_display_dat"]
            wp_dict["end_dat"]
            wp_dict["end_display_dat"]
            wp_dict["updated"] = False
            wp_dict["update_type"] = "file"
            wp_dict["np_obj_new"] = None


        (status, errtext, wp_dict) = get_update_dict_values(wb_obj, wp_dict)
    """
    status = hdef.OKAY
    errtext = ""
    halfrange = 12 * 60 * 60

    # # erstes Datum zum Suchen aus ini
    # start_dat_ini_file = htype.type_transform_direct(wb_obj.base_ddict["price_volumen_first_dat"], "datStrP", "dat")
    # # Erscheinungsdatum des wp
    # if len(wp_dict["start_dat_str"]) == 0:
    #     start_dat_wp = start_dat_ini_file
    # else:
    #     start_dat_wp = htype.type_transform_direct(wp_dict["start_dat_str"], "datStrP", "dat")
    #
    # if start_dat_wp > start_dat_ini_file:
    #     start_dat = start_dat_wp
    # else:
    #     start_dat = start_dat_ini_file
    #
    # # Prüfen  start_dat_str
    #
    # # Start Datum
    # if (wp_dict["first_dat"] != -1) and (wp_dict["first_dat"] <= start_dat + halfrange):
    #     start_dat = wp_dict["last_dat"]
    # # end if

    if wp_dict["last_dat"] < 0:
        start_dat = htype.type_transform_direct(wb_obj.base_ddict["price_volumen_first_dat"], "datStrP", "dat")
    else:
        start_dat = wp_dict["last_dat"]

    # # letztes Datum in Datensatz
    # (status, errtext, _, _, lastdat) = get_number_of_np_obj(wb_obj, np_obj)
    # if status != hdef.OKAY:
    #     return (status, errtext)
    # # end if
    # if lastdat > start_dat:
    #     start_dat = lastdat
    # # end if
    try:
        start_display_dat = htype.type_transform_direct(start_dat, "dat", "datStrP")
    except:
        start_display_dat = ""

    wp_dict["start_dat"] = start_dat
    wp_dict["start_display_dat"] = start_display_dat

    # Was ist der letzte aktuelle Handelsdatum
    end_dat_time_list = wp_fkt.letzter_beendeter_handelstag_dat_list(wb_obj.base_ddict["boerse"])
    end_display_dat = htype.type_transform_direct(end_dat_time_list, "datTimeList", "datStrP")
    end_dat = htype.type_transform_direct(end_display_dat, "datStrP", "dat")

    wp_dict["end_dat"] = end_dat
    wp_dict["end_display_dat"] = end_display_dat

    if end_dat >= start_dat + halfrange:

        wp_dict["updated"] = False
        wp_dict["update_type"] = ""
        wp_dict["np_obj_new"] = None
    else:
        wp_dict["updated"] = True
        wp_dict["update_type"] = "file"
        wp_dict["np_obj_new"] = wp_dict["np_obj"]


    # end if

    return (status, errtext, wp_dict)
# end def
def get_number_of_np_obj(wb_obj,np_obj):
    """

    :return: (status,errtext,number,firstdat,lastdat) = get_number_of_np_obj(wb_obj,np_obj)
    """
    status = hdef.OKAY
    errtext = ""
    number = 0
    firstdat = 0
    lastdat = 0

    if (np_obj is not None) and isinstance(np_obj.dat_np_array, (np.ndarray, np.generic)) and (len(np_obj.dat_np_array) > 0):
        number   = len(np_obj.dat_np_array)
        firstdat = int(np_obj.dat_np_array[0])
        lastdat  = int(int(np_obj.dat_np_array[-1]))

    return (status, errtext,number,firstdat,lastdat)
# end def
def log_write_uptodate(wb_obj,wp_dict_liste):
    wb_obj.log.write_info(f"Anfang updated =============================================================================")

    n = len(wp_dict_liste)

    for i,wp_dict in enumerate(wp_dict_liste):
        if wp_dict["updated"]:
            wb_obj.log.write_info(f"updated: {i + 1}./{n} Wert isin = {wp_dict["isin"]} Name: {wp_dict["name"]}")
        # end if
    # end for
    wb_obj.log.write_info(f"Ende   updated =============================================================================")
# end def
def sortiere_upgedated_aus(wp_dict_liste):

    wp_dict_liste_out = []
    for wp_dict in wp_dict_liste:
        if wp_dict["updated"] == False:
            wp_dict_liste_out.append(wp_dict)
        # end if
    # end for
    return wp_dict_liste_out
# end def
def update_start_to_end_dat_yahoo(wb_obj,wp_dict):
    """
        (status, errtext,infotext,wp_dict) = update_start_to_end_dat_yahoo(wb_obj,wp_dict)
    """
    infotext = ""

    (status, errtext, wp_dict) = get_new_price_vol_from_yf(wb_obj, wp_dict)
    if status != hdef.OKAY:
        return (status, errtext)
    # end if

    (status, errtext, wp_dict) = merge_and_update_file(wb_obj, wp_dict)

    return (status,errtext,infotext,wp_dict)
# end def
def update_start_to_end_dat_eodhd(wb_obj,wp_dict):
    """
        (status, errtext,infotext) = update_start_to_end_dat_eodhd(wb_obj,wp_dict)
    """
    infotext = ""

    wb_obj.log.write_info(f"Anfang eodhd =============================================================================")
    (status, errtext, wp_dict) = get_new_price_vol_from_eodhd(wb_obj, wp_dict)
    if status != hdef.OKAY:
        return (status, errtext)
    # end if
    wb_obj.log.write_info(f"Ende   eodhd =============================================================================")

    (status, errtext, wp_dict) = merge_and_update_file(wb_obj, wp_dict)

    return (status, errtext, infotext,wp_dict)
# end dfe
def update_start_to_end_dat_ariva_requests(wb_obj, wp_dict):
    """
        (status, errtext,infotext,wp_dict) = update_start_to_end_dat_ariva_requests(wb_obj,wp_dict)
    """
    infotext = ""

    (status, errtext, wp_dict) = get_new_price_vol_from_ariva_requests(wb_obj, wp_dict)
    if status != hdef.OKAY:
        return  (status, errtext, infotext,wp_dict)
    # end if

    (status, errtext, wp_dict) = merge_and_update_file(wb_obj, wp_dict)

    return (status, errtext, infotext,wp_dict)

# end dfe
def get_new_price_vol_from_yf(wb_obj,  wp_dict):
    """
    :param wb_obj:
    :param wp_dict:
        (status, errtext, wp_dict) = get_new_price_vol_from_yf(wb_obj, wp_dict)
    """
    status = hdef.OKAY
    errtext = ""

    if wp_dict["updated"]:
        pass # wb_obj.log.write_info(f"yahoo-finance: {i+1}./{n} Wert Daten sind upgedated für wpname = {wp_dict["name"]} mit isin = {wp_dict["isin"]}")
    else:
        isin = wp_dict["isin"]
        wpname = wp_dict["name"]
        ticker = wp_dict["ticker"]
        wb_obj.log.write_info(f"yahoo-finance: -------------------------------------------------------------------------------------------------------")
        wb_obj.log.write_info(f"yahoo-finance: {wp_dict["i"]+1}./{wp_dict["i"]} Wert yahhoo für {wpname = } mit {isin = } einzulesen")

        np_obj_yf = None
        if wp_yf.is_Ticker_info_available(ticker):

            wb_obj.log.write_info(f"yahoo-finance: Ist vorhanden  {ticker = }")
            (status, errtext, infotext, np_obj_yf) = wp_yf.get_price_volume_data(ticker,
                                                                       wp_np_dc.NpPriceVolumeClass,
                                                                       wp_dict["start_dat"],
                                                                       wp_dict["end_dat"])

            if status != hdef.OKAY:
                return (status, errtext, wp_dict)
            # end if

            if len(infotext) > 0:
                # wb_obj.log.write_info(f"yahoo-finance: Ist nicht vorhanden")
                np_obj_yf = None
            # end if
        elif len(ticker) > 0:

            ticker = ticker + ".DE"
            if wp_yf.is_Ticker_info_available(ticker):

                wb_obj.log.write_info(f"yahoo-finance: Ist vorhanden  {ticker = }")

                (status, errtext, infotext,np_obj_yf) = wp_yf.get_price_volume_data(ticker,
                                                                           wp_np_dc.NpPriceVolumeClass,
                                                                           wp_dict["start_dat"],
                                                                           wp_dict["end_dat"])

                if status != hdef.OKAY:
                    return (status, errtext, wp_dict)
                # end if
                if len(infotext) > 0:
                    # wb_obj.log.write_info(f"yahoo-finance: Ist nicht vorhanden")
                    np_obj_yf = None
                # end if
            # else:
            #    wb_obj.log.write_info(f"yahoo-finance: Ist nicht vorhanden")
            # end if
        # else:
        #    wb_obj.log.write_info(f"yahoo-finance: Ist nicht vorhanden")
        # end if

        # Währung
        if np_obj_yf != None:
            if len(np_obj_yf.dat_np_array) != 0:
                # Währung
                if np_obj_yf.is_currency("usd"):
                    wb_obj.log.write_info(f"yahoo-finance: Suche USD/euro-Kurse ")
                    (status, errtext, np_obj_yf) = transfer_price_vol_fromto_euro(wb_obj, np_obj_yf,
                                                                                          wb_obj.par.INDICES_USDEURO_NAME)
                elif np_obj_yf.is_currency("chf"):
                    wb_obj.log.write_info(f"yahoo-finance: Suche CHF/euro-Kurse ")
                    (status, errtext, np_obj_yf) = transfer_price_vol_fromto_euro(wb_obj, np_obj_yf,
                                                                                          wb_obj.par.INDICES_CHFEURO_NAME)
                # end if

                # keep end date
                np_obj_yf.reduce_end_dat(wp_dict["end_dat"])
                if len(np_obj_yf.dat_np_array) != 0:
                    range = 60*60*24
                    flag = wp_fkt.is_in_range(np_obj_yf.dat_np_array[-1],wp_dict["end_dat"],range)

                    if flag:
                        wp_dict["np_obj_new"]  = np_obj_yf
                        wp_dict["updated"]     = True
                        wp_dict["update_type"] = "yahoofinance"
                        wb_obj.log.write_info(f"yahoo-finance: Kurs gefunden ")
                    else:
                        wb_obj.log.write_info(f"yahoo-finance: Kurs gefunden, aber nicht das richtige End-Datum bekommen ")
                    # end if
                else:
                    wb_obj.log.write_info(f"yahoo-finance: Kurs ist leer durch Reduzierung")
                # end if
            else:
                wb_obj.log.write_info(f"yahoo-finance: Kurs war leer null Werte")
            # end if
        else:
            wb_obj.log.write_info(f"yahoo-finance: Kurs nicht gefunden ")
        # end if
    # end if
    return (status, errtext, wp_dict)
# end def
def get_new_price_vol_from_eodhd(wb_obj,  wp_dict):
    """
    :param wb_obj:
    :param isin_info_dict_liste:
    :param wp_dict:
        (status, errtext, wp_dict) = get_new_price_vol_from_eodhd(wb_obj, wp_dict)
    """
    status = hdef.OKAY
    errtext = ""

    if wp_dict["updated"]:
        pass # wb_obj.log.write_info(f"end-of-day-hd: {i+1}./{n} Wert Daten sind upgedated für wpname = {wp_dict["name"]} mit isin = {wp_dict["isin"]}")
    else:
        isin = wp_dict["isin"]
        wpname = wp_dict["name"]
        wb_obj.log.write_info(f"end-of-day-hd: -------------------------------------------------------------------------------------------------------")
        wb_obj.log.write_info(f"end-of-day-hd: {wp_dict["i"]+1}./{wp_dict["n"]} Wert Versuche Daten von eodhd für {wpname = } mit {isin = } einzulesen")



        (flag_avail, symbol, exchange, currency, infotext) = wp_eodhd.is_info_available(isin, wb_obj.base_ddict["eodhd_key"])
        if len(infotext) > 0:
            wb_obj.log.write_info(infotext)
        # end if

        if flag_avail:

            wb_obj.log.write_info(f"end-of-day-hd: Ist vorhanden  symbol:exchange = {symbol}:{exchange} currency = {currency}")
            (status, errtext, infotext, np_obj_eodhd) = wp_eodhd.get_price_volume_data(symbol,
                                                                                    exchange,
                                                                                    currency,
                                                                                    wb_obj.base_ddict["eodhd_key"],
                                                                                    wp_np_dc.NpPriceVolumeClass)

            if status != hdef.OKAY:
                return (status, errtext, wp_dict)
            # end if

            if len(infotext) > 0:
                wb_obj.log.write_info(f"end-of-day-hd: Ist nicht korrekt\n{infotext}")
                np_obj_eodhd = None
            # end if
        else:
            np_obj_eodhd = None
        # else:
        #    wb_obj.log.write_info(f"end-of-day-hd: Ist nicht vorhanden")
        # end if

        # Währungs USDEuro
        if np_obj_eodhd != None:

            if np_obj_eodhd.is_currency("usd"):
                wb_obj.log.write_info(f"end-of-day-hd: Suche USD/euro-Kurse ")
                (status, errtext, np_obj_eodhd) = transfer_price_vol_fromto_euro(wb_obj, np_obj_eodhd,wb_obj.par.INDICES_USDEURO_NAME)
            elif np_obj_eodhd.is_currency("chf"):
                wb_obj.log.write_info(f"end-of-day-hd: Suche CHF/euro-Kurse ")
                (status, errtext, np_obj_eodhd) = transfer_price_vol_fromto_euro(wb_obj, np_obj_eodhd,wb_obj.par.INDICES_CHFEURO_NAME)
            # end if

            # keep end date
            np_obj_eodhd.reduce_end_dat(wp_dict["end_dat"])

            wp_dict["np_obj_new"]  = np_obj_eodhd
            wp_dict["updated"]     = True
            wp_dict["update_type"] = "endofdathd"
            wb_obj.log.write_info(f"end-of-day-hd: Kurs gefunden ")
        else:

            wb_obj.log.write_info(f"end-of-day-hd: Kurs nicht gefunden ")

        # end if
    # end if
    return (status, errtext, wp_dict)
# end def
def get_new_price_vol_from_ariva_requests(wb_obj,  wp_dict):
    """
    :param wb_obj:
    :param wp_dict:
        (status, errtext, wp_dict) = get_new_price_vol_from_yf(wb_obj, wp_dict)
    """
    status = hdef.OKAY
    errtext = ""

    if wp_dict["updated"]:
        pass # wb_obj.log.write_info(f"ariva-requests: {i+1}./{n} Wert Daten sind upgedated für wpname = {wp_dict["name"]} mit isin = {wp_dict["isin"]}")
    else:
        isin     = wp_dict["isin"]
        base_url = hstr.elim_e(wp_dict["url_ariva"],"/")
        url      = f"{base_url}/kurse/historische-kurse?currency=EUR"

        wb_obj.log.write_info(f"ariva-requests: {wp_dict["i"]+1}./{wp_dict["n"]} Wert Versuche Daten von ariva für name: {wp_dict["name"]} mit {isin = } einzulesen")

        np_obj_ariva = None
        if wp_req.requests_exists(url):

            wb_obj.log.write_info(f"ariva-requests: Ist vorhanden  {url = }")
            (status, errtext, infotext, np_obj_ariva) = wp_req.get_price_volume_data(url,
                                                                       wp_np_dc.NpPriceVolumeClass)

            if len(infotext) > 0:
                # wb_obj.log.write_info(f"ariva-requests: Ist nicht vorhanden")
                np_obj_ariva = None
            # end if

            if status != hdef.OKAY:
                return (status, errtext, wp_dict)
            # end if

        # else:
        #    wb_obj.log.write_info(f"ariva-requests: Ist nicht vorhanden")
        # end if

        # Währungs USDEuro
        if np_obj_ariva != None:

            if np_obj_ariva.is_currency("usd"):

                wb_obj.log.write_info(f"ariva-requests: Suche USD/euro-Kurse ")
                (status, errtext, np_obj_ariva) = transfer_price_vol_fromto_euro(wb_obj, np_obj_ariva,wb_obj.par.INDICES_USDEURO_NAME)

            elif np_obj_ariva.is_currency("chf"):

                wb_obj.log.write_info(f"ariva-requests: Suche CHF/euro-Kurse ")
                (status, errtext, np_obj_ariva) = transfer_price_vol_fromto_euro(wb_obj, np_obj_ariva,wb_obj.par.INDICES_CHFEURO_NAME)

            # end if

            # keep end date
            np_obj_ariva.reduce_end_dat(wp_dict["end_dat"])

            wp_dict["np_obj_new"]  = np_obj_ariva
            wp_dict["updated"]     = True
            wp_dict["update_type"] = "arivarequests"
            wb_obj.log.write_info(f"ariva-requests: Kurs gefunden ")
        else:
            wb_obj.log.write_info(f"ariva-requests: Kurs nicht gefunden ")
        # end if
    # end if
    return (status, errtext, wp_dict)
# end def
def get_new_price_vol_from_ariva(wb_obj,  wp_dict_liste):
    """
    :param wb_obj:
    :param wp_dict_liste:
        (status, errtext, wp_dict_liste) = get_new_price_vol_from_ariva(wb_obj,  wp_dict_liste)
    """
    status = hdef.OKAY
    errtext = ""

    # Build liste mit nicht gefundenen
    flag = False
    for wp_dict in wp_dict_liste:

        if not wp_dict["updated"]:
            flag = True
            break
        # end if
    # end for

    if flag:
        (status,errtext,wp_dict_liste) = wp_pw.get_ariva_price_volume_data(wp_dict_liste,
                                                                           wp_np_dc.NpPriceVolumeClass,
                                                                           wb_obj.base_ddict["ariva_user"],
                                                                           wb_obj.base_ddict["ariva_pw"],
                                                                           wb_obj.base_ddict["ariva_timeout_s"],
                                                                           wb_obj.log)
        if status != hdef.OKAY:
            return (status, errtext, wp_dict_liste)
        # end if
    # end if

    for i,wp_dict in enumerate(wp_dict_liste):

        # Währungs USDEuro
        if wp_dict["update_type"] == "ariva":


            if wp_dict["np_obj_new"].is_currency("usd"):
                wb_obj.log.write_info(f"ariva: Suche USD/euro-Kurse ")
                (status, errtext, wp_dict["np_obj_new"]) = transfer_price_vol_fromto_euro(wb_obj, wp_dict["np_obj_new"],
                                                                                   wb_obj.par.INDICES_USDEURO_NAME)
            elif wp_dict["np_obj_new"].is_currency("chf"):
                wb_obj.log.write_info(f"ariva: Suche CHF/euro-Kurse ")
                (status, errtext, wp_dict["np_obj_new"]) = transfer_price_vol_fromto_euro(wb_obj, wp_dict["np_obj_new"],
                                                                                   wb_obj.par.INDICES_CHFEURO_NAME)
            # end if

            wp_dict_liste[i] = wp_dict
        # end if
    # end for

    return (status, errtext, wp_dict_liste)
# end def
def get_new_price_vol_from_onvista(wb_obj, wp_dict_liste):
    """
    :param wb_obj:
    :param wp_dict_liste:
        (status, errtext, wp_dict_liste) = get_new_price_vol_from_onvista(wb_obj,  wp_dict_liste)
    """
    status = hdef.OKAY
    errtext = ""

    # Build liste mit nicht gefundenen
    flag = False
    for wp_dict in wp_dict_liste:

        if not wp_dict["updated"]:
            flag = True
            break
        # end if
    # end for

    if flag:
        (status, errtext, wp_dict_liste) = wp_pw.get_onvista_price_volume_data(wp_dict_liste,
                                                                             wp_np_dc.NpPriceVolumeClass,
                                                                             wb_obj.base_ddict["onvista_user"],
                                                                             wb_obj.base_ddict["onvista_pw"],
                                                                             wb_obj.base_ddict["onvista_timeout_s"],
                                                                             wb_obj.log)

        if status != hdef.OKAY:
            return (status, errtext, wp_dict_liste)
        # end if
    # end if

    for i, wp_dict in enumerate(wp_dict_liste):

        # Währungs USDEuro
        if wp_dict["update_type"] == "onvista":

            if  wp_dict["np_obj_new"].is_currency("usd"):
                wb_obj.log.write_info(f"onvista: Suche USD/euro-Kurse ")
                (status, errtext,  wp_dict["np_obj_new"]) = transfer_price_vol_fromto_euro(wb_obj,  wp_dict["np_obj_new"],
                                                                                      wb_obj.par.INDICES_USDEURO_NAME)
            elif  wp_dict["np_obj_new"].is_currency("chf"):
                wb_obj.log.write_info(f"onvista: Suche CHF/euro-Kurse ")
                (status, errtext,  wp_dict["np_obj_new"]) = transfer_price_vol_fromto_euro(wb_obj,  wp_dict["np_obj_new"],
                                                                                      wb_obj.par.INDICES_CHFEURO_NAME)
            # end if

            wp_dict_liste[i] = wp_dict
        # end if
    # end for

    return (status, errtext, wp_dict_liste)


# end def
def get_new_price_vol_from_ariva_csv_file(wb_obj,  wp_dict, csv_file):
    """
    :param wb_obj:
    :param isin_info_dict:
    :param csv_file:
        (status, errtext, wp_dict) = get_new_price_vol_from_ariva_csv_lliste(wb_obj, wp_dict, csv_file)
    """
    status = hdef.OKAY
    errtext = ""

    # Build liste mit nicht gefundenen

    isin = wp_dict["isin"]
    wpname = wp_dict["name"]

    wb_obj.log.write_info(f"ariva-csv: Versuche Daten von ariva für {wpname = } mit {isin = } einzulesen")


    (status, errtext, infotext, np_obj_csv) = wp_bearb.get_price_volume_data_from_ariva_csv_file(
        csv_file,
        wb_obj.base_ddict["avira_price_volume_csv_trennzeichen"],
        wp_np_dc.NpPriceVolumeClass,
        wp_dict)


    if status != hdef.OKAY:
        if np_obj_csv.is_empty():
            wb_obj.log.write_info(f"ariva-csv: {csv_file = } mit {isin = } ist leer {errtext = }")
            status = hdef.OKAY
            errtext = ""
            wp_dict["updated"] = False
        # end if
        return (status, errtext, wp_dict)
    # end if


    # Währungs USDEuro
    if np_obj_csv != None:
        if np_obj_csv.is_currency("usd"):
            wb_obj.log.write_info(f"ariva-csv: Suche USD/euro-Kurse ")
            (status, errtext, np_obj_csv) = transfer_price_vol_fromto_euro(wb_obj, np_obj_csv,
                                                                                  wb_obj.par.INDICES_USDEURO_NAME)
        elif np_obj_csv.is_currency("chf"):
            wb_obj.log.write_info(f"ariva-csv: Suche CHF/euro-Kurse ")
            (status, errtext, np_obj_csv) = transfer_price_vol_fromto_euro(wb_obj, np_obj_csv,
                                                                                  wb_obj.par.INDICES_CHFEURO_NAME)
        # end if

        # keep end date
        np_obj_csv.reduce_end_dat(wp_dict["end_dat"])

        wp_dict["np_obj_new"]  = np_obj_csv
        wp_dict["updated"]     = True
        wp_dict["update_type"] = "arivacsv"
        wb_obj.log.write_info(f"ariva-csv: Kurs gefunden ")
    else:
        wb_obj.log.write_info(f"ariva-csv: Kurs nicht gefunden ")

    # end if

    return (status, errtext, wp_dict)
# end def
def transfer_price_vol_fromto_euro(wb_obj,np_price_vol,fromto):
    """
    :param wb_obj:
    :param np_obj_new:
    :return: (status,errtext,np_obj_new) = transfer_price_vol_fromto_euro(wb_obj,np_price_vol)
    """

    start_dat = np_price_vol.dat_np_array[0]
    end_dat   = np_price_vol.dat_np_array[-1]

    (status,errtext,np_dict_fromto) = wb_obj.get_dict_indice_from_start_dat_to_end_dat(fromto,start_dat,end_dat)
    if status == hdef.OKAY:
        np_fromto = np_dict_fromto[fromto]
        istart = 0
        float_array_dat_usdeuro = np.array(np_fromto.dat_np_array, dtype=np.float64)
        float_array_dat_price_vol = np.array(np_price_vol.dat_np_array, dtype=np.float64)

        for i,d in enumerate(float_array_dat_price_vol):

            index = np.abs(np_fromto.dat_np_array - d).argmin()

            (i0, i1, fact, istart) = wp_fkt.find_linear_interpol_index(float_array_dat_usdeuro, d, istart)

            usdeuro = (np_fromto.indice_np_array[i0] +
                       (np_fromto.indice_np_array[i1] - np_fromto.indice_np_array[i0]) * fact)

            np_price_vol.start_np_array[i] = np_price_vol.start_np_array[i] * usdeuro
            np_price_vol.high_np_array[i] = np_price_vol.start_np_array[i] * usdeuro
            np_price_vol.low_np_array[i] = np_price_vol.start_np_array[i] * usdeuro
            np_price_vol.end_np_array[i] = np_price_vol.start_np_array[i] * usdeuro

        # end for
        np_price_vol.currency = "euro"
    # end if

    return (status, errtext, np_price_vol)
# end def
def merge_and_update_file(wb_obj, wp_dict):
    """
    :param wb_obj:
    :param wp_dict_liste:
    :return: (status,errtext,wp_dict) = merge_and_update_file(wb_obj, wp_dict)
    """
    status = hdef.OKAY
    errtext = ""


    if wp_dict["updated"] and (wp_dict["update_type"] != "file"):

        wb_obj.log.write_info(
            f"-------------------------------------------------------------------------------------------------------")
        wb_obj.log.write_info(f"Update WP isin: {wp_dict["isin"]} Name: {wp_dict["name"]}")
        wb_obj.log.write_info(f"Update type: {wp_dict["update_type"]} ")

        if wp_dict["np_obj"] is None:
            nstart = -1
            np_obj = wp_dict["np_obj_new"]
        else:
            nstart = len(wp_dict["np_obj"].dat_np_array)

            (status, errtext, np_obj) = merge_np_data(wp_dict["np_obj"], wp_dict["np_obj_new"])

            if status != hdef.OKAY:
                return (status, errtext, wp_dict)
            # end if

        # end if

        nmerge = len(np_obj.dat_np_array)

        if nstart != nmerge:
            (status, errtext, filename) = save_np_data(wb_obj, wp_dict, np_obj)

            if status != hdef.OKAY:
                return (status, errtext, wp_dict)
            # end if

            wb_obj.log.write_info(f"Updated file: {filename} ")
        else:
            wb_obj.log.write_info(f"No Update nmerge == nstart ")
        # end if

    # end if
    return (status, errtext, wp_dict)
# end def
def merge_ariva_csv_and_update_file(wb_obj, wp_dict):
    """
    :param wb_obj:
    :param wp_dict:
    :return: (status,errtext,wp_dict) = merge_and_update_file(wb_obj, wp_dict)
    """
    status = hdef.OKAY
    errtext = ""




    if wp_dict["updated"]:

        wb_obj.log.write_info(
            f"-------------------------------------------------------------------------------------------------------")
        wb_obj.log.write_info(f"Update WP isin: {wp_dict["isin"]} Name: {wp_dict["name"]}")
        wb_obj.log.write_info(f"Update type: {wp_dict["update_type"]} ")

        np_obj_new = wp_dict["np_obj_new"]
        first_new_dat = None
        if np_obj_new is not None:
            if len(np_obj_new.dat_np_array) > 0:
                (first_new_dat, _) = np_obj_new.get_first_last_dat("dat")
            # end if
        # end if



        save_flag = False
        if wp_dict["np_obj"] is None:

            np_obj = wp_dict["np_obj_new"]

            if np_obj is not None:
                (first_dat_before_merge, _) = np_obj.get_first_last_dat("dat")
                save_flag = True
            else:
                first_dat_before_merge = None
        else:
            nstart = len(wp_dict["np_obj"].dat_np_array)

            (first_dat_before_merge, _) = wp_dict["np_obj"].get_first_last_dat("dat")

            if wb_obj.base_ddict["avira_price_volume_csv_is_master"] > 0:
                (status, errtext, np_obj) = merge_np_data( wp_dict["np_obj_new"],wp_dict["np_obj"])
            else:
                (status, errtext, np_obj) = merge_np_data(wp_dict["np_obj"], wp_dict["np_obj_new"])

            if status != hdef.OKAY:
                return (status, errtext, wp_dict)
            # end if
            nmerge = len(np_obj.dat_np_array)

            if nstart != nmerge:
                save_flag = True
            # end if
        # end if
        if save_flag:


            (status, errtext, filename) = save_np_data(wb_obj, wp_dict, np_obj)

            if status != hdef.OKAY:
                return (status, errtext, wp_dict)
            # end if


            wb_obj.log.write_info(f"Updated file: {filename} ")
        # end if
    else:
        wb_obj.log.write_info(f"No Update  ")
    # end if

    if save_flag or (wp_dict["np_obj_new"].is_empty == False):
        # basic_info_dict["start_ariva_dat_str"] bearbeiten
        (status, errtext) = save_start_ariva_dat_str(wb_obj, wp_dict, first_new_dat, first_dat_before_merge)
        if status != hdef.OKAY:
            return (status, errtext, wp_dict)

    return (status,errtext,wp_dict)
# end def
def save_start_ariva_dat_str(wb_obj, wp_dict,first_new_dat,first_dat_before_merge):
    """
    :param wb_obj:
    :param wp_dict:
    :param first_new_dat:           aus ariva-csv-Datei
    :param first_dat_before_merge:  aus bestehenden Datensatz
    :return: (status,errtext) = save_start_ariva_dat_str(wb_obj, wp_dict,first_new_dat,first_dat_before_merge)
    """

    status  = hdef.OKAY
    errtext = ""

    # Trage Anfangsdatum, was Ariva hergegeben hat ein
    if first_new_dat is not None:

        save_flag = False

        if first_dat_before_merge is not None:
            first_new_dat = min(first_new_dat, first_dat_before_merge)
        # end if

        # Lade basic info
        (status, errtext, basic_info_dict) = wb_obj.get_basic_info(wp_dict["isin"])
        if status != hdef.OKAY:
            return (status, errtext)

        # schreibe basic_info_dict["start_ariva_dat_str"]
        if len(basic_info_dict["start_ariva_dat_str"]) > 0:
            old_dat = htype.type_transform_direct(basic_info_dict["start_ariva_dat_str"],"datStrP","dat")

            if first_new_dat < old_dat:
                save_flag = True
                basic_info_dict["start_ariva_dat_str"] = htype.type_transform_direct(first_new_dat, "dat", "datStrP")
        else:
            save_flag = True
            basic_info_dict["start_ariva_dat_str"] = htype.type_transform_direct(first_new_dat, "dat", "datStrP")
        # end if

        if save_flag:
            (status, errtext) = wb_obj.save_basic_info(wp_dict["isin"], basic_info_dict)
            if status != hdef.OKAY:
                return (status, errtext)
            # end if
        # end if
    # end if

    return (status, errtext)
# end def
def merge_np_data(np_obj,np_obj_new):
    """
    :param wb_obj:
    :param isin:
    :param np_obj_new:
    :return: (status,errtext,np_obj) = merge_np_data(np_obj,np_obj_new)
    """

    status  = hdef.OKAY
    errtext = ""

    if np_obj is None:
        np_obj = np_obj_new
    else:

        np_obj.currency = np_obj_new.currency

        np_dat_akt = np_obj.dat_np_array
        np_dat_new = np_obj_new.dat_np_array

        day_seconds = 24 * 60 * 60
        sort_index_list = wp_fkt.build_sort_list_of_index(list(np_dat_akt), list(np_dat_new), day_seconds)

        if len(sort_index_list):
            # "dat_np_array", "start_np_array", "high_np_array", "low_np_array", "end_np_array", "volume_np_array"

            np_dat_merge = np.array([], dtype=np.int64)
            np_start_merge = np.array([], dtype=np.float64)
            np_high_merge = np.array([], dtype=np.float64)
            np_low_merge = np.array([], dtype=np.float64)
            np_end_merge = np.array([], dtype=np.float64)
            np_volume_merge = np.array([], dtype=np.float64)


            for index,val in enumerate(sort_index_list):

                if val[0] == 0:
                    np_dat_merge   = np.append(np_dat_merge,np_obj.dat_np_array[val[1]:val[2]+1])
                    np_start_merge = np.append(np_start_merge,np_obj.start_np_array[val[1]:val[2]+1])
                    np_high_merge = np.append(np_high_merge,np_obj.high_np_array[val[1]:val[2]+1])
                    np_low_merge = np.append(np_low_merge,np_obj.low_np_array[val[1]:val[2]+1])
                    np_end_merge = np.append(np_end_merge,np_obj.end_np_array[val[1]:val[2]+1])
                    np_volume_merge = np.append(np_volume_merge,np_obj.volume_np_array[val[1]:val[2]+1])
                else:
                    np_dat_merge   = np.append(np_dat_merge,np_obj_new.dat_np_array[val[1]:val[2]+1])
                    np_start_merge = np.append(np_start_merge,np_obj_new.dat_np_array[val[1]:val[2] + 1])
                    np_high_merge = np.append(np_high_merge,np_obj_new.high_np_array[val[1]:val[2]+1])
                    np_low_merge = np.append(np_low_merge,np_obj_new.low_np_array[val[1]:val[2]+1])
                    np_end_merge = np.append(np_end_merge,np_obj_new.end_np_array[val[1]:val[2]+1])
                    np_volume_merge = np.append(np_volume_merge,np_obj_new.volume_np_array[val[1]:val[2]+1])

                # end if
            # end for
            val = np_start_merge[-1]

            np_obj = wp_np_dc.NpPriceVolumeClass(np_dat_merge,
                                                 np_start_merge,
                                                 np_high_merge,
                                                 np_low_merge,
                                                 np_end_merge,
                                                 np_volume_merge)
        # end if
    # end if
    return (status, errtext, np_obj )
# end def
def save_np_data(wb_obj,wp_dict,np_obj):
    """
    :param wb_obj:
    :param np_obj:
    :param wp_dict:
    :return:  (status, errtext,filename) = save_np_data(wb_obj,wp_dict,np_obj)
    """
    (first_dat_str, last_dat_str) = np_obj.get_first_last_dat("datStrP")
    wb_obj.updat_first_last_in_basic_info(wp_dict["isin"], first_dat_str, last_dat_str)

    file_name = wp_storage.build_file_name_json(wb_obj.base_ddict["price_volumen_pre_file_name"] + wp_dict["isin"],
                                                wb_obj.base_ddict["store_path"])
    formatpj = int(wb_obj.base_ddict["price_volumen_use_format"] % 10)
    (status, errtext,filename) = wp_storage.save_np_obj(np_obj,file_name,formatpj)

    return (status, errtext,filename)
# end def
def get_exist_filenames(wp_obj, isin_input):
    """
    (status, errtext, filename_list) = wp_base_basic_info.get_exist_filenames(wb_obj, isin_input)
    """
    status = hdef.OKAY
    errtext = ""

    if isinstance(isin_input, str):
        isin_input = [isin_input]
    # end if

    filename_list = []
    for isin in isin_input:

        file_name = wp_storage.build_file_name_json(wp_obj.base_ddict["price_volumen_pre_file_name"] + isin,
                                                    wp_obj.base_ddict["store_path"])
        formatpj = int(wp_obj.base_ddict["price_volumen_use_format"] % 10)

        filename = wp_storage.get_filename_formated(file_name, formatpj)

        if isinstance(filename, list):
            filename_list += filename
        else:
            filename_list.append(filename)
        # end if

        filename_list2 = []
        for filename in filename_list:
            if os.path.isfile(filename):
                filename_list2.append(filename)
            # end if
        # endfor

    # end for
    return (status, errtext, filename_list2)
# end def
def get_csv_ariva_csv_lliste(wb_obj):
    """
    :param wb_obj:
    :return: (status, errtext, infotext, csv_lliste) = update_csv_ariva(wb_obj)
    csv_lliste = [ [filename1,wkn1], [filename2,wkn2], ...]
    """

    status = hdef.OKAY
    errtext = ""
    infotext = ""
    csv_lliste = []

    file_liste = []
    file_liste = hfp.get_liste_of_subdir_files(wb_obj.base_ddict["avira_price_volume_csv_store_path"],
                                               liste=file_liste,
                                               search_ext="csv")

    for filename in file_liste:
        (path,fbody,ext) = hfp.get_pfe(filename)
        index = hstr.such(fbody, wb_obj.base_ddict["avira_price_volume_csv_pre_file_name"])


        if index == 0:
            index = hstr.such(fbody, wb_obj.base_ddict["avira_price_volume_csv_post_file_name"])

            if index == (len(fbody) - len(wb_obj.base_ddict["avira_price_volume_csv_post_file_name"])):

                wkn = fbody[len(wb_obj.base_ddict["avira_price_volume_csv_pre_file_name"]):index]
                csv_lliste.append([filename,wkn])
            # end if
        # end if
    # end for

    return (status, errtext, infotext,csv_lliste)
# end if
def read_csv_ariva_file(wb_obj,csv_file,wkn):
    """
    :param wb_obj:
    :param csv_file:
    :param wkn:         Muss in infodict vorhanden sein
    :return: (status, errtext, infotext) = read_csv_ariva_file(wb_obj,csv_file,wkn
    """

    # status = hdef.OKAY
    errtext = ""
    infotext = ""

    (status,isin) = wb_obj.get_isin_from_wkn(wkn)

    if (status != hdef.OKAY) or (len(isin) == 0):
        infotext += wb_obj.errtext
    else:

        # Get basic_info_dict in a list
        (status, errtext, isin_wp_dict) = wb_obj.get_basic_info(isin)
        if status != hdef.OKAY:
            return (status, errtext, infotext)

        wp_dict_liste = [isin_wp_dict]
        (status, errtext, wp_dict_liste) = get_np_obj_liste(wb_obj, wp_dict_liste)
        if status != hdef.OKAY:
            return (status, errtext, infotext)
        # end if
        isin_wp_dict = wp_dict_liste[0]

        # Von csv_llise zu np_data_new erstellen
        (status, errtext, wp_dict) = get_new_price_vol_from_ariva_csv_file(wb_obj, isin_wp_dict, csv_file)
        if status != hdef.OKAY:
            return (status, errtext, infotext)

        (status, errtext, wp_dict_liste) = merge_ariva_csv_and_update_file(wb_obj, wp_dict)
        if status != hdef.OKAY:
            return (status, errtext, infotext)

        (status, errtext, infotext,wp_dict_liste) = proof_np_obj_liste_data(wb_obj, [wp_dict])
        if status != hdef.OKAY:
            return (status, errtext, infotext)

        if wb_obj.base_ddict["avira_price_volume_csv_delete"] > 0:
            wb_obj.log.write_info(f"Delete file from Disc: {csv_file} ")
            hfp.remove_file(csv_file)
        # end if

    # end if

    return (status, errtext, infotext)
# end def
def proof_np_obj_liste_data(wb_obj,wp_dict):
    """
    :param wb_obj:
    :param wp_dict:
         (status, errtext, infotext,wp_dict) = proof_np_obj_liste_data(wb_obj,wp_dict)
    """

    status = hdef.OKAY
    errtext = ""
    infotext = ""

    wb_obj.log.write_info(f"WP proof np_obj:  isin: {wp_dict['isin']} wkn: {wp_dict['wkn']} name: {wp_dict['name']}")
    wp_dict["changed"] = False

    if wp_dict["np_obj"] is None:

        infotext = f"{infotext}\nisin={wp_dict['isin']},wkn={wp_dict['wkn']}: np_obj ist None => d.h. nicht vorhanden"

    else:

        # Schaue nach den nan in Datensatz
        flag = wp_dict["np_obj"].interpolate_nan_items()

        if flag:
            infotext = f"{infotext}\nisin={wp_dict['isin']}: np_obj wurden nans interpoliert ]"
            wp_dict["changed"] = True
        # end if

        # Schaue nach Ausreißer im Datensatz
        flag = wp_dict["np_obj"].interpolate_Ausreisser()

        if flag:
            infotext = f"{infotext}\nisin={wp_dict['isin']}: np_obj wurden Ausreißer interpoliert ]"
            wp_dict["changed"] = True
        # end if

    # end if
    return (status, errtext, infotext,wp_dict)
# end def
def proof_wp_dict(wb_obj, wp_dict):
    """
    :param wb_obj:
    :param wp_dict:
        (status, errtext, infotext, wp_dict) = proof_wp_dict(wb_obj, wp_dict)
    """
    status = hdef.OKAY
    errtext = ""
    infotext = ""

    wp_dict["changed"] = False
    wb_obj.log.write_info(f"WP proof wp_dict:  isin: {wp_dict['isin']} wkn: {wp_dict['wkn']} name: {wp_dict['name']}")

    if wp_dict["np_obj"] is None:

        infotext = f"{infotext}\nisin={wp_dict['isin']},wkn={wp_dict['wkn']}: np_obj ist None => d.h. nicht vorhanden"
        if isinstance(wp_dict["first_dat_str"], str):
            if len(wp_dict["first_dat_str"]) > 0:
                wp_dict["first_dat_str"] = ""
                wp_dict["changed"] = True
            # end if
        elif isinstance(wp_dict["first_dat_str"], int):
            wp_dict["first_dat_str"] = ""
            wp_dict["changed"] = True

        if isinstance(wp_dict["last_dat_str"], str):
            if len(wp_dict["last_dat_str"]) > 0:
                wp_dict["last_dat_str"] = ""
                wp_dict["changed"] = True
            # end if
        elif isinstance(wp_dict["last_dat_str"], int):
            wp_dict["last_dat_str"] = ""
            wp_dict["changed"] = True

    else:
        (first_dat_str,last_dat_str) = wp_dict["np_obj"].get_first_last_dat("datStrP")

        if wp_dict["first_dat_str"] != first_dat_str:
            wp_dict["first_dat_str"] = first_dat_str
            wp_dict["changed"] = True

        if wp_dict["last_dat_str"] != last_dat_str:
            wp_dict["last_dat_str"] = last_dat_str
            wp_dict["changed"] = True

    # end if
    return (status, errtext, infotext,wp_dict)
# end def
