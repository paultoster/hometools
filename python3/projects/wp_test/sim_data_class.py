import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
# import tools.hfkt_log as hlog
import tools.hfkt_type as htype
# import tools.hfkt_np_calc as hnpcalc

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
        if parobj.ZinsKontoPruefung:

            # Datensatz für ezb-zins anlegen
            self.WPscrefunc.build_ezbzins_sigset()

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

            # Zins Startdatum abfragen
            self.AktZins_float = self.WPscrefunc.get_ezbzins(htype.type_transform_direct(self.Parobj.StartDat_datetime, "datetimeclass", "dat"))

            # bei Negativzins auf null setzen
            if self.AktZins_float < 0.0:
                self.AktZins_float = 0.0
            # end if
        else:
            self.AktZins_float = 0.0
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

# end class
