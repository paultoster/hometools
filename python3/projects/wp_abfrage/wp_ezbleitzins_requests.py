import pandas as pd
import requests
import numpy as np
import os, sys, re
from ecbdata import ecbdata
import pandas as pd

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

from tools import hfkt_type as htype
from tools import hfkt_def as hdef

def get_data(np_classdef,start_dat, end_dat):
    """
    (status, errtext, np_obj) = wp_yfinance.get_usdeuro_data(np_classdef,lastdat,end_dat)
    """
    status = hdef.OKAY
    errtext = ""

    # Start time
    start_dat_time_class = htype.type_transform_direct(start_dat,"dat","datetimeclass")
    start_dat_time = start_dat_time_class.strftime('%Y-%m-%d')


    # End time
    # end_dat_add = end_dat + 24 * 60 * 60
    # end_dat_time_class   = htype.type_transform_direct(end_dat_add,"dat","datetimeclass")
    # end_dat_time = end_dat_time_class.strftime('%Y-%m-%d')
    start_dat_time = "1999-01-01"
    df = ecbdata.get_series('FM.B.U2.EUR.4F.KR.DFR.LEV', start=start_dat_time)

    # Nur die interessanten Spalten auswählen
    df_ecbzins = df[["TIME_PERIOD", "OBS_VALUE"]].copy()

    # Datum umwandeln
    df_ecbzins["TIME_PERIOD"] = pd.to_datetime(df_ecbzins["TIME_PERIOD"])

    # Index setzen
    df_ecbzins.set_index("TIME_PERIOD", inplace=True)

    date_str_list = df_ecbzins.index.strftime("%d.%m.%Y").tolist()
    ezb_dat_np_array = np.array(htype.type_transform_direct(date_str_list, "datStrP", "dat"), copy=True)
    ezb_zins_np_array = df_ecbzins["OBS_VALUE"].to_numpy()

    euro_dat_np_array   = ezb_dat_np_array.reshape(np.prod(ezb_dat_np_array.shape))
    ezb_zins_np_array = ezb_zins_np_array.reshape(np.prod(ezb_zins_np_array.shape))

    np_obj = np_classdef(ezb_dat_np_array,ezb_zins_np_array)

    np_obj.sort_by_dat()

    return (status, errtext, np_obj)
# end def

