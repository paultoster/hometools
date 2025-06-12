import os, sys, time

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

import wp_abfrage.wp_basic_info_fkt as wp_basic
import wp_storage

import tools.hfkt_def as hdef
import tools.hfkt_type as htyp

class WPData:
    '''
    Hilfsfunktionen:
    self.check_store_path()
    self.check_isin_input(isin_input)
    
    '''
    def __init__(self,store_path,use_json):
        self.ddict = {}
        self.ddict["store_path"] = store_path
        self.ddict["pre_file_name"] = "wp_data_"
        self.ddict["use_json"] = use_json # 0: don't 1: write, 2: read
        self.ddict["isin_input_is_list"] = False
        self.ddict["isin_list"] = []
        self.ddict["output_list"] = []
        self.ddict["wp_isin_file_dict_list"] = []

        self.status = hdef.OKAY
        self.errtext = ""

        self.check_store_path()
    # end def
    def get_basic_info(self, isin_input):
        '''

        :param isin:
        :return:
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
        
        self.ddict["output_list"] = [None] * len(self.ddict["isin_list"])
        for i, isin in enumerate(self.ddict["isin_list"]):
            
            print(f"Build basic_info from isin: {isin}:")
            start_time = time.time()
            
            # basic info data einlesen
            if wp_storage.info_storage_eixst(isin, self.ddict):
                print(f"            ... read File")
                (status, errtext, info_dict) = wp_storage.read_info_dict(isin, self.ddict)
            else:
                print(f"            ... read HTML")
                (status, errtext, info_dict) = wp_basic.wp_basic_info_fkt(isin, self.ddict)
                if status == hdef.OKAY:
                    (status, errtext) = wp_storage.save_info_dict(isin, info_dict, self.ddict)
                # end if
            # end if
            
            if status == hdef.OKAY:
                self.ddict["output_list"][i] = info_dict
            else:
                self.status = status
                self.errtext = errtext
                return (self.status, self.errtext, None)
            # end if
            
            end_time = time.time()
            print('Execution time: ', end_time - start_time, ' s')
        # end for
        
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
                self.status = hdef.NOT_OKAY
                self.errtext = f"isin = {isin} ist kein passender Wert"
                return
            # end dif
        # end for
    
    # end def

if __name__ == '__main__':
    isin = ["IE00B4L5Y983","IE00BKZGB098","DE0007100000"]
    
    store_path = "K:/data/orga/wp_store"
    use_json = 0 # 0: don't 1: write, 2: read
    wp = WPData(store_path,use_json)
    if wp.status != hdef.OKAY:
        print(f"WPData: Fehler  errtext = {wp.errtext}")
        exit(1)
    # end if
    
    (status,errtext,info_dict_list) = wp.get_basic_info(isin)
    if status != hdef.OKAY:
        print(f"get_basic_info: Fehler   errtext = {errtext}")
        exit(1)
    # end if
    
    for info_dict in info_dict_list:
        print(info_dict)
