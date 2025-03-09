# Hilfsfunktionen
import hfkt_def as hdef
import hfkt_log as hlog
import sgui



def listen_abfrage(rd,auswahl_liste,auswahl_title):

    index = sgui.abfrage_liste_index(auswahl_liste, auswahl_title)
    return index
# enddef

def iban_abfrage(rd,header_liste,data_set,abfrage_liste):
    
    (d_new, index_abfrage,irow) = sgui.abfrage_tabelle_get_row(header_liste=header_liste
                                                 , data_set=data_set
                                                 , data_index_liste=None
                                                 , listeAbfrage=abfrage_liste)
    
    return (d_new,index_abfrage,irow)
# end def

def auswahl_konto(rd):
    index = sgui.abfrage_liste_index(rd.ini.konto_names, "Konto auswählen")

    return index
# enddef
