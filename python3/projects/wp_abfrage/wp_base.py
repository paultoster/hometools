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
from wp_abfrage import wp_base_usdeuro as wp_base_usdeuro
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
                        ("usdeuro_use_format", "int", "int",0),
                        ("usdeuro_pre_file_name", "str","str","usdeuro_data_"),
                        ("price_volumen_use_format", "int", "int",0),
                        ("price_volumen_pre_file_name", "str","str","wp_price_volume_data_"),
                        ("price_volumen_first_dat","str","datStrP","01.01.2000"),
                        ("eodhd_key","str"),
                        ("avira_price_volume_csv_store_path","str"),
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

    HEADER_USDEURO_NAME = "USDEURO"
    HEADER_USDEURO_TYPE = "float"

# end class
class WPData:
    '''
    Basis Funktion:
    
    obj                                  = WPData(ini_filename)
    (status, errtext, output_dict)       = obj.get_basic_info(isin)
    (status, errtext, output_dict_liste) = obj.get_basic_info(isin_liste)
    (status, errtext, wpname_isin_dict)  = obj.get_stored_basic_info_wpname_isin_dict()
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
    def get_stored_basic_info_wpname_isin_dict(self) -> (int,str,dict):
        '''
        
        Lese wpname_isin_dict ein und gebe sie zurück
        
        :return: (status, errtext, wpname_isin_dict) = self.get_stored_basic_info_wpname_isin_dict()
        '''
        
        (self.status,self.errtext,wpname_isin_dict) = wp_base_basic_info.get_wpname_isin_dict(self)
        
        return (self.status,self.errtext,wpname_isin_dict)
    # end def
    def save_basic_info_wpname_isin_dict(self,isin,wpname) -> (int,str):
        """
        speichere in file
        """
        (self.status, self.errtext) = wp_base_basic_info.save_wpname_isin(self, isin,wpname )
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

        return key_list
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
    def process_usdeuro_ezb_xml(self, xmlfilename: str) -> (int,str):
        """

        :param wp_obj:
        :param xmlfilename:
        :return: (status, errtext) = wp_obj.process_usdeuro_ezb_xml(xmlfilename)
        """

        (status, errtext, number, firstdat, lastdat) = wp_base_usdeuro.get_number_of_data(self)

        firstdatstr = htype.type_transform_direct(firstdat, "dat", "datStrP")
        lastdatstr = htype.type_transform_direct(lastdat, "dat", "datStrP")

        print(f"start reading {number = }, {firstdatstr = },{lastdatstr = }")


        (self.status,self.errtext) = wp_base_usdeuro.process_ezb_xml(self,xmlfilename)


        firstdatstr = htype.type_transform_direct(firstdat, "dat", "datStrP")
        lastdatstr = htype.type_transform_direct(lastdat, "dat", "datStrP")

        print(f"end reading {number = }, {firstdatstr = },{lastdatstr = }")

        return (self.status,self.errtext)
    # end def
    def process_akt_usdeuro(self) -> (int,str):
        """

        :return: (status, errtext) = wp_obj.process_akt_usdeuro()
        """
        (status, errtext, number, firstdat, lastdat) = wp_base_usdeuro.get_number_of_data(self)
        if self.status != hdef.OK:
            return (self.status, self.errtext)

        firstdatstr = htype.type_transform_direct(firstdat, "dat", "datStrP")
        lastdatstr = htype.type_transform_direct(lastdat, "dat", "datStrP")

        print(f"start reading {number = }, {firstdatstr = },{lastdatstr = }")

        (self.status, self.errtext) = wp_base_usdeuro.process_akt(self)
        if self.status != hdef.OK:
            return (self.status, self.errtext)

        (status, errtext, number, firstdat, lastdat) = wp_base_usdeuro.get_number_of_data(self)
        if self.status != hdef.OK:
            return (self.status, self.errtext)

        firstdatstr = htype.type_transform_direct(firstdat, "dat", "datStrP")
        lastdatstr = htype.type_transform_direct(lastdat, "dat", "datStrP")

        print(f"end reading {number = }, {firstdatstr = },{lastdatstr = }")

        return (self.status, self.errtext)
    # end def
    def get_usdeuro_from_start_dat_to_end_dat(self,start_dat:int,end_dat:int):
        """
        :param start_dat:
        :param end_dat:
        :return: (status,errtext,np_usdeuro) = get_usdeuro_from_start_dat_to_end_dat(self,start_dat:int,end_dat:int)
        """
        (self.status, self.errtext,np_obj) = wp_base_usdeuro.get_from_start_dat_to_end_dat(self,start_dat,end_dat)
        return (self.status, self.errtext,np_obj)
    # end def

    # def update_usdeuro(self):
    #     """
    #
    #     :return: (status, errtext) = wp_obj.update_usdeuro()
    #     """
    #     (self.status, self.errtext) = wp_base_usdeuro.update(self)
    #     #---------------------------------------------------------------------------------------------------------------
    #     # Hole die aktuellen Werte von yfinace
    #     #---------------------------------------------------------------------------------------------------------------
    #     # Was ist der letzte gespeicherte wert => start datum
    #     (_, _, start_dat) = self.get_number_of_data_usdeuro_course()
    #     start_dat_time_list = htype.type_transform_direct(start_dat,"dat","datTimeList")
    #     # Was ist der letzte aktuelle Handelsdatum
    #     end_dat_time_list = wp_fkt.letzter_beendeter_handelstag_dat_list(self.base_ddict["boerse"])
    #     end_dat           = htype.type_transform_direct(end_dat_time_list, "datTimeList", "dat")
    #
    #     # ---------------------------------------------------------------------------------------------------------------
    #     # wennn Daten fehlen: Hole die aktuellen Werte von yfinace
    #     # ---------------------------------------------------------------------------------------------------------------
    #     if end_dat > start_dat:
    #
    #         (self.status, self.errtext, df_new) = wp_yfinance.get_usdeuro_data(start_dat_time_list,
    #                                                                            end_dat_time_list,
    #                                                                            self.par.HEADER_DATUM_NAME,
    #                                                                            self.par.HEADER_USDEURO_NAME)
    #
    #         if self.status != hdef.OKAY:
    #             return self.status
    #
    #         (read_flag,df) = wp_storage.read_parquet(self.par.HEADER_USDEURO_NAME, self.base_ddict)
    #
    #         if read_flag:
    #             (self.status, self.errtext, df) = wp_fkt.merge_usdeuro_dfnew_to_df(df,df_new,
    #                                                                     self.par.HEADER_DATUM_NAME,
    #                                                                     self.par.HEADER_USDEURO_NAME)
    #             if self.status != hdef.OKAY:
    #                 return self.status
    #
    #             wp_storage.save_parquet(df, self.par.HEADER_USDEURO_NAME, self.base_ddict)
    #         else:
    #             df = df_new
    #         # end if
    #     # end def
    #     return self.status
    # # end def
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
    def update_price_volume_csv(self):
        status = hdef.OKAY

        errtext = ""

        (self.status, self.errtext, self.infotext) = wp_base_price_volume.update_csv(self)
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
    def get_act_np_obj(self,isin):
        """
        lade die no_obj-Datei und übergebe ein eKopie

        :param isin:
        :return: (status,errtext) = wp_obj.get_act_np_obj(isin)
        """
        (self.status, self.errtext, np_obj) = wp_base_price_volume.get_act_np_obj(self, isin)
        return (self.status, self.errtext, np_obj)
    # end def
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
