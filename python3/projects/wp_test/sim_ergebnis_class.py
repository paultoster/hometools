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
# import tools.hfkt_type as htype
import tools.hfkt_file_path as hfp
import tools.hfkt_np_dataclass as hnpclass
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
                                self.Parobj.plot_euro_datei_ame + ".png")
        return
    def update(self):

        self.KontoObj.SetzeSonderEintragFlag()

        (summe_cash_cent,
         summe_steuer_cent,
         summe_kosten_cent) = self.KontoObj.EntnahmeVollstaendig()

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
    def erstelleDaten(self):


        # Bilde ein np_data_obj aus den Ergebnissen
        #-----------------------------------------
        # np_data_obj.np_dat_array
        # np_data_obj.np_dyears_array
        # np_data_obj.np_cash_array
        # np_data_obj.np_steuer_array
        # np_data_obj.np_kosten_array
        # np_data_obj.np_zins_array
        # np_data_obj.np_cash_mean_zins_array
        # np_data_obj.mean_zins

        np_data_obj = self.do_np_data()

        np_data_obj = self.do_zins_curve(np_data_obj)

        self.do_plots(np_data_obj)

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
    def do_zins_curve(self,np_data_obj):
        """
        np_data_obj = self.do_zins_curve(np_data_obj)

        add np_mean_zins_array

        :param np_data_obj:
        """

        # Startpunkt
        Kn_K0 = np_data_obj.np_cash_array[-1]/np_data_obj.np_cash_array[0]
        years = np_data_obj.np_dyears_array[-1]
        zins_fact = math.pow(Kn_K0, 1./years)
        mean_zins = zins_fact - 1.

        np_cash_mean_zins_array = np.array(np_data_obj.np_dyears_array)

        for index, x in np.ndenumerate(np_cash_mean_zins_array):
            np_cash_mean_zins_array[index] = (np_data_obj.np_cash_array[0] *
                                         math.pow(zins_fact,x))

        np_data_obj.add_signal(np_cash_mean_zins_array, "np_cash_mean_zins_array")
        np_data_obj.add_signal(mean_zins, "mean_zins")

        np_data_obj.save()

        return np_data_obj
    # end def
    def do_plots(self,np_data_obj):

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
        dict_data2["label"] = "cash_mzins"

        dict_subplot1 = {}
        dict_subplot1["name"] = "Cash"
        dict_subplot1["title"] = "Ergebnis"
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
        ddict["title"] = "Gesamtplot"
        ddict["title_add_date_range"] = True

        ddict["subplot_list"] = [dict_subplot1]

        dict_input = {}
        dict_input["plot"] = ddict
        dict_input["widget"] = False
        dict_input["show"] = False
        dict_input["plotfile"] = self.PlotEuroFilename

        obj = sgui.matplot_date_data_widget(dict_input)


        return
    # end def
# end class

