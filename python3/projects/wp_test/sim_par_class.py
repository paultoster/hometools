import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_log as hlog
import tools.hfkt_type as htype
import tools.hfkt_np_calc as hnpcalc

import konto_class
import trigger_datum_class
import sim_data_class

class WPSimPar:
    """

    """

    def __init__(self,parstruct) -> None:

        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""

        for name,value in parstruct.__dict__.items():
            setattr(self,name,value)

        # Start, End und Act
        # ------------------
        self.StartDat_datetime = htype.type_transform_direct(parstruct.StartDat_str, "datStrP", "datetimeclass")
        self.EndDat_datetime   = htype.type_transform_direct(parstruct.EndDat_str, "datStrP", "datetimeclass")


        # Start Cash festlegen
        #---------------------
        self.StartCash_cent = htype.type_transform_direct(parstruct.StartCash, "euroStrK", "cent")

        # Depotpruefung
        #--------------
        if len(self.Katalog.keys()) == 0:
            self.DepotKontoPruefung = False
        else:
            self.DepotKontoPruefung = True
        # end if


    def get_status(self):
        return self.status
    # end def
    def get_errtext(self):
        return self.errtext
    # end def
    def get_infotext(self):
        return self.infotext
    # end def
    def reset_status(self):
        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""
        return
    # end def

