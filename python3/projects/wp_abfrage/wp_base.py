import os, sys, time
import tomllib

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

import wp_abfrage.wp_fkt as wp_fkt
import wp_abfrage.wp_wkn as wp_wkn
import wp_abfrage.wp_storage as wp_storage
import wp_abfrage.wp_isin as wp_isin

import tools.hfkt_def as hdef
import tools.hfkt_dict as hdict
# import tools.hfkt_type as htyp

INI_DICT_PROOF_LISTE = [("store_path", "str"),
                        ("basic_info_pre_file_name", "str"),
                        ("wpname_isin_filename", "str"),
                        ("use_json", "int", "int",0),
                        ("wkn_isin_sleep_time", "int", "int", 10),
                        ("wkn_isin_n_times", "int", "int", 2),
                        ("ariva_user","str"),
                        ("ariva_pw","str"),
                        ("ariva_timeout_playright","int","int",10000)
                        ]


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
    
    Hilfsfunktionen:
    self.check_store_path()
    self.check_isin_input(isin_input)
    ini_filename
    '''
    def __init__(self,ini_filename):
        
        if (not os.path.isfile(ini_filename)):
            self.status = hdef.NOT_OKAY
            self.errtext = f"ini_file_name = {ini_filename} does not exist !!!!"
            return
        
        # read ini-file
        else:
            self.ini_file_name = ini_filename
            with open(ini_filename, "rb") as f:
                ddict = tomllib.load(f)
        # endif
        
        (self.status, self.errtext, self.base_ddict) = hdict.proof_transform_ddict(ddict,INI_DICT_PROOF_LISTE)
        if self.status != hdef.OK:
            return
        # endif

        # additional dict vars
        # self.base_ddict["isin_input_is_list"] = False
        # self.base_ddict["isin_list"] = []
        # self.base_ddict["output_list"] = []
        # self.base_ddict["wp_isin_file_dict_list"] = []

        self.status = hdef.OKAY
        self.errtext = ""
        
        (self.status,self.errtext) = wp_fkt.check_store_path(self.base_ddict)
    # end def
    def get_basic_info_isin_liste(self):
        '''
        
        Lese wpname_isin_dict ein und bilde daraus eine Liste mit allen ISINs
        
        :return: (status,errtext, isin_liste) = obj.get_basic_info_isin_liste()
        '''
        
        (self.status,self.errtext,wpname_isin_dict) = wp_storage.read_wpname_isin_dict(self.base_ddict)
        
        if self.status == hdef.OKAY:
            isin_liste = list(wpname_isin_dict.keys())
        else:
            isin_liste =[]
        # end if
        
        return (self.status, self.errtext, isin_liste)
    def get_stored_basic_info_wpname_isin_dict(self):
        '''
        
        Lese wpname_isin_dict ein und gebe sie zurück
        
        :return: (status, errtext, wpname_isin_dict) = self.get_stored_basic_info_wpname_isin_dict()
        '''
        
        (self.status,self.errtext,wpname_isin_dict) = wp_storage.read_wpname_isin_dict(self.base_ddict)
        
        return (self.status,self.errtext,wpname_isin_dict)
    # end def
    def get_basic_info(self, isin_input):
        '''

        :param isin_input:
        :return: (status, errtext, output_dict_liste) = self.get_basic_info(isin_liste)
                 (status, errtext, output_dict) = self.get_basic_info(isin)
        '''
        
        self.status = hdef.OKAY
        self.errtext = ""
        
        # -----------------------------------------------------------
        # check ISIN input build self.base_ddict["isin_list"]
        # -----------------------------------------------------------
        (self.status, self.errtext,
         isin_input_is_list,isin_list) \
            = wp_fkt.check_isin_input(isin_input)
        
        if self.status != hdef.OKAY:
            return (self.status, self.errtext, None)
        # end if
        
        output_list = [None] * len(isin_list)
        
        # ---------------------------------------------------------------------
        # iteriere über isin_list
        # ---------------------------------------------------------------------
        for i, isin in enumerate(isin_list):
            
            print(f"Build basic_info from isin: {isin}:")
            start_time = time.time()
            
            (status, errtext, info_dict) = wp_isin.get_basic_info(isin, self.base_ddict)
            
            # ---------------------------------------------
            # Einzel dict info_dict in Liste einsortieren
            # ---------------------------------------------
            if status == hdef.OKAY:
                output_list[i] = info_dict
            else:
                status = status
                errtext = errtext
                return (status, errtext, None)
            # end if
            
            end_time = time.time()
            print('Execution time: ', end_time - start_time, ' s')
        # end for
        
        if isin_input_is_list:
            output = output_list
        else:
            if len(output_list):
                output = output_list[0]
            else:
                output = None
            # end if
        # end if
        
        return (self.status, self.errtext, output)
    # end def
    def save_basic_info(self, isin_input,basic_info_dict):
        '''

        Speicheren der basic_info_dict ind die entsprechende Datei
        
        :param isin:
        :return: (status, errtext) = self.save_basic_info(isin_liste, basic_info_dict_liste)
                 (status, errtext) = self.save_basic_info(isin, basic_info_dict)
        '''
        
        self.status = hdef.OKAY
        self.errtext = ""
        
        # -----------------------------------------------------------
        # check ISIN input build self.base_ddict["isin_list"]
        # -----------------------------------------------------------
        (self.status, self.errtext,
         isin_input_is_list,isin_list) = \
            wp_fkt.check_isin_input(isin_input)
        
        if self.status != hdef.OKAY:
            return (self.status, self.errtext, None)
        # end if
        
        if isin_input_is_list:
            if isinstance(basic_info_dict,list):
                basic_info_dict_list = basic_info_dict
            else:
                status = hdef.NOT_OKAY
                errtext = f"save_basic_info: isin_input: {isin_input} need a list of dict dict_list: {basic_info_dict}"
                return (status,errtext)
            # end if
        else:
            if isinstance(basic_info_dict, list):
                basic_info_dict_list = [basic_info_dict[0]]
            else:
                basic_info_dict_list = [basic_info_dict]
            # end if
        # end if
        
        for i,isin in enumerate(isin_list):
            
            (status,errtext) =  wp_storage.save_info_dict(isin, basic_info_dict_list[i], self.base_ddict)
            
            if self.status != hdef.OKAY:
                return (self.status, self.errtext)
            # end if
        # end for
        return (self.status, self.errtext)
    
    # end def
    
    def get_isin_from_wkn(self,wkn):
        '''
        
        Suche die passende isin zu wkn nummer
        :param wkn:
        :return: (okay,isin) = self.wpfunc.get_isin_from_wkn(wkn)
        '''
        (self.status, self.errtext, isin) = wp_wkn.wp_search_wkn(wkn,self.base_ddict)
        if self.status != hdef.OKAY:
            print(f"get_isin_from_wkn not working errtext: {self.errtext}")
            isin = ""
        # end if
        return (self.status,isin)
    # end def
    def find_wpname_in_comment_get_isin(self,comment):
        '''
        
        :param comment:
        :return:
        '''
        
        (self.status, self.errtext, isin) = wp_wkn.wp_search_wpname_in_comment(comment, self.base_ddict)

        if self.status != hdef.OKAY:
            print(f"find_wpname_in_comment_get_isin not working errtext: {self.errtext}")
        # end if
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
    def update_isin_w_wpname_wkn(self,isin,wpname,wkn):
        '''

        :param wpname:
        :return: status self.update_isin_w_wpname_wkn(isin,wpname,wkn)
        '''
        
        (self.status, self.errtext, info_dict) = self.get_basic_info(isin)
        
        if self.status != hdef.OKAY:
            print(f"update_isin_w_wpname_wkn: not working errtext: {self.errtext}")
            return self.status
        # end if
        flag = False
        if len(info_dict["name"]) == 0:
            flag = True
            info_dict["name"] = wpname
            
        if len(wkn) > 0:
            flag = True
            info_dict["wkn"] = wkn
            
        if flag:
            (self.status, self.errtext) = wp_storage.save_info_dict(isin,info_dict,self.base_ddict)
        
        return self.status
    
    # end def
    # def check_store_path(self):
    #     '''
    #
    #     :return:
    #     '''
    #     if not os.path.isdir(self.base_ddict["store_path"]):
    #         try:
    #             os.mkdir(self.base_ddict["store_path"])
    #         except:
    #             t = self.base_ddict["store_path"]
    #             self.errtext = f"Der store_path: {t} konnte nicht erstellt werden"
    #             self.status = hdef.NOT_OKAY
    #         # end try
    #     # end if
    #
    #
    # def check_isin_input(self,isin_input):
    #     '''
    #
    #     :param isin_input:
    #
    #     :return: (isin_input_is_list,isin_list) = self.check_isin_input(isin_input)
    #     '''
    #     isin_input_is_list = False
    #     if isinstance(isin_input, str):
    #         isin_list = [isin_input]
    #     elif isinstance(isin_input, list):
    #         (okay, value) = htyp.type_proof(isin_input, "listStr")
    #         if okay != hdef.OKAY:
    #             self.status = hdef.NOT_OKAY
    #             self.errtext = f"isin = {isin_input} ist keine Liste mit strings"
    #             return
    #         else:
    #             isin_input_is_list = True
    #             isin_list = value
    #     else:
    #         self.errtext = f"isin = {isin_input} ist kein string"
    #         self.status = hdef.NOT_OKAY
    #         return
    #     # end if
    #
    #     for isin in isin_list:
    #         (okay,value) = htyp.type_proof(isin,'isin')
    #         if okay != hdef.OKAY:
    #
    #             (okay, value) = htyp.type_proof(isin, 'wkn')
    #             if okay != hdef.OKAY:
    #                 self.status = hdef.NOT_OKAY
    #                 self.errtext = f"isin = {isin} ist kein passender Wert"
    #                 return
    #             # end if
    #         # end if
    #     # end for
    # return (isin_input_is_list,isin_list)
    # # end def

if __name__ == '__main__':


    isin = "AU3TB0000192"
    isin = "DE000ETFL482"
    
    store_path = "K:/data/orga/wp_store"
    use_json = 0 # 0: don't 1: write, 2: read
    wp = WPData(store_path,use_json)
    if wp.status != hdef.OKAY:
        print(f"WPData: Fehler  errtext = {wp.errtext}")
        exit(1)
    # end if
    
    # wkn = "A0S9GB"
    # (status,isin) = wp.get_isin_from_wkn(wkn)

    # if status == hdef.OKAY:
    #     print(f"isin = {isin}")
    # end if

    (status,errtext,info_dict_list) = wp.get_basic_info(isin)
    if status != hdef.OKAY:
        print(f"get_basic_info: Fehler   errtext = {errtext}")
        exit(1)
    # end if
    
    for info_dict in info_dict_list:
        print(info_dict)
