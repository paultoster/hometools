import os, sys
import datetime

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_log as hlog
import tools.hfkt_type as htype
import tools.hfkt_np_calc as hnpcalc

import sim_par_class
import konto_class
import trigger_datum_class
import sim_data_class
import sim_pruef_class

class WPSim:
    """

    """

    def __init__(self,
                 wpscrefunc,
                 parstruct,
                 ) -> None:

        self.Parobj = sim_par_class.WPSimPar(parstruct)

        # Prüf Datum (Prüfen der anlage)
        #-------------------------------
        self.PruefDatumtObj = trigger_datum_class.WPTriggerDatum(self.Parobj.StartDat_datetime,
                                                                 self.Parobj.EndDat_datetime,
                                                                 self.Parobj.ErsterTagPruefung,
                                                                 self.Parobj.WiederholTagPruefung)

        if self.PruefDatumtObj.get_status() != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.PruefDatumtObj.get_errtext()
            self.PruefDatumtObj.reset_status()
            return
        # end if

        # Ergebnis Datum (Zwischergebnis produzieren)
        #--------------------------------------------
        self.ErgebnisDatumtObj = trigger_datum_class.WPTriggerDatum(self.Parobj.StartDat_datetime,
                                                                    self.Parobj.EndDat_datetime,
                                                                    self.Parobj.ErsterTagErgebnis,
                                                                    self.Parobj.WiederholTagErgebnis)

        if self.ErgebnisDatumtObj.get_status() != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.ErgebnisDatumtObj.get_errtext()
            self.ErgebnisDatumtObj.reset_status()
            return
        # end if

        # Zinsabrechnung Datum
        #--------------------------------------------
        self.ZinsAbrechnungDatumtObj = trigger_datum_class.WPTriggerDatum(self.Parobj.StartDat_datetime,
                                                                          self.Parobj.EndDat_datetime,
                                                                          self.Parobj.ErsterTagZinsAbrechnung,
                                                                          self.Parobj.WiederholTagZinsAbrechnung)

        if self.ZinsAbrechnungDatumtObj.get_status() != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.ZinsAbrechnungDatumtObj.get_errtext()
            self.ZinsAbrechnungDatumtObj.reset_status()
            return

        # end if


        # Daten-Objekt bilden
        #---------------------
        self.DataObj = sim_data_class.WPData(wpscrefunc, self.Parobj)

        if self.Parobj.get_status() != hdef.OKAY:
            return
        # end if

        # Konto erstellen
        #-----------------
        self.KontoObj = konto_class.WPKonto(self.Parobj,
                                            self.DataObj)

        if self.Parobj.get_status() != hdef.OKAY:
            return
        # end if

        # Pruef
        #-----
        self.PruefObj = sim_pruef_class.WPPruef(wpscrefunc,
                                                self.Parobj,
                                                self.DataObj,
                                                self.KontoObj)

        return
    # end def
    def get_status(self):
        return self.Parobj.status
    # end def
    def get_errtext(self):
        return self.Parobj.errtext
    # end def
    def get_infotext(self):
        return self.Parobj.infotext
    # end def
    def reset_status(self):
        self.Parobj.reset_status()
        return
    # end def
    def run(self):

        self.Dataobj.AktDat_datetime += datetime.timedelta(days=1)

        while self.Dataobj.AktDat_datetime != self.Parobj.EndDat_datetime:

            # Trigger
            #--------
            pruefTrigger    = self.PruefDatumtObj.triggerStatus(self.Dataobj.AktDat_datetime)
            ergebnisTrigger = self.ErgebnisDatumtObj.triggerStatus(self.Dataobj.AktDat_datetime)
            zinsabrechnungTrigger = self.ZinsAbrechnungDatumtObj.triggerStatus(self.Dataobj.AktDat_datetime)

            # Daten updaten
            #--------------
            self.DataObj.update()



            # Zinsabrechnung
            if zinsabrechnungTrigger:
                print(f"zinsTrigger: {self.Dataobj.AktDat_datetime.strftime("%d.%m.%Y,}")}")
                self.ZinsAbrechnungDatumtObj.setNextTriggerDay()
            # end if

            # Pruefen
            if pruefTrigger:
                print(f"pruefTrigger: {self.Dataobj.AktDat_datetime.strftime("%d.%m.%Y,}")}")
                self.PruefObj.update()
                if self.Parobj.status != hdef.STATUS_OK:
                    return
                self.PruefDatumtObj.setNextTriggerDay()
            # end if

            # Ergebnis
            #-----------
            if ergebnisTrigger:
                print(f"ergebnisTrigger: {self.Dataobj.AktDat_datetime.strftime("%d.%m.%Y,}")}")
                self.ErgebnisDatumtObj.setNextTriggerDay()
            # end if

            # Update den Tag
            self.Dataobj.AktDat_datetime += datetime.timedelta(days=1)
        # end while

        return
    # end def