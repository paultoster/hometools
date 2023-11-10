
import sys, os

tools_path = "D:\\tools_tb\\python3"

if( tools_path not in sys.path ):
    sys.path.append(tools_path)

# Hilfsfunktionen
from hfkt import hfkt as h
from AADatabase import DatabaseDef as dbdef
from hfkt import hfkt_db as hdb


#-----------------------------------------------
# Anlagenkonto anlegen
#-----------------------------------------------
def fkt_db_set_anlagen_konto_daten(dbh,konto_name_exist,dout):
  """
  dictionary dout schreiben
  muss vorher geprüft sein insbesondere konto_stand_float und anfangs_datum_str
  konto_name_exist Konto existiert ansonsten leer ""
  """
  status = dbh.OKAY
  errText = ""
  dbh.reset_status()

  for header_name in dout:

    # get type of headername
    type_no = dbh.get_tab_type_of_cell_name(dbdef.TAB_ANLAGEKONTO,header_name)

    if( dbh.status != dbh.OKAY ):
      status  = dbh.status
      errText = f"type from table <{dbdef.TAB_ANLAGEKONTO}> with cellname <header_name> is not available"
      return (status,errText)
    #endif

    if(type_no == hdb.DB_DATA_TYPE_STR ):

      pass

    elif( type_no == hdb.DB_DATA_TYPE_DATUM):

      dout[header_name] = h.secs_time_epoch_from_str(dout[header_name])

    elif( type_no == hdb.DB_DATA_TYPE_CENT ):

      dout[header_name] = int(float(dout[header_name])*100.)

    elif( type_no == hdb.DB_DATA_TYPE_FLOAT ):

      dout[header_name] = float(dout[header_name])

    elif( (type_no == hdb.DB_DATA_TYPE_INT) or (type == hdb.DB_DATA_TYPE_KEY) ):

      dout[header_name] = int(dout[header_name])

    else:
      pass

    #endif
  #endfor

  #------------------------------------------------------------------------
  # neuen DAtensatz anlegen
  #------------------------------------------------------------------------
  if( len(konto_name_exist) == 0 ):

    status = dbh.add_new_data_set(dbdef.TAB_ANLAGEKONTO,dout)

    if( status != dbh.OKAY):
      status = dbh.NOT_OKAY
      errText = "Error hfkt_db_handle: "+ dbh.errText
      return (status,errText)

  #------------------------------------------------------------------------
  # bestehender Datensatz modifizieren
  #------------------------------------------------------------------------
  else:

    # primkey Abfrage, ob vorhanden
    primkey_liste = dbh.get_tab_primary_key_with_value(dbdef.TAB_ANLAGEKONTO,dbdef.CELL_KONTONAME,konto_name_exist)

    if( len(primkey_liste)==0):
      status  = dbh.NOT_OKAY
      errText = f"primkey für Tabelle {dbdef.TAB_ANLAGEKONTO} für Name {dbdef.CELL_KONTONAME} nicht gefunden"
      return (status,errText)
    else:
      primkey = primkey_liste[0]
    #endif

    # Aufruf modifizieren
    status = dbh.modify_data_by_primkey(dbdef.TAB_ANLAGEKONTO,primkey,dout)

    if( status != dbh.OKAY):
      status = dbh.NOT_OKAY
      errText = dbh.errText
      return (status,errText)
    #endif
  #endif

  return (status,errText)
#enddef
