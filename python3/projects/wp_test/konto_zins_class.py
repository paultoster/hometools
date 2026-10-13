import os, sys
import datetime

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_type as htype
import tools.hfkt_tvar as htvar
import tools.hfkt_data_set as hdset

class WPKontoZins:
    """

    """
    NAME_DATUM  = "Datum"
    NAME_AKTION = "Aktion"
    NAME_WERT   = "Wert"
    NAME_SUMME  = "Summe"
    NAME_ZINS   = "Zins"
    Header_liste = [NAME_DATUM, NAME_AKTION, NAME_WERT, NAME_SUMME, NAME_ZINS]

    ICOL_DATUM = Header_liste.index(NAME_DATUM)
    ICOL_AKTION = Header_liste.index(NAME_AKTION)
    ICOL_WERT = Header_liste.index(NAME_WERT)
    ICOL_SUMME = Header_liste.index(NAME_SUMME)
    ICOL_ZINS = Header_liste.index(NAME_ZINS)

    TYPE_DATUM = "datetimeclass"
    TYPE_AKTION = "str"
    TYPE_WERT = "wert"
    TYPE_WERT = "cent"
    TYPE_SUMME = "cent"
    TYPE_ZINS = "float"
    Type_liste = [TYPE_DATUM, TYPE_AKTION, TYPE_WERT, TYPE_SUMME,TYPE_ZINS]



    def __init__(self,parobj,aktZins_float, name) -> None:

        self.Parobj = parobj

        # Konto anlegen
        #--------------
        self.KontoDataSet = hdset.DataSet(name)
        self.KontoDataSet.set_definition_list(self.Header_liste, self.Type_liste, self.Type_liste)

        # Anfangswert setzen ,
        #-------------------
        data_set_liste = [self.Parobj.StartDat_datetime, "Anfangswert", 0, 0, aktZins_float]
        status = self.KontoDataSet.add_data_set_liste(data_set_liste, self.Header_liste, self.Type_liste)

        if status != hdef.OKAY:
            self.Parobj.status = hdef.NOT_OKAY
            self.Parobj.errtext = self.KontoDataSet.get_errtext()
            self.reset_status()
            return
        # end if

        # iter Datensatz, bis dahin sind die Zinsen berechnet
        #----------------------------------------------------
        self.IrowLetzteZinsAbrechnung = 0

        return
    # end def
    def einzahlen(self,cash_cent,aktdat_datetime,aktion,aktzins_float):
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
        data_set_liste = [aktdat_datetime,aktion,wert,summe,aktzins_float]

        status = self.KontoDataSet.add_data_set_liste(data_set_liste,self.Header_liste, self.Type_liste)

        if status != hdef.OKAY:
            self.Parobj.status = hdef.NOT_OKAY
            self.Parobj.errtext = self.KontoDataSet.get_errtext()
            self.KontoDataSet.reset_status()
            return wert
        # end if

        return wert
    # end def
    def auszahlen(self,cash_cent,aktdat_datetime,aktion, aktzins_float):
        """
         Auszahlen cash_sent

        :param cash_cent:
        :param aktdat_datetime:
        :param aktion:
        :return: tat_cash_cent = self.auszahlen(cash_cent,aktdat_datetime,aktion)
        """

        if self.KontoDataSet.get_n_data() > 0:
            summe = self.KontoDataSet.get_data_item(self.KontoDataSet.get_n_data()-1,self.NAME_SUMME)
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

        data_set_liste = [aktdat_datetime,aktion,wert,summe,aktzins_float]

        status = self.KontoDataSet.add_data_set_liste(data_set_liste,self.Header_liste, self.Type_liste)

        if status != hdef.OKAY:
            self.Parobj.status = hdef.NOT_OKAY
            self.Parobj.errtext = self.KontoDataSet.get_errtext()
            self.KontoDataSet.reset_status()
            return wert
        # end if

        return wert
    # end def
    def AktuallisiereZins(self,aktDat_datetime,aktZins_float):
        """
        Prüfen ob sich der Zins geändert hat
        :param aktDat_datetime:
        :param aktZins_float:
        :return:
        """
        alterZins_float = self.KontoDataSet.get_data_item(self.KontoDataSet.get_n_data() - 1, self.NAME_ZINS)

        if abs(aktZins_float - alterZins_float) > 0.0001:
            self.einzahlen( 0, aktDat_datetime, "Zinsänderung", aktZins_float)
        # end if

        return
    # end def
    def MacheZinsAbrechnung(self,aktDat_datetime):
        """

        :param aktDat_datetime:
        :return: steuer_c   Steueranteil in Cent
        """
        ndata = self.KontoDataSet.get_n_data()
        tlist = self.KontoDataSet.get_one_data_set_tlist(self.IrowLetzteZinsAbrechnung)

        summe_c  = htvar.get_val_from_list(tlist, self.ICOL_SUMME)
        dat_dt0 = htvar.get_val_from_list(tlist, self.ICOL_DATUM)
        zins_f = htvar.get_val_from_list(tlist, self.ICOL_ZINS)

        ertrag_float = 0.0
        for irow in range(self.IrowLetzteZinsAbrechnung+1,ndata):

            tlist = self.KontoDataSet.get_one_data_set_tlist(irow)

            dat_dt1 = htvar.get_val_from_list(tlist, self.ICOL_DATUM)
            differenz = dat_dt1 - dat_dt0
            tage      = differenz.days
            dat_dt0   = dat_dt1

            ertrag_float += float(summe_c) * float(tage) / self.Parobj.tage_pro_jahr * zins_f

            summe_c  = htvar.get_val_from_list(tlist, self.ICOL_SUMME)
            zins_f = htvar.get_val_from_list(tlist, self.ICOL_ZINS)
        # end for

        differenz = aktDat_datetime - dat_dt0
        tage      = differenz.days
        ertrag_float += float(summe_c) * float(tage) / self.Parobj.tage_pro_jahr * zins_f

        # Steueranteil
        #-------------
        steuer_c = int(ertrag_float * self.Parobj.ErtragsSteuerAnteil + 0.5)
        gutschrift_c  = int(ertrag_float + 0.5) - steuer_c

        # Einzahlung Gutschrift
        #----------------------
        self.einzahlen(gutschrift_c,
                       aktDat_datetime,
                       "Zinsabrechnung",
                       zins_f)

        # irow setzen
        #------------
        self.IrowLetzteZinsAbrechnung = self.KontoDataSet.get_n_data()

        return steuer_c
    # end def



