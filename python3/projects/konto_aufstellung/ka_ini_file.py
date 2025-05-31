# -*- coding: cp1252 -*-
#
# read ini-file and proof sections for kontodata, ...
#
# data.structure
#
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
  
  def __init__(self, par,ini_file_name):
    
    self.errtext = ""
    self.logtext = ""
    
    # check ini-filename
    if (not os.path.isfile(ini_file_name)):
      self.status = hdef.NOT_OKAY
      self.add_err_text(f"ini_file_name = {ini_file_name} does not exist !!!!")
      return

    # read ini-file
    else:
      self.ini_file_name = ini_file_name
      with open(ini_file_name, "rb") as f:
        self.ddict = tomllib.load(f)
    #endif

    # check base input
    if self.check_base_input(par) != hdef.OK:
      return
    # endif

    # check konotonames
    if self.check_kontodata(par) != hdef.OK:
      return
    # endif
  
    # check depotnames
    if self.check_depotdata(par) != hdef.OK:
      return

    # check csv import
    if self.check_csv_import(par) != hdef.OK:
      return
    # endif

    # endif
  # enddef
  # def get_par(self,par):
  #   par.KONTO_NAMES = self.ddict[par.KONTO_DATA_DICT_NAMES_NAME]
  #   return par
  # # end def

  def check_base_input(self,par):
    
    data_key_liste = self.ddict.keys()
    # Prüfe die Daten aus proof_liste
    #--------------------------------
    proof_length = len(par.INI_BASE_PROOF_LISTE)
    index_liste  = [i for i in range(proof_length)]
    for index,(proof,ttype) in enumerate(par.INI_BASE_PROOF_LISTE):
      if proof in data_key_liste:
        [okay,wert] = htype.type_proof(self.ddict[proof],ttype)
        if okay != hdef.OK:
          self.status = hdef.NOT_OKAY
          self.add_err_text(f"In inifile {self.ini_file_name} is variable {self.ddict[proof]} not correct !!!!")
          return self.status
        else:
          self.ddict[proof] = wert
          index_liste.remove(index)
        #endif
      #endi
    #endfor

    # Prüfe was nicht definiert wurde
    #--------------------------------
    if len(index_liste):
      self.status = hdef.NOT_OKAY
      for index in index_liste:
        self.add_err_text(f"Im inifile {self.ini_file_name} ist Variable \"{par.INI_BASE_PROOF_LISTE[index][0]}\" nicht gesetzt !!!!")
      #endofor
      return self.status
    #endif
    
    return self.status
  # enddef


  def check_kontodata(self,par):
    """
    check kontonames sections from ini-file
    :return: status = self.check_kontodata(par)
    """
    
    for kontoname in self.ddict[par.INI_KONTO_DATA_DICT_NAMES_NAME]:
      
      if kontoname not in self.ddict:
        self.status = hdef.NOT_OKAY
        self.add_err_text(
          f"In inifile {self.ini_file_name} ist Konto-Sektion [{kontoname}] nicht vorhanden !!!!")
        return self.status
      
      if self.check_konto(par,kontoname) != hdef.OK:
        return hdef.NOT_OKAY
      #endif
    #endfor

    
    return self.status
  #enddef
  def check_konto(self,par,kontoname):
    """
    check specific kontoname from ini-file
    :return: status
    """
    key_liste = self.ddict[kontoname].keys()

    # Prüfe die Daten aus proof_liste
    #--------------------------------
    proof_length = len(par.INI_KONTO_PROOF_LISTE)
    index_liste  = [i for i in range(proof_length)]
    for index,(proof,ttype) in enumerate(par.INI_KONTO_PROOF_LISTE):
      if proof in key_liste:
        [okay,wert] = htype.type_proof(self.ddict[kontoname][proof],ttype)
        if okay != hdef.OK:
          self.status = hdef.NOT_OKAY
          self.add_err_text(f"In inifile {self.ini_file_name} is variable {kontoname}.{proof} = {self.ddict[kontoname][proof]} not correct !!!!")
          return self.status
        else:
          self.ddict[kontoname][proof] = wert
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
    (start_tag,start_zeit) = hdt.secs_time_epoch_to_epoch_day_time(self.ddict[kontoname][par.INI_START_DATUM_NAME])
    
    self.ddict[kontoname][par.INI_START_TAG_NAME]  = start_tag
    self.ddict[kontoname][par.INI_START_ZEIT_NAME] = start_zeit
    
    return self.status

  #enddef
  def check_depotdata(self, par):
    """
    check kontonames sections from ini-file
    :return: status
    """
    for depotname in self.ddict[par.INI_DEPOT_DATA_DICT_NAMES_NAME]:

      if depotname not in self.ddict:
        self.status = hdef.NOT_OKAY
        self.add_err_text(
          f"In inifile {self.ini_file_name} ist Depot-Sektion [{depotname}] nicht vorhanden !!!!")
        return self.status

      if self.check_depot(par, depotname) != hdef.OK:
        return hdef.NOT_OKAY
    # endfor
    
    return self.status
  # enddef
  def check_depot(self, par, depotname):
    """
    check specific kontoname from ini-file
    :return: status
    """
    key_liste = self.ddict[depotname].keys()
    
    # Prüfe die Daten aus proof_liste
    # --------------------------------
    proof_length = len(par.INI_DEPOT_PROOF_LISTE)
    index_liste = [i for i in range(proof_length)]
    for index, (proof, ttype) in enumerate(par.INI_DEPOT_PROOF_LISTE):
      if proof in key_liste:
        [okay, wert] = htype.type_proof(self.ddict[depotname][proof], ttype)
        if okay != hdef.OK:
          self.status = hdef.NOT_OKAY
          self.add_err_text(
            f"In inifile {self.ini_file_name} is variable {depotname}.{proof} = {self.ddict[depotname][proof]} not correct !!!!")
          return self.status
        else:
          self.ddict[depotname][proof] = wert
          index_liste.remove(index)
        # endif
      # endi
    # endfor
    
    # Prüfe was nicht definiert wurde
    # --------------------------------
    if len(index_liste):
      self.status = hdef.NOT_OKAY
      for index in index_liste:
        self.add_err_text(
          f"Im inifile {self.ini_file_name} ist Variable \"{depotname}.{par.INI_DEPOT_PROOF_LISTE[index][0]}\" nicht gesetzt !!!!")
      # endofor
      return self.status
    # endif
    
    # Bilde/Prüfe Zusatzwerte
    # ------------------------
    return self.status
  
  # enddef
  def check_csv_import(self, par):
    """
    check csv_import_type sections from ini-file
    :return: status = self.check_csv_import(par)
    """
    
    for csv_import_type in self.ddict[par.INI_CSV_IMPORT_TYPE_NAMES_NAME]:
      
      if csv_import_type not in self.ddict:
        self.status = hdef.NOT_OKAY
        self.add_err_text(
          f"In inifile {self.ini_file_name} ist csv-import-Sektion [{csv_import_type}] nicht vorhanden !!!!")
        return self.status
      
      if self.check_csv_import_type(par, csv_import_type) != hdef.OK:
        return hdef.NOT_OKAY
      # endif
    # endfor
    
    return self.status
  
  # enddef
  def check_csv_import_type(self, par, csv_import_type):
    """
    check specific kontoname from ini-file
    :return: status
    """
    key_liste = self.ddict[csv_import_type].keys()
    
    # Prüfe die Daten aus proof_liste
    # --------------------------------
    proof_length = len(par.INI_CSV_PROOF_LISTE)
    index_liste = [i for i in range(proof_length)]
    for index, (proof, ttype) in enumerate(par.INI_CSV_PROOF_LISTE):
      if proof in key_liste:
        [okay, wert] = htype.type_proof(self.ddict[csv_import_type][proof], ttype)
        if okay != hdef.OK:
          self.status = hdef.NOT_OKAY
          self.add_err_text(
            f"In inifile {self.ini_file_name} is variable {csv_import_type}.{proof} = {self.ddict[csv_import_type][proof]} not correct !!!!")
          return self.status
        else:
          self.ddict[csv_import_type][proof] = wert
          index_liste.remove(index)
        # endif
      # endi
    # endfor
    
    # Prüfe was nicht definiert wurde
    # --------------------------------
    if len(index_liste):
      self.status = hdef.NOT_OKAY
      for index in index_liste:
        self.add_err_text(
          f"Im inifile {self.ini_file_name} ist Variable \"{csv_import_type}.{par.INI_KONTO_PROOF_LISTE[index][0]}\" nicht gesetzt !!!!")
      # endofor
      return self.status
    # endif
    
    return self.status
  
  # enddef
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