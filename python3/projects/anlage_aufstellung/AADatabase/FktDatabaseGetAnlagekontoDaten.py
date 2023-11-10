
import sys, os

tools_path = "D:\\tools_tb\\python3"

if( tools_path not in sys.path ):
    sys.path.append(tools_path)

# Hilfsfunktionen
from hfkt import hfkt as h
from hfkt import hfkt_db  as hdb

from AADatabase import DatabaseDef as dbdef

#-----------------------------------------------
# Anlagenkonto header liste
#-----------------------------------------------
def fkt_db_get_anlage_konto_header_liste(dbh):

  header_liste = dbh.get_tab_header_list(dbdef.TAB_ANLAGEKONTO,1)

  return (header_liste,dbh.status,dbh.errText)
#enddef
#-----------------------------------------------------------------------------
# Daten des  Anlagenkonto
#-----------------------------------------------------------------------------
def fkt_db_get_anlage_konto_daten(dbh,anlagekontoname):

  #d = {dbdef.CELL_KONTONAME:"",dbdef.CELL_KONTONR:"",dbdef.CELL_KONTOBLZ:"",dbdef.CELL_KONTOIBAN:"",dbdef.CELL_KONTOSTAND:0.,dbdef.CELL_ANFANGSDATUM:""}
  d = {}

  if( len(anlagekontoname) > 0 ):

    dd = dbh.get_tab_data_with_value_type_in_dict(dbdef.TAB_ANLAGEKONTO,dbdef.CELL_KONTONAME,anlagekontoname)

    if( len(dd) == 0):

      return d

    else:



      for header in dd:

        value = dd[header][0]
        type  = dd[header][1]

        if( type == hdb.DB_DATA_TYPE_STR ):

          d[header] = value

        elif( type == hdb.DB_DATA_TYPE_DATUM):

          d[header] = h.secs_time_epoch_to_str(value)

        elif( type == hdb.DB_DATA_TYPE_DATUM):

          d[header] = h.secs_time_epoch_to_str(value)

        elif( type == hdb.DB_DATA_TYPE_CENT ):

          d[header] = float(value)/100.

        else:

          d[header] = value

        #endif
      #endofr

  #endif

  return (d,dbh.status,dbh.errText)
#enddef
