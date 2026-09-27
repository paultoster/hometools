
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

        werte_dict = {"plotsignal":key}
        if check_content(rd,ddict[key],werte_dict) != hdef.OKAY:
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
def check_content(rd,content,werte_dict):

    content = hstr.elim_ae_liste(content, [" ", "\t"])

    t = copy.copy(content)

    muster = r"(\w+)\("
    tupel_liste = re.findall(muster, t.replace(" ", ""))

    if len(tupel_liste) > 0:

        sig_name = tupel_liste[0][0]
        werte_dict["signal"] = sig_name

        muster = r"\((.*?)\)"    # r"([^(),]+)(?:,|(?=\)))"
        tupel_liste = re.findall(muster, t.replace(" ", ""))

        if len(tupel_liste) > 0:
            item_list = tupel_liste[0][0].split(',')
            return check_content_tuple(rd.par,sig_name,item_list,werte_dict)
        # end if
    # end if

    return hdef.NOT_OKAY
# end def
def check_content_tuple(par,sig_name,item_list,werte_dict):

    global INFOTEXT
    global ZEILE

    # SignalName(subplot=x, height_rows=x, color=c, linewidth=y, linestyle=z, marker=m)"

    if len(item_list) > 6:
        INFOTEXT = f"Im plotdef zeile:{ZEILE}, (Anweisung: \"={sig_name}({item_list})\") sind mehr als 5 Parameter gefunden worden!!!"
        return hdef.NOT_OKAY
    else:
        liste = ["subplot","height_rows","color","linewidth","marker"]
        werte_dict["subplot"] = 1
        werte_dict["height_rows"] = 1
        werte_dict["color"] = "k"
        werte_dict["linewidth"] = 1
        werte_dict["marker"] = ""
        for i,item in enumerate(item_list):

            items = item.split('=')

            if len(items) != 2:
                INFOTEXT = f"Im plotdef zeile:{ZEILE}, (Anweisung: \"={sig_name}({item_list})\") ist der {i+1}. Parameter nicht in der Struktur name=wert"
                return hdef.NOT_OKAY
            else:
                name = hstr.elim_ae_liste(items[0], [" ", "\t"])
                wert = hstr.elim_ae_liste(items[1], [" ", "\t"])
            # end if

            if name not in liste:
                INFOTEXT = f"Im plotdef zeile:{ZEILE}, (Anweisung: \"={sig_name}({item_list})\") ist der {i+1}. Parameter name = {name} nicht definiert Definition = {liste} "
                return hdef.NOT_OKAY
            # end if
            index = liste.index(name)
            # liste = ["subplot", "height_rows", "color", "linewidth", "marker"]

            if index == 0:
                werte_dict[liste[index]] = int(wert)
            elif index == 1:
                werte_dict[liste[index]] = int(wert)
            elif index == 2:
                werte_dict[liste[index]] = str(wert)
            elif index == 3:
                werte_dict[liste[index]] = float(wert)
            elif index == 4:
                werte_dict[liste[index]] = str(wert)
            # end if
        # end for
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
                val1 = "SignalName(subplot=1)"
                val2 = f"Subplotreihe: (default=1) 1,2,3, ... "
            case 2:
                val1 = "SignalName(height_rows=1)"
                val2 = f"Höhe des subplots: (default=1) 1,2,3, ... "
            case 3:
                val1 = "SignalName(color=red)"
                val2 = f"Farbe: (default='k') 'b', 'g', 'r', 'c', 'm', 'y', 'k', 'w', 'white', ... "
            case 4:
                val1 = "SignalName(linewidth=3)"
                val2 = "Liniendicke (default=1)"
            case 5:
                val1 = "SignalName(linestyle=-)"
                val2 = "Linetype (default=-) '--', '-.', ':', '' "
            case 6:
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