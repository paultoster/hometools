#
# data-pickle-file ein data set vom konto (also mehrere) und iban liste
#
# mit data_get() und data_save werden alle pickles geholt und gespeichert
#
# data[par.konto_names]
# data[par.IBAN_DICT_DATA_NAME]

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

KONTOPREFIX      = "konto"
IBANPREFIX       = "info"




class ka_data_pickle:

    OKAY = hdef.OK
    NOT_OKAY = hdef.NOT_OK
    status = hdef.OKAY
    errtext = ""
    logtext = ""
    name = ""
    ddict = {}
    filename = "default_name.pkl"
    filename_json = "default_name.json"
    use_json = 0    # 0: keine json-Datei
                    # 1: schreibe auch json-datei
                    # 2: lessen von json Datei

    def __init__(self, name_prefix: str, body_name: str, use_json: int):
        '''
        build data dict
        :param name_prefix: Filename
        :param body_name:   Filesname
        :param use_json:    0: don't 1: write, 2: read
        '''
        if( len(name_prefix) > 0 ):
          self.filename      = name_prefix + "_" + body_name + ".pkl"
          self.filename_json = name_prefix + "_" + body_name + ".json"
        else:
            self.filename = body_name + ".pkl"
            self.filename_json = body_name + ".json"
        # end if
        
        self.name = body_name
        self.use_json = use_json
        
        if (self.use_json == 2):  # read json
            
            if (os.path.isfile(self.filename_json)):
                
                try:
                    with open(self.filename_json, "r") as f:
                        self.ddict = json.load(f)
                        f.close()
                except PermissionError:
                    self.status = hdef.NOT_OKAY
                    self.errtext = f"File {self.filename_json} does not exist!"
                    return
                except IOError:
                    self.status = hdef.NOT_OKAY
                    self.errtext = f"An error occurred while reading the file {self.filename_json}"
                    return
                except Exception as e:
                    self.status = hdef.NOT_OKAY
                    self.errtext = f"An error occurred while reading the file {self.filename_json} with {traceback.format_exc(e)}"
                    return
                # endtry
            else:
                self.status = hdef.NOT_OKAY
                self.errtext = f"File {self.filename_json} does not exist!"
                return
            
            # end if
            
        else: # normal pickle load
            
            # Wenn die Datei vorhanden ist:
            if (os.path.isfile(self.filename)):
        
                try:
                    with open(self.filename, "rb") as f:
                        uncompressed_data = zlib.decompress(f.read())
                        f.close()
                except PermissionError:
                    self.status = hdef.NOT_OKAY
                    self.errtext = f"File {self.filename} does not exist!"
                    return
                except IOError:
                    self.status = hdef.NOT_OKAY
                    self.errtext = f"An error occurred while reading the file {self.filename}"
                    return
                except Exception as e:
                    self.status = hdef.NOT_OKAY
                    self.errtext = f"An error occurred while reading the file {self.filename} with {traceback.format_exc(e)}"
                    return
                # endtry

                try:
                    self.ddict = pickle.loads(uncompressed_data)
                except pickle.UnpicklingError as e:
                    self.status = hdef.NOT_OKAY
                    self.errtext = f"An error occurred while run pickle with loaded file: {self.filename} with {traceback.format_exc(e)}"
                except Exception as e:
                    self.status = hdef.NOT_OKAY
                    self.errtext = f"An error occurred while run pickle with loaded file: {self.filename} with {traceback.format_exc(e)}"
                # endtry
            else:
                
                self.ddict = {}
            
            # endif
        
        # end if

    # enddef
    def save(self):
        
        try:
            uncompressed_data = pickle.dumps(self.ddict)
        except (pickle.PickleError, pickle.PicklingError) as e:
            self.status = hdef.NOT_OKAY
            self.errtext = f"An error occurred while run pickle with loaded file: {self.filename} with {traceback.format_exc(e)}"
            return
        except Exception as e:
            self.status = hdef.NOT_OKAY
            self.errtext = f"An error occurred while run pickle with loaded file: {self.filename} with {traceback.format_exc(e)}"
            return
        # endtry
        
        try:
            with (open(self.filename, "wb") as f):
                f.write(zlib.compress(uncompressed_data))
                f.close()
        except PermissionError:
            self.status = hdef.NOT_OKAY
            self.errtext = f"File {self.filename} does not exist!"
            return
        except IOError:
            self.status = hdef.NOT_OKAY
            self.errtext = f"An error occurred while reading the file {self.filename}"
            return
        except Exception as e:
            self.status = hdef.NOT_OKAY
            self.errtext = f"An error occurred while reading the file {self.filename} with {traceback.format_exc(e)}"
            return
        # endtry

        if (self.use_json == 1):  # read json
            try:
                json_obj = json.dumps(self.ddict,indent=2)
                
                # print json to screen with human-friendly formatting
                # pprint.pprint(json_obj, compact=True)
                
                # write json to file with human-friendly formatting
                # pretty_json_str = pprint.pformat(json_obj, compact=False)
                
                with open(self.filename_json, 'w') as f:
                    f.write(json_obj)
                
                # with open(self.filename_json, 'w') as outfile:
                #     json.dump(self.ddict, outfile, indent=2)
            
            except PermissionError:
                self.status = hdef.NOT_OKAY
                self.errtext = f"File {self.filename_json} does not exist!"
                return
            except IOError:
                self.status = hdef.NOT_OKAY
                self.errtext = f"An error occurred while reading the file {self.filename_json}"
                return
            except Exception as e:
                self.status = hdef.NOT_OKAY
                self.errtext = f"An error occurred while reading the file {self.filename_json} with {traceback.format_exc(e)}"
                return
    
    # end if

    # enddef
#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------

def data_get(par,ini):
    status = hdef.OKAY
    errtext = ""
    data = {}
    
    # read konto-pickle-file
    for konto_name in ini.konto_names:
        if( konto_name in ini.data_pickle_jsonfile_list):
            j = ini.data_pickle_use_json
        else:
            j = 0
        # end if
        d = ka_data_pickle(KONTOPREFIX, konto_name, j)
        if (d.status != hdef.OK):
            status = hdef.NOT_OKAY
            errtext = d.errtext
            return (status, errtext, data)
        #endif
        
        data[konto_name] = proof_konto_data_from_ini(d,ini.konto_data[konto_name])
        
    # endfor

    # iban-liste --------------------------------------------
    if (ini.iban_list_file_name in ini.data_pickle_jsonfile_list):
        j = ini.data_pickle_use_json
    else:
        j = 0
    # end if
    d = ka_data_pickle(IBANPREFIX,ini.iban_list_file_name,j)

    if (d.status != hdef.OK):
        status = hdef.NOT_OKAY
        errtext = d.errtext
        return (status, errtext, data)
    # endif
    
    (status,errtext,data[par.IBAN_DICT_DATA_NAME]) = proof_iban_data_and_add_from_ini(d, par,data,ini)
    
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
        
        if( data[key].status != hdef.OKAY ):
            status  = hdef.NOT_OKAY
            errtext = data[key].errtext
        #endif
    #endfor
    
    return (status,errtext)
#enddef

def proof_konto_data_from_ini(d,ini_data):
    """
    proof ini_data in d
    :param d:
    :param ini_data:
    :return:
    """
    
    for key in ini_data:
        
        if( key in d.ddict):
            if( ini_data[key] != d.ddict[key] ):
                d.ddict[key] = ini_data[key]
            # endif
        else:
            d.ddict[key] = ini_data[key]
        # endif
    # end for
    
    return d
# end def
def proof_iban_data_and_add_from_ini(d,par,data,ini):
    
    status  = hdef.OK
    errtext = ""
    
    if (par.IBAN_DATA_LIST_NAME not in d.ddict):
        d.ddict[par.IBAN_DATA_LIST_NAME] = []
        d.ddict[par.IBAN_ID_MAX_NAME]    = 0
    # end if
    
    # Suche nach ibans in konto-Daten
    for konto_name in ini.konto_names:
        
        dkonto = data[konto_name]
        
        if not ka_iban_data.iban_find(d.ddict[par.IBAN_DATA_LIST_NAME],dkonto.ddict[par.IBAN_NAME]):
            idmax = d.ddict[par.IBAN_ID_MAX_NAME]+1
            (status, errtext,_,data_list) = ka_iban_data.iban_add(d.ddict[par.IBAN_DATA_LIST_NAME],idmax,dkonto.ddict[par.IBAN_NAME], dkonto.ddict[par.BANK_NAME], dkonto.ddict[par.WER_NAME], "")
            if( status != hdef.OK ):
                return (status, errtext, d)
            else:
                d.ddict[par.IBAN_DATA_LIST_NAME] = data_list
                d.ddict[par.IBAN_ID_MAX_NAME] = idmax
            # endif
        # endnif
    # endif

    return (status,errtext,d)
# edndef