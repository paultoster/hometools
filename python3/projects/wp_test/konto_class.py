import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_data_set as hdset
# import tools.hfkt_log as hlog
import tools.hfkt_type as htype
# import tools.hfkt_np_calc as hnpcalc

import konto_verrechnung_class
import konto_zins_class

class WPKonto:
    """

    """
    NAME_STEUER_TAB_DATUM  = "Datum"
    NAME_STEUER_TAB_AKTION = "Aktion"
    NAME_STEUER_TAB_WERT   = "Wert"
    NAME_STEUER_TAB_SUMME  = "Summe"
    HEADER_STEUER_TAB_LISTE = [NAME_STEUER_TAB_DATUM,
                               NAME_STEUER_TAB_AKTION,
                               NAME_STEUER_TAB_WERT,
                               NAME_STEUER_TAB_SUMME]

    ICOL_STEUER_TAB_DATUM = HEADER_STEUER_TAB_LISTE.index(NAME_STEUER_TAB_DATUM)
    ICOL_STEUER_TAB_AKTION = HEADER_STEUER_TAB_LISTE.index(NAME_STEUER_TAB_AKTION)
    ICOL_STEUER_TAB_WERT = HEADER_STEUER_TAB_LISTE.index(NAME_STEUER_TAB_WERT)
    ICOL_STEUER_TAB_SUMME = HEADER_STEUER_TAB_LISTE.index(NAME_STEUER_TAB_SUMME)

    TYPE_STEUER_TAB_DATUM = "datetimeclass"
    TYPE_STEUER_TAB_AKTION = "str"
    TYPE_STEUER_TAB_WERT = "cent"
    TYPE_STEUER_TAB_SUMME = "cent"
    TYPE_STEUER_TAB_LISTE = [TYPE_STEUER_TAB_DATUM, TYPE_STEUER_TAB_AKTION, TYPE_STEUER_TAB_WERT, TYPE_STEUER_TAB_SUMME]

    def __init__(self,parobj,dataobj) -> None:

        self.Parobj = parobj
        self.DataObj = dataobj

        # Verrechnungskonto anlegen
        #------------------
        self.KontoVerrechnung = konto_verrechnung_class.WPKontoVerrechnung(self.Parobj,"Cashkonto")

        # Zinskonto
        #----------
        self.KontoZins = konto_zins_class.WPKontoZins(self.Parobj,self.DataObj.AktZins_float,"Zinskonto")


        # Steuertabelle
        #--------------
        self.SteuerDataSet = hdset.DataSet("Steuertabelle")
        self.SteuerDataSet.set_definition_list(self.HEADER_STEUER_TAB_LISTE,
                                              self.TYPE_STEUER_TAB_LISTE,
                                              self.TYPE_STEUER_TAB_LISTE)
        # Anfangswert setzen
        #-------------------
        data_set_liste = [self.Parobj.StartDat_datetime,
                          "Anfangswert", 0,0]
        status = self.SteuerDataSet.add_data_set_liste(data_set_liste,
                                                       self.HEADER_STEUER_TAB_LISTE,
                                                       self.TYPE_STEUER_TAB_LISTE)

        if status != hdef.OKAY:
            self.Parobj.status = hdef.NOT_OKAY
            self.Parobj.errtext = self.SteuerDataSet.get_errtext()
            self.SteuerDataSet.reset_status()
            return
        # end if

        return
    # end def
    def uebreweise_von_Verrechnung_auf_Zins(self,cash_cent):

        tat_cash_cent = self.KontoVerrechnung.auszahlen(cash_cent,
                                                        self.DataObj.AktDat_datetime,
                                                        "Auszahlung an Zinskonto")
        if self.Parobj.status != hdef.OKAY:
            return 0

        tat_cash_cent = self.KontoZins.einzahlen(tat_cash_cent,
                                                 self.DataObj.AktDat_datetime,
                                                 "Einzahlung von Verrechnungskonto",
                                                 self.DataObj.AktZins_float)
        if self.Parobj.status != hdef.OKAY:
            return 0
        return tat_cash_cent
    # end if
    def MacheZinsAbrechnung(self):

        steuer_c = self.KontoZins.MacheZinsAbrechnung(self.DataObj.AktDat_datetime)

        # In Steuerliste eintragen
        #-------------------------
        if steuer_c > 0:
            self.MacheEintragSteuer(steuer_c,"Zinskonto_abrechnung")
        # end if

        return
    # end def
    def MacheEintragSteuer(self,steuer_cent,aktion):

        # Prüfen
        # -------
        (okay, wert) = htype.type_proof(steuer_cent, self.TYPE_STEUER_TAB_WERT)
        if okay != hdef.OKAY:
            raise Exception(
                f"einzahlen: steuer_cent = {steuer_cent} kann nicht in type = {self.TYPE_STEUER_TAB_WERT} gewandelt werden")

        # summe bilden:
        # --------------
        if self.SteuerDataSet.get_n_data() > 0:
            summe = self.SteuerDataSet.get_data_item(self.SteuerDataSet.get_n_data() - 1,
                                                     self.NAME_STEUER_TAB_SUMME)
            summe += wert
        else:
            summe = 0
        # end if
        data_set_liste = [self.DataObj.AktDat_datetime, aktion, wert, summe]

        status = self.SteuerDataSet.add_data_set_liste(data_set_liste,
                                                       self.HEADER_STEUER_TAB_LISTE,
                                                       self.TYPE_STEUER_TAB_LISTE)

        if status != hdef.OKAY:
            self.Parobj.status = hdef.NOT_OKAY
            self.Parobj.errtext = self.SteuerDataSet.get_errtext()
            self.SteuerDataSet.reset_status()
            return wert
        # end if

        return wert
# end def