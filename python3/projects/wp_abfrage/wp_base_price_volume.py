
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
from wp_abfrage import wp_yahoofinance as wp_yfinance
from wp_abfrage import wp_yahoofinance as wp_yf



def update(wb_obj,isin):
    """
        (status,errtext) = wp_base_price_volume.update(wb_obj,isin)
    """

    # Gibt es bereits eine Datei
    flag_use_json = (wb_obj.base_ddict["use_json"] == 2) or (wb_obj.base_ddict["use_json"] == 3)
    flag = wp_storage.np_obj_storage_exist(isin,
                                           flag_use_json,
                                           wb_obj.base_ddict["price_volumen_pre_file_name"],
                                           wb_obj.base_ddict["store_path"])
    # Wenn ja lese Datei ein
    if flag:
        (status, errtext, np_obj) = wp_storage.read_np_obj(wp_np_dc.NpPriceVolumeClass,
                                                           isin,
                                                           flag_use_json,
                                                           wb_obj.base_ddict["price_volumen_pre_file_name"],
                                                           wb_obj.base_ddict["store_path"])
        if status != hdef.OKAY:
            return (status, errtext)

        #lese letztes Datum aus
        (status, errtext, _, _, lastdat) = get_number_of_np_obj(wb_obj, np_obj)
        if status != hdef.OKAY:
            return (status, errtext)

    # Wenn nein setze erstes Datum aus ini
    else:
        np_obj = None
        lastdat = htype.type_transform_direct(wb_obj.base_ddict["price_volumen_first_dat"], "datStrP", "dat")
    # end if

    # Start Datum
    start_display_dat = htype.type_transform_direct(lastdat, "dat", "datStrP")
    start_dat = lastdat


    # Was ist der letzte aktuelle Handelsdatum
    end_dat_time_list = wp_fkt.letzter_beendeter_handelstag_dat_list(wb_obj.base_ddict["boerse"])
    end_display_dat = htype.type_transform_direct(end_dat_time_list, "datTimeList", "datStrP")
    end_dat = htype.type_transform_direct(end_dat_time_list, "datTimeList", "dat")

    print(f"Suche Update für start: {start_display_dat} bis end: {end_display_dat}")


    (status,errtext) = update_start_to_end_dat(wb_obj,isin,start_dat,end_dat,np_obj)

    return (status,errtext)
# end if
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
def update_start_to_end_dat(wb_obj,isin,start_dat,end_dat,np_obj):
    """
        (status, errtext) = update_start_to_end_dat(wb_obj, isin, start_dat, end_dat)
    """

    # letztes Datum in Datensatz
    (status, errtext, _, _, lastdat) = get_number_of_np_obj(wb_obj, np_obj)
    if status != hdef.OKAY:
        return (status, errtext)

    if lastdat > start_dat:
        start_dat = lastdat

    (status,errtext,np_obj_new) = get_price_vol_from_start_dat_to_end_dat(wb_obj,isin,start_dat,end_dat)
    if status != hdef.OKAY:
        return (status, errtext)

    (status,errtext,np_obj) = merge_np_data(np_obj,np_obj_new)
    if status != hdef.OKAY:
        return (status, errtext)

    flag_use_json = (wb_obj.base_ddict["use_json"] == 1) or (wb_obj.base_ddict["use_json"] == 3)

    wp_storage.save_np_obj(np_obj,
                           isin,
                           flag_use_json,
                           wb_obj.base_ddict["price_volumen_pre_file_name"],
                           wb_obj.base_ddict["store_path"])

    return (status,errtext)
# end def
def get_price_vol_from_start_dat_to_end_dat(wb_obj, isin, start_dat,end_dat):
    """

    :param wb_obj:
    :param isin:
    :param start_dat:
    :param end_dat:
    :return: (status,errtext,np_obj) = get_price_vol_from_start_dat_to_end_dat(wb_obj, isin, start_dat,end_dat)
    """
    status = hdef.OKAY
    errtext = ""

    print("Hole basic infos")
    (status, errtext, isin_basic_dict) = wb_obj.get_basic_info(isin)
    if status != hdef.OKAY:
        return (status, errtext,None)

    wpname = isin_basic_dict["name"]
    ticker = isin_basic_dict["ticker"]
    print(f"Lese Daten für {wpname = } mit {isin = } ein")

    if len(ticker) != 0:
        (status, errtext, np_obj_yf) = wp_yf.get_price_volume_data(ticker,
                                                                   wp_np_dc.NpPriceVolumeClass,
                                                                   start_dat,
                                                                   end_dat)

        if status != hdef.OKAY:
            return (status, errtext, None)
        # end if
    else:
        status  = hdef.NOT_OKAY
        errtext = f"get_price_vol_from_start_dat_to_end_dat: Es konnte kein Methode zum Einlesen von Wertpapier {wpname = },{isin = } "
        return (status, errtext, None)
    # end if

    # Währungs USDEuro
    if  np_obj_yf.currency.find("usd") == 0:
        (status,errtext,np_obj_yf) = transfer_price_vol_from_usd_to_euro(wb_obj,np_obj_yf)
    # end if

    return (status,errtext,np_obj_yf)
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
        np_dat_akt = np_obj.dat_np_array
        np_dat_new = np_obj_new.dat_np_array

        half_day_seconds = 12 * 60 * 60
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




