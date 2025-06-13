from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

import time

import tools.hfkt_def as hdef
import tools.hfkt_type as htype
import wp_abfrage.wp_storage as wp_storage

WKN_NOT_FOUND = "wknnotfound"

def wp_search_wkn(wkn,ddict):
    '''
    
    :param wkn:
    :param ddict:
    :return:  (status, errtext, isin) = wp_wkn.wp_search_wkn(wkn,ddict)
    '''
    status = hdef.OKAY
    errtext = ""
    wkn_isin_dict = wp_storage.read_wkn_isin_file(ddict)
    
    if wkn in wkn_isin_dict.keys():
        if ddict["use_json"] == 1: # write json
            wp_storage.save_wkn_isin_file_json(wkn_isin_dict,ddict)
        elif ddict["use_json"] == 2: # read json
            wp_storage.save_wkn_isin_file_pickle(wkn_isin_dict,ddict)
        # end if
        isin = wkn_isin_dict[wkn]
        if isin == WKN_NOT_FOUND:
            isin = ""
            status = hdef.NOT_OKAY
            errtext = f"wkn: {wkn} wurde früher schon nicht gefunden"
        # endif
        return (status,errtext,wkn_isin_dict[wkn])
    else:
        (status,errtext,isin) = wp_search_wkn_html(wkn,ddict)
        
        if status == hdef.OKAY:
            wkn_isin_dict[wkn] = isin
        else:
            wkn_isin_dict[wkn] = WKN_NOT_FOUND
        # end if
        wp_storage.save_wkn_isin_file_pickle(wkn_isin_dict, ddict)
        if ddict["use_json"] == 1:  # write json
            wp_storage.save_wkn_isin_file_json(wkn_isin_dict, ddict)
        # end if
    # end if
    
    return (status,errtext,isin)
# end def
def wp_search_wkn_html(wkn,ddict):
    '''
    
    :param wpn:
    :param ddict:
    :return: (status,errtext,isin) = wp_search_wkn_html(wkn,ddict)
    '''
    n = ddict["wkn_isin_n_times"]
    i = 1
    while i < n:
        try:
            url = f"https://www.ariva.de"
            driver = webdriver.Firefox()
            driver.implicitly_wait(ddict["wkn_isin_sleep_time"])
            driver.get(url)
            print(f"driver.title = {driver.title}")
            
            element = driver.find_element(By.ID, "main-search")
            WebDriverWait(driver, ddict["wkn_isin_sleep_time"]).until(EC.presence_of_element_located((By.ID, "main-search")))
            time.sleep(ddict["wkn_isin_sleep_time"])
            element.send_keys(wkn)
            element.send_keys(Keys.RETURN)
            time.sleep(ddict["wkn_isin_sleep_time"])
            
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