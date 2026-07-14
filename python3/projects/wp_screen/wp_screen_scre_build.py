
import os, sys, copy

from hfkt_log import log

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

    global STATUS,ERRTEXT

    # dataclass anlegen
    #------------------
    filename = get_dataclass_filename(rd, isin)
    np_data_obj = hnp_dataclass.NpDataHandlingClass(filename)
    rd.scre["scre_isin_dataclass_dict"][isin] = np_data_obj

    # Kursdaten für bestimmte isin holen
    (status, errtext, np_wp_obj) = rd.wpfunc.get_act_np_obj(isin)
    if (status != hdef.OKAY) or (np_wp_obj == None):
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"scre_build_signal: Für {isin = } konnte kein np_wp_obj erstellt werden \n{errtext = }"
        return
    # end if

    # Datum in np_data_obj schreiben
    np_data_obj.add_signal(np_wp_obj.dat_np_array, rd.par.SIG_STORE_DATUM)
    if np_data_obj.get_status() != hdef.OKAY:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"scre_build_signal: Für {isin = } konnte Signal {rd.par.SIG_STORE_DATUM} nicht zu np_data_obj hinzugefügt werden \n{np_data_obj.get_errtext()}"
        return
    # end if
    rd.log.write_info(f"isin = {isin}, n = {len(np_data_obj.datum_array)}",screen=rd.par.LOG_SCREEN_OUT)
    print(f"isin = {isin}, n = {len(np_data_obj.datum_array)}")
    

    for werte_dict in sigset_werte_dict_liste:

        werte_dict["isin"] = isin

        # Null Signal
        if werte_dict["type"] == rd.par.SIG_TYPE_NULL:  # kein signal
            pass
        else:
            (success,np_data_obj) = get_0par_signal(rd,werte_dict,np_data_obj,np_wp_obj)

            if not success:
                (success, np_data_obj) = get_2par_signal(rd, werte_dict, np_data_obj)

        # end if
        print(werte_dict)
    # end for

    #  save np_data_obj
    np_data_obj.save()
    if np_data_obj.get_status() != hdef.OKAY:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"scre_build_signal: Für {isin = } konnte Signal {rd.par.SIG_STORE_DATUM} nicht zu np_data_obj hinzugefügt werden \n{np_data_obj.get_errtext()}"
        return
    # end if

    return
# end def
def get_0par_signal(rd,werte_dict,np_data_obj,np_wp_obj):
    """
    (success,np_data_obj) = get_0par_signal(rd,werte_dict,np_data_obj,np_wp_obj)
    """
    global STATUS, ERRTEXT
    success = False

    # Kurs/Close
    match werte_dict["type"]:
        case rd.par.SIG_TYPE_KURS | rd.par.SIG_TYPE_CLOSE:
            np_data_obj.add_signal(np_wp_obj.end_np_array, werte_dict["signal"])
            success = True
        case rd.par.SIG_TYPE_OPEN:
            np_data_obj.add_signal(np_wp_obj.start_np_array, werte_dict["signal"])
            success = True
        case rd.par.SIG_TYPE_HIGH:
            np_data_obj.add_signal(np_wp_obj.high_np_array, werte_dict["signal"])
            success = True
        case rd.par.SIG_TYPE_LOW:
            np_data_obj.add_signal(np_wp_obj.low_np_array, werte_dict["signal"])
            success = True
        case rd.par.SIG_TYPE_VOLUME:
            np_data_obj.add_signal(np_wp_obj.volume_np_array, werte_dict["signal"])
            success = True
    # end match

    if success:
        if np_data_obj.get_status() != hdef.OKAY:
            STATUS = hdef.NOT_OKAY
            ERRTEXT = f"scre_build_signal: Für isin = {werte_dict["isin"]} konnte Signal {werte_dict["signal"]} nicht zu np_data_obj hinzugefügt werden \n{np_data_obj.get_errtext()}"
        # end if

    return (success,np_data_obj)
# end def
def get_2par_signal(rd, werte_dict, np_data_obj):
    """
    (success,np_data_obj) = get_2par_signal(rd, werte_dict, np_data_obj)
    """
    global STATUS, ERRTEXT
    success = False
    match werte_dict["type"]:
        #
        # SignalName3 = np_obj(isin,kurs)                     Kurswerte von einer anderen isin
        #                                                     gespeichrt wird:
        #                                                     "SignalName3_dat_array" und "SignalName3"
        case rd.par.SIG_TYPE_2PAR_NP_OBJ:
            fremd_isin = werte_dict["par1"]
            kurssignal = werte_dict["par2"]

            (success_sub,np_dat_array,np_array) = get_signal_fremd_isin(rd,fremd_isin,kurssignal)
            if STATUS != hdef.OKAY:
                return

            if success_sub:
                np_data_obj.add_signal(np_dat_array, werte_dict["signal"]+"_"+rd.par.SIG_STORE_DATUM)
                np_data_obj.add_signal(np_array, werte_dict["signal"])
                success = True
            else:
                STATUS = hdef.NOT_OKAY
                ERRTEXT = f"Der 2. Parameter von fkt: {rd.par.SIG_2PAR_NP_OBJ}({fremd_isin},{kurssignal}) ist nicht bekannt"
                return
            # end if
        #
        # SignalName4 = lingrad(SignalName1,20)               Linearer Gerade aus SignalName1 mit 20 Punkten
        #                                                     gespeichert wird:
        #                                                     "SignalName4_dat_array" und "SignalName4" sowie "SignalName4_grad" (Einzelwert)
        case rd.par.SIG_TYPE_2PAR_LINGRAD:
            signame = werte_dict["par1"]
            points  = werte_dict["par2"]

            (success_sub, np_dat_array, np_array, grad) = build_signal_lingrad(rd, signame, points,np_data_obj)
            if STATUS != hdef.OKAY:
                return

            if success_sub:
                np_data_obj.add_signal(np_dat_array, werte_dict["signal"] + "_" + rd.par.SIG_STORE_DATUM)
                np_data_obj.add_signal(np_array, werte_dict["signal"])
                success = True
            else:
                STATUS = hdef.NOT_OKAY
                ERRTEXT = f"Der 2. Parameter von fkt: {rd.par.SIG_2PAR_NP_OBJ}({fremd_isin},{kurssignal}) ist nicht bekannt"
                return
            # end if
    # end match

    if success:
        if np_data_obj.get_status() != hdef.OKAY:
            STATUS = hdef.NOT_OKAY
            ERRTEXT = f"scre_build_signal: Für fremd_isin = {fremd_isin} konnte Signal {werte_dict["signal"]} nicht zu np_data_obj hinzugefügt werden \n{np_data_obj.get_errtext()}"
        # end if
    # end if

    return (success, np_data_obj)
# end def
def get_signal_fremd_isin(rd,fremd_isin,kurssignal):
    """
    (success,np_dat_arry,np_array) = get_signal_fremd_isin(rd,fremd_isin,kurssignal)
    """
    global STATUS, ERRTEXT
    # Kursdaten für bestimmte fremd_isin holen
    (status, errtext, np_wp_obj) = rd.wpfunc.get_act_np_obj(fremd_isin)
    if (status != hdef.OKAY) or (np_wp_obj == None):
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"scre_build_signal: Für {fremd_isin = } konnte kein np_wp_obj erstellt werden \n{errtext = }"
        return (None,None)
    # end if

    success = False
    np_array = None
    np_dat_array = None
    # Kurs/Close
    match kurssignal:
        case rd.par.SIG_KURS | rd.par.SIG_CLOSE:
            np_array =  np_wp_obj.end_np_arra
            success = True
        case rd.par.SIG_OPEN:
            np_array =  np_wp_obj.start_np_array
            success = True
        case rd.par.SIG_HIGH:
            np_array =  np_wp_obj.high_np_array
            success = True
        case rd.par.SIG_LOW:
            np_array =  np_wp_obj.low_np_array
            success = True
        case rd.par.SIG_VOLUME:
            np_array =  np_wp_obj.volume_np_array
            success = True
    # end match

    if success:
        np_dat_array =  np_wp_obj.dat_np_array

    return (success, np_dat_array, np_array)
#end def
def build_signal_lingrad(rd, signame, points,np_data_obj):
    """
    (success, np_dat_array, np_array, grad) = build_signal_lingrad(rd, signame, points,np_data_obj)
    """
    global STATUS, ERRTEXT

    success = False
    np_array = None
    np_dat_array = None
    grad = None

    if hasattr(np_data_obj, signame):
        np_dat_array = np_data_obj.dat_np_array
        np_array = getattr(np_data_obj, signame)
    else:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"Signal {signame} nicht bekannt im erstellten Datensatz !!"
        return
    # end if


    return (success, np_dat_array, np_array, grad)
# end def
def get_dataclass_filename(rd,isin):

    filename = os.path.join(rd.ini["store_path"],rd.ini["scre_dataclass_pre_file_name"] + isin + ".joblib")
    return filename
# end def