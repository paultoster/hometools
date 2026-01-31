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
#     rd.allg.kat_json_obj
#     rd.allg.katfunc
#     rd.allg.kat_dict
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



import depot_data_init_allg
import depot_data_init_iban
import depot_data_init_konto
import depot_data_init_csv
import depot_data_init_depot

# @dataclass
# class AllgData:
#     pickle_obj = None
#     data_dict: dict = field(default_factory=dict)
#     idfunc = None   # : dclassdef.IDCount = field(default_factory=dclassdef.IDCount)
#     wpfunc = None   # : wp_base.WPData = field(default_factory=wp_base.WPData)
#     banknamefunc = None
#     kat_json_obj = None
#     katfunc = None  # konto kategorie
#     kat_dict: dict = field(default_factory=dict)

# @dataclass
# class KontoData:
#     pickle_obj = None
#     data_dict: dict = field(default_factory=dict)
#     data_dict_tvar: dict = field(default_factory=dict)
#     konto_obj = None

# @dataclass
# class CsvData:
#     data_dict: dict = field(default_factory=dict)
#     data_dict_tvar: dict = field(default_factory=dict)
#     csv_obj = None

# @dataclass
# class DepotData:
#     pickle_obj = None
#     data_dict: dict = field(default_factory=dict)
#     data_dict_tvar: dict = field(default_factory=dict)
#     wp_obj_dict: dict = field(default_factory=dict)
#     depot_obj = None

# @dataclass
# class WpData:
#     pickle_obj = None
#     data_dict: dict = field(default_factory=dict)
#     data_dict_tvar: dict = field(default_factory=dict)
#     wp_obj = None

# @dataclass
# class IbanData:
#     pickle_obj = None
#     data_dict: dict = field(default_factory=dict)
#     data_dict_tvar: dict = field(default_factory=dict)
#     iban_obj = None


# --------------------------------------------------------------------------------------
#
# Get DATA Start
#
# --------------------------------------------------------------------------------------
def data_read(rd):
    '''

    :param rd: data-structure
    :return:  (status, errtext) = data_get(rd)
    '''
    # status = hdef.OKAY
    # errtext = ""
    # data = {}
    
    #================================================================================
    # read allgeine-pickle-file
    #================================================================================
    (rd.allg,status,errtext) = depot_data_init_allg.read(rd)
    
    if status != hdef.OK:
        return (status, errtext)
    # end if
    
    # ================================================================================
    # iban-liste pickle --------------------------------------------
    # ================================================================================
    (rd.iban, status, errtext) = depot_data_init_iban.read(rd)
    
    if status != hdef.OK:
        return (status, errtext)
    # end if

    
    #================================================================================
    # read konto-pickle-file
    #================================================================================
    for konto_name in rd.ini.ddict[rd.par.INI_KONTO_DATA_LIST_NAMES_NAME]:
        
        (rd.konto_dict[konto_name],status, errtext) = depot_data_init_konto.read(rd,konto_name)

        if status != hdef.OK:
            return (status, errtext)
        # end if

    # endfor

    #================================================================================
    # read csv-Daten from ini und lege klasse an
    #================================================================================
    for csv_config_name in rd.ini.ddict[rd.par.INI_CSV_IMPORT_CONFIG_NAMES_NAME]:
        
        if csv_config_name not in rd.ini.ddict.keys():
            raise Exception(f"data_set: {csv_config_name = } sind nicht im ini-File als section vorhanden")
        # end if

        (rd.csv_dict[csv_config_name], status, errtext) = depot_data_init_csv.read(rd, csv_config_name)

        if status != hdef.OK:
            return (status, errtext)
        # end if

    # end for
    
    #================================================================================
    # proof csv-objekte mit konto
    #================================================================================
    for konto_name in rd.ini.ddict[rd.par.INI_KONTO_DATA_LIST_NAMES_NAME]:
        
        (status,errtext) = depot_data_init_konto.set_csv_func(rd,konto_name)

        if status != hdef.OK:
            return (status, errtext)
        # end if

    # end for
    
    #================================================================================
    #  depot-data pickle --------------------------------------------
    #================================================================================
    for depot_name in rd.ini.ddict[rd.par.INI_DEPOT_DATA_LIST_NAMES_NAME]:
        
        (rd.depot_dict[depot_name], status, errtext) = depot_data_init_depot.read(rd, depot_name)
        
        if status != hdef.OK:
            return (status, errtext)
        # end if
        
        konto_name = rd.ini.ddict[depot_name][rd.par.INI_DEPOT_KONTO_NAME]
        print(f"{depot_name =} {konto_name =}")
    
    # endfor
    
    for depot_name in rd.ini.ddict[rd.par.INI_DEPOT_DATA_LIST_NAMES_NAME]:
        print('-=-' * 30)
        konto_name = rd.depot_dict[depot_name].depot_obj.konto_name
        print(f"depot konto_obj {rd.depot_dict[depot_name].depot_obj.konto_obj = } \n == external set {rd.konto_dict[konto_name].konto_obj =}")
        print('-=-' * 30)
    # end for
    
    
    return (status, errtext)
# end def
# --------------------------------------------------------------------------------------
#
# Set DATA Save to pickle
#
# --------------------------------------------------------------------------------------
def data_save(rd):
    # status = hdef.OKAY
    # errtext = ""
    
    # --------------------------------------------------------------------
    # allg data
    #     rd.allg.pickle_obj
    #     rd.allg.data_dict
    #     rd.allg.idfunc
    #     rd.allg.wpfunc
    #     rd.allg.katfunc
    # --------------------------------------------------------------------
    (status,errtext) = depot_data_init_allg.save(rd)
    
    if status != hdef.OK:
        return (status,errtext)
    # end def

    # --------------------------------------------------------------------
    # iban data
    # --------------------------------------------------------------------
    #     rd.iban.pickle_obj
    #     rd.iban
    (status,errtext) = depot_data_init_iban.save(rd)
    
    if status != hdef.OK:
        return (status, errtext)
    # end def
    
    # --------------------------------------------------------------------
    # konto data
    # --------------------------------------------------------------------
    #     rd.konto_dict[konto_name].pickle_obj
    #     rd.konto_dict[konto_name].data_dict
    #     rd.konto_dict[konto_name].data_dict_tvar
    #     rd.konto_dict[konto_name].konto_obj
    
    for konto_name in rd.konto_dict.keys():
        
        (status, errtext) = depot_data_init_konto.save(rd,rd.konto_dict[konto_name])

        if status != hdef.OK:
            return (status,errtext)
        # end def

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
        
        (status, errtext) = depot_data_init_depot.save(rd, rd.depot_dict[depot_name],depot_name)

        if status != hdef.OK:
            return (status,errtext)
        # end def

    # end for depot

    
    return (status, errtext)
# enddef
# # --------------------------------------------------------------------------------------
# #
# # Set DEPOT DATA
# #
# # --------------------------------------------------------------------------------------
# def proof_depot_data_from_ini(depot_data, ini_data_dict, par):
#     """
#     proof ini_data_dict in depot_data
#     :param depot_data:
#     :param ini_data_dict:
#     :return:
#     """
#
#     for key in ini_data_dict:
#
#         if (key in depot_data.ddict):
#             if (ini_data_dict[key] != depot_data.ddict[key]):
#                 depot_data.ddict[key] = ini_data_dict[key]
#             # endif
#         else:
#             depot_data.ddict[key] = ini_data_dict[key]
#             # end if
#         # endif
#     # end for
#
#     return depot_data
#
#
# # end def
# def proof_depot_data_intern(par, depot_data, depot_name):
#     '''
#
#     :param par
#     :param depot_data:
#     :param konto_name
#     :return:depot_data =  proof_konto_data_intern(par,depot_data,konto_name)
#     '''
#     # type
#     depot_data.ddict[par.DDICT_TYPE_NAME] = par.DEPOT_DATA_TYPE_NAME
#
#     # depot name
#     key = par.DEPOT_NAME
#     if key in depot_data.ddict:
#         if depot_name != depot_data.ddict[key]:
#             depot_data.ddict[key] = depot_name
#         # end if
#     else:
#         depot_data.ddict[key] = depot_name
#     # end if
#
#     # isin list name
#     key = par.DEPOT_DATA_ISIN_LIST_NAME
#     if key not in depot_data.ddict.keys():
#         depot_data.ddict[key] = []
#     # end if
#
#     # depot wp list name
#     key = par.DEPOT_DATA_DEPOT_WP_LIST_NAME
#     if key not in depot_data.ddict.keys():
#         depot_data.ddict[key] = []
#     # end if
#
#     return depot_data
#
#
# # end def
