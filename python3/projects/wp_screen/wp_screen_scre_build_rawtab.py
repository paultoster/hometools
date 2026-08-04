
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
import tools.hfkt_list as hlist

# import tools.sgui as sgui
import tools.hfkt_tvar as htvar
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

def scre_build_rawtab(rd, isin, tab_werte_dict_liste, dat):

    global STATUS,ERRTEXT

    np_data_obj = get_np_data_obj(rd,isin,dat)

    data_list = []
    type_list = []
    for icol,werte_dict in enumerate(tab_werte_dict_liste):

        werte_dict["isin"] = isin

        (value,type)  = scre_build_data_get_value(rd, werte_dict, np_data_obj)
        if value is None:
            return (None,None)

        data_list.append(value)
        type_list.append(type)

    # end for

    return (data_list,type_list)
# end def
def scre_build_data_get_value(rd,werte_dict,np_data_obj):
    """
    :param rd:
    :param werte_dict:
    :param np_data_obj:
    :return: (value,type) = scre_build_data_get_value(rd,werte_dict,np_data_obj)

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

        if isinstance(value,str):
            type = "str"
        elif isinstance(value,float):
            type = "float"
        elif isinstance(value,int):
            type = "int"
        else:
            type = None
        # end if

        if status != hdef.OKAY:
            STATUS = status
            ERRTEXT = errtext
            return (None,None)
        # end if
    elif werte_dict["section"] == rd.par.TAB_SEC_SIG:

        np_array = np_data_obj.get_data(werte_dict["name"])

        if np_array is None:
            STATUS = hdef.NOT_OKAY
            ERRTEXT = f"Von isin: {werte_dict['isin']} kann im np_data_obj nicht der {werte_dict['name']} gefunden werden!"
            return (None,None)
        # end if

        value = np_array[-1]

        if np.isnan(value):
            STATUS = hdef.NOT_OKAY
            ERRTEXT = f"Von isin: {werte_dict['isin']} ist das Signal {werte_dict['name']} == np.nan !"
            return None
        # end if

        if isinstance(value,np.int64):
            value = int(value)
            type = "int"
        elif isinstance(value,np.float64):
            value = float(value)
            type = "float"
        else:
            type = None
        # end if
    else # if (werte_dict["section"] == rd.par.TAB_SEC_TABRANKMIN) or (werte_dict["section"] == rd.par.TAB_SEC_TABRANKMAX):

        value = 0  # Vorbelegung in der Tabelle
        type = "int"
    # end if

    if type is None:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"Von isin: {werte_dict['isin']} kann {werte_dict['name']} der type für value: {value}  gefunden werden!"
        return (None,None)
    # end if

    return (value,type)
# end if
def scre_build_values_over_rawtab(rd,ttable,tab_werte_dict_liste,isin_liste,dat):
    """
    :param rd:
    :param ttable:
    :param tab_werte_dict_liste:
    :param dat
    :return: ttable = wp_screen_scre_build_rawtab.scre_build_values_over_rawtab(rd,ttable,tab_werte_dict_liste,isin_liste,dat)
    """

    for icol, werte_dict in enumerate(tab_werte_dict_liste):

        if werte_dict["section"] == rd.par.TAB_SEC_TABRANKMIN:

            rank_liste = build_rank_liste(rd,werte_dict["name"],isin_liste,dat,True)

            for i,rank in enumerate(rank_liste):
                ttable.vals[i][icol] = rank
            # end for

            ttable = htvar.sort_col_in_table(ttable, icol, aufsteigend=0)

        elif werte_dict["section"] == rd.par.TAB_SEC_TABRANKMAX:

            rank_liste = build_rank_liste(rd,werte_dict["name"],isin_liste,dat,False)

            for i,rank in enumerate(rank_liste):
                ttable.vals[i][icol] = rank
            # end for

            ttable = htvar.sort_col_in_table(ttable, icol, aufsteigend=0)

        # end if
    # end for
    return ttable
# end def
def build_rank_liste(rd,signame,isin_liste,dat,flagmin):
    """
    :param rd:
    :param signame:
    :param isin_liste:
    :param flagmin:
    :return: rank_liste = build_rank_liste(rd,signame,isin_liste,flagmin)
    """
    global STATUS, ERRTEXT, INFOTEXT

    value_liste = []
    for isin in isin_liste:

        np_data_obj = get_np_data_obj(rd, isin, dat)
        if get_status() != hdef.OKAY:
            return []
        # end if

        np_array = np_data_obj.get_data(signame)
        if np_array is None:
            STATUS = hdef.NOT_OKAY
            ERRTEXT = f"Von isin: {isin} kann im np_data_obj nicht der {signame} gefunden werden!"
            return []
        # end if

        if len(np_array) > 0:
            value_liste.append(np_array[-1])
        elif flagmin:
            value_liste.append(10000000000.)
        else:
            value_liste.append(-10000000000.)
        # end if
    # end if

    index_liste = list(range(len(value_liste)))

    if flagmin:
        (value_liste,index_liste) = hlist.sort_two_list(value_liste, index_liste, aufsteigend=0)
    else:
        (value_liste, index_liste) = hlist.sort_two_list(value_liste, index_liste, aufsteigend=1)
    # end if

    rank_liste = [None] * len(index_liste)
    for i,index in enumerate(index_liste):
        rank_liste[index] = i+1

    return rank_liste
# end def
def get_np_data_obj(rd,isin,dat):
    """
    :param rd:
    :param isin:
    :param dat:
    :return: np_data_obj = get_np_data_obj(rd,isin,dat)
    """
    global STATUS, ERRTEXT, INFOTEXT

    filename = rd.scre["scre_isin_dataclass_filename_dict"][isin]
    np_data_obj = hnp_dataclass.NpDataHandlingClass(filename)
    np_data_obj.read()
    if np_data_obj.get_status() != hdef.OKAY:
        STATUS = np_data_obj.get_status()
        ERRTEXT = np_data_obj.get_errtext()
        return None
    # end if
    np_data_obj.sort_by_signal(rd.par.SIG_STORE_DATUM)
    if dat > 0:
        np_data_obj.reduce_to_endvalue(rd.par.SIG_STORE_DATUM,dat)
    # end if
    return np_data_obj
# end def