import sys

import codecs

# Hilfsfunktionen
from hfkt import hfkt as h
from hfkt import hfkt_def as hdef
from hfkt import hfkt_log as hlog
from hfkt import hfkt_status as status
from hfkt import sguicommand
from hfkt import hfkt_commands as hcommand

from .FktSteuAnlagekontoGetKonto import fkt_steu_anlage_konto_get_konto
from .FktSteuAnlageKontoGetCsvKeywords import fkt_steu_anlage_konto_get_csv_keywords
from .FktSteuAnlageKontoGetCsvKeywords import fkt_steu_anlage_konto_set_csv_start_dir
from AADataCalc.FktDataCalcReadUmsatzCsv import fkt_data_calc_read_umsatz_csv
from AADatabase import DatabaseDef as dbdef

#------------------------------------------------------------
# Anlagekonto bearbeiten
#------------------------------------------------------------
def fkt_steu_anlage_konto_umsatz_csv(obj):

  d = {}
  #==========================================================
  # Konto auswählen
  #==========================================================
  (d[dbdef.CELL_KONTONAME],d["primekey"],okay) = fkt_steu_anlage_konto_get_konto(obj)

  if( okay == 0):
    return
  #endif

  #===========================================================
  # get rows-name of csv-File
  #===========================================================
  (dcsv,okay)  = fkt_steu_anlage_konto_get_csv_keywords(obj,d[dbdef.CELL_KONTONAME])

  # update with dcsv-dict
  #----------------------
  d.update(dcsv)

  #===========================================================
  # get filename to read
  #===========================================================
  t = "Suche csv-Datei von konto " + d[dbdef.CELL_KONTONAME]
  csvfilename = h.abfrage_file(file_types="*.csv",comment=t)
  # print(dir(csvfilename))
  # print(csvfilename.__class__)

  if( len(csvfilename)==0):
    t =f"fkt_data_calc_read_umsatz_csv: Error: Keine CSV-Datei ausgewählt"
    obj.stat.set_NOT_OKAY(t)
    return
  #endif
  d[dbdef.CSV_FILENAME] = csvfilename

  (path,_,_) = h.get_pfe(csvfilename)

  # fkt_steu_anlage_konto_set_csv_start_dir(obj,path)

  if( obj.stat.is_NOT_OKAY()):
    return

  #=================
  # read csv-file
  #=================
  (vecdict,okay,errtext) = fkt_data_calc_read_umsatz_csv(d)

  if( okay != 1 ):
    t =f"fkt_data_calc_read_umsatz_csv: Error: {errtext}"
    obj.stat.set_NOT_OKAY(t)
    return

  for vec in vecvec:
    print(vec)

#enddef
