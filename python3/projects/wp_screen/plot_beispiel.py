
# https://plainenglish.io/python/plot-stock-chart-using-mplfinance-in-python-9286fc69689

import matplotlib.pyplot as plt
import mplfinance as mpf
import pandas as pd
import numpy as np

#import datetime as dt
#import yfinance as yf

# start = dt.datetime(2019,1,1)
# end   = dt.datetime.now()
# data = yf.download('TSLA', start, end)
# print(data)
# print(mpf.available_styles())
# colors = mpf.make_marketcolors(up="#00ff00",
#                                 down="#ff0000",
#                                 wick="inherit",
#                                 edge="inherit",
#                                 volume="in")
# mpf_style = mpf.make_mpf_style(base_mpf_style='yahoo', marketcolors=colors)
# mpf.plot(data, type="candle", style=mpf_style, volume=True)

"""
# 1. Beispieldaten als NumPy-Arrays erstellen (Open, High, Low, Close)
dates = pd.date_range(start='2026-07-01', periods=5, freq='B')
opens  = np.array([100.5, 102.0, 101.5, 104.0, 103.5])
highs  = np.array([103.0, 103.5, 103.0, 105.5, 104.5])
lows   = np.array([ 99.0, 101.0, 100.0, 103.0, 102.0])
closes = np.array([102.0, 101.8, 103.5, 103.8, 104.0])

# 2. Zusammenführen in ein strukturiertes NumPy-Array und in einen Pandas DataFrame
# (mplfinance benötigt zur korrekten Datumsausrichtung ein DataFrame-Format)
ohlc_array = np.column_stack([opens, highs, lows, closes])
df = pd.DataFrame(ohlc_array, index=dates, columns=['Open', 'High', 'Low', 'Close'])

# 3. Den Candlestick-Plot mit mplfinance erstellen
mpf.plot(
    df,
    type='candle',
    style='yahoo',
    title='Candlestick Chart mit NumPy-Daten',
    ylabel='Preis ($)',
    volume=False
)
"""
"""
# 1. Beispieldaten als NumPy-Arrays erstellen
# Format: [Open, High, Low, Close, Volume]
dates = pd.date_range(start='2026-07-01', periods=5, freq='B') # Werktage
numpy_data = np.array([
    [150.0, 155.0, 149.0, 154.0, 100000],
    [154.0, 158.0, 153.0, 155.0, 125000],
    [155.0, 156.0, 151.0, 152.0, 95000],
    [152.0, 157.0, 151.0, 156.0, 110000],
    [156.0, 160.0, 155.0, 159.0, 140000]
])

# 2. Daten in ein strukturiertes Pandas DataFrame überführen
# mplfinance benötigt zur perfekten Achsenbeschriftung einen Pandas DataFrame/DatetimeIndex
df = pd.DataFrame(
    numpy_data,
    columns=['Open', 'High', 'Low', 'Close', 'Volume'],
    index=dates
)

# 3. Plot erstellen inkl. Volumen-Anzeige
mpf.plot(
    df,
    type='candle',
    volume=True,
    style='yahoo',
    title='Aktienkurs & Volumen (Candlestick)'
)
"""
# 1. Beispieldaten: Numpy Arrays erstellen
# 5 Tage: Datum (Unix-Zeit), Open, High, Low, Close, Volume
dates = np.array([1768435200, 1768521600, 1768608000, 1768694400, 1768780800])
openp = np.array([100.0, 102.0, 101.0, 104.0, 103.0])
highp = np.array([105.0, 103.5, 105.5, 106.0, 107.0])
lowp = np.array([99.0, 101.0, 100.0, 103.0, 102.0])
closep = np.array([102.0, 101.5, 104.0, 103.5, 106.5])
volumes = np.array([1500, 1200, 2500, 1800, 3000])

# 2. Daten in ein strukturiertes Pandas DataFrame umwandeln
df = pd.DataFrame({
    'Date': pd.to_datetime(dates, unit='s'),
    'Open': openp,
    'High': highp,
    'Low': lowp,
    'Close': closep,
    'Volume': volumes
})
df.set_index('Date', inplace=True)

# 3. Weitere Linien vorbereiten (z. B. ein benutzerdefinierter gleitender Durchschnitt)
df['Moving_Average'] = df['Close'].rolling(window=2).mean()

# 4. Definition weiterer Plots mit 'make_addplot'
# Wir fügen den Moving Average als Linie hinzu
add_lines = mpf.make_addplot(df['Moving_Average'], color='blue', width=1.5)

# 5. Candlestick-Chart mit Volume und Zusatzlinie zeichnen
mpf.plot(
    df,
    type='candle',
    volume=True,           # Zeigt das Handelsvolumen unter dem Chart an
    addplot=add_lines,     # Fügt die weiteren Linien hinzu
    style='yahoo',         # Klassischer Finanz-Look
    title='Candlestick mit Volume & Zusätzlicher Linie'
)

"""
siehe auch https://github.com/matplotlib/mplfinance/blob/master/examples/addplot.ipynb
"""
