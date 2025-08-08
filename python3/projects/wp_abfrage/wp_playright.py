from playwright.sync_api import Playwright, sync_playwright, expect
import time
import tools.hfkt_def as hdef

def get_ariva_url_playwright(isin):
    status  =  hdef.NOT_FOUND
    errtext = ""
    
    icount = 0
    url = ""
    while (icount < 2) and (status != hdef.OKAY):
        
        try:
            with sync_playwright() as playwright:
                
                browser = playwright.chromium.launch(headless=False)
                context = browser.new_context()
                page = context.new_page()
                page.goto("https://www.ariva.de/")
                page.locator("iframe[title=\"SP Consent Message\"]").content_frame.get_by_role("button",
                                                                                           name="Akzeptieren und weiter").click()
            
                ppage = page.locator("div[class=snapshotName]")
                page.get_by_role("textbox", name="Name / WKN / ISIN").click()
                page.get_by_role("textbox", name="Name / WKN / ISIN").fill(f"{isin}")
                page.get_by_role("textbox", name="Name / WKN / ISIN").press("Enter")
            
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
        
        if len(url) > 10:
            status  = hdef.OKAY
        else:
            status = hdef.NOT_FOUND
            errtext = f"url = {url} ist kleiner 10 Zeichen"
        # end if
    # end while
    
    return (status,errtext,url)
# end def