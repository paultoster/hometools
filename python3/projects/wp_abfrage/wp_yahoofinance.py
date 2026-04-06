import yfinance as yf
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
import tools.hfkt_date_time as hdt

if os.path.isfile('wp_fkt.py'):
    import wp_fkt
else:
    import wp_abfrage.wp_fkt as wp_fkt
# end if

currencyvalueheaderlist = ["Close", "High", "Low", "Open"]

def get_price_volume_data(ticker,classdef,start_dat,end_dat):
    """
    (status, errtext, np_obj) = get_price_volume_data(ticker,classdef,start_dat,end_dat)
    """
    status = hdef.OKAY
    errtext = ""
    np_obj = classdef()

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

    df_data = yf.download(ticker, start_dat_time_class.strftime('%Y-%m-%d'), end_dat_time_class.strftime('%Y-%m-%d'))

    if df_data.empty:
        status = hdef.NOT_OKAY
        errtext = f"for Ticker-Symbol \"{ticker}\" no data from yahoofinance"
        return (status, errtext, np_obj)
    # end if

    date_str_list = df_data.index.strftime("%d.%m.%Y").tolist()

    dat_np_array = np.array(htype.type_transform_direct(date_str_list, "datStrP", "dat"), copy=True)
    open_np_array = df_data["Open"].to_numpy()
    high_np_array = df_data["High"].to_numpy()
    low_np_array = df_data["Low"].to_numpy()
    close_np_array = df_data["Close"].to_numpy()
    volume_np_array = df_data["Volume"].to_numpy()

    np_obj.from_np_array_list([dat_np_array,open_np_array,high_np_array,low_np_array,close_np_array,volume_np_array])

    return (status, errtext, np_obj)
# end def
def get_price_volume_data(ticker, waehrung, start_dat_time_list, end_dat_time_list):
    """


    :param ticker:
    :param waehrung:
    :param start_dat_time_list:
    :param end_dat_time_list:
    :return: (status,errtext,df_data) = get_price_volume_data(ticker,waehrung,start_dat_time_list,end_dat_time_list)
    """

    status = hdef.OKAY
    errtext = ""

    # Start time
    (status, start_dat) = htype.type_transform(start_dat_time_list, "datTimeList", "datetimeclass")
    if status != hdef.OKAY:
        raise Exception(f"type transform missglückt von {start_dat_time_list = } von \"datTimeList\" zu \"dat\" ")
    # end if
    # End time
    (status, end_dat) = htype.type_transform(end_dat_time_list, "datTimeList", "datetimeclass")
    if status != hdef.OKAY:
        raise Exception(f"type transform missglückt von {end_dat_time_list = } von \"datTimeList\" zu \"dat\" ")
    # end if

    df_data = yf.download(ticker, start_dat.strftime('%Y-%m-%d'), end_dat.strftime('%Y-%m-%d'))

    if df_data.empty:
        status = hdef.NOT_OKAY
        errtext = f"for Ticker-Symbol \"{ticker}\" no data from yahoofinance"
        return (status, errtext, df_data)
    # end if

    date_str_list = df_data.index.strftime("%d.%m.%Y").tolist()

    dat_np_array = np.array(htype.type_transform_direct(date_str_list, "datStrP", "dat"), copy=True)
    close_np_array = df_data["Close"].to_numpy()
    high_np_array = df_data["High"].to_numpy()
    low_np_array = df_data["Low"].to_numpy()
    open_np_array = df_data["Open"].to_numpy()
    volume_np_array = df_data["Volume"].to_numpy()

    # currency
    if waehrung == "euro" or waehrung == "€":

        t = 'EURUSD=X'
        df_data_eurodol = yf.download(t, start_dat.strftime('%Y-%m-%d'), end_dat.strftime('%Y-%m-%d'))

        if df_data_eurodol.empty:
            status = hdef.NOT_OKAY
            errtext = f"For Euro-Calc Ticker-Symbol \"{t}\" no data from yahoofinance"
            return (status, errtext, df_data)
        # end if

        date_str_list = df_data_eurodol.index.strftime("%d.%m.%Y").tolist()
        euro_dat_np_array = np.array(htype.type_transform_direct(date_str_list, "datStrP", "dat"), copy=True)
        euro_close_np_array = df_data_eurodol["Close"].to_numpy()

        half_day_seconds = 12 * 60 * 60
        index_dat_of_euro_dict = wp_fkt.build_overlap_dict_of_index(dat_np_array.tolist(),euro_close_np_array.tolist(), half_day_seconds)

        dat_end_array = np.empty([len(index_dat_of_euro_dict), 1], dtype=dat_np_array.dtype)
        close_end_array = np.empty([len(index_dat_of_euro_dict), 1], dtype=float)
        high_end_array = np.empty([len(index_dat_of_euro_dict), 1], dtype=float)
        low_end_array = np.empty([len(index_dat_of_euro_dict), 1], dtype=float)
        open_end_array = np.empty([len(index_dat_of_euro_dict), 1], dtype=float)
        volume_end_array = np.empty([len(index_dat_of_euro_dict), 1], dtype=volume_np_array.dtype)

        index = 0
        for key, value in index_dat_of_euro_dict.items():
            dat_end_array[index] = dat_np_array[key]
            close_end_array[index] = close_np_array[key] * euro_close_np_array[value]
            high_end_array[index] = close_np_array[key] * euro_close_np_array[value]
            low_end_array[index] = close_np_array[key] * euro_close_np_array[value]
            open_end_array[index] = close_np_array[key] * euro_close_np_array[value]
            volume_end_array[index] = volume_np_array[key]
            index += 1
        # end for
    else:
        dat_end_array = dat_np_array.view()
        close_end_array = close_np_array.view()
        high_end_array = high_np_array.view()
        low_end_array = low_np_array.view()
        open_end_array = open_np_array.view()
        volume_end_array = volume_np_array.view()
    # end if

    return (status, errtext, df_data)
# end def
def get_usdeuro_data(start_dat, end_dat):
    """
    (status, errtext, np_obj) = wp_yfinance.get_usdeuro_data(lastdat,end_dat)
    (status, errtext, df_data) = get_usdeuro_data(start_dat_time_list, end_dat_time_list)
    """
    # status = hdef.OKAY
    errtext = ""

    # Start time
    start_dat_time_class = htype.type_transform_direct(start_dat,"dat","datetimeclass")
    # End time
    # add one day because yfinace need
    end_dat_add = end_dat + 24 * 60 * 60

    end_dat_time_class   = htype.type_transform_direct(end_dat_add,"dat","datetimeclass")

    t = 'EURUSD=X'
    df_data_eurodol = yf.download(t, start_dat_time_class.strftime('%Y-%m-%d'), end_dat_time_class.strftime('%Y-%m-%d'))

    if df_data_eurodol.empty:
        status = hdef.NOT_OKAY
        errtext = f"For Euro-Calc Ticker-Symbol \"{t}\" no data from yahoofinance"
        return (status, errtext, None)
    # end if

    date_str_list = df_data_eurodol.index.strftime("%d.%m.%Y").tolist()
    euro_dat_np_array = np.array(htype.type_transform_direct(date_str_list, "datStrP", "dat"), copy=True)
    euro_close_np_array = df_data_eurodol["Close"].to_numpy()

    (status, errtext, np_obj) = wp_fkt.build_usdeuro_np_obj_from_np_array(euro_dat_np_array, euro_close_np_array)

    return (status, errtext, np_obj)
# end def