import requests
import pandas as pd
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


    else:
        print("Symbol not found")