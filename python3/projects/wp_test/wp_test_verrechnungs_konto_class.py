import os, sys
import datetime

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_type as htype
# import tools.hfkt_np_calc as hnpcalc
import tools.hfkt_data_set as hdset

class WPVerrechnungsKonto:
    """

    """
    NAME_DATUM  = "Datum"
    NAME_AKTION = "Aktion"
    NAME_WERT   = "Wert"
    NAME_SUMME  = "Summe"
    Header_liste = [NAME_DATUM, NAME_AKTION, NAME_WERT, NAME_SUMME]

    TYPE_DATUM = "datetimeclass"
    TYPE_AKTION = "str"
    TYPE_WERT = "cent"
    TYPE_SUMME = "cent"
    Type_liste = [TYPE_DATUM, TYPE_AKTION, TYPE_WERT, TYPE_SUMME]

    Aktionsliste = ["Anfangswert","Einzahlung"]

    def __init__(self,name,start_dat_datclass, start_cash_cent) -> None:

        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""

        # Konto anlegen
        #--------------
        self.KontoDataSet = hdset.DataSet(name)
        self.KontoDataSet.set_definition_list(self.Header_liste, self.Type_liste, self.Type_liste)

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
    # end def


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
    def einzahlen(self,dat_datclass,cash_cent):
        """
        Einzahlen einer Summe

        :param dat_datclass:
        :param cash_cent:
        :return:
        """

        # summe bilden:
        #--------------
        if self.KontoDataSet.get_n_data() > 0:
            summe = self.KontoDataSet.get_data_item(self.KontoDataSet.get_n_data()-1,self.NAME_SUMME)
            (okay,wert) = htype.proof_type(cash_cent,self.TYPE_WERT)
            if okay != hdef.OKAY:
                raise Exception(f"einzahlen: cash_cent = {cash_cent} kann nicht in type = {self.TYPE_WERT} gewandelt werden")

            summe += wert
        else:
            summe = 0
        # end if
        data_set_liste = [dat_datclass,"Einzahlung",cash_cent,summe]

        status = self.KontoDataSet.add_data_set_liste(data_set_liste,self.Header_liste, self.Type_liste)

        if status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.KontoDataSet.get_errtext()
            self.KontoDataSet.reset_status()
            return self.status
        # end if

        return self.status
    # end def
