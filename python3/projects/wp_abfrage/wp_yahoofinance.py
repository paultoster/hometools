import yfinance as yf
import pandas as pd
import numpy as np
import os, sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

from tools import hfkt_type as htype
from tools import hfkt_def as hdef

if os.path.isfile('wp_fkt.py'):
    import wp_fkt
else:
    import wp_abfrage.wp_fkt as wp_fkt
# end if

currencyvalueheaderlist = ["Close", "High", "Low", "Open"]


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

    dat_np_array = np.array(htype.type_tranform_direct(date_str_list, "datStrP", "dat"), copy=True)
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
        euro_dat_np_array = np.array(htype.type_tranform_direct(date_str_list, "datStrP", "dat"), copy=True)
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
