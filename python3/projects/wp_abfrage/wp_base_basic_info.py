import os, sys, time

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif


from tools import hfkt_def as hdef
# import tools.hfkt_dict as hdict
from tools import hfkt_type as htype

from wp_abfrage import wp_storage
from wp_abfrage import wp_fkt
from wp_abfrage import wp_isin
from wp_abfrage import wp_wkn


def get_isin_liste(wb_obj) -> (int, str, list):
    """

    :param wb_obj:
    :return: (status, errtext, isin_liste) = wp_base_basic_info.get_isin_liste(wb_obj)
    """

    status = hdef.OKAY
    errtext = ""

    (status ,errtext ,wpname_isin_dict) = wp_storage.read_wpname_isin_dict(wb_obj.base_ddict["wpname_isin_filename"],
                                                                           wb_obj.base_ddict["store_path"])

    if status == hdef.OKAY:
        isin_liste = list(wpname_isin_dict.keys())
    else:
        isin_liste =[]
    # end if

    return (status, errtext, isin_liste)
# end def
def get_wpname_isin_dict(wb_obj) -> (int, str, dict):
    '''

    Lese wpname_isin_dict ein und gebe sie zurück

    :return: (status, errtext, wpname_isin_dict) = get_wpname_isin_dict(wb_obj)
    '''

    (status, errtext, wpname_isin_dict) = wp_storage.read_wpname_isin_dict(wb_obj.base_ddict["wpname_isin_filename"],
                                                                           wb_obj.base_ddict["store_path"])

    return (status, errtext, wpname_isin_dict)
# end def
def get(wb_obj, isin_input: str|list) -> (int,str,dict|list):
    """

    :param wb_obj:
    :param isin_input:
    :return: (status, errtext, output_dict_liste) = self.get(isin_liste)
             (status, errtext, output_dict) = self.get(isin)
    """
    status = hdef.OKAY
    errtext = ""

    # -----------------------------------------------------------
    # check ISIN input build wb_obj.base_ddict["isin_list"]
    # -----------------------------------------------------------
    (status, errtext,isin_input_is_list, isin_list) \
        = wp_fkt.check_isin_input(isin_input)

    if status != hdef.OKAY:
        return (status, errtext, None)
    # end if

    output_list = [None] * len(isin_list)

    # ---------------------------------------------------------------------
    # iteriere über isin_list
    # ---------------------------------------------------------------------
    for i, isin in enumerate(isin_list):

        print(f"Build basic_info from isin: {isin}:")
        start_time = time.time()

        falg_use_json = wb_obj.base_ddict["use_json"] == 2
        (status, errtext, info_dict) = wp_isin.get_basic_info(isin,
                                                              falg_use_json,
                                                              wb_obj.base_ddict["basic_info_pre_file_name"],
                                                              wb_obj.base_ddict["store_path"])

        # ---------------------------------------------
        # Einzel dict info_dict in Liste einsortieren
        # ---------------------------------------------
        if status == hdef.OKAY:
            output_list[i] = info_dict
        else:
            return (status, errtext, None)
        # end if

        end_time = time.time()
        print('Execution time: ', end_time - start_time, ' s')
    # end for

    if isin_input_is_list:
        output = output_list
    else:
        if len(output_list):
            output = output_list[0]
        else:
            output = None
        # end if
    # end if

    return (status, errtext, output)
# end def
def save(wb_obj, isin_input, basic_info_dict):
    """

    :param wb_obj:
    :param isin_input:
    :param basic_info_dict:
    :return: (status, errtext) = save(isin_liste, basic_info_dict_liste)
             (status, errtext) = save_basic_info(isin, basic_info_dict)
    """

    # -----------------------------------------------------------
    # check ISIN input build self.base_ddict["isin_list"]
    # -----------------------------------------------------------
    (status, errtext, isin_input_is_list, isin_list) = wp_fkt.check_isin_input(isin_input)

    if status != hdef.OKAY:
        return (status, errtext)
    # end if

    if isin_input_is_list:
        if isinstance(basic_info_dict, list):
            basic_info_dict_list = basic_info_dict
        else:
            status = hdef.NOT_OKAY
            errtext = f"save_basic_info: isin_input: {isin_input} need a list of dict dict_list: {basic_info_dict}"
            return (status, errtext)
        # end if
    else:
        if isinstance(basic_info_dict, list):
            basic_info_dict_list = [basic_info_dict[0]]
        else:
            basic_info_dict_list = [basic_info_dict]
        # end if
    # end if

    for i, isin in enumerate(isin_list):
        use_jason = wb_obj.base_ddict["use_json"] == 1

        (status, errtext) = wp_storage.save_dict(basic_info_dict_list[i], isin,
                                                 use_jason,
                                                 wb_obj.base_ddict["basic_info_pre_file_name"],
                                                 wb_obj.base_ddict["store_path"])

        if status != hdef.OKAY:
            return (status, errtext)
        # end if

        # update isin wpname liste
        if status == hdef.OKAY:
            (status, errtext) = wp_storage.update_isin_name_dict(isin,
                                                                 basic_info_dict_list[i]["name"],
                                                                 wb_obj.base_ddict["wpname_isin_filename"],
                                                                 wb_obj.base_ddict["store_path"])
        # end if
    # end for

    return (status, errtext)
# end def
def process_isin_from_wkn(wb_obj, wkn):
    """

    :param wb_obj:
    :param wkn:
    :return:  (status, errtext, isin) = process_isin_from_wkn(wb_obj,wkn)
    """

    flag_json = wb_obj.base_ddict["use_json"] == 2
    (status, errtext, isin) = wp_wkn.wp_search_wkn(wkn,
                                                   flag_json,
                                                   wb_obj.base_ddict["wpname_isin_filename"],
                                                   wb_obj.base_ddict["basic_info_pre_file_name"],
                                                   wb_obj.base_ddict["store_path"],
                                                   wb_obj.base_ddict["wkn_isin_n_times"],
                                                   wb_obj.base_ddict["wkn_isin_sleep_time"])
    if status != hdef.OKAY:
        print(f"get_isin_from_wkn not working errtext: {errtext}")
        isin = ""
    # end if
    return (status,errtext,isin)
# end def
def find_wpname(wb_obj, comment):
    """

    :param wb_obj:
    :param comment:
    :return: (status, errtext, isin) = find_wpname(wb_obj, comment)
    """

    flag_json = wb_obj.base_ddict["use_json"] == 2
    (status, errtext, isin) = wp_wkn.wp_search_wpname_in_comment(comment,
                                                                flag_json,
                                                                wb_obj.base_ddict["wpname_isin_filename"],
                                                                 wb_obj.base_ddict["store_path"])

    if status != hdef.OKAY:
        print(f"find_wpname_in_comment_get_isin not working errtext: {errtext}")
    # end if
    return (status, errtext, isin)
# end def
def process_isin_w_wpname_wkn(wb_obj,isin,wpname,wkn):
    """

    :param wb_obj:
    :param isin:
    :param wpname:
    :param wkn:
    :return:
    """

    (status, errtext, info_dict) = wb_obj.get_basic_info(isin)

    if status != hdef.OKAY:
        print(f"update_isin_w_wpname_wkn: not working errtext: {errtext}")
        return (status,errtext)
    # end if
    flag = False
    if len(info_dict["name"]) == 0:
        flag = True
        info_dict["name"] = wpname

    if len(wkn) > 0:
        flag = True
        info_dict["wkn"] = wkn

    if flag:
        flag_use_json = wb_obj.base_ddict["use_json"] == 2
        (status, errtext) = wp_storage.save_dict(isin,info_dict,
                                                 flag_use_json,
                                                 wb_obj.base_ddict["basic_info_pre_file_name"],
                                                 wb_obj.base_ddict["store_path"])

    return (status,errtext)