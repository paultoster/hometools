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

import ka_iban_data
import ka_data_pickle


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
        
        d = proof_konto_data_from_ini(d, ini.konto_data[konto_name])
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
    if (ini.iban_list_file_name in ini.data_pickle_jsonfile_list):
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


def data_save(data):
    status = hdef.OKAY
    errtext = ""
    
    for key in data:
        
        data[key].save()
        
        if (data[key].status != hdef.OKAY):
            status = hdef.NOT_OKAY
            errtext = data[key].errtext
        # endif
    # endfor
    
    return (status, errtext)


# enddef

def proof_konto_data_from_ini(d, ini_data):
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
            d.ddict[key] = ini_data[key]
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
    
    # kont_data set anlegen
    key = par.KONTO_DATA_SET_NAME
    if key in d.ddict:
        if len(d.ddict[key]) > 0:
            if len(d.ddict[key][0]) != len(par.KONTO_DATA_ITEM_LIST):
                d.status = hdef.NOT_OKAY
                d.errtext = f"length of header-list {par.KONTO_DATA_ITEM_LIST} not same with data-dict {d.dict[key]} of konto: {konto_name}"
                return d
            # end if
        # end if
    else:
        d.ddict[key] = []
    # end if
    
    key = par.KONTO_DATA_ID_MAX_NAME
    if key not in d.ddict:
        d.ddict[key] = 0
    # end if
    
    # Liste für neuen Input
    key = par.KONTO_DATA_ID_NEW_LIST
    d.ddict[key] = []
    
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