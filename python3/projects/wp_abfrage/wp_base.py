import os, sys, time

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

import wp_abfrage.wp_basic_info_fkt as wp_basic
import wp_abfrage.wp_wkn as wp_wkn

import tools.hfkt_def as hdef
import tools.hfkt_type as htyp

class WPData:
    '''
    Basis Funktion:
    (status, errtext, output)       = self.get_basic_info(isin)
    (status, errtext, output_liste) = self.get_basic_info(isin_liste)
    
    Hilfsfunktionen:
    self.check_store_path()
    self.check_isin_input(isin_input)
    
    '''
    def __init__(self,store_path,use_json):
        self.ddict = {}
        self.ddict["store_path"] = store_path
        self.ddict["pre_file_name"] = "wp_data_"
        self.ddict["wkn_isin_filename"] = "wkn_isin_dict"
        self.ddict["wpname_isin_filename"] = "wpname_isin_dict"
        self.ddict["use_json"] = use_json # 0: don't 1: write, 2: read
        self.ddict["isin_input_is_list"] = False
        self.ddict["isin_list"] = []
        self.ddict["output_list"] = []
        self.ddict["wp_isin_file_dict_list"] = []
        self.ddict["wkn_isin_sleep_time"] = 10
        self.ddict["wkn_isin_n_times"] = 2

        self.status = hdef.OKAY
        self.errtext = ""

        self.check_store_path()
    # end def
    def get_basic_info(self, isin_input):
        '''

        :param isin:
        :return: (status, errtext, output_dict_liste) = self.get_basic_info(isin_liste)
                 (status, errtext, output_dict) = self.get_basic_info(isin)
        '''
        
        self.status = hdef.OKAY
        self.errtext = ""
        
        # -----------------------------------------------------------
        # check ISIN input
        # -----------------------------------------------------------
        self.check_isin_input(isin_input)
        
        if self.status != hdef.OKAY:
            return (self.status, self.errtext, None)
        # end if
        
        (self.status, self.errtext, self.ddict) = wp_basic.wp_basic_info_with_isin_list(self.ddict)
        
        if self.status != hdef.OKAY:
            return (self.status, self.errtext, None)
        # end if
        
        if self.ddict["isin_input_is_list"]:
            output = self.ddict["output_list"]
        else:
            if len(self.ddict["output_list"]):
                output = self.ddict["output_list"][0]
            else:
                output = None
            # end if
        # end if
        
        return (self.status, self.errtext, output)
    # end def
    def get_isin_from_wkn(self,wkn):
        '''
        
        :param wkn:
        :return: (okay,isin) = self.wpfunc.get_isin_from_wkn(wkn)
        '''
        (self.status, self.errtext, isin) = wp_wkn.wp_search_wkn(wkn,self.ddict)
        if self.status != hdef.OKAY:
            print(f"get_isin_from_wkn not working errtext: {self.errtext}")
            isin = ""
        # end if
        return (self.status,isin)
    # end def
    def get_isin_from_wpname(self, wpname):
        '''

        :param wpname:
        :return:
        '''
        (self.status, self.errtext, isin) = wp_wkn.wp_search_wpname(wpname, self.ddict)
        
        if self.status != hdef.OKAY:
            print(f"get_isin_from_wpname not working errtext: {self.errtext}")
            isin = ""
        # end if
        return (self.status, isin)
    
    def find_wpname_in_comment_get_isin(self,comment):
        '''
        
        :param comment:
        :return:
        '''
        
        (self.status, self.errtext, isin) = wp_wkn.wp_search_wpname_in_comment(comment, self.ddict)

        if self.status != hdef.OKAY:
            print(f"find_wpname_in_comment_get_isin not working errtext: {self.errtext}")
        # end if
        return (self.status,isin)
    # end def
    def set_wkn_isin(self, wkn, isin):
        '''

        :param wpname:
        :return:
        '''
        (self.status, self.errtext) = wp_wkn.wp_add_wkn_isin(wkn, isin, self.ddict)
        
        if self.status != hdef.OKAY:
            print(f"set_wkn_isin not working errtext: {self.errtext}")
        # end if
        return self.status
    
    # end def
    def set_wpname_isin(self, wpname, isin):
        '''

        :param wpname:
        :return:
        '''
        (self.status, self.errtext) = wp_wkn.wp_add_wpname_isin(wpname, isin, self.ddict)
        
        if self.status != hdef.OKAY:
            print(f"set_wpname_isin not working errtext: {self.errtext}")
        # end if
        return self.status
    
    # end def
    def check_store_path(self):
        '''
        
        :return:
        '''
        if not os.path.isdir(self.ddict["store_path"]):
            try:
                os.mkdir(self.ddict["store_path"])
            except:
                t = self.ddict["store_path"]
                self.errtext = f"Der store_path: {t} konnte nicht erstellt werden"
                self.status = hdef.NOT_OKAY
            # end try
        # end if


    def check_isin_input(self,isin_input):
        '''
    
        :param isin_input:
        
        :return:
        '''
        self.ddict["isin_input_is_list"] = False
        if isinstance(isin_input, str):
            self.ddict["isin_list"] = [isin_input]
        elif isinstance(isin_input, list):
            (okay, value) = htyp.type_proof(isin_input, "listStr")
            if okay != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = f"isin = {isin_input} ist keine Liste mit strings"
                return
            else:
                self.ddict["isin_input_is_list"] = True
                self.ddict["isin_list"] = value
        else:
            self.errtext = f"isin = {isin_input} ist kein string"
            self.status = hdef.NOT_OKAY
            return
        # end if
        
        for isin in self.ddict["isin_list"]:
            (okay,value) = htyp.type_proof(isin,'isin')
            if okay != hdef.OKAY:
                
                (okay, value) = htyp.type_proof(isin, 'wkn')
                if okay != hdef.OKAY:
                    self.status = hdef.NOT_OKAY
                    self.errtext = f"isin = {isin} ist kein passender Wert"
                    return
                # end if
            # end if
        # end for
    
    # end def

if __name__ == '__main__':


    isin = "AU3TB0000192"
    
    
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
