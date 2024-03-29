# -*- coding: cp1252 -*-
#
# AdressBookBase:
#               Liest ini-File ein und setzt defaultwerte
#
# verionen:
# 0.0
#
# self.state            Programmzustand ABDef.OK/ABDef.NOT_OK
# aus ini-File eingelesen
# self.DB_FILE_NAME              datenbasis-Dateiname
# self.GUI_GEOMETRY_WIDTH        Width of GUI-window
# self.GUI_GEOMETRY_HEIGHT       Height of GUI-window
# self.D                dictionary mit
# ["group"]             liste Gruppennamen
# ["IDmax"]             int   ID - counter
# ["adresslist"]        list  Adressen dictionary
#
# liste = self.D["adresslist"]
# dict  = liste[i]
# ddict[A_ID]        = int             ABDef.INTERN_HEADER_LIST[0]
# ddict[A_GROUPNAME] = liste(strings)  ABDef.INTERN_HEADER_LIST[1]
# ddict[A_NACHNAME]  = string          ABDef.INTERN_HEADER_LIST[2]
# ddict[A_VORNAME]   = [string]
#                             Liste alle weiteren item ABDef.INTERN_HEADER_LIST[3:36] sind Listen
# ...
# ddict[A_NOTIZEN]   = [string]        ABDef.INTERN_HEADER_LIST[35]
#
#    def existGroupName(self,groupname):
#      ''' Prüft in dict Gruppenname, wenn vorhanden
#          return True, ansonsten False
#      '''
#    def addGroupName(self,groupname):
#       ''' Speichert in dict Gruppenname, wenn neu
#           return True, wenn okay, ansoanten False
#       '''
#    def getGroupNameList(self):
#      ''' Gibt Liste mit Gruppennamen
#      '''
#    def getGroupByID(self,id):
#      ''' Gibt Gruppennamen über id
#      '''
#    def changeGroupNameByID(self,id,groupname):
#      ''' Ändert Gruppennamen über id
#      '''

import os
import configparser
import sys
import gzip, time
import _pickle as cPickle
import random
import types
import time

tools_path = os.getcwd() + "\\.."
if( tools_path not in sys.path ):
    sys.path.append(tools_path)

from tools import hfkt as h

import AdressBookDef as ABDef
import MsOutlook

class AdressBookBase:
  state = ABDef.OKAY
  csv_file_name = ""
  DB_FILE_NAME = ""
  D = {}
###############################################################################
# base-Function
###############################################################################
###############################################################################
  def __init__(self, log, ini_file=None):

    self.log = log

    # Ini-File einlesen
    self.read_ini_file(ini_file)
    if(self.state != ABDef.OK): return

    # data-base einlesen oder anlegen
    self.read_db_file()
    if(self.state != ABDef.OK): return

    # dict prüfen
    if( not ("group" in self.D) ):
      self.D["group"] = []
    if( not ("IDmax" in self.D) ):
      self.D["IDmax"] = 0
    if( not ("adresslist" in self.D) ):
      self.D["adresslist"] = []
###############################################################################
###############################################################################
  def create_new_database(self):
    """
    neue Datenbasis anlegen
    """
    self.D["group"]      = []
    self.D["IDmax"]      = 0
    self.D["adresslist"] = []
###############################################################################
###############################################################################
  def read_ini_file(self, ini_file):

    # ini-file bestimmen
    if(not ini_file):
      self.ini_file = ABDef.INI_FILE_NAME_DEFAULT
    else:
      self.ini_file = ini_file

    config = configparser.RawConfigParser()
    try:
      # open configfile
      f = config.read(self.ini_file)
      if(len(f) == 0):
        self.log.write_e("Error configparser read file <%s>" % self.ini_file)
        self.state = ABDef.NOT_OK
        return
      #read db-filename
      if(config.has_section(ABDef.INI_FILE_SECTION)                         and \
        config.has_option(ABDef.INI_FILE_SECTION, ABDef.INI_FILE_DB_FILE)):
        self.DB_FILE_NAME = config.get(ABDef.INI_FILE_SECTION, ABDef.INI_FILE_DB_FILE)
      else:
        self.DB_FILE_NAME = ""
        self.log.write_e("Error configparser file <%s> has no section [%s] with otion %s"
                         % (self.ini_file, ABDef.INI_FILE_SECTION, ABDef.INI_FILE_DB_FILE))
        self.state = ABDef.NOT_OK
        return
      #Gui
      #gui geometry width
      if(config.has_section(ABDef.INI_FILE_GUI_SECTION)                         and \
        config.has_option(ABDef.INI_FILE_GUI_SECTION, ABDef.INI_FILE_GUI_GEOMETRY_WIDTH)):
        self.GUI_GEOMETRY_WIDTH = int(config.get(ABDef.INI_FILE_GUI_SECTION, ABDef.INI_FILE_GUI_GEOMETRY_WIDTH))
      else:
        self.GUI_GEOMETRY_WIDTH = int(800)
      #gui geometry heigth
      if(config.has_section(ABDef.INI_FILE_GUI_SECTION)                         and \
        config.has_option(ABDef.INI_FILE_GUI_SECTION, ABDef.INI_FILE_GUI_GEOMETRY_HEIGHT)):
        self.GUI_GEOMETRY_HEIGHT = int(config.get(ABDef.INI_FILE_GUI_SECTION, ABDef.INI_FILE_GUI_GEOMETRY_HEIGHT))
      else:
        self.GUI_GEOMETRY_HEIGHT = int(600)

    except:
      self.log.write_e("Error configparser read file <%s>" % self.ini_file)
      self.state = ABDef.NOT_OK
      return
###############################################################################
###############################################################################
  def read_db_file(self):

    if(os.path.isfile(self.DB_FILE_NAME)):
      try:
        f = gzip.open(self.DB_FILE_NAME, "rb")
        self.D = cPickle.load(f)
        f.close()
      except:
        self.log.write_e("Problem bei einlesen db datei <%s>" % self.DB_FILE_NAME)
        self.state = ABDef.NOT_OK
        return
    else:
      self.D = {}
###############################################################################
###############################################################################
  def save_db_file(self):
    try:
      f = gzip.open(self.DB_FILE_NAME, "wb")
      self.log.write_e("save versionfile: %s %s" % (time.ctime(), self.DB_FILE_NAME))
      cPickle.dump(self.D, f, 1)
      f.close()
    except:
      self.log.write_e("Problem bei schreiben db datei <%s>" % self.DB_FILE_NAME)
      self.state = ABDef.NOT_OK
      return
###############################################################################
# Group-Function
###############################################################################
###############################################################################
  def existGroupName(self,groupname):
    ''' Prüft in dict Gruppenname, wenn vorhanden
        return True, ansonsten False
    '''
    ## print self.D["group"]

    if( groupname in self.D["group"] ):
      return True
    else:
      return False
###############################################################################
###############################################################################
  def addGroupName(self,groupname):
    ''' Speichert in dict Gruppenname, wenn neu
        return True, wenn okay, ansoanten False
    '''
    ## print self.D["group"]
    flag = False
    if( h.is_list(groupname) ):
      for group in groupname:
        if( group not in self.D["group"] ):
          self.D["group"].append(group)
          flag = True
    else:
      if( groupname not in self.D["group"] ):
        self.D["group"].append(groupname)
        flag = True

    return flag
###############################################################################
###############################################################################
  def getGroupNameList(self):
    ''' Gibt Liste mit Gruppennamen
    '''
    return self.D["group"]
###############################################################################
###############################################################################
  def getGroupByID(self,id):
    ''' Gibt Gruppennamen über id
    '''
    if( len(self.D["group"]) > id):
      return self.D["group"][id]
    else:
      return ""
###############################################################################
###############################################################################
  def changeGroupNameByID(self,id,groupname):
    ''' Ändert Gruppennamen über id
    '''
    if( len(self.D["group"]) > id):
      self.changeGroupNameInAllAdress(self.D["group"][id],groupname)
      self.D["group"][id] = groupname
      return self.D["group"][id]
    else:
      return ""
###############################################################################
###############################################################################
  def changeGroupNameByName(self,old_groupname,groupname):
    ''' Ändert Gruppennamen über alten NAme
    '''
    n = len(self.D["group"])
    for i in range(n):
      if( self.D["group"][i] == old_groupname ):
        self.changeGroupNameInAllAdress(self.D["group"][i],groupname)
        self.D["group"][i] = groupname
        return self.D["group"][i]
    return ""
###############################################################################
###############################################################################
# Adress-Function
###############################################################################
  def getNumOfAdressByGroupname(self,groupname):
    ''' Gibt Anzahl der Adresse für eine Gruppe
    '''
    n = 0
    for adict in self.D["adresslist"]:
      if( groupname in adict[ABDef.A_GROUPNAME] ):
        n += 1
    return n
###############################################################################
###############################################################################
  def getListOfIndexFromAdressByGroupname(self,groupname):
    ''' Gibt liste mit index der Adressliste mit der genannten Gruppe
    '''
    liste = []
    index = 0
    for adict in self.D["adresslist"]:
      if( groupname in adict[ABDef.A_GROUPNAME] ):
        liste.append(index)
      index += 1
    return liste
###############################################################################
###############################################################################
  def getAdressByIndex(self,index):
    ''' Gibt Adresse über Index zurück
    '''
    if( len(self.D["adresslist"]) > index):
      return self.D["adresslist"][index]
    else:
      return {}
###############################################################################
###############################################################################
  def searchAdressByName(self,vorname,nachname):
    ''' suche Adresse mit vorname, nachname
        Wenn gefunden, wird index zurückgegeben
        ansonsten index = -1
    '''
    index = -1
    i = 0
    for adict in self.D["adresslist"]:

      ivor  = 0
      inach = 0

      if( ABDef.A_VORNAME in adict ):
        if( adict[ABDef.A_VORNAME] == vorname ):
          ivor = 1  # Vorname in Adressenliste gefunden
      else:
        if( len(vorname) == 0 ):
          ivor = 1  # Sowohl kein Vorname, als auch kein Vorname in Adressenliste

      if( ABDef.A_NACHNAME in adict ):
        if( adict[ABDef.A_NACHNAME] == nachname ):
          inach = 1  # Nachname in Adressenliste gefunden
      else:
        if( len(nachname) == 0 ):
          inach = 1  # Sowohl kein Nachname, als auch kein Nachname in Adressenliste

      if( ivor == 1 and inach == 1 ):
        index = i
        break

      i += 1

    return index
###############################################################################
###############################################################################
  def changeGroupNameInAllAdress(self,old_groupname,new_groupname):
    '''
    Durchsucht alle Adressen nach old_groupname und tauscht auf new_groupname
    '''
    for adict in self.D["adresslist"]:
      i = 0
      for group in adict[ABDef.A_GROUPNAME]:
        if( old_groupname == group ):
          adict[ABDef.A_GROUPNAME][i] = new_groupname
          break
        i += 1
###############################################################################
###############################################################################
  def buildEmptyAdressDict(self):
    '''
    Durchsucht alle Adressen nach old_groupname und tauscht auf new_groupname
    '''
    ddict = {}

    for key in ABDef.INTERN_HEADER_LIST:

      if( key == ABDef.A_ID ):
        ddict[key] = 0
      elif( key == ABDef.A_GROUPNAME ):
        ddict[key] = []
      else:
        ddict[key] = ""

    return ddict
###############################################################################
###############################################################################
# read/import-Function
###############################################################################
###############################################################################
  def loadOutlookData(self):
    ''' Outlook Adressen über COM-Schnittstelle laden
    '''

    # Outlookdaten lesen
    #-------------------
    (self.state,reason,data) = self.readOutlookData()

    if( self.state != ABDef.OKAY ):
      self.log.write_e(text="Probleme mit loadOutlook: %s" % reason,display=1)
      return self.state

    #Outlookdaten einsortieren
    #-------------------------
    for d in data:

      # Nachname prüfen
      if( ABDef.A_NACHNAME in d ):
        lastname  = d[ABDef.A_NACHNAME]
      else:
        lastname  = ""

      lastname = lastname.strip()
      if( len(lastname) == 0 ):
        self.log.write_dict(text='loadOutlookData: Kein Nachnahme vorhanden',ddict=d,display=1)
        return ABDef.NOT_OK
      else:
        # Gruppe suchen (mehere Gruppe möglich)
        if( ABDef.A_MS_OUTL_KATEGORIE in d ):
          groupname = d[ABDef.A_MS_OUTL_KATEGORIE]
          # In Liste wandeln, wenn keine Liste
          if( h.is_list(groupname) ):
            liste = groupname
            groupname = []
            for item in liste:
              name = item.strip()
              if( len(name) > 0 ):
                groupname.append(name)
          else:
            if( ";" in groupname ):
              liste = groupname.split(";")
              groupname = []
              for item in liste:
                name = item.strip()
                if( len(name) > 0 ):
                  groupname.append(name)
            else:
              groupname = [groupname.strip()]
        else:
          groupname = []

        # Wenn nichts vorhanden nogroup zuweisen
        if( len(groupname) == 0 ):
          group_name = ["nogroup"]
        # Gruppenname einsortieren
        for group in groupname:
          if( not self.existGroupName(group) ):
            self.addGroupName(group)

        # Vorname
        if( ABDef.A_VORNAME in d ):
          firstname = d[ABDef.A_VORNAME]
        else:
          firstname = ""

        # Kontakt in dict  suchen
        index = self.searchAdressByName(firstname,lastname)

        # neue Adresse
        if( index == -1 ):

          # neues dict anlegen
          self.addNewOutlookAddressDict(groupname,d)
        else:
          self.log.write_e(text='loadOutlookData: oulook-Adresse muss mit interner Adresse gemerged werden',display=1)
          self.log.write_e(text="lastname: <%s>" % lastname,display=1)
          self.log.write_e(text="firstname: <%s>" % firstname,display=1)
          self.log.write_e(text="groupname: <%s>" % groupname,display=1)
          self.log.write_dict('Outlook Adresse ',d)
          self.log.write_dict('Interne Adresse ',self.getAdressByIndex(index))

    return self.state
###############################################################################
  def readOutlookData(self):
    ''' Liest über die COM-Schnittstelle Outlookadressen
        und wandelt key-Wörter schon in intern key-Wörter um
    '''
    data   = []
    reason = ""
    # mit Outlook verbinden
    #======================
    o = MsOutlook.MsOutlook()

    # delayed check for Outlook on win32 box
    if not o.outlookFound:
      reason = "Outlook not found!"
      self.state = ABDef.NOT_OK
      return (self.state,reason,data)

    fields_dict = ABDef.MS_OUTL_DICT.keys()

    o.loadContacts(fields_dict)

    for record in o.records:
      dict = {}
      fields = record.keys()

      for field in fields:
        if( field in fields_ddict):
          try:
            if( type(record[field]) is types.ListType ):
              ddict[ABDef.MS_OUTL_DICT[field]] = record[field]
            elif(  (type(record[field]) is types.StringType)  \
                or (type(record[field]) is types.UnicodeType) ):
             ddict[ABDef.MS_OUTL_DICT[field]] = record[field]
            else:
             ddict[ABDef.MS_OUTL_DICT[field]] = str(record[field])
          except:
            print("field:",field)
            print("record[field]",record[field])
            print(type(record[field]))

      data.append(ddict)

    return (self.state,reason,data)
###############################################################################
  def addNewOutlookAddressDict(self,groupliste,outlook_dict):
    ''' Erstellt für diese  Outlook-Adresse neues dict
    '''
    okay = ABDef.OKAY
    # neues dictionary anlegen
    ddict = buildEmptyAdressDict()

    # Gruppe
    if( h.is_string(groupliste) or h.is_unicode(groupliste) ):
      groupliste = [groupliste]
    ddict[ABDef.A_GROUPNAME] = groupliste
    # auch gleichzeitig prüfen, ob in Gruppenliste vorhanden
    for group in groupliste:
      if( group not in self.D["group"] ):
        self.D["group"].append(group)

    # ID hochzählen und zuordnen
    self.D["IDmax"] += 1
    ddict[ABDef.A_ID] = self.D["IDmax"]

    # alle items von csv_header durchgehen
    i = 0
    for key in outlook_dict:
      # Besteht ein Zuordnungskey
      if( key in ABDef.INTERN_HEADER_LIST ):
        value      = outlook_dict[key]
        # Prüfen, ob Wert vorhanden
        if( (len(value) > 0) ):
          # Prüfen, ob schon Wert eingetragen, dann anhängen
          if( key in ddict ):
            ddict[key] = ddict[key]+ABDef.A_TRENNZEICHEN+value
          # ansonsten Wert Zuordnen
          else:
            ddict[key] = value
      # Index hochzählen
      i += 1


    self.D["adresslist"].append(ddict)

    return okay
###############################################################################
###############################################################################
  def read_mab_file(self, file_name):

      if(os.path.isfile(file_name)):

          liste = h.read_mab_file(file_name)

      # in Datenstruktur einsortieren
      return (ABDef.OK, csv_header, csv_data)
###############################################################################
###############################################################################
  def read_and_evaluate_csv_file(self, file_name):
    (state, csv_header, csv_data) = self.read_csv_file(file_name)
    if(state != ABDef.OK): return ABDef.NOT_OK
    # csv-Info mit datenbasis abgleichen
    if(len(csv_header) > 0 and len(csv_header) > 0):
      state = self.evaluate_csv_data(csv_header, csv_data)
      if(state != ABDef.OK): return  ABDef.NOT_OK
    return  ABDef.OK
###############################################################################
###############################################################################
  def read_csv_file(self, file_name,trennzeichen=";"):

    csv_header = []
    csv_data = []
    if(os.path.isfile(file_name)):

      csv_liste = h.read_csv_file(file_name, trennzeichen)

      if(len(csv_liste) < 2):
        self.log.write_e("csv Datei zu klein (1. Zeile Header, weitere Zeilen Vokabeln)" % self.ini_file)
        self.state = ABDef.NOT_OK
        return (ABDef.NOT_OK, csv_header, csv_data)
      # header separieren
      csv_header = csv_liste[0]
      n = len(csv_header)
      # Alle Spalten so groß wie header line
      csv_data = []
      for i in range(1, len(csv_liste), 1):
        row = csv_liste[i]
        m = len(row)
        if(m > n):
          del row[n:m]
        elif(m < n):
          for j in range(m, n, 1):
            row.append("")
        csv_data.append(row)
    else:
      self.log.write_e("DAtei nicht vorhanden <%s>" % file_name)
      self.state = ABDef.NOT_OK
      return (ABDef.NOT_OK, csv_header, csv_data)

    return (ABDef.OK, csv_header, csv_data)
###############################################################################
###############################################################################
# adress-Function for imort
###############################################################################
###############################################################################
  def add_address_from_thunderbird_csv_data(self,groupname,csv_header,csv_adress_list):
    ''' adds new adress from thunderbird csv import
        Prüft erst ob neue Adresse und gültig
        option = 0 alles okay neue Adresse hinzugefügt
        option = 1 Kein Vor- und NAchnahme gefunden
    '''
    option = 0 # alles okay
    dummy_dict = {}

    # Suche Vorname, Nachname
    vorname  = ""
    nachname = ""
    i = 0
    for item in csv_header:
      if( item == ABDef.A_CSV_THUN_VORNAME ):
        vorname = csv_adress_list[i]
      if( item == ABDef.A_CSV_THUN_NACHNAME ):
        nachname = csv_adress_list[i]
      i += 1

    if( vorname == "" and nachname == "" ):
      option = 1 # Kein Vor und Nachnahme
      return (option, dummy_dict, dummy_dict)


    # Adresse in Liste suchen
    index = self.search_for_adress(groupname,vorname,nachname)
    # dict erstellen aus Thunderbirddaten
    new_dict = self.new_address_dict_from_thunderbird_csv_data(groupname,csv_header,csv_adress_list)
    if( index == -1 ):   # Adresse ist neu, also einsortieren
      # ID hochzählen und zuordnen
      self.D["IDmax"] += 1
      new_dict[A_ID] = self.D["IDmax"]
      self.D["adresslist"].append(new_dict)
    else:                 # Adresse schon vorhanden
      adress_dict = self.D["adresslist"][index]

      option = 2  # zwei gleiche Adressen
      return (option, new_dict, adress_dict)

    return (option, dummy_dict, dummy_dict)
###############################################################################
###############################################################################
  def add_address_from_outlook_csv_data(self,groupname,csv_header,csv_adress_list):
    ''' adds new adress from outlook csv import
        Prüft erst ob neue Adresse und gültig
        option = 0 alles okay neue Adresse hinzugefügt
        option = 1 Kein Vor- und NAchnahme gefunden
    '''
    option = 0 # alles okay
    dummy_dict = {}

    # Suche Vorname, Nachname
    vorname   = ""
    nachname  = ""
    kategorie = ""

    i = 0
    for item in csv_header:
      if( item == ABDef.A_CSV_OUTL_VORNAME ):
        vorname = csv_adress_list[i]
      if( item == ABDef.A_CSV_OUTL_NACHNAME ):
        nachname = csv_adress_list[i]
      if( item == ABDef.A_CSV_OUTL_KATEGORIE ):
        kategorie = csv_adress_list[i]
      i += 1

    if( vorname == "" and nachname == "" ):
      option = 1 # Kein Vor und Nachnahme
      return (option, dummy_dict, dummy_dict)


    # Adresse in Liste suchen
    liste = kategorie.split(";")
    for item in liste:
      item = h.elim_ae(item," ")
      index = self.search_for_adress(item,vorname,nachname)
      # dict erstellen aus Outlookdaten
      new_dict = self.new_address_dict_from_outlook_csv_data(item,csv_header,csv_adress_list)
      if( index == -1 ):   # Adresse ist neu, also einsortieren
        # ID hochzählen und zuordnen
        self.D["IDmax"] += 1
        new_dict[A_ID] = self.D["IDmax"]
        self.D["adresslist"].append(new_dict)
      else:                 # Adresse schon vorhanden
        adress_dict = self.D["adresslist"][index]

        option = 2  # zwei gleiche Adressen
        return (option, new_dict, adress_dict)

    return (option, dummy_dict, dummy_dict)
###############################################################################
###############################################################################
  def new_address_dict_from_thunderbird_csv_data(self,groupliste,csv_header,csv_adress_list):
    ''' Fügt Adresse zur Datenbasis hinzu
    '''
    # neues dictionary anlegen
    ddict = {}

    # Gruppe
    if( h.is_string(groupliste) or h.is_unicode(groupliste) ):
      groupliste = [groupliste]
    ddict[ABDef.A_GROUPNAME] = groupliste
    # auch gleichzeitig prüfen, ob in Gruppenliste vorhanden
    for group in groupliste:
      if( group not in self.D["group"] ):
        self.D["group"].append(group)

    # alle items von csv_header durchgehen
    i = 0
    for item in csv_header:
      # Besteht ein Zuordnungskey
      if( ABDef.CSV_THUNDERBIRD_DICT.has_key(item) ):
        intern_key = ABDef.CSV_THUNDERBIRD_DICT[item]
        value      = csv_adress_list[i]
        # Prüfen, ob Wert vorhanden
        if( (len(value) > 0) ):
          # Prüfen, ob schon Wert eingetragen, dann anhängen
          if( ddict.has_key(intern_key) ):
            ddict[intern_key] = ddict[intern_key]+ABDef.A_TRENNZEICHEN+value
          # ansonsten Wert Zuordnen
          else:
            ddict[intern_key] = value
      # Index hochzählen
      i += 1
    return ddict
###############################################################################
###############################################################################
  def new_address_dict_from_thunderbird_csv_data(self,groupliste,csv_header,csv_adress_list):
    ''' Fügt Adresse zur Datenbasis hinzu
    '''
    # neues dictionary anlegen
    ddict = {}


    # Gruppe
    if( h.is_string(groupliste) or h.is_unicode(groupliste) ):
      groupliste = [groupliste]
    ddict[A_GROUPNAME] = groupliste
    # auch gleichzeitig prüfen, ob in Gruppenliste vorhanden
    for group in groupliste:
      if( group not in self.D["group"] ):
        self.D["group"].append(group)

    # alle items von csv_header durchgehen
    i = 0
    for item in csv_header:
      # Besteht ein Zuordnungskey
      if( CSV_OUTLOOK_DICT.has_key(item) ):
        intern_key = CSV_OUTLOOK_DICT[item]
        value      = csv_adress_list[i]
        # Prüfen, ob Wert vorhanden
        if( (len(value) > 0) ):

          # Geburtsdatum
          if( item == A_CSV_OUTL_GEBURTSDATUM ):
            ll = item.split(".")
            if( len(ll) == 3 and ll[0] != "0" ):
              ddict[A_GEBURTSTAG] = ll[0]
              ddict[A_GEBURTSMONAT] = ll[1]
              ddict[A_GEBURTSJAHR] = ll[2]
          else:
            # Prüfen, ob schon Wert eingetragen, dann anhängen
            if( ddict.has_key(intern_key) ):
              ddict[intern_key] = ddict[intern_key]+A_TRENNZEICHEN+value
            # ansonsten Wert Zuordnen
            else:
              ddict[intern_key] = value
      # Index hochzählen
      i += 1
    return ddict

###############################################################################
###############################################################################
# write Function
###############################################################################
  def write_db_to_csv_file(self,file_name=""):
    """
    Schreibt Datenbasis-Daten in ein csv-datei, Namen sind sind in AdressBookDef festgelegt
    """
    #Datenbasis
    if(len(self.D["base_liste"]) > 0):

      if( file_name == "" ):
        file_name = ABDef.OUTPUT_FILE_NAME_BASE_LISTE + ".csv"
      else:
        (path,body,ext) = h.file_split(file_name)
        if( len(ext) == 0 ):
          file_name = os.path.join(path,body+".csv")

      keys = self.keys_from_base_key_liste()
      with open(file_name, 'w') as f:
        #header
        text = "Nr" + ";"
        for item in keys:
          text += item
          text += ";"
        f.write(text + "\n")
        i = 1
        for item in self.D["base_liste"]:
          text = str(i) + ";"
          for name in keys:
            text += str(item[name])
            text += ";"
          f.write(text + "\n")
          i += 1
      f.closed
      self.log.write_e("save csvfile: %s %s" % (time.ctime(), ABDef.OUTPUT_FILE_NAME_BASE_LISTE + ".csv"))
