import numpy as np
import os, sys, copy
import joblib
import pandas as pd

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


TYPE_NDARRAY = "ndarray"
TYPE_STR = "str"
TYPE_FLOAT = "float"
TYPE_INT = "int"

class NpDataClass:
    def __init__(self) -> None:
        pass
# end class
class NpPriceVolumeClass:
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

        self.signal_list = ["dat_np_array","start_np_array","high_np_array","low_np_array","end_np_array","volume_np_array","currency"]
        self.dat_np_array = np.array([], dtype=np.int64)
        self.start_np_array = np.array([], dtype=np.float64)
        self.high_np_array = np.array([], dtype=np.float64)
        self.low_np_array = np.array([], dtype=np.float64)
        self.end_np_array = np.array([], dtype=np.float64)
        self.volume_np_array = np.array([], dtype=np.float64)
        self.currency: str = ""

        self.np_name_list = ["dat_np_array","start_np_array","high_np_array","low_np_array","end_np_array","volume_np_array"]

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
    def set_filename(self,filename):
        self.file_flag = True
        (store_path, fbody, extension) = hfile_path.get_pfe(filename)
        self.file_name = os.path.join(store_path, fbody + ".joblib")
        return
    # end def
    def get_filename(self):
        return self.file_name
    # end if
    def put_signal(self,dat_np_array,start_np_array,high_np_array,low_np_array,end_np_array,volume_np_array):

        self.dat_np_array = dat_np_array
        self.start_np_array = start_np_array
        self.high_np_array = high_np_array
        self.low_np_array = low_np_array
        self.end_np_array = end_np_array
        self.volume_np_array = volume_np_array

        return
    # end def
    def get_data(self,signal_name):
        if hasattr(self,signal_name):

            return getattr(self,signal_name)
        else:
            return None
        # end if
    # end def
    def save(self):
        self.print_mean_max_min()
        if self.file_flag:
            try:
                joblib.dump(self,self.file_name)
            except Exception as e:
                self.errtext = f"Fehler beim Speichern der Datei: {self.file_name} \nFehler: {e}"
                self.status = hdef.NOT_OKAY
                return
            # end try

            self.save_csv()
        # end if
    # end def
    def save_csv(self):
        if self.file_flag:
            csv_filename = hfile_path.reset_ext(self.file_name,"csv")

            df = pd.DataFrame({
                'Date':  pd.to_datetime(getattr(self, "dat_np_array"), unit='s').strftime('%d.%m.%Y %H:%M-%a'),
                'Open': getattr(self, "start_np_array"),
                'High': getattr(self, "high_np_array"),
                'Low': getattr(self, "low_np_array"),
                'Close': getattr(self, "end_np_array"),
                'Volume': getattr(self, "volume_np_array")
            })

            df.set_index('Date', inplace=True)
            df.to_csv(csv_filename, sep=";", index=True)
            (_, fbody, _) = hfile_path.get_pfe(csv_filename)
            if len(self.infotext):
                self.infotext = self.infotext + "\n"+ f"save_csv: {fbody+".csv"}"
            else:
                self.infotext = f"save_csv: {fbody+".csv"}"

        # end if
        return
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
        self.print_mean_max_min()
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
    def get_first_last_dat(self,formatstr):
        """
            (first_dat_str, last_dat_str) = self.get_first_last_dat(formatstr)
        """
        first_dat_str = ""
        last_dat_str  = ""
        if hasattr(self, 'dat_np_array'):
            if isinstance(self.dat_np_array, np.ndarray) and (len(self.dat_np_array) > 0):
                first_dat = self.dat_np_array[0]
                last_dat = self.dat_np_array[-1]

                first_dat_str = hfkt_type.type_transform_direct(first_dat,"dat",formatstr)
                last_dat_str = hfkt_type.type_transform_direct(last_dat,"dat",formatstr)
        # end if
        return (first_dat_str,last_dat_str)
    # end def
    def sort_by_dat(self):

        if hasattr(self, 'dat_np_array') and isinstance(self.dat_np_array, np.ndarray) and (len(self.dat_np_array) > 0):
            index_arr = np.argsort(self.dat_np_array)
            self.dat_np_array    = np.array(self.dat_np_array)[index_arr]
            try:
                self.start_np_array  = np.array(self.start_np_array)[index_arr]
                self.high_np_array = np.array(self.high_np_array)[index_arr]
                self.low_np_array = np.array(self.low_np_array)[index_arr]
                self.end_np_array = np.array(self.end_np_array)[index_arr]
                self.volume_np_array = np.array(self.volume_np_array)[index_arr]
            except:
                raise Exception(f"start_np_array,high_np_array,low_np_array,end_np_array oder volume_np_array kann nicht sortiert werden")
            # end try
        # end if
    # end def
    def reduce_end_dat(self,end_dat):

        if hasattr(self, 'dat_np_array') and isinstance(self.dat_np_array, np.ndarray) and (len(self.dat_np_array) > 0):

            self.sort_by_dat()

            edayend = hfkt_date_time.secs_to_end_of_day(end_dat)

            while self.dat_np_array[-1] > edayend:
                self.dat_np_array    = np.delete(self.dat_np_array, -1)
                self.start_np_array  = np.delete(self.start_np_array, -1)
                self.high_np_array   = np.delete(self.high_np_array, -1)
                self.low_np_array    = np.delete(self.low_np_array, -1)
                self.end_np_array    = np.delete(self.end_np_array, -1)
                self.volume_np_array = np.delete(self.volume_np_array, -1)
                if len(self.dat_np_array) == 0:
                    break
            # end while
        # end if
    # end def
    def delete_nan_items(self):
        index_list = []
        if hasattr(self, 'dat_np_array') and (len(self.dat_np_array) > 0):

            for i,val in enumerate(self.dat_np_array):

                try:
                    if np.isnan(val):
                        index_list.append(i)
                    elif np.isnan(self.start_np_array[i]):
                        index_list.append(i)
                    elif np.isnan(self.high_np_array[i]):
                        index_list.append(i)
                    elif np.isnan(self.low_np_array[i]):
                        index_list.append(i)
                    elif np.isnan(self.end_np_array[i]):
                        index_list.append(i)
                    elif np.isnan(self.volume_np_array[i]):
                        index_list.append(i)
                    # end if
                except:
                    a = 0

            # end for

            for i in reversed(index_list):
                self.dat_np_array = np.delete(self.dat_np_array, i)
                self.start_np_array = np.delete(self.start_np_array, i)
                self.high_np_array = np.delete(self.high_np_array, i)
                self.low_np_array = np.delete(self.low_np_array, i)
                self.end_np_array = np.delete(self.end_np_array, i)
                self.volume_np_array = np.delete(self.volume_np_array, i)
                if len(self.dat_np_array) == 0:
                    break
                # end if
            # end for
        # end if

        return index_list
    # end def
    def interpolate_nan_items(self):
        """
        flag = self.interpolate_nan_items()
        """
        flag = False
        if hasattr(self, 'dat_np_array') and (len(self.dat_np_array) > 0):

            n = len(self.dat_np_array)

            index_pair_list = []
            for i in range(n):

                for j,name in enumerate(self.np_name_list):

                    np_array = getattr(self,name)
                    if np.isnan(np_array[i]):
                        index_pair_list.append((i, j))
                # end for
            # end for
            for i,j in reversed(index_pair_list):

                Flag = True
                if (i == 0) and (n>1): # Wert von i=1 nehmen

                    if j == 0: # date
                        self.dat_np_array[i] = wp_fkt.naechster_handelstag_timestamp(self.dat_np_array[i+1], vorwaerts=False)
                    else:
                        np_array = getattr(self, self.np_name_list[j])
                        np_array[i] = np_array[i+1]
                        setattr(self,self.np_name_list[j],np_array)
                    # end if

                elif (i > n - 1):
                    pass
                elif (i == n - 1):  # letzen Wert weglöschen

                    self.dat_np_array = np.delete(self.dat_np_array, i)
                    self.start_np_array = np.delete(self.start_np_array, i)
                    self.high_np_array = np.delete(self.high_np_array, i)
                    self.low_np_array = np.delete(self.low_np_array, i)
                    self.end_np_array = np.delete(self.end_np_array, i)
                    self.volume_np_array = np.delete(self.volume_np_array, i)
                    n -= 1
                    if len(self.dat_np_array) == 0:
                        break
                    # end if
                else: # ansonsten interpolieren

                    if j == 0: # date
                        self.dat_np_array[i] = wp_fkt.naechster_handelstag_timestamp(self.dat_np_array[i - 1],
                                                                                    vorwaerts=True)
                    else:
                        np_array = getattr(self, self.np_name_list[j])
                        np_array[i] = (np_array[i+1]+np_array[i-1])/2.
                        setattr(self, self.np_name_list[j], np_array)
                    # end if
                # end if
            # end for
        # end if
        return flag
    # end def
    def interpolate_Ausreisser(self):
        """
        flag = self.interpolate_Ausreisser()
        """
        factor_std = 8
        flag = False
        if hasattr(self, 'dat_np_array') and (len(self.dat_np_array) > 0):

            n = len(self.dat_np_array)

            value_pair_list = []
            name_list = ["start_np_array","high_np_array","low_np_array","end_np_array"]
            for j, name in enumerate(name_list):
                np_array = getattr(self, name_list[j])
                mean = np.mean(np_array)
                std = np.std(np_array)
                value_pair_list.append((mean,std*factor_std))
            # end for

            index_pair_list = []
            for i in range(n):

                for j,name in enumerate(name_list):

                    np_array = getattr(self,name)
                    if abs(np_array[i]-value_pair_list[j][0]) > value_pair_list[j][1]:
                        index_pair_list.append((i, j))
                # end for
            # end for
            for i,j in reversed(index_pair_list):

                flag = True
                if (i == 0) and (n>1): # Wert von i=1 nehmen

                    np_array = getattr(self, name_list[j])
                    t = f"interpolate_Ausreisser: np_ob.{name_list[j]}[0] = {np_array[0]} => {np_array[1]} gesetzt"
                    print(t)
                    self.infotext += "\n" + t
                    np_array[i] = np_array[i + 1]
                    setattr(self, name_list[j], np_array)

                elif i > n-1:
                    pass  # wurde schon am Ende gelöscht
                elif (i == n-1): # letzen Wert weglöschen

                    np_array = getattr(self, name_list[j])
                    t = f"interpolate_Ausreisser: np_ob.{name_list[j]}[{i}] = {np_array[i]} am Ende löschen"
                    print(t)
                    self.infotext += "\n" + t

                    self.dat_np_array = np.delete(self.dat_np_array, i)
                    self.start_np_array = np.delete(self.start_np_array, i)
                    self.high_np_array = np.delete(self.high_np_array, i)
                    self.low_np_array = np.delete(self.low_np_array, i)
                    self.end_np_array = np.delete(self.end_np_array, i)
                    self.volume_np_array = np.delete(self.volume_np_array, i)
                    n -= 1
                    if len(self.dat_np_array) == 0:
                        break
                    # end if
                else: # ansonsten interpolieren

                    fac = self.get_neighbour_factor(i, j, name_list, n, index_pair_list)

                    np_array = getattr(self, name_list[j])

                    t = f"interpolate_Ausreisser: np_ob.{name_list[j]}[{i}] = {np_array[i]} => {(np_array[i - 1] + np_array[i + 1]) / 2. * fac}"
                    print(t)
                    self.infotext += "\n" + t

                    np_array[i] = (np_array[i - 1] + np_array[i + 1]) / 2. * fac
                    setattr(self, name_list[j], np_array)

                # end if
            # end for
        # end if
        return flag
    # end def
    def get_neighbour_factor(self,i,j,name_list,n,index_pair_list):
        """
            fac = self.get_neighbour_factor(i, j, n,index_pair_list)
        """

        name = name_list[j]

        if (i == 0) or (i == n-1): # Wenn erste Zeile oder letzte Zeile in Datensatz
            fac = 1.0
        else:

            # neighbour
            neighbour_list = [na for na in name_list if na != name]

            neighb= None
            for neighbour in neighbour_list:
                if (i,neighbour) not in index_pair_list:
                    neighb = neighbour
                    break
                # end if
            # end for

            if neighb is None:
                fac = 1.0
            else:
                np_array = getattr(self, neighb)
                if i >= len(np_array):
                    i = len(np_array)-2

                fac = np_array[i] / ((np_array[i+1]+np_array[i-1])/2.)
            # end if
        # end if
        return fac
    # end def
    def print_mean_max_min(self):

        if hasattr(self, 'dat_np_array') and (len(self.dat_np_array) > 0):

            n = len(self.dat_np_array)

            value_llist = []
            name_list = ["start_np_array","high_np_array","low_np_array","end_np_array"]
            for j, name in enumerate(name_list):
                np_array = getattr(self, name_list[j])
                mean = np.mean(np_array)
                std = np.std(np_array)
                maxval = np.max(np_array)
                minval = np.min(np_array)
                value_llist.append((mean,std, maxval, minval))
            # end for
            isearch = -1
            maxval_search = -1000.
            for i,liste in enumerate(value_llist):

                if abs(liste[2]) > maxval_search:
                    maxval_search = abs(liste[2])
                    isearch = i
                # end if
                if abs(liste[3]) > maxval_search:
                    maxval_search = abs(liste[3])
                    isearch = i
                # end if
            # end if

            (_, fbody, _) = hfile_path.get_pfe(self.file_name)
            if len(self.infotext):
                self.infotext = self.infotext + "\n"+ f"print_mean_max_min: {fbody}: {name_list[isearch]}, mean: {value_llist[isearch][0]}, std: {value_llist[isearch][1]}, max: {value_llist[isearch][2]}, std: {value_llist[isearch][3]}"
            else:
                self.infotext = f"print_mean_max_min: {fbody}: {name_list[isearch]}, mean: {value_llist[isearch][0]}, std: {value_llist[isearch][1]}, max: {value_llist[isearch][2]}, std: {value_llist[isearch][3]}"
            # end if
        # end if
        return
    # end def
    def set_currency(self,currency):

        if len(currency) == 0:
            self.currency = "euro"
        elif currency.find("€") >= 0:
            self.currency = "euro"
        elif currency.lower().find("eur") >= 0:
            self.currency = "euro"
        elif currency.find("$") >= 0:
            self.currency = "usd"
        elif currency.lower().find("dollar") >= 0:
            self.currency = "usd"
        elif currency.lower().find("usd") >= 0:
            self.currency = "usd"
        elif currency.lower().find("chf") >= 0:
            self.currency = "chf"
        elif currency.lower().find("gbp") >= 0:
            self.currency = "gbp"
        elif currency.find("%") >= 0:
            self.currency = "percent"
        elif currency.lower().find("percent") >= 0:
            self.currency = "percent"
        else:
            raise Exception(f"currency nicht gefundent werden")
        # end if
        return
    # end def
    def get_currency(self):
        return self.currency
    # end def
    def is_currency(self, currency):
        if (currency.find("€") >= 0) or (currency.lower().find("euro") >= 0):
            if self.currency == "euro":
                return True
            else:
                return False
            # end if
        elif (currency.find("$") >= 0) or (currency.lower().find("dollar") >= 0) or (currency.lower().find("usd") >= 0):
            if self.currency == "usd":
                return True
            else:
                return False
            # end if
        elif (currency.lower().find("chf") >= 0):
            if self.currency == "chf":
                return True
            else:
                return False
            # end if
        elif (currency.lower().find("gbp") >= 0):
            if self.currency == "gbp":
                return True
            else:
                return False
            # end if
        elif (currency.find("%") >= 0) or (currency.lower().find("percent") >= 0):
            if self.currency == "percent":
                return True
            else:
                return False
            # end if
        else:
            raise Exception(f"currency nicht gefundent werden")
        # end if
        return


    # end def
