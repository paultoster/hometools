from playwright.sync_api import Playwright, sync_playwright, expect
import time
import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef

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

    itest = 2

    # end with

    isin = "AU3TB0000192"
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


    else:
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
    # end if