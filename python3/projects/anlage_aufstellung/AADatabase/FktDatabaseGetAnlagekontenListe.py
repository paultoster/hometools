
import sys, os

tools_path = "D:\\tools_tb\\python3"

if( tools_path not in sys.path ):
    sys.path.append(tools_path)

# Hilfsfunktionen
# import hfkt as h
# import hfkt_def as hdef
# import hfkt_log as hlog
# import hfkt_ini as hini
# import hfkt_db_handle  as hdbh
# import hfkt_db         as hdb

from AADatabase import DatabaseDef as dbdef

#-----------------------------------------------------------------------------
# Liste Anlagenkonten
#-----------------------------------------------------------------------------
def fkt_db_get_anlagen_konten_liste(dbh):

  r = {"prim_key_liste":[],"anlagekonten_namen_liste":[]}
  errText = ""
  status  = dbh.OKAY

  # get primary ke name from table person
  primkeyname = dbh.get_tab_primary_key_name(dbdef.TAB_ANLAGEKONTO)

  if( dbh.status != dbh.OKAY ):

    errText = "Fehler in dbh.get_tab_key_name: <%s>" % dbh.errText
    status = dbh.NOT_OKAY
    return (r,status,errText)
  #endif

  # get data
  (header_liste,data_liste) = dbh.get_tab_data(dbdef.TAB_ANLAGEKONTO,[primkeyname,dbdef.CELL_KONTONAME])
  
  for row in data_liste:
    
    r["prim_key_liste"].append(row[0])
    r["anlagekonten_namen_liste"].append(row[1])

  #endfor

  return (r,status,errText)

#enddef
