"""
# Kommentar
# Grafikbefehle als Beispiele
--------------------------------------------------------------------------------
Base( UnitWidth=10.0,UnitHeight=10.0,PointWidth=800,PointHeight=800)
--------------------------------------------------------------------------------
CoordSys(Name=coord1,X0=2.0,Y0=2.0,Dir0=90)
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
Line(Name=L1,PO=P1,P1=P2)
Name=L1   Name of line
PO=P1     First Point
P1=P2     second point definition
--------------------------------------------------------------------------------
RectAngle(Name=RA1,DX=10,DY=10,Anchor='m',P0=PName,X0=2,Y0=3,Dir0=0)
#
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
#

TextDef(Name=TDef1,Text=abcdef\nijjk)
#
RectAngle(Name=RA1,RectAbgleName=RADef1,X0=5.0,Y0=20.0,Dir0=0)
Text(Name=T1,TextName=TDef1,X0=5.0,Y0=20.0,Dir0=0)


PlotCoordSys(DefName=coord1,NameX=x,NameY=y,LineWidth=1,ArrowWidth=10,
             ArrowLength=10,LineColor=k)
--------------------------------------------------------------------------------
PlotPoint(Point=PA,Color=red,Width=2,Type=0)
Point=PA     Definition of a point
Color=red  color  [black],green,red,blue,orange,aqua,azure,brown,coral,cyan,gray
                  yellow,magenta,olive,pink,voilet,white, ...
Width=2    width of point [1] size is points
Type=0     fill type [0: solid],1: line
Radius     [points] if type == 1 radius of circle
--------------------------------------------------------------------------------
PlotRectAngle(DefName=RA1,LineColor=b,LineWidth=2,LineType=0)
PlotText(DefName=T1,TextColor=k)



"""

import tkinter as tk
from dataclasses import dataclass
from typing import List

import os, sys

tools_path = os.getcwd() + "//.."
if( tools_path not in sys.path ):
    sys.path.append(tools_path)

from hfkt import hfkt_str as hs
from hfkt import hfkt_list as hl

import small_vector_graphic_classes as c
import small_vector_graphic_defines as d
import small_vector_graphic_helper  as h
import small_vector_graphic_Base as base
import small_vector_graphic_CoordSys as coordsys
import small_vector_graphic_Plot as plot
import small_vector_graphic_Geo as geo
import small_vector_graphic_Canvas as canvas


def static_vars(**kwargs):
  def decorate(func):
    for k in kwargs:
      setattr(func, k, kwargs[k])
    return func
  return decorate



def build_and_proof_input(input_liste: List[str]) -> (bool, str,List[c.CBasic]):


   # eleminiere Komentare und leere Zeilen und füge mehrzeilge kommandos zusammen
  (okay,errtext,csd) = h.prepare_input_lines(input_liste)

  if( not okay ):
    return (okay,errtext,[])
  #endif

  (okay,errtext,command_liste) = prepare_commands(csd)

  if( not okay ):
    return (okay,errtext,[])
  #endif

  return (okay,errtext,command_liste)




def prepare_commands(csd: c.CCommandStrData) -> (bool, str,List[c.CBasic]):

  okay = True
  errtext = ""
  command_liste = []

  #--------------------------------------------------------------------------------------------
  # Base definition
  #--------------------------------------------------------------------------------------------

  (okay,errtext,base_obj,index_liste) = base.build_base_object(csd)

  if( not okay ):
    return (okay,errtext,command_liste)
  #endif
  csd.erase(index_liste)

  command_liste = [base_obj]

  #---------------------------------------------------------------------------------------------
  # seperate all Plot Demands
  #-----------------------------------------------------------------------------------------------
  index_liste = plot.find_plot_commands(csd)

  csdplot = csd.move(index_liste)

  #--------------------------------------------------------------------------------------------
  # find coordinate systems, read and devide definition
  #--------------------------------------------------------------------------------------------

  (okay,errtext,list_coordsys_obj,line_index_tuple_liste) = coordsys.build_coordsys_object_list(csd)
  if( not okay ):
    return (okay,errtext,command_liste)
  #endif

  #--------------------------------------------------------------------------------------------
  # loop over list of coordsy and line demands, read geometric function, proof and
  # add to command_liste
  #--------------------------------------------------------------------------------------------

  for i,obj in enumerate(list_coordsys_obj):

    command_liste.append(obj)
    csdgeo = csd.cpy_i0_i1(line_index_tuple_liste[i][0],line_index_tuple_liste[i][1])
    coordsysname = obj.Name

    (okay,errtext,command_liste) = geo.build_geo_objects(csdgeo,command_liste,coordsysname)

    if( not okay ):
      return (okay,errtext,command_liste)

  #endfor

  #-------------------------------------------------------------------------------------------
  # plot demands
  #-------------------------------------------------------------------------------------------

  (okay,errtext,command_liste) = plot.build_plot_commands(csdplot,command_liste)

  return (okay,errtext,command_liste)
#enddef

@static_vars(TkMaster=0)
@static_vars(TkCanvas=0)
def paint_command_liste(command_liste: List[c.CBasic]) -> (bool, str):

  nTkMaster=nTkCanvas=0
  if( isinstance(paint_command_liste.TkMaster,tk.Tk) ):

    try:
      nTkMaster = paint_command_liste.TkMaster.winfo_exists()
      nTkCanvas = paint_command_liste.TkCanvas.winfo_exists()
    except:
      print(f"Crash")

    print(f"paint_command_liste.TkMaster.winfo_exists(): {nTkMaster}")
    print(f"paint_command_liste.TkCanvas.winfo_exists(): {nTkCanvas}")
  #endif

  if( nTkMaster > 0 and nTkCanvas > 0):
    paint_command_liste.TkCanvas.delete('all')
    tkcanvas = paint_command_liste.TkCanvas
  else:
     # Canvas anlegen
    (okay,errtext,tkmaster,tkcanvas) = canvas.define_plot_on_cnavas(command_liste)
    if( not okay ):
      return (okay,errtext)

    paint_command_liste.TkMaster = tkmaster
    paint_command_liste.TkCanvas = tkcanvas
  #endif


  (okay,errtext) = canvas.plot_commands_on_cnavas(tkcanvas,command_liste)
  if( not okay ):
    return (okay,errtext)


  return(okay,errtext)
#endif

