import os, sys
import numpy as np

# from hfkt_log import log

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_type as htype

from wp_abfrage import wp_storage
from wp_abfrage import wp_fkt

from wp_abfrage import wp_np_dataclass as wp_np_dc
from wp_abfrage import wp_yahoofinance as wp_yfinance
from wp_abfrage import wp_bearbeiten as wp_bearbeit

def process_akt(wb_obj):
    """

    :param wb_obj:
    :return: (status, errtext) = process_akt(wp_obj)
    """

    np_obj = wp_bearbeit.read_indice_np_data(wb_obj.par.INDICES_USDEURO_NAME)
    if (np_obj is None) or np_obj.is_empty():
        last_dat = htype.type_transform_direct(wb_obj.base_ddict["price_volumen_first_dat"], "datStrP", "dat")
    else:
        (_,last_dat) = np_obj.get_first_last_dat("dat")

    # Was ist der letzte aktuelle Handelsdatum
    end_dat_time_list = wp_fkt.letzter_beendeter_handelstag_dat_list(wb_obj.base_ddict["boerse"])
    end_dat = htype.type_transform_direct(end_dat_time_list, "datTimeList", "dat")

    (status, errtext, np_obj_new) = wp_yfinance.get_usdeuro_data(wp_np_dc.NpUsdEuroClass,last_dat,end_dat)
    #    (status, errtext, np_obj) = wp_yfinance.get_chfeuro_data(wp_np_dc.NpUsdEuroClass, lastdat, end_dat)
    if status != hdef.OKAY:
        return (status, errtext)


    wb_obj.log.write_info(f"Update usdeuro course:")

    if np_obj is None:
        np_obj = np_obj_new
    else:

        if isinstance(np_obj.dat_np_array, (np.ndarray, np.generic)):
            (status, errtext, np_obj) = merge_usdeuro_np_obj_new_to_np_obj(np_obj,np_obj_new)
            if status != hdef.OKAY:
                return (status, errtext)
        else:
            np_obj = np_obj_new
        # end if
    # end if

    np_obj.save()

    wb_obj.log.write_info(f"Update of file: {np_obj.get_filename()}")

    del np_obj

    return (status,errtext)
# end def
def merge_usdeuro_np_obj_new_to_np_obj(np_obj,np_obj_new):
    """

    :param df:
    :param df_new:
    :param dat_name:
    :param usdeuro_name: (status, errtext, df_merge) = obj.merge_usdeuro_dfnew_to_df(df,df_new, dat_name,usdeuro_name)
    :return:
    """
    status = hdef.OKAY
    errtext = ""

    np_dat_akt = np_obj.dat_np_array
    np_dat_new = np_obj_new.dat_np_array

    half_day_seconds = 24 * 60 * 60
    sort_index_list = wp_fkt.build_sort_list_of_index(list(np_dat_akt), list(np_dat_new), half_day_seconds)

    if len(sort_index_list):
        np_usdeuro_akt = np_obj.indice_np_array
        np_usdeuro_new = np_obj_new.indice_np_array

        np_dat_merge = np.array([], dtype=np.int64)
        np_usdeuro_merge = np.array([], dtype=np.float64)


        for index,val in enumerate(sort_index_list):

            if val[0] == 0:
                np_dat_merge = np.append(np_dat_merge,np_dat_akt[val[1]:val[2]+1])
                np_usdeuro_merge = np.append(np_usdeuro_merge,np_usdeuro_akt[val[1]:val[2]+1])
            else:
                np_dat_merge = np.append(np_dat_merge,np_dat_new[val[1]:val[2]+1])
                np_usdeuro_merge = np.append(np_usdeuro_merge,np_usdeuro_new[val[1]:val[2] + 1])
            # end if
        # end for

        np_obj = wp_np_dc.NpUsdEuroClass(np_dat_merge, np_usdeuro_merge)

    # end if
    return (status, errtext, np_obj )
# end def
def get_from_start_dat_to_end_dat(wb_obj, start_dat, end_dat,fromto=None):
    """
    :param wb_obj:
    :param start_dat:
    :param end_dat:
    :return: (status, errtext,np_obj) = wp_base_usdeuro.get_from_start_dat_to_end_dat(wb_obj, start_dat, end_dat)
    """
    status = hdef.OKAY
    errtext = ""

    np_obj = wp_bearbeit.read_indice_np_data(wb_obj.par.INDICES_USDEURO_NAME)
    if (np_obj is None) or np_obj.is_empty():
        last_dat = -1
        first_dat = -1
    else:
        (first_dat,last_dat) = np_obj.get_first_last_dat("dat")
    # end if

    # Prüfe ob start-Datum, dass gesucht wird vor dem ersten Datum aus Datei => Fehler
    if (last_dat == -1) or (first_dat == -1):
        status = hdef.NOT_OKAY
        errtext = f"get_from_start_dat_to_end_dat: Keine Daten gespeichert!!"
        return (status, errtext,None)
    # end def
    if start_dat < first_dat:
        status = hdef.NOT_OKAY
        firstdatstr = htype.type_transform_direct(first_dat, "dat", "datStrP")
        startdatstr = htype.type_transform_direct(start_dat, "dat", "datStrP")
        errtext = f"get_from_start_dat_to_end_dat: Das start_datum: {startdatstr} liegt vor dem ersten gespeichertem Datum {firstdatstr}"
        return (status, errtext,None)
    # end def

    # Update auf aktuelles Datum, wenn gesuchtes Enddatum größer als letztes gespeichertes Datum
    if end_dat > last_dat:
        # Update der fehlenden Werte bis zum letzten Handelstag einschließlich
        (status, errtext) = process_akt(wb_obj)

        if status != hdef.OKAY:
            return (status, errtext,None)
        # end if

        np_obj = wp_bearbeit.read_indice_np_data(wb_obj.par.INDICES_USDEURO_NAME)
    # end def

    range = 24*60*60

    # Suche den Indize-Bereich für von start nach end mit dem range von einem Tag
    (start_index,end_index,_,_) = wp_fkt.find_index_range(list(np_obj.dat_np_array),
                                                          start_dat,
                                                          end_dat,
                                                          range)

    # Prüfung, ob gefunden
    if (start_index is None) or (end_index is None):
        status = hdef.NOT_OKAY

        errtext = f"Für Auslesen USD-Euro konnte  das Datum zwischen {start_dat = } und {end_dat = } konnte nicht gefunden werden."
    # Stutze Vektoren auf den Indize-Bereich ein
    else:
        np_obj.dat_np_array = np_obj.dat_np_array[start_index:end_index+1]
        np_obj.indice_np_array = np_obj.indice_np_array[start_index:end_index+1]
    # end if

    # print(f"{start_index =},{end_index =},dat_np_array_len = {len(np_obj.dat_np_array)}")
    # print(f"start_dat = {htype.type_transform_direct(start_dat, "dat", "datStrP")}")
    # print(f"end_dat = {htype.type_transform_direct(end_dat, "dat", "datStrP")}")
    # print(f"dat_np_array[0] = {htype.type_transform_direct(np_obj.dat_np_array[0], "dat", "datStrP")}")
    # print(f"dat_np_array[-1] = {htype.type_transform_direct(np_obj.dat_np_array[-1], "dat", "datStrP")}")

    return (status, errtext, np_obj)
# end def
def get_act(wb_obj):
    status = hdef.OKAY
    errtext = ""

    np_obj = wp_bearbeit.read_indice_np_data(wb_obj.par.INDICES_USDEURO_NAME)

    return (status,errtext,np_obj)
# end def
def get_datums_reihe(wb_obj,start_dat,end_dat):
    """
        (status, errtext,dat_np_array) = get_datums_reihe_von_usdeuro(wb_obj,end_dat)
    """
    #
    # Hole korrekte Datumsreihe:
    (status, errtext, np_obj) = get_from_start_dat_to_end_dat(wb_obj, start_dat, end_dat)

    if np_obj is not None:
        np_obj.reduce_end_dat(end_dat)

        dat_np_array = np_obj.dat_np_array
    else:
        dat_np_array = None
        status = hdef.NOT_OKAY
        errtext = f"get_datums_reihe: Keine Datumreihe für USDEuro gefunden"
    # end if

    return (status, errtext,dat_np_array)
# end def
