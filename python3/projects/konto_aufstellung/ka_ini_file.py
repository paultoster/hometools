# -*- coding: cp1252 -*-
#
# read ini-file and proof sections for kontodata, ...
#
# data.structure
#
# self.IBAN_TXT                        Iban
# self.WER_TXT                         Inhaber
# self.START_WERT_TXT                  Startwert
# self.START_TAG_TXT                   Starttag
# self.START_ZEIT_TXT                  Startzeit
# self.START_DATUM_TXT                 Startdatum
# self.AUSZUGS_TYP_TXT                 Type von Kontoauszug
#
# self.konto_names = []                Namen der Konten
# self.iban_list_file_name             Name des Iban-Fielnames
#
# dict=self.konto_data[kontoname]      dict von Konto
#
# dict.[self.IBAN_TXT]                        IBAN-Nummer als string
# dict.[self.WER_TXT]                         Wem gehört
# dict.[self.START_WERT_TXT]                  Startwert Euro
# dict.[self.START_DATUM_TXT]                 Startdatum secs
# dict.[self.START_TAG_TXT]                   Tag seit Start int
# dict.[START_ZEIT_TXT]                       Startdatum secs
# dict.[self.AUSZUGS_TYP_TXT]                 Name des types für den Kontoauszug name1_pdf, name2_csv, etc
#
#
# self.KONTO_DATEN_LESEN_TXT
# self.konto_bearb_auswahl = []        Auswahl der Bearbeitungen des Kontos
# self.ENDE_RETURN_TXT                   Zeichen für Ende
#


import os, sys
import tomllib

tools_path = os.getcwd() + "\\.."
if( tools_path not in sys.path ):
    sys.path.append(tools_path)
#endif

# Hilfsfunktionen
import hfkt_def as hdef
import hfkt_type as htype
import hfkt_date_time as hdt


status  = hdef.OKAY
errtext = ""
logtext = ""

class ini_file:
  OKAY = hdef.OK
  NOT_OKAY = hdef.NOT_OK
  status = hdef.OKAY
  errtext = ""
  logtext = ""
  
  konto_names = []
  konto_data  = {}
  
  # Liste der zu checkenden Daten
  # ------------------------------
  KONTO_NAMES         = "konto_names"
  IBAN_LIST_FILE_NAME = "iban_list_file_name"

  # konto daten
  KONTO_PREFIX      = "konto"
  IBAN_TXT          = "iban"
  BANK_TXT          = "bank"
  WER_TXT           = "wer"
  START_WERT_TXT    = "start_wert"
  START_TAG_TXT     = "start_tag"
  START_ZEIT_TXT    = "start_zeit"
  START_DATUM_TXT   = "start_datum"
  AUSZUGS_TYP_TXT  = "auszug_type"
  
  KONTO_PROOF_LISTE = [ (IBAN_TXT, "iban")
                      , (BANK_TXT, "str")
                      , (WER_TXT, "str")
                      , (START_WERT_TXT, "float")
                      , (START_DATUM_TXT, "dat")
                      , (AUSZUGS_TYP_TXT,"str")
                      ]
  


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
        data = tomllib.load(f)
    #endif

    # check base input
    if( self.check_base_input(data) != hdef.OK ):
      return
    # endif

    # check konotonames
    if( self.check_kontodata(data) != hdef.OK ):
      return
    # endif
  # enddef

  def check_base_input(self,data):

    self.konto_names = data.get(self.KONTO_NAMES)
    if( not self.konto_names or (len(self.konto_names)==0)):
      self.status = hdef.NOT_OKAY
      self.add_err_text(f"In inifile {self.ini_file_name} ist keine Liste mit Kontonamen "
                        f"{self.KONTO_NAMES} = [kont1,konto2, ...] !!!!")
      return self.status
    # endif


    [okay, self.iban_list_file_name] = htype.hfkt_type_proof(data.get(self.IBAN_LIST_FILE_NAME), "str")
    if( okay != hdef.OKAY ):
      self.status = hdef.NOT_OKAY
      self.add_err_text(f"In inifile {self.ini_file_name} ist keine Name für das iban_file angegeben"
                        f" {self.IBAN_LIST_FILE_NAME} = \"name\" !!!!")
      return self.status
    # endif

    
    return self.status
  # enddef


  def check_kontodata(self,data):
    """
    check kontonames sections from ini-file
    :return: status
    """
    liste = self.konto_names
    self.konto_names = []
    for kontoname in liste:

      kontodict = data.get(kontoname)

      if( self.check_konto(kontoname,kontodict) != hdef.OK ):
        return hdef.NOT_OKAY
      else:
        self.konto_names.append(kontoname)
        self.konto_data[kontoname] = kontodict
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

    # Prüfe die Daten aus proof_liste
    #--------------------------------
    proof_length = len(self.KONTO_PROOF_LISTE)
    index_liste  = [i for i in range(proof_length)]
    for index,(proof,ttype) in enumerate(self.KONTO_PROOF_LISTE):
      if( proof in key_liste):
        [okay,wert] = htype.hfkt_type_proof(kontodict[proof],ttype)
        if( okay != hdef.OK ):
          self.status = hdef.NOT_OKAY
          self.add_err_text(f"In inifile {self.ini_file_name} is variable {kontoname}.{proof} = {kontodict[proof]} not correct !!!!")
          return self.status
        else:
          kontodict[proof] = wert
          index_liste.remove(index)
        #endif
      #endi
    #endfor

    # Prüfe was nicht definiert wurde
    #--------------------------------
    if( len(index_liste) ):
      self.status = hdef.NOT_OKAY
      for index in index_liste:
        self.add_err_text(f"Im inifile {self.ini_file_name} ist Variable \"{kontoname}.{self.KONTO_PROOF_LISTE[index][0]}\" nicht gesetzt !!!!")
      #endofor
      return self.status
    #endif

    # Bilde/Prüfe Zusatzwerte
    #------------------------

    # aus start_dutum => start_tag und start_zeit
    (start_tag,start_zeit) = hdt.secs_time_epoch_to_epoch_day_time(kontodict[self.START_DATUM_TXT])
    
    kontodict[self.START_TAG_TXT]  = start_tag
    kontodict[self.START_ZEIT_TXT] = start_zeit
    
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
    if (len(self.errtext) > 0):
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