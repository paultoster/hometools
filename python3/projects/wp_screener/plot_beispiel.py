
# https://plainenglish.io/python/plot-stock-chart-using-mplfinance-in-python-9286fc69689

import matplotlib.pyplot as plt
import yfinance as yf
import mplfinance as mpf
import datetime as dt
start = dt.datetime(2019,1,1)
end   = dt.datetime.now()
data = yf.download('TSLA', start, end)
print(data)
print(mpf.available_styles())
colors = mpf.make_marketcolors(up="#00ff00",
                                down="#ff0000",
                                wick="inherit",
                                edge="inherit",
                                volume="in")
mpf_style = mpf.make_mpf_style(base_mpf_style='yahoo', marketcolors=colors)
mpf.plot(data, type="candle", style=mpf_style, volume=True)