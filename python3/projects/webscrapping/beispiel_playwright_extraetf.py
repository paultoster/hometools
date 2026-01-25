import re
from playwright.sync_api import Playwright, sync_playwright, expect
from PIL import Image
import pytesseract

# import time
# from bs4 import BeautifulSoup as bs
# import urllib.request

def run(playwright: Playwright) -> None:
    browser = playwright.chromium.launch(headless=False)
    context = browser.new_context()
    page = context.new_page()
    # page.goto("https://extraetf.com/de/etf-profile/IE00B3RBWM25")
    # page.goto("https://extraetf.com/de/etf-profile/DE0002635299")
    page.goto("https://extraetf.com/de/etf-profile/IE00B5KQNG97")
    
    
    
    page.get_by_role("button", name="Auswahl erlauben").click()
    page.get_by_role("link", name="Ausschüttungen", exact=True).click()
    page.locator("#dividends").get_by_text("Überblick").click()
    page.get_by_role("cell", name="2025").click()
    page.get_by_role("cell", name="2024").click()
    page.get_by_role("cell", name="2023").click()
    page.get_by_role("cell", name="2022").click()
    # page.locator("a").filter(has_text="2026").click()
    # page.get_by_role("cell", name="Ausschüttungsrendite (").click()
    # page.get_by_text("+5,07 %").click()
    
    url = page.url
    
    page.screenshot(path="playwright_screenshot.png")  # , full_page=True
    # ---------------------
    context.close()
    browser.close()
    
    text = pytesseract.image_to_string(Image.open("playwright_screenshot.png")) # , lang='deu'
    
    with open('output.txt', mode='w') as f:
        f.write(text)


with sync_playwright() as playwright:
    run(playwright)
    
    
    
# C:\Users\lino\AppData\Local\Programs\Tesseract-OCR