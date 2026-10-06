import os
import sys
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib as mpl
import numpy as np

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)

import tools.sgui as sgui
import tools.hfkt_def as hdef

if os.path.isfile('wp_base.py'):
    # import wp_storage as wp_storage
    # import wp_playwright as wp_pr
    pass
else:
    # import wp_abfrage.wp_storage as wp_storage
    # import wp_abfrage.wp_playwright as wp_pr
    pass
# end if

def plot_indice_invert(np_obj,indice):
    """
    (status,errtext,invert_indice) = plot_indice_invert(np_obj)
    """

    # np_dat_str_array = pd.to_datetime(getattr(np_obj, "dat_np_array"))
    np_dat_str_array = np.array(pd.to_datetime(getattr(np_obj, "dat_np_array"), unit='s').strftime('%d.%m.%Y'))
    np_indice_array = getattr(np_obj, "indice_np_array")

    ddict_inp = {}
    ddict_inp["title"] = "Sollen die Werte invertiert werden?"
    ddict_inp["auswahl_liste"] = ["so lassen", "invertieren"]
    ddict_inp["index_default_auswahl"] = 0
    ddict_inp["plot_x_np_array"] = np_dat_str_array
    ddict_inp["plot_y_np_array"] = np_indice_array
    ddict_inp["plot_x_is_date"] = 1
    ddict_inp["plot_x_name"] = "Datum"
    ddict_inp["plot_y_name"] = indice

    ddict_inp["plo_title"] = ""
    ddict_inp["plo_x_label"] = "Datum"
    ddict_inp["plot_y_label"] = indice
    ddict_inp["plot_legend"] = 0

    ddict_out = sgui.plot_mit_radiobuttons(ddict_inp)

    if ddict_out["index"] < 0:
        invert_indice = None
    elif ddict_out["index"] == 0:
        invert_indice = False
    else:
        invert_indice = True

    return (ddict_out["status"],ddict_out["errtext"],invert_indice)

    # plt.gca().xaxis.set_major_formatter(mpl.dates.DateFormatter('%d.%m.%Y'))
    # plt.gca().xaxis.set_major_locator(mpl.dates.MonthLocator())
    #
    # plt.plot(np_dat_str_array,np_indice_array)
    #
    # plt.grid(axis='x', color='0.95')
    # plt.grid(axis='y', color='0.95')
    #
    #
    # plt.title('Sollen die Werte invertiert werden?')
    #
    # plt.ylabel(indice)
    # plt.xlabel("datum")
    #
    # plt.show()
def plot_indice(wb_obj,np_obj, indice):
    """
    (status,errtext) = plot_indice(wb_obj.np_obj,indice)
    """

    # Build plot-dict
    dict_data = {}
    dict_data["xdat"] = getattr(np_obj, "dat_np_array")
    dict_data["y"] = getattr(np_obj, "indice_np_array")
    dict_data["label"] = indice

    dict_subplot = {}
    dict_subplot["xlabel"] = "date"

    match indice:
        case wb_obj.par.INDICES_EZB_LEITZINS_NAME:

            dict_subplot["ylabel"] = np_obj.get_unit()

        case wb_obj.par.INDICES_USDEURO_NAME:

            dict_subplot["ylabel"] = "usd/euro"

        case wb_obj.par.INDICES_CHFEURO_NAME:

            dict_subplot["ylabel"] = "chf/euro"

        case wb_obj.par.INDICES_GBPEURO_NAME:

            dict_subplot["ylabel"] = "gbp/euro"

        case _:

            status = hdef.NOT_OKAY
            errtext = f"plot_indice: Der Indice {indice} ist nicht gefunden worden in der Liste."
    # end match

    dict_subplot["data_list"] = [dict_data]
    dict_subplot["legend"] = "best"

    fig_dict = {}
    fig_dict["title"]  = f"indice: {indice}"
    fig_dict["title_add_date_range"] = True
    fig_dict["subplot_list"] = [dict_subplot]

    dict_input = {}
    dict_input["plot"] = fig_dict

    dict_out = sgui.matplot_date_data(dict_input)

    return (dict_out["status"], dict_out["errtext"])
# end def