import os, sys
import copy
import datetime

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_log as hlog
import tools.hfkt_ini as hini
# import tools.hfkt_type as htype

import wp_test.wp_test_def as wpdef
import wp_screen.wp_screen_base as wp_screen_base
import wp_test.wp_test_param as wp_test_param
import wp_test.sim_class as sim_class

def build_log_file_name(store_path,parametername,act_time_str):
    """

    :param store_path:
    :param parametername:
    :return: log_file = build_log_file_name(store_path,parametername)
    """


    p = os.path.join(store_path,"log_"+parametername)
    if not os.path.exists(p):
        os.makedirs(p)
    # end if

    log_file = os.path.join(p,"log_"+parametername+"_"+act_time_str+".log")
    return log_file
# end if
def build_log_file_name(store_path,parametername,act_time_str):
    """

    :param store_path:
    :param parametername:
    :return: log_file = build_log_file_name(store_path,parametername)
    """


    p = os.path.join(store_path,"log_"+parametername)
    if not os.path.exists(p):
        os.makedirs(p)
    # end if

    log_file = os.path.join(p,"log_"+parametername+"_"+act_time_str+".log")
    return log_file
# end if
class WPTest:
    """

    """

    def __init__(self,base_path:str,log_obj=None) -> None:

        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""

        self.par_struct_liste = []
        self.comment_struct = None

        self.act_time_str = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        self.ini_file     = os.path.join(base_path,"wp.ini")

        # ini
        self.ini = hini.get_section_of_ini_file(self.ini_file,"wp_test",("@base_path@",base_path),wpdef.INI_DICT_PROOF_LISTE)

        if hini.get_status() != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = f"WPTest: ini-error: {hini.get_errtext()}"
            hini.reset_status()
            print(self.errtext)
            return
        # end if

        # Log-File start
        # ---------------
        if log_obj is None:
            log_file = build_log_file_name(self.ini["store_path"], "wp_test", self.act_time_str)
            self.log = hlog.log(consol_func=True, log_window=False)
        else:
            self.log = log_obj
        # end if
        self.log_file_name = self.log.get_logfilename()



        # wp_screen
        # ----------
        self.wpscrefunc = wp_screen_base.WPScreen(base_path=base_path,
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
    def set_param(self,param_filename:str=None,par_struct_liste:list=None):

        if (param_filename is None) and (par_struct_liste is None):
            raise Exception(f"param_filename and par_struct_liste are both None")
        # end if

        if param_filename is not None:
            # Parameter
            # ---------
            (self.par_struct_liste,self.comment_struct) = wp_test_param.set_param(self,param_filename)

            if self.status != hdef.OKAY:
                self.log.write_err(self.errtext)
                return
            # end if

        else:
            self.par_struct_liste = par_struct_liste

        # end if
        return
    # end if
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
            self.Simobj = sim_class.WPSim(self.wpscrefunc,parstruct,self.log)

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
    def get_ferror(self):
        return self.Simobj.get_ferror()
# end class