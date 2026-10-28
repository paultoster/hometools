import os, sys

from hfkt_tvar import transform_icol_table

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
import konto_depot_class


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

    TYPE_STEUER_STORE_DATUM = "datStrP"
    TYPE_STEUER_STORE_AKTION = "str"
    TYPE_STEUER_STORE_WERT = "euroStrK"
    TYPE_STEUER_STORE_SUMME = "euroStrK"
    TYPE_STEUER_STORE_LISTE = [TYPE_STEUER_STORE_DATUM, TYPE_STEUER_STORE_AKTION, TYPE_STEUER_STORE_WERT, TYPE_STEUER_STORE_SUMME]

    NAME_KOSTEN_TAB_DATUM  = "Datum"
    NAME_KOSTEN_TAB_AKTION = "Aktion"
    NAME_KOSTEN_TAB_WERT   = "Wert"
    NAME_KOSTEN_TAB_SUMME  = "Summe"
    HEADER_KOSTEN_TAB_LISTE = [NAME_KOSTEN_TAB_DATUM,
                               NAME_KOSTEN_TAB_AKTION,
                               NAME_KOSTEN_TAB_WERT,
                               NAME_KOSTEN_TAB_SUMME]

    ICOL_KOSTEN_TAB_DATUM = HEADER_KOSTEN_TAB_LISTE.index(NAME_KOSTEN_TAB_DATUM)
    ICOL_KOSTEN_TAB_AKTION = HEADER_KOSTEN_TAB_LISTE.index(NAME_KOSTEN_TAB_AKTION)
    ICOL_KOSTEN_TAB_WERT = HEADER_KOSTEN_TAB_LISTE.index(NAME_KOSTEN_TAB_WERT)
    ICOL_KOSTEN_TAB_SUMME = HEADER_KOSTEN_TAB_LISTE.index(NAME_KOSTEN_TAB_SUMME)

    TYPE_KOSTEN_TAB_DATUM = "datetimeclass"
    TYPE_KOSTEN_TAB_AKTION = "str"
    TYPE_KOSTEN_TAB_WERT = "cent"
    TYPE_KOSTEN_TAB_SUMME = "cent"
    TYPE_KOSTEN_TAB_LISTE = [TYPE_KOSTEN_TAB_DATUM, TYPE_KOSTEN_TAB_AKTION, TYPE_KOSTEN_TAB_WERT, TYPE_KOSTEN_TAB_SUMME]

    TYPE_KOSTEN_STORE_DATUM = "datStrP"
    TYPE_KOSTEN_STORE_AKTION = "str"
    TYPE_KOSTEN_STORE_WERT = "euroStrK"
    TYPE_KOSTEN_STORE_SUMME = "euroStrK"
    TYPE_KOSTEN_STORE_LISTE = [TYPE_KOSTEN_STORE_DATUM, TYPE_KOSTEN_STORE_AKTION, TYPE_KOSTEN_STORE_WERT, TYPE_KOSTEN_STORE_SUMME]

    def __init__(self,parobj,dataobj) -> None:

        self.Parobj = parobj
        self.DataObj = dataobj

        # Verrechnungskonto anlegen
        #------------------
        self.KontoVerrechnung = konto_verrechnung_class.WPKontoVerrechnung(self.Parobj,"Cashkonto")

        # Zinskonto
        #----------
        self.KontoZins = konto_zins_class.WPKontoZins(self.Parobj,self.DataObj.AktZins_float,"Zinskonto")

        # Depotkonto
        #----------
        self.KontoDepot = konto_depot_class.WPKontoDepot(self.Parobj,self.DataObj,"Depotkonto")


        # Steuertabelle
        #--------------
        self.SteuerDataSet = hdset.DataSet("Steuertabelle")
        self.SteuerDataSet.set_definition_list(self.HEADER_STEUER_TAB_LISTE,
                                              self.TYPE_STEUER_TAB_LISTE,
                                              self.TYPE_STEUER_STORE_LISTE)
        self.SteuerDataSetSonderEintrag = False
        self.SteuerDataSetSonderEintragListe = []

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

        # Kostentabelle
        #--------------
        self.KostenDataSet = hdset.DataSet("Kostentabelle")
        self.KostenDataSet.set_definition_list(self.HEADER_KOSTEN_TAB_LISTE,
                                              self.TYPE_KOSTEN_TAB_LISTE,
                                              self.TYPE_KOSTEN_STORE_LISTE)
        self.KostenDataSetSonderEintrag = False
        self.KostenDataSetSonderEintragListe = []

        # Anfangswert setzen
        #-------------------
        data_set_liste = [self.Parobj.StartDat_datetime,
                          "Anfangswert", 0,0]
        status = self.KostenDataSet.add_data_set_liste(data_set_liste,
                                                       self.HEADER_KOSTEN_TAB_LISTE,
                                                       self.TYPE_KOSTEN_TAB_LISTE)

        if status != hdef.OKAY:
            self.Parobj.status = hdef.NOT_OKAY
            self.Parobj.errtext = self.KostenDataSet.get_errtext()
            self.KostenDataSet.reset_status()
            return
        # end if

        return
    # end def
    def GetSummeSteuer(self):
        return self.SteuerDataSet.get_data_item(self.SteuerDataSet.get_n_data() - 1,
                                                self.NAME_STEUER_TAB_SUMME)
    # end def
    def GetSummeKosten(self):

        return self.KostenDataSet.get_data_item(self.KostenDataSet.get_n_data() - 1,
                                                self.NAME_KOSTEN_TAB_SUMME)
    # end def
    def UpdateZinskontoEinzahlung(self):

        # Was auf dem Verrechnungskonto liegt wird auf das Zins konto eingezahlt
        cash_cent = self.KontoVerrechnung.GetSumme()
        if self.Parobj.status != hdef.OKAY:
            return

        if cash_cent > 0:

            tat_cash_cent = self.KontoVerrechnung.auszahlen(cash_cent,
                                                            self.DataObj.AktDat_datetime,
                                                            "Auszahlung an Zinskonto")
            if self.Parobj.status != hdef.OKAY:
                return

            _ = self.KontoZins.einzahlen(tat_cash_cent,
                                         self.DataObj.AktDat_datetime,
                                         "Einzahlung von Verrechnungskonto",
                                         self.DataObj.AktZins_float)
            if self.Parobj.status != hdef.OKAY:
                return

        return
    # end def
    def EntnahmeVollstaendig(self):
        """
        vollständige Entnahme aller Konten
        :return: summe_cash_cent,summe_steuer_cent,summe_kosten_cent
        """

        summe_cash_cent = 0
        summe_steuer_cent = 0
        summe_kosten_cent = 0

        # Depotverkaufen
        self.DepotVerkaufAnVerrechnung()

        # Mache eine Zinsabrechnung
        self.MacheZinsAbrechnung()


        # Zinskonto leeren
        self.EntnahmeZinsAnVerrechnung()

        # vollständige Entnahme
        summe_cash_cent = self.KontoVerrechnung.auszahlen(None,
                                                          self.DataObj.AktDat_datetime,
                                                          "vollständige Entnahme")


        # wieviel Steuer abgeführt
        summe_steuer_cent = self.GetSummeSteuer()

        # Kosten
        summe_kosten_cent = self.GetSummeKosten()

        return (summe_cash_cent, summe_steuer_cent, summe_kosten_cent)
    # end def
    def EntnahmeZinsAnVerrechnung(self, entnahme_cent=None):
        """
        Entnahme Zinskonto und auf VerrezchnunsKonto schieben
        :param entnahme_cent: wenn None , dann alles
        :return: self.EntnahmeZinsAnVerrechnung( entnahme_cent=None)
        """

        if entnahme_cent == None:
            entnahme_cent = self.KontoZins.GetSumme()
        # end if

        if entnahme_cent > 0:

            tat_entnahme_cent = self.KontoZins.auszahlen(entnahme_cent,
                                                     self.DataObj.AktDat_datetime,
                                                     "Entnahme für Verrechnungskonto",
                                                     self.DataObj.AktZins_float)

            if self.Parobj.status != hdef.OKAY:
                return

            _ = self.KontoVerrechnung.einzahlen(tat_entnahme_cent,
                                                self.DataObj.AktDat_datetime,
                                                "Einzahlung von Zinskonto")
        # end if

        return

    # end def
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

        # Sondereintrag, der wieder gelöscht wird
        if self.SteuerDataSetSonderEintrag:
            self.SteuerDataSetSonderEintragListe.append(self.SteuerDataSet.get_n_data() - 1)
        # end if

        return wert
    # end def
    def MacheEintragKosten(self,kosten_cent:int,aktion:str):

        # Prüfen
        # -------
        (okay, wert) = htype.type_proof(kosten_cent, self.TYPE_KOSTEN_TAB_WERT)
        if okay != hdef.OKAY:
            raise Exception(
                f"einzahlen: kosten_cent = {kosten_cent} kann nicht in type = {self.TYPE_KOSTEN_TAB_WERT} gewandelt werden")

        # summe bilden:
        # --------------
        if self.KostenDataSet.get_n_data() > 0:
            summe = self.KostenDataSet.get_data_item(self.KostenDataSet.get_n_data() - 1,
                                                     self.NAME_KOSTEN_TAB_SUMME)
            summe += wert
        else:
            summe = 0
        # end if
        data_set_liste = [self.DataObj.AktDat_datetime, aktion, wert, summe]

        status = self.KostenDataSet.add_data_set_liste(data_set_liste,
                                                       self.HEADER_KOSTEN_TAB_LISTE,
                                                       self.TYPE_KOSTEN_TAB_LISTE)

        if status != hdef.OKAY:
            self.Parobj.status = hdef.NOT_OKAY
            self.Parobj.errtext = self.KostenDataSet.get_errtext()
            self.KostenDataSet.reset_status()
            return wert
        # end if

        # Sondereintrag, der wieder gelöscht wird
        if self.KostenDataSetSonderEintrag:
            self.KostenDataSetSonderEintragListe.append(self.KostenDataSet.get_n_data() - 1)
        # end if

        return wert
    # end def
    def revidiereLetzteAktionKosten(self):
        """

        :return:
        """
        if self.KostenDataSet.get_n_data() > 0:

            status = self.KostenDataSet.delete_row_in_data_set(self.KostenDataSet.get_n_data() - 1)
            if status != hdef.OKAY:
                self.Parobj.status = hdef.NOT_OKAY
                self.Parobj.errtext = self.KostenDataSet.get_errtext()
                self.KostenDataSet.reset_status()
                return
            # end if

            # Sondereintrag, wieder löschen
        if self.KostenDataSetSonderEintrag and (len(self.KostenDataSetSonderEintragListe) > 0):
            del self.KostenDataSetSonderEintragListe[-1]
            # end if
        return
        # end def

    def SetzeSonderEintragFlag(self):
        self.SteuerDataSetSonderEintrag = True
        self.KostenDataSetSonderEintrag = True
        self.KontoVerrechnung.SetzeSonderEintragFlag()
        self.KontoZins.SetzeSonderEintragFlag()
        self.KontoDepot.SetzeSonderEintragFlag()
        return
    # end def
    def LoescheSonderEintrag(self):

        self.KontoVerrechnung.LoescheSonderEintrag()
        self.KontoZins.LoescheSonderEintrag()
        self.KontoDepot.LoescheSonderEintrag()

        if len(self.SteuerDataSetSonderEintragListe):

            liste = sorted(self.SteuerDataSetSonderEintragListe,reverse=True)

            flagLastPoints = True
            for irow in liste:
                if (irow+1) != self.SteuerDataSet.get_n_data() :
                    flagLastPoints = False
                # end if
                status = self.SteuerDataSet.delete_row_in_data_set(irow)
                if status != hdef.OKAY:
                    self.Parobj.status = hdef.NOT_OKAY
                    self.Parobj.errtext = self.SteuerDataSet.get_errtext()
                    self.SteuerDataSet.reset_status()
                    return
                # end if
            # end for

            # Summen neu Berechnen
            if not flagLastPoints:
                self.SteuerDataSet.recalc_summe_from_value(self.NAME_STEUER_TAB_SUMME,
                                                           self.NAME_STEUER_TAB_WERT)
            # end if
            self.SteuerDataSetSonderEintragListe = []
        # end if
        self.SteuerDataSetSonderEintrag = False
        return
    # end def
    def ErstelleSteuerTabelle(self):
        """

        :return: ttable
        """
        return self.SteuerDataSet.get_data_set_to_store_ttable()
    # end def
    def ErstelleTabelleKontoVerrechnung(self):
        """

        :return: ttable
        """

        ttable = self.KontoVerrechnung.ErstelleTabelle()

        return ttable
    # end def
    def ErstelleTabelleKontoZins(self):
        """

        :return: ttable
        """


        ttable = self.KontoZins.ErstelleTabelle()

        return ttable
    # end def
    def ErstelleTabelleKontoDepot(self,isin):
        """

        :param isin:
        :return: ttable
        """

        ttable = self.KontoDepot.ErstelleTabelle(isin)
        return ttable
    # end def
    def ErstelleTabelleKontoDepotTrace(self,isin):
        """
        Erstelle Ausgabe Tabelle von einem trace
        :param isin:
        :return: ttable
        """
        ttable = self.KontoDepot.ErstelleTraceTabelle(isin)
        return ttable

    # end def
    def bildeAktivesDepotISINListe(self):
        """
        :return: liste
        """
        return self.KontoDepot.bildeListeAktiveISINs()
    # end def
    def bildeGesamtDepotISINListe(self):
        """
        :return: liste
        """
        return self.KontoDepot.bildeListeGesamtISINs()
    # end def
    def getWPName(self,isin):
        return self.KontoDepot.getWPName(isin)
    # end if
    def bildeAnzahlAktivesDepotListe(self):
        """

        :return: n
        """
        return len(self.KontoDepot.bildeListeAktiveISINs())
    # end def
    def verkaufeAusDepot(self,isin,kurs,anzahl = None):
        """

        :param isin:
        :return: self.verkaufeAusDepot(isin,kurs,anzahl=None)
        """
        if anzahl is None:
            anzahl = self.KontoDepot.GetSumme(isin)
        else:
            anzahl = min(anzahl, self.KontoDepot.GetSumme(isin))
        # end if

        (gutschrift_c,steuer_c,kosten_c) = self.KontoDepot.verkaufe(isin,self.DataObj.AktDat_datetime,kurs,anzahl)

        # In Steuerliste eintragen
        #-------------------------
        if steuer_c > 0:
            self.MacheEintragSteuer(steuer_c,f"Depotverkauf {isin}: {anzahl} * {kurs:.3f} ")
        # end if

        # In Kostenliste eintragen
        #-------------------------
        if kosten_c > 0:
            self.MacheEintragKosten(kosten_c,f"Depotverkauf {isin}: {anzahl} * {kurs:.3f} ")
        # end if

        _ = self.KontoVerrechnung.einzahlen(gutschrift_c,
                                            self.DataObj.AktDat_datetime,
                                            f"Depotverkauf {isin}: {anzahl} * {kurs:.3f} ")

        return
    # end def
    def kaufeInDepotVonVerrechnung(self,isin,name,kurs,anzahl):
        """

        :param isin:
        :param kurs:
        :param anzahl:
        :return: (belastung_c,kosten_c) = self.kaufeInDepotVonVerrechnung(isin, kurs, anzahl)
        """

        # Prüfen, ob Verrechnungskonto genug hat
        (belastung_c, kosten_c) = self.KontoDepot.bestimmePreisUndKosten(kurs,anzahl)

        verrechnung_summe_c = self.KontoVerrechnung.GetSumme()

        if verrechnung_summe_c < belastung_c:

            return (False,None,None)
        # end if


        # Aktion durchführen
        (belastung_c, kosten_c) = self.KontoDepot.kaufe(isin, name,self.DataObj.AktDat_datetime, kurs, anzahl)

        # In verrechnungskonto eintragen
        # -------------------------------
        tat_belastung_c = self.KontoVerrechnung.auszahlen(belastung_c,
                                            self.DataObj.AktDat_datetime,
                                            f"Depotkauf {isin}: {anzahl} * {kurs:.3f} ")
        # In Kostenliste eintragen
        # -------------------------
        if kosten_c > 0:
            self.MacheEintragKosten(kosten_c, f"Depotkauf {isin}: {anzahl} * {kurs:.3f} ")
        # end if

        return (True,tat_belastung_c,kosten_c)
    # end def
    def revidiereKaufeInDepotVonVerrechnung(self,isin, kosten_c):
        """

        :param isin:
        :param kosten_c:
        :return:
        """

        self.KontoDepot.revidiereLetzteAktion(isin)

        self.KontoVerrechnung.revidiereLetzteAktion()

        if kosten_c > 0:
            self.revidiereLetzteAktionKosten()
        # end if

        return
    # end def
    def kaufeWPmitSumme(self,isin_kauf,name_kauf,kurs,anlage_summe_c):
        """
        :param isin_kauf:
        :param anlage_summe_c:
        :return:
        """

        verrechnung_summe_c = self.KontoVerrechnung.GetSumme()
        zins_summe_c        = self.KontoZins.GetSumme()

        (anzahl,umsatz_c) = self.KontoDepot.pruefeKauf(anlage_summe_c,kurs)

        if verrechnung_summe_c >= umsatz_c:  # nur aus Verrechnung

            pass
        elif (verrechnung_summe_c+zins_summe_c) >= umsatz_c:  # aus Zinskonto entnahmen

            zins_summe_c = umsatz_c - verrechnung_summe_c

            # Entnehme von Zinskonto
            self.EntnahmeZinsAnVerrechnung(zins_summe_c)
            zins_summe_c = 0

        else: # Verkauf von anderen Aktien

            # Entnehme von Zinskonto
            if zins_summe_c > 0:
                self.EntnahmeZinsAnVerrechnung(zins_summe_c)
                zins_summe_c = 0
            # end if

            verrechnung_summe_c = self.KontoVerrechnung.GetSumme()

            delta_summe_c = umsatz_c - verrechnung_summe_c

            isin_anzahl_dict = self.sucheWPsImDepotZumVerkauf(delta_summe_c,anlage_summe_c)

            for isin in isin_anzahl_dict.keys():

                self.verkaufeAusDepot(isin, self.DataObj.WPISINKursDict[isin], isin_anzahl_dict[isin])

                verrechnung_summe_c = self.KontoVerrechnung.GetSumme()

                if verrechnung_summe_c >= umsatz_c:
                    break
                # end if
            # end for
        # end if

        # Kauf des WP aus Verrechnung in Depot
        (_, _) = self.procedureKaufeInDepotVonVerrechnung(isin_kauf, name_kauf,kurs, anzahl)

        return
    # end def
    def procedureKaufeInDepotVonVerrechnung(self,isin,name,kurs,anzahl):
        """

        :param isin:
        :param name:
        :param kurs:
        :param anzahl:
        :return: (belastung_c,kosten_c) = self.procedureKaufeInDepotVonVerrechnung(isin,name,kurs,anzahl)
        """

        while True:
            (flag,belastung_c, kosten_c) = self.kaufeInDepotVonVerrechnung(isin,name, kurs, anzahl)
            if flag:
                break
            else:
                anzahl -= 1
                if anzahl == 0:
                    belastung_c = 0
                    kosten_c = 0
                    break
                # end if
            # end if
        # end while

        return  (belastung_c, kosten_c)
    # end def
    def DepotVerkaufAnVerrechnung(self):

        isin_liste = self.KontoDepot.GetListeISIN()

        for isin in isin_liste:
            if (self.KontoDepot.GetSummeAnzahlISIN(isin) > 0) and (isin in self.DataObj.WPISINKursDict.keys()):
                self.verkaufeAusDepot(isin, self.DataObj.WPISINKursDict[isin])
            # end if
        # end for
        return
    # end def
    def sucheWPsImDepotZumVerkauf(self, delta_summe_c,anlage_summe_c):
        """

        :param delta_summe_c:
        :return: isin_anzahl_dict = self.sucheWPsImDepotZumVerkauf(delta_summe_c)
        """

        isin_liste = self.KontoDepot.GetListeISIN()

        isin_delta_c_dict = {}
        isin_max_anzahl_dict = {}
        summe_wps_delta_c = 0
        for isin in isin_liste:
            if (self.KontoDepot.GetSummeAnzahlISIN(isin) > 0) and (isin in self.DataObj.WPISINKursDict.keys()):

                kurs = self.DataObj.WPISINKursDict[isin]
                (anzahl, gesamtwert_c) = self.KontoDepot.pruefeWert(isin,kurs)
                isin_max_anzahl_dict[isin] = anzahl

                # Wenn der Gesamtwert über dem Anlageanteil liegt
                if gesamtwert_c > anlage_summe_c:

                    # dann soll die Differenz verwendet werden
                    delta_c = gesamtwert_c - anlage_summe_c

                    isin_delta_c_dict[isin]  = delta_c
                    summe_wps_delta_c += delta_c
                # end if
            # end if
        # end for

        # Wenn die Summe zu groß, dann wird verteilt reduziert
        if summe_wps_delta_c > delta_summe_c:


            # Verteilungsfaktor
            fac = float(delta_summe_c)/float(summe_wps_delta_c)
            isin_delta_c_dict_neu = {}
            for isin in isin_delta_c_dict.keys():

                delta_c = int(float(isin_delta_c_dict[isin]) * fac + 0.5)
                isin_delta_c_dict_neu[isin] = delta_c
            # end if
            summe_neu_c = 0
            for isin in isin_delta_c_dict_neu:
                summe_neu_c += isin_delta_c_dict_neu[isin]
            # end if

            # Wenn dann die Summe zu kleine wird Euro-Weise addiert
            max_loops = max(0,delta_summe_c-summe_neu_c)/len(isin_delta_c_dict_neu.keys())
            i_loop = 0
            while summe_neu_c < delta_summe_c:
                summe_neu_c = 0
                for isin in isin_delta_c_dict_neu:
                    isin_delta_c_dict_neu[isin] = min(isin_delta_c_dict[isin],isin_delta_c_dict_neu[isin] + 100)
                    summe_neu_c += isin_delta_c_dict_neu[isin]
                # end if
                i_loop += 1
                if i_loop > max_loops:
                    break
                # end if
            # end while
            isin_delta_c_dict = isin_delta_c_dict_neu
        # end if

        # Für die verbleibenden Überschüsse wird die anzahl bestimmt
        isin_anzahl_dict = {}
        for isin in isin_delta_c_dict.keys():

            kurs = self.DataObj.WPISINKursDict[isin]

            anzahl = int(float(isin_delta_c_dict[isin])/100./kurs)

            (anzahl, teil_gutschrift_c) = self.KontoDepot.pruefeWert(isin, kurs, anzahl)

            while teil_gutschrift_c <= isin_delta_c_dict[isin]:
                anzahl += 1
                (anzahl, teil_gutschrift_c) = self.KontoDepot.pruefeWert(isin, kurs, anzahl)
            #end while

            isin_anzahl_dict[isin] = anzahl
        # end for

        return isin_anzahl_dict
    # end def
    def bildeDepotTraceTabelle(self):

        self.KontoDepot.berechneTrace()

        return
    # end def
    def getListeRelVKDepot(self,isin):
        return self.KontoDepot.getListeRelVK(isin)
    # end de
    def getListeRelVMaxDepot(self,isin):
        return self.KontoDepot.getListeRelVMax(isin)
    # end de
    def getDatumKursVerlauf(self,isin):
        return self.KontoDepot.getDatumKursVerlauf(isin)
    def getKursVerlauf(self,isin):
        return self.KontoDepot.getKursVerlauf(isin)
    def getRohKursVerlauf(self,isin):
        return self.KontoDepot.getKursVerlauf(isin)

# end class
