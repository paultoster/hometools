import sys

if( "..\\allg" not in sys.path ):
    sys.path.append("..\\allg")

from anlage_class import Anlage
from auswahl_anlage import auswahl_anlage
from csv_daten_lesen import csv_daten_lesen

import hfkt as h

def daten_laden(a_liste : list) -> list:
    
    print(f"Daten laden")

    # Auswahl der Anlage
    #-------------------
    (a,_) = auswahl_anlage(a_liste)

    # csv einlesen
    #-------------
    if( a.par["type_read"] == "csv" ):

        a = daten_laden_csv(a)
    
    # Abruch da nicht bekannt
    #------------------------
    else:
        type = a.par["type_read"]
        print(f"a.type_read = {type} existiert nicht")
    
    #endif

    return a_liste
#enddef
def daten_laden_csv(a : Anlage) -> Anlage:
    
    # csv-Daie auswählen
    #-------------------
    csvfilename = h.abfrage_file(file_types="*.csv",comment="Welche csv-Datei um Buchungen auszuwerten",start_dir=".")

    if( len(csvfilename) == 0):

      print(f"keine csv-DAtei ausgewählt")
      return a
    #endif

    liste = csv_daten_lesen(filename = csvfilename, pattern_list = a.par["txt_csv_suchtext"])

    return a
#enddef


