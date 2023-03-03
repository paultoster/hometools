import sys, os

if( "..\\allg" not in sys.path ):
    sys.path.append("..\\allg")


import sgui

def auswahl_liste(name_list : list) -> tuple:
    
    index = sgui.abfrage_liste_index(name_list)

    if( index >= 0 ):
        a = name_list[index]
    else:
        a = ""
    #endif

    return (a,index)
#enddef


