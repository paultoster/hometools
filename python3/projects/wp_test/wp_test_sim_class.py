import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_log as hlog
import tools.hfkt_type as htype
import tools.hfkt_np_calc as hnpcalc

import wp_test_bank_class


class WPSim:
    """

    """

    def __init__(self,parstruct) -> None:

        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""

        # Start und End
        #--------------
        self.Start_datStrP  = parstruct.Start
        self.Start_datClass = htype.type_transform_direct(parstruct.Start, "datStrP", "datetimeclass")
        self.End_datStrP = parstruct.End
        self.End_datClass   = htype.type_transform_direct(parstruct.End, "datStrP", "datetimeclass")

        # Gesamt Start Cash
        #------------------
        self.GesamtStartCash_cent = htype.type_transform_direct(parstruct.StartCash, "euroStrK", "cent")

        # Anzahl der Konten
        #------------------
        self.NKonten = len(parstruct.Katalog.keys())



        # Konten erstellen
        #-----------------
        konto_start_cash_np_array = hnpcalc.divide_in_int_nparts(self.GesamtStartCash_cent, self.NKonten)
        self.KontoObjListe = [None]*self.NKonten

        for i in range(self.NKonten):
            self.KontoObjListe[i] = wp_test_bank_class.WPBank(self.Start_datClass,konto_start_cash_np_array[i])

            if self.KontoObjListe[i].get_status() != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = self.KontoObjListe[i].get_errtext()
                self.KontoObjListe[i].reset_status()
                return
            # end if
        # end for



    def get_status(self):
        return self.status
    # end def
    def get_errtext(self):
        return self.errtext
    # end def
    def get_infotext(self):
        return self.infotext
    # end def
    def reset_status(self):
        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""
        return
    # end def
