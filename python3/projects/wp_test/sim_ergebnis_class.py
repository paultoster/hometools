import os, sys, math

import numpy as np

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_data_set as hdset
import tools.hfkt_date_time as hdt
import tools.hfkt_io as hio
import tools.hfkt_file_path as hfp
import tools.hfkt_np_dataclass as hnpclass
import tools.hfkt_np_calc as hnpcalc
import tools.hfkt_np_fkt as hnpfkt
import tools.hfkt_type as htype
import tools.hfkt_tvar as htvar
import tools.sgui as sgui

class WPErg:
    """

    """
    NAME_ERG_TAB_DATUM  = "Datum"
    NAME_ERG_TAB_CASH   = "Cash"
    NAME_ERG_TAB_STEUER = "Steur"
    NAME_ERG_TAB_KOSTEN = "Kosten"
    NAME_ERG_TAB_ZINS   = "Zins"
    HEADER_ERG_TAB_LISTE = [NAME_ERG_TAB_DATUM,
                            NAME_ERG_TAB_CASH,
                            NAME_ERG_TAB_STEUER,
                            NAME_ERG_TAB_KOSTEN,
                            NAME_ERG_TAB_ZINS]

    ICOL_ERG_TAB_DATUM = HEADER_ERG_TAB_LISTE.index(NAME_ERG_TAB_DATUM)
    ICOL_ERG_TAB_CASH = HEADER_ERG_TAB_LISTE.index(NAME_ERG_TAB_CASH)
    ICOL_ERG_TAB_STEUER = HEADER_ERG_TAB_LISTE.index(NAME_ERG_TAB_STEUER)
    ICOL_ERG_TAB_KOSTEN = HEADER_ERG_TAB_LISTE.index(NAME_ERG_TAB_KOSTEN)
    ICOL_ERG_TAB_ZINS = HEADER_ERG_TAB_LISTE.index(NAME_ERG_TAB_ZINS)

    TYPE_ERG_TAB_DATUM = "datetimeclass"
    TYPE_ERG_TAB_CASH = "cent"
    TYPE_ERG_TAB_STEUER = "cent"
    TYPE_ERG_TAB_KOSTEN = "cent"
    TYPE_ERG_TAB_ZINS = "float"

    TYPE_ERG_TAB_LISTE = [TYPE_ERG_TAB_DATUM,
                          TYPE_ERG_TAB_CASH,
                          TYPE_ERG_TAB_STEUER,
                          TYPE_ERG_TAB_KOSTEN,
                          TYPE_ERG_TAB_ZINS]

    def __init__(self,
                 parobj,
                 dataobj,
                 kontoobj) -> None:

        # referenz
        #---------
        self.Parobj = parobj
        self.DataObj = dataobj
        self.KontoObj = kontoobj

        # Ergebnistabelle
        #--------------
        self.ErgDataSet = hdset.DataSet("Ergebnistabelle")
        self.ErgDataSet.set_definition_list(self.HEADER_ERG_TAB_LISTE,
                                              self.TYPE_ERG_TAB_LISTE,
                                              self.TYPE_ERG_TAB_LISTE)

        # Ergebnispfad
        #-------------
        self.ErgPath = os.path.join(self.Parobj.store_path,
                                    self.Parobj.ergebnis_path_pre_name +
                                    self.Parobj.SimName)

        status = hfp.build_path(self.ErgPath)
        if status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = f"Pfad: {self.ErgPath} konnte nicht erstellt werden"
            return
        # end if

        # np_data-File
        self.NpDataFilename = os.path.join(self.ErgPath,
                                self.Parobj.np_datei_name + ".joblib")
        # np_data-File
        self.PlotEuroFilename = os.path.join(self.ErgPath,
                                self.Parobj.plot_euro_datei_name + ".png")
        self.PlotProzentFilename = os.path.join(self.ErgPath,
                                self.Parobj.plot_prozent_datei_name + ".png")
        self.MdFilename = os.path.join(self.ErgPath,
                                self.Parobj.md_datei_name + ".md")

        # Bilde schreibe Parameterfile
        self.ParYamlFilename = os.path.join(self.ErgPath,
                                self.Parobj.SimName + ".yaml")
        self.ParYamlObj = hio.DataYaml(self.ParYamlFilename)
        if self.ParYamlObj.get_status() != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = f"File : {self.ParYamlFilename} konnte nicht erstellt werden errtext: {self.ParYamlObj.get_errtext()}"
            return
        # end if

        self.ParYamlObj.set_data(vars(self.Parobj))
        if self.ParYamlObj.get_status() != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = f"File : {self.ParYamlFilename} konnte nicht erstellt werden errtext: {self.ParYamlObj.get_errtext()}"
            return
        # end if

        self.ParYamlObj.save()
        if self.ParYamlObj.get_status() != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = f"File : {self.ParYamlFilename} konnte nicht erstellt werden errtext: {self.ParYamlObj.get_errtext()}"
            return
        # end if

        # kONTO-bEWEGUNG CSV-fILE
        self.ParKontoSteuerCsvFilename = os.path.join(self.ErgPath, "konto_steuer.csv")
        self.ParKontoVerrechnungCsvFilename = os.path.join(self.ErgPath, "konto_verrechnung.csv")
        self.ParKontoZinsCsvFilename = os.path.join(self.ErgPath, "konto_zins.csv")

        return
    def update(self,ZwischenErgebnisFlag=True):

        if ZwischenErgebnisFlag:
            self.KontoObj.SetzeSonderEintragFlag()

        (summe_cash_cent,
         summe_steuer_cent,
         summe_kosten_cent) = self.KontoObj.EntnahmeVollstaendig()

        if ZwischenErgebnisFlag:
            self.KontoObj.LoescheSonderEintrag()

        data_set_liste = [self.DataObj.AktDat_datetime,
                          summe_cash_cent,
                          summe_steuer_cent,
                          summe_kosten_cent,
                          self.DataObj.AktZins_float]

        _ = self.ErgDataSet.add_data_set_liste(data_set_liste,
                                               self.HEADER_ERG_TAB_LISTE,
                                               self.TYPE_ERG_TAB_LISTE)


        return
    # end def
    def erstelleErgebnisse(self):

        # erstelle Trace jeden deals zur Auswertung
        self.KontoObj.bildeDepotTraceTabelle()

        # cash, steuer und kosten in arrays
        np_data_obj = self.do_np_data()

        # gebe Konto-Tabellen aus
        self.do_csv_output_konto_data()

        # Bilde Zinskurve mean und median
        np_data_obj = self.do_zins_curve(np_data_obj)

        # Schaue auf Schwankung und min/max-abweichung
        np_data_obj = self.do_std_min_max(np_data_obj)

        # Gib Änderung Jahr für Jahr auf
        np_data_obj = self.do_change_year_by_year(np_data_obj)

        # Depot verläufe und WP-Verläüfe
        np_data_obj = self.do_depot_trace_und_wp_verlauf(np_data_obj)

        # Häufigkeitsverteilung der Deals
        np_data_obj = self.do_wp_deal_verlauf(np_data_obj)

        # Plotten
        self.do_plot_euro(np_data_obj)
        self.do_plot_prozent(np_data_obj)
        self.do_plot_wp_verlauf(np_data_obj)
        self.do_plot_wp_deal_haeufigkeit_plot(np_data_obj)

        # Speichere array-datei
        np_data_obj.save()

        # Schreibe Ergebnis in md-File und bilde pdf
        self.write_md_pdf(np_data_obj)


        return
    # end def
    def do_np_data(self):
        """

        :return: np_data_obj
        """



        # Dateiname array
        # ----------------

        # numpy-Dateset anlegen
        np_data_obj = hnpclass.NpDataHandlingClass(self.NpDataFilename)

        # Arrays aus Tabelle
        dat_liste = self.ErgDataSet.get_row_list_of_header(self.NAME_ERG_TAB_DATUM,
                                                                "dat")
        dyears_float_liste = hdt.calc_datetime_to_dyears_float_liste(self.ErgDataSet.get_row_list_of_header(self.NAME_ERG_TAB_DATUM))
        cash_liste = self.ErgDataSet.get_row_list_of_header(self.NAME_ERG_TAB_CASH)
        stuer_liste = self.ErgDataSet.get_row_list_of_header(self.NAME_ERG_TAB_STEUER)
        kosten_liste = self.ErgDataSet.get_row_list_of_header(self.NAME_ERG_TAB_KOSTEN)
        zins_liste = self.ErgDataSet.get_row_list_of_header(self.NAME_ERG_TAB_ZINS)

        np_dat_array = np.array(dat_liste)
        np_dyears_float_liste = np.array(dyears_float_liste)
        np_cash_array = np.array(cash_liste)
        np_steur_array = np.array(stuer_liste)
        np_kosten_array = np.array(kosten_liste)
        np_zins_array = np.array(zins_liste)

        np_data_obj.add_signal(np_dat_array, "np_dat_array")
        np_data_obj.add_signal(np_dyears_float_liste, "np_dyears_array")
        np_data_obj.add_signal(np_cash_array, "np_cash_array")
        np_data_obj.add_signal(np_steur_array, "np_steuer_array")
        np_data_obj.add_signal(np_kosten_array, "np_kosten_array")
        np_data_obj.add_signal(np_zins_array, "np_zins_array")

        # Datei speichern joblib und csv
        np_data_obj.save()
        ddict = {"np_dat_array":"datStrP",
                 "np_dyears_array":"float",
                 "np_cash_array":"euroStrK",
                 "np_steuer_array":"euroStrK",
                 "np_kosten_array":"euroStrK",
                 "np_zins_array":"percentStr"}
        np_data_obj.save_to_csv(ddict)

        return np_data_obj
    # end def
    def do_csv_output_konto_data(self):
        """

        :return:
        """
        ttable = self.KontoObj.ErstelleSteuerTabelle()
        status =  htvar.write_table_to_csv(ttable,self.ParKontoSteuerCsvFilename)
        if status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = f"File : {self.ParKontoSteuerCsvFilename} konnte nicht erstellt werden"
            return
        # end if

        ttable = self.KontoObj.ErstelleTabelleKontoVerrechnung()
        status =  htvar.write_table_to_csv(ttable,self.ParKontoVerrechnungCsvFilename)
        if status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = f"File : {self.ParKontoVerrechnungCsvFilename} konnte nicht erstellt werden"
            return
        # end if

        ttable = self.KontoObj.ErstelleTabelleKontoZins()
        status =  htvar.write_table_to_csv(ttable,self.ParKontoZinsCsvFilename)
        if status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = f"File : {self.ParKontoZinsCsvFilename} konnte nicht erstellt werden"
            return
        # end if

        # Depot Daten
        isin_liste = self.KontoObj.bildeGesamtDepotISINListe()

        for isin in isin_liste:

            filename = os.path.join(self.ErgPath, f"konto_depot_{isin}.csv")
            ttable   = self.KontoObj.ErstelleTabelleKontoDepot(isin)

            status =  htvar.write_table_to_csv(ttable,filename)
            if status != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = f"File : {filename} konnte nicht erstellt werden"
                return
            # end if
        # end for

        # depot Trace Daten
        for isin in isin_liste:

            filename = os.path.join(self.ErgPath, f"konto_depot_trace_{isin}.csv")
            ttable   = self.KontoObj.ErstelleTabelleKontoDepotTrace(isin)

            status =  htvar.write_table_to_csv(ttable,filename)
            if status != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = f"File : {filename} konnte nicht erstellt werden"
                return
            # end if
        # end for

        return
    # end def
    def do_zins_curve(self,np_data_obj):
        """
        np_data_obj = self.do_zins_curve(np_data_obj)

        add np_mean_zins_array

        :param np_data_obj:
        """

        (mean_zins,
         np_cash_mean_zins_array) = hnpcalc.build_mean_zins_curve(np_data_obj.np_dyears_array,
                                                                  np_data_obj.np_cash_array)

        (median_zins,
         np_cash_median_zins_array) = hnpcalc.build_median_zins_curve(np_data_obj.np_dyears_array,
                                                                  np_data_obj.np_cash_array)

        np_data_obj.add_signal(np_cash_mean_zins_array, "np_cash_mean_zins_array")
        np_data_obj.add_signal(mean_zins, "mean_zins")
        np_data_obj.add_signal(np_cash_median_zins_array, "np_cash_median_zins_array")
        np_data_obj.add_signal(median_zins, "median_zins")


        return np_data_obj
    # end def
    def do_std_min_max(self,np_data_obj):

        Cash0 = np_data_obj.np_cash_array[0]
        if abs(Cash0) < 0.000001:
            Cash0 = 0.000001
        # end if
        gesamt_delta_cash = np_data_obj.np_cash_array[-1] - np_data_obj.np_cash_array[0]
        gesamt_rel_delta_cash = gesamt_delta_cash/Cash0
        gesamt_steuer = np_data_obj.np_steuer_array[-1]
        gesamt_rel_steuer = gesamt_steuer/Cash0
        gesamt_kosten = np_data_obj.np_kosten_array[-1]
        gesamt_rel_kosten = gesamt_kosten/Cash0

        np_diff_array = np.array(
            [(cash-zins)/cash for (cash,zins) in zip(np_data_obj.np_cash_array,np_data_obj.np_cash_mean_zins_array) if abs(cash) > 0.1 ]
        )
        mean_std = np_diff_array.std(ddof=1)

        np_diff_neg_array = np.array(
            [np_diff_array[i] for i in range(len(np_diff_array)) if np_diff_array[i] < 0.0]
        )

        mean_neg_std = np_diff_neg_array.std(ddof=1)

        index = np.argmin(np_diff_array)
        mean_diff_min = np_diff_array[index]
        index = np.argmax(np_diff_array)
        mean_diff_max = np_diff_array[index]

        np_diff_array = np.array(
            [(cash-zins)/cash for (cash,zins) in zip(np_data_obj.np_cash_array,np_data_obj.np_cash_median_zins_array) if abs(cash) > 0.1 ]
        )

        # Tägliche Volatilität
        median_std = np_diff_array.std(ddof=1)

        np_diff_neg_array = np.array(
            [np_diff_array[i] for i in range(len(np_diff_array)) if np_diff_array[i] < 0.0]
        )

        median_neg_std = np_diff_neg_array.std(ddof=1)

        index = np.argmin(np_diff_array)
        median_diff_min = np_diff_array[index]
        index = np.argmax(np_diff_array)
        median_diff_max = np_diff_array[index]

        np_data_obj.add_signal(gesamt_delta_cash, "gesamt_delta_cash")
        np_data_obj.add_signal(gesamt_rel_delta_cash, "gesamt_rel_delta_cash")
        np_data_obj.add_signal(gesamt_steuer, "gesamt_steuer")
        np_data_obj.add_signal(gesamt_rel_steuer, "gesamt_rel_steuer")
        np_data_obj.add_signal(gesamt_kosten, "gesamt_kosten")
        np_data_obj.add_signal(gesamt_rel_kosten, "gesamt_rel_kosten")

        np_data_obj.add_signal(mean_std, "mean_std")
        np_data_obj.add_signal(mean_neg_std, "mean_neg_std")
        np_data_obj.add_signal(mean_diff_min, "mean_diff_min")
        np_data_obj.add_signal(mean_diff_max, "mean_diff_max")

        np_data_obj.add_signal(median_std, "median_std")
        np_data_obj.add_signal(median_neg_std, "median_neg_std")
        np_data_obj.add_signal(median_diff_min, "median_diff_min")
        np_data_obj.add_signal(median_diff_max, "median_diff_max")

        return np_data_obj
    # end def
    def do_change_year_by_year(self,np_data_obj):
        """
        np_data_obj = self.do_change_year_by_year(np_data_obj)
        :param np_data_obj:
        :return:
        """
        nyears = int(np_data_obj.np_dyears_array[-1])
        dat_secs_liste = []
        cash_liste = []
        steuer_liste = []
        kosten_liste = []

        index = 0

        for year in range(nyears+1):

            (_,index) = hnpfkt.find_nearest_value(float(year),
                                                  np_data_obj.np_dyears_array)

            dat_secs_liste.append(np_data_obj.np_dat_array[index])
            cash_liste.append(np_data_obj.np_cash_array[index])
            steuer_liste.append(np_data_obj.np_steuer_array[index])
            kosten_liste.append(np_data_obj.np_kosten_array[index])
        # end for

        if index+1 != len(np_data_obj.np_dyears_array):
            dat_secs_liste.append(np_data_obj.np_dat_array[-1])
            cash_liste.append(np_data_obj.np_cash_array[-1])
            steuer_liste.append(np_data_obj.np_steuer_array[-1])
            kosten_liste.append(np_data_obj.np_kosten_array[-1])
        # end if

        np_data_obj.add_signal(np.array(dat_secs_liste), "np_years_dat_array")
        np_data_obj.add_signal(np.array(cash_liste), "np_years_cash_array")
        np_data_obj.add_signal(np.array(steuer_liste), "np_years_steuer_array")
        np_data_obj.add_signal(np.array(kosten_liste), "np_years_kosten_array")

        return np_data_obj
    # end def
    def do_depot_trace_und_wp_verlauf(self,np_data_obj):


        # isin-Liste
        isin_liste = self.KontoObj.bildeGesamtDepotISINListe()
        namen_liste = [self.KontoObj.getWPName(isin) for isin in isin_liste]

        np_data_obj.add_signal(np.array(isin_liste), "np_depot_wp_isin_array")
        np_data_obj.add_signal(np.array(namen_liste), "np_depot_wp_namen_array")

        for isin in isin_liste:

            liste = self.KontoObj.getListeRelVKDepot(isin)
            np_data_obj.add_signal(np.array(liste), f"np_depot_relvk_{isin}_array")

            liste = self.KontoObj.getListeRelVMaxDepot(isin)
            np_data_obj.add_signal(np.array(liste), f"np_depot_relvkmax_{isin}_array")
        # end for

        # WP Verlauf
        for isin in isin_liste:
            np_dat_array = self.KontoObj.getDatumKursVerlauf(isin)
            np_kurs_array = self.KontoObj.getKursVerlauf(isin)
            np_roh_kurs_array = self.KontoObj.getRohKursVerlauf(isin)

            np_data_obj.add_signal(np_dat_array, f"np_wp_dat_{isin}_array")
            np_data_obj.add_signal(np_kurs_array, f"np_wp_kurs_{isin}_array")
            np_data_obj.add_signal(np_roh_kurs_array, f"np_wp_rohkurs_{isin}_array")
        return np_data_obj
    # end def
    def do_wp_deal_verlauf(self,np_data_obj):
        """

        :param np_data_obj:
        :return: np_data_obj = self.do_wp_deal_verlauf(np_data_obj)
        """
        # Bringe alle einzelne isin Verläufe in ein array
        if len(np_data_obj.np_depot_wp_isin_array):

            np_depot_relvk_array = np.array([],dtype=np.float64)
            np_depot_relvkmax_array = np.array([],dtype=np.float64)

            for isin in np_data_obj.np_depot_wp_isin_array:
                np_depot_relvk_array = np.concatenate((np_depot_relvk_array,getattr(np_data_obj, f"np_depot_relvk_{isin}_array")*100.))
                np_depot_relvkmax_array = np.concatenate((np_depot_relvkmax_array,getattr(np_data_obj, f"np_depot_relvkmax_{isin}_array")*100.))
            # end for

            (np_kl_relvk_schw_array,np_kl_relvk_haeuf_array) = hnpcalc.build_klassen_einteilung(np_depot_relvk_array, 10.)
            (np_kl_relvkmax_schw_array,np_kl_relvkmax_haeuf_array) = hnpcalc.build_klassen_einteilung(np_depot_relvkmax_array, 10.)

            relvk_mean = np.mean(np_depot_relvk_array)
            relvkmax_mean = np.mean(np_depot_relvkmax_array)

            np_data_obj.add_signal(np_kl_relvk_schw_array, "np_kl_relvk_schw_array")
            np_data_obj.add_signal(np_kl_relvk_haeuf_array, "np_kl_relvk_haeuf_array")
            np_data_obj.add_signal(np_kl_relvkmax_schw_array, "np_kl_relvkmax_schw_array")
            np_data_obj.add_signal(np_kl_relvkmax_haeuf_array, "np_kl_relvkmax_haeuf_array")
            np_data_obj.add_signal(relvk_mean, "relvk_mean")
            np_data_obj.add_signal(relvkmax_mean, "relvkmax_mean")
        # end if
        return np_data_obj
    # end if
    def do_plot_euro(self,np_data_obj):



        dict_data1 = {}
        dict_data1["xdat"] = np_data_obj.np_dat_array
        dict_data1["y"] = np_data_obj.np_cash_array
        dict_data1["color"] = "k"
        dict_data1["linewidth"] = 1
        dict_data1["linestyle"] = "-"
        dict_data1["marker"] = ""
        dict_data1["label"] = "cash"

        dict_data2 = {}
        dict_data2["xdat"] = np_data_obj.np_dat_array
        dict_data2["y"] = np_data_obj.np_cash_mean_zins_array
        dict_data2["color"] = "g"
        dict_data2["linewidth"] = 1
        dict_data2["linestyle"] = "-"
        dict_data2["marker"] = ""
        dict_data2["label"] = "cash_mzins_" +  "%.2f" % (float(np_data_obj.mean_zins) * 100) + "%"

        dict_data3 = {}
        dict_data3["xdat"] = np_data_obj.np_dat_array
        dict_data3["y"] = np_data_obj.np_cash_median_zins_array
        dict_data3["color"] = "y"
        dict_data3["linewidth"] = 1
        dict_data3["linestyle"] = "-"
        dict_data3["marker"] = ""
        dict_data3["label"] = "cash_medzins_" +  "%.2f" % (float(np_data_obj.median_zins) * 100) + "%"

        dict_subplot1 = {}
        dict_subplot1["name"] = "Cash"
        dict_subplot1["title"] = "Ergebnis in Euro"
        dict_subplot1["xlabel"] = "Date"
        dict_subplot1["ylabel"] = "€"
        dict_subplot1["legend"] = "best"
        dict_subplot1["data_list"] = [dict_data1,dict_data2,dict_data3]

        ddict = {}
        ddict["rows"] = 1
        ddict["cols"] = 1
        ddict["sharex"] = False
        ddict["sharey"] = False
        ddict["width"] = 30
        ddict["height"] = 20
        ddict["title"] = self.Parobj.SimName
        ddict["title_add_date_range"] = True

        ddict["subplot_list"] = [dict_subplot1]

        dict_input = {}
        dict_input["plot"] = ddict
        dict_input["widget"] = False
        dict_input["show"] = False
        dict_input["plotfile"] = self.PlotEuroFilename

        obj = sgui.matplot_date_data(dict_input)


        return
    # end def
    def do_plot_prozent(self, np_data_obj):

        B0 = np_data_obj.np_cash_array[0]
        dict_data1 = {}
        dict_data1["xdat"] = np_data_obj.np_dat_array
        dict_data1["y"] = (np_data_obj.np_cash_array-B0)/B0 * 100.
        dict_data1["color"] = "k"
        dict_data1["linewidth"] = 1
        dict_data1["linestyle"] = "-"
        dict_data1["marker"] = ""
        dict_data1["label"] = "cash"

        dict_data2 = {}
        dict_data2["xdat"] = np_data_obj.np_dat_array
        dict_data2["y"] = (np_data_obj.np_cash_mean_zins_array-B0)/B0* 100.
        dict_data2["color"] = "g"
        dict_data2["linewidth"] = 1
        dict_data2["linestyle"] = "-"
        dict_data2["marker"] = ""
        dict_data2["label"] = "cash_mzins_" + "%.2f" % (float(np_data_obj.mean_zins) * 100) + "%"

        dict_data3 = {}
        dict_data3["xdat"] = np_data_obj.np_dat_array
        dict_data3["y"] = (np_data_obj.np_cash_median_zins_array - B0)/B0 * 100.
        dict_data3["color"] = "y"
        dict_data3["linewidth"] = 1
        dict_data3["linestyle"] = "-"
        dict_data3["marker"] = ""
        dict_data3["label"] = "cash_medzins_" + "%.2f" % (float(np_data_obj.median_zins) * 100) + "%"

        dict_subplot1 = {}
        dict_subplot1["name"] = "Cash"
        dict_subplot1["title"] = "Ergebnis in Prozent"
        dict_subplot1["xlabel"] = "Date"
        dict_subplot1["ylabel"] = "%"
        dict_subplot1["legend"] = "best"
        dict_subplot1["data_list"] = [dict_data1, dict_data2, dict_data3]

        ddict = {}
        ddict["rows"] = 1
        ddict["cols"] = 1
        ddict["sharex"] = False
        ddict["sharey"] = False
        ddict["width"] = 30
        ddict["height"] = 20
        ddict["title"] = self.Parobj.SimName
        ddict["title_add_date_range"] = True

        ddict["subplot_list"] = [dict_subplot1]

        dict_input = {}
        dict_input["plot"] = ddict
        dict_input["widget"] = False
        dict_input["show"] = False
        dict_input["plotfile"] = self.PlotProzentFilename

        obj = sgui.matplot_date_data(dict_input)

        return
    # end def
    def do_plot_wp_verlauf(self,np_data_obj):
        #
        for isin in np_data_obj.np_depot_wp_isin_array:


            name_dat_array =  f"np_wp_dat_{isin}_array"
            name_kurs_array = f"np_wp_kurs_{isin}_array"
            name_rohkurs_array = f"np_wp_rohkurs_{isin}_array"
            bodyname = f"erg_plot_wp_{isin}"
            filename = os.path.join(self.ErgPath,bodyname + ".png")

            if hasattr(np_data_obj,name_dat_array) and hasattr(np_data_obj,name_kurs_array) and hasattr(np_data_obj,name_rohkurs_array):


                self.do_plot_wp_verlauf_plot(isin,
                                             getattr(np_data_obj,name_dat_array),
                                             getattr(np_data_obj, name_kurs_array),
                                             getattr(np_data_obj, name_rohkurs_array),
                                             filename)
            # end if
        # end for
        return
    # end def
    def do_plot_wp_verlauf_plot(self,
                                isin,
                                np_dat_array,
                                np_kurs_array,
                                np_rohkurs_array,
                                plotfilename):

        dict_data1 = {}
        dict_data1["xdat"] =np_dat_array
        dict_data1["y"] = np_kurs_array
        dict_data1["color"] = "k"
        dict_data1["linewidth"] = 1
        dict_data1["linestyle"] = "-"
        dict_data1["marker"] = ""
        dict_data1["label"] = "kurs"

        dict_data2 = {}
        dict_data2["xdat"] = np_dat_array
        dict_data2["y"] = np_rohkurs_array
        dict_data2["color"] = "b"
        dict_data2["linewidth"] = 1
        dict_data2["linestyle"] = "-"
        dict_data2["marker"] = ""
        dict_data2["label"] = "rohkurs"

        dict_subplot1 = {}
        dict_subplot1["name"] = "WPVerlauf"
        dict_subplot1["title"] = f"WPVerlauf {isin} in Euro"
        dict_subplot1["xlabel"] = "Date"
        dict_subplot1["ylabel"] = "€"
        dict_subplot1["legend"] = "best"
        dict_subplot1["data_list"] = [dict_data1,dict_data2]

        ddict = {}
        ddict["rows"] = 1
        ddict["cols"] = 1
        ddict["sharex"] = False
        ddict["sharey"] = False
        ddict["width"] = 30
        ddict["height"] = 20
        ddict["title"] = self.Parobj.SimName
        ddict["title_add_date_range"] = True

        ddict["subplot_list"] = [dict_subplot1]

        dict_input = {}
        dict_input["plot"] = ddict
        dict_input["widget"] = False
        dict_input["show"] = False
        dict_input["plotfile"] = plotfilename

        obj = sgui.matplot_date_data(dict_input)
        return
    # end def
    def do_plot_wp_deal_haeufigkeit_plot(self,np_data_obj):
        """

        :param np_data_obj:
        :return:
        """
        if hasattr(np_data_obj, "np_kl_relvk_schw_array") and hasattr(np_data_obj, "np_kl_relvk_haeuf_array"):


            plotfilename = os.path.join(self.ErgPath,"erg_plot_wp_deal_haeuf_relvk.png")

            ddict = {}
            ddict["x"] = getattr(np_data_obj, "np_kl_relvk_schw_array")
            ddict["y"] = getattr(np_data_obj, "np_kl_relvk_haeuf_array")
            ddict["color"] = "k"
            ddict["label"] = "relvk"
            ddict["title"] = f"{self.Parobj.SimName} H-Verteilung Kurs Verkauf/Kauf"
            ddict["xlabel"] = "Prozent %"
            ddict["ylabel"] = "n"

            if hasattr(np_data_obj, "relvk_mean"):
                ddict["xline"] = getattr(np_data_obj, "relvk_mean")
                ddict["xline_color"] = 'r'
                ddict["xline_linewidth"] = 5
                ddict["xline_linestyle"] = '--'
                ddict["xline_label"] = 'mean'

                ddict["legend"] = "best"
            # end if

            dict_input = {}
            dict_input["plot"] = ddict
            dict_input["show"] = False
            dict_input["plotfile"] = plotfilename

            obj1 = sgui.matplot_bar(dict_input)
        # end if

        if hasattr(np_data_obj, "np_kl_relvkmax_schw_array") and hasattr(np_data_obj, "np_kl_relvkmax_haeuf_array"):

            plotfilename = os.path.join(self.ErgPath, "erg_plot_wp_deal_haeuf_relvkmax.png")

            ddict = {}
            ddict["x"] = getattr(np_data_obj, "np_kl_relvkmax_schw_array")
            ddict["y"] = getattr(np_data_obj, "np_kl_relvkmax_haeuf_array")
            ddict["color"] = "k"
            ddict["label"] = "relvkmax"
            ddict["title"] = f"{self.Parobj.SimName} H-Verteilung Kurs (Verkauf-Kauf)/(Max-Kauf)"
            ddict["xlabel"] = "Prozent %"
            ddict["ylabel"] = "n"
            if hasattr(np_data_obj, "relvkmax_mean"):
                ddict["xline"] = getattr(np_data_obj, "relvkmax_mean")
                ddict["xline_color"] = 'r'
                ddict["xline_linewidth"] = 5
                ddict["xline_linestyle"] = '--'
                ddict["xline_label"] = 'mean'

                ddict["legend"] = "best"
            # end if

            dict_input = {}
            dict_input["plot"] = ddict
            dict_input["show"] = False
            dict_input["plotfile"] = plotfilename

            obj1 = sgui.matplot_bar(dict_input)
        # end if
        return
    # end def
    def write_md_pdf(self,np_data_obj):


        mdobj = hio.MDBuild(self.MdFilename)

        mdobj.add_header(f"Simulation: {self.Parobj.SimName}")
        mdobj.add_paragraph("---")

        # Parameter
        #----------
        headers = ["Parameter", "Wert"]
        rows = [["StartDatum",  self.Parobj.StartDat_str],
                ["EndDatum", self.Parobj.EndDat_str],
                ["StartCash",
                 htype.type_transform_direct(self.Parobj.StartCash,"cent", "euroStrK")+" €" ]
               ]
        mdobj.add_table(headers, rows)

        # Plots
        mdobj.add_image(self.PlotProzentFilename,"GesamtPlotProzent")
        mdobj.add_image(self.PlotEuroFilename,"GesamtPlotEuro")

        # Ergebnis
        #----------
        headers = ["Ergebnis", "Wert"]
        rows = [["DeltaCash",
                 htype.type_transform_direct(np_data_obj.gesamt_delta_cash,"cent", "euroStrK")+" €"],
                ["RelDeltaCash",
                 htype.type_transform_direct(np_data_obj.gesamt_rel_delta_cash, "float", "percentStr")],
                ["Steuer",
                 htype.type_transform_direct(np_data_obj.gesamt_steuer, "cent", "euroStrK") + " €"],
                ["RelSteuer",
                 htype.type_transform_direct(np_data_obj.gesamt_rel_steuer, "float", "percentStr")],
                ["Kosten",
                 htype.type_transform_direct(np_data_obj.gesamt_kosten, "cent", "euroStrK") + " €"],
                ["RelKosten",
                 htype.type_transform_direct(np_data_obj.gesamt_rel_kosten, "float", "percentStr")],
                ["ZinsMean",
                 htype.type_transform_direct(np_data_obj.mean_zins,"float", "percentStr")],
                ["MeanSTD",
                 htype.type_transform_direct(np_data_obj.mean_std,"float", "percentStr")],
                ["MeanNegSTD",
                 htype.type_transform_direct(np_data_obj.mean_neg_std,"float", "percentStr")],
                ["MeanDiffMin",
                 htype.type_transform_direct(np_data_obj.mean_diff_min, "float", "percentStr")],
                ["MeanDiffMax",
                 htype.type_transform_direct(np_data_obj.mean_diff_max, "float", "percentStr")],
                ["ZinsMedian",
                 htype.type_transform_direct(np_data_obj.median_zins, "float", "percentStr")],
                ["MedianSTD",
                 htype.type_transform_direct(np_data_obj.median_std,"float", "percentStr")],
                ["MedianNegSTD",
                 htype.type_transform_direct(np_data_obj.median_neg_std, "float", "percentStr")],
                ["MedianDiffMin",
                 htype.type_transform_direct(np_data_obj.median_diff_min, "float", "percentStr")],
                ["MedianDiffMax",
                 htype.type_transform_direct(np_data_obj.median_diff_max, "float", "percentStr")],
                ]
        mdobj.add_table(headers, rows)
        mdobj.add_paragraph("---")

        headers = ["Ergeb pro jahr", "Cash", "Steuer", "Kosten"]

        rows = []
        n = len(np_data_obj.np_years_cash_array)

        for index_tuple, dat_secs in np.ndenumerate(np_data_obj.np_years_dat_array):
            i = index_tuple[0]
            if i > 0:
                Cash0 = np_data_obj.np_years_cash_array[i-1]
                if abs(Cash0) < 0.000001:
                    Cash0 = 0.000001
                # end if
                relcash = np_data_obj.np_years_cash_array[i] - np_data_obj.np_years_cash_array[i-1]
                relcash /= Cash0
                relsteuer = np_data_obj.np_years_steuer_array[i]-np_data_obj.np_years_steuer_array[i-1]
                relsteuer /= Cash0
                relkosten = np_data_obj.np_years_kosten_array[i]-np_data_obj.np_years_kosten_array[i-1]
                relkosten /= Cash0

                dattime = htype.type_transform_direct(dat_secs, "dat", "datetimeclass")

                if i + 1 == n:
                    sec_jahr = self.Parobj.tage_pro_jahr * 24 * 3600
                    year = i - 1 + (dat_secs - np_data_obj.np_years_dat_array[i-1]) / sec_jahr
                    year_str = ("%.2f" % (float(year)))
                    t = f"({year_str}) {dattime.year}"
                else:
                    t = f"({i}.) {dattime.year-1}"
                # end if

                zeile = [t,
                         htype.type_transform_direct(relcash, "float", "percentStr"),
                         htype.type_transform_direct(relsteuer, "float", "percentStr"),
                         htype.type_transform_direct(relkosten, "float", "percentStr")
                         ]
                rows.append(zeile)
            # end if
        # end for
        mdobj.add_table(headers, rows)
        mdobj.add_paragraph("---")

        headers = ["Ergeb/jahr sum", "Cash","Steuer","Kosten"]

        rows = []
        n = len(np_data_obj.np_years_cash_array)
        Cash0 = np_data_obj.np_years_cash_array[0]
        if abs(Cash0) < 0.000001:
            Cash0 = 0.000001
        # end if
        for index_tuple,dat_secs in np.ndenumerate(np_data_obj.np_years_dat_array):
            i = index_tuple[0]
            if i > 0:
                relcash = np_data_obj.np_years_cash_array[i]-np_data_obj.np_years_cash_array[0]
                relcash /= Cash0
                relsteuer = np_data_obj.np_years_steuer_array[i]
                relsteuer /= Cash0
                relkosten = np_data_obj.np_years_kosten_array[i]
                relkosten /= Cash0

                dattime = htype.type_transform_direct(dat_secs, "dat", "datetimeclass")

                if i+1 == n:
                    sec_jahr = self.Parobj.tage_pro_jahr * 24 * 3600
                    year = i - 1 + (dat_secs - np_data_obj.np_years_dat_array[i-1]) / sec_jahr
                    year_str = ("%.2f" % (float(year)))
                    t = f"({year_str}) {dattime.year}"
                else:
                    t = f"({i}.) {dattime.year-1}"
                # end if

                zeile = [t,
                         htype.type_transform_direct(relcash, "float", "percentStr"),
                         htype.type_transform_direct(relsteuer, "float", "percentStr"),
                         htype.type_transform_direct(relkosten, "float", "percentStr")
                ]
                rows.append(zeile)
            # end if
        # end for
        mdobj.add_table(headers, rows)
        mdobj.add_paragraph("---")

        plotfilename = os.path.join(self.ErgPath, "erg_plot_wp_deal_haeuf_relvk.png")
        mdobj.add_image(plotfilename, "WP Häufigkeit Verkauf/Kauf-Kurs")
        plotfilename = os.path.join(self.ErgPath, "erg_plot_wp_deal_haeuf_relvkmax.png")
        mdobj.add_image(plotfilename, "WP Häufigkeit (Verkauf-Kauf)/(Max-Kauf)-Kurs")

        mdobj.add_paragraph("---")
        # Plots von WPs
        rows = []
        headers = ["isin","name"]
        for i,isin in np.ndenumerate(np_data_obj.np_depot_wp_isin_array):
            rows.append([isin,np_data_obj.np_depot_wp_namen_array[i[0]]])
        # end ofr

        mdobj.add_table(headers, rows)
        mdobj.add_paragraph("---")

        # Plots von WPs
        for isin in np_data_obj.np_depot_wp_isin_array:

            bodyname = f"erg_plot_wp_{isin}"
            filename = os.path.join(self.ErgPath, bodyname + ".png")
            mdobj.add_image(filename, f"WPVerlaf {isin}")
        # end for


        mdobj.write()

        mdobj.write_pdf()

        return
    # end def
# end class
        np_data_obj.add_signal(np.array(dat_secs_liste), "")
        np_data_obj.add_signal(np.array(cash_liste), "")
        np_data_obj.add_signal(np.array(steuer_liste), "np_years_steuer_array")
        np_data_obj.add_signal(np.array(kosten_liste), "np_years_kosten_array")
