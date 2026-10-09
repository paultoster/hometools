import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_log as hlog
import tools.hfkt_ini as hini


import wp_screen.wp_screen_base as wp_screen_base
import wp_test_param
import wp_test_sim_class

INI_DICT_PROOF_LISTE =   [("store_path", "str"),
                          ("wpscre_func_ini_file_name","str")]

class WPTest:
    """

    """

    def __init__(self,param_filename:str,ini_filename:str,log_obj=None) -> None:

        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""

        # Log-File start
        # ---------------
        if log_obj is None:
            self.log = hlog.log(consol_func=True, log_window=False)
        else:
            self.log = log_obj
        # end if
        self.log_file_name = self.log.get_logfilename()

        # ini
        self.ini = hini.get_tomlib_ini_dict(ini_filename, INI_DICT_PROOF_LISTE)

        # Parameter
        # ---------
        self.par_liste = wp_test_param.set_param(self,param_filename)

        if self.status != hdef.OKAY:
            self.log.write_err(self.errtext)
            return
        # end if

        # wp_screen
        # ----------
        self.wpscrefunc = wp_screen_base.WPScreen(ini_filename=self.ini["wpscre_func_ini_file_name"],
                                                  log_obj=self.log)

        if self.wpscrefunc.get_status() != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.wpscrefunc.get_errtext()
            self.log.write_err(self.errtext)
            self.wpscrefunc.reset_status()
            return
        # end if


        return
    # end def
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

    def run(self):
        self.reset_status()

        n = len(self.par_liste)
        for i,par in enumerate(self.par_liste):
            self.log.write_info(f"{i+1}/{n}: Start Simulation: {par.SimName} von {par.Start} - {par.End}")

            simobj = wp_test_sim_class.WPSim(par)

            if simobj.get_status() != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = self.wp_test_sim_class.get_errtext()
                self.log.write_err(self.errtext)
                self.wp_test_sim_class.reset_status()
                return

        return
    # end def
# end class