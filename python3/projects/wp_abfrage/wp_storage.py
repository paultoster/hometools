import os, sys
import pickle
import json
import zlib
import traceback
import xml.etree.ElementTree as ET
import numpy as np
import datetime
import pandas as pd

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_file_path as hfp

from wp_abfrage import wp_fkt
from wp_abfrage import wp_np_dataclass as wp_np_dc

FORMAT_PICKLE = 1
FORMAT_JSON   = 2
FORMAT_BOTH   = 3

def info_storage_eixst(file_name, formatpj):

    if formatpj == FORMAT_PICKLE:
        file_name = hfp.reset_ext(file_name, "pkl")
    else:
        file_name = hfp.reset_ext(file_name, "json")
    # end if

    if os.path.isfile(file_name):
        return True
    else:
        return False
    # end if
# end def
def read_dict(file_name,formatpj):
    '''
    
    :param file_name:  Dateiname mit beliebige extension
    :param formatpj:    1: pkl, 2: json
    :return: (status,errtext,ddict) = read_dict(file_name,formatpj)
    '''
    # (status ,errtext ,wpname_isin_dict) = wp_storage.read_dict(file_name_json,formatpj)
    status = hdef.OKAY
    errtext = ""

    if formatpj == FORMAT_JSON:  # read json

        file_name = hfp.reset_ext(file_name, "json")
        # Wenn die Datei vorhanden ist:
        if (os.path.isfile(file_name)):
            (status, errtext, ddict) = read_json(file_name)
        else:
            status = hdef.NOT_OKAY
            errtext = f"File {file_name} does not exist!"
            ddict = {}
        # end if
    
    else:  # normal pickle load

        file_name = hfp.reset_ext(file_name, "pkl")
        # Wenn die Datei vorhanden ist:
        if (os.path.isfile(file_name)):
            (status, errtext, ddict) = read_pickle(file_name)
        else:
            status = hdef.NOT_OKAY
            errtext = f"File {file_name} does not exist!"
            ddict = {}
        # endif
    
    # end if
    
    return (status,errtext,ddict)
# end def
def save_dict(ddict, file_name, format):
    '''

    :param ddict:
    :param file_name:
    :param format: 1: pkl, 2: json, 3=1+2

    :return: (status, errtext) = wp_storage.save_dict(ddict, file_name, format)
    '''
    status = hdef.OKAY
    errtext = ""

    # save pckl
    if (format == FORMAT_PICKLE) or (format == FORMAT_BOTH):

        file_name = hfp.reset_ext(file_name, "pkl")
        (status, errtext) = save_pickle(ddict, file_name)
        if status != hdef.OKAY:
            return (status, errtext)
        # end if
    # end if

    # save json
    if (format == FORMAT_JSON) or (format == FORMAT_BOTH):

        file_name = hfp.reset_ext(file_name, "json")
        (status, errtext) = save_json(ddict, file_name)
    # end if

    return (status, errtext)
# end def
def update_isin_name_dict(isin, wpname, file_name, formatpj):
    '''

    :param isin:
    :param wpname:
    :param base_ddict:
    :return: (status, errtext) = update_isin_name_dict(isin,info_dict["name"],base_ddict)
    '''

    if info_storage_eixst(file_name, formatpj):

        (status, errtext, wpname_dict) = read_dict(file_name, formatpj)
        if (status != hdef.OKAY):
            return (status, errtext)
        # end if
    else:
        wpname_dict = {}
    # end if

    # set isin and name
    if isin not in wpname_dict.keys():
        print(f"add isin: {isin} und wpname: {wpname} zu wpname_dict[isin] = wpname")

    wpname_dict[isin] = wpname

    # Save Dict
    (status, errtext) = save_dict(wpname_dict, file_name, formatpj)

    return (status, errtext)


def np_obj_storage_exist(file_name,formatpj):
    """

    :param filename:
    :param formatpj: 1: pkl, 2: json
    :return: flag = np_obj_storage_exist(filename,formatpj)
    """
    if formatpj == FORMAT_PICKLE:
        file_name = hfp.reset_ext(file_name, "pkl")
    else:
        file_name = hfp.reset_ext(file_name, "json")
    # end if

    if os.path.isfile(file_name):
        return True
    else:
        return False
    # end if
# end def
def read_np_obj(classdef,file_name,formatpj):
    """

    :param file_name:
    :param formatpj: 1: pkl, 2: json
    :return: (status,errtext,ddict) = read_np_obj(classdef,file_name,formatpj)
    """
    status = hdef.OKAY
    errtext = ""

    # Check ob existieret
    flag = np_obj_storage_exist(file_name,formatpj)

    # Wenn nicht existiert, dann Fehler
    if not flag:
        status = hdef.NOT_OKAY
        if formatpj == FORMAT_PICKLE:
            file_name = hfp.reset_ext(file_name, "pkl")
        else:
            file_name = hfp.reset_ext(file_name, "json")
        # end if
        errtext = f"read_np_obj(): Error read_np_obj: Es besteht kein File {file_name = }"
        return (status, errtext, None)
    else:
        # lese dict-File
        (status, errtext, ddict) = read_dict(file_name,formatpj)
        if (status != hdef.OKAY):
            return (status, errtext,None)

        # bilde leeres Objekt und wandele ddict
        np_obj = classdef()
        np_obj.from_store_dict(ddict)
    # end if

    return (status,errtext,np_obj)
# end def
def save_np_obj(np_obj,file_name,formatpj):
    """

    :param np_obj
    :param file_name:
    :param formatpj: 1: pkl, 2: json, 3=1+2
    :return: (status,errtext) = save_np_obj(np_obj,file_name,formatpj)
    """
    # wandel zu dict
    ddict = np_obj.to_store_dict()

    # ddict speichern
    (status, errtext) = save_dict(ddict,file_name,formatpj)

    return (status, errtext)
# end def
# def read_wpname_isin_dict(wpname_isin_filename,store_path):
#     '''
#
#     :param base_ddict:
#     :return:
#     '''#
#     status = hdef.OKAY
#     errtext = ""
#
#     # file_name_pckl = build_file_name_pickle(base_ddict["wpname_isin_filename"], base_ddict)
#     file_name_json = build_file_name_json(wpname_isin_filename, store_path)
#
#     # Use always json
#     # if (base_ddict["use_json"] == 2):  # read json
#
#     if (os.path.isfile(file_name_json)):
#         (status, errtext, wpname_dict) = read_json(file_name_json)
#     else:
#         status = hdef.NOT_OKAY
#         errtext = f"File {file_name_json} does not exist!"
#         return (status, errtext, {})
#     # end if
#
#     # else:  # normal pkl load
#     #
#     #     # Wenn die Datei vorhanden ist:
#     #     if (os.path.isfile(file_name_pckl)):
#     #         (status, errtext, wpname_dict) = read_pickle(file_name_pckl)
#     #     else:
#     #         wpname_dict = {}
#     #     # endif
#     #
#     # # end if
#     return (status, errtext,wpname_dict)
# # end def
def build_file_name_pickle(body, store_path):
    '''

    :param isin:
    :param base_ddict:
    :return: file_name
    '''
    return os.path.join(store_path, body + ".pkl")
# end def
def build_file_name_json(body,store_path):
    '''

    :param isin:
    :param base_ddict:
    :return: file_name
    '''
    return os.path.join(store_path, body+".json")
# end def
def build_file_name_pandas(body,store_path):
    '''

    :param base:
    :param base_dict:
    :return: file_name
    '''
    return os.path.join(store_path, body+".parquet")
# end def
def read_pickle(file_name):
    '''

    :param file_name:
    :return: (status,errtext,ddict) = read_pickle(file_name)
    '''
    status = hdef.OKAY
    errtext = ""
    try:
        with open(file_name, "rb") as f:
            uncompressed_data = zlib.decompress(f.read())
            f.close()
    except PermissionError:
        status = hdef.NOT_OKAY
        errtext = f"File {file_name} does not exist!"
        return (status, errtext, {})
    except IOError:
        status = hdef.NOT_OKAY
        errtext = f"An error occurred while reading the file {file_name}"
        return (status, errtext, {})
    except Exception as e:
        status = hdef.NOT_OKAY
        errtext = f"An error occurred while reading the file {file_name} with {e}"
        return (status, errtext, {})
    # endtry
    
    try:
        ddict = pickle.loads(uncompressed_data)
    except pickle.UnpicklingError as e:
        status = hdef.NOT_OKAY
        errtext = f"An error occurred while run pickle with loaded file: {file_name} with {traceback.format_exc(e)}"
        return (status, errtext, {})
    except Exception as e:
        status = hdef.NOT_OKAY
        errtext = f"An error occurred while run pickle with loaded file: {file_name} with {traceback.format_exc(e)}"
        return (status, errtext, {})
    # endtry
    
    return (status, errtext, ddict)


# end def
def read_json(file_name):
    '''
    
    :param file_name:
    :return: (status,errtext,ddict) = read_json(file_name)
    '''
    status = hdef.OKAY
    errtext = ""
    try:
        with open(file_name, "r") as f:
            ddict = json.load(f)
            f.close()
    except PermissionError:
        status = hdef.NOT_OKAY
        errtext = f"File {file_name} does not exist!"
        return (status, errtext, {})
    except IOError:
        status = hdef.NOT_OKAY
        errtext = f"An error occurred while reading the file {file_name}"
        return (status, errtext, {})
    except Exception as e:
        status = hdef.NOT_OKAY
        errtext = f"An error occurred while reading the file {file_name} with {e}"
        return (status, errtext, {})
    # endtry
    
    return (status, errtext, ddict)

# end def
def save_pickle(ddict, file_name):
    '''
    
    :param ddict:
    :param file_name:
    :return: (status, errtext) =  save_pickle(ddict, file_name):
    '''
    status = hdef.OKAY
    errtext = ""
    try:
        uncompressed_data = pickle.dumps(ddict)
    except (pickle.PickleError, pickle.PicklingError) as e:
        status = hdef.NOT_OKAY
        errtext = f"An error occurred while run pickle with loaded file: {file_name} with {traceback.format_exc(e)}"
        return (status, errtext)
    except Exception as e:
        status = hdef.NOT_OKAY
        errtext = f"An error occurred while run pickle with loaded file: {file_name} with {traceback.format_exc(e)}"
        return (status, errtext)
    # endtry
    
    try:
        with (open(file_name, "wb") as f):
            f.write(zlib.compress(uncompressed_data))
            f.close()
    except PermissionError:
        status = hdef.NOT_OKAY
        errtext = f"File {file_name} does not exist!"
        return (status, errtext)
    except IOError:
        status = hdef.NOT_OKAY
        errtext = f"An error occurred while reading the file {file_name}"
        return (status, errtext)
    except Exception as e:
        status = hdef.NOT_OKAY
        errtext = f"An error occurred while reading the file {file_name} with {traceback.format_exc(e)}"
        return (status, errtext)
    # endtry
    return (status, errtext)
# end if

def save_json(ddict,file_name):
    '''
    
    :param ddict:
    :param file_name:
    :return: (status, errtext) = save_json(ddict,file_name)
    '''
    status = hdef.OKAY
    errtext = ""
    try:
        json_obj = json.dumps(ddict, indent=2)
        
        # print json to screen with human-friendly formatting
        # pprint.pprint(json_obj, compact=True)
        
        # write json to file with human-friendly formatting
        # pretty_json_str = pprint.pformat(json_obj, compact=False)
        
        with open(file_name, 'w') as f:
            f.write(json_obj)
        
        # with open(file_name, 'w') as outfile:
        #     json.dump(self.ddict, outfile, indent=2)
    
    except PermissionError:
        status = hdef.NOT_OKAY
        errtext = f"File {file_name} does not exist!"
        return (status, errtext)
    except IOError:
        status = hdef.NOT_OKAY
        errtext = f"An error occurred while reading the file {file_name}"
        return (status, errtext)
    except Exception as e:
        status = hdef.NOT_OKAY
        errtext = f"An error occurred while reading the file {file_name} with {e}"
        return (status, errtext)
    # end try
    return (status,errtext)

# def read_dict_file(filebodyname,ddict):
#     '''
#     dict_dict[wkn] = isin
#     :param ddict:
#     :return: dict_dict = read_dict_file(ddict)
#     '''
#     if ddict["use_json"] == 2:
#         file_name = build_file_name_json(filebodyname,ddict)
#     else:
#         file_name = build_file_name_pickle(filebodyname,ddict)
#     # end if
#
#     if not os.path.isfile(file_name):
#         dict_dict = {}
#     else: # read
#         if ddict["use_json"] == 2: # json
#             (status, errtext, dict_dict) = read_json(file_name)
#             if status != hdef.OKAY:
#                 raise Exception(f"read_dict_file: Problems reading {file_name} errtext: {errtext}")
#             # end if
#         else:
#             (status, errtext, dict_dict) = read_pickle(file_name)
#             if status != hdef.OKAY:
#                 raise Exception(f"read_dict_file: Problems reading {file_name} errtext: {errtext}")
#             # end if
#         #end if
#     # end if
#     return dict_dict
# # end if
def save_dict_file_json(dict_dict,filebodyname,ddict):
    '''
    
    :param dict_dict:
    :param ddict:
    :return:
    '''
    file_name = build_file_name_json(filebodyname, ddict)

    (status, errtext) = save_json(dict_dict,file_name)
    if status != hdef.OKAY:
        raise Exception(f"save_dict_file_json: Problems saving {file_name} errtext: {errtext}")
    # end if
    return
# end def
def save_dict_file_pickle(data_ddict, filebodyname, store_path):
    '''

    :param data_ddict:
    :param store_path:
    :return:
    '''
    file_name = build_file_name_pickle(filebodyname, store_path)
    
    (status, errtext) = save_pickle(data_ddict, file_name)
    if status != hdef.OKAY:
        raise Exception(f"save_dict_file_pickle: Problems saving {file_name} errtext: {errtext}")
    # end if
    return
# end def
def read_usdeuro_ezb_xml(classdef,xmlfilename):
    """
    :param classdef
    :param xmlfilename:
    :return: (status, errtext,np_obj) = read_usdeuro_ezb_xml(classdef,xmlfilename)

    """

    status = hdef.OKAY
    errtext = ""

    tree = ET.parse(xmlfilename)
    root = tree.getroot()

    ns = {
        "exr": "http://www.ecb.europa.eu/vocabulary/stats/exr/1"
    }

    date_str_list = []
    value_string_list = []
    for obs in root.findall(".//exr:Obs", ns):
        date_str_list.append(int(datetime.datetime.strptime(obs.attrib["TIME_PERIOD"],"%Y-%m-%d").timestamp()))
        value_string_list.append(float(obs.attrib["OBS_VALUE"]))
    # end for

    np_dat_list = np.array(date_str_list)
    np_usdeuro_liste = np.array(value_string_list)

    if np_dat_list.size == 0:
        status = hdef.NOT_OKAY
        errtext = f"Von Datei: {xmlfilename} konnten keine Daten Obs \"TIME_PERIOD\" ist \"OBS_VALUE\" gefunden werden."
        return (status,errtext,None)
    # end if


    np_dat_arr = np.array(np_dat_list, dtype=np.int64)
    np_usdeuro_arr = np.array(np_usdeuro_liste, dtype=np.float64)

    return classdef(np_dat_arr,np_usdeuro_arr)
# end def

