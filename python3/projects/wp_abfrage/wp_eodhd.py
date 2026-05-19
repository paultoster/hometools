import requests
import json
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
    data = requests.get(url)
    d_list = data.json()
    if data.ok and (len(d_list) > 0):

        for d in d_list:

            key = "Exchange"
            if key in d.keys() and ((d[key] == "XETRA") or (d[key] == "EUFUND")):

                symbol   = d['Code']
                exchange = d[key]
                cur      = d['Currency'].lower()

                if cur.find("EUR") == 0:
                    currency = "euro"
                elif cur.find("USD") == 0:
                    currency = "usd"
                else:
                    currency = cur.lower()
                # end if

                flag_avail = True
                break
            # end if
        # end for
        if not flag_avail:
            infotext = f" Xetra was not found see dump:\n{json.dumps(d_list, indent=2)}"
        # end if
    # end if


    return (flag_avail,symbol,exchange,currency,infotext)
# end def
def get_price_volume_data(symbol,exchange,currency,eodhd_key,np_classdef):
    """
    (status, errtext, np_obj) = get_price_volume_data(symbol,exchange,currency,eodhd_key,np_classdef)
    """
    status = hdef.OKAY
    errtext = ""
    infotext = ""
    np_obj = np_classdef()

    url = f'https://eodhd.com/api/eod/{symbol}.{exchange}?api_token={eodhd_key}&fmt=json'
    data = requests.get(url)

    if data.ok:

        d = data.json()
        df = pd.DataFrame(d)

        date_list = df['date'].tolist()
        dat_np_array = np.array(htype.type_transform_direct(date_list, "datStrBInv", "dat"), copy=True)
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

        np_obj.from_np_array_list([dat_np_array,
                                   open_np_array,
                                   high_np_array,
                                   low_np_array,
                                   close_np_array,
                                   volume_np_array])

        np_obj.currency = currency

    else:
        infotext = f"for Symbol \"{symbol}\" and Exchange \"{exchange}\" no data from eodhd"
        return (status, errtext, infotext, np_obj)
    # end if

    return (status, errtext,infotext, np_obj)
# end def
