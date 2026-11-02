import numpy as np
import os, sys, copy
import joblib
# from openpyxl.cell.cell import TYPE_STRING

t_path, _ = os.path.split(__file__)
if (t_path == os.getcwd()):

    import hfkt_def as hdef
    import hfkt_file_path as hfile_path
    import hfkt_io as hio
    import hfkt_type as htype
else:
    p_list = os.path.normpath(t_path).split(os.sep)
    if (len(p_list) > 1): p_list = p_list[: -1]
    t_path = ""
    for i, item in enumerate(p_list): t_path += item + os.sep
    if (os.path.normpath(t_path) not in sys.path): sys.path.append(t_path)

    from tools import hfkt_def as hdef
    from tools import hfkt_file_path as hfile_path
    from tools import hfkt_io as hio
    from tools import hfkt_type as htype
# end if

TYPE_STR = "str"
TYPE_FLOAT = "float"
TYPE_INT = "int"

class SingleDataClass:
    def __init__(self) -> None:
        pass
# end class
class SingleDataHandlingClass:
    def __init__(self,filename=None) -> None:

        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""

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
        self.signal_obj  = SingleDataClass()

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

        if isinstance(signal, str):
            type = self.TYPE_STR
        elif isinstance(signal, (float,np.float64,np.float32)):
            type = self.TYPE_FLOAT
        elif isinstance(signal, (int,np.int8,np.int16,np.int32,np.int64)):
            type = self.TYPE_INT
        else:
            raise Exception(f"add_signal: signal_name: {signal_name} Type nicht erkannt")
        # end if
        match type:
            case self.TYPE_STR:
                self.__setattr__(signal_name, str(copy.copy(signal)))
            case self.TYPE_FLOAT:
                self.__setattr__(signal_name, float(copy.copy(signal)))
            case self.TYPE_INT:
                self.__setattr__(signal_name, int(copy.copy(signal)))
        # end match

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
    def save_to_json(self):
        """
        Schreibt csv Datei
        :return: status
        """
        json_filename = hfile_path.reset_ext(self.file_name, "json")

        ddict = {}

        for signal_name in self.signal_list:
            ddict[signal_name] = self.__getattribute__(signal_name)
        # end for

        jsonobj = hio.DataJson(json_filename)

        jsonobj.save(ddict)

        self.status = jsonobj.get_status()

        if self.status != hdef.OKAY:
            self.errtext = f"save_to_json: Problem mit  {json_filename}  errtext: {jsonobj.get_errtext()}"
        # end if

        del jsonobj

        return self.status
    # end def
    def exist_file(self):
        if self.file_flag:
            if os.path.isfile(self.file_name):
                return True
            # end if
        # end if
        return False
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
    def get_signal(self,signame):
        if hasattr(self, signame):
            return getattr(self,signame)
        else:
            return None
        # end if
    # end def

