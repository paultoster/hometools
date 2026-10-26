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

class WPKontoDepot:
    """

    """
    NAME_DATUM       = "Datum"
    NAME_AKTION      = "Aktion"
    NAME_KURS        = "Kurs"
    NAME_ANZAHL      = "Anzahl"
    NAME_SUMMEANZAHL = "SummeAnzahl"
    HEADER_LISTE = [NAME_DATUM, NAME_AKTION, NAME_KURS,NAME_ANZAHL, NAME_SUMMEANZAHL]

    ICOL_DATUM = HEADER_LISTE.index(NAME_DATUM)
    ICOL_AKTION = HEADER_LISTE.index(NAME_AKTION)
    ICOL_KURS = HEADER_LISTE.index(NAME_KURS)
    ICOL_ANZAHL = HEADER_LISTE.index(NAME_ANZAHL)
    ICOL_SUMMEANZAHL = HEADER_LISTE.index(NAME_SUMMEANZAHL)

    TYPE_DATUM = "datetimeclass"
    TYPE_AKTION = "str"
    TYPE_KURS = "float"
    TYPE_ANZAHL = "int"
    TYPE_SUMMEANZAHL = "int"
    TYPE_LISTE = [TYPE_DATUM, TYPE_AKTION, TYPE_KURS, TYPE_ANZAHL,TYPE_SUMMEANZAHL]

    TYPE_STORE_DATUM = "datStrP"
    TYPE_STORE_AKTION = "str"
    TYPE_STORE_KURS = "euroStrK"
    TYPE_STORE_ANZAHL = "int"
    TYPE_STORE_SUMMEANZAHL = "int"
    TYPE_STORE_LISTE = [TYPE_STORE_DATUM, TYPE_STORE_AKTION, TYPE_STORE_KURS,TYPE_STORE_ANZAHL, TYPE_STORE_SUMMEANZAHL]

    def __init__(self,parobj,name) -> None:

        self.Parobj = parobj
        self.Name = name

        # Depotdict isin bezogen anlegen
        #--------------------------------
        self.DepotDict = {}

        self.KontoDataSetSonderEintrag = False

        return
    # end def
    def EroeffneDepot(self,isin):
        dataset = hdset.DataSetKonto(isin)
        dataset.set_definition_list(self.HEADER_LISTE, self.TYPE_LISTE, self.TYPE_STORE_LISTE)

        return dataset
    # end def
    def Kaufen(self,isin:str,anzahl:int,aktdat_datetime,kurs:float):
        """
          WP in das Depot legen
        :param isin:
        :param anzahl:
        :param kurs:
        :return: anzahl
        """

        aktion = "Kaufen"

        if isin not in self.DepotDict.keys():
            self.DepotDict[isin] = self.EroeffneDepot(isin)
        # end if

        # summe bilden:
        #--------------
        if self.DepotDict[isin].get_n_data() > 0:
            summe = self.DepotDict[isin].get_data_item(self.DepotDict[isin].get_n_data()-1,self.NAME_SUMMEANZAHL)
            summe += anzahl
        else:
            summe = 0
        # end if
        data_set_liste = [aktdat_datetime,aktion,kurs,anzahl,summe]

        status = self.DepotDict[isin].add_data_set_liste(data_set_liste,self.HEADER_LISTE, self.TYPE_LISTE)

        if status != hdef.OKAY:
            self.Parobj.status = hdef.NOT_OKAY
            self.Parobj.errtext = self.DepotDict[isin].get_errtext()
            self.DepotDict[isin].reset_status()
            return 0
        # end if

        # Sondereintrag, der wieder gelöscht wird
        if self.KontoDataSetSonderEintrag:
            self.DepotDict[isin].mache_sondereintrag()
        # end if

        return anzahl
    # end def
    def Verkaufen(self,isin,anzahl,aktdat_datetime):
        """
         Auszahlen cash_sent

        :param cash_cent:
        :param aktdat_datetime:
        :param aktion:
        :return: tat_cash_cent = self.auszahlen(cash_cent,aktdat_datetime,aktion)
        """

        if isin not in self.DepotDict.keys():
            raise Exception(
                f"Verkaufen: isin = {isin} kann nicht im depot zum Verkauf gefunden werden")
        # end if
        aktion = "Verkaufen"

        anzahl = abs(anzahl)

        if self.DepotDict[isin].get_n_data() > 0:
            summe = self.GetSumme(isin)
        else:
            summe = 0
        # end if


        if anzahl > summe:
            anzahl = summe
        # end if

        # summe bilden:
        #--------------
        summe -= anzahl

        data_set_liste = [aktdat_datetime,aktion,-anzahl,summe]

        status = self.DepotDict[isin].add_data_set_liste(data_set_liste,self.HEADER_LISTE, self.TYPE_LISTE)

        if status != hdef.OKAY:
            self.Parobj.status = hdef.NOT_OKAY
            self.Parobj.errtext = self.DepotDict[isin].get_errtext()
            self.DepotDict[isin].reset_status()
            return 0
        # end if

        # Sondereintrag, der wieder gelöscht wird
        if self.KontoDataSetSonderEintrag:
            self.DepotDict[isin].mache_sondereintrag()
        # end if

        return anzahl
    # end def
    def GetSumme(self,isin):
        summe = self.DepotDict[isin].get_data_item(self.DepotDict[isin].get_n_data() - 1, self.NAME_SUMMEANZAHL)
        return summe
    # end def
    def SetzeSonderEintragFlag(self):
        self.KontoDataSetSonderEintrag = True
        return
    # end def
    def LoescheSonderEintrag(self):

        for isin in self.DepotDict.keys():
            self.DepotDict[isin].loesche_sondereintrag(wert=self.NAME_ANZAHL, summe=self.NAME_SUMMEANZAHL)

        return
    # end def
    def ErstelleTabelle(self,isin):
        """

        :return: ttable
        """
        if isin not in self.DepotDict.keys():
            raise Exception(
                f"ErstelleTabelle: isin = {isin} kann nicht im depot zum Tabellenerstellen gefunden werden")
        # end if
        return self.DepotDict[isin].get_data_set_to_store_ttable()
    # end def
    def GetListeISIN(self):
        return list(self.DepotDict.keys())
    # end def
    def ExistISIN(self,isin):
        return isin in self.DepotDict.keys()
    def GetAnzahlISIN(self,isin):

        if not self.ExistISIN(isin):
            raise Exception(
                f"GetAnzahlISIN: isin = {isin} kann nicht im depot gefunden werden")
        # end if
        return self.GetSumme(isin)
# end class