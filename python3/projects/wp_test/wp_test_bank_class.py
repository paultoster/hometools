import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_log as hlog
# import tools.hfkt_type as htype
# import tools.hfkt_np_calc as hnpcalc

import wp_test_cash_konto_class


class WPBank:
    """

    """

    def __init__(self,start_dat_datclass,start_cash_cent) -> None:

        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""


        # Cashkonto anlegen
        #------------------
        self.CashKonto = wp_test_cash_konto_class.WPCashKonto("Cashkonto",start_dat_datclass,start_cash_cent)




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
