from playwright.sync_api import Playwright, sync_playwright, expect
from playwright.async_api import async_playwright
import time
import os, sys
import random
import numpy as np
import asyncio

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

def get_ariva_url_playwright(isin,log=None):
    status  =  hdef.NOT_FOUND
    errtext = ""
    
    icount = 0
    url = ""
    sleepTimeHalf = 2.5/2.
    #tTime = pTime*1000



    while (icount < 2) and (status != hdef.OKAY):
        
        try:
            with sync_playwright() as playwright:
                
                browser = playwright.chromium.launch(headless=False,slow_mo=500)
                context = browser.new_context()
                page = context.new_page()
                page.goto("https://www.ariva.de/")

                t = f"get_ariva_url_playwright: Akzeptieren und weiter (sleep:{sleepTimeHalf*2.} s)"
                if log is not None:
                    log.write_info(t)
                else:
                    print(t)
                # end if
                time.sleep(sleepTimeHalf * (1. + random.random()))
                try:
                    page.locator("iframe[title=\"SP Consent Message\"]").content_frame.get_by_role("button",
                                                                                                   name="Akzeptieren und weiter").click()
                    t = f"get_ariva_url_playwright: Nach Akzeptieren und weiter  (sleep:{sleepTimeHalf * 2.} s)"
                    if log is not None:
                        log.write_info(t)
                    else:
                        print(t)
                    # end if
                    time.sleep(sleepTimeHalf * (1. + random.random()))
                except:

                    pass
                # end try
                t = f"get_ariva_url_playwright: First pass  Akzeptieren und weiter"
                if log is not None:
                    log.write_info(t)
                else:
                    print(t)
                # end if

                t = f"get_ariva_url_playwright: Suche öffnen"
                if log is not None:
                    log.write_info(t)
                else:
                    print(t)
                # end if
                page.get_by_role("button", name="Suche öffnen").click()
                page.get_by_test_id("search-dialog-input").fill(isin)
                page.get_by_test_id("search-dialog-input").press("Enter")

                try:
                    page.locator("iframe[title=\"SP Consent Message\"]").content_frame.get_by_role("button",
                                                                                                   name="Akzeptieren und weiter").click()
                    t = f"get_ariva_url_playwright: Nach Akzeptieren und weiter  (sleep:{sleepTimeHalf * 2.} s)"
                    if log is not None:
                        log.write_info(t)
                    else:
                        print(t)
                    # end if
                    time.sleep(sleepTimeHalf * (1. + random.random()))

                except:
                    t = f"get_ariva_url_playwright: Second pass  Akzeptieren und weiter"
                    if log is not None:
                        log.write_info(t)
                    else:
                        print(t)
                    # end if
                    pass
                # end try

                t = f"get_ariva_url_playwright: First pass  Akzeptieren und weiter"
                if log is not None:
                    log.write_info(t)
                else:
                    print(t)
                # end if

                t = f"get_ariva_url_playwright: page.url übergebenr  (sleep:{sleepTimeHalf * 2.} s)"
                if log is not None:
                    log.write_info(t)
                else:
                    print(t)
                # end if
                time.sleep(sleepTimeHalf * (1. + random.random()))

                url = page.url
                
                # ---------------------
                context.close()
                browser.close()
                
            # end with
        except:
            icount += 1

            t = f"get_ariva_url_playwright: while-Schleife  (sleep:{sleepTimeHalf * 2.} s)"
            if log is not None:
                log.write_info(t)
            else:
                print(t)
            # end if
            time.sleep(sleepTimeHalf * (1. + random.random()))

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
def get_onvista_url_playwright(isin,log=None):
    """


    """
    status = hdef.NOT_FOUND
    errtext = ""

    icount = 0
    url = ""
    # tTime = 10000
    sleepTimeHalf = 2.5/2.

    while (icount < 2) and (status != hdef.OKAY):

        try:
            with sync_playwright() as playwright:

                browser = playwright.chromium.launch(headless=False, slow_mo=500)
                context = browser.new_context()
                page = context.new_page()
                page.goto("https://www.onvista.de/")

                t = f"get_onvista_url_playwright: Akzeptieren und weiter (sleep:{sleepTimeHalf*2.} s)"
                if log is not None:
                    log.write_info(t)
                else:
                    print(t)
                # end if

                time.sleep(sleepTimeHalf * (1. + random.random()))
                try:
                    page.locator("#sp_message_iframe_1441229").nth(1).content_frame.get_by_role("button",
                                                                                                name="Akzeptieren").click()
                    t = f"get_onvista_url_playwright: Nach Akzeptieren und weiter (sleep:{sleepTimeHalf * 2.} s)"
                    if log is not None:
                        log.write_info(t)
                    else:
                        print(t)
                    # end if
                    time.sleep(sleepTimeHalf * (1. + random.random()))
                except:
                    t = f"get_onvista_url_playwright: First pass  Akzeptieren und weiter"
                    if log is not None:
                        log.write_info(t)
                    else:
                        print(t)
                    # end if
                    pass
                # end try

                t = f"get_onvista_url_playwright: Suche öffnen"
                if log is not None:
                    log.write_info(t)
                else:
                    print(t)
                # end if
                page.get_by_role("textbox", name="Suche …").click()
                page.get_by_role("textbox", name="Suche …").fill(isin)
                page.get_by_role("textbox", name="Suche …").press("Enter")

                try:
                    page.locator("#sp_message_iframe_1441229").nth(1).content_frame.get_by_role("button",
                                                                                                name="Akzeptieren").click()

                    t = f"get_onvista_url_playwright: Nach Akzeptieren und weiter (sleep:{sleepTimeHalf*2.} s)"
                    if log is not None:
                        log.write_info(t)
                    else:
                        print(t)
                    # end if
                    time.sleep(sleepTimeHalf * (1. + random.random()))
                except:

                    t = f"get_onvista_url_playwright: Second pass  Akzeptieren und weiter"
                    if log is not None:
                        log.write_info(t)
                    else:
                        print(t)
                    # end if
                    pass
                # end try

                t = f"get_onvista_url_playwright: page.url(sleep:{sleepTimeHalf * 2.} s)"
                if log is not None:
                    log.write_info(t)
                else:
                    print(t)
                # end if
                time.sleep(sleepTimeHalf * (1. + random.random()))
                url = page.url

                # ---------------------
                context.close()
                browser.close()

            # end with
        except:
            icount += 1

            t = f"get_onvista_url_playwright: while-Schleife :{sleepTimeHalf * 2.} s)"
            if log is not None:
                log.write_info(t)
            else:
                print(t)
            # end if
            time.sleep(sleepTimeHalf * (1. + random.random()))
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
def get_ariva_price_volume_data(wp_dict_liste,np_classdef,ariva_user,ariva_pw,timeout_s,log=None):
    """
    :param wp_dict_liste: see definition in wp_base_price_volume.get_new_price_vol_from_ariva()
    :param np_classdef:
    :param ariva_user:
    :param ariva_pw:
    :param timeout_s:
    :return: (status,errtext,logtext,wp_dict_liste) =
                     get_price_volume_data(wp_dict_liste,np_classdef,ariva_user,ariva_pw,timeout_s)
    """
    status = hdef.NOT_FOUND
    errtext = ""

    csv_liste = ["" for i in range(len(wp_dict_liste))]

    # mit with die Abfrage starten
    for i in range(3):


        log_message(log,f"ariva_playwright: Step: {i+1}. Versuch Ariva zu öffnen")

        try:

            (status, errtext, wp_dict_liste) = asyncio.run(
                playwright_ariva(wp_dict_liste,np_classdef,ariva_user,ariva_pw,timeout_s,log))

            # with sync_playwright() as playwright:
            #
            #     akzept_flag = False # Ist ein Flag zur Identifizierung, ob die Abnickseite schon abgenickt ist
            #
            #     (status, errtext, page,context,browser,akzept_flag) = get_ariva_price_volume_start(playwright,ariva_user, ariva_pw, timeout_s,akzept_flag,log)
            #
                #
                # for index,wp_dict in enumerate(wp_dict_liste):
                #
                #     url_ariva = wp_dict["url_ariva"]
                #     flag = True
                #     if len(url_ariva) == 0:
                #         flag = False
                #         t = f"isin = {wp_dict["isin"]}: url_ariva ist nicht bekannt"
                #         if log is not None:
                #             log.write_info(t)
                #         else:
                #             print(t)
                #         # end if
                #     # end if
                #     if (url_ariva.lower() == "https://www.ariva.de/") or (url_ariva.lower() == "https://www.ariva.de"):
                #         flag = False
                #         t = f"isin = {wp_dict["isin"]}: url_ariva ist nicht vollständig"
                #         if log is not None:
                #             log.write_info(t)
                #         else:
                #             print(t)
                #         # end if
                #     # end if
                #     if flag and (wp_dict["updated"] is False):
                #
                #         t = f"ariva_playwright: Suche isin: {wp_dict['isin']} url: {wp_dict['url_ariva']}"
                #         if log is not None:
                #             log.write_info(t)
                #         else:
                #             print(t)
                #         # end if
                #
                #         (status, errtext,csv_filename,akzept_flag) = get_ariva_price_volume_isin(page,context,browser,
                #                                                                      wp_dict["isin"],
                #                                                                      url_ariva,
                #                                                                      wp_dict["start_display_dat"],
                #                                                                      timeout_s,
                #                                                                      akzept_flag,
                #                                                                      log)
                #         if status != hdef.OKAY:
                #             context.close()
                #             browser.close()
                #             break
                #         else:
                #             if csv_filename is None:
                #                 t = f"isin = {wp_dict["isin"]}: csv_filename konnte nicht von {url_ariva = } generiert werden"
                #                 if log is not None:
                #                     log.write_info(t)
                #                 else:
                #                     print(t)
                #                 # end if
                #             elif os.path.exists(csv_filename):
                #                 (status, errtext,wp_dict) = read_ariva_csv_file(csv_filename,wp_dict,np_classdef,log)
                #
                #                 if status == hdef.OKAY:
                #                     os.remove(csv_filename)
                #                     wp_dict["updated"] = True
                #                     wp_dict["update_type"] = "ariva"
                #                     wp_dict_liste[index] = wp_dict
                #                     log.write_info(f"ariva-playwright: Kurs gefunden ")
                #                 else:
                #                     log.write_info(f"ariva-playwright: Kurs nicht gefunden ")
                #                 # end if
                #             else:
                #                 t = f"isin = {wp_dict["isin"]}: {csv_filename = } konnte nicht von {url_ariva = } geöffnet werden"
                #                 if log is not None:
                #                     log.write_info(t)
                #                 else:
                #                     print(t)
                #                 # end if
                #             # end if
                #         # end if
                #     # end if
                #
                # # end for

                # web-seite schliessen
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
async def playwright_ariva(wp_dict_liste,np_classdef,ariva_user,ariva_pw,timeout_s,log):
    async with async_playwright() as playwright:
        (status,errtext,wp_dict_liste) = await run_playright_ariva(playwright,wp_dict_liste,np_classdef,ariva_user,ariva_pw,timeout_s,log)

    return (status,errtext,wp_dict_liste)
# end def
async def run_playright_ariva(playwright,wp_dict_liste,np_classdef,ariva_user,ariva_pw,timeout_s,log):

    akzept_flag = False  # Ist ein Flag zur Identifizierung, ob die Abnickseite schon abgenickt ist

    (status, errtext, page, context, browser, akzept_flag) = await get_ariva_price_volume_start(playwright, ariva_user,
                                                                                          ariva_pw, timeout_s,
                                                                                          akzept_flag, log)

    if status != hdef.OKAY:
        await context.close()
        await browser.close()
        return (status, errtext, wp_dict_liste)
    # end if

    for index, wp_dict in enumerate(wp_dict_liste):

        url_ariva = wp_dict["url_ariva"]
        flag = True
        if len(url_ariva) == 0:
            flag = False
            log_message(log,f"isin = {wp_dict["isin"]}: url_ariva ist nicht bekannt")
        # end if
        if (url_ariva.lower() == "https://www.ariva.de/") or (url_ariva.lower() == "https://www.ariva.de"):
            flag = False
            log_message(log,f"isin = {wp_dict["isin"]}: url_ariva ist nicht vollständig")
        # end if
        if flag and (wp_dict["updated"] is False):

            log_message(log,f"ariva_playwright: Suche isin: {wp_dict['isin']} url: {wp_dict['url_ariva']}")

            (status, errtext, csv_filename, akzept_flag) = await get_ariva_price_volume_isin(page, context, browser,
                                                                                       wp_dict["isin"],
                                                                                       url_ariva,
                                                                                       wp_dict["start_display_dat"],
                                                                                       timeout_s,
                                                                                       akzept_flag,
                                                                                       log)
            if status != hdef.OKAY:
                break
            else:
                if csv_filename is None:
                    log_message(log,f"isin = {wp_dict["isin"]}: csv_filename konnte nicht von {url_ariva = } generiert werden")
                elif os.path.exists(csv_filename):
                    (status, errtext, wp_dict) = read_ariva_csv_file(csv_filename, wp_dict, np_classdef, log)

                    if status == hdef.OKAY:
                        os.remove(csv_filename)
                        wp_dict["updated"] = True
                        wp_dict["update_type"] = "ariva"
                        wp_dict_liste[index] = wp_dict
                        log_message(log,f"ariva-playwright: Kurs gefunden ")
                    else:
                        log_message(log,f"ariva-playwright: Kurs nicht gefunden ")
                    # end if
                else:
                    log_message(log,f"isin = {wp_dict["isin"]}: {csv_filename = } konnte nicht von {url_ariva = } geöffnet werden")
                # end if
            # end if
        # end if

    # end for

    # web-seite schliessen
    await context.close()
    await browser.close()

    return (status, errtext, wp_dict_liste)
# enddef
async def get_ariva_price_volume_start(playwright,ariva_user,ariva_pw,timeout_s,akzept_flag,log=None):
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

    log_message(log,"ariva_playwright: Step: Open Ariva")


    browser = await playwright.chromium.launch(headless=False, slow_mo=500)
    context = await browser.new_context()
    page    = await context.new_page()
    await page.goto("https://www.ariva.de/")

    time.sleep(sleepTimeHalf *(1.+ random.random()))

    log_message(log,"ariva_playwright: goto button Akzeptieren")
    akzept_flag = await wait_for_akzept_ariva(page,akzept_flag,TimeoutTime)

    await page.get_by_role("button", name="Login").click(timeout=TimeoutTime)
    await page.wait_for_load_state('networkidle')
    # page.goto(
    #     "https://login.ariva.de/realms/ariva/protocol/openid-connect/auth?client_id=ariva-web&redirect_uri=https%3A%2F%2Fwww.ariva.de%2F%3Fbase64_redirect%3DaHR0cHM6Ly93d3cuYXJpdmEuZGUv&response_type=code&scope=openid+profile+email&state=ebf48737-c647-4f9a-aed4-06307db5f022")
    await page.get_by_role("textbox", name="Nutzername oder E-Mail").fill(ariva_user)
    await page.wait_for_load_state('networkidle')
    await page.get_by_role("textbox", name="Passwort").click(timeout=TimeoutTime)
    await page.wait_for_load_state('networkidle')
    await page.get_by_role("textbox", name="Passwort").fill(ariva_pw)
    await page.get_by_role("button", name="Anmelden").click(timeout=TimeoutTime)
    await page.wait_for_load_state('networkidle')

    log_message(log,"ariva_playwright: goto button Akzeptieren")
    akzept_flag = await wait_for_akzept_ariva(page,akzept_flag,TimeoutTime)

    log_message(log,"ariva_playwright: Ariva is Open")

    return (hdef.OKAY, "", page,context,browser,akzept_flag)
#end if
async def wait_for_akzept_ariva(page,akzept_flag,TimeoutTime):
    """
    :param page:
    :param akzept_flag:
    :param TimeoutTime:
    :return: akzept_flag = wait_for_akzept_ariva(page,akzept_flag,TimeoutTime)
    """
    if not akzept_flag:
        try:
            await page.locator("iframe[title=\"SP Consent Message\"]").content_frame.get_by_role("button",
                                                                                           name="Akzeptieren und weiter").click(timeout=TimeoutTime)
            akzept_flag = True
        except:
            pass
        # end try
    # end if
    return akzept_flag
# end def
async def get_ariva_price_volume_isin(page,context,browser, isin,url_ariva,datStrFirst,timeout_s,akzept_flag,log=None):
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
        await page.goto(url_ariva)
        time.sleep(sleepTimeHalf * (1. + random.random()))
        t = "ariva_playwright: goto button Akzeptieren"
        if log is not None:
            log.write_info(t)
        else:
            print(t)
        # end if
        akzept_flag = await wait_for_akzept_ariva(page, akzept_flag,TimeoutTime)
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
        errtext = f"ariva_playwright: url: {url_ariva} could not be opened"
        log_message(log,errtext)

        return (status,errtext,csv_filename)
    # end try

    if url.find("www.ariva.de/search") < 0:  # ISIN was found

        await page.get_by_role("link", name="Kurse").click(timeout=TimeoutTime)
        await page.wait_for_load_state('networkidle')
        # kurs_url = url.split("?")[0] + "/kurse"
        # page.goto(kurs_url, timeout=TimeoutTime)
        log_message(log,"ariva_playwright: goto button Akzeptieren")
        akzept_flag = await wait_for_akzept_ariva(page, akzept_flag,TimeoutTime)
        await page.get_by_role("link", name="Historische Kurse").click(timeout=TimeoutTime)
        await page.wait_for_load_state('networkidle')
        log_message(log,"ariva_playwright: goto button Akzeptieren")
        akzept_flag = await wait_for_akzept_ariva(page, akzept_flag,TimeoutTime)
        await page.get_by_role("textbox", name="Vom").click(timeout=TimeoutTime)
        await page.wait_for_load_state('networkidle')
        await page.get_by_role("textbox", name="Vom").fill(datStrFirst)
        await page.get_by_role("textbox", name="Trennzeichen").click(timeout=TimeoutTime)
        await page.wait_for_load_state('networkidle')
        await page.get_by_role("textbox", name="Trennzeichen").press("ArrowRight")
        await page.get_by_role("textbox", name="Trennzeichen").fill(";")

        time.sleep(sleepTimeHalf * (1. + random.random()))

        with await page.expect_download() as download_info:
            await page.get_by_role("button", name="Download").click()
            await page.wait_for_load_state('networkidle')
        download = download_info.value


        # Wait for the download process to complete and save the downloaded file somewhere
        await download.save_as(download.suggested_filename)
        time.sleep(sleepTimeHalf * (1. + random.random()))
        log_message(log,f"ariva-playwright: Downloaded suggested File {download.suggested_filename}")
        csv_filename = download.suggested_filename
    else:

        status = hdef.NOT_OKAY
        errtext = f"ariva-playwright: ISIN: {isin} in ariva not found"
        log_message(log,errtext)
    # end if
    return (status,errtext,csv_filename,akzept_flag)
# end def
def read_ariva_csv_file(csv_filename,wp_dict,np_classdef,log=None):
    """
    :param csv_filename:
    :param wp_dict:
    :param np_classdef:
    :return: (status, errtext,ariva_data_dict) = read_ariva_csv_file(csv_filename,wp_dict,np_classdef)
    """

    status = hdef.OKAY
    errtext = ""
    np_obj = np_classdef()

    t = f"ariva-playwright: read {csv_filename = }"
    if log is not None:
        log.write_info(t)
    else:
        print(t)
    # end if

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

    np_obj.sort_by_dat()

    wp_dict["np_obj_new"] = np_obj

    return (status,errtext,ariva_data_dict)
# end def
def get_onvista_price_volume_data(wp_dict_liste,np_classdef,onvista_user,onvista_pw,timeout_s,log=None):
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


        log_message(log,"onvista-playwright: Step: {i+1}. Versuch onvista zu öffnen")
        try:

            (status, errtext, wp_dict_liste) = asyncio.run(playwright_onvista(wp_dict_liste,np_classdef,onvista_user,onvista_pw,timeout_s,log))


        except:
            pass
        else:
            break
        # end try
    # end for

    return (status,errtext,wp_dict_liste)
# end def
async def playwright_onvista(wp_dict_liste,np_classdef,onvista_user,onvista_pw,timeout_s,log):
    async with async_playwright() as playwright:
        (status,errtext,wp_dict_liste) = await run_playright_onvista(playwright,wp_dict_liste,np_classdef,onvista_user,onvista_pw,timeout_s,log)

    return (status,errtext,wp_dict_liste)
# end def
async def run_playright_onvista(playwright,wp_dict_liste,np_classdef,onvista_user,onvista_pw,timeout_s,log):

    akzept_flag = False  # Ist ein Flag zur Identifizierung, ob die Abnickseite schon abgenickt ist

    (status, errtext, page, context, browser, akzept_flag) = await get_onvista_price_volume_start(playwright, onvista_user,
                                                                                            onvista_pw, timeout_s,
                                                                                            akzept_flag, log)

    if status != hdef.OKAY:
        await context.close()
        await browser.close()
        return (status, errtext, wp_dict_liste)
    # end if

    for index, wp_dict in enumerate(wp_dict_liste):

        if (len(wp_dict["isin"]) > 0) and (wp_dict["updated"] is False):

            (status, errtext, csv_filename, akzept_flag) = await get_onvista_price_volume_isin(page, context, browser,
                                                                                         wp_dict["isin"],
                                                                                         wp_dict["url_onvista"],
                                                                                         wp_dict["start_display_dat"],
                                                                                         timeout_s,
                                                                                         akzept_flag,
                                                                                         log)
            if status != hdef.OKAY:
                await context.close()
                await browser.close()
                break
            else:
                if os.path.exists(csv_filename):
                    (status, errtext, wp_dict) = read_onvista_csv_file(csv_filename, wp_dict, np_classdef, log)

                    if status == hdef.OKAY:
                        os.remove(csv_filename)
                        wp_dict["updated"] = True
                        wp_dict["update_type"] = "onvista"
                        wp_dict_liste[index] = wp_dict
                        log_message(log,f"onvista-playwright: Kurs gefunden ")
                    else:
                        log_message(log,f"onvista-playwright: Kurs nicht gefunden ")
                    # end if
                # end if
            # end if
        # end if

    # end for

    # web-seite schliessen
    await context.close()
    await browser.close()

    return (status,errtext,wp_dict_liste)
# end def
async def get_onvista_price_volume_start(playwright,onvista_user,onvista_pw,timeout_s,akzept_flag,log=None):
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

    log_message(log, "get_onvista_price_volume_start: Step: Open onvista")

    browser = await playwright.chromium.launch(headless=False, slow_mo=500)
    context = await browser.new_context()
    page    = await context.new_page()
    await page.goto("https://www.onvista.de/")

    time.sleep(sleepTimeHalf *(1.+ random.random()))

    log_message(log,"get_onvista_price_volume_start: goto button Akzeptieren")
    akzept_flag = await wait_for_akzept_onvista(page,akzept_flag,TimeoutTime)

    try:
        await page.get_by_role("button", name="Login").click(timeout=TimeoutTime)
        await page.wait_for_load_state('networkidle')
    except:
        pass

    try:
        await page.get_by_role("button", name="Anmelden").click(timeout=TimeoutTime)
        await page.wait_for_load_state('networkidle')
    except:
        pass

    await page.locator("#input-email").click(timeout=TimeoutTime)
    await page.wait_for_load_state('networkidle')
    log_message(log, "get_onvista_price_volume_start: goto button Akzeptieren")
    akzept_flag = await wait_for_akzept_onvista(page, akzept_flag, TimeoutTime)

    await page.locator("#input-email").fill(onvista_user)
    await page.wait_for_load_state('networkidle')
    log_message(log, "get_onvista_price_volume_start: goto button Akzeptieren")
    akzept_flag = await wait_for_akzept_onvista(page, akzept_flag, TimeoutTime)

    await page.locator("#input-password").click(timeout=TimeoutTime)
    await page.wait_for_load_state('networkidle')
    log_message(log, "get_onvista_price_volume_start: goto button Akzeptieren")
    akzept_flag = await wait_for_akzept_onvista(page, akzept_flag, TimeoutTime)

    await page.locator("#input-password").fill(onvista_pw)
    await page.wait_for_load_state('networkidle')
    log_message(log, "get_onvista_price_volume_start: goto button Akzeptieren")
    akzept_flag = await wait_for_akzept_onvista(page, akzept_flag, TimeoutTime)

    await page.get_by_role("button", name="Login bei my onvista").click(timeout=TimeoutTime)
    await page.wait_for_load_state('networkidle')
    log_message(log, "get_onvista_price_volume_start: goto button Akzeptieren")
    akzept_flag = await wait_for_akzept_onvista(page,akzept_flag,TimeoutTime)

    return (hdef.OKAY, "", page,context,browser,akzept_flag)
#end if
async def wait_for_akzept_onvista(page,akzept_flag,TimeoutTime):
    """
    :param page:
    :param akzept_flag:
    :param TimeoutTime:
    :return: akzept_flag = wait_for_akzept_onvista(page,akzept_flag,TimeoutTime)
    """

    if not akzept_flag:
        try:
            await page.locator("iframe[title=\"Iframe title\"]").content_frame.get_by_role("button", name="Akzeptieren").click(timeout=TimeoutTime)
            akzept_flag = True
        except:
            pass
        # end try
    # end if
    return akzept_flag
# end def
async def get_onvista_price_volume_isin(page,context,browser, isin,url_onvista,datStrFirst,timeout_s,akzept_flag,log=None):
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
            await page.goto(url_onvista)
            time.sleep(sleepTimeHalf * (1. + random.random()))
            log_message(log, "get_onvista_price_volume_isin: 1. onvista-playwright: goto button Akzeptieren")
            akzept_flag = await wait_for_akzept_onvista(page, akzept_flag,TimeoutTime)
            success_flag = True
        except:
            pass
    # end try

    if not success_flag:
        await page.get_by_role("textbox", name="Suche …").click(timeout=TimeoutTime)
        await page.wait_for_load_state('networkidle')
        await page.get_by_role("textbox", name="Suche …").fill(isin)
        await page.wait_for_load_state('networkidle')
        await page.get_by_role("textbox", name="Suche …").press("Enter")

        log_message(log, "get_onvista_price_volume_isin: 2. onvista-playwright: goto button Akzeptieren")
        akzept_flag = await wait_for_akzept_onvista(page, akzept_flag,TimeoutTime)
    # end if

    try:
        url = page.url
    except:
        url = ""
    # end try
    if len(url) == 0:
        status = hdef.NOT_OKAY
        errtext = f"onvista-playwright: url: {url_onvista} or search for {isin = } could not be opened"
        log_message(log,errtext)

        return (status,errtext,csv_filename)
    # end try

    if len(url) > len("www.onvista.de"):  # ISIN was found

        try:
            log_message(log, "get_onvista_price_volume_isin: click on Alle Kurse")
            await page.get_by_role("link", name="Alle Kurse", exact=True).click(timeout=TimeoutTime)
            await page.wait_for_load_state('networkidle')
        except:
            log_message(log, "get_onvista_price_volume_isin: except click on Alle Kurse")
        # end try
        try:
            log_message(log, "get_onvista_price_volume_isin: click on Alle Kurse mit Tab Navigation")
            await page.get_by_label("Tab Navigation").get_by_role("link", name="Alle Kurse").click(timeout=TimeoutTime)
            await page.wait_for_load_state('networkidle')
        except:
            log_message(log, "get_onvista_price_volume_isin: except click on Alle Kurse mit Tab Navigation ")
        # end try

        log_message(log, "get_onvista_price_volume_isin: 3. onvista-playwright: goto button Akzeptieren")
        akzept_flag = await wait_for_akzept_onvista(page, akzept_flag,TimeoutTime)

        try:
            log_message(log, "get_onvista_price_volume_isin: click on Historisch")
            await page.get_by_role("link", name="Historisch").click(timeout=TimeoutTime)
            await page.wait_for_load_state('networkidle')
        except:
            log_message(log, "get_onvista_price_volume_isin: except click on Historisch ")


        log_message(log, "get_onvista_price_volume_isin: 4. onvista-playwright: goto button Akzeptieren")
        akzept_flag = await wait_for_akzept_onvista(page, akzept_flag,TimeoutTime)

        try:
            log_message(log, "get_onvista_price_volume_isin: press on nach Startdatum filtern ArrowLeft")
            await page.get_by_role("textbox", name="nach Startdatum filtern").press("ArrowLeft")
            await page.wait_for_load_state('networkidle')
        except:
            log_message(log, "get_onvista_price_volume_isin: except press on nach Startdatum filtern ArrowLeft")


        try:
            datStrFirstBInv = htype.type_transform_direct(datStrFirst, "datStrP", "datStrBInv")
            log_message(log, f"get_onvista_price_volume_isin: fill nach Startdatum filtern mit {datStrFirstBInv}")
            await page.get_by_role("textbox", name="nach Startdatum filtern").fill(datStrFirstBInv) # "2000-01-01"
            await page.wait_for_load_state('networkidle')
        except:
            log_message(log, f"get_onvista_price_volume_isin: except fill nach Startdatum filtern ")

        log_message(log, "get_onvista_price_volume_isin: select_option MAX")
        await page.get_by_label("history-range").select_option("MAX")

        time.sleep(sleepTimeHalf * (1. + random.random()))

        with await page.expect_download() as download_info:
            log_message(log, "get_onvista_price_volume_isin: click on Download als CSV")
            await page.get_by_role("button", name="Download als CSV").click(timeout=TimeoutTime)
            await page.wait_for_load_state('networkidle')
            # time.sleep(sleepTimeHalf * (1. + random.random()))
        download = download_info.value

        # Wait for the download process to complete and save the downloaded file somewhere
        await download.save_as(download.suggested_filename)
        time.sleep(sleepTimeHalf * (1. + random.random()))
        log_message(log,f"onvista-playwright: Downloaded suggested File {download.suggested_filename}")
        csv_filename = download.suggested_filename
    else:

        status = hdef.NOT_OKAY
        errtext = f"onvista-playwright: ISIN: {isin} in onvista not found"
        log_message(log,errtext)
    # end if
    return (status,errtext,csv_filename,akzept_flag)
# end def
def read_onvista_csv_file(csv_filename,wp_dict,np_classdef,log=None):
    """
    :param csv_filename:
    :param wp_dict:
    :param np_classdef:
    :return: (status, errtext,ariva_data_dict) = read_onvista_csv_file(csv_filename,wp_dict,np_classdef)
    """

    status = hdef.OKAY
    errtext = ""
    np_obj = np_classdef()

    t = f"onvista-playwright: read {csv_filename = }"
    if log is not None:
        log.write_info(t)
    else:
        print(t)
    # end if

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

    np_obj.sort_by_dat()

    wp_dict["np_obj_new"] = np_obj

    return (status,errtext,ariva_data_dict)
# end def
def log_message(log,text):
    if log is not None:
        log.write_info(text)
    else:
        print(text)
    # end if
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
        ariva_data_dict_liste = [{"isin":isin,"url_ariva":ariva_url,"waehrung":"euro","updated":False},
                                 {"isin":"IE00B4L5Y983","url_ariva":"https://www.ariva.de/etf/ishares-core-msci-world-ucits-etf-usd-acc","waehrung":"euro","updated":False}]

        (status, errtext, ariva_data_dict_liste) = get_ariva_price_volume_data(ariva_data_dict_liste,
                                                                               wp_np_dc.NpPriceVolumeClass,
                                                                               ariva_user,
                                                                               ariva_pw,
                                                                               sleep_time_s)


    else: # itest = 5

        csv_filename = "wkn_A0RPWH_historic.csv"
        ariva_data_dict = {"isin":isin,"url_ariva":ariva_url,"waehrung":"euro"}

        (status,errtext,ariva_data_dict) = read_ariva_csv_file(csv_filename, ariva_data_dict, wp_np_dc.NpPriceVolumeClass)
    # end if
