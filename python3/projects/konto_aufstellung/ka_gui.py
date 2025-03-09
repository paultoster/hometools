# Hilfsfunktionen
import hfkt_def as hdef
import hfkt_log as hlog
import sgui



def listen_abfrage(rd,auswahl_liste,auswahl_title):

    index = sgui.abfrage_liste_index(auswahl_liste, auswahl_title)
    return index
# enddef

def auswahl_konto(rd):
    index = sgui.abfrage_liste_index(rd.ini.konto_names, "Konto auswählen")

    return index
# enddef
