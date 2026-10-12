import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
# import tools.hfkt_log as hlog
# import tools.hfkt_type as htype
# import tools.hfkt_np_calc as hnpcalc

import konto_verrechnung_class
import konto_zins_class

class WPKonto:
    """

    """

    def __init__(self,parobj,dataobj) -> None:

        self.Parobj = parobj
        self.Dataobj = dataobj

        # Verrechnungskonto anlegen
        #------------------
        self.KontoVerrechnung = konto_verrechnung_class.WPKontoVerrechnung(self.Parobj,"Cashkonto")

        # Zinskonto
        #----------
        self.KontoZins = konto_zins_class.WPKontoZins(self.Parobj,"Zinskonto")

        return
    # end def
    def uebreweise_von_Verrechnung_auf_Zins(self,cash_cent):

        tat_cash_cent = self.KontoVerrechnung.auszahlen(cash_cent,
                                                        self.Dataobj.AktDat_datetime,
                                                        "Auszahlung an Zinskonto")
        if self.Parobj.status != hdef.STATUS_OK:
            return 0

        tat_cash_cent = self.KontoZins.einzahlen(tat_cash_cent,
                                                 self.Dataobj.AktDat_datetime,
                                                 "Einzahlung von Verrechnungskonto",
                                                 self.Dataobj.AktZins_float)
        if self.Parobj.status != hdef.STATUS_OK:
            return 0
        return tat_cash_cent
    # end if

