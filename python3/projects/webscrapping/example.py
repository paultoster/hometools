import re
from playwright.sync_api import Playwright, sync_playwright, expect


def run(playwright: Playwright) -> None:
    browser = playwright.chromium.launch(headless=False)
    context = browser.new_context()
    page = context.new_page()
    page.goto("https://www.ariva.de/")
    page.get_by_role("button", name="Login").click()
    page.get_by_role("textbox", name="Nutzername oder E-Mail").click()
    page.get_by_role("textbox", name="Nutzername oder E-Mail").fill("PaulToster")
    page.get_by_role("textbox", name="Passwort").click()
    page.get_by_role("textbox", name="Passwort").fill("RLj+onx,!aJL?|3y:UOE")
    page.get_by_role("button", name="Anmelden").click()

    page.locator("iframe[title=\"SP Consent Message\"]").content_frame.locator("div").nth(1).click()
    page.get_by_role("button", name="Suche öffnen").click()
    page.get_by_test_id("search-dialog-input").fill("DE0008430026")
    page.get_by_test_id("search-dialog-input").press("Enter")
    page.get_by_test_id("search-dialog-input").press("Enter")
    page.goto("https://www.ariva.de/aktien/muenchner-rueckversicherungs-ag-aktie")
    page.locator("a").filter(has_text=re.compile(r"^Kurse$")).click()
    page.locator("#tabs__list").get_by_role("link", name="Kurse").click()
    page.goto("https://www.ariva.de/aktien/muenchner-rueckversicherungs-ag-aktie/kurse/handelsplaetze")
    page.get_by_role("link", name="Historische Kurse").click()
    page.get_by_role("listitem").filter(has_text="Währung: (wählen) Euro US-").get_by_role("combobox").select_option("EUR")
    page.goto("https://www.ariva.de/aktien/muenchner-rueckversicherungs-ag-aktie/kurse/historische-kurse?go=1&currency=EUR")
    page.get_by_role("textbox", name="Vom").click()
    page.get_by_role("textbox", name="Vom").fill("28.01.2025")
    page.get_by_role("textbox", name="Vom").press("ArrowLeft")
    page.get_by_role("textbox", name="Vom").press("ArrowLeft")
    page.get_by_role("textbox", name="Vom").press("ArrowLeft")
    page.get_by_role("textbox", name="Vom").fill("01.01.2025")
    page.get_by_role("textbox", name="Vom").press("ArrowRight")
    page.get_by_role("textbox", name="Vom").press("ArrowRight")
    page.get_by_role("textbox", name="Vom").press("ArrowRight")
    page.get_by_role("textbox", name="Vom").press("ArrowRight")
    page.get_by_role("textbox", name="Vom").press("ArrowRight")
    page.get_by_role("textbox", name="Vom").press("ArrowRight")
    page.get_by_role("textbox", name="Vom").press("ArrowRight")
    page.get_by_role("textbox", name="Vom").press("ArrowRight")
    page.get_by_role("textbox", name="Vom").fill("01.01.2019")
    with page.expect_download() as download_info:
        page.get_by_role("button", name="Download").click()
    download = download_info.value
    page.locator("iframe[name=\"google_ads_iframe_/183/ariva/aktien/Nachhaltigkeit/artikel_6\"]").content_frame.locator("#iqdSitebar").click()
    page.get_by_role("button", name="Suche öffnen").click()
    page.get_by_test_id("search-dialog-input").fill("LU0322250712")
    page.get_by_test_id("search-dialog-input").press("Enter")
    page.get_by_role("link", name="Kurse", exact=True).click()
    page.get_by_role("link", name="Historische Kurse").click()
    page.get_by_role("textbox", name="Vom").click()
    page.get_by_role("textbox", name="Vom").fill("28.01.2025")
    page.get_by_role("textbox", name="Vom").press("ArrowLeft")
    page.get_by_role("textbox", name="Vom").press("ArrowLeft")
    page.get_by_role("textbox", name="Vom").press("ArrowLeft")
    page.get_by_role("textbox", name="Vom").fill("01.01.2025")
    page.get_by_role("textbox", name="Vom").press("ArrowRight")
    page.get_by_role("textbox", name="Vom").press("ArrowRight")
    page.get_by_role("textbox", name="Vom").press("ArrowRight")
    page.get_by_role("textbox", name="Vom").press("ArrowRight")
    page.get_by_role("textbox", name="Vom").press("ArrowRight")
    page.get_by_role("textbox", name="Vom").press("ArrowRight")
    page.get_by_role("textbox", name="Vom").press("ArrowRight")
    page.get_by_role("textbox", name="Vom").press("ArrowRight")
    page.get_by_role("textbox", name="Vom").fill("01.01.2019")
    with page.expect_download() as download1_info:
        page.get_by_role("button", name="Download").click()
    download1 = download1_info.value
    page.close()

    # ---------------------
    context.close()
    browser.close()


with sync_playwright() as playwright:
    run(playwright)
