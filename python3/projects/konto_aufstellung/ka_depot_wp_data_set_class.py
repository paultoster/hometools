
import hfkt_def as hdef
import hfkt_type as htype
import hfkt_list as hlist

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
        self.kategorie = ""
        self.par  = par

        self.status = hdef.OK
        self.errtext = ""
        self.infotext = ""
        self.data_set_obj = ka_class.DataSet("data_set_"+isin)
        
        for index in self.par.DEPOT_DATA_NAME_DICT.keys():
            self.data_set_obj.set_definition(index, self.par.DEPOT_DATA_NAME_DICT[index]
                                             , self.par.DEPOT_DATA_TYPE_DICT[index]
                                             , self.par.DEPOT_DATA_STORE_TYPE_DICT[index])
            if self.data_set_obj.status != hdef.OKAY:
                self.status = self.data_set_obj.status
                self.errtext = self.data_set_obj.errtext
                self.data_set_obj.reset_status()
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
    def reset_status(self):
        self.status = hdef.OKAY
        self.errtext = ""
        self.data_set_obj.reset_status()
    # end def
    def get_name(self):
        '''
        
        :return:
        '''
        return self.wp_info_dict["name"]
    # end def
    def get_n_data(self):
        return self.data_set_obj.n_data_sets
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
                self.data_set_obj.reset_status()
                return None
            # end if
            buchtype = self.data_set_obj.get_data_item(irow,self.par.DEPOT_DATA_NAME_BUCHTYPE)
            if self.data_set_obj.status != hdef.OKAY:
                self.status = self.data_set_obj.status
                self.errtext = self.data_set_obj.errtext
                self.data_set_obj.reset_status()
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
            wert = self.data_set_obj.get_data_item(irow, self.par.DEPOT_DATA_NAME_WERT, "euro")
            if self.data_set_obj.status != hdef.OKAY:
                self.status = self.data_set_obj.status
                self.errtext = self.data_set_obj.errtext
                self.data_set_obj.reset_status()
                return None
            # end if
            buchtype = self.data_set_obj.get_data_item(irow, self.par.DEPOT_DATA_NAME_BUCHTYPE)
            if self.data_set_obj.status != hdef.OKAY:
                self.status = self.data_set_obj.status
                self.errtext = self.data_set_obj.errtext
                self.data_set_obj.reset_status()
                return None
            # end if
            if buchtype == self.par.DEPOT_BUCHTYPE_INDEX_WP_KAUF:
                summe -= wert
            elif buchtype == self.par.DEPOT_BUCHTYPE_INDEX_WP_VERKAUF:
                summe += wert
            elif buchtype == self.par.DEPOT_BUCHTYPE_INDEX_WP_KOSTEN:
                summe -= wert
            elif buchtype == self.par.DEPOT_BUCHTYPE_INDEX_WP_EINNAHMEN:
                summe += wert
            else:
                pass
            # end if
        # end for
        
        (okay, summe) = htype.type_proof(summe, "euro")
        
        return summe
    # end def
    def get_einnahmen_wert(self):
        summe = 0.0
        
        for irow in range(self.data_set_obj.n_data_sets):
            wert = self.data_set_obj.get_data_item(irow, self.par.DEPOT_DATA_NAME_WERT, "euro")
            if self.data_set_obj.status != hdef.OKAY:
                self.status = self.data_set_obj.status
                self.errtext = self.data_set_obj.errtext
                self.data_set_obj.reset_status()
                return None
            # end if
            buchtype = self.data_set_obj.get_data_item(irow, self.par.DEPOT_DATA_NAME_BUCHTYPE)
            if self.data_set_obj.status != hdef.OKAY:
                self.status = self.data_set_obj.status
                self.errtext = self.data_set_obj.errtext
                self.data_set_obj.reset_status()
                return None
            # end if
            if buchtype == self.par.DEPOT_BUCHTYPE_INDEX_WP_EINNAHMEN:
                summe += wert
            else:
                pass
            # end if
        # end for
        
        (okay, summe) = htype.type_proof(summe, "euro")
        
        return summe
    
    # end def
    def get_kategorie(self):
        return self.kategorie
    # end def
    def get_id_of_irow(self,irow):
        '''
        
        :param irow:
        :return:
        '''
        id = self.data_set_obj.get_data_item(irow, self.par.DEPOT_DATA_NAME_KONTO_ID)
        self.status = self.data_set_obj.status
        self.errtext = self.data_set_obj.errtext
        self.data_set_obj.reset_status()
        return id
    # end def
    def set_kategorie(self,kategorie):
        self.kategorie = kategorie
    def set_stored_wp_data_set_dict(self,wp_data_set_dict_list,line_color,header_dict=None,type_dict=None):
        self.status = hdef.OK
        self.errtext = ""
        
        # for i in range(len(wp_data_set_dict_list)):
        #     (okay,wert) = htype.type_transform(wp_data_set_dict_list[i]['wert'],type_dict[6],'euro')
        #     value = abs(wert)
        #     (okay,wert) = htype.type_transform(abs(wert),'euro',type_dict[6])
        #     wp_data_set_dict_list[i]['wert'] = wert
        
        self.data_set_obj.set_data_set_dict_list(wp_data_set_dict_list,line_color,header_dict,type_dict)
        
        if self.data_set_obj.status != hdef.OKAY:
            self.status = self.data_set_obj.status
            self.errtext = self.data_set_obj.errtext
            self.data_set_obj.reset_status()
        # end if
        
        self.data_set_obj.update_order_by_date(self.par.DEPOT_DATA_INDEX_BUCHDATUM)

        if self.data_set_obj.status != hdef.OKAY:
            self.status = self.data_set_obj.status
            self.errtext = self.data_set_obj.errtext
            self.data_set_obj.reset_status()
        # end if

        return self.status
    # end def
    def get_depot_wp_name(self):
        return self.depot_wp_name
    # end def
    def get_wp_immutable_list_from_header_list(self,header_liste):
        '''
        
        :param header_liste:
        :return: immutable_liste = self.get_wp_immutable_list_from_header_list(header_liste)
        '''
        immutable_liste = []
        header_dict = self.data_set_obj.build_name_dict(header_liste)
    
        if self.data_set_obj.status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.data_set_obj.errtext
            self.data_set_obj.reset_status()
            return immutable_liste
        # end if
        
        
        for key in header_dict.keys():
            if key in self.par.DEPOT_DATA_IMMUTABLE_INDEX_LIST:
                immutable_liste.append(True)
            else:
                immutable_liste.append(False)
            # end if
        # end for
        
        return immutable_liste
    # end def
    def get_wp_data_set_dict_to_store(self):
        '''
        
        :return: wp_data_set_dict =  self.get_wp_data_set_dict_to_store()
        '''
        wp_data_set_dict = {}
        
        wp_data_set_dict[self.par.ISIN] = self.isin
        wp_data_set_dict[self.par.WP_NAME] = self.depot_wp_name
        wp_data_set_dict[self.par.WP_KATEGORIE] = self.kategorie
        (wp_data_set_dict[self.par.WP_DATA_SET_DICT_LIST],wp_data_set_dict[self.par.WP_DATA_SET_NAME_DICT],wp_data_set_dict[self.par.WP_DATA_SET_TYPE_DICT] ) \
            = self.data_set_obj.get_data_set_dict_list()
        
        if self.data_set_obj.status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.data_set_obj.errtext
            self.data_set_obj.reset_status()
        # end if

        return wp_data_set_dict
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
    def add_data_set_dict_to_table(self,new_data_dict,new_header_dict,new_type_dict,line_color):
        '''
        
        :param new_data_dict:
        :param new_type_dict:
        :return:
        '''
        
        
        
        self.data_set_obj.add_data_set_dict(new_data_dict,new_header_dict,new_type_dict,line_color)
        
        if self.data_set_obj.status != hdef.OKAY:
            self.status  = self.data_set_obj.status
            self.errtext = self.data_set_obj.errtext
            self.data_set_obj.reset_status()
        # end if
    # end def
    def update_item_if_different(self,id, update_data_dict, update_header_dict,update_type_dict,line_color):
        '''
        
        :param new_data_dict:
        :param new_header_dict:
        :param new_type_dict:
        :return: flag_update = self.update_item_if_different(id, new_data_dict, new_header_dict,new_type_dict,line_color)
        '''
        
        flag_update = False
        
        icol = hlist.find_first_key_dict_value(update_header_dict,self.par.DEPOT_DATA_NAME_KONTO_ID)
        
        if icol is not None:
            irow_list = self.data_set_obj.find_in_col(id, update_type_dict[icol], icol)
            
            if len(irow_list) > 1:
                self.status = hdef.NOT_OKAY
                self.errtext = f"update_item_if_different: id = {id} ist mehrfach vorhanden irow_list = {irow_list}"
                return flag_update
            elif len(irow_list) == 0:
                return flag_update
            # end if
            
            irow = irow_list[0]
            data_set_dict = self.data_set_obj.get_one_data_set_dict(irow,update_header_dict,update_type_dict)
            
            if self.data_set_obj.status != hdef.OKAY:
                self.status = self.data_set_obj.status
                self.errtext = self.data_set_obj.errtext
                self.data_set_obj.reset_status()
                return flag_update
            # end if
            
            for key in data_set_dict.keys():
                
                if data_set_dict[key] != update_data_dict[key]:
                    flag_update =self.data_set_obj.set_data_item(update_data_dict[key], line_color,irow, key, update_type_dict[key])
    
                    if self.data_set_obj.status != hdef.OKAY:
                        self.status = self.data_set_obj.status
                        self.errtext = self.data_set_obj.errtext
                        self.data_set_obj.reset_status()
                        return flag_update
                    # end if
                # end if
            # end for
        return flag_update
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
            self.data_set_obj.reset_status()
        # end if

        return  data_lliste
    # end def
    def get_line_color_set_liste(self):
        return self.data_set_obj.get_line_color_set_liste()
    def get_one_data_set_liste(self,irow,header_liste, type_liste):
        '''
        
        :param irow:
        :param header_liste:
        :param type_liste:
        :return: data_set = self.get_one_data_set_liste(irow,header_liste, type_liste)
        get_one_data_set_liste(self,irow, header_liste, type_liste)
        '''
    
        data_set = self.data_set_obj.get_one_data_set_liste(irow, header_liste, type_liste)
        
        if self.data_set_obj.status != hdef.OKAY:
            self.status = self.data_set_obj.status
            self.errtext = self.data_set_obj.errtext
            self.data_set_obj.reset_status()
        # end if
        
        return data_set
    # end def
    def get_one_data_item(self, irow, header, type):
        '''
        
        :param irow:
        :param header:
        :param type:
        :return: data_item = self.get_one_data_item(irow, header, type)
        '''
    
        data_item = self.data_set_obj.get_one_data_item(irow, header, type)
    
        if self.data_set_obj.status != hdef.OKAY:
            self.status = self.data_set_obj.status
            self.errtext = self.data_set_obj.errtext
            self.data_set_obj.reset_status()
        # end if
    
        return data_item
    # end def
    def set_edit_data_set_in_irow(self,new_data_list, header_liste, type_liste,irow,line_color):
        '''
        
        :param new_data_list:
        :param header_liste:
        :param type_liste:
        :param irow:
        :return: flag = self.set_edit_data_set_in_irow(new_data_list, header_liste, type_liste,irow)
        '''
        self.infotext = ""
        for i,value in enumerate(new_data_list):
            header = header_liste[i]
            type   = type_liste[i]
            
            flag = self.set_item_in_irow(value, header, type,irow,line_color)
            if not flag:
                return False
        # end for
        return True
    # end def
    def set_item_in_irow(self,value, header, type,irow,line_color):
        '''
        
        :param data:
        :param header:
        :param type:
        :param irow:
        :return: flag = self.set_item_in_irow(data, header, type,irow)
        '''
        
        (okay, wert) = htype.type_proof(value, type)
        if okay != hdef.OKAY:
            raise Exception(
                f"Fehler value: {value} kann nicht in  type: {type}  gerechnet werden !!!")
        # end if
        
        icol = self.data_set_obj.find_header_index(header)
        if icol is None:
            self.status = hdef.NOT_OKAY
            self.errtext = self.data_set_obj.errtext
            self.data_set_obj.reset_status()
            return False
        # end if
        value_old = self.data_set_obj.get_data_item(irow, icol, type)
        
        if wert != value_old:
            
            if icol in self.par.DEPOT_DATA_IMMUTABLE_INDEX_LIST:
                self.infotext = f"set_edit_data_set_in_irow: header: {header} / icol: {icol} darf nicht verändert werden"
            else:
                flag = self.data_set_obj.set_data_item(wert,line_color, irow, icol, type)
                if not flag:
                    self.status = hdef.NOT_OKAY
                    self.errtext = self.data_set_obj.errtext
                    self.data_set_obj.reset_status()
                    return False
                # endif
            # end if
        # end if
    
        return True
    # end def
    def delete_in_wp_data_set(self,irow):
        '''
        
        :param irow:
        :return:
        '''
        self.status = self.data_set_obj.delete_row_in_data_set(irow)
        return self.status
    # end def
    def update_order_by_date(self):
        '''
        
        :return: status = self.update_order_by_date()
        '''
        self.data_set_obj.update_order_by_date(self.par.DEPOT_DATA_INDEX_BUCHDATUM)
        
        if self.data_set_obj.status != hdef.OKAY:
            self.status = self.data_set_obj.status
            self.errtext = self.data_set_obj.errtext
            self.data_set_obj.reset_status()
        # end if
        
        return self.status
    # end def
# end class