#
# data sets getting from pickle module or build new or also prolong
#
# mit data_get() und data_save werden alle pickles geholt und gespeichert
#
#     rd.par
#     rd.log
#     rd.ini
#     rd.allg.pickle_obj
#     rd.allg.data_dict
#     rd.allg.idfunc
#     rd.allg.wpfunc
#     rd.iban.pickle_obj
#     rd.iban.data_dict
#     rd.iban.data_dict_tvar
#     rd.iban.iban_obj
#     rd.konto_dict[konto_name].pickle_obj
#     rd.konto_dict[konto_name].data_dict
#     rd.konto_dict[konto_name].data_dict_tvar
#     rd.konto_dict[konto_name].konto_obj
#     rd.csv_dict[csv_config_name].data_dict
#     rd.csv_dict[csv_config_name].data_dict_tvar
#     rd.csv_dict[csv_config_name].csv_obj
#     rd.depot_dict[depot_name].pickle_obj
#     rd.depot_dict[depot_name].pickle_obj
#     rd.depot_dict[depot_name].data_dict
#     rd.depot_dict[depot_name].data_dict_tvar
#     rd.depot_dict[depot_name].wp_obj_dict
#     rd.depot_dict[depot_name].depot_obj

#
import copy
import os, sys
from dataclasses import dataclass, field

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# # endif

# Hilfsfunktionen
import tools.hfkt_def as hdef
import tools.hfkt_type as htype
import tools.hfkt_pickle as hpickle
import tools.hfkt_tvar as htvar


import wp_abfrage.wp_base as wp_base

import depot_iban_data_class
import depot_konto_data_set_class
import depot_konto_csv_read_class
import depot_depot_data_set_class
import depot_data_class_defs
import depot_konto_data_set_class as dkonto
import depot_data_class_defs as dclassdef

@dataclass
class AllgData:
    pickle_obj = None
    data_dict: dict = field(default_factory=dict)
    idfunc = None   # : dclassdef.IDCount = field(default_factory=dclassdef.IDCount)
    wpfunc = None   # : wp_base.WPData = field(default_factory=wp_base.WPData)

@dataclass
class KontoData:
    pickle_obj = None
    data_dict: dict = field(default_factory=dict)
    data_dict_tvar: dict = field(default_factory=dict)
    konto_obj = None

@dataclass
class CsvData:
    data_dict: dict = field(default_factory=dict)
    data_dict_tvar: dict = field(default_factory=dict)
    csv_obj = None

@dataclass
class DepotData:
    pickle_obj = None
    data_dict: dict = field(default_factory=dict)
    data_dict_tvar: dict = field(default_factory=dict)
    wp_obj_dict: dict = field(default_factory=dict)
    depot_obj = None

@dataclass
class WpData:
    pickle_obj = None
    data_dict: dict = field(default_factory=dict)
    data_dict_tvar: dict = field(default_factory=dict)
    wp_obj = None

@dataclass
class IbanData:
    pickle_obj = None
    data_dict: dict = field(default_factory=dict)
    data_dict_tvar: dict = field(default_factory=dict)
    iban_obj = None


# --------------------------------------------------------------------------------------
#
# Get DATA Start
#
# --------------------------------------------------------------------------------------
def data_set(rd):
    '''

    :param rd: data-structure
    :return:  (status, errtext) = data_get(rd)
    '''
    status = hdef.OKAY
    errtext = ""
    data = {}
    
    #================================================================================
    # read allgeime-pickle-file
    #================================================================================
    
    rd.allg = AllgData()
    
    if rd.par.ALLG_DATA_NAME in rd.ini.ddict[rd.par.INI_DATA_PICKLE_JSONFILE_LIST]:
        use_json = rd.ini.ddict[rd.par.INI_DATA_PICKLE_USE_JSON]
    else:
        use_json = 0
    # end if

    # pickle object
    rd.allg.pickle_obj = hpickle.DataPickle(rd.par.ALLG_PREFIX_NAME,rd.par.ALLG_DATA_NAME,use_json)
    if (rd.allg.pickle_obj.status != hdef.OK):
        status = hdef.NOT_OKAY
        errtext = rd.allg.pickle_obj.errtext
        return (status, errtext)
    # endif
    
    rd.allg.data_dict = rd.allg.pickle_obj.get_ddict()
    
    # class id anlegen
    #-----------------
    if rd.par.ID_MAX_NAME in rd.allg.data_dict:
        idmax = rd.allg.data_dict[rd.par.ID_MAX_NAME]
    else:
        idmax = 0
    # end if
    
    rd.allg.idfunc = depot_data_class_defs.IDCount()
    rd.allg.idfunc.set_act_id(idmax)

    # function wp-data anlgene
    #-------------------------
    # wp funktion wert papier rd.ini.ddict["wp_abfrage"]["store_path"]
    rd.allg.wpfunc = wp_base.WPData(rd.ini.ddict[rd.par.INI_WP_DATA_STORE_PATH_NAME]
                                   ,rd.ini.ddict[rd.par.INI_WP_DATA_USE_JSON_NAME])
    
    if (rd.allg.wpfunc.status != hdef.OK):
        status = hdef.NOT_OKAY
        errtext = rd.wpfunc.errtext
        return (status, errtext)
    # endif
    
    #================================================================================
    # read konto-pickle-file
    #================================================================================
    for konto_name in rd.ini.ddict[rd.par.INI_KONTO_DATA_LIST_NAMES_NAME]:
        
        konto_data_obj = KontoData()
        
        if konto_name in rd.ini.ddict[rd.par.INI_DATA_PICKLE_JSONFILE_LIST]:
            use_json = rd.ini.ddict[rd.par.INI_DATA_PICKLE_USE_JSON]
        else:
            use_json = 0
        # end if
        
        # get data set
        #-------------
        konto_data_obj.pickle_obj = hpickle.DataPickle(rd.par.KONTO_PREFIX, konto_name, use_json)
        if (konto_data_obj.pickle_obj.status != hdef.OK):
            status = hdef.NOT_OKAY
            errtext = konto_data_obj.pickle_obj.errtext
            return (status, errtext)
        else:
            konto_data_obj.data_dict = konto_data_obj.pickle_obj.get_ddict()
        # endif
        
        # type
        konto_data_obj.data_dict[rd.par.DDICT_TYPE_NAME] = rd.par.KONTO_DATA_TYPE_NAME
        
        # Umbau filter vorübergehend
        konto_data_obj.data_dict = umbau_kont_data_dict_filter(rd.par,depot_konto_data_set_class.KontoParam
                                                          ,konto_data_obj.data_dict)
        # Tvariable bilden
        konto_data_obj.data_dict_tvar = build_konto_transform_data_dict(rd.par,konto_data_obj.data_dict)
        
        # konto Klasse bilden
        konto_data_obj.konto_obj = depot_konto_data_set_class.KontoDataSet(konto_name,rd.allg.idfunc,rd.allg.wpfunc)
        
        # gespeicherte DatenSet übergeben  data_dict_tvar[]
        konto_data_obj.konto_obj.set_stored_data_set_tvar(konto_data_obj.data_dict_tvar[rd.par.KONTO_DATA_SET_TABLE_NAME]
                                                    ,rd.ini.dict_tvar[konto_name][rd.par.INI_START_DATUM_NAME]
                                                    ,rd.ini.dict_tvar[konto_name][rd.par.INI_START_WERT_NAME])
        
        rd.konto_dict[konto_name] = copy.deepcopy(konto_data_obj)
        
        del konto_data_obj
        
    # endfor

    #================================================================================
    # read csv-Daten from ini und lege klasse an
    #================================================================================
    for csv_config_name in rd.ini.ddict[rd.par.INI_CSV_IMPORT_CONFIG_NAMES_NAME]:
        
        if csv_config_name not in rd.ini.ddict.keys():
            raise Exception(f"data_set: {csv_config_name = } sind nicht im ini-File als section vorhanden")
        # end if
        
        csv_data_obj = CsvData()
        
        # Bilde data_dict von ini-Daten
        csv_data_obj.data_dict = get_csv_dict_values_from_ini(csv_config_name,rd.par,rd.ini.ddict[csv_config_name])
        
        # Tvariable bilden
        csv_data_obj.data_dict_tvar = build_csv_transform_data_dict(csv_config_name,rd.par,csv_data_obj.data_dict)
        
        # Klassen-Objekt erstellen
        csv_data_obj.csv_obj = depot_konto_csv_read_class.KontoCsvRead(csv_data_obj.data_dict_tvar[rd.par.CSV_TRENNZEICHEN]
                                                     ,csv_data_obj.data_dict_tvar[rd.par.CSV_WERT_PRUEFUNG]
                                                     ,csv_data_obj.data_dict_tvar[rd.par.CSV_BUCHTYPE_ZUORDNUNG_NAME]
                                                     ,csv_data_obj.data_dict_tvar[rd.par.CSV_HEADER_ZUORDNUNG_NAME]
                                                     ,csv_data_obj.data_dict_tvar[rd.par.CSV_HEADER_TYPE_ZUORDNUNG_NAME])
        
        rd.csv_dict[csv_config_name] = copy.deepcopy(csv_data_obj)
        
        del csv_data_obj
    # end for
    
    #================================================================================
    # proof csv-objekte mit konto
    #================================================================================
    for konto_name in rd.ini.ddict[rd.par.INI_KONTO_DATA_LIST_NAMES_NAME]:
        
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
                raise Exception(f"data_set: proof csv-objekte mit konto von {konto_name = } und {csv_config_name = } passt nicht {errtext = }")
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
    # end for
    
    #================================================================================
    #  depot-data pickle --------------------------------------------
    #================================================================================
    for depot_name in rd.ini.ddict[rd.par.INI_DEPOT_DATA_LIST_NAMES_NAME]:
        
        depot_data_obj = DepotData()
        
        if depot_name in rd.ini.ddict[rd.par.INI_DATA_PICKLE_JSONFILE_LIST]:
            use_json = rd.ini.ddict[rd.par.INI_DATA_PICKLE_USE_JSON]
        else:
            use_json = 0
        # end if
        
        # get data set
        depot_data_obj.pickle_obj = hpickle.DataPickle(rd.par.DEPOT_PREFIX, depot_name, use_json)
        if (depot_data_obj.pickle_obj.status != hdef.OK):
            status = hdef.NOT_OKAY
            errtext = depot_data_obj.pickle_obj.errtext
            return (status, errtext)
        else:
            depot_data_obj.data_dict = depot_data_obj.pickle_obj.get_ddict()
        # endif
        
        # type
        depot_data_obj.data_dict[rd.par.DDICT_TYPE_NAME] = rd.par.DEPOT_DATA_TYPE_NAME
        
        # Tvariable bilden
        depot_data_obj.data_dict_tvar = build_depot_transform_data_dict(rd.par,depot_data_obj.data_dict)
        
        # zugehöriges Konto
        konto_name = rd.ini.ddict[depot_name][rd.par.INI_DEPOT_KONTO_NAME]
        if konto_name not in rd.konto_dict:
            raise Exception(f"data_set: {konto_name = } sind nicht im ini-File als konto definition (section) vorhanden")
        # end if
        
        # depot obj Klasse
        depot_data_obj.depot_obj = depot_depot_data_set_class.DepotDataSet(depot_name
                                                                         ,depot_data_obj.data_dict[rd.par.DEPOT_DATA_ISIN_LIST_NAME]
                                                                         ,depot_data_obj.data_dict[rd.par.DEPOT_DATA_DEPOT_WP_LIST_NAME]
                                                                         ,rd.allg.wpfunc
                                                                         ,rd.konto_dict[konto_name].konto_obj)
        
        if (depot_data_obj.depot_obj.status != hdef.OK):
            status = hdef.NOT_OKAY
            errtext = depot_data_obj.depot_obj.errtext
            return (status, errtext)
        # end if
        
        # load each depot_wp_data_set
        wp_name_liste = depot_data_obj.depot_obj.get_wp_name_liste()
        for i,isin in enumerate(depot_data_obj.depot_obj.get_isin_liste()):
            
            wp_data_obj = WpData()
            
            wp_list_name = wp_name_liste[i]
            
            # get data set
            if wp_list_name in rd.ini.ddict[rd.par.INI_DATA_PICKLE_JSONFILE_LIST]:
                use_json_wp = rd.ini.ddict[rd.par.INI_DATA_PICKLE_USE_JSON]
            else:
                use_json_wp = 0
            # end if
            
            wp_data_obj.pickle_obj = hpickle.DataPickle(rd.par.DEPOT_WP_PREFIX, wp_list_name, use_json_wp)
            if (wp_data_obj.pickle_obj.status != hdef.OK):
                status = hdef.NOT_OKAY
                errtext = wp_data_obj.pickle_obj.errtext
                return (status, errtext)
            else:
                wp_data_obj.data_dict = wp_data_obj.pickle_obj.get_ddict()
            # endif
            
            if len(wp_data_obj.data_dict) == 0:
                depot_data_obj.depot_obj.set_stored_wp_data_set_ttable(isin,"",None)
                wp_data_obj.wp_obj = depot_data_obj.depot_obj.get_wp_data_obj(isin)
            else:
                wp_data_obj.data_dict[rd.par.DDICT_TYPE_NAME] = rd.par.DEPOT_WP_DATA_TYPE_NAME
            
                # Umbau filter vorübergehend
                try:
                    wp_data_obj.data_dict = umbau_wp_data_dict_filter(rd.par, wp_data_obj.data_dict)
                except:
                    wp_data_obj.data_dict = umbau_wp_data_dict_filter(rd.par, wp_data_obj.data_dict)
                # end try
            
                # Tvariable bilden
                wp_data_obj.data_dict_tvar = build_wp_transform_data_dict(rd.par, wp_data_obj.data_dict)
            
                depot_data_obj.depot_obj.set_stored_wp_data_set_ttable(wp_data_obj.data_dict[rd.par.ISIN]
                                                               ,wp_data_obj.data_dict[rd.par.WP_KATEGORIE]
                                                               ,wp_data_obj.data_dict_tvar[rd.par.WP_DATA_SET_TABLE_NAME])
                wp_data_obj.wp_obj = depot_data_obj.depot_obj.get_wp_data_obj(wp_data_obj.data_dict[rd.par.ISIN])
            # end if
            
            
            
            depot_data_obj.wp_obj_dict[wp_list_name] = copy.deepcopy(wp_data_obj)
            del wp_data_obj
        # end for
        
        rd.depot_dict[depot_name] = copy.deepcopy(depot_data_obj)
        
        del depot_data_obj
        
    # endfor
    
    #================================================================================
    # iban-liste pickle --------------------------------------------
    #================================================================================
    
    iban_data_obj = IbanData()
    
    if rd.ini.ddict[rd.par.INI_IBAN_LIST_FILE_NAME] in rd.ini.ddict[rd.par.INI_DATA_PICKLE_JSONFILE_LIST]:
        use_json = rd.ini.ddict[rd.par.INI_DATA_PICKLE_USE_JSON]
    else:
        use_json = 0
    # end if
    iban_data_obj.pickle_obj = hpickle.DataPickle(rd.par.IBAN_PREFIX, rd.ini.ddict[rd.par.INI_IBAN_LIST_FILE_NAME], use_json)
    
    if (iban_data_obj.pickle_obj.status != hdef.OK):
        status = hdef.NOT_OKAY
        errtext = iban_data_obj.pickle_obj.errtext
        return (status, errtext)
    else:
        iban_data_obj.data_dict = iban_data_obj.pickle_obj.get_ddict()
    # endif
    
    
    iban_data_obj.data_dict[rd.par.DDICT_TYPE_NAME] = rd.par.IBAN_DATA_TYPE_NAME
    
    # Umbau filter vorübergehend
    iban_data_obj.data_dict = umbau_iban_data_dict_filter(rd.par, iban_data_obj.data_dict)
    # Tvariable bilden
    iban_data_obj.data_dict_tvar = build_iban_transform_data_dict(rd.par,depot_iban_data_class.IbanParam, iban_data_obj.data_dict)
    
    
    iban_data_obj.iban_obj = depot_iban_data_class.IbanDataSet(iban_data_obj.data_dict_tvar[rd.par.IBAN_DATA_TABLE_NAME])
    
    if (iban_data_obj.iban_obj.status != hdef.OK):
        status = hdef.NOT_OKAY
        errtext = iban_data_obj.iban_obj.errtext
        return (status, errtext)
    # endif
    
    rd.iban = copy.deepcopy(iban_data_obj)
    
    del iban_data_obj
    
    return (status, errtext)
# end def
# --------------------------------------------------------------------------------------
#
# Set DATA Save to pickle
#
# --------------------------------------------------------------------------------------
def data_save(rd):
    status = hdef.OKAY
    errtext = ""
    
    # --------------------------------------------------------------------
    # allg data
    # --------------------------------------------------------------------
    #     rd.allg.pickle_obj
    #     rd.allg.data_dict
    #     rd.allg.idfunc
    #     rd.allg.wpfunc
    rd.allg.data_dict[rd.par.ID_MAX_NAME] = rd.allg.idfunc.get_act_id()
    rd.allg.pickle_obj.set_ddict(rd.allg.data_dict)
    
    
    rd.allg.pickle_obj.save(rd.allg.data_dict)
    if (rd.allg.pickle_obj.status != hdef.OKAY):
        status = hdef.NOT_OKAY
        errtext = f"{errtext}/ allg: {rd.allg.pickle_obj.errtext}"
    # endif

    # --------------------------------------------------------------------
    # konto data
    # --------------------------------------------------------------------
    #     rd.konto_dict[konto_name].pickle_obj
    #     rd.konto_dict[konto_name].data_dict
    #     rd.konto_dict[konto_name].data_dict_tvar
    #     rd.konto_dict[konto_name].konto_obj
    
    for konto_name in rd.konto_dict.keys():
        
        (ttable,_) = rd.konto_dict[konto_name].konto_obj.get_to_store_data_set_tvar()
        
        (val_dict_list,type_dict) = htvar.get_dict_list_from_table(ttable)
        rd.konto_dict[konto_name].data_dict[rd.par.KONTO_DATA_SET_DICT_LIST_NAME] = val_dict_list
        rd.konto_dict[konto_name].data_dict[rd.par.KONTO_DATA_TYPE_DICT_NAME]     = type_dict
        rd.konto_dict[konto_name].data_dict[rd.par.KONTO_DATA_BANK_NAME]     \
            = rd.konto_dict[konto_name].konto_obj.get_konto_name()

        rd.konto_dict[konto_name].pickle_obj.save(rd.konto_dict[konto_name].data_dict)
        if (rd.konto_dict[konto_name].pickle_obj.status != hdef.OKAY):
            status = hdef.NOT_OKAY
            errtext = f"{errtext}/ allg: {rd.konto_dict[konto_name].pickle_obj.errtext}"
        # endif
    #end for
    
    # --------------------------------------------------------------------
    # depot data
    # --------------------------------------------------------------------
    #     rd.depot_dict[depot_name].pickle_obj
    #     rd.depot_dict[depot_name].data_dict
    #     rd.depot_dict[depot_name].data_dict_tvar
    #     rd.depot_dict[depot_name].depot_obj
    #     rd.depot_dict[depot_name].wp_obj_dict
    for depot_name in rd.depot_dict.keys():
        rd.depot_dict[depot_name].data_dict[rd.par.DEPOT_DATA_ISIN_LIST_NAME] \
            = rd.depot_dict[depot_name].depot_obj.get_isin_liste()
        
        rd.depot_dict[depot_name].data_dict[rd.par.DEPOT_DATA_DEPOT_WP_LIST_NAME] \
            = rd.depot_dict[depot_name].depot_obj.get_wp_name_liste()
        
        rd.depot_dict[depot_name].pickle_obj.save(rd.depot_dict[depot_name].data_dict)
        if (rd.depot_dict[depot_name].pickle_obj.status != hdef.OKAY):
            status = hdef.NOT_OKAY
            errtext = f"{errtext}/ allg: {rd.depot_dict[depot_name].pickle_obj.errtext}"
        # endif

        # --------------------------------------------------------------------
        # wp data
        # --------------------------------------------------------------------
        #     rd.depot_dict[depot_name].wp_obj_dict[wp_list_name].pickle_obj
        #     rd.depot_dict[depot_name].wp_obj_dict[wp_list_name].data_dict
        #     rd.depot_dict[depot_name].wp_obj_dict[wp_list_name].data_dict_tvar
        #     rd.depot_dict[depot_name].wp_obj_dict[wp_list_name].wp_obj

        wp_name_liste = rd.depot_dict[depot_name].data_dict[rd.par.DEPOT_DATA_DEPOT_WP_LIST_NAME]
        for i,wp_list_name in enumerate(wp_name_liste):
            
            isin = rd.depot_dict[depot_name].data_dict[rd.par.DEPOT_DATA_ISIN_LIST_NAME][i]
            
            # for new isins:
            if wp_list_name not in rd.depot_dict[depot_name].wp_obj_dict:
                
                wp_data_obj = WpData()
                
                # get data set
                if wp_list_name in rd.ini.ddict[rd.par.INI_DATA_PICKLE_JSONFILE_LIST]:
                    use_json_wp = rd.ini.ddict[rd.par.INI_DATA_PICKLE_USE_JSON]
                else:
                    use_json_wp = 0
                # end if
                
                wp_data_obj.pickle_obj = hpickle.DataPickle(rd.par.DEPOT_WP_PREFIX, wp_list_name, use_json_wp)
                if (wp_data_obj.pickle_obj.status != hdef.OKAY):
                    status = hdef.NOT_OKAY
                    errtext = f"{errtext}/ allg: {wp_data_obj.pickle_obj.errtext}"
                # endif
                
                
                wp_data_obj.wp_obj = rd.depot_dict[depot_name].depot_obj.get_wp_data_obj(isin)
                
                rd.depot_dict[depot_name].wp_obj_dict[wp_list_name] = wp_data_obj
            else:
                rd.depot_dict[depot_name].wp_obj_dict[wp_list_name].wp_obj = rd.depot_dict[depot_name].depot_obj.get_wp_data_obj(isin)
            # end if
            
            rd.depot_dict[depot_name].wp_obj_dict[wp_list_name].data_dict[rd.par.ISIN] = \
                rd.depot_dict[depot_name].wp_obj_dict[wp_list_name].wp_obj.get_isin()
            rd.depot_dict[depot_name].wp_obj_dict[wp_list_name].data_dict[rd.par.WP_NAME] = \
                rd.depot_dict[depot_name].wp_obj_dict[wp_list_name].wp_obj.get_depot_wp_name()
            rd.depot_dict[depot_name].wp_obj_dict[wp_list_name].data_dict[rd.par.WP_KATEGORIE] = \
                rd.depot_dict[depot_name].wp_obj_dict[wp_list_name].wp_obj.get_kategorie()

            ttable = rd.depot_dict[depot_name].wp_obj_dict[wp_list_name].wp_obj.get_wp_data_set_ttable_to_store()
            rd.depot_dict[depot_name].wp_obj_dict[wp_list_name].data_dict_tvar[rd.par.WP_DATA_SET_TABLE_NAME] = ttable
            
            (val_dict_list, type_dict) = htvar.get_dict_list_from_table(ttable)
            rd.depot_dict[depot_name].wp_obj_dict[wp_list_name].data_dict[rd.par.WP_DATA_SET_DICT_LIST] = val_dict_list
            rd.depot_dict[depot_name].wp_obj_dict[wp_list_name].data_dict[rd.par.WP_DATA_SET_TYPE_DICT] = type_dict

            rd.depot_dict[depot_name].wp_obj_dict[wp_list_name].pickle_obj.save(rd.depot_dict[depot_name].wp_obj_dict[wp_list_name].data_dict)
            if (rd.depot_dict[depot_name].wp_obj_dict[wp_list_name].pickle_obj.status != hdef.OKAY):
                status = hdef.NOT_OKAY
                errtext = f"{errtext}/ allg: {rd.depot_dict[depot_name].wp_obj_dict[wp_list_name].pickle_obj.errtext}"
            # endif
        # end for wp
    # end for depot

    # --------------------------------------------------------------------
    # iban data
    # --------------------------------------------------------------------
    #     rd.iban.pickle_obj
    #     rd.allg.data_dict
    #     rd.allg.idfunc
    #     rd.allg.wpfunc
    #     rd.iban
    #####
    
    # # first get depot wk data into data dict
    # for key in data:
    #     if par.DDICT_TYPE_NAME in data[key].ddict.keys():
#             #--------------------------------------------------------------------
#             # konto data
#             #--------------------------------------------------------------------
#             # end if
#             if data[key].ddict[par.DDICT_TYPE_NAME] == par.KONTO_DATA_TYPE_NAME:
#                 # get data from konto set class to save
#                 if par.KONTO_DATA_SET_NAME in data[key].ddict.keys():
#                     data[key].ddict[par.KONTO_DATA_SET_NAME] = data[key].obj.data_set_llist
#                 # end if
#                 data[key].ddict[par.KONTO_DATA_SET_DICT_LIST_NAME] = data[key].obj.get_data_set_dict_ttable()
#                 data[key].ddict[par.KONTO_DATA_TYPE_DICT_NAME] = data[key].obj.get_data_type_dict()
# #                if close_flag:
# #                    del data[key].obj
#             # --------------------------------------------------------------------
#             # depot data
#             # --------------------------------------------------------------------
#             elif data[key].ddict[par.DDICT_TYPE_NAME] == par.DEPOT_DATA_TYPE_NAME:
#
#                 data[key].ddict[par.DEPOT_DATA_ISIN_LIST_NAME] = data[key].obj.get_to_store_isin_list()
#                 data[key].ddict[par.DEPOT_DATA_DEPOT_WP_LIST_NAME] = data[key].obj.get_to_store_depot_wp_name_list()
#
#                 # --------------------------------------------------------------------
#                 # einzelne neue wp daten  aus dem depot speichern
#                 # --------------------------------------------------------------------
#                 data_wp = {}
#                 for i,wp_list_name in enumerate(data[key].ddict[par.DEPOT_DATA_DEPOT_WP_LIST_NAME]):
#
#                     if wp_list_name not in data.keys():
#
#                         if wp_list_name in inidict[par.INI_DATA_PICKLE_JSONFILE_LIST]:
#                             use_json = inidict[par.INI_DATA_PICKLE_USE_JSON]
#                         else:
#                             use_json = 0
#                         # end if
#                         data_wp[wp_list_name] = depot_data_pickle.depot_data_pickle(par.DEPOT_WP_PREFIX, wp_list_name, use_json)
#
#
#                         isin = data[key].ddict[par.DEPOT_DATA_ISIN_LIST_NAME][i]
#                         data_wp[wp_list_name].ddict = data[key].obj.get_wp_data_set_dict_to_store(isin)
#                         data_wp[wp_list_name].ddict[par.DDICT_TYPE_NAME] = par.DEPOT_WP_DATA_TYPE_NAME
#                         data_wp[wp_list_name].ddict[par.DEPOT_WP_DEPOT_NAME_KEY] = key
#
#                         if data[key].obj.status != hdef.OKAY:
#                             raise Exception(f"ddict aus wp_data_set für isin = {isin} gibt es nicht, errtext={data[key].obj.errtext}")
#                         # end if
#
#                         data_wp[wp_list_name].save()
#
#                         if (data_wp[wp_list_name].status != hdef.OKAY):
#                             status = hdef.NOT_OKAY
#                             errtext = data_wp[wp_list_name].errtext
#                             return (status, errtext)
#                         # endif
# #                    else:
# #                        data_wp[wp_list_name] = data[wp_list_name]
#                     # end if
#                 # end for
# #                if close_flag:
# #                    del data[key].obj
#             # --------------------------------------------------------------------
#             # depot kown wp data
#             # --------------------------------------------------------------------
#             elif data[key].ddict[par.DDICT_TYPE_NAME] == par.DEPOT_WP_DATA_TYPE_NAME:
#
#
#                 isin      = data[key].ddict["isin"]
#                 depot_key = data[key].ddict[par.DEPOT_WP_DEPOT_NAME_KEY]
#
#                 data[key].ddict = data[depot_key].obj.get_wp_data_set_dict_to_store(isin)
#                 data[key].ddict[par.DDICT_TYPE_NAME] = par.DEPOT_WP_DATA_TYPE_NAME
#                 data[key].ddict[par.DEPOT_WP_DEPOT_NAME_KEY] = depot_key
#             # --------------------------------------------------------------------
#             # program data
#             # --------------------------------------------------------------------
#             elif data[key].ddict[par.DDICT_TYPE_NAME] == par.PROG_DATA_TYPE_NAME:
#                 data[key].ddict[par.KONTO_DATA_ID_MAX_NAME] = data[key].idfunc.get_act_id()
# #                if close_flag:
# #                    del data[key].idfunc
#             # end if
#         else:
#             raise Exception(f"key = {key} not updated")
#         # end if
#     # end for
#
#     # save all data[key]ddict:
#     for key in data:
#
#         data[key].save()
#
#         if (data[key].status != hdef.OKAY):
#             status = hdef.NOT_OKAY
#             errtext = data[key].errtext
#         # endif
#     # endfor
    
    return (status, errtext)


# enddef
def umbau_kont_data_dict_filter(par,konto_par,data_dict):
    
    data_dict_out = {}
    
    data_dict_out[par.DDICT_TYPE_NAME] = data_dict[par.DDICT_TYPE_NAME]
    
    data_dict_out[par.KONTO_DATA_SET_DICT_LIST_NAME] = data_dict[par.KONTO_DATA_SET_DICT_LIST_NAME]

    data_dict_out[par.KONTO_DATA_TYPE_DICT_NAME] = data_dict[par.KONTO_DATA_TYPE_DICT_NAME]

    # change buchtype if still int
    data_dict_out[par.KONTO_DATA_TYPE_DICT_NAME]["buchtype"] = konto_par.KONTO_BUCHTYPE_TEXT_LIST
        
    for i in range(len(data_dict_out[par.KONTO_DATA_SET_DICT_LIST_NAME])):
        
        index = data_dict_out[par.KONTO_DATA_SET_DICT_LIST_NAME][i]["buchtype"]
        
        if isinstance(index,int):
            data_dict_out[par.KONTO_DATA_SET_DICT_LIST_NAME][i]["buchtype"] = konto_par.KONTO_BUCHTYPE_TEXT_LIST[index]
        # end if
    # end for
    
    return data_dict_out
# end def
def build_konto_transform_data_dict(par,data_dict):
    '''
    
    :param par:
    :param data_dict:
    :return: data_dict_tvar = build_konto_transform_data_dict(par,data_dict)
    '''

    data_dict_tvar = {}
    
    # DDICT_TYPE_NAME
    data_dict_tvar[par.DDICT_TYPE_NAME] = htvar.build_val(par.DDICT_TYPE_NAME,data_dict[par.DDICT_TYPE_NAME],'str')
    
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
    data_dict_tvar[par.KONTO_DATA_SET_TABLE_NAME] = htvar.build_table(names,table,types)
    
    return data_dict_tvar
# end def
def get_csv_dict_values_from_ini(csv_config_name,par,ini_dict):
    '''
    
    :param par:
    :param ini:
    :return: data_dict = get_csv_dict_values_from_ini(par,ini)
    '''
    
    data_dict = {}
    
    # type
    data_dict[par.DDICT_TYPE_NAME] = par.CSV_DATA_TYPE_NAME

    # INI_CSV_PROOF_LISTE = [(INI_CSV_TRENNZEICHEN, "str")
    #     , (INI_CSV_HEADER_NAMEN, "list")
    #     , (INI_CSV_HEADER_ZUORDNUNG, "list_str")
    #     , (INI_CSV_HEADER_DATA_TYPE, "list_str")
    #     , (INI_CSV_BUCHTYPE_NAMEN, "list")
    #     , (INI_CSV_BUCHTYPE_ZUORDNUNG, "list_str")]

    # Trennungszeichen in csv-Datei
    #--------------------------------
    data_dict[par.CSV_TRENNZEICHEN] = ini_dict[par.INI_CSV_TRENNZEICHEN]

    # wert prüfung in csv-Datei
    #--------------------------------
    data_dict[par.CSV_WERT_PRUEFUNG] = ini_dict[par.INI_CSV_WERT_PRUEFUNG]

    # build buchungstype list from ini-File for csv-file
    # ---------------------------------------------------
    n = min(len(ini_dict[par.INI_CSV_BUCHTYPE_NAMEN]), len(ini_dict[par.INI_CSV_BUCHTYPE_ZUORDNUNG]))
    
    csv_buchungs_zuordnung_dict = {}
    for i in range(n):
        buchtype_zuordnung = ini_dict[par.INI_CSV_BUCHTYPE_ZUORDNUNG][i]
        buchtype_name = ini_dict[par.INI_CSV_BUCHTYPE_NAMEN][i]
        
        csv_buchungs_zuordnung_dict[buchtype_zuordnung] = buchtype_name
    # end for
    
    # unbekannt hinzu fügen
    if "unbekannt" not in csv_buchungs_zuordnung_dict.keys():
        csv_buchungs_zuordnung_dict["unbekannt"] = ""
    
    data_dict[par.CSV_BUCHTYPE_DICT] = csv_buchungs_zuordnung_dict

    # Bilde list für header name csv, index und buchungstype
    # -------------------------------------------------------
    n = min(len(ini_dict[par.INI_CSV_HEADER_NAMEN]), len(ini_dict[par.INI_CSV_HEADER_ZUORDNUNG]))
    n = min(n, len(ini_dict[par.INI_CSV_HEADER_DATA_TYPE]))
    
    csv_header_name_liste = []
    csv_header_zuordnung_liste = []
    csv_header_type_liste = []
    for i in range(n):
        header_name = ini_dict[par.INI_CSV_HEADER_NAMEN][i]
        header_zuordnung = ini_dict[par.INI_CSV_HEADER_ZUORDNUNG][i]
        header_data_type = ini_dict[par.INI_CSV_HEADER_DATA_TYPE][i]
        csv_header_name_liste.append(header_name)
        csv_header_type_liste.append(header_data_type)
        csv_header_zuordnung_liste.append(header_zuordnung)
    # end for
    
    data_dict[par.CSV_HEADER_NAME_LISTE] = csv_header_name_liste
    data_dict[par.CSV_HEADER_TYPE_LISTE] = csv_header_type_liste
    data_dict[par.CSV_HEADER_ZUORDNUNG_LISTE] = csv_header_zuordnung_liste

    return data_dict
# end def
def build_csv_transform_data_dict(csv_config_name,par,data_dict):
    '''
    
    :param par:
    :param data_dict:
    :return: data_dict_tvar = build_csv_transform_data_dict(par,data_dict)
    '''
    data_dict_tvar = {}
    
    # DDICT_TYPE_NAME
    data_dict_tvar[par.DDICT_TYPE_NAME] = htvar.build_val(par.DDICT_TYPE_NAME, data_dict[par.DDICT_TYPE_NAME], 'str')
    
    # CSV_TRENNZEICHEN
    data_dict_tvar[par.CSV_TRENNZEICHEN] = htvar.build_val(par.CSV_TRENNZEICHEN, data_dict[par.CSV_TRENNZEICHEN], 'str')

    # CSV_WERT_PRUEFUNG
    data_dict_tvar[par.CSV_WERT_PRUEFUNG] = htvar.build_val(par.CSV_WERT_PRUEFUNG, data_dict[par.CSV_WERT_PRUEFUNG], 'str')

    # CSV_BUCHTYPE_ZUORDNUNG_NAME
    names = list(data_dict[par.CSV_BUCHTYPE_DICT].keys())
    vals  = list(data_dict[par.CSV_BUCHTYPE_DICT].values())
    types = []
    for val in vals:
        if isinstance(val,str):
            types.append("str")
        else:
            types.append("list_str")
        # end if
    # end for
    data_dict_tvar[par.CSV_BUCHTYPE_ZUORDNUNG_NAME] = htvar.build_list(names, vals, types)
    
    # CSV_HEADER_ZUORDNUNG_NAME
    names = data_dict[par.CSV_HEADER_ZUORDNUNG_LISTE]
    vals  = data_dict[par.CSV_HEADER_NAME_LISTE]
    types = []
    for val in vals:
        if isinstance(val,str):
            types.append("str")
        else:
            types.append("list_str")
        # end if
    # end for
    
    data_dict_tvar[par.CSV_HEADER_ZUORDNUNG_NAME] = htvar.build_list(names, vals, types)
    
    # CSV_HEADER_TYPE_ZUORDNUNG_NAME
    names = data_dict[par.CSV_HEADER_ZUORDNUNG_LISTE]
    vals = data_dict[par.CSV_HEADER_TYPE_LISTE]
    types = []
    for val in vals:
        if isinstance(val,str):
            types.append("str")
        else:
            types.append("list_str")
        # end if
    # end for

    data_dict_tvar[par.CSV_HEADER_TYPE_ZUORDNUNG_NAME] = htvar.build_list(names, vals, types)
    
    for type_name in vals:
        if htype.type_name_proof(type_name) != hdef.OKAY:
            raise Exception(
                f"data_set.build_csv_transform_data_dict: In section  {csv_config_name = } ist {type_name = } nicht korrekt")
        # end if
    # end for

    return data_dict_tvar
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
                                                                   ,val
                                                                   ,'list_str')

    # DEPOT_DATA_DEPOT_WP_LIST_NAME
    if par.DEPOT_DATA_DEPOT_WP_LIST_NAME in data_dict.keys():
        val = data_dict[par.DEPOT_DATA_DEPOT_WP_LIST_NAME]
    else:
        val = []
    # end if
    data_dict_tvar[par.DEPOT_DATA_DEPOT_WP_LIST_NAME] = htvar.build_val(par.DEPOT_DATA_DEPOT_WP_LIST_NAME
                                                                       , val
                                                                       ,'list_str')

    return data_dict_tvar


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
def umbau_iban_data_dict_filter(par, data_dict):
    data_dict_out = {}
    
    data_dict_out[par.DDICT_TYPE_NAME] = data_dict[par.DDICT_TYPE_NAME]
    
    if par.IBAN_DATA_LIST_NAME in data_dict.keys():
        
        lliste0 = data_dict[par.IBAN_DATA_LIST_NAME]
        lliste  = []
        for liste0 in lliste0:
            if len(liste0) > 4:
                liste = liste0[1:5]
            else:
                liste = liste0
            # end if
            lliste.append(liste)
        # end for
        data_dict_out[par.IBAN_DATA_LIST_NAME] = lliste
    else:
        data_dict_out[par.IBAN_DATA_LIST_NAME] = []
    # end if
    return data_dict_out


# end def
def build_iban_transform_data_dict(par, iban_par, data_dict):
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
    
    if par.IBAN_DATA_LIST_NAME in data_dict.keys():
        
        names = iban_par.IBAN_DATA_NAME_LIST
        types = iban_par.IBAN_DATA_TYPE_LIST
        table = data_dict[par.IBAN_DATA_LIST_NAME]
    else:
        names = []
        types = []
        table = []
    # end if
    data_dict_tvar[par.IBAN_DATA_TABLE_NAME] = htvar.build_table(names, table, types)
    
    return data_dict_tvar


# end def

# def build_konto_data_csv_obj(par, konto_data, konto_name,ini_data_dict):
#     #----------------------------------------------------------------------------
#     # Set parameter for konto csv read
#     #----------------------------------------------------------------------------
#
#     # import data type
#     #----------------------------------------------------------------------------
#     key = par.INI_IMPORT_CONFIG_TYPE_NAME
#     if key in konto_data.ddict:
#         import_data_type = konto_data.ddict[key]
#     else:
#         raise Exception(f"build_konto_data_csv_obj: import_data_type = konto_data.ddict[{key}] of konto_name = {konto_name} ist nicht im ini-File")
#     # end if
#
#     # No import type
#     if( len(import_data_type) == 0 ) or (import_data_type == "none"):
#         konto_data.csv = None
#         return konto_data
#     # end if
#
#     if import_data_type not in ini_data_dict[par.INI_CSV_IMPORT_TYPE_NAMES_NAME]:
#         raise Exception(
#             f"build_konto_data_csv_obj: import_data_type = {import_data_type} of konto_name = {konto_name} ist nicht in der Liste der csv_import_type_names = {par.INI_CSV_IMPORT_TYPE_NAMES_NAME} im ini-File")
#     # end if
#
#     csv_import_dict = ini_data_dict[import_data_type]
#
#     # Trennungszeichen in csv-Datei
#     #--------------------------------
#     key = par.INI_CSV_TRENNZEICHEN
#     if key in csv_import_dict:
#         wert_trenn = csv_import_dict[key]
#     else:
#         raise Exception(f"key {par.INI_CSV_TRENNZEICHEN} not ini-File in sction [{import_data_type}]of konto: {konto_name}")
#     # end if
#
#     # Klassen-Objekt erstellen
#     csv = depot_konto_csv_read_class.KontoCsvRead()
#     csv.set_csv_trennzeichen(wert_trenn)
#
#
#     # build buchungstype list from ini-File for csv-file
#     #---------------------------------------------------
#     n = min(len(csv_import_dict[par.INI_CSV_BUCHTYPE_NAMEN]),len(csv_import_dict[par.INI_CSV_BUCHTYPE_ZUORDNUNG]))
#
#     csv_buchungs_typ_liste = ["" for i in konto_data.obj.KONTO_BUCHTYPE_INDEX_LIST]
#
#     for i in range(n):
#         buchtype_zuordnung = csv_import_dict[par.INI_CSV_BUCHTYPE_ZUORDNUNG][i]
#         buchtype_name      = csv_import_dict[par.INI_CSV_BUCHTYPE_NAMEN][i]
#
#         buchtype_index = konto_data.obj.get_buchtype_index(buchtype_zuordnung)
#         if buchtype_index is None:
#             raise Exception(
#                 f"build_konto_data_csv_obj: buchtype_zuordnung = {buchtype_zuordnung} aus section [{import_data_type}]of konto: {konto_name} kann nicht in Klasse KontoDataSet (depot_konto_data_set_class) gefunden werden")
#         # end if
#
#         # Suche den Index in der Index-Liste
#
#         try:
#             index = konto_data.obj.KONTO_BUCHTYPE_INDEX_LIST.index(buchtype_index)
#         except ValueError:
#             raise Exception(
#                 f"build_konto_data_csv_obj: buchtype_index = {buchtype_index} von  konto_data.obj.get_buchtype_index(buchtype_zuordnung) buchtype_zuordnung = {buchtype_zuordnung}of konto: {konto_name} kann nicht in Klasse KontoDataSet (depot_konto_data_set_class) gefunden werden")
#         # end try
#         csv_buchungs_typ_liste[index] = buchtype_name
#     # end for
#
#     # unbekannt hinzu fügen
#     index = konto_data.obj.KONTO_BUCHTYPE_INDEX_LIST.index(konto_data.obj.KONTO_BUCHTYPE_INDEX_UNBEKANNT)
#     if csv_buchungs_typ_liste[index] == "":
#         csv_buchungs_typ_liste[index] = "unbekannt"
#     # end if
#
#
#     # Bilde list für header name csv, index und buchungstype
#     #-------------------------------------------------------
#     n = min(len(csv_import_dict[par.INI_CSV_HEADER_NAMEN]), len(csv_import_dict[par.INI_CSV_HEADER_ZUORDNUNG]))
#     n = min(n,len(csv_import_dict[par.INI_CSV_HEADER_DATA_TYPE]))
#
#     for i in range(n):
#         header_name = csv_import_dict[par.INI_CSV_HEADER_NAMEN][i]
#         header_zuordnung = csv_import_dict[par.INI_CSV_HEADER_ZUORDNUNG][i]
#         header_data_type = csv_import_dict[par.INI_CSV_HEADER_DATA_TYPE][i]
#         index = konto_data.obj.get_name_index(header_zuordnung)
#         if index is None:
#             raise Exception(
#                 f"build_konto_data_csv_obj: header_zuordnung = {header_zuordnung} aus section [{import_data_type}]of konto: {konto_name} kann nicht in Klasse KontoDataSet (depot_konto_data_set_class) gefunden werden")
#         # end if
#         if index == konto_data.obj.KONTO_DATA_INDEX_BUCHTYPE:
#             csv.set_csv_header_name(index, header_name, csv_buchungs_typ_liste)
#         else:
#             csv.set_csv_header_name(index, header_name, header_data_type)
#         # end if
#     # end for
#
#     konto_data.csv = copy.deepcopy(csv)
#
#     del csv
#
#     return konto_data
#
# # end def
# --------------------------------------------------------------------------------------
#
# Set DEPOT DATA
#
# --------------------------------------------------------------------------------------
def proof_depot_data_from_ini(depot_data, ini_data_dict, par):
    """
    proof ini_data_dict in depot_data
    :param depot_data:
    :param ini_data_dict:
    :return:
    """
    
    for key in ini_data_dict:
        
        if (key in depot_data.ddict):
            if (ini_data_dict[key] != depot_data.ddict[key]):
                depot_data.ddict[key] = ini_data_dict[key]
            # endif
        else:
            depot_data.ddict[key] = ini_data_dict[key]
            # end if
        # endif
    # end for
    
    return depot_data


# end def
def proof_depot_data_intern(par, depot_data, depot_name):
    '''

    :param par
    :param depot_data:
    :param konto_name
    :return:depot_data =  proof_konto_data_intern(par,depot_data,konto_name)
    '''
    # type
    depot_data.ddict[par.DDICT_TYPE_NAME] = par.DEPOT_DATA_TYPE_NAME
    
    # depot name
    key = par.DEPOT_NAME
    if key in depot_data.ddict:
        if depot_name != depot_data.ddict[key]:
            depot_data.ddict[key] = depot_name
        # end if
    else:
        depot_data.ddict[key] = depot_name
    # end if
    
    # isin list name
    key = par.DEPOT_DATA_ISIN_LIST_NAME
    if key not in depot_data.ddict.keys():
        depot_data.ddict[key] = []
    # end if

    # depot wp list name
    key = par.DEPOT_DATA_DEPOT_WP_LIST_NAME
    if key not in depot_data.ddict.keys():
        depot_data.ddict[key] = []
    # end if

    return depot_data


# end def
# def build_depot_data_set_obj(par, depot_data, depot_name,wpfunc):
#     '''
#
#     :param par:
#     :param depot_data:
#     :param depot_name:
#     :return: depot_data =  build_konto_data_set_obj(par, depot_data, depot_name):
#     '''
#
#     # ----------------------------------------------------------------------------
#     # Set parameter for konto Data
#     # ----------------------------------------------------------------------------
#     # isin_list set anlegen
#     #----------------------
#     key = par.DEPOT_DATA_ISIN_LIST_NAME
#     if key in depot_data.ddict:
#         isin_list = depot_data.ddict[key]
#     else:
#         isin_list = []
#     # end if
#
#     obj = depot_depot_data_set_class.DepotDataSet(depot_name,isin_list,wpfunc)
#
#     depot_data.obj = copy.deepcopy(obj)
#
#     del obj
#
#     #
#     # # class KontoDataSet anlegen
#     # obj.set_stored_data(isin_list,depot_data_set_dict_list,depot_data_type_dict)
#     # if obj.status != hdef.OKAY:
#     #     raise Exception(obj.errtext)
#     # # end if
#     # if key in depot_data.ddict:
#     #     del depot_data.ddict[key]
#     # # end if
#     #
#
#     return depot_data


# end def



# --------------------------------------------------------------------------------------
#
# Set IBAN DATA
#
# --------------------------------------------------------------------------------------
# def proof_iban_data_and_add_from_ini(iban_data, par, data, inidict):
#     status = hdef.OK
#     errtext = ""
#
#     iban_data.ddict[par.DDICT_TYPE_NAME] = par.IBAN_DATA_TYPE_NAME
#
#     if (par.IBAN_DATA_LIST_NAME not in iban_data.ddict):
#         iban_data.ddict[par.IBAN_DATA_LIST_NAME] = []
#         iban_data.ddict[par.IBAN_DATA_ID_MAX_NAME] = 0
#     # end if
#
#     # Suche nach ibans in konto-Daten
#     for konto_name in inidict[par.INI_KONTO_DATA_LIST_NAMES_NAME]:
#
#         dkonto = data[konto_name]
#
#         if not depot_iban_data.iban_find(iban_data.ddict[par.IBAN_DATA_LIST_NAME], dkonto.ddict[par.INI_IBAN_NAME]):
#             idmax = iban_data.ddict[par.IBAN_DATA_ID_MAX_NAME] + 1
#             (status, errtext, _, data_list) = depot_iban_data.iban_add(iban_data.ddict[par.IBAN_DATA_LIST_NAME], idmax,
#                                                                     dkonto.ddict[par.INI_IBAN_NAME],
#                                                                     dkonto.ddict[par.INI_BANK_NAME],
#                                                                     dkonto.ddict[par.INI_WER_NAME], "")
#             if (status != hdef.OK):
#                 return (status, errtext, iban_data)
#             else:
#                 iban_data.ddict[par.IBAN_DATA_LIST_NAME] = data_list
#                 iban_data.ddict[par.IBAN_DATA_ID_MAX_NAME] = idmax
#             # endif
#         # endnif
#     # endif
#
#     return (status, errtext, iban_data)
# edndef