#
#
#   beinhaltet class DateSet zur Behandlung daten in einer Tabelle
#
import os, sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif


import tools.hfkt_def as hdef
import tools.hfkt_type as htype
import tools.hfkt_list as hlist
import tools.hfkt_dict as hdict
import tools.hfkt_tvar as htvar

class DataSet:
    '''
        :return:                    self.set_definition(icol, name, type)  definiere für icol (Spalte) das dutum mit name und dem type
                 status           = self.add_data_set_tvar(data_set_tlist,[line_color=""])
                 status           = self.add_data_set_tvar(data_set_ttable,[line_color=""])
                 value            = self.get_data_item(irow, icol [,type])
                 value            = self.get_data_item(irow, headername [,type])
                 value            = self.get_data_item_special(calc_type, icol [,type]): calc_type = "sum"
                 value            = self.get_data_item_special(calc_type, headername [,type]): calc_type = "sum"
                 irow_list        = self.find_in_col(value,type, icol)
                 irow_list        = self.find_in_col(value,type, headername)
                 icol             = self.find_header_index(header)
                 ttable:class     = self.get_data_set_to_store_ttable()
                 ttable:class     = self.get_data_set_ttable([[header_liste],type_liste])
                 tlist:class      = self.get_one_data_set_tlist(irow, [header_liste, [type_liste]])
                 liste:list       = self.get_row_list_of_icol(icol, [type])
                 liste:list       = self.get_row_list_of_header(headername, [type])
                 type             = self.get_type_of_icol(icol)
                 type             = self.get_type_of_header(header)
                 data_type_dict   = self.get_data_type_dict()  data_type_dict[name] = type
                 flag             = self.set_data_item(value,line_color,irow, icol, type)
                 flag             = self.set_data_item(value,line_color,irow, name, type)
                 flag             = self.set_data_item(value,line_color,irow, icol)
                 flag             = self.set_data_item(value,line_color,irow, name)
                 status           = self.set_data_tlist(tlist,line_color,irow)
                 status           = self.delete_row_in_data_set(irow)
                 
                                    self.update_order_icol(icol)
                                    self.update_order_name(self, name)
    '''
    def __init__(self ,name):
        self.name = name
        self.data_set_llist = []
        self.line_color_liste = []
        self.ncol = 0
        self.n_data_sets = 0
        self.name_dict = {}
        self.type_dict = {}
        self.store_type_dict = {} # is type for storing get_data_set_dict_list() und set_data_set_dict_list()
        self.def_okay  = False   # is definition okay
        self.status    = hdef.OKAY
        self.errtext   = ""
    def reset_status(self):
        self.status = hdef.OKAY
        self.errtext = ""
    # end def
    def set_definition(self ,icol :int ,name :str ,type: str | list ,store_type: str| list):
        '''
        Deinition einer Spalte
        :param icol: Spalte gezählt von 0
        :param name: Name der Spalte
        :param type: type der Spalte
        :return: self.set_definition(icol, name, type)  definiere für icol (Spalte) das dutum mit name und dem type
        '''
        if icol in self.name_dict:
            self.status = hdef.NOT_OKAY
            self.errtext = f"set_definition: Spalte col = {icol} ist schon definiert"
            return
        else:
            self.name_dict[icol] = name
            self.type_dict[icol] = type
            self.store_type_dict[icol] = store_type
            self.name_dict = dict(sorted(self.name_dict.items()))
            self.type_dict = dict(sorted(self.type_dict.items()))
            key_list = list(self.name_dict.keys())
            if key_list[-1] == (len(key_list ) -1): # Wenn letzter key gleich Anzahl in der Liste minus eins
                self.def_okay = True
                self.ncol     = len(self.name_dict)
            else:
                self.def_okay = False
                self.ncol = 0
            # end if
        # end if
        return
    # end def
    def get_n_data(self):
        self.n_data_sets = len(self.data_set_llist)
        return self.n_data_sets
    # end def
    def add_data_set_tvar(self ,tvar: htvar.TTable | htvar.TList ,line_color :str = ""):
        '''
        
        :param self:
        :param tvar:
        :param line_color:
        :return: status = self.add_data_set_tvar(tvar,[line_color=""])
                 status = self.add_data_set_tvar(data_set_tlist,[line_color=""])
                 status = self.add_data_set_tvar(data_set_ttable,[line_color=""])
        '''

        if isinstance(tvar, htvar.TTable):
            return self.add_data_set_ttable(tvar,line_color)
        else:
            return self.add_data_set_tlist(tvar, line_color)
        # end if
    # end def
    def add_data_set_ttable(self ,new_ttable: htvar.TTable ,line_color :str = ""):
        
        if (not self.def_okay):
            self.status = hdef.NOT_OKAY
            self.errtext = f"add_data_set_dict: Definition der TAbelle nicht okay def_okay = False "
            return self.status
        # end if
        
        for i in range(new_ttable.ntable):
            
            data_set_list = [htype.type_get_default(self.type_dict[icol]) for icol in range(self.ncol)]

            for j in range(new_ttable.n):
            
                name = new_ttable.names[j]
                type = new_ttable.types[j]
                value = new_ttable.table[i][j]
                
                # suche in self.name_dict
                key_name_dict = hdict.find_first_key_dict_value(self.name_dict, name)
            
                if key_name_dict is not None:
                    (okay, wert) = htype.type_transform(value, type, self.type_dict[key_name_dict])
                
                    if okay == hdef.OK:
                        data_set_list[key_name_dict] = wert
                    else:
                        self.status = hdef.NOT_OKAY
                        self.errtext = f"add_data_set_dict: Problem type_transform of <{value}> von type: <{type}> zu <{self.type_dict[key_name_dict]}> "
                        return self.status
                    # end if
                # end if
            # end for
            self.data_set_llist.append(data_set_list)
            self.line_color_liste.append(line_color)
            self.n_data_sets += 1
        # end for
        
        
        return self.status
    # end def
    def add_data_set_tlist(self, new_tlist: htvar.TList, line_color: str = ""):
        
        if (not self.def_okay):
            self.status = hdef.NOT_OKAY
            self.errtext = f"add_data_set_tlist: Definition der TTable nicht okay def_okay = False "
            return self.status
        # end if
        
        
        data_set_list = [htype.type_get_default(self.type_dict[icol]) for icol in range(self.ncol)]
        
        for j in range(new_tlist.n):
            
            name = new_tlist.names[j]
            type = new_tlist.types[j]
            value = new_tlist.vals[j]
            
            # suche in self.name_dict
            key_name_dict = hdict.find_first_key_dict_value(self.name_dict, name)
            
            if key_name_dict is not None:
                (okay, wert) = htype.type_transform(value, type, self.type_dict[key_name_dict])
                
                if okay == hdef.OK:
                    data_set_list[key_name_dict] = wert
                else:
                    self.status = hdef.NOT_OKAY
                    self.errtext = f"add_data_set_tlist: Problem type_transform of <{value}> von type: <{type}> zu <{self.type_dict[key_name_dict]}> "
                    return self.status
                # end if
            # end if
        # end for
        self.data_set_llist.append(data_set_list)
        self.line_color_liste.append(line_color)
        self.n_data_sets += 1
        
        return self.status
    # end def
    # def add_data_set_dict(self ,new_data_dict: dict ,new_header_dict: dict ,new_type_dict :dict ,line_color :str):
    #     '''
    #
    #     :param new_data_dict:
    #     :param new_header_dict:
    #     :param new_type_dict:
    #     :return: status = self.add_data_set_dict(new_data_dict: dict,new_header_dict: dict,new_type_dict:dict)
    #     '''
    #
    #     if( not self.def_okay ):
    #         self.status = hdef.NOT_OKAY
    #         self.errtext = f"add_data_set_dict: Definition der TAbelle nicht okay def_okay = False "
    #         return self.status
    #     # end if
    #
    #     data_set_list =  [htype.type_get_default(self.type_dict[icol]) for icol in range(self.ncol)]
    #     for key in new_data_dict.keys():
    #         new_name = new_header_dict[key]
    #
    #         # suche in self.name_dict
    #         key_name_dict = hdict.find_first_key_dict_value(self.name_dict ,new_name)
    #
    #         if key_name_dict is not None:
    #             (okay, wert) = htype.type_transform(new_data_dict[key], new_type_dict[key],
    #                                                 self.type_dict[key_name_dict])
    #             if okay == hdef.OK:
    #                 data_set_list[key_name_dict] = wert
    #             else:
    #                 self.status = hdef.NOT_OKAY
    #                 self.errtext = f"add_data_set_dict: Problem type_transform of <{new_data_dict[key]}> von type: <{new_type_dict[key]}> zu <{self.type_dict[key_name_dict]}> "
    #                 return self.status
    #             # end if
    #         # end if
    #     # end for
    #
    #     self.data_set_llist.append(data_set_list)
    #     self.line_color_liste.append(line_color)
    #     self.n_data_sets += 1
    #
    #     return self.status
    # # end if
    
    def get_data_item(self, irow: int, icol: int |str, type: any = None):
        '''

        :param icol:
        :param irow:
        :param type:
        :return: wert = self.get_data_item(irow, icol [, type])
        :return: wert = self.get_data_item(irow, headername [,type])
        '''
        if isinstance(icol ,str): # header name
            # search headername
            key = self.find_header_index(icol)
            if key is None:
                self.status = hdef.NOT_OKAY
                self.errtext = f"get_data_item_by_header:  Fehler headername = {icol} kann nicht im header of data_set gefunden werden (header_dict: {self.name_dict.items()} !!!"
                return None
            else:
                icol = key
            # end if
        # end if
        
        if irow >= self.n_data_sets:
            self.status = hdef.NOT_OKAY
            self.errtext = f"get_data_item:  Fehler irow = {irow} >= self.n_data_sets = {self.n_data_sets} !!!"
            return None
        # end if
        if icol >= self.ncol:
            self.status = hdef.NOT_OKAY
            self.errtext = f"get_data_item: Fehler get_data_item: icol = {icol} >= self.ncol = {self.ncol} !!!"
            return None
        # end if
        if type:
            (okay, wert) = htype.type_transform(self.data_set_llist[irow][icol], self.type_dict[icol] ,type)
            if okay != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = f"get_data_item: Fehler transform data_item = {self.data_set_llist[irow][icol]} von type: {self.type_dict[icol]} in type {type} wandeln !!! !!!"
                return None
            # end if
        else:
            wert = self.data_set_llist[irow][icol]
        # end if
        return wert
    # end def
    def get_data_item_special(self, calc_type: str, icol: int |str, type: any = None):
        '''

        :param calc_type:  bis jetzt summe
        :param icol/headername:  icol integer or name des Haders
        :param type: wenn in ein bestimten type umgerechnet werden soll
        :return: wert = self.get_data_item_by_header("sum", icol [,type])
        :return: wert = self.get_data_item_by_header("sum", "headername" [,type])
        '''
        
        
        # calc_type == "sum":
        #   calc_type = 'sum'
        # else:
        #    calc_type = 'value'
        
        wert = 0.0
        for irow in range(self.n_data_sets):
            self.get_data_item(self, irow, icol, "float")
            value = htype.type_transform(self.data_set_llist[irow][icol]
                                         , self.type_dict[icol], "float")
            if not value:
                return None
            # end if
            wert += value
        # end for
        if type:
            (okay, wert) = htype.type_transform(wert,
                                                self.type_dict[icol], type)
            if okay != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = f"get_data_item_by_header: Fehler transform data_item = {self.data_set_llist[irow][icol]} von type: {self.type_dict[icol]} in type {type} wandeln !!! !!!"
                return None
            # end if
        # end if
        
        return wert
    
    # end def
    def find_in_col(self, value, type, icol):
        '''

        :param value:
        :param type:
        :param icol:
        :return: irow_list = self.find_in_col(value,type, icol)
                 irow_list = self.find_in_col(value,type, name)
        '''
        
        irow_list = []
        
        if isinstance(icol, str):  # header name
            # search headername
            key = self.find_header_index(icol)
            if key is None:
                self.status = hdef.NOT_OKAY
                self.errtext = f"find_in_col:  Fehler headername = {icol} kann nicht im header of data_set gefunden werden (header_dict: {self.name_dict.items()} !!!"
                return []
            else:
                icol = key
            # end if
        # end if

        
        if( icol >= self.ncol):
            self.status = hdef.NOT_OKAY
            self.errtext = f"find_in_col: Fehler in find_in_col  icol = {icol} ist >= self.ncol  {self.ncol} !!!"
            return
        # end if
        for i, data_set in enumerate(self.data_set_llist):
            (okay ,val_intern) = htype.type_transform(data_set[icol] ,self.type_dict[icol] ,type)
            if okay != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = f"find_in_col:  Fehler transform data_item = <{data_set[icol]}> von type: <{self.type_dict[icol]}> in type {type} wandeln !!!!!!"
                return
            if val_intern == value:
                irow_list.append(i)
            # end if
        # end for
        return irow_list
    # end def
    def find_header_index(self ,header):
        '''

        :param header:
        :return: icol = self.find_header_index(header)
        '''
        
        # search headername
        key = hdict.find_first_key_dict_value(self.name_dict, header)
        
        if key is None:
            self.status = hdef.NOT_OKAY
            self.errtext = f"find_header_index:  Fehler headername = {header} kann nicht im header of data_set gefunden werden (header_dict: {self.name_dict.items()} !!!"
            return None
        # end if
        return key # == icol
    # end def
    def get_data_set_to_store_ttable(self):
        '''
        
        :return: ttable = self.get_data_set_to_store_ttable()
        '''
        return self.get_data_set_ttable()
    def get_data_set_ttable(self ,header_liste=None ,type_liste=None):
        '''
         data_dict_list = self.get_data_set_dict_list()
        :return: ttable = self.get_data_set_ttable(,header_liste=None ,type_liste=None)
        '''
        
        if header_liste is None:
            name_dict = self.name_dict
            type_dict = self.store_type_dict
        else:
            (name_dict ,type_dict) = self.build_name_and_type_dict(header_liste ,type_liste)
            if self.status != hdef.OKAY:
                return []
        # end if
        
        vals = []
        names = list(name_dict.values())
        types = list(type_dict.values())
        n     = len(names)
        
        for liste in self.data_set_llist:
            val_liste = [None for i in range(n)]
            for index,name in enumerate(names):
                
                key = hdict.find_first_key_dict_value(self.name_dict, name)
                if key is None:
                    self.status = hdef.NOT_OKAY
                    self.errtext = f"find_header_index:  Fehler headername = {name} kann nicht im header of data_set gefunden werden (header_dict: {self.name_dict.values()} !!!"
                    return None
                # end if
                
                if types[index] != self.type_dict[key]:
                    (okay, value) = htype.type_transform(liste[key], self.type_dict[key], types[index])
                    if okay != hdef.OKAY:
                        self.status = hdef.NOT_OKAY
                        self.errtext = f"get_data_set_dict_list:  Fehler transform data_item = <{liste[key]}> von type: <{self.type_dict[key]}> in type {types[index]} wandeln !!!!!!"
                        return []
                else:
                    value = liste[key]
                # end if
                val_liste[index] = value
            # end for
            vals.append(val_liste)
        # end for
        
        ttable = htvar.build_table(names,vals,types)
        
        return (ttable)
    # end def
    def get_one_data_set_tlist(self,irow,header_liste=None,type_liste=None):
        '''
        
        :param irow:
        :param header_liste:
        :param type_liste:
        :return: tlist:class = self.get_one_data_set_tlist(irow, header_liste, type_liste)
        '''
        
        if header_liste is None:
            name_dict = self.name_dict
            type_dict = self.store_type_dict
        else:
            (name_dict, type_dict) = self.build_name_and_type_dict(header_liste, type_liste)
            if self.status != hdef.OKAY:
                return []
        # end if
        
        vals = []
        names = list(name_dict.values())
        types = list(type_dict.values())
        n = len(names)
        
        if self.n_data_sets:
        
            if irow >= self.n_data_sets:
                irow = self.n_data_sets-1
        
            liste = self.data_set_llist[irow]
            vals = [None for i in range(n)]
            for index, name in enumerate(names):
                
                key = hdict.find_first_key_dict_value(self.name_dict, name)
                if key is None:
                    self.status = hdef.NOT_OKAY
                    self.errtext = f"find_header_index:  Fehler headername = {name} kann nicht im header of data_set gefunden werden (header_dict: {self.name_dict.values()} !!!"
                    return None
                # end if
                
                if types[index] != self.type_dict[key]:
                    (okay, value) = htype.type_transform(liste[key], self.type_dict[key], types[index])
                    if okay != hdef.OKAY:
                        self.status = hdef.NOT_OKAY
                        self.errtext = f"get_data_set_dict_list:  Fehler transform data_item = <{liste[key]}> von type: <{self.type_dict[key]}> in type {types[index]} wandeln !!!!!!"
                        return []
                else:
                    value = liste[key]
                # end if
                vals[index] = value
            # end for
        # end if
        
        tlist = htvar.build_list(names, vals, types)
        
        return (tlist)
    def get_row_list_of_header(self,header,type=None):
        '''
        
        :param header:
        :param type:
        :return: row_list = self.get_row_list_of_header(header,[type])
        '''
        index = self.find_header_index(header)
        if index == None:
            return []
        # end if
        return self.get_row_list_of_icol(index,type)
    # end def
    def get_row_list_of_icol(self,icol,type=None):
        '''
        
        :param icol:
        :param type:
        :return: row_list = self.get_row_list_of_icol(icol,[type])
        '''
        if self.ncol == 0:
            self.status = hdef.NOT_OKAY
            self.errtext = f"get_row_list_of_icol:  Fehler ncol == 0 wandeln !!!!!!"
            return []
        # end if
        
        if icol >= self.ncol:
            icol = self.ncol-1
            
        row_list = []
        if type == None:
            for irow in range(self.n_data_sets):
                row_list.append(self.data_set_llist[irow][icol])
            # end for
        else:
            for irow in range(self.n_data_sets):
                (okay, value) = htype.type_transform(self.data_set_llist[irow][icol], self.type_dict[icol], type)
                if okay != hdef.OKAY:
                    self.status = hdef.NOT_OKAY
                    self.errtext = f"get_row_list_of_icol:  Fehler transform data_item[{irow}][{icol}] = <{self.data_set_llist[irow][icol]}> von type: <{self.type_dict[icol]}> in type: {type} wandeln !!!!!!"
                    return []
                # end if
                row_list.append(value)
            # end for
        # end if
        return row_list
    # end def
    def get_type_of_header(self,header):
        '''
        
        :param header:
        :return: type = self.get_type_of_header(header)
        '''
        index = self.find_header_index(header)
        if index == None:
            return ""
        # end if
        return self.get_type_of_icol(index)
    # end def
    def get_type_of_icol(self,icol):
        '''
        
        :param icol:
        :return: type = self.get_type_of_icol(icol)
        '''
        
        if self.ncol == 0:
            self.status = hdef.NOT_OKAY
            self.errtext = f"get_type_of_icol:  Fehler ncol == 0 wandeln !!!!!!"
            return []
        # end if
        
        if icol >= self.ncol:
            icol = self.ncol - 1
        
        return self.type_dict[icol]
    # end def
    def build_name_and_type_dict(self, header_liste, type_liste):
        '''

        :param header_liste:
        :param type_liste:
        :return:
        '''
        
        header_dict = {}
        type_dict = {}
        for i, header in enumerate(header_liste):
            
            key = self.find_header_index(header)
            if key is None:
                return ({}, {})
            # end if
            header_dict[key] = header
            type_dict[key] = type_liste[i]
        
        # end for
        
        return (header_dict, type_dict)
    
    def build_name_dict(self, header_liste):
        '''

        :param header_liste:
        :param type_liste:
        :return:
        '''
        
        header_dict = {}
        
        for i, header in enumerate(header_liste):
            
            key = self.find_header_index(header)
            if key is None:
                return {}
            # end if
            header_dict[key] = header
        
        # end for
        
        return header_dict
    # end def
    def get_data_type_dict(self):
        '''

        :return: data_type_dict = self.get_data_type_dict()
        '''
        data_type_dict = {}
        for key in self.name_dict.keys():
            data_type_dict[self.name_dict[key]] = self.type_dict[key]
        # end for
        
        return data_type_dict
    # end def
    def get_data_set_lliste(self ,header_liste ,type_liste):
        '''

        :param header_liste:
        :param type_liste:
        :return: data_set_lliste = self.get_data_set_lliste(header_liste,type_liste)
        '''
        output_data_lliste = []
        icol_liste = []
        for header in header_liste:
            key = self.find_header_index(header)
            if  key is None:
                return output_data_lliste
            else:
                icol_liste.append(key)
            # end if
        # end if
        n = len(icol_liste)
        
        for data_liste in self.data_set_llist:
            output_data_liste = [None for j in range(n)]
            for i ,icol in enumerate(icol_liste):
                (okay, value) = htype.type_transform(data_liste[icol], self.type_dict[icol], type_liste[i])
                if okay != hdef.OKAY:
                    self.status = hdef.NOT_OKAY
                    self.errtext = f"get_data_set_lliste:  Fehler transform data_item = <{data_liste[icol]}> von type: <{self.type_dict[icol]}> in type {type_liste[i]} wandeln !!!!!!"
                    return []
                # end if
                output_data_liste[i] = value
            # end for
            output_data_lliste.append(output_data_liste)
        # end for
        return output_data_lliste
    # end def
    def get_line_color_set_liste(self):
        '''

        :param header_liste:
        :return: line_color_liste = self.get_line_color_set_liste()
        '''
        return self.line_color_liste
    def get_one_data_set_dict(self ,irow, header_dict_or_list: list |dict, type_dict_or_list: list |dict):
        '''

        :param irow:
        :param header_dict:
        :param type_dict:
        :return: ddict = self.get_one_data_set_dict(irow, header_dict, type_dict):
        '''
        if isinstance(header_dict_or_list ,list):
            (name_dict ,type_dict) = self.build_name_and_type_dict(header_dict_or_list ,type_dict_or_list)
            if self.status != hdef.OKAY:
                return self.status
            # end if
        else:
            name_dict = header_dict_or_list
            type_dict = type_dict_or_list
        # end if
        
        icol_liste = []
        for key in name_dict.keys():
            icol_liste.append(key)
        # end for
        n = len(icol_liste)
        
        data_liste = self.data_set_llist[irow]
        output_data_set_dict = {}
        for icol in icol_liste:
            (okay, value) = htype.type_transform(data_liste[icol], self.type_dict[icol], type_dict[icol])
            if okay != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = f"get_one_data_set_dict:  Fehler transform data_item = <{data_liste[icol]}> von type: <{self.type_dict[icol]}> in type {type_dict[icol]} wandeln !!!!!!"
                return {}
            # end if
            output_data_set_dict[icol] = value
        # end for
        
        return output_data_set_dict
    
    def get_one_data_set_liste(self ,irow, header_liste, type_liste):
        '''

        :param header_liste:
        :param type_liste:
        :return: output_data_set = self.get_one_data_set_liste(irow,header_liste,type_liste)
        '''
        output_data_set = []
        icol_liste = []
        for header in header_liste:
            key = hdict.find_first_key_dict_value(self.name_dict, header)
            if key is None:
                self.status = hdef.NOT_OKAY
                self.errtext = f"get_one_data_set_liste:  Fehler header = {header} ist nicht in name_dict = {self.name_dict} !!!!!!"
                return output_data_set
            else:
                icol_liste.append(key)
            # end if
        # end if
        n = len(icol_liste)
        
        if irow >= self.n_data_sets:
            self.status = hdef.NOT_OKAY
            self.errtext = f"find_in_col:  Fehler irow = <{irow}> is größßer gleich n_data_sets: <{self.n_data_sets}> !!!!!!"
            return output_data_set
        # end if
        
        data_liste = self.data_set_llist[irow]
        
        
        output_data_set = [None for j in range(n)]
        for i, icol in enumerate(icol_liste):
            (okay, value) = htype.type_transform(data_liste[icol], self.type_dict[icol], type_liste[i])
            if okay != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = f"get_one_data_set_liste:  Fehler transform data_item = <{data_liste[icol]}> von type: <{self.type_dict[icol]}> in type {type_liste[i]} wandeln !!!!!!"
                return []
            # end if
            output_data_set[i] = value
        # end for
        
        
        return output_data_set
    # end def
    def get_one_data_item(self, irow, header, type):
        '''

        :param header_liste:
        :param type_liste:
        :return: data_item = self.get_one_data_item(irow,header,type)
        '''
        key = hdict.find_first_key_dict_value(self.name_dict, header)
        if key is None:
            self.status = hdef.NOT_OKAY
            self.errtext = f"get_one_data_set_liste:  Fehler header = {header} ist nicht in name_dict = {self.name_dict} !!!!!!"
            return None
        else:
            icol = key
        # end if
        
        if irow >= self.n_data_sets:
            self.status = hdef.NOT_OKAY
            self.errtext = f"find_in_col:  Fehler irow = <{irow}> is größßer gleich n_data_sets: <{self.n_data_sets}> !!!!!!"
            return None
        # end if
        
        data_item = self.data_set_llist[irow][icol]
        (okay, value) = htype.type_transform(data_item, self.type_dict[icol], type)
        if okay != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = f"get_one_data_set_liste:  Fehler transform data_item = <{data_item}> von type: <{self.type_dict[icol]}> in type {type} wandeln !!!!!!"
            return None
        else:
            data_item = value
        # end if
        
        return data_item
    
    # end def
    def set_data_item(self, value: any ,line_color, irow: int, icol: int | str, type: any = None):
        '''

        :param irow:
        :param icol:
        :param type:
        :return: flag = self.set_data_item(value,line_color,irow, icol, type)
                 flag = self.set_data_item(value,line_color,irow, name, type)
                 flag = self.set_data_item(value,line_color,irow, icol)
                 flag = self.set_data_item(value,line_color,irow, name)
        '''
        
        if isinstance(icol, str):  # header name
            # search headername
            key = self.find_header_index(icol)
            if key is None:
                self.status = hdef.NOT_OKAY
                self.errtext = f"get_data_item_by_header:  Fehler headername = {icol} kann nicht im header of data_set gefunden werden (header_dict: {self.name_dict.items()} !!!"
                return False
            else:
                icol = key
            # end if
        # end if
        
        if irow >= self.n_data_sets:
            self.status = hdef.NOT_OKAY
            self.errtext = f"set_data_item:  Fehler irow = {irow} >= self.n_data_sets = {self.n_data_sets} !!!"
            return False
        # end if
        if icol >= self.ncol:
            self.status = hdef.NOT_OKAY
            self.errtext = f"set_data_item: Fehler get_data_item: icol = {icol} >= self.ncol = {self.ncol} !!!"
            return False
        # end if
        if type:
            (okay, wert) = htype.type_transform(value, type ,self.type_dict[icol])
            if okay != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = f"set_data_item: Fehler transform data_item = {value} von type: {type}  in type {self.type_dict[icol]} wandeln !!! !!!"
                return False
            # end if
            self.data_set_llist[irow][icol] = wert
            self.line_color_liste[irow] = line_color
        else: # ohne type
            (okay, wert) = htype.type_proof(value, self.type_dict[icol])
            if okay != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = f"set_data_item: Fehler type_proof data_item = {value} sollte type: {self.type_dict[icol]} sein !!! !!!"
                return False
            # end if
            self.data_set_llist[irow][icol] = wert
            self.line_color_liste[irow] = line_color
        # end if
        return True
    # end def
    def set_data_tlist(self,tlist, line_color, irow):
        '''
        
        :param tlist:
        :param line_color:
        :param irow:
        :return: status = self.update_data_tlist(tlist, line_color, irow)
        '''
        
        if (not self.def_okay):
            self.status = hdef.NOT_OKAY
            self.errtext = f"add_data_set_tlist: Definition der TTable nicht okay def_okay = False "
            return self.status
        # end if

        if irow == self.n_data_sets:
            return self.add_data_set_tvar(tlist, line_color)
        elif irow > self.n_data_sets:
        
            self.status = hdef.NOT_OKAY
            self.errtext = f"update_data_tlist:  Fehler irow = {irow} >= self.n_data_sets = {self.n_data_sets} !!!"
            return self.status
        # end if
    
        
        for j in range(tlist.n):
        
            name = tlist.names[j]
            type = tlist.types[j]
            value = tlist.vals[j]
        
            # suche in self.name_dict
            key_name_dict = hdict.find_first_key_dict_value(self.name_dict, name)
        
            if key_name_dict is not None:
                (okay, wert) = htype.type_transform(value, type, self.type_dict[key_name_dict])
            
                if okay == hdef.OK:
                    self.data_set_llist[key_name_dict] = wert
                else:
                    self.status = hdef.NOT_OKAY
                    self.errtext = f"add_data_set_tlist: Problem type_transform of <{value}> von type: <{type}> zu <{self.type_dict[key_name_dict]}> "
                    return self.status
                # end if
            # end if
        # end for
        self.line_color_liste[irow] = line_color
        
        return self.status
    # end def
    def delete_row_in_data_set(self ,irow):
        '''

        :param irow:
        :return: status self.delete_row_in_data_set(irow)
        '''
        
        if not self.def_okay:
            self.status = hdef.NOT_OKAY
            self.errtext = f"delete_row_in_data_set: Definition der TAbelle nicht okay def_okay = False "
            return self.status
        # end if
        
        if irow >= self.n_data_sets:
            self.status = hdef.NOT_OKAY
            self.errtext = f"delete_row_in_data_set: irow ist nicht im range, irow = {irow} > n_data_sets = {self.n_data_sets} !!!!! "
            return self.status
        # end if
        
        del self.data_set_llist[irow]
        del self.line_color_liste[irow]
        self.n_data_sets -= 1
        
        return self.status
    # end def
    def update_order_icol(self ,icol):
        self.data_set_llist = hlist.sort_list_of_list(self.data_set_llist, icol ,aufsteigend=1)
    # end def
    def update_order_name(self, name):

        icol = hdict.find_first_key_dict_value(self.name_dict,name)
        if icol is None:
            raise Exception(f"{name = } is not in name_dict")
        else:
            self.update_order_icol(icol)
        # end if
    # end def
# end class