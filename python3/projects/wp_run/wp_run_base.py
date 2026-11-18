import os, sys
import datetime
import subprocess

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_log as hlog
import tools.hfkt_ini as hini
import tools.hfkt_io as hio
import tools.hfkt_date_time as hdt
import copy_backup.copy_backup as copy_backup

import wp_screen.wp_screen_base as wp_screen_base

INI_DICT_PROOF_LISTE =   [("store_path", "str"),
                          ("steuer_file_name","str"),
                          ("parameter_file_name","str")]

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
class WPRun:
    """

    """

    def __init__(self,base_path:str,log_obj=None) -> None:

        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""

        self.act_time_str = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        self.ini_file = os.path.join(base_path, "wp.ini")

        # Ini
        self.ini = hini.get_section_of_ini_file(self.ini_file, "wp_run",
                                                ("@base_path@", base_path),
                                                INI_DICT_PROOF_LISTE)

        if hini.get_status() != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = f"WPRun: ini-error: {hini.get_errtext()}"
            hini.reset_status()
            print(self.errtext)
            return
        # end if

        # Log-File start
        # ---------------
        if log_obj is None:
            log_file = build_log_file_name(self.ini["store_path"], "wp_run", self.act_time_str)
            self.log = hlog.log(log_file=log_file,consol_func=True, log_window=False)
        else:
            self.log = log_obj
        # end if
        self.log_file_name = self.log.get_logfilename()



        # wp_screen
        # ----------
        self.wpscrefunc = wp_screen_base.WPScreen(base_path=base_path,log_obj=self.log)

        if self.wpscrefunc.get_status() != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.wpscrefunc.get_errtext()
            self.wpscrefunc.reset_status()
            print(self.errtext)
            return
        # end if


        self.yamlobj = hio.DataYaml(self.ini["parameter_file_name"])

        if self.yamlobj.exist_file():
            self.yaml_dict = self.yamlobj.read_and_get_data()
        else:
            self.yaml_dict = {}
        # end if

        return
    # end def
    def last(self):

        self.log.write_info(f"save self.yamlobj", screen=1)
        self.yamlobj.save(self.yaml_dict)

        self.log.write_info(f"close self.log", screen=1)
        self.log.close()
    # end def
    def run(self):

        self.log.write_info("run",screen=1)

        self.run_WP_Screen()

        self.yamlobj.save(self.yaml_dict)

        self.run_Shutdown()

        return
    # end def
    def run_WP_Screen(self):

        self.log.write_info(f"UpdateWP: {self.yaml_dict["UpdateWP"]}", screen=1)
        self.log.write_info(f"UpdateScreen: {self.yaml_dict["UpdateScreen"]}", screen=1)

        if  self.yaml_dict["UpdateWP"] or self.yaml_dict["UpdateScreen"] or self.yaml_dict["UpdateSave"]:

            (trigger,act_datetime) = self.triggerNextDate()

            if self.yaml_dict["UpdateWP"] and trigger:

                self.wpscrefunc.execute_WP_update()

                if len(self.wpscrefunc.get_infotext()):
                    self.infotext = f"Info run_WP_Screen() \n infotext = {self.wpscrefunc.get_infotext()}"
                    self.log.write_info(self.infotext)

                # end if

                if self.wpscrefunc.get_status() != hdef.OKAY:
                    self.status = hdef.NOT_OKAY
                    self.errtext = f"Error run_WP_Screen() \n errtext = {self.wpscrefunc.get_errtext()}"
                    self.log.write_err(self.errtext)
                # end if

                self.wpscrefunc.reset_status()
            # end if

            if self.yaml_dict["UpdateScreen"] and trigger: #

                self.wpscrefunc.execute_update_scre_sigset(no_scre_name=self.yaml_dict["ScreDoNotBuild"])

                if len(self.wpscrefunc.get_infotext()):
                    self.infotext = f"Info run_WP_Screen() \n infotext = {self.wpscrefunc.get_infotext()}"
                    self.log.write_info(self.infotext)

                # end if

                if self.wpscrefunc.get_status() != hdef.OKAY:
                    self.status = hdef.NOT_OKAY
                    self.errtext = f"Error run_WP_Screen() \n errtext = {self.wpscrefunc.get_errtext()}"
                    self.log.write_err(self.errtext)
                # end if
                self.wpscrefunc.reset_status()
            # end if

            if trigger:
                self.yaml_dict["LastUpdate"] = act_datetime.strftime("%d.%m.%Y")

            if self.yaml_dict["UpdateSave"]:
                self.updateSaveData()
            # end if

        return
    # end def
    def triggerNextDate(self):
        """

        :return: self.next_date_datetime = self.triggerNextDate()
        """
        trigger = False
        act_datetime = datetime.datetime.now()

        key = "LastUpdate"
        if key in self.yaml_dict.keys():
            last_update_datetime = datetime.datetime.strptime(self.yaml_dict[key] , "%d.%m.%Y")
        else:
            exact_act_datetime = datetime.datetime(act_datetime.year,act_datetime.month,act_datetime.day)
            last_update_datetime = hdt.get_last_weekday(exact_act_datetime,self.yaml_dict["UpdateTag"])
        # end if

        next_update_datetime = hdt.get_next_weekday(last_update_datetime, self.yaml_dict["UpdateTag"])

        if act_datetime >= next_update_datetime:

            self.log.write_info(f"trigger = True da act_datetime:{act_datetime.strftime('%d.%m.%Y')} >= next_update_datetime {next_update_datetime.strftime('%d.%m.%Y')}", screen=1)

            trigger = True
        else:
            self.log.write_info(f"trigger = False da act_datetime:{act_datetime.strftime('%d.%m.%Y')} < next_update_datetime {next_update_datetime.strftime('%d.%m.%Y')}", screen=1)

        # end if

        return (trigger,act_datetime)
    # end def

    def run_Shutdown(self):


        yamlsdobj = hio.DataYaml(self.ini["steuer_file_name"])

        if yamlsdobj.exist_file():
            yamlsd_dict = yamlsdobj.read_and_get_data()
        else:
            yamlsd_dict = {"ShutdownAtEnd":False}
        # end if

        self.log.write_info(f"ShutdownAtEnd: {yamlsd_dict["ShutdownAtEnd"]}", screen=1)

        if yamlsd_dict["ShutdownAtEnd"]:

            self.last()

            # os.system("shutdown /s /t 60")
            try:
                retcode = subprocess.call("shutdown /s /t 60", shell=True)
                if retcode < 0:
                    print("Child was terminated by signal", -retcode, file=sys.stderr)
                else:
                    print("Child returned", retcode, file=sys.stderr)
            except OSError as e:
                print("Execution failed:", e, file=sys.stderr)
            # end try
        # end if
        return
    # end def
    def updateSaveData(self):


        # wp_abfrage
        #-----------

        ddict = {}

        # Quellpafad
        ddict[copy_backup.NAME_SOURCE_PATH] = "D:\\data\\wp\\wp_abfrage"
        # Zielpfad
        ddict[copy_backup.NAME_TARGET_PATH] = os.path.join("X:\\Samsung-SSD850EVO1TB-01\\wp_datenpool",f"wp_abfrage_{self.act_time_str}")
        # Ausschlusspfade
        # ddict[copy_backup.NAME_EXCLUDE_ABS_PATH_LIST] = ["data/SmartSwitch"]
        # ddict[copy_backup.NAME_EXCLUDE_REL_PATH_LIST] = ["$RECYCLE.BIN"]
        # Ausschlussextensions
        ddict[copy_backup.NAME_EXCLUDE_EXT_LIST] = [".obj", "bak"]
        ddict[copy_backup.NAME_EXACT_COPY_FLAG] = 0

        # ddict[copy_backup.NAME_COPY_ALWAYS_FILE_LIST] = ["pdata"]

        copyobj = copy_backup.copybackup(ddict)
        if (copyobj.STATUS == copy_backup.OKAY):
            copyobj.make_backup()
        # end if

        # wp_abfrage
        #-----------

        ddict = {}

        # Quellpafad
        ddict[copy_backup.NAME_SOURCE_PATH] = "D:\\data\\wp\\wp_screen"
        # Zielpfad
        ddict[copy_backup.NAME_TARGET_PATH] = os.path.join("X:\\Samsung-SSD850EVO1TB-01\\wp_datenpool",f"wp_screen_{self.act_time_str}")
        # Ausschlusspfade
        # ddict[copy_backup.NAME_EXCLUDE_ABS_PATH_LIST] = ["data/SmartSwitch"]
        # ddict[copy_backup.NAME_EXCLUDE_REL_PATH_LIST] = ["$RECYCLE.BIN"]
        # Ausschlussextensions
        ddict[copy_backup.NAME_EXCLUDE_EXT_LIST] = [".obj", "bak"]
        ddict[copy_backup.NAME_EXACT_COPY_FLAG] = 0

        # ddict[copy_backup.NAME_COPY_ALWAYS_FILE_LIST] = ["pdata"]

        copyobj = copy_backup.copybackup(ddict)
        if (copyobj.STATUS == copy_backup.OKAY):
            copyobj.make_backup()
        # end if

        return
    # end def
# end class