#
#
#   beinhaltet verschiedene Definitionen
#
import os, sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif


import hfkt_def as hdef
import hfkt_type as htype
import hfkt_list as hlist

class IDCount:
    '''
    self.set_act_id(id) setzt die die id (sollte bei initialisierung benutzt werden)
    self.get_act_id()   gibt actual idmax zurück
    self.get_new_id()   zählt idmax um eins hoch und gibt id zurück
    '''
    idmax: int = 0
    def __init__(self):
        pass
    # end def
    def set_act_id(self,id:int):
        IDCount.idmax = id
    # end def
    def get_act_id(self):
        return IDCount.idmax
    # end def
    def get_new_id(self):
        IDCount.idmax += 1
        return IDCount.idmax
    # end def
    def reset_consistency_check(self):
        IDCount.id_consistency_check_dict = {}
    def proof_and_add_consistency_check_id(self,id,konto_name):
        '''
        
        :param id: used id
        :return: (okay,errtext) = self.proof_and_add_consistency_check_id(id)
        '''
        
        if id in IDCount.id_consistency_check_dict.keys():
            okay = hdef.NOT_OKAY
            errtext = f"proof_and_add_consistency_check_id: id = <{id}> is already in konto_name: <{IDCount.id_consistency_check_dict[id]}>"
        elif id > IDCount.idmax:
            okay = hdef.NOT_OKAY
            errtext = f"proof_and_add_consistency_check_id: id = <{id}> is greater then idmx: <{IDCount.idmax}> in konto_name: <{konto_name}>"
        else:
            IDCount.id_consistency_check_dict[id] = konto_name
            okay = hdef.OKAY
            errtext = ""
        # end if
        return (okay,errtext)
# end class
class DataSet:
    '''
        :return: self.set_definition(icol, name, type)  definiere für icol (Spalte) das dutum mit name und dem type
        :return: self.add_data_set_list(data_llist, col_list, type_list, add_if_new_in_col)     add with col_list, type_list if add_if_new_in_col=icol
        :return: self.add_data_set_list(data_llist, col_list, type_list)                        add with col_list, type_list always
        :return: self.add_data_set_list(data_llist, col_list)                                   add with col_list  always without transforming
        :return: self.add_data_set_list(data_llist)                                             add always without transforming and in order of data_set
        :return: self.add_data_set(data_set, col_list, type_list, add_if_new_in_col)     add with col_list, type_list if add_if_new_in_col=icol
        :return: self.add_data_set(data_set, col_list, type_list)                        add with col_list, type_list always
        :return: self.add_data_set(data_set, col_list)                                   add with col_list  always without transforming
        :return: self.add_data_set(data_set)                                             add always without transforming and in order of data_set
        :return: self.add_data_set(data_set, col_list, type_list, add_if_new_in_col)     add with col_list, type_list if add_if_new_in_col=icol
        :return: self.add_data_set(data_set, col_list, type_list)                        add with col_list, type_list always
        :return: self.add_data_set(data_set, col_list)                                   add with col_list  always without transforming
        :return: self.add_data_set(data_set)                                             add always without transforming and in order of data_set
                 self.def get_data_item(irow, icol [,type]):
                 value = self.def get_data_item(irow, headername [,type]):
                 value = self.def get_data_item_special(calc_type, icol [,type]): calc_type = "sum"
                 value = self.def get_data_item_special(calc_type, headername [,type]): calc_type = "sum"
                 irow_list = self.find_in_col(value,type, icol)
                 data_dict_list = get_data_set_dict_list()
                 data_type_dict = self.get_data_type_dict()
    '''
    def __init__(self,name):
        self.name = name
        self.data_set_llist = []
        self.ncol = 0
        self.n_data_sets = 0
        self.name_dict = {}
        self.type_dict = {}
        self.def_okay  = False   # is definition okay
        self.status    = hdef.OKAY
        self.errtext   = ""
    def set_definition(self,icol:int,name:str,type: str | list):
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
            self.name_dict = dict(sorted(self.name_dict.items()))
            self.type_dict = dict(sorted(self.type_dict.items()))
            key_list = list(self.name_dict.keys())
            if key_list[-1] == (len(key_list)-1): # Wenn letzter key gleich Anzahl in der Liste minus eins
                self.def_okay = True
                self.ncol     = len(self.name_dict)
            else:
                self.def_okay = False
                self.ncol = 0
            #end if
        # end if
        return
    # end def
    def add_data_set_dict(self,new_data_dict: dict,new_header_dict: dict,new_type_dict:dict):
        
        if( not self.def_okay ):
            self.status = hdef.NOT_OKAY
            self.errtext = f"add_data_set_dict: Definition der TAbelle nicht okay def_okay = False "
            return
        # end if
        
        data_set_list =  [htype.type_get_default(self.type_dict[icol]) for icol in range(self.ncol)]
        for key in new_data_dict.keys():
            new_name = new_header_dict[key]
            
            # suche in self.name_dict
            keys = [k for k, v in self.name_dict.items() if v == new_name]
            
            if keys and (keys[0] == key):
                (okay, wert) = htype.type_transform(new_data_dict[key], new_type_dict[key],
                                                    self.type_dict[key])
                if okay == hdef.OK:
                    data_set_list[key] = wert
                else:
                    self.status = hdef.NOT_OKAY
                    self.errtext = f"add_data_set_dict: Problem type_transform of <{new_data_dict[key]}> von type: <{new_type_dict[key]}> zu <{self.type_dict[key]}> "
                    return
                # end if
            # end if
        # end for

        self.data_set_llist.append(data_set_list)
        self.n_data_sets += 1

        return
    # end if
    
    def get_data_item(self, irow: int, icol: int|str, type: any = None):
        '''
        
        :param icol:
        :param irow:
        :param type:
        :return: wert = self.get_data_item(irow, icol [, type])
        :return: wert = self.get_data_item(irow, headername [,type])
        '''
        if isinstance(icol,str): # header name
            # search headername
            keys = [k for k, v in self.name_dict.items() if v == icol]
            
            if len(keys) == 0:
                self.status = hdef.NOT_OKAY
                self.errtext = f"get_data_item_by_header:  Fehler headername = {icol} kann nicht im header of data_set gefunden werden (header_dict: {self.name_dict.items()} !!!"
                return None
            else:
                icol = keys[0]
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
            (okay, wert) = htype.type_transform(self.data_set_llist[irow][icol], self.type_dict[icol],type)
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
    def get_data_item_special(self, calc_type: str, icol: int|str, type: any = None):
        '''
        
        :param calc_type:  bis jetzt summe
        :param icol/headername:  icol integer or name des Haders
        :param type: wenn in ein bestimten type umgerechnet werden soll
        :return: wert = self.get_data_item_by_header("sum", icol [,type])
        :return: wert = self.get_data_item_by_header("sum", "headername" [,type])
        '''
        
        
        # calc_type == "sum":
        #   calc_type = 'sum'
        #else:
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
        '''
        
        irow_list = []
        
        if( icol >= self.ncol):
            self.status = hdef.NOT_OKAY
            self.errtext = f"find_in_col: Fehler in find_in_col  icol = {icol} ist >= self.ncol  {self.ncol} !!!"
            return
        # end if
        for i, data_set in enumerate(self.data_set_llist):
            (okay,val_intern) = htype.type_transform(data_set[icol],self.type_dict[icol],type)
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
    def get_data_set_dict_list(self):
        '''
         data_dict_list = self.get_data_set_dict_list()
        :return:
        '''
        
        data_dict_list = []
        for liste in self.data_set_llist:
            ddict = {}
            for index in self.name_dict.keys():
                ddict[self.name_dict[index]] = liste[index]
            # end for
            data_dict_list.append(ddict)
        # end for
        
        return data_dict_list
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
    def get_data_set_lliste(self,header_liste,type_liste):
        '''
        
        :param header_liste:
        :param type_liste:
        :return: data_set_lliste = self.get_data_set_lliste(header_liste,type_liste)
        '''
        output_data_lliste = []
        icol_liste = []
        for header in header_liste:
            key = hlist.find_first_key_dict_value(self.name_dict, header)
            if  key is None:
                self.status = hdef.NOT_OKAY
                self.errtext = f"get_data_set_llist:  Fehler header = {header} ist nicht in name_dict = {self.name_dict} !!!!!!"
                return output_data_lliste
            else:
                icol_liste.append(key)
            # end if
        # end if
        n = len(icol_liste)
        
        for data_liste in self.data_set_llist:
            output_data_liste = [None for j in range(n)]
            for i,icol in enumerate(icol_liste):
                (okay, value) = htype.type_transform(data_liste[icol], self.type_dict[icol], type_liste[i])
                if okay != hdef.OKAY:
                    self.status = hdef.NOT_OKAY
                    self.errtext = f"find_in_col:  Fehler transform data_item = <{data_liste[icol]}> von type: <{self.type_dict[icol]}> in type {type_liste[i]} wandeln !!!!!!"
                    return []
                # end if
                output_data_liste[i] = value
            # end for
            output_data_lliste.append(output_data_liste)
        # end for
        return output_data_lliste
    # end def
# end class