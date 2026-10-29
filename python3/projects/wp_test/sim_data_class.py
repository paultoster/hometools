import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_tvar as htvar
import tools.hfkt_type as htype
import tools.hfkt_list as hlist

import konto_verrechnung_class
import konto_zins_class

class WPData:
    """

    """

    def __init__(self,
                 wpscrefunc,
                 parobj,) -> None:

        # referenz
        #---------
        self.Parobj = parobj
        self.WPscrefunc = wpscrefunc

        # Akt Datum initialisieren
        #-------------------------
        self.AktDat_datetime = self.Parobj.StartDat_datetime
        #self.AktDat_datstr   = self.Parobj.StartDat_str


        # Daten zu Zinskonto anlegen
        #---------------------------
        if self.Parobj.ZinsKontoPruefung:

            # Datensatz für ezb-zins anlegen
            self.WPscrefunc.build_ezbzins_sigset()

            if self.WPscrefunc.get_status() != hdef.OKAY:
                self.Parobj.status = hdef.NOT_OKAY
                self.Parobj.errtext = self.WPscrefunc.get_errtext()
                return
            # end if
            if len(self.WPscrefunc.get_infotext()):
                self.Parobj.infotext += self.WPscrefunc.get_infotext()
            # end if
            self.WPscrefunc.reset_status()

            # Zins Startdatum abfragen
            self.AktZins_float = self.WPscrefunc.get_ezbzins(htype.type_transform_direct(self.Parobj.StartDat_datetime, "datetimeclass", "dat"))

            # bei Negativzins auf null setzen
            if self.AktZins_float < 0.0:
                self.AktZins_float = 0.0
            # end if
        else:
            self.AktZins_float = 0.0
        # end if

        if self.Parobj.DepotKontoPruefung:

            # -------------------------------------------------------------------------------------------
            # wp_screener anlegen
            #--------------------------------------------------------------------------------------------

            # ScreKat anlegen
            self.WPscrefunc.add_katalog_gruppe_isin_dict(self.Parobj.sim_screkat_name,self.Parobj.ScreKat)
            if self.WPscrefunc.get_status() != hdef.OKAY:
                self.Parobj.status = hdef.NOT_OKAY
                self.Parobj.errtext = self.WPscrefunc.get_errtext()
                self.WPscrefunc.reset_status()
                return
            # end if
            if len(self.WPscrefunc.get_infotext()):
                self.Parobj.infotext += self.WPscrefunc.get_infotext()
                self.WPscrefunc.reset_status()
            # end if

            # Sigset anlegen
            self.WPscrefunc.add_sigset_dict(self.Parobj.sim_scresig_name,self.Parobj.ScreSig)
            if self.WPscrefunc.get_status() != hdef.OKAY:
                self.Parobj.status = hdef.NOT_OKAY
                self.Parobj.errtext = self.WPscrefunc.get_errtext()
                self.WPscrefunc.reset_status()
                return
            # end if
            if len(self.WPscrefunc.get_infotext()):
                self.Parobj.infotext += self.WPscrefunc.get_infotext()
                self.WPscrefunc.reset_status()
            # end if

            # Tabelle anlegen
            self.WPscrefunc.add_tab_dict(self.Parobj.sim_scretab_name, self.Parobj.SreTab)
            if self.WPscrefunc.get_status() != hdef.OKAY:
                self.Parobj.status = hdef.NOT_OKAY
                self.Parobj.errtext = self.WPscrefunc.get_errtext()
                self.WPscrefunc.reset_status()
                return
            # end if
            if len(self.WPscrefunc.get_infotext()):
                self.Parobj.infotext += self.WPscrefunc.get_infotext()
                self.WPscrefunc.reset_status()
            # end if

            # screen anlegen (wird intern angelegt, da es immer gleich sein soll)
            screDict = {"katalog": self.Parobj.sim_screkat_name,
                        "sigset": self.Parobj.sim_scresig_name,
                        "tab": self.Parobj.sim_scretab_name,
                        "plotdef": ""
                       }
            self.WPscrefunc.add_scre_dict(self.Parobj.sim_scre_name, screDict)
            if self.WPscrefunc.get_status() != hdef.OKAY:
                self.Parobj.status = hdef.NOT_OKAY
                self.Parobj.errtext = self.WPscrefunc.get_errtext()
                self.WPscrefunc.reset_status()
                return
            # end if
            if len(self.WPscrefunc.get_infotext()):
                self.Parobj.infotext += self.WPscrefunc.get_infotext()
                self.WPscrefunc.reset_status()
            # end if

            # Bilde alle Signale und lege sie in Dateien ab
            start_dat = htype.type_transform_direct(self.Parobj.StartDat_datetime,"datetimeclass", "dat")
            self.WPscrefunc.build_scre_sigset(self.Parobj.sim_scre_name,start_dat)
            if self.WPscrefunc.get_status() != hdef.OKAY:
                self.Parobj.status = hdef.NOT_OKAY
                self.Parobj.errtext = self.WPscrefunc.get_errtext()
                self.WPscrefunc.reset_status()
                return
            # end if
            if len(self.WPscrefunc.get_infotext()):
                self.Parobj.infotext += self.WPscrefunc.get_infotext()
                self.WPscrefunc.reset_status()
            # end if

            # Liste mit den screnner Ergebnissen
            self.WPScreDictListObj = hlist.HandleDictListe([])

            # dict mit isin-Kurswerten

            self.WPISINKursDict = {}

            self.AnzahlDepotAufteilung = self.Parobj.NAuswahlWPGruppe * self.Parobj.NAuswahlWP
            self.AnteilDepotAufteilung = 1. / max(1, self.AnzahlDepotAufteilung)
        # end if

        return
    # end def
    def get_aktzins_float(self):
        return self.AktZins_float
    # end def
    def update(self):

        # Daten zu Zinskonto
        #-------------------
        if self.Parobj.ZinsKontoPruefung:


            # Zins aktuellem Datum abfragen
            self.AktZins_float = self.WPscrefunc.get_ezbzins(
                htype.type_transform_direct(self.AktDat_datetime, "datetimeclass", "dat"))

            # bei Negativzins auf null setzen
            if self.AktZins_float < 0.0:
                self.AktZins_float = 0.0
            # end if
        # end if

        return
    # end def
    def update_scre(self):
        """

        :return:
        """
        pruef_dat = htype.type_transform_direct(self.AktDat_datetime, "datetimeclass", "dat")
        ttable = self.WPscrefunc.build_scre_rawtable(self.Parobj.sim_scre_name,pruef_dat,self.Parobj.WPExistDays)

        self.WPScreDictListObj.set_liste(ttable)

        self.WPISINKursDict = {}
        for scredict in self.WPScreDictListObj:
            self.WPISINKursDict[scredict["ISIN"]] = scredict["KURS"]
        # end for

        return
    # end class
    # def bildeAufteilungWps(self,anzahlWPs, anzahlSollKauf):
    #     """
    #     Berechnet self.AnzahlDepotAufteilung und self.AnteilDepotAufteilung
    #
    #     :param anzahlWPs:
    #     :param anzahlSollKauf:
    #     :return:
    #     """
    #
    #     # Depotaufteilung nach vorgabe, begrenzr ducrh die Anzahl von vorhandenen WP und zu kaufender zu dieser Zeit
    #     #------------------------------------------------------------------------------------------
    #     self.AnzahlDepotAufteilung = min(self.Parobj.NAuswahlWPGruppe * self.Parobj.NAuswahlWP,
    #                                      anzahlWPs + anzahlSollKauf)
    #     self.AnteilDepotAufteilung = 1. / max(1, self.AnzahlDepotAufteilung)
    #
    #     return
    # # end def
    def getMinMaxFromWP(self,isin,datstart_datetime,datend_datetime):
        """

        :param isin:
        :param datstart_datetime:
        :param datend_datetime:
        :return: (KursMin,KursMax) = getMinMaxFromWP(isin,datstart_datetime,datend_datetime)
        """

        datstart = htype.type_transform_direct(datstart_datetime, "datetimeclass", "dat")
        datend = htype.type_transform_direct(datend_datetime, "datetimeclass", "dat")
        (KursMin, KursMax) = self.WPscrefunc.getMaxMinFromSigSet(isin,
                                                                self.Parobj.sim_scre_name,
                                                                "KursFilt",
                                                                datstart,
                                                                datend)


        if self.WPscrefunc.get_status() != hdef.OKAY:
            raise Exception(self.WPscrefunc.get_errtext())
        # end if

        return (KursMin,KursMax)
    # end def
    def getDatumKursVerlauf(self,isin, startdat_datetime, enddat_datetime):
        datstart = htype.type_transform_direct(startdat_datetime, "datetimeclass", "dat")
        datend = htype.type_transform_direct(enddat_datetime, "datetimeclass", "dat")
        np_array = self.WPscrefunc.getArrayFromSigSet(isin,
                                                      self.Parobj.sim_scre_name,
                                                      "Datum",
                                                      datstart,
                                                      datend)


        if self.WPscrefunc.get_status() != hdef.OKAY:
            raise Exception(self.WPscrefunc.get_errtext())
        # end if

        return np_array
    # end def
    def getKursVerlauf(self,isin, startdat_datetime, enddat_datetime):
        datstart = htype.type_transform_direct(startdat_datetime, "datetimeclass", "dat")
        datend = htype.type_transform_direct(enddat_datetime, "datetimeclass", "dat")
        np_array = self.WPscrefunc.getArrayFromSigSet(isin,
                                                      self.Parobj.sim_scre_name,
                                                      "KursFilt",
                                                      datstart,
                                                      datend)


        if self.WPscrefunc.get_status() != hdef.OKAY:
            raise Exception(self.WPscrefunc.get_errtext())
        # end if

        return np_array
    # end def
    def getRohKursVerlauf(self,isin, startdat_datetime, enddat_datetime):
        datstart = htype.type_transform_direct(startdat_datetime, "datetimeclass", "dat")
        datend = htype.type_transform_direct(enddat_datetime, "datetimeclass", "dat")
        np_array = self.WPscrefunc.getArrayFromSigSet(isin,
                                                      self.Parobj.sim_scre_name,
                                                      "Kurs",
                                                      datstart,
                                                      datend)


        if self.WPscrefunc.get_status() != hdef.OKAY:
            raise Exception(self.WPscrefunc.get_errtext())
        # end if

        return np_array
    # end def
    def getRohKursVerlauf(self,isin, startdat_datetime, enddat_datetime):
        datstart = htype.type_transform_direct(startdat_datetime, "datetimeclass", "dat")
        datend = htype.type_transform_direct(enddat_datetime, "datetimeclass", "dat")
        np_array = self.WPscrefunc.getArrayFromSigSet(isin,
                                                      self.Parobj.sim_scre_name,
                                                      "Kurs",
                                                      datstart,
                                                      datend)


        if self.WPscrefunc.get_status() != hdef.OKAY:
            raise Exception(self.WPscrefunc.get_errtext())
        # end if

        return np_array
    # end def

# end class