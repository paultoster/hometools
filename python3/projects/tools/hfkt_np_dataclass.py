import numpy as np
import os, sys, copy
import joblib
from openpyxl.cell.cell import TYPE_STRING

t_path, _ = os.path.split(__file__)
if (t_path == os.getcwd()):

    import hfkt_def as hdef
    import hfkt_file_path as hfile_path
else:
    p_list = os.path.normpath(t_path).split(os.sep)
    if (len(p_list) > 1): p_list = p_list[: -1]
    t_path = ""
    for i, item in enumerate(p_list): t_path += item + os.sep
    if (os.path.normpath(t_path) not in sys.path): sys.path.append(t_path)

    from tools import hfkt_def as hdef
    from tools import hfkt_file_path as hfile_path
# end if

TYPE_NDARRAY = "ndarray"
TYPE_STR = "str"
TYPE_FLOAT = "float"
TYPE_INT = "int"

class NpDataClass:
    def __init__(self) -> None:
        pass
# end class
class NpDataHandlingClass:
    def __init__(self,filename=None) -> None:

        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""

        self.TYPE_NDARRAY = TYPE_NDARRAY
        self.TYPE_STR = TYPE_STR
        self.TYPE_FLOAT = TYPE_FLOAT
        self.TYPE_INT = TYPE_INT

        if (filename != None):
            self.file_flag = True
            (store_path,fbody,extension) = hfile_path.get_pfe(filename)
            self.file_name =  os.path.join(store_path, fbody + ".joblib")
        else:
            self.file_flag = False
            self.file_name = ""
        # end if

        self.nsignal     = 0
        self.signal_list = []
        self.signal_type = []
        self.signal_obj  = NpDataClass()

    def get_status(self):
        return self.status
    def get_errtext(self):
        return self.errtext
    def get_infotext(self):
        return self.infotext
    def reset_status(self):
        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""

    def add_signal(self,signal,signal_name):

        self.del_signal(signal_name)

        if isinstance(signal, np.ndarray):
            type = TYPE_NDARRAY
        elif isinstance(signal, str):
            type = TYPE_STR
        elif isinstance(signal, float):
            type = TYPE_FLOAT
        elif isinstance(signal, int):
            type = TYPE_INT
        else:
            raise Exception(f"add_signal: signal_name: {signal_name} Type nicht erkannt")
        # end if

        self.__setattr__(signal_name, copy.copy(signal))

        self.signal_list.append(signal_name)
        self.signal_type.append(type)
        self.nsignal += 1

        return
    # end def
    def get_signame_list(self):
        return self.signal_list
    # end def
    def get_signal_type(self):
        return self.signal_type
    # end def
    def get_data(self,signal_name):
        if signal_name in self.signal_list:

            return self.__getattribute__(signal_name)
        else:
            return None
        # end if
    # end def
    def del_signal(self,signal_name):

        if signal_name in self.signal_list:
            delattr(self, signal_name)
            index = self.signal_list.index(signal_name)
            del self.signal_list[index]
        # end if
        return
    # end def
    def save(self):
        if self.file_flag:
            try:
                joblib.dump(self,self.file_name)
            except Exception as e:
                self.errtext = f"Fehler beim Speichern der Datei: {self.file_name} \nFehler: {e}"
                self.status = hdef.NOT_OKAY
                return
            # end try
        # end if
    # end def
    def read(self):
        if self.file_flag:
            try:
                signal_obj = joblib.load(self.file_name)
            except FileNotFoundError:
                self.errtext = f"Datei: {self.file_name} wurde nicht gefunden."
                self.status = hdef.NOT_OKAY
            except PermissionError:
                self.errtext = f"Keine Berechtigung zum Lesen der Datei: {self.file_name}"
                self.status = hdef.NOT_OKAY
            except EOFError:
                self.errtext = f"Datei: {self.file_name} ist unvollständig oder beschädigt."
                self.status = hdef.NOT_OKAY
            except Exception as e:
                self.errtext = f"Anderer Fehler  Datei: {self.file_name}: {e}"
                self.status = hdef.NOT_OKAY
            # end try

            if self.status == hdef.OKAY:

                if hasattr(signal_obj,"signal_list"):
                    self.signal_list = signal_obj.signal_list
                else:
                    self.errtext = f"read Datei: {self.file_name}: eingelesenes signal_obj hat kein \"signal_list\""
                    self.status = hdef.NOT_OKAY
                    return
                # end if
                if hasattr(signal_obj,"signal_type"):
                    self.signal_type = signal_obj.signal_type
                else:
                    self.errtext = f"read Datei: {self.file_name}: eingelesenes signal_obj hat kein \"signal_type\""
                    self.status = hdef.NOT_OKAY
                    return
                # end if


                self.nsignal = len(self.signal_list)

                for signalname in self.signal_list:
                    if hasattr(signal_obj, signalname):
                        self.__setattr__(signalname, getattr(signal_obj, signalname))
                    else:
                        self.errtext = f"read Datei: {self.file_name}: eingelsenes signal_obj hat kein attribut \"{signalname}\""
                        self.status = hdef.NOT_OKAY
                        return
                    # end if
                # end for
            # end if
        # end if
        return
    # end def

