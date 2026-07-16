
import os, sys, copy, re

import wp_screen_param

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_str as hstr
# import tools.hfkt_tvar as htvar
import tools.hfkt_type as htype

STATUS   = hdef.OKAY
ERRTEXT  = ""
INFOTEXT = ""
ZEILE    = 0

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

def check(rd,ddict):
    """
    check dicctionary signal definition set
    :param rd:
    :param ddict:
    :return: okay = check(rd,ddict)
    """
    global INFOTEXT
    global ZEILE
    signaldef_liste = []
    rd.sig["sigset_werte_dict_liste"] = []

    for i,key in enumerate(ddict.keys()):
        ZEILE = i+1

        # check signalname
        if key == rd.par.SIG_STORE_DATUM:
            INFOTEXT = f"Als Signalname darf signame={ wp_screen_param.SIG_STORE_DATUM} nicht benutzt werden !!"
            return (hdef.NOT_OKAY, INFOTEXT)
        # end if

        werte_dict = {"signal":key}
        if check_content(rd.par,ddict[key],signaldef_liste,werte_dict) != hdef.OKAY:
            return  (hdef.NOT_OKAY,INFOTEXT)
        else:
            if key in signaldef_liste:
                index = signaldef_liste.index(key)
                INFOTEXT = f"Signalname {key} {i+1}. Definition ist bereits in der {index+1}. Definition gemacht worden!!!"
                return (hdef.NOT_OKAY, INFOTEXT)
            else:
                signaldef_liste.append(key)
            # end if

            rd.sig["sigset_werte_dict_liste"].append(werte_dict)
        # end if
    # end for


    return (hdef.OKAY,"")
# end def
def check_content(par,content,signaldef_liste,werte_dict):

    content = hstr.elim_ae_liste(content, [" ", "\t"])

    (status,type,fkt) =  check_content_0par(par,content)
    if status == hdef.OKAY:
        werte_dict["type"] = type
        werte_dict["fkt"] = fkt
    else:
        return check_content_2par(par,content,signaldef_liste,werte_dict)
    # end if
    return hdef.OKAY
# end def
def check_content_0par(par,content):
    """
    :param par:
    :param content:
    :return: (status,type,fkt) =  check_content_0par(content)
    """
    type = 0
    fkt = ""
    status = hdef.OKAY
    if content[0] == par.SIG_NULL:
        type=par.SIG_TYPE_NULL
        fkt=par.SIG_NULL
    elif content == par.SIG_KURS:
        type=par.SIG_TYPE_KURS
        fkt=par.SIG_KURS
    elif content == par.SIG_CLOSE:
        type=par.SIG_TYPE_CLOSE
        fkt=par.SIG_CLOSE
    elif content == par.SIG_OPEN:
        type=par.SIG_TYPE_OPEN
        fkt=par.SIG_OPEN
    elif content == par.SIG_HIGH:
        type=par.SIG_TYPE_HIGH
        fkt=par.SIG_HIGH
    elif content == par.SIG_LOW:
        type=par.SIG_TYPE_LOW
        fkt=par.SIG_LOW
    elif content == par.SIG_VOLUME:
        type=par.SIG_TYPE_VOLUME
        fkt=par.SIG_VOLUME
    else:
        status = hdef.NOT_OKAY
    # end if

    return (status,type,fkt)
# end def
def check_content_2par(par,content,signaldef_liste,werte_dict):

    t = copy.copy(content)
    # muster = r"(\w+)\((\w+),(\w+)\)"
    muster = r"(\w+)\(([^,)]+),([^,)]+)\)"

    tupel_liste = re.findall(muster, t.replace(" ",""))

    if len(tupel_liste) > 0:
        return check_content_2par_tuple(par,tupel_liste[0][0],tupel_liste[0][1],tupel_liste[0][2],signaldef_liste,werte_dict)
    else:
        return check_content_3par(par, content, signaldef_liste,werte_dict)
    # end if
# end ofr
def check_content_2par_tuple(par,fkt,par1,par2,signaldef_liste,werte_dict):

    global INFOTEXT
    global ZEILE
    if fkt == par.SIG_2PAR_NP_OBJ:

        # par1: isin, par2: kurs,close, etc
        (status,isin) = htype.type_proof_isin(par1)
        if status != hdef.OKAY:
            INFOTEXT = f"Im sigset zeile:{ZEILE}, (Anweisung: \"={fkt}({par1},{par2})\") ist erster Parameter isin = {par1} falsch "
            return status
        # end if
        (status, type, fkt) = check_content_0par(par, par2)
        if status != hdef.OKAY:
            INFOTEXT = f"Im sigset zeile:{ZEILE}, (Anweisung: \"={fkt}({par1},{par2})\") ist zweiter Parameter fkt = {par2} nicht in der Liste gefunden worden "
            return status
        # end if
        werte_dict["type"]=par.SIG_TYPE_2PAR_NP_OBJ
        werte_dict["fkt"]=par.SIG_2PAR_NP_OBJ
        werte_dict["par1"]=isin
        werte_dict["par2"]=fkt

    elif fkt == par.SIG_2PAR_LINGRAD:

        # par1: signal, par2: n
        if par1 not in signaldef_liste:
            INFOTEXT = f"Im sigset zeile:{ZEILE}, (Anweisung: \"={fkt}({par1},{par2})\") ist erster Parameter signal = {par1} nicht davor definiert worden "
            return hdef.NOT_OKAY
        # end if
        (status, nint) = htype.type_proof_int(par2)
        if status != hdef.OKAY:
            INFOTEXT = f"Im sigset zeile:{ZEILE}, (Anweisung: \"={fkt}({par1},{par2})\") ist zweiter Parameter n = {par2} nicht in integer wandelbar "
            return status
        # end if
        werte_dict["type"]=par.SIG_TYPE_2PAR_LINGRAD
        werte_dict["fkt"]=par.SIG_2PAR_LINGRAD
        werte_dict["par1"]=par1
        werte_dict["par2"]=abs(nint)

    elif fkt == par.SIG_2PAR_SMA:

        # par1: signal, par2: n
        # par1: signal, par2: n
        if par1 not in signaldef_liste:
            INFOTEXT = f"Im sigset zeile:{ZEILE}, (Anweisung: \"={fkt}({par1},{par2})\") ist erster Parameter signal = {par1} nicht davor definiert worden "
            return hdef.NOT_OKAY
        # end if
        (status, nint) = htype.type_proof_int(par2)
        if status != hdef.OKAY:
            INFOTEXT = f"Im sigset zeile:{ZEILE}, (Anweisung: \"={fkt}({par1},{par2})\") ist zweiter Parameter n = {par2} nicht in integer wandelbar "
            return status
        # end if
        werte_dict["type"]=par.SIG_TYPE_2PAR_SMA
        werte_dict["fkt"]=par.SIG_2PAR_SMA
        werte_dict["par1"]=par1
        werte_dict["par2"]=abs(nint)

    elif fkt == par.SIG_2PAR_EMA:

        # par1: signal, par2: n
        if par1 not in signaldef_liste:
            INFOTEXT = f"Im sigset zeile:{ZEILE}, (Anweisung: \"={fkt}({par1},{par2})\") ist erster Parameter signal = {par1} nicht davor definiert worden "
            return hdef.NOT_OKAY
        # end if
        (status, nint) = htype.type_proof_int(par2)
        if status != hdef.OKAY:
            INFOTEXT = f"Im sigset zeile:{ZEILE}, (Anweisung: \"={fkt}({par1},{par2})\") ist zweiter Parameter n = {par2} nicht in integer wandelbar "
            return status
        # end if
        werte_dict["type"] = par.SIG_TYPE_2PAR_EMA
        werte_dict["fkt"] = par.SIG_2PAR_EMA
        werte_dict["par1"] = par1
        werte_dict["par2"] = abs(nint)
    # end if
    return hdef.OKAY
# end def
def check_content_3par(par,content,signaldef_liste,werte_dict):

    t = copy.copy(content)

    # muster = r"(\w+)\((\w+),(\w+),(\w+)\)"
    muster = r"(\w+)\(([^,)]+),([^,)]+),([^,)]+)\)"

    tupel_liste = re.findall(muster, t.replace(" ",""))

    if len(tupel_liste) > 0:
        return check_content_3par_tuple(par, tupel_liste[0][0], tupel_liste[0][1], tupel_liste[0][2], tupel_liste[0][3], signaldef_liste,werte_dict)
    else:
        global INFOTEXT
        INFOTEXT = f"Der Kontent {content} konnte nicht erkannt werden"
        return hdef.NOT_OKAY
    # end if

# end def
def  check_content_3par_tuple(par,fkt,par1,par2,par3,signaldef_liste, werte_dict):
    global INFOTEXT
    global ZEILE

    if fkt == par.SIG_3PAR_VERGLEICH:

        # par1: signal1, par2: <,>, ... par3: signal2
        if par1 not in signaldef_liste:
            INFOTEXT = f"Im sigset zeile:{ZEILE}, (Anweisung: \"={fkt}({par1},{par2},{par3})\") ist erster Parameter signal = {par1} nicht davor definiert worden "
            return hdef.NOT_OKAY
        # end if
        if par2 not in [">","<",">=","<="]:
            INFOTEXT = f"Im sigset zeile:{ZEILE}, (Anweisung: \"={fkt}({par1},{par2},{par3})\") ist zweite Parameter Vergleichsvorschrift = {par2} nicht richtig definiert (>,<,>=,<=) "
            return hdef.NOT_OKAY
        # end if
        if par3 not in signaldef_liste:
            INFOTEXT = f"Im sigset zeile:{ZEILE}, (Anweisung: \"={fkt}({par1},{par2},{par3})\") ist dritte Parameter signal = {par3} nicht davor definiert worden "
            return hdef.NOT_OKAY
        # end if
        werte_dict["type"] = par.SIG_TYPE_3PAR_VERGLEICH
        werte_dict["fkt"] = par.SIG_3PAR_VERGLEICH
        werte_dict["par1"] = par1
        werte_dict["par2"] = par2
        werte_dict["par3"] = par3
    # end if
    return hdef.OKAY
# end def
def hilfe(rd):
    """

    SignalName0 = 0                                     Signal wird ignoriert
    SignalName1 = kurs                                  Kurs=Close-Signal
    SignalName2 = close/open/high/low/volume            Chart-Werte
    SignalName3 = np_obj(isin,kurs)                     Kurswerte von einer anderen isin
                                                        gespeichrt wird:
                                                        "SignalName3_dat_array" und "SignalName3"
    SignalName4 = lingrad(SignalName1,20)               Linearer Gerade aus SignalName1 mit 20 Punkten
                                                        gespeichert wird:
                                                        "SignalName4_dat_array" und "SignalName4" sowie "SignalName4_grad" (Einzelwert)
    SignalName5 = sma(SignalName1,200)                  simple moving avarage  aus SignalName1 mit 200 Punkten
                                                        gespeichert wird:
                                                        "SignalName5_dat_array" (wenn aus fremd-signal) und "SignalName5"
    SignalName6 = ema(SignalName1,20)                   exponential moving avarage  aus SignalName1 mit 20 Punkten
                                                        gespeichert wird:
                                                        "SignalName6_dat_array" (wenn aus fremd-signal) und "SignalName6"
    SignalName7 = vergleich(SignalName1,<,SignalName2)  vergleich  SignalName1 und SignalName2 hier SignalName1 < SignalName2
                                                        wahr wird = 1 gesetzt und unwahr = 0
                                                        gespeichert wird:
                                                        "SignalName7_dat_array" (wenn aus fremd-signal) und "SignalName7"

    :param rd:
    :return: infotext = hilfe(rd)
    """
    infotext = ""

    for i in range(10):
        match i:
            case 0:
                val1 = rd.par.SIG_NULL
                val2 = "Signal wird ignoriert"
            case 1:
                val1 = rd.par.SIG_KURS
                val2 = f"kursabfrage: {rd.par.SIG_CLOSE},{rd.par.SIG_OPEN},{rd.par.SIG_HIGH},{rd.par.SIG_LOW}"
            case 2:
                val1 = rd.par.SIG_VOLUME
                val2 = "Volumenabfrage"
            case 3:
                val1 = f"{rd.par.SIG_2PAR_NP_OBJ}(isin,{rd.par.SIG_KURS})"
                val2 = f"Kurs von einer bestimmten isin, {rd.par.SIG_KURS} = {rd.par.SIG_CLOSE}"
            case 4:
                val1 = f"{rd.par.SIG_2PAR_LINGRAD}(signal,Anzahl/Tage)"
                val2 = f"linearer Gradient für Signal (muss definiert sein) und Anzahl von Punkten/Tage"
            case 5:
                val1 = f"{rd.par.SIG_2PAR_SMA}(signal,Anzahl/Tage)"
                val2 = f"simple moving avarage für Signal (muss definiert sein) und Anzahl von Punkten/Tage"
            case 6:
                val1 = f"{rd.par.SIG_2PAR_EMA}(signal,Anzahl/Tage)"
                val2 = f"exponential moving avarage für Signal (muss definiert sein) und Anzahl von Punkten/Tage"
            case 7:
                val1 = f"{rd.par.SIG_3PAR_VERGLEICH}(signal1,>,signal2)"
                val2 = f"Vergleich zweier Signale (müssen definiert sein) und Vorschrif >,<,>=,<="
            case _:
                break
        # end match

        if i == 0:
            infotext += format_text(val1,val2,rd.par.SIG_COMMENT)
        else:
            infotext += "\n" + format_text(val1,val2,rd.par.SIG_COMMENT)

    # end for
    return infotext
# end def
def format_text(val1,val2,comment):
    n1 = 35
    n2 = 20
    text = f"= {val1:<{n1}}{comment} {val2:<{n2}}"
    return text
# end def