# -*- coding: utf8 -*-
#

import sys, os

tools_path = "D:\\tools_tb\\python3"

if( tools_path not in sys.path ):
    sys.path.append(tools_path)

# Hilfsfunktionen
import hfkt as h
import hfkt_def as hdef
import hfkt_log as hlog
import hfkt_ini as hini

#===============================================================================
#===============================================================================
class AADataCalc:
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  status     = hdef.OK
  OKAY       = hdef.OK
  NOT_OKAY   = hdef.NOT_OK
  DEBUG_FLAG = False
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def __init__(self,log,db,par):

    self.state = hdef.OKAY
    self.log = log
    self.db  = db
    self.par = par

    self.log.write_e(text="AADataCalc Init done",screen=0)
  #enddef



  #enddef
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def __del__(self):

    pass
  #enddef
#endclass

if __name__ == '__main__':
  pass
