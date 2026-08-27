import yfinance as yf
# import pandas as pd
import datetime
import numpy as np
import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

from tools import hfkt_type as htype
from tools import hfkt_def as hdef
import tools.hfkt_np_fkt as hnp_fkt

if os.path.isfile('wp_fkt.py'):
    import wp_fkt
else:
    import wp_abfrage.wp_fkt as wp_fkt
# end if

currencyvalueheaderlist = ["Close", "High", "Low", "Open"]


def search_ticker_from_isin(isin):
    """
    (ticker,boerse,sektor,type) = search_ticker_from_isin(isin)
    """

    ticker = ""
    boerse = ""
    sektor = ""
    type   = ""

    search_results = yf.Search(isin).all
    if "quotes" not in search_results.keys():
        print(f" Für isin = {isin} gibt es keine quotes!!")
        dicct = {}
    else:
        if len(search_results["quotes"]):
            ddict = search_results["quotes"][0]
        else:
            ddict = {}
        # end if
    # end if

    key = "isYahooFinance"
    if key in ddict.keys():
        isvalid = ddict[key]
    else:
        isvalid = False
    # end if

    if isvalid:
        key = "symbol"
        if key in ddict.keys():
            ticker = ddict[key]
        key = "exchDisp"
        if key in ddict.keys():
            boerse = ddict[key]
        key = "sector"
        if key in ddict.keys():
            sektor = ddict[key]
        key = "typeDisp"
        if key in ddict.keys():
            if ddict[key] == "equity":
                type = "aktie"
            elif ddict[key] == "etf":
                type = "etf"
            elif (ddict[key] == "fond") or (ddict[key] == "mutualfond"):
                type = "fond"
            else:
                type = ddict[key]
                print(f"type = {type} ------------------------------------------------")
            # end if
        # end if
    # end if

    return (ticker,boerse,sektor,type)

def is_Ticker_info_available(ticker):
    """
    Checks if ticker is available via the Yahoo Finance API.
    """
    t = str(ticker)
    if len(t) == 0:
        return False
    # end if

    tinfo = yf.Ticker(t)

    if ('regularMarketPrice' in  tinfo.info) and (tinfo.info['regularMarketPrice'] != None):
        return True
    else:
        return False
    # end if
# end def
def get_price_volume_data(ticker,np_obj,start_dat,end_dat):
    """
    (status, errtext, np_obj) = get_price_volume_data(ticker,np_obj,start_dat,end_dat)
    """
    status = hdef.OKAY
    errtext = ""
    infotext = ""

    # sub einen Tag
    start_dat_minus = start_dat - 24*60*60
    # add einen Tag
    end_dat_pluse = end_dat + 24*60*60

    # Start time
    (status, start_dat_time_class) = htype.type_transform(start_dat_minus, "dat", "datetimeclass")
    if status != hdef.OKAY:
        raise Exception(f"type transform missglückt von {start_dat_minus = } von \"dat\" zu \"dat\" ")
    # end if
    # End time
    (status, end_dat_time_class) = htype.type_transform(end_dat_pluse, "dat", "datetimeclass")
    if status != hdef.OKAY:
        raise Exception(f"type transform missglückt von {end_dat_pluse = } von \"dat\" zu \"dat\" ")
    # end if

    info = yf.Ticker(ticker)

    # hist_data = info.history(period="max")
    #
    # # date_list = hist_data.index.tolist()
    #
    # earliest_date = hist_data.index.min()
    #
    # dat_np_array = np.array(htype.type_transform_direct(date_str_list, "datStrP", "dat"), copy=True)
    # open_np_array = hist_data["Open"].to_numpy()
    # high_np_array = hist_data["High"].to_numpy()
    # low_np_array = hist_data["Low"].to_numpy()
    # close_np_array = hist_data["Close"].to_numpy()
    # volume_np_array = hist_data["Volume"].to_numpy()
    #
    # df_data = yf.download(ticker, start_dat_time_class.strftime('%Y-%m-%d'), end_dat_time_class.strftime('%Y-%m-%d'))

    df_data = yf.download(ticker, period = "max", interval = "1d")

    if df_data.empty:
        df_data = yf.download(ticker,
                              start_dat_time_class.strftime('%Y-%m-%d'),
                              end_dat_time_class.strftime('%Y-%m-%d'))
    # end if
    if df_data.empty:
        periods = ["5d","1d"]
        for p in periods:
            df_data = yf.download(ticker,period = p, interval = "1d")
            if not df_data.empty:
                break
            # end if
        # end for
    # end if

    if df_data.empty:
        infotext = f"for Ticker-Symbol \"{ticker}\" no data from yahoofinance"
        return (status, errtext, infotext, np_obj)
    # end if

    date_str_list = df_data.index.strftime("%d.%m.%Y").tolist()
    # dat_np_array = np.array(htype.type_transform_direct(date_str_list, "datStrP", "dat"), copy=True)

    date_time_list = [datetime.datetime.strptime(htype.type_transform_direct(d,"datStrP", "datStr"), "%d.%m.%Y") for d in date_str_list]
    dat_np_array = hnp_fkt.transform_date_time_liste_in_np_dat_array_d(date_time_list)


    open_np_array = df_data["Open"].to_numpy()
    high_np_array = df_data["High"].to_numpy()
    low_np_array = df_data["Low"].to_numpy()
    close_np_array = df_data["Close"].to_numpy()
    volume_np_array = df_data["Volume"].to_numpy()

    range = 24 * 60 * 60
    (start_index, end_index, _, _) = wp_fkt.find_index_range(list(dat_np_array),
                                                             start_dat,
                                                             end_dat,
                                                             range)
    if (start_index is None) or (end_index is None):
        infotext = f"for Ticker-Symbol \"{ticker}\" no data from yahoofinance start_index = None or/and end_index = None "
        return (status, errtext, infotext, np_obj)
    # end if

    dat_np_array = dat_np_array[start_index: end_index + 1]
    open_np_array = open_np_array[start_index: end_index + 1]
    high_np_array = high_np_array[start_index: end_index + 1]
    low_np_array = low_np_array[start_index: end_index + 1]
    close_np_array = close_np_array[start_index: end_index + 1]
    volume_np_array = volume_np_array[start_index: end_index + 1]

    dat_np_array   = dat_np_array.reshape(np.prod(dat_np_array.shape))
    open_np_array   = open_np_array.reshape(np.prod(open_np_array.shape))
    high_np_array   = high_np_array.reshape(np.prod(high_np_array.shape))
    low_np_array   = low_np_array.reshape(np.prod(low_np_array.shape))
    close_np_array   = close_np_array.reshape(np.prod(close_np_array.shape))
    volume_np_array   = volume_np_array.reshape(np.prod(volume_np_array.shape))

    np_obj.put_signal(dat_np_array,
                               open_np_array,
                               high_np_array,
                               low_np_array,
                               close_np_array,
                               volume_np_array)

    # currency
    if "currency" in info.history_metadata.keys():
        currency = info.history_metadata["currency"]
        np_obj.set_currency(currency)
    # end def

    np_obj.sort_by_dat()

    return (status, errtext,infotext, np_obj)
# end def
def get_indice_data(wb_obj,np_obj,start_dat, end_dat, indice):
    """
    (status, errtext, np_obj) = wp_yfinance.get_usdeuro_data(np_obj,lastdat,end_dat)
    """
    status = hdef.OKAY
    errtext = ""

    # Start time
    start_dat_time_class = htype.type_transform_direct(start_dat,"dat","datetimeclass")
    # End time
    # add one day because yfinace need
    end_dat_add = end_dat + 24 * 60 * 60

    end_dat_time_class   = htype.type_transform_direct(end_dat_add,"dat","datetimeclass")

    if indice == wb_obj.par.INDICES_USDEURO_NAME:
        t = 'USDEUR=X'
    elif indice == wb_obj.par.INDICES_CHFEURO_NAME:
            t = 'CHFEUR=X'
    elif indice == wb_obj.par.INDICES_GBPEURO_NAME:
            t = 'GBPEUR=X'
    else:
        raise Exception(f"invalid indice: {indice}")
    # end if

    df_data_eurodol = yf.download(t, start_dat_time_class.strftime('%Y-%m-%d'), end_dat_time_class.strftime('%Y-%m-%d'))

    if df_data_eurodol.empty:
        status = hdef.NOT_OKAY
        errtext = f"For Euro-Calc Ticker-Symbol \"{t}\" no data from yahoofinance"
        return (status, errtext, None)
    # end if

    date_time_list = df_data_eurodol.index.strftime("%d.%m.%Y").tolist()
    date_time_list = [datetime.datetime.strptime(d, "%d.%m.%Y") for d in date_time_list]
    euro_dat_np_array = hnp_fkt.transform_date_time_liste_in_np_dat_array_d(date_time_list)
    euro_close_np_array = df_data_eurodol["Close"].to_numpy()

    print(euro_dat_np_array.astype('datetime64[s]'))
    print(euro_close_np_array)

    euro_dat_np_array   = euro_dat_np_array.reshape(np.prod(euro_dat_np_array.shape))
    euro_close_np_array = euro_close_np_array.reshape(np.prod(euro_close_np_array.shape))

    np_obj.put_signal(euro_dat_np_array,euro_close_np_array)

    return (status, errtext, np_obj)
# end def
if __name__ == '__main__':

    ticker = "^GDAXI"
    flag = is_Ticker_info_available(ticker)
    print(f"{ticker = }: {flag = }")
    ticker = "MUV2"
    flag = is_Ticker_info_available(ticker)
    print(f"{ticker = }: {flag = }")

    search_results = yf.Search("AU3TB0000192").all
    if len(search_results["quotes"]):
        ddict = search_results["quotes"][0]
        print("--------------------------")
        for key,value in ddict.items():
            print(f"{key = } , {value = }")
    # end if
    search_results = yf.Search("DE0002635307").all
    ddict = search_results["quotes"][0]
    print("--------------------------")
    for key,value in ddict.items():
        print(f"{key = } , {value = }")
    search_results = yf.Search("DE0007314007").all
    ddict = search_results["quotes"][0]
    print("--------------------------")
    for key,value in ddict.items():
        print(f"{key = } , {value = }")

    data2 = yf.Lookup('DE0007314007').all

    etf = yf.Lookup("DE0002635307").get_etf(count=100)
