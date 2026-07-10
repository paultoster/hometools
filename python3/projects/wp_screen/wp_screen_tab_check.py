
import os, sys, copy, re

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
    rd.sig["tab_werte_dict_liste"] = []

    for i,key in enumerate(ddict.keys()):
        ZEILE = i+1
        werte_dict = {"spalte":key}
        if check_content(rd,ddict[key],werte_dict) != hdef.OKAY:
            return  (hdef.NOT_OKAY,INFOTEXT)
        else:
            rd.sig["tab_werte_dict_liste"].append(werte_dict)
        # end if
    # end for
    return (hdef.OKAY,"")
# end def
def check_content(rd,content,werte_dict):

    global INFOTEXT
    global ZEILE
    content = hstr.elim_ae(content, [" ", "\t"])

    (status,section,name,fmt,color) =  check_content_base(rd.par,content)
    if status == hdef.NOT_OKAY:

        INFOTEXT = f"Im tab zeile:{ZEILE}, (Kontext: \"={content})\") ist kann nicht in section:name(fmt,color) zerlegt werden! "
        return status
    else:

        # section
        if (section != rd.par.TAB_SEC_BI) and (section != rd.par.TAB_SEC_SIG):
            INFOTEXT = f"Im tab zeile:{ZEILE}, (section: \"{section})\") ist nicht \"{rd.par.TAB_SEC_BI}\" oder \"{rd.par.TAB_SEC_SIG}\" "
            return hdef.NOT_OKAY
        # end if
        werte_dict["section"] = section

        # name
        if section == rd.par.TAB_SEC_BI:
            key_list = rd.wpfunc.get_basic_info_key_list()
            if name not in key_list:
                INFOTEXT = f"Im tab zeile:{ZEILE}, name : \"{name}\" (section: \"{section}\") ist nicht in basic_info zu finden "
                return hdef.NOT_OKAY
            # end if
        # end if
        werte_dict["name"] = name

        (status,base_fmt,nachkomma,special_dict_liste) = check_content_fmt(rd.par,fmt)
        if status == hdef.NOT_OKAY:
            return status
        # end if

        werte_dict["fmt"] = base_fmt
        werte_dict["fmt_nachkomma"] = nachkomma
        werte_dict["fmt_spez_dict_liste"] = special_dict_liste

        (status, base_color, special_dict_liste) = check_content_color(rd.par, color)
        if status == hdef.NOT_OKAY:
            return status
        # end if

        werte_dict["color"] = base_color
        werte_dict["color_spez_dict_liste"] = special_dict_liste
    # end if
    return hdef.OKAY
# end def
def check_content_base(par,content):
    """
    :param par:
    :param content:
    :return: (status,type,fkt) =  check_content_0par(content)
    """
    status = hdef.NOT_OKAY
    section = name = fmt = color = ""

    t = copy.copy(content)
    muster = r"([^:)]+):([^:)]+)\(([^,)]+),([^,)]+)\)"
    tupel_liste = re.findall(muster, t.replace(" ", ""))
    if len(tupel_liste) > 0:
        status = hdef.OKAY
        section = tupel_liste[0][0]
        name = tupel_liste[0][1]
        fmt = tupel_liste[0][2]
        color = tupel_liste[0][3]
    # end if

    return (status,section,name,fmt,color)
# end def
def check_content_fmt(par,fmt):
    """

    :param par:
    :param fmt:
    :return: (status,base_fmt,nachkomma,special_dict_liste) = check_content_fmt(rd.par,fmt)
    """
    global INFOTEXT
    global ZEILE
    status = hdef.NOT_OKAY
    base_fmt = ""
    nachkomma = -1
    special_dict_liste = []

    if (fmt == par.TAB_FMT_STR) or (fmt == par.TAB_FMT_INT):

        base_fmt = fmt
        status = hdef.OKAY

    elif fmt.find(par.TAB_FMT_FLOAT) != -1:

        status = hdef.OKAY
        base_fmt = par.TAB_FMT_FLOAT
        index = fmt.find(par.TAB_FMT_FLOAT_SEP)
        if index != -1:
            value = fmt[index+1:]
            (status,wert) = htype.type_proof_int(value)
            if status == hdef.NOT_OKAY:
                INFOTEXT = f"Im tab zeile:{ZEILE}, fmt : \"{fmt}\" nachkomma: \"{value}\") kann nicht in int gewandelt werden "
            else:
                nachkomma = wert
            # end if
        # end if
    else:
        i0 = fmt.find(par.TAB_FMT_SPEZ_BRACKET_OPEN)
        i1 = fmt.find(par.TAB_FMT_SPEZ_BRACKET_CLOSE)

        if i0 != -1 and i1 > i0:
            base_fmt = par.TAB_FMT_SPEZ
            (status,special_dict_liste) = check_content_fmt_special_dict_liste(par,fmt[i0+1:i1])
        else:
            status = hdef.NOT_OKAY
            INFOTEXT = f"Im tab zeile:{ZEILE}, fmt : \"{fmt}\"  kann nicht mit brackest \"{par.TAB_FMT_SPEZ_BRACKET_OPEN}\" und \"{par.TAB_FMT_SPEZ_BRACKET_CLOSE}\" gewandelt werden "
        # end if
    # end if

    return (status,base_fmt,nachkomma,special_dict_liste)
# end def
def check_content_fmt_special_dict_liste(par,fmt):
    """
    (status,special_dict_liste) = check_content_fmt_special_dict_liste(fmt)
    """
    global INFOTEXT
    global ZEILE

    special_dict_liste = []

    liste = fmt.strip().split(sep=par.TAB_FMT_SPEZ_SEP)

    for i,item in enumerate(liste):
        ddict = {}
        sliste = item.split(sep=par.TAB_FMT_SPEZ_COMMAND_SEP)

        if len(sliste) != 2:
            INFOTEXT = f"Im tab zeile:{ZEILE}, fmt : \"{fmt}\" kann das {i+1}te command \"{item}\") nicht nicht mit \"{par.TAB_FMT_SPEZ_COMMAND_SEP}\" separiert werden"
            return (hdef.NOT_OKAY,special_dict_liste)
        # end if

        ddict["ausgabe"] = hstr.elim_ae(sliste[0], " ")
        val  = hstr.elim_ae(sliste[1], " ")

        if val.find(par.TAB_SPEZ_GT) == 0:
            ddict["vergleich"] = par.TAB_SPEZ_GT
        elif val.find(par.TAB_SPEZ_LT) == 0:
            ddict["vergleich"] = par.TAB_SPEZ_LT
        elif val.find(par.TAB_SPEZ_GE) == 0:
            ddict["vergleich"] = par.TAB_SPEZ_GE
        elif val.find(par.TAB_SPEZ_LE) == 0:
            ddict["vergleich"] = par.TAB_SPEZ_LE
        elif val.find(par.TAB_SPEZ_EQ) == 0:
            ddict["vergleich"] = par.TAB_SPEZ_EQ
        else:
            INFOTEXT = f"Im tab zeile:{ZEILE}, fmt : \"{fmt}\" kann im {i+1}te command: \"{item}\") der Vergleich nicht gefunden werden"
            return (hdef.NOT_OKAY,special_dict_liste)
        # end if

        rest = hstr.elim_ae(val[len(ddict["vergleich"]):]," ")
        (status, wert) = htype.type_proof_float(rest)
        if status == hdef.NOT_OKAY: # Ist ein Signal
            ddict["vergleichssignal"] = par.TAB_FMT_SPEZ_GT
        else:
            ddict["vergleichswert"] = wert
        # end if

        special_dict_liste.append(ddict)
    # end for

    return (hdef.OKAY,special_dict_liste)
# end def
def check_content_color(par, color):
    """

    :param par:
    :param color:
    :return: (status, base_color, special_dict_liste) = check_content_color(rd.par, color)
    """
    global INFOTEXT
    global ZEILE
    status = hdef.NOT_OKAY
    base_color = ""
    special_dict_liste = []

    if color in par.TAB_COLOR_LISTE:

        base_color = color
        status = hdef.OKAY

    else:
        i0 = color.find(par.TAB_COLOR_SPEZ_BRACKET_OPEN)
        i1 = color.find(par.TAB_COLOR_SPEZ_BRACKET_CLOSE)

        if i0 != -1 and i1 > i0:
            base_color = par.TAB_COLOR_SPEZ
            (status, special_dict_liste) = check_content_color_special_dict_liste(par, color[i0 + 1:i1])
        else:
            status = hdef.NOT_OKAY
            INFOTEXT = f"Im tab zeile:{ZEILE}, color : \"{color}\"  kann nicht mit brackest \"{par.TAB_COLOR_SPEZ_BRACKET_OPEN}\" und \"{par.TAB_COLOR_SPEZ_BRACKET_CLOSE}\" gewandelt werden "
        # end if
    # end if

    return (status, base_color, special_dict_liste)


# end def
def check_content_color_special_dict_liste(par,color):
    """
    (status,special_dict_liste) = check_content_fmt_special_dict_liste(fmt)
    """
    global INFOTEXT
    global ZEILE

    special_dict_liste = []

    liste = color.strip().split(sep=par.TAB_COLOR_SPEZ_SEP)

    for i,item in enumerate(liste):
        ddict = {}
        sliste = item.split(sep=par.TAB_COLOR_SPEZ_COMMAND_SEP)

        if len(sliste) != 2:
            INFOTEXT = f"Im tab zeile:{ZEILE}, fmt : \"{color}\" kann das {i+1}te command \"{item}\") nicht mit \"{par.TAB_COLOR_SPEZ_COMMAND_SEP}\" separiert werden"
            return (hdef.NOT_OKAY,special_dict_liste)
        # end if
        c = hstr.elim_ae(sliste[0], " ")

        if c not in par.TAB_COLOR_LISTE:
            INFOTEXT = f"Im tab zeile:{ZEILE}, spez : \"{color}\" kann das {i + 1}te command \"{item}\") mit die detektierte color \"{c}\" nicht einer Farbe zugeorndet werden."
            return (hdef.NOT_OKAY, special_dict_liste)
        # end if

        ddict["color"] = c
        val  = hstr.elim_ae(sliste[1], " ")

        if val.find(par.TAB_SPEZ_GT) == 0:
            ddict["vergleich"] = par.TAB_SPEZ_GT
        elif val.find(par.TAB_SPEZ_LT) == 0:
            ddict["vergleich"] = par.TAB_SPEZ_LT
        elif val.find(par.TAB_SPEZ_GE) == 0:
            ddict["vergleich"] = par.TAB_SPEZ_GE
        elif val.find(par.TAB_SPEZ_LE) == 0:
            ddict["vergleich"] = par.TAB_SPEZ_LE
        elif val.find(par.TAB_SPEZ_EQ) == 0:
            ddict["vergleich"] = par.TAB_SPEZ_EQ
        else:
            INFOTEXT = f"Im tab zeile:{ZEILE}, spez : \"{color}\" kann im {i+1}te command: \"{item}\") der Vergleich nicht gefunden werden"
            return (hdef.NOT_OKAY,special_dict_liste)
        # end if

        rest = hstr.elim_ae(val[len(ddict["vergleich"]):]," ")
        (status, wert) = htype.type_proof_float(rest)
        if status == hdef.NOT_OKAY: # Ist ein Signal
            ddict["vergleichssignal"] = par.TAB_FMT_SPEZ_GT
        else:
            ddict["vergleichswert"] = wert
        # end if

        special_dict_liste.append(ddict)
    # end for

    return (hdef.OKAY,special_dict_liste)
# end def
def hilfe(rd):
    """

    :param rd:
    :return: infotext = hilfe(rd)
    """
    infotext = "\n"

    for i in range(12):
        match i:
            case 0:
                val1 = "section:name(fmt,color)"
                val2 = ""
            case 1:
                val1 = ""
                val2 = f""
            case 2:
                val1 = "section"
                val2 = "\"bi\": basic_info isin oder \"sig\": Signal aus sigset"
            case 3:
                val1 = ""
                val2 = f""
            case 4:
                val1 = "fmt"
                val2 = "\"str\", \"float.X\" (anzahl der Nachkomma-Stellen), \"int\""
            case 5:
                val1 = "fmt"
                val2 = "\"[\"x\":>0.1;\"y\":<-0.1]\" druckt x oder y unter den Bedingungen"
            case 6:
                val1 = "fmt"
                val2 = "\"[\"x\":==1]\" druckt x unter den Bedingungen"
            case 7:
                val1 = "fmt"
                val2 = "\"[\"x\":==Signaly]\" druckt x unter den Bedingungen im Vergleich mit weiterem Signal"
            case 8:
                val1 = ""
                val2 = f""
            case 9:
                val1 = "color"
                val2 = "white, red, green, blue (Hintergrund aller Zellen in Spalte mit Vorgabe)"
            case 10:
                val1 = "color"
                val2 = "\"[green:>0.0; red<=0.0 ]\" (Hintergrund aller Zellen in Spalte mit Vorgabe und Bedignung)"
            case 11:
                val1 = "color"
                val2 = "\"[green:>Signal2; red<=Signal2 ]\" (Hintergrund aller Zellen in Spalte mit Vorgabe und Bedignung)"
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