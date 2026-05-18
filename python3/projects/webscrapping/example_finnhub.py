import finnhub
import datetime as dt
import pandas as pd


isin = "IE00BDGN9Z19"
api_key= 'd144k8hr01qrqeas1ph0d144k8hr01qrqeas1phg'
fticker = ''
resolution = 'D'
end_date = dt.datetime.now()
start_date = end_date - dt.timedelta(days=365)
end = int(end_date.timestamp())
start = int(start_date.timestamp())


finnhub_client = finnhub.Client(api_key=api_key)

res = finnhub_client.stock_candles('AAPL', 'D', 1590988249, 1591852249)

d = finnhub_client.symbol_lookup(isin)

if d["count"] > 0:

    fticker = d["result"][0]["symbol"]

    flag = False
    try:
        result = finnhub_client.stock_candles(fticker, resolution, start, end)
        flag = True
    except finnhub.FinnhubAPIException:

        print(finnhub.FinnhubAPIException)




        df = pd.DataFrame(result)

        print(df.head())