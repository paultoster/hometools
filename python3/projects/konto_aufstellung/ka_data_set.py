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


# --------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------

def data_get(par, ini):
    '''

    :param par:
    :param ini:
    :return:  (status, errtext, data) = data_get(par,ini)
    '''
    status = hdef.OKAY
    errtext = ""
    data = {}
    
    # read konto-pickle-file
    for konto_name in ini.konto_names:
        if konto_name in ini.data_pickle_jsonfile_list:
            j = ini.data_pickle_use_json
        else:
            j = 0
        # end if
        
        # get data set
        konto_data = ka_data_pickle.ka_data_pickle(par.KONTO_PREFIX, konto_name, j)
        if (konto_data.status != hdef.OK):
            status = hdef.NOT_OKAY
            errtext = konto_data.errtext
            return (status, errtext, data)
        # endif
        
        konto_data = proof_konto_data_from_ini(konto_data, ini.konto_data[konto_name],par)
        konto_data = proof_konto_data_intern(par, konto_data, konto_name)
        konto_data = build_konto_data_set_obj(par, konto_data, konto_name,data)
        if (konto_data.status != hdef.OK):
            status = hdef.NOT_OKAY
            errtext = konto_data.errtext
            return (status, errtext, data)
        else:
            data[konto_name] = copy.deepcopy(konto_data)
            del konto_data
        # endif
    
    # endfor
    
    #  depot-data liste --------------------------------------------
    for depot_name in ini.depot_names:
        
        if depot_name in ini.data_pickle_jsonfile_list:
            j = ini.data_pickle_use_json
        else:
            j = 0
        # end if
        
        # get data set
        depot_data = ka_data_pickle.ka_data_pickle(par.DEPOT_PREFIX, depot_name, j)
        if (depot_data.status != hdef.OK):
            status = hdef.NOT_OKAY
            errtext = depot_data.errtext
            return (status, errtext, data)
        # endif
        
        depot_data = proof_depot_data_from_ini(depot_data, ini.depot_data[depot_name], par)
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
    
    # iban-liste --------------------------------------------
    if ini.iban_list_file_name in ini.data_pickle_jsonfile_list:
        j = ini.data_pickle_use_json
    else:
        j = 0
    # end if
    iban_data = ka_data_pickle.ka_data_pickle(par.IBAN_PREFIX, ini.iban_list_file_name, j)
    
    if (iban_data.status != hdef.OK):
        status = hdef.NOT_OKAY
        errtext = iban_data.errtext
        return (status, errtext, data)
    # endif
    
    (status, errtext, data[par.IBAN_DATA_DICT_NAME]) = proof_iban_data_and_add_from_ini(iban_data, par, data, ini)
    
    if (status != hdef.OK):
        status = hdef.NOT_OKAY
        return (status, errtext, data)
    # endif
    
    return (status, errtext, data)


def data_save(data,par):
    status = hdef.OKAY
    errtext = ""
    
    for key in data:
        if data[key].ddict[par.DDICT_TYPE_NAE] == par.TYPE_KONTO_DATA:
            # get data from konto set class to save
            data[key].ddict[par.KONTO_DATA_SET_NAME] = data[key].obj.data_set_llist
            data[key].ddict[par.KONTO_DATA_ID_MAX_NAME] = data[key].obj.idmax
            del data[key].obj
        # end if
        data[key].save()
        
        if (data[key].status != hdef.OKAY):
            status = hdef.NOT_OKAY
            errtext = data[key].errtext
        # endif
    # endfor
    
    return (status, errtext)


# enddef

def proof_konto_data_from_ini(konto_data, ini_data,par):
    """
    proof ini_data in konto_data
    :param konto_data:
    :param ini_data:
    :return:
    """
    
    for key in ini_data:
        
        if (key in konto_data.ddict):
            if (ini_data[key] != konto_data.ddict[key]):
                konto_data.ddict[key] = ini_data[key]
            # endif
        else:
            if key == par.START_WERT_NAME:
                if isinstance(ini_data[key],str) or isinstance(ini_data[key],float):
                    # Trennungs zeichen für decimal wert
                    if par.INI_KONTO_STR_EURO_TRENN_BRUCH in ini_data.keys():
                        wert_delim = ini_data[par.INI_KONTO_STR_EURO_TRENN_BRUCH]
                    else:
                        wert_delim = par.STR_EURO_TRENN_BRUCH_DEFAULT
                    # end if
                    
                    # Trennungszeichen für Tausend
                    if par.INI_KONTO_STR_EURO_TRENN_TAUSEND in ini_data.keys():
                        wert_trennt = ini_data[par.INI_KONTO_STR_EURO_TRENN_TAUSEND]
                    else:
                        wert_trennt = par.STR_EURO_TRENN_TAUSEN_DEFAULT
                    # end if
                    (okay, wert) = htype.type_convert_euro_to_cent(ini_data[key],delim=wert_delim,thousandsign=wert_trennt)
                    if okay != hdef.OKAY:
                        raise Exception(f"ka_data_set: Den Startwert = {ini_data[key]} kann nicht gewandelt werden ")
                    # end if
                else:
                    wert = ini_data[key]
                # end if
                konto_data.ddict[key] = wert
            else:
                konto_data.ddict[key] = ini_data[key]
            # end if
        # endif
    # end for
    
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
    konto_data.ddict[par.DDICT_TYPE_NAE] = par.TYPE_KONTO_DATA
    
    # konto name
    key = par.KONTO_NAME_NAME
    if key in konto_data.ddict:
        if konto_name != konto_data.ddict[key]:
            konto_data.ddict[key] = konto_name
        # end if
    else:
        konto_data.ddict[key] = konto_name
    # end if
    
    return konto_data
# end def
def build_konto_data_set_obj(par, konto_data, konto_name,data):
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
    obj = ka_konto_data_set_class.KontoDataSet()
    
    # kont_data set anlegen
    #----------------------
    key = par.KONTO_DATA_SET_NAME
    if key in konto_data.ddict:
        if len(konto_data.ddict[key]) > 0:
            if len(konto_data.ddict[key][0]) != len(obj.KONTO_DATA_ITEM_LIST):
                konto_data.status = hdef.NOT_OKAY
                konto_data.errtext = f"length of header-list {par.KONTO_DATA_ITEM_LIST} not same with data-dict {konto_data.dict[key]} of konto: {konto_name}"
                return konto_data
            # end if
        # end if
        data_set_llist = konto_data.ddict[key]
    else:
        data_set_llist = []
    # end if
    
    # konto data id
    #--------------
    key = par.KONTO_DATA_ID_MAX_NAME
    if key in konto_data.ddict:
        idmax = konto_data.ddict[key]
    else:
        idmax = 0
    # end if
    
    # konto_start_wert von ini übergeben:
    #-----------------------------------
    key = par.START_WERT_NAME
    if key in konto_data.ddict:
        konto_start_wert = konto_data.ddict[key]
    else:
        konto_start_wert = 0
    # end if
    
    # konto_start_datum von ini übergeben:
    #-------------------------------------
    key = par.START_DATUM_NAME
    if key in konto_data.ddict:
        konto_start_datum = konto_data.ddict[key]
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
        data_set_llist,
        idmax,
        konto_start_datum,
        konto_start_wert,
        wert_delim,
        wert_trennt)
    
    konto_data.obj = copy.deepcopy(obj)
    
    
    
    #----------------------------------------------------------------------------
    # Set parameter for konto csv read
    #----------------------------------------------------------------------------
    csv = ka_konto_csv_read_class.KontoCsvRead()

    # Trennungszeichen in csv-Datei
    #--------------------------------
    key = par.INI_KONTO_CSV_TRENN_DATA
    if key in konto_data.ddict:
        wert_trenn = konto_data.ddict[key]
    else:
        raise Exception(f"key {par.INI_KONTO_CSV_TRENN_DATA} not ini-File of konto: {konto_name}")
    # end if
    csv.set_csv_trennzeichen(wert_trenn)

    # build buchungstype list from ini-File for csv-file
    #---------------------------------------------------
    csv_buchungs_typ_liste = []
    ddict    = {obj.KONTO_BUCHTYPE_INDEX_EINZAHLUNG:par.INI_KONTO_BUCH_EINZAHLUNG_NAME,
                obj.KONTO_BUCHTYPE_INDEX_AUSZAHLUNG:par.INI_KONTO_BUCH_AUSZAHLUNG_NAME,
                obj.KONTO_BUCHTYPE_INDEX_KOSTEN:par.INI_KONTO_BUCH_KOSTEN_NAME,
                obj.KONTO_BUCHTYPE_INDEX_WP_KAUF:par.INI_KONTO_BUCH_WP_KAUF_NAME,
                obj.KONTO_BUCHTYPE_INDEX_WP_VERKAUF:par.INI_KONTO_BUCH_WP_VERKAUF_NAME,
                obj.KONTO_BUCHTYPE_INDEX_WP_KOSTEN:par.INI_KONTO_BUCH_WP_KOSTEN_NAME,
                obj.KONTO_BUCHTYPE_INDEX_WP_EINNAHMEN:par.INI_KONTO_BUCH_WP_EINNAHMEN_NAME}
    #
    for index,buchtype_name in ddict.items():
        if buchtype_name not in konto_data.ddict.keys():
            raise Exception(f"In ini-File Parameter {buchtype_name} is not set of konto: {konto_name}")
        # end if
        csv_buchungs_typ_liste.append(konto_data.ddict[buchtype_name])
    # end for

    # Bilde list für header name csv, index und buchungstype
    #-------------------------------------------------------
    d =     {obj.KONTO_DATA_NAME_BUCHDATUM: par.HEADER_BUCHDATUM_NAME
            ,obj.KONTO_DATA_NAME_WERTDATUM: par.HEADER_WERTDATUM_NAME
            ,obj.KONTO_DATA_NAME_WER: par.HEADER_WER_NAME
            ,obj.KONTO_DATA_NAME_BUCHTYPE: par.HEADER_BUCHTYPE_NAME
            ,obj.KONTO_DATA_NAME_WERT: par.HEADER_WERT_NAME
            ,obj.KONTO_DATA_NAME_COMMENT: par.HEADER_COMMENT_NAME}
    
    # Übergebe den Headernamen (aus ini) für das entsprechende item und den type
    # standard ist string, für buchtype die erstelle Liste csv_buchungs_typ_liste
    for konto_data_name,csv_name in d.items():
        if csv_name not in konto_data.ddict.keys():
            raise Exception(f"header {csv_name} not ini-File of konto: {konto_name}")
        index = obj.get_index(konto_data_name)
        if index == obj.KONTO_DATA_INDEX_BUCHTYPE:
            csv.set_csv_header_name(index, csv_name, csv_buchungs_typ_liste)
        else:
            csv.set_csv_header_name(index, csv_name, "str")
    
    konto_data.csv = copy.deepcopy(csv)
    
    del obj
    del csv
    
    return konto_data

# end def
def proof_depot_data_from_ini(depot_data, ini_data, par):
    """
    proof ini_data in depot_data
    :param depot_data:
    :param ini_data:
    :return:
    """
    
    for key in ini_data:
        
        if (key in depot_data.ddict):
            if (ini_data[key] != depot_data.ddict[key]):
                depot_data.ddict[key] = ini_data[key]
            # endif
        else:
            depot_data.ddict[key] = ini_data[key]
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
    depot_data.ddict[par.DDICT_TYPE_NAE] = par.TYPE_DEPOT_DATA
    
    # konto name
    key = par.DEPOT_NAME_NAME
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
    obj = ka_depot_data_set_class.DepotDataSet()
    
    
    # kont_data set anlegen
    key = par.DEPOT_DATA_SET_NAME
    if key in depot_data.ddict:
        if len(depot_data.ddict[key]) > 0:
            if len(depot_data.ddict[key][0]) != len(obj.DEPOT_DATA_ITEM_LIST):
                depot_data.status = hdef.NOT_OKAY
                depot_data.errtext = f"length of header-list {par.DEPOT_DATA_ITEM_LIST} not same with data-dict {depot_data.dict[key]} of konto: {depot_name}"
                return depot_data
            # end if
        # end if
        data_set_llist = depot_data.ddict[key]
    else:
        data_set_llist = []
    # end if
    
    key = par.DEPPOT_DATA_ID_MAX_NAME
    if key in depot_data.ddict:
        idmax = depot_data.ddict[key]
    else:
        idmax = 0
    # end if
    
    
    # depot_start_datum von ini übergeben:
    key = par.START_DATUM_NAME
    if key in depot_data.ddict:
        depot_start_datum = depot_data.ddict[key]
    else:
        depot_start_datum = 0
    # end if
    
    # Trennungs zeichen für decimal wert
    key = par.INI_KONTO_STR_EURO_TRENN_BRUCH
    if key in depot_data.ddict:
        wert_delim = depot_data.ddict[key]
    else:
        wert_delim = par.STR_EURO_TRENN_BRUCH_DEFAULT
    # end if
    
    # Trennungszeichen für Tausend
    key = par.INI_KONTO_STR_EURO_TRENN_TAUSEND
    if key in depot_data.ddict:
        wert_trennt = depot_data.ddict[key]
    else:
        wert_trennt = par.STR_EURO_TRENN_TAUSEN_DEFAULT
    # end if
    
    # class KontoDataSet anlegen
    obj.set_starting_data_llist(
        data_set_llist,
        idmax,
        depot_start_datum,
        wert_delim,
        wert_trennt)
    
    depot_data.obj = copy.deepcopy(obj)
    
    del obj
    
    return depot_data


# end def
def proof_iban_data_and_add_from_ini(iban_data, par, data, ini):
    status = hdef.OK
    errtext = ""
    
    iban_data.ddict[par.DDICT_TYPE_NAE] = par.TYPE_IBAN_DATA
    
    if (par.IBAN_DATA_LIST_NAME not in iban_data.ddict):
        iban_data.ddict[par.IBAN_DATA_LIST_NAME] = []
        iban_data.ddict[par.IBAN_DATA_ID_MAX_NAME] = 0
    # end if
    
    # Suche nach ibans in konto-Daten
    for konto_name in ini.konto_names:
        
        dkonto = data[konto_name]
        
        if not ka_iban_data.iban_find(iban_data.ddict[par.IBAN_DATA_LIST_NAME], dkonto.ddict[par.IBAN_NAME]):
            idmax = iban_data.ddict[par.IBAN_DATA_ID_MAX_NAME] + 1
            (status, errtext, _, data_list) = ka_iban_data.iban_add(iban_data.ddict[par.IBAN_DATA_LIST_NAME], idmax,
                                                                    dkonto.ddict[par.IBAN_NAME],
                                                                    dkonto.ddict[par.BANK_NAME],
                                                                    dkonto.ddict[par.WER_NAME], "")
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