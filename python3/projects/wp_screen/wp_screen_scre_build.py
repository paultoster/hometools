
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


import tools.hfkt_def as hdef
import tools.hfkt_np_dataclass as hnp_dataclass
import tools.sgui as sgui
# import tools.hfkt_tvar as htvar
# import tools.hfkt_type as htype

STATUS   = hdef.OKAY
ERRTEXT  = ""
INFOTEXT = ""


def get_status():
    global STATUS
    return STATUS
def get_errtext():
    global ERRTEXT
    return ERRTEXT
def get_infotext():
    global INFOTEXT
    return INFOTEXT
def reset_status():
    global STATUS
    global ERRTEXT
    global INFOTEXT
    STATUS = hdef.OKAY
    ERRTEXT = ""
    INFOTEXT = ""
# end def

def scre_build(rd,scre_dict):

    global STATUS, ERRTEXT

    katalog = scre_dict[rd.par.SCRE_KATALOG]
    sigset = scre_dict[rd.par.SCRE_SIGSET]

    isin_liste = wp_screen_katalog.get_katalog_isin_liste(rd,katalog)
    sigset_dict = wp_screen_sigset.get_sigset_dict(rd,sigset)

    (status, infotext, sigset_werte_dict_liste) = wp_screen_sigset.get_sigset_werte_dict_liste(rd, sigset_dict)
    if status != hdef.OKAY:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = infotext
        return
    # end if

    # reset isin-dataclass dict (vielleicht richtig löschen, einzeln)
    rd.scre["scre_isin_dataclass_dict"] = {}

    for isin in isin_liste:
        scre_build_signal(rd,isin,sigset_dict,sigset_werte_dict_liste)
        if STATUS != hdef.OKAY:
            return
        # end if
    # end for


    return
# end def
def scre_build_signal(rd,isin,sigset_dict,sigset_werte_dict_liste):

    global STATUS

    # dataclass anlegen
    #------------------
    filename = get_dataclass_filename(rd, isin)
    np_data_obj = hnp_dataclass.NpDataHandlingClass(filename)
    rd.scre["scre_isin_dataclass_dict"][isin] = np_data_obj

    for werte_dict in sigset_werte_dict_liste:

        # Kursdaten für bestimmte isin holen

    # end for

    return
# end def
def get_dataclass_filename(rd,isin):

    filename = os.path.join(rd.ini["store_path"],rd.ini["scre_dataclass_pre_file_name"] + isin + ".joblib")
    return filename
# end def