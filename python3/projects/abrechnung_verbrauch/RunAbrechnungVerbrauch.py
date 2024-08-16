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

import tools_path as tp

if( tp.tools_path not in sys.path ):
    sys.path.append(tp.tools_path)
    
from abrechnung_verbrauch import AbrechnungVerbrauch as av
# Hilfsfunktionen
from tools import hfkt as h
from tools import hfkt_def as hdef



a = av.AV(inifile="modul.ini",debug_flag=1)

if( a.status == hdef.OK ):
  a.run()
a.__del__()