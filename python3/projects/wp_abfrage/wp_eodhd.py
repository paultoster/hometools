import requests
import json
import pandas as pd
import numpy as np
import datetime
import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

from tools import hfkt_type as htype
from tools import hfkt_def as hdef
from tools import hfkt_np_fkt as hnp_fkt

def is_info_available(isin,eodhd_key):
    """
        (flag_avail,symbol,exchange,currency,infotext) =  wp_eodhd.is_info_available(isin,eodhd_key)
    """

    symbol = None
    exchange = None
    currency = None
    flag_avail = False
    infotext = ""
    url = f'https://eodhd.com/api/search/{isin}?api_token={eodhd_key}&fmt=json'


    try:
        data = requests.get(url)
        if data.status_code != 200:
            infotext = f"data.status_code nicht == 200: data.status_code = {data.status_code}"
            return (flag_avail, symbol, exchange, currency, infotext)
        # end if
        d_list = data.json()
    except requests.exceptions.JSONDecodeError as e:
        infotext = f" data was not okay json-Error:\n{str(e)}"
        return (flag_avail,symbol,exchange,currency,infotext)
    # end except

    if data.ok and (len(d_list) > 0):

        (d,exchange_liste) = get_best_exchange(d_list)
        infotext = f"Exchange_list: {isin = }: {exchange_liste}"


        symbol   = d['Code']
        exchange = d['Exchange']
        cur      = d['Currency'].lower()

        if cur.lower().find("eur") == 0:
            currency = "euro"
        elif cur.lower().find("usd") == 0:
            currency = "usd"
        else:
            currency = cur.lower()
        # end if
        flag_avail = True
    # end if


    return (flag_avail,symbol,exchange,currency,infotext)
# end def
def get_best_exchange(d_list):

    key = "Exchange"
    exchange_liste = [d[key] for d in d_list]

    key_exchange_list = ["XETRA","F","US","EUFUND","LSE"]
    for key_exchange in key_exchange_list:
        if key_exchange in exchange_liste:
            i = exchange_liste.index(key_exchange)
            return (d_list[i],exchange_liste)
        # end if
    # end for

    return (d_list[0],exchange_liste)
# end def
def get_price_volume_data(symbol,exchange,currency,eodhd_key,strat_dat,end_dat,np_obj):
    """
    (status, errtext, np_obj) = get_price_volume_data(symbol,exchange,currency,eodhd_key,np_classdef)
    """
    status = hdef.OKAY
    errtext = ""
    infotext = ""


    start_dat_strBInv = htype.type_transform_direct(strat_dat, "dat","datStrBInv")
    end_dat_strBInv = htype.type_transform_direct(end_dat, "dat","datStrBInv")

    url = f'https://eodhd.com/api/eod/{symbol}.{exchange}?api_token={eodhd_key}&from={start_dat_strBInv}&to={end_dat_strBInv}&fmt=json'
    # print(f"url = {url}")
    data = requests.get(url)

    if data.ok:

        d = data.json()
        df = pd.DataFrame(d)

        # print(df.head())
        # print(df.tail())

        date_list = df['date'].tolist()
        dat_str_list = htype.type_transform_direct(date_list, "datStrBInv", "datStr")
        date_time_list = [datetime.datetime.strptime(d, "%d.%m.%Y")
                          for d in dat_str_list]
        dat_np_array = hnp_fkt.transform_date_time_liste_in_np_dat_array_d(date_time_list)

        open_np_array = df["open"].to_numpy()
        high_np_array = df["high"].to_numpy()
        low_np_array = df["low"].to_numpy()
        close_np_array = df["adjusted_close"].to_numpy()
        volume_np_array = df["volume"].to_numpy()

        dat_np_array = dat_np_array.reshape(np.prod(dat_np_array.shape))
        open_np_array = open_np_array.reshape(np.prod(open_np_array.shape))
        high_np_array = high_np_array.reshape(np.prod(high_np_array.shape))
        low_np_array = low_np_array.reshape(np.prod(low_np_array.shape))
        close_np_array = close_np_array.reshape(np.prod(close_np_array.shape))
        volume_np_array = volume_np_array.reshape(np.prod(volume_np_array.shape))

        np_obj.put_signal(dat_np_array,
                          open_np_array,
                          high_np_array,
                          low_np_array,
                          close_np_array,
                          volume_np_array)

        np_obj.set_currency(currency)

        np_obj.sort_by_dat()
    else:
        infotext = f"for Symbol \"{symbol}\" and Exchange \"{exchange}\" no data from eodhd"
        return (status, errtext, infotext, np_obj)
    # end if

    return (status, errtext,infotext, np_obj)
# end def
