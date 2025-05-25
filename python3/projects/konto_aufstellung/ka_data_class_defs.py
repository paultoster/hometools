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
    '''
    def __init__(self):
        self.data_set_llist = []
        self.ncol = 0
        self.n_data_sets = 0
        self.name_dict = {}
        self.type_dict = {}
        self.def_okay  = False   # is definition okay
    def set_definition(self,icol:int,name:str,type: str | list):
        '''
        Deinition einer Spalte
        :param icol: Spalte gezählt von 0
        :param name: Name der Spalte
        :param type: type der Spalte
        :return: self.set_definition(icol, name, type)  definiere für icol (Spalte) das dutum mit name und dem type
        '''
        if icol in self.name_dict:
            raise Exception(
                f"set_definition: Spalte col = {icol} ist schon definiert")
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
    def add_data_set_list(self, data_llist: list, col_list: list = None, type_list: list = None,add_if_new_in_col: int = None):
        '''

        :param data_llist: list of of data_sets
        :param col_list:  list of index position from data_set
        :param type_list: list of type in order of data_set
        :param add_if_new_in_col: Wenn Wert aus der Spalte col neu ist
        :return: self.add_data_set_list(data_llist, col_list, type_list, add_if_new_in_col)     add with col_list, type_list if add_if_new_in_col=icol
        :return: self.add_data_set_list(data_llist, col_list, type_list)                        add with col_list, type_list always
        :return: self.add_data_set_list(data_llist, col_list)                                   add with col_list  always without transforming
        :return: self.add_data_set_list(data_llist)                                             add always without transforming and in order of data_set
        '''
        for data_set in data_llist:
            self.add_data_set(data_set,col_list,type_list,add_if_new_in_col)
        # end for
        return
    # end def
    def add_data_set(self, data_set:list, col_list:list=None, type_list:list=None, add_if_new_in_col:int=None):
        '''
        
        :param data_set: list of data
        :param col_list:  list of index position from data_set
        :param type_list: list of type in order of data_set
        :param add_if_new_in_col: Wenn Wert aus der Spalte col neu ist
        :return: self.add_data_set(data_set, col_list, type_list, add_if_new_in_col)     add with col_list, type_list if add_if_new_in_col=icol
        :return: self.add_data_set(data_set, col_list, type_list)                        add with col_list, type_list always
        :return: self.add_data_set(data_set, col_list)                                   add with col_list  always without transforming
        :return: self.add_data_set(data_set)                                             add always without transforming and in order of data_set
        :return: self.add_data_item(data_item, icol, type,add_if_new):   add value item in icol with type to tranform, add if add_if_new=True
        :return: self.add_data_item(data_item, icol, type)               add value item in icol with type to tranform, add always
        :return: self.add_data_item(data_item, icol):                    add value item in icol w/o tranform, add always
        :return: self.set_data_item(data_item, irow, icol, type)   set value item in icol of irow in data_llist with type to tranform
        :return: self.set_data_item(data_item, irow, icol)         set value item in icol of irow in data_llist w/o tranform
        :return: wert = self.get_data_item(irow, icol, type)
        :return: wert = self.get_data_item(irow, icol)
        '''
        if self.def_okay == False:
            raise Exception(
                f"add_data_set: Data-Set nicht richtig definiert")
        # end if

        n_data_set = min(len(data_set),self.ncol)
        if not col_list:
            col_list = list(range(n_data_set))
        # endif
        n_data_set = min(len(col_list), n_data_set)
        if not type_list:
            type_list = []
            for i in range(n_data_set):
                type_list.append(self.type_dict[i])
            # end for
        # end if
        n_data_set = min(len(type_list), n_data_set)
        
        # proof for new
        if add_if_new_in_col and (add_if_new_in_col < n_data_set):
            irow_list = self.find_in_col(data_set[add_if_new_in_col],col_list[add_if_new_in_col])
            if len(irow_list) == 0:
                flag_add_data_set = True
            else:
                flag_add_data_set = False
            # end if
        else:
            flag_add_data_set = True
        # end if
        
        # Starte Hinzufügen data_set
        if flag_add_data_set:
            new_data_set =[''] * self.ncol
            for i in range(n_data_set):
                icol = max(min(col_list[i],self.ncol-1),0)
                (okay, wert) = htype.type_transform(data_set[i], type_list[i],self.type_dict[icol])
                if okay != hdef.OKAY:
                    raise Exception(
                        f"Fehler transform  {data_set[i]} von type: {type_list[i]} in type {self.type_dict[icol]} wandeln !!!")
                # end if
                new_data_set[icol] = wert
            # end for
            self.data_set_llist.append(new_data_set)
            self.n_data_sets += 1
        # end if
        return
    # edn def
    def add_data_item(self, data_item: any, icol: int, type: any = None,add_if_new: bool = None):
        '''
        
        :param data_item:
        :param icol:
        :param type:
        :param add_if_new:
        :return: self.add_data_item(data_item, icol, type,add_if_new):   add value item in icol with type to tranform, add if add_if_new=True
        :return: self.add_data_item(data_item, icol, type)               add value item in icol with type to tranform, add always
        :return: self.add_data_item(data_item, icol):                    add value item in icol w/o tranform, add always
        
        '''
        data_set = [data_item]
        col_list = [icol]
        if type:
            type_list = [type]
        else:
            type_list = None
        # end if
        if add_if_new:
            add_if_new_in_col = icol
        else:
            add_if_new_in_col = None
        # end if
        return self.add_data_set(data_set,col_list,type_list,add_if_new_in_col)
    # end def
    def set_data_item(self, data_item: any, irow: int, icol: int, type: any = None):
        '''

        :param data_item:
        :param icol:
        :param irow:
        :param type:
        :return: self.set_data_item(data_item, irow, icol, type)   set value item in icol of irow in data_llist with type to tranform
        :return: self.set_data_item(data_item, irow, icol)         set value item in icol of irow in data_llist w/o tranform
        '''
        if irow >= self.n_data_sets:
            raise Exception(
                f"Fehler set_data_item: irow = {irow} >= self.n_data_sets = {self.n_data_sets} !!!")
        if icol >= self.ncol:
            raise Exception(
                f"Fehler set_data_item: icol = {icol} >= self.ncol = {self.ncol} !!!")
        if type:
            (okay, wert) = htype.type_transform(data_item, type, self.type_dict[icol])
            if okay != hdef.OKAY:
                raise Exception(
                    f"Fehler transform data_item = {data_item} von type: {type} in type {self.type_dict[icol]} wandeln !!!")
            # end if
        else:
            wert = data_item
        # end if
        self.data_set_llist[irow][icol] = wert
        return
    # end defget_data_item
    def get_data_item(self, irow: int, icol: int, type: any = None):
        '''
        
        :param icol:
        :param irow:
        :param type:
        :return: wert = self.get_data_item(irow, icol, type)
        :return: wert = self.get_data_item(irow, icol)
        '''
        if irow >= self.n_data_sets:
            raise Exception(
                f"Fehler get_data_item: irow = {irow} >= self.n_data_sets = {self.n_data_sets} !!!")
        if icol >= self.ncol:
            raise Exception(
                f"Fehler get_data_item: icol = {icol} >= self.ncol = {self.ncol} !!!")
        
        if type:
            (okay, wert) = htype.type_transform(self.data_set_llist[irow][icol], self.type_dict[icol],type)
            if okay != hdef.OKAY:
                raise Exception(
                    f"Fehler transform data_item = {self.data_set_llist[irow][icol]} von type: {self.type_dict[icol]} in type {type} wandeln !!!")
            # end if
        else:
            wert = self.data_set_llist[irow][icol]
        # end if
        return wert
    # end def
    def find_in_col(self, value, icol):
        '''
        
        :param value:
        :param icol:
        :return: irow_list = self.find_in_col(value,icol)
        '''
        
        irow_list = []
        
        if( icol >= self.ncol):
            raise Exception(
                f"Fehler in find_in_col  icol = {icol} ist >= self.ncol  {self.ncol} !!!")
        
        for i, data_set in enumerate(self.data_set_llist):
            if data_set[icol] == value:
                irow_list.append(i)
            # end if
        # end for
        return irow_list
    # end def
