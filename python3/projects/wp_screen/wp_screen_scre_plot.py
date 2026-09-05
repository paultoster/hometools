
import os, sys, copy


t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import wp_screen_gui
import wp_screen_katalog
import wp_screen_sigset
import wp_screen_tab
import wp_screen_scre_build_rawtab
import wp_screen_scre_build_signal
import wp_screen_scre_build_fmttab
import wp_screen_scre

import tools.hfkt_def as hdef
import tools.hfkt_pickle as hfkt_pickle
import tools.sgui as sgui
import tools.hfkt_tvar as htvar
# import tools.hfkt_type as htype


def plot_scre(rd,scre_dict,index):
    """
    (status,errtext) = wp_screen_scre_plot.plot_scre(rd,scre_dict,index)
    """
    status = hdef.OKAY
    errtext = ""

    isin_liste = wp_screen_katalog.get_katalog_isin_liste(rd, scre_dict[rd.par.SCRE_KATALOG])

    isin = isin_liste[index]

    rd.scre["scre_isin_dataclass_filename_dict"][isin]


    np_data_obj = wp_screen_scre_build_rawtab.get_np_data_obj(rd, isin)

