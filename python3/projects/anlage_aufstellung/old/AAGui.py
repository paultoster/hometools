# -*- coding: utf8 -*-

import sys

tools_path = "D:\\tools\\tools_tb\\python3"

if( tools_path not in sys.path ):
    sys.path.append(tools_path)

# Hilfsfunktionen
import hfkt_def as hdef
import hfkt_log as hlog


#===============================================================================
#===============================================================================
class AAGui:
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def __init__(self,log):

    self.log = log