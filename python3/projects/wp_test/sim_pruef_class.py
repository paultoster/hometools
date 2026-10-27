import os, sys

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

        return
    def update(self):

        if self.Parobj.DepotKontoPruefung:

            self.pruefe_verkauf()
            self.pruefe_verbleib_u_nichtkauf()
            self.pruefe_kauf()

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

        liste_isin_im_depot = self.KontoObj.bildeAktivesDepotListe()

        verkaufs_index_liste = []
        for isin in liste_isin_im_depot:

            index = hlist.search_value_in_list_of_dict(self.DataObj.WPScreDictList, "ISIN", isin)

            if index is not None:

                if self.DataObj.WPScreDictList[index]["VERKAUF"] > 0:
                    verkaufs_index_liste.append(index)
                # end if
            # end if
        # end for

        # Verkaufen und aus liste löschen
        for index in reversed(verkaufs_index_liste):

            self.KontoObj.verkaufeAusDepot(self.DataObj.WPScreDictList[index]["ISIN"],
                                           self.DataObj.WPScreDictList[index]["KURS"],
                                           anzahl = None)
            if self.Parobj.status != hdef.OKAY:
                return
            del self.DataObj.WPScreDictList[index]
        # end for

        return
    # end def
    def pruefe_verbleib_u_nichtkauf(self):
        """
        Prüft anhand der WPScreDictList, was bleiben soll
        :return:
        """
        liste_isin_im_depot = self.KontoObj.bildeAktivesDepotListe()

        verbleib_index_liste = []
        for isin in liste_isin_im_depot:
            index = hlist.search_value_in_list_of_dict(self.DataObj.WPScreDictList, "ISIN", isin)
            if index is not None:

                if self.DataObj.WPScreDictList[index]["VERKAUF"] > 0:

                    verbleib_index_liste.append(index)
                # endif
            # end if
        # end for

        # Verbleib aus liste löschen
        for index in reversed(verbleib_index_liste):
            del self.DataObj.WPScreDictList[index]
        # end for

        # Nichtkauf auch rauswerfen
        for index in reversed(range(len(self.DataObj.WPScreDictList))):
            if self.DataObj.WPScreDictList[index]["KAUF"] == 0:
                del self.DataObj.WPScreDictList[index]
            # end if
        # end for
        return
    # end def
    def pruefe_kauf(self):

        if len(self.DataObj.WPScreDictList):

            # Theoretisches Guthaben
            self.KontoObj.SetzeSonderEintragFlag()

            (summe_cash_cent,_,_) = self.KontoObj.EntnahmeVollstaendig()

            self.KontoObj.LoescheSonderEintrag()

            anlage_summe_c = int(summe_cash_cent * self.DataObj.AnteilDepotAufteilung +0.5)

            for scre_dict in self.DataObj.WPScreDictList:

                self.KontoObj.kaufeWPmitSumme(scre_dict["ISIN"],anlage_summe_c)
            # end for
        # end if

        return
    # end def


