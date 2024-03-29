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


from tools import hfkt_str as hs

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
  --------------------------------------------------------------------------------
  Point( Name=P1, X0=10.0, Y0=0.0)
  Name=P1    Name of Point
  X0=10      [unit] x-coordinate
  Y0=1       [unit] y-coordinate
  P0=P10     [name] Name of first point
  P1=P11     [name] Name of point point
  SCALE      [float] P = P0 + (P1-P0)*SCALE
  SCALELEFT  [float] add scale perpendicular left to PO,P1
  SCALERIGHT [float] add scale perpendicular right to PO,P1
  DIST       [unit]  P = P0 + DIST * dir(P0,P1)
  DISTLEFT   [unit]  add distance perpendicular left to PO,P1
  DISTRIGHT  [unit]  add distance perpendicular right to PO,P1
  --------------------------------------------------------------------------------
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

  # Proof if X0,Y0 definition or base on P0,P1
  if( 'X0' in dfuncdef.keys() ): flagx0 = True
  else: flagx0 = False
  if( 'Y0' in dfuncdef.keys() ): flagy0 = True
  else: flagy0 = False
  if( 'P0' in dfuncdef.keys() ): flagp0 = True
  else: flagp0 = False
  if( 'P1' in dfuncdef.keys() ): flagp1 = True
  else: flagp1 = False

  typestr = 'no'
  if( flagp0 and not flagp1 ):
    typestr = 'copyp0'
  elif( flagp1 and not flagp0 ):
    typestr = 'copyp1'
  elif( flagp1 and flagp0 ):
    typestr = 'buildp0p1'
  elif( flagx0 and flagy0 ):
    typestr = 'buildx0y1'
  #endif

  if( typestr == 'no' ):

    errtext = f"No correct definition for Point {DefName} 1. no X0,Y0 defined and/or 2. no P0,P1 defined"
    okay = False
    return (okay,errtext,command_liste)

  #endif
  if( typestr == 'copyp0' or  typestr == 'buildp0p1' ):

    # P0
    (okay,errtext,P0) = h.get_value_from_input_str(dfuncdef,'P0',False,"",line_str=linenum)
    if( not okay ):
      return (okay,errtext,command_liste)
    #endif
    (okay,errtext1,iP0) = h.get_index_of_name_in_command_liste("Point",P0,linenum,command_liste)
    if( not okay ):
      errtext = f"Line Dfeinition in linenum {linenum} has errro: {errtext1}"
      return (okay,errtext,command_liste)
    #endif

    if( typestr == 'copyp0' ):
      X0 = command_liste[iP0].X0
      Y0 = command_liste[iP0].Y0
    else:
      X00 = command_liste[iP0].X0
      Y00 = command_liste[iP0].Y0
    #endif
  #endif
  if( typestr == 'copyp1' or  typestr == 'buildp0p1' ):

    # P1
    (okay,errtext,P1) = h.get_value_from_input_str(dfuncdef,'P1',False,"",line_str=linenum)
    if( not okay ):
      return (okay,errtext,command_liste)
    #endif
    (okay,errtext1,iP1) = h.get_index_of_name_in_command_liste("Point",P1,linenum,command_liste)
    if( not okay ):
      errtext = f"Line Dfeinition in linenum {linenum} has errro: {errtext1}"
      return (okay,errtext,command_liste)
    #endif

    if( typestr == 'copyp1' ):
      X0 = command_liste[iP1].X0
      Y0 = command_liste[iP1].Y0
    else:
      X11 = command_liste[iP1].X0
      Y11 = command_liste[iP1].Y0
    #endif
  #endif

  if( typestr == 'buildp0p1' ):

    alpha = math.atan2((Y11-Y00),(X11-X00))

    # SCALE or DISTANCE
    if( 'SCALE' in dfuncdef.keys() ): flagscale = True
    else: flagscale = False
    if( 'DIST' in dfuncdef.keys() ): flagdist = True
    else: flagdist = False

    if( flagscale ):

      # SCALE
      (okay,errtext,SCALE) = h.get_value_from_input_float(dfuncdef,'SCALE',True,-9999.0,line_str=linenum)
      if( not okay ):
        return (okay,errtext,command_liste)
      #endif

      X0 = X00 + (X11-X00)*SCALE
      Y0 = Y00 + (Y11-Y00)*SCALE
    elif( flagdist ):

      # DIST
      (okay,errtext,DIST) = h.get_value_from_input_float(dfuncdef,'DIST',True,-9999.0,line_str=linenum)
      if( not okay ):
        return (okay,errtext,command_liste)
      #endif



      X0 = X00 + math.cos(alpha) * DIST
      Y0 = Y00 + math.sin(alpha) * DIST


    else:

      errtext = f"No correct definition for Point {DefName} 2. for P0,P1 no SCALE or DIST defined"
      okay = False
      return (okay,errtext,command_liste)

    #endif

    # Look for penpendicular deviation

    # Proof if SCALELEFT,SCALERIGHT,DISTLEFT or DISTRIGHT is defined
    if( 'SCALELEFT' in dfuncdef.keys() ): flagsl = True
    else: flagsl = False
    if( 'SCALERIGHT' in dfuncdef.keys() ): flagsr = True
    else: flagsr = False
    if( 'DISTLEFT' in dfuncdef.keys() ): flagdl = True
    else: flagdl = False
    if( 'DISTRIGHT' in dfuncdef.keys() ): flagdr = True
    else: flagdr = False


    if( flagsl ):

      # SCALELEFT
      (okay,errtext,SCALELEFT) = h.get_value_from_input_float(dfuncdef,'SCALELEFT',True,0.0,line_str=linenum)
      if( not okay ):
        return (okay,errtext,command_liste)
      #endif

      dx = (X11-X00)*abs(SCALELEFT)
      dy = (Y11-Y00)*abs(SCALELEFT)

      dist = math.sqrt(dx*dx+dy*dy)

      if( SCALELEFT >= 0. ):
        alpha += math.pi/2
      else:
        alpha -= math.pi/2
      #endif

      X0 += math.cos(alpha) * dist
      Y0 += math.sin(alpha) * dist

    elif( flagsr ):

      # SCALERIGHT
      (okay,errtext,SCALERIGHT) = h.get_value_from_input_float(dfuncdef,'SCALERIGHT',True,0.0,line_str=linenum)
      if( not okay ):
        return (okay,errtext,command_liste)
      #endif

      dx = (X11-X00)*abs(SCALERIGHT)
      dy = (Y11-Y00)*abs(SCALERIGHT)

      dist = math.sqrt(dx*dx+dy*dy)

      if( SCALERIGHT >= 0. ):
        alpha -= math.pi/2
      else:
        alpha += math.pi/2
      #endif

      X0 += math.cos(alpha) * dist
      Y0 += math.sin(alpha) * dist

    elif( flagdl ):

      # DISTLEFT
      (okay,errtext,DISTLEFT) = h.get_value_from_input_float(dfuncdef,'DISTLEFT',True,0.0,line_str=linenum)
      if( not okay ):
        return (okay,errtext,command_liste)
      #endif

      dist = abs(DISTLEFT)

      if( DISTLEFT >= 0. ):
        alpha += math.pi/2
      else:
        alpha -= math.pi/2
      #endif

      X0 += math.cos(alpha) * dist
      Y0 += math.sin(alpha) * dist

    elif( flagdr ):

      # DISTRIGHT
      (okay,errtext,DISTRIGHT) = h.get_value_from_input_float(dfuncdef,'DISTRIGHT',True,0.0,line_str=linenum)
      if( not okay ):
        return (okay,errtext,command_liste)
      #endif

      dist = abs(DISTRIGHT)

      if( DISTRIGHT >= 0. ):
        alpha -= math.pi/2
      else:
        alpha += math.pi/2
      #endif

      X0 += math.cos(alpha) * dist
      Y0 += math.sin(alpha) * dist
    #endif
  #endif

  if( typestr == 'buildx0y1' ):

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



  #endif


  # point definition
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
  (okay,errtext1,iP0) = h.get_index_of_name_in_command_liste("Point",P0,linenum,command_liste)
  if( not okay ):
    errtext = f"Line Dfeinition in linenum {linenum} has errro: {errtext1}"
    return (okay,errtext,command_liste)
  #endif

  # P1
  (okay,errtext,P1) = h.get_value_from_input_str(dfuncdef,'P1',False,"",line_str=linenum)
  if( not okay ):
    return (okay,errtext,command_liste)
  #endif
  (okay,errtext1,iP1) = h.get_index_of_name_in_command_liste("Point",P1,linenum,command_liste)
  if( not okay ):
    errtext = f"Line Dfeinition in linenum {linenum} has errro: {errtext1}"
    return (okay,errtext,command_liste)
  #endif


  lineobj = c.CLine(Name=DefName,P0=P0,P1=P1,indexP0=iP0,indexP1=iP1
                   ,LineNum=linenum,CoordSysName=coordsysname)

  command_liste.append(lineobj)

  return (okay,errtext,command_liste)

#enddef