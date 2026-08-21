import numpy as np
import os, sys, re
from ecbdata import ecbdata
import pandas as pd
import datetime

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

from tools import hfkt_type as htype
from tools import hfkt_def as hdef
from tools import hfkt_np_fkt as hnp_fkt

from wp_abfrage import wp_fkt

def get_data(np_obj,start_dat, end_dat):
    """
    (status, errtext, np_obj) = wp_yfinance.get_usdeuro_data(np_obj,lastdat,end_dat)
    """
    status = hdef.OKAY
    errtext = ""

    # Start time
    start_dat_time_class = htype.type_transform_direct(start_dat,"dat","datetimeclass")
    start_dat_time = start_dat_time_class.strftime('%Y-%m-%d')


    df = ecbdata.get_series('FM.B.U2.EUR.4F.KR.DFR.LEV', start=start_dat_time)

    # Nur die interessanten Spalten auswählen
    df_ecbzins = df[["TIME_PERIOD", "OBS_VALUE"]].copy()

    # Datum umwandeln
    df_ecbzins["TIME_PERIOD"] = pd.to_datetime(df_ecbzins["TIME_PERIOD"])

    # Index setzen
    df_ecbzins.set_index("TIME_PERIOD", inplace=True)

    date_str_list = df_ecbzins.index.strftime("%d.%m.%Y").tolist()
    date_time_list = [datetime.datetime.strptime(d, "%d.%m.%Y") for d in date_str_list]
    ezb_dat_np_array = hnp_fkt.transform_date_time_liste_in_np_dat_array_d(date_time_list)

    ezb_zins_np_array = df_ecbzins["OBS_VALUE"].to_numpy()


    ezb_dat_np_array   = ezb_dat_np_array.reshape(np.prod(ezb_dat_np_array.shape))
    ezb_zins_np_array = ezb_zins_np_array.reshape(np.prod(ezb_zins_np_array.shape))

    dat_letzter_handelstag = wp_fkt.letzter_beendeter_handelstag_timestamp()

    np_handelstage_dat_array = wp_fkt.get_np_handels_tage_von_bis(start_dat,dat_letzter_handelstag)

    ezb_zins_handelstage_np_array = wp_fkt.interpol_with_dat_const(ezb_dat_np_array,ezb_zins_np_array,np_handelstage_dat_array)


    np_obj.put_signal(np_handelstage_dat_array,ezb_zins_handelstage_np_array)

    np_obj.sort_by_dat()

    return (status, errtext, np_obj)
# end def

