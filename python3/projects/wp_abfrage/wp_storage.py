import os
import pickle
import json
import zlib
import traceback

import tools.hfkt_def as hdef
# import tools.hfkt_str as hstr

def info_storage_eixst(isin,ddict):
    
    if ddict["use_json"] == 2:
        file_name = build_file_name_json(ddict["basic_info_pre_file_name"] + str(isin),ddict)
    else:
        file_name = build_file_name_pickle(ddict["basic_info_pre_file_name"] + str(isin),ddict)
    # end if

    if os.path.isfile(file_name):
        return True
    else:
        return False
    # end if
# end def
def read_info_dict(isin,ddict):
    '''
    
    :param isin:
    :param ddict:
    :return:
    '''
    status = hdef.OKAY
    errtext = ""

    if (ddict["use_json"] == 2):  # read json
        
        file_name = build_file_name_json(ddict["basic_info_pre_file_name"]+str(isin), ddict)
        
        if (os.path.isfile(file_name)):
            (status, errtext, info_dict) = read_json(file_name)
        else:
            status = hdef.NOT_OKAY
            errtext = f"File {file_name} does not exist!"
            return (status, errtext, {})
        # end if
    
    else:  # normal pickle load
        file_name = build_file_name_pickle(ddict["basic_info_pre_file_name"] + str(isin), ddict)
        
        # Wenn die Datei vorhanden ist:
        if (os.path.isfile(file_name)):
            (status, errtext, info_dict) = read_pickle(file_name)
        else:
            info_dict = {}
        # endif
    
    # end if
    
    return (status,errtext,info_dict)
# end def
def save_info_dict(isin, info_dict, ddict):
    '''
    
    :param isin:
    :param info_dict:
    :param ddict:
    :return: (status, errtext) = wp_storage.save_info_dict(isin, info_dict, self.ddict)
    '''
    status = hdef.OKAY
    errtext = ""
   
    # save pckl
    file_name = build_file_name_pickle(ddict["basic_info_pre_file_name"] + str(isin), ddict)
    
    (status, errtext) = save_pickle(info_dict, file_name)
    
    if (ddict["use_json"] == 1):  # write json
        file_name = build_file_name_json(ddict["basic_info_pre_file_name"]+str(isin), ddict)
        
        (status, errtext) = save_json(info_dict, file_name)
    # end if
    
    return (status,errtext)
# end def
def build_file_name_pickle(body, ddict):
    '''

    :param isin:
    :param ddict:
    :return: file_name
    '''
    return os.path.join(ddict["store_path"], body + ".pkl")
# end def
def build_file_name_json(body,ddict):
    '''

    :param isin:
    :param ddict:
    :return: file_name
    '''
    return os.path.join(ddict["store_path"], body+".json")
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

def read_dict_file(filebodyname,ddict):
    '''
    dict_dict[wkn] = isin
    :param ddict:
    :return: dict_dict = read_dict_file(ddict)
    '''
    if ddict["use_json"] == 2:
        file_name = build_file_name_json(filebodyname,ddict)
    else:
        file_name = build_file_name_pickle(filebodyname,ddict)
    # end if
    
    if not os.path.isfile(file_name):
        dict_dict = {}
    else: # read
        if ddict["use_json"] == 2: # json
            (status, errtext, dict_dict) = read_json(file_name)
            if status != hdef.OKAY:
                raise Exception(f"read_dict_file: Problems reading {file_name} errtext: {errtext}")
            # end if
        else:
            (status, errtext, dict_dict) = read_pickle(file_name)
            if status != hdef.OKAY:
                raise Exception(f"read_dict_file: Problems reading {file_name} errtext: {errtext}")
            # end if
        #end if
    # end if
    return dict_dict
# end if
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
def save_dict_file_pickle(dict_dict, filebodyname, ddict):
    '''

    :param dict_dict:
    :param ddict:
    :return:
    '''
    file_name = build_file_name_pickle(filebodyname, ddict)
    
    (status, errtext) = save_pickle(dict_dict, file_name)
    if status != hdef.OKAY:
        raise Exception(f"save_dict_file_pickle: Problems saving {file_name} errtext: {errtext}")
    # end if
    return
# end def
