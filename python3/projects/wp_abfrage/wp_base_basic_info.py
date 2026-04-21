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
from wp_abfrage import wp_wkn
from wp_abfrage import wp_basic_info_internet


def get_isin_liste(wb_obj) -> (int, str, list):
    """

    :param wb_obj:
    :return: (status, errtext, isin_liste) = wp_base_basic_info.get_isin_liste(wb_obj)
    """
    (status ,errtext ,wpname_isin_dict) = get_wpname_isin_dict(wb_obj)

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
    file_name = wp_storage.build_file_name_json(wb_obj.base_ddict["wpname_isin_filename"],
                                                wb_obj.base_ddict["store_path"])

    format = 2  # 1: pickle, 2: json
    (status, errtext, wpname_isin_dict) = wp_storage.read_dict(file_name, format)

    return (status, errtext, wpname_isin_dict)
# end def
def get(wb_obj, isin_input: str|list) -> (int,str,dict|list):
    """

    get basic info for each isin 1) find if stored 2) search with extraETF, ...

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

        # Lade von Datei
        (status, errtext, info_dict) = get_from_file(wb_obj,isin)

        if status == hdef.NOT_FOUND:

            # Suche im Internet
            (status, errtext, info_dict) = wp_basic_info_internet.search(isin)

            if status == hdef.OKAY:

                (status, errtext) = save(wb_obj,isin, info_dict)
                print(f"info_dict: {info_dict}")
            # end if
        # end if

        end_time = time.time()
        print('Execution time: ', end_time - start_time, ' s')

        # ---------------------------------------------
        # Einzel dict info_dict in Liste einsortieren
        # ---------------------------------------------
        if status == hdef.OKAY:
            output_list[i] = info_dict
        else:
            return (status, errtext, None)
        # end if

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
def  get_from_file(wb_obj,isin):
    """
        (status, errtext, info_dict) = get_from_file(wb_obj,isin)
    """

    if isin == "IE0003UVYC20":
        stoppp=0
    # end if
    file_name = wp_storage.build_file_name_json(wb_obj.base_ddict["basic_info_pre_file_name"] + isin,
                                                wb_obj.base_ddict["store_path"])

    formatpj = 2

    if wp_storage.info_storage_eixst(file_name, formatpj):

        print("            ... lese File")
        (status, errtext, info_dict) = wp_storage.read_dict(file_name,
                                                            formatpj)
        if status != hdef.OKAY:
            return (status,errtext,info_dict)
        # end if

        (flag, info_dict) = update_info_dict_with_new_defaults(info_dict)
        if flag:
            (status, errtext) = wp_storage.save_dict( info_dict,
                                                      file_name,
                                                      formatpj)
            if status != hdef.OKAY:
                return (status, errtext, info_dict)
            # end if
        # end if

    else:
        status = hdef.NOT_FOUND
        errtext = ""
        info_dict = None
    # end if

    return (status, errtext, info_dict)
# end def
def save(wb_obj, isin_input, basic_info_dict):
    """

    :param wb_obj:
    :param isin_input:
    :param basic_info_dict:
    :return: (status, errtext) = save(wb_obj,isin_liste, basic_info_dict_liste)
             (status, errtext) = save(wb_obj,isin, basic_info_dict)
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

        file_name = wp_storage.build_file_name_json(wb_obj.base_ddict["basic_info_pre_file_name"] + isin,
                                                    wb_obj.base_ddict["store_path"])
        formatpj = 3
        (status, errtext) = wp_storage.save_dict(basic_info_dict_list[i],
                                                 file_name,
                                                 formatpj)

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
    wpname_isin_filename = wp_storage.build_file_name_json( wb_obj.base_ddict["wpname_isin_filename"],
                                                wb_obj.base_ddict["store_path"])

    formatpj = 2
    (status, errtext, isin) = wp_wkn.wp_search_wkn(wkn,
                                                   wpname_isin_filename,
                                                   formatpj,
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
    wpname_isin_filename = wp_storage.build_file_name_json( wb_obj.base_ddict["wpname_isin_filename"],
                                                wb_obj.base_ddict["store_path"])

    formatpj = 2
    (status, errtext, isin) = wp_wkn.wp_search_wpname_in_comment(comment,
                                                                 wpname_isin_filename,
                                                                 formatpj)

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
    # end if
    if len(wkn) > 0:
        flag = True
        info_dict["wkn"] = wkn
    # end if
    if flag:
        file_name = wp_storage.build_file_name_json(wb_obj.base_ddict["basic_info_pre_file_name"] + isin,
                                                    wb_obj.base_ddict["store_path"])
        formatpj = 2
        (status, errtext) = wp_storage.save_dict(info_dict,file_name, formatpj)
    # end if
    return (status,errtext)
# end def
def update_info_dict_with_new_defaults(info_dict):
    '''

    :param info_dict:
    :return: (flag,info_dict) = update_info_dict_with_new_defaults(info_dict)
    '''
    flag = False
    default_dict = wp_basic_info_internet.get_default_info_dict(info_dict["isin"])

    for key in default_dict.keys():
        if key not in info_dict.keys():
            info_dict[key] = default_dict[key]
            flag = True
        # end if
    # end for

    # sortieren
    for key in default_dict.keys():
        default_dict[key] = info_dict[key]

    return (flag, default_dict)
# end def
def update_isin(wb_obj,isin, flag_update_all):
    """
    :param wb_obj:
    :param isin:
    :param flag_update_all:
    :return: (status, errtext) = wp_base_basic_info.update_isin(wb_obj,isin, flag_update_all)
    """
    status = hdef.OKAY

    (status2, errtext, info_dict) = get_from_file(wb_obj, isin)
    if status2 == hdef.NOT_OKAY:
        print(f"update_isin not working errtext: {errtext}")
        return (status2, errtext)
    # end if

    url_avira = ""
    url_onvista = ""

    if (not flag_update_all) and (status2 == hdef.OKAY) and ("url_ariva" in info_dict.keys()):
        if info_dict["url_ariva"] != "":
            url_avira = info_dict["url_ariva"]
        # end if
    # end if
    if (not flag_update_all) and (status2 == hdef.OKAY) and ("url_onvista" in info_dict.keys()):
        if info_dict["url_onvista"] != "":
            url_onvista = info_dict["url_onvista"]
        # end if
    # end if

    (status1, errtext, info_dict_search) = wp_basic_info_internet.search(isin,url_avira,url_onvista)
    if status1 == hdef.NOT_OKAY:
        print(f"update_isin not working errtext: {errtext}")
        return (status1, errtext)
    # end if


    flag = False
    if status2 == hdef.NOT_FOUND:
        info_dict = info_dict_search
        flag = True
    else:
        for key in info_dict_search.keys():

            if isinstance(info_dict_search[key],str):

                if len(info_dict_search[key]) > 0:
                    if flag_update_all:
                        info_dict[key] = info_dict_search[key]
                        flag = True
                    else:
                        if key in info_dict.keys():
                            if len(info_dict[key]) == 0:
                                info_dict[key] = info_dict_search[key]
                                flag = True
                            # end if
                        # end if
                    # end if
                else:
                    if key not in info_dict.keys():
                        info_dict[key] = info_dict_search[key]
                        flag = True
                    # end if
                # end if
            else:
                if key not in info_dict.keys():
                    info_dict[key] = info_dict_search[key]
                    flag = True
                # end if
        # end ofr
    # end if

    if flag:
        file_name = wp_storage.build_file_name_json(wb_obj.base_ddict["basic_info_pre_file_name"] + isin,
                                                    wb_obj.base_ddict["store_path"])
        formatpj = 2
        (status, errtext) = wp_storage.save_dict(info_dict, file_name, formatpj)
    # end if

    return (status, errtext)
# end def

