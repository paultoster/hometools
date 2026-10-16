import os, sys

import numpy as np

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_data_set as hdset
# import tools.hfkt_log as hlog
# import tools.hfkt_type as htype
# import tools.hfkt_np_calc as hnpcalc
import hfkt_np_dataclass as hnpclass

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

        # Dateiname array
        fbody = self.Parobj.np_datei_pre_name + self.Parobj.SimName
        filename = os.path.join(self.Parobj.store_path, fbody + ".joblib")

        # numpy-Dateset anlegen
        np_data_obj = hnpclass.NpDataHandlingClass(filename)

        # Arrays aus Tabelle
        dat_liste = self.ErgDataSet.get_row_list_of_header(self.NAME_ERG_TAB_DATUM,
                                                                "dat")
        cash_liste = self.ErgDataSet.get_row_list_of_header(self.NAME_ERG_TAB_CASH)
        stuer_liste = self.ErgDataSet.get_row_list_of_header(self.NAME_ERG_TAB_STEUER)
        kosten_liste = self.ErgDataSet.get_row_list_of_header(self.NAME_ERG_TAB_KOSTEN)
        zins_liste = self.ErgDataSet.get_row_list_of_header(self.NAME_ERG_TAB_ZINS)

        np_dat_array = np.array(dat_liste)
        np_cash_array = np.array(cash_liste)
        np_steur_array = np.array(stuer_liste)
        np_kosten_array = np.array(kosten_liste)
        np_zins_array = np.array(zins_liste)

        np_data_obj.add_signal(np_dat_array, "dat_np_array")
        np_data_obj.add_signal(np_cash_array, "np_cash_array")
        np_data_obj.add_signal(np_steur_array, "np_stuer_array")
        np_data_obj.add_signal(np_kosten_array, "np_kosten_array")
        np_data_obj.add_signal(np_zins_array, "np_zins_array")

        # Datei speichern joblib und csv
        np_data_obj.save()
        ddict = {"dat_np_array":"datStrP",
                 "np_cash_array":"euroStrK",
                 "np_stuer_array":"euroStrK",
                 "np_kosten_array":"euroStrK",
                 "np_zins_array":"percentStr"}
        np_data_obj.save_to_csv(ddict)


# end class

