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
        self.store_type_dict = {}
        self.def_okay  = False   # is definition okay
        self.status    = hdef.OKAY
        self.errtext   = ""
    def reset_status(self):
        self.status = hdef.OKAY
        self.errtext = ""
    # end def
    def set_definition(self,icol:int,name:str,type: str | list,store_type: str| list):
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
        '''
        
        :param new_data_dict:
        :param new_header_dict:
        :param new_type_dict:
        :return: status = self.add_data_set_dict(new_data_dict: dict,new_header_dict: dict,new_type_dict:dict)
        '''
        
        if( not self.def_okay ):
            self.status = hdef.NOT_OKAY
            self.errtext = f"add_data_set_dict: Definition der TAbelle nicht okay def_okay = False "
            return self.status
        # end if
        
        data_set_list =  [htype.type_get_default(self.type_dict[icol]) for icol in range(self.ncol)]
        for key in new_data_dict.keys():
            new_name = new_header_dict[key]
            
            # suche in self.name_dict
            key_name_dict = hlist.find_first_key_dict_value(self.name_dict,new_name)
            
            if (key_name_dict is not None) and (key_name_dict == key):
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

        return self.status
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
    def find_header_index(self,header):
        '''
        
        :param header:
        :return: icol = self.find_header_index(header)
        '''
    
        # search headername
        key = hlist.find_first_key_dict_value(self.name_dict, header)
    
        if key is None:
            self.status = hdef.NOT_OKAY
            self.errtext = f"find_header_index:  Fehler headername = {header} kann nicht im header of data_set gefunden werden (header_dict: {self.name_dict.items()} !!!"
            return None
        # end if
        return key # == icol
    # end def
    def get_data_set_dict_list(self,header_liste=None,type_liste=None):
        '''
         data_dict_list = self.get_data_set_dict_list()
        :return:
        '''
        
        if header_liste is None:
            name_dict = self.name_dict
            type_dict = self.store_type_dict
        else:
            (name_dict,type_dict) = self.build_name_and_type_dict(header_liste,type_liste)
            if self.status != hdef.OKAY:
                return []
        # end if
        
        data_dict_list = []
        for liste in self.data_set_llist:
            ddict = {}
            for index in name_dict.keys():
                if type_dict[index] != self.type_dict[index]:
                    (okay, value) = htype.type_transform(liste[index], self.type_dict[index], type_dict[index])
                    if okay != hdef.OKAY:
                        self.status = hdef.NOT_OKAY
                        self.errtext = f"get_data_set_dict_list:  Fehler transform data_item = <{liste[index]}> von type: <{self.type_dict[index]}> in type {type_dict[index]} wandeln !!!!!!"
                        return []
                else:
                    value = liste[index]
                # end if
                ddict[name_dict[index]] = value
            # end for
            data_dict_list.append(ddict)
        # end for
        
        return (data_dict_list,name_dict,type_dict)
    # end def
    def build_name_and_type_dict(self,header_liste,type_liste):
        '''
        
        :param header_liste:
        :param type_liste:
        :return:
        '''
        
        header_dict = {}
        type_dict = {}
        for i,header in enumerate(header_liste):
            
            key = self.find_header_index(header)
            if key is None:
                return ({},{})
            # end if
            header_dict[key] = header
            type_dict[key] = type_liste[i]
            
        # end for
        
        return (header_dict,type_dict)
        
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
            for i,icol in enumerate(icol_liste):
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
    def get_one_data_set_liste(self,irow, header_liste, type_liste):
        '''

        :param header_liste:
        :param type_liste:
        :return: output_data_set = self.get_one_data_set_liste(irow,header_liste,type_liste)
        '''
        output_data_set = []
        icol_liste = []
        for header in header_liste:
            key = hlist.find_first_key_dict_value(self.name_dict, header)
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
    def set_data_set_dict_list(self,data_set_dict_list,header_liste:list|dict=None,type_liste:list|dict=None):
        '''
        
        :param header_liste:
        :param type_liste:
        :return: status = self.set_data_set_dict_list(header_liste=None,type_liste=None)
        '''
        if header_liste is None:
            name_dict = self.name_dict
            type_dict = self.store_type_dict
        elif isinstance(header_liste,list):
                (name_dict,type_dict) = self.build_name_and_type_dict(header_liste,type_liste)
                if self.status != hdef.OKAY:
                    return self.status
                # end if
        else:
            name_dict = header_liste
            type_dict = type_liste
        # end if
        
        for data_set_dict in data_set_dict_list:
        
            data_set_dict_out = self.proof_data_set_dict(data_set_dict, name_dict)
            self.status = self.add_data_set_dict(data_set_dict_out, name_dict, type_dict)
            
            if self.status != hdef.OKAY:
                return self.status
            # end if
        # end for
        return self.status
    # end def
    def proof_data_set_dict(self,data_set_dict, name_dict):
        '''
        
        Prüfe ob keys in data_set_dict namen sind (str) oder index (int)
        Wenn Namen, dann in index wandeln
        :param data_set_dict:
        :param name_dict:
        :return:
        '''
        
        data_set_dict_out = {}
        for key in data_set_dict.keys():
            if isinstance(key,str):
                keyout = hlist.find_first_key_dict_value(name_dict,key)
                if keyout is None:
                    raise Exception(f"proof_data_set_dict: Finde nicht value = {key} in name_dict = {name_dict}")
                # end if
                data_set_dict_out[keyout] = data_set_dict[key]
            elif isinstance(key,int):
                data_set_dict_out[key] = data_set_dict[key]
            else:
                raise Exception(f"proof_data_set_dict: key = {key} is string noch int")
            # end if
        # end for
        return data_set_dict_out
    # end def
    def set_data_item(self, value: any, irow: int, icol: int | str, type: any = None):
        '''
        
        :param irow:
        :param icol:
        :param type:
        :return: flag = self.set_data_item(value,irow, icol, type)
                 flag = self.set_data_item(value,irow, icol)
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
            (okay, wert) = htype.type_transform(value, type,self.type_dict[icol])
            if okay != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = f"set_data_item: Fehler transform data_item = {value} von type: {type}  in type {self.type_dict[icol]} wandeln !!! !!!"
                return False
            # end if
            self.data_set_llist[irow][icol] = wert
        else: # ohne type
            (okay, wert) = htype.type_proof(value, self.type_dict[icol])
            if okay != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = f"set_data_item: Fehler type_proof data_item = {value} sollte type: {self.type_dict[icol]} sein !!! !!!"
                return False
            # end if
            self.data_set_llist[irow][icol] = wert
        # end if
        return True
    # end def
    def delete_row_in_data_set(self,irow):
        '''
        
        :param irow:
        :return:
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
        self.n_data_sets -= 1

        return self.status
    # end def
# end class