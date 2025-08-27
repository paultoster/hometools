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
obj = hfkt_tvar.build_table(names,table,types)                  build table (llist) variable as TTable
obj = hfkt_tvar.build_table(names,table,types,types_store)      build table (llist) variable as TTable with type-list to store

(status,errtext) = proof_val(name,val,type)                     proof values to build TVal, TList, TTable
(status,errtext) = proof_list(names,vals,types)
(status,errtext) = proof_table(names,table,types)

val   = get_val(tval,type)                                     get single value out of TVal with given type
vals  =  get_list(tlist, types)                                get list values out of TList with given types
table =  get_table(ttable, types)                              get table values out of TTable with given types

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
                    f"Error build_list: type_proof for table[0][{i}]={table[0][i]} not possible types[{i}] = {types[i]}")
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
                        f"Error build_list: type_proof for table[{index}][{i}]={table[index][i]} not possible types[{i}] = {types[i]}")
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
                    f"Error build_val: type_transform for table[0][{i}]={table[0][i]} not possible from types[{i}] = {types[i]} tp types_store[{i}]={types_store[i]}")
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


