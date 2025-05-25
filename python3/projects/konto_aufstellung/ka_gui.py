# Hilfsfunktionen
import hfkt_def as hdef
import hfkt_log as hlog
import sgui



def listen_abfrage(rd,auswahl_liste,auswahl_title):

    index = sgui.abfrage_liste_index(auswahl_liste, auswahl_title)
    return index
# enddef

def iban_abfrage(rd,header_liste,data_llist,abfrage_liste):
    '''
    
    :param rd:
    :param header_liste:
    :param data_llist:
    :param abfrage_liste:
    :return: (d_new,index_abfrage,irow) =  iban_abfrage(rd,header_liste,data_llist,abfrage_liste)
    '''
    (d_new, index_abfrage,irow,_) = sgui.abfrage_tabelle_get_row(header_liste=header_liste
                                                 , data_set=data_llist
                                                 , listeAbfrage=abfrage_liste)
    
    return (d_new,index_abfrage,irow)
# end def

def auswahl_konto(rd):
    index = sgui.abfrage_liste_index(rd.ini.konto_names, "Konto auswählen")
    if index < 0:
        choice =  ""
    else:
        choice = rd.ini.konto_names[index]
    # endif
    return (index,choice)
# enddef
def auswahl_depot(rd):
    index = sgui.abfrage_liste_index(rd.ini.depot_names, "Depot auswählen")
    if index < 0:
        choice =  ""
    else:
        choice = rd.ini.depot_names[index]
    # endif
    return (index,choice)
# enddef

def konto_abfrage( header_liste, data_llist, abfrage_liste,color_list):
    '''
    
    
    :param header_liste:
    :param data_llist:
    :param abfrage_liste:
    :param color_list
    :return: (d_new,index_abfrage,irow,data_changed_pos_list) = konto_abfrage(rd, header_liste, data_llist, abfrage_liste, color_list)
    '''

    (d_new, index_abfrage, irow,data_changed_pos_list) = sgui.abfrage_tabelle_get_row_set_color(header_liste=header_liste
                                                                , data_set=data_llist
                                                                , color_liste=color_list
                                                                , listeAbfrage=abfrage_liste)
    
    return (d_new, index_abfrage, irow,data_changed_pos_list)

# edn def
def konto_data_set_eingabe(eingabe_liste,data_set):
    '''
    
    
    :param header_liste:
    :param buchungs_type_list:
    :return: new_data_list = ka_gui.konto_data_set_eingabe(header_liste,buchungs_type_list)
    '''
    new_data_list = sgui.abfrage_n_eingabezeilen(liste=eingabe_liste,vorgabe_liste=data_set, title="Eine Kontobewegung eingeben")
    
    return new_data_list
# end if