# Hilfsfunktionen
import tools.sgui as sgui

import tools.hfkt_tvar as htvar
import tools.hfkt_type as htype
import tools.hfkt_def as hdef

def janein_abfrage(rd,ausgabe_text,ausgabe_title):

    flag = sgui.abfrage_janein(text=ausgabe_text,title=ausgabe_title)
    return flag

# end def
def listen_abfrage(auswahl_liste,auswahl_title,abfrage_liste=None):
    
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

def auswahl_konto(konto_liste):
    index = sgui.abfrage_liste_index(konto_liste, "Konto auswählen")
    if index < 0:
        choice =  ""
    else:
        choice = konto_liste[index]
    # endif
    return (index,choice)
# enddef
def auswahl_depot(abfrage_liste):
    index = sgui.abfrage_liste_index(abfrage_liste, "Depot auswählen")
    if index < 0:
        choice =  ""
    else:
        choice = abfrage_liste[index]
    # endif
    return (index,choice)
# enddef

def konto_abfrage( ttable, abfrage_liste,color_list):
    '''
    
    
    :param header_liste:
    :param data_llist:
    :param abfrage_liste:
    :param color_list
    :return: (d_new,index_abfrage,irow,data_changed_pos_list) = konto_abfrage(rd, header_liste, data_llist, abfrage_liste, color_list)
    '''

    dict_inp = {}
    dict_inp["ttable"] = ttable
    dict_inp["row_color_dliste"] = color_list
    dict_inp["abfrage_liste"] = abfrage_liste
    dict_inp["auswahl_filter_col_liste"] = ["isin","buchtype"]
    
    dict_out = sgui.abfrage_tabelle(dict_inp)
    
    if dict_out["status"] != hdef.OKAY:
        
        return (dict_out["status"],dict_out["errtext"],[],-1,-1,[])
    # end if
    
    return ( dict_out["status"],dict_out["errtext"],dict_out["ttable"]
           , dict_out["index_abfrage"], dict_out["irow_select"], dict_out["data_change_irow_icol_liste"])
# end def
def konto_isin_wkn_set_eingabe(eingabe_liste,data_set=None,title=None):
    ddict = {}
    ddict["liste_abfrage"] = eingabe_liste
    
    if title is not None:
        ddict["title"] = title
    # end if
    
    if data_set is not None:
        ddict["liste_vorgabe"] = data_set
    # end if
    
    new_data_list = sgui.abfrage_n_eingabezeilen_dict(ddict)

    return new_data_list

def konto_depot_data_set_eingabe(tlist,buchtype_index_in_header_liste,buchungs_type_list,title=None,immutable_liste=None):
    '''
    
    
    :param header_liste:
    :param buchungs_type_list:
    :return: new_data_list = depot_gui.konto_data_set_eingabe(header_liste,buchungs_type_list)
    '''
    
    # Erstelle die Eingabe liste
    eingabe_liste = []
    for i, header in enumerate(tlist.names):
        if i == buchtype_index_in_header_liste:
            eingabe_liste.append([header, buchungs_type_list])  # Auswahl ist die buchungs_type_list
        else:
            eingabe_liste.append(header)
        # end if
    # end for
    
    if title is None:
        title = "Eine Kontobewegung eingeben"
    # end if
    if not isinstance(immutable_liste,list):
        immutable_liste = []
        for i in range(len(eingabe_liste)):
            immutable_liste.append(False)
        # end for
    # end if
    ddict = {}
    ddict["liste_abfrage"] = eingabe_liste
    ddict["title"] = title
    ddict["liste_immutable"] = immutable_liste

    ddict["liste_vorgabe"] = tlist.vals
    
    run_flag = True
    errtext  = "Error in Eingabe "
    change_flag = False
    
    while run_flag:
        new_data_list = sgui.abfrage_n_eingabezeilen_dict(ddict)
        
        if len(new_data_list) == 0:
            return ([],False)
        # end if
        
        run_flag = False
        vals = []
        for i in range(tlist.n):
            (okay, val) = htype.type_proof(new_data_list[i], tlist.types[i])
            if okay == hdef.OKAY:
                if val != tlist.vals[i]:
                    change_flag = True
                # end if
                vals.append(val)
            else:
                run_flag = True
                errtext  = f"{errtext}/name: {tlist.names[i]} = val: {new_data_list[i]}"
                vals.append(tlist.vals[i])
            # end if
        # end for
        
        if run_flag:
            sgui.anzeige_text(errtext, title="Fehler bei Eingabe", textcolor='red')
        # end if
    # end while
    
    tlist_new = htvar.build_list(tlist.names,vals,tlist.types)

    return (tlist_new,change_flag)
# end def
def konto_depot_kategorie(kategorie, titlename):
    '''
    
    :param kategorie:
    :param titlename:
    :return: kategorie = depot_gui.konto_depot_kategorie(kategorie, titlename)
    '''
    kategorie = sgui.abfrage_n_eingabezeilen(liste=["kategorie"], vorgabe_liste=[kategorie], title=titlename)
    return kategorie
# end dfe
def  depot_overview(ttable, abfrage_liste,titlename,row_color_dliste):
    '''
    
    :param header_liste:
    :param data_lliste:
    :param abfrage_liste:
    :return: choice =  depot_gui.depot_overview(header_liste, data_lliste, abfrage_liste)
    '''



    dict_inp = {}
    dict_inp["ttable"] = ttable
    dict_inp["abfrage_liste"] = abfrage_liste
    dict_inp["title"] = titlename
    dict_inp["row_color_dliste"] = row_color_dliste
    
    dict_out = sgui.abfrage_tabelle(dict_inp)
    
    if dict_out["status"] != hdef.OKAY:
        return (dict_out["status"], dict_out["errtext"], -1, -1)
    # end if
    
    return (dict_out["status"], dict_out["errtext"], dict_out["index_abfrage"], dict_out["irow_select"])
# end def
def depot_isin(header_liste, data_lliste, abfrage_liste,title,row_color_dliste):
    '''
    
    :param header_liste:
    :param data_lliste:
    :param abfrage_liste:
    :param title:
    :return: (choice, irow) = depot_gui.depot_isin(header_liste, data_lliste, abfrage_liste,title)
    '''
    
    dict_inp = {}
    dict_inp["header_liste"] = header_liste
    dict_inp["data_set_lliste"] = data_lliste
    dict_inp["abfrage_liste"] = abfrage_liste
    dict_inp["title"] = title
    dict_inp["row_color_dliste"] = row_color_dliste
    
    dict_out = sgui.abfrage_tabelle(dict_inp)
    
    return (dict_out["index_abfrage"], dict_out["irow_select"], dict_out["data_change_irow_icol_liste"],dict_out["data_set"])
def auswahl_depot_kategorie_liste(kategorie_liste):
    '''
    
    :param kategorie_liste:
    :return: (index,choice) = auswahl_depot_kategorie_liste(kategorie_liste)
    '''
    
    
    index = sgui.abfrage_liste_index(kategorie_liste, "Kategorie auswählen")
    if index < 0:
        choice =  ""
    else:
        choice = kategorie_liste[index]
    # endif
    return (index,choice)
# enddef
