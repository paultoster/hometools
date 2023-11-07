"""
# Kommentar
# Grafikbefehle als Beispiele

Base( UnitWidth=10.0,UnitHeight=10.0,PointWidth=800,PointHeight=800)

CoordSys(Name=coord1,X0=2.0,Y0=2.0,Dir0=90)

Point( Name=P1, X0=10.0, Y0=0.0)
Line(Name=L1,PO=P1,P1=P2)
#
PlotLine(Line=L1,Color=r,Width=2,Type=0)
#
RectAngleDef(Name=RADef1,XWidth=10,YWidth=10)
TextDef(Name=TDef1,Text=abcdef\nijjk)
#
RectAngle(Name=RA1,RectAbgleName=RADef1,X0=5.0,Y0=20.0,Dir0=0)
Text(Name=T1,TextName=TDef1,X0=5.0,Y0=20.0,Dir0=0)


PlotCoordSys(DefName=coord1,NameX=x,NameY=y,LineWidth=1,ArrowWidth=10,
             ArrowLength=10,LineColor=k)

PlotPoint(DefName=L1,NameP=,PointColor=r,PointWidth=2)
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

