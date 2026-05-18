import re
from playwright.sync_api import Playwright, sync_playwright, expect
from playwright.async_api import async_playwright
import asyncio

async def run(playwright: Playwright) -> None:

    browser = await playwright.chromium.launch(headless=False)
    context = await browser.new_context()
    page = await context.new_page()
    await page.goto("https://www.ariva.de/")
    await page.get_by_role("button", name="Login").click()
    await page.get_by_role("textbox", name="Nutzername oder E-Mail").click()
    await page.get_by_role("textbox", name="Nutzername oder E-Mail").fill("PaulToster")
    await page.get_by_role("textbox", name="Passwort").click()
    await page.get_by_role("textbox", name="Passwort").fill("RLj+onx,!aJL?|3y:UOE")
    await page.get_by_role("button", name="Anmelden").click()
    try:
        await page.locator("iframe[title=\"SP Consent Message\"]").content_frame.get_by_role("button", name="Akzeptieren und weiter").click()
    except:
        pass

    await page.get_by_role("button", name="Suche öffnen").click()
    await page.get_by_test_id("search-dialog-input").fill("AU3TB0000192")
    await page.get_by_test_id("search-dialog-input").press("Enter")
    await page.get_by_role("link", name="Kurse", exact=True).click()
    # await page.goto("https://www.ariva.de/AU3TB0000192/kurse/handelsplaetze")
    await page.get_by_role("link", name="Historische Kurse").click()
    await page.get_by_role("textbox", name="Vom").click()
    with page.expect_download() as download_info:
        await page.get_by_role("button", name="Download").click()
    download = download_info.value
    await page.get_by_role("button", name="Profile").click()
    await page.get_by_role("button", name="Logout").click()
    await page.close()

    # ---------------------
    await context.close()
    await browser.close()


async def playwright_ariva():

    async with async_playwright() as playwright:
        await run(playwright)

# end def

asyncio.run(playwright_ariva())