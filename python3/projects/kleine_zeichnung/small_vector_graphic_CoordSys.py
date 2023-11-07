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
import math

import small_vector_graphic_classes as c
import small_vector_graphic_defines as d
import small_vector_graphic_helper  as h


from hfkt import hfkt_str as hs


def build_coordsys_object_list(csd: c.CCommandStrData) -> (bool, str,List[c.CBase],List[list]):
  """
  CoordSys(Name=coord1,X0=2.0,Y0=2.0,Dir0=90)

  (okay,errtext,list_coordsys_obj,line_index_tuple_liste) =
     build_coordsys_object_list(csd)

  """
  okay = True
  errtext = ""
  coordsys_obj_list = []
  tuple_list = []

  line_index_liste = hs.such_in_liste(csd.command_str_list,'CoordSys','t')

  if( (len(line_index_liste)==0) ):

    okay = False
    errtext = "No definition for CoordSys !!!"
    return (okay,errtext,coordsys_obj_list,tuple_list)

  elif( line_index_liste[0] != 0):

    okay = False
    errtext = f"First definition in line {liste_line_number[0]} is not CoordSys !!!"
    return (okay,errtext,coordsys_obj_list,tuple_list)

  #endif

  iname = 0
  for ipos,index in enumerate(line_index_liste):

    iname = iname + 1
    default_name = "coordsys" + str(iname)
    (okay,errtext,coordsys_obj) = build_coordsys(csd.command_str_list[index],csd.linenum_str_list[index],default_name)

    if( not okay ):
      return (okay,errtext,coordsys_obj_list,tuple_list)
    #endif

    i0 = index+1
    if( ipos+1 >= len(line_index_liste) ):
      i1 = len(csd.command_str_list)-1
    else:
      i1 = line_index_liste[ipos+1]-1
    #endif

    # Proof name
    name_list = []
    for obj in coordsys_obj_list:
      name_list.append(obj.Name)
    #endfor
    index_liste = hs.such_in_liste(name_list,coordsys_obj.Name,'e')
    if( len(index_liste)):
      okay = False
      errtext = f"CoordSys.Name={coordsys_obj.Name} double found in {(index_liste[0]+1)}. definition"
      (okay,errtext,coordsys_obj_list,tuple_list)
    #endif

    coordsys_obj_list.append(coordsys_obj)
    tuple_list.append((i0,i1))

  #endfor

  return (okay,errtext,coordsys_obj_list,tuple_list)

def build_coordsys(line: str,line_number: str,defaul_name: str) -> (bool, str,c.CBase):
  """
  CoordSys(Name=coord1,X0=2.0,Y0=2.0,Dir0=90)
  """

  okay = True;
  errtext = ""

  dfuncdef = {}
  (okay,errtext,dfuncdef) = h.get_keys_from_line_input(line,dfuncdef)

  if( not okay ):
    return (okay,errtext,c.CBase)
  #endif

  # Name
  (okay,errtext,DefName) = h.get_value_from_input_str(dfuncdef,'Name',True,defaul_name,line_str=line)
  if( not okay ):
    return (okay,errtext,c.CBase)
  #endif

  (okay,errtext,X0) = h.get_value_from_input_float(dfuncdef,'X0',False,0.0,line_str=line)
  if( not okay ):
    return (okay,errtext,c.CBase)
  #endif

  (okay,errtext,Y0) = h.get_value_from_input_float(dfuncdef,'Y0',False,0.0,line_str=line)
  if( not okay ):
    return (okay,errtext,c.CBase)
  #endif

  (okay,errtext,Dir0) = h.get_value_from_input_float(dfuncdef,'Dir0',False,0.0,line_str=line)
  if( not okay ):
    return (okay,errtext,c.CBase)
  #endif

  # transform from deg to rad
  Dir0 = Dir0 * d.FACTOR_GRAD_TO_RAD
  CDir0 = math.cos(Dir0)
  SDir0 = math.sin(Dir0)

  coordsys = c.CCoordSys(Name=DefName,X0=X0,Y0=Y0,Dir0=Dir0,CosDir0=CDir0,SinDir0=SDir0,LineNum=line_number)

  return (okay,errtext,coordsys)
#enddef
