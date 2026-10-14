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

class WPKontoVerrechnung:
    """

    """
    NAME_DATUM  = "Datum"
    NAME_AKTION = "Aktion"
    NAME_WERT   = "Wert"
    NAME_SUMME  = "Summe"
    HEADER_LISTE = [NAME_DATUM, NAME_AKTION, NAME_WERT, NAME_SUMME]

    ICOL_DATUM = HEADER_LISTE.index(NAME_DATUM)
    ICOL_AKTION = HEADER_LISTE.index(NAME_AKTION)
    ICOL_WERT = HEADER_LISTE.index(NAME_WERT)
    ICOL_SUMME = HEADER_LISTE.index(NAME_SUMME)

    TYPE_DATUM = "datetimeclass"
    TYPE_AKTION = "str"
    TYPE_WERT = "cent"
    TYPE_SUMME = "cent"
    TYPE_LISTE = [TYPE_DATUM, TYPE_AKTION, TYPE_WERT, TYPE_SUMME]


    def __init__(self,parobj,name) -> None:

        self.Parobj = parobj

        # Konto anlegen
        #--------------
        self.KontoDataSet = hdset.DataSet(name)
        self.KontoDataSet.set_definition_list(self.HEADER_LISTE, self.TYPE_LISTE, self.TYPE_LISTE)
        self.KontoDataSetSonderEintrag = False
        self.KontoDataSetSonderEintragListe = []

        # Anfangswert setzen
        #-------------------
        data_set_liste = [self.Parobj.StartDat_datetime, "Anfangswert", 0,self.Parobj.StartCash_cent]
        status = self.KontoDataSet.add_data_set_liste(data_set_liste, self.HEADER_LISTE, self.TYPE_LISTE)

        if status != hdef.OKAY:
            self.Parobj.status = hdef.NOT_OKAY
            self.Parobj.errtext = self.KontoDataSet.get_errtext()
            self.KontoDataSet.reset_status()
            return
        # end if

        return
    # end def


    def einzahlen(self,cash_cent,aktdat_datetime,aktion):
        """
         Einzahlen cash_sent

        :param cash_cent:
        :param aktdat_datetime:
        :param aktion:
        :return: tat_cash_cent = self.einzahlen(cash_cent,aktdat_datetime,aktion)
        """

        # Prüfen
        #-------
        (okay, wert) = htype.type_proof(cash_cent, self.TYPE_WERT)
        if okay != hdef.OKAY:
            raise Exception(
                f"einzahlen: cash_cent = {cash_cent} kann nicht in type = {self.TYPE_WERT} gewandelt werden")

        # summe bilden:
        #--------------
        if self.KontoDataSet.get_n_data() > 0:
            summe = self.KontoDataSet.get_data_item(self.KontoDataSet.get_n_data()-1,self.NAME_SUMME)
            summe += wert
        else:
            summe = 0
        # end if
        data_set_liste = [aktdat_datetime,aktion,wert,summe]

        status = self.KontoDataSet.add_data_set_liste(data_set_liste,self.HEADER_LISTE, self.TYPE_LISTE)

        if status != hdef.OKAY:
            self.Parobj.status = hdef.NOT_OKAY
            self.Parobj.errtext = self.KontoDataSet.get_errtext()
            self.KontoDataSet.reset_status()
            return wert
        # end if

        # Sondereintrag, der wieder gelöscht wird
        if self.KontoDataSetSonderEintrag:
            self.KontoDataSetSonderEintragListe.append(self.KontoDataSet.get_n_data() - 1)
        # end if

        return wert
    # end def
    def auszahlen(self,cash_cent,aktdat_datetime,aktion):
        """
         Auszahlen cash_sent

        :param cash_cent:
        :param aktdat_datetime:
        :param aktion:
        :return: tat_cash_cent = self.auszahlen(cash_cent,aktdat_datetime,aktion)
        """
        if cash_cent is None:
            cash_cent = self.GetSumme()
        # end if

        cash_cent = abs(cash_cent)

        if self.KontoDataSet.get_n_data() > 0:
            summe = self.GetSumme()
        else:
            summe = 0
        # end if

        # Prüfen
        #-------
        (okay, wert) = htype.type_proof(cash_cent, self.TYPE_WERT)
        if okay != hdef.OKAY:
            raise Exception(
                f"einzahlen: cash_cent = {cash_cent} kann nicht in type = {self.TYPE_WERT} gewandelt werden")

        if wert > summe:
            wert = summe
        # end if

        # summe bilden:
        #--------------
        summe -= wert

        data_set_liste = [aktdat_datetime,aktion,-wert,summe]

        status = self.KontoDataSet.add_data_set_liste(data_set_liste,self.HEADER_LISTE, self.TYPE_LISTE)

        if status != hdef.OKAY:
            self.Parobj.status = hdef.NOT_OKAY
            self.Parobj.errtext = self.KontoDataSet.get_errtext()
            self.KontoDataSet.reset_status()
            return wert
        # end if

        # Sondereintrag, der wieder gelöscht wird
        if self.KontoDataSetSonderEintrag:
            self.KontoDataSetSonderEintragListe.append(self.KontoDataSet.get_n_data() - 1)
        # end if

        return wert
    # end def
    def GetSumme(self):
        summe = self.KontoDataSet.get_data_item(self.KontoDataSet.get_n_data() - 1, self.NAME_SUMME)
        return summe
    # end def
    def SetzeSonderEintragFlag(self):
        self.KontoDataSetSonderEintrag = True
        return
    # end def
    def LoescheSonderEintrag(self):

        if len(self.KontoDataSetSonderEintragListe):

            liste = sorted(self.KontoDataSetSonderEintragListe,reverse=True)

            flagLastPoints = True
            for irow in liste:
                if (irow+1) != self.KontoDataSet.get_n_data() :
                    flagLastPoints = False
                # end if
                status = self.KontoDataSet.delete_row_in_data_set(irow)
                if status != hdef.OKAY:
                    self.Parobj.status = hdef.NOT_OKAY
                    self.Parobj.errtext = self.KontoDataSet.get_errtext()
                    self.KontoDataSet.reset_status()
                    return
                # end if
            # end for

            # Summen neu Berechnen
            if not flagLastPoints:
                self.KontoDataSet.recalc_summe_from_value(self.NAME_SUMME,
                                                           self.NAME_WERT)
            # end if
            self.KontoDataSetSonderEintragListe = []
        # end if
        self.KontoDataSetSonderEintrag = False
        return
    # end def
# end class