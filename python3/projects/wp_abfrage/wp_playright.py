from playwright.sync_api import Playwright, sync_playwright, expect
import time
import os, sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef

def get_ariva_url_playwright(isin):
    status  =  hdef.NOT_FOUND
    errtext = ""
    
    icount = 0
    url = ""
    TimeoutTime = 1000000000
    while (icount < 2) and (status != hdef.OKAY):
        
        try:
            with sync_playwright() as playwright:
                
                browser = playwright.chromium.launch(headless=False)
                context = browser.new_context()
                page = context.new_page()
                page.goto("https://www.ariva.de/")

                page.locator("iframe[title=\"SP Consent Message\"]").content_frame.get_by_role("button",
                                                                                           name="Akzeptieren und weiter").click()

                page.get_by_role("button", name="Suche öffnen").click(timeout=TimeoutTime)
                page.get_by_test_id("search-dialog-input").fill(isin)
                page.get_by_test_id("search-dialog-input").press("Enter")

                # ppage = page.locator("div[class=snapshotName]")
                # page.get_by_role("textbox", name="Name / WKN / ISIN").click()
                # page.get_by_role("textbox", name="Name / WKN / ISIN").fill(f"{isin}")
                # page.get_by_role("textbox", name="Name / WKN / ISIN").press("Enter")
            
                title = page.title()
                
                time.sleep(5)
                url = page.url
                
                # ---------------------
                context.close()
                browser.close()
                
            # end with
        except:
            icount += 1
            time.sleep(5)
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
def get_price_volume_data(ariva_user,ariva_pw,ariva_timeout_playright,isin,datStrFirst,datStrLast):
    """

    :param wp_obj:
    :param isin:
    :param datStrFirst:
    :param datStrLast:
    :return: (status,errtext,csv_datei) = wp_playwright.get_price_volume_data(ariva_user,ariva_pw,ariva_timeout_playright,isin,datStrFirst,datStrLast)
    """
    icount = 0
    url = ""
    csv_filename = ""
    status = hdef.NOT_FOUND
    errtext = ""
    while (icount < 2) and (status != hdef.OKAY):

        try:
            with sync_playwright() as playwright:

                TimeoutTime = ariva_timeout_playright
                auser = ariva_user
                apw   = ariva_pw

                browser = playwright.chromium.launch(headless=False, slow_mo=50)
                context = browser.new_context()
                page = context.new_page()
                page.goto("https://www.ariva.de/")

                page.locator("iframe[title=\"SP Consent Message\"]").content_frame.get_by_role("button",
                                                                                               name="Akzeptieren und weiter").click()
                page.get_by_role("link", name="Login").click(timeout=TimeoutTime)
                page.goto(
                    "https://login.ariva.de/realms/ariva/protocol/openid-connect/auth?client_id=ariva-web&redirect_uri=https%3A%2F%2Fwww.ariva.de%2F%3Fbase64_redirect%3DaHR0cHM6Ly93d3cuYXJpdmEuZGUv&response_type=code&scope=openid+profile+email&state=ebf48737-c647-4f9a-aed4-06307db5f022")
                page.get_by_role("textbox", name="Nutzername oder E-Mail").fill(auser)
                page.get_by_role("textbox", name="Passwort").click(timeout=TimeoutTime)
                page.get_by_role("textbox", name="Passwort").click(timeout=TimeoutTime)
                page.get_by_role("textbox", name="Passwort").fill(apw)
                page.get_by_role("button", name="Anmelden").click()
                page.get_by_role("textbox", name="Name / WKN / ISIN").click(timeout=TimeoutTime)
                page.get_by_role("textbox", name="Name / WKN / ISIN").fill(isin)
                page.get_by_role("textbox", name="Name / WKN / ISIN").press("Enter")
                page.get_by_role("textbox", name="Name / WKN / ISIN").click(timeout=TimeoutTime)
                page.get_by_role("textbox", name="Name / WKN / ISIN").click(timeout=TimeoutTime)
                url = page.url

                if url.find("www.ariva.de/search") < 0:  # ISIN was found

                    page.get_by_role("link", name="Kurse", exact=True).click(timeout=TimeoutTime)
                    kurs_url = url.split("?")[0] + "/kurse"
                    page.goto(kurs_url, timeout=TimeoutTime)
                    time.sleep(10)
                    page.get_by_role("link", name="Historische Kurse").click(timeout=TimeoutTime)
                    page.get_by_role("textbox", name="Vom").click(timeout=TimeoutTime)
                    page.get_by_role("textbox", name="Vom").fill(datStrFirst)
                    page.get_by_role("textbox", name="Trennzeichen").click(timeout=TimeoutTime)
                    page.get_by_role("textbox", name="Trennzeichen").press("ArrowRight")
                    page.get_by_role("textbox", name="Trennzeichen").fill(";")
                    time.sleep(10)
                    with page.expect_download(timeout=TimeoutTime) as download_info:
                        page.get_by_role("button", name="Download").click(timeout=TimeoutTime)
                        time.sleep(10)
                    download = download_info.value

                    # Wait for the download process to complete and save the downloaded file somewhere
                    download.save_as(download.suggested_filename)
                    time.sleep(10)
                    print(f"Downloaded suggested File {download.suggested_filename}")
                    csv_filename = download.suggested_filename
                else:
                    print(f"ISIN: {isin} in ariva not found")
                # end if
                # ------

                context.close()
                browser.close()
            # end with
        except:
            icount += 1
            time.sleep(5)
        # end try

        if icount >= 2:
            status = hdef.NOT_FOUND
            errtext = f"get_price_volume_data: icount = {icount} playwright hat nicht funktioniert"
        elif len(csv_filename) > 0:
            status = hdef.OKAY
        else:
            status = hdef.NOT_FOUND
            errtext = f"get_price_volume_data: csv_filename = {csv_filename} ist leer"
        # end if
    # end while

    return (status, errtext, csv_filename)
# end def

if __name__ == '__main__':
    (status,errtext,url) = get_ariva_url_playwright("NO0010844079")
    if status == hdef.OKAY:
        print(f"{url = } ")
    else:
        print(f"{errtext =} ")
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