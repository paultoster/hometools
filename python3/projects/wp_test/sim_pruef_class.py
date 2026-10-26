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

            if len(self.DataObj.WPScreDictList):

                # print(self.DataObj.WPScreDictList)

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


