from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

import time

import tools.hfkt_def as hdef
import tools.hfkt_str as hstr
import tools.hfkt_type as htype
import wp_abfrage.wp_storage as wp_storage

WKN_NOT_FOUND = "wknnotfound"

def wp_search_wkn(wkn,base_ddict):
    '''
    
    :param wkn:
    :param base_ddict:
    :return:  (status, errtext, isin) = wp_wkn.wp_search_wkn(wkn,base_ddict)
    '''
    status = hdef.OKAY
    errtext = ""
    wp_isin_dict = wp_storage.read_dict_file(base_ddict["wpname_isin_filename"],base_ddict)
    
    for isin in wp_isin_dict.keys():
    
        (status,errtext,info_dict) = wp_storage.read_info_dict(isin, base_ddict)
        
        if status != hdef.OKAY:
            return (status,errtext,None)
        
        if info_dict["wkn"] == wkn:
            return (status, errtext, isin)
        # end if
    # end for

    (status,errtext,isin) = wp_search_wkn_html(wkn,base_ddict)
    
    return (status,errtext,isin)
# end def
def wp_search_wkn_html(wkn,base_ddict):
    '''
    
    :param wpn:
    :param base_ddict:
    :return: (status,errtext,isin) = wp_search_wkn_html(wkn,base_ddict)
    '''
    n = base_ddict["wkn_isin_n_times"]
    i = 1
    while i < n:
        try:
            url = f"https://www.ariva.de"
            driver = webdriver.Firefox()
            driver.implicitly_wait(base_ddict["wkn_isin_sleep_time"])
            driver.get(url)
            print(f"driver.title = {driver.title}")
            
            element = driver.find_element(By.ID, "main-search")
            WebDriverWait(driver, base_ddict["wkn_isin_sleep_time"]).until(EC.presence_of_element_located((By.ID, "main-search")))
            time.sleep(base_ddict["wkn_isin_sleep_time"])
            element.send_keys(wkn)
            element.send_keys(Keys.RETURN)
            time.sleep(base_ddict["wkn_isin_sleep_time"])
            
            get_url = driver.current_url
            print("The current url is:" + str(get_url))
            print(f"driver.title = {driver.title}")
            (okay, isin) = htype.type_proof_isin(driver.title)
            driver.quit()

            if okay == hdef.OKAY:
                status = hdef.OKAY
                errtext = ""
                break
            else:
                status = hdef.NOT_OKAY
                errtext = f"wp_search_wkn_html: not found = {i}"
                isin = ""
                i += 1
            
        except:
            status = hdef.NOT_OKAY
            errtext = f"wp_search_wkn_html: crash firefox loop = {i}"
            isin = ""
            i += 1
            
        # end try
    # end while
    return (status,errtext,isin)
# end def
def wp_add_wkn_isin(wkn, isin, base_ddict):
    '''

    :param wpn:
    :param base_ddict:
    :return: (status,errtext,isin) = wp_search_wkn_html(wkn,base_ddict)
    '''
    status = hdef.OKAY
    errtext = ""
    wkn_isin_dict = wp_storage.read_dict_file(base_ddict["wkn_isin_filename"], base_ddict)
    
    wkn_isin_dict[wkn] = isin
    
    wp_storage.save_dict_file_pickle(wkn_isin_dict, base_ddict["wkn_isin_filename"], base_ddict)
    if base_ddict["use_json"] == 1:  # write json
        wp_storage.save_dict_file_json(wkn_isin_dict, base_ddict["wkn_isin_filename"], base_ddict)
    # end if
    
    return (status, errtext)

def wp_search_wpname(wpname, base_ddict):
    '''

    :param wpname:
    :param base_ddict:
    :return:  (status, errtext, isin) = wp_wkn.wp_search_wpname(wpname,base_ddict)
    '''
    status = hdef.OKAY
    errtext = ""
    wpname_isin_dict = wp_storage.read_dict_file(base_ddict["wpname_isin_filename"],base_ddict)
    
    if wpname in wpname_isin_dict.keys():
        if base_ddict["use_json"] == 1:  # write json
            wp_storage.save_dict_file_json(wpname_isin_dict, base_ddict["wpname_isin_filename"],base_ddict)
        elif base_ddict["use_json"] == 2:  # read json
            wp_storage.save_dict_file_pickle(wpname_isin_dict, base_ddict["wpname_isin_filename"], base_ddict)
        # end if
        isin = wpname_isin_dict[wpname]
        if isin == WKN_NOT_FOUND:
            isin = ""
            status = hdef.NOT_OKAY
            errtext = f"wkn: {wpname} wurde früher schon nicht gefunden"
        # endif
        return (status, errtext, wpname_isin_dict[wpname])
    else:
        status = hdef.NOT_OKAY
        errtext = ""
        isin = ""
    # end if
    
    return (status, errtext, isin)


# end def
def wp_search_wpname_in_comment(comment, base_ddict):
    '''
    
    Sucht
    
    :param comment:
    :param base_ddict:
    :return: (status, errtext, isin) = wp_wkn.wp_search_wpname_in_comment(comment,base_ddict)
    '''
    status = hdef.NOT_OKAY
    errtext = f"wp_search_wpname_in_comment: wpname wurde in {comment} nicht gefunden"
    isin = ""

    wpname_isin_dict = wp_storage.read_dict_file(base_ddict["wpname_isin_filename"], base_ddict)
    
    for wpname, key in wpname_isin_dict.items():

        index = hstr.such(comment, wpname)

        if index >= 0:
            status = hdef.OKAY
            errtext = ""
            isin = key
            break
        # end if
    # end for

    return (status, errtext, isin)
# end def

def wp_add_wpname_isin(wpname,isin, base_ddict):
    '''

    :param wpn:
    :param base_ddict:
    :return: (status,errtext,isin) = wp_search_wkn_html(wkn,base_ddict)
    '''
    status = hdef.OKAY
    errtext = ""
    wpname_isin_dict = wp_storage.read_dict_file(base_ddict["wpname_isin_filename"], base_ddict)
    
    
    wpname_isin_dict[wpname] = isin
    
    wp_storage.save_dict_file_pickle(wpname_isin_dict, base_ddict["wpname_isin_filename"], base_ddict)
    if base_ddict["use_json"] == 1:  # write json
        wp_storage.save_dict_file_json(wpname_isin_dict, base_ddict["wpname_isin_filename"], base_ddict)
    # end if
    

    return (status, errtext)