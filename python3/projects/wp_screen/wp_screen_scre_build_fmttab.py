
import os, sys, copy
import numpy as np

# from hfkt_log import log

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import wp_screen_gui
import wp_screen_katalog
import wp_screen_sigset
import wp_screen_scre


import tools.hfkt_def as hdef
import tools.hfkt_np_dataclass as hnp_dataclass
# import tools.hfkt_np_fkt as hnpfkt

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
def build_header_list(tab_werte_dict_liste):
    header_list = []
    for werte_dict in tab_werte_dict_liste:
        header_list.append(werte_dict["spalte"])
    # end for
    return header_list
# end def
def build_type_list(tab_werte_dict_liste):

    global STATUS
    global ERRTEXT
    global INFOTEXT

    type_list = []
    for werte_dict in tab_werte_dict_liste:

        # types
        if len(werte_dict["fmt_spez_dict_liste"]) > 0:
            ddict = werte_dict["fmt_spez_dict_liste"][0]
            if isinstance(ddict["ausgabe"],str):
                type_list.append("str")
            elif isinstance(ddict["ausgabe"], int):
                type_list.append("int")
            elif isinstance(ddict["ausgabe"], float):
                type_list.append("float")
            else:
                type_list.append("str")
            # end if
        elif werte_dict["fmt"] == "str":
            type_list.append("str")
        elif werte_dict["fmt"] == "int":
            type_list.append("int")
        elif werte_dict["fmt"] == "float":
            type_list.append("float")
        elif werte_dict["fmt"] == "%":
            type_list.append("str")
        elif werte_dict["fmt"] == "euroStrK":
            type_list.append("euroStrK")
        elif werte_dict["fmt"] == "datStrP":
            type_list.append("datStrP")
        else:
            raise Exception("Format type not supported")
        # end if
    # end for
    return type_list
# end def
def scre_build_fmttable_data(rd,irow ,data_set_raw,header_list,tab_werte_dict_liste,type_list):

    global STATUS, ERRTEXT, INFOTEXT

    data_list = []
    color_dict_list = []
    for icol,werte_dict in enumerate(tab_werte_dict_liste):

        valout = scre_build_data_format_value(rd, werte_dict, data_set_raw[icol], type_list[icol],data_set_raw,header_list)
        if valout is None:
            return (None,None)
        color  = scre_build_data_color_value(rd, werte_dict, data_set_raw[icol],data_set_raw,header_list)
        if color is None:
            return (None,None)

        data_list.append(valout)

        if (len(color) > 0) and (color != rd.par.TAB_COLOR_WHITE):
            color_dict_list.append({'row':irow,'col':icol,'bg':color})
        # end if
    # end for

    return (data_list,color_dict_list)
# end def
def scre_build_data_format_value(rd, werte_dict, value, type,data_set,header_list):
    """
    :param rd:
    :param werte_dict:
    :param value:
    :param type:
    :return: value = scre_build_data_format_value(rd,werte_dict,value,type)
    """

    global STATUS, ERRTEXT, INFOTEXT

    val_out= copy.copy(value)

    if isinstance(value, int):
        val_out= htype.type_transform_direct(val_out, "int", type)
    elif isinstance(value, float):
        val_out = htype.type_transform_direct(val_out, "float", type)
    else:
        val_out = htype.type_transform_direct(val_out, "str", type)
    # end if

    if werte_dict["fmt"] == "float":
        (status,wert) = htype.type_proof(val_out,"float")
        if status != hdef.OKAY:
            STATUS = hdef.NOT_OKAY
            ERRTEXT = f"scre_build_data_format_value: In Tabelle kann der Wert: {val_out} mit Namen {werte_dict['name']} nicht in float gewandelt werden!"
            return None
        # end if

        # Nachkommastellen
        if werte_dict["fmt_nachkomma"] > -1:
            text = f"{wert:.{werte_dict["fmt_nachkomma"]}f}"
            val_out = htype.type_transform_direct(text, "str", type)
        else:
            val_out = htype.type_transform_direct(wert, "float", type)
        # end if
    elif werte_dict["fmt"] == "%":

        (status, wert) = htype.type_proof(val_out, "float")
        if status != hdef.OKAY:
            STATUS = hdef.NOT_OKAY
            ERRTEXT = f"scre_build_data_format_value: In Tabelle kann der Wert: {val_out} mit Namen {werte_dict['name']} nicht in float gewandelt werden!"
            return None
        # end if

        val_out = wert*100.

        # Nachkommastellen
        if werte_dict["fmt_nachkomma"] > -1:
            text = f"{val_out:.{werte_dict["fmt_nachkomma"]}f}"
            val_out = htype.type_transform_direct(text, "str", type)
        else:
            val_out = htype.type_transform_direct(val_out, "float", type)
        # end if

    # spez-fmt
    elif len(werte_dict["fmt_spez_dict_liste"]) > 0:

        fmt_spez_dict_liste = werte_dict["fmt_spez_dict_liste"]
        ersatzwert = ""
        for fmt_spez_dict in fmt_spez_dict_liste:

            # Vergleichswert
            if ("vergleichswert" in fmt_spez_dict.keys()) and  (fmt_spez_dict["vergleichswert"] != None):

                if isinstance(value, int) :
                    vergleichswert = int(fmt_spez_dict["vergleichswert"])
                else:
                    vergleichswert = float(fmt_spez_dict["vergleichswert"])
                # end if
            elif ("vergleichstabellenwert" in fmt_spez_dict.keys()) and  (fmt_spez_dict["vergleichstabellenwert"] != None):

                if fmt_spez_dict["vergleichstabellenwert"] not in header_list:
                    STATUS = hdef.NOT_OKAY
                    ERRTEXT = f"scre_build_data_format_value:  der Vergleichstabellenwert: {fmt_spez_dict["vergleichstabellenwert"]} konnte nicht in header_list: {header_list}  gefunden werden!!"
                    return None
                # end if

                index = header_list.index(fmt_spez_dict["vergleichswert"])

                if isinstance(value, int) :
                    vergleichswert = int(data_set[index])
                else:
                    vergleichswert = float(data_set[index])
                # end if

            else:
                raise   Exception("fmt_spez_dict Problem")
            # end if

            if fmt_spez_dict["vergleich"] == rd.par.TAB_SPEZ_GT:
                if value > vergleichswert:
                    ersatzwert = fmt_spez_dict["ausgabe"]
                # end if
            elif fmt_spez_dict["vergleich"] == rd.par.TAB_SPEZ_LT:
                if value < vergleichswert:
                    ersatzwert = fmt_spez_dict["ausgabe"]
                # end if
            elif fmt_spez_dict["vergleich"] == rd.par.TAB_SPEZ_GE:
                if value >= vergleichswert:
                    ersatzwert = fmt_spez_dict["ausgabe"]
                # end if
            elif fmt_spez_dict["vergleich"] == rd.par.TAB_SPEZ_LE:
                if value <= vergleichswert:
                    ersatzwert = fmt_spez_dict["ausgabe"]
                # end if
            elif fmt_spez_dict["vergleich"] == rd.par.TAB_SPEZ_EQ:
                if value == vergleichswert:
                    ersatzwert = fmt_spez_dict["ausgabe"]
                # end if
            elif fmt_spez_dict["vergleich"] == rd.par.TAB_SPEZ_NEQ:
                    if value != vergleichswert:
                        ersatzwert = fmt_spez_dict["ausgabe"]
                    # end if
            else:
                STATUS = hdef.NOT_OKAY
                ERRTEXT = f"scre_build_data_format_value: Die Vergleichsanwesiung  : \"{fmt_spez_dict["vergleich"]}\" stimmt nicht"
                return None
            # end if
        # end for
        if len(ersatzwert) > 0:
            val_out = ersatzwert
        # end if
    # end if

    return val_out
# end def
def scre_build_data_color_value(rd, werte_dict, value, data_set,header_list):
    """
        color = scre_build_data_color_value(rd, werte_dict, value)
    """
    global STATUS, ERRTEXT, INFOTEXT

    color = ""

    # spez-fmt
    if werte_dict["color"] == rd.par.TAB_COLOR_SPEZ:

        color_spez_dict_liste = werte_dict["color_spez_dict_liste"]
        if len(color_spez_dict_liste) > 0:

            colorersatzwert = ""
            for color_spez_dict in color_spez_dict_liste:

                # Vergleichswert
                vergleichswert = 0
                if ("vergleichswert" in color_spez_dict.keys()) and (color_spez_dict["vergleichswert"] != None):

                    if isinstance(value, int):
                        vergleichswert = int(color_spez_dict["vergleichswert"])
                    else:
                        vergleichswert = float(color_spez_dict["vergleichswert"])
                    # end if
                elif ("vergleichstabellenwert" in color_spez_dict.keys()) and (color_spez_dict["vergleichstabellenwert"] != None):

                    if color_spez_dict["vergleichstabellenwert"] not in header_list:
                        STATUS = hdef.NOT_OKAY
                        ERRTEXT = f"scre_build_data_format_value:  der Vergleichstabellenwert: {color_spez_dict["vergleichstabellenwert"]} konnte nicht in header_list: {header_list}  gefunden werden!!"
                        return None
                    # end if

                    index = header_list.index(color_spez_dict["vergleichswert"])

                    if isinstance(value, int):
                        vergleichswert = int(data_set[index])
                    else:
                        vergleichswert = float(data_set[index])
                    # end if
                else:
                    raise Exception("color_spez_dict Problem")
                # end if

                if color_spez_dict["vergleich"] == rd.par.TAB_SPEZ_GT:
                    if value > vergleichswert:
                        colorersatzwert = color_spez_dict["color"]
                    # end if
                elif color_spez_dict["vergleich"] == rd.par.TAB_SPEZ_LT:
                    if value < vergleichswert:
                        colorersatzwert = color_spez_dict["color"]
                    # end if
                elif color_spez_dict["vergleich"] == rd.par.TAB_SPEZ_GE:
                    if value >= vergleichswert:
                        colorersatzwert = color_spez_dict["color"]
                    # end if
                elif color_spez_dict["vergleich"] == rd.par.TAB_SPEZ_LE:
                    if value <= vergleichswert:
                        colorersatzwert = color_spez_dict["color"]
                    # end if
                elif color_spez_dict["vergleich"] == rd.par.TAB_SPEZ_EQ:
                    if value == vergleichswert:
                        colorersatzwert = color_spez_dict["color"]
                    # end if
                elif color_spez_dict["vergleich"] == rd.par.TAB_SPEZ_NEQ:
                    if value != vergleichswert:
                        colorersatzwert = color_spez_dict["color"]
                    # end if
                else:
                    STATUS = hdef.NOT_OKAY
                    ERRTEXT = f"scre_build_data_color_value: Die Vergleichsanwesiung  : \"{color_spez_dict["vergleich"]}\" stimmt nicht"
                    return None
                # end if
            # end for
            if len(colorersatzwert) > 0:
                color = colorersatzwert
            # end if
        # end if
    else:
        if len(werte_dict["color"]) > 0:
            color = werte_dict["color"]
        # end if
    # end if

    return color
# end def






