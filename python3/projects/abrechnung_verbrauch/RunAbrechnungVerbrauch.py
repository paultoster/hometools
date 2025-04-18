#-------------------------------------------------------------------------------
# Name:        RunAbrechnungVerbrauch (Python 3)
# Purpose:
#
# Author:      tftbe1
#
# Created:     02.01.2020
# Copyright:   (c) tftbe1 2020
# Licence:     -
#-------------------------------------------------------------------------------
import sys,os



tools_path = os.getcwd() + "\\.."
if( tools_path not in sys.path ):
    sys.path.append(tools_path)

t_path, _ = os.path.split(__file__)
if (t_path == os.getcwd()):
  import AbrechnungVerbrauch as av
else:
  from abrechnung_verbrauch import AbrechnungVerbrauch as av
#endif

# Hilfsfunktionen
from tools import hfkt as h
from tools import hfkt_def as hdef



a = av.AV(inifile="modul.ini",debug_flag=1)

if( a.status == hdef.OK ):
  a.run()
a.__del__()