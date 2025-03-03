# -*- coding: cp1252 -*-
#
# read ini-file and proof sections for kontodata, ...
#
# data.structure
#
# self.IBAN_TXT                        Iban
# self.START_WERT_TXT                  Startwert
# self.START_TAG_TXT                   Starttag
# self.START_ZEIT_TXT                  Startzeit
# self.START_DATUM_TXT                 Startdatum
# self.AUSZUGS_TYP_TXT                 Type von Kontoauszug
#
# self.konto_names = []                 Namen der Konten
#
# dict=self.konto_data[kontoname]      dict von Konto
#
# dict.[self.IBAN_TXT]                        IBAN-Nummer als string
# dict.[self.START_WERT_TXT]                  Startwert Euro
# dict.[self.START_DATUM_TXT]                 Startdatum secs
# dict.[self.START_TAG_TXT]                   Tag seit Start int
# dict.[START_ZEIT_TXT]                       Startdatum secs
# dict.[self.AUSZUGS_TYP_TXT]                 Name des types f�r den Kontoauszug name1_pdf, name2_csv, etc
#
#
# self.KONTO_DATEN_LESEN_TXT
# self.konto_bearb_auswahl = []        Auswahl der Bearbeitungen des Kontos
# self.ENDE_RETURN_TXT                   Zeichen f�r Ende
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
  KONTO_PREFIX      = "konto"
  IBAN_TXT          = "iban"
  START_WERT_TXT    = "start_wert"
  START_TAG_TXT     = "start_tag"
  START_ZEIT_TXT    = "start_zeit"
  START_DATUM_TXT   = "start_datum"
  AUSZUGS_TYP_TXT  = "auszug_type"
  
  KONTO_PROOF_LISTE = [ (IBAN_TXT, "iban")
                      , (START_WERT_TXT, "float")
                      , (START_DATUM_TXT, "dat")
                      , (AUSZUGS_TYP_TXT,"str")
                      ]
  
  
  KONTO_DATEN_LESEN_TXT   = "Auszug lesen"
  konto_bearb_auswahl = [KONTO_DATEN_LESEN_TXT
                        ]
  
  ENDE_RETURN_TXT     = "ende_return_sign"
  
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

    # check konotonames
    if( self.check_kontonames(data) != hdef.OK ):
      return
  # enddef
  
  def check_kontonames(self,data):
    """
    check kontonames sections from ini-file
    :return: status
    """
    liste = data.get("konto_names")
    if( not liste or (len(liste)==0)):
      self.status = hdef.NOT_OKAY
      self.add_err_text(f"In inifile {self.ini_file_name} is no list 'names' !!!!")
      return self.status
    # endif
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

    # Pr�fe die Daten aus proof_liste
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

    # Pr�fe was nicht definiert wurde
    #--------------------------------
    if( len(index_liste) ):
      self.status = hdef.NOT_OKAY
      for index in index_liste:
        self.add_err_text(f"In inifile {self.ini_file_name} is variable {kontoname}.{self.KONTO_PROOF_LISTE[index][0]} not set !!!!")
      #endofor
      return self.status
    #endif

    # Bilde/Pr�fe Zusatzwerte
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