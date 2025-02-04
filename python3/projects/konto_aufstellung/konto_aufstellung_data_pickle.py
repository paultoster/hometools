import os, sys
import pickle
import zlib
import traceback

# tools_path = os.getcwd() + "\\.."
# if (tools_path not in sys.path):
#   sys.path.append(tools_path)
# # endif

# Hilfsfunktionen
import hfkt_def as hdef

KONTOPREFIX = "konto"


class data_pickle:
    OKAY = hdef.OK
    NOT_OKAY = hdef.NOT_OK
    status = hdef.OKAY
    errtext = ""
    logtext = ""
    ddict = {}
    filename = "default_name"
    
    def __init__(self, name_prefix: str, body_name: str):
        
        self.filename = name_prefix + "_" + body_name + ".pkl"
        
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
        # wenn keine Datei vorhanden, wird ein default gebildet
        else:
            
            self.ddict[name_prefix] = body_name
        
        # endif
    
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
    
    # enddef


def data_get(ini):
    status = hdef.OKAY
    errtext = ""
    data = {}
    
    # read konto-pickle-file
    for konto_name in ini.konto_names:
        d = data_pickle(KONTOPREFIX, konto_name)
        
        if (d.status != hdef.OK):
            status = hdef.NOT_OKAY
            errtext = d.errtext
            return (status, errtext, data)
        #endif
        
        data[konto_name] = d
    # endfor
    
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
