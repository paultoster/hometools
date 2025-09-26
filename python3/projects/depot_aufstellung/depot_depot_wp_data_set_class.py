
import tools.hfkt_def as hdef
import tools.hfkt_type as htype
import tools.hfkt_list as hlist
import tools.hfkt_dict as hdict
import tools.hfkt_tvar as htvar
import tools.hfkt_data_set as hdset

class WpDataSet:
    '''
                                 self.reset_status()
    name:str                   = self.get_name()   get name from info_dict
    n:int                      = self.get_n_data()
    i:int                      = self.get_zahltdiv()
    isin:str                   = self.get_isin()
    kategorie:str              = self.get_kategorie()
    depot_wp_name:str          = self.get_depot_wp_name()
    anzahl:float               = self.get_summen_anzahl()
    summ:euro                  = self.get_summen_wert()
    summ:euro                  = self.get_einnahmen_wert()
    id:int                     = self.get_id_of_irow(irow)
    immutable_liste:list       = self.get_wp_immutable_list_from_header_list(header_liste)
    ttable: class              = self.get_wp_data_set_ttable_to_store()
    data_item                  = self.get_one_data_item(irow, header, type)
    tliste: TList              = self.get_one_data_set_tlist(irow,header_liste, type_liste)
    ttable: TTable             = self.get_data_set_ttable(header_liste,type_liste)
    line_color_liste:list[str] = self.get_line_color_set_liste()
    flag: bool                 = self.exist_id_in_table(id)
                                 self.set_kategorie(kategorie)
    status:int                 = self.set_stored_wp_data_set_ttable(wp_data_set_ttable,line_color)
    flag_update:bool           = self.update_item_if_different(id, tvals,line_color)
    flag:bool                  = self.set_edit_data_set_in_irow(new_data_list, header_liste, type_liste,irow)
    flag:bool                  = self.set_item_in_irow(data_item, header, type,irow,line_color)
    status:int                 = self.delete_in_wp_data_set(irow)
    status:int                 = self.update_order_by_date()
    '''
    
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
        self.data_set_obj = hdset.DataSet("data_set_"+isin)
        
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
        
        self.get_wp_info(isin)
        
        return
    # end def
    def get_wp_info(self,isin):
        '''
        
        :param isin:
        :return:
        '''
    
        (status, errtext, info_dict) = self.wp_func_obj.get_basic_info(isin)
        if status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = errtext
        else:
            self.wp_info_dict = info_dict
        # end if
        return
    # end def
    def reset_status(self):
        '''
        
        :return: self.reset_status()
        '''
        self.status = hdef.OKAY
        self.errtext = ""
        self.data_set_obj.reset_status()
    # end def
    def get_name(self):
        '''
        
        :return: name = self.get_name()
        '''
        return self.wp_info_dict["name"]
    # end def
    def get_depot_wp_name(self):
        '''
        
        :return: depot_ap_name = self.get_depot_wp_name()
        '''
        return self.depot_wp_name
    # end def
    def get_isin(self):
        return self.isin
    # end def
    def get_n_data(self):
        '''
        
        :return: n =  self.get_n_data()
        '''
        return self.data_set_obj.get_n_data()
    # end def
    def get_zahltdiv(self):
        '''
        
        :return: i:int = self.get_zahltdiv()
        '''
        return self.wp_info_dict["zahltdiv"]
    # end def
    def get_kategorie(self):
        '''
        
        :return: kategorie = self.get_kategorie()
        '''
        return self.kategorie
    # end def
    def get_summen_anzahl(self):
        '''
        Summe der Anzahl von Aktien
        :return: anzahl:float = self.get_summen_anzahl()
        '''
        summe = 0.0
        for irow in range(self.data_set_obj.get_n_data()):
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
        
        return float(int(summe*1000. + 0.5))/1000.
    # end def
    def get_summen_wert(self):
        '''
        
        :return: summ:euro = self.get_summen_wert()
        '''
        summe = 0.0
    
        for irow in range(self.data_set_obj.get_n_data()):
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
        '''
        
        :return: summ:euro = self.get_einnahmen_wert()
        '''
        summe = 0.0
        
        for irow in range(self.data_set_obj.get_n_data()):
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
    def get_id_of_irow(self,irow):
        '''
        
        :param irow:
        :return:  id:int = self.get_id_of_irow(irow)
        '''
        id = self.data_set_obj.get_data_item(irow, self.par.DEPOT_DATA_NAME_KONTO_ID)
        self.status = self.data_set_obj.status
        self.errtext = self.data_set_obj.errtext
        self.data_set_obj.reset_status()
        return id
    # end def
    def set_kategorie(self,kategorie):
        '''
        
        :param kategorie:
        :return: self.set_kategorie(kategorie)
        '''
        self.kategorie = kategorie
    def reget_wp_info(self):
        self.get_wp_info(self.isin)
        return
    # end def
    def set_stored_wp_data_set_ttable(self, wp_data_set_ttable: htvar.TTable, line_color: str):
        '''
        
        :param wp_data_set_ttable:
        :param line_color:
        :return:  status:int = self.set_stored_wp_data_set_ttable(wp_data_set_ttable,line_color)
        '''
        self.status = hdef.OK
        self.errtext = ""
        
        if wp_data_set_ttable != None:
        
            self.data_set_obj.add_data_set_tvar( wp_data_set_ttable, line_color)
        
            if self.data_set_obj.status != hdef.OKAY:
                self.status = self.data_set_obj.status
                self.errtext = self.data_set_obj.errtext
                self.data_set_obj.reset_status()
                return self.status
            # end if
        
            self.data_set_obj.update_order_icol(self.par.DEPOT_DATA_INDEX_BUCHDATUM)
        
            if self.data_set_obj.status != hdef.OKAY:
                self.status = self.data_set_obj.status
                self.errtext = self.data_set_obj.errtext
                self.data_set_obj.reset_status()
            # end if
        # end if
        
        return self.status
    
    # end def
    def get_depot_wp_name(self):
        '''
        
        :return: depot_wp_name = self.get_depot_wp_name()
        '''
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
    def get_wp_data_set_ttable_to_store(self):
        '''
        
        :return: ttable =  self.get_wp_data_set_ttable_to_store()
        '''
        return self.data_set_obj.get_data_set_to_store_ttable()
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
    def add_data_set_dict_to_table(self,new_data_tlist: htvar.TList,line_color):
        '''

        :param new_data_dict:
        :param new_type_dict:
        :return:
        '''
        self.data_set_obj.add_data_set_tvar(new_data_tlist,line_color)

        if self.data_set_obj.status != hdef.OKAY:
            self.status  = self.data_set_obj.status
            self.errtext = self.data_set_obj.errtext
            self.data_set_obj.reset_status()
        # end if
    # end def
    def update_item_if_different(self,id, tlist_update: htvar.TList,line_color):
        '''
        
        :param new_data_dict:
        :param new_header_dict:
        :param new_type_dict:
        :return: flag_update = self.update_item_if_different(id, tvals,line_color)
        '''
        
        flag_update = False
        
        # index_liste = hlist.search_value_in_list_return_indexlist(tlist_update.names,self.par.DEPOT_DATA_NAME_KONTO_ID)
        
#        icol = hdict.find_first_key_dict_value(update_header_dict,self.par.DEPOT_DATA_NAME_KONTO_ID)
        
        #if len(index_liste):
            #icol = index_liste[0]
        irow_list = self.data_set_obj.find_in_col(id
                                                  ,self.par.DEPOT_DATA_TYPE_DICT[self.par.DEPOT_DATA_INDEX_KONTO_ID]
                                                  ,self.par.DEPOT_DATA_INDEX_KONTO_ID)
            
        if len(irow_list) > 1:
            self.status = hdef.NOT_OKAY
            self.errtext = f"update_item_if_different: id = {id} ist mehrfach vorhanden irow_list = {irow_list}"
            return flag_update
        elif len(irow_list) == 0:
            return flag_update
        # end if
            
        irow = irow_list[0]
        data_set_tlist = self.data_set_obj.get_one_data_set_tlist(irow,tlist_update.names,tlist_update.types)
        
        if self.data_set_obj.status != hdef.OKAY:
            self.status = self.data_set_obj.status
            self.errtext = self.data_set_obj.errtext
            self.data_set_obj.reset_status()
            return flag_update
        # end if
            
        for index,name in enumerate(data_set_tlist.names):
            
            if data_set_tlist.vals[index] != tlist_update.vals[index]:
                
                flag_update =self.data_set_obj.set_data_item(tlist_update[index], line_color,irow, name, tlist_update.types[index])

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
    def get_data_set_ttable(self,header_liste,type_liste):
        '''

        :param header_liste:
        :param type_liste:
        :return: ttable = self.get_data_set_ttable(header_liste,type_liste)
        '''

        ttable = self.data_set_obj.get_data_set_ttable(header_liste, type_liste)

        if self.data_set_obj.status != hdef.OKAY:
            self.status  = self.data_set_obj.status
            self.errtext = self.data_set_obj.errtext
            self.data_set_obj.reset_status()
        # end if

        return  ttable
    # end def
    def get_line_color_set_liste(self):
        '''
        
        :return: line_color_liste = self.get_line_color_set_liste()
        '''
        return self.data_set_obj.get_line_color_set_liste()
    def get_one_data_set_tlist(self,irow,header_liste, type_liste):
        '''

        :param irow:
        :param header_liste:
        :param type_liste:
        :return: tliste = self.get_one_data_set_tlist(irow,header_liste, type_liste)
        
        '''

        data_set_tlist = self.data_set_obj.get_one_data_set_tlist(irow, header_liste, type_liste)

        if self.data_set_obj.status != hdef.OKAY:
            self.status = self.data_set_obj.status
            self.errtext = self.data_set_obj.errtext
            self.data_set_obj.reset_status()
        # end if

        return data_set_tlist
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
    def set_edit_data_set_in_irow(self,tliste:htvar.TList,irow,line_color):
        '''
        
        :param new_data_list:
        :param header_liste:
        :param type_liste:
        :param irow:
        :return: flag = self.set_edit_data_set_in_irow(new_data_list, header_liste, type_liste,irow)
        '''
        self.infotext = ""
        
        for i,value in enumerate(tliste.vals):
            header = tliste.names[i]
            type   = tliste.types[i]
            
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
        :return: flag = self.set_item_in_irow(data, header, type,irow,line_color)
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
        :return: status = self.delete_in_wp_data_set(irow)
        '''
        self.status = self.data_set_obj.delete_row_in_data_set(irow)
        return self.status
    # end def
    def update_order_by_date(self):
        '''
        
        :return: status = self.update_order_by_date()
        '''
        self.data_set_obj.update_order_icol(self.par.DEPOT_DATA_INDEX_BUCHDATUM)
        
        if self.data_set_obj.status != hdef.OKAY:
            self.status = self.data_set_obj.status
            self.errtext = self.data_set_obj.errtext
            self.data_set_obj.reset_status()
        # end if
        
        return self.status
    # end def
# end class