import os
import pickle
import json
import zlib
import traceback

import tools.hfkt_def as hdef
import tools.hfkt_str as hstr

def info_storage_eixst(isin,ddict):
    
    if ddict["use_json"] == 2:
        file_name = build_file_name_json(isin,ddict)
    else:
        file_name = build_file_name_pickle(isin,ddict)
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
        
        file_name = build_file_name_json(isin, ddict)
        
        if (os.path.isfile(file_name)):
            
            try:
                with open(file_name, "r") as f:
                    info_dict = json.load(f)
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
        else:
            status = hdef.NOT_OKAY
            errtext = f"File {file_name} does not exist!"
            return (status, errtext, {})
        
        # end if
    
    else:  # normal pickle load
        file_name = build_file_name_pickle(isin, ddict)
        # Wenn die Datei vorhanden ist:
        if (os.path.isfile(file_name)):
            
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
                info_dict = pickle.loads(uncompressed_data)
            except pickle.UnpicklingError as e:
                status = hdef.NOT_OKAY
                errtext = f"An error occurred while run pickle with loaded file: {file_name} with {traceback.format_exc(e)}"
                return (status, errtext, {})
            except Exception as e:
                status = hdef.NOT_OKAY
                errtext = f"An error occurred while run pickle with loaded file: {file_name} with {traceback.format_exc(e)}"
                return (status, errtext, {})
            # endtry
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
    file_name = build_file_name_pickle(isin, ddict)
    try:
        uncompressed_data = pickle.dumps(info_dict)
    except (pickle.PickleError, pickle.PicklingError) as e:
        status = hdef.NOT_OKAY
        errtext = f"An error occurred while run pickle with loaded file: {file_name} with {traceback.format_exc(e)}"
        return (status,errtext)
    except Exception as e:
        status = hdef.NOT_OKAY
        errtext = f"An error occurred while run pickle with loaded file: {file_name} with {traceback.format_exc(e)}"
        return (status,errtext)
    # endtry
    
    try:
        with (open(file_name, "wb") as f):
            f.write(zlib.compress(uncompressed_data))
            f.close()
    except PermissionError:
        status = hdef.NOT_OKAY
        errtext = f"File {file_name} does not exist!"
        return (status,errtext)
    except IOError:
        status = hdef.NOT_OKAY
        errtext = f"An error occurred while reading the file {file_name}"
        return (status,errtext)
    except Exception as e:
        status = hdef.NOT_OKAY
        errtext = f"An error occurred while reading the file {file_name} with {traceback.format_exc(e)}"
        return (status,errtext)
    # endtry
    
    if (ddict["use_json"] == 1):  # write json
        file_name = build_file_name_json(isin, ddict)
        
        try:
            json_obj = json.dumps(info_dict, indent=2)
            
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
            return (status,errtext)
        except IOError:
            status = hdef.NOT_OKAY
            errtext = f"An error occurred while reading the file {file_name}"
            return (status,errtext)
        except Exception as e:
            status = hdef.NOT_OKAY
            errtext = f"An error occurred while reading the file {file_name} with {traceback.format_exc(e)}"
            return (status,errtext)
        # end try
    # end if
    
    return (status,errtext)
# end def
def build_file_name_pickle(isin, ddict):
    '''

    :param isin:
    :param ddict:
    :return: file_name
    '''
    return os.path.join(ddict["store_path"], ddict["pre_file_name"] + str(isin) + ".pkl")
# end def
def build_file_name_json(isin,ddict):
    '''

    :param isin:
    :param ddict:
    :return: file_name
    '''
    return os.path.join(ddict["store_path"], ddict["pre_file_name"]+str(isin)+".json")
# end def