
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
import wp_screen_tab


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
def build_header_list_type_list(tab_dict,tab_werte_dict_liste):

    global STATUS
    global ERRTEXT
    global INFOTEXT

    header_list = []
    type_list = []
    for werte_dict in tab_werte_dict_liste:

        header_list.append(werte_dict["spalte"])

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
        elif werte_dict["fmt"] == "euroStrK":
            type_list.append("euroStrK")
        elif werte_dict["fmt"] == "datStrP":
            type_list.append("datStrP")
        else:
            raise Exception("Format type not supported")
        # end if
    # end for
    return (header_list,type_list)
# end def
def scre_build_data(rd,irow ,isin,tab_dict,tab_werte_dict_liste,type_list):

    global STATUS, ERRTEXT, INFOTEXT

    filename = rd.scre["scre_isin_dataclass_filename_dict"][isin]
    np_data_obj = hnp_dataclass.NpDataHandlingClass(filename)
    np_data_obj.read()
    if np_data_obj.get_status() != hdef.OKAY:
        STATUS = np_data_obj.get_status()
        ERRTEXT = np_data_obj.get_errtext()
        return None
    # end if
    data_list = []
    for icol,werte_dict in enumerate(tab_werte_dict_liste):

        werte_dict["isin"] = isin

        value  = scre_build_data_get_value(rd, werte_dict, np_data_obj)
        if value is None:
            return (None,None)
        valout = scre_build_data_format_value(rd, werte_dict, value, type_list[icol],np_data_obj)
        if valout is None:
            return (None,None)
        color  = scre_build_data_color_value(rd, werte_dict, value, np_data_obj)
        if color is None:
            return (None,None)

        data_list.append(valout)

        if (len(color) > 0) and (color != rd.par.TAB_COLOR_WHITE):
            color_dict = {'row':irow,'col':icol,'bg':color}
        else:
            color_dict = None
        # end if
    # end for

    return (data_list,color_dict)
# end def
def scre_build_data_get_value(rd,werte_dict,np_data_obj):
    """
    :param rd:
    :param werte_dict:
    :param np_data_obj:
    :param type:
    :return: value = scre_build_data_get_value(rd,werte_dict,np_data_obj,type)

    werte_dict["section"] = "bi", "sig"
    werte_dict["name"] = name
    werte_dict["fmt"] = base_fmt
    werte_dict["fmt_nachkomma"] = nachkomma
    werte_dict["fmt_spez_dict_liste"] = special_dict_liste
    werte_dict["color"] = base_color
    werte_dict["color_spez_dict_liste"] = special_dict_liste

    """
    global STATUS, ERRTEXT, INFOTEXT

    if werte_dict["section"] == rd.par.TAB_SEC_BI:

        (status, errtext,value) = rd.wpfunc.get_basic_info_key_value(werte_dict["isin"],werte_dict["name"])

        if status != hdef.OKAY:
            STATUS = status
            ERRTEXT = errtext
            return None
        # end if
    else: # werte_dict["section"] == rd.par.TAB_SEC_SIG

        np_array = np_data_obj.get_data(werte_dict["name"])

        if np_array is None:
            STATUS = hdef.NOT_OKAY
            ERRTEXT = f"Von isin: {werte_dict['isin']} kann im np_data_obj nicht der {werte_dict['name']} gefunden werden!"
            return None
        # end if

        value = np_array[-1]

        if np.isnan(value):
            STATUS = hdef.NOT_OKAY
            ERRTEXT = f"Von isin: {werte_dict['isin']} ist das Signal {werte_dict['name']} == np.nan !"
            return None
        # end if

        if isinstance(value,np.int64):
            value = int(value)
        elif isinstance(value,np.float64):
            value = float(value)
        # end if
    # end if
    return value
# end if
def scre_build_data_format_value(rd, werte_dict, value, type,np_data_obj):
    """
    :param rd:
    :param werte_dict:
    :param value:
    :param type:
    :return: value = scre_build_data_format_value(rd,werte_dict,value,type)
    """

    global STATUS, ERRTEXT, INFOTEXT

    if isinstance(value, int):
        value = htype.type_transform_direct(value, "int", type)
    elif isinstance(value, float):
        value = htype.type_transform_direct(value, "float", type)
    else:
        value = htype.type_transform_direct(value, "str", type)
    # end if

    # Nachkommastellen
    if (werte_dict["fmt_nachkomma"] > -1) and (isinstance(value, int) or isinstance(value, float)):
        t = f"{value:.{werte_dict["fmt_nachkomma"]}f}"
        value = htype.type_transform_direct(t, "str", type)
    # end if


    # spez-fmt
    fmt_spez_dict_liste = werte_dict["fmt_spez_dict_liste"]
    if len(fmt_spez_dict_liste) > 0:
        ersatzwert = ""
        for fmt_spez_dict in fmt_spez_dict_liste:

            # Vergleichswert
            vergleichswert = 0
            if fmt_spez_dict["vergleichswert"] != None:

                if isinstance(value, int) :
                    vergleichswert = int(fmt_spez_dict["vergleichswert"])
                else:
                    vergleichswert = float(fmt_spez_dict["vergleichswert"])
                # end if
            else:
                np_array = np_data_obj.get_data(fmt_spez_dict["vergleichssignal"])

                if np_array == None:
                    STATUS = hdef.NOT_OKAY
                    ERRTEXT = f"scre_build_data_format_value: Von isin: {werte_dict['isin']} kann im np_data_obj nicht der {werte_dict['name']} gefunden werden!"
                    return None
                # end if

                if isinstance(value, int) :
                    vergleichswert = int(np_array[-1])
                else:
                    vergleichswert = float(np_array[-1])
                # end if
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
            else:
                STATUS = hdef.NOT_OKAY
                ERRTEXT = f"scre_build_data_format_value: Die Vergleichsanwesiung  : \"{fmt_spez_dict["vergleich"]}\" stimmt nicht"
                return None
            # end if
        # end for
        if len(ersatzwert) > 0:
            value = ersatzwert
        # end if

    return value
# end def
def scre_build_data_color_value(rd, werte_dict, value, np_data_obj):
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
                if color_spez_dict["vergleichswert"] != None:

                    if isinstance(value, int):
                        vergleichswert = int(color_spez_dict["vergleichswert"])
                    else:
                        vergleichswert = float(color_spez_dict["vergleichswert"])
                    # end if
                else:
                    np_array = np_data_obj.get_data(color_spez_dict["vergleichssignal"])

                    if np_array == None:
                        STATUS = hdef.NOT_OKAY
                        ERRTEXT = f"scre_build_data_color_value: Von isin: {werte_dict['isin']} kann im np_data_obj nicht der {werte_dict['name']} gefunden werden!"
                        return None
                    # end if

                    if isinstance(value, int):
                        vergleichswert = int(np_array[-1])
                    else:
                        vergleichswert = float(np_array[-1])
                    # end if
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






