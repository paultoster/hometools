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

class WPErg:
    """

    """
    def __init__(self,
                 parobj,
                 dataobj,
                 kontoobj) -> None:

        # referenz
        #---------
        self.Parobj = parobj
        self.DataObj = dataobj
        self.KontoObj = kontoobj

        return
    def update(self):

        self.KontoObj.SetzeSonderEintragFlag()

        (summe_cash_cent,
         summe_steuer_cent,
         summe_kosten_cent) = self.KontoObj.EntnahmeVollstaendig()

        

        return
    # end def
# end class

