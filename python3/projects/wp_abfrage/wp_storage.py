import os
import pickle
import json
import zlib
import traceback

import tools.hfkt_def as hdef
# import tools.hfkt_str as hstr

def info_storage_eixst(isin,base_ddict):
    
    if base_ddict["use_json"] == 2:
        file_name = build_file_name_json(base_ddict["basic_info_pre_file_name"] + str(isin),base_ddict)
    else:
        file_name = build_file_name_pickle(base_ddict["basic_info_pre_file_name"] + str(isin),base_ddict)
    # end if

    if os.path.isfile(file_name):
        return True
    else:
        return False
    # end if
# end def
def read_info_dict(isin,base_ddict):
    '''
    
    :param isin:
    :param base_ddict:
    :return:
    '''
    status = hdef.OKAY
    errtext = ""

    if (base_ddict["use_json"] == 2):  # read json
        
        file_name = build_file_name_json(base_ddict["basic_info_pre_file_name"]+str(isin), base_ddict)
        
        if (os.path.isfile(file_name)):
            (status, errtext, info_dict) = read_json(file_name)
        else:
            status = hdef.NOT_OKAY
            errtext = f"File {file_name} does not exist!"
            return (status, errtext, {})
        # end if
    
    else:  # normal pickle load
        file_name = build_file_name_pickle(base_ddict["basic_info_pre_file_name"] + str(isin), base_ddict)
        
        # Wenn die Datei vorhanden ist:
        if (os.path.isfile(file_name)):
            (status, errtext, info_dict) = read_pickle(file_name)
        else:
            info_dict = {}
        # endif
    
    # end if
    
    return (status,errtext,info_dict)
# end def
def read_wpname_isin_dict(base_ddict):
    '''
    
    :param base_ddict:
    :return:
    '''#
    status = hdef.OKAY
    errtext = ""
    
    file_name_pckl = build_file_name_pickle(base_ddict["wpname_isin_filename"], base_ddict)
    file_name_json = build_file_name_json(base_ddict["wpname_isin_filename"], base_ddict)
    
    if (base_ddict["use_json"] == 2):  # read json
        
        if (os.path.isfile(file_name_json)):
            (status, errtext, wpname_dict) = read_json(file_name_json)
        else:
            status = hdef.NOT_OKAY
            errtext = f"File {file_name_json} does not exist!"
            return (status, errtext, {})
        # end if
    
    else:  # normal pickle load
        
        # Wenn die Datei vorhanden ist:
        if (os.path.isfile(file_name_pckl)):
            (status, errtext, wpname_dict) = read_pickle(file_name_pckl)
        else:
            wpname_dict = {}
        # endif
    
    # end if
    return (status, errtext,wpname_dict)
# end def
def save_info_dict(isin, info_dict, base_ddict):
    '''
    
    :param isin:
    :param info_dict:
    :param base_ddict:
    :return: (status, errtext) = wp_storage.save_info_dict(isin, info_dict, base_ddict)
    '''
    status = hdef.OKAY
    errtext = ""
    
    # save pckl
    file_name = build_file_name_pickle(base_ddict["basic_info_pre_file_name"] + str(isin), base_ddict)
    
    (status, errtext) = save_pickle(info_dict, file_name)
    
    if (base_ddict["use_json"] == 1):  # write json
        file_name = build_file_name_json(base_ddict["basic_info_pre_file_name"]+str(isin), base_ddict)
        
        (status, errtext) = save_json(info_dict, file_name)
    # end if
    
    # update isin wpname liste
    if status == hdef.OKAY:
        (status, errtext) = update_isin_name_dict(isin,info_dict["name"],base_ddict)

    return (status,errtext)
# end def
def update_isin_name_dict(isin,wpname,base_ddict):
    '''
    
    :param isin:
    :param wpname:
    :param base_ddict:
    :return: (status, errtext) = update_isin_name_dict(isin,info_dict["name"],base_ddict)
    '''
    
    (status, errtext,wpname_dict) = read_wpname_isin_dict(base_ddict)
    
    if( status != hdef.OKAY):
        return (status, errtext)
    # end if
    
    # set isin and name
    if isin not in wpname_dict.keys():
        print(f"add isin: {isin} und wpname: {wpname} zu wpname_dict[isin] = wpname")
        
    wpname_dict[isin] = wpname
    
    file_name_pckl = build_file_name_pickle(base_ddict["wpname_isin_filename"], base_ddict)
    (status, errtext) = save_pickle(wpname_dict, file_name_pckl)
    
    if (base_ddict["use_json"] == 1):  # write json
        file_name_json = build_file_name_json(base_ddict["wpname_isin_filename"], base_ddict)
        (status, errtext) = save_json(wpname_dict, file_name_json)
    # end if
    
    return (status, errtext)


def build_file_name_pickle(body, base_ddict):
    '''

    :param isin:
    :param base_ddict:
    :return: file_name
    '''
    return os.path.join(base_ddict["store_path"], body + ".pkl")
# end def
def build_file_name_json(body,base_ddict):
    '''

    :param isin:
    :param base_ddict:
    :return: file_name
    '''
    return os.path.join(base_ddict["store_path"], body+".json")
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
def save_dict_file_pickle(data_ddict, filebodyname, base_ddict):
    '''

    :param data_ddict:
    :param base_ddict:
    :return:
    '''
    file_name = build_file_name_pickle(filebodyname, base_ddict)
    
    (status, errtext) = save_pickle(data_ddict, file_name)
    if status != hdef.OKAY:
        raise Exception(f"save_dict_file_pickle: Problems saving {file_name} errtext: {errtext}")
    # end if
    return
# end def
