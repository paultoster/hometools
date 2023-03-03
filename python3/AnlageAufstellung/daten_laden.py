import sys

if( "..\\allg" not in sys.path ):
    sys.path.append("..\\allg")

from anlage_class import Anlage
from auswahl_anlage import auswahl_anlage

def daten_laden(a_liste : list) -> list:
    
    print(f"Daten laden")

    (a,index) = auswahl_anlage(a_liste)

    if( a.type_read == 'csv' ):

        a = daten_laden_csv(a)
    else:
        print(f"a.type_read = {a.type_read} existiert nicht")
        exit(0)
    #endif

    return a_liste
#enddef
def daten_laden_csv(a : Anlage) -> Anlage:
    
    print(f"Bearbeite Anlage {a.name}")
    return a
#enddef


