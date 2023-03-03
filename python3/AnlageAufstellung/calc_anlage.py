import sys, os

if( "..\\allg" not in sys.path ):
    sys.path.append("..\\allg")

from anlage_class import Anlage

def calc_anlage(a : Anlage) -> Anlage:
    
    print(f"Bearbeite Anlage {a.name}")
    return a
#enddef


