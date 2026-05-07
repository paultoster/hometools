
import os, sys
import numpy as np

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
# import tools.hfkt_dict as hdict
import tools.hfkt_type as htype

from wp_abfrage import wp_storage
from wp_abfrage import wp_fkt

from wp_abfrage import wp_np_dataclass as wp_np_dc
from wp_abfrage import wp_base
from wp_abfrage import wp_playwright as wp_pw
from wp_abfrage import wp_yahoofinance as wp_yf



def update(wb_obj,isin_liste):
    """
        (status,errtext) = wp_base_price_volume.update(wb_obj,isin_liste)
    """

    # Get basic_info_dict in a list
    (status, errtext, isin_info_dict_liste) = wb_obj.get_basic_info(isin_liste)
    if status != hdef.OKAY:
        return (status, errtext)


    wp_dict_liste = isin_info_dict_liste
    # get np_obj, start_dat and end_dat into wp_dict_liste
    (status, errtext, wp_dict_liste) = get_np_obj_liste(wb_obj,wp_dict_liste)

    (status,errtext) = update_start_to_end_dat(wb_obj,wp_dict_liste)

    return (status,errtext)
# end if
def get_np_obj_liste(wb_obj,wp_dict_liste):
    """
        (status, errtext, wp_dict_liste) = get_np_obj_liste(wb_obj,isin_info_dict_liste)

        build  wp_dict_liste mit:
            wp_dict_liste[i]["np_obj"]
            wp_dict_liste[i]["start_dat"]
            wp_dict_liste[i]["start_display_dat"]
            wp_dict_liste[i]["end_dat"]
            wp_dict_liste[i]["end_display_dat"]
            wp_dict_liste[i]["updated"] = False
            wp_dict_liste[i]["np_obj_new"] = None
    """
    status = hdef.OKAY
    errtext = ""

    for i,wp_dict in enumerate(wp_dict_liste):

        # Gibt es bereits eine Datei
        file_name = wp_storage.build_file_name_json(wb_obj.base_ddict["price_volumen_pre_file_name"] + wp_dict["isin"],
                                                    wb_obj.base_ddict["store_path"])

        formatpj = int(wb_obj.base_ddict["price_volumen_use_format"]/10)
        flag = wp_storage.np_obj_storage_exist(file_name,formatpj)

        # Wenn ja lese Datei ein
        if flag:
            (status, errtext, np_obj) = wp_storage.read_np_obj(wp_np_dc.NpPriceVolumeClass,
                                                               file_name,
                                                               formatpj)
            if status != hdef.OKAY:
                return (status, errtext,wp_dict_liste)

            #lese letztes Datum aus
            (status, errtext, _, _, last_dat_for_begin) = get_number_of_np_obj(wb_obj, np_obj)
            if status != hdef.OKAY:
                return (status, errtext,wp_dict_liste)

        # Wenn nein setze erstes Datum aus ini
        else:
            np_obj = None
            last_dat_for_begin = htype.type_transform_direct(wb_obj.base_ddict["price_volumen_first_dat"], "datStrP", "dat")
        # end if

        wp_dict["np_obj"] = np_obj

        # Start Datum

        start_dat         = last_dat_for_begin
        # letztes Datum in Datensatz
        (status, errtext, _, _, lastdat) = get_number_of_np_obj(wb_obj, np_obj)
        if status != hdef.OKAY:
            return (status, errtext)
        # end if
        if lastdat > start_dat:
            start_dat = lastdat
        # end if
        start_display_dat = htype.type_transform_direct(start_dat, "dat", "datStrP")

        wp_dict["start_dat"] = start_dat
        wp_dict["start_display_dat"] = start_display_dat


        # Was ist der letzte aktuelle Handelsdatum
        end_dat_time_list = wp_fkt.letzter_beendeter_handelstag_dat_list(wb_obj.base_ddict["boerse"])
        end_display_dat = htype.type_transform_direct(end_dat_time_list, "datTimeList", "datStrP")
        end_dat = htype.type_transform_direct(end_dat_time_list, "datTimeList", "dat")

        wp_dict["end_dat"] = end_dat
        wp_dict["end_display_dat"] = end_display_dat

        range = 24 * 60 * 60
        if end_dat >= start_dat+range:

            wp_dict["updated"] = False
            wp_dict["update_type"] = ""
            wp_dict["np_obj_new"] = None
        else:
            wp_dict["updated"] = True
            wp_dict["update_type"] = "file"
            wp_dict["np_obj_new"] = wp_dict["np_obj"]
        #end if

        wp_dict_liste[i] = wp_dict
    # end for
    return (status, errtext, wp_dict_liste)
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

    if (np_obj is not None) and isinstance(np_obj.dat_np_array, (np.ndarray, np.generic)):
        number   = len(np_obj.dat_np_array)
        firstdat = int(np_obj.dat_np_array[0])
        lastdat  = int(int(np_obj.dat_np_array[-1]))

    return (status, errtext,number,firstdat,lastdat)
# end def
def update_start_to_end_dat(wb_obj,wp_dict_liste):
    """
        (status, errtext) = update_start_to_end_dat(wb_obj,wp_dict_liste)
    """


    (status,errtext,wp_dict_liste) = get_new_price_vol_from_start_dat_to_end_dat(wb_obj,wp_dict_liste)
    if status != hdef.OKAY:
        return (status, errtext)
    # end if

    for wp_dict in wp_dict_liste:

        if wp_dict["updated"] and wp_dict["update_type"] != "file":

            (status,errtext,np_obj) = merge_np_data(wp_dict["np_obj"],wp_dict["np_obj_new"])
            if status != hdef.OKAY:
                return (status, errtext)
            # end if

            file_name = wp_storage.build_file_name_json(wb_obj.base_ddict["price_volumen_pre_file_name"] + wp_dict["isin"],
                                                        wb_obj.base_ddict["store_path"])
            formatpj = int(wb_obj.base_ddict["price_volumen_use_format"] % 10)
            wp_storage.save_np_obj(np_obj,file_name,formatpj)
        # end if
    # end for
    return (status,errtext)
# end def
def get_new_price_vol_from_start_dat_to_end_dat(wb_obj,wp_dict_liste):
    """

    :param wb_obj:
    :param isin:
    :param start_dat:
    :param end_dat:
    :return: (status,errtext,wp_dict_liste) = get_new_price_vol_from_start_dat_to_end_dat(wb_obj,isin_info_dict_liste,wp_dict_liste)
    """

    (status, errtext, wp_dict_liste) = get_new_price_vol_from_yf(wb_obj, wp_dict_liste)

    (status, errtext, wp_dict_liste) = get_new_price_vol_from_ariva(wb_obj, wp_dict_liste)

    (status, errtext, wp_dict_liste) = get_new_price_vol_from_onvista(wb_obj, wp_dict_liste)

    return (status,errtext,wp_dict_liste)
# end def
def get_new_price_vol_from_yf(wb_obj,  wp_dict_liste):
    """
    :param wb_obj:
    :param isin_info_dict_liste:
    :param wp_dict_liste:
        (status, errtext, wp_dict_liste) = get_new_price_vol_from_yf(wb_obj, wp_dict_liste)
    """
    status = hdef.OKAY
    errtext = ""

    # Build liste mit nicht gefundenen

    for i, wp_dict in enumerate(wp_dict_liste):

        if wp_dict["updated"]:
            pass
        else:
            isin = wp_dict["isin"]
            wpname = wp_dict["name"]
            ticker = wp_dict["ticker"]
            wb_obj.log.write_info(f"yahoo-finance: Lese Daten von yahhoo für {wpname = } mit {isin = } ein")

            np_obj_yf = None
            if wp_yf.is_Ticker_info_available(ticker):

                wb_obj.log.write_info(f"yahoo-finance: versuche  {ticker = }")
                (status, errtext, np_obj_yf) = wp_yf.get_price_volume_data(ticker,
                                                                           wp_np_dc.NpPriceVolumeClass,
                                                                           wp_dict["start_dat"],
                                                                           wp_dict["end_dat"])

                if status != hdef.OKAY:
                    return (status, errtext, wp_dict_liste)
                # end if

            elif len(ticker) > 0:

                ticker = ticker + ".DE"
                if wp_yf.is_Ticker_info_available(ticker):

                    wb_obj.log.write_info(f"yahoo-finance: versuche  {ticker = }")

                    (status, errtext, np_obj_yf) = wp_yf.get_price_volume_data(ticker,
                                                                               wp_np_dc.NpPriceVolumeClass,
                                                                               wp_dict["start_dat"],
                                                                               wp_dict["end_dat"])

                    if status != hdef.OKAY:
                        return (status, errtext, wp_dict_liste)
                    # end if

                # end if
            # end if

            # Währungs USDEuro
            if np_obj_yf != None:
                if np_obj_yf.currency.find("usd") == 0:
                    wb_obj.log.write_info(f"yahoo-finance: Suche USD/euro-Kurse ")
                    (status, errtext, np_obj_yf) = transfer_price_vol_from_usd_to_euro(wb_obj, np_obj_yf)
                # end if
                wp_dict["np_obj_new"]  = np_obj_yf
                wp_dict["updated"]     = True
                wp_dict["update_type"] = "yf"
                wb_obj.log.write_info(f"yahoo-finance: Kurs gefunden ")
            else:
                wb_obj.log.write_info(f"yahoo-finance: Kurs nicht gefunden ")

            # end if

            wp_dict_liste[i] = wp_dict
        # end if
    # end for
    return (status, errtext, wp_dict_liste)
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

            if wp_dict["np_obj_new"].currency.find("usd") == 0:
                (status, errtext, wp_dict["np_obj_new"]) = transfer_price_vol_from_usd_to_euro(wb_obj, wp_dict["np_obj_new"])
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

            if np_obj_new.currency.find("usd") == 0:
                (status, errtext, wp_dict["np_obj_new"]) = transfer_price_vol_from_usd_to_euro(wb_obj,
                                                                                               wp_dict["np_obj_new"])
            # end if

            wp_dict_liste[i] = wp_dict
        # end if
    # end for

    return (status, errtext, wp_dict_liste)


# end def
def transfer_price_vol_from_usd_to_euro(wb_obj,np_price_vol):
    """
    :param wb_obj:
    :param np_obj_new:
    :return: (status,errtext,np_obj_new) = transfer_price_vol_from_usd_to_euro(wb_obj,np_price_vol)
    """

    start_dat = np_price_vol.dat_np_array[0]
    end_dat   = np_price_vol.dat_np_array[-1]

    (status,errtext,np_usdeuro) = wb_obj.get_usdeuro_from_start_dat_to_end_dat(start_dat,
                                                                               end_dat)

    if status == hdef.OKAY:

        start_np_array = np.array([], dtype=np.float64)
        high_np_array = np.array([], dtype=np.float64)
        low_np_array = np.array([], dtype=np.float64)
        end_np_array = np.array([], dtype=np.float64)


        for i,d in enumerate(np_price_vol.dat_np_array):
            index = np.abs(np_usdeuro.dat_np_array - d).argmin()

            start_np_array = np.append(np_price_vol.start_np_array[i],np_usdeuro.usdeuro_np_array[index])
            high_np_array = np.append(np_price_vol.high_np_array[i] , np_usdeuro.usdeuro_np_array[index])
            low_np_array = np.append(np_price_vol.low_np_array[i] , np_usdeuro.usdeuro_np_array[index])
            end_np_array = np.append(np_price_vol.end_np_array[i] , np_usdeuro.usdeuro_np_array[index])
        # end for

        np_price_vol.start_np_array = start_np_array
        np_price_vol.high_np_array = high_np_array
        np_price_vol.low_np_array = low_np_array
        np_price_vol.end_np_array = end_np_array

        np_price_vol.currency = "euro"
    # end if

    return (status, errtext, np_price_vol)
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

        half_day_seconds = 24 * 60 * 60
        sort_index_list = wp_fkt.build_sort_list_of_index(list(np_dat_akt), list(np_dat_new), half_day_seconds)

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

            np_obj = wp_np_dc.NpPriceVolumeClass(np_dat_merge,
                                                 np_start_merge,
                                                 np_high_merge,
                                                 np_low_merge,
                                                 np_end_merge,
                                                 np_volume_merge)
        # end if
    # end if
    return (status, errtext, np_obj )




