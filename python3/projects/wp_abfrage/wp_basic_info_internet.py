from bs4 import BeautifulSoup as bs
import urllib.request
import re
import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_str as hstr
import tools.hfkt_type as htype
import time

if os.path.isfile('wp_base.py'):
    import wp_playwright as wp_pr
else:
    import wp_abfrage.wp_playwright as wp_pr
# end if


def search(isin):
    '''
    
    :param isin:
    :return: (status, errtext, info_dict) = wp_basic_info_internet.search(isin)
    '''

    info_dict = get_default_info_dict(isin)

    print(f"            versuche extraetf_ETF")
    (status, errtext, info_dict) = extraetf_ETF(isin, info_dict)

    if status == hdef.NOT_FOUND:

        print(f"            versuche extraetf_Aktie")
        info_dict = get_default_info_dict(isin)
        (status, errtext, info_dict) = extraetf_Aktie(isin, info_dict)

    if status == hdef.NOT_FOUND:

        print(f"            versuche extraetf_Fond")
        info_dict = get_default_info_dict(isin)
        (status, errtext, info_dict) = extraetf_Fond(isin, info_dict)


    # suche ariva-Webseite
    (stat, errtext, url) = wp_pr.get_ariva_url_playwright(isin)
    if stat == hdef.OKAY and status == hdef.OKAY:
        info_dict["url_ariva"] = url
    # end if

    if stat == hdef.OKAY and status == hdef.NOT_FOUND:

        print(f"            versuche ariva")
        info_dict = get_default_info_dict(isin)
        (status, errtext, info_dict) = ariva_anleihe(isin,url, info_dict)
        if status == hdef.OKAY:
            info_dict["url_ariva"] = url
        # end if
    # end if

    (stat, errtext, url) = wp_pr.get_onvista_url_playwright(isin)
    if stat == hdef.OKAY and status == hdef.OKAY:
        info_dict["url_onvista"] = url
    # end if

    if stat == hdef.OKAY and status == hdef.NOT_FOUND:

        print(f"            versuche onvista")
        info_dict = get_default_info_dict(isin)
        (status, errtext, info_dict) = onvista(isin,url, info_dict)
        if status == hdef.OKAY:
            info_dict["url_ariva"] = url
        # end if
    # end if


    return (status, errtext, info_dict)
# end def
def extraetf_ETF(isin, info_dict):
    status = hdef.OKAY
    errtext = ""
    
    url = f"https://extraetf.com/de/etf-profile/{isin}"
    try:
        page = urllib.request.urlopen(url)
    except urllib.error.HTTPError as e:
        status = hdef.NOT_FOUND
        errtext = f"extraetf_ETF isin: {isin} Error code: {e.code}"
    except urllib.error.URLError as e:
        status = hdef.NOT_FOUND
        errtext = f"extraetf_ETF isin: {isin} Reason: {e.reason}"
    # end try
    if status != hdef.OKAY:
        return (status, errtext, {})
    # end if
    
    soup = bs(page, 'html.parser')
    
    info_dict["url"] = url
    info_dict["type"] = "etf"
    
    # ----------------------------------------------------------------
    # Name
    # ----------------------------------------------------------------
    item = soup.body.find('div', class_='investment-name')
    item1 = item.find('h1')
    name = str(item1.text.strip())
    
    info_dict["name"] = hstr.elim_ae(name.replace('\xa0', ' '), ' ')
    
    # ----------------------------------------------------------------
    # ISIN, WKN, TICKER
    # ----------------------------------------------------------------
    items = soup.body.find_all('button', class_='btn-product-etf')
    flag_isin = False
    flag_wkn  = False
    for item in items:
        flag_found = False
        word = str(item.get('id'))
        word = word.replace('\xa0', ' ')
        word = hstr.elim_ae(word, " ")
        if not flag_isin:
            (okay,isin) = htype.type_proof_isin(word)
            if okay == hdef.OKAY:
                info_dict["isin"] = isin
                flag_isin = True
                flag_found = True
            # end if
        # end if
        if not flag_found and not flag_wkn:
            (okay, wkn) = htype.type_proof_wkn(word)
            if okay == hdef.OKAY:
                info_dict["wkn"] = wkn
                flag_wkn = True
                flag_found = True
            # end if
        # end if
        if not flag_found:
            info_dict["ticker"] = word
        # end if
    # end for
    # ---------------------------------------------------------------------
    # Indexabbildung, Ertragsverwendung, TER, Fondsgröße, Anzahl Positionen, Anteil Top 10, Währung
    # ---------------------------------------------------------------------
    items = soup.body.find_all('div', class_='top-info-column')
    
    for item in items:
        
        # print(item )
        
        item1 = item.find('span', class_='value')
        item2 = item.find('span', class_='text-muted')
        value = str(item1.text.strip())
        value = value.replace('\xa0', ' ')
        value = hstr.elim_ae(value, " ")
        type = item2.text.strip()
        type = type.replace('\xa0', ' ')
        type = hstr.elim_ae(type, " ")
        
        if type == 'Indexabbildung':
            info_dict["indexabbildung"] = value
        elif type == 'Ertragsverwendung':
            info_dict["ertragsverwendung"] = value
        elif type == 'TER':
            info_dict["ter"] = value
        elif type == 'Fondsgröße':
            info_dict["volumen"] = value
        elif type == 'Anzahl Positionen':
            info_dict["anzahl"] = value
        # end if
    # end for
    
    # -----------------------------------------------------
    # Zahlt Dividendne
    # -----------------------------------------------------
    if "ertragsverwendung" in info_dict.keys():
        if info_dict["ertragsverwendung"] == "Ausschüttend":
            info_dict["zahltdiv"] = 1
        # end if
    # end if
    
    # ---------------------------------------------------------------------
    # Indexabbildung, Ertragsverwendung, TER, Fondsgröße, Anzahl Positionen, Anteil Top 10, Währung
    # ---------------------------------------------------------------------
    items = soup.body.find_all('div', class_='top-info-column')
    
    for item in items:
        
        # print(item )
        
        item1 = item.find('span', class_='value')
        item2 = item.find('span', class_='text-muted')
        value = str(item1.text.strip())
        value = value.replace('\xa0', ' ')
        value = hstr.elim_ae(value, " ")
        type = item2.text.strip()
        type = type.replace('\xa0', ' ')
        type = hstr.elim_ae(type, " ")
        type = type.replace('-', '')
        
        if type == 'Indexabbildung':
            info_dict["indexabbildung"] = value
        elif type == 'Ertragsverwendung':
            info_dict["ertragsverwendung"] = value
        elif type == 'TER':
            info_dict["ter"] = value
        elif type == 'Fondsgröße':
            info_dict["volumen"] = value
        elif type == 'Anzahl Positionen':
            info_dict["anzahl"] = value
        elif type == 'KGV':
            info_dict["kgv"] = value
        elif type == 'Marktkapitalisierung':
            info_dict["marktkapitalisierung"] = value
        elif type == 'Gewinn':
            info_dict["marktkapitalisierung"] = value
        elif type == 'Dividendenrendite':
            info_dict["dividendenrendite"] = value
        # end if
    # end for
    
    # ------------------------------------------------------------
    # Beschreibung
    # -------------------------------------------------------------
    # items = soup.body.find_all('div', class_='card-body')
    # for item in items:
    #     all_found = re.findall('investiertweltweit ', str(item))
    #     print(all_found)
    info_dict["beschreibung"] = ""
    
    # -----------------------------------------------------
    # Zahlt Dividendne
    # -----------------------------------------------------
    if "dividendenrendite" in info_dict.keys():
        (okay, value) = htype.type_transform(info_dict["dividendenrendite"], "percentStr", "float")
        if okay == hdef.OKAY:
            if value > 0.1:
                info_dict["zahltdiv"] = 1
            # end if
        # end if
    elif "ertragsverwendung" in info_dict.keys():
        if info_dict["ertragsverwendung"] == "Ausschüttend":
            info_dict["zahltdiv"] = 1
        # end if
    # end if
    
    return (status, errtext, info_dict)


# end def
def extraetf_Aktie(isin, info_dict):
    status = hdef.OKAY
    errtext = ""
    
    url = f"https://extraetf.com/de/stock-profile/{isin}"
    try:
        page = urllib.request.urlopen(url)
    except urllib.error.HTTPError as e:
        status = hdef.NOT_FOUND
        errtext = f"extraetf_Aktie isin: {isin} Error code: {e.code}"
    except urllib.error.URLError as e:
        status = hdef.NOT_FOUND
        errtext = f"extraetf_Aktie isin: {isin} Reason: {e.reason}"
    # end try
    if status != hdef.OKAY:
        return (status, errtext, {})
    # end if
    
    soup = bs(page, 'html.parser')
    
    info_dict["url"] = url
    info_dict["type"] = "aktie"
    
    # ----------------------------------------------------------------
    # Name
    # ----------------------------------------------------------------
    item = soup.body.find('div', class_='investment-name')
    item1 = item.find('h1')
    name = item1.text.strip()
    
    info_dict["name"] = name
    
    # ----------------------------------------------------------------
    # ISIN, WKN, TICKER
    # ----------------------------------------------------------------
    items = soup.body.find_all('button', class_='btn-product-etf')
    for item in items:
        word = str(item.get('id'))
        word = word.replace('\xa0', ' ')
        word = hstr.elim_ae(word, " ")
        if len(word) > 6:
            info_dict["isin"] = word
        elif len(word) == 6:
            info_dict["wkn"] = word
        else:
            info_dict["ticker"] = word
    
    # ---------------------------------------------------------------------
    # Indexabbildung, Ertragsverwendung, TER, Fondsgröße, Anzahl Positionen, Anteil Top 10, Währung
    # KGV, Marktkapitalisierung, Dividendenrendite
    # ---------------------------------------------------------------------
    items = soup.body.find_all('div', class_='top-info-column')
    
    for item in items:
        
        # print(item )
        
        item1 = item.find('span', class_='value')
        item2 = item.find('span', class_='text-muted')
        value = str(item1.text.strip())
        value = value.replace('\xa0', ' ')
        value = hstr.elim_ae(value, " ")
        type = item2.text.strip()
        type = type.replace('\xa0', ' ')
        type = hstr.elim_ae(type, " ")
        type = type.replace('-', '')
        
        if type == 'Indexabbildung':
            info_dict["indexabbildung"] = value
        elif type == 'Ertragsverwendung':
            info_dict["ertragsverwendung"] = value
        elif type == 'TER':
            info_dict["ter"] = value
        elif type == 'Fondsgröße':
            info_dict["volumen"] = value
        elif type == 'Anzahl Positionen':
            info_dict["anzahl"] = value
        elif type == 'KGV':
            info_dict["kgv"] = value
        elif type == 'Marktkapitalisierung':
            info_dict["marktkapitalisierung"] = value
        elif type == 'Gewinn':
            info_dict["gewinn"] = value
        elif type == 'Dividendenrendite':
            info_dict["dividendenrendite"] = value
        # end if
    # end for
    
    # ------------------------------------------------------------
    # Beschreibung
    # -------------------------------------------------------------
    info_dict["beschreibung"] = ""
    
    # -----------------------------------------------------
    # Zahlt Dividendne
    # -----------------------------------------------------
    info_dict["zahltdiv"] = 0
    if "dividendenrendite" in info_dict.keys():
        (okay, value) = htype.type_transform(info_dict["dividendenrendite"], "percentStr", "float")
        if okay == hdef.OKAY:
            if value > 0.1:
                info_dict["zahltdiv"] = 1
            # end if
        # end if
    elif "ertragsverwendung" in info_dict.keys():
        if info_dict["ertragsverwendung"] == "Ausschüttend":
            info_dict["zahltdiv"] = 1
        # end if
    # end if
    
    return (status, errtext, info_dict)


# end if

def extraetf_Fond(isin, info_dict):
    status = hdef.OKAY
    errtext = ""
    
    url = f"https://extraetf.com/de/fund-profile/{isin}"
    try:
        page = urllib.request.urlopen(url)
    except urllib.error.HTTPError as e:
        status = hdef.NOT_FOUND
        errtext = f"extraetf_Aktie isin: {isin} Error code: {e.code}"
    except urllib.error.URLError as e:
        status = hdef.NOT_FOUND
        errtext = f"extraetf_Aktie isin: {isin} Reason: {e.reason}"
    # end try
    if status != hdef.OKAY:
        return (status, errtext, {})
    # end if
    
    soup = bs(page, 'html.parser')
    
    info_dict["url"] = url
    info_dict["type"] = "fond"
    
    # ----------------------------------------------------------------
    # Name
    # ----------------------------------------------------------------
    item = soup.body.find('div', class_='investment-name')
    item1 = item.find('h1')
    name = item1.text.strip()
    
    info_dict["name"] = name
    
    # ----------------------------------------------------------------
    # ISIN, WKN, TICKER
    # ----------------------------------------------------------------
    items = soup.body.find_all('button', class_='btn-product-etf')
    for item in items:
        word = str(item.get('id'))
        word = word.replace('\xa0', ' ')
        word = hstr.elim_ae(word, " ")
        if len(word) > 6:
            info_dict["isin"] = word
        elif len(word) == 6:
            info_dict["wkn"] = word
        else:
            info_dict["ticker"] = word
    
    # ---------------------------------------------------------------------
    # Indexabbildung, Ertragsverwendung, TER, Fondsgröße, Anzahl Positionen, Anteil Top 10, Währung
    # KGV, Marktkapitalisierung, Dividendenrendite
    # ---------------------------------------------------------------------
    items = soup.body.find_all('div', class_='top-info-column')
    
    for item in items:
        
        # print(item )
        
        item1 = item.find('span', class_='value')
        item2 = item.find('span', class_='text-muted')
        value = str(item1.text.strip())
        value = value.replace('\xa0', ' ')
        value = hstr.elim_ae(value, " ")
        type = item2.text.strip()
        type = type.replace('\xa0', ' ')
        type = hstr.elim_ae(type, " ")
        type = type.replace('­', '')
        
        if type == 'Indexabbildung':
            info_dict["indexabbildung"] = value
        elif (type == 'Ertragsverwendung'):
            info_dict["ertragsverwendung"] = value
        elif type == 'TER':
            info_dict["ter"] = value
        elif type == 'Fondsgröße':
            info_dict["volumen"] = value
        elif type == 'Anzahl Positionen':
            info_dict["anzahl"] = value
        elif type == 'KGV':
            info_dict["kgv"] = value
        elif type == 'Marktkapitalisierung':
            info_dict["marktkapitalisierung"] = value
        elif type == 'Gewinn':
            info_dict["gewinn"] = value
        elif type == 'Dividendenrendite':
            info_dict["dividendenrendite"] = value
        # end if
    # end for
    
    # ------------------------------------------------------------
    # Beschreibung
    # -------------------------------------------------------------
    info_dict["beschreibung"] = ""
    
    # -----------------------------------------------------
    # Zahlt Dividendne
    # -----------------------------------------------------
    info_dict["zahltdiv"] = 0
    if "dividendenrendite" in info_dict.keys():
        (okay, value) = htype.type_transform(info_dict["dividendenrendite"], "percentStr", "float")
        if okay == hdef.OKAY:
            if value > 0.1:
                info_dict["zahltdiv"] = 1
            # end if
        # end if
    elif "ertragsverwendung" in info_dict.keys():
        if info_dict["ertragsverwendung"] == "Ausschüttend":
            info_dict["zahltdiv"] = 1
        # end if
    # end if
    
    return (status, errtext, info_dict)


# end def

def ariva_anleihe(isin_, url, info_dict):
    status = hdef.OKAY
    errtext = ""

    try:
        newpage = urllib.request.urlopen(url)
    except urllib.error.HTTPError as e:
        status = hdef.NOT_FOUND
        errtext = f"ariva_anleihe isin: {isin_} Error code: {e.code}"
    except urllib.error.URLError as e:
        status = hdef.NOT_FOUND
        errtext = f"ariva_anleihe isin: {isin_} Reason: {e.reason}"
    # end try

    if status != hdef.OKAY:
        return (status, errtext, info_dict)
    # end if
    
    soup = bs(newpage, 'html.parser')

    text = soup.get_text(" ", strip=True)

    liste = soup.get_text(" ", strip=True).split()

    #---------------------------------------------------
    # wkn and type
    #---------------------------------------------------
    wkn = ""
    type = ""
    if( "WKN:" in liste):
        index = liste.index("WKN:")+1
        if index < len(liste):
            wkn = liste[index]
        # end if
        index -= 2
        if (index > 0) and (index < len(liste)):
            type = liste[index]
        # end if
    # end if
    #---------------------------------------------------
    # isin
    #---------------------------------------------------
    if( "ISIN:" in liste):
        index = liste.index("ISIN:")+1
        if index < len(liste):
            isin_proof = liste[index]
        # end if
    # end if
    #---------------------------------------------------
    # ticker
    #---------------------------------------------------
    ticker = ""
    if( "US-Symbol:" in liste):
        index = liste.index("US-Symbol:")+1
        if index < len(liste):
            ticker = liste[index]
        # end if
    # end if

    # name from h1
    h_list = soup.find_all("h1",attrs={"itemprop" : "name"})
    name = h_list[0].get_text(" ", strip=True)

    info_dict["isin"] = isin
    info_dict["wkn"] = wkn
    info_dict["name"] = name
    info_dict["ticker"] = ticker
    info_dict["type"] = type
    info_dict["url"] = url

    return (status, errtext, info_dict)
# end def
def onvista(isin_, url, info_dict):
    status = hdef.OKAY
    errtext = ""

    try:
        newpage = urllib.request.urlopen(url)
    except urllib.error.HTTPError as e:
        status = hdef.NOT_FOUND
        errtext = f"ariva_anleihe isin: {isin_} Error code: {e.code}"
    except urllib.error.URLError as e:
        status = hdef.NOT_FOUND
        errtext = f"ariva_anleihe isin: {isin_} Reason: {e.reason}"
    # end try

    if status != hdef.OKAY:
        return (status, errtext, info_dict)
    # end if

    soup = bs(newpage, 'html.parser')

    info_dict["url"] = url

    # Title
    title = soup.title.text.strip() if soup.title else None

    if title.find(' • ') > -1:
        name = title.split(' • ')[0]
    else:
        name = ""
    # end if
    # -------------------------------------------------
    # Gesamten Text durchsuchen
    # -------------------------------------------------
    text = soup.get_text(" ", strip=True)

    # -------------------------------------------------
    # WKN suchen (meist 6-stellig alphanumerisch)
    # -------------------------------------------------
    wkn_match = re.search(r'WKN[:\s]+([A-Z0-9]{6})', text, re.IGNORECASE)
    wkn = wkn_match.group(1) if wkn_match else ""

    # -------------------------------------------------
    # ISIN suchen
    # -------------------------------------------------
    isin_match = re.search(r'ISIN[:\s]+([A-Z]{2}[A-Z0-9]{10})', text, re.IGNORECASE)
    isin = isin_match.group(1) if isin_match else ""

    index = text.find('Ticker')
    if index > -1:
        ticker = text[index+len('Ticker'):].split()[0]
    else:
        ticker = ""
    # end if

    # -------------------------------------------------
    # Name ermitteln
    # Möglichkeit 1: aus <title>
    # -------------------------------------------------
    liste = url.split('/')[-1].split('-')
    isin_proof = liste[-1]
    if isin_proof == isin:
        type = liste[-2]
    else:
        type = ""
    # end if

    if (len(name) == 0) and (len(liste) > 2):
        for item in liste[0:len(liste)-2]:
            name += item + " "
        # end if
        name = hstr.elim_ae(name,' ')
    # end if

    # name from h1
    h_list = soup.find_all("h1")
    for h in h_list:
        name = h.get_text(" ", strip=True)



    info_dict["isin"] = isin
    info_dict["wkn"] = wkn
    info_dict["name"] = name
    info_dict["ticker"] = ticker
    info_dict["type"] = type

    return (status, errtext, info_dict)


# end def

def get_default_info_dict(isin):
    info_dict = {}
    info_dict["type"] = ""
    info_dict["name"] = ""
    info_dict["beschreibung"] = ""
    info_dict["isin"] = isin
    info_dict["wkn"]  = ""
    info_dict["ticker"] = ""
    info_dict["indexabbildung"] = ""
    info_dict["ertragsverwendung"] = ""
    info_dict["ter"] = ""
    info_dict["volumen"] = ""
    info_dict["anzahl"] = ""
    info_dict["zahltdiv"] = 0
    info_dict["url"] = ""
    info_dict["url_ariva"] = ""
    info_dict["url_onvista"] = ""
    info_dict["kgv"] = ""
    info_dict["marktkapitalisierung"] = ""
    info_dict["marktkapitalisierung"] = ""
    info_dict["dividendenrendite"] = ""
    info_dict["gewinn"] = ""
    info_dict["waehrung"] = "€"
    info_dict["preisabfrage"] = ""
    return info_dict
# end def
if __name__ == '__main__':

    itest = 2
    ichoice = 3

    if ichoice == 1:
        isin = "DE0007030009"
        url_onvista = "https://www.onvista.de/aktien/Rheinmetall-Aktie-DE0007030009"
        url_ariva = "https://www.ariva.de/aktien/rheinmetall-aktie"
    elif ichoice == 2:
        isin = "AU3TB0000192"
        url_onvista = "https://www.onvista.de/anleihen/AUSTRALIA-2037-144-Anleihe-AU3TB0000192"
        url_ariva = "https://www.ariva.de/AU3TB0000192"
    else:
        isin = "IE00B8GKDB10"
        url_onvista = "https://www.onvista.de/etf/Vanguard-FTSE-All-World-High-Dividend-Yield-UCITS-ETF-USD-DIS-ETF-IE00B8GKDB10"
        url_ariva = "https://www.ariva.de/etf/vanguard-ftse-all-world-high-dividend-yield-ucits-etf-usd-di"
    # end if

    if itest == 1:

        info_dict = get_default_info_dict(isin)
        (status, errtext, info_dict) = onvista(isin,url_onvista, info_dict)
        print(info_dict)
    elif itest == 2:

        info_dict = get_default_info_dict(isin)
        (status, errtext, info_dict) = ariva_anleihe(isin,url_ariva, info_dict)
        print(info_dict)
    # end if


    # <h1 itemprop="name" data-cy="instrument-name">
	# 			Vanguard FTSE All-World High Dividend Yield UCITS ETF USD Di
	# 		</h1>