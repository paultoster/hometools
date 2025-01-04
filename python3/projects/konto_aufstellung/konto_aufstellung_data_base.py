import os, sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

# Hilfsfunktionen
import hfkt_def as hdef
import hfkt_db_io as hdbio


class data_base:
  
  OKAY     = hdef.OK
  NOT_OKAY = hdef.NOT_OK
  status = hdef.OKAY
  errtext = ""
  logtext = ""

  def __init__(self,sqlfilename):
  
    # open sl-File
    dbio = hdbio.dbio(sqlfilename)
    
    if (dbio.status == dbio.NOT_OKAY):
      self.add_err_text(dbio.get_err_text())
      status =  self.NOT_OKAY
    #endif
    
  #enddef
  
  # -----------------------------------------------------------------------------
  # internal add_err_text
  # -----------------------------------------------------------------------------
  def add_err_text(self, text: str) -> None:
    """
    add error text

    :param text:
    :return:
    """
    if (len(self.errText) > 0):
      self.errtext += "\n" + text
    else:
      self.errtext += text
  
  # enddef
  # -----------------------------------------------------------------------------
  # public get_err_text
  # -----------------------------------------------------------------------------
  def get_err_text(self) -> str:
    """
    get erro text reurned and reset internally
    :return:
    """
    err_text = self.errtext
    self.errtext = ""
    return err_text
  # enddef
  # -----------------------------------------------------------------------------
#enddef
