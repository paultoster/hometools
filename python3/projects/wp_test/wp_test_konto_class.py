import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_tvar as htvar
import tools.hfkt_data_set as hdset
# import tools.hfkt_np_calc as hnpcalc

class WPKonto:
    """

    """
    NAME_DATUM  = "Datum"
    NAME_AKTION = "Aktion"
    NAME_WERT   = "Wert"
    NAME_SUMME  = "Summe"
    Header_liste = [NAME_DATUM, NAME_AKTION, NAME_WERT, NAME_SUMME]
    Type_liste = ["datetimeclass", "str", "cent", "cent"]

    Aktionsliste = ["Anfangswert","Einzahlung"]

    def __init__(self, name,start_dat_datclass,start_cash_cent) -> None:
        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""


        # Konto Daten-Tabelle anlegen
        #-----------------------------
        self.KontoDataSet = hdset.DataSet(name)

        for icol,(header, type) in enumerate(zip(self.Header_liste, self.Type_liste)):
            self.KontoDataSet.set_definition(icol, header, type,type)
        # end for

        # Anfangswert setzen
        #-------------------
        data_set_liste = [start_dat_datclass, "Anfangswert", 0,start_cash_cent]
        status = self.KontoDataSet.add_data_set_liste(data_set_liste, self.Header_liste, self.Type_liste)

        if status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.KontoDataSet.get_errtext()
            self.KontoDataSet.reset_status()
            return
        # end if

        return
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
    def einzahlen(self,start_dat_datclass,start_cash_cent):

        data_set_liste = [start_dat_datclass,"Einzahlung",start_cash_cent,0]

        status = self.KontoDataSet.add_data_set_liste(data_set_liste,self.Header_liste, self.Type_liste)

        if status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.KontoDataSet.get_errtext()
            self.KontoDataSet.reset_status()
            return self.status
        # end if

        # Sume neu bilden:
        self.KontoDataSet.recalc_summe_from_value(self.NAME_SUMME,self.NAME_WERT)

        return self.status
    # end def
