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
# import tools.hfkt_str as hstr

from wp_abfrage import wp_fkt
from wp_abfrage import wp_np_dataclass as wp_np_dc

def info_storage_eixst(isin,flag_use_json,basic_info_pre_file_name,store_path):

    body = basic_info_pre_file_name + str(isin)
    if flag_use_json:
        file_name = build_file_name_json(body,store_path)
    else:
        file_name = build_file_name_pickle(body,store_path)
    # end if

    if os.path.isfile(file_name):
        return True
    else:
        return False
    # end if
# end def
def read_dict(name,flag_use_json,pre_file_name,store_path):
    '''
    
    :param name:
    :param flag_use_json:
    :param pre_file_name:
    :param store_path:
    :return: (status,errtext,ddict) = read_dict(name,flag_use_json,pre_file_name,store_path)
    '''
    status = hdef.OKAY
    errtext = ""

    if flag_use_json:  # read json
        
        file_name = build_file_name_json(pre_file_name+name, store_path)
        
        if (os.path.isfile(file_name)):
            (status, errtext, ddict) = read_json(file_name)
        else:
            status = hdef.NOT_OKAY
            errtext = f"File {file_name} does not exist!"
            return (status, errtext, {})
        # end if
    
    else:  # normal pickle load
        file_name = build_file_name_pickle(pre_file_name + str(name), store_path)
        
        # Wenn die Datei vorhanden ist:
        if (os.path.isfile(file_name)):
            (status, errtext, ddict) = read_pickle(file_name)
        else:
            ddict = {}
        # endif
    
    # end if
    
    return (status,errtext,ddict)
# end def
def save_dict(ddict, name,flag_use_json,pre_file_name,store_path):
    '''

    :param name:
    :param ddict:
    :param flag_use_json:
    :param pre_file_name:
    :param store_path:

    :return: (status, errtext) = wp_storage.save_dict(ddict, name, flag_use_json,pre_file_name,store_path)
    '''
    status = hdef.OKAY
    errtext = ""

    # save pckl
    file_name = build_file_name_pickle(pre_file_name + name,store_path)

    (status, errtext) = save_pickle(ddict, file_name)

    if flag_use_json:  # write json
        file_name = build_file_name_json(pre_file_name + name, store_path)

        (status, errtext) = save_json(ddict, file_name)
    # end if

    return (status, errtext)


# end def
def np_obj_storage_exist(name,flag_use_json,pre_file_name,store_path):
    """

    :param name:
    :param flag_use_json:
    :param pre_file_name:
    :param store_path:
    :return: flag = np_obj_storage_exist(name,flag_use_json,pre_file_name,store_path)
    """
    if flag_use_json:
        file_name = build_file_name_json(pre_file_name + name, store_path)
    else:
        file_name = build_file_name_pickle(pre_file_name + name, store_path)
    # end if

    if os.path.isfile(file_name):
        return True
    else:
        return False
    # end if
# end def
def read_np_obj(classdef,name,flag_use_json,pre_file_name,store_path):
    """

    :param name:
    :param flag_use_json:
    :param pre_file_name:
    :param store_path:
    :param classdef
    :return: (status,errtext,ddict) = read_np_obj(classdef,name,flag_use_json,pre_file_name,store_path)
    """
    status = hdef.OKAY
    errtext = ""

    # Check ob existieret
    flag = np_obj_storage_exist(name,
                                flag_use_json,
                                pre_file_name,
                                store_path)

    # Wenn es ein json Datei war und nicht gefunden, dann wird nachgeschaut ob pickle vorhanden
    # Ansonsten bilde leeres objekt
    if not flag:
        if flag_use_json:
            flagp = np_obj_storage_exist(name,
                                         False,
                                         pre_file_name,
                                         store_path)

            # wenn bereits ein pickle file besteht, dann Fehler ausgeben, da pickle nicht in json gewandelt wurde
            if flagp:
                status = hdef.NOT_OKAY
                file_name = build_file_name_json(pre_file_name +
                                                 name,
                                                 store_path)

                errtext = f"Error read_np_obj: Es besteht ein pickle-File aber das dazugehörige json-File {file_name = } existiert nicht"

                return (status, errtext, None)
            # end if
        # end if
        np_obj = classdef()
    else:
        # lese dict-File
        (status, errtext, ddict) = read_dict(name, flag_use_json, pre_file_name, store_path)
        if (status != hdef.OKAY):
            return (status, errtext,None)

        # bilde leeres Objekt und wandele ddict
        np_obj = classdef()
        np_obj.from_store_dict(ddict)
    # end if

    return (status,errtext,np_obj)
# end def
def save_np_obj(np_obj,name, flag_use_json, pre_file_name, store_path):
    """

    :param name:
    :param flag_use_json:
    :param pre_file_name:
    :param store_path:
    :param np_obj
    :return: (status,errtext) = save_np_obj(np_obj,name,flag_use_json,pre_file_name,store_path)
    """
    # wandel zu dict
    ddict = np_obj.to_store_dict()

    # ddict speichern
    (status, errtext) = save_dict(ddict,name, flag_use_json, pre_file_name, store_path)

    return (status, errtext)
# end def
def read_wpname_isin_dict(wpname_isin_filename,store_path):
    '''
    
    :param base_ddict:
    :return:
    '''#
    status = hdef.OKAY
    errtext = ""
    
    # file_name_pckl = build_file_name_pickle(base_ddict["wpname_isin_filename"], base_ddict)
    file_name_json = build_file_name_json(wpname_isin_filename, store_path)

    # Use always json
    # if (base_ddict["use_json"] == 2):  # read json
        
    if (os.path.isfile(file_name_json)):
        (status, errtext, wpname_dict) = read_json(file_name_json)
    else:
        status = hdef.NOT_OKAY
        errtext = f"File {file_name_json} does not exist!"
        return (status, errtext, {})
    # end if
    
    # else:  # normal pickle load
    #
    #     # Wenn die Datei vorhanden ist:
    #     if (os.path.isfile(file_name_pckl)):
    #         (status, errtext, wpname_dict) = read_pickle(file_name_pckl)
    #     else:
    #         wpname_dict = {}
    #     # endif
    #
    # # end if
    return (status, errtext,wpname_dict)
# end def
def update_isin_name_dict(isin,wpname,wpname_isin_filename,store_path):
    '''
    
    :param isin:
    :param wpname:
    :param base_ddict:
    :return: (status, errtext) = update_isin_name_dict(isin,info_dict["name"],base_ddict)
    '''
    
    (status, errtext,wpname_dict) = read_wpname_isin_dict(wpname_isin_filename,store_path)
    
    if( status != hdef.OKAY):
        return (status, errtext)
    # end if
    
    # set isin and name
    if isin not in wpname_dict.keys():
        print(f"add isin: {isin} und wpname: {wpname} zu wpname_dict[isin] = wpname")
        
    wpname_dict[isin] = wpname

    # save always in json
    #file_name_pckl = build_file_name_pickle(base_ddict["wpname_isin_filename"], base_ddict)
    #(status, errtext) = save_pickle(wpname_dict, file_name_pckl)
    
    # if (base_ddict["use_json"] == 1):  # write json
    file_name_json = build_file_name_json(wpname_isin_filename, store_path)
    (status, errtext) = save_json(wpname_dict, file_name_json)
    # end if
    
    return (status, errtext)


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
        errtext = f"An error occurred while reading the file {file_name} with {traceback.format_exc(e)}"
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
        errtext = f"An error occurred while reading the file {file_name} with {traceback.format_exc(e)}"
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
        errtext = f"An error occurred while reading the file {file_name} with {traceback.format_exc(e)}"
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
def read_usdeuro_ezb_xml(xmlfilename):
    """

    :param xmlfilename:

    :return: (status, errtext,np_obj) = read_usdeuro_ezb_xml(xmlfilename)

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

    return wp_fkt.build_usdeuro_np_obj_from_list(np_dat_list, np_usdeuro_liste)

# end def

