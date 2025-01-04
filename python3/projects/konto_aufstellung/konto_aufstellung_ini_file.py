import os, sys
import tomllib

tools_path = os.getcwd() + "\\.."
if( tools_path not in sys.path ):
    sys.path.append(tools_path)
#endif

# Hilfsfunktionen
import hfkt_def as hdef

status  = hdef.OKAY
errtext = ""
logtext = ""

class ini_file:
  OKAY = hdef.OK
  NOT_OKAY = hdef.NOT_OK
  status = hdef.OKAY
  errtext = ""
  logtext = ""
  
  data = []
  
  def __init__(self, ini_file_name):

    # check ini-filename
    if (not os.path.isfile(ini_file_name)):
      self.status = hdef.NOT_OKAY
      self.add_err_text(f"ini_file_name = {ini_file_name} does not exist !!!!")
      return

    # read ini-file
    else:
      self.ini_file_name = ini_file_name
      with open(ini_file_name, "rb") as f:
        self.data = tomllib.load(f)
    #endif

    # check konotonames
    if( self.check_kontonames() != hdef.OK ):
      return
  # enddef
  
  def check_kontonames(self):
    """
    check kontonames sections from ini-file
    :return: status
    """
    liste = self.data.get("konto_names")
    if( not liste or (len(liste)==0)):
      self.status = hdef.NOT_OKAY
      self.add_err_text(f"In inifile {self.ini_file_name} is no list 'names' !!!!")
      return self.status
    # endif
    for kontoname in liste:
      kontodict = self.data.get(kontoname)
      if( self.check_konto(kontoname,kontodict) != hdef.OK ):
        return hdef.NOT_OKAY
      #endif
    #endfor

    #endif
    
    return self.status
  #enddef
  def check_konto(self,kontoname,kontodict):
    """
    check specific kontoname from ini-file
    :return: status
    """
    key_liste = kontodict.keys()

    proof_liste      = ["iban","start_wert","start_datum"]
    proof_type_liste = ["str", "float",     "str"]

    for index,proof in enumerate(proof_liste):
      if( proof in key_liste):



    return self.status

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
  
  # -----------------------------------------------------------------------------
#enddef