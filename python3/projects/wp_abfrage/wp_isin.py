from bs4 import BeautifulSoup as bs
import urllib.request
import os


import tools.hfkt_def as hdef
import tools.hfkt_str as hstr
import tools.hfkt_type as htype
import time

if os.path.isfile('wp_base.py'):
    import wp_storage as wp_storage
    import wp_playright as wp_pr
    import wp_basic_info as wp_basic_info
else:
    import wp_abfrage.wp_storage as wp_storage
    import wp_abfrage.wp_playright as wp_pr
    import wp_abfrage.wp_basic_info as wp_basic_info
# end if



def get_basic_info(isin,base_ddict):
    '''
    
    :param isin:
    :param base_ddict:
    :return: (status, errtext, info_dict) = wp_isin.get_basic_info(isin,base_ddict)
    '''


    # ---------------------------------------------
    # basic info data einlesen wenn vorhanden
    # ---------------------------------------------
    if wp_storage.info_storage_eixst(isin, base_ddict):
        print(f"            ... lese File")
        (status, errtext, info_dict) = wp_storage.read_info_dict(isin, base_ddict)
        if status != hdef.OKAY:
            return (status,errtext,info_dict)
        # end if

        (flag, info_dict) = update_info_dict_with_new_defaults(info_dict)
        if flag:
            (status, errtext) = wp_storage.save_info_dict(isin, info_dict, base_ddict)
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
            
            (status, errtext) = wp_storage.save_info_dict(isin, info_dict, base_ddict)
            # if status == hdef.OKAY:
            #     if len(info_dict["name"]) > 0:
            #         (status, errtext) = wp_wkn.wp_add_wpname_isin(info_dict["name"],isin, base_ddict)
            #     else:
            #         status = hdef.NOT_OKAY
            #         errtext = f"wp_basic_info_with_isin_list: info_dict[name] from isin : {isin} is empty"
            #     # end if
            # if status == hdef.OKAY:
            #     if len(info_dict["wkn"]) > 0:
            #         (status, errtext) = wp_wkn.wp_add_wkn_isin(info_dict["wkn"],isin, base_ddict)
            #     else:
            #         status = hdef.NOT_OKAY
            #         errtext = f"wp_basic_info_with_isin_list: info_dict[wkn] from isin : {isin} is empty"
            #     # end if
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
