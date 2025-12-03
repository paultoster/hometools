# Hilfsfunktionen
import tools.sgui as sgui

import tools.hfkt_tvar as htvar
import tools.hfkt_type as htype
import tools.hfkt_def as hdef

def janein_abfrage(gui,ausgabe_text,ausgabe_title):

    flag = gui.abfrage_janein(text=ausgabe_text,title=ausgabe_title)
    return flag

# end def
def listen_abfrage(gui,auswahl_liste,auswahl_title,abfrage_liste=None):
    
    if abfrage_liste == None:
        index = gui.abfrage_liste_index(auswahl_liste, auswahl_title)
        indexAbfrage = 0
    else:
        [index,indexAbfrage] = gui.abfrage_liste_index_abfrage_index(auswahl_liste,abfrage_liste,auswahl_title)
    # end if
    return (index,indexAbfrage)
# enddef

def iban_abfrage(gui,ttable, abfrage_liste, color_list, title=None):
    '''
    
    :param gui:
    :param header_liste:
    :param data_llist:
    :param abfrage_liste:
    :return: (d_new,index_abfrage,irow) =  iban_abfrage(rd.gui,ttable, abfrage_liste, color_list, title=None)
    '''
    
    dict_inp = {}
    dict_inp["ttable"] = ttable
    dict_inp["row_color_dliste"] = color_list
    dict_inp["abfrage_liste"] = abfrage_liste
    dict_inp["auswahl_filter_col_liste"] = ttable.names
    if title:
        dict_inp["title"] = title
    # end if
    
    dict_out = gui.abfrage_tabelle(dict_inp)
    
    if dict_out["status"] != hdef.OKAY:
        return (dict_out["status"], dict_out["errtext"], [], -1, -1, [])
    # end if
    
    return (dict_out["status"], dict_out["errtext"], dict_out["ttable"]
                , dict_out["index_abfrage"], dict_out["irow_select"], dict_out["data_change_irow_icol_liste"])
    
# end def
def iban_data_set_eingabe(gui, tlist,  title=None,
                                 immutable_liste=None):
    '''


    :param header_liste:
    :param buchungs_type_list:
    :return: new_data_list = depot_gui.konto_data_set_eingabe(header_liste,buchungs_type_list)
    '''
    
    # Erstelle die Eingabe liste
    eingabe_liste = tlist.names
    
    if title is None:
        title = "Eine Kontobewegung eingeben"
    # end if

    ddict = {}
    ddict["liste_abfrage"] = eingabe_liste
    ddict["title"] = title
    # dict["liste_immutable"] = immutable_liste
    
    ddict["liste_vorgabe"] = tlist.vals
    
    run_flag = True
    errtext = "Error in Eingabe "
    change_flag = False
    
    while run_flag:
        new_data_list = gui.abfrage_n_eingabezeilen_dict(ddict)
        
        if len(new_data_list) == 0:
            return ([], False)
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
                errtext = f"{errtext}/name: {tlist.names[i]} = val: {new_data_list[i]}"
                vals.append(tlist.vals[i])
            # end if
        # end for
        
        if run_flag:
            gui.anzeige_text(errtext, title="Fehler bei Eingabe", textcolor='red')
        # end if
    # end while
    
    tlist_new = htvar.build_list(tlist.names, vals, tlist.types)
    
    return (tlist_new, change_flag)


# end def

def auswahl_konto(gui,konto_liste):
    index = gui.abfrage_liste_index(konto_liste, "Konto auswählen")
    if index < 0:
        choice =  ""
    else:
        choice = konto_liste[index]
    # endif
    return (index,choice)
# enddef
def auswahl_depot(gui,abfrage_liste):
    index = gui.abfrage_liste_index(abfrage_liste, "Depot auswählen")
    if index < 0:
        choice =  ""
    else:
        choice = abfrage_liste[index]
    # endif
    return (index,choice)
# enddef

def konto_abfrage(gui, ttable, abfrage_liste,color_list,title=None):
    '''
    
    
    :param header_liste:
    :param data_llist:
    :param abfrage_liste:
    :param color_list
    :return: (d_new,index_abfrage,irow,data_changed_pos_list) = konto_abfrage(gui, header_liste, data_llist, abfrage_liste, color_list)
    '''

    dict_inp = {}
    dict_inp["ttable"] = ttable
    dict_inp["row_color_dliste"] = color_list
    dict_inp["abfrage_liste"] = abfrage_liste
    dict_inp["auswahl_filter_col_liste"] = ["buchdatum","wer","buchtype","wert","comment","isin","kategorie"]
    if title:
        dict_inp["title"] = title
    # end if
    
    dict_out = gui.abfrage_tabelle(dict_inp)
    
    if dict_out["status"] != hdef.OKAY:
        
        return (dict_out["status"],dict_out["errtext"],[],-1,-1,[])
    # end if
    
    return ( dict_out["status"],dict_out["errtext"],dict_out["ttable"]
           , dict_out["index_abfrage"], dict_out["irow_select"], dict_out["data_change_irow_icol_liste"])
# end def
def konto_isin_wkn_set_eingabe(gui,eingabe_liste,data_set=None,title=None):
    ddict = {}
    ddict["liste_abfrage"] = eingabe_liste
    
    if title is not None:
        ddict["title"] = title
    # end if
    
    if data_set is not None:
        ddict["liste_vorgabe"] = data_set
    # end if
    
    new_data_list = gui.abfrage_n_eingabezeilen_dict(ddict)

    return new_data_list
def konto_set_kat(gui, eingabeListe, vorgabeListe,immutableListe, title):
    ddict = {}


    ddict["liste_abfrage"] = eingabeListe
    ddict["title"] = title
    ddict["liste_immutable"] = immutableListe
    
    ddict["liste_vorgabe"] = vorgabeListe
    
    new_data_list = gui.abfrage_n_eingabezeilen_dict(ddict)
    
    return new_data_list

# end def
def konto_regel_edit_abfrage(gui,reg_list):
    '''
    
    :param gui:
    :param reg_list:
    :return: reg_list_mod = konto_regel_edit_abfrage(gui, reg_list)
    '''
    title = "Konto-Regel-dictionary editieren"
    reg_list_mod = gui.modify_variable(reg_list, title)
    
    return reg_list_mod
# end def
def konto_regel_edit(gui, eingabeListe, vorgabeListe,title):
    '''
    
    :param gui:
    :param eingabeListe:
    :param vorgabeListe:
    :param title:
    :return:
    '''
    
    ddict = {}
    ddict["liste_abfrage"] = eingabeListe
    ddict["title"] = title
    # ddict["liste_immutable"] = immutable_liste
    
    ddict["liste_vorgabe"] = vorgabeListe
    
    new_data_list = gui.abfrage_n_eingabezeilen_dict(ddict)

    return new_data_list
# end def
def konto_kat_abfrage(gui, kat_dict):
    '''

    :param gui:
    :param kat_dict:
    :return: kat_dict_mod = konto_kat_abfrage(gui, kat_dict)
    '''
    title = "Veränderung der dict der Kategorie mit Hauptkategorie für Konto"
    kat_dict_mod = gui.modify_variable(kat_dict, title)
    
    return kat_dict_mod
# end def
def konto_kategorie_dict_abfrage(gui, ddict):
    '''

    :param gui:
    :param hkat_list:
    :return: ddict = konto_kategorie_dict_abfrage(gui, ddict)
    '''
    title = "Kategorie editieren"
    ddict_mod = gui.modify_variable(ddict, title)
    
    return ddict_mod
# end def
def konto_depot_data_set_eingabe(gui,tlist,buchtype_index_in_header_liste,buchungs_type_list,title=None,immutable_liste=None):
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
        new_data_list = gui.abfrage_n_eingabezeilen_dict(ddict)
        
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
            gui.anzeige_text(errtext, title="Fehler bei Eingabe", textcolor='red')
        # end if
    # end while
    
    tlist_new = htvar.build_list(tlist.names,vals,tlist.types)

    return (tlist_new,change_flag)
# end def
def depot_kategorie(gui,kategorie, titlename):
    '''
    
    :param kategorie:
    :param titlename:
    :return: kategorie = depot_gui.depot_kategorie(gui,kategorie, titlename)
    '''
    ddict = {}
    ddict["liste_abfrage"] = ["kategorie"]
    ddict["liste_vorgabe"] = [kategorie]
    ddict["title"]         = titlename
    
    
    kategorie_liste = gui.abfrage_n_eingabezeilen_dict(ddict)
    return kategorie_liste
# end dfe
def  depot_overview(gui,ttable, abfrage_liste,titlename,row_color_dliste):
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
    
    dict_out = gui.abfrage_tabelle(dict_inp)
    
    if dict_out["status"] != hdef.OKAY:
        return (dict_out["status"], dict_out["errtext"], -1, -1)
    # end if
    
    return (dict_out["status"], dict_out["errtext"], dict_out["index_abfrage"], dict_out["irow_select"])
# end def
def depot_isin(gui, ttable,abfrage_liste,title,row_color_dliste):
    '''
    
    :param header_liste:
    :param data_lliste:
    :param abfrage_liste:
    :param title:
    :return: (choice, irow) = depot_gui.depot_isin(gui,header_liste, data_lliste, abfrage_liste,title)
    '''
    
    dict_inp = {}
    dict_inp["ttable"] = ttable
    # dict_inp["header_liste"] = header_liste
    # dict_inp["data_set_lliste"] = data_lliste
    dict_inp["abfrage_liste"] = abfrage_liste
    dict_inp["title"] = title
    dict_inp["row_color_dliste"] = row_color_dliste
    
    dict_out = gui.abfrage_tabelle(dict_inp)
    
    return (dict_out["index_abfrage"], dict_out["irow_select"], dict_out["data_change_irow_icol_liste"],dict_out["ttable"])
def auswahl_liste(gui,auswahl_liste,titlename):
    '''
    
    :param auswahl_liste:
    :return: (index,choice) = auswahl_depot_kategorie_liste(gui,auswahl_liste)
    '''
    
    
    index = gui.abfrage_liste_index(auswahl_liste,titlename )
    
    if index < 0:
        choice =  ""
    else:
        choice = auswahl_liste[index]
    # endif
    return (index,choice)
# enddef
def auswahl_liste_abfrage_liste(gui, auswahl_liste,abfrage_liste, titlename):
    '''

    :param auswahl_liste:
    :return: (index,choice,indexAbfrage) = abfrage_liste_index_abfrage_index(gui,auswahl_liste)
    '''
    
    
    (index, indexAbfrage) = gui.abfrage_liste_index_abfrage_index(auswahl_liste, abfrage_liste,titlename)
    if index < 0:
        choice = ""
    else:
        choice = auswahl_liste[index]
    # endif
    
    return (index, choice,indexAbfrage)
# enddef
def abfrage_dict(gui,isin_dict,ttilename):
    '''
    
    :param isin_dict:
    :param ttilename:
    :return: isin_result_dict = depot_gui.abfrage_dict(isin_dict,"Edit wp_info(isin)")
    '''
    
    (result_dict, changed_key_liste) = gui.abfrage_dict(isin_dict,ttilename)
    
    return (result_dict, changed_key_liste)
    