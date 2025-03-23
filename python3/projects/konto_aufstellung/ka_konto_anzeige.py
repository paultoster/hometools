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
import sgui

import ka_gui
import ka_konto_report_read_ing


def anzeige_mit_wahl(rd):
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

def anzeige(rd,ddict)
    '''
    
    :param rd:
    :param ddict:
    :return: (status, ddict) =  anzeige(rd,ddict)
    '''
    
    header_liste = rd.par.KONTO_DATA_ITEM_LIST
    abfrage_liste = ["vor","zurück","ende", "update edit", "add", "delete"]
    i_end = 0
    i_update = 1
    i_add = 2
    i_delete = 3
    
    .append(data_set)
    ddict[par.KONTO_DATA_ID_NEW_LIST].append(idmax)
    
    (istart,iend) = build_range_to_show_dataset(len(ddict[rd.par.KONTO_DATA_SET_NAME]),-1,rd.par.KONTO_SHOW_NUMBER_OF_LINES,1)
    
    runflag = True
    while (runflag):
        
        (data_llist,color_list) = build_table_list(rd,ddict,istart,iend)
        id_max = rd.data[rd.par.IBAN_DATA_DICT_NAME].ddict[rd.par.IBAN_DATA_ID_MAX_NAME]
        
        (d_new, index_abfrage, irow) = ka_gui.iban_abfrage(rd, header_liste, data_llist, abfrage_liste)
        
        # Beenden
        # ----------------------------
        if (index_abfrage == i_end):
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
def build_table_list(rd, ddict, istart, iend):
    '''
    
    :param rd:
    :param ddict:
    :param istart:
    :param iend:
    :return: (data_llist, color_list) = build_table_list(rd, ddict, istart, iend)
    '''
    
    
    data_llist = []
    color_list =
    for
    
    
# end def

