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
            pass
        # end if


        if self.Parobj.ZinsKontoPruefung:
            self.update_zinskonto_einzahlung()
            if self.Parobj.status != hdef.STATUS_OK:
                return
            # end if
        # end if
        return
    # end def
    def update_zinskonto_einzahlung(self):

        # Was auf dem Verrechnungskonto liegt wird auf das Zins konto eingezahlt
        cash_cent = self.KontoObj.KontoVerrechnung.get_konto_summe()
        if self.Parobj.status != hdef.STATUS_OK:
            return

        if cash_cent > 0:
            cash_cent = self.KontoObj.uebreweise_von_Verrechnung_auf_Zins(cash_cent)

        return
    # end def


