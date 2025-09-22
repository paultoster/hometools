#
# datensatz anzeigen
#
#
#
import os
import sys
import pyperclip



tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

# Hilfsfunktionen
import tools.hfkt_def as hdef
import tools.hfkt_date_time as hdate
import tools.hfkt_str as hstr
import tools.hfkt_tvar as htvar

import depot_gui
import depot_depot_anzeige_isin


def anzeige_mit_depot_wahl(rd):
    '''
    
    :param rd:
    :return: status =  anzeige_mit_wahl(rd)
    '''

    
    status = hdef.OKAY
    
    # Kontoauswählen
    runflag = True
    while (runflag):
        
        (index, auswahl) = depot_gui.auswahl_depot(rd.gui,rd.ini.ddict[rd.par.INI_DEPOT_DATA_LIST_NAMES_NAME])
        
        if index < 0:
            return status
        elif auswahl in rd.ini.ddict[rd.par.INI_DEPOT_DATA_LIST_NAMES_NAME]:
            
            rd.log.write(f"depot  \"{auswahl}\" ausgewählt")
            break
        else:
            status = hdef.NOT_OKAY
            errtext = f"Depot Auswahl: {auswahl} nicht bekannt"
            rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
            return status
        # endif
    # endwhile
    
    # Konto data in ini
    depot_dict = rd.depot_dict[auswahl].data_dict
    depot_obj  = rd.depot_dict[auswahl].depot_obj
    
    # choice = 0 Zusammenfassung
    #        = 1 Auswahl isin
    #        = 2 toggle
    #        = 3 kategorie
    #        = -1 Ende
    choice = 0 # Zusammenfassung
    runflag = True
    depot_show_type = 1 # 0: alle, 1: nur aktive, 2: inaktive
    
    while runflag:

        if choice < 0:
            return status
        elif choice == 0:
            (ttable,row_color_dliste) = depot_obj.get_depot_daten_sets_overview(depot_show_type)
            if depot_obj.status != hdef.OKAY:  # Abbruch
                status = depot_obj.status
                rd.log.write_err(depot_obj.errtext, screen=rd.par.LOG_SCREEN_OUT)
                depot_obj.reset_status()
                return status
    
            icol_isin = htvar.get_index_from_table(ttable,depot_obj.par.DEPOT_DATA_NAME_ISIN)
    
            # Overview Anzeigen
            #--------------------------------------
            if depot_show_type == 0:
                addtext = "alle WPs"
            elif depot_show_type == 1:
                addtext = "aktive WPs"
            else:
                addtext = "inaktive WPs"
            # end if
            titlename = f"Depot: {depot_obj.get_depot_name()} {addtext}"
            (sw, isin) = anzeige_overview(rd,ttable,icol_isin,titlename,row_color_dliste)
            
            if sw < 0:
                runflag = False
            elif sw == 1:
                choice = 1      # auswahl isin
                runflag = True
            elif sw == 2: # toggle
                depot_show_type += 1
                if depot_show_type > 2:
                    depot_show_type = 0
                choice = 0      # auswahl overview
                runflag = True
            else: # sw == 3
                choice = 3      # auswahl kategorie
                runflag = True

            # end if
        elif choice == 1: # isin spezifisch
            
            print(f"Depot: {auswahl} isin: {isin}")
            pyperclip.copy(isin)
            
            (sw,status) = depot_depot_anzeige_isin.anzeige_depot_isin(rd,isin,depot_obj,depot_dict)

            if sw < 0:
                runflag = False
            else: # if sw == 0: # zurück
                choice = 0
                runflag = True
            # end if
            
        elif choice == 3: # kategorie
            
            kategorie = depot_obj.get_kategorie(isin)
            titlename = depot_obj.get_titlename(isin)
 
            # edit kateorie
            kategorie_liste = depot_gui.konto_depot_kategorie(rd.gui,kategorie, titlename)
            
            if len(kategorie_liste):
                depot_obj.set_kategorie(isin,kategorie_liste[0])
            
            choice = 0
            runflag = True
            
        # end if
        
    # end while
    
    return status
# enddef
def anzeige_overview(rd,ttable, icol_isin,titlename,row_color_dliste):
    '''
    
    :param ttable:
    :return: (sw, isin) = anzeige_overview(data_lliste, header_liste)
    sw = 1  Auswahl isin
       = 2  toggle die Zusammenfassung
       = -1 Ende
    '''
    abfrage_liste = ["ende", "wp auswahl","toggle indepot","edit kategorie"]
    i_end = 0
    i_auswahl = 1
    i_toggle = 2
    # i_kategorie = 3
    runflag = True
    isin    = None
    
    n = ttable.ntable
    
    while (runflag):
        
        (status,errtext,sw,irow) =  depot_gui.depot_overview(rd.gui,ttable, abfrage_liste,titlename,row_color_dliste)
        
        if status != hdef.OKAY:
            rd.log.write_err(errtext,screen=rd.par.LOG_SCREEN_OUT)
            sw = i_end
        # end if

        if sw <= i_end:
            sw = -1
            runflag = False
        elif sw == i_auswahl:
            if irow < 0:
                rd.log.write_warn("Keine Zeile ausgewählt",screen=rd.par.LOG_SCREEN_OUT)
                runflag = True
            elif irow == (n-1):
                rd.log.write_warn("Summen-Zeile ausgewählt",screen=rd.par.LOG_SCREEN_OUT)
                runflag = True
            else:
                isin = data_lliste[irow][icol_isin]
                runflag = False
            # end if
        elif sw == i_toggle:
            sw = 2
            runflag = False
        else:
            
            if irow < 0:
                rd.log.write_warn("Keine Zeile ausgewählt",screen=rd.par.LOG_SCREEN_OUT)
                runflag = True
            elif irow == (n - 1):
                rd.log.write_warn("Summen-Zeile ausgewählt", screen=rd.par.LOG_SCREEN_OUT)
                runflag = True
            else:
                isin = data_lliste[irow][icol_isin]
                runflag = False
                sw = 3
            # end if
        # end if
    # end while
    return (sw, isin)
# end def
def anzeige_isin(rd, data_lliste, header_liste, title,row_color_dliste):
    '''

    :param data_lliste:
    :param header_liste:
    :return: (sw, isin) = anzeige_isin(data_lliste, header_liste,title)
    sw = 1  zurück
       = 2  edit
       = 3  delete
       = -1 Ende
    '''
    abfrage_liste = ["ende", "zurück", "edit","delete","kurs","update(edit)"]
    i_end = 0
    i_zurueck = 1
    i_edit = 2
    i_delete = 3
    i_kurs = 4
    # i_update = 5
    
    runflag = True
    while (runflag):
        
        (sw, irow,changed_pos_list,date_set) = depot_gui.depot_isin(rd.gui,header_liste, data_lliste, abfrage_liste,title,row_color_dliste)
        
        if sw <= i_end:
            sw = -1
            runflag = False
        elif sw == i_zurueck:
            runflag = False
        elif (sw == i_edit) or (sw == i_delete) or (sw == i_kurs):
            if irow < 0:
                rd.log.write_warn("Keine Zeile ausgewählt",screen=rd.par.LOG_SCREEN_OUT)
                runflag = True
            else:
                runflag = False
            # end if
        else: # if sw == i_update
            if len(changed_pos_list) == 0:
                rd.log.write_warn("Keine Daten in Tabelle geändert",screen=rd.par.LOG_SCREEN_OUT)
                runflag = True
            else:
                runflag = False
        # end if
        
    # end while
    return (sw, irow,changed_pos_list,date_set)


# end def
# def anzeige(rd,konto_dict,konto_obj):
#     '''
#
#     :param rd:
#     :param ddict:
#     :return: (status, konto_dict,konto_obj) =  anzeige(rd,konto_dict,konto_obj)
#     '''
#
#     status = hdef.OKAY
#     abfrage_liste = ["vor","zurück","ende", "update edit", "edit","add", "delete"]
#     i_vor = 0
#     i_back = 1
#     i_end = 2
#     i_update = 3
#     i_edit = 4
#     i_add = 5
#     i_delete = 6
#
#     runflag = True
#     istart  = 0
#     dir     = 0
#     while (runflag):
#
#         (istart,header_liste, data_llist, new_data_list) = konto_obj.get_anzeige_data_llist(istart, dir, rd.par.KONTO_SHOW_NUMBER_OF_LINES)
#
#         # color list with new_data_list
#         color_list = []
#         for flag in new_data_list:
#             if flag:
#                 color_list.append(rd.par.COLOR_SHOW_NEW_DATA_SETS)
#             else:
#                 color_list.append("")
#             # end if
#         # end for
#         if len(data_llist):
#             (new_data_llist, index_abfrage, irow, data_changed_pos_list) = \
#                 depot_gui.konto_abfrage(header_liste, data_llist, abfrage_liste, color_list)
#         else:
#             rd.log.write_warn("Noch keine Daten für dieses Konto angelegt, es geht weiter zu Add ",screen=rd.par.LOG_SCREEN_OUT)
#             index_abfrage = i_end
#         # end if
#
#         # Vorblättern
#         # ----------------------------
#         if (index_abfrage == i_vor):
#
#             # Daten updaten
#             if len(data_changed_pos_list) > 0:
#                 konto_obj.write_anzeige_back_data(new_data_llist, data_changed_pos_list, istart)
#
#             # Vorwärts gehen
#             dir = +1
#             runflag = True
#
#         # Zurückblättern
#         # ----------------------------
#         elif (index_abfrage == i_back):
#
#             # Daten updaten
#             if len(data_changed_pos_list) > 0:
#                 konto_obj.write_anzeige_back_data(new_data_llist, data_changed_pos_list,istart)
#
#             # Rückwärts gehen
#             dir = -1
#             runflag = True
#
#         # Beenden
#         # ----------------------------
#         elif (index_abfrage == i_end):
#             runflag = False
#
#         # Updaten
#         # ----------------------------
#         elif (index_abfrage == i_update):
#
#             # Daten updaten
#             if len(data_changed_pos_list) > 0:
#                 konto_obj.write_anzeige_back_data(new_data_llist, data_changed_pos_list,istart)
#                 if status != hdef.OKAY:
#                     rd.log.write_err("konto__anzeige edit " + errtext, screen=rd.par.LOG_SCREEN_OUT)
#                     return (status, konto_dict)
#                 elif not new_data_set_flag:
#                     runflag = False
#                 # endif
#
#             # lösche die Änderungs-Liste
#             konto_obj.delete_new_data_list()
#             runflag = False
#
#         elif index_abfrage == i_edit:
#             if (irow >= 0):
#                 (data_set, header_liste,buchungs_type_list, buchtype_index_in_header_liste) = konto_obj.get_edit_data(irow)
#             else:
#                 rd.log.write_err("konto__anzeige edit: irow out of range ", screen=rd.par.LOG_SCREEN_OUT)
#                 return (hdef.NOT_OK, konto_dict)
#             # endif
#
#             # Erstelle die Eingabe liste
#             eingabeListe = []
#             for i, header in enumerate(header_liste):
#                 if i == buchtype_index_in_header_liste:
#                     eingabeListe.append([header, buchungs_type_list])  # Auswahl ist die buchungs_type_list
#                 else:
#                     eingabeListe.append(header)
#                 # end if
#             # end for
#
#             new_data_list = depot_gui.konto_data_set_eingabe(eingabeListe,data_set)
#
#             if len(new_data_list):
#                 (new_data_set_flag, status, errtext) = konto_obj.set_data_set_extern_liste(new_data_list,irow)
#
#                 if status != hdef.OKAY:
#                     rd.log.write_err("konto__anzeige edit " + errtext, screen=rd.par.LOG_SCREEN_OUT)
#                     return (status, konto_dict)
#                 elif not new_data_set_flag:
#                     runflag = False
#                 # endif
#             # endif
#             dir = 0
#
#         elif index_abfrage == i_add :
#
#             (header_liste, buchungs_type_list,buchtype_index_in_header_liste) = konto_obj.get_data_to_add_lists()
#
#             # Erstelle die Eingabe liste
#             eingabeListe = []
#             for i,header in enumerate(header_liste):
#                 if i == buchtype_index_in_header_liste:
#                     eingabeListe.append([header,buchungs_type_list])  # Auswahl ist die buchungs_type_list
#                 else:
#                     eingabeListe.append(header)
#                 # end if
#             # end for
#
#             new_data_list = depot_gui.konto_data_set_eingabe(eingabeListe)
#             if len(new_data_list):
#                 (new_data_set_flag, status, errtext) = konto_obj.set_one_new_data_set_extern_liste(new_data_list)
#
#                 if status != hdef.OKAY:
#                     rd.log.write_err("konto__anzeige add "+errtext, screen=rd.par.LOG_SCREEN_OUT)
#                     return (status, konto_dict)
#                 elif not new_data_set_flag:
#                     runflag = False
#                 # endif
#             # endif
#             dir = 0
#
#         elif( index_abfrage == i_delete ):
#
#             if( irow >= 0 ):
#                 flag = rd.gui.abfrage_janein(text=f"Soll irow = {irow} (von null gezält) gelöschen werden")
#                 if( flag ):
#                     (status,errtext) = konto_obj.delete_data_list(irow)
#                     if( status != hdef.OKAY ):
#                         rd.log.write_err("konto__anzeige delete " + errtext, screen=rd.par.LOG_SCREEN_OUT)
#                         return (status, konto_dict)
#                     # end if
#                 # end if
#             # end if
#             runflag = True
#             dir = 0
#         else:
#             runflag = False
#     # end while
#
#     return (status, konto_dict,konto_obj)
# # end def
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
