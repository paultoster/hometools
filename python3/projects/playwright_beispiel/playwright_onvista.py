import re
from playwright.sync_api import Playwright, sync_playwright, expect
import time

tTime = 30000
pTime = 30

def run(playwright: Playwright) -> None:
    counter = 0
    browser = playwright.chromium.launch(headless=False,slow_mo=500)
    context = browser.new_context()
    page = context.new_page()
    print("Step: goto onvista")
    page.goto("https://www.onvista.de/",timeout=tTime)

    print("Step: goto button Anmledung")
    page.get_by_role("button", name="Anmelden").click(timeout=tTime)
    time.sleep(pTime)

    print("Step: goto button Akzeptieren")
    try:
        page.locator("iframe[title=\"Iframe title\"]").content_frame.get_by_role("button", name="Akzeptieren").click(timeout=tTime)
        time.sleep(pTime)
    except:
        pass
    # end try

    print("Step: goto button #input-email")
    page.locator("#input-email").click(timeout=tTime)
    time.sleep(pTime)

    print("Step: goto #input-email input")
    page.locator("#input-email").fill("t.b.email@web.de")
    time.sleep(pTime)

    print("Step: goto button #input-password")
    page.locator("#input-password").click(timeout=tTime)
    time.sleep(pTime)

    print("Step: goto #input-password input")
    page.locator("#input-password").fill("i9WB/td&,279b#pgS.1WP7_1KC$7?@")
    time.sleep(pTime)

    print("Step: Login")
    page.get_by_role("button", name="Login bei my onvista").click(timeout=tTime)
    time.sleep(pTime)

    print("Step: Suche")
    page.get_by_role("textbox", name="Suche …").click(timeout=tTime)
    time.sleep(pTime)

    print("Step: Suche DE0005318406")
    page.get_by_role("textbox", name="Suche …").fill("DE0005318406")
    time.sleep(pTime)

    print("Step: Suche Enter")
    page.get_by_role("textbox", name="Suche …").press("Enter")
    time.sleep(pTime)

    print("Step: goto https://www.onvista.de/fonds/DWS-ESG-STIFTUNGSFONDS-LD-EUR-DIS-Fonds-DE0005318406")
    page.goto("https://www.onvista.de/fonds/DWS-ESG-STIFTUNGSFONDS-LD-EUR-DIS-Fonds-DE0005318406",timeout=tTime)
    time.sleep(pTime)

    print("Step: Alle Kurse")
    page.get_by_label("Tab Navigation").get_by_role("link", name="Alle Kurse").click(timeout=tTime)
    # page.get_by_role("link", name="Alle Kurse", exact=True).click(timeout=tTime)
    time.sleep(pTime)

    print("Step: history-range")
    page.get_by_label("history-range").select_option("MAX")
    time.sleep(pTime)

    with page.expect_download() as download_info:

        print("Step: Download als CSV")
        page.get_by_role("button", name="Download als CSV").nth(1).click(timeout=tTime)
    # end with

    print("Step: Download copy")
    download = download_info.value
    download.save_as(download.suggested_filename)
    print(f"Downloaded suggested File {download.suggested_filename}")

    print("Step: Benutzer-Optionen anzeigen")
    page.get_by_role("button", name="Benutzer-Optionen anzeigen").click(timeout=tTime)
    time.sleep(pTime)

    print("Step: Abmelden")
    page.get_by_role("link", name="Abmelden").click(timeout=tTime)
    time.sleep(pTime)

    print("Step: close")
    page.close()

    # ---------------------
    context.close()
    browser.close()


with sync_playwright() as playwright:
    run(playwright)
