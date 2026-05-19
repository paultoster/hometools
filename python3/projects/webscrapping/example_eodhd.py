import requests
import pandas as pd
import numpy as np
import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

from tools import hfkt_type as htype
from tools import hfkt_def as hdef




key_string = "6a0b46ce9ed880.96243511"
query_string = "DE0007236101"
symbol = None
exchange = None
currency = None
url = f'https://eodhd.com/api/search/{query_string}?api_token={key_string}&fmt=json'
data = requests.get(url)
if data.ok:
    d_list = data.json()
    for d in d_list:
        print(d)
        key = "Exchange"
        if key in d.keys() and d[key] == "XETRA":

            symbol   = d['Code']
            exchange = d[key]
            currency  = d['Currency']
            break

    if symbol is not None:
        url = f'https://eodhd.com/api/eod/{symbol}.{exchange}?api_token={key_string}&fmt=json'
        data = requests.get(url)
        if data.ok:
            d = data.json()
            df =pd.DataFrame(d)

            print(df.head())
            print(df.tail())
            print(f" Symbol: {symbol}, Exchange: {exchange}, Currency: {currency}")

            date_list = df['date'].tolist()
            dat_np_array = np.array(htype.type_transform_direct(date_list, "datStrBInv", "dat"), copy=True)

            open_np_array = df["open"].to_numpy()
            open_np_array = df["open"].to_numpy()

    else:
        print("Symbol not found")