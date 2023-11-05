from dataclasses import dataclass, field
from typing import List

import hfkt_list as hl

@dataclass
class CCommandStrData:
  '''Store all base datas'''
  command_str_list: List[str] = field(default_factory=list)
  linenum_str_list: List[str] = field(default_factory=list)
  n: int = 0
  def add(self,command_str: str, linenum_str: str):
    self.command_str_list.append(command_str)
    self.linenum_str_list.append(linenum_str)
    self.n = self.n + 1;
  def erase(self,index_liste: List[int]):
    self.command_str_list = hl.erase_from_list(self.command_str_list,index_liste)
    self.linenum_str_list = hl.erase_from_list(self.linenum_str_list,index_liste)
    self.n = len(self.command_str_list)
  def move(self,index_liste: List[int]):
    csd = CCommandStrData()
    for i in index_liste:
      if( i < self.n ):
        csd.add(self.command_str_list[i],self.linenum_str_list[i])
      #endif
    #endfor
    self.erase(index_liste)
    self.n = len(self.command_str_list)
    return csd
  def cpy_i0_i1(self,i0: int, i1: int):
    csd = CCommandStrData()
    index_liste = list(range(i0,i1+1))
    for i in index_liste:
      if( i < self.n):
        csd.add(self.command_str_list[i],self.linenum_str_list[i])
      #endif
    #endfor
    return csd

@dataclass
class CBasic:
  ''' basic class'''
  Name: str = 'basic'
  LineNum: str = ""
  TypeName: str = ""

@dataclass
class CBase(CBasic):
  '''Base graphic setup'''
  UnitWidth: float = 10.0                                # [unit] width
  UnitHeight: float = 10.0                               # [unit] height
  PointWidth: int = 800                                  # [points] width
  PointHeight: int = 800                                 # [points] height
  PointsPerUnit: float = field(init=False, repr=False)   # [point/unit] Scaling is not in init and is not show
  def __post_init__(self):

    self.TypeName = "Base"

    self.UnitWidth = max(self.UnitWidth,1e-3)
    self.UnitHeight = max(self.UnitHeight,1e-3)

    scalw = self.PointWidth/self.UnitWidth
    scalh = self.PointHeight/self.UnitHeight

    self.PointsPerUnit = min(scalw,scalh)
  #enddef
@dataclass
class CCoordSys(CBasic):
  '''Coordinate System'''
  X0: float = 0.0             # [unit] Base position X
  Y0: float = 0.0             # [unit] Base position Y
  Dir0: float = 0.0           # [rad]  Bas direction 0.0 is in x-axis direction pi/2 in y-direction
  def __post_init__(self):
    self.TypeName = "CoordSys"
  #enddef

@dataclass
class CPoint(CBasic):
  '''Coordinate System'''
  X0: float = 0.0             # [unit] Base position X
  Y0: float = 0.0             # [unit] Base position Y
  CoordSysName: str = ""
  def __post_init__(self):
    self.TypeName = "Point"
  #enddef

@dataclass
class CLine(CBasic):
  '''Coordinate System'''
  P0: str  = ""               # Name first point
  P1: str  = ""               # Name second point
  CoordSysName: str = ""
  def __post_init__(self):
    self.TypeName = "Line"
  #enddef

@dataclass
class CRectAngle(CBasic):
  '''Coordinate System'''
  P0Name: str  =  ""               # Name start point left/bottom
  XWidth: float = 0.0              # [unit] x-width of rectangle
  YWidth: float = 0.0              # [unit] y-width of rectangle
  Dir0: float = 0.0           # [rad] direction 0.0 is in x-axis direction pi/2 in y-direction

@dataclass
class CPlotCoordSys(CBasic):
  '''Plot Coordinate System'''
  NameX: str = ""             # Name for x-axis
  NameY: str = ""             # Name for y-axis
  LineWidth: float = 1        # [width] line width
  ArrowWidth: float = 10      # [width] arrow width compared to line width
  ArrowLength: float = 10     # [width] arrow length compared to line width
  LineColor: str = 'k'        # ['k','r','g',...] line color

@dataclass
class CPlotLine(CBasic):
  '''plot line'''
  NameLine: str = ""          # Name to plot on line
  LineColor: str = 'k'        # ['k','r','g',...] line color
  LineWidth: float = 1        # [width] line width
  LineType: str = ""          # [straight, arrow+straight, straight+arrow] type of line
  ArrowWidth: float = 10      # [width] arrow width compared to line width
  ArrowLength: float = 10     # [width] arrow length compared to line width

@dataclass
class CPlotPoint(CBasic):
  '''plot ploint'''
  NamePoint: str = ""         # Name to plot on point
  PointColor: str = 'k'       # ['k','r','g',...] line color
  PointWidth: float = 10      # [width] width of the point compared to line width
  PontType: str = ""          # ['o',+',*',',...] type of point

@dataclass
class CPlotRectAngle(CBasic):
  '''plot ploint'''
  LineColor: str = 'k'        # ['k','r','g',...] line color
  LineWidth: float = 1        # [width] line width
