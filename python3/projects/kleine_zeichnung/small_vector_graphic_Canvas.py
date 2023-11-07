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


def plot_on_cnavas(command_liste: List[c.CBasic]) -> (bool, str,tk.Tk):

  okay    = True
  errtext = ""

  master = tk.Tk()

  (okay,errtext1,baseobj) = h.get_object_from_command_liste("Base","Base","",command_liste)

  if( not okay ):
    return(okay,errtext)
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

  x0,y0 = 0.0, 0.0
  x1,y1 = CanvasData.unit_width , CanvasData.unit_height


  (X0INT,Y0INT) = CanvasData.scale_unit_to_screen(x0,y0)
  (X1INT,Y1INT) = CanvasData.scale_unit_to_screen(x1,y1)


  widget.create_line(X0INT, Y0INT, X1INT, Y1INT, fill="black")

  rr = CanvasData.resolution_unit * 10
  x0,y0 = -rr, -rr
  x1,y1 = rr,rr

  (X0INT,Y0INT) = CanvasData.scale_unit_to_screen(x0,y0)
  (X1INT,Y1INT) = CanvasData.scale_unit_to_screen(x1,y1)

  widget.create_oval(X0INT, Y0INT, X1INT, Y1INT,fill="black")

  rr = CanvasData.resolution_unit * 2

  x0,y0 = CanvasData.unit_width/2. - rr, CanvasData.unit_height/2. - rr
  x1,y1 = x0 + 2*rr,y0 + 2*rr

  (X0INT,Y0INT) = CanvasData.scale_unit_to_screen(x0,y0)
  (X1INT,Y1INT) = CanvasData.scale_unit_to_screen(x1,y1)

  widget.create_oval(X0INT, Y0INT, X1INT, Y1INT,fill="red")


  tk.mainloop()

  return (okay,errtext,master)

#enddef