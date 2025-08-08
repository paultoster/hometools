#
# datensatz anzeigen
#
#
#
import os
import sys

import sgui

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

# Hilfsfunktionen
import hfkt_def as hdef
import hfkt_date_time as hdate
import hfkt_str as hstr
import hfkt_type as htype

import ka_gui


def anzeige_mit_konto_wahl(rd):
    '''
    
    :param rd:
    :return: status =  anzeige_mit_wahl(rd)
    '''

    
    status = hdef.OKAY
    
    # Kontoauswählen
    runflag = True
    while (runflag):
        
        (index, choice) = ka_gui.auswahl_konto(rd)
        
        if index < 0:
            return status
        elif choice in rd.ini.ddict[rd.par.INI_KONTO_DATA_DICT_NAMES_NAME]:
            
            rd.log.write(f"konto  \"{choice}\" ausgewählt")
            break
        else:
            status = hdef.NOT_OKAY
            errtext = f"Konto Auswahl: {choice} nicht bekannt"
            rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
            return status
        # endif
    # endwhile
    
    # Konto data in ini
    konto_dict = rd.data[choice].ddict
    konto_obj  = rd.data[choice].obj
    
    # Anzeigen
    (status, konto_dict,konto_obj) = anzeige(rd,konto_dict,konto_obj)
    
    if status != hdef.OKAY:  # Abbruch
        return status
    
    # write back modified ddict
    rd.data[choice].ddict = konto_dict
    rd.data[choice].obj   = konto_obj
    
    return status
# enddef

def anzeige(rd,konto_dict,konto_obj):
    '''
    
    :param rd:
    :param ddict:
    :return: (status, konto_dict,konto_obj) =  anzeige(rd,konto_dict,konto_obj)
    '''
    
    status = hdef.OKAY
    abfrage_liste = ["vor","zurück","ende", "update(edit)","update(isin)", "edit","edit(isin)","add", "delete"]
    i_vor = 0
    i_back = 1
    i_end = 2
    i_update = 3
    i_update_isin = 4
    i_edit = 5
    i_edit_isin = 6
    i_add = 7
    i_delete = 8
    
    runflag = True
    istart  = 1000000
    dir     = 0
    while (runflag):
        
        (istart,header_liste, data_llist, new_data_list) = konto_obj.get_anzeige_data_llist(istart, dir, rd.par.KONTO_SHOW_NUMBER_OF_LINES)
        
        # color list with new_data_list
        color_list = []
        for flag in new_data_list:
            if flag:
                color_list.append(rd.par.COLOR_SHOW_NEW_DATA_SETS)
            else:
                color_list.append("")
            # end if
        # end for
        if len(data_llist):
            (new_data_llist, index_abfrage, irow, data_changed_pos_list) = \
                ka_gui.konto_abfrage(header_liste, data_llist, abfrage_liste, color_list)
        else:
            rd.log.write_warn("Noch keine Daten für dieses Konto angelegt, es geht weiter zu Add ",screen=rd.par.LOG_SCREEN_OUT)
            index_abfrage = i_end
        # end if
        
        # Vorblättern
        # ----------------------------
        if (index_abfrage == i_vor):
            
            # Daten updaten
            if len(data_changed_pos_list) > 0:
                konto_obj.write_anzeige_back_data(new_data_llist, data_changed_pos_list, istart)
                
            # Vorwärts gehen
            dir = +1
            runflag = True
        
        # Zurückblättern
        # ----------------------------
        elif (index_abfrage == i_back):
            
            # Daten updaten
            if len(data_changed_pos_list) > 0:
                konto_obj.write_anzeige_back_data(new_data_llist, data_changed_pos_list,istart)
            
            # Rückwärts gehen
            dir = -1
            runflag = True
        
        # Beenden
        # ----------------------------
        elif (index_abfrage == i_end):
            runflag = False
        
        # Updaten
        # ----------------------------
        elif (index_abfrage == i_update):
            
            # Daten updaten
            if len(data_changed_pos_list) > 0:
                konto_obj.write_anzeige_back_data(new_data_llist, data_changed_pos_list,istart)
                if konto_obj.status != hdef.OKAY:
                    rd.log.write_err("konto_anzeige update " + konto_obj.errtext, screen=rd.par.LOG_SCREEN_OUT)
                    return (status, konto_dict,konto_obj)
                else:
                    if len(konto_obj.infotext):
                        rd.log.write_info("konto_anzeige update " + konto_obj.infotext, screen=rd.par.LOG_SCREEN_OUT)
                    # end if
                    runflag = False
                # endif

            # lösche die Änderungs-Liste
            konto_obj.delete_new_data_list()
            runflag = True
        
        
        # Updaten isin
        # ----------------------------
        elif index_abfrage == i_update_isin:
            
            konto_obj.update_isin_find()
            
            if konto_obj.status != hdef.OKAY:
                rd.log.write_err("konto_anzeige update isin " + konto_obj.errtext, screen=rd.par.LOG_SCREEN_OUT)
                return (status, konto_dict, konto_obj)
            
            runflag = True
            
        elif index_abfrage == i_edit:
            
            if (irow >= 0):
                (data_set, header_liste,buchungs_type_list, buchtype_index_in_header_liste) = konto_obj.get_edit_data(irow)
            else:
                rd.log.write_err("konto__anzeige edit: irow out of range ", screen=rd.par.LOG_SCREEN_OUT)
                return (hdef.NOT_OK, konto_dict,konto_obj)
            # endif

            
            new_data_list = ka_gui.konto_depot_data_set_eingabe(header_liste,buchtype_index_in_header_liste,buchungs_type_list,data_set)
            
            if len(new_data_list):
                (new_data_set_flag, status, errtext) = konto_obj.set_data_set_extern_liste(new_data_list,irow)
                
                if status != hdef.OKAY:
                    rd.log.write_err("konto__anzeige edit " + errtext, screen=rd.par.LOG_SCREEN_OUT)
                    return (status, konto_dict,konto_obj)
                # endif
            # endif
            dir = 0
            runflag = True
        elif index_abfrage == i_edit_isin:
            
            if (irow >= 0):
                (data_set, header_liste, buchungs_type_list, buchtype_index_in_header_liste) = konto_obj.get_edit_data(
                    irow)
            else:
                rd.log.write_err("konto__anzeige edit: irow out of range ", screen=rd.par.LOG_SCREEN_OUT)
                return (hdef.NOT_OK, konto_dict, konto_obj)
            # endif
            
            # Erstelle die Eingabe liste
            eingabeListe = []
            vorgabeListe = []
            
            # wpname
            #-----------------------------------------------------------------------------------------------------------
            eingabeListe.append("möglich. wpname")
            index = header_liste.index(konto_obj.KONTO_DATA_NAME_COMMENT)
            vorgabeListe.append(data_set[index])

            (okay, wkn, isin_comment) = konto_obj.search_wkn_from_comment(data_set[index])

            # isin
            #-----------------------------------------------------------------------------------------------------------
            eingabeListe.append("möglich. isin")
            index_isin = header_liste.index(konto_obj.KONTO_DATA_NAME_ISIN)
            isin       = data_set[index_isin]
            if (len(isin) == 0) and (okay == hdef.OKAY):
                (okay, value) = htype.type_proof_isin(isin_comment)
                if okay == hdef.OKAY:
                    isin = value
            # end if
            
            vorgabeListe.append(isin)
            
            # wkn
            #-----------------------------------------------------------------------------------------------------------
            eingabeListe.append("möglich. wkn")
            
            if len(wkn):
                vorgabeListe.append(wkn)
            else:
                vorgabeListe.append("")
                
                
            # Daten in den title
            data_title = ""
            for d in data_set:
                (okay,dstr) = htype.type_proof_string(d)
                if okay == hdef.OKAY:
                    data_title += "|"+dstr
                # end fi
            # end for
            
            # Abfrage
            #-----------------------------------------------------------------------------------------------------------
            ergebnisListe = ka_gui.konto_isin_wkn_set_eingabe(eingabeListe, vorgabeListe
                                                          ,title=f"{data_title} wpnname,isin und wkn ausfüllen (wpnname,isin evt. leer, kein EIntrag)")
            # Daten übernehmen
            #-----------------------------------------------------------------------------------------------------------
            flag = False
            if len(ergebnisListe):
                wpname = ergebnisListe[0]
                isin   = ergebnisListe[1]
                wkn    =  ergebnisListe[2]
                
                if len(isin):
                    status = rd.wpfunc.update_isin_w_wpname_wkn(isin,wpname,wkn)
                # end if
                
                # isin
                if( (status == hdef.OKAY) and len(isin) and (data_set[index_isin] != isin)):
                    flag = True
                    data_set[index_isin] = ergebnisListe[1]
                # end if
                
            # update dateset
            if flag:
                (new_data_set_flag, status, errtext) = konto_obj.set_data_set_extern_liste(data_set, irow)
                
                if status != hdef.OKAY:
                    rd.log.write_err("konto__anzeige edit isin" + errtext, screen=rd.par.LOG_SCREEN_OUT)
                    return (status, konto_dict, konto_obj)
                # endif
            # endif
            dir = 0
            runflag = True
        elif index_abfrage == i_add :
            
            (header_liste, buchungs_type_list,buchtype_index_in_header_liste) = konto_obj.get_data_to_add_lists()
            
            # Erstelle die Eingabe liste
            eingabeListe = []
            for i,header in enumerate(header_liste):
                if i == buchtype_index_in_header_liste:
                    eingabeListe.append([header,buchungs_type_list])  # Auswahl ist die buchungs_type_list
                else:
                    eingabeListe.append(header)
                # end if
            # end for
            
            titlename = konto_obj.get_titlename()
            
            
            new_data_list = ka_gui.konto_depot_data_set_eingabe(header_liste, buchtype_index_in_header_liste,
                                                                buchungs_type_list,None,titlename)
                        
            if len(new_data_list):
                (new_data_set_flag, status, errtext) = konto_obj.set_one_new_data_set_extern_liste(new_data_list)
                
                if status != hdef.OKAY:
                    rd.log.write_err("konto__anzeige add "+errtext, screen=rd.par.LOG_SCREEN_OUT)
                    return (status, konto_dict,konto_obj)
                # endif
            # endif
            dir = 0
            runflag = True
        elif( index_abfrage == i_delete ):
            
            if( irow >= 0 ):
                flag = sgui.abfrage_janein(text=f"Soll irow = {irow} (von null gezält) gelöschen werden")
                if( flag ):
                    (status,errtext) = konto_obj.delete_data_list(irow)
                    if( status != hdef.OKAY ):
                        rd.log.write_err("konto__anzeige delete " + errtext, screen=rd.par.LOG_SCREEN_OUT)
                        return (status, konto_dict,konto_obj)
                    # end if
                # end if
            # end if
            runflag = True
            dir = 0
        else:
            runflag = True
    # end while
    
    return (status, konto_dict,konto_obj)
# end def
def build_range_to_show_dataset(nlines,istart,nshow,dir):
    '''
    
    :param nlines:  maximale Anzahl an Zeilen
    :param istart:  letzte startzeile (-1 ist beginn)
    :param nshow:   Wieviele Zeile zeigen
    :param dir:     -1 zurück, +1 vorwärts
    :return:     (istart,iend) = build_range_to_show_dataset(nlines,istart,nshow,dir)
    '''
    if istart < 0 : # Start with newest part
        istart = max(0,nlines - nshow)
    elif dir > 0:
        istart = min(istart + nshow,max(0,nlines - nshow))
    else:
        istart = max(istart - nshow,0)
    # endif
    iend = min(istart + nshow - 1, max(0, nlines - 1))
    return (istart,iend)
# end def
def build_data_table_list_and_color_list(par, ddict, istart, iend):
    '''
    
    :param rd:
    :param ddict:
    :param istart:
    :param iend:
    :return: (data_llist, color_list) = build_data_table_list_and_color_list(rd, ddict, istart, iend)
    '''
    
    
    data_llist = []
    color_list = []
    n = len(ddict[par.KONTO_DATA_SET_NAME])
    index = istart
    while (index <= iend) and (index<n):
        data_list = []
        data_set_list = ddict[par.KONTO_DATA_SET_NAME][index]
        # 1) id
        data_list.append(data_set_list[par.KONTO_DATA_INDEX_ID])
        # 2)    KONTO_DATA_INDEX_BUCHDATUM
        data_list.append(hdate.secs_time_epoch_to_str(data_set_list[par.KONTO_DATA_INDEX_BUCHDATUM]))
        # 3)    KONTO_DATA_INDEX_WERTDATUM
        data_list.append(hdate.secs_time_epoch_to_str(data_set_list[par.KONTO_DATA_INDEX_WERTDATUM]))
        # 4)    KONTO_DATA_INDEX_WER:
        data_list.append(data_set_list[par.KONTO_DATA_INDEX_WER])
        # 5)    KONTO_DATA_INDEX_BUCHTYPE
        data_list.append(par.KONTO_BUCHUNGS_TEXT_LIST[data_set_list[par.KONTO_DATA_INDEX_BUCHTYPE]])
        # 6)    KONTO_DATA_INDEX_WERT:
        data_list.append(hstr.convert_int_cent_to_string_euro(data_set_list[par.KONTO_DATA_INDEX_WERT]))
        # 7)    KONTO_DATA_INDEX_SUMWERT
        data_list.append(hstr.convert_int_cent_to_string_euro(data_set_list[par.KONTO_DATA_INDEX_SUMWERT]))
        # 8)    KONTO_DATA_INDEX_COMMENT
        data_list.append(data_set_list[par.KONTO_DATA_INDEX_COMMENT])
        # 9)    KONTO_DATA_INDEX_ISIN
        data_list.append(data_set_list[par.KONTO_DATA_INDEX_ISIN])
        # 10)    KONTO_DATA_INDEX_KATEGORIE
        data_list.append(data_set_list[par.KONTO_DATA_INDEX_KATEGORIE])
        
        # add to llist
        data_llist.append(data_list)

        # color list
        if data_set_list[par.KONTO_DATA_INDEX_ID] in ddict[par.KONTO_DATA_ID_NEW_LIST]:
            color_list.append(par.COLOR_SHOW_NEW_DATA_SETS)
        else:
            color_list.append("")
        # end if
        
        index += 1
    # end while
    
    return (data_llist, color_list)
# end def
def write_back_data(par,d_new_llist,data_changed_pos_list,istart,ddict):
    '''
    
    :param par:
    :param d_new_llist:
    :param data_changed_pos_list:
    :param istart:
    :param ddict:
    :return: ddict =  write_back_data(par,d_new_llist,data_changed_pos_list,istart,ddict)
    '''
    
    wert_changed = False
    for (irow,icol) in data_changed_pos_list:
        
        if (icol != par.KONTO_DATA_INDEX_ID) and (icol != par.KONTO_DATA_INDEX_BUCHTYPE) and \
            (icol != par.KONTO_DATA_INDEX_COMMENT) and (icol != par.KONTO_DATA_INDEX_SUMWERT):
            
            ddict[par.KONTO_DATA_SET_NAME][istart+irow][icol] = d_new_llist[irow][icol]
            
            if (icol == par.KONTO_DATA_INDEX_WERT):
                wert_changed = True
        # end if
    # end for
    
    if wert_changed:
        if istart == 0:
            sumwert = ddict[par.START_WERT_NAME]
        else:
            sumwert = ddict[par.KONTO_DATA_SET_NAME][istart-1][par.KONTO_DATA_INDEX_SUMWERT]
        # end if
        
        i = istart
        n = len(ddict[par.KONTO_DATA_SET_NAME])
        while( i < n ):
            
            sumwert += ddict[par.KONTO_DATA_SET_NAME][i][par.KONTO_DATA_INDEX_WERT]
            
            ddict[par.KONTO_DATA_SET_NAME][i][par.KONTO_DATA_INDEX_SUMWERT] = int(sumwert)
            
            i += 1
        # end while
    # end if
    
    return ddict
# end def
