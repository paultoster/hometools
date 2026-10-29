import os, sys, copy

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
# import tools.hfkt_log as hlog
import tools.hfkt_list as hlist
# import tools.hfkt_np_calc as hnpcalc


class WPPruef:
    """

    """
    def __init__(self,
                 wpscrefunc,
                 parobj,
                 dataobj,
                 kontoobj) -> None:

        # referenz
        #---------
        self.WPscrefunc = wpscrefunc
        self.Parobj = parobj
        self.DataObj = dataobj
        self.KontoObj = kontoobj

        self.WPObjListe = []
        self.WPObjLooserListe = []

        return
    def update(self):

        if self.Parobj.DepotKontoPruefung:

            self.pruefe_verkauf()
            if self.Parobj.status != hdef.OKAY:
                return
            # end if

            self.pruefe_verbleib()
            if self.Parobj.status != hdef.OKAY:
                return
            # end if

            if self.Parobj.WPTriggerVerkauf == "Vsig+Rank":

                self.pruefe_verkauf_wegen_ranking()
                if self.Parobj.status != hdef.OKAY:
                    return
                # end if
            # end if

            self.pruefe_kauf()
            if self.Parobj.status != hdef.OKAY:
                return
            # end if

            # end if
        # end if

        # Soll alles Cash in Zins steckenen
        if self.Parobj.ZinsKontoPruefung:
            self.KontoObj.UpdateZinskontoEinzahlung()
            if self.Parobj.status != hdef.OKAY:
                return
            # end if
        # end if
        return
    # end def
    def pruefe_verkauf(self):
        """
        Prüft anhand der WPScreDictList, ob verkauft werden soll
        :return:
        """

        liste_isin_im_depot = self.KontoObj.bildeAktivesDepotISINListe()

        verkaufs_index_liste = self.DataObj.WPScreDictListObj.get_obj_items_eq("ISIN", liste_isin_im_depot).get_index_list_items_gt("VERKAUFEN",0)

        # Verkaufen und aus liste löschen
        for index in reversed(verkaufs_index_liste):

            self.KontoObj.verkaufeAusDepot(self.DataObj.WPScreDictListObj.get_value(index,"ISIN"),
                                           self.DataObj.WPScreDictListObj.get_value(index,"KURS"),
                                           anzahl = None)
            if self.Parobj.status != hdef.OKAY:
                return
            self.DataObj.WPScreDictListObj.erase_dict_by_index(index)

        # end for

        return
    # end def
    def pruefe_verbleib(self):
        """
        Prüft anhand der WPScreDictList, was bleiben soll
        :return:
        """

        liste_isin_im_depot = self.KontoObj.bildeAktivesDepotISINListe()
        gruppen_liste = list(self.Parobj.ScreKat.keys())
        depot_gruppen_isin_dict = {}
        depot_gruppen_anzahl_dict = {}
        # Die Depot isin Depot Gruppen-Dict merken
        for grup in gruppen_liste:
            depot_gruppen_isin_dict[grup] = []
            depot_gruppen_anzahl_dict[grup] = 0
            for isin in liste_isin_im_depot:
                if isin in self.Parobj.ScreKat[grup]:
                    depot_gruppen_isin_dict[grup].append(isin)
                    depot_gruppen_anzahl_dict[grup] += 1
                # end if
            # end for
        # end for

        wpObj = copy.copy(self.DataObj.WPScreDictListObj)

        # Add Gruppe zu WPScreDictListObj
        wpObj.add_item_to_dict("GRUPPE", "")
        for grup in gruppen_liste:
            wpObj.set_item_to_dict("GRUPPE", grup, "ISIN", depot_gruppen_isin_dict[grup])
        # # end for

        # die vom Depot mit "IMDEPOT" kennzeichnen (für Verkauf)
        wpObj.add_item_to_dict("IMDEPOT", False)
        wpObj.set_item_to_dict("IMDEPOT", True, "ISIN", liste_isin_im_depot)

        # werfe alle nicht kaufen raus die nicht im Depot sind
        index_liste = wpObj.get_index_list_items_eq("KAUFEN", 0, "IMDEPOT", False)
        wpObj.erase_dict_by_index(index_liste)

        # Aufteilen in die Gruppen
        WPObj_liste = [wpObj.get_obj_items_eq("ISIN", self.Parobj.ScreKat[grup]) for grup in gruppen_liste]

        # Sortieren nach RANKING kleinster nach vorne
        WPObj_liste = self.sort_WPObj_liste_by_ranking(WPObj_liste)

        # Gruppenaufteilung
        # jetz muss geschaut werden, wieviele in der jeweiligen Gruppe investiert sind, da smuss von NAuswahlWPGruppe abgezogen werden
        # d.h. Aufteilen
        (WPObj_liste,WPObj_looser_liste) = self.gruppen_begrenzungs_aufteilung(WPObj_liste,self.Parobj.NAuswahlWPGruppe)


        # Aufteilung innerhalb der Gruppe
        (WPObj_liste,WPObj_looser_liste) = self.in_gruppen_begrenzungs_aufteilung(WPObj_liste,WPObj_looser_liste,self.Parobj.NAuswahlWP)


        if self.Parobj.WPTriggerVerkauf == "Vsig":  # nur nach Verkaufssignal verkaufen

            # Deswegen alle gekauft wieder raus (nach sortieren)
            # begrenze jede Gruppe
            for i in range(len(WPObj_liste)):
                WPObj_liste[i].erase_dict_by_value("IMDEPOT", True)
            # end for
            for i in range(len(WPObj_looser_liste)):
                WPObj_looser_liste[i].erase_dict_by_value("IMDEPOT", True)
            # end for
        # endif


        self.WPObjListe = WPObj_liste
        self.WPObjLooserListe = WPObj_looser_liste

        return

    # end def
    def pruefe_verkauf_wegen_ranking(self):

        for wpobj in self.WPObjLooserListe:
            index_liste = wpobj.get_index_list_items_eq("IMDEPOT", True)
            for index in index_liste:
                ddict = wpobj.get_dict(index)

                self.KontoObj.verkaufeAusDepot(ddict["ISIN"], ddict["KURS"], anzahl=None)
                if self.Parobj.status != hdef.OKAY:
                    return
                # end if
            # end for
        # end for
        return

    # end def
    def pruefe_kauf(self):

        # Theoretisches Guthaben für Anlegesumme bestimmen
        self.KontoObj.SetzeSonderEintragFlag()

        (summe_cash_cent, _, _) = self.KontoObj.EntnahmeVollstaendig()

        self.KontoObj.LoescheSonderEintrag()

        anlage_summe_c = int(summe_cash_cent * self.DataObj.AnteilDepotAufteilung + 0.5)

        # WPObjListe Liste durchgehen und die noch nicht gekauften kaufen
        for wpobj in self.WPObjListe:

            index_liste = wpobj.get_index_list_items_eq("IMDEPOT", False)

            for index in index_liste:
                self.KontoObj.kaufeWPmitSumme(wpobj.get_value(index, "ISIN"),
                                              wpobj.get_value(index, "NAME"),
                                              wpobj.get_value(index, "KURS"),
                                              anlage_summe_c)
            # end for
        # end for
        return

    # end def
    def sort_WPObj_liste_by_ranking(self,WPObj_liste):

        # Sortieren nach RANKING kleinster nach vorne
        lliste = []
        for i in range(len(WPObj_liste)):
            WPObj_liste[i].sor_by_item("RANKING")
            lliste.append([i, WPObj_liste[i].get_value(0, "RANKING")])
        # end for
        lliste = hlist.sort_list_of_list(lliste, 1)
        obj2List = [None] * len(WPObj_liste)
        for index,liste in enumerate(lliste):
            i = liste[0]
            obj2List[index] = WPObj_liste[i]
        # end for
        for i, obj in enumerate(obj2List):
            if obj is None:
                obj2List[i] = WPObj_liste[i]
            # end if
        # end for
        return obj2List
    # end def
    def gruppen_begrenzungs_aufteilung(self,WPObj_liste,nmax):

        # if nmax < len(obj_liste):
        #     obj_looser_liste = obj_liste[nmax:]
        #     obj_liste        = obj_liste[0:nmax]
        # else:
        #     obj_looser_liste = []
        # # end if
        # return (obj_liste,obj_looser_liste)
        WPObj_liste_neu = []
        WPObj_looser_liste = []
        ngruppen = 0
        for wpobj in WPObj_liste:

            if self.Parobj.WPTriggerVerkauf == "Vsig":
                anzahl = wpobj.berechne_anzahl_mit_value("IMDEPOT", True)
            else:
                anzahl = 0
            # end if
            n = max(0,nmax - anzahl)

            if n > 0 and ngruppen < self.Parobj.NAuswahlWPGruppe:
                WPObj_liste_neu.append(wpobj)
            else:
                WPObj_looser_liste.append(wpobj)
            # end if
            ngruppen += 1
        # end for
        WPObj_liste = WPObj_liste_neu
        return (WPObj_liste, WPObj_looser_liste)
    # end def
    def in_gruppen_begrenzungs_aufteilung(self,WPObj_liste,WPObj_looser_liste,nmax):

        for i, wpobj in enumerate(WPObj_liste):

            if self.Parobj.WPTriggerVerkauf == "Vsig":
                # Vsig, dann reduziert die Anzahl der im Depot das nmax um die Anzahl
                # und die im Depot müssen rausgeworfen werden, da sie ja bleiben
                # und die bereinigte Begrenzung auf die verbliebnen angewendet wird
                anzahl = wpobj.berechne_anzahl_mit_value("IMDEPOT", True)
                wpobj.erase_dict_by_value("IMDEPOT", True)
            else:
                anzahl = 0
            # end if
            n = max(0,nmax - anzahl)

            obj = wpobj.begrenze_liste_auf_nmax_gebe_rest_als_obj(n)

            WPObj_looser_liste.append(obj)

            WPObj_liste[i] = wpobj
        # end for
        return (WPObj_liste, WPObj_looser_liste)
    # end def


