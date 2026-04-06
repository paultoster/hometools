from bs4 import BeautifulSoup as bs
import urllib.request
import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_str as hstr
import tools.hfkt_type as htype
import time

if os.path.isfile('wp_base.py'):
    import wp_storage as wp_storage
    import wp_playwright as wp_pr
    import wp_basic_info as wp_basic_info
else:
    import wp_abfrage.wp_storage as wp_storage
    import wp_abfrage.wp_playwright as wp_pr
    import wp_abfrage.wp_basic_info as wp_basic_info
# end if



def get_basic_info(isin,flag_use_json,basic_info_pre_file_name,store_path):
    '''
    
    :param isin:
    :param base_ddict:
    :return: (status, errtext, info_dict) = wp_isin.get_basic_info(isin,flag_use_json,basic_info_pre_file_name,store_path)
    '''


    # ---------------------------------------------
    # basic info data einlesen wenn vorhanden
    # ---------------------------------------------
    if wp_storage.info_storage_eixst(isin, flag_use_json,basic_info_pre_file_name,store_path):
        print(f"            ... lese File")
        (status, errtext, info_dict) = wp_storage.read_dict(isin,
                                                          flag_use_json,
                                                          basic_info_pre_file_name,
                                                          store_path)
        if status != hdef.OKAY:
            return (status,errtext,info_dict)
        # end if

        (flag, info_dict) = update_info_dict_with_new_defaults(info_dict)
        if flag:
            (status, errtext) = wp_storage.save_dict( info_dict,
                                                      isin,
                                                      flag_use_json,
                                                      basic_info_pre_file_name,
                                                      store_path)
            if status != hdef.OKAY:
                return (status, errtext, info_dict)
            # end if
        # end if
    # ---------------------------------------------
    # basic info data vo html suchen
    # ---------------------------------------------
    else:
        print(f"            ... lese HTML")
        
        (status, errtext, info_dict) = wp_basic_info.get_basic_info(isin)
        
        if status == hdef.OKAY:
            
            (status, errtext) = wp_storage.save_dict( info_dict,
                                                      isin,
                                                      flag_use_json,
                                                      basic_info_pre_file_name,
                                                      store_path)
            print(f"info_dict: {info_dict}")
        else:
            print(f"errtext: {errtext}")
        # end if
    # end if

    return (status, errtext, info_dict)
# end def
def update_info_dict_with_new_defaults(info_dict):
    '''

    :param info_dict:
    :return: (flag,info_dict) = update_info_dict_with_new_defaults(info_dict)
    '''
    flag = False
    default_dict = wp_basic_info.get_default_info_dict(info_dict["isin"])
    
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
