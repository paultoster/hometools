
import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

# import wp_screen_gui

import tools.hfkt_def as hdef
import tools.hfkt_np_dataclass as hnp_dataclass
import tools.hfkt_np_fkt as hnpfkt
import tools.hfkt_type as htype

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
def build_ezbzins_sigset(rd):

    global STATUS
    global ERRTEXT
    global INFOTEXT

    if not proof_if_ezbzins_data_uptodate(rd):

        filename = get_dataclass_filename(rd)
        np_data_obj = hnp_dataclass.NpDataHandlingClass(filename)

        # EZBZins-np obj holen
        (status, errtext, np_ezbzins_obj) = rd.wpfunc.get_dict_indice_from_act("ezbleitzins")
        if (status != hdef.OKAY) or (np_ezbzins_obj is None):
            STATUS = hdef.NOT_OKAY
            ERRTEXT = f"build_ezbzins_sigset: Für ezbleitzins konnte kein np_obj_dict erstellt werden \n{errtext = }"
            return
        # end if

        # Datum in np_data_obj schreiben
        if not hnpfkt.is_monoton_steigend(np_ezbzins_obj.dat_np_array):
            STATUS = hdef.NOT_OKAY
            ERRTEXT = f"scre_build_signal: Für ezbleitzins ist np_ezbzins_obj mit dem Datums-array nicht monoton steigend "
            return
        # end if

        np_data_obj.add_signal(np_ezbzins_obj.dat_np_array, rd.par.SIG_STORE_DATUM)
        if np_data_obj.get_status() != hdef.OKAY:
            STATUS = hdef.NOT_OKAY
            ERRTEXT = f"scre_build_signal: Für ezbleitzins konnte Signal {rd.par.SIG_STORE_DATUM} nicht zu np_data_obj hinzugefügt werden \n{np_data_obj.get_errtext()}"
            return
        # end if

        if np_ezbzins_obj.is_unit("%"):
            np_ezbzins_obj.indice_np_array /= 100.

        np_data_obj.add_signal(np_ezbzins_obj.indice_np_array, "ezbleitzins")

        datStrP = htype.type_transform_direct(getattr(np_data_obj, rd.par.SIG_STORE_DATUM)[-1],"dat","datStrP")

        INFOTEXT = f" letztes Datum = {datStrP}, n = {len(getattr(np_data_obj, rd.par.SIG_STORE_DATUM))}"

        #  save np_data_obj
        np_data_obj.save()
        if np_data_obj.get_status() != hdef.OKAY:
            STATUS = hdef.NOT_OKAY
            ERRTEXT = f"scre_build_signal: Für ezbzins konnte np_data_obj nicht gespeichert werden \n{np_data_obj.get_errtext()}"
            return
        # end if

        del np_data_obj
    # end if

    return
    # end def
def proof_if_ezbzins_data_uptodate(rd):


    filename = get_dataclass_filename(rd)

    np_data_obj = hnp_dataclass.NpDataHandlingClass(filename)
    if np_data_obj.exist_file():
        np_data_obj.read()
    else:
        return False
    # end if

    np_dat_obj_array = np_data_obj.get_data(rd.par.SIG_STORE_DATUM)
    if (np_data_obj.get_status() != hdef.OKAY) or (np_dat_obj_array is None):
        return False
    # end if

    # EZBZins-np obj holen
    (status, errtext, np_ezbzins_obj) = rd.wpfunc.get_dict_indice_from_act("ezbleitzins")
    if (status != hdef.OKAY) or (np_ezbzins_obj is None):
        return False
    # end if

    if np_ezbzins_obj.dat_np_array is None:
        return False
    # end if

    half_day = 60*60*12
    if (np_ezbzins_obj.dat_np_array[-1] - np_dat_obj_array[-1]) > half_day:
        return False
    # end if

    return True
# end def
def get_ezbzins(rd,aktdat):

    global STATUS
    global ERRTEXT
    global INFOTEXT

    filename = get_dataclass_filename(rd)

    np_data_obj = hnp_dataclass.NpDataHandlingClass(filename)
    if np_data_obj.exist_file():
        np_data_obj.read()
    else:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"get_ezbzins: Für ezbleitzins konnte Datei: {filename} nicht gelesen werden"
        return
    # end if

    ezbleitzins = hnpfkt.interpoliere(aktdat, getattr(np_data_obj, rd.par.SIG_STORE_DATUM), getattr(np_data_obj,"ezbleitzins"), type='const')

    return ezbleitzins
# end def
def get_dataclass_filename(rd):
    """

    filename = get_dataclass_filename(rd)

    """

    return os.path.join(rd.ini["store_path"],
                        rd.ini["ezbzins_dataclass_file_name"] + ".joblib")
# end def

