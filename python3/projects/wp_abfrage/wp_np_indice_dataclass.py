import numpy as np
import os, sys, copy
import joblib

t_path, _ = os.path.split(__file__)
if (t_path == os.getcwd()):

    import hfkt_def as hdef
    import hfkt_file_path as hfile_path
    import hfkt_type as hfkt_type
    import hfkt_date_time as hfkt_date_time

else:
    p_list = os.path.normpath(t_path).split(os.sep)
    if (len(p_list) > 1): p_list = p_list[: -1]
    t_path = ""
    for i, item in enumerate(p_list): t_path += item + os.sep
    if (os.path.normpath(t_path) not in sys.path): sys.path.append(t_path)

    from tools import hfkt_def as hdef
    from tools import hfkt_file_path as hfile_path
    from tools import hfkt_type as hfkt_type
    from tools import hfkt_date_time as hfkt_date_time

# end if

from wp_abfrage import wp_fkt as wp_fkt

class NpDataClass:
    def __init__(self) -> None:
        pass


# end class
class NpIndiceClass:
    def __init__(self, filename=None) -> None:

        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""

        if (filename != None):
            self.file_flag = True
            (store_path, fbody, extension) = hfile_path.get_pfe(filename)
            self.file_name = os.path.join(store_path, fbody + ".joblib")
        else:
            self.file_flag = False
            self.file_name = ""
        # end if

        self.signal_list = ["dat_np_array","indice_np_array"]
        self.dat_np_array = np.array([], dtype=np.int64)
        self.indice_np_array = np.array([], dtype=np.float64)


        self.unit = ""

        self.np_name_list = ["dat_np_array","indice_np_array"]

        self.signal_obj = NpDataClass()

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

    def set_filename(self, filename):
        self.file_flag = True
        (store_path, fbody, extension) = hfile_path.get_pfe(filename)
        self.file_name = os.path.join(store_path, fbody + ".joblib")
        return

    # end def
    def get_filename(self):
        return self.file_name
    # end if
    def put_signal(self, dat_np_array, indice_np_array):

        self.dat_np_array = dat_np_array
        self.indice_np_array = indice_np_array

        return

    # end def
    def get_data(self, signal_name):
        if hasattr(self, signal_name):

            return getattr(self, signal_name)
        else:
            return None
        # end if

    # end def
    def save(self):
        if self.file_flag:
            try:
                joblib.dump(self, self.file_name)
            except Exception as e:
                self.errtext = f"Fehler beim Speichern der Datei: {self.file_name} \nFehler: {e}"
                self.status = hdef.NOT_OKAY
                return
            # end try
        # end if

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
                for signalname in self.signal_list:
                    if hasattr(signal_obj, signalname):
                        self.__setattr__(signalname, getattr(signal_obj, signalname))
                    else:
                        self.errtext = f"read Datei: {self.file_name}: eingelesenes signal_obj hat kein \"{signalname}\""
                        self.status = hdef.NOT_OKAY
                        return
                # end if
            # end if
        # end if
        return

    # end def
    def is_empty(self):
        if hasattr(self, 'dat_np_array'):
            if self.dat_np_array is None:
                return True
            elif len(self.dat_np_array) == 0:
                return True
            # end if
        # end if
        return False

    # end def
    def get_last_data(self):
        if hasattr(self, 'dat_np_array'):
            if isinstance(self.dat_np_array, np.ndarray) and (len(self.dat_np_array) > 0):
                dat_act = self.dat_np_array[-1]
                array_act = self.indice_np_array[-1]
                return (dat_act,array_act)
            # end if
        # end if
        return (None,None)
    # end def
    def get_first_data(self):
        if hasattr(self, 'dat_np_array'):
            if isinstance(self.dat_np_array, np.ndarray) and (len(self.dat_np_array) > 0):
                dat_0 = self.dat_np_array[0]
                array_0 = self.indice_np_array[0]
                return (dat_0,array_0)
            # end if
        # end if
        return (None,None)
    def get_first_last_dat(self, formatstr):
        """
            (first_dat_str, last_dat_str) = self.get_first_last_dat(formatstr)
        """
        first_dat_str = ""
        last_dat_str = ""
        if hasattr(self, 'dat_np_array'):
            if isinstance(self.dat_np_array, np.ndarray) and (len(self.dat_np_array) > 0):
                first_dat = self.dat_np_array[0]
                last_dat = self.dat_np_array[-1]

                first_dat_str = hfkt_type.type_transform_direct(first_dat, "dat", formatstr)
                last_dat_str = hfkt_type.type_transform_direct(last_dat, "dat", formatstr)
        # end if
        return (first_dat_str, last_dat_str)

    # end def
    def sort_by_dat(self):

        if hasattr(self, 'dat_np_array') and isinstance(self.dat_np_array, np.ndarray) and (len(self.dat_np_array) > 0):
            index_arr = np.argsort(self.dat_np_array)
            self.dat_np_array = np.array(self.dat_np_array)[index_arr]
            try:
                self.indice_np_array = np.array(self.indice_np_array)[index_arr]
            except:
                raise Exception(
                    f"start_np_array,high_np_array,low_np_array,end_np_array oder volume_np_array kann nicht sortiert werden")
            # end try
        # end if

    # end def
    def reduce_end_dat(self, end_dat):

        if hasattr(self, 'dat_np_array') and isinstance(self.dat_np_array, np.ndarray) and (len(self.dat_np_array) > 0):

            self.sort_by_dat()

            edayend = hfkt_date_time.secs_to_end_of_day(end_dat)

            while self.dat_np_array[-1] > edayend:
                self.dat_np_array = np.delete(self.dat_np_array, -1)
                self.indice_np_array = np.delete(self.indice_np_array, -1)
                if len(self.dat_np_array) == 0:
                    break
            # end while
        # end if
    # end def
    def set_unit(self,unit):

        if len(unit) == 0:
            self.unit = "-"
        elif unit.find("-") >= 0:
            self.unit = "-"
        elif unit.find("%") >= 0:
            self.unit = "percent"
        elif unit.lower().find("percent") >= 0:
            self.unit = "percent"
        elif unit.lower().find("prozent") >= 0:
            self.unit = "percent"
        else:
            raise Exception(f"unit nicht gefundent werden")
        # end if
        return
    # end def
    def get_unit(self):
        return self.unit
    # end def
    def is_unit(self, unit):
        if (unit.find("%") >= 0) or (unit.lower().find("percent") >= 0) or (unit.lower().find("prozent") >= 0):
            if self.unit == "percent":
                return True
            else:
                return False
            # end if
        elif (unit.find("-") >= 0):
            if self.unit == "-":
                return True
            else:
                return False
            # end if
        else:
            raise Exception(f"unit konnte nicht gefundent werden")
        # end if
        return
