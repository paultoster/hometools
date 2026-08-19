import os, sys
import numpy as np
import pandas as pd

# import copy
# import hfkt_str
# from hfkt_log import log

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_np_fkt as hnp_fkt
import hfkt_file_path as hfp


from wp_abfrage import wp_storage
from wp_abfrage import wp_fkt

from wp_abfrage import wp_np_price_volume_dataclass as wp_np_dc
from wp_abfrage import wp_base
from wp_abfrage import wp_indice_yahoo
from wp_abfrage import wp_indice_ezbleitzins
from wp_abfrage import wp_bearbeiten as wp_bearbeit
from wp_abfrage import wp_plot
from wp_abfrage import wp_fkt
from wp_abfrage import wp_bearbeiten as wp_bearb

def get_indices_liste(wb_obj) -> list:
    """

    :param wb_obj:
    :return: indices_liste = wp_base_indices.get_indices_liste(wb_obj)
    """
    return wb_obj.par.INDICES_NAME_LISTE
# end def
def get_leitzins_indice(wb_obj):
    return wb_obj.par.INDICES_EZB_LEITZINS_NAME
# end def
def is_indices_name(wb_obj, indices_name) -> (int, str, list):
    """
    :param wb_obj:
    :return: flag = wp_base_indices.get_indices_name(wb_obj)
    """

    indices_liste = get_indices_liste(wb_obj)

    if indices_name in indices_liste:
        return True
    else:
        return False
    # end if
# end def
def update_indices(wb_obj,indice = None):

    status = hdef.OKAY
    errtext = ""
    if indice is None:
        indices = get_indices_liste(wb_obj)
    elif not isinstance(indice, list):
        indices = [indice]
    else:
        indices = indice
    # end if

    for indice in indices:
        match indice:
            case wb_obj.par.INDICES_EZB_LEITZINS_NAME:

                (status,errtext) = wp_indice_ezbleitzins.process_akt(wb_obj)


            case wb_obj.par.INDICES_USDEURO_NAME  | wb_obj.par.INDICES_CHFEURO_NAME  | wb_obj.par.INDICES_GBPEURO_NAME:

                (status, errtext) = wp_indice_yahoo.process_akt(wb_obj,indice)

            case _:

                status = hdef.NOT_OKAY
                errtext = f"update_indices: Der Indice {indice} ist nicht gefunden worden in der Liste."
        # end match
        if status != hdef.OKAY:
            break
    # end for

    return (status,errtext)
# end def
def make_backup(wb_obj,indice_liste,move_flag):


    if len(indice_liste) == 0:
        indice_liste = get_indices_liste(wb_obj)
    # end if

    (status, errtext, backup_dir) = wp_bearb.make_backup_build_new_dir_indice(wb_obj)
    if status != hdef.OKAY:
        return (status, errtext)
    #  end if

    (status, errtext, filename_list) = get_exist_filenames(wb_obj,indice_liste)
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
def get_exist_filenames(wp_obj, indice_liste):
    """
    (status, errtext, filename_list) = wp_base_basic_info.get_exist_filenames(wb_obj, isin_input)
    """
    status = hdef.OKAY
    errtext = ""

    if isinstance(indice_liste, str):
        indice_liste = [indice_liste]
    # end if

    filename_list = []
    for indice in indice_liste:

        file_name = wp_storage.build_file_name_joblib(wp_obj.base_ddict["indices_pre_file_name"] + indice,
                                                    wp_obj.base_ddict["store_path"])
        if os.path.isfile(file_name):
            filename_list.append(file_name)
        # end if
    # end for
    return (status, errtext, filename_list)
# end def

def process_ezb_xml(wb_obj: wp_base.WPData,xmlfilename: str,indice:str) -> (int,str):
    """

    :param wb_obj:
    :param xmlfilename:
    :param indice:
    :return: (status,errtext) = wp_base_usdeuro.process_ezb_xml(wb_obj ,xmlfilename,indice)
    """
    np_obj_new = wp_bearbeit.build_indice_np_obj(wb_obj,indice)
    (status, errtext, np_obj_new) = wp_storage.read_indice_ezb_xml(xmlfilename,np_obj_new)
    if status != hdef.OKAY:
        return (status, errtext)

    (status, errtext, np_obj_new) = proof_ezb_xml_np_obj(wb_obj, np_obj_new,indice)

    np_obj = wp_bearbeit.read_indice_np_data(wb_obj,indice)



    (status, errtext) = update_with_np_obj_new(wb_obj,np_obj,np_obj_new,indice,True)

    if status != hdef.OKAY:
        return (status, errtext)

    return (status, errtext)
# end  def
def process_ezb_leitzins_csv(wb_obj,csvfilename):
    """
    (status,errtext) = wp_base_indices.process_ezb_leitzins_csv(self,csvfilename)
    """

    (status, errtext, np_obj_new) = read_csv_ezb_leitzins(wb_obj,csvfilename)

    if status != hdef.OKAY:
        return (status, errtext)

    np_obj = wp_bearbeit.read_indice_np_data(wb_obj,wb_obj.par.INDICES_EZB_LEITZINS_NAME)



    (status, errtext) = update_with_np_obj_new(wb_obj,np_obj,np_obj_new,wb_obj.par.INDICES_EZB_LEITZINS_NAME,True)

    if status != hdef.OKAY:
        return (status, errtext)

    return (status, errtext)
# end  def
def read_csv_ezb_leitzins(wb_obj,csvfilename):
    """
    (status, errtext, np_obj_new) = read_csv_ezb_leitzins(csvfilename)
    """
    status =  hdef.OKAY
    errtext = ""

    np_obj_new = wp_bearbeit.build_indice_np_obj(wb_obj,wb_obj.par.INDICES_EZB_LEITZINS_NAME)

    df = pd.read_csv(
        csvfilename,
        parse_dates=["DATE"]
    )

    if len(df) == 0:
        status = hdef.NOT_OKAY
        errtext = f"Aus Datei {csvfilename} konnte nichts eingelsen werden"
        return (status, errtext, np_obj_new)
    # end if

    np_dat_array = df.iloc[:, 0].to_numpy().astype('datetime64[D]').astype('datetime64[s]').astype(np.int64)
    np_indice_array = df.iloc[:, 2].to_numpy().astype('float64')

    dat_letzter_handelstag = wp_fkt.letzter_beendeter_handelstag_timestamp()

    np_handelstage_dat_array = wp_fkt.get_np_handels_tage_von_bis(np_dat_array[0],dat_letzter_handelstag)

    np_handelstage_indice_array = wp_fkt.interpol_with_dat_const(np_dat_array,np_indice_array,np_handelstage_dat_array)

    np_obj_new.put_signal(np_handelstage_dat_array,np_handelstage_indice_array)

    return (status,errtext,np_obj_new)
# end def
def update_with_np_obj_new(wb_obj,np_obj,np_obj_new,indice,flag_take_new=False):
    """

    :param np_obj_new: dataclass
    :return:  (status,errtext) = obj.update_with_np_obj_new(wb_obj,np_obj,np_obj_new,indice)
    """

    status = hdef.OKAY
    errtext = ""

    wb_obj.log.write_info(f"Update {indice} course:")

    if np_obj is not None:

        if isinstance(np_obj.dat_np_array, (np.ndarray, np.generic)):
            (status, errtext, np_obj) = merge_np_obj_new_to_np_obj(wb_obj,np_obj,np_obj_new,indice,flag_take_new)
            if status != hdef.OKAY:
                return (status, errtext)
        else:
            np_obj = np_obj_new
        # end if
    else:
        np_obj = np_obj_new
    # end if


    np_obj.save()

    wb_obj.log.write_info(f"Update of file: {np_obj.get_filename()}")

    return (status,errtext)
# end def
def merge_np_obj_new_to_np_obj(wb_obj,np_obj,np_obj_new,indice,flag_take_new=False):
    """

    :param df:
    :param df_new:
    :param dat_name:
    :param usdeuro_name: (status, errtext, df_merge) = obj.merge_usdeuro_dfnew_to_df(dwb_obj,np_obj,np_obj_new)
    :return:
    """
    status = hdef.OKAY
    errtext = ""

    np_dat_akt = np_obj.dat_np_array
    np_dat_new = np_obj_new.dat_np_array

    if flag_take_new:
        sort_index_list = hnp_fkt.build_sort_list_of_index_for_dat_array(np_dat_new, np_dat_akt)
    else:
        sort_index_list = hnp_fkt.build_sort_list_of_index_for_dat_array(np_dat_akt, np_dat_new)

    if len(sort_index_list):
        np_indice_akt = np_obj.indice_np_array
        np_indice_new = np_obj_new.indice_np_array

        np_dat_merge = np.array([], dtype=np.int64)
        np_indice_merge = np.array([], dtype=np.float64)

        if flag_take_new:
            index_akt = 1  # => akt is second
        else:
            index_akt = 0  # => akt is first
        # end if
        for index,val in enumerate(sort_index_list):

            if val[0] == index_akt:
                np_dat_merge = np.append(np_dat_merge,np_dat_akt[val[1]:val[2]+1])
                np_indice_merge = np.append(np_indice_merge,np_indice_akt[val[1]:val[2]+1])
            else:
                np_dat_merge = np.append(np_dat_merge,np_dat_new[val[1]:val[2]+1])
                np_indice_merge = np.append(np_indice_merge,np_indice_new[val[1]:val[2] + 1])
            # end if
        # end for

        np_obj_out = wp_bearbeit.build_indice_np_obj(wb_obj,indice)
        np_obj_out.put_signal(np_dat_merge, np_indice_merge)

    # end if
    return (status, errtext, np_obj_out )
# end def

def get_dict_from_act(wb_obj,indice=None):
    """
    (status,errtext,np_obj_dict) = get_dict_from_act(wb_obj):
    (status,errtext,np_obj_dict) = get_dict_from_act(wb_obj,[indece1,indice2,...]):
    (status,errtext,np_obj)      = get_dict_from_act(wb_obj,indece1):
    """


    status = hdef.OKAY
    errtext = ""

    list_type = True
    if (indice is None) or (isinstance(indice, list) and (len(indice) == 0)):
        indices = get_indices_liste(wb_obj)
    elif not isinstance(indice, list):
        indices = [indice]
        list_type = False
    else:
        indices = indice
    # end if
    np_obj_dict = {}

    for indice in indices:
        match indice:
            case wb_obj.par.INDICES_EZB_LEITZINS_NAME:

                (status, errtext, np_obj) = wp_indice_ezbleitzins.get_act(wb_obj)
                if np_obj is not None:
                    np_obj.set_unit("%")

            case wb_obj.par.INDICES_USDEURO_NAME  | wb_obj.par.INDICES_CHFEURO_NAME  | wb_obj.par.INDICES_GBPEURO_NAME:

                (status, errtext, np_obj) = wp_indice_yahoo.get_act(wb_obj,indice)

                if np_obj is not None:
                    np_obj.set_unit("-")

            case _:

                status = hdef.NOT_OKAY
                errtext = f"get_from_start_dat_to_end_dat: Der Indice {indice} ist nicht gefunden worden in der Liste."
        # end match
        if status != hdef.OKAY:
            break
        else:
            np_obj_dict[indice] = np_obj
        # end if
    # end for

    if list_type:
        return (status, errtext, np_obj_dict)
    else:
        return (status, errtext, np_obj_dict[indices[0]])
    # end if

# end def
def get_dict_from_start_dat_to_end_dat(wb_obj,start_dat,end_dat,indice):

    status = hdef.OKAY
    errtext = ""
    if indice is None:
        indices = get_indices_liste(wb_obj)
    elif isinstance(indice, list) and (len(indice)==0):
        indices = get_indices_liste(wb_obj)
    elif not isinstance(indice, list):
        indices = [indice]
    else:
        indices = indice
    # end if
    np_obj_dict = {}

    for indice in indices:
        match indice:
            case wb_obj.par.INDICES_EZB_LEITZINS_NAME:

                (status, errtext, np_obj) = wp_indice_ezbleitzins.get_from_start_dat_to_end_dat(wb_obj,start_dat,end_dat)

            case wb_obj.par.INDICES_USDEURO_NAME  | wb_obj.par.INDICES_CHFEURO_NAME  | wb_obj.par.INDICES_GBPEURO_NAME:

                (status, errtext,np_obj) = wp_indice_yahoo.get_from_start_dat_to_end_dat(wb_obj,start_dat,end_dat,indice)

            case _:

                status = hdef.NOT_OKAY
                errtext = f"get_from_start_dat_to_end_dat: Der Indice {indice} ist nicht gefunden worden in der Liste."
        # end match
        if status != hdef.OKAY:
            break
        else:
            np_obj_dict[indice] = np_obj
        # end if
    # end for

    return (status, errtext,np_obj_dict)
# end def
def proof_ezb_xml_np_obj(wb_obj, np_obj,indice):
    """
    (status, errtext, np_obj_new) = proof_ezb_xml_np_obj(wb_obj, np_obj)
    """
    status = hdef.OKAY
    errtext = ""

    (status,errtext,invert_indice) = wp_plot.plot_indice(np_obj,indice)
    if status != hdef.OKAY:
        return (status, errtext,np_obj)

    if (invert_indice is not None) and invert_indice:
        indice_np_array = np.reciprocal(getattr(np_obj, "indice_np_array"))
        np_obj.put_indice_signal(indice_np_array)
    # endif

    return (status, errtext, np_obj)
# end def


