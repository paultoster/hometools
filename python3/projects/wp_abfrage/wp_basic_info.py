from bs4 import BeautifulSoup as bs
import urllib.request
import os


import tools.hfkt_def as hdef
import tools.hfkt_str as hstr
import tools.hfkt_type as htype
import time

if os.path.isfile('wp_base.py'):
    import wp_storage as wp_storage
    import wp_playright as wp_pr
    import wp_isin as wp_isin
else:
    import wp_abfrage.wp_storage as wp_storage
    import wp_abfrage.wp_playright as wp_pr
    import wp_abfrage.wp_isin as wp_isin
# end if


def get_basic_info(isin):
    '''
    
    :param isin:
    :return: (status, errtext, info_dict) = wp_basic_info.get_basic_info(isin)
    '''

    print(f"            versuche extraetf_ETF")
    info_dict = get_default_info_dict(isin)
    (status, errtext, info_dict) = extraetf_ETF(isin, info_dict)
    if status == hdef.NOT_FOUND:
        print(f"            versuche extraetf_Aktie")
        info_dict = get_default_info_dict(isin)
        (status, errtext, info_dict) = extraetf_Aktie(isin, info_dict)
    if status == hdef.NOT_FOUND:
        print(f"            versuche extraetf_Fond")
        info_dict = get_default_info_dict(isin)
        (status, errtext, info_dict) = extraetf_Fond(isin, info_dict)
    if status == hdef.NOT_FOUND:
        print(f"            versuche ariva_Anleihe")
        info_dict = get_default_info_dict(isin)
        (status, errtext, info_dict) = ariva_Anleihe(isin, info_dict)

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
    ######
    info_dict["zahltdiv"] = 0
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

def ariva_Anleihe(isin, info_dict):
    status = hdef.OKAY
    errtext = ""
    
    (status, errtext, url) = wp_pr.get_ariva_url_playwright(isin)
    
    if status != hdef.OKAY:
        return (status, errtext, info_dict)
    # end if
    
    try:
        newpage = urllib.request.urlopen(url)
    except urllib.error.HTTPError as e:
        status = hdef.NOT_FOUND
        errtext = f"ariva_Anleihe isin: {isin} Error code: {e.code}"
    except urllib.error.URLError as e:
        status = hdef.NOT_FOUND
        errtext = f"ariva_Anleihe isin: {isin} Reason: {e.reason}"
    # end try
    if status != hdef.OKAY:
        return (status, errtext, info_dict)
    # end if
    
    soup = bs(newpage, 'html.parser')
    
    info_dict["url"] = url
    info_dict["type"] = "anleihe"
    
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
    info_dict["name"] = name
    
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
            info_dict["type"] = type_text
        if len(wkn_text):
            info_dict["wkn"] = wkn_text
        if len(isin_text):
            info_dict["isin"] = isin_text
    # end for
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
    info_dict["indexabbildung"] = ""
    info_dict["ertragsverwendung"] = ""
    info_dict["ter"] = ""
    info_dict["volumen"] = ""
    info_dict["anzahl"] = ""
    info_dict["kgv"] = ""
    info_dict["marktkapitalisierung"] = ""
    info_dict["marktkapitalisierung"] = ""
    info_dict["dividendenrendite"] = ""
    info_dict["gewinn"] = ""
    return info_dict
# end def

