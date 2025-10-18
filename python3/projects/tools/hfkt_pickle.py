#
# data-pickle-file ein data set vom konto (also mehrere) und iban liste
#
# mit data_get() und data_save werden alle pickles geholt und gespeichert
#
# data[par.konto_names]
# data[par.IBAN_DATA_DICT_NAME]
#
#-------------------------------------------------------------------
# obj = hfkt_pickle.DataPickle(name_prefix, body_name, use_json)
#       name_prefix Prefixname for pickle- or json-File
#       body_name   Bodyname for pickle- or json-File
#       use_json    0: don't use 1: write, 2: read
#
#       proof obj.status and obj.errtext
#
# ddict = obj.get_ddict():  get read dictionary
#         obj.set_ddict(ddict)
#         obj.update_ddict(ddict)
#         obj.save()
#         obj.save(ddict)
#-------------------------------------------------------------------
# obj = hfkt_pickle.DataJson(file_name)
#
#       proof obj.status and obj.errtext
#
#        obj.read()
# data = obj.get_data():  get read dictionary
#        obj.set_data(data)
#        obj.save()
#        obj.save(data)



import os, sys
import pickle
import json
import datetime
import zlib
import traceback

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
#  endif

# Hilfsfunktionen
import tools.hfkt_def as hdef
import tools.hfkt_date_time as hdate
import tools.hfkt_file_path as hfile

class DataPickle:
    OKAY = hdef.OK
    NOT_OKAY = hdef.NOT_OK
    
    def __init__(self, name_prefix: str, body_name: str, use_json: int, run_backup: int=0):
        '''
        build data dict
        :param name_prefix: Filename
        :param body_name:   Filesname
        :param use_json:    0: don't 1: write, 2: read
        '''
        self.status = hdef.OKAY
        self.errtext = ""
        self.logtext = ""
        self.name = ""
        self.ddict = {}
        
        # 1: schreibe auch json-datei
        # 2: lessen von json Datei
        if (len(name_prefix) > 0):
            self.filename = name_prefix + "_" + body_name + ".pkl"
            self.filename_json = name_prefix + "_" + body_name + ".json"
        else:
            self.filename = body_name + ".pkl"
            self.filename_json = body_name + ".json"
        # end if
        
        if run_backup:
            make_backup(self.filename)
            make_backup(self.filename_json)

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
        
        else:  # normal pickle load
            
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
    def get_ddict(self):
        return self.ddict
    # end def
    def set_ddict(self,ddict):
        self.ddict = ddict
    # end def
    def update_ddict(self,ddict):
        
        for key in ddict.keys():
            if key in self.ddict.keys():
                if ddict[key] != self.ddict[key]:
                    self.ddict[key] = ddict[key]
                # end if
            else:
                self.ddict[key] = ddict[key]
            # end if
        # end for
    # end def
        
        
        
        self.ddict = ddict
    # end def
    def save(self,ddict:dict = None):
        
        if ddict is not None:
            self.update_ddict(ddict)
        # end if
        try:
            uncompressed_data = pickle.dumps(self.ddict)
        except (pickle.PickleError, pickle.PicklingError) as e:
            self.status = hdef.NOT_OKAY
            self.errtext = f"An error occurred while run pickle with loaded file: {self.filename} with {traceback.format_exc(e)}"
            return
        except TypeError as e:
            self.status = hdef.NOT_OKAY
            self.errtext = f"An TypeError error occurred while run pickle with loaded file: {self.filename} with {e.args[0]}"
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
                json_obj = json.dumps(self.ddict, indent=2)
                
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


class DataJson:
    OKAY = hdef.OK
    NOT_OKAY = hdef.NOT_OK
    
    def __init__(self, filename_json: str):
        '''
        read and write data in json format
        '''
        self.status = hdef.OKAY
        self.errtext = ""
        self.logtext = ""
        self.name = ""
        self.data = None
        self.filename_json = filename_json
    def get_filename(self):
        return self.filename_json
    # end def
    def make_backup(self):
        make_backup(self.filename_json)
        return
    def read(self):
        
        if (os.path.isfile(self.filename_json)):
            
            try:
                with open(self.filename_json, "r") as f:
                    self.data = json.load(f)
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
                
                self.errtext = f"An error occurred while reading the file {self.filename_json} with {e}"
                return
            # endtry
        else:
            self.status = hdef.NOT_OKAY
            self.errtext = f"File {self.filename_json} does not exist!"
            return
        
        # end if
    # enddef
    def get_data(self):
        return self.data
    
    # end def
    def set_data(self, data):
        self.data = data
    
    # end def
    def save(self, data: any = None):
        
        if data is not None:
            self.set_data(data)
        # end if
        try:
            json_obj = json.dumps(self.data, indent=2)
            
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
            self.errtext = f"An error occurred while reading the file {self.filename_json} with {e}"
            return
            
    # enddef
# end class
def make_backup(filename):
    '''
    Mach Backup, wennn filename vorhanden und noch kein Backup gemacht mit Datum gemacht ist
    :param filename:
    :return: None
    '''
    if os.path.isfile(filename):
        
        t = os.path.getmtime(filename)
        
        (p, fbody, ext) = hfile.get_pfe(filename)
        
        backup_body_name = hdate.secs_time_epoch_to_str(t,'_',True,True) + "_" + fbody
        backup_filename = hfile.set_pfe(p, backup_body_name, ext)
        
        if not os.path.isfile(backup_filename):
            okay = hfile.copy(filename, backup_filename, silent=1)
            if okay == hdef.OKAY:
                print(f"Backupcopy: {filename} => {backup_filename}")
            else:
                print(f"!!!! No Backupcopy: {filename} => {backup_filename}")
        # end if
    # end if
    return
    
###########################################################################
# testen mit main
###########################################################################
if __name__ == '__main__':
    
    # with open("demofile.txt", "a") as f:
    #     f.write("Now the file has more content!")
    # # end with
    make_backup("demofile.txt")
    
    # # chnage to directory of data-Files
    # WORKING_DIRECTORY = "K:/data/orga/Toped_save_250823"
    # os.chdir(WORKING_DIRECTORY)
    #
    # obj = DataPickle("depot_wp_smartbroker_depot", "DE000A0S9GB0",1)
    #
    # if obj.status != hdef.OKAY:
    #     print(f"Error: {obj.errtext}")
    #     exit(1)
    # else:
    #     ddict = obj.get_ddict()
    #     print(ddict)
    #     obj.save()
    # # end if
    


# end if