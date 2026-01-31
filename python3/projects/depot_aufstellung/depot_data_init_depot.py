import os, sys
from dataclasses import dataclass, field

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# # endif

# Hilfsfunktionen
import tools.hfkt_def as hdef
# import tools.hfkt_type as htype
import tools.hfkt_pickle as hpickle
import tools.hfkt_tvar as htvar

import depot_depot_data_set_class
import depot_data_init_wpdata

@dataclass
class DepotData:
    pickle_obj = None
    data_dict: dict = field(default_factory=dict)
    data_dict_tvar: dict = field(default_factory=dict)
    wp_obj_dict: dict = field(default_factory=dict)
    depot_obj = None

def read(rd,depot_name):
    """
    
    :param rd:
    :param depot_name:
    :return: (depot_data_obj, status, errtext) = depot_data_init_depot.read(rd, depot_name)
    """

    status       = hdef.OK
    errtext      = ""

    depot_data_obj = DepotData()
    
    if depot_name in rd.ini.ddict[rd.par.INI_DATA_PICKLE_JSONFILE_LIST]:
        use_json = rd.ini.ddict[rd.par.INI_DATA_PICKLE_USE_JSON]
    else:
        use_json = 0
    # end if
    
    make_backup = rd.ini.ddict[rd.par.INI_DATA_PICKLE_MAKE_BACKUP]
    path_backup = rd.ini.ddict[rd.par.INI_BACKUP_PATH]
    
    # get data set
    depot_data_obj.pickle_obj = hpickle.DataPickle(rd.par.DEPOT_PREFIX, depot_name, use_json, make_backup,
                                                              path_backup)
    if (depot_data_obj.pickle_obj.status != hdef.OK):
        
        status = hdef.NOT_OKAY
        errtext = depot_data_obj.pickle_obj.errtext
        return (depot_data_obj,status, errtext)
    
    else:
        
        depot_data_obj.data_dict = depot_data_obj.pickle_obj.get_ddict()
        
    # endif
    
    # type
    depot_data_obj.data_dict[rd.par.DDICT_TYPE_NAME] = rd.par.DEPOT_DATA_TYPE_NAME
    
    # depot_data_isin_list
    if rd.par.DEPOT_DATA_ISIN_LIST_NAME not in depot_data_obj.data_dict.keys():
        depot_data_obj.data_dict[rd.par.DEPOT_DATA_ISIN_LIST_NAME] = []
        depot_data_obj.data_dict[rd.par.DEPOT_DATA_DEPOT_WP_LIST_NAME] = []
    
    # Tvariable bilden
    depot_data_obj.data_dict_tvar = build_depot_transform_data_dict(rd.par, depot_data_obj.data_dict)
    
    # zugehöriges Konto
    konto_name = rd.ini.ddict[depot_name][rd.par.INI_DEPOT_KONTO_NAME]
    if konto_name not in rd.konto_dict:
        raise Exception(f"data_set: {konto_name = } sind nicht im ini-File als konto definition (section) vorhanden")
    # end if
    
    # depot obj
    depot_data_obj.depot_obj = depot_depot_data_set_class.DepotDataSet(
        depot_name,
        depot_data_obj.data_dict[rd.par.DEPOT_DATA_ISIN_LIST_NAME],
        depot_data_obj.data_dict[rd.par.DEPOT_DATA_DEPOT_WP_LIST_NAME],
        rd.allg.wpfunc,
        rd.konto_dict[konto_name].konto_obj)
    
    if (depot_data_obj.depot_obj.status != hdef.OK):
        status = hdef.NOT_OKAY
        errtext = depot_data_obj.depot_obj.errtext
        return (depot_data_obj,status, errtext)
    # end if
    
    # load each depot_wp_data_set
    wp_name_liste = depot_data_obj.depot_obj.get_wp_name_liste()

    for i, isin in enumerate(depot_data_obj.depot_obj.get_isin_liste()):
        
        (wp_data_obj,status,errtext) = \
            depot_data_init_wpdata.read(rd,
                                        wp_name_liste[i],
                                        isin,
                                        depot_data_obj,
                                        depot_name )
        
        if status != hdef.OK:
            return (depot_data_obj, status, errtext)
        
        depot_data_obj.depot_obj.set_stored_wp_data_set_ttable(wp_data_obj.data_dict[rd.par.ISIN],
                                                               wp_data_obj.data_dict[rd.par.WP_KATEGORIE],
                                                               wp_data_obj.data_dict_tvar[rd.par.WP_DATA_SET_TABLE_NAME])

        
    # end for
    
    return (depot_data_obj, status, errtext)
# end def
def save(rd,depot_data_obj,depot_name):
    """
    
    :param rd:
    :param depot_data_obj:
    :param depot_name
    :return: (status, errtext) = depot_data_init_depot.save(rd, depot_data_obj,depot_name)
    """
    status = hdef.OKAY
    errtext = ""
    
    depot_data_obj.data_dict[rd.par.DEPOT_DATA_ISIN_LIST_NAME] \
        = depot_data_obj.depot_obj.get_isin_liste()
    
    depot_data_obj.data_dict[rd.par.DEPOT_DATA_DEPOT_WP_LIST_NAME] \
        = depot_data_obj.depot_obj.get_wp_name_liste()
    
    depot_data_obj.pickle_obj.save(depot_data_obj.data_dict)
    if (depot_data_obj.pickle_obj.status != hdef.OKAY):
        status = hdef.NOT_OKAY
        errtext = depot_data_obj.pickle_obj.errtext
        return (status,errtext)
    # endif
    
    # --------------------------------------------------------------------
    # wp data
    # --------------------------------------------------------------------
    #     depot_data_obj.wp_obj_dict[wp_list_name].pickle_obj
    #     depot_data_obj.wp_obj_dict[wp_list_name].data_dict
    #     depot_data_obj.wp_obj_dict[wp_list_name].data_dict_tvar
    #     depot_data_obj.wp_obj_dict[wp_list_name].wp_obj
    
    wp_name_liste = depot_data_obj.data_dict[rd.par.DEPOT_DATA_DEPOT_WP_LIST_NAME]
    for i, wp_list_name in enumerate(wp_name_liste):
        
        isin = depot_data_obj.data_dict[rd.par.DEPOT_DATA_ISIN_LIST_NAME][i]
        
        (status,errtext) = depot_data_init_wpdata.save(rd,
                                                       depot_data_obj,
                                                       wp_list_name,
                                                       isin)
        if status != hdef.OKAY:
            break
    # end for wp
    
    # reset line color for tables
    if status == hdef.OKAY:
        depot_data_obj.depot_obj.reset_line_color()
    # end if
    return (status,errtext)
# end def

def build_depot_transform_data_dict(par, data_dict):
    '''

    :param par:
    :param data_dict:
    :return: data_dict_tvar = build_depot_transform_data_dict(par,data_dict)
    '''
    
    data_dict_tvar = {}
    
    # DDICT_TYPE_NAME
    data_dict_tvar[par.DDICT_TYPE_NAME] = htvar.build_val(par.DDICT_TYPE_NAME, data_dict[par.DDICT_TYPE_NAME], 'str')
    
    # DEPOT_DATA_ISIN_LIST_NAME
    if par.DEPOT_DATA_ISIN_LIST_NAME in data_dict.keys():
        val = data_dict[par.DEPOT_DATA_ISIN_LIST_NAME]
    
    else:
        val = []
    # end if
    data_dict_tvar[par.DEPOT_DATA_ISIN_LIST_NAME] = htvar.build_val(par.DEPOT_DATA_ISIN_LIST_NAME
                                                                    , val
                                                                    , 'list_str')
    
    # DEPOT_DATA_DEPOT_WP_LIST_NAME
    if par.DEPOT_DATA_DEPOT_WP_LIST_NAME in data_dict.keys():
        val = data_dict[par.DEPOT_DATA_DEPOT_WP_LIST_NAME]
    else:
        val = []
    # end if
    data_dict_tvar[par.DEPOT_DATA_DEPOT_WP_LIST_NAME] = htvar.build_val(par.DEPOT_DATA_DEPOT_WP_LIST_NAME
                                                                        , val
                                                                        , 'list_str')
    
    return data_dict_tvar

# end def
