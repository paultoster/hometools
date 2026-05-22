import pandas as pd
import requests
import numpy as np
import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

from tools import hfkt_type as htype
from tools import hfkt_def as hdef

def uri_exists_stream(uri: str) -> bool:
    try:
        with requests.get(uri, stream=True) as response:
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


# base_url = "https://live.deutsche-boerse.com/etf/xtrackers-msci-emu-screened-ucits-etf-1d?currency=EUR"
url = "https://www.finanzen.net/etf/kurse/xtrackers-msci-emu-screened-etf-1d-ie00bdgn9z19"

# response = requests.get(base_url)

if uri_exists_stream(url):

    response = requests.get(url)

    # Alle Tabellen auf der Seite als Liste von DataFrames einlesen
    tabellen = pd.read_html(url)

    # Die erste gefundene Tabelle ausgeben
    df = tabellen[0]
    print(df.head())
    print(df.tail())
    for col in df.columns:
        print(f"{col}")
    print(df.columns)
    print(df[0][0])
    print(df[0][1:])
    print(df[1][0])
    print(df[1][1:])
    print("--------------------------------------------")

    if df[0][0] == "Datum":
        date_list = df[0][1:].tolist()
        dat_np_array = np.array(htype.type_transform_direct(date_list, "datStrP", "dat"), copy=True)

    if df[1][0] == "Erster":
        open_np_array = df[1][1:].to_numpy()
    if df[2][0] == "Hoch":
        high_np_array = df[2][1:].to_numpy()
    if df[3][0] == "Tief":
        low_np_array = df[3][1:].to_numpy()
    if df[4][0] == "Schluss":
        low_np_array = df[4][1:].to_numpy()
    if df[6][0] == "Stücke":
        low_np_array = df[6][1:].to_numpy()
else:
    print(f"URL = {url} geht nicht")
