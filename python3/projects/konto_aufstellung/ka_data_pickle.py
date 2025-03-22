#
# data-pickle-file ein data set vom konto (also mehrere) und iban liste
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
