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


def find_plot_commands(csd: c.CCommandStrData) -> List[list]:
  """
  PlotCoordSys(DefName=coord1,NameX=x,NameY=y,LineWidth=1,ArrowWidth=10,
               ArrowLength=10,LineColor=k)
  PlotLine(DefName=L1,LineColor=r,LineWidth=2,LineType=0)
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