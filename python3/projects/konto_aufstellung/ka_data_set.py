#
# data sets getting from pickle module or build new or also prolong
#
# mit data_get() und data_save werden alle pickles geholt und gespeichert
#
# data[par.konto_names]
# data[par.IBAN_DATA_DICT_NAME]
import copy
import os, sys
import pickle
import json
import pprint
import zlib
import traceback

# tools_path = os.getcwd() + "\\.."
# if (tools_path not in sys.path):
#   sys.path.append(tools_path)
# # endif

# Hilfsfunktionen
import hfkt_def as hdef
import hfkt_type as htype

import ka_iban_data
import ka_data_pickle
import ka_konto_data_set_class
import ka_konto_csv_read_class
import ka_depot_data_set_class
import ka_data_class_defs

# --------------------------------------------------------------------------------------
#
# Get DATA Start
#
# --------------------------------------------------------------------------------------
def data_get(par, inidict):
    '''

    :param par:
    :param ini:
    :return:  (status, errtext, data) = data_get(par,ini)
    '''
    status = hdef.OKAY
    errtext = ""
    data = {}
    
    # read allgeime-pickle-file
    #--------------------------
    for allg_name in inidict[par.INI_ALLG_DATA_DICT_NAMES_NAME]:
        
        if allg_name in inidict[par.INI_DATA_PICKLE_JSONFILE_LIST]:
            use_json = inidict[par.INI_DATA_PICKLE_USE_JSON]
        else:
            use_json = 0
        # end if
        allg_data = ka_data_pickle.ka_data_pickle(par.ALLG_PREFIX_NAME, allg_name,use_json)
        
        
        
        if allg_name == par.PROG_DATA_TYPE_NAME:
            allg_data = set_prog_data(par,allg_data)
        else:
            allg_data.status = hdef.NOT_OKAY
            allg_data.errtext = f"data_get: allg_name = {allg_name} ist nicht in if-struktur für allgemeine Daten"
        # end if
        
        if (allg_data.status != hdef.OK):
            status = hdef.NOT_OKAY
            errtext = allg_data.errtext
            return (status, errtext, data)
        else:
            data[allg_name] = allg_data
        # endif
    # end for
    
    # read konto-pickle-file
    for konto_name in inidict[par.INI_KONTO_DATA_DICT_NAMES_NAME]:
        if konto_name in inidict[par.INI_DATA_PICKLE_JSONFILE_LIST]:
            use_json = inidict[par.INI_DATA_PICKLE_USE_JSON]
        else:
            use_json = 0
        # end if
        
        # get data set
        konto_data = ka_data_pickle.ka_data_pickle(par.KONTO_PREFIX, konto_name, use_json)
        if (konto_data.status != hdef.OK):
            status = hdef.NOT_OKAY
            errtext = konto_data.errtext
            return (status, errtext, data)
        # endif
        
        konto_data = proof_konto_data_from_ini(par,konto_data, inidict[konto_name])
        konto_data = proof_konto_data_intern(par, konto_data, konto_name)
        konto_data = build_konto_data_set_obj(par, konto_data, konto_name,data[par.PROG_DATA_TYPE_NAME].idfunc)
        konto_data = build_konto_data_csv_obj(par, konto_data, konto_name,inidict)
        if (konto_data.status != hdef.OK):
            status = hdef.NOT_OKAY
            errtext = konto_data.errtext
            return (status, errtext, data)
        else:
            data[konto_name] = copy.deepcopy(konto_data)
            del konto_data
        # endif
    # endfor
    
    #  depot-data pickle --------------------------------------------
    for depot_name in inidict[par.INI_DEPOT_DATA_DICT_NAMES_NAME]:
        
        if depot_name in inidict[par.INI_DATA_PICKLE_JSONFILE_LIST]:
            use_json = inidict[par.INI_DATA_PICKLE_USE_JSON]
        else:
            use_json = 0
        # end if
        
        # get data set
        depot_data = ka_data_pickle.ka_data_pickle(par.DEPOT_PREFIX, depot_name, use_json)
        if (depot_data.status != hdef.OK):
            status = hdef.NOT_OKAY
            errtext = depot_data.errtext
            return (status, errtext, data)
        # endif
        
        depot_data = proof_depot_data_from_ini(depot_data, inidict[depot_name], par)
        depot_data = proof_depot_data_intern(par, depot_data, depot_name)
        depot_data = build_depot_data_set_obj(par, depot_data, depot_name, data)
        if (depot_data.status != hdef.OK):
            status = hdef.NOT_OKAY
            errtext = depot_data.errtext
            return (status, errtext, data)
        else:
            data[depot_name] = copy.deepcopy(depot_data)
            del depot_data
        # endif
    
    # endfor
    
    # iban-liste pickle --------------------------------------------
    if inidict[par.INI_IBAN_LIST_FILE_NAME] in inidict[par.INI_DATA_PICKLE_JSONFILE_LIST]:
        use_json = inidict[par.INI_DATA_PICKLE_USE_JSON]
    else:
        use_json = 0
    # end if
    iban_data = ka_data_pickle.ka_data_pickle(par.IBAN_PREFIX, inidict[par.INI_IBAN_LIST_FILE_NAME], use_json)
    
    if (iban_data.status != hdef.OK):
        status = hdef.NOT_OKAY
        errtext = iban_data.errtext
        return (status, errtext, data)
    # endif
    
    (status, errtext, data[par.IBAN_DATA_DICT_NAME]) = proof_iban_data_and_add_from_ini(iban_data, par, data, inidict)
    
    if (status != hdef.OK):
        status = hdef.NOT_OKAY
        return (status, errtext, data)
    # endif
    
    return (status, errtext, data)
# end def
# --------------------------------------------------------------------------------------
#
# Set DATA Save to pickle
#
# --------------------------------------------------------------------------------------
def data_save(data,par):
    status = hdef.OKAY
    errtext = ""
    
    for key in data:
        if data[key].ddict[par.DDICT_TYPE_NAME] == par.KONTO_DATA_TYPE_NAME:
            # get data from konto set class to save
            if par.KONTO_DATA_SET_NAME in data[key].ddict.keys():
                data[key].ddict[par.KONTO_DATA_SET_NAME] = data[key].obj.data_set_llist
            # end if
            data[key].ddict[par.KONTO_DATA_SET_DICT_LIST_NAME] = data[key].obj.get_data_set_dict_list()
            data[key].ddict[par.KONTO_DATA_TYPE_DICT_NAME] = data[key].obj.get_data_type_dict()
            del data[key].obj
        elif data[key].ddict[par.DDICT_TYPE_NAME] == par.DEPOT_DATA_TYPE_NAME:
            data[key].ddict[par.DEPOT_DATA_ISIN_LIST_NAME] = data[key].obj.get_to_store_data_isin_list()
            data[key].ddict[par.DEPOT_DATA_SET_DICT_LIST_NAME] = data[key].obj.get_data_set_dict_list()
            data[key].ddict[par.DEPOT_DATA_TYPE_DICT_NAME] = data[key].obj.get_data_type_dict()
            del data[key].obj
        elif data[key].ddict[par.DDICT_TYPE_NAME] == par.PROG_DATA_TYPE_NAME:
            data[key].ddict[par.KONTO_DATA_ID_MAX_NAME] = data[key].idfunc.get_act_id()
            del data[key].idfunc
        # end if
        data[key].save()
        
        if (data[key].status != hdef.OKAY):
            status = hdef.NOT_OKAY
            errtext = data[key].errtext
        # endif
    # endfor
    
    return (status, errtext)


# enddef
# --------------------------------------------------------------------------------------
#
# Set PROG DATA
#
# --------------------------------------------------------------------------------------
def set_prog_data(par,allg_data):
    '''
    
    :param allg_data:
    :return: allg_data = set_prog_data(allg_data)
    '''

    allg_data.ddict[par.DDICT_TYPE_NAME] = par.PROG_DATA_TYPE_NAME

    # class id anlegen
    allg_data.idfunc = ka_data_class_defs.IDCount()

    key = par.KONTO_DATA_ID_MAX_NAME
    if key in allg_data.ddict:
        allg_data.idfunc.set_act_id(allg_data.ddict[key])
    else:
        allg_data.idfunc.set_act_id(0)
    # end if

    return allg_data

# end def
# --------------------------------------------------------------------------------------
#
# Set KONTO DATA
#
# --------------------------------------------------------------------------------------
def proof_konto_data_from_ini(par,konto_data, ini_data_dict):
    """
    proof ini_data in konto_data
    :param konto_data:
    :param ini_data:
    :return:
    """
    
    for key in ini_data_dict.keys():
        
        if (key in konto_data.ddict):
            if (ini_data_dict[key] != konto_data.ddict[key]):
                konto_data.ddict[key] = ini_data_dict[key]
            # endif
        else:
            if key == par.INI_START_WERT_NAME:
                if isinstance(ini_data_dict[key],str) or isinstance(ini_data_dict[key],float):
                    # Trennungs zeichen für decimal wert
                    if par.INI_KONTO_STR_EURO_TRENN_BRUCH in ini_data_dict.keys():
                        wert_delim = ini_data_dict[par.INI_KONTO_STR_EURO_TRENN_BRUCH]
                    else:
                        wert_delim = par.STR_EURO_TRENN_BRUCH_DEFAULT
                    # end if
                    
                    # Trennungszeichen für Tausend
                    if par.INI_KONTO_STR_EURO_TRENN_TAUSEND in ini_data_dict.keys():
                        wert_trennt = ini_data_dict[par.INI_KONTO_STR_EURO_TRENN_TAUSEND]
                    else:
                        wert_trennt = par.STR_EURO_TRENN_TAUSEN_DEFAULT
                    # end if
                    (okay, wert) = htype.type_convert_euro_to_cent(ini_data_dict[key],delim=wert_delim,thousandsign=wert_trennt)
                    if okay != hdef.OKAY:
                        raise Exception(f"ka_data_set: Den Startwert = {ini_data_dict[key]} kann nicht gewandelt werden ")
                    # end if
                else:
                    wert = ini_data_dict[key]
                # end if
                konto_data.ddict[key] = wert
            else:
                konto_data.ddict[key] = ini_data_dict[key]
            # end if
        # endif
    # end for
    
    # proof if all ini-Data in konto_data and vice versa
    #---------------------------------------------------
    ini_keys = list(ini_data_dict.keys())
    
    if par.INI_DATA_KEYS_NAME not in konto_data.ddict:
        konto_data.ddict[par.INI_DATA_KEYS_NAME] = ini_keys
    else:
        data_ini_keys = konto_data.ddict[par.INI_DATA_KEYS_NAME]
        flag = False
        for key in data_ini_keys:
            if (key not in ini_keys) and (key in konto_data.ddict.keys() ):
                del konto_data.ddict[key]
                flag = True
            # end if
        # end for
        if flag :
            konto_data.ddict[par.INI_DATA_KEYS_NAME] = ini_keys
        # end if
    # end if
    
    return konto_data


# end def
def proof_konto_data_intern(par, konto_data, konto_name):
    '''

    :param par
    :param konto_data:
    :param konto_name
    :return:konto_data =  proof_konto_data_intern(par,konto_data,konto_name)
    '''
    # type
    konto_data.ddict[par.DDICT_TYPE_NAME] = par.KONTO_DATA_TYPE_NAME
    
    # konto name
    key = par.KONTO_NAME
    if key in konto_data.ddict:
        if konto_name != konto_data.ddict[key]:
            konto_data.ddict[key] = konto_name
        # end if
    else:
        konto_data.ddict[key] = konto_name
    # end if
    
    return konto_data
# end def
def build_konto_data_set_obj(par, konto_data, konto_name,idfunc):
    '''
    
    :param par:
    :param konto_data:
    :param konto_name:
    :return: konto_data =  build_konto_data_set_obj(par, konto_data, konto_name):
    '''
    
    #----------------------------------------------------------------------------
    # Set parameter for konto Data set
    #----------------------------------------------------------------------------
    
    # class KontoDataSet anlegen
    obj = ka_konto_data_set_class.KontoDataSet(konto_name)
    
    # # kont_data set anlegen
    # #----------------------
    # key = par.KONTO_DATA_SET_NAME
    # if key in konto_data.ddict:
    #     if len(konto_data.ddict[key]) > 0:
    #         if len(konto_data.ddict[key][0]) != len(obj.KONTO_DATA_NAME_LIST):
    #             konto_data.status = hdef.NOT_OKAY
    #             konto_data.errtext = f"length of header-list {par.KONTO_DATA_NAME_LIST} not same with data-dict {konto_data.dict[key]} of konto: {konto_name}"
    #             return konto_data
    #         # end if
    #     # end if
    #     data_set_llist = konto_data.ddict[key]
    # else:
    #     data_set_llist = []
    # # end if

    # neue Datenbeschreibung
    key = par.KONTO_DATA_SET_DICT_LIST_NAME
    if key in konto_data.ddict:
        konto_data_set_dict_list = konto_data.ddict[key]
    else:
        konto_data_set_dict_list = []
    # end if
    
    key = par.KONTO_DATA_TYPE_DICT_NAME
    if key in konto_data.ddict:
        konto_data_type_dict = konto_data.ddict[key]
    else:
        konto_data_type_dict =   {}
    # end if
    if par.KONTO_DATA_SET_NAME in konto_data.ddict:
        del konto_data.ddict[par.KONTO_DATA_SET_NAME]
    # end if

    
    # konto_start_wert von ini übergeben:
    #-----------------------------------
    key = par.INI_START_WERT_NAME
    if key in konto_data.ddict:
        konto_start_wert = konto_data.ddict[key]
        if isinstance(konto_start_wert,str ):
            (okay, konto_start_wert) = htype.type_transform_str(konto_start_wert,'cent')
            if okay != hdef.OKAY:
                raise Exception(f"konto_start_wert = konto_data.ddict[{key}] of konto_name = {konto_name} lässt sich von float (euro) in cent nicht wandeln")
            # end if
        else:
            (okay, konto_start_wert) = htype.type_proof_cent(konto_start_wert)
            if okay != hdef.OKAY:
                raise Exception(f"konto_start_wert = konto_data.ddict[{key}] of konto_name = {konto_name} ist nicht in cent")
            # end if
        # end if
    else:
        konto_start_wert = 0
    # end if
    
    # konto_start_datum von ini übergeben:
    #-------------------------------------
    key = par.INI_START_DATUM_NAME
    if key in konto_data.ddict:
        konto_start_datum = konto_data.ddict[key]
        (okay, konto_start_datum) = htype.type_proof_dat(konto_start_datum)
        if okay != hdef.OKAY:
            raise Exception(
                f"konto_start_datum = konto_data.ddict[{key}] of konto_name = {konto_name} ist kein Datum")
        # end if
    else:
        konto_start_datum = 0
    # end if
    
    # Trennungs zeichen für decimal wert
    #-----------------------------------
    key = par.INI_KONTO_STR_EURO_TRENN_BRUCH
    if key in konto_data.ddict:
        wert_delim = konto_data.ddict[key]
    else:
        wert_delim = par.STR_EURO_TRENN_BRUCH_DEFAULT
    # end if
    
    # Trennungszeichen für Tausend
    #-----------------------------
    key = par.INI_KONTO_STR_EURO_TRENN_TAUSEND
    if key in konto_data.ddict:
        wert_trennt = konto_data.ddict[key]
    else:
        wert_trennt = par.STR_EURO_TRENN_TAUSEN_DEFAULT
    # end if

    # KontoDataSet data_llist übergeben
    obj.set_starting_data_llist(
        konto_data_set_dict_list,
        konto_data_type_dict,
        idfunc,
        konto_start_datum,
        konto_start_wert,
        wert_delim,
        wert_trennt)
    
    konto_data.obj = copy.deepcopy(obj)
    
    del obj
    
    return konto_data
def build_konto_data_csv_obj(par, konto_data, konto_name,ini_data_dict):
    #----------------------------------------------------------------------------
    # Set parameter for konto csv read
    #----------------------------------------------------------------------------
    
    # import data type
    #----------------------------------------------------------------------------
    key = par.INI_IMPORT_DATA_TYPE_NAME
    if key in konto_data.ddict:
        import_data_type = konto_data.ddict[key]
    else:
        raise Exception(f"build_konto_data_csv_obj: import_data_type = konto_data.ddict[{key}] of konto_name = {konto_name} ist nicht im ini-File")
    # end if
    
    # No import type
    if( len(import_data_type) == 0 ) or (import_data_type == "none"):
        konto_data.csv = None
        return konto_data
    # end if
    
    if import_data_type not in ini_data_dict[par.INI_CSV_IMPORT_TYPE_NAMES_NAME]:
        raise Exception(
            f"build_konto_data_csv_obj: import_data_type = {import_data_type} of konto_name = {konto_name} ist nicht in der Liste der csv_import_type_names = {par.INI_CSV_IMPORT_TYPE_NAMES_NAME} im ini-File")
    # end if
    
    csv_import_dict = ini_data_dict[import_data_type]

    # Trennungszeichen in csv-Datei
    #--------------------------------
    key = par.INI_CSV_TRENNZEICHEN
    if key in csv_import_dict:
        wert_trenn = csv_import_dict[key]
    else:
        raise Exception(f"key {par.INI_CSV_TRENNZEICHEN} not ini-File in sction [{import_data_type}]of konto: {konto_name}")
    # end if

    # Klassen-Objekt erstellen
    csv = ka_konto_csv_read_class.KontoCsvRead()
    csv.set_csv_trennzeichen(wert_trenn)

    
    # build buchungstype list from ini-File for csv-file
    #---------------------------------------------------
    n = min(len(csv_import_dict[par.INI_CSV_BUCHTYPE_NAMEN]),len(csv_import_dict[par.INI_CSV_BUCHTYPE_ZUORDNUNG]))
    
    csv_buchungs_typ_liste = ["" for i in konto_data.obj.KONTO_BUCHTYPE_INDEX_LIST]
    
    for i in range(n):
        buchtype_zuordnung = csv_import_dict[par.INI_CSV_BUCHTYPE_ZUORDNUNG][i]
        buchtype_name      = csv_import_dict[par.INI_CSV_BUCHTYPE_NAMEN][i]
        
        buchtype_index = konto_data.obj.get_buchtype_index(buchtype_zuordnung)
        if buchtype_index is None:
            raise Exception(
                f"build_konto_data_csv_obj: buchtype_zuordnung = {buchtype_zuordnung} aus section [{import_data_type}]of konto: {konto_name} kann nicht in Klasse KontoDataSet (ka_konto_data_set_class) gefunden werden")
        # end if
        
        # Suche den Index in der Index-Liste
        
        try:
            index = konto_data.obj.KONTO_BUCHTYPE_INDEX_LIST.index(buchtype_index)
        except ValueError:
            raise Exception(
                f"build_konto_data_csv_obj: buchtype_index = {buchtype_index} von  konto_data.obj.get_buchtype_index(buchtype_zuordnung) buchtype_zuordnung = {buchtype_zuordnung}of konto: {konto_name} kann nicht in Klasse KontoDataSet (ka_konto_data_set_class) gefunden werden")
        # end try
        csv_buchungs_typ_liste[index] = buchtype_name
    # end for
    
    # unbekannt hinzu fügen
    index = konto_data.obj.KONTO_BUCHTYPE_INDEX_LIST.index(konto_data.obj.KONTO_BUCHTYPE_INDEX_UNBEKANNT)
    if csv_buchungs_typ_liste[index] == "":
        csv_buchungs_typ_liste[index] = "unbekannt"
    # end if
    

    # Bilde list für header name csv, index und buchungstype
    #-------------------------------------------------------
    n = min(len(csv_import_dict[par.INI_CSV_HEADER_NAMEN]), len(csv_import_dict[par.INI_CSV_HEADER_ZUORDNUNG]))
    n = min(n,len(csv_import_dict[par.INI_CSV_HEADER_DATA_TYPE]))
    
    for i in range(n):
        header_name = csv_import_dict[par.INI_CSV_HEADER_NAMEN][i]
        header_zuordnung = csv_import_dict[par.INI_CSV_HEADER_ZUORDNUNG][i]
        header_data_type = csv_import_dict[par.INI_CSV_HEADER_DATA_TYPE][i]
        index = konto_data.obj.get_name_index(header_zuordnung)
        if index is None:
            raise Exception(
                f"build_konto_data_csv_obj: header_zuordnung = {header_zuordnung} aus section [{import_data_type}]of konto: {konto_name} kann nicht in Klasse KontoDataSet (ka_konto_data_set_class) gefunden werden")
        # end if
        if index == konto_data.obj.KONTO_DATA_INDEX_BUCHTYPE:
            csv.set_csv_header_name(index, header_name, csv_buchungs_typ_liste)
        else:
            csv.set_csv_header_name(index, header_name, header_data_type)
        # end if
    # end for
    
    konto_data.csv = copy.deepcopy(csv)
    
    del csv
    
    return konto_data

# end def
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
    
    return depot_data


# end def
def build_depot_data_set_obj(par, depot_data, depot_name, data):
    '''

    :param par:
    :param depot_data:
    :param depot_name:
    :return: depot_data =  build_konto_data_set_obj(par, depot_data, depot_name):
    '''
    
    # ----------------------------------------------------------------------------
    # Set parameter for konto Data
    # ----------------------------------------------------------------------------
    obj = ka_depot_data_set_class.DepotDataSet(depot_name)
    
    
    # isin_list set anlegen
    #----------------------
    key = par.DEPOT_DATA_ISIN_LIST_NAME
    if key in depot_data.ddict:
        isin_list = depot_data.ddict[key]
    else:
        isin_list = []
    # end if
    
    # neue Datenbeschreibung
    key = par.DEPOT_DATA_SET_DICT_LIST_NAME
    if key in depot_data.ddict:
        depot_data_set_dict_list = depot_data.ddict[key]
    else:
        depot_data_set_dict_list = []
    # end if
    
    key = par.DEPOT_DATA_TYPE_DICT_NAME
    if key in depot_data.ddict:
        depot_data_type_dict = depot_data.ddict[key]
    else:
        depot_data_type_dict = {}
    # end if
    
    # class KontoDataSet anlegen
    obj.set_stored_data(isin_list,depot_data_set_dict_list,depot_data_type_dict)
    if obj.status != hdef.OKAY:
        raise Exception(obj.errtext)
    # end if
    if key in depot_data.ddict:
        del depot_data.ddict[key]
    # end if
    
    depot_data.obj = copy.deepcopy(obj)
    
    del obj
    
    return depot_data


# end def
# --------------------------------------------------------------------------------------
#
# Set IBAN DATA
#
# --------------------------------------------------------------------------------------
def proof_iban_data_and_add_from_ini(iban_data, par, data, inidict):
    status = hdef.OK
    errtext = ""
    
    iban_data.ddict[par.DDICT_TYPE_NAME] = par.IBAN_DATA_TYPE_NAME
    
    if (par.IBAN_DATA_LIST_NAME not in iban_data.ddict):
        iban_data.ddict[par.IBAN_DATA_LIST_NAME] = []
        iban_data.ddict[par.IBAN_DATA_ID_MAX_NAME] = 0
    # end if
    
    # Suche nach ibans in konto-Daten
    for konto_name in inidict[par.INI_KONTO_DATA_DICT_NAMES_NAME]:
        
        dkonto = data[konto_name]
        
        if not ka_iban_data.iban_find(iban_data.ddict[par.IBAN_DATA_LIST_NAME], dkonto.ddict[par.INI_IBAN_NAME]):
            idmax = iban_data.ddict[par.IBAN_DATA_ID_MAX_NAME] + 1
            (status, errtext, _, data_list) = ka_iban_data.iban_add(iban_data.ddict[par.IBAN_DATA_LIST_NAME], idmax,
                                                                    dkonto.ddict[par.INI_IBAN_NAME],
                                                                    dkonto.ddict[par.INI_BANK_NAME],
                                                                    dkonto.ddict[par.INI_WER_NAME], "")
            if (status != hdef.OK):
                return (status, errtext, iban_data)
            else:
                iban_data.ddict[par.IBAN_DATA_LIST_NAME] = data_list
                iban_data.ddict[par.IBAN_DATA_ID_MAX_NAME] = idmax
            # endif
        # endnif
    # endif
    
    return (status, errtext, iban_data)
# edndef