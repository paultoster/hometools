
import os, sys, copy
import numpy as np

# from hfkt_log import log

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_np_dataclass as hnp_dataclass
import tools.hfkt_np_fkt as hnpfkt

# import tools.sgui as sgui
# import tools.hfkt_tvar as htvar
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

def scre_build_signal(rd,isin,sigset_werte_dict_liste):

    global STATUS,ERRTEXT, INFOTEXT

    # dataclass anlegen
    #------------------
    filename = get_dataclass_filename(rd, isin)
    np_data_obj = hnp_dataclass.NpDataHandlingClass(filename)




    # Kursdaten für vorggegbene isin holen
    (status, errtext, np_isin_obj) = rd.wpfunc.get_act_price_volume_np_obj(isin)
    if (status != hdef.OKAY) or (np_isin_obj == None):
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"scre_build_signal: Für {isin = } konnte kein np_isin_obj erstellt werden \n{errtext = }"
        return
    # end if

    # Datum in np_data_obj schreiben
    if not hnpfkt.is_monoton_steigend(np_isin_obj.dat_np_array):
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"scre_build_signal: Für {isin = } ist np_isin_obj mit dem Datums-array nicht monoton steigend \n{errtext = }"
        return
    # end if

    np_data_obj.add_signal(np_isin_obj.dat_np_array, rd.par.SIG_STORE_DATUM)
    if np_data_obj.get_status() != hdef.OKAY:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"scre_build_signal: Für {isin = } konnte Signal {rd.par.SIG_STORE_DATUM} nicht zu np_data_obj hinzugefügt werden \n{np_data_obj.get_errtext()}"
        return
    # end if

    datStrP = htype.type_transform_direct(getattr(np_data_obj, rd.par.SIG_STORE_DATUM)[-1],"dat","datStrP")

    INFOTEXT = f" letztes Datum = {datStrP}, n = {len(getattr(np_data_obj, rd.par.SIG_STORE_DATUM))}"

    # print(f"isin = {isin}, n = {len(np_data_obj.datum_array)}")
    

    for werte_dict in sigset_werte_dict_liste:

        werte_dict["isin"] = isin

        # Null Signal
        if werte_dict["type"] == rd.par.SIG_TYPE_NULL:  # kein signal
            pass
        else:

            (success, np_data_obj) = get_0par_signal(rd, werte_dict, np_data_obj, np_isin_obj)

            if not success:
                (success, np_data_obj) = get_1par_signal(rd, werte_dict, np_data_obj)

                if not success:
                    (success, np_data_obj) = get_2par_signal(rd, werte_dict, np_data_obj)

                    if not success:
                        (success, np_data_obj) = get_3par_signal(rd, werte_dict, np_data_obj)

                        if not success:
                            (success, np_data_obj) = get_npar_signal(rd, werte_dict, np_data_obj)

                            if not success:
                                STATUS = hdef.NOT_OKAY
                                ERRTEXT = f"scre_build_signal: Für {isin = } konnte sigset werte_dict = {werte_dict} nicht ausgeführt werden"
                                return

                # end if
            # end if

        # end if

    # end for

    #  save np_data_obj
    np_data_obj.save()
    if np_data_obj.get_status() != hdef.OKAY:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"scre_build_signal: Für {isin = } konnte Signal {rd.par.SIG_STORE_DATUM} nicht zu np_data_obj hinzugefügt werden \n{np_data_obj.get_errtext()}"
        return
    # end if

    del np_data_obj

    return
# end def
def get_0par_signal(rd,werte_dict,np_data_obj,np_isin_obj):
    """
    (success,np_data_obj) = get_0par_signal(rd,werte_dict,np_data_obj,np_isin_obj)
    """
    global STATUS, ERRTEXT
    success = False

    # Kurs/Close
    match werte_dict["type"]:
        case rd.par.SIG_TYPE_KURS | rd.par.SIG_TYPE_CLOSE:
            np_data_obj.add_signal(np_isin_obj.end_np_array, werte_dict["signal"])
            success = True
        case rd.par.SIG_TYPE_OPEN:
            np_data_obj.add_signal(np_isin_obj.start_np_array, werte_dict["signal"])
            success = True
        case rd.par.SIG_TYPE_HIGH:
            np_data_obj.add_signal(np_isin_obj.high_np_array, werte_dict["signal"])
            success = True
        case rd.par.SIG_TYPE_LOW:
            np_data_obj.add_signal(np_isin_obj.low_np_array, werte_dict["signal"])
            success = True
        case rd.par.SIG_TYPE_VOLUME:
            np_data_obj.add_signal(np_isin_obj.volume_np_array, werte_dict["signal"])
            success = True
        case rd.par.SIG_TYPE_DATUM:
            np_data_obj.add_signal(np_isin_obj.dat_np_array, werte_dict["signal"])
            success = True
        case rd.par.SIG_TYPE_INIDICE:
            (status, errtext, np_indice_obj) = rd.wpfunc.get_dict_indice_from_act(werte_dict["fkt"])
            if status != hdef.OKAY:
                STATUS = hdef.NOT_OKAY
                ERRTEXT = f"get_0par_signal Fehler indice: {werte_dict["fkt"]} ist nicht bereit getsellt worden"
                return (False, None)
            # end if

            np_y_array = hnpfkt.interpoliere(getattr(np_data_obj, rd.par.SIG_STORE_DATUM),
                                            np_indice_obj.dat_np_array,
                                            np_indice_obj.indice_np_array)
            np_data_obj.add_signal(np_y_array, werte_dict["signal"])
            success = True
    # end match

    if success:
        if np_data_obj.get_status() != hdef.OKAY:
            STATUS = hdef.NOT_OKAY
            ERRTEXT = f"scre_build_signal: Für isin = {werte_dict["isin"]} konnte Signal {werte_dict["signal"]} nicht zu np_data_obj hinzugefügt werden \n{np_data_obj.get_errtext()}"
        # end if

    return (success,np_data_obj)
# end def
def get_1par_signal(rd, werte_dict, np_data_obj):
    """
    (success,np_data_obj) = get_2par_signal(rd, werte_dict, np_data_obj)
    """
    global STATUS, ERRTEXT
    success = False
    if success:
        if np_data_obj.get_status() != hdef.OKAY:
            STATUS = hdef.NOT_OKAY
            ERRTEXT = f"Fehler \n{np_data_obj.get_errtext()}"
        # end if
    # end if

    return (success, np_data_obj)
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

            (success_sub,np_array) = get_signal_fremd_isin(rd,fremd_isin,kurssignal,np_data_obj)
            if STATUS != hdef.OKAY:
                return

            if success_sub:
                np_data_obj.add_signal(np_array, werte_dict["signal"])
                success = True
            else:
                STATUS = hdef.NOT_OKAY
                ERRTEXT = f"Fehler fkt: {rd.par.SIG_2PAR_NP_OBJ}({fremd_isin},{kurssignal}) ist nicht bekannt"
                return
            # end if
        #
        # SignalName4 = lingrad(SignalName1,20)               Linearer Gerade aus SignalName1 mit 20 Punkten
        #                                                     gespeichert wird:
        #                                                     "SignalName4_dat_array" und "SignalName4" sowie "SignalName4_grad" (Einzelwert)
        case rd.par.SIG_TYPE_2PAR_LINGRAD:

            signame = werte_dict["par1"]
            points  = werte_dict["par2"]

            (success_sub,  n_np_array, y0_np_array, y1_np_array, rel_anstieg_np_array) = build_signal_lingrad(rd, signame, points,np_data_obj)
            if STATUS != hdef.OKAY:
                return

            if success_sub:
                np_data_obj.add_signal(n_np_array, werte_dict["signal"] + "_" + rd.par.SIG_STORE_LINGRAD_N)
                np_data_obj.add_signal(y0_np_array, werte_dict["signal"] + "_" + rd.par.SIG_STORE_LINGRAD_Y0)
                np_data_obj.add_signal(y1_np_array, werte_dict["signal"] + "_" + rd.par.SIG_STORE_LINGRAD_Y1)
                np_data_obj.add_signal(rel_anstieg_np_array, werte_dict["signal"])
                success = True
            else:
                STATUS = hdef.NOT_OKAY
                ERRTEXT = f"Fehler fkt: {rd.par.SIG_2PAR_LINGRAD}({signame},{points}) ist nicht bekannt"
                return
            # end if
        case rd.par.SIG_TYPE_2PAR_SMA:

            signame = werte_dict["par1"]
            points = werte_dict["par2"]

            (success_sub, np_sma_array) = build_signal_sma(rd, signame, points, np_data_obj)
            if STATUS != hdef.OKAY:
                return

            if success_sub:
                np_data_obj.add_signal(np_sma_array, werte_dict["signal"])
                success = True
            else:
                STATUS = hdef.NOT_OKAY
                ERRTEXT = f"Fehler fkt: {rd.par.SIG_2PAR_SMA}({signame},{points}) ist nicht bekannt"
                return
            # end if

        case rd.par.SIG_TYPE_2PAR_EMA:

            signame = werte_dict["par1"]
            points = werte_dict["par2"]

            (success_sub, np_sma_array) = build_signal_ema(rd, signame, points, np_data_obj)
            if STATUS != hdef.OKAY:
                return

            if success_sub:
                np_data_obj.add_signal(np_sma_array, werte_dict["signal"])
                success = True
            else:
                STATUS = hdef.NOT_OKAY
                ERRTEXT = f"Der 2. Parameter von fkt: {rd.par.SIG_2PAR_EMA}({signame},{points}) ist nicht bekannt"
                return
            # end if
        case rd.par.SIG_TYPE_2PAR_MIN:

            signame = werte_dict["par1"]
            value = werte_dict["par2"]

            (success_sub,np_min_array) = build_signal_minmax(rd, signame, value, np_data_obj,True)
            if STATUS != hdef.OKAY:
                return

            if success_sub:
                np_data_obj.add_signal(np_min_array, werte_dict["signal"])
                success = True
            else:
                STATUS = hdef.NOT_OKAY
                ERRTEXT = f"Der 2. Parameter von fkt: {rd.par.SIG_2PAR_MIN}({signame},{value}) ist nicht bekannt"
                return
            # end if

        case rd.par.SIG_TYPE_2PAR_MAX:

            signame = werte_dict["par1"]
            value = werte_dict["par2"]

            (success_sub, np_max_array) = build_signal_minmax(rd, signame, value, np_data_obj, False)
            if STATUS != hdef.OKAY:
                return

            if success_sub:
                np_data_obj.add_signal(np_max_array, werte_dict["signal"])
                success = True
            else:
                STATUS = hdef.NOT_OKAY
                ERRTEXT = f"Der 2. Parameter von fkt: {rd.par.SIG_2PAR_MAX}({signame},{value}) ist nicht bekannt"
                return
            # end if
    # end match

    if success:
        if np_data_obj.get_status() != hdef.OKAY:
            STATUS = hdef.NOT_OKAY
            ERRTEXT = f"Fehler \n{np_data_obj.get_errtext()}"
        # end if
    # end if

    return (success, np_data_obj)
# end def
def get_3par_signal(rd, werte_dict, np_data_obj):
    """
    (success,np_data_obj) = get_3par_signal(rd, werte_dict, np_data_obj)
    """
    global STATUS, ERRTEXT
    success = False
    match werte_dict["type"]:
        #
        # SignalName3 = np_obj(isin,kurs)                     Kurswerte von einer anderen isin
        #                                                     gespeichrt wird:
        #                                                     "SignalName3_dat_array" und "SignalName3"
        case rd.par.SIG_TYPE_3PAR_VERGLEICH:
            signal1   = werte_dict["par1"]
            vergleich = werte_dict["par2"]
            signal2   = werte_dict["par3"]

            (success_sub, np_vergl_array) = build_signal_vergleich(rd, signal1, vergleich,signal2,np_data_obj)
            if STATUS != hdef.OKAY:
                return (success, np_data_obj)

            if success_sub:
                np_data_obj.add_signal(np_vergl_array, werte_dict["signal"])
                success = True
            else:
                STATUS = hdef.NOT_OKAY
                ERRTEXT = f"Der 2. Parameter von fkt: {rd.par.SIG_2PAR_VERGLEICH}({signal1},{vergleich},{signal2}) ist nicht bekannt"
                return (success, np_data_obj)
            # end if
    # end match

    if success:
        if np_data_obj.get_status() != hdef.OKAY:
            STATUS = hdef.NOT_OKAY
            ERRTEXT = f"scre_build_signal.get_3par_signal: \n{np_data_obj.get_errtext()}"
        # end if
    # end if

    return (success, np_data_obj)


# end def
def get_npar_signal(rd, werte_dict, np_data_obj):
    """
    (success,np_data_obj) = get_npar_signal(rd, werte_dict, np_data_obj)
    """
    global STATUS, ERRTEXT
    success = False
    match werte_dict["type"]:
        #
        # SignalName3 = np_obj(isin,kurs)                     Kurswerte von einer anderen isin
        #                                                     gespeichrt wird:
        #                                                     "SignalName3_dat_array" und "SignalName3"
        case rd.par.SIG_TYPE_NPAR_BEDINGUNG:
            signal_liste = []
            for name in ["par1", "par2", "par3", "par4", "par5"]:
                if len(werte_dict[name]):
                    signal_liste.append(werte_dict[name])


            (success_sub, np_bedingnung_array) = build_signal_bedingung(rd, signal_liste,np_data_obj)
            if STATUS != hdef.OKAY:
                return

            if success_sub:
                np_data_obj.add_signal(np_bedingnung_array, werte_dict["signal"])
                success = True
            else:
                STATUS = hdef.NOT_OKAY
                content = ""
                for name in ["par1", "par2", "par3", "par4", "par5"]:
                    if len(werte_dict[name]):
                        content += werte_dict[name]+ ","

                ERRTEXT = f"Der 2. Parameter von fkt: {rd.par.SIG_NPAR_BEDINGUNG}({content[0:-1]}) ist nicht bekannt"
                return
            # end if
    # end match

    if success:
        if np_data_obj.get_status() != hdef.OKAY:
            STATUS = hdef.NOT_OKAY
            ERRTEXT = f"scre_build_signal.get_npar_signal: \n{np_data_obj.get_errtext()}"
        # end if
    # end if

    return (success, np_data_obj)


# end def
def build_signal_datum(rd, signame,np_data_obj):
    """
    (success, np_dat_array, np_array) = build_signal_datum(rd, signame,np_data_obj)
    """

    global STATUS, ERRTEXT

    success = False
    np_dat_array = None


    if hasattr(np_data_obj, signame):

        if hasattr(np_data_obj, rd.par.SIG_STORE_DATUM ):
            np_dat_array = getattr(np_data_obj, rd.par.SIG_STORE_DATUM).copy()
        else:
            STATUS = hdef.NOT_OKAY
            ERRTEXT = f"Signal {signame} nicht bekannt im erstellten Datensatz !!"
            return (success, np_dat_array, np_dat_array)
        # end if


        success = True
    else:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"Signal {signame} nicht bekannt im erstellten Datensatz !!"
        return (success, np_dat_array, np_dat_array)
    # end if
    return (success, np_dat_array, np_dat_array)
# end def
def get_signal_fremd_isin(rd,fremd_isin,kurssignal,np_data_obj):
    """
    (success,np_array) = get_signal_fremd_isin(rd,fremd_isin,kurssignal)
    """
    global STATUS, ERRTEXT
    # Kursdaten für bestimmte fremd_isin holen
    (status, errtext, np_isin_obj) = rd.wpfunc.get_act_np_obj(fremd_isin)
    if (status != hdef.OKAY) or (np_isin_obj == None):
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"scre_build_signal: Für {fremd_isin = } konnte kein np_isin_obj erstellt werden \n{errtext = }"
        return (None,None)
    # end if

    # Datum in np_isin_obj prüfen
    if not hnpfkt.is_monoton_steigend(np_isin_obj.dat_np_array):
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"scre_build_signal:get_signal_fremd_isin: Für {fremd_isin = } ist np_isin_obj mit dem Datums-array nicht monoton steigend \n{errtext = }"
        return
    # end if


    success = False
    np_array = None
    # Kurs/Close
    match kurssignal:
        case rd.par.SIG_KURS | rd.par.SIG_CLOSE:
            np_array =  np_isin_obj.end_np_arra
            success = True
        case rd.par.SIG_OPEN:
            np_array =  np_isin_obj.start_np_array
            success = True
        case rd.par.SIG_HIGH:
            np_array =  np_isin_obj.high_np_array
            success = True
        case rd.par.SIG_LOW:
            np_array =  np_isin_obj.low_np_array
            success = True
        case rd.par.SIG_VOLUME:
            np_array =  np_isin_obj.volume_np_array
            success = True
        case rd.par.SIG_DATUM:
            np_array = np_isin_obj.datum_np_array
            success = True
    # end match

    if success:
        np_int_array =  hnpfkt.interpoliere(np_data_obj.dat_np_array,
                                            np_isin_obj.dat_np_array,
                                            np_array)
    else:
        np_int_array = None

    return (success, np_int_array)
#end def
def build_signal_lingrad(rd, signame, points,np_data_obj):
    """
    (success, n_np_array, y0_np_array, y1_np_array, rel_anstieg_np_array) = build_signal_lingrad(rd, signame, points,np_data_obj)
    """
    global STATUS, ERRTEXT

    success = False
    n_np_array = None
    y0_np_array = None
    y1_np_array = None
    rel_anstieg_np_array = None

    if hasattr(np_data_obj, signame):

        np_array = getattr(np_data_obj, signame)
        (n_np_array, y0_np_array, y1_np_array, rel_anstieg_np_array) = hnpfkt.lingrad(np_array, points, float(rd.par.SIG_ANZAHL_HANDELSTAGE_PRO_JAHR))
        success = True
    else:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"Signal {signame} nicht bekannt im erstellten Datensatz !!"
        return (success, n_np_array, y0_np_array, y1_np_array, rel_anstieg_np_array)
    # end if
    return (success, n_np_array, y0_np_array, y1_np_array, rel_anstieg_np_array)
# end def
def build_signal_sma(rd, signame, points, np_data_obj):
    """
    (success_sub,np_array) = build_signal_sma(rd, signame, points, np_data_obj)
    """
    global STATUS, ERRTEXT

    success = False
    np_sma_array = None

    if hasattr(np_data_obj, signame):

        np_array     = getattr(np_data_obj, signame)
        np_sma_array  = hnpfkt.sma(np_array,points)
        success = True
    else:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"Signal {signame} nicht bekannt im erstellten Datensatz !!"
        return (success, np_sma_array)
    # end if
    return (success, np_sma_array)
# end def
def build_signal_ema(rd, signame, points, np_data_obj):
    """
    (success_sub, np_array) = build_signal_sma(rd, signame, points, np_data_obj)
    """
    global STATUS, ERRTEXT

    success = False
    np_ema_array = None

    if hasattr(np_data_obj, signame):

        np_array     = getattr(np_data_obj, signame)
        np_ema_array  = hnpfkt.ema(np_array,points)
        success = True
    else:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"Signal {signame} nicht bekannt im erstellten Datensatz !!"
        return (success, np_ema_array)
    # end if
    return (success, np_ema_array)
# end def
def build_signal_minmax(rd, signame, value, np_data_obj,flagmin):
    """
    (success_sub, np_array) = build_signal_minmax(rd, signame, value, np_data_obj,flagmin)
    """
    global STATUS, ERRTEXT

    success = False
    np_minmax_array = None
    np_dat_array = None

    if hasattr(np_data_obj, signame):

        np_array     = getattr(np_data_obj, signame)

        if flagmin:
            np_minmax_array  = hnpfkt.minvalue(np_array,value)
        else:
            np_minmax_array = hnpfkt.maxvalue(np_array,value)
        # end if
        success = True
    else:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"Signal {signame} nicht bekannt im erstellten Datensatz !!"
        return (success, np_minmax_array)
    # end if
    return (success, np_minmax_array)
# end def
def build_signal_vergleich(rd, signal1, vergleich,signal2,np_data_obj):
    """
    (success_sub, np_vergl_array) = build_signal_vergleich(rd, signal1, vergleich, signal2, np_data_obj)
    """
    global STATUS, ERRTEXT

    success = False
    np_vergl_array = None

    if not hasattr(np_data_obj, rd.par.SIG_STORE_DATUM):
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"Signal {rd.par.SIG_STORE_DATUM} nicht bekannt im erstellten Datensatz !!"
        return (success, np_vergl_array)
    else:
        np_dat_array = getattr(np_data_obj, rd.par.SIG_STORE_DATUM)
    # end if

    if not hasattr(np_data_obj, signal1):
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"Signal {signal1} nicht bekannt im erstellten Datensatz !!"
        return (success, np_vergl_array)
    else:
        np1_array     = getattr(np_data_obj, signal1)
    # end if

    if not hasattr(np_data_obj, signal2):
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"Signal {signal2} nicht bekannt im erstellten Datensatz !!"
        return (success, np_vergl_array)
    else:
        np2_array     = getattr(np_data_obj, signal2)
    # end if

    (status,errtext,np_dat_array,np_vergl_array) = hnpfkt.vergleich(np_dat_array,np1_array,vergleich,np_dat_array,np2_array)

    if status == hdef.NOT_OKAY:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = errtext
        return (success, np_vergl_array)
    else:
        success = True
    # end if

    return (success, np_vergl_array)
# end def
def build_signal_bedingung(rd, signal_liste,np_data_obj):
    """
    (success_sub, np_bedignung_array) = build_signal_vergleich(rd, signal1, vergleich, signal2, np_data_obj)
    """
    global STATUS, ERRTEXT

    success = False
    np_bedignung_array = None
    np_dat_array = None

    if hasattr(np_data_obj, rd.par.SIG_STORE_DATUM):
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"Signal {rd.par.SIG_STORE_DATUM} nicht bekannt im erstellten Datensatz !!"
        return (success, np_bedignung_array)
    else:
        np_dat_array = getattr(np_data_obj, rd.par.SIG_STORE_DATUM)
    # end if

    np_dat_array_liste = []
    np_array_liste = []
    for signal in signal_liste:

        if not hasattr(np_data_obj, signal):
            STATUS = hdef.NOT_OKAY
            ERRTEXT = f"Signal {signal} nicht bekannt im erstellten Datensatz !!"
            return (success, np_dat_array, np_bedignung_array)
        # end if

        np_array     = getattr(np_data_obj, signal).copy()

        np_dat_array_liste.append(np_dat_array)
        np_array_liste.append(np_array)
    # end if

    (status,errtext,np_dat_array,np_bedignung_array) = hnpfkt.bedigung(np_dat_array_liste,np_array_liste)

    if status == hdef.NOT_OKAY:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = errtext
        return (success, np_bedignung_array)
    else:
        success = True

    return (success, np_bedignung_array)
# end def
def get_dataclass_filename(rd,isin):

    filename = os.path.join(rd.ini["store_path"],rd.ini["scre_dataclass_pre_file_name"] + isin + ".joblib")
    return filename
# end def
def proof_if_data_uptodate(rd, isin):
    """
    flag = proof_if_data_uptodate(rd,isin)
    """
    global STATUS, ERRTEXT

    filename = get_dataclass_filename(rd, isin)
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



    # Kursdaten für vorggegbene isin holen
    (status, errtext, np_isin_obj) = rd.wpfunc.get_act_price_volume_np_obj(isin)
    if (status != hdef.OKAY) or (np_isin_obj is None):
        return False
    # end if
    if np_isin_obj.dat_np_array is None:
        return False
    # end if

    half_day = 60*60*12
    if (np_isin_obj.dat_np_array[-1] - np_dat_obj_array[-1]) > half_day:
        return False
    # end if

    for signal in rd.sig["sigset_signaldef_liste"]:
        if signal not in np_data_obj.signal_list:
            return False
        # end if
    # end for

    return True
# end def
# def scre_build_rankmax(rd,isin_liste,werte_dict):
#
#
#     signalname = werte_dict["par1"]
#
#     sigval_liste = []
#     for isin in isin_liste:
#
#         sigval = get_single_data_value_np_data(rd,isin,-1) #####
#         sigval_liste.append(sival)
#
#         filename = rd.scre["scre_isin_dataclass_filename_dict"][isin]
#         np_data_obj = hnp_dataclass.NpDataHandlingClass(filename)
#         np_data_obj.read()

