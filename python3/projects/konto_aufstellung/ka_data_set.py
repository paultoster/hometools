#
# data sets getting from pickle module or build new or also prolong
#
# mit data_get() und data_save werden alle pickles geholt und gespeichert
#
# data[par.konto_names]
# data[par.IBAN_DATA_DICT_NAME]

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
import ka_konto_data_set


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
        if (konto_name in ini.data_pickle_jsonfile_list):
            j = ini.data_pickle_use_json
        else:
            j = 0
        # end if
        
        # get data set
        d = ka_data_pickle.ka_data_pickle(par.KONTO_PREFIX, konto_name, j)
        if (d.status != hdef.OK):
            status = hdef.NOT_OKAY
            errtext = d.errtext
            return (status, errtext, data)
        # endif
        
        d = proof_konto_data_from_ini(d, ini.konto_data[konto_name],par)
        d = proof_konto_data_intern(par, d, konto_name)
        if (d.status != hdef.OK):
            status = hdef.NOT_OKAY
            errtext = d.errtext
            return (status, errtext, data)
        else:
            data[konto_name] = d
        # endif
    
    # endfor
    
    # iban-liste --------------------------------------------
    if ini.iban_list_file_name in ini.data_pickle_jsonfile_list:
        j = ini.data_pickle_use_json
    else:
        j = 0
    # end if
    d = ka_data_pickle.ka_data_pickle(par.IBAN_PREFIX, ini.iban_list_file_name, j)
    
    if (d.status != hdef.OK):
        status = hdef.NOT_OKAY
        errtext = d.errtext
        return (status, errtext, data)
    # endif
    
    (status, errtext, data[par.IBAN_DATA_DICT_NAME]) = proof_iban_data_and_add_from_ini(d, par, data, ini)
    
    if (status != hdef.OK):
        status = hdef.NOT_OKAY
        return (status, errtext, data)
    # endif
    
    return (status, errtext, data)


def data_save(data,par):
    status = hdef.OKAY
    errtext = ""
    
    for key in data:
        
        # get data from class to save
        data[key][par.KONTO_DATA_SET_NAME] = data[key][par.KONTO_DATA_SET_CLASS].data_set_llist
        data[key][par.KONTO_DATA_ID_MAX_NAME] = data[key][par.KONTO_DATA_SET_CLASS].idmax
        del data[key][par.KONTO_DATA_SET_CLASS]
        
        data[key].save()
        
        if (data[key].status != hdef.OKAY):
            status = hdef.NOT_OKAY
            errtext = data[key].errtext
        # endif
    # endfor
    
    return (status, errtext)


# enddef

def proof_konto_data_from_ini(d, ini_data,par):
    """
    proof ini_data in d
    :param d:
    :param ini_data:
    :return:
    """
    
    for key in ini_data:
        
        if (key in d.ddict):
            if (ini_data[key] != d.ddict[key]):
                d.ddict[key] = ini_data[key]
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
                d.ddict[key] = wert
            else:
                d.ddict[key] = ini_data[key]
            # end if
        # endif
    # end for
    
    return d


# end def
def proof_konto_data_intern(par, d, konto_name):
    '''

    :param par
    :param d:
    :param konto_name
    :return:d =  proof_konto_data_intern(d)
    '''
    
    # konto name
    key = par.KONTO_NAME_NAME
    if key in d.ddict:
        if konto_name != d.ddict[key]:
            d.ddict[key] = konto_name
        # end if
    else:
        d.ddict[key] = konto_name
    # end if
    
    
    
    # kont_data set anlegen
    key = par.KONTO_DATA_SET_NAME
    if key in d.ddict:
        if len(d.ddict[key]) > 0:
            if len(d.ddict[key][0]) != len(par.KDSP.KONTO_DATA_ITEM_LIST):
                d.status = hdef.NOT_OKAY
                d.errtext = f"length of header-list {par.KONTO_DATA_ITEM_LIST} not same with data-dict {d.dict[key]} of konto: {konto_name}"
                return d
            # end if
            data_set_llist = d.ddict[key]
        # end if
    else:
        data_set_llist = []
    # end if
    
    key = par.KONTO_DATA_ID_MAX_NAME
    if key in d.ddict:
        idmax = d.ddict[key]
    else:
        idmax = 0
    # end if

    
    # konto_start_wert von ini übergeben:
    key = par.KONTO_DATA_ID_MAX_NAME
    if key in d.ddict:
        konto_start_wert = d.ddict[key]
    else:
        konto_start_wert = 0
    # end if
    
    # Trennungs zeichen für decimal wert
    key = par.INI_KONTO_STR_EURO_TRENN_BRUCH
    if key in d.ddict:
        wert_delim = d.ddict[key]
    else:
        wert_delim = par.STR_EURO_TRENN_BRUCH_DEFAULT
    # end if

    # Trennungszeichen für Tausend
    key = par.INI_KONTO_STR_EURO_TRENN_TAUSEND
    if key in d.ddict:
        wert_trennt = d.ddict[key]
    else:
        wert_trennt = par.STR_EURO_TRENN_TAUSEN_DEFAULT
    # end if

    # class KontoDataSet anlegen
    d.ddict[par.KONTO_DATA_SET_CLASS] = ka_konto_data_set.KontoDataSet(par.KDSP,data_set_llist,idmax,konto_start_wert,wert_delim,wert_trennt)

    return d
# end def

def proof_iban_data_and_add_from_ini(d, par, data, ini):
    status = hdef.OK
    errtext = ""
    
    if (par.IBAN_DATA_LIST_NAME not in d.ddict):
        d.ddict[par.IBAN_DATA_LIST_NAME] = []
        d.ddict[par.IBAN_DATA_ID_MAX_NAME] = 0
    # end if
    
    # Suche nach ibans in konto-Daten
    for konto_name in ini.konto_names:
        
        dkonto = data[konto_name]
        
        if not ka_iban_data.iban_find(d.ddict[par.IBAN_DATA_LIST_NAME], dkonto.ddict[par.IBAN_NAME]):
            idmax = d.ddict[par.IBAN_DATA_ID_MAX_NAME] + 1
            (status, errtext, _, data_list) = ka_iban_data.iban_add(d.ddict[par.IBAN_DATA_LIST_NAME], idmax,
                                                                    dkonto.ddict[par.IBAN_NAME],
                                                                    dkonto.ddict[par.BANK_NAME],
                                                                    dkonto.ddict[par.WER_NAME], "")
            if (status != hdef.OK):
                return (status, errtext, d)
            else:
                d.ddict[par.IBAN_DATA_LIST_NAME] = data_list
                d.ddict[par.IBAN_DATA_ID_MAX_NAME] = idmax
            # endif
        # endnif
    # endif
    
    return (status, errtext, d)
# edndef