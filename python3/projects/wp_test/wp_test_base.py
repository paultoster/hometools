import os, sys
import copy

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_log as hlog
import tools.hfkt_ini as hini
# import tools.hfkt_type as htype

import wp_screen.wp_screen_base as wp_screen_base
import wp_test_param
import sim_class

INI_DICT_PROOF_LISTE =   [("store_path", "str"),
                          ("wpscre_func_ini_file_name","str"),
                          ("tage_pro_jahr","int","int",365.),
                          ("ergebnis_path_pre_name","str","str","erg_"),
                          ("np_datei_name","str","str","erg_array"),
                          ("plot_euro_datei_ame","str","str","erg_plot_euro")]

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
        (self.par_struct_liste,self.comment_struct) = wp_test_param.set_param(self,param_filename)

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

        n = len(self.par_struct_liste)
        for i,parstruct in enumerate(self.par_struct_liste):

            self.wpscrefunc.reset_status()

            if n > 1:
                parstruct.SimName += "_" + str(i)

            self.log.write_info(f"{i+1}/{n}: Start Simulation: {parstruct.SimName} von {parstruct.StartDat_str} - {parstruct.EndDat_str}")

            # ini-Parameter dazu schreiben
            #-----------------------------
            for (key,item) in self.ini.items():
                if not hasattr(parstruct, key):
                    parstruct.__setattr__(key, copy.copy(item))
                # end if
            # end for

            # Init Simulation
            #----------------
            self.Simobj = sim_class.WPSim(self.wpscrefunc,parstruct)

            if self.Simobj.get_status() != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = self.Simobj.get_errtext()
                self.log.write_err(self.errtext)
                self.Simobj.reset_status()
                return
            # end if

            if len(self.Simobj.get_infotext()):
                self.log.write_info(self.Simobj.get_infotext())
                self.Simobj.reset_status()
            # end if

            if self.status != hdef.OKAY:
                return

            # Run simulation
            #--------------
            self.Simobj.run()

            if self.Simobj.get_status() != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = self.Simobj.get_errtext()
                self.log.write_err(self.errtext)
                self.Simobj.reset_status()
                return
            # end if

            # Ergebnisauflistung
            #-------------------
            self.Simobj.ergebnis()

            if self.Simobj.get_status() != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = self.Simobj.get_errtext()
                self.log.write_err(self.errtext)
                self.Simobj.reset_status()
                return
            # end if

            if self.status != hdef.OKAY:
                return

    # end def
# end class