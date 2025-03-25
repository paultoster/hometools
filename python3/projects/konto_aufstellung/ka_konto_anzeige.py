#
# datensatz anzeigen
#
#
#
import os
import sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

# Hilfsfunktionen
import hfkt_def as hdef
import hfkt_date_time as hdate
import hfkt_str as hstr

import ka_gui
import ka_konto_report_read_ing


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
        elif choice in rd.ini.konto_names:
            
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
    ddict = rd.data[choice].ddict
    
    # Anzeige
    (status, ddict) = anzeige(rd,ddict)
    
    if status != hdef.OKAY:  # Abbruch
        return status
    
    # write back modified ddict
    rd.data[choice].ddict = ddict
    
    return status
# enddef

def anzeige(rd,ddict):
    '''
    
    :param rd:
    :param ddict:
    :return: (status, ddict) =  anzeige(rd,ddict)
    '''
    
    header_liste = rd.par.KONTO_DATA_ITEM_LIST
    abfrage_liste = ["vor","zurück","ende", "update edit", "add", "delete"]
    i_vor = 0
    i_back = 1
    i_end = 2
    i_update = 3
    i_add = 4
    i_delete = 5
    
    (istart,iend) = build_range_to_show_dataset(len(ddict[rd.par.KONTO_DATA_SET_NAME]),-1,rd.par.KONTO_SHOW_NUMBER_OF_LINES,1)
    
    runflag = True
    while (runflag):
        
        (data_llist,color_list) = build_data_table_list_and_color_list(rd.par,ddict,istart,iend)
        
        (d_new, index_abfrage, irow) = ka_gui.konto_abfrage(rd, header_liste, data_llist, abfrage_liste, color_list)
        
        # Beenden
        # ----------------------------
        if (index_abfrage == i_end):
            runflag = False
        else:
            runflag = False
    # end while
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


