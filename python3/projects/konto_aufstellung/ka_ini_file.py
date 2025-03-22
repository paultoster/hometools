# -*- coding: cp1252 -*-
#
# read ini-file and proof sections for kontodata, ...
#
# data.structure
#
# self.IBAN_NAME                        Iban
# self.WER_NAME                         Inhaber
# self.START_WERT_NAME                  Startwert
# self.START_TAG_NAME                   Starttag
# self.START_TAG_NAME                  Startzeit
# self.START_DATUM_NAME                 Startdatum
# self.AUSZUGS_TYP_NAME                 Type von Kontoauszug
#
# self.konto_names = []                Namen der Konten
# self.iban_list_file_name             Name des Iban-Fielnames
# self.data_pickle_use_json            # 0: keine json-Datei
#                                      # 1: schreibe auch json-datei
#                                      # 2: lessen von json Datei
# self.data_pickle_jsonfile_list       list of pickle names as self.data_pickle_use_json, self.konto_names[i]
# dict=self.konto_data[kontoname]      dict von Konto
#
# dict.[self.IBAN_NAME]                        IBAN-Nummer als string
# dict.[self.WER_NAME]                         Wem gehört
# dict.[self.START_WERT_NAME]                  Startwert Euro
# dict.[self.START_DATUM_NAME]                 Startdatum secs
# dict.[self.START_TAG_NAME]                   Tag seit Start int
# dict.[START_TAG_NAME]                       Startdatum secs
# dict.[self.AUSZUGS_TYP_NAME]                 Name des types für den Kontoauszug name1_pdf, name2_csv, etc
#
#
# self.KONTO_DATEN_LESEN_TXT
# self.konto_bearb_auswahl = []        Auswahl der Bearbeitungen des Kontos
# self.ENDE_RETURN_TXT                   Zeichen für Ende
#


import os, sys
import tomllib

tools_path = os.getcwd() + "\\.."
if tools_path not in sys.path:
    sys.path.append(tools_path)
#endif

# Hilfsfunktionen
import hfkt_def as hdef
import hfkt_type as htype
import hfkt_date_time as hdt


status  = hdef.OKAY
errtext = ""
logtext = ""

class ini:
  status = hdef.OKAY
  errtext = ""
  logtext = ""
  
  konto_names = []
  konto_data  = {}
  
  def __init__(self, par,ini_file_name):

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
    if self.check_base_input(par,data) != hdef.OK:
      return
    # endif

    # check konotonames
    if self.check_kontodata(par,data) != hdef.OK:
      return
    # endif
  # enddef
  def get_par(self,par):
    par.KONTO_NAMES = self.konto_names
    return par
  # end def

  def check_base_input(self,par,data):
    
    key_liste = data.keys()
    
    # Prüfe die Daten aus proof_liste
    #--------------------------------
    proof_length = len(par.BASE_PROOF_LISTE)
    index_liste  = [i for i in range(proof_length)]
    for index,(proof,ttype) in enumerate(par.BASE_PROOF_LISTE):
      if proof in key_liste:
        [okay,wert] = htype.type_proof(data[proof],ttype)
        if okay != hdef.OK:
          self.status = hdef.NOT_OKAY
          self.add_err_text(f"In inifile {self.ini_file_name} is variable {data[proof]} not correct !!!!")
          return self.status
        else:
          data[proof] = wert
          index_liste.remove(index)
        #endif
      #endi
    #endfor

    # Prüfe was nicht definiert wurde
    #--------------------------------
    if len(index_liste):
      self.status = hdef.NOT_OKAY
      for index in index_liste:
        self.add_err_text(f"Im inifile {self.ini_file_name} ist Variable \"{par.BASE_PROOF_LISTE[index][0]}\" nicht gesetzt !!!!")
      #endofor
      return self.status
    #endif
    
    self.konto_names = data.get(par.KONTO_DATA_DICT_NAMES_NAME)
    self.iban_list_file_name = data.get(par.IBAN_LIST_FILE_NAME)
    self.data_pickle_use_json = data.get(par.DATA_PICKLE_USE_JSON)
    self.data_pickle_jsonfile_list = data.get(par.DATA_PICKLE_JSONFILE_LIST)


    # # self.konto_names = data.get(par.KONTO_DATA_DICT_NAMES_NAME)
    # # if not self.konto_names or (len(self.konto_names) == 0):
    # #   self.status = hdef.NOT_OKAY
    # #   self.add_err_text(f"In inifile {self.ini_file_name} ist keine Liste mit Kontonamen "
    # #                     f"{par.KONTO_DATA_DICT_NAMES_NAME} = [kont1,konto2, ...] !!!!")
    # #   return self.status
    # # # endif
    #
    #
    # [okay, self.iban_list_file_name] = htype.type_proof(data.get(par.IBAN_LIST_FILE_NAME), "str")
    # if okay != hdef.OKAY:
    #   self.status = hdef.NOT_OKAY
    #   self.add_err_text(f"In inifile {self.ini_file_name} ist keine Name für das iban_file angegeben"
    #                     f" {par.IBAN_LIST_FILE_NAME} = \"name\" !!!!")
    #   return self.status
    # # endif

    
    return self.status
  # enddef


  def check_kontodata(self,par,data):
    """
    check kontonames sections from ini-file
    :return: status
    """
    liste = self.konto_names
    self.konto_names = []
    for kontoname in liste:

      kontodict = data.get(kontoname)

      if self.check_konto(par,kontoname, kontodict) != hdef.OK:
        return hdef.NOT_OKAY
      else:
        self.konto_names.append(kontoname)
        self.konto_data[kontoname] = kontodict
      #endif
    #endfor

    #endif
    
    return self.status
  #enddef
  def check_konto(self,par,kontoname,kontodict):
    """
    check specific kontoname from ini-file
    :return: status
    """
    key_liste = kontodict.keys()

    # Prüfe die Daten aus proof_liste
    #--------------------------------
    proof_length = len(par.INI_KONTO_PROOF_LISTE)
    index_liste  = [i for i in range(proof_length)]
    for index,(proof,ttype) in enumerate(par.INI_KONTO_PROOF_LISTE):
      if proof in key_liste:
        [okay,wert] = htype.type_proof(kontodict[proof],ttype)
        if okay != hdef.OK:
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
    if len(index_liste):
      self.status = hdef.NOT_OKAY
      for index in index_liste:
        self.add_err_text(f"Im inifile {self.ini_file_name} ist Variable \"{kontoname}.{par.INI_KONTO_PROOF_LISTE[index][0]}\" nicht gesetzt !!!!")
      #endofor
      return self.status
    #endif

    # Bilde/Prüfe Zusatzwerte
    #------------------------

    # aus start_dutum => start_tag und start_zeit
    (start_tag,start_zeit) = hdt.secs_time_epoch_to_epoch_day_time(kontodict[par.START_DATUM_NAME])
    
    kontodict[par.START_TAG_NAME]  = start_tag
    kontodict[par.START_TAG_NAME] = start_zeit
    
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
    if len(self.errtext) > 0:
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