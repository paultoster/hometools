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

# import depot_iban_data_class
import depot_konto_data_set_class
# import depot_konto_csv_read_class
# import depot_depot_data_set_class


@dataclass
class KontoData:
    pickle_obj = None
    data_dict: dict = field(default_factory=dict)
    data_dict_tvar: dict = field(default_factory=dict)
    konto_obj = None


def read(rd,konto_name):
    """

    :param rd:
    :return: (iban, status, errtext) = depot_data_init_iban.read(rd)
    """
    status     = hdef.OK
    errtext    = ""
    konto_data = KontoData()
    
    if konto_name in rd.ini.ddict[rd.par.INI_DATA_PICKLE_JSONFILE_LIST]:
        use_json = rd.ini.ddict[rd.par.INI_DATA_PICKLE_USE_JSON]
    else:
        use_json = 0
    # end if
    
    make_backup = rd.ini.ddict[rd.par.INI_DATA_PICKLE_MAKE_BACKUP]
    path_backup = rd.ini.ddict[rd.par.INI_BACKUP_PATH]
    # get data set
    # -------------
    konto_data.pickle_obj = hpickle.DataPickle(rd.par.KONTO_PREFIX, konto_name, use_json, make_backup,
                                                              path_backup)
    if (konto_data.pickle_obj.status != hdef.OK):
        status = hdef.NOT_OKAY
        errtext = konto_data.pickle_obj.errtext
        return (konto_data,status, errtext)
    else:
        konto_data.data_dict = konto_data.pickle_obj.get_ddict()
    # endif
    
    # type
    konto_data.data_dict[rd.par.DDICT_TYPE_NAME] = rd.par.KONTO_DATA_TYPE_NAME
    
    # Umbau filter vorübergehend
    konto_data.data_dict = umbau_kont_data_dict_filter(rd.par, depot_konto_data_set_class.KontoParam
                                                                      , konto_data.data_dict)
    # Tvariable bilden
    konto_data.data_dict_tvar = build_konto_transform_data_dict(rd.par, konto_data.data_dict)
    
    # konto Klasse bilden
    konto_data.konto_obj = depot_konto_data_set_class.KontoDataSet(
        konto_name, rd.allg.idfunc, rd.allg.wpfunc, rd.allg.katfunc, rd.iban.iban_obj)
    
    print(f"{konto_name =}: {konto_data.konto_obj} ; {hex(id(konto_data.konto_obj))}")
    
    # gespeicherte DatenSet übergeben  data_dict_tvar[]
    konto_data.konto_obj.set_stored_data_set_tvar(
        konto_data.data_dict_tvar[rd.par.KONTO_DATA_SET_TABLE_NAME]
        , rd.ini.dict_tvar[konto_name][rd.par.INI_START_DATUM_NAME]
        , rd.ini.dict_tvar[konto_name][rd.par.INI_START_WERT_NAME])
    
    if konto_data.konto_obj.status != hdef.OKAY:
        status = hdef.NOT_OKAY
        errtext = f"In Konto: \"{konto_name}\" ist ein Fehler aufgetreten: \n{konto_data.konto_obj.errtext}"
        return (konto_data,status, errtext)
    # end if

    return (konto_data,status,errtext)

# end def
def set_csv_func(rd,konto_name):
    """
    
    :param rd:
    :param konto_name:
    :return: (status,errtext) = depot_data_init_konto.set_csv_func(rd,konto_name)
    """
    status     = hdef.OK
    errtext    = ""


    csv_config_name = rd.ini.ddict[konto_name][rd.par.INI_IMPORT_CONFIG_TYPE_NAME]
    if len(csv_config_name):
        
        if csv_config_name not in rd.csv_dict.keys():
            raise Exception(f"data_set: {csv_config_name = } sind nicht im ini-File als section vorhanden")
        # end if
        
        # CSV_BUCHTYPE_ZUORDNUNG_NAME
        names = rd.csv_dict[csv_config_name].data_dict_tvar[rd.par.CSV_BUCHTYPE_ZUORDNUNG_NAME].names
        status = rd.konto_dict[konto_name].konto_obj.proof_csv_read_buchtype_zuordnung_names(names)
        if status != hdef.OKAY:
            errtext = rd.konto_dict[konto_name].konto_obj.errtext
            raise Exception(
                f"data_set: proof csv-objekte mit konto von {konto_name = } und {csv_config_name = } passt nicht {errtext = }")
        # end if
        
        # CSV_HEADER_ZUORDNUNG_NAME
        names = rd.csv_dict[csv_config_name].data_dict_tvar[rd.par.CSV_HEADER_ZUORDNUNG_NAME].names
        status = rd.konto_dict[konto_name].konto_obj.proof_csv_read_header_zuordnung_names(names)
        if status != hdef.OKAY:
            errtext = rd.konto_dict[konto_name].konto_obj.errtext
            raise Exception(
                f"data_set: proof csv-objekte mit konto von {konto_name = } und {csv_config_name = } passt nicht {errtext = }")
        # end if
        
        # Referenz
        rd.konto_dict[konto_name].konto_obj.set_csvfunc(rd.csv_dict[csv_config_name].csv_obj)
    # end if
    return (status,errtext)
# end def
def save(rd,konto_data):
    """
    
    :param rd:
    :return: (status, errtext) = depot_data_init_konto.save(rd)
    """
    status  = hdef.OK
    errtext = ""

    (ttable, _) = konto_data.konto_obj.get_to_store_data_set_tvar()
    
    (val_dict_list, type_dict) = htvar.get_dict_list_from_table(ttable)
    konto_data.data_dict[rd.par.KONTO_DATA_SET_DICT_LIST_NAME] = val_dict_list
    konto_data.data_dict[rd.par.KONTO_DATA_TYPE_DICT_NAME] = type_dict
    konto_data.data_dict[rd.par.KONTO_DATA_BANK_NAME] \
        = konto_data.konto_obj.get_konto_name()
    
    konto_data.pickle_obj.save(konto_data.data_dict)
    if (konto_data.pickle_obj.status != hdef.OKAY):
        status = hdef.NOT_OKAY
        errtext = f"konto: {konto_data.pickle_obj.errtext}"
    # endif
    
    # reset line color for tables
    konto_data.konto_obj.reset_line_color()

    return (status,errtext)
# end if
def umbau_kont_data_dict_filter(par, konto_par, data_dict):
    data_dict_out = {}
    
    data_dict_out[par.DDICT_TYPE_NAME] = data_dict[par.DDICT_TYPE_NAME]
    
    if par.KONTO_DATA_SET_DICT_LIST_NAME in data_dict:
        data_dict_out[par.KONTO_DATA_SET_DICT_LIST_NAME] = data_dict[par.KONTO_DATA_SET_DICT_LIST_NAME]
    else:
        data_dict_out[par.KONTO_DATA_SET_DICT_LIST_NAME] = []
    # end if
    
    if (par.KONTO_DATA_TYPE_DICT_NAME in data_dict) and (par.KONTO_DATA_TYPE_DICT_NAME in data_dict):
        data_dict_out[par.KONTO_DATA_TYPE_DICT_NAME] = data_dict[par.KONTO_DATA_TYPE_DICT_NAME]
        # change buchtype if still int
        data_dict_out[par.KONTO_DATA_TYPE_DICT_NAME]["buchtype"] = konto_par.KONTO_BUCHTYPE_TEXT_LIST
        
        for i in range(len(data_dict_out[par.KONTO_DATA_SET_DICT_LIST_NAME])):
            
            index = data_dict_out[par.KONTO_DATA_SET_DICT_LIST_NAME][i]["buchtype"]
            
            if isinstance(index, int):
                data_dict_out[par.KONTO_DATA_SET_DICT_LIST_NAME][i]["buchtype"] = \
                    konto_par.KONTO_BUCHTYPE_TEXT_LIST[index]
            # end if
        # end for
    else:
        data_dict_out[par.KONTO_DATA_TYPE_DICT_NAME] = {}
        data_dict_out[par.KONTO_DATA_TYPE_DICT_NAME]["buchtype"] = []
    # end if
    
    return data_dict_out


# end def
def build_konto_transform_data_dict(par, data_dict):
    '''

    :param par:
    :param data_dict:
    :return: data_dict_tvar = build_konto_transform_data_dict(par,data_dict)
    '''
    
    data_dict_tvar = {}
    
    # DDICT_TYPE_NAME
    data_dict_tvar[par.DDICT_TYPE_NAME] = htvar.build_val(par.DDICT_TYPE_NAME, data_dict[par.DDICT_TYPE_NAME], 'str')
    
    # KONTO_DATA_SET_TABLE_NAME
    if par.KONTO_DATA_TYPE_DICT_NAME in data_dict.keys():
        names = list(data_dict[par.KONTO_DATA_TYPE_DICT_NAME].keys())
        types = []
        for name in names:
            types.append(data_dict[par.KONTO_DATA_TYPE_DICT_NAME][name])
        # end for
        table = []
        for dict_item in data_dict[par.KONTO_DATA_SET_DICT_LIST_NAME]:
            
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
    data_dict_tvar[par.KONTO_DATA_SET_TABLE_NAME] = htvar.build_table(names, table, types)
    
    return data_dict_tvar
# end def
