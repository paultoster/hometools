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
import small_vector_graphic_helper  as h


import hfkt_str as hs

def build_geo_objects(csd: c.CCommandStrData,command_liste: List[c.CBasic],coordsysname: str) -> (bool, str,List[c.CBasic]):
  """
   Point( Name=P1, X0=10.0, Y0=0.0)
   Line(Name=L1,PO=P1Name,P1=P2Name)
  """

  okay    = True
  errtext = ""
  index_list = []

  for i in range(csd.n):

    liste = hs.get_string_not_quoted(csd.command_str_list[i],d.QUOT0_FUNCTION,d.QUOT1_FUNCTION)

    if( len(liste) == 0):
      okay = False
      errtext = f"In line {csd.linenum_str_list[i]} no Function name (like \"Point\") was found"
      return (okay,errtext,command_liste)
    #endif

    funcword = liste[0]

    dfuncdef = {}
    (okay,errtext,dfuncdef) = h.get_keys_from_line_input(csd.command_str_list[i],dfuncdef)

    if( not okay ):
      return (okay,errtext,command_liste)

    match funcword:
      case "Point":

        (okay,errtext,command_liste) = getPoint(dfuncdef,command_liste,csd.linenum_str_list[i],coordsysname)
        if( not okay ):
          return (okay,errtext,command_liste)

      case "Line":

        (okay,errtext,command_liste) = getLine(dfuncdef,command_liste,csd.linenum_str_list[i],coordsysname)
        if( not okay ):
          return (okay,errtext,command_liste)

      case _:

        okay = False
        errtext = f"The function word: {funcword} in line {csd.linenum_str_list[i]} is not valid"
        return (okay,errtext,command_liste)
    #endmatch

  return (okay,errtext,command_liste)

#enddef

def getPoint(dfuncdef: dict,command_liste: List[c.CBasic],linenum: str,coordsysname: str) -> (bool, str,List[c.CBasic]):
  """
  Point( Name=P1, X0=10.0, Y0=0.0)
  """
  okay=True
  errtext= ""


  # Name
  (okay,errtext,DefName) = h.get_value_from_input_str(dfuncdef,'Name',False,"",line_str=linenum)
  if( not okay ):
    return (okay,errtext,command_liste)
  #endif
  # Name must be unique
  (okay,errtext1) = h.proof_name_in_command_liste(DefName,command_liste)
  if( not okay ):
    errtext = f"Point Dfeinition in linenum {linenum} has errro: {errtext1}"
    return (okay,errtext,command_liste)
  #endif

  # X0
  (okay,errtext,X0) = h.get_value_from_input_float(dfuncdef,'X0',False,0.0,line_str=linenum)
  if( not okay ):
    return (okay,errtext,command_liste)
  #endif

  # Y0
  (okay,errtext,Y0) = h.get_value_from_input_float(dfuncdef,'Y0',False,0.0,line_str=linenum)
  if( not okay ):
    return (okay,errtext,command_liste)
  #endif


  pointobj = c.CPoint(Name=DefName,X0=X0,Y0=Y0,LineNum=linenum,CoordSysName=coordsysname)

  command_liste.append(pointobj)

  return (okay,errtext,command_liste)

#enddef

def getLine(dfuncdef: dict,command_liste: List[c.CBasic],linenum: str,coordsysname: str) -> (bool, str,List[c.CBasic]):
  """
  Line(Name=L1,PO=P1,P1=P2)
  """
  okay=True
  errtext= ""


  # Name
  (okay,errtext,DefName) = h.get_value_from_input_str(dfuncdef,'Name',False,"",line_str=linenum)
  if( not okay ):
    return (okay,errtext,command_liste)
  #endif
  # Name must be unique
  (okay,errtext1) = h.proof_name_in_command_liste(DefName,command_liste)
  if( not okay ):
    errtext = f"Line Dfeinition in linenum {linenum} has errro: {errtext1}"
    return (okay,errtext,command_liste)
  #endif

  # P0
  (okay,errtext,P0) = h.get_value_from_input_str(dfuncdef,'P0',False,"",line_str=linenum)
  if( not okay ):
    return (okay,errtext,command_liste)
  #endif
  (okay,errtext1) = h.find_name_in_command_liste("Point",P0,linenum,command_liste)
  if( not okay ):
    errtext = f"Line Dfeinition in linenum {linenum} has errro: {errtext1}"
    return (okay,errtext,command_liste)
  #endif

  # P1
  (okay,errtext,P1) = h.get_value_from_input_str(dfuncdef,'P1',False,"",line_str=linenum)
  if( not okay ):
    return (okay,errtext,command_liste)
  #endif
  (okay,errtext1) = h.find_name_in_command_liste("Point",P1,linenum,command_liste)
  if( not okay ):
    errtext = f"Line Dfeinition in linenum {linenum} has errro: {errtext1}"
    return (okay,errtext,command_liste)
  #endif


  lineobj = c.CLine(Name=DefName,P0=P0,P1=P1,LineNum=linenum,CoordSysName=coordsysname)

  command_liste.append(lineobj)

  return (okay,errtext,command_liste)

#enddef