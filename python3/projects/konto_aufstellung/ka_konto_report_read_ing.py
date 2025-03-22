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
import hfkt_str as hstr
import hfkt_type as htype
import hfkt_io as hio


def read_csv(rd,d,filename):
    '''
    
    :param csv_lliste:
    :param header_lliste
    :param filename:
    :return: (status,d) = read(rd,d,filename)
    '''
    status  = hdef.OKAY
    data_dict_list = {}
    
    # read csv-File
    #==============
    csv_lliste = hio.read_csv_file(file_name=filename, delim=";")
    
    if (len(csv_lliste) == 0):
        rd.log.write_err(f"Fehler in read_ing_csv read_csv_file()  filename = {filename}", screen=rd.par.LOG_SCREEN_OUT)
        status = hdef.NOT_OKAY
        return (status,data_dict_list)
    # end if
    
    # build header_liste from ini-File
    header_liste = []
    for head_name in rd.par.INI_KONTO_HEADER_NAME_LIST:
        if( head_name in d.keys() ):
            header_liste.append(d[head_name])
        else:
            rd.log.write_err(f"Fehler in building hear_liste header name: {head_name} not found in ini-File for konto  {d['name']} ",
                             screen=rd.par.LOG_SCREEN_OUT)
            status = hdef.NOT_OKAY
            return (status, data_dict_list)
        # end if
    # end for
    
    # Suche header-Zeile
    #-----------------------------
    (okay, errtext, linestartindex, index_liste) = search_header(csv_lliste, header_liste , filename)

    if okay != hdef.OKAY:
        rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        status = hdef.NOT_OKAY
        return (status, data_dict_list)
    # end if

    # get data from csv lliste mit linestartindex, index_liste
    #-----------------------------
    (okay, errtext, data_dict_list) = get_data_from_csv_lliste(csv_lliste,d,rd.par,linestartindex, index_liste, filename)

    # Fehler
    if okay != hdef.OKAY:
        rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        status = hdef.NOT_OKAY
        return (status, data_dict_list)
    # end if
    
    # extract new data from data_llist with d[rd.par.KONTO_DATA_ID_MAX_NAME
    data_dict_list_to_add = extract_new_data_from_data_dict_list(data_dict_list, rd.par,d[rd.par.KONTO_DATA_SET_NAME])
    
    data_dict_list_to_add = add_isin_from_text_to_data_set(data_dict_list_to_add,rd.par)
    
    # add new found data into d and modify idmax in d
    (status, d) = add_new_data_in_data_lliste(data_dict_list_to_add, rd.par, d)
    
    return (status,d)
    
#enddef
def search_header(csv_lliste,header_liste,filename):
    '''
    
    :param csv_lliste:
    :param header_liste:
    :return: (okay,errtext,linestartindex,index_liste) =  search_header(csv_lliste,header_lliste,filename):
    '''
    nheader = len(header_liste)
    notfound   = True
    header_found_liste = []
    start_index = 0
    index_liste = []
    for i,liste in enumerate(csv_lliste):
        
        # for each new line in csv_lliste reset index_liste
        index_liste = []
        
        # search header_liste in csv_lliste[i] (one line)
        for j,head_name in enumerate(header_liste):
            
            if head_name in liste:
                index_liste.append(liste.index(head_name))
                header_found_liste.append(head_name)
            # end if
        # end for
        
        # if index_liste is full stop for-loop and build start_index (next line)
        if len(index_liste) == nheader:
            start_index = i+1
            notfound = False
            break
        # end if
    # end fo
    
    if notfound:
        okay = hdef.NOT_OKAY
        item = ""
        for head_name in header_liste:
            if head_name not in header_found_liste:
                item = head_name
                break
            # end if
        # end for
        errtext = f"header item: {item} not found in csv_file: {filename}"
        start_index = 0
        index_liste = []
    else:
        okay = hdef.OKAY
        errtext = ""
        # start_index = start_index
        # index_liste = index_liste
    # end if
    return (okay,errtext,start_index,index_liste)
# end def
def get_data_from_csv_lliste(csv_lliste,d,par,linestartindex, index_liste,filename):
    '''
    
    :param csv_lliste:
    :param linestartindex:
    :param index_liste:
    :return: (okay, errtext, data_dict_list) = get_data_from_csv_lliste(csv_lliste,d,par,linestartindex, index_liste)
    '''
    okay = hdef.OKAY
    errtext = ""
    data_dict_list = []
    n = len(csv_lliste)
    
    for iline in range(linestartindex,n):
        csv_data = csv_lliste[iline]
        nline    = len(csv_data)
        data_dict = {}
        index      = -1
        for j in index_liste:
            index += 1
            # convertion
            
            # buchdatum
            if( index == par.KONTO_DATA_INDEX_BUCHDATUM):
                (okay, wert) = htype.type_proof_dat(csv_data[j])
                if (okay != hdef.OKAY):
                    okay = hdef.NOT_OKAY
                    errtext = f"get_data_from_csv_lliste: error input buchdatum = <{csv_data[j]}> is not valid (iline={iline}, file={filename})"
                    return (okay, errtext, data_dict_list)
                else:
                    data_dict[par.KONTO_DATA_ITEM_LIST[par.KONTO_DATA_INDEX_BUCHDATUM]] = wert
                # endif
            elif (index == par.KONTO_DATA_INDEX_WERTDATUM):
                (okay, wert) = htype.type_proof_dat(csv_data[j])
                if (okay != hdef.OKAY):
                    okay = hdef.NOT_OKAY
                    errtext = f"get_data_from_csv_lliste: error input wertdatum = <{csv_data[j]}> is not valid (iline={iline}, file={filename})"
                    return (okay, errtext, data_dict_list)
                else:
                    data_dict[par.KONTO_DATA_ITEM_LIST[par.KONTO_DATA_INDEX_WERTDATUM]] = wert
                # endif
            elif (index == par.KONTO_DATA_INDEX_WER):
                (okay, wert) = htype.type_proof_string(csv_data[j])
                if (okay != hdef.OKAY):
                    okay = hdef.NOT_OKAY
                    errtext = f"get_data_from_csv_lliste: error input wer = <{csv_data[j]}> is not valid (iline={iline}, file={filename})"
                    return (okay, errtext, data_dict_list)
                else:
                    data_dict[par.KONTO_DATA_ITEM_LIST[par.KONTO_DATA_INDEX_WER]] = wert
                # endif
            elif (index == par.KONTO_DATA_INDEX_BUCHTYPE):
                (okay, wert) = htype.type_proof_string(csv_data[j])
                if (okay != hdef.OKAY):
                    okay = hdef.NOT_OKAY
                    errtext = f"get_data_from_csv_lliste: error input buchtype = <{csv_data[j]}> is not valid (iline={iline}, file={filename})"
                    return (okay, errtext, data_dict_list)
                else:
                    (okay,buchtype) = get_data_buchtype(wert,d,par)
                    if (okay != hdef.OKAY):
                        okay = hdef.NOT_OKAY
                        errtext = f"get_data_from_csv_lliste: error input buchtype = <{wert}> is not found with keywords (iline={iline}, file={filename})"
                        return (okay, errtext, data_dict_list)
                    # end if
                    data_dict[par.KONTO_DATA_ITEM_LIST[par.KONTO_DATA_INDEX_BUCHTYPE]] = buchtype
                # end if
            elif index == par.KONTO_DATA_INDEX_WERT:
                # (okay, wert) = htype.type_proof_euro(csv_data[j])
                (okay, wert) = htype.type_convert_euro_to_cent(csv_data[j])
                if (okay != hdef.OKAY):
                    okay = hdef.NOT_OKAY
                    errtext = f"get_data_from_csv_lliste: error input wert = <{csv_data[j]}> is not valid (iline={iline}, file={filename})"
                    return (okay, errtext, data_dict_list)
                else:
                    data_dict[par.KONTO_DATA_ITEM_LIST[par.KONTO_DATA_INDEX_WERT]] = wert
                # endif
            elif index == par.KONTO_DATA_INDEX_COMMENT:
                (okay, wert) = htype.type_proof_string(csv_data[j])
                if (okay != hdef.OKAY):
                    okay = hdef.NOT_OKAY
                    errtext = f"get_data_from_csv_lliste: error input comment = <{csv_data[j]}> is not valid (iline={iline}, file={filename})"
                    return (okay, errtext, data_dict_list)
                else:
                    data_dict[par.KONTO_DATA_ITEM_LIST[par.KONTO_DATA_INDEX_COMMENT]] = wert
                # endif
            # end if
        # end for
        data_dict_list.append(data_dict)
    # end for
    
    return (okay, errtext, data_dict_list)
# end def
def get_data_buchtype(wert, d, par):
    '''
    
    :param wert:
    :param par:
    :return: (okay, buchtype) =  get_data_buchtype(wert, par):
    '''
    
    okay = hdef.OKAY
    not_found = True
    for list in par.KONTO_DATA_BUCHTYPE_LIST:
        if list[0] in d:
            if isinstance(d[list[0]],str):
                liste = [d[list[0]]]
            else:
                liste = d[list[0]]
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
def add_new_data_in_data_lliste(data_dict_list_to_add, par, d, filename):
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
    :param d:
    :param filename:
    :return: (status, d) =  add_new_data_in_data_lliste(data_dict_list_to_add,rd, d, filename)
    '''
    status = hdef.OKAY
    idmax = d[par.KONTO_DATA_ID_MAX_NAME]
    for data_dict in data_dict_list_to_add:
        idmax += 1
        data_set = []
        # par.KONTO_DATA_INDEX_ID:
        data_set.append(idmax)
        
        index_liste = \
            [par.KONTO_DATA_INDEX_BUCHDATUM
            , par.KONTO_DATA_INDEX_WERTDATUM
            , par.KONTO_DATA_INDEX_WER
            , par.KONTO_DATA_INDEX_BUCHTYPE
            , par.KONTO_DATA_INDEX_WERT
            , par.KONTO_DATA_INDEX_COMMENT
            , par.KONTO_DATA_INDEX_ISIN]
        
        for index in index_liste:
            data_set.append(data_dict[par.KONTO_DATA_ITEM_LIST[index]])
            
        d[par.KONTO_DATA_SET_NAME].append(data_set)
    # end for
    d[par.KONTO_DATA_ID_MAX_NAME] = idmax
    return (status, d)
# end def

        

    