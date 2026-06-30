import os, sys, time
import copy

from hfkt_log import log

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif


from tools import hfkt_def as hdef
# import tools.hfkt_dict as hdict
from tools import hfkt_type as htype

from wp_abfrage import wp_storage
from wp_abfrage import wp_fkt
from wp_abfrage import wp_wkn
from wp_abfrage import wp_basic_info_internet

def set_for_depot(wb_obj, depot_name, isin_dict_katalog):
    """
    :param wb_obj:
    :param depot_name:
    :param isin_dict_katalog:  dictionary mit key = isin und value = katalog
                               {'isin1':'katalogx','isin2':'katalogy',...}
    :return: (status, errtext) = wp_base_active_katalog.set_for_depot(wb_obj, depot_name, isin_dict_katalog)
    """

    (status, errtext, active_katalog_dict) = get_active_katalog_dict(wb_obj)
    if status != hdef.OKAY:
        return (status, errtext)

    change_flag = False

    for isin in isin_dict_katalog.keys():
        katalog = isin_dict_katalog[isin]

        if katalog in active_katalog_dict.keys():

            if isin in active_katalog_dict[katalog]:

                if depot_name not in active_katalog_dict[katalog][isin]:
                    active_katalog_dict[katalog][isin].append(depot_name)
                    change_flag = True
                # end if
            else:
                active_katalog_dict[katalog][isin] = [depot_name]
                change_flag = True
            # end if
        else:
            active_katalog_dict[katalog] = {isin: [depot_name]}
            change_flag = True
        # end if
    #end for

    if change_flag:
        (status, errtext) = save_active_katalog_dict(wb_obj, active_katalog_dict)
    # end if
    return (status, errtext)
# end def
def erase_depot(wb_obj, depot_name):
    """
    :param wb_obj:
    :param depot_name:
    :return: (status, errtext) = erase_depot(wb_obj, depot_name)
    """
    (status, errtext, active_katalog_dict) = get_active_katalog_dict(wb_obj)
    if status != hdef.OKAY:
        return (status, errtext)

    change_flag = False

    for katalog in active_katalog_dict.keys():

        for isin in active_katalog_dict[katalog].keys():

            if depot_name in active_katalog_dict[katalog][isin]:
                active_katalog_dict[katalog][isin].remove(depot_name)
                change_flag = True
            # end if
        # end for
    # end for

    for katalog in active_katalog_dict.keys():
        isin_liste = []
        for isin in active_katalog_dict[katalog].keys():

            if len(active_katalog_dict[katalog][isin]) == 0:
                isin_liste.append(isin)
                change_flag = True
            # end if
        # end for
        for isin in isin_liste:
            del active_katalog_dict[katalog][isin]
    # end for

    katalog_liste = []
    for katalog in active_katalog_dict.keys():
        if len(active_katalog_dict[katalog].keys()) == 0:
            katalog_liste.append(katalog)
            change_flag = True
        # end if
    # end for
    for katalog in katalog_liste:
        del active_katalog_dict[katalog]

    if change_flag:
        (status, errtext) = save_active_katalog_dict(wb_obj, active_katalog_dict)
    # end if
    return (status, errtext)
# end def
def get_active_katalog_dict(wb_obj) -> (int, str, dict):
    '''

    Lese active_katalog_dict ein und gebe sie zurück

    :return: (status, errtext, active_katalog_dict) = get_active_katalog_dict(wb_obj)

    active_katalog_dict : {'katalog1': {'isin1':['depot1','depot2',...], 'isin2':['depot2','depot3',...], ...},
                           'katalog2': {'isina':['depot1','depot2',...], 'isinb':['depot2','depot3',...], ...},
    '''

    file_name = wp_storage.build_file_name_json(wb_obj.base_ddict["active_katalog_filename"],
                                                wb_obj.base_ddict["store_path"])

    format = 2  # 1: pickle, 2: json
    (status, errtext, active_katalog_dict) = wp_storage.read_dict(file_name, format)

    if errtext.find("does not exist") != -1:
        status = hdef.OKAY
        active_katalog_dict = {}
    # end if

    return (status, errtext, active_katalog_dict)
# end def
def save_active_katalog_dict(wb_obj, active_katalog_dict ):
    """
    :param wb_obj:
    :param active_katalog_dict:
    :return: (status, errtext) = save_active_katalog_dict(wb_obj, active_katalog_dict )
    """

    file_name = wp_storage.build_file_name_json(wb_obj.base_ddict["active_katalog_filename"],
                                                wb_obj.base_ddict["store_path"])

    format = 2  # 1: pickle, 2: json

    (status, errtext, _) = wp_storage.save_dict(active_katalog_dict, file_name, format)

    return (status, errtext)
# end def
