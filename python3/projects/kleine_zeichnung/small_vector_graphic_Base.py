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

from tools import hfkt_str as hs

import small_vector_graphic_classes as c
import small_vector_graphic_defines as d
import small_vector_graphic_helper  as h





def build_base_object(csd: c.CCommandStrData) -> (bool, str,c.CBase,List[int]):
  """
  Base(UnitWidth=10.0,UnitHeight=10.0,PointWidth=800,PointHeight=800)
  """
  okay = True
  errtext = ""
  base_obj = c.CBase

  line_index_liste = hs.such_in_liste(csd.command_str_list,'Base','n')

  if( len(line_index_liste) == 0 ): # kein Base definiert dannn default

      base_obj = c.CBase

  else:

    # read all parameter of Base
    dfuncdef = {}
    for line_index in line_index_liste:

      (okay,errtext,dfuncdef) = h.get_keys_from_line_input(csd.command_str_list[line_index],dfuncdef)

      if( not okay ):
        return (okay,errtext,c.CBase,line_index_liste)
      #endif
    #endfor

    # set parameters:
    # UnitWidth
    (okay,errtext,UnitWidth) = h.get_value_from_input_float(dfuncdef,'UnitWidth',True,10.0,line_str=csd.linenum_str_list[line_index])
    if( not okay ):
      return (okay,errtext,base_obj,line_index_liste)
    #endif

    # UnitHeight
    (okay,errtext,UnitHeight) = h.get_value_from_input_float(dfuncdef,'UnitHeight',True,10.0,line_str=csd.linenum_str_list[line_index])
    if( not okay ):
      return (okay,errtext,base_obj,line_index_liste)
    #endif

    # PointWidth
    (okay,errtext,PointWidth) = h.get_value_from_input_int(dfuncdef,'PointWidth',True,800,line_str=csd.linenum_str_list[line_index])
    if( not okay ):
      return (okay,errtext,base_obj,line_index_liste)
    #endif

    # PointHeight
    (okay,errtext,PointHeight) = h.get_value_from_input_int(dfuncdef,'PointHeight',True,800,line_str=csd.linenum_str_list[line_index])
    if( not okay ):
      return (okay,errtext,base_obj,line_index_liste)
    #endif

    base_obj = c.CBase(UnitWidth=UnitWidth,UnitHeight=UnitHeight,PointWidth=PointWidth,PointHeight=PointHeight,LineNum=csd.linenum_str_list[line_index])

  #endif

  return (okay,errtext,base_obj,line_index_liste)