#
# report Ing-csv-Daten auslesen
#
#    =>  type und_csv
#
import os
import sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

# Hilfsfunktionen
import hfkt_def as hdef
import hfkt_list as hlist
import hfkt_type as htype
import hfkt_io as hio


def read_csv(rd,konto_dict,filename):
    '''
    
    :param csv_lliste:
    :param header_lliste
    :param filename:
    :return: (status,konto_dict,flag_newdata) = read(rd,konto_dict,filename)
    '''
    status  = hdef.OKAY
    new_data_set_flag = False
    
    
    # read csv-File
    #==============
    csv_lliste = hio.read_csv_file(file_name=filename, delim=";")
    
    if (len(csv_lliste) == 0):
        rd.log.write_err(f"Fehler in read_ing_csv read_csv_file()  filename = {filename}", screen=rd.par.LOG_SCREEN_OUT)
        status = hdef.NOT_OKAY
        return (status,konto_dict,new_data_set_flag)
    # end if
    
    # build header dict names
    #========================
    (status, errtext, header_name_dict) = build_header_name_dict(konto_dict,rd.par)
    if status != hdef.OKAY:
        rd.log.write_err(errtext,screen=rd.par.LOG_SCREEN_OUT)
        return (status, konto_dict, new_data_set_flag)
    # endif
    
    # build buch_type_dict
    #=====================
    (status, errtext, buch_type_dict) = build_buch_type_dict(konto_dict, rd.par)
    if status != hdef.OKAY:
        rd.log.write_err(errtext,screen=rd.par.LOG_SCREEN_OUT)
        return (status, konto_dict, new_data_set_flag)
    # endif

    # konto_start_wert von ini
    konto_start_wert = konto_dict[rd.par.START_WERT_NAME]
    
    # Trennungs zeichen für decimal wert
    if rd.par.INI_KONTO_STR_EURO_TRENN_BRUCH in konto_dict.keys():
        wert_delim = konto_dict[rd.par.INI_KONTO_STR_EURO_TRENN_BRUCH]
    else:
        wert_delim = rd.par.STR_EURO_TRENN_BRUCH_DEFAULT
    # end if
    
    # Trennungszeichen für Tausend
    if rd.par.INI_KONTO_STR_EURO_TRENN_TAUSEND in konto_dict.keys():
        wert_trennt = konto_dict[rd.par.INI_KONTO_STR_EURO_TRENN_TAUSEND]
    else:
        wert_trennt = rd.par.STR_EURO_TRENN_TAUSEN_DEFAULT
    # end if

    # csv-daten einlesen
    #===================
    (new_data_set_flag,status,errtex) =  konto_dict[rd.par.KONTO_DATA_SET_CLASS].read_csv(csv_lliste
                                                                                          ,header_name_dict
                                                                                          , buch_type_dict
                                                                                          , konto_start_wert
                                                                                          , wert_delim
                                                                                          , wert_trennt
                                                                                          , filename)
   
    return (status,konto_dict,new_data_set_flag)
    
#enddef
def build_header_name_dict(konto_dict,par):
    '''
    
    :param konto_dict:
    :param par:
    :return: (status,errtext,header_name_dict) = build_header_name_dict(konto_dict,par)
    '''
    header_name_dict = {}
    status = hdef.OKAY
    errtext = ""
    for key in par.KDSP.KONTO_DATA_HEADER_INI_NAME_DICT.keys():
        # no data
        if (len(par.KDSP.KONTO_DATA_HEADER_INI_NAME_DICT[key]) == 0):
            status = hdef.NOT_OKAY
            errtext = f"par.KONTO_DATA_HEADER_INI_NAME_DICT[{key}] is empty"
            return (status,errtext,header_name_dict)
        elif (par.KDSP.KONTO_DATA_HEADER_INI_NAME_DICT[key] in konto_dict):
            header_name_dict[key] = konto_dict[par.KDSP.KONTO_DATA_HEADER_INI_NAME_DICT[key]]
        else:
            status = hdef.NOT_OKAY
            errtext = f"key =  from par.KONTO_DATA_HEADER_INI_NAME_DICT[{key}] = {par.KDSP.KONTO_DATA_HEADER_INI_NAME_DICT[key]} is not in konto_dict"
            return (status,errtext,header_name_dict)
        # end if
    # end for
    return (status,errtext,header_name_dict)
# end def
def build_buch_type_dict(konto_dict,par):
    '''

    :param konto_dict ist das dictionary vom Konto mit allen Datan
    :param par
    :return: (status,errtext,buch_type_dict) = self.build_buch_type_dict(konto_dict,par)
    '''
    
    status = hdef.OKAY
    errtext = ""
    buch_type_dict = {}
    
    for key in par.KDSP.KONTO_DATA_BUCHTYPE_INI_NAME_DICT.keys():
        
        if (len(par.KDSP.KONTO_DATA_BUCHTYPE_INI_NAME_DICT[key]) == 0):
            status = hdef.NOT_OKAY
            errtext = f"key =  from par.KONTO_DATA_BUCHTYPE_INI_NAME_DICT[{key}] = {par.KDSP.KONTO_DATA_BUCHTYPE_INI_NAME_DICT[key]} is empty"
            return (status,errtext,buch_type_dict)
        elif (par.KDSP.KONTO_DATA_BUCHTYPE_INI_NAME_DICT[key] in konto_dict):
            buch_type_dict[key] = konto_dict[par.KDSP.KONTO_DATA_BUCHTYPE_INI_NAME_DICT[key]]
        else:
            status = hdef.NOT_OKAY
            errtext = f"key =  from par.KONTO_DATA_BUCHTYPE_INI_NAME_DICT[{key}] = {self.par.KDSP.KONTO_DATA_BUCHTYPE_INI_NAME_DICT[key]} is not in konto_dict"
            return (status,errtext,buch_type_dict)
        # end if
    # end for
    return (status,errtext,buch_type_dict)
# end def


def search_header(csv_lliste,header_name_liste,index_konto_dataset_liste,filename):
    '''
    
    :param csv_lliste:
    :param par:
    :return: (okay,errtext,linestartindex,index_lliste) =  search_header(csv_lliste,par,filename):
    '''
    nheader = len(header_name_liste)
    notfound   = True
    header_found_liste = []
    start_index = 0
    index_lliste = []    # liste mit position in csv-datei Spalte und mit index in konto_dataset
    for i,csv_liste in enumerate(csv_lliste):
        
        # for each new line in csv_lliste reset index_liste
        index_lliste = []
        
        # search header_liste in csv_lliste[i] (one line)
        for j,head_name in enumerate(header_name_liste):
            
            if head_name in csv_liste:
                index_lliste.append([csv_liste.index(head_name),index_konto_dataset_liste[j]])
                header_found_liste.append(head_name)
            # end if
        # end for
        
        # if index_liste is full stop for-loop and build start_index (next line)
        if len(index_lliste) == nheader:
            start_index = i+1
            notfound = False
            break
        # end if
    # end fo
    
    if notfound:
        okay = hdef.NOT_OKAY
        item = ""
        for head_name in header_name_liste:
            if head_name not in header_found_liste:
                item = head_name
                break
            # end if
        # end for
        errtext = f"header item: {item} not found in csv_file: {filename}"
        start_index = 0
        index_lliste = []
    else:
        okay = hdef.OKAY
        errtext = ""
        # start_index = start_index
        # index_liste = index_liste
    # end if
    return (okay,errtext,start_index,index_lliste)
# end def
def get_data_from_csv_lliste(csv_lliste,konto_dict,par,linestartindex, index_lliste,filename):
    '''
    
    :param csv_lliste:
    :param linestartindex:
    :param index_lliste:  liste mit position in csv-datei Spalte und mit index in konto_dataset
    :return: (okay, errtext, data_dict_list) = get_data_from_csv_lliste(csv_lliste,konto_dict,par,linestartindex, index_lliste,filename)
    '''
    okay = hdef.OKAY
    errtext = ""
    data_dict_list = []
    n = len(csv_lliste)
    
    for iline in range(linestartindex,n):
        csv_data_liste = csv_lliste[iline]
        nline    = len(csv_data_liste)
        data_dict = {}
        
        for  liste in index_lliste:
            i_csv = liste[0]
            i_dataset = liste[1]
            
            # buchdatum
            if( i_dataset == par.KONTO_DATA_INDEX_BUCHDATUM):
                (okay, wert) = htype.type_proof_dat(csv_data_liste[i_csv])
                if (okay != hdef.OKAY):
                    okay = hdef.NOT_OKAY
                    errtext = f"get_data_from_csv_lliste: error input buchdatum = <{csv_data_liste[i_csv]}> is not valid (iline={iline+1}, file={filename})"
                    return (okay, errtext, data_dict_list)
                else:
                    data_dict[par.KONTO_DATA_ITEM_LIST[i_dataset]] = wert
                # endif
            elif (i_dataset == par.KONTO_DATA_INDEX_WERTDATUM):
                (okay, wert) = htype.type_proof_dat(csv_data_liste[i_csv])
                if (okay != hdef.OKAY):
                    okay = hdef.NOT_OKAY
                    errtext = f"get_data_from_csv_lliste: error input wertdatum = <{csv_data_liste[i_csv]}> is not valid (iline={iline+1}, file={filename})"
                    return (okay, errtext, data_dict_list)
                else:
                    data_dict[par.KONTO_DATA_ITEM_LIST[i_dataset]] = wert
                # endif
            elif (i_dataset == par.KONTO_DATA_INDEX_WER):
                (okay, wert) = htype.type_proof_string(csv_data_liste[i_csv])
                if (okay != hdef.OKAY):
                    okay = hdef.NOT_OKAY
                    errtext = f"get_data_from_csv_lliste: error input wer = <{csv_data_liste[i_csv]}> is not valid (iline={iline+1}, file={filename})"
                    return (okay, errtext, data_dict_list)
                else:
                    data_dict[par.KONTO_DATA_ITEM_LIST[i_dataset]] = wert
                # endif
            elif (i_dataset == par.KONTO_DATA_INDEX_BUCHTYPE):
                (okay, wert) = htype.type_proof_string(csv_data_liste[i_csv])
                if (okay != hdef.OKAY):
                    okay = hdef.NOT_OKAY
                    errtext = f"get_data_from_csv_lliste: error input buchtype = <{csv_data_liste[i_csv]}> is not valid (iline={iline+1}, file={filename})"
                    return (okay, errtext, data_dict_list)
                else:
                    (okay,buchtype) = get_data_buchtype(wert,konto_dict,par)
                    if (okay != hdef.OKAY):
                        okay = hdef.NOT_OKAY
                        errtext = f"get_data_from_csv_lliste: error input buchtype = <{wert}> is not found with keywords (iline={iline+1}, file={filename})"
                        return (okay, errtext, data_dict_list)
                    # end if
                    data_dict[par.KONTO_DATA_ITEM_LIST[i_dataset]] = buchtype
                # end if
            elif i_dataset == par.KONTO_DATA_INDEX_WERT:
                if(par.INI_KONTO_STR_EURO_TRENN_BRUCH in konto_dict):
                    delim = konto_dict[par.INI_KONTO_STR_EURO_TRENN_BRUCH]
                else:
                    delim = par.STR_EURO_TRENN_BRUCH_DEFAULT
                # end if
                if (par.INI_KONTO_STR_EURO_TRENN_TAUSEND in konto_dict):
                    trennt = konto_dict[par.INI_KONTO_STR_EURO_TRENN_TAUSEND]
                else:
                    trennt = par.STR_EURO_TRENN_TAUSEN_DEFAULT
                # end if
                (okay, wert) = htype.type_convert_euro_to_cent(csv_data_liste[i_csv],delim=delim,thousandsign=trennt)
                if (okay != hdef.OKAY):
                    okay = hdef.NOT_OKAY
                    errtext = f"get_data_from_csv_lliste: error input wert = <{csv_data_liste[i_csv]}> is not valid (iline={iline+1}, file={filename})"
                    return (okay, errtext, data_dict_list)
                else:
                    data_dict[par.KONTO_DATA_ITEM_LIST[i_dataset]] = wert
                # endif
            elif i_dataset == par.KONTO_DATA_INDEX_COMMENT:
                (okay, wert) = htype.type_proof_string(csv_data_liste[i_csv])
                if (okay != hdef.OKAY):
                    okay = hdef.NOT_OKAY
                    errtext = f"get_data_from_csv_lliste: error input comment = <{csv_data_liste[i_csv]}> is not valid (iline={iline+1}, file={filename})"
                    return (okay, errtext, data_dict_list)
                else:
                    data_dict[par.KONTO_DATA_ITEM_LIST[i_dataset]] = wert
                # endif
            # end if
        # end for
        data_dict_list.append(data_dict)
    # end for
    
    return (okay, errtext, data_dict_list)
# end def
def get_data_buchtype(wert, konto_dict, par):
    '''
    
    :param wert:
    :param par:
    :return: (okay, buchtype) =  get_data_buchtype(wert, par):
    '''
    
    okay = hdef.OKAY
    not_found = True
    for list in par.KONTO_DATA_BUCHTYPE_LIST:
        if list[0] in konto_dict:
            if isinstance(konto_dict[list[0]],str):
                liste = [konto_dict[list[0]]]
            else:
                liste = konto_dict[list[0]]
            # end if
            
            for item in liste:
                if wert == item:
                    buchtype = list[1]
                    not_found = False
                    break
            # end if
        # end if
    # end for
    if not_found:
        buchtype = par.KONTO_BUCHUNG_UNBEKANNT
        okay = hdef.NOT_OKAY
    # end if
    
    return (okay,buchtype)
    
# end def
def extract_new_data_from_data_dict_list(data_dict_list, par, data_set_lliste):
    '''

    :param data_dict_list:       eingelesene Liste mit dictionary mit neuen Daten
    :param data_set_lliste:   intern gespeicherte Data set list (bisher eingelesenen)
    :return: extract_data_dict_list = extract_new_data_data_lliste(data_lliste, par, data_set_lliste)
    '''
    
    extract_data_dict_list = []
    for data_dict in data_dict_list:
        if data_set_is_not_in_liste(data_dict, par, data_set_lliste):
            extract_data_dict_list.append(data_dict)
        # end if
    # end for

    return extract_data_dict_list
# end def
def data_set_is_not_in_liste(data_dict, par, data_set_lliste):
    '''
    
    :param data_dict:
    :param par:
    :param data_set_lliste:
    :return: yes =  data_set_is_not_in_liste(data_dict, par, data_set_lliste)
    '''
    
    wertdat_new = data_dict[par.KONTO_DATA_ITEM_LIST[par.KONTO_DATA_INDEX_WERTDATUM]]
    wert_new    = data_dict[par.KONTO_DATA_ITEM_LIST[par.KONTO_DATA_INDEX_WERT]]
    comment_new = data_dict[par.KONTO_DATA_ITEM_LIST[par.KONTO_DATA_INDEX_COMMENT]]
    flag = True
    for data_set in data_set_lliste:
        
        wertdat = data_set[par.KONTO_DATA_INDEX_WERTDATUM]
        wert    = data_set[par.KONTO_DATA_INDEX_WERT]
        comment = data_set[par.KONTO_DATA_INDEX_COMMENT]
        
        if( wertdat_new == wertdat and wert_new == wert and comment_new == comment):
            flag = False
            break
        # end if
    # end for
    return flag
# end def

def add_isin_from_text_to_data_set(data_dict_list_to_add,par):
    '''
    
    für die WP Buchungstypen wird die ISIN extrahiert
    
    KONTO_BUCHUNG_WP_KAUF: int       = 4
    KONTO_BUCHUNG_WP_VERKAUF: int    = 5
    KONTO_BUCHUNG_WP_KOSTEN: int     = 6
    KONTO_BUCHUNG_WP_EINNAHMEN:int   = 7
   
    :param data_llist_to_add:
    :return: data_llist_to_add = add_isin_from_text_to_data_set(data_llist_to_add):
    '''
    
    n = len(data_dict_list_to_add)
    for index in range(n):
        
        data_dict = data_dict_list_to_add[index]
        
        if  (data_dict[par.KONTO_DATA_ITEM_LIST[par.KONTO_DATA_INDEX_BUCHTYPE]] == par.KONTO_BUCHUNG_WP_KAUF) or \
            (data_dict[par.KONTO_DATA_ITEM_LIST[par.KONTO_DATA_INDEX_BUCHTYPE]] == par.KONTO_BUCHUNG_WP_VERKAUF) or \
            (data_dict[par.KONTO_DATA_ITEM_LIST[par.KONTO_DATA_INDEX_BUCHTYPE]] == par.KONTO_BUCHUNG_WP_KOSTEN) or \
            (data_dict[par.KONTO_DATA_ITEM_LIST[par.KONTO_DATA_INDEX_BUCHTYPE]] == par.KONTO_BUCHUNG_WP_EINNAHMEN):
            
            (okay,isin) = htype.type_proof(data_dict[par.KONTO_DATA_ITEM_LIST[par.KONTO_DATA_INDEX_COMMENT]],'isin')
            
            if( okay != hdef.OKAY):
                isin = "isinnotfound"
            
            # end if
        else:
            isin = ""
        # end if
        
        data_dict[par.KONTO_DATA_ITEM_LIST[par.KONTO_DATA_INDEX_ISIN]] = isin
        
        data_dict_list_to_add[index] = data_dict
    # endfor
    
    return data_dict_list_to_add
# end def
def add_new_data_in_data_lliste(data_dict_list_to_add, par, konto_dict):
    '''
    KONTO_DATA_INDEX_BUCHDATUM: int = 1
    KONTO_DATA_INDEX_WERTDATUM: int = 2
    KONTO_DATA_INDEX_WER: int       = 3
    KONTO_DATA_INDEX_BUCHTYPE: int  = 4
    KONTO_DATA_INDEX_WERT: int      = 5
    KONTO_DATA_INDEX_COMMENT: int   = 6
    KONTO_DATA_INDEX_ISIN: int      = 7
 
    :param data_dict_list_to_add:
    :param rd:
    :param konto_dict:
    :return: (status, konto_dict, flag_newdata) =  add_new_data_in_data_lliste(data_dict_list_to_add,rd, konto_dict)
    '''
    status = hdef.OKAY
    flag_newdata = False
    
    # sortiere neue Einträge nach buchdatum
    keyname = par.KONTO_DATA_ITEM_LIST[par.KONTO_DATA_INDEX_BUCHDATUM]
    data_dict_list_to_add = hlist.sort_list_of_dict(data_dict_list_to_add, keyname, aufsteigend=1)
    
    idmax = konto_dict[par.KONTO_DATA_ID_MAX_NAME]
    
    # speichere letzen sum wert aus alter Liste
    if( len(konto_dict[par.KONTO_DATA_SET_NAME]) == 0):
        last_sumwert = konto_dict[par.START_WERT_NAME]
    else:
        data_set_list = konto_dict[par.KONTO_DATA_SET_NAME][-1]
        last_sumwert  = data_set_list[par.KONTO_DATA_INDEX_SUMWERT]
    # end if
    
    for data_dict in data_dict_list_to_add:
        idmax += 1
        data_set_list = []
        
        # par.KONTO_DATA_INDEX_ID:
        data_set_list.append(idmax)
        
        index_liste = \
            [par.KONTO_DATA_INDEX_BUCHDATUM
            , par.KONTO_DATA_INDEX_WERTDATUM
            , par.KONTO_DATA_INDEX_WER
            , par.KONTO_DATA_INDEX_BUCHTYPE
            , par.KONTO_DATA_INDEX_WERT]
        
        for index in index_liste:
            data_set_list.append(data_dict[par.KONTO_DATA_ITEM_LIST[index]])
        
        # par.KONTO_DATA_INDEX_SUMWERT:
        last_sumwert += data_set_list[-1]
        data_set_list.append(int(last_sumwert))
        
        index_liste = \
            [par.KONTO_DATA_INDEX_COMMENT
            , par.KONTO_DATA_INDEX_ISIN]
        
        for index in index_liste:
            data_set_list.append(data_dict[par.KONTO_DATA_ITEM_LIST[index]])
            
        # par.KONTO_DATA_INDEX_KATEGORIE
        data_set_list.append("")
        
        konto_dict[par.KONTO_DATA_SET_NAME].append(data_set_list)
        konto_dict[par.KONTO_DATA_ID_NEW_LIST].append(idmax)
        flag_newdata = True
    # end for
    konto_dict[par.KONTO_DATA_ID_MAX_NAME] = idmax
    return (status, konto_dict, flag_newdata)
# end def

        

    