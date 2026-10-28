import os, sys
import datetime

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_tvar as htvar
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


    NAME_DATUMK      = "DatumK"
    NAME_DATUMV      = "DatumV"
    NAME_ANZAHL      = "Anzahl"
    NAME_KURSK       = "KursK"
    NAME_KURSV       = "KursV"
    NAME_KURSMAX     = "KursMax"
    NAME_KURSMIN     = "KursMin"
    NAME_RELVK       = "RelVK"
    NAME_RELVMAX     = "RelVMax"
    HEADER_TRACE_LISTE = [NAME_DATUMK, NAME_DATUMV,NAME_ANZAHL, NAME_KURSK,NAME_KURSV, NAME_KURSMAX,NAME_KURSMIN,NAME_RELVK,NAME_RELVMAX]

    TYPE_DATUMK      = "datetimeclass"
    TYPE_DATUMV      = "datetimeclass"
    TYPE_ANZAHL      = "int"
    TYPE_KURSK       = "float"
    TYPE_KURSV       = "float"
    TYPE_KURSMAX     = "float"
    TYPE_KURSMIN     = "float"
    TYPE_RELVK       = "float"
    TYPE_RELVMAX     = "float"
    TYPE_TRACE_LISTE = [TYPE_DATUMK, TYPE_DATUMV, TYPE_ANZAHL, TYPE_KURSK,TYPE_KURSV, TYPE_KURSMAX,TYPE_KURSMIN,TYPE_RELVK,TYPE_RELVMAX]

    TYPE_STORE_DATUMK      = "datStrP"
    TYPE_STORE_DATUMV      = "datStrP"
    TYPE_STORE_ANZAHL      = "int"
    TYPE_STORE_KURSK       = "euroStrK"
    TYPE_STORE_KURSV       = "euroStrK"
    TYPE_STORE_KURSMAX     = "euroStrK"
    TYPE_STORE_KURSMIN     = "euroStrK"
    TYPE_STORE_RELVK       = "percentStr"
    TYPE_STORE_RELVMAX     = "percentStr"
    TYPE_STORE_TRACE_LISTE = [TYPE_STORE_DATUMK, TYPE_STORE_DATUMV, TYPE_STORE_ANZAHL,TYPE_STORE_KURSK,TYPE_STORE_KURSV, TYPE_STORE_KURSMAX,TYPE_STORE_KURSMIN,TYPE_STORE_RELVK,TYPE_STORE_RELVMAX]


    def __init__(self,parobj,datobj,name) -> None:

        self.Parobj = parobj
        self.Dataobj = datobj
        self.Name = name

        # Depotdict isin bezogen anlegen
        #--------------------------------
        self.DepotDict = {}
        self.DepotTraceDict = {}
        self.WPNameDict = {}

        self.KontoDataSetSonderEintrag = False

        return
    # end def
    def EroeffneDepot(self,isin,name):

        dataset = hdset.DataSetKonto(isin)
        dataset.set_definition_list(self.HEADER_LISTE, self.TYPE_LISTE, self.TYPE_STORE_LISTE)

        # Anfangswert setzen
        #-------------------
        data_set_liste = [self.Parobj.StartDat_datetime, "Anfangswert",0.0, 0,0]
        status = dataset.add_data_set_liste(data_set_liste, self.HEADER_LISTE, self.TYPE_LISTE)

        if status != hdef.OKAY:
            self.Parobj.status = hdef.NOT_OKAY
            self.Parobj.errtext = dataset.get_errtext()
            dataset.reset_status()
            return
        # end if

        # Namen des WP
        self.WPNameDict[isin] = name


        # Trace Datei anlegen
        datasettrace = hdset.DataSetKonto(f"{isin}_trace")
        datasettrace.set_definition_list(self.HEADER_TRACE_LISTE, self.TYPE_TRACE_LISTE, self.TYPE_STORE_TRACE_LISTE)
        self.DepotTraceDict[isin] = datasettrace

        return dataset
    # end def
    def pruefeKauf(self,anlage_summe_c,kurs):
        """
         Berechnet anzahl und Gesamtkosten
        :param anlage_summe_c:
        :param kurs:
        :return: (anzahl,umsatz_c) = self.KontoDepot.pruefeKauf(anlage_summe_c,kurs)
        """

        anzahl =  int(anlage_summe_c/(kurs*100.))
        kaufwert_c = int(anzahl * kurs * 100. + 0.5)

        kosten_c = self.berechneKosten(kaufwert_c)

        umsatz_c = kaufwert_c+kosten_c
        return (anzahl,umsatz_c)
    # end def
    def kaufe(self,isin:str,name:str,aktdat_datetime,kurs_euro:float,anzahl:int):
        """
          WP in das Depot legen
        :param isin:
        :param anzahl:
        :param kurs_euro:
        :return: (belastung_c, kosten_c) = self.KontoDepot.kaufe(isin, aktdat_datetime, kurs_euro,anzahl)
        """

        aktion = "Kaufen"

        if isin not in self.DepotDict.keys():
            self.DepotDict[isin] = self.EroeffneDepot(isin,name)
        # end if

        anzahl = abs(anzahl)

        # summe bilden:
        #--------------
        if self.DepotDict[isin].get_n_data() > 0:
            summe = self.DepotDict[isin].get_data_item(self.DepotDict[isin].get_n_data()-1,self.NAME_SUMMEANZAHL)
        else:
            summe = 0
        # end if


        # summe bilden:
        #--------------
        summe += anzahl

        data_set_liste = [aktdat_datetime,aktion,kurs_euro,anzahl,summe]

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

        # Umsatz
        # ======
        (belastung_c, kosten_c) = self.bestimmePreisUndKosten(kurs_euro, anzahl)

        return (belastung_c,kosten_c)

        return anzahl
    # end def
    def bestimmePreisUndKosten(self,kurs_euro,anzahl):
        """

        :param kurs_euro:
        :param anzahl:
        :return: (belastung_c, kosten_c) = self.bestimmePreisUndKosten(kurs_euro, anzahl)
        """
        umsatz_c_float = anzahl * kurs_euro * 100.

        # Steueranteil, Kosten Gutschrift
        # --------------------------------
        kosten_c = self.berechneKosten(umsatz_c_float)
        belastung_c = int(umsatz_c_float + 0.5) + kosten_c
        return (belastung_c, kosten_c)
    # end def
    def pruefeWert(self,isin, kurs_euro,anzahl = None):
        """

        :param isin:
        :param kurs_euro:
        :return: (anzahl, gutschrift_c) = self.KontoDepot.pruefeWert(isin,kurs,anzahl=None)
        """

        if isin in self.DepotDict.keys():

            if anzahl is None:

                if self.DepotDict[isin].get_n_data() > 0:
                    anzahl = self.DepotDict[isin].get_data_item(self.DepotDict[isin].get_n_data() - 1,
                                                               self.NAME_SUMMEANZAHL)
                else:
                    anzahl = 0
                # end if
            # end if
            anzahl = abs(anzahl)

            # Umsatz,Ertrag
            # =============
            umsatz_c_float = anzahl * kurs_euro * 100.
            ertrag_c_float = self.berechneErtrag(isin,umsatz_c_float,anzahl)

            # Steueranteil, Kosten Gutschrift
            # --------------------------------
            steuer_c = max(0,int(ertrag_c_float * self.Parobj.ErtragsSteuerAnteil + 0.5))
            kosten_c = self.berechneKosten(umsatz_c_float)
            gutschrift_c = int(umsatz_c_float + 0.5) - steuer_c - kosten_c
        else:
            anzahl = 0
            gutschrift_c = 0
        # end if
        return (anzahl, gutschrift_c)
    # end def
    def verkaufe(self,isin,aktdat_datetime,kurs_euro,anzahl):
        """
         Auszahlen cash_sent

        :param cash_cent:
        :param aktdat_datetime:
        :param aktion:
        :return: (gutschrift_c,steuer_c,kosten_c) = self.verkaufe(isin,aktdat_datetime,kurs,anzahl)
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


        # Umsatz,Ertrag (vor dem Eintrag in die Tabelle berechnen)
        # =======================================================
        umsatz_c_float = anzahl * kurs_euro * 100.
        ertrag_c_float = self.berechneErtrag(isin,umsatz_c_float,anzahl)

        # Steueranteil, Kosten Gutschrift
        # --------------------------------
        steuer_c = max(0,int(ertrag_c_float * self.Parobj.ErtragsSteuerAnteil + 0.5))
        kosten_c = self.berechneKosten(umsatz_c_float)
        gutschrift_c = int(umsatz_c_float + 0.5) - steuer_c - kosten_c



        # Eintrag in Tabelle
        #-------------------
        data_set_liste = [aktdat_datetime,aktion,kurs_euro,-anzahl,summe]

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


        return (gutschrift_c,steuer_c,kosten_c)
    # end def
    def revidiereLetzteAktion(self,isin):
        """

        :return: self.KontoDepot.revidiereLetzteAktion(isin)
        """

        if self.DepotDict[isin].get_n_data() > 0:

            status = self.DepotDict[isin].delete_row_in_data_set(self.DepotDict[isin].get_n_data()-1)
            if status != hdef.OKAY:
                self.Parobj.status = hdef.NOT_OKAY
                self.Parobj.errtext = self.DepotDict[isin].get_errtext()
                self.DepotDict[isin].reset_status()
                return
            # end if

        # Sondereintrag, wieder löschen
        if self.KontoDataSetSonderEintrag:
            self.DepotDict[isin].revidiere_sondereintrag()
        # end if
        return
    # end def
    def GetSumme(self,isin):
        if isin in self.DepotDict.keys():
            summe = self.DepotDict[isin].get_data_item(self.DepotDict[isin].get_n_data() - 1, self.NAME_SUMMEANZAHL)
        else:
            summe = 0
        # end if
        return summe
    # end def
    def SetzeSonderEintragFlag(self):
        self.KontoDataSetSonderEintrag = True
        return
    # end def
    def LoescheSonderEintrag(self):

        for isin in self.DepotDict.keys():
            self.DepotDict[isin].loesche_sondereintrag(wert=self.NAME_ANZAHL, summe=self.NAME_SUMMEANZAHL)
        self.KontoDataSetSonderEintrag = False
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
    def ErstelleTraceTabelle(self,isin):
        """

        :param isin:
        :return: ttable
        """
        if isin not in self.DepotTraceDict.keys():
            raise Exception(
                f"ErstelleTabelle: isin = {isin} kann nicht im depot zum Tabellenerstellen gefunden werden")
        # end if
        return self.DepotTraceDict[isin].get_data_set_to_store_ttable()
    # end def
    def GetListeISIN(self):
        return list(self.DepotDict.keys())
    # end def
    def ExistISIN(self,isin):
        return isin in self.DepotDict.keys()
    def GetSummeAnzahlISIN(self,isin):

        if not self.ExistISIN(isin):
            raise Exception(
                f"GetSummeAnzahlISIN: isin = {isin} kann nicht im depot gefunden werden")
        # end if
        return self.GetSumme(isin)
    def bildeListeGesamtISINs(self):

        liste = [isin for isin in self.DepotDict.keys()]
        return liste
    # end def
    def getWPName(self,isin):
        if isin in self.WPNameDict.keys():
            return self.WPNameDict[isin]
        else:
            return "NoName"
        # end if
    # end def
    def bildeListeAktiveISINs(self):

        liste = [isin for isin in self.DepotDict.keys() if self.GetSummeAnzahlISIN(isin) > 0 ]
        return liste
    # end def
    def berechneErtrag(self,isin,umsatz_c_float,umsatz_anteile):
        """

        :param anzahl:
        :param kurs_euro:
        :return: ertrag_c_float
        """
        # verkaufte_anteile = self.DepotDict[isin].get_data_item(self.DepotDict[isin].get_n_data()-1,self.NAME_ANZAHL)
        # verkaufte_anteile = abs(verkaufte_anteile)

        # Gehe soweit zurück bis Summe null ist
        #--------------------------------------
        index = 0
        for i in reversed(range(self.DepotDict[isin].get_n_data())):

            summe = self.DepotDict[isin].get_data_item(i,self.NAME_SUMMEANZAHL)

            if summe == 0:
                index = i
                break
            # end if
        # end for

        # gehe von index soweit vor bis die anteil des Kaufens zusammen sind
        #-------------------------------------------------------------------
        kauf_summe_c_float = 0.0
        summe_anteile = abs(umsatz_anteile)
        for i in range(index+1,self.DepotDict[isin].get_n_data()):

            anteile = self.DepotDict[isin].get_data_item(i,self.NAME_ANZAHL)
            kurs    = self.DepotDict[isin].get_data_item(i,self.NAME_KURS)

            if anteile > 0:

                if summe_anteile > anteile:
                    kauf_summe_c_float += kurs * anteile * 100.
                    summe_anteile -= anteile
                else:
                    kauf_summe_c_float += kurs * summe_anteile * 100.
                    summe_anteile = 0
                    break
                # end if
            # end if
        # end for

        return umsatz_c_float - kauf_summe_c_float
    # end def
    def berechneKosten(self,umsatz_c_float):


        kosten_c = int(self.Parobj.WPKostenFest_cent + min(umsatz_c_float * self.Parobj.WPKostenAnteil,self.Parobj.WPKostenMax_cent) + 0.5)

        return kosten_c
    # end def
    def berechneTrace(self,isin=None):
        """

        :param isin:
        :return:
        """
        if isin is None:
            isin_liste = self.DepotDict.keys()
        else:
            isin_liste = [isin]
        # end if

        for isin in isin_liste:

            list_dat_datetime = self.DepotDict[isin].get_row_list_of_header(self.NAME_DATUM)
            list_anzahl       = self.DepotDict[isin].get_row_list_of_header(self.NAME_ANZAHL)
            list_kurs         = self.DepotDict[isin].get_row_list_of_header(self.NAME_KURS)


            nloopmax = len(list_anzahl)*3
            iloop = 0
            while sum([abs(a) for a in list_anzahl]) > 0:

                iloop += 1
                if iloop >= nloopmax:
                    raise Exception("nloopmax erreicht")
                # end if

                istart = -1
                iend = -1
                for i in range(len(list_anzahl)):

                    if list_anzahl[i] > 0:   # Kauf eines WP

                        istart = i
                        anzahlstart = list_anzahl[i]
                        break
                    # end if
                # end for
                if istart >= 0:

                    for i in range(istart,len(list_anzahl)):

                        # verkauf
                        if list_anzahl[i] < 0:

                            iend = i
                            anzahlend = abs(list_anzahl[i])
                            break
                        # end if
                    # end for
                # end if

                if iend >= 0:

                    # Wieviele Aktien bei dem Trace
                    anzahl = min(anzahlstart,anzahlend)

                    kaufdat_datetime = list_dat_datetime[istart]
                    verkaufdat_datetime = list_dat_datetime[iend]

                    kurskauf = list_kurs[istart]
                    kursverkauf = list_kurs[iend]

                    # Anzahl austragen
                    list_anzahl[istart] -= anzahl
                    if list_anzahl[istart] < 0:
                        raise Exception("Anzahl darf nicht negativ werden")

                    list_anzahl[iend]   += anzahl

                    if list_anzahl[iend] > 0:
                        raise Exception("Anzahl darf nicht positiv werden")


                    # KursMaximum und Minumum bestimmen
                    (kursmin, kursmax) =  self.Dataobj.getMinMaxFromWP(isin, kaufdat_datetime, verkaufdat_datetime)

                    relVK =   kursverkauf/max(0.0001,kurskauf)
                    relVMax = (kursverkauf-kurskauf)/max(0.0001,(kursmax - kurskauf))

                    data_set_liste = [kaufdat_datetime,
                                     verkaufdat_datetime,
                                     anzahl,
                                     kurskauf,
                                     kursverkauf,
                                     kursmax,
                                     kursmin,
                                     relVK,
                                     relVMax]

                    self.DepotTraceDict[isin].add_data_set_liste(data_set_liste,
                                                                 self.HEADER_TRACE_LISTE,
                                                                 self.TYPE_TRACE_LISTE)

                # end if
            # end while
        # end for
        return
    # end def
    def getListeRelVK(self,isin):
        liste = self.DepotTraceDict[isin].get_row_list_of_header(self.NAME_RELVK)
        return liste
    # end def
    def getListeRelVMax(self, isin):
        liste = self.DepotTraceDict[isin].get_row_list_of_header(self.NAME_RELVMAX)
        return liste
    # end def
    def getDatumKursVerlauf(self,isin):
        return self.Dataobj.getDatumKursVerlauf(isin, self.Parobj.StartDat_datetime, self.Parobj.EndDat_datetime)
    def getKursVerlauf(self,isin):
        return self.Dataobj.getKursVerlauf(isin, self.Parobj.StartDat_datetime, self.Parobj.EndDat_datetime)
    def getRohKursVerlauf(self,isin):
        return self.Dataobj.getRohKursVerlauf(isin, self.Parobj.StartDat_datetime, self.Parobj.EndDat_datetime)

# end class