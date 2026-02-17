import os, sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import.tools.hfkt_type as htype


import wp_abfrage.wp_fkt as wp_fkt
import wp_abfrage.wp_storage as wp_storage

HEADER_PANDAS_DATUM_NAME = "Datum"
HEADER_PANDAS_ERSTER_NAME = "Erster"
HEADER_PANDAS_HOCH_NAME = "Hoch"
HEADER_PANDAS_TIEF_NAME = "Tief"
HEADER_PANDAS_SCHLUSS_NAME = "Schlusskurs"
HEADER_PANDAS_STUECKE_NAME = "Stuecke"
HEADER_PANDAS_VOLUMEN_NAME = "Volumen"

HEADER_PANDAS_LLISTE = [(HEADER_PANDAS_DATUM_NAME, "datPandas"),
                       (HEADER_PANDAS_ERSTER_NAME, "float"),
                       (HEADER_PANDAS_HOCH_NAME, "float"),
                       (HEADER_PANDAS_TIEF_NAME, "float"),
                       (HEADER_PANDAS_SCHLUSS_NAME, "float"),
                       (HEADER_PANDAS_STUECKE_NAME, "float"),
                       (HEADER_PANDAS_VOLUMEN_NAME, "float"),
                       ]
HEADER_PANDAS_NAME_DICT = {}
HEADER_PANDAS_NAME_LIST = []
HEADER_PANDAS_TYPE_DICT = {}
HEADER_PANDAS_TYPE_LIST = []

for i,liste in enumerate(HEADER_PANDAS_LLISTE):
    HEADER_PANDAS_NAME_DICT[i] = liste[0]
    HEADER_PANDAS_TYPE_DICT[i] = liste[1]
    HEADER_PANDAS_NAME_LIST.append(liste[0])
    HEADER_PANDAS_TYPE_LIST.append(liste[1])
# end for

HEADER_ARIVA_CSV_LLISTE = [(HEADER_PANDAS_DATUM_NAME, "datStrP"),
                          (HEADER_PANDAS_ERSTER_NAME, "euroStrK"),
                          (HEADER_PANDAS_HOCH_NAME, "euroStrK"),
                          (HEADER_PANDAS_TIEF_NAME, "euroStrK"),
                          (HEADER_PANDAS_SCHLUSS_NAME, "euroStrK"),
                          (HEADER_PANDAS_STUECKE_NAME, "float"),
                          (HEADER_PANDAS_VOLUMEN_NAME, "float"),
                         ]
HEADER_ARIVA_CSV_NAME_DICT = {}
HEADER_ARIVA_CSV_NAME_LIST = []
HEADER_ARIVA_CSV_TYPE_DICT = {}
HEADER_ARIVA_CSV_TYPE_LIST = []

for i,liste in enumerate(HEADER_ARIVA_CSV_LLISTE):
    HEADER_ARIVA_CSV_NAME_DICT[i] = liste[0]
    HEADER_ARIVA_CSV_TYPE_DICT[i] = liste[1]
    HEADER_ARIVA_CSV_NAME_LIST.append(liste[0])
    HEADER_ARIVA_CSV_TYPE_LIST.append(liste[1])
# end for

def update_last_price_volume_isin(wp_obj, isin):
    """

    :param wp_obj:
    :param isin:
    :return: (status, errtext) = get_last_price_volume_isin(wp_obj, isin)
    """

    status = hdef.OKAY
    errtext = ""

    last_active_dat_time_list = wp_fkt.letzter_beendeter_handelstag_dat_list(wp_obj.base_ddict["boerse"])

    if not proof_date_in_price_volume_data(wp_obj, isin, last_active_dat_time_list):

        (df_data,status,errtext) = read_price_volume_data_from_ariva(wp_obj, isin, last_active_dat_time_list)





    return (status,errtext)
# end def
def proof_date_in_price_volume_data(wp_obj, isin, last_active_dat_time_list):
    """

    :param wp_obj:
    :param isin:
    :param last_active_dat_time_list:
    :return: flag = proof_date_in_price_volume_data(wp_obj, isin, last_active_date)
    """

    flag = False

    # Gibt es bereits eine Datei
    if wp_storage.price_volume_storage_exist(isin, wp_obj.base_ddict):
        data_df = wp_storage.read_parquet(isin, wp_obj.base_ddict)

    # end if

    return flag
# end def
def read_price_volume_data_from_ariva(wp_obj, isin, last_active_dat_time_list):
    """

    :param wp_obj:
    :param isin:
    :param last_active_dat_time_list:
    :return: (df_data,status,errtext) = read_price_volume_data_from_ariva(wp_obj, isin, last_active_date)
    """

    htype.####





