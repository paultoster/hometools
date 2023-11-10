# -*- coding: utf8 -*-
#
import sys

tools_path = "D:\\tools\\tools_tb\\python3"

if( tools_path not in sys.path ):
    sys.path.append(tools_path)

# Hilfsfunktionen
#from hfkt import hfkt as h
from hfkt import hfkt_def as hdef
#from hfkt import hfkt_log as hlog
from hfkt import hfkt_ini as hini

#===============================================================================
#===============================================================================
class AAPar:
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  status     = hdef.OK
  OKAY       = hdef.OK
  NOT_OKAY   = hdef.NOT_OK
  DEBUG_FLAG = False


  INIVARLIST = [[u'allg',        u'logfilename',          hdef.DEF_STR,         u'log.txt'      ] \
               ,[u'allg',        u'dbdatafilename',       hdef.DEF_STR,         u'dbdata.sql'   ] \
               ,[u'allg',        u'backup_flag',          hdef.DEF_INT,         0               ] \
               ,[u'allg',        u'backup_dir',           hdef.DEF_STR,         u'.'            ] \
               ]

  def __init__(self):
    self.logfilename       = ""      # log-filename to write log file
    self.dbdatafilename    = ""      # data-base-file-name
    self.backup_flag       = 0
    self.backup_dir        = ""
    self.status            = hdef.OK
    self.errtext           = ""
    self.logtext           = ""

  def read_ini_file(self,inifile):
    """
    read ini-File to get
    self.logfilename            Logfilename
    self.dbdatafilename         Datenbasis-Dateiname
    self.backup_flag            flag if back to write
    self.backup_dir             directory for backup
    """
    (self.status,self.errtext,out) = hini.readini(inifile,self.INIVARLIST)

    if( self.status != hdef.OK ):
      self.errtext = "Fehler Einlesen Ini-DAtei: <%s>  %s" % (inifile,self.errtext)
      return self.status



    self.logfilename     = out['allg']['logfilename']
    self.dbdatafilename  = out['allg']['dbdatafilename']
    self.backup_flag     = out['allg']['backup_flag']
    self.backup_dir      = out['allg']['backup_dir']

    if( self.backup_flag and (len(self.backup_dir)==0) ):
      self.backup_flag = 0

    self.logtext = "================================================================================\n"+ \
                   "%-20s: %s\n" % ("Logfilename",self.logfilename) + \
                   "%-20s: %s\n" % ("Datbasefilename",self.dbdatafilename) + \
                   "%-20s: %i\n" % ("BackupFlag",self.backup_flag) + \
                   "%-20s: %s\n" % ("Backuppath",self.backup_dir) + \
                   "================================================================================\n"

    return self.status

###########################################################################
if __name__ == '__main__':


  tt = "Fehler Einlesen Ini-DAtei: <%s>  %s" % ("def.txt","abc")
  par = AAPar

  par.read_ini_file("inifile.txt")

  if( par.status != hdef.OK ):
    print("%-20s: %s" % ("Error",par.errtext))
    exit()

  print(par.logtext)