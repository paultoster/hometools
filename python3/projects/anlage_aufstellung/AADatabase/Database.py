# -*- coding: utf8 -*-
#
#
# cp1252
#

import sys, os

tools_path = "D:\\tools_tb\\python3"

if( tools_path not in sys.path ):
  sys.path.append(tools_path)

# Hilfsfunktionen
from hfkt import hfkt as h
from hfkt import hfkt_db_handle  as hdbh
from hfkt import hfkt_status as hstatus

from AADatabase import DatabaseDef as dbdef
from .FktDatabaseGetAnlagekontoDaten import fkt_db_get_anlage_konto_daten
from .FktDatabaseGetAnlagekontoDaten import fkt_db_get_anlage_konto_header_liste
from .FktDatabaseGetAnlagekontenListe import fkt_db_get_anlagen_konten_liste
from .FktDatabaseLoescheAnlagenkonto import fkt_db_loesche_anlagen_konto
from .FktDatabaseSetAnlagenkontoDaten import fkt_db_set_anlagen_konto_daten

#===============================================================================
#===============================================================================
class db:
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  status     = dbdef.OKAY

  #-------------------------------------------------------------------------------
  #-------------------------------------------------------------------------------
  def __init__(self,log,datafilename,debug_flag=0,backup_flag=0,backup_dir = ''):

    # Status
    #========
    self.stat = hstatus.status()

    self.log          = log
    self.datafilename = datafilename
    self.backup_flag  = backup_flag
    self.backup_dir   = backup_dir

    if( len(backup_dir) == 0 ):
      self.backup_flag = 0
    #endif

    # dbdeffile dbdef.dbdeffile lesen
    self.dbh = hdbh.dbhandle(dbdef.DBDEFLISTE,self.datafilename)

    if( self.dbh.status != self.dbh.OKAY ):

      self.stat
      self.status = dbdef.NOT_OKAY
      self.errText = f"Error hfkt_db_handle: {self.dbh.errText}"
      self.log.write_err(self.errText)
      return

    elif( self.dbh.has_log_text() ):

      self.log.write_e(self.dbh.logText)
      self.dbh.logText = ""
    #endif

    if( debug_flag ):
      self.DEBUG_FLAG = True
    else:
      self.DEBUG_FLAG = False
    #endif

  #enddef
  #-------------------------------------------------------------------------------
  #-------------------------------------------------------------------------------
  def getAnlagenkontenHeaderList(self):

    (header_liste,status,errText) = fkt_db_get_anlage_konto_header_liste(self.dbh)

    return header_liste
  #-------------------------------------------------------------------------------
  #-------------------------------------------------------------------------------
  def getAnlagenkontenDaten(self,anlagekontoname: str):

    (d,status,errText) = fkt_db_get_anlage_konto_daten(self.dbh,anlagekontoname)

    if( status == self.dbh.NOT_OKAY ):

      self.status = dbdef.NOT_OKAY
      self.errText = f"Error hfkt_db_handle: {errText}"
      self.log.write_err(errText,1)

    else:

      self.status = dbdef.OKAY
      self.errText = ""

    #endif

    return d
  #endef
  #-------------------------------------------------------------------------------
  #-------------------------------------------------------------------------------
  def getAnlagekontenListe(self):

    (r,status,errText) = fkt_db_get_anlagen_konten_liste(self.dbh)

    if( status != self.dbh.OKAY ):
      self.status = dbdef.NOT_OKAY
      self.errText = f"Error FktDatabaseGetAnlagekontenListe: {errText}"
      self.log.write_err(errText,1)
    else:
      self.status = dbdef.OKAY
      self.errText = ""

    #endif
    return (r["prim_key_liste"],r["anlagekonten_namen_liste"])
  #endef
  #-------------------------------------------------------------------------------
  #-------------------------------------------------------------------------------
  def setAnlagenkontoDaten(self,kontoname: str,dout: dict):

    (status,errText) = fkt_db_set_anlagen_konto_daten(self.dbh,kontoname,dout)

    if( status != self.dbh.OKAY ):
      self.status = dbdef.NOT_OKAY
      self.errText = f"Error fkt_db_set_anlagen_konto_daten: {errText}"
      self.log.write_err(errText,1)
    else:
      self.status = dbdef.OKAY
      self.errText = ""
    #endif

    return
  #enddef

  #-------------------------------------------------------------------------------
  #-------------------------------------------------------------------------------
  def loescheAnlagenkonto(self,kontoname: str):
  #-------------------------------------------------------------------------------
  #-------------------------------------------------------------------------------
    (flag,status,errText) = fkt_db_loesche_anlagen_konto(self.dbh,kontoname)

    if( status != self.dbh.OKAY ):
      self.status = dbdef.NOT_OKAY
      self.errText = f"Error fkt_db_loesche_anlagen_konto: {errText}"
      self.log.write_err(errText,1)
    else:
      self.status = dbdef.OKAY
      self.errText = ""
    #endif

    return flag
  #enddef
  #-------------------------------------------------------------------------------
  #-------------------------------------------------------------------------------
  def __del__(self):

    # close database connection
    self.dbh.close()
    if( self.dbh.has_log_text() ):
      self.log.write_e(self.dbh.logText,1)
      self.dbh.logText = ""
    #endif

    #copy backup
    if( self.backup_flag and self.dbh.data_base_is_modified() ):
      if( not os.path.isdir(self.backup_dir) ):
        self.log.write_err("Backup-Dir <%s> not available" % self.backup_dir,1)
      elif( not os.path.isfile(self.dbdatafile) ):
        self.log.write_err("No database-Fiel <%s> found" % self.dbdatafile,1)
      else:
        (path,fbody,ext) = h.get_pfe(self.par.dbdatafile)
        backup_file_name = os.path.join(self.backup_dir,fbody+"_"+str(h.int_akt_datum())+"_"+str(h.int_akt_time())+"."+ext)
        try:
          h.copy(self.par.dbdatafile,backup_file_name,silent=1)
          self.log.write_e("backup-copy: %s " % backup_file_name,1)
        except:
          self.log.write_err("No backup-copy possible to <%s> " % self.par.dbdatafile,1)
        #endtry
      #endif
    #endif
  #enddef
#endclass

if __name__ == '__main__':
  pass
