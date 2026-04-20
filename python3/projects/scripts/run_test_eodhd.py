import requests
from eodhd import APIClient
import pandas as pd

API_Key = "69e3d9f83b73f5.09415097"
query_string = "AAPL"
query_string = "DE0005318406"
url = f'https://eodhd.com/api/search/{query_string}?api_token={API_Key}&fmt=json'
data = requests.get(url).json()
symb = data[0]["Code"]+"."+data[0]["Exchange"]
print(data)
print(symb)

api = APIClient(API_Key)

resp = api.get_eod_historical_stock_market_data(symbol = symb, period='d', from_date = '2025-04-22', to_date = '2026-04-16', order='a')

df = pd.DataFrame(resp)
print(df)