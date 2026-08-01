import os, sys



t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import wp_screen_param
import wp_screen_ini
# import wp_screen_gui
import wp_screen_katalog
import wp_screen_sigset
import wp_screen_tab
import wp_screen_scre

import wp_abfrage.wp_base as wp_base

import tools.hfkt_def as hdef
import tools.hfkt_log as hlog
import tools.sgui as sgui
import tools.sgui_protocol_class as sgui_prot



class WPScreen:
    """

    """

    def __init__(self,ini_filename:str,log_obj=None) -> None:

        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""

        self.kat: dict = {
                    "katalog_liste": [],
                    "katalog_liste_filename":"",
                    "katalog_liste_jsonobj": None,
                    "katalog": "",
                    "katalog_gruppe_isin_dict": {},
                    "katalog_gruppe_isin_dict_filename": "",
                    "katalog_gruppe_isin_dict_jsonobj":None}

        self.sig: dict = {
                    "sigset_liste": [],
                    "sigset_liste_filename": "",
                    "sigset_liste_jsonobj": None,
                    "sigset": "",
                    "sigset_dict": {},
                    "sigset_dict_filename": "",
                    "sigset_dict_jsonobj": None,
                    "sigset_werte_dict_liste": {} }
        self.tab: dict = {
                    "tab_liste": [],
                    "tab_liste_filename": "",
                    "tab_liste_jsonobj": None,
                    "tab": "",
                    "tab_dict": {},
                    "tab_dict_filename": "",
                    "tab_dict_jsonobj": None,
                    "tab_werte_dict_liste": {}}
        self.scre: dict = {
                    "scre_liste": [],
                    "scre_liste_filename": "",
                    "scre_liste_jsonobj": None,
                    "scre_dict": {},
                    "scre_dict_filename": "",
                    "scre_dict_jsonobj": None,
                    "scre_werte_dict_liste": {},
                    "scre_isin_dataclass_filename_dict": {},
                    "ttable_raw": None,
                    "ttable": None,
                    "color_dict_liste": []}

        # gui
        self.gui = sgui_prot.SguiProtocol()

        # Log-File start ---------------
        if log_obj is None:
            self.log = hlog.log(consol_func=True, log_window=False)
        else:
            self.log = log_obj
        # end if
        self.log_file_name = self.log.get_logfilename()

        # Parameter
        self.par = wp_screen_param.Param()

        # ini
        self.ini = wp_screen_ini.get_ini_dict(ini_filename, self.par.INI_DICT_PROOF_LISTE)

        if wp_screen_ini.get_status() != hdef.OK:
            self.log.write_e(wp_screen_ini.get_errtext(), screen=1)
            wp_screen_ini.reset_status()
            return
        # end if

        # wp_abfrage
        self.wpfunc = wp_base.WPData(ini_filename=self.ini["wp_func_ini_file_name"],
                                   log_obj=self.log)

        # setup katalog
        self.katalog_set()
        if self.status != hdef.OKAY:
            sgui.anzeige_text(self.errtext, textcolor='red')
            exit(1)
        # end if

        # setup sigset
        self.sigset_set()
        if self.status != hdef.OKAY:
            sgui.anzeige_text(self.errtext, textcolor='red')
            exit(1)
        # end if


        # setup tab
        self.tab_set()
        if self.status != hdef.OKAY:
            sgui.anzeige_text(self.errtext, textcolor='red')
            exit(1)
        # end if

        # setup scre
        self.scre_set()
        if self.status != hdef.OKAY:
            sgui.anzeige_text(self.errtext, textcolor='red')
            exit(1)
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
    def __del__(self) -> None:
        if hasattr(self, "log_file_name"):
            print(f"Siehe logfile: {self.log_file_name}")

        # close log-file
        self.log.close()

        # close protokoll
        self.gui.save()

        return
    # end def
    def katalog_set(self):
        """
        setup katalog

        """
        wp_screen_katalog.katalog_set(self)

        if wp_screen_katalog.get_status() != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = f"Error wp_screen_katalog.katalog_set(wp_obj) errtext = {wp_screen_katalog.get_errtext()}"
            self.log.write_err(self.errtext, screen=self.par.LOG_SCREEN_OUT)
        # end if
        return
    # end def
    def get_katalog_gruppe_isin_dict(self,katalog):
        """
        Gibt das dict für einen bestimmten katalog zurück
        """
        if katalog in self.kat["katalog_liste"]:
            self.kat["katalog"] = katalog

            wp_screen_katalog.katalog_gruppe_isin_dict_read(self)

            if wp_screen_katalog.get_status() != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = f"Error wp_screen_katalog.wp_screen_katalog_read_dict({katalog}) errtext = {wp_screen_katalog.get_errtext()}"
                self.log.write_err(self.errtext, screen=self.par.LOG_SCREEN_OUT)
                self.kat["katalog_gruppe_isin_dict"] = {}
            # end if
        else:
            self.status = hdef.NOT_OKAY
            self.errtext = f"Error wp_screen_katalog.wp_screen_katalog_read_dict({katalog}) errtext = katalog nicht vorhanden"
            self.kat["katalog_gruppe_isin_dict"] = {}
        # end if
        return self.kat["katalog_gruppe_isin_dict"]
    # end if

    def sigset_set(self):

        wp_screen_sigset.sigset_set(self)
        if wp_screen_sigset.get_status() != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = f"Error wp_screen_sigset.sigset_set(wp_obj) errtext = {wp_screen_sigset.get_errtext()}"
            self.log.write_err(self.errtext, screen=self.par.LOG_SCREEN_OUT)
        # end if
        return
    # end def
    def tab_set(self):

        wp_screen_tab.tab_set(self)
        if wp_screen_tab.get_status() != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = f"Error wp_screen_tab.tab_set(wp_obj) errtext = {wp_screen_tab.get_errtext()}"
            self.log.write_err(self.errtext, screen=self.par.LOG_SCREEN_OUT)
        # end if
        return
    # end def
    def scre_set(self):

        wp_screen_scre.scre_set(self)
        if wp_screen_scre.get_status() != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = f"Error wp_screen_tab.tab_set(wp_obj) errtext = {wp_screen_scre.get_errtext()}"
            self.log.write_err(self.errtext, screen=self.par.LOG_SCREEN_OUT)
        # end if
        return
    # end def
    def build_scre_sigset(self,scre_name):
        """

        """
        wp_screen_scre.setup_scre_name(self,scre_name)

        if wp_screen_scre.get_status() != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = f"Error wp_screen_base.setup_scre_name({scre_name}) errtext = {wp_screen_scre.get_errtext()}"
            self.log.write_err(self.errtext, screen=self.par.LOG_SCREEN_OUT)
            wp_screen_scre.reset_status()
            return
        # end if

        wp_screen_scre.scre_build_sigset(self, self.scre["scre_dict"])
        if wp_screen_scre.get_status() != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = f"Error wp_screen_base.build_scre_sigset({scre_name}) errtext = {wp_screen_scre.get_errtext()}"
            self.log.write_err(self.errtext, screen=self.par.LOG_SCREEN_OUT)
            wp_screen_scre.reset_status()
            return
        # end if

        return
    # end def
    def build_scre_rawtable(self,scre_name):

        wp_screen_scre.setup_scre_name(self,scre_name)

        if wp_screen_scre.get_status() != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = f"Error wp_screen_base.setup_scre_name({scre_name}) errtext = {wp_screen_scre.get_errtext()}"
            self.log.write_err(self.errtext, screen=self.par.LOG_SCREEN_OUT)
            wp_screen_scre.reset_status()
            return
        # end if

        rawtable = wp_screen_scre.scre_build_rawtable(self, self.scre["scre_dict"])

        if wp_screen_scre.get_status() != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = f"Error wp_screen_base.scre_build_rawtable({scre_name}) errtext = {wp_screen_scre.get_errtext()}"
            self.log.write_err(self.errtext, screen=self.par.LOG_SCREEN_OUT)
            wp_screen_scre.reset_status()
            return
        # end if
        return rawtable
    # end def