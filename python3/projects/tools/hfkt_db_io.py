# -*- coding: cp1252 -*-
#
# hfkt_db_iohfkt_db_hande, aber ohne die Definitionstabelle
#
# Aufbau Tabelle
#=========================
#
#-----------------------------------------------------------------------------------------------------------------------
# externe Definition Tabelle
#
#   tabdef = {"name": tabname,
#             "cells": {"name":[name1,name2,...],
#                       "type":[type1,typ2,...]
#                      }
#            }
#--------------------------------------------------------------------------------------------------------------------------
# interne Definition Tabelle
#
# self.DbDefTab[i]                  i = 0, ... , self.nDbDefTab - 1
# self.DbDefTab[i].name             Name
#                 .type             wird hier nicht benutzt, ist immer DB_TAB_TYPE_BUILD
#                 .comment          wird hier nicht benutzt
#                 .isdb             ist in database enthalten
#                 .cells[j]         j = 0, ..., self.DbDefTab[i].ncells - 1
#                 .cells[j].name       Name Zelle
#                          .datatype   datatype  siehe oben
#                          .unit       Enheit, wird nicht benutzt
#                          .comment    wird hier nicht benutzt
#                          .tablelink  Wenn ein key einer anderen TAbelle eingetragen wird, steht hier der Tabellenname
#----------------------------------------------------------------------------------------------------------------------------
# types:
#
#     hdb.DB_DATA_TYPE_DATUM       Datum-Typ
#     hdb.DB_DATA_TYPE_PRIMKEY     prime key of data set
#     hdb.DB_DATA_TYPE_STR         String-Typ
#     hdb.DB_DATA_TYPE_FLOAT       Float-Typ
#     hdb.DB_DATA_TYPE_INT         Integer-Typ
#     hdb.DB_DATA_TYPE_KEY         Key-Typ       Key einer anderen Tabelle
#     hdb.DB_DATA_TYPE_CENT        Integer-Typ  as Cent
#     hdb.BD_DATA_TYPE_EURO        Float-Type in Euro
#
# allgemeine Funktionen =================================================================================
#
# dbio = hdbio.dbio(dbdatafile)              Klasse anlegen mit dabdatafile und öffnen
#
#                                            if not dbio.status == dbio.NOT_OKAY
#                                            also use dbio.has_err_text() and dbio.get_err_text()
#
# dbio.define_table(tabdef) -> bool:         Tabelle anlegen bzw. checken, ob vorhanden
#
# dbio.has_err_text() -> bool:               has object errortext
# get_err_text(self) -> str:                 get errror text and erase in object
#
# dbio.has_log_text() -> bool:               has object logtext
# get_log_text()      -> str:                 get log text and erase in object
#
# get_tabdef(tabname)  -> list with strut
# get_celldef(tabname) -> list               get cell definition of table
#
#---------------------------------------------------------------------------------------------------------
# neues Datenset für eine Tabelle kreieren ================================================================
#
# dlist = dbio.create_datalist(tabname) -> list  creat a empty list of table tabname
#
# dlist.add_data(cellname,data) -> status       add to dlist one cell
#
# status = dlist.add_to_table()                 addd dlist to table
#
# Daten holen ==============================================================================================
#
# ddict = dbio.get_data(tabname)
#
# cell_listed = 1: Sortiere in ddict = {namezelle1: [var1_zelle1, var2_zelle1, ...],
#                                       namezelle2: [var1_zelle2, var2_zelle2, ...], ...}
#
# key_listed = 1: Sortiert
# nach keys                   ddict = {'header': [name_zelle1, name_zelle2, ... name_zellem],
#                                      'key': [key_var1, key_var2, ... key_varn],
#                                      'nkey': n, 'nheader': m
#                                      'data': [[var1_zelle1, var1_zelle2, ..., var1_zellem], [var2_zelle1, var2_zelle2, ..., var2_zellem], ...,
#                                              [varn_zelle1, varn_zelle2, ..., varn_zellem]
#                                     }
#      Gesamten Inhalt der Tabelle ausgeben in einem dictionary
#     mit  ddict[Zellname] = [], ...
#
#     Inhalt der Tabelle abfragen, iype1 = 0, itype2=None:   gesamte Tabelle
#     (header_liste,data_liste) = dbh.get_tab_data(tabelename) <= nix
#        header_liste : m x 1  m rows/Zellen
#        data_liste   : n x m  n DatensÃ¤tze
#     (header_liste,data_liste) = dbh.get_tab_data(tabelename,cellname) <= string
#        header_liste : 1
#        data_liste   : n x 1
#    (header_liste,data_liste) = dbh.get_tab_data(tabelename,cellnames_liste) <= liste
#        header_liste : m x 1
#        data_liste   : n x m
#
#----------------------------------------------------------------------------------------------
# Daten löschen
#  staus = dbio.delete_data_by_primkey(tabname,primkey)
#
#    delete_data_by_primkey(self,tabname,primkey)
#    delete_data_by_primkey(self,tabname,primkey_liste):
#    Es werden aus der Tabelle mit tabname die Zellen mit primkey bzw liste von primkeys
#    gelÃ¶scht
#    return status
#-----------------------------------------------------------------------------------------------------------------------------------------
# Beispiel TAbelle erstellen:
#
#   dbio =  dbio("testdb.sql")
#
#   celldef = {"name": ["Datum"               , "Wert"               , "Menge"             , "Comment"           , "key@Material"]
#             ,"type": [hdb.DB_DATA_TYPE_DATUM, hdb.DB_DATA_TYPE_CENT, hdb.DB_DATA_TYPE_INT, hdb.DB_DATA_TYPE_STR, hdb.DB_DATA_TYPE_KEY]
#             }
#   tabdef = {"name": "Einkauf", "cells": celldef}
#
#   dbio.define_table(tabdef)
#
#   # Build a new data list item:
#   # first initiate for a specific table
#
#   dlist = dbio.create_datalist(tabname)
#   if( dbio.status != dbio.OKAY ) =>
#
#   # Erstelle einen neuen Tabelleneintrag
#   # dlist = dbio.create_datalist(tabname)
#
#   # Fülle alle Werte ein
#   dlist.add_data("Datum","12.01.2003")
#   dlist.add_data("Wert",20.31)
#   dlist.add_data("Menge",100)
#   dlist.add_data("Comment","erste Buchung")
#   dlist.add_to_table("key@Material",11)
#   if( dlist.status != dlist.OKAY ) =>
#
#   # Speichere die daten liste in Tabelle
#   dlist.add_to_table()
#   if( dlist.status != dlist.OKAY ) =>
#     delete dlist
#
#----------------------------------------------------------------------------------


import os, sys, types, sqlite3

#-------------------------------------------------------------------------------
#t_path, _ = os.path.split(__file__)
#p_list     = os.path.normpath(t_path).split(os.sep)
#if( t_path == os.getcwd() ):

import hfkt     as h
import hfkt_def as hdef
import hfkt_ini as hini
import hfkt_db  as hdb
import hfkt_type  as htype
import sgui
#else:
#  p_list     = os.path.normpath(t_path).split(os.sep)
#  if( len(p_list) > 1 ): p_list = p_list[ : -1]
#  tools_path = ""
#  for i,item in enumerate(p_list): tools_path += item + os.sep
#  if( os.path.normpath(tools_path) not in sys.path ): sys.path.append(tools_path)
  
#  from tools_path import hfkt     as h
#  from tools_path import hfkt_def as hdef
#  from tools_path import hfkt_ini as hini
#  from tools_path import hfkt_db  as hdb
#  from tools_path import hfkt_type as htype
#  from tools_path import sgui
#endif--------------------------------------------------------------------------


DB_TAB_TYPE_BUILD     = 0
DB_TAB_TYPE_SCHABLONE = 1
DB_TAB_TYPE_STRING_LISTE = ["DB_TAB_TYPE_BUILD","DB_TAB_TYPE_SCHABLONE"]
I0_GETKEY = 0
DELIM_TABLINK    = "@"
def getKey(s):
  return s[I0_GETKEY]

#-----------------------------------------------------------------------------------------------------
#
# class data_list
#
#------------------------------------------------------------------------------------------------------
class data_list:
  PRIMARY_KEY_NAME = hdef.PRIMARY_KEY_NAME
  OKAY     = hdef.OK
  NOT_OKAY = hdef.NOT_OK
  errtext  = ""
  logText  = ""
  status   = hdef.OK
  dataList = []
  defTab   = None
  db       = None
  #-----------------------------------------------------------------------------
  # public init
  #-----------------------------------------------------------------------------
  def __init__(self, deftab, db):
    '''
      Build a new data set with zeros and ""
      :param deftab: definition of the table
    '''
    self.defTab   = deftab
    self.db       = db
    self.dataList = self.set_empty_values()
  #enddef
  #-----------------------------------------------------------------------------
  # intern set_empty_values
  #-----------------------------------------------------------------------------
  def set_empty_values(self):
    '''
      set empty values for one data set of the table
      :return: data_list
    '''
    #     hdb.DB_DATA_TYPE_DATUM       Datum-Typ
    #     hdb.DB_DATA_TYPE_STR         String-Typ
    #     hdb.DB_DATA_TYPE_FLOAT       Float-Typ
    #     hdb.DB_DATA_TYPE_INT         Integer-Typ
    #     hdb.DB_DATA_TYPE_KEY         Key-Typ       Key einer anderen Tabelle
    #     hdb.DB_DATA_TYPE_CENT        Integer-Typ  as Cent
    #     hdb.BD_DATA_TYPE_EURO        Float-Type in Euro
    data_list = []
    for defcell in self.defTab.cells:
      if(  (defcell.datatype == hdb.DB_DATA_TYPE_DATUM)
        or (defcell.datatype == hdb.DB_DATA_TYPE_INT)
        or (defcell.datatype == hdb.DB_DATA_TYPE_KEY)
        or (defcell.datatype == hdb.DB_DATA_TYPE_CENT)
        ):
        data_list.append(0)
      elif( defcell.datatype == hdb.DB_DATA_TYPE_STR ):
        data_list.append("")
      elif(  (defcell.datatype == hdb.DB_DATA_TYPE_FLOAT)
          or (defcell.datatype == hdb.DB_DATA_TYPE_EURO)):
        data_list.append(0.0)
      # primekey not
      #endif
    #endfor
    return data_list
  #enddef
  # -----------------------------------------------------------------------------
  # public add_data
  # -----------------------------------------------------------------------------
  def add_data(self,cellname,data):
    '''
      set values in data_list for collecting all input for one data set
      :param cellname:   Name of cell to fill
      :param data:       data of cell to fill
      :return:           status
    '''
    icell = 0
    flag = True
    for defcell in self.defTab.cells:
      if( (defcell.datatype == hdb.DB_DATA_TYPE_KEY)):
        (cname, tablink) = seperate_tablink(cellname)
        if(   (len(defcell.tablelink) > 0)
          and (tablink ==  defcell.tablelink)):
          cellname = cname
        #endif
      #endif
      if( cellname == defcell.name ): # gefunden
        self.dataList[icell] = self.convert_value(defcell,data)
        flag = False
        break
      else:
        icell += 1
      #endif
    #endfor
    
    if( flag ):
      self.status  = self.NOT_OKAY
      self.errtext = "In dictionary d ist die Zelle <%s> nicht vorhanden (nach DbDefTab wird diese benoetigt)" % defcell.name
      return self.status
    #endif
    
    
  #enddef
  # -----------------------------------------------------------------------------
  # public add_to_table
  # -----------------------------------------------------------------------------
  def add_to_table(self):
    """
      Add dataset to the defined table
      :return: status
    """
    # db_liste mit unterliste Zellname und Datum erstellen
    db_liste = []
    for i, data in enumerate(self.dataList):
      vliste = [self.defTab.cells[i].name,data]
      db_liste.append(vliste)
    #endfor
    if (self.db.add_new_data_set(self.defTab.name, db_liste) != self.db.OKAY):
      self.errtext += self.db.errtext
      self.status = self.NOT_OKAY
      return self.status
    # endif
    return self.status
  #enddef
  # -----------------------------------------------------------------------------
  # intern convert_value
  # -----------------------------------------------------------------------------
  def convert_value(self,defcell,value):
    """
    Konvertiert Wert, wenn notwendig
    return converted value
    """
    if(  (defcell.datatype == hdb.DB_DATA_TYPE_PRIMKEY)
      or (defcell.datatype == hdb.DB_DATA_TYPE_INT)
      or (defcell.datatype == hdb.DB_DATA_TYPE_CENT)
      or (defcell.datatype == hdb.DB_DATA_TYPE_KEY)
      ):
      conv_value = int(value)
    elif ((defcell.datatype == hdb.DB_DATA_TYPE_DATUM)):
      if(isinstance(value,str)):
        conv_value = htype.secs_time_epoch_from_str_re(value)
      elif(isinstance(value,int) ):
        conv_value = value
      else:
        self.errtext = "In Tabelle: konnte aus der Zelle: <%s> nicht der type(%i) umgesetzt werden " % (
        defcell.name, defcell.type)
        self.status = self.NOT_OKAY
        conv_value = -1.0
      #endif
    elif(  (defcell.datatype == hdb.DB_DATA_TYPE_STR) ):
      if( not isinstance(value, str) ):
        conv_value = h.to_unicode(str(value))
      else:
        conv_value = h.to_unicode(value)
      #endif
    elif(  (defcell.datatype == hdb.DB_DATA_TYPE_FLOAT)
        or (defcell.datatype == hdb.DB_DATA_TYPE_EURO)):
      conv_value = float(value)
    else:
      self.errtext = "In Tabelle: konnte aus der Zelle: <%s> nicht der type(%i) umgesetzt werden " % (defcell.name,defcell.type)
      self.status  = self.NOT_OKAY
      conv_value    = -1.0
    #endif

    return conv_value
  #enddef
  # -----------------------------------------------------------------------------
  # public has_err_text
  # -----------------------------------------------------------------------------
  def has_err_text(self) -> bool:
    if (len(self.errtext) > 0):
      return True
    else:
      return False
    # endif
  # enddef

  # -----------------------------------------------------------------------------
  # intern add_err_text
  # -----------------------------------------------------------------------------
  def add_err_text(self, text: str) -> None:
    if (len(self.errtext) > 0):
      self.errtext += "\n" + text
    else:
      self.errtext += text
  # enddef
  # -----------------------------------------------------------------------------
  # public get_err_text
  # -----------------------------------------------------------------------------
  def get_err_text(self) -> str:
    err_text = self.errtext
    self.errtext = ""
    return err_text
  #enddef
#endclass
#-----------------------------------------------------------------------------------------------------
#
# class dbio
#
#------------------------------------------------------------------------------------------------------
class dbio:
  PRIMARY_KEY_NAME = u"key"

  OKAY     = hdef.OK
  NOT_OKAY = hdef.NOT_OK
  errtext  = ""
  logText  = ""
  status   = hdef.OK
  db       = None
  
  #######################################################################################################
  #
  # class DB-Def-Table:
  #
  #######################################################################################################
  class db_def_tab:
    def __init__(self,name):
      self.name    = name        # Name (bei type=DB_TAB_TYPE_SCHABLONE wird spezifischer Name mit '_' anghï¿½ngt)
      self.type    = DB_TAB_TYPE_BUILD        # siehe hfkt_db
      self.comment = ""          # Kommentar
      self.cells   = []          # List mit Zellen
      self.ncells  = 0           # Anzahl der Zellen
      self.isdb    = 0           # Tabelle ist angelegt!

  #######################################################################################################
  #
  # class DB-Def-Cell:
  #
  #######################################################################################################
  class db_def_cell:
    def __init__(self,name,datatype,tablelink):
      self.name      = name            # Name
      self.datatype  = datatype        # Datentype siehe hfkt_db
      self.unit      = ""              #
      self.comment   = ""              # Kommentar
      self.tablelink = tablelink       # Wenn ein key einer anderen TAbelle eingetragen wird, steht hier der Tabellenname

  #-----------------------------------------------------------------------------
  # public init
  #-----------------------------------------------------------------------------
  def __init__(self,dbfile):
    """
    Check Db - Define - LIste with Dbfile
    and build or modify table of Dbfile
    """

    # Number of Database Table
    self.DbDefTab  = []
    self.nDbDefTab = 0
    self.dbfile    = dbfile

    # datafile oeffnen
    self.db = hdb.db(self.dbfile)
    if( self.db.status  != self.db.OKAY ):
      self.status  = self.NOT_OKAY
      self.errtext = self.db.errtext
      return
    elif( self.db.has_log_text() ):
      self.add_log_text(self.db.get_log_text())
    #endif
    return
  #enddef
  #-----------------------------------------------------------------------------
  # public define_table
  #-----------------------------------------------------------------------------
  def define_table(self,tabdef:dict) -> bool:
    """
    Tabelle anlegen bzw. checken, ob vorhanden

    :param tabdef:  {"name":"Einkauf", "cells":celldef}
           celldef; { "name":["Wert","Datum","Menge","Comment","Key1@Anbieter"] \
                    , "type":[hdb.DB_DATA_TYPE_CENT, hdb.DB_DATA_TYPE_DATUM, hdb.DB_DATA_TYPE_INT,type':hdb.DB_DATA_TYPE_STR,hdb.DB_DATA_TYPE_KEY] \
                    }
    :return: True/Fale
    """

    keylist = tabdef.keys()

    #
    # proof keylist
    #
    if( "name" not in keylist):
      self.status = self.NOT_OKAY
      self.errtext = f"tabdef has not keyname \"name\" "
      return False
    elif(not isinstance(tabdef["name"], str)):
      self.status = self.NOT_OKAY
      self.errtext = f"tabdef[\"name\"] is not a string "
      return False
    #endif
    if( "cells" not in keylist):
      self.status = self.NOT_OKAY
      self.errtext = f"tabdef has not keyname \"cells\" "
      return False
    elif(not isinstance(tabdef["cells"], dict)):
      self.status = self.NOT_OKAY
      self.errtext = f"tabdef[\"cells\"] is not a dictionary "
      return False
    #endif

    cells   = tabdef.get("cells")
    keylist = cells.keys()

    if( "name" not in keylist):
      self.status = self.NOT_OKAY
      self.errtext = f"tabdef[\"cells\"] has not keyname \"name\" "
      return False
    elif(not isinstance(cells["name"], list)):
      self.status = self.NOT_OKAY
      self.errtext = f"cells[\"name\"] is not a list "
      return False
    #endif
    if( "type" not in keylist):
      self.status = self.NOT_OKAY
      self.errtext = f"tabdef[\"type\"] has not key \"cells\" "
      return False
    elif(not isinstance(cells["type"], list)):
      self.status = self.NOT_OKAY
      self.errtext = f"tabdef[\"cells\"] is not a list "
      return False
    #endif

    if( len(cells["name"]) != len(cells["type"])):
      self.status = self.NOT_OKAY
      self.errtext = f"tabdef[\"cells\"] has not same length as cells[\"name\"]"
      return False
    #endif

    # Tabelle definieren
    # .................
    deftab = self.db_def_tab(tabdef["name"])

    # Zellen definieren
    # .................
    for i in range(min(len(cells["name"]),len(cells["type"]))):

      if( cells["type"][i] == hdb.DB_DATA_TYPE_KEY):
        (name,tablink) = seperate_tablink(cells["name"][i])
      else:
        name = cells["name"][i]
        tablink = ""
      #endif

      zelle = self.db_def_cell(name, cells["type"][i],tablink)

      # Zelle in Tablle einfï¿½gen
      # ...........................
      deftab.cells.append(zelle)
      deftab.ncells += 1
    #endfor

    # Primary Key
    zelle = self.db_def_cell(self.PRIMARY_KEY_NAME, hdb.DB_DATA_TYPE_PRIMKEY,"")
    deftab.cells.append(zelle)
    deftab.ncells += 1

    if (self.check_and_build_table(deftab) != self.db.OKAY):
      self.errtext += self.db.errtext
      self.status = self.NOT_OKAY
      return self.status
    # endif

    # Tablle DbDefTab in self.DbDefTab einfï¿½gen
    #.........................
    self.DbDefTab.append(deftab)
    self.nDbDefTab += 1
    self.DbDefTab[self.nDbDefTab-1].isdb = 1

  #enddef
  
  # -----------------------------------------------------------------------------
  # public get_tabdef
  # -----------------------------------------------------------------------------
  def get_tabdef(self,tabname):
    """
    Sucht in self.DbDefTab die tabelle und gibt die Struktur zurï¿½ck
    wenn nicht vorhanden, dann None Rueckgabe
    """
    
    for tabdef in self.DbDefTab:
      if( tabdef.name == tabname ):
        return tabdef
      #endif
    #endfor
    self.status = self.NOT_OKAY
    tt = "Tabelle <%s> konnte in der Definition nicht gefunden werden !!!" % (tabname)
    self.errtext = tt
    return None
  #enddef

  # -----------------------------------------------------------------------------
  # public get_celldef
  # -----------------------------------------------------------------------------
  def get_celldef(self,tabname):
    """
    # get_celldef(tabname) -> list      get cell definition of table
    :param tabname:                     Name of table
    :return:                            list of cell names
    """
    
    cell_names = []
    flag = True
    for deftab in self.DbDefTab:
      if( tabname == deftab.name ):
        for cell in deftab.cells:
          cell_names.append(cell.name)
          flag = False
        #endfor
      #endif
    #endfor

    if( flag ):
      self.status = hdef.NOT_OK
      tt          = "Tabelle <%s> konnte in der Definition nicht gefunden werden !!!" % (tabname)
      self.errtext = tt
    #endif
    
    return cell_names
  # -----------------------------------------------------------------------------
  # public create_datalist
  # -----------------------------------------------------------------------------
  def create_datalist(self,tabname):
    '''
     create a empty data set of table with tabname
     
    :param tabname: table name
    :return: data_list
    '''
    tabdef = self.get_tabdef(tabname)
    if( self.status != self.OKAY):
      return None
    #endif
    
    dlist = data_list(tabdef,self.db)
    if( dlist.status != dlist.OKAY ):
      self.errtext.append(f" {dlist.errtext}")
      self.status = self.NOT_OKAY
      return None
    #endif
    return dlist
  #enddef
  
  # -----------------------------------------------------------------------------
  # public get_data
  # -----------------------------------------------------------------------------
  def get_data(self,tabname,cell_listed=0,key_listed=0):
    """
    get data from table tabname

    cell_listed=1 : Sortiere in ddict = {namezelle1: [var1_zelle1, var2_zelle1, ...],namezelle2: [var1_zelle2, var2_zelle2, ...], ...}

    key_listed=1 : Sortiert nach keys ddict = {'header':[name_zelle1,name_zelle2, ... name_zellem],
                                               'key':[key_var1, key_var2, ... key_varn],
                                               'nkey':n, 'nheader':m
                                               'data':[[var1_zelle1,var1_zelle2, ..., var1_zellem],[var2_zelle1,var2_zelle2, ... ,var2_zellem], ...,[varn_zelle1,varn_zelle2, ... ,varn_zellem]
                                              }

    
    :param     tabname (str):
    :return:   data (dict)
    """
    ddict        = {}
    
    if( not self.db.exist_table(tabname)):
      self.status = self.NOT_OKAY
      self.errtext = "In dictionary d ist die Zelle <%s> nicht vorhanden (nach DbDefTab wird diese benoetigt)" % defcell.name
      return ddict

    #Header-Liste
    header_liste = self.get_cell_names_from_deftab(tabname)

    # Daten holen
    data_liste = self.db.get_data_from_tab(tabname,header_liste)

    # Data-Liste
    if( self.db.status != self.db.OKAY):
      self.status = self.NOT_OKAY
      tt          = "Tabelle <%s> konnte in Datei <%s> nicht gelesen werden !!!" % (tabname,self.dbfile)
      self.errtext = tt
      return ddict
    #endif

    # -------------------------------------------------------------------------------------------------------------------
    # cell_listed: ddict = {namezelle1: [var1_zelle1, var2_zelle1, ...],namezelle2: [var1_zelle2, var2_zelle2, ...], ...}
    # -------------------------------------------------------------------------------------------------------------------
    if( cell_listed != 0 ):
      for i,col in enumerate(header_liste):
        ddict[col] = []
      for data in data_liste:
        for i,col in enumerate(header_liste):
          ddict[col].append(data[i])
    #---------------------------------------------------------------------------------------------------------------
    # key_listed: ddict = {'header': [name_zelle1, name_zelle2, ...],
    #                      key_num_first: [var1_zelle1, var1_zelle2, ...], key_num_second: [var2_zelle1, var2_zelle2, ...], ...
    #                     }
    # ---------------------------------------------------------------------------------------------------------------
    elif(key_listed != 0):
      n = len(header_liste)
      ddict['header']  = header_liste[0:n-1]
      ddict['mheader'] = n-1
      ddict['key']     = []
      ddict['data']    = []
      nkey             = 0
      for data in data_liste:
        ddict['key'].append(data[n-1])
        ddict['data'].append(data[0:n-1])
        nkey += 1
      #endfor
      ddict['nkey'] = nkey
    else:
      self.status = self.NOT_OKAY
      tt          = "Für Tabelle: %s in File: %s  Datenausgabefomat setzen: cell_listed=1 or key_listed=1 or ...  !!!" % (tabname,self.dbfile)
      self.errtext = tt
    #endif

    return ddict
  #enddef

  """
      # A) gesamte Tabelle
      if( not cellnames ):
        #Header-Liste
        header_liste = self.get_cell_names_from_deftab(tabname)
      # B) Auswahlliste
      elif( h.is_list(cellnames) ):
        for cellname in cellnames:
          if( self.is_cell_name_tabdef(tabname,cellname) ):
            header_liste.append(cellname)
          #endif
        #endfor
        if( len(header_liste) == 0 ):
          self.status = self.NOT_OKAY
          tt          = "Tabelle <%s> enthï¿½lt die genannten Zellennamen nicht:  " % tabname
          for cellname in cellnames:
            tt += "%s, " % cellname
  
          self.errtext = tt
          return (header_liste,data_liste)
      # C) Ein Name
      else:
        if( self.is_cell_name_tabdef(tabname,cellnames) ):
          header_liste.append(cellnames)
        if( len(header_liste) == 0 ):
          self.status = self.NOT_OKAY
          tt          = "Tabelle <%s>  enthï¿½lt die genannten Zellennamen nicht: " % tabname
          tt += " %s" % cellnames
          #endfor
          self.errtext = tt
          return (header_liste,data_liste)
        #endif
      #endif
  
      # Daten holen
      data_liste = self.db.get_data_from_tab(tabname,header_liste)
  
      # Data-Liste
      if( self.db.status != self.db.OKAY):
        self.status = self.NOT_OKAY
        tt          = "Tabelle <%s> konnte in Datei <%s> nicht gelesen werden !!!" % (tabname,self.dbfile)
        self.errtext = tt
        return (header_liste,data_liste)
      #endif
  
      return (header_liste,data_liste)
  """
  #enddef
  # -----------------------------------------------------------------------------
  # public delete_data
  # -----------------------------------------------------------------------------
  def delete_data(self, tabname, liste,by_primekey=0):
    """
    dbio.delete_data(tabname,primkey,by_primekey=1)
    dbio.delete_data(tabname,primkey_liste,by_primekey=1):

    Es werden aus der Tabelle mit tabname die Zellen mit primkey bzw liste von primkeys
    gelï¿½scht
    return status
    """

    if( by_primekey != 0 ):
      return self.delete_data_by_primekey(tabname, liste)
    else:
      self.status = self.NOT_OKAY
      tt          = "Für Tabelle: %s in File: %s Dateneingabefomat setzen: by_primekey=1 or ...  !!!" % (tabname,self.dbfile)
      self.errtext = tt
    #endif

    return self.status
  #enddef

  # -----------------------------------------------------------------------------
  # public close
  # -----------------------------------------------------------------------------
  def close(self):
    """
    close db
    
    :return:
    """
    if (self.db != None):

      self.db.close_dbfile()

      if (self.db.has_log_text()):
        self.add_log_text(self.db.get_log_text())
      # endif
      if (self.db.has_err_text()):
        self.add_err_text(self.db.get_err_text())
        self.status = self.NOT_OKAY
      # endif

      self.db = None

  # enddef

  # -----------------------------------------------------------------------------
  # public has_log_text
  # -----------------------------------------------------------------------------
  def has_log_text(self):
    """
    proof if log text is written
    :return:
    """
    if (len(self.logText) > 0):
      return True
    else:
      return False
    # endif

  # enddef

  # -----------------------------------------------------------------------------
  # intern add_log_text
  # -----------------------------------------------------------------------------
  def add_log_text(self, text):
    """
     add log-text
    :param text:
    :return:
    """
    if (len(self.logText) > 0):
      self.logText += "\n" + text
    else:
      self.logText += text

  # enddef
  # -----------------------------------------------------------------------------
  # public get_log_text
  # -----------------------------------------------------------------------------
  def get_log_text(self):
    """
    return logtext and reset internal
    :return:
    """
    log_text = self.logText
    self.logText = ""
    return log_text

  # endif

  # -----------------------------------------------------------------------------
  # public has_err_text
  # -----------------------------------------------------------------------------
  def has_err_text(self) -> bool:
    """
    proof is error text is set
    :return:
    """
    if (len(self.errtext) > 0):
      return True
    else:
      return False
    # endif

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
  # intern check_and_build_table
  # -----------------------------------------------------------------------------
  def check_and_build_table(self, deftab):
    """
    Checkt die Tabellendefinition, ob erstellt, wenn nein, dann erstellen
    return status
    """
    # Wenn deftabelle existiert
    if (self.db.exist_table(deftab.name)):

      # suche alle cells der tabelle mit [[cellname, index, type],[cellname, index, type], ... ]
      db_cell_liste = self.db.get_db_table_info(deftab.name)

      # Schauen ï¿½ber definierten alle Zellen
      for defcell in deftab.cells:
        flag = False

        # In db_cells suchen
        for db_cell in db_cell_liste:
          db_cell_name = db_cell[0]
          db_cell_type = db_cell[2]
          # gefunden
          if (defcell.name == db_cell_name):
            flag = True
            break
          # endif
        # endfor

        # wenn Zelle in db nicht existiert
        if (not flag):
          # bilden einer neuen Zelle
          self.db.build_new_cell_in_table(deftab.name, defcell.name, defcell.datatype)
          if (self.db.status != self.db.OKAY):
            self.errtext += self.db.errtext
            self.status = self.NOT_OKAY
            return self.status
          # endif
        # endif
      # endfor

      # Prï¿½fen ob eine Zelle aus definiton weggefallen ist
      # Schleife ï¿½ber alle Zellen der Table
      # suche alle cells der tabelle mit [[cellname, index, type],[cellname, index, type], ... ]
      #------------------------------------------------------------------------------------------
      db_cell_liste = self.db.get_db_table_info(deftab.name)

      # ï¿½ber alle db_cells
      for db_cell in db_cell_liste:
        db_cell_name = db_cell[0]
        db_cell_type = db_cell[2]
        flag = False
        # Suchen, ob definition vorhanden
        for defcell in deftab.cells:
          if (defcell.name == db_cell_name):
            flag = True
            break
          # endif
        # endfor
        # Zelle in Tabelle lï¿½schen wenn nicht vorhanden
        if (not flag):
          self.db.del_cell_in_table(deftab.name, db_cell_name)
      # endfor
    # table does not exist
    else:
      # build table
      self.build_db_table(deftab)
      if (self.status != self.OKAY):
        return self.status
    # endif

    return self.status
  #enddef
  # -----------------------------------------------------------------------------
  # intern build_db_table
  # -----------------------------------------------------------------------------
  def build_db_table(self, deftab):
    """
    Bildet Tabelle mit  cells aus deftab Definition
    """
    cell_liste = []
    for cell in deftab.cells:

      if (self.find_name_in_list(cell.name, cell_liste)):
        self.errtext += "In Tabelle <%s> ist cellname <%s> doppelt:\n" % (deftab.name, cell.name)
        self.status = self.NOT_OKAY
        return self.status
      # endif

      liste = [cell.name, cell.datatype]
      cell_liste.append(liste)
    # endfor
    if (self.db.build_db_table(deftab.name, cell_liste) != self.db.OKAY):
      self.errtext += "Tabelle <%s> konnte in Datei <%s> nicht erstellt  werden:\n(%s)" % (
      deftab.name, self.dbfile, self.db.errtext)
      self.status = self.NOT_OKAY
    # endif

    return self.status
  #enddef
  # -----------------------------------------------------------------------------
  # intern find_name_in_list
  # -----------------------------------------------------------------------------
  def find_name_in_list(self,cell_name,cell_liste):
    """
    Prueft ob Cellname bereits voranden
    """
    for item in cell_liste:
      if( item[0] == cell_name):
        return True
      #endif
    #endfor

    return False
  #endddef
# -----------------------------------------------------------------------------
# intern get_cell_names_from_deftab
# -----------------------------------------------------------------------------
  def get_cell_names_from_deftab(self,tabname):
    """
    Sucht alle Zellen namen der Tabelle
    (Wird hier gemacht wegen den Tabelleverweis)
    """
    cell_names = []
    flag = True

    for deftab in self.DbDefTab:
      if( tabname == deftab.name ):
        for cell in deftab.cells:
          cell_names.append(cell.name)
          flag = False
        #endfor
      #endif
    #endfor

    if( flag ):
      self.status = hdef.NOT_OK
      tt          = "Tabelle <%s> konnte in der Definition nicht gefunden werden !!!" % (tabname)
      self.errtext = tt
    #endif
    return cell_names
  #enddef
  # -----------------------------------------------------------------------------
  # intern delete_data_by_primekey
  # -----------------------------------------------------------------------------
  def delete_data_by_primekey(self, tabname, primkey_liste):
    """
    delete_data(self,tabname,primkey,by_primekey=1)
    delete_data(self,tabname,primkey_liste,by_primekey=1):

    Es werden aus der Tabelle mit tabname die Zellen mit primkey bzw liste von primkeys
    gelï¿½scht
    return status
    """

    # Liste erstellen wenn notwendig
    if (not h.is_list(primkey_liste)):
      primkey_liste = [primkey_liste]

    # Sucht Tabelle in Definition und db
    if (not self.db.exist_table(tabname)):
      self.errtext += self.db.get_err_text()
      self.status = self.NOT_OKAY
      return self.status
    # endif

    # get tabstruct von deftab
    deftab = self.get_tabdef(tabname)

    if( self.status == self.NOT_OKAY ):
      return self.status

    for primkey in primkey_liste:
      if (self.db.exist_data_in_tab(tabname, self.PRIMARY_KEY_NAME, primkey)):
        self.db.delete_data_set_by_key(tabname, self.PRIMARY_KEY_NAME, primkey)
      else:
        self.errtext += "Primary Key %i existiert in Tabelle %s nicht und kann nicht gelï¿½scht werden" % (
        primkey, tabname)
        self.status = self.NOT_OKAY
        return self.status
      # endif
    # enfor
    return self.status
  #endif

  # -------------------------------------------------------------------------------
  # -------------------------------------------------------------------------------
  # -------------------------------------------------------------------------------
  # -------------------------------------------------------------------------------

#endclass

#########################################################################################################
#########################################################################################################
# Hilfsfunktionen
#########################################################################################################
#########################################################################################################
# -----------------------------------------------------------------------------
# intern seperate_tablink
# -----------------------------------------------------------------------------
def seperate_tablink(name_in):
  name = h.elim_ae(name_in, ' ')
  # pruefen, ob Tabellen name zu z.B. key angehï¿½ngt ist
  if (h.such(name, DELIM_TABLINK, "vs") >= 0):
    lliste = name.split(DELIM_TABLINK)
    name = lliste[0]
    if (len(lliste) > 1):
      tablink = lliste[1]
    else:
      tablink = ""
    # endif
  else:
    tablink = ""
  # endif
  return(name,tablink)
#enddef

###########################################################################
# testen mit main
###########################################################################
if __name__ == '__main__':
  
  dbfile = "testdb.sql"
  dbio =  dbio(dbfile)

  # dbio.status == dbio.NOT_OKAY
  if(dbio.status == dbio.NOT_OKAY):
    print(f"error in dbio: {dbio.get_err_text()}")
  #endif
  if( dbio.has_log_text() ):
    print(f"Log text dbio: {dbio.get_log_text()}")
  #endif

  celldef = {"name": ["Wert"               , "Datum"               , "Menge"             , "Comment"           , "key1@Material"]
            ,"type": [hdb.DB_DATA_TYPE_EURO, hdb.DB_DATA_TYPE_DATUM, hdb.DB_DATA_TYPE_INT, hdb.DB_DATA_TYPE_STR, hdb.DB_DATA_TYPE_KEY]
            }
  tabdef = {"name": "Einkauf", "cells": celldef}

  dbio.define_table(tabdef)

  celldef = {"name": ["Name"               , "Woher"               ]
            ,"type": [hdb.DB_DATA_TYPE_STR, hdb.DB_DATA_TYPE_STR  ]
            }
  tabdef = {"name": "Material", "cells": celldef}

  dbio.define_table(tabdef)

  if(dbio.status == False):
    print(f"error in dbio mit Tabelle Einkauf: {dbio.get_err_text()}")
  #endif


  dlist = dbio.create_datalist("Material")
  dlist.add_data("Name","Tee")
  dlist.add_data("Woher","Kaufhof")
  dlist.add_to_table()

  dlist = dbio.create_datalist("Material")
  dlist.add_data("Name","Kaffee")
  dlist.add_data("Woher","Karstadt")
  dlist.add_to_table()

  dlist = dbio.create_datalist("Material")
  dlist.add_data("Name","Mukkefuk")
  dlist.add_data("Woher","DM")
  dlist.add_to_table()

  if (dlist.status != dlist.OKAY):
    print(f"Tabellen eingang Material hat Fehler: {dlist.get_err_text()}")
    exit(1)
  #endif

  del dlist

  dlist = dbio.create_datalist("Einkauf")
  dlist.add_data("Datum","12.01.2003")
  dlist.add_data("Wert",20.31)
  dlist.add_data("Menge",100)
  dlist.add_data("Comment","Ein neues Datum")
  dlist.add_data("key1@Material",1)
  dlist.add_to_table()

  if (dlist.status != dlist.OKAY):
    print(f"Tabelleneingang Einkauf hat Fehler:  {dlist.get_err_text()}")
    exit(1)
  #endif
  del dlist

  ddict = dbio.get_data("Einkauf",key_listed=1)

  if (dbio.status != dbio.OKAY):
    print(f"Tabellen abfrage Einkauf fehlgeschlagen:  {dbio.get_err_text()}")
    exit(1)
  #endif
  
  # header_liste,data_set,data_index_liste=None,listeAbfrage=None
  
  (data_set_out,_) = sgui.abfrage_tabelle(header_liste = ddict["header"], data_set=ddict["data"])
  
  print(data_set_out)
  
  #  if( dbio.delete_data("Material", 1 , by_primekey=1) != dbio.OKAY ):
  #    print(f"Tabellen daten löschen Material fehlgeschlagen:  {dbio.get_err_text()}")
  #    exit(1)
  #  # endif


  dbio.close()

  if (dbio.has_err_text()):
    print(f"error in dbio: {dbio.get_err_text()}")
  #endif
  if (dbio.has_log_text()):
    print(f"Log text dbio: {dbio.get_log_text()}")
  #endif


"""
  liste = ["Dieter", "Roland", "Dirk"]
  items = sgui.abfrage_listbox(liste, smode="S")
  for item in items:
    print("\nName: %s" % liste[item])
"""