
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



@dataclass
class WpData:
    pickle_obj = None
    data_dict: dict = field(default_factory=dict)
    data_dict_tvar: dict = field(default_factory=dict)
    wp_obj = None


def read(rd, wp_list_name, isin, depot_data_obj, depot_name):
    """
    
    :param rd:
    :param wp_list_name:
    :param isin:
    :return: (wp_data_obj,status,errtext) = depot_data_init_wpdata.read(rd,wp_list_name,isin)
    """
    status = hdef.OK
    errtext = ""
    wp_data_obj = WpData()
    
    # get data set
    if wp_list_name in rd.ini.ddict[rd.par.INI_DATA_PICKLE_JSONFILE_LIST]:
        use_json_wp = rd.ini.ddict[rd.par.INI_DATA_PICKLE_USE_JSON]
    else:
        use_json_wp = 0
    # end if
    
    make_backup = rd.ini.ddict[rd.par.INI_DATA_PICKLE_MAKE_BACKUP]
    path_backup = rd.ini.ddict[rd.par.INI_BACKUP_PATH]
    
    wp_data_obj.pickle_obj = hpickle.DataPickle(rd.par.DEPOT_WP_PREFIX,
                                                wp_list_name, use_json_wp,
                                                make_backup, path_backup)
    if (wp_data_obj.pickle_obj.status != hdef.OK):
        status = hdef.NOT_OKAY
        errtext = wp_data_obj.pickle_obj.errtext
        return (wp_data_obj, status, errtext)
    # endif
    
    wp_data_obj.data_dict = wp_data_obj.pickle_obj.get_ddict()
    
    if len(wp_data_obj.data_dict) == 0:
        depot_data_obj.depot_obj.set_stored_wp_data_set_ttable(isin, "", None)
        wp_data_obj.wp_obj = rd.depot_dict[depot_name].depot_obj.get_wp_data_obj(isin)
    else:
        wp_data_obj.data_dict[rd.par.DDICT_TYPE_NAME] = rd.par.DEPOT_WP_DATA_TYPE_NAME
        
        # Umbau filter vorübergehend
        try:
            wp_data_obj.data_dict = umbau_wp_data_dict_filter(rd.par,
                                                              wp_data_obj.data_dict)
        except:
            wp_data_obj.data_dict = umbau_wp_data_dict_filter(rd.par,
                                                              wp_data_obj.data_dict)
        # end try
        
        # Tvariable bilden
        wp_data_obj.data_dict_tvar = build_wp_transform_data_dict(rd.par,
                                                                  wp_data_obj.data_dict)
        
        wp_data_obj.wp_obj = depot_data_obj.depot_obj.get_wp_data_obj(wp_data_obj.data_dict[rd.par.ISIN])
    # end if
    return (wp_data_obj, status, errtext)


# end if
def save(rd,depot_data_obj,wp_list_name,isin):
    """
    
    :param rd:
    :param depot_data_obj:
    :param wp_data_obj:
    :param wp_list_name:
    :param isin:
    :return: (status, errtext) = depot_data_init_wpdata.save(rd,
                                                    depot_data_obj,
                                                    wp_list_name,
                                                    isin)
    """
    
    # for new isins:
    if wp_list_name not in depot_data_obj.wp_obj_dict:
        
        wp_data_obj = WpData()
        
        # get data set
        if wp_list_name in rd.ini.ddict[rd.par.INI_DATA_PICKLE_JSONFILE_LIST]:
            use_json_wp = rd.ini.ddict[rd.par.INI_DATA_PICKLE_USE_JSON]
        else:
            use_json_wp = 0
        # end if
        
        make_backup = rd.ini.ddict[rd.par.INI_DATA_PICKLE_MAKE_BACKUP]
        path_backup = rd.ini.ddict[rd.par.INI_BACKUP_PATH]
        wp_data_obj.pickle_obj = hpickle.DataPickle(rd.par.DEPOT_WP_PREFIX, wp_list_name, use_json_wp, make_backup,
                                                    path_backup)
        if (wp_data_obj.pickle_obj.status != hdef.OKAY):
            status = hdef.NOT_OKAY
            errtext = wp_data_obj.pickle_obj.errtext
            return (status, errtext)
        # endif
        
    else:
        wp_data_obj = depot_data_obj.wp_obj_dict[wp_list_name]
    # end if
    
    wp_data_obj.wp_obj = depot_data_obj.depot_obj.get_wp_data_obj(isin)

    wp_data_obj.data_dict[rd.par.ISIN]         = wp_data_obj.wp_obj.get_isin()
    wp_data_obj.data_dict[rd.par.WP_NAME]      = wp_data_obj.wp_obj.get_depot_wp_name()
    wp_data_obj.data_dict[rd.par.WP_KATEGORIE] = wp_data_obj.wp_obj.get_kategorie()
    
    ttable = wp_data_obj.wp_obj.get_wp_data_set_ttable_to_store()
    wp_data_obj.data_dict_tvar[rd.par.WP_DATA_SET_TABLE_NAME] = ttable
    
    (val_dict_list, type_dict) = htvar.get_dict_list_from_table(ttable)
    wp_data_obj.data_dict[rd.par.WP_DATA_SET_DICT_LIST] = val_dict_list
    wp_data_obj.data_dict[rd.par.WP_DATA_SET_TYPE_DICT] = type_dict
    
    wp_data_obj.pickle_obj.save(wp_data_obj.data_dict)
    if (wp_data_obj.pickle_obj.status != hdef.OKAY):
        status = hdef.NOT_OKAY
        errtext = wp_data_obj.pickle_obj.errtext
    # endif
    return (status, errtext)
# end def
def umbau_wp_data_dict_filter(par, data_dict):
    data_dict_out = {}
    
    data_dict_out[par.DDICT_TYPE_NAME] = data_dict[par.DDICT_TYPE_NAME]
    
    data_dict_out[par.ISIN] = data_dict[par.ISIN]
    
    data_dict_out[par.WP_NAME] = data_dict[par.WP_NAME]
    
    data_dict_out[par.WP_KATEGORIE] = data_dict[par.WP_KATEGORIE]
    
    data_dict_out[par.WP_DATA_SET_DICT_LIST] = data_dict[par.WP_DATA_SET_DICT_LIST]
    
    if par.WP_DATA_SET_NAME_DICT in data_dict.keys():
        
        type_dict = {}
        for key in data_dict[par.WP_DATA_SET_NAME_DICT]:
            
            if key in data_dict[par.WP_DATA_SET_TYPE_DICT]:
                type_dict[data_dict[par.WP_DATA_SET_NAME_DICT][key]] = data_dict[par.WP_DATA_SET_TYPE_DICT][key]
            # end if
        # end for
        data_dict_out[par.WP_DATA_SET_TYPE_DICT] = type_dict
    else:
        data_dict_out[par.WP_DATA_SET_TYPE_DICT] = data_dict[par.WP_DATA_SET_TYPE_DICT]
    # end if
    
    return data_dict_out


# end def
def build_wp_transform_data_dict(par, data_dict):
    '''

    :param par:
    :param data_dict:
    :return: data_dict_tvar = build_wp_transform_data_dict(par,data_dict)
    '''
    
    data_dict_tvar = {}
    
    # DDICT_TYPE_NAME
    name = par.DDICT_TYPE_NAME
    data_dict_tvar[name] = htvar.build_val(name, data_dict[name], 'str')
    
    # ISIN
    name = par.ISIN
    data_dict_tvar[name] = htvar.build_val(name, data_dict[name], 'isin')
    
    # WP_NAME
    name = par.WP_NAME
    data_dict_tvar[name] = htvar.build_val(name, data_dict[name], 'str')
    
    # WP_KATEGORIE
    name = par.WP_KATEGORIE
    data_dict_tvar[name] = htvar.build_val(name, data_dict[name], 'str')
    
    # WP_DATA_SET_DICT_LIST
    
    if (par.WP_DATA_SET_DICT_LIST in data_dict.keys()) and (len(data_dict[par.WP_DATA_SET_DICT_LIST])):
        
        names = list(data_dict[par.WP_DATA_SET_DICT_LIST][0].keys())
        types = []
        for name in names:
            types.append(data_dict[par.WP_DATA_SET_TYPE_DICT][name])
        # end for
        table = []
        for dict_item in data_dict[par.WP_DATA_SET_DICT_LIST]:
            
            vals = []
            for name in names:
                vals.append(dict_item[name])
            # end for
            table.append(vals)
        # end for
    else:
        names = []
        types = []
        table = []
    # end if
    data_dict_tvar[par.WP_DATA_SET_TABLE_NAME] = htvar.build_table(names, table, types)
    
    return data_dict_tvar

# end def
