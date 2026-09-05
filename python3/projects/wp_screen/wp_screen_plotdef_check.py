
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
    plotdef_liste = []
    rd.plot["plotdef_werte_dict_liste"] = []

    for i,key in enumerate(ddict.keys()):
        ZEILE = i+1

        # check signalname
        if key == rd.par.SIG_STORE_DATUM:
            INFOTEXT = f"Als Signalname darf signame={ wp_screen_param.SIG_STORE_DATUM} nicht benutzt werden !!"
            return (hdef.NOT_OKAY, INFOTEXT)
        # end if

        werte_dict = {"signal":key}
        if check_content(rd,ddict[key],plotdef_liste,werte_dict) != hdef.OKAY:
            return  (hdef.NOT_OKAY,INFOTEXT)
        else:
            if key in plotdef_liste:
                index = plotdef_liste.index(key)
                INFOTEXT = f"Signalname {key} {i+1}. Definition ist bereits in der {index+1}. Definition gemacht worden!!!"
                return (hdef.NOT_OKAY, INFOTEXT)
            else:
                plotdef_liste.append(key)
            # end if

            rd.plot["plotdef_werte_dict_liste"].append(werte_dict)
        # end if
    # end for
    rd.plot["plotdef_signaldef_liste"] = plotdef_liste

    return (hdef.OKAY,"")
# end def
def check_content(rd,content,plotdef_liste,werte_dict):

    content = hstr.elim_ae_liste(content, [" ", "\t"])

    status = check_content_npar(rd.par, content, plotdef_liste, werte_dict)

    if status == hdef.OKAY:
        return status

    (status,type,fkt) =  check_content_0par(rd,content)

    if status == hdef.OKAY:
        werte_dict["type"] = type
        werte_dict["fkt"]  = fkt
        return status
    # end if

    status = check_content_1par(rd.par,content,plotdef_liste,werte_dict)

    if status == hdef.OKAY:
        return status

    status = check_content_2par(rd.par, content, plotdef_liste, werte_dict)

    if status == hdef.OKAY:
        return status

    status = check_content_3par(rd.par, content, plotdef_liste,werte_dict)

    return status
# end def
def check_content_0par(rd,content):
    """
    :param par:
    :param content:
    :return: (status,type,fkt) =  check_content_0par(par,content)
    """
    type = 0
    fkt = ""
    status = hdef.OKAY
    if content[0] == rd.par.SIG_NULL:
        type=rd.par.SIG_TYPE_NULL
        fkt=rd.par.SIG_NULL
    elif content == rd.par.SIG_KURS:
        type=rd.par.SIG_TYPE_KURS
        fkt=rd.par.SIG_KURS
    elif content == rd.par.SIG_CLOSE:
        type=rd.par.SIG_TYPE_CLOSE
        fkt=rd.par.SIG_CLOSE
    elif content == rd.par.SIG_OPEN:
        type=rd.par.SIG_TYPE_OPEN
        fkt=rd.par.SIG_OPEN
    elif content == rd.par.SIG_HIGH:
        type=rd.par.SIG_TYPE_HIGH
        fkt=rd.par.SIG_HIGH
    elif content == rd.par.SIG_LOW:
        type=rd.par.SIG_TYPE_LOW
        fkt=rd.par.SIG_LOW
    elif content == rd.par.SIG_VOLUME:
        type = rd.par.SIG_TYPE_VOLUME
        fkt = rd.par.SIG_VOLUME
    elif content == rd.par.SIG_DATUM:
        type = rd.par.SIG_TYPE_DATUM
        fkt = rd.par.SIG_DATUM
    elif rd.wpfunc.is_an_indice(content):
        type = rd.par.SIG_TYPE_INIDICE
        fkt = content
    else:
        status = hdef.NOT_OKAY
    # end if

    return (status,type,fkt)
# end def
def check_content_npar(par,content,plotdef_liste,werte_dict):

    index1 = content.find(par.SIG_NPAR_BEDINGUNG)

    if index1 == 0:

        t = copy.copy(content)
        muster = r"\((.*?)\)"
        tupel_liste = re.findall(muster, t.replace(" ", ""))

        if len(tupel_liste) > 0:
            return check_content_npar_tuple(par,par.SIG_NPAR_BEDINGUNG,tupel_liste[0][0],plotdef_liste,werte_dict)
    # end if

    return hdef.NOT_OKAY
# end def
def check_content_npar_tuple(par,fkt,content,plotdef_liste,werte_dict):

    global INFOTEXT
    global ZEILE

    if fkt == par.SIG_NPAR_BEDINGUNG:

        sig_list = content.split(',')

        if len(sig_list) > 5:
            INFOTEXT = f"Im plotdef zeile:{ZEILE}, (Anweisung: \"={fkt}({content})\") sind mehr als 5 Parameter gefunden worden!!!"
            return hdef.NOT_OKAY
        elif len(sig_list) == 0:
            INFOTEXT = f"Im plotdef zeile:{ZEILE}, (Anweisung: \"={fkt}({content})\") sind kein Parameter gefunden worden!!!"
            return hdef.NOT_OKAY
        else:
            werte_dict["par1"] = ""
            werte_dict["par2"] = ""
            werte_dict["par3"] = ""
            werte_dict["par4"] = ""
            werte_dict["par5"] = ""
            for i,plot in enumerate(sig_list):

                plot = hstr.elim_ae_liste(plot, [" ", "\t"])

                if plot not in plotdef_liste:
                    INFOTEXT = f"Im plotdef zeile:{ZEILE}, (Anweisung: \"={fkt}({content})\") ist erster Parameter signal = {plot} nicht davor definiert worden "
                    return hdef.NOT_OKAY
                # end if

                if i == 0:
                    werte_dict["par1"] = plot
                elif i == 1:
                    werte_dict["par2"] = plot
                elif i == 2:
                    werte_dict["par3"] = plot
                elif i == 3:
                    werte_dict["par4"] = plot
                elif i == 4:
                    werte_dict["par5"] = plot
                # end if
            # end for
            werte_dict["type"] = par.SIG_TYPE_NPAR_BEDINGUNG
            werte_dict["fkt"] = par.SIG_NPAR_BEDINGUNG
        # end if
    else:

        INFOTEXT = f"Im plotdef zeile:{ZEILE}, (Anweisung: \"={fkt}({content})\") ist Parameter Funktion:{fkt} nicht definiert"
        return hdef.NOT_OKAY
    # end if
    return hdef.OKAY
# end def
def check_content_1par(par,content,plotdef_liste,werte_dict):

    t = copy.copy(content)

    muster = r"(\w+)\(([^,)]+)\)"

    tupel_liste = re.findall(muster, t.replace(" ",""))

    if len(tupel_liste) > 0:
        return check_content_1par_tuple(par,tupel_liste[0][0],tupel_liste[0][1],plotdef_liste,werte_dict)
    # end if
    return hdef.NOT_OKAY
# end def
def check_content_1par_tuple(par,fkt,par1,plotdef_liste,werte_dict):

    global INFOTEXT
    global ZEILE


    INFOTEXT = f"Im plotdef zeile:{ZEILE}, (Anweisung: \"={fkt}({par1})\") ist Parameter Funktion:{fkt} nicht definiert"
    return hdef.NOT_OKAY
# end def
def check_content_2par(par,content,plotdef_liste,werte_dict):

    t = copy.copy(content)
    # muster = r"(\w+)\((\w+),(\w+)\)"
    muster1 = r"(\w+)\(([^,)]+),([^,)]+)\)"

    tupel_liste1 = re.findall(muster1, t.replace(" ",""))

    if len(tupel_liste1) > 0:
        return check_content_2par_tuple(par,tupel_liste1[0][0],tupel_liste1[0][1],tupel_liste1[0][2],plotdef_liste,werte_dict)
    # end if

    return hdef.NOT_OKAY
# end def
def check_content_2par_tuple(par,fkt,par1,par2,plotdef_liste,werte_dict):

    global INFOTEXT
    global ZEILE
    if fkt == par.SIG_2PAR_NP_OBJ:

        # par1: isin, par2: kurs,close, etc
        (status,isin) = htype.type_proof_isin(par1)
        if status != hdef.OKAY:
            INFOTEXT = f"Im plotdef zeile:{ZEILE}, (Anweisung: \"={fkt}({par1},{par2})\") ist erster Parameter isin = {par1} falsch "
            return status
        # end if
        (status, type, fkt) = check_content_0par(par, par2)
        if status != hdef.OKAY:
            INFOTEXT = f"Im plotdef zeile:{ZEILE}, (Anweisung: \"={fkt}({par1},{par2})\") ist zweiter Parameter fkt = {par2} nicht in der Liste gefunden worden "
            return status
        # end if
        werte_dict["type"]=par.SIG_TYPE_2PAR_NP_OBJ
        werte_dict["fkt"]=par.SIG_2PAR_NP_OBJ
        werte_dict["par1"]=isin
        werte_dict["par2"]=fkt

    elif fkt == par.SIG_2PAR_LINGRAD:

        # par1: signal, par2: n
        if par1 not in plotdef_liste:
            INFOTEXT = f"Im plotdef zeile:{ZEILE}, (Anweisung: \"={fkt}({par1},{par2})\") ist erster Parameter signal = {par1} nicht davor definiert worden "
            return hdef.NOT_OKAY
        # end if
        (status, nint) = htype.type_proof_int(par2)
        if status != hdef.OKAY:
            INFOTEXT = f"Im plotdef zeile:{ZEILE}, (Anweisung: \"={fkt}({par1},{par2})\") ist zweiter Parameter n = {par2} nicht in integer wandelbar "
            return status
        # end if
        werte_dict["type"]=par.SIG_TYPE_2PAR_LINGRAD
        werte_dict["fkt"]=par.SIG_2PAR_LINGRAD
        werte_dict["par1"]=par1
        werte_dict["par2"]=abs(nint)

    elif fkt == par.SIG_2PAR_SMA:

        # par1: signal, par2: n
        # par1: signal, par2: n
        if par1 not in plotdef_liste:
            INFOTEXT = f"Im plotdef zeile:{ZEILE}, (Anweisung: \"={fkt}({par1},{par2})\") ist erster Parameter signal = {par1} nicht davor definiert worden "
            return hdef.NOT_OKAY
        # end if
        (status, nint) = htype.type_proof_int(par2)
        if status != hdef.OKAY:
            INFOTEXT = f"Im plotdef zeile:{ZEILE}, (Anweisung: \"={fkt}({par1},{par2})\") ist zweiter Parameter n = {par2} nicht in integer wandelbar "
            return status
        # end if
        werte_dict["type"]=par.SIG_TYPE_2PAR_SMA
        werte_dict["fkt"]=par.SIG_2PAR_SMA
        werte_dict["par1"]=par1
        werte_dict["par2"]=abs(nint)

    elif fkt == par.SIG_2PAR_EMA:

        # par1: signal, par2: n
        if par1 not in plotdef_liste:
            INFOTEXT = f"Im plotdef zeile:{ZEILE}, (Anweisung: \"={fkt}({par1},{par2})\") ist erster Parameter signal = {par1} nicht davor definiert worden "
            return hdef.NOT_OKAY
        # end if
        (status, nint) = htype.type_proof_int(par2)
        if status != hdef.OKAY:
            INFOTEXT = f"Im plotdef zeile:{ZEILE}, (Anweisung: \"={fkt}({par1},{par2})\") ist zweiter Parameter n = {par2} nicht in integer wandelbar "
            return status
        # end if
        werte_dict["type"] = par.SIG_TYPE_2PAR_EMA
        werte_dict["fkt"] = par.SIG_2PAR_EMA
        werte_dict["par1"] = par1
        werte_dict["par2"] = abs(nint)

    elif fkt == par.SIG_2PAR_MAX:

        # par1: signal, par2: n
        if par1 not in plotdef_liste:
            INFOTEXT = f"Im plotdef zeile:{ZEILE}, (Anweisung: \"={fkt}({par1},{par2})\") ist erster Parameter signal = {par1} nicht davor definiert worden "
            return hdef.NOT_OKAY
        # end if
        (status, val) = htype.type_proof_float(par2)
        if status != hdef.OKAY:
            INFOTEXT = f"Im plotdef zeile:{ZEILE}, (Anweisung: \"={fkt}({par1},{par2})\") ist zweiter Parameter n = {par2} nicht in float wandelbar "
            return status
        # end if
        werte_dict["type"] = par.SIG_TYPE_2PAR_MAX
        werte_dict["fkt"] = par.SIG_2PAR_MAX
        werte_dict["par1"] = par1
        werte_dict["par2"] = val
    elif fkt == par.SIG_2PAR_MIN:

        # par1: signal, par2: n
        if par1 not in plotdef_liste:
            INFOTEXT = f"Im plotdef zeile:{ZEILE}, (Anweisung: \"={fkt}({par1},{par2})\") ist erster Parameter signal = {par1} nicht davor definiert worden "
            return hdef.NOT_OKAY
        # end if
        (status, val) = htype.type_proof_float(par2)
        if status != hdef.OKAY:
            INFOTEXT = f"Im plotdef zeile:{ZEILE}, (Anweisung: \"={fkt}({par1},{par2})\") ist zweiter Parameter n = {par2} nicht in float wandelbar "
            return status
        # end if
        werte_dict["type"] = par.SIG_TYPE_2PAR_MIN
        werte_dict["fkt"] = par.SIG_2PAR_MIN
        werte_dict["par1"] = par1
        werte_dict["par2"] = val
    else:

        INFOTEXT = f"Im plotdef zeile:{ZEILE}, (Anweisung: \"={fkt}({par1},{par2})\") ist Parameter Funktion:{fkt} nicht definiert"
        return hdef.NOT_OKAY
    # end if
    return hdef.OKAY
# end def
def check_content_3par(par,content,plotdef_liste,werte_dict):

    t = copy.copy(content)

    # muster = r"(\w+)\((\w+),(\w+),(\w+)\)"
    muster = r"(\w+)\(([^,)]+),([^,)]+),([^,)]+)\)"

    tupel_liste = re.findall(muster, t.replace(" ",""))

    if len(tupel_liste) > 0:
        return check_content_3par_tuple(par, tupel_liste[0][0], tupel_liste[0][1], tupel_liste[0][2], tupel_liste[0][3], plotdef_liste,werte_dict)
    else:
        global INFOTEXT
        INFOTEXT = f"Der Kontent {content} konnte nicht erkannt werden"
        return hdef.NOT_OKAY
    # end if

# end def
def  check_content_3par_tuple(par,fkt,par1,par2,par3,plotdef_liste, werte_dict):
    global INFOTEXT
    global ZEILE

    if fkt == par.SIG_3PAR_VERGLEICH:

        # par1: signal1, par2: <,>, ... par3: signal2
        if par1 not in plotdef_liste:
            INFOTEXT = f"Im plotdef zeile:{ZEILE}, (Anweisung: \"={fkt}({par1},{par2},{par3})\") ist erster Parameter signal = {par1} nicht davor definiert worden "
            return hdef.NOT_OKAY
        # end if
        if par2 not in [">","<",">=","<=","==","!="]:
            INFOTEXT = f"Im plotdef zeile:{ZEILE}, (Anweisung: \"={fkt}({par1},{par2},{par3})\") ist zweite Parameter Vergleichsvorschrift = {par2} nicht richtig definiert (>,<,>=,<=) "
            return hdef.NOT_OKAY
        # end if
        if par3 not in plotdef_liste:
            INFOTEXT = f"Im plotdef zeile:{ZEILE}, (Anweisung: \"={fkt}({par1},{par2},{par3})\") ist dritte Parameter signal = {par3} nicht davor definiert worden "
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
    PlotName0   = SignalName(color=white,linewidth=1,linestyle=-,marker=o)
    :param rd:
    :return: infotext = hilfe(rd)
    """
    infotext = f"Hilfe für plotdef\n\nSyntax: PlotName = Kontext, für Kontext kann stehen:\n\n"

    for i in range(10):
        match i:
            case 0:
                val1 = "SignalName"
                val2 = "Ein Signal aus sigset"
            case 1:
                val1 = "SignalName(color=white)"
                val2 = f"Farbe: (default='k') 'b', 'g', 'r', 'c', 'm', 'y', 'k', 'w', 'white', ... "
            case 2:
                val1 = "SignalName(linewidth=3)"
                val2 = "Liniendicke (default=1)"
            case 3:
                val1 = "SignalName(linestyle=-)"
                val2 = "Linetype (default=-) '--', '-.', ':', '' "
            case 4:
                val1 = "SignalName(marker='')"
                val2 = "marker (default=''), '.', 'o', 'd', 'v', '^', '>', '<', ..."
            case _:
                pass
        # end match

        if i == 0:
            infotext += format_text(val1,val2,rd.par.SIG_COMMENT,i)
        else:
            infotext += "\n" + format_text(val1,val2,rd.par.SIG_COMMENT,i)

    # end for
    return infotext
# end def
def format_text(val1,val2,comment,i):
    n1 = 35
    n2 = 20
    text = f"PlotName{i+1:02d} = {val1:<{n1}}{comment} {val2:<{n2}}"
    return text
# end def