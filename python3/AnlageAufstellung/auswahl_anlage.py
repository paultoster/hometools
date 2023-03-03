import sys, os

if( "..\\allg" not in sys.path ):
    sys.path.append("..\\allg")

import anlage_class
import sgui

def auswahl_anlage(a_liste : list) -> tuple:
    
    name_list = []
    for a in a_liste:
        name_list.append(a.name)
    #endfor

    index = sgui.abfrage_liste_index(name_list)

    if( index >= 0 ):
        a = a_liste[index]
    else:
        a = anlage_class.Anlage()
    #endif

    return (a,index)
#enddef


