# Hilfsfunktionen
import hfkt_def as hdef
import hfkt_log as hlog
import sgui


def bearbeitung_konto(rd):
    index = sgui.abfrage_liste_index(rd.ini.konto_bearb_auswahl
                                     , "Kontobearbeitung auswählen")
    if (index < 0):
        choice = rd.ini.ENDE_RETURN_TXT
    else:
        choice = rd.ini.konto_bearb_auswahl[index]
    # endif
    
    return choice


# enddef

def auswahl_konto(rd):
    index = sgui.abfrage_liste_index(rd.ini.konto_names, "Konto auswählen")
    
    if (index < 0):
        choice = rd.ini.ENDE_RETURN_TXT
    else:
        choice = rd.ini.konto_names[index]
    # endif
    
    return choice
# enddef
