# Hilfsfunktionen
import hfkt_def as hdef
import hfkt_log as hlog
import sgui

def janein_abfrage(rd,ausgabe_text,ausgabe_title):

    flag = sgui.abfrage_janein(text=ausgabe_text,title=ausgabe_title)
    return flag

# end def
def listen_abfrage(rd,auswahl_liste,auswahl_title,abfrage_liste=None):
    
    if abfrage_liste == None:
        index = sgui.abfrage_liste_index(auswahl_liste, auswahl_title)
        indexAbfrage = 0
    else:
        [index,indexAbfrage] = sgui.abfrage_liste_index_abfrage_index(auswahl_liste,abfrage_liste,auswahl_title)
    # end if
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
   
    dict_inp = {}
    dict_inp["header_liste"] = header_liste
    dict_inp["data_set_lliste"] = data_llist
    dict_inp["abfrage_liste"] = abfrage_liste
    
    dict_out = sgui.abfrage_tabelle(dict_inp)
    
    
    return (dict_out["data_set"],dict_out["index_abfrage"] ,dict_out["irow_select"] )
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

    dict_inp = {}
    dict_inp["header_liste"] = header_liste
    dict_inp["data_set_lliste"] = data_llist
    dict_inp["row_color_dliste"] = color_list
    dict_inp["abfrage_liste"] = abfrage_liste
    
    dict_out = sgui.abfrage_tabelle(dict_inp)
    
    return (dict_out["data_set"], dict_out["index_abfrage"], dict_out["irow_select"], dict_out["data_change_irow_icol_liste"])

# edn def
def konto_data_set_eingabe(eingabe_liste,data_set=None,title=None):
    '''
    
    
    :param header_liste:
    :param buchungs_type_list:
    :return: new_data_list = ka_gui.konto_data_set_eingabe(header_liste,buchungs_type_list)
    '''
    

    if data_set is None:
        if title is None:
            title = "Eine Kontobewegung eingeben"
        new_data_list = sgui.abfrage_n_eingabezeilen(liste=eingabe_liste,title=title)
    else:
        if title is None:
            title = "Eine Kontobewegung eingeben"
        new_data_list = sgui.abfrage_n_eingabezeilen(liste=eingabe_liste,vorgabe_liste=data_set, title=title)
    
    return new_data_list
# end if