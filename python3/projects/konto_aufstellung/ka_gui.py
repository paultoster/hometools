# Hilfsfunktionen
import hfkt_def as hdef
import hfkt_log as hlog
import sgui

def janein_abfrage(rd,ausgabe_text,ausgabe_title):

    flag = sgui.abfrage_janein(text=ausgabe_text,title=ausgabe_title)
    return flag

# end def
def listen_abfrage(rd,auswahl_liste,abfrage_liste,auswahl_title):
    
    # index = sgui.abfrage_liste_index(auswahl_liste, auswahl_title)
    [index,indexAbfrage] = sgui.abfrage_liste_index_abfrage_index(auswahl_liste,abfrage_liste,auswahl_title)
    return (index,indexAbfrage)
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
    index = sgui.abfrage_liste_index(rd.ini.ddict[rd.par.INI_KONTO_DATA_DICT_NAMES_NAME], "Konto auswählen")
    if index < 0:
        choice =  ""
    else:
        choice = rd.ini.ddict[rd.par.INI_KONTO_DATA_DICT_NAMES_NAME][index]
    # endif
    return (index,choice)
# enddef
def auswahl_depot(rd):
    index = sgui.abfrage_liste_index(rd.ini.ddict[rd.par.INI_DEPOT_DATA_DICT_NAMES_NAME], "Depot auswählen")
    if index < 0:
        choice =  ""
    else:
        choice = rd.ini.ddict[rd.par.INI_DEPOT_DATA_DICT_NAMES_NAME][index]
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
def konto_data_set_eingabe(eingabe_liste,data_set=None):
    '''
    
    
    :param header_liste:
    :param buchungs_type_list:
    :return: new_data_list = ka_gui.konto_data_set_eingabe(header_liste,buchungs_type_list)
    '''
    if data_set is None:
        new_data_list = sgui.abfrage_n_eingabezeilen(liste=eingabe_liste,title="Eine Kontobewegung eingeben")
    else:
        new_data_list = sgui.abfrage_n_eingabezeilen(liste=eingabe_liste,vorgabe_liste=data_set, title="Eine Kontobewegung eingeben")
    
    return new_data_list
# end if