import re
from playwright.sync_api import Playwright, sync_playwright, expect
import time
from bs4 import BeautifulSoup as bs
import urllib.request

import os, sys
tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_str as hstr

tTime = 10000
pTime = 10



def run(playwright: Playwright) -> None:

    browser = playwright.chromium.launch(headless=False,slow_mo=500)
    context = browser.new_context()
    page = context.new_page()
    page.goto("https://www.ariva.de/")
    time.sleep(pTime)

    print("Step: goto button Akzeptieren")
    try:
        page.locator("iframe[title=\"SP Consent Message\"]").content_frame.get_by_role("button",
                                                                                       name="Akzeptieren und weiter").click()
        time.sleep(pTime)
    except:
        pass
    # end try

    print("Step: Suche öffnen")
    page.get_by_role("button", name="Suche öffnen").click()
    page.get_by_test_id("search-dialog-input").fill("AU3TB0000192")
    page.get_by_test_id("search-dialog-input").press("Enter")
    try:
        page.locator("iframe[title=\"SP Consent Message\"]").content_frame.get_by_role("button", name="Akzeptieren und weiter").click()

        time.sleep(pTime)
    except:
        pass
    # end try

    time.sleep(pTime)

    title = page.title()
    
    print(f"title: {title}")
    time.sleep(5)
    url = page.url
    print(f"url = {url}")

    context.close()
    browser.close()

# print("--------------------------------------------------------------------------------------------------------------")
    # print(soup.title)
    # print(soup.title.string)
    #
    # liste = soup.find_all('meta')
    # for i,item in enumerate(liste):
    #     # print(f"{i}.: {item}")
    #     print(f"meta: content: {item.get('href')}")
    #
    # tags = soup.select('meta')
    # print(tags)
    # print("--------------------------------------------------------------------------------------------------------------")

    # ---------------------

    newpage = urllib.request.urlopen(url)
    soup = bs(newpage, 'html.parser')

    # Save original stdout
    o = sys.stdout

    # Redirect stdout to a file
    with open('output.txt', 'w') as f:
        sys.stdout = f
        print(soup)

    # Restore stdout
    sys.stdout = o



    info_text = {}
    
    # -------------------------------------------------------------------------
    # name
    # -------------------------------------------------------------------------
    liste = soup.find_all("span", itemprop="name")
    name = ""
    for item in liste:
        nname = item.text
        if len(nname) > len(name):
            name = nname
        # end if
    # end for
    name = hstr.change(name, '\n', ' ')
    name = hstr.elim_ae(name.replace('\xa0', ' '), ' ')
    info_text["name"] = name
    
    # -------------------------------------------------------------------------
    # type, isin, wkn
    # -------------------------------------------------------------------------
    liste = soup.find_all("div", "verlauf snapshotInfo")
    type_text = ""
    isin_text = ""
    wkn_text = ""
    
    for i, item in enumerate(liste):
        tt = item.text
        tt = hstr.change(tt, '\n', ' ')
        tt = hstr.change_max(tt, '  ', ' ')
        splitliste = tt.split(' ')
        typeflag = False
        isinflag = False
        wknflag = False
        count = 0
        for body in splitliste:
            if typeflag:
                type_text = body
                count += 1
                typeflag = False
            elif isinflag:
                isin_text = body
                count += 1
                isinflag = False
            elif wknflag:
                wkn_text = body
                count += 1
                wknflag = False
            # end if
            
            if count == 3:
                break
            # end if
            
            if body == "Typ:":
                typeflag = True
            elif body == "ISIN:":
                isinflag = True
            elif body == "WKN:":
                wknflag = True
            # end fif
        # end for
        if len(type_text):
            info_text["type"] = type_text
        if len(wkn_text):
            info_text["wkn"] = wkn_text
        if len(isin_text):
            info_text["isin"] = isin_text
    # end for
    
    print(f"info_text = {info_text}")

with sync_playwright() as playwright:
    run(playwright)
