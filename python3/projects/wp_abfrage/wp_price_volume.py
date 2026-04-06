import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_type as htype


import wp_abfrage.wp_fkt as wp_fkt
import wp_abfrage.wp_storage as wp_storage
import wp_abfrage.wp_yahoofinance as wp_yf

def update_last_price_volume_isin(wp_obj, isin_basic_dict, isin):
    """

    :param wp_obj:
    :param isin:
    :return: (status, errtext) = get_last_price_volume_isin(wp_obj, isin_basic_dict,isin)
    """

    status = hdef.OKAY
    errtext = ""

    print("Bestimme letzen aktiven Handelstag:")
    last_active_dat_time_list = wp_fkt.letzter_beendeter_handelstag_dat_list(wp_obj.base_ddict["boerse"])
    datStrLast = htype.type_transform_direct(last_active_dat_time_list,"datTimeList","datStrP")
    print(f"letzen aktiver Handelstag: {datStrLast}")
    first_active_dat_time_list = wp_obj.basic_dict["price_volumen_first_dat "]


    #df_usdeuro =


    # Prüfe ob Daten vorhanden
    (flag, last_stored_dat_time_list) =  proof_date_in_price_volume_data(wp_obj, isin, last_active_dat_time_list)
    if not flag:

        if len(isin_basic_dict["ticker"]) != 0:

            print("Versuche yahoofinace-Abfrage")

            (status,errtext,df_data) = read_price_volume_data_from_yf(wp_obj,
                                                                      par,
                                                                      isin_basic_dict,
                                                                      isin,
                                                                      last_stored_dat_time_list,
                                                                      last_active_dat_time_list)





    return (status,errtext)
# end def
def proof_date_in_price_volume_data(wp_obj, isin, last_active_dat_time_list):
    """

    :param wp_obj:
    :param isin:
    :param last_active_dat_time_list:
    :return: (flag,last_stored_dat_time_list) = proof_date_in_price_volume_data(wp_obj, isin, last_active_date)
    """

    flag = False
    last_stored_dat_time_list = [ 31,12,1999,0,0,0]

    # Gibt es bereits eine Datei
    if wp_storage.price_volume_storage_exist(isin, wp_obj.base_ddict):
        data_df = wp_storage.read_parquet(isin, wp_obj.base_ddict)

    # end if

    return (flag,last_stored_dat_time_list)
# end def
# def read_price_volume_data_from_ariva(wp_obj, isin, last_active_dat_time_list):
#     """
#
#     :param wp_obj:
#     :param isin:
#     :param last_active_dat_time_list:
#     :return: (df_data,status,errtext) = read_price_volume_data_from_ariva(wp_obj, isin, last_active_date)
#     """
#
#     (okay,datStrLast) = htype.type_transform(last_active_dat_time_list,"datTimeList","datStrP")
#
#     if okay != hdef.OKAY:
#         raise Exception(f"Das Datum konnte nicht gewandlt werden: {last_active_dat_time_list = }")
#     # end if
#
#     (status,errtext,csv_datei) = wp_playwright.get_price_volume_data(wp_obj.base_ddict["ariva_user"],
#                                                                      wp_obj.base_ddict["ariva_pw"],
#                                                                      wp_obj.base_ddict["ariva_timeout_playright"],
#                                                                      isin,
#                                                                      wp_obj.base_ddict["price_volumen_first_dat"],
#                                                                      datStrLast)

def read_price_volume_data_from_yf(wp_obj,par,isin_basic_dict, isin, last_stored_dat_time_list,last_active_dat_time_list):
    """

    :param wp_obj:
    :param par:
    :param isin_basic_dict:
    :param isin:
    :param last_stored_dat_time_list:
    :param last_active_dat_time_list:
    :return: (status,errtext,df_data) = read_price_volume_data_from_yf(wp_obj,isin_basic_dict, isin, last_stored_dat_time_list, last_active_dat_time_list)
    """

    (status,errtext,df_data) = wp_yf.get_price_volume_data(isin_basic_dict["ticker"],
                                                           isin_basic_dict["waehrung"],
                                                           last_stored_dat_time_list,
                                                           last_active_dat_time_list)


# end def



