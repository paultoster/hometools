import re
import time
from playwright.sync_api import Playwright, sync_playwright, expect


def run(playwright: Playwright) -> None:
    
    TimeoutTime = 100000
    isin        = "IE00B5BMR087"
    
    browser = playwright.chromium.launch(headless=False,slow_mo=50)
    context = browser.new_context()
    page = context.new_page()
    page.goto("https://www.ariva.de/")
    page.locator("iframe[title=\"SP Consent Message\"]").content_frame.get_by_role("button", name="Akzeptieren und weiter").click()
    page.get_by_role("link", name="Login").click(timeout=TimeoutTime)
    page.goto("https://login.ariva.de/realms/ariva/protocol/openid-connect/auth?client_id=ariva-web&redirect_uri=https%3A%2F%2Fwww.ariva.de%2F%3Fbase64_redirect%3DaHR0cHM6Ly93d3cuYXJpdmEuZGUv&response_type=code&scope=openid+profile+email&state=ebf48737-c647-4f9a-aed4-06307db5f022")
    page.get_by_role("textbox", name="Nutzername oder E-Mail").fill("PaulToster")
    page.get_by_role("textbox", name="Passwort").click(timeout=TimeoutTime)
    page.get_by_role("textbox", name="Passwort").click(timeout=TimeoutTime)
    page.get_by_role("textbox", name="Passwort").fill("RLj+onx,!aJL?|3y:UOE")
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
        page.goto(kurs_url,timeout=TimeoutTime)
        time.sleep(10)
        page.get_by_role("link", name="Historische Kurse").click(timeout=TimeoutTime)
        page.get_by_role("textbox", name="Vom").click(timeout=TimeoutTime)
        page.get_by_role("textbox", name="Vom").fill("01.01.2020")
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
    else:
        print(f"ISIN: {isin} in ariva not found")
    # end if
    # ------
    
    
    
    context.close()
    browser.close()


with sync_playwright() as playwright:
    run(playwright)
