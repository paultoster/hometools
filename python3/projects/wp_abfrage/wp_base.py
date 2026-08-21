import os, sys, time
import tomllib
import pandas as pd


t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

from wp_abfrage import wp_fkt as wp_fkt
from wp_abfrage import wp_wkn as wp_wkn
from wp_abfrage import wp_storage as wp_storage
from wp_abfrage import wp_yahoofinance as wp_yfinance
from wp_abfrage import wp_bearbeiten as wp_bearbeiten
from wp_abfrage import wp_base_indices as wp_base_indices
from wp_abfrage import wp_base_basic_info as wp_base_basic_info
from wp_abfrage import wp_base_price_volume
from wp_abfrage import wp_base_active_katalog


import tools.hfkt_def as hdef
import tools.hfkt_dict as hdict
import tools.hfkt_type as htype
import tools.hfkt_log as hlog

INI_DICT_PROOF_LISTE = [("store_path", "str"),
                        ("basic_info_pre_file_name", "str","str","wp_basic_info_data_"),
                        ("wpname_isin_filename", "str"),
                        ("wkn_isin_sleep_time", "int", "int", 10),
                        ("wkn_isin_n_times", "int", "int", 2),
                        ("ariva_user","str"),
                        ("ariva_pw","str"),
                        ("ariva_timeout_s","int","int",10),
                        ("onvista_user","str"),
                        ("onvista_pw","str"),
                        ("onvista_timeout_s","int","int",10),
                        ("boerse","str","str","xetra"),
                        ("indices_pre_file_name", "str","str","indices_data_"),
                        ("usdeuro_use_format", "int", "int",0),
                        ("ezbleitzins_use_format", "int", "int",0),
                        ("price_volumen_use_format", "int", "int",0),
                        ("price_volumen_pre_file_name", "str","str","wp_price_volume_data_"),
                        ("price_volumen_first_dat","str","datStrP","01.01.2000"),
                        ("eodhd_key","str"),
                        ("avira_price_volume_csv_store_path","str"),
                        ("avira_price_isin_liste_csv_filebasename","str"),
                        ("avira_price_volume_csv_pre_file_name","str","str","wkn_"),
                        ("avira_price_volume_csv_post_file_name","str","str","_historic"),
                        ("avira_price_volume_csv_delete","int","int",1),
                        ("avira_price_volume_csv_is_master","int","int",1),
                        ("avira_price_volume_csv_trennzeichen","str","str",";"),
                        ("active_katalog_filename","str","str","active_katalog_data")
                        ]

class WPParam:

    HEADER_DATUM_NAME   = "Datum"
    HEADER_ERSTER_NAME  = "Erster"
    HEADER_HOCH_NAME    = "Hoch"
    HEADER_TIEF_NAME    = "Tief"
    HEADER_SCHLUSS_NAME = "Schlusskurs"
    HEADER_STUECKE_NAME = "Stuecke"
    HEADER_VOLUMEN_NAME = "Volumen"

    HEADER_DATUM_TYPE   = "dat"
    HEADER_ERSTER_TYPE  = "float"
    HEADER_HOCH_TYPE    = "float"
    HEADER_TIEF_TYPE    = "float"
    HEADER_SCHLUSS_TYPE = "float"
    HEADER_STUECKE_TYPE = "float"
    HEADER_VOLUMEN_TYPE = "float"

    HEADER_LLISTE = [(HEADER_DATUM_NAME, HEADER_DATUM_TYPE),
                           (HEADER_ERSTER_NAME, HEADER_ERSTER_TYPE),
                           (HEADER_HOCH_NAME, HEADER_HOCH_TYPE),
                           (HEADER_TIEF_NAME, HEADER_TIEF_TYPE),
                           (HEADER_SCHLUSS_NAME, HEADER_SCHLUSS_TYPE),
                           (HEADER_STUECKE_NAME, HEADER_STUECKE_TYPE),
                           (HEADER_VOLUMEN_NAME, HEADER_VOLUMEN_TYPE),
                           ]
    HEADER_NAME_DICT = {}
    HEADER_NAME_LIST = []
    HEADER_TYPE_DICT = {}
    HEADER_TYPE_LIST = []

    for i,liste in enumerate(HEADER_LLISTE):
        HEADER_NAME_DICT[i] = liste[0]
        HEADER_TYPE_DICT[i] = liste[1]
        HEADER_NAME_LIST.append(liste[0])
        HEADER_TYPE_LIST.append(liste[1])
    # end for

    # HEADER_USDEURO_NAME = "USDEURO"
    # HEADER_USDEURO_TYPE = "float"

    INDICES_EZB_LEITZINS_NAME = "ezbleitzins"
    INDICES_USDEURO_NAME = "usdeuro"
    INDICES_CHFEURO_NAME = "chfeuro"
    INDICES_GBPEURO_NAME = "gbpeuro"

    INDICES_NAME_LISTE = [INDICES_USDEURO_NAME,
                          INDICES_CHFEURO_NAME,
                          INDICES_GBPEURO_NAME,
                          INDICES_EZB_LEITZINS_NAME]
# end class
class WPData:
    '''
    Basis Funktion:
    
    obj                                  = WPData(ini_filename)
    (status, errtext, output_dict)       = obj.get_basic_info(isin)
    (status, errtext, output_dict_liste) = obj.get_basic_info(isin_liste)
    (status, errtext, wpname_isin_dict)  = obj.get_stored_basic_info_isin_wpname_dict()
    (status,errtext, isin_liste)         = obj.get_basic_info_isin_liste()
    (status, errtext)                    = obj.save_basic_info(isin_liste, output_dict_liste)
    (status, errtext)                    = obj.save_basic_info(isin, output_dict)

    (status, errtext)                    = obj.set_usdeuro_course(np_dat_array, np_value_array)
    
    Hilfsfunktionen:
    self.check_store_path()
    self.check_isin_input(isin_input)
    ini_filename
    '''
    def __init__(self,ini_filename:str,log_obj=None) -> None:

        self.par =  WPParam()

        if (not os.path.isfile(ini_filename)):
            self.status = hdef.NOT_OKAY
            self.errtext = f"ini_file_name = {ini_filename} does not exist !!!!"
            return
        
        # read ini-file
        else:
            self.ini_file_name = ini_filename
            try:
                with open(ini_filename, "rb") as f:
                    ddict = tomllib.load(f)
            except Exception as e:
                self.errtext = f"tomllib: Bei lesen {ini_filename} gibt Fehler: {e.args[0]}"
                self.status = hdef.NOT_OKAY
                return
            # endtry
        # endif
        if log_obj is None:
            self.log = hlog.log(consol_func=True, log_window=False)
        else:
            self.log = log_obj
        # end if
        self.log_file_name = self.log.get_logfilename()

        (self.status, self.errtext, self.base_ddict) = hdict.proof_transform_ddict(ddict,INI_DICT_PROOF_LISTE)
        if self.status != hdef.OK:
            return
        # endif

        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""

        (self.status,self.errtext) = wp_fkt.check_store_path(self.base_ddict["store_path"])
    # end def
    def __del__(self) -> None:
        if hasattr(self, "log_file_name"):
            print(f"Siehe logfile: {self.log_file_name}")
    # end def
    def get_basic_info_isin_liste(self) -> (int,str,list):
        '''
        
        Lese wpname_isin_dict ein und bilde daraus eine Liste mit allen ISINs
        
        :return: (status,errtext, isin_liste) = obj.get_basic_info_isin_liste()
        '''

        (self.status, self.errtext, isin_liste) = wp_base_basic_info.get_isin_liste(self)

        return (self.status, self.errtext, isin_liste)
    def get_stored_basic_info_isin_wpname_dict(self) -> (int,str,dict):
        '''
        
        Lese wpname_isin_dict ein und gebe sie zurück
        
        :return: (status, errtext, wpname_isin_dict) = self.get_stored_basic_info_isin_wpname_dict()
        '''
        
        (self.status,self.errtext,wpname_isin_dict) = wp_base_basic_info.get_isin_wpname_dict(self)
        
        return (self.status,self.errtext,wpname_isin_dict)
    # end def
    def save_basic_info_isin_wpname_dict(self,isin,wpname) -> (int,str):
        """
        speichere in file
        """
        (self.status, self.errtext) = wp_base_basic_info.save_isin_wpname(self, isin,wpname )
        return (self.status, self.errtext)

    # end def
    def get_basic_info(self, isin_input: str|list) -> (int,str,dict|list):
        '''

        :param isin_input:
        :return: (status, errtext, output_dict_liste) = self.get_basic_info(isin_liste)
                 (status, errtext, output_dict) = self.get_basic_info(isin)
        '''

        (self.status, self.errtext, output) = wp_base_basic_info.get(self,isin_input)

        return (self.status, self.errtext, output)
    # end def
    def get_basic_info_key_list(self) -> list:
        '''

        :return: key_list = self.get_basic_info_key_list()
        '''

        key_list = wp_base_basic_info.get_key_list(self)

        return list(key_list)
    # end def
    def get_basic_info_key_value(self,isin: str,key: str) -> (int,str,any):
        '''

        :return: (status,errtext,value) = self.get_basic_info_key_value(isin,key)
        '''

        (self.status, self.errtext,value) = wp_base_basic_info.get_basic_info_key_value(self,isin,key)

        return (self.status, self.errtext,value)
    # end def
    def get_exist_filenames_of_basic_info(self, isin_input: str | list) -> (int, str, list):
        """
        :param isin_input:
        (status, errtext, filename_list) = wp_base.get_exist_filenames_of_basic_info( isin_input)
        """
        (self.status, self.errtext, filename_list) = wp_base_basic_info.get_exist_filenames(self, isin_input)
        return (self.status, self.errtext, filename_list)
    # end def
    def set_value_in_basic_info(self,isin,key,wert):
        """
        :param isin:
        :param key
        :param wert:
        :return:
        """
        (self.status, self.errtext) = wp_base_basic_info.set_value(self, isin,key,wert)
        return (self.status, self.errtext)
    # end def
    def filter_basic_info_from_wp_dict(self,wp_dict: dict) -> (int,str,dict):
        """
        :param wp_dict:
        :return: (status, errtext,basic_info_dict) = self.filter_basic_info_from_wp_dict(wp_dict)
        """
        (self.status, self.errtext,basic_info_dict) = wp_base_basic_info.filter_wp_dict(self, wp_dict)

        return (self.status, self.errtext, basic_info_dict)
    # end def
    def save_basic_info(self, isin_input: str|list, basic_info_dict: list|dict) -> (int,str):
        '''

        Speicheren der basic_info_dict ind die entsprechende Datei
        
        :param isin:
        :return: (status, errtext) = self.save_basic_info(isin_liste, basic_info_dict_liste)
                 (status, errtext) = self.save_basic_info(isin, basic_info_dict)
        '''

        (self.status, self.errtext) = wp_base_basic_info.save(self, isin_input,basic_info_dict)

        return (self.status, self.errtext)
    # end def
    
    def get_isin_from_wkn(self,wkn:str) -> (int,str):
        '''
        
        Suche die passende isin zu wkn nummer
        :param wkn:
        :return: (okay,isin) = self.wpfunc.get_isin_from_wkn(wkn)
        '''
        (self.status, self.errtext, isin) = wp_base_basic_info.process_isin_from_wkn(self,wkn)

        return (self.status,isin)
    # end def
    def find_wpname_in_comment_get_isin(self,comment:str) -> (int,str):
        '''
        
        :param comment:
        :return: (status,isin) = self.find_wpname_in_comment_get_isin(comment)
        '''

        (self.status, self.errtext, isin) = wp_base_basic_info.find_wpname(self,comment)

        return (self.status,isin)
    # end def
    # def set_wkn_isin(self, wkn, isin):
    #     '''
    #
    #     :param wpname:
    #     :return:
    #     '''
    #     (self.status, self.errtext) = wp_wkn.wp_add_wkn_isin(wkn, isin, self.base_ddict)
    #
    #     if self.status != hdef.OKAY:
    #         print(f"set_wkn_isin not working errtext: {self.errtext}")
    #     # end if
    #     return self.status
    #
    # # end def
    def update_isin_w_wpname_wkn(self,isin:str,wpname:str,wkn:str) -> int:
        '''

        :param wpname:
        :return: status self.update_isin_w_wpname_wkn(isin,wpname,wkn)
        '''

        (self.status, self.errtext) = wp_base_basic_info.process_isin_w_wpname_wkn(self,isin,wpname,wkn)

        return self.status
    
    # end def
    def updat_first_last_in_basic_info(self,isin:str,first_dat_str:str,last_dat_str:str) -> tuple:
        """
        :param isin:
        :param first_dat_str:
        :param last_dat_str:
        :return: (status, errtext) = self.updat_first_last_in_basic_info(isin,first_dat_str,last_dat_str)
        """
        self.log.write_info(f"Update basic_info of {isin = } from {first_dat_str = } to {last_dat_str = }")
        (self.status, self.errtext) = wp_base_basic_info.updat_first_last(self, isin, first_dat_str,last_dat_str)
        return (self.status, self.errtext)
    # end def
    def update_all_basic_infos(self,flag_update_all):
        """
             (status, errtext) = self.update_alla_basic_infos(flag_update_all)
        """
        self.log.write_info(f"Lade isin-Liste")
        (self.status, self.errtext, isin_liste) = wp_base_basic_info.get_isin_liste(self)
        if self.status != hdef.OK:
            return (self.status, self.errtext)
        # endif
        start_time = time.time()
        self.log.write_info(f"Starte update isins mit basic-info {start_time = }")
        n = len(isin_liste)
        for i,isin in enumerate(isin_liste):
            self.log.write_info(f"({i+1}/{n}) Starte update {isin = }  {flag_update_all = }")
            (self.status, self.errtext) = self.update_basic_info_isin(isin,flag_update_all)
            if self.status != hdef.OK:
                return (self.status, self.errtext)
            # end if
        # end for
        end_time = time.time()
        self.log.write_info(f"Ende update isins mit basic-info {end_time = }")
        self.log.write_info(f"Ausführungszeit: {end_time - start_time } s")
        return (self.status, self.errtext)
    # end def
    def update_one_basic_infos(self, isin, flag_update_all=True):
        """
        :param isin:
        :param flag_update_all:
        :return:  (status, errtext) = wb_obj.update_one_basic_infos(isin)
                  (status, errtext) = wb_obj.update_one_basic_infos(isin, True/False)
        """
        start_time = time.time()
        self.log.write_info(f"Starte update {isin = }  {flag_update_all = }")
        (self.status, self.errtext) = self.update_basic_info_isin(isin,flag_update_all)
        if self.status != hdef.OK:
            return (self.status, self.errtext)
        # end if
        end_time = time.time()
        self.log.write_info(f"Ende update {isin = } mit basic-info {end_time = }")
        self.log.write_info(f"Ausführungszeit: {end_time - start_time } s")
        return (self.status, self.errtext)
    # end def
    def update_basic_info_isin(self, isin,flag_update_all):
        """
             (status, errtext) = self.update_basic_info_isin(self, isin,flag_update_all)
        """

        (self.status, self.errtext) = wp_base_basic_info.update_isin(self,isin, flag_update_all)
        if self.status != hdef.OK:
            return (self.status, self.errtext)
        # end if
        return (self.status, self.errtext)

    # end def
    # def process_usdeuro_ezb_xml(self, xmlfilename: str) -> (int,str):
    #     """
    #
    #     :param wp_obj:
    #     :param xmlfilename:
    #     :return: (status, errtext) = wp_obj.process_usdeuro_ezb_xml(xmlfilename)
    #     """
    #
    #     (status, errtext, number, firstdat, lastdat) = wp_base_usdeuro.get_number_of_data(self)
    #
    #     firstdatstr = htype.type_transform_direct(firstdat, "dat", "datStrP")
    #     lastdatstr = htype.type_transform_direct(lastdat, "dat", "datStrP")
    #
    #     print(f"start reading {number = }, {firstdatstr = },{lastdatstr = }")
    #
    #
    #     (self.status,self.errtext) = wp_base_usdeuro.process_ezb_xml(self,xmlfilename)
    #
    #
    #     firstdatstr = htype.type_transform_direct(firstdat, "dat", "datStrP")
    #     lastdatstr = htype.type_transform_direct(lastdat, "dat", "datStrP")
    #
    #     print(f"end reading {number = }, {firstdatstr = },{lastdatstr = }")
    #
    #     return (self.status,self.errtext)
    # # end def
    def get_indices_liste(self):

        indices_liste = wp_base_indices.get_indices_liste(self)

        return (self.status, self.errtext,indices_liste)
    # end def
    def get_leitzins_indice_name(self):

        indice = wp_base_indices.get_leitzins_indice_name(self)

        return indice
    # end def

    def is_an_indice(self,wp):
        """
        (status, errtext) = self.is_rom_indes_liste(wp)
        """
        indices_liste = wp_base_indices.get_indices_liste(self)
        if wp in indices_liste:
            return True
        else:
            return False
        # end if
    # end def
    def update_indices(self,indice=None) -> (int,str):
        """

        :return: (status, errtext,infotext) = wp_obj.update_indices()
        """

        (self.status, self.errtext) = wp_base_indices.update_indices(self,indice)
        if self.status != hdef.OK:
            return (self.status, self.errtext,self.infotext)


        return (self.status, self.errtext,self.infotext)
    # end def
    def make_backup_indice(self,indice_liste=[],move_flag = False):
        """
        :param wb_obj:
        :return: (status, errtext) = make_backup_basic_infos(wb_obj)
        """
        (self.status,self.errtext) = wp_base_indices.make_backup(self,indice_liste,move_flag)
        if self.status != hdef.OKAY:
            return (self.status,self.errtext)

        return (self.status,self.errtext)
    # end def

    def get_dict_indice_from_act(self, indice=None):
        """
        (status, errtext, np_obj_dict) = self.get_dict_indice_from_act()
        (status, errtext, np_obj) = self.get_dict_indice_from_act(indece)
        (status, errtext, np_obj_dict) = self.get_dict_indice_from_act([indeice1,indece2])

        """
        (self.status, self.errtext, np_obj_dict) = wp_base_indices.get_dict_from_act(self, indice)

        return (self.status, self.errtext, np_obj_dict)
    # end def
    def get_dict_indice_from_start_dat_to_end_dat(self,start_dat:int,end_dat:int,indice):
        """
        :param start_dat:
        :param end_dat:
        :return: (status,errtext,np_obj_dict) = get_usdeuro_from_start_dat_to_end_dat(self,start_dat:int,end_dat:int)
        """
        (self.status, self.errtext,np_obj_dict) = wp_base_indices.get_dict_from_start_dat_to_end_dat(self,start_dat,end_dat,indice)

        return (self.status, self.errtext,np_obj_dict)
    # end def
    def process_indice_ezb_xml(self, xmlfilename: str,indice:str) -> (int,str):
        """

        :param wp_obj:
        :param xmlfilename:
        :param indice:
        :return: (status, errtext) = wp_obj.process_usdeuro_ezb_xml(xmlfilename,indice)
        """

        (self.status,self.errtext) = wp_base_indices.process_ezb_xml(self,xmlfilename,indice)

        return (self.status,self.errtext)
    # end def
    def process_indice_ezb_leitzins_csv(self,csvfilename:str):
        """
        :param csvfilename:
        (status, errtext) = wp_obj.process_indice_ezb_leitzins_csv(csvfilename)
        """
        (self.status,self.errtext) = wp_base_indices.process_ezb_leitzins_csv(self,csvfilename)

        return (self.status,self.errtext)
    # end def
    def is_an_isin(self,isin):
        (status, wert) = htype.type_proof_isin(isin)
        if status == hdef.OKAY:
            return True
        else:
            return False
        # end if
    # end def
    def update_price_volume(self, isin=None):
        """
        - Demand: run_wp_abfrage.py

        Für isin werden die letzten Tagespreise und Volumen abgefragt


        :param isin:
        :return: (status,errtext) = wp_obj.update_price_volume(isin)
        """
        status = hdef.OKAY
        errtext = ""

        if isin == None:
            (self.status,self.errtext, isin_liste) = self.get_basic_info_isin_liste()
            if self.status != hdef.OKAY:
                return (self.status,self.errtext,self.infotext)
            # end if
        else:
            isin_liste = [isin]
        # end if

        (self.status,self.errtext,self.infotext) = wp_base_price_volume.update(self,isin_liste)
        if self.status != hdef.OKAY:
            return (self.status,self.errtext,self.infotext)
        # end if

        # (status, errtext) = wp_base_price_volume.update_last_price_volume_isin(self, isin_basic_dict, isin)
        # if status != hdef.OKAY:
        #     return (status, errtext)
        # # end if

        return (self.status,self.errtext,self.infotext)


    # end def
    def proof_price_volume(self, isin=None):
        """
        - Demand: run_wp_abfrage.py

        Für isin wird die Datei überprüft

        :param isin:
        :return: (status,errtext) = wp_obj.update_price_volume(isin)
        """
        status = hdef.OKAY
        errtext = ""

        if isin == None:
            (self.status,self.errtext, isin_liste) = self.get_basic_info_isin_liste()
            if self.status != hdef.OKAY:
                return (self.status,self.errtext,self.infotext)
            # end if
        else:
            isin_liste = [isin]
        # end if

        (self.status,self.errtext,self.infotext) = wp_base_price_volume.proof(self,isin_liste)
        if self.status != hdef.OKAY:
            return (self.status,self.errtext,self.infotext)
        # end if

        return (self.status,self.errtext,self.infotext)


    # end def
    def make_backup_price_volumen(self,isin_liste=[],move_flag = False):
        """
        :param wb_obj:
        :return: (status, errtext) = make_backup_basic_infos(wb_obj)
        """
        (self.status,self.errtext) = wp_base_price_volume.make_backup(self,isin_liste,move_flag)
        if self.status != hdef.OKAY:
            return (self.status,self.errtext)

        return (self.status,self.errtext)
    # end def
    def build_ariva_isin_csv(self,isin_ariva_liste=[]):
        status = hdef.OKAY

        errtext = ""

        (self.status, self.errtext, self.infotext) = wp_base_price_volume.build_ariva_isin_csv(self,isin_ariva_liste)
        if self.status != hdef.OKAY:
            return (self.status, self.errtext, self.infotext)
        # end if

        return (self.status, self.errtext, self.infotext)
    # end def
    def update_price_volume_ariva_csv(self):
        status = hdef.OKAY

        errtext = ""

        (self.status, self.errtext, self.infotext) = wp_base_price_volume.update_ariva_csv(self)
        if self.status != hdef.OKAY:
            return (self.status, self.errtext, self.infotext)
        # end if

        return (self.status, self.errtext, self.infotext)
    # end def
    def get_exist_filenames_of_privce_volume(self, isin_input: str | list) -> (int, str, list):
        """
        :param isin_input:
        (status, errtext, filename_list) = wp_base.get_exist_filenames_of_basic_info( isin_input)
        """
        (self.status, self.errtext, filename_list) = wp_base_price_volume.get_exist_filenames(self, isin_input)
        return (self.status, self.errtext, filename_list)
    # end def
    def get_act_price_volume(self, isin=None,pricetype="euro",dattype="dat"):
        """

        Für isin wird der letzte Tagespreise und Datum zurückgegeben


        :param isin:
        :return: (status,errtext,price,dat) = wp_obj.get_act_price_volume(isin,pricetype,dattype)
                 (status,errtext,price_liste,dat_liste) = wp_obj.get_act_price_volume(isin_liste,pricetype,dattype)
        """

        (self.status,self.errtext,price,dat) = wp_base_price_volume.get_act(self,isin,pricetype,dattype)

        return (self.status,self.errtext,price,dat)
    # end def
    def get_act_price_volume_np_obj(self,isin):
        """
        lade die no_obj-Datei und übergebe ein eKopie

        :param isin:
        :return: (status,errtext,np_obj) = wp_obj.get_act_price_volume_np_obj(isin)
        """
        (self.status, self.errtext, np_obj) = wp_base_price_volume.get_act_np_obj(self, isin)
        return (self.status, self.errtext, np_obj)
    # end def
    def is_wp(self,wp):
        """
        Gibt es dieses wertpapier a) als gültige isin oder als abgelegter indice

        :param wp: Wert Papier
        """

        if self.is_an_indice(wp):
            return True
        # end if

        return self.is_an_isin(wp)
    # end if
    def set_active_isin_katalog_for_depot(self,depot_name,isin_dict_katalog):
        """
        :param depot_name:                Name des Depots
        :param isin_dict_katalog_liste:   dictionary mit key = isin und value = katalog

        (status,errtext) = self.set_active_isin_katalog_for_depot(depot_name,isin_dict_katalog)
        """
        (self.status, self.errtext) = wp_base_active_katalog.set_for_depot(self, depot_name, isin_dict_katalog)

        return (self.status, self.errtext)
    # end def

    def erase_active_isin_katalog_for_depot(self,depot_name):
        """
        :param depot_name:                Name des Depots

        (status, errtext) = self.erase_active_isin_katalog_for_depot(depot_name)

        """
        (self.status, self.errtext) = wp_base_active_katalog.erase_depot(self,depot_name)

        return (self.status, self.errtext)
    # end def
    def get_active_depot_isin_scre(self,isin,scre):
        """
        :param isin:
        :param scre:
        return (status,errtext,active_depot) = wp_base.get_active_depot_isin_scre(isin,scre)
        """
        (self.status, self.errtext,active_depot) = wp_base_active_katalog.get_w_isin_scr(self, isin,scre)

        return (self.status, self.errtext,active_depot)
    # end def


if __name__ == '__main__':


    isin = "AU3TB0000192"
    isin = "DE000ETFL482"
    
    store_path = "D:/data/orga/wp_store/wp_abfrage.ini"
    wp = WPData(store_path)
    if wp.status != hdef.OKAY:
        print(f"WPData: Fehler  errtext = {wp.errtext}")
        exit(1)
    # end if

    wkn = "LS9U3L"
    (status,isin) = wp.get_isin_from_wkn(wkn)

    if status == hdef.OKAY:
        print(f"isin = {isin}")
    # end if

    (status,errtext,info_dict_list) = wp.get_basic_info(isin)
    if status != hdef.OKAY:
        print(f"get_basic_info: Fehler   errtext = {errtext}")
        exit(1)
    # end if
    
    for info_dict in info_dict_list:
        print(info_dict)
