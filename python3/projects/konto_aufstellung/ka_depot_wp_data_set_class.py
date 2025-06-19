
import hfkt_def as hdef
import hfkt_type as htype

import ka_data_class_defs as ka_class

class WpDataSet:
    
    
    def __init__(self,isin,depot_wp_name,par):
        
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
        return
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
    def add_data_set_dict_to_table(self,new_data_dict,new_type_dict):
        '''
        
        :param new_data_dict:
        :param new_type_dict:
        :return:
        '''
        
        self.data_set_obj.add_data_set_dict(new_data_dict,new_type_dict)
        
        if self.data_set_obj.status != hdef.OKAY:
            self.status  = self.data_set_obj.status
            self.errtext = self.data_set_obj.errtext
# end class