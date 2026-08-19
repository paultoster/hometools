import os, sys
import numpy as np
import mplfinance as mpf
import pandas as pd

# from hfkt_log import log

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

from tools import sgui
from tools import hfkt_def as hdef
from tools import hfkt_dict as hdict
from tools import hfkt_type as htype
from tools import hfkt_date_time as hdate
from tools import hfkt_file_path as hpf
from tools import hfkt_io as hio
from tools import hfkt_list as hlist
from tools import hfkt_str as hstr

from wp_abfrage import wp_price_volume
from wp_abfrage import wp_base_indices
from wp_abfrage import wp_fkt
from wp_abfrage import wp_storage as wp_storage
from wp_abfrage import wp_requests as wp_req
from wp_abfrage import wp_np_price_volume_dataclass
from wp_abfrage import wp_np_indice_dataclass
# from wp_abfrage import wp_np_pdataclass as wp_np_dc



def read_price_volumen_np_data(wb_obj,isin):

    np_obj = build_price_volumen_np_obj(wb_obj,isin)
    if np_obj.exist_file():
        np_obj.read()
        infotext = np_obj.get_infotext()
        if len(infotext):
            wb_obj.log.write_info(infotext)
        # end if
    else:
        np_obj = None
    # end if
    return np_obj
# end def
def build_price_volumen_np_obj(wb_obj,isin):

    file_name = build_price_volumen_filename(wb_obj,isin)

    np_obj = wp_np_price_volume_dataclass.NpPriceVolumeClass(file_name)

    return np_obj
# end def
def build_price_volumen_filename(wb_obj,isin):

    file_name = wp_storage.build_file_name_joblib(wb_obj.base_ddict["price_volumen_pre_file_name"] + isin,
                                                wb_obj.base_ddict["store_path"])
    return file_name
# end def
def read_indice_np_data(wb_obj,indice):

    np_obj = build_indice_np_obj(wb_obj,indice)
    if np_obj.exist_file():
        np_obj.read()
    else:
        np_obj = None
    # end if
    return np_obj
# end def
def build_indice_np_obj(wb_obj,indice):

    if wp_base_indices.is_indices_name(wb_obj, indice):
        file_name = build_indice_filename(wb_obj,indice)

        np_obj = wp_np_indice_dataclass.NpIndiceClass(file_name)
    else:
        np_obj = None

    return np_obj
# end def
def build_indice_filename(wb_obj,indice):

    file_name = wp_storage.build_file_name_joblib(wb_obj.base_ddict["indices_pre_file_name"] + indice,
                                                wb_obj.base_ddict["store_path"])
    return file_name
# end def
# old definition
# def read_np_obj(wb_obj, isin):
#     """
#     (status, errtext,np_obj) = read_np_obj(wb_obj,isin)
#
#         Wenn keine Datei vorhanden, np_obj = None aber status = OKAY
#     """
#     status = hdef.OKAY
#     errtext = ""
#
#     # Gibt es bereits eine Datei
#     file_name = wp_storage.build_file_name_json(wb_obj.base_ddict["price_volumen_pre_file_name"] + isin,
#                                                 wb_obj.base_ddict["store_path"])
#
#     formatpj = int(wb_obj.base_ddict["price_volumen_use_format"] / 10)
#     flag = wp_storage.np_obj_storage_exist(file_name, formatpj)
#
#     # Wenn ja lese Datei ein
#     if flag:
#         (status, errtext, np_obj) = wp_storage.read_np_obj(wp_np_dc.NpPriceVolumeClass,
#                                                            file_name,
#                                                            formatpj)
#
#         np_obj.sort_by_dat()
#
#         if status != hdef.OKAY:
#             return (status, errtext, np_obj)
#     else:
#         np_obj = None
#     # end if
#     return (status, errtext, np_obj)
# # end def
# def read_np_indice_obj(wb_obj, indice):
#     """
#     (status, errtext,np_obj) = read_np_indice_obj(wb_obj,indice)
#
#         Wenn keine Datei vorhanden, np_obj = None aber status = OKAY
#     """
#     status = hdef.OKAY
#     errtext = ""
#     np_obj = None
#
#     if wp_base_indices.is_indices_name(wb_obj, indice):
#
#         # Hole korrekte Datumsreihe:
#         file_name = wp_storage.build_file_name_json(wb_obj.base_ddict["indices_pre_file_name"] + indice,
#                                                     wb_obj.base_ddict["store_path"])
#
#         formatpj = int(wb_obj.base_ddict["usdeuro_use_format"]/10)
#
#         flag = wp_storage.np_obj_storage_exist(file_name, formatpj)
#
#         if flag:
#
#             (status,errtext,np_obj) = wp_storage.read_np_obj(wp_np_dc.NpUsdEuroClass,file_name,formatpj)
#             if status != hdef.OKAY:
#                 return (status, errtext, None)
#             # end if
#         # end if
#
#     return (status, errtext, np_obj)
# # end def


def make_backup_build_new_dir_price_volume(wb_obj):
    """
    (status, errtext) = make_backup_build_new_dir_price_volume(wb_obj)
    """

    status = hdef.OKAY
    errtext = ""

    backup_dir = os.path.join(wb_obj.base_ddict["store_path"],
                            hdate.get_name_by_dat_time("price_volume_", ""))


    if not os.path.isdir(backup_dir):
        try:
            os.mkdir(backup_dir)
        except:

            errtext = f"Der BACKUP_store_path: {backup_dir} konnte nicht erstellt werden"
            status = hdef.NOT_OKAY
        # end try
    # end if

    return (status, errtext,backup_dir)
# end def

def make_backup_build_new_dir_indice(wb_obj):
    """
    (status, errtext) = make_backup_build_new_dir_indice(wb_obj)
    """

    status = hdef.OKAY
    errtext = ""

    backup_dir = os.path.join(wb_obj.base_ddict["store_path"],
                            hdate.get_name_by_dat_time("indice_", ""))


    if not os.path.isdir(backup_dir):
        try:
            os.mkdir(backup_dir)
        except:

            errtext = f"Der BACKUP_store_path: {backup_dir} konnte nicht erstellt werden"
            status = hdef.NOT_OKAY
        # end try
    # end if

    return (status, errtext,backup_dir)
# end def
def get_price_volume_data_from_ariva_csv_file(csv_file,delim,np_obj,wp_dict):
    """
    :param csv_file:
    :param delim:
    :param np_classdef:
    :param wp_dict:
    :return: (status, errtext, infotext, np_obj_csv) = wp_fkt.get_price_volume_data_from_ariva_csv_file(csv_file,delim,np_classdef,wp_dict)
    """

    status = hdef.OKAY
    errtext = ""
    infotext = ""

    # read csv-File
    # ==============
    csv_lliste = hio.read_csv_file(file_name=csv_file, delim=delim)

    if (len(csv_lliste) == 0):
        errtext = f"Fehler in read_ing_csv read_csv_file()  filename = {csv_file}"
        status = hdef.NOT_OKAY
        return (status, errtext, infotext,np_obj)
    # end if

    csv_lliste = erase_and_modify_empty_rows_in_llist(csv_lliste)

    llist = []
    for i,csv_list in enumerate(csv_lliste):

        # erase from volume dots
        csv_list[5] = hstr.change_max(csv_list[5],".","")

        if i > 0:

            liste = [htype.type_transform_direct(csv_list[0], "datStrB", "dat"),
                     htype.type_transform_direct(csv_list[1], "euroStrK", "float"),
                     htype.type_transform_direct(csv_list[2], "euroStrK", "float"),
                     htype.type_transform_direct(csv_list[3], "euroStrK", "float"),
                     htype.type_transform_direct(csv_list[4], "euroStrK", "float"),
                     htype.type_transform_direct(csv_list[5], "str", "float")]

            llist.append(liste)
        # end if
    # end for

    llist = hlist.sort_list_of_list(llist, 0)

    dat_list = hlist.get_col_list_by_index(llist, 0)
    start_list = hlist.get_col_list_by_index(llist, 1)
    high_list = hlist.get_col_list_by_index(llist, 2)
    low_list = hlist.get_col_list_by_index(llist, 3)
    end_list = hlist.get_col_list_by_index(llist, 4)
    vol_list = hlist.get_col_list_by_index(llist, 5)

    dat_np_array  = np.array(dat_list, copy=True)
    start_np_array = np.array(start_list, copy=True)
    high_np_array = np.array(high_list, copy=True)
    low_np_array = np.array(low_list, copy=True)
    end_np_array = np.array(end_list, copy=True)
    vol_np_array = np.array(vol_list, copy=True)

    np_obj.from_np_array_list([dat_np_array,
                               start_np_array,
                               high_np_array,
                               low_np_array,
                               end_np_array,
                               vol_np_array])


    base_url = hstr.elim_e(wp_dict["url_ariva"], "/")
    url = f"{base_url}/kurse/historische-kurse"
    (status, errtext, infotext, np_obj_ariva_request) = wp_req.get_price_volume_data(url,np_classdef)

    if status != hdef.OKAY:
        return (status, errtext, infotext, np_obj)

    if len(np_obj_ariva_request.currency) > 0:
        np_obj.set_currency(np_obj_ariva_request.currency)
    else:
        np_obj.set_currency(wp_dict["waehrung"])

    np_obj.sort_by_dat()

    return (status, errtext, infotext, np_obj)
# end def
def erase_and_modify_empty_rows_in_llist(llist,whitespace=True):

    index_liste = []
    i_schlusskurs = -1
    header_liste = []
    for index,liste in enumerate(llist):
        if index == 0:
            header_liste = liste
            if "Schlusskurs" in header_liste:
                i_schlusskurs = header_liste.index("Schlusskurs")
        # end if
        for i,value in enumerate(liste):
            if whitespace and isinstance(value,str):
                value = hstr.elim_ae(value,' ')

            # end if
            if len(value) == 0:


                flag = True
                if (index > 0) and (i < len(header_liste)) and (i_schlusskurs >= 0):

                    if header_liste[i] =="Volumen":
                        liste[i] = "0"
                        flag = False
                    elif header_liste[i] == "Stuecke":
                            liste[i] = "0"
                            flag = False
                    elif i_schlusskurs >= 0:
                        if (header_liste[i] == 'Erster') and (len(liste[i_schlusskurs]) > 0):
                            liste[i] = liste[i_schlusskurs]
                            flag = False
                        elif (header_liste[i] == 'Hoch') and (len(liste[i_schlusskurs]) > 0):
                            liste[i] = liste[i_schlusskurs]
                            flag = False
                        elif (header_liste[i] == 'Tief') and (len(liste[i_schlusskurs]) > 0):
                            liste[i] = liste[i_schlusskurs]
                            flag = False
                        # end if
                    # end if
                # end if

                if flag:
                    index_liste.append(index)
                    # print(f"{index = }, {liste = }")
                    break
                else:
                    llist[index] = liste
            # end if
        # end for
    # end for
    return hlist.erase_rows_from_llist(llist, index_liste)
# end def
def plot_price_volume(np_obj,tit):
    """
        (status, errtext, infotext) = wp_bearbeiten.plot_price_volume(wb_obj,np_obj,tit)
    """
    status = hdef.OK
    errtext = ""
    infotext = ""

    df = pd.DataFrame({
        'Date': pd.to_datetime(getattr(np_obj,"dat_np_array"), unit='s'),
        'Open': getattr(np_obj,"start_np_array"),
        'High': getattr(np_obj,"high_np_array"),
        'Low': getattr(np_obj,"low_np_array"),
        'Close': getattr(np_obj,"end_np_array"),
        'Volume': getattr(np_obj,"volume_np_array")
    })

    df.set_index('Date', inplace=True)
    print(df.head(10))
    print(df.tail(10))
    df.to_csv("plotdaten.csv", sep=";", index=False)

    mpf.plot(
        df,
        type='candle',
        volume=True,           # Zeigt das Handelsvolumen unter dem Chart an
        style='yahoo',         # Klassischer Finanz-Look 'binance'
        title=tit
    )
