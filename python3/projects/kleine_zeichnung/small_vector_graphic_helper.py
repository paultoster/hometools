#-------------------------------------------------------------------------------
# Name:        module1
# Purpose:
#
# Author:      lino
#
# Created:     04.11.2023
# Copyright:   (c) lino 2023
# Licence:     <your licence>
#-------------------------------------------------------------------------------
from dataclasses import dataclass
from typing import List

import small_vector_graphic_classes as c
import small_vector_graphic_defines as d

import hfkt_str as hs


def get_keys_from_line_input(line: str,din: dict) -> (bool,str,dict):
  okay = True
  errtext = ""
  dout = din

  tt = hs.get_string_quoted(line,d.QUOT0_FUNCTION,d.QUOT1_FUNCTION)
  if( len(tt)>0 ):

    ll = hs.split_text(tt[0],d.SEPERATOR_FUNCTION)

    for item in ll:

      lll = hs.split_text(item,d.ASSIGN_FUNCTION)

      if( len(lll)>1 ):

        tkey = hs.elim_ae_liste(lll[0], [" ","\t"])
        tval = hs.elim_ae_liste(lll[1], [" ","\t"])

        dout.update({tkey: tval})

      #endif
    #endfor
  #endif

  return (okay,errtext,dout)

def get_value_from_input_float(dfuncdef: dict,keyname: str, set_default: bool,default_val=float(0.0),line_str="") -> (bool,str,float):
  """
    (okay,errtext,UnitWidth) = h.get_value_from_input_float(dfuncdef,'UnitWidth',True,10.0)
  """
  okay = True
  errtext = ""
  fval = float(0.0)

  if keyname in dfuncdef.keys():
    try:
      fval = float(dfuncdef[keyname])
    except ValueError as e:
      okay = False
      errtext = f"keyname: {keyname} (line {line_str}) has err: {e}"
      return (okay,errtext,fval)
    #endtry
  elif(set_default):
    # predefinition
    fval = default_val
  else:
    okay = False
    errtext = f"keyname: {keyname} (line {line_str}) was not found"
    return (okay,errtext,fval)
  #end

  return (okay,errtext,fval)

def get_value_from_input_int(dfuncdef: dict,keyname: str, set_default: bool,default_val=int(0),line_str="") -> (bool,str,int):
  """
    (okay,errtext,PointWidth) = h.get_value_from_input_int(dfuncdef,'PointWidth',True,100)
  """
  okay = True
  errtext = ""
  ival = int(0)

  if keyname in dfuncdef.keys():
    try:
      ival = int(dfuncdef[keyname])
    except ValueError as e:
      okay = False
      errtext = f"keyname: {keyname} (line {line_str}) has err: {e}"
      return (okay,errtext,ival)
    #endtry
  elif(set_default):
    # predefinition
    ival = default_val
  else:
    okay = False
    errtext = f"keyname: {keyname} (line {line_str}) was not found"
    return (okay,errtext,ival)
  #end

  return (okay,errtext,ival)

def get_value_from_input_str(dfuncdef: dict,keyname: str, set_default: bool,default_val="",line_str="") -> (bool,str,str):
  """
    (okay,errtext,Name) = h.get_value_from_input_int(dfuncdef,'Name',True,100)
  """
  okay = True
  errtext = ""
  sval = ""

  if keyname in dfuncdef.keys():
    try:
      sval = dfuncdef[keyname]
    except ValueError as e:
      okay = False
      errtext = f"keyname: {keyname} (line {line_str}) has err: {e}"
      return (okay,errtext,sval)
    #endtry
  elif(set_default):
    # predefinition
    sval = default_val
  else:
    okay = False
    errtext = f"keyname: {keyname} (line {line_str}) was not found"
    return (okay,errtext,sval)
  #end

  return (okay,errtext,sval)
#enddef
def proof_name_in_command_liste(DefName: str,command_liste: List[c.CBasic]) -> (bool,str):

  okay = True;
  errtext = ""

  for obj in command_liste:

    if( obj.Name == DefName ):
      okay = False
      errtext = f"Name: {DefName} is already define in Line: {obj.LineNum} "
      return (okay,errtext)
    #endif
  #endfor

  return (okay,errtext)
#enddef



def find_name_in_command_liste(TypeName: str,SearchName: str,linenum: str,command_liste: List[c.CBasic]) -> (bool,str):

  okay = True;
  errtext = ""

  for obj in command_liste:

    if( TypeName == obj.TypeName):
      if( obj.Name == SearchName ):
        return (okay,errtext)
      #endif
    #endif
  #endfor

  okay = False
  errtext = f"Type: {TypeName}: SearchName: {SearchName} was not found before line {linenum}"

  return (okay,errtext)
#enddef
