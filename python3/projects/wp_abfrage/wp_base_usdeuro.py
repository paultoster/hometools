import os, sys
import numpy as np

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_dict as hdict
import tools.hfkt_type as htype

import wp_storage
import wp_fkt
import wp_np_dataclass
import wp_np_dataclass as wp_np_dc
import wp_base
import wp_yahoofinance as wp_yfinance

def process_ezb_xml(wb_obj: wp_base.WPData,xmlfilename: str) -> (int,str):
    """

    :param wb_obj:
    :param xmlfilename:
    :return: (status,errtext) = wp_base_usdeuro.process_ezb_xml(wb_obj ,xmlfilename
    """

    (status, errtext, np_obj_new) = wp_storage.read_usdeuro_ezb_xml(xmlfilename)
    if status != hdef.OKAY:
        return (status, errtext)


    (status, errtext) = update_with_np_obj_new(wb_obj,np_obj_new)

    if status != hdef.OKAY:
        return (status, errtext)

    return (status, errtext)
# end  def
def process_akt(wb_obj):
    """

    :param wb_obj:
    :return: (status, errtext) = process_akt(wp_obj)
    """

    (status,errtext,_, _, lastdat) = get_number_of_data(wb_obj)

    if status != hdef.OKAY:
        return (status, errtext)

    # Was ist der letzte aktuelle Handelsdatum
    end_dat_time_list = wp_fkt.letzter_beendeter_handelstag_dat_list(wb_obj.base_ddict["boerse"])
    end_dat = htype.type_transform_direct(end_dat_time_list, "datTimeList", "dat")

    (status,errtext) = process_start_end_dat(wb_obj,lastdat,end_dat)

    return (status, errtext)
# end def
def process_start_end_dat(wb_obj,lastdat,end_dat):
    """

    :param wb_obj:
    :param lastdat:
    :param end_dat:
    :return:  (status, errtext) = process_start_end_dat(wp_obj,lastdat,end_dat)
    """


    (status, errtext, np_obj) = wp_yfinance.get_usdeuro_data(lastdat,end_dat)

    if status != hdef.OKAY:
        return (status, errtext)


    (status, errtext) = update_with_np_obj_new(wb_obj,np_obj)

    return (status, errtext)
# end def
def get_number_of_data(wb_obj):
    """

    :return: (status,errtext,number,firstdat,lastdat) = get_number_of_data_usdeuro_course()
    """
    status = hdef.OKAY
    errtext = ""
    number = 0
    firstdat = 0
    lastdat = 0

    flag_use_json = wb_obj.base_ddict["use_json"] == 2


    (status,errtext,np_obj) = wp_storage.read_np_obj(wp_np_dataclass.NpUsdEuroClass,
                                                     wb_obj.par.HEADER_PANDAS_USDEURO_NAME,
                                                     flag_use_json,
                                                     wb_obj.base_ddict["usdeuro_pre_file_name"],
                                                     wb_obj.base_ddict["store_path"])
    if status != hdef.OKAY:
        return (status, errtext, number, firstdat, lastdat)
    # end if

    if isinstance(np_obj.dat_np_array, (np.ndarray, np.generic)):
        number   = len(np_obj.dat_np_array)
        firstdat = int(np_obj.dat_np_array[0])
        lastdat  = int(int(np_obj.dat_np_array[-1]))

    return (status, errtext,number,firstdat,lastdat)
# end def
def update_with_np_obj_new(wb_obj,np_obj_new):
    """

    :param np_obj_new: dataclass
    :return:  (status,errtext) = obj.set_usdeuro_course(np_obj_new,HEADER_PANDAS_DATUM_NAME,HEADER_PANDAS_USDEURO_NAME,base_ddict)
    """

    status = hdef.OKAY
    errtext = ""

    flag_use_json = wb_obj.base_ddict["use_json"] == 2

    (status,errtext,np_obj) = wp_storage.read_np_obj(wp_np_dataclass.NpUsdEuroClass,
                                                     wb_obj.par.HEADER_PANDAS_USDEURO_NAME,
                                                     flag_use_json,
                                                     wb_obj.base_ddict["usdeuro_pre_file_name"],
                                                     wb_obj.base_ddict["store_path"])
    if status != hdef.OKAY:
        return (status, errtext)
    # end if

    if isinstance(np_obj.dat_np_array, (np.ndarray, np.generic)):
        (status, errtext, np_obj) = merge_usdeuro_np_obj_new_to_np_obj(np_obj,np_obj_new)
    else:
        np_obj = np_obj_new
    # end if

    if status != hdef.OKAY:
        return (status,errtext)

    wp_storage.save_np_obj(np_obj,
                           wb_obj.par.HEADER_PANDAS_USDEURO_NAME,
                           flag_use_json,
                           wb_obj.base_ddict["usdeuro_pre_file_name"],
                           wb_obj.base_ddict["store_path"])

    return (status,errtext)
# end def
def merge_usdeuro_np_obj_new_to_np_obj(np_obj,np_obj_new):
    """

    :param df:
    :param df_new:
    :param dat_name:
    :param usdeuro_name: (status, errtext, df_merge) = wp_fkt.merge_usdeuro_dfnew_to_df(df,df_new, dat_name,usdeuro_name)
    :return:
    """
    status = hdef.OKAY
    errtext = ""

    np_dat_akt = np_obj.dat_np_array
    np_dat_new = np_obj_new.dat_np_array

    half_day_seconds = 12 * 60 * 60
    sort_index_list = wp_fkt.build_sort_list_of_index(list(np_dat_akt), list(np_dat_new), half_day_seconds)

    if len(sort_index_list):
        np_usdeuro_akt = np_obj.usdeuro_np_array
        np_usdeuro_new = np_obj_new.usdeuro_np_array

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
