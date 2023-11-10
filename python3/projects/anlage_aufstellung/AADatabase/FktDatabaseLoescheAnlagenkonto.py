
import sys, os

tools_path = "D:\\tools_tb\\python3"

if( tools_path not in sys.path ):
    sys.path.append(tools_path)

from AADatabase import DatabaseDef as dbdef

#-----------------------------------------------
# Anlagenkonto löschen
#-----------------------------------------------
def fkt_db_loesche_anlagen_konto(dbh,konto_name:str):

  status = dbh.OKAY
  errText = ""

  # primkey Abfrage, ob vorhanden
  primkey_liste = dbh.get_tab_primary_key_with_value(dbdef.TAB_ANLAGEKONTO,dbdef.CELL_KONTONAME,konto_name)

  if( len(primkey_liste)==0):
    return (False,status,errText)
  else:
    primkey = primkey_liste[0]
  #endif

  # Kontodaten löschen
  #
  #

  # Konto mit primkey löschen
  status = dbh.delete_data_by_primkey(dbdef.TAB_ANLAGEKONTO,primkey)


  if( status != dbh.OKAY):
    errText = dbh.errText
    return (False,status,errText)
  #endif

  return (True,status,errText)
#enddef
