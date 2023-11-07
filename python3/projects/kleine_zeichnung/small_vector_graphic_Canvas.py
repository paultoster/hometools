#-------------------------------------------------------------------------------
# Name:        Canvas
# Purpose:
#
# Author:      lino
#
# Created:     04.11.2023
# Copyright:   (c) lino 2023
# Licence:     <your licence>
#-------------------------------------------------------------------------------

import tkinter as tk

from dataclasses import dataclass
from typing import List

import small_vector_graphic_classes as c
import small_vector_graphic_defines as d
import small_vector_graphic_helper  as h


from hfkt import hfkt_str as hs
from hfkt import hfkt_list as hl

@dataclass
class CCanvasData:
    '''Store all canvas datas'''
    unit_width: float = 0.0
    unit_height: float = 0.0
    point_width: int = 0
    point_height: int = 0
    screen_width: int = 0
    screen_height: int = 0
    points_per_unit: float = 1.0
    ratio_width_to_height: float = 1.0
    ratio_canvas_to_screen: float = 1.0
    resolution_unit = 0.0
    y_resolution = 0.0
    def calc_screen(self,maxscreenwidth: int,maxscreenheight: int):
      if( self.point_width == 0 ): self.point_width = 1
      if( self.point_height == 0 ): self.point_height = 1
      if( maxscreenwidth == 0 ): maxscreenwidth = 1
      if( maxscreenheight == 0 ): maxscreenheight = 1

      ratio_w = float(self.point_width)/float(maxscreenwidth)
      ratio_h = float(self.point_height)/float(maxscreenheight)

      if( ratio_w > ratio_h ):
        self.ratio_canvas_to_screen = 1./ratio_w
        self.screen_width  = maxscreenwidth;
        self.screen_height = int(float(self.point_height)*self.ratio_canvas_to_screen)
      else:
        self.ratio_canvas_to_screen = 1./ratio_h
        self.screen_width = int(float(self.point_width)*self.ratio_canvas_to_screen)
        self.screen_height  = maxscreenheight;

      CanvasData.ratio_width_to_height = float(CanvasData.point_height)/float(CanvasData.point_width)
    #enddef
    def calc_resolution(self):
      self.resolution_unit = 1.0 / self.points_per_unit / self.ratio_canvas_to_screen
    #enddef
    def scale_unit_to_screen(self,xunit: float,yunit: float) -> (int,int):
      xs = int(xunit * self.points_per_unit * self.ratio_canvas_to_screen)
      ys = self.screen_height - int(yunit * self.points_per_unit * self.ratio_canvas_to_screen)

      return (xs,ys)
    #enddef

CanvasData = CCanvasData()


def define_plot_on_cnavas(command_liste: List[c.CBasic]) -> (bool, str,tk.Tk,tk.Canvas):

  okay    = True
  errtext = ""

  master = tk.Tk()

  (okay,errtext1,baseobj) = h.get_object_from_command_liste("Base","Base","",command_liste)

  if( not okay ):
    return(okay,errtext,master,tk.Canvas())
  #endif

  CanvasData.point_width  = baseobj.PointWidth
  CanvasData.point_height = baseobj.PointHeight
  CanvasData.unit_width   = baseobj.UnitWidth
  CanvasData.unit_height  = baseobj.UnitHeight
  CanvasData.points_per_unit = baseobj.PointsPerUnit

  if( CanvasData.point_width == 0 ): CanvasData.point_width = 10
  if( CanvasData.point_height == 0 ): CanvasData.point_height = 10

  CanvasData.calc_screen(int(master.winfo_screenwidth()*d.CANVAS_SCREEN_SIZE_WIDTH_FACTOR)
                        ,int(master.winfo_screenheight()*d.CANVAS_SCREEN_SIZE_HEIGHT_FACTOR))

  CanvasData.calc_resolution()

  geometry = f"{CanvasData.screen_width}x{CanvasData.screen_height}"

  master.geometry(geometry)
  master.title("Canvas Plot")

  widget = tk.Canvas(master,width=CanvasData.screen_width,height=CanvasData.screen_height,bg="white")
  widget.pack()

  return (okay,errtext, master, widget )
#enddef

##  x0,y0 = 0.0, 0.0
##  x1,y1 = CanvasData.unit_width , CanvasData.unit_height
##
##
##  (X0INT,Y0INT) = CanvasData.scale_unit_to_screen(x0,y0)
##  (X1INT,Y1INT) = CanvasData.scale_unit_to_screen(x1,y1)
##
##
##  widget.create_line(X0INT, Y0INT, X1INT, Y1INT, fill="black")
##
##  rr = CanvasData.resolution_unit * 10
##  x0,y0 = -rr, -rr
##  x1,y1 = rr,rr
##
##  (X0INT,Y0INT) = CanvasData.scale_unit_to_screen(x0,y0)
##  (X1INT,Y1INT) = CanvasData.scale_unit_to_screen(x1,y1)
##
##  widget.create_oval(X0INT, Y0INT, X1INT, Y1INT,fill="black")
##
##  rr = CanvasData.resolution_unit * 2
##
##  x0,y0 = CanvasData.unit_width/2. - rr, CanvasData.unit_height/2. - rr
##  x1,y1 = x0 + 2*rr,y0 + 2*rr
##
##  (X0INT,Y0INT) = CanvasData.scale_unit_to_screen(x0,y0)
##  (X1INT,Y1INT) = CanvasData.scale_unit_to_screen(x1,y1)
##
##  widget.create_oval(X0INT, Y0INT, X1INT, Y1INT,fill="red")


  tk.mainloop()

  return (okay,errtext,master)

#enddef


def plot_commands_on_cnavas(tkcanvas: tk.Canvas,command_liste: List[c.CBasic])  -> (bool, str):

  (okay,errtext) = (True,"")

  #---------------------------------------------------------------------------------------------
  # seperate all Plot Demands
  #-----------------------------------------------------------------------------------------------
  index_list = []
  for i,obj in enumerate(command_liste):
    index = hs.such(obj.TypeName,'Plot','vs')
    if( index == 0 ):
      index_list.append(i)
    #endif
  #endfor


  plot_command_liste = hl.list_move_items(command_liste,index_list)


  # loop over plot command list
  for pobj in plot_command_liste:


    match pobj.Name:
      case "PlotLine":

        (okay,errtext) = plot_line_on_cnavas(tkcanvas,command_liste,pobj)
        if( not okay ):
          return (okay,errtext)

      case _:
        okay = False
        errtext = f"The function Name for Plot: {pobj.Name} in line {pobj.LineNum} is not valid"
        return (okay,errtext)
    #endmatch
  #endfor
  return (okay,errtext)
#enddef

def plot_line_on_cnavas(tkcanvas: tk.Canvas,command_liste: List[c.CBasic],pobj: c.CBasic) -> (bool, str):

  (okay,errtext) = (True,"")


  # point indeces of Line command
  iP0 = command_liste[pobj.indexLine].indexP0
  iP1 = command_liste[pobj.indexLine].indexP1

  # x,y positions of two point commands
  x0  = command_liste[iP0].X0
  y0  = command_liste[iP0].Y0
  x1  = command_liste[iP1].X0
  y1  = command_liste[iP1].Y0

  tuple_list = h.transform_from_coord_to_base( [(x0,y0),(x1,y1)],command_liste[pobj.indexCoordSys])

  X0 = tuple_list[0][0]
  Y0 = tuple_list[0][1]
  X1 = tuple_list[1][0]
  Y1 = tuple_list[1][1]

  (X0INT,Y0INT) = CanvasData.scale_unit_to_screen(X0,Y0)
  (X1INT,Y1INT) = CanvasData.scale_unit_to_screen(X1,Y1)

  # dash
  if( pobj.Type == 0 ):
    tkcanvas.create_line(X0INT, Y0INT, X1INT, Y1INT, fill=pobj.Color, width=pobj.Width)
  else:
    if( pobj.Type == 1):
       ddash = (1*pobj.Width,1)
    elif( pobj.Type == 2):
       ddash = (5*pobj.Width,1)
    else:     #if( pobj.Type == 3)
       ddash = (5*pobj.Width,1,1,1)
    #endif
    tkcanvas.create_line(X0INT, Y0INT, X1INT, Y1INT, fill=pobj.Color, width=pobj.Width,dash=ddash)
  #endif

  return (okay,errtext)
#enddef