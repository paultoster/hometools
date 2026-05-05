from playwright.sync_api import Playwright, sync_playwright, expect
import time
import os, sys
import random
import numpy as np

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_io as hio
import tools.hfkt_list as hlist
import tools.hfkt_type as htype

import wp_abfrage.wp_np_dataclass as wp_np_dc

def get_ariva_url_playwright(isin):
    status  =  hdef.NOT_FOUND
    errtext = ""
    
    icount = 0
    url = ""
    tTime = 10000
    pTime = 10

    while (icount < 2) and (status != hdef.OKAY):
        
        try:
            with sync_playwright() as playwright:
                
                browser = playwright.chromium.launch(headless=False,slow_mo=500)
                context = browser.new_context()
                page = context.new_page()
                page.goto("https://www.ariva.de/")

                print(f"get_ariva_url_playwright: Akzeptieren und weiter (sleep:{pTime} s)")
                time.sleep(pTime)

                try:
                    page.locator("iframe[title=\"SP Consent Message\"]").content_frame.get_by_role("button",
                                                                                                   name="Akzeptieren und weiter").click()
                    print(f"get_ariva_url_playwright: Nach Akzeptieren und weiter (sleep:{pTime} s)")
                    time.sleep(pTime)
                except:
                    print(f"get_ariva_url_playwright: First pass  Akzeptieren und weiter")
                    pass
                # end try

                print("get_ariva_url_playwright: Suche öffnen")
                page.get_by_role("button", name="Suche öffnen").click()
                page.get_by_test_id("search-dialog-input").fill(isin)
                page.get_by_test_id("search-dialog-input").press("Enter")

                try:
                    page.locator("iframe[title=\"SP Consent Message\"]").content_frame.get_by_role("button",
                                                                                                   name="Akzeptieren und weiter").click()
                    print(f"get_ariva_url_playwright: Nach Akzeptieren und weiter (sleep:{pTime} s)")
                    time.sleep(pTime)
                except:
                    print(f"get_ariva_url_playwright: Second pass  Akzeptieren und weiter")
                    pass
                # end try

                print(f"get_ariva_url_playwright: page.url (sleep:{pTime} s)")
                time.sleep(pTime)
                url = page.url
                
                # ---------------------
                context.close()
                browser.close()
                
            # end with
        except:
            icount += 1
            print(f"get_ariva_url_playwright: while-Schleife (sleep:{pTime} s)")
            time.sleep(pTime)
        # end try
        
        if icount >= 2:
            status = hdef.NOT_FOUND
            errtext = f"get_ariva_url_playwright: icount = {icount} playwright hat nicht funktioniert"
        elif len(url) > 10:
            status  = hdef.OKAY
        else:
            status = hdef.NOT_FOUND
            errtext = f"get_ariva_url_playwright: url = {url} ist kleiner 10 Zeichen"
        # end if
    # end while
    
    return (status,errtext,url)
# end def
def get_onvista_url_playwright(isin):
    """


    """
    status = hdef.NOT_FOUND
    errtext = ""

    icount = 0
    url = ""
    tTime = 10000
    pTime = 10

    while (icount < 2) and (status != hdef.OKAY):

        try:
            with sync_playwright() as playwright:

                browser = playwright.chromium.launch(headless=False, slow_mo=500)
                context = browser.new_context()
                page = context.new_page()
                page.goto("https://www.onvista.de/")

                print(f"get_onvista_url_playwright: Akzeptieren und weiter (sleep:{pTime} s)")
                time.sleep(pTime)

                try:
                    page.locator("#sp_message_iframe_1441229").nth(1).content_frame.get_by_role("button",
                                                                                                name="Akzeptieren").click()
                    print(f"get_onvista_url_playwright: Nach Akzeptieren und weiter (sleep:{pTime} s)")
                    time.sleep(pTime)
                except:
                    print(f"get_onvista_url_playwright: First pass  Akzeptieren und weiter")
                    pass
                # end try

                print("get_onvista_url_playwright: Suche öffnen")
                page.get_by_role("textbox", name="Suche …").click()
                page.get_by_role("textbox", name="Suche …").fill(isin)
                page.get_by_role("textbox", name="Suche …").press("Enter")

                try:
                    page.locator("#sp_message_iframe_1441229").nth(1).content_frame.get_by_role("button",
                                                                                                name="Akzeptieren").click()
                    print(f"get_onvista_url_playwright: Nach Akzeptieren und weiter (sleep:{pTime} s)")
                    time.sleep(pTime)
                except:
                    print(f"get_onvista_url_playwright: Second pass  Akzeptieren und weiter")
                    pass
                # end try

                print(f"get_onvista_url_playwright: page.url (sleep:{pTime} s)")
                time.sleep(pTime)
                url = page.url

                # ---------------------
                context.close()
                browser.close()

            # end with
        except:
            icount += 1
            print(f"get_onvista_url_playwright: while-Schleife (sleep:{pTime} s)")
            time.sleep(pTime)
        # end try

        if icount >= 2:
            status = hdef.NOT_FOUND
            errtext = f"get_onvista_url_playwright: icount = {icount} playwright hat nicht funktioniert"
        elif len(url) > 10:
            status = hdef.OKAY
        else:
            status = hdef.NOT_FOUND
            errtext = f"get_onvista_url_playwright: url = {url} ist kleiner 10 Zeichen"
        # end if
    # end while

    return (status, errtext, url)


# end def
def get_ariva_price_volume_data(wp_dict_liste,np_classdef,ariva_user,ariva_pw,datStrFirst,timeout_s):
    """
    :param wp_dict_liste: see definition in wp_base_price_volume.get_new_price_vol_from_ariva()
    :param np_classdef:
    :param ariva_user:
    :param ariva_pw:
    :param timeout_s:
    :return: (status,errtext,wp_dict_liste) =
                     get_price_volume_data(wp_dict_liste,np_classdef,ariva_user,ariva_pw,timeout_s)
    """
    status = hdef.NOT_FOUND
    errtext = ""

    csv_liste = ["" for i in range(len(wp_dict_liste))]

    # mit with die Abfrage starten
    for i in range(3):

        print(f"Step: {i+1}. Versuch Ariva zu öffnen")
        try:
            with sync_playwright() as playwright:

                akzept_flag = False # Ist ein Flag zur Identifizierung, ob die Abnickseite schon abgenickt ist

                (status, errtext, page,context,browser,akzept_flag) = get_ariva_price_volume_start(playwright,ariva_user, ariva_pw, timeout_s,akzept_flag)

                if status != hdef.OKAY:
                    context.close()
                    browser.close()
                    break
                # end if

                for index,wp_dict in enumerate(wp_dict_liste):

                    if (len(wp_dict["url_avira"]) > 0) and (wp_dict["updated"] is False):

                        (status, errtext,csv_filename,akzept_flag) = get_ariva_price_volume_isin(page,context,browser,
                                                                                     wp_dict["isin"],
                                                                                     wp_dict["url_avira"],
                                                                                     datStrFirst,
                                                                                     timeout_s,
                                                                                     akzept_flag)
                        if status != hdef.OKAY:
                            context.close()
                            browser.close()
                            break
                        else:
                            if os.path.exists(csv_filename):
                                (status, errtext,wp_dict) = read_ariva_csv_file(csv_filename,wp_dict,np_classdef)

                                if status == hdef.OKAY:
                                    os.remove(csv_filename)
                                    wp_dict["updated"] = True
                                    wp_dict["update_type"] = "ariva"
                                    wp_dict_liste[index] = wp_dict
                                # end if
                            # end if
                        # end if
                    # end if

                # end for

                # web-seite schliessen
                context.close()
                browser.close()

                if status != hdef.OKAY:
                    break
                # end if
            # end with
        # end try

        except:
            pass
        else:
            break
        # end try
    # end for

    return (status,errtext,wp_dict_liste)
# end def
def get_ariva_price_volume_start(playwright,ariva_user,ariva_pw,timeout_s,akzept_flag):
    """
    :param playwright:
    :param ariva_user:
    :param ariva_pw:
    :param timeout_playright_s:
    :param sleep_time_s:
    :return: (status, errtext, page,akzept_flag) = get_price_volume_start(ariva_user,ariva_pw,timeout_playright_s,sleep_time_s)
    """
    # status = hdef.NOT_FOUND
    # errtext = ""

    TimeoutTime = timeout_s*1000
    sleepTimeHalf = timeout_s * 0.5


    print("Step: Open Ariva")

    browser = playwright.chromium.launch(headless=False, slow_mo=500)
    context = browser.new_context()
    page    = context.new_page()
    page.goto("https://www.ariva.de/")

    time.sleep(sleepTimeHalf *(1.+ random.random()))

    akzept_flag = wait_for_akzept_ariva(page,akzept_flag)

    page.get_by_role("button", name="Login").click(timeout=TimeoutTime)
    # page.goto(
    #     "https://login.ariva.de/realms/ariva/protocol/openid-connect/auth?client_id=ariva-web&redirect_uri=https%3A%2F%2Fwww.ariva.de%2F%3Fbase64_redirect%3DaHR0cHM6Ly93d3cuYXJpdmEuZGUv&response_type=code&scope=openid+profile+email&state=ebf48737-c647-4f9a-aed4-06307db5f022")
    page.get_by_role("textbox", name="Nutzername oder E-Mail").fill(ariva_user)
    page.get_by_role("textbox", name="Passwort").click(timeout=TimeoutTime)
    page.get_by_role("textbox", name="Passwort").click(timeout=TimeoutTime)
    page.get_by_role("textbox", name="Passwort").fill(ariva_pw)
    page.get_by_role("button", name="Anmelden").click(timeout=TimeoutTime)

    akzept_flag = wait_for_akzept_ariva(page,akzept_flag)

    return (hdef.OKAY, "", page,context,browser,akzept_flag)
#end if
def wait_for_akzept_ariva(page,akzept_flag):
    """
    :param page:
    :param akzept_flag:
    :return: akzept_flag = wait_for_akzept_ariva(page,akzept_flag)
    """
    print("Step: goto button Akzeptieren")
    if not akzept_flag:
        try:
            page.locator("iframe[title=\"SP Consent Message\"]").content_frame.get_by_role("button",
                                                                                           name="Akzeptieren und weiter").click()
            akzept_flag = True
        except:
            pass
        # end try
    # end if
    return akzept_flag
# end def
def get_ariva_price_volume_isin(page,context,browser, isin,url_avira,datStrFirst,timeout_s,akzept_flag):
    """
    :param page:
    :param context:
    :param browser:
    :param isin:
    :param timeout_s:
    :return:
    """
    status = hdef.OKAY
    errtext = ""

    TimeoutTime = timeout_s*1000
    sleepTimeHalf = timeout_s * 0.5
    csv_filename  = None

    try:
        page.goto(url_avira)
        time.sleep(sleepTimeHalf * (1. + random.random()))
        akzept_flag = wait_for_akzept_ariva(page, akzept_flag)
    except:
        pass
    # end try
    try:
        url = page.url
    except:
        url = ""
    # end try
    if len(url) == 0:
        status = hdef.NOT_OKAY
        errtext = f"url: {url_avira} could not be opened"
        print(errtext)
        return (status,errtext,csv_filename)
    # end try

    if url.find("www.ariva.de/search") < 0:  # ISIN was found

        page.get_by_role("link", name="Kurse", exact=True).click(timeout=TimeoutTime)
        # kurs_url = url.split("?")[0] + "/kurse"
        # page.goto(kurs_url, timeout=TimeoutTime)
        akzept_flag = wait_for_akzept_ariva(page, akzept_flag)
        page.get_by_role("link", name="Historische Kurse").click(timeout=TimeoutTime)
        akzept_flag = wait_for_akzept_ariva(page, akzept_flag)
        page.get_by_role("textbox", name="Vom").click(timeout=TimeoutTime)
        page.get_by_role("textbox", name="Vom").fill(datStrFirst)
        page.get_by_role("textbox", name="Trennzeichen").click(timeout=TimeoutTime)
        page.get_by_role("textbox", name="Trennzeichen").press("ArrowRight")
        page.get_by_role("textbox", name="Trennzeichen").fill(";")

        time.sleep(sleepTimeHalf * (1. + random.random()))

        with page.expect_download() as download_info:
            page.get_by_role("button", name="Download").click()
        download = download_info.value


        # Wait for the download process to complete and save the downloaded file somewhere
        download.save_as(download.suggested_filename)
        time.sleep(sleepTimeHalf * (1. + random.random()))
        print(f"Downloaded suggested File {download.suggested_filename}")
        csv_filename = download.suggested_filename
    else:

        status = hdef.NOT_OKAY
        errtext = f"ISIN: {isin} in ariva not found"
        print(errtext)
    # end if
    return (status,errtext,csv_filename,akzept_flag)
# end def
def read_ariva_csv_file(csv_filename,wp_dict,np_classdef):
    """
    :param csv_filename:
    :param wp_dict:
    :param np_classdef:
    :return: (status, errtext,ariva_data_dict) = read_ariva_csv_file(csv_filename,wp_dict,np_classdef)
    """

    status = hdef.OKAY
    errtext = ""
    np_obj = np_classdef()

    csv_lliste = hio.read_csv_file(file_name=csv_filename, delim=";")

    csv_lliste = hlist.erase_empty_rows_in_llist(csv_lliste)

    llist = []
    for i,csv_list in enumerate(csv_lliste):

        if i > 0:

            liste = [htype.type_transform_direct(csv_list[0], "datStrB", "dat"),
                     htype.type_transform_direct(csv_list[1], "euroStrK", "float"),
                     htype.type_transform_direct(csv_list[2], "euroStrK", "float"),
                     htype.type_transform_direct(csv_list[3], "euroStrK", "float"),
                     htype.type_transform_direct(csv_list[4], "euroStrK", "float"),
                     htype.type_transform_direct(csv_list[4], "str", "float")]

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
    np_obj.currency = wp_dict["waehrung"]



    wp_dict["np_obj_new"] = np_obj

    return (status,errtext,ariva_data_dict)
# end def
def get_onvista_price_volume_data(wp_dict_liste,np_classdef,onvista_user,onvista_pw,datStrFirst,timeout_s):
    """
    :param wp_dict_liste: see definition in wp_base_price_volume.get_new_price_vol_from_onvista()
    :param np_classdef:
    :param onvista_user:
    :param onvista_pw:
    :param timeout_s:
    :return: (status,errtext,wp_dict_liste) =
                     get_onvista_price_volume_data(wp_dict_liste,np_classdef,onvista_user,onvista_pw,timeout_s)
    """
    status = hdef.NOT_FOUND
    errtext = ""

    csv_liste = ["" for i in range(len(wp_dict_liste))]

    # mit with die Abfrage starten
    for i in range(3):

        print(f"Step: {i+1}. Versuch onvista zu öffnen")
        try:
            with sync_playwright() as playwright:

                akzept_flag = False # Ist ein Flag zur Identifizierung, ob die Abnickseite schon abgenickt ist

                (status, errtext, page,context,browser,akzept_flag) = get_onvista_price_volume_start(playwright,onvista_user, onvista_pw, timeout_s,akzept_flag)

                if status != hdef.OKAY:
                    context.close()
                    browser.close()
                    break
                # end if

                for index,wp_dict in enumerate(wp_dict_liste):

                    if (len(wp_dict["isin"]) > 0) and (wp_dict["updated"] is False):

                        (status, errtext,csv_filename,akzept_flag) = get_onvista_price_volume_isin(page,context,browser,
                                                                                     wp_dict["isin"],
                                                                                     wp_dict["url_onvista"],
                                                                                     datStrFirst,
                                                                                     timeout_s,
                                                                                     akzept_flag)
                        if status != hdef.OKAY:
                            context.close()
                            browser.close()
                            break
                        else:
                            if os.path.exists(csv_filename):
                                (status, errtext,wp_dict) = read_onvista_csv_file(csv_filename,wp_dict,np_classdef)

                                if status == hdef.OKAY:
                                    os.remove(csv_filename)
                                    wp_dict["updated"] = True
                                    wp_dict["update_type"] = "onvista"
                                    wp_dict_liste[index] = wp_dict
                                # end if
                            # end if
                        # end if
                    # end if

                # end for

                # web-seite schliessen
                context.close()
                browser.close()

                if status != hdef.OKAY:
                    break
                # end if
            # end with
        # end try

        except:
            pass
        else:
            break
        # end try
    # end for

    return (status,errtext,wp_dict_liste)
# end def
def get_onvista_price_volume_start(playwright,onvista_user,onvista_pw,timeout_s,akzept_flag):
    """
    :param playwright:
    :param onvista_user:
    :param onvista_pw:
    :param timeout_playright_s:
    :param sleep_time_s:
    :return: (status, errtext, page,akzept_flag) = get_price_volume_start(onvista_user,onvista_pw,timeout_playright_s,sleep_time_s)
    """
    # status = hdef.NOT_FOUND
    # errtext = ""

    TimeoutTime = timeout_s*1000
    sleepTimeHalf = timeout_s * 0.5


    print("Step: Open onvista")

    browser = playwright.chromium.launch(headless=False, slow_mo=500)
    context = browser.new_context()
    page    = context.new_page()
    page.goto("https://www.onvista.de/")

    time.sleep(sleepTimeHalf *(1.+ random.random()))

    akzept_flag = wait_for_akzept_onvista(page,akzept_flag)

    page.get_by_role("button", name="Login").click(timeout=TimeoutTime)

    page.get_by_role("button", name="Anmelden").click()
    page.locator("#input-email").click()
    page.locator("#input-email").fill(onvista_user)
    page.locator("#input-password").click()
    page.locator("#input-password").fill(onvista_pw)
    page.get_by_role("button", name="Login bei my onvista").click()

    akzept_flag = wait_for_akzept_onvista(page,akzept_flag)

    return (hdef.OKAY, "", page,context,browser,akzept_flag)
#end if
def wait_for_akzept_onvista(page,akzept_flag):
    """
    :param page:
    :param akzept_flag:
    :return: akzept_flag = wait_for_akzept_ariva(page,akzept_flag)
    """
    print("Step: goto button Akzeptieren")
    if not akzept_flag:
        try:
            page.locator("iframe[title=\"Iframe title\"]").content_frame.get_by_role("button", name="Akzeptieren").click()
            akzept_flag = True
        except:
            pass
        # end try
    # end if
    return akzept_flag
# end def
def get_onvista_price_volume_isin(page,context,browser, isin,url_onvista,datStrFirst,timeout_s,akzept_flag):
    """
    :param page:
    :param context:
    :param browser:
    :param isin:
    :param timeout_s:
    :return:
    """
    status = hdef.OKAY
    errtext = ""

    TimeoutTime = timeout_s*1000
    sleepTimeHalf = timeout_s * 0.5
    csv_filename  = None


    success_flag = False
    if len(url_onvista) > 0:

        try:
            page.goto(url_onvista)
            time.sleep(sleepTimeHalf * (1. + random.random()))
            akzept_flag = wait_for_akzept_onvista(page, akzept_flag)
            success_flag = True
        except:
            pass
    # end try

    if not success_flag:
        page.get_by_role("textbox", name="Suche …").click(timeout=TimeoutTime)
        page.get_by_role("textbox", name="Suche …").fill(isin)
        page.get_by_role("textbox", name="Suche …").press("Enter")
        akzept_flag = wait_for_akzept_onvista(page, akzept_flag)
    # end if

    try:
        url = page.url
    except:
        url = ""
    # end try
    if len(url) == 0:
        status = hdef.NOT_OKAY
        errtext = f"url: {url_onvista} or search for {isin = } could not be opened"
        print(errtext)
        return (status,errtext,csv_filename)
    # end try

    if len(url) > len("www.onvista.de"):  # ISIN was found

        page.get_by_role("link", name="Alle Kurse", exact=True).click(timeout=TimeoutTime)
        akzept_flag = wait_for_akzept_ariva(page, akzept_flag)
        page.get_by_role("link", name="Historisch").click(timeout=TimeoutTime)
        akzept_flag = wait_for_akzept_ariva(page, akzept_flag)
        page.get_by_role("textbox", name="nach Startdatum filtern").press("ArrowLeft")
        page.get_by_role("textbox", name="nach Startdatum filtern").press("ArrowLeft")
        import tools.hfkt_type as htype
        datStrFirstBInv = htype.type_transform_direct(datStrFirst, "datStrP", "datStrBInv")
        page.get_by_role("textbox", name="nach Startdatum filtern").fill(datStrFirstBInv) # "2000-01-01"
        page.get_by_label("history-range").select_option("MAX")

        time.sleep(sleepTimeHalf * (1. + random.random()))

        with page.expect_download() as download_info:
            page.get_by_role("button", name="Download als CSV").click()
        download = download_info.value


        # Wait for the download process to complete and save the downloaded file somewhere
        download.save_as(download.suggested_filename)
        time.sleep(sleepTimeHalf * (1. + random.random()))
        print(f"Downloaded suggested File {download.suggested_filename}")
        csv_filename = download.suggested_filename
    else:

        status = hdef.NOT_OKAY
        errtext = f"ISIN: {isin} in onvista not found"
        print(errtext)
    # end if
    return (status,errtext,csv_filename,akzept_flag)
# end def
def read_onvista_csv_file(csv_filename,wp_dict,np_classdef):
    """
    :param csv_filename:
    :param wp_dict:
    :param np_classdef:
    :return: (status, errtext,ariva_data_dict) = read_onvista_csv_file(csv_filename,wp_dict,np_classdef)
    """

    status = hdef.OKAY
    errtext = ""
    np_obj = np_classdef()

    csv_lliste = hio.read_csv_file(file_name=csv_filename, delim=";")

    csv_lliste = hlist.erase_empty_rows_in_llist(csv_lliste)

    llist = []
    for i,csv_list in enumerate(csv_lliste):

        if i > 0:

            liste = [htype.type_transform_direct(csv_list[0], "datStrB", "dat"),
                     htype.type_transform_direct(csv_list[1], "euroStrK", "float"),
                     htype.type_transform_direct(csv_list[2], "euroStrK", "float"),
                     htype.type_transform_direct(csv_list[3], "euroStrK", "float"),
                     htype.type_transform_direct(csv_list[4], "euroStrK", "float"),
                     htype.type_transform_direct(csv_list[4], "str", "float")]

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
    np_obj.currency = wp_dict["waehrung"]



    wp_dict["np_obj_new"] = np_obj

    return (status,errtext,ariva_data_dict)
# end def

# def get_price_volume_data(ariva_user,ariva_pw,ariva_timeout_playright,isin,datStrFirst,datStrLast):
#     """
#
#     :param wp_obj:
#     :param isin:
#     :param datStrFirst:
#     :param datStrLast:
#     :return: (status,errtext,csv_datei) = wp_playwright.get_price_volume_data(ariva_user,ariva_pw,ariva_timeout_playright,isin,datStrFirst,datStrLast)
#     """
#     icount = 0
#     url = ""
#     csv_filename = ""
#     status = hdef.NOT_FOUND
#     errtext = ""
#     while (icount < 2) and (status != hdef.OKAY):
#
#         try:
#             with sync_playwright() as playwright:
#
#                 TimeoutTime = ariva_timeout_playright
#                 auser = ariva_user
#                 apw   = ariva_pw
#
#                 browser = playwright.chromium.launch(headless=False, slow_mo=50)
#                 context = browser.new_context()
#                 page = context.new_page()
#                 page.goto("https://www.ariva.de/")
#
#                 page.locator("iframe[title=\"SP Consent Message\"]").content_frame.get_by_role("button",
#                                                                                                name="Akzeptieren und weiter").click()
#                 page.get_by_role("link", name="Login").click(timeout=TimeoutTime)
#                 page.goto(
#                     "https://login.ariva.de/realms/ariva/protocol/openid-connect/auth?client_id=ariva-web&redirect_uri=https%3A%2F%2Fwww.ariva.de%2F%3Fbase64_redirect%3DaHR0cHM6Ly93d3cuYXJpdmEuZGUv&response_type=code&scope=openid+profile+email&state=ebf48737-c647-4f9a-aed4-06307db5f022")
#                 page.get_by_role("textbox", name="Nutzername oder E-Mail").fill(auser)
#                 page.get_by_role("textbox", name="Passwort").click(timeout=TimeoutTime)
#                 page.get_by_role("textbox", name="Passwort").click(timeout=TimeoutTime)
#                 page.get_by_role("textbox", name="Passwort").fill(apw)
#                 page.get_by_role("button", name="Anmelden").click()
#                 page.get_by_role("textbox", name="Name / WKN / ISIN").click(timeout=TimeoutTime)
#                 page.get_by_role("textbox", name="Name / WKN / ISIN").fill(isin)
#                 page.get_by_role("textbox", name="Name / WKN / ISIN").press("Enter")
#                 page.get_by_role("textbox", name="Name / WKN / ISIN").click(timeout=TimeoutTime)
#                 page.get_by_role("textbox", name="Name / WKN / ISIN").click(timeout=TimeoutTime)
#                 url = page.url
#
#                 if url.find("www.ariva.de/search") < 0:  # ISIN was found
#
#                     page.get_by_role("link", name="Kurse", exact=True).click(timeout=TimeoutTime)
#                     kurs_url = url.split("?")[0] + "/kurse"
#                     page.goto(kurs_url, timeout=TimeoutTime)
#                     time.sleep(10)
#                     page.get_by_role("link", name="Historische Kurse").click(timeout=TimeoutTime)
#                     page.get_by_role("textbox", name="Vom").click(timeout=TimeoutTime)
#                     page.get_by_role("textbox", name="Vom").fill(datStrFirst)
#                     page.get_by_role("textbox", name="Trennzeichen").click(timeout=TimeoutTime)
#                     page.get_by_role("textbox", name="Trennzeichen").press("ArrowRight")
#                     page.get_by_role("textbox", name="Trennzeichen").fill(";")
#                     time.sleep(10)
#                     with page.expect_download(timeout=TimeoutTime) as download_info:
#                         page.get_by_role("button", name="Download").click(timeout=TimeoutTime)
#                         time.sleep(10)
#                     download = download_info.value
#
#                     # Wait for the download process to complete and save the downloaded file somewhere
#                     download.save_as(download.suggested_filename)
#                     time.sleep(10)
#                     print(f"Downloaded suggested File {download.suggested_filename}")
#                     csv_filename = download.suggested_filename
#                 else:
#                     print(f"ISIN: {isin} in ariva not found")
#                 # end if
#                 # ------
#
#                 context.close()
#                 browser.close()
#             # end with
#         except:
#             icount += 1
#             time.sleep(5)
#         # end try
#
#         if icount >= 2:
#             status = hdef.NOT_FOUND
#             errtext = f"get_price_volume_data: icount = {icount} playwright hat nicht funktioniert"
#         elif len(csv_filename) > 0:
#             status = hdef.OKAY
#         else:
#             status = hdef.NOT_FOUND
#             errtext = f"get_price_volume_data: csv_filename = {csv_filename} ist leer"
#         # end if
#     # end while
#
#     return (status, errtext, csv_filename)
# # end def

if __name__ == '__main__':






    itest = 4

    # end with

    isin = "AU3TB0000192"
    ariva_url = "https://www.ariva.de/AU3TB0000192"

    if itest == 1:

        (status,errtext,url) = get_ariva_url_playwright(isin)
        if status == hdef.OKAY:
            print(f"{url = } ")
        else:
            print(f"{errtext =} ")
        # end if
    elif itest == 2:

        from bs4 import BeautifulSoup as bs
        import urllib.request
        import codecs

        (status,errtext,url) = get_onvista_url_playwright(isin)
        if status == hdef.OKAY:
            print(f"{url = } ")
        else:
            print(f"{errtext =} ")
        # end if

        newpage = urllib.request.urlopen(url)
        soup = bs(newpage, 'html.parser')

        with codecs.open('output_onvista.txt', 'w', 'utf-8') as f:
            f.write(soup.__str__())


    elif itest == 3:
        (status,errtext,csv_filename) = get_price_volume_data("PaulToster",
                                                               "RLj+onx,!aJL?|3y:UOE",
                                                               10000,
                                                               "NO0010844079",
                                                               "01.01.2000",
                                                               "17.02.2026")
        if status == hdef.OKAY:
            print(f"{csv_file = } {os.psth.isfile(csv_filename) = } ")
        else:
            print(f"{errtext =} ")
    elif itest == 4:

        ariva_user = "PaulToster"
        ariva_pw = "RLj+onx,!aJL?|3y:UOE"
        sleep_time_s = 10
        ariva_data_dict_liste = [{"isin":isin,"url_avira":ariva_url,"waehrung":"euro","updated":False},
                                 {"isin":"IE00B4L5Y983","url_avira":"https://www.ariva.de/etf/ishares-core-msci-world-ucits-etf-usd-acc","waehrung":"euro","updated":False}]

        (status, errtext, ariva_data_dict_liste) = get_ariva_price_volume_data(ariva_data_dict_liste,
                                                                               wp_np_dc.NpPriceVolumeClass,
                                                                               ariva_user,
                                                                               ariva_pw,
                                                                               "01.01.2000",
                                                                               sleep_time_s)


    else: # itest = 5

        csv_filename = "wkn_A0RPWH_historic.csv"
        ariva_data_dict = {"isin":isin,"url_avira":ariva_url,"waehrung":"euro"}

        (status,errtext,ariva_data_dict) = read_ariva_csv_file(csv_filename, ariva_data_dict, wp_np_dc.NpPriceVolumeClass)
    # end if
