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
import wp_test_rigger_datum_class

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

        # Start Cash
        #------------------
        self.StartCash_cent = htype.type_transform_direct(parstruct.StartCash, "euroStrK", "cent")

        # Konto erstellen
        #-----------------
        self.KontoObj = wp_test_bank_class.WPBank(self.Start_datClass,self.StartCash_cent)

        if self.KontoObj.get_status() != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.KontoObj.get_errtext()
            self.KontoObj.reset_status()
            return
        # end if

        # Prüf Datum (Prüfen der anlage)
        self.PruefDatumtObj = wp_test_rigger_datum_class.WPTriggerDatum(self.Start_datClass,
                                                                        self.End_datClass,
                                                                        parstruct.ErsterTagPruefung,
                                                                        parstruct.WiederholTagPruefung )

        if self.PruefDatumtObj.get_status() != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.PruefDatumtObj.get_errtext()
            self.PruefDatumtObj.reset_status()
            return
        # end if

        # Ergebnis Datum (Zwischergebnis produzieren)
        self.ErgebnisDatumtObj = wp_test_rigger_datum_class.WPTriggerDatum(self.Start_datClass,
                                                                        self.End_datClass,
                                                                        parstruct.ErsterTagErgebnis,
                                                                        parstruct.WiederholTagErgebnis)

        if self.ErgebnisDatumtObj.get_status() != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.ErgebnisDatumtObj.get_errtext()
            self.ErgebnisDatumtObj.reset_status()
            return

        # end if

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
