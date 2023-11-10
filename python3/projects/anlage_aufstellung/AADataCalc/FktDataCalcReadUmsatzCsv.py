import sys, os
import pandas as pd

from hfkt import hfkt_def as hdef

from AADatabase import DatabaseDef as dbdef

# Hilfsfunktionen
# import hfkt as h
# import hfkt_def as hdef
# import hfkt_log as hlog
# import hfkt_ini as hini
# import hfkt_db_handle  as hdbh
# import hfkt_db         as hdb

#-----------------------------------------------------------------------------
# CSV Umsatzdatei lesen
# d["csvfilename"]         Dateiname csv-File

#-----------------------------------------------------------------------------
def fkt_data_calc_read_umsatz_csv(d):

  vecdict = [d]
  okay = hdef.OKAY
  errtext = ""

  df = pd.read_csv(d[dbdef.CSV_FILENAME],sep = ';',usecols = ['Name 1','Name 2'])

  print(df)

  # header = ""
  # vecvec = []
  # okay = 1
  # errtext = ""

  # csvfilename=d["csvfilename"]
  # with open(csvfilename, 'r') as file:
  #   csvreader = csv.reader(file,delimiter =";")
  #   header = next(csvreader)

  #   if( (len(header) == 0) ):
  #     errtext =f"File {csvfilename} konnte nicht gelesen werden"
  #     okay = 0
  #     return  (vecvec,okay,errtext)
  #   #endif

  #   (ilist,okay,errtext) = fkt_data_calc_find_rows(header,rlist)

  #   if( okay != 1):
  #     errtext =f"fkt_data_calc_read_umsatz_csv: Error: {errtext}"
  #     okay = 0
  #     return (vecvec,okay,errtext)
  #   #endif

  #   for row in csvreader:
  #     vec = [None for i in range(len(ilist))]
  #     for ih,ir in ilist:

  #       vec[ir] = row[ih]
  #     #endfor
  #     vecvec.append(vec)
  #   #endfor

  # #endwith

  return (vecdict,okay,errtext)
#enddef

def fkt_data_calc_find_rows(header,rlist):

  iliste = []
  okay = 1
  errtext = ""

  for rindex, searchrow in enumerate(rlist):
    flag = 1
    for hindex,hname in enumerate(header):
      if( hname.lower() == searchrow.lower()):
        flag = 0
        iliste.append((hindex,rindex))
        break
      #endif
    #endfor
    if( flag ):
      errtext = f"rowname: {searchrow} could not be found in header"
      okay    = 0
      break
    #endif
  #endfor
  return (iliste,okay,errtext)
#endef

