
from bs4 import BeautifulSoup as bs
import urllib.request
import re

import tools.hfkt_def as hdef
import tools.hfkt_str as hstr


def wp_basic_info_fkt(isin,ddict):
    '''
    
    :param isin:
    :param ddict:
    :return: (status, errtext, info_dict) =  wp_basic_info_fkt(isin,ddict)
    '''
    (status, errtext, info_dict) =  wp_basic_info_ETF(isin)

    return (status, errtext, info_dict)
# end def
def wp_basic_info_ETF(isin):
    status = hdef.OKAY
    errtext = ""
    info_dict = {}
    
    
    url = f"https://extraetf.com/de/etf-profile/{isin}"
    try:
        page = urllib.request.urlopen(url)
    except urllib.error.HTTPError as e:
        status = hdef.NOT_OKAY
        errtext = f"wp_basic_info_ETF isin: {isin} Error code: {e.code}"
    except urllib.error.URLError as e:
        status = hdef.NOT_OKAY
        errtext = f"wp_basic_info_ETF isin: {isin} Reason: {e.reason}"
    # end try
    if status != hdef.OKAY:
        return (status,errtext,{})
    # end if

    soup = bs(page, 'lxml')
    
    info_dict["type"] = "etf"
    
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
        word = hstr.elim_ae(str(item.get('id')), " ")
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
        
        value = hstr.elim_ae(item1.text.strip(), " ")
        type = hstr.elim_ae(item2.text.strip(), " ")
        
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
    
    # ------------------------------------------------------------
    # Beschreibung
    # -------------------------------------------------------------
    # items = soup.body.find_all('div', class_='card-body')
    # for item in items:
    #     all_found = re.findall('investiertweltweit ', str(item))
    #     print(all_found)
    
    return (status,errtext,info_dict)

    

