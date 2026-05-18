import pandas as pd
import requests

url = "https://www.ariva.de/etf/spdr-s-p-euro-dividend-aristocrats-ucits-etf/kurse/historische-kurse"
url = "https://www.ariva.de/etf/spdr-s-p-euro-dividend-aristocrats-ucits-etf/kurse/historische-kurse?currency=EUR"

# Webseite abrufen
response = requests.get(url)

# Alle Tabellen auf der Seite als Liste von DataFrames einlesen
tabellen = pd.read_html(url)

# Die erste gefundene Tabelle ausgeben
df = tabellen[0]
print(df.head())
print(df.tail())
print(df.columns)
print(df[0][0])
print(df[0][1:])
print(df[1][0])
print(df[1][1:])
print("--------------------------------------------")



