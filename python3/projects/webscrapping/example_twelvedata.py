
import requests
import os, sys
import get_keys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

import get_keys

from tools import hfkt_pickle as hpick
from tools import hfkt_def as hdef


def get_twelvedata(liste):
    filename = liste[0]
    url      = liste[1]

    handle = hpick.DataJson(filename)

    if handle.exist_file():
        handle.read()
        if handle.status == hdef.OKAY:
            ddict = handle.get_data()
            print(f"read file: {filename}")
        else:
            print(f"Fehler: {handle.errtext}")
            exit(200)
        # end if
    else:
        print(f"make request: {url}")
        ddict = requests.get(url).json()
        handle.save(ddict)
    # end if
    return ddict
# end def

key_dict = get_keys.get_keys()

stocks_liste = ["TwelveDataStocks.json",
                f'https://api.twelvedata.com/stocks?apikey={key_dict["twelvedata"]}']
ETF_liste = ["TwelveDataETF.json",
                f'https://api.twelvedata.com/etfs?apikey={key_dict["twelvedata"]}']



symbol = "SPYW"
aapl_liste = [f"TwelveData_{symbol}.json",
                f'https://api.twelvedata.com/time_series?apikey={key_dict["twelvedata"]}&symbol={symbol}&interval=1day&start_date=2000-01-01 13:12:00&end_date=2026-05-21 13:13:00&format=JSON']


ddict_stocks = get_twelvedata(stocks_liste)
ddict_ETF = get_twelvedata(ETF_liste)
ddict_aapl = get_twelvedata(aapl_liste)

if ddict_aapl["status"] != "ok":
    print(f"Fehler: \ncode = {ddict_aapl['code']}\nmessage = {ddict_aapl['message']}\nstatus = {ddict_aapl['status']}")
else:
    print(ddict_aapl["meta"])
    print(ddict_aapl["status"])

