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


from tools import hfkt_str as hs


def find_plot_commands(csd: c.CCommandStrData) -> List[list]:
  """
  PlotCoordSys(DefName=coord1,NameX=x,NameY=y,LineWidth=1,ArrowWidth=10,
               ArrowLength=10,LineColor=k)
  --------------------------------------------------------------------------------
  PlotLine(Line=L1,Color=red,Width=2,Type=0,Arrow=11)
  Line=L1:   Line definition Line(Name=L1,... must be defined
  Color=red  color  [black],green,red,blue,orange,aqua,azure,brown,coral,cyan,gray
                    yellow,magenta,olive,pink,voilet,white, ...
  Width=2    width of line [1] size is points
  Type=0     line type [0: solid],1: dash,2: double dashed
  Arrow=11   arrow left digit is start (Xo,Y0), right digit is end (X1,Y1)
                   [00: no arrow],11: eckiger Pfeil, 22: spitzer Pfeil
  --------------------------------------------------------------------------------
  PlotPoint(DefName=L1,NameP=,PointColor=r,PointWidth=2)
  PlotRectAngle(DefName=RA1,LineColor=b,LineWidth=2,LineType=0)
  PlotText(DefName=T1,TextColor=k)
  """
  index_list = []

  for i,cline in enumerate(csd.command_str_list):
    index = hs.such(cline,'Plot','vs')
    if( index == 0 ):
      index_list.append(i)
    #endif
  #endfor

  return index_list

#enddef



def build_plot_commands(csd: c.CCommandStrData,command_liste: List[c.CBasic]) -> (bool, str,List[c.CBasic]):
  """
  PlotLine(Line=L1,Color=r,Width=2,Type=0)
  """
  okay = True
  errtext = ""

  if( csd.n == 0 ):
      okay = False
      errtext = f"No plotting Function set yet"
      return (okay,errtext,command_liste)
  #endif

  for i in range(csd.n):

    liste = hs.get_string_not_quoted(csd.command_str_list[i],d.QUOT0_FUNCTION,d.QUOT1_FUNCTION)

    if( len(liste) == 0):
      okay = False
      errtext = f"In line {csd.linenum_str_list[i]} no Function name (like \"PlotLine\") was found"
      return (okay,errtext,command_liste)
    #endif

    funcword = liste[0]

    dfuncdef = {}
    (okay,errtext,dfuncdef) = h.get_keys_from_line_input(csd.command_str_list[i],dfuncdef)

    if( not okay ):
      return (okay,errtext,command_liste)

    match funcword:
      case "PlotLine":

        (okay,errtext,command_liste) = getPlotLine(dfuncdef,command_liste,csd.linenum_str_list[i])
        if( not okay ):
          return (okay,errtext,command_liste)

      case "PlotPoint":

        (okay,errtext,command_liste) = getPlotPoint(dfuncdef,command_liste,csd.linenum_str_list[i])
        if( not okay ):
          return (okay,errtext,command_liste)

      case _:
        okay = False
        errtext = f"The function word for Plot: {funcword} in line {csd.linenum_str_list[i]} is not valid"
        return (okay,errtext,command_liste)
    #endmatch


  #endfor

  return (okay,errtext,command_liste)

#enddef

def getPlotLine(dfuncdef: dict,command_liste: List[c.CBasic],linenum: str) -> (bool, str,List[c.CBasic]):
  """
  --------------------------------------------------------------------------------
  PlotLine(Line=L1,Color=red,Width=2,Type=0,Arrow=11)
  Line=L1:   Line definition Line(Name=L1,... must be defined
  Color=red  color  [black],green,red,blue,orange,aqua,azure,brown,coral,cyan,gray
                    yellow,magenta,olive,pink,voilet,white, ...
  Width=2    width of line [1] size is points
  Type=0     line type [0: solid],1: dash,2: double dashed
  Arrow=11   arrow left digit is start (Xo,Y0), right digit is end (X1,Y1)
                   [00: no arrow],11: eckiger Pfeil, 22: spitzer Pfeil
  --------------------------------------------------------------------------------
  """
  okay=True
  errtext= ""


  # LineName
  (okay,errtext,LineName) = h.get_value_from_input_str(dfuncdef,'Line',False,"",line_str=linenum)
  if( not okay ):
    return (okay,errtext,command_liste)
  #endif
  # LineName in command suchen und index merken
  (okay,errtext1,iLineDef) = h.get_index_of_name_in_command_liste("Line",LineName,linenum,command_liste)
  if( not okay ):
    errtext = f"In PlotLine Function (linenum {linenum}) Name of Line: {LineName} not found: {errtext1}"
    return (okay,errtext,command_liste)
  #endif

  # CoordSys von Line suchen uns index merken
  (okay,errtext1,iCoordSysDef) = h.get_index_of_name_in_command_liste("CoordSys",command_liste[iLineDef].CoordSysName,linenum,command_liste)
  if( not okay ):
    errtext = f"In PlotLine Function (linenum {linenum}) CoordSys Name: {command_liste[iLineDef].CoordSysName} not found: {errtext1}"
    return (okay,errtext,command_liste)
  #endif

  # Color
  (okay,errtext,Color) = h.get_value_from_input_str(dfuncdef,'Color',True,"black",line_str=linenum)
  if( not okay ):
    return (okay,errtext,command_liste)
  #endif

  # Width
  (okay,errtext,Width) = h.get_value_from_input_int(dfuncdef,'Width',True,1,line_str=linenum)
  if( not okay ):
    return (okay,errtext,command_liste)
  #endif

  # Type
  (okay,errtext,Type) = h.get_value_from_input_int(dfuncdef,'Type',True,0,line_str=linenum)
  if( not okay ):
    return (okay,errtext,command_liste)
  #endif

  # Arrow
  (okay,errtext,Arrow) = h.get_value_from_input_int(dfuncdef,'Arrow',True,0,line_str=linenum)
  if( not okay ):
    return (okay,errtext,command_liste)
  #endif

  plotobj = c.CPlotLine(Line=LineName,indexLine=iLineDef,indexCoordSys=iCoordSysDef
                       ,Color=Color,Width=Width,Type=Type,Arrow=Arrow)

  command_liste.append(plotobj)

  return (okay,errtext,command_liste)

#enddef
def getPlotPoint(dfuncdef: dict,command_liste: List[c.CBasic],linenum: str) -> (bool, str,List[c.CBasic]):
  """
  --------------------------------------------------------------------------------
  PlotPoint(Point=PA,Color=red,Width=2,Type=0)
  Point=PA     Definition of a point
  Color=red  color  [black],green,red,blue,orange,aqua,azure,brown,coral,cyan,gray
                    yellow,magenta,olive,pink,voilet,white, ...
  Width=2    width of point [1] size is points
  Type=0     fill type [0: solid],1: line
  Radius     [points] if type == 1 radius of circle
  --------------------------------------------------------------------------------
  """
  okay=True
  errtext= ""


  # PointName
  (okay,errtext,PointName) = h.get_value_from_input_str(dfuncdef,'Point',False,"",line_str=linenum)
  if( not okay ):
    return (okay,errtext,command_liste)
  #endif

  # PointName in command suchen und index merken
  (okay,errtext1,iPointDef) = h.get_index_of_name_in_command_liste("Point",PointName,linenum,command_liste)
  if( not okay ):
    errtext = f"In PlotPoint Function (linenum {linenum}) Name of Line: {PointName} not found: {errtext1}"
    return (okay,errtext,command_liste)
  #endif

  # CoordSys von Pont suchen und index merken
  (okay,errtext1,iCoordSysDef) = h.get_index_of_name_in_command_liste("CoordSys",command_liste[iPointDef].CoordSysName,linenum,command_liste)
  if( not okay ):
    errtext = f"In PlotLine Function (linenum {linenum}) CoordSys Name: {command_liste[iPointDef].CoordSysName} not found: {errtext1}"
    return (okay,errtext,command_liste)
  #endif

  # Color
  (okay,errtext,Color) = h.get_value_from_input_str(dfuncdef,'Color',True,"black",line_str=linenum)
  if( not okay ):
    return (okay,errtext,command_liste)
  #endif

  # Width
  (okay,errtext,Width) = h.get_value_from_input_int(dfuncdef,'Width',True,1,line_str=linenum)
  if( not okay ):
    return (okay,errtext,command_liste)
  #endif

  # Type
  (okay,errtext,Type) = h.get_value_from_input_int(dfuncdef,'Type',True,0,line_str=linenum)
  if( not okay ):
    return (okay,errtext,command_liste)
  #endif

  (okay,errtext,Radius) = h.get_value_from_input_int(dfuncdef,'Radius',True,10,line_str=linenum)
  if( not okay ):
    return (okay,errtext,command_liste)
  #endif

  plotobj = c.CPlotPoint(Point=PointName,indexPoint=iPointDef,indexCoordSys=iCoordSysDef
                       ,Color=Color,Width=Width,Type=Type,Radius=Radius)

  command_liste.append(plotobj)

  return (okay,errtext,command_liste)

#enddef

