
import hfkt_def as hdef
import hfkt_type as htype

import ka_data_class_defs as ka_class

class WpDataSet:
    
    
    def __init__(self,isin,depot_wp_name,par,wp_func_obj):
        '''
            self.wp_info_dict["type"] = "etf","aktie"
            self.wp_info_dict["name"]
            self.wp_info_dict["isin"]
            self.wp_info_dict["wkn"]
            self.wp_info_dict["ticker"]
            self.wp_info_dict["zahltdiv"] = 0/1
                                                                    ETF
            self.wp_info_dict["indexabbildung"] = value
            self.wp_info_dict["ertragsverwendung"] = value
            self.wp_info_dict["ter"] = value
            self.wp_info_dict["volumen"] = value
            self.wp_info_dict["anzahl"] = value

        :param isin:
        :param depot_wp_name:
        :param par:
        :param wp_func_obj:
        '''
        self.isin = isin
        self.depot_wp_name = depot_wp_name
        self.par  = par

        self.status = hdef.OK
        self.errtext = ""
        self.infotext = ""
        self.data_set_obj = ka_class.DataSet("data_set_"+isin)
        
        for index in self.par.DEPOT_DATA_NAME_DICT.keys():
            self.data_set_obj.set_definition(index, self.par.DEPOT_DATA_NAME_DICT[index]
                                             , self.par.DEPOT_DATA_TYPE_DICT[index])
            if self.data_set_obj.status != hdef.OKAY:
                self.status = self.data_set_obj.status
                self.errtext = self.data_set_obj.errtext
                break
            # end if
        # end for
        
        # get basic infos
        self.wp_func_obj = wp_func_obj
        (status,errtext,info_dict) = self.wp_func_obj.get_basic_info(isin)
        if status != hdef.OKAY:
            self.status  = hdef.NOT_OKAY
            self.errtext = errtext
        else:
            self.wp_info_dict = info_dict
        # end if
        
        
        return
    # end def
    def get_name(self):
        '''
        
        :return:
        '''
        return self.wp_info_dict["name"]
    # end def
    def get_zahltdiv(self):
        '''
        
        :return:
        '''
        return self.wp_info_dict["zahltdiv"]
    # end def
    def get_summen_anzahl(self):
        '''
        
        :return: Summe der Anzahl von Aktien
        '''
        summe = 0.0
        for irow in range(self.data_set_obj.n_data_sets):
            anzahl = self.data_set_obj.get_data_item(irow,self.par.DEPOT_DATA_NAME_ANZAHL,"float")
            if self.data_set_obj.status != hdef.OKAY:
                self.status = self.data_set_obj.status
                self.errtext = self.data_set_obj.errtext
                return None
            # end if
            buchtype = self.data_set_obj.get_data_item(irow,self.par.DEPOT_DATA_NAME_BUCHTYPE)
            if self.data_set_obj.status != hdef.OKAY:
                self.status = self.data_set_obj.status
                self.errtext = self.data_set_obj.errtext
                return None
            # end if
            if buchtype == self.par.DEPOT_BUCHTYPE_INDEX_WP_KAUF:
                summe += abs(anzahl)
            elif buchtype == self.par.DEPOT_BUCHTYPE_INDEX_WP_VERKAUF:
                summe -= abs(anzahl)
            # end if
        # end for
        
        return summe
    # end def
    def get_summen_wert(self):
        summe = 0.0
    
        for irow in range(self.data_set_obj.n_data_sets):
            wert = self.data_set_obj.get_data_item(irow, self.par.DEPOT_DATA_NAME_WERT, "float")
            if self.data_set_obj.status != hdef.OKAY:
                self.status = self.data_set_obj.status
                self.errtext = self.data_set_obj.errtext
                return None
            # end if
            summe += abs(wert)
        # end for
        
        return summe
    # end def
    def set_stored_wp_data_set_dict(self,wp_data_set_dict):
        self.status = hdef.OK
        self.errtext = ""
        
    # end def
    def get_depot_wp_name(self):
        return self.depot_wp_name
    # end def
    def get_wp_data_set_dict_to_store(self):
        '''
        
        :return: (isin,depot_wp_name,wp_data_set_dict) =  self.get_wp_data_set_dict_to_store()
        '''
        wp_data_set_dict = {}
        
        wp_data_set_dict[self.par.ISIN] = self.isin
        
        return (self.isin,self.depot_wp_name,wp_data_set_dict)
    # end def
    def exist_id_in_table(self,new_id):
        
        liste = self.data_set_obj.find_in_col(new_id
               ,self.par.DEPOT_DATA_TYPE_DICT[self.par.DEPOT_DATA_INDEX_KONTO_ID]
               ,self.par.DEPOT_DATA_INDEX_KONTO_ID)
        
        if liste is None:
            return False
        if len(liste):
            return True
        else:
            return False
        # end if
    # end def
    def add_data_set_dict_to_table(self,new_data_dict,new_header_dict,new_type_dict):
        '''
        
        :param new_data_dict:
        :param new_type_dict:
        :return:
        '''
        
        
        
        self.data_set_obj.add_data_set_dict(new_data_dict,new_header_dict,new_type_dict)
        
        if self.data_set_obj.status != hdef.OKAY:
            self.status  = self.data_set_obj.status
            self.errtext = self.data_set_obj.errtext
        # end if
    # end def
    def get_data_set_lliste(self,header_liste,type_liste):
        '''
        
        :param header_liste:
        :param type_liste:
        :return: data_lliste = self.get_data_setheader_liste,type_liste)
        '''
        
        data_lliste = self.data_set_obj.get_data_set_lliste(header_liste, type_liste)

        if self.data_set_obj.status != hdef.OKAY:
            self.status  = self.data_set_obj.status
            self.errtext = self.data_set_obj.errtext
        # end if

        return  data_lliste
# end class