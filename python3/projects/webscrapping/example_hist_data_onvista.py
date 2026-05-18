import re
from playwright.sync_api import Playwright, sync_playwright, expect


def run(playwright: Playwright) -> None:
    browser = playwright.chromium.launch(headless=False)
    context = browser.new_context()
    page = context.new_page()
    page.goto("https://www.onvista.de/")
    page.get_by_role("button", name="Anmelden").click()
    page.locator("iframe[title=\"Iframe title\"]").content_frame.get_by_role("button", name="Akzeptieren").click()
    page.locator("#input-email").click()
    page.locator("#input-email").fill("t.b.email@web.de")
    page.locator("#input-password").click()
    page.locator("#input-password").click()
    page.locator("#input-password").fill("i9WB/td&,279b#pgS.1WP7_1KC$7?@")
    page.get_by_role("button", name="Login bei my onvista").click()
    page.goto("https://www.onvista.de/anleihen/AUSTRALIA-2037-144-Anleihe-AU3TB0000192")
    page.get_by_label("Tab Navigation").get_by_role("link", name="Alle Kurse").click()
    page.get_by_label("history-range").select_option("MAX")
    with page.expect_download() as download_info:
        page.get_by_role("button", name="Download als CSV").click()
    download = download_info.value
    page.get_by_label("history-market").select_option("255761423")
    with page.expect_download() as download1_info:
        page.get_by_role("button", name="Download als CSV").nth(1).click()
    download1 = download1_info.value
    page.close()

    # ---------------------
    context.close()
    browser.close()


with sync_playwright() as playwright:
    run(playwright)
