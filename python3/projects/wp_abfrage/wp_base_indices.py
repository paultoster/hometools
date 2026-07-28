import os, sys
import numpy as np
import copy
import hfkt_str
from hfkt_log import log

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef


from wp_abfrage import wp_storage
from wp_abfrage import wp_fkt

from wp_abfrage import wp_np_dataclass as wp_np_dc
from wp_abfrage import wp_base
from wp_abfrage import wp_usdeuro
from wp_abfrage import wp_ezbleitzins




def get_indices_liste(wb_obj) -> list:
    """

    :param wb_obj:
    :return: indices_liste = wp_base_indices.get_indices_liste(wb_obj)
    """

    liste = [wb_obj.par.INDICES_EZB_LEITZINS_NAME, wb_obj.par.INDICES_USDEURO_NAME]

    return liste
# end def
def is_indices_name(wb_obj, indices_name) -> (int, str, list):
    """
    :param wb_obj:
    :return: flag = wp_base_indices.get_indices_name(wb_obj)
    """

    indices_liste = get_indices_liste(wb_obj)

    if indices_name in indices_liste:
        return True
    else:
        return False
    # end if
# end def
def update_indices(wb_obj,indice = None):

    status = hdef.OKAY
    errtext = ""
    if indice is None:
        indices = get_indices_liste(wb_obj)
    elif not isinstance(indice, list):
        indices = [indice]
    else:
        indices = indice
    # end if

    for indice in indices:
        match indice:
            case wb_obj.par.INDICES_EZB_LEITZINS_NAME:

                (status,errtext) = wp_ezbleitzins.process_akt(wb_obj)


            case wb_obj.par.INDICES_USDEURO_NAME:

                (status, errtext) = wp_usdeuro.process_akt(wb_obj)

            case _:

                status = hdef.NOT_OKAY
                errtext = f"update_indices: Der Indice {indice} ist nicht gefunden worden in der Liste."
        # end match
        if status != hdef.OKAY:
            break
    # end for

    return (status,errtext)
# end def
def get_dict_from_act(wb_obj,indice=None):

    status = hdef.OKAY
    errtext = ""

    if indice is None:
        indices = get_indices_liste(wb_obj)
    elif isinstance(indice, list) and (len(indice) == 0):
        indices = get_indices_liste(wb_obj)
    elif not isinstance(indice, list):
        indices = [indice]
    else:
        indices = indice
    # end if
    np_obj_dict = {}

    for indice in indices:
        match indice:
            case wb_obj.par.INDICES_EZB_LEITZINS_NAME:

                (status, errtext, np_obj) = wp_ezbleitzins.get_act(wb_obj)

            case wb_obj.par.INDICES_USDEURO_NAME:

                (status, errtext, np_obj) = wp_usdeuro.get_act(wb_obj)

            case _:

                status = hdef.NOT_OKAY
                errtext = f"get_from_start_dat_to_end_dat: Der Indice {indice} ist nicht gefunden worden in der Liste."
        # end match
        if status != hdef.OKAY:
            break
        else:
            np_obj_dict[indice] = np_obj
        # end if
    # end for

    return (status, errtext, np_obj_dict)


# end def

def get_dict_from_start_dat_to_end_dat(wb_obj,indice,start_dat,end_dat):

    status = hdef.OKAY
    errtext = ""
    if indice is None:
        indices = get_indices_liste(wb_obj)
    elif isinstance(indice, list) and (len(indice)==0):
        indices = get_indices_liste(wb_obj)
    elif not isinstance(indice, list):
        indices = [indice]
    else:
        indices = indice
    # end if
    np_obj_dict = {}

    for indice in indices:
        match indice:
            case wb_obj.par.INDICES_EZB_LEITZINS_NAME:

                (status, errtext, np_obj) = wp_ezbleitzins.get_from_start_dat_to_end_dat(wb_obj,start_dat,end_dat)

            case wb_obj.par.INDICES_USDEURO_NAME:

                (status, errtext,np_obj) = wp_usdeuro.get_from_start_dat_to_end_dat(wb_obj,start_dat,end_dat)

            case _:

                status = hdef.NOT_OKAY
                errtext = f"get_from_start_dat_to_end_dat: Der Indice {indice} ist nicht gefunden worden in der Liste."
        # end match
        if status != hdef.OKAY:
            break
        else:
            np_obj_dict[indice] = np_obj
        # end if
    # end for

    return (status, errtext,np_obj_dict)
# end def

