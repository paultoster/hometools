from dataclasses import dataclass

@dataclass
class CBasic:
  ''' basic class'''
  Name: str = 'basic'

@dataclass
class CBase(CBasic):
  '''Base graphic setup'''
  X0: float = 0.0             # [unit] Base position X
  Y0: float = 0.0             # [unit] Base position Y
  Dir0: float = 0.0           # [rad]  Bas direction 0.0 is in x-axis direction pi/2 in y-direction
  PointsPerUnit: float = 100   # [point/unit] Scaling

@dataclass
class CCoordSys(CBasic):
  '''Coordinate System'''
  X0: float = 0.0             # [unit] Base position X
  Y0: float = 0.0             # [unit] Base position Y
  Dir0: float = 0.0           # [rad]  Bas direction 0.0 is in x-axis direction pi/2 in y-direction
  PointsPerUnit: float = 100. # [point/unit] Scaling

@dataclass
class CPoint(CBasic):
  '''Coordinate System'''
  X0: float = 0.0             # [unit] Base position X
  Y0: float = 0.0             # [unit] Base position Y

@dataclass
class CLine(CBasic):
  '''Coordinate System'''
  P0Name: str  = ""               # Name first point
  P1Name: str  = ""               # Name second point

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
