#
# von https://www.youtube.com/watch?v=VjK-dA6Nf_8
# "Monatliche Übersicht einer Aktienperformance mit Python und yfinance erstellen"
#

# Python Yahoo Finance Stock Analysis | RoboticView.com
# https://roboticview.com/resource/python-yahoo-finance-stock-analysis/?utm_source=youtube_live&utm_medium=youtube_live&utm_campaign=youtube_live

import yfinance as yf
import yahoo_fin.stock_info as si
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from datetime import datetime


stock = "AAPL"



aapl = yf.Ticker(stock)


a = aapl.fast_info['lastPrice']

print(f"lastPrice={a}")

print(aapl.get_financials())

#print(dir(aapl))