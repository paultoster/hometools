# -*- coding: cp1252 -*-
#
# VokTrainBase: Vokabel Trainer
#               Liest ini-File ein und setzt defaultwerte
#
# def readini( ini_file, ddlist ) Liest ein ini-File aus
#
#     ini_file                   Name des ini-Files
#     dlist                     doppelte liste mit zu erwartenden Variablen
#     dlist  = [['section1','varname1',typ1,'default1'] \
#              ,['section2','varname2',typ2,'default2'] \
#              ]
#              varname           Variablenname
#              section           Sektion in [] geschrieben
#              typ               hdef.DEF_FLOAT    float-Wert
#                                hdef.DEF_INT      interger-Wert
#                                hdef.DEF_STR      string-Wert
#                                hdef.DEF_VEC      Vektor als Liste 1,2,3.2,-0.1
#                                                   oder   [1,2,3.2,-0.1]
#              default           '' kein default m�glich
#                                '1.0' immer als Text
import os
import configparser
import sys

#-------------------------------------------------------------------------------
t_path, _ = os.path.split(__file__)
if( t_path == os.getcwd() ):

  import hfkt     as h
  import hfkt_def as hdef
else:
  p_list     = os.path.normpath(t_path).split(os.sep)
  if( len(p_list) > 1 ): p_list = p_list[ : -1]
  t_path = ""
  for i,item in enumerate(p_list): t_path += item + os.sep
  if( os.path.normpath(t_path) not in sys.path ): sys.path.append(t_path)

  from hfkt import hfkt     as h
  from hfkt import hfkt_def as hdef
#endif--------------------------------------------------------------------------


def readini( ini_file, dliste=None ):
  out      = None
  outtext  = ""
  # Pr�fen, ob ini-Datei vorhanden
  if( not os.path.isfile(ini_file ) ):
    actpath = os.path.abspath(".")
    outtext = "ini-file <%s> konnte nicht gefunden werden (actpath: <%s> " % (ini_file,actpath)
    return (hdef.NOT_OK,outtext,out)

  config = configparser.RawConfigParser()
  #try:
    # open configfile
  f = config.read(ini_file)
  #except:
  #  outtext = "Error configparser read file <%s>" % ini_file
  #  return (hdef.NOT_OK,outtext,out)
  if(len(f) == 0):
    hfkt_log.write_e("Error configparser read file <%s>" % ini_file)
    return out

  # wenn nicht definiert, wir alles eingelesen und ausgegeben
  if( dliste == None or len(dliste) == 0 ):
    if( out == None ):
      out = {}

    liste = config.sections()
    for sect in liste:
      liste2 = config.options(sect)
      if( not (sect in out) and (len(liste2)>0) ):
        out[sect] = {}
      for opt in liste2:
        out[sect][opt] = config.get(sect,opt)


  # Es werden nach der dliste, die Werte gesetzt
  else:

    ii = 0
    for liste in dliste:
      ii += 1
      if( len(liste) < 4 ):
        outtext = "%i. Variable in ini-Liste ddlist hat nicht gen�gend Werte < 4 (['name','section',typ,'defaul'])" % ii
        return (hdef.NOT_OK,outtext,out)

      sect = liste[0]
      name = liste[1]
      typ  = liste[2]
      defa = liste[3]
      if( config.has_section(sect) and config.has_option(sect,name) ):
        val = config.get(sect, name)
      elif( not h.isempty(defa) ):
        val = defa
      else:
        outtext = "%i. Variable ist nicht in ini-File <%s> " % (ii,ini_file)
        return (hdef.NOT_OK,outtext,out)

      if( typ == hdef.DEF_FLT ):
        try:
          v = float(val)
        except:
          outtext = "Fehler bei Wandlung Wert zu float aus ini-File <%s> [%s]%s =  %s " % (ini_file,sect,name,val)
          return (hdef.NOT_OK,outtext,out)
      elif( typ == hdef.DEF_INT ):
        try:
          v = int(val)
        except:
          outtext = "Fehler bei Wandlung Wert zu integer aus ini-File <%s> [%s]%s =  %s " % (ini_file,sect,name,val)
          return (hdef.NOT_OK,outtext,out)
      elif( typ == hdef.DEF_VEC ):
        try:
          v = h.string_to_num_list(val)
        except:
          outtext = "Fehler bei Wandlung Wert zu vektor aus ini-File <%s> [%s]%s =  %s " % (ini_file,sect,name,val)
          return (hdef.NOT_OK,outtext,out)
      else:
        v = val

      if( out == None ):
        out = {}

      if( not sect in out ):
        out[sect] = {}

      out[sect][name] = v


  return (hdef.OK,outtext,out)
