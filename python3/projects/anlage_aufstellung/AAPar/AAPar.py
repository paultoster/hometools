# -*- coding: utf8 -*-
#
import sys

tools_path = "D:\\tools\\tools_tb\\python3"

if( tools_path not in sys.path ):
    sys.path.append(tools_path)

from dataclasses import make_dataclass

# Hilfsfunktionen
#from tools import hfkt as h
from tools import hfkt_def as hdef
#from tools import hfkt_log as hlog
from tools import hfkt_ini as hini

#===============================================================================
#===============================================================================
class AAPar:
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  status     = hdef.OK
  OKAY       = hdef.OK
  NOT_OKAY   = hdef.NOT_OK
  DEBUG_FLAG = False


  SECTION_ALLG      = u'allg'
  SECTION_KPOSTBANK = u'konto_postbank'

  INIVARLIST = [[SECTION_ALLG,        u'logfilename',              hdef.DEF_STR,    1,     u'log.txt'      ,''] \
               ,[SECTION_ALLG,        u'dbdatafilename',           hdef.DEF_STR,    1,     u'dbdata.sql'   ,''] \
               ,[SECTION_ALLG,        u'backup_flag',              hdef.DEF_INT,    1,     0               ,''] \
               ,[SECTION_ALLG,        u'backup_dir',               hdef.DEF_STR,    1,     u'.'            ,''] \
               ,[SECTION_ALLG,        u'restore_par_file',         hdef.DEF_STR,    1,     u'restore_ini.dat'             ,'if restore_par_file has a file name it stores parameter after read in this file with all defaults'] \
               ,[SECTION_KPOSTBANK,   u'iban',                     hdef.DEF_STR,    1,     u''] \
               ,[SECTION_KPOSTBANK,   u'start_wert',               hdef.DEF_FLT,    1,     0.] \
               ,[SECTION_KPOSTBANK,   u'start_datum',              hdef.DEF_STR,    1,     u''] \
               ,[SECTION_KPOSTBANK,   u'csv_header_name',          hdef.DEF_STR,    1,     u''] \
               ,[SECTION_KPOSTBANK,   u'csv_header_datum',         hdef.DEF_STR,    1,     u''] \
               ,[SECTION_KPOSTBANK,   u'csv_header_wert',          hdef.DEF_STR,    1,     u''] \
               ,[SECTION_KPOSTBANK,   u'csv_header_kommentar',     hdef.DEF_STR,    1,     u''] \
               ,[SECTION_KPOSTBANK,   u'csv_header_iban',          hdef.DEF_STR,    1,     u''] \
               ,[SECTION_KPOSTBANK,   u'csv_header_waehrung',      hdef.DEF_STR,    1,     u''] \
               ]



  def __init__(self):
    self.status            = hdef.OK
    self.errtext           = ""
    self.logtext           = ""
    self.list_konto_name   = []   # list of all konto names see down

  def read_ini_file(self,inifile):
    """
    read ini-File to get
    self.allg.logfilename            Logfilename
    self.allg.dbdatafilename         Datenbasis-Dateiname
    self.allg.backup_flag            flag if back to write
    self.allg.backup_dir             directory for backup

    self.kname1.iban                 first konto iban
    .
    .
    .

    """
    (self.status,self.errtext,out) = hini.readini(inifile,self.INIVARLIST)

    if( self.status != hdef.OK ):
      self.errtext = "Fehler Einlesen Ini-DAtei: <%s>  %s" % (inifile,self.errtext)
      return self.status

    # build dataclas allg
    Allg = make_dataclass(self.SECTION_ALLG,out[self.SECTION_ALLG])
    self.allg = Allg(**out[self.SECTION_ALLG])

    # build dataclass kont_postbank
    Kpostbank = make_dataclass(self.SECTION_KPOSTBANK,out[self.SECTION_KPOSTBANK])
    self.konto_postbank = Kpostbank(**out[self.SECTION_KPOSTBANK])


    # build lidt of all kontos
    self.list_konto_name = [self.SECTION_KPOSTBANK]

    if( self.allg.backup_flag and (len(self.allg.backup_dir)==0) ):
      self.allg.backup_flag = 0
    #endif

    if( len(self.allg.restore_par_file) > 0 ):
      hini.writeini(self.allg.restore_par_file,out)
    #endif



    self.logtext = "================================================================================\n"+ \
                   "%-20s: %s\n" % ("Logfilename",self.allg.logfilename) + \
                   "%-20s: %s\n" % ("Datbasefilename",self.allg.dbdatafilename) + \
                   "%-20s: %i\n" % ("BackupFlag",self.allg.backup_flag) + \
                   "%-20s: %s\n" % ("Backuppath",self.allg.backup_dir) + \
                   "%-20s: %s\n" % ("RestoreParFile",self.allg.restore_par_file) + \
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