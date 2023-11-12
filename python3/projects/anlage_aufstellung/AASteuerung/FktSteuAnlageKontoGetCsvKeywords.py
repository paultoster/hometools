import sys

from AADatabase import DatabaseDef as dbdef

# Hilfsfunktionen


#------------------------------------------------------------
# Anlagenkonto bearbeiten
#------------------------------------------------------------
def fkt_steu_anlage_konto_get_csv_keywords(obj,anlagenkontoname):

  okay     = 1

  rliste = [dbdef.CELL_CSV_HEAD_NAME,dbdef.CELL_CSV_HEAD_IBAN \
           ,dbdef.CELL_CSV_HEAD_BIC,dbdef.CELL_CSV_HEAD_WERT \
          ,dbdef.CELL_CSV_HEAD_DATUM,dbdef.CELL_CSV_HEAD_KOMMENTAR]

  d = obj.db.dbh.get_tab_data_with_value_in_dict(dbdef.TAB_ANLAGEKONTO,dbdef.CELL_KONTONAME,anlagenkontoname,rliste)

  return (d,okay)
#enddef

def fkt_steu_anlage_konto_set_csv_start_dir(obj,path):

  path
#enddef
