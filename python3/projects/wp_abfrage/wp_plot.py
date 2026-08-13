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

import tools.hfkt_def as hdef
import tools.hfkt_list as hlist
import tools.hfkt_type as htype
import tools.hfkt_date_time as hdt

if os.path.isfile('wp_base.py'):
    import wp_storage as wp_storage
    import wp_playwright as wp_pr

else:
    import wp_abfrage.wp_storage as wp_storage
    import wp_abfrage.wp_playwright as wp_pr

# end if

def plot_indice(np_obj,indice):
    """
    plot_indice(np_obj)
    """

    # np_dat_str_array = pd.to_datetime(getattr(np_obj, "dat_np_array"))
    np_dat_str_array = np.array(pd.to_datetime(getattr(np_obj, "dat_np_array"), unit='s').strftime('%d.%m.%Y'))
    np_indice_array = getattr(np_obj, "indice_np_array")

    plt.gca().xaxis.set_major_formatter(mpl.dates.DateFormatter('%d.%m.%Y'))
    plt.gca().xaxis.set_major_locator(mpl.dates.MonthLocator())

    plt.plot(np_dat_str_array,np_indice_array)

    plt.grid(axis='x', color='0.95')
    plt.grid(axis='y', color='0.95')


    plt.title('Sollen die Werte invertiert werden?')

    plt.ylabel(indice)
    plt.xlabel("datum")

    plt.show()