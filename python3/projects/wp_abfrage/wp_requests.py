import pandas as pd
import requests
import numpy as np
import os, sys, re

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

from tools import hfkt_type as htype
from tools import hfkt_def as hdef

def requests_exists(url: str) -> bool:
    try:
        with requests.get(url, stream=True) as response:
            try:
                response.raise_for_status()
                # return True
            except requests.exceptions.HTTPError:
                return False
    except requests.exceptions.ConnectionError:
        return False
    except requests.exceptions.Timeout as e:
        return False
    except requests.exceptions.RequestException as e:
        return False
    else:
        return True
    # end if
# end def
def get_price_volume_data(url,np_classdef):
    """
    (status, errtext, np_obj) = get_price_volume_data(url,np_classdef,start_dat,end_dat)
    """
    status = hdef.OKAY
    errtext = ""
    infotext = ""
    np_obj = np_classdef()

    # Alle Tabellen auf der Seite als Liste von DataFrames einlesen
    tabellen = pd.read_html(url)

    # Suche die passende Tabelle
    index_dat = -1
    index_open = -1
    index_high = -1
    index_low = -1
    index_close = -1
    index_vol = -1
    foundflag = False
    index_tab = -1
    for index,tab in enumerate(tabellen):
        index_dat = -1
        index_open = -1
        index_high = -1
        index_low = -1
        index_close = -1
        index_vol = -1
        icountfound = 0
        for col in tab.columns:

            if (tab[col][0] == "Datum") or (tab[col][0] == "Date"):
                index_dat = col
                icountfound += 1
            elif (tab[col][0] == "Open") or (tab[col][0] == "Erster"):
                index_open = col
                icountfound += 1
            elif (tab[col][0] == "High") or (tab[col][0] == "Hoch"):
                index_high = col
                icountfound += 1
            elif (tab[col][0] == "Low") or (tab[col][0] == "Tief"):
                index_low = col
                icountfound += 1
            elif (tab[col][0] == "Close") or (tab[col][0] == "Schluss"):
                index_close = col
                icountfound += 1
            elif (tab[col][0] == "Volume") or (tab[col][0] == "Vol. (nom.)") or (tab[col][0] == "Stücke"):
                index_vol = col
                icountfound += 1
            # end if
        # end for
        if icountfound == 6:
            foundflag = True
            index_tab = index
            break
    # end for

    if not(foundflag):
        infotext = f"for url \"{url}\" no data from ariva (icountfound = {icountfound} != 6)\n{tabellen}"
        return (status, errtext, infotext, np_obj)
    # end if
    df = tabellen[index_tab]
    date_list = df[index_dat][1:].tolist()
    dat_np_array = np.array(htype.type_transform_direct(date_list, "datStrP", "dat"), copy=True)

    open_np_array = np.array(wandel_char_liste(df[index_open][1:].to_list()))
    high_np_array =  np.array(wandel_char_liste(df[index_high][1:].to_list()))
    low_np_array =  np.array(wandel_char_liste(df[index_low][1:].to_list()))
    close_np_array =  np.array(wandel_char_liste(df[index_close][1:].to_list()))
    volume_np_array =  np.array(wandel_char_liste(df[index_vol][1:].to_list()))

    dat_np_array   = dat_np_array.reshape(np.prod(dat_np_array.shape))
    open_np_array   = open_np_array.reshape(np.prod(open_np_array.shape))
    high_np_array   = high_np_array.reshape(np.prod(high_np_array.shape))
    low_np_array   = low_np_array.reshape(np.prod(low_np_array.shape))
    close_np_array   = close_np_array.reshape(np.prod(close_np_array.shape))
    volume_np_array   = volume_np_array.reshape(np.prod(volume_np_array.shape))

    np_obj.from_np_array_list([dat_np_array,
                               open_np_array,
                               high_np_array,
                               low_np_array,
                               close_np_array,
                               volume_np_array])

    # currency
    np_obj.currency = "euro"

    np_obj.sort_by_dat()

    return (status, errtext,infotext, np_obj)
# end def
def wandel_char_liste(liste):


    liste1 = [x.replace("€","").replace("%","").replace(" ","") for x in liste]
    liste2 = [wandel_mit_re(x) for x in liste1]
    liste3 = [htype.type_transform_direct(x, "euroStrK", "euro") for x in liste2]

    return liste3
# end def
def wandel_mit_re(value_in):
    match = re.search(r'[\d.]+(?:,\d+)?', value_in)

    if match:
        value_out = match.group()
    else:
        value_out = value_in
    # end if
    return value_out
# end def