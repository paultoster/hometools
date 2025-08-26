# -*- coding: cp1252 -*-
#
# read ini-file and proof sections for kontodata, ...
#
# data.structure
#
#


import os, sys
import tomllib

tools_path = os.getcwd() + "\\.."
if tools_path not in sys.path:
    sys.path.append(tools_path)
# endif

# Hilfsfunktionen
import hfkt_def as hdef
import hfkt_type as htype
import hfkt_date_time as hdt
import hfkt_dict as hdict
import hfkt_tvar as htvar

status = hdef.OKAY
errtext = ""
logtext = ""


class ini:
    status = hdef.OKAY
    
    def __init__(self, par, ini_file_name):
        
        self.errtext = ""
        self.logtext = ""
        self.dict_tvar = {}
        
        # check ini-filename
        if (not os.path.isfile(ini_file_name)):
            self.status = hdef.NOT_OKAY
            self.add_err_text(f"ini_file_name = {ini_file_name} does not exist !!!!")
            return
        
        # read ini-file
        else:
            self.ini_file_name = ini_file_name
            with open(ini_file_name, "rb") as f:
                self.ddict = tomllib.load(f)
        # endif
        
        # check base input
        (self.status, self.errtext, dict_tvar) = hdict.proof_transform_ddict_to_tvar(self.ddict, par.INI_BASE_PROOF_LISTE)
        if self.status != hdef.OK:
            return
        else:
            self.dict_tvar = hdict.add_dict_to_dict(self.dict_tvar,dict_tvar)
        # endif
        
        # check konotonames
        if self.check_kontodata(par) != hdef.OK:
            return
        # endif
        
        # check depotnames
        if self.check_depotdata(par) != hdef.OK:
            return
        
        # check csv import
        if self.check_csv_import(par) != hdef.OK:
            return
        # endif
        
        # endif
    
    # enddef
    # def check_allg_data(self, par):
    #     '''
    #
    #     :param par:
    #     :return:
    #     '''
    #
    #     for allg_section in self.ddict[par.INI_ALLG_DATA_DICT_NAMES_NAME]:
    #         if allg_section == par.INI_IBAN_DATA_NAME:
    #             (self.status, self.errtext, self.ddict[allg_section]) = hdict.proof_transform_ddict(
    #                 self.ddict[allg_section], par.INI_IBAN_DATA_PROOF_LISTE)
    #             if self.status != hdef.OK:
    #                 return self.status
    #         elif allg_section == par.INI_WP_DATA_NAME:
    #             (self.status, self.errtext, self.ddict[allg_section]) = hdict.proof_transform_ddict(
    #                 self.ddict[allg_section], par.INI_WP_DATA_PROOF_LISTE)
    #             if self.status != hdef.OK:
    #                 return self.status
    #         else:
    #             self.status = hdef.NOT_OKAY
    #             self.add_err_text(
    #                 f"ini-check: für die section {allg_section} gibt es keine proof liste inifile: {self.ini_file_name}")
    #             return self.status
    #         # end if
    #     # end for
    #
    #     return self.status
    #
    # # end def
    def check_kontodata(self, par):
        """
        check kontonames sections from ini-file
        :return: status = self.check_kontodata(par)
        """
        
        for kontoname in self.ddict[par.INI_KONTO_DATA_DICT_NAMES_NAME]:
            
            if kontoname not in self.ddict:
                self.status = hdef.NOT_OKAY
                self.add_err_text(
                    f"In inifile {self.ini_file_name} ist Konto-Sektion [{kontoname}] nicht vorhanden !!!!")
                return self.status
            
            (self.status, self.errtext, dict_tvar) = hdict.proof_transform_ddict_to_tvar(self.ddict[kontoname],
                                                                                             par.INI_KONTO_PROOF_LISTE)
            if self.status != hdef.OK:
                return hdef.NOT_OKAY
            else:
                self.dict_tvar[kontoname] = dict_tvar
            # endif

            # Bilde/Prüfe Zusatzwerte
            # ------------------------
            
            # aus start_dutum => start_tag und start_zeit
            start_date = htvar.get_val(self.dict_tvar[kontoname][par.INI_START_DATUM_NAME],'dat')
            (start_tag, start_zeit) = hdt.secs_time_epoch_to_epoch_day_time(start_date)
            
            self.dict_tvar[kontoname][par.INI_START_TAG_NAME] = htvar.build_val(par.INI_START_TAG_NAME,start_tag,'dat')
            self.dict_tvar[kontoname][par.INI_START_ZEIT_NAME] = htvar.build_val(par.INI_START_TAG_NAME,start_zeit,'dat')
        
        # endfor
        
        return self.status
    
    # enddef
    def check_depotdata(self, par):
        """
        check kontonames sections from ini-file
        :return: status
        """
        for depotname in self.ddict[par.INI_DEPOT_DATA_DICT_NAMES_NAME]:
            
            if depotname not in self.ddict:
                self.status = hdef.NOT_OKAY
                self.add_err_text(
                    f"In inifile {self.ini_file_name} ist Depot-Sektion [{depotname}] nicht vorhanden !!!!")
                return self.status
            
            (self.status, self.errtext, dict_tvar) = hdict.proof_transform_ddict_to_tvar(self.ddict[depotname],
                                                                                             par.INI_DEPOT_PROOF_LISTE)
            if self.status != hdef.OK:
                return hdef.NOT_OKAY
            else:
                self.dict_tvar[depotname] = dict_tvar
            # endif
        # endfor
        
        return self.status
    
    # enddef
    def check_csv_import(self, par):
        """
        check csv_import_config sections from ini-file
        :return: status = self.check_csv_import(par)
        """
        
        for csv_import_config in self.ddict[par.INI_CSV_IMPORT_CONFIG_NAMES_NAME]:
            
            if csv_import_config not in self.ddict:
                self.status = hdef.NOT_OKAY
                self.add_err_text(
                    f"In inifile {self.ini_file_name} ist csv-import-Sektion [{csv_import_config}] nicht vorhanden !!!!")
                return self.status
            
            (self.status, self.errtext, dict_tvar) = hdict.proof_transform_ddict_to_tvar(self.ddict[csv_import_config],
                                                                                             par.INI_CSV_PROOF_LISTE)
            if self.status != hdef.OK:
                return hdef.NOT_OKAY
            else:
                self.dict_tvar[csv_import_config] = dict_tvar
            # endif

        # endfor
        
        return self.status
    
    # enddef
    # -----------------------------------------------------------------------------
    # internal add_err_text
    # -----------------------------------------------------------------------------
    def add_err_text(self, text: str) -> None:
        """
        add error text
    
        :param text:
        :return:
        """
        if len(self.errtext) > 0:
            self.errtext += "\n" + text
        else:
            self.errtext += text
    
    # enddef
    # -----------------------------------------------------------------------------
    # public get_err_text
    # -----------------------------------------------------------------------------
    def get_err_text(self) -> str:
        """
        get erro text reurned and reset internally
        :return:
        """
        err_text = self.errtext
        self.errtext = ""
        return err_text
    
    # -----------------------------------------------------------------------------
# enddef
