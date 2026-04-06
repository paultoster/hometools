
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
    flag_use_json = wb_obj.base_ddict["use_json"] == 2
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
        lastdat = htype.type_transform_direct(wb_obj.basic_dict["price_volumen_first_dat "], "datStrP", "dat")
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
    number = 0
    firstdat = 0
    lastdat = 0

    if isinstance(np_obj.dat_np_array, (np.ndarray, np.generic)):
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

    (status,errtext,np_obj_new) = process_start_end_dat(wb_obj,isin,start_dat,end_dat)

    return (status,errtext)
# end def
def process_start_end_dat(wb_obj, isin, start_dat,end_dat):
    """

    :param wb_obj:
    :param isin:
    :param start_dat:
    :param end_dat:
    :return: (status,errtext,np_obj) = process_start_end_dat(wb_obj, isin, start_dat,end_dat)
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
        (status, errtext, np_obj_yf) = wp_yf.get_price_volume_data(ticker,wp_np_dc.NpPriceVolumeClass,start_dat,end_dat)

        if status != hdef.OKAY:
            return (status, errtext, None)

        # Währungs USDEuro
        ######

    return (status,errtext,np_obj)
# end def
