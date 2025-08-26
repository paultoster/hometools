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

status = hdef.OKAY
errtext = ""
logtext = ""


class ini:
    status = hdef.OKAY
    
    def __init__(self, par, ini_file_name):
        
        self.errtext = ""
        self.logtext = ""
        
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
        (self.status,self.errtext,_) = hdict.proof_transform_ddict(self.ddict, par.INI_BASE_PROOF_LISTE)
        if self.status != hdef.OK:
            return
        # endif
        
        # check konotonames
        if self.check_kontodata(par) != hdef.OK:
            return
        # endif
        
        # check csv import
        if self.check_csv_import(par) != hdef.OK:
            return
        # endif
        
        # endif
    
    # enddef
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
            # end if
            
            (self.status, self.errtext, self.ddict[kontoname]) = hdict.proof_transform_ddict(self.ddict[kontoname], par.INI_KONTO_PROOF_LISTE)
            if self.status != hdef.OK:
                return hdef.NOT_OKAY
            # endif

            # Bilde/Prüfe Zusatzwerte
            # ------------------------
            
            # aus start_dutum => start_tag und start_zeit
            (start_tag, start_zeit) = hdt.secs_time_epoch_to_epoch_day_time(self.ddict[kontoname][par.INI_START_DATUM_NAME])
            
            self.ddict[kontoname][par.INI_START_TAG_NAME] = start_tag
            self.ddict[kontoname][par.INI_START_ZEIT_NAME] = start_zeit
            
            return self.status
        # end for
        
        return self.status
    # enddef
    def check_csv_import(self, par):
        """
        check csv_import_type sections from ini-file
        :return: status = self.check_csv_import(par)
        """
        
        for csv_import_config in self.ddict[par.INI_CSV_IMPORT_CONFIG_NAMES_NAME]:
            
            if csv_import_config not in self.ddict:
                self.status = hdef.NOT_OKAY
                self.add_err_text(
                    f"In inifile {self.ini_file_name} ist csv-import-Sektion [{csv_import_config}] nicht vorhanden !!!!")
                return self.status
            
            (self.status, self.errtext, self.ddict[csv_import_config]) = hdict.proof_transform_ddict(self.ddict[csv_import_config],
                                                                                             par.INI_CSV_PROOF_LISTE)
            
            if self.status != hdef.OK:
                return hdef.NOT_OKAY
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
