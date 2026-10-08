import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_log as hlog

import wp_test_param

class WPTest:
    """

    """

    def __init__(self,param_filename:str,log_obj=None) -> None:

        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""

        # Log-File start ---------------
        if log_obj is None:
            self.log = hlog.log(consol_func=True, log_window=False)
        else:
            self.log = log_obj
        # end if
        self.log_file_name = self.log.get_logfilename()

        # Parameter
        self.par_liste = wp_test_param.set_param(self,param_filename)

        if self.status != hdef.OKAY:
            self.log.write_err(self.errtext)
            return

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
        return
    # end def
# end class