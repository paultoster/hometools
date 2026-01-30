# import copy
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


# import wp_abfrage.wp_base as wp_base
# import bank_name_bestimmen.blz_class as blz_class

import depot_iban_data_class
# import depot_konto_data_set_class
# import depot_konto_csv_read_class
# import depot_depot_data_set_class
# import depot_data_class_defs
# import depot_kategorie_class


@dataclass
class IbanData:
    pickle_obj = None
    data_dict: dict = field(default_factory=dict)
    data_dict_tvar: dict = field(default_factory=dict)
    iban_obj = None


def read(rd):
    """
    
    :param rd:
    :return: (iban, status, errtext) = depot_data_init_iban.read(rd)
    """
    status  = hdef.OK
    errtext = ""
    iban = IbanData()
    
    if rd.ini.ddict[rd.par.INI_IBAN_LIST_FILE_NAME] in rd.ini.ddict[rd.par.INI_DATA_PICKLE_JSONFILE_LIST]:
        use_json = rd.ini.ddict[rd.par.INI_DATA_PICKLE_USE_JSON]
    else:
        use_json = 0
    # end if
    
    make_backup = rd.ini.ddict[rd.par.INI_DATA_PICKLE_MAKE_BACKUP]
    path_backup = rd.ini.ddict[rd.par.INI_BACKUP_PATH]
    
    iban.pickle_obj = hpickle.DataPickle(rd.par.IBAN_PREFIX, rd.ini.ddict[rd.par.INI_IBAN_LIST_FILE_NAME],
                                                  use_json, make_backup, path_backup)
    
    if (iban.pickle_obj.status != hdef.OK):
        status = hdef.NOT_OKAY
        errtext = iban.pickle_obj.errtext
        return (iban,status, errtext)
    else:
        iban.data_dict = iban.pickle_obj.get_ddict()
    # endif
    
    iban.data_dict[rd.par.DDICT_TYPE_NAME] = rd.par.IBAN_DATA_TYPE_NAME
    
    # Umbau filter vorübergehend
    # iban.data_dict = umbau_iban_data_dict_filter(rd.par, iban.data_dict)
    # Tvariable bilden
    iban.data_dict_tvar = build_iban_transform_data_dict(rd.par, iban.data_dict)
    
    iban.iban_obj = depot_iban_data_class.IbanDataSet(
        iban.data_dict_tvar[rd.par.IBAN_DATA_TABLE_NAME],
        rd.allg.banknamefunc)
    
    if (iban.iban_obj.status != hdef.OK):
        status = hdef.NOT_OKAY
        errtext = iban.iban_obj.errtext
        return (iban,status, errtext)
    # endif
    
    return (iban,status, errtext)
# end def
def save(rd):
    """
    #     rd.iban.pickle_obj
    #     rd.iban

    save rd.allg.pickle_obj with rd.allg.data_dict
    save kat_json_obj with rd.allg.kat_dict

    :param rd:
    :return: (status,errtext) = depot_data_init_iban.save(rd)
    """
    status = hdef.OKAY
    errtext = ""
    
    (ttable, _) = rd.iban.iban_obj.get_data_table()
    
    (val_dict_list, type_dict) = htvar.get_dict_list_from_table(ttable)
    
    rd.iban.data_dict[rd.par.IBAN_DATA_DICT_NAME] = val_dict_list
    rd.iban.data_dict[rd.par.IBAN_TYPE_DICT_NAME] = type_dict
    
    rd.iban.pickle_obj.save(rd.iban.data_dict)
    
    if (rd.iban.pickle_obj.status != hdef.OKAY):
        status = hdef.NOT_OKAY
        errtext = f"{errtext}/ iban: {rd.iban.pickle_obj.errtext}"
    # endif
    
    return (status,errtext)
# end def


def build_iban_transform_data_dict(par, data_dict):
    '''

    :param par:
    :param data_dict:
    :return: data_dict_tvar = build_wp_transform_data_dict(par,data_dict)
    '''
    
    data_dict_tvar = {}
    
    # DDICT_TYPE_NAME
    name = par.DDICT_TYPE_NAME
    data_dict_tvar[name] = htvar.build_val(name, data_dict[name], 'str')
    
    # IBAN_DATA_SET_DICT_LIST
    if (par.IBAN_DATA_DICT_NAME in data_dict.keys()) and (par.IBAN_TYPE_DICT_NAME in data_dict.keys()):
        
        val_dict_list = data_dict[par.IBAN_DATA_DICT_NAME]
        type_dict = data_dict[par.IBAN_TYPE_DICT_NAME]
        
        names = list(type_dict.keys())
        types = list(type_dict.values())
        table = []
        for ddict in val_dict_list:
            table.append(list(ddict.values()))
        # end for
    else:
        names = []
        types = []
        table = []
    # end if
    data_dict_tvar[par.IBAN_DATA_TABLE_NAME] = htvar.build_table(names, table, types)
    
    return data_dict_tvar

# end def

