"""
Build dataclasses:

class TVal(name,val,type)
class TList(names,vals,types):
class TTable(names,table,types):

Build value for TVal:

obj = hfkt_tvar.build_val(name,val,type)                        build single variable as TVal
obj = hfkt_tvar.build_val(name,val,type,type_store)             build single variable as TVal with type to store
obj = hfkt_tvar.build_list(names,vals,types)                    build list variable as TList
obj = hfkt_tvar.build_list(names,vals,types,types_store)        build list variable as TList with type-list to store
obj = hfkt_tvar.build_default_list(names,types)
obj = hfkt_tvar.build_table(names,table,types)                  build table (llist) variable as TTable
obj = hfkt_tvar.build_table(names,table,types,types_store)      build table (llist) variable as TTable with type-list to store
obj = hfkt_tvar.build_table_from_list(tlist,types_store)
obj = hfkt_tvar.build_table_from_list(tlist)

(status,errtext) = proof_val(name,val,type)                     proof values to build TVal, TList, TTable
(status,errtext) = proof_list(names,vals,types)
(status,errtext) = proof_table(names,table,types)

val   = get_val(tval,type)                                     get single value out of TVal with given type
vals  =  get_list(tlist, types)                                get list values out of TList with given types
val   =  get_val_from_list(tlist,name,type)                    get one value from tlist with given name and type
val   =  get_val_from_list(tlist,name)                         get one value from tlist with given name
val   =  get_val_from_list(tlist,index)                        get one value from tlist with given index
index =  get_index_from_list(tlist,name)
index =  get_index_from_table(ttable,name)
flag  =  check_name_from_list(tlist,name)
flag  =  check_name_from_table(ttable,name)
table =  get_table(ttable, types)                              get table values out of TTable with given types
val   =  get_val_from_table(ttable,irow,name,type)
val   =  get_val_from_table(ttable,irow,name)
val   =  get_val_from_table(ttable,irow,index,type)
val   =  get_val_from_table(ttable,irow,index)
type  =  get_type_from_table(ttable,name)
type  =  get_type_from_table(ttable,indx)
names =  get_names(ttable)
names =  get_names(tlist)
vals  =  get_vals(ttable)
vals  =  get_vals(tlist)
types =  get_types(ttable)
types =  get_types(tlist)
(val_dict_list,type_dict) = get_dict_list_from_table(ttable)
(val_dict,type_dict) = get_dict_list_from_list(ttable)
ttable = add_row_liste_to_table(ttable, name,add_row_liste,type)
ttable = set_val_in_table(ttable,val,irow,name,type)
ttable = set_val_in_table(ttable,val,irow,name)
ttable = set_val_in_table(ttable,val,irow,icol,type)
ttable = set_val_in_table(ttable,val,irow,icol)
tlist  = set_val_in_list(tlist,val,name,type)
tlist  = set_val_in_list(tlist,val,name)
tlist  = set_val_in_list(tlist,val,icol,type)
tlist  = set_val_in_list(tlist,val,icol)
ttable = erase_irows_in_table(ttable,irow_erase_list)
ttable = erase_irows_in_table(ttable,irow)
ttable = sort_col_in_table(ttable,name,aufsteigend=1)
ttable = sort_col_in_table(ttable,name)
ttable = sort_col_in_table(ttable,index,aufsteigend=1)
ttable = sort_col_in_table(ttable,index)
ttable = transform_icol_table(ttable,new_name_list)
ttable = transform_type_table(ttable,new_type_list)
flag   = is_table(ttable)
flag   = is_list(tlist)
"""
import os, sys
from dataclasses import dataclass, field

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# # endif

# Hilfsfunktionen
import tools.hfkt_def as hdef
import tools.hfkt_type as htype
import tools.hfkt_list as hlist




@dataclass
class TVal:
    name: str                # name
    val: str | int | float   # any value
    type: str                # type siehe hfk_type.type_proof()

@dataclass
class TList:
    names: list[str]         # list of names
    vals: list               # list of values
    types: list[str]         # list of types
    n: int = field(init=False)               # length of list
    
    def __post_init__(self):
        self.n = len(self.names)
@dataclass
class TTable:
    names: list[str]         # list of names
    table: list[list]        # list of list of values (table)
    types: list[str]         # list of types
    n: int = field(init=False)              # length of names
    ntable: int = field(init=False)          # length of table
    
    def __post_init__(self):
        self.ntable = len(self.table)
        self.n      = len(self.names)


def build_val(name: str,val: any,type: str,type_store: str=None):
    '''
    
    :param name:
    :param val:
    :param type:
    :param type_store:
    :return: obj = hfkt_tvar.build_val(name,val,type)
             obj = hfkt_tvar.build_val(name,val,type,type_store)
    '''
    
    if type_store is None: # proof
        # proof value
        (okay,wert) = htype.type_proof(val,type)
        if okay != hdef.OKAY:
            raise Exception(f"Error build_val: type_proof for val={val} not possible type = {type}")
        else:
            return TVal(name=name,val=wert,type=type)
        # end if
    else: # transform
        # transform value
        (okay,wert) = htype.type_transform(val,type,type_store)
        if okay != hdef.OKAY:
            raise Exception(f"Error build_val: type_transform for val={val} not possible from type = {type} tp type_store={type_store}")
        else:
            return TVal(name=name,val=wert,type=type_store)
        # end if
    # end if
# end def
def build_list(names: list, vals: list, types: list, types_store: list=None):
    '''
    
    :param names:
    :param vals:
    :param types:
    :param types_store:
    :return: obj = hfkt_tvar.build_list(names,vals,types)
             obj = hfkt_tvar.build_list(names,vals,types,types_store)
    '''
    
    n = min(len(names),len(vals))
    n = min(n,len(types))
    if types_store is not None:
        n = min(n,len(types_store))
    # end if
    nnames = [None for i in range(n)]
    vvals =  [None for i in range(n)]
    ttypes =  [None for i in range(n)]
    if types_store is None: # proof
        
        for i in range(n):
            
            nnames[i] = names[i]
            
            # proof value
            (okay, wert) = htype.type_proof(vals[i], types[i])
            if okay != hdef.OKAY:
                raise Exception(f"Error build_list: type_proof for vals[{i}]={vals[i]} not possible types[{i}] = {types[i]}")
            else:
                vvals[i] = wert
                ttypes[i] = types[i]
            # end if
        # rnf for
        
    else:  # transform
        for i in range(n):
            
            nnames[i] = names[i]
            
            # transform value
            (okay, wert) = htype.type_transform(vals[i], types[i], types_store[i])
            if okay != hdef.OKAY:
                raise Exception(
                    f"Error build_val: type_transform for vals[{i}]={vals[i]} not possible from types[{i}] = {types[i]} tp types_store[{i}]={types_store}")
            else:
                vvals[i] = wert
                ttypes[i] = types_store[i]
            # end if
    # end if
    return TList(names=nnames,vals=vvals,types=ttypes)
# end def
def build_default_list(names: list,types: list):
    '''
    
    :param names:
    :param types:
    :return:
    '''
    n = min(len(names),len(types))
    
    nnames = names[0:n]
    ttypes = types[0:n]
    vvals = []
    for i in range(n):
        wert = htype.type_get_default(ttypes[i])
        vvals.append(wert)
    # end if
    return build_list(nnames, vvals, ttypes)
# end def
def build_table(names: list, table: list, types:list, types_store:list=None):
    '''
    
    :param names:
    :param table:
    :param types:
    :param types_store:
    :return: obj = hfkt_tvar.build_table(names,table,types)
             obj = hfkt_tvar.build_table(names,table,types,types_store)
    '''
    
    ntable = len(table)
    if ntable == 0:
        if types_store is None:
            return TTable(names=names, table=[], types=types)
        else:
            return TTable(names=names, table=[], types=types_store)
        raise Exception(
            f"Error build_table: table is empty")
    # end if
    
    n = min(len(names), len(table[0]))
    n = min(n, len(types))
    if types_store is not None:
        n = min(n, len(types_store))
    # end if
    nnames = [None for i in range(n)]
    ttable = []
    ttypes = [None for i in range(n)]
    if types_store is None:  # proof
        
        # first row of table:
        vvals = [None for i in range(n)]
        for i in range(n):
            
            nnames[i] = names[i]
            
            # proof value
            (okay, wert) = htype.type_proof(table[0][i], types[i])
            if okay != hdef.OKAY:
                raise Exception(
                    f"Error build_table: type_proof for table[0][{i}]= \"{table[0][i]}\" not possible types[{i}] = {types[i]}")
            else:
                vvals[i] = wert
                ttypes[i] = types[i]
            # end if
        # end for
        ttable.append(vvals)
        
        # all following rows of table:
        for index in range(1,ntable):
            vvals = [None for i in range(n)]
            for i in range(n):
                
                # proof value
                (okay, wert) = htype.type_proof(table[index][i], types[i])
                if okay != hdef.OKAY:
                    raise Exception(
                        f"Error build_table: type_proof for table[{index}][{i}]={table[index][i]} not possible types[{i}] = {types[i]}")
                else:
                    vvals[i] = wert
                # end if
            # end for
            ttable.append(vvals)
        # end for
    else:  # transform
        # first row of table:
        vvals = [None for i in range(n)]
        for i in range(n):
            
            nnames[i] = names[i]
            
            # transform value
            (okay, wert) = htype.type_transform(table[0][i], types[i], types_store[i])
            if okay != hdef.OKAY:
                raise Exception(
                    f"Error build_table: type_transform for table[0][{i}]={table[0][i]} not possible from types[{i}] = {types[i]} tp types_store[{i}]={types_store[i]}")
            else:
                vvals[i] = wert
                ttypes[i] = types_store[i]
            # end if
        # end ofr
        ttable.append(vvals)
        # all following rows of table:
        for index in range(1, ntable):
            vvals = [None for i in range(n)]
            for i in range(n):
                # transform value
                (okay, wert) = htype.type_transform(table[index][i], types[i], types_store[i])
                if okay != hdef.OKAY:
                    raise Exception(
                        f"Error build_val: type_transform for table[{index}][{i}]={table[index][i]} not possible from types[{i}] = {types[i]} tp types_store[{i}]={types_store[i]}")
                else:
                    vvals[i] = wert
                    ttypes[i] = types_store[i]
                # end if
            # end ofr
        # end for
    # end if
    return TTable(names=nnames, table=ttable, types=ttypes)
# end def
def build_table_from_list(tlist,types_store= None):
    '''
    
    :param tlist:
    :param types_store:
    :return: obj = hfkt_tvar.build_table_from_list(tlist,types_store)
             obj = hfkt_tvar.build_table_from_list(tlist)
    '''
    
    return build_table(tlist.names, [tlist.vals], tlist.types, types_store)
def proof_val(name:str,val:any,type: str):
    '''
    
    :param name:
    :param val:
    :param type:
    :return: (status,errtext) = proof_val(name,val,type)
    '''
    status = hdef.OKAY
    errtext = ""
    
    # proof value
    (status, wert) = htype.type_proof(val, type)
    
    if status != hdef.OKAY:
        errtext = f"hfkt_tvar.proof_val val = {val} is not in type = {type} for variable = {name}"
    # end if
    
    return (status, errtext)
# end def
def proof_list(names:list, vals:list, types:list):
    '''

    :param names:
    :param vals:
    :param types:
    :return: (status,errtext) = proof_list(names,vals,types)
    '''
    status = hdef.OKAY
    errtext = ""
    
    for i in range(len(names)):
        
        # proof value
        (status, wert) = htype.type_proof(vals[i], types[i])
        if status != hdef.OKAY:
            errtext = f"hfkt_tvar.proof_list val[{i}] = {vals[i]} is not in types[{i}] = {types[i]} for names[{i}] = {names[i]}"
            return (status, errtext)
        # end if
    # rnf for
    
    return (status, errtext)
# end def
def proof_table(names:list, table:list, types:list):
    '''

    :param names:
    :param table:
    :param types:
    :return: (status,errtext) = proof_table(names,table,types)
    '''
    status = hdef.OKAY
    errtext = ""
    
    # all following rows of table:
    for index in range(len(table)):
        vals = table[index]
        for i in range(len(vals)):
            
            # proof value
            (status, wert) = htype.type_proof(table[index][i], types[i])
            if status != hdef.OKAY:
                errtext = f"hfkt_tvar.proof_table table[{index}][{i}]={table[index][i]} is not in types[{i}] = {types[i]} for names[{i}] = {names[i]}"
                return (status, errtext)
            # end if
        # end for
    # end for
    
    return (status, errtext)
# end def
def get_val(tval:TVal,type: str):
    '''
    
    :param tval:
    :param type:
    :return: val = get_val(tval,type)
    '''
    # transform value
    (okay, wert) = htype.type_transform(tval.val, tval.type, type)

    if okay != hdef.OKAY:
        raise Exception(
            f"Error get_val: type_transform for tval.val ={tval.val} not possible from tval.type = {tval.type} to type={type} for variable = {tval.name}")
    # end if
    
    return wert
# end def
def get_list(tlist: TList, types: list):
    '''
    
    :param tlist:
    :param types:
    :return: vals =  get_list(tlist, types)
    '''
    vals = []
    
    for i in range(tlist.n):
        
        (status,wert) = htype.type_transform(tlist.vals[i], tlist.types[i], types[i])
        if status != hdef.OKAY:
            raise Exception(
                f"Error get_list: type_transform for tlist.vals[{i}] ={tlist.vals[i]} not possible from type tlist.types[{i}] = {tlist.types[i]} to types[{i}]={types[i]} for names[{i}] = {tlist.names[i]}")
        # end if
        vals.append(wert)
    # end for
    
    return  vals
# end def
def get_val_from_list(tlist,name,type=None):
    '''
    get one value from tlist with given name and type
    :param tlist:
    :param name:
    :param type:
    :return: val   =  get_val_from_list(tlist,name,type)
             val   =  get_val_from_list(tlist,name)
             val   =  get_val_from_list(tlist,index,type)
             val   =  get_val_from_list(tlist,index)
    '''


    if isinstance(name,int):
        if len(tlist.vals) == 0:
            raise Exception(
                f"Error get_val_from_list: tlist = {tlist} is leer")
        # end if
        index = name
        if index >= len(tlist.names):
            index  = len(tlist.names)-1
        # end if
    else:
        index = get_index_from_list(tlist, name)
    # end if
    
    if type is not None:
    
        (status, wert) = htype.type_transform(tlist.vals[index], tlist.types[index], type)
    
        if status != hdef.OKAY:
            raise Exception(
                f"Error get_val_from_list: type_transform for tlist.vals[{index}] = {tlist.vals[index]} not possible from tlist.types[{index}] = {tlist.types[index]} to type={type} for variable = {tlist.names[index]}")
        # end if
    else:
        wert = tlist.vals[index]
    # end if
    return wert
# end def
def get_index_from_list(tlist, name):
    '''
    get index from tlist with given name
    :param tlist:
    :param name:
    :param type:
    :return: index   =  get_index_from_list(tlist,name)
    '''
    
    index_list = hlist.search_value_in_list_return_indexlist(tlist.names, name)
    if len(index_list) == 0:
        raise Exception(
            f"Error get_val_from_list: tlist.namess = {tlist.names} hat nicht den gesuchten namen:{name = }")
    else:
        index = index_list[0]
    # end if
    
    return index


# end def
def get_index_from_table(ttable, name):
    '''
    get index from ttable with given name
    :param tlist:
    :param name:
    :param type:
    :return: index   =  get_index_from_table(ttable,name)
    '''
    
    index_list = hlist.search_value_in_list_return_indexlist(ttable.names, name)
    if len(index_list) == 0:
        raise Exception(
            f"Error get_val_from_list: tlist.namess = {ttable.names} hat nicht den gesuchten namen:{name = }")
    else:
        index = index_list[0]
    # end if
    
    return index


# end def
def check_name_from_list(tlist,name):
    '''
    
    :param tlist:
    :param name:
    :return: flag  =  check_name_from_list(tlist,name)
    '''
    index_list = hlist.search_value_in_list_return_indexlist(tlist.names, name)
    if len(index_list) == 0:
        return False
    
    return True
# end def
def check_name_from_table(ttable,name):
    '''
    
    :param tlist:
    :param name:
    :return: flag  =  check_name_from_table(ttable,name)
    '''
    return check_name_from_list(ttable,name)
# end def



def get_table(ttable: TTable, types: list):
    '''

    :param tlist:
    :param types:
    :return: vals =  get_table(ttable, types)
    '''
    table = []
    for index in range(ttable.ntable):
    
        vals = []
    
        for i in range(ttable.n):
        
            (status, wert) = htype.type_transform(ttable.table[index][i], ttable.types[i], types[i])
            if status != hdef.OKAY:
                raise Exception(
                    f"Error get_list: type_transform for ttable.table[{index}][{i}] = {ttable.table[index][i]} not possible from type ttable.types[{i}] = {ttable.types[i]} to types[{i}]={types[i]} for names[{i}] = {ttable.names[i]}")
            # end if
            vals.append(wert)
        # end for

        table.append(vals)
    # end for
    return table
# end def
def get_val_from_table(ttable, irow,name, type=None):
    '''
    get one value from tlist with given name and type
    :param tlist:
    :param name:
    :param type:
    :return: val   =  get_val_from_table(ttable,irow,name,type)
             val   =  get_val_from_table(ttable,irow,name)
             val   =  get_val_from_table(ttable,irow,index,type)
             val   =  get_val_from_table(ttable,irow,index)
    '''
    
    if len(ttable.table) == 0:
        raise Exception(
            f"Error get_val_from_table: tlist = {ttable} is leer")
    # end if

    if irow >= ttable.ntable:
        irow = ttable.ntable-1
    # end if
    
    if isinstance(name, int):
        index = name
        if index >= ttable.n:
            index = ttable.n - 1
        # end if
    else:
        index = get_index_from_table(ttable, name)
    # end if
    
    if type is not None:
        
        (status, wert) = htype.type_transform(ttable.table[irow][index], ttable.types[index], type)
        
        if status != hdef.OKAY:
            raise Exception(
                f"Error get_val_from_list: type_transform for ttable.table[{irow}][{index}] = {ttable.table[irow][index]} not possible from ttable.types[{index}] = {ttable.types[index]} to type={type} for variable = {ttable.names[index]}")
        # end if
    else:
        wert = ttable.table[irow][index]
    # end if
    return wert
# end def
def get_type_from_table(ttable,name):
    '''
    
    :param ttable:
    :param name:
    :return: type  =  get_type_from_table(ttable,name)
             type  =  get_type_from_table(ttable,index)
    '''
    if len(ttable.table) == 0:
        raise Exception(
            f"Error get_type_from_table: tlist = {ttable} is leer")
    # end if
    
    
    if isinstance(name, int):
        index = name
        if index >= ttable.n:
            index = ttable.n - 1
        # end if
    else:
        index = get_index_from_table(ttable, name)
    # end if
    return ttable.types[index]
# end def
def get_names(tvar):
    '''

    :param tvar:
    :return: names =  get_names(ttable)
             names =  get_names(tlist)
    '''
    if is_list(tvar):
        return tvar.names
    elif is_table(tvar):
        return tvar.names
    else:
        raise Exception(f"Error get_names: tvar = {tvar} ist keine liste (TList) und keine table (TTable)")
    # end if
# end def
def get_vals(tvar):
    '''

    :param tvar:
    :return: vals =  get_vals(ttable)
             vals =  get_vals(tlist)
    '''
    if is_list(tvar):
        return tvar.vals
    elif is_table(tvar):
        return tvar.table
    else:
        raise Exception(f"Error get_names: tvar = {tvar} ist keine liste (TList) und keine table (TTable)")
    # end if
# end def
def get_table(tvar):
    '''

    :param tvar:
    :return: vals =  get_table(ttable)
    
    '''
    if is_list(tvar):
        return tvar.vals
    elif is_table(tvar):
        return tvar.table
    else:
        raise Exception(f"Error get_names: tvar = {tvar} ist keine liste (TList) und keine table (TTable)")
    # end if
# end def
def get_types(tvar):
    '''

    :param tvar:
    :return: types =  get_types(ttable)
             types =  get_types(tlist)
    '''
    if is_list(tvar):
        return tvar.types
    elif is_table(tvar):
        return tvar.types
    else:
        raise Exception(f"Error get_names: tvar = {tvar} ist keine liste (TList) und keine table (TTable)")
    # end if
# end def
def get_dict_list_from_table(ttable):
    '''
    
    :param ttable:
    :return:  (val_dict_list,type_dict) = get_dict_list_from_table(ttable)
    '''
    val_dict_list = []
    type_dict ={}
    
    for irow in range(ttable.ntable):
        
        if irow == 0:
            for i in range(ttable.n):
                type_dict[ttable.names[i]] = ttable.types[i]
            # end for
        # end if
        
        val_dict = {}
        for i in range(ttable.n):
            val_dict[ttable.names[i]] = ttable.table[irow][i]
        # end for
        
        val_dict_list.append(val_dict)
    # end for
    
    return (val_dict_list,type_dict)
# end def
def get_dict_list_from_list(tlist):
    '''

    :param tlist:
    :return: (val_dict,type_dict) = get_dict_list_from_list(tlist)
    '''
    type_dict = {}
    val_dict = {}
    
    for i in tlist.n:
        val_dict[tlist.names[i]] = tlist.vals[i]
        type_dict[tlist.names[i]] = tlist.types[i]
    # end for
    
    return (val_dict, type_dict)
# ewnd def
def set_val_in_table(ttable,val,irow,name,type=None):
    '''
    
    :param ttable:
    :paran val
    :param irow:
    :param name:
    :param type:
    :return: ttable = set_val_in_table(ttable,val,irow,name,type)
             ttable = set_val_in_table(ttable,val,irow,name)
             ttable = set_val_in_table(ttable,val,irow,icol,type)
             ttable = set_val_in_table(ttable,val,irow,icol)
    '''
    
    if len(ttable.table) == 0:
        raise Exception(
            f"Error set_val_in_table: tlist = {ttable} is leer")
    # end if
    
    if irow >= ttable.ntable:
        irow = ttable.ntable - 1
    # end if
    
    if isinstance(name, int):
        index = name
        if index >= ttable.n:
            index = ttable.n - 1
        # end if
    else:
        index = get_index_from_table(ttable, name)
    # end if
    
    if type is not None:
        
        (status, wert) = htype.type_transform(val,type,ttable.types[index])
        
        if status != hdef.OKAY:
            raise Exception(
                f"Error set_val_in_table: type_transform for val = {val} not possible from type={type} to ttable.types[{index}] = {ttable.types[index]} for variable = {ttable.names[index]}")
        # end if
        ttable.table[irow][index] = wert
    else:
        (status, wert) = htype.type_proof(val,ttable.types[index])
        if status != hdef.OKAY:
            raise Exception(
                f"Error set_val_in_table: type_proof for val = {val} not possible from ttable.types[{index}] = {ttable.types[index]} for variable = {ttable.names[index]}")
        # end if
        ttable.table[irow][index] = wert
    # end if
    return ttable
# end def
def set_val_in_list(tlist, val, name, type=None):
    '''

    :param ttable:
    :paran val
    :param irow:
    :param name:
    :param type:
    :return:    tlist = set_val_in_list(tlist,val,name,type)
                tlist = set_val_in_list(tlist,val,name)
                tlist = set_val_in_list(tlist,val,icol,type)
                tlist = set_val_in_list(tlist,val,icol)
    '''
    
    if len(tlist.vals) == 0:
        raise Exception(
            f"Error set_val_in_table: tlist = {tlist} is leer")
    # end if
    
    if isinstance(name, int):
        index = name
        if index >= tlist.n:
            index = tlist.n - 1
        # end if
    else:
        index = get_index_from_list(tlist, name)
    # end if
    
    if type is not None:
        
        (status, wert) = htype.type_transform(val, type, tlist.types[index])
        
        if status != hdef.OKAY:
            raise Exception(
                f"Error set_val_in_table: type_transform for val = {val} not possible from type={type} to ttable.types[{index}] = {tlist.types[index]} for variable = {tlist.names[index]}")
        # end if
        tlist.vals[index] = wert
    else:
        (status, wert) = htype.type_proof(val, tlist.types[index])
        if status != hdef.OKAY:
            raise Exception(
                f"Error set_val_in_table: type_proof for val = {val} not possible from ttable.types[{index}] = {tlist.types[index]} for variable = {tlist.names[index]}")
        # end if
        tlist.vals[index] = wert
    # end if
    return tlist


# end def
def add_row_liste_to_table(ttable, name,add_row_liste,type):
    '''
    
    :param ttable:
    :param name:
    :param liste:
    :param type:
    :return: ttable = add_row_liste_to_table(ttable, name,add_row_liste,type)

    '''
    n = len(add_row_liste)
    for irow in ttable.ntable:
        
        liste = ttable.table[irow]
        
        if irow < n:
            liste.append(add_row_liste[irow])
        else:
            liste.append(None)
        # end if
        ttable.table[irow] = liste
    # end for
    
    ttable.names.append(name)
    ttable.types.append(type)
    ttable.n += 1
    
    return ttable
# end def
def erase_irows_in_table(ttable,irow_erase_list):
    '''
    
    :param ttable:
    :param irow_erase_list:
    :return: ttable = erase_irows_in_table(ttable,irow_erase_list)
             ttable = erase_irows_in_table(ttable,irow)
    '''


    if isinstance(irow_erase_list,int):
        irow_erase_list = [irow_erase_list]
    # end if
    
    irow_erase_list.sort(reverse=True)
    
    for irow in irow_erase_list:
        if irow < ttable.ntable:
            del ttable.table[irow]
            ttable.ntable -= 1
        # end if
    # end for
    return ttable
# end def
def sort_col_in_table(ttable,name,aufsteigend=1):
    '''
    
    :param ttable:
    :param name:
    :param aufsteigend:
    :return:    ttable = sort_col_in_table(ttable,name,aufsteigend=1)
                ttable = sort_col_in_table(ttable,name)
                ttable = sort_col_in_table(ttable,index,aufsteigend=1)
                ttable = sort_col_in_table(ttable,index)
 
    '''
    
    if len(ttable.table) == 0:
        raise Exception(
            f"Error sort_col_in_table: ttable = {ttable} is leer")
    # end if
    
    if isinstance(name, int):
        index = name
        if index >= ttable.n:
            index = ttable.n - 1
        # end if
    else:
        index = get_index_from_table(ttable, name)
    # end if
    
    ttable.table = hlist.sort_list_of_list(ttable.table, index, aufsteigend=aufsteigend)
    
    return ttable
# end def
def transform_icol_table(ttable,new_name_list):
    '''
    
    :param ttable:
    :param new_name_list:
    :return: ttable = transform_icol_table(ttable,new_name_list)
    '''
    
    
    types_new = []
    index_list = []
    for new_name in new_name_list:
        index = get_index_from_table(ttable, new_name)
        index_list.append(index)
        types_new.append(ttable.types[index])
    # end for
    
    table_new = []
    for irow in range(ttable.ntable):
        
        vals = ttable.table[irow]
        vals_new = []
        for i in index_list:
            vals_new.append(vals[i])
        # end for
        table_new.append(vals_new)
    # end for
    
    return build_table(new_name_list,table_new,types_new)
# end def
def transform_type_table(ttable,new_type_list):
    '''
    
    :param ttable:
    :param new_type_list:
    :return: ttable = transform_type_table(ttable,new_type_list)
    '''
    if len(new_type_list) != ttable.n:
        raise Exception(
            f"Error transform_type_table: ttable.n: {ttable.n} != len(new_type_list): {len(new_type_list)}")
    # end def
    
    for irow in range(ttable.ntable):
        
        vals = ttable.table[irow]
        for icol in range(ttable.n):
            val_new = get_val_from_table(ttable,irow,icol,new_type_list[icol])
            if vals[icol] != val_new:
                ttable = set_val_in_table(ttable,val_new,irow,icol)
            # end if
        # end for
    # end for

    return ttable
# end def
def is_table(ttable):
    '''
    
    :param ttable:
    :return: flag = is_table(ttable)
    '''
    flag = False
    
    if hasattr(ttable,'names') \
        and hasattr(ttable,'table') \
        and hasattr(ttable,'types') \
        and hasattr(ttable, 'n') \
        and hasattr(ttable,'ntable'):
        
        if isinstance(ttable.names,list) \
            and isinstance(ttable.table,list) \
            and isinstance(ttable.types,list) \
            and isinstance(ttable.n,int) \
            and isinstance(ttable.ntable,int):
            
            flag = True
        # end if
    # end if
    return flag
# end def
def is_list(tlist):
    '''

    :param ttable:
    :return: flag = is_list(tlist)
    '''
    flag = False
    
    if hasattr(tlist, 'names') \
        and hasattr(tlist, 'vals') \
        and hasattr(tlist, 'types') \
        and hasattr(tlist, 'n'):
        
        if isinstance(tlist.names, list) \
            and isinstance(tlist.vals, list) \
            and isinstance(tlist.types, list) \
            and isinstance(tlist.n, int):
            flag = True
        # end if
    # end if
    return flag
# end def



    

