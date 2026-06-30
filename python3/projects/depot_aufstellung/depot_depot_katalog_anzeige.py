#
# datensatz anzeigen
#
#
#
import os
import sys
import pyperclip

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

# Hilfsfunktionen
import tools.hfkt_def as hdef
import tools.hfkt_io as hio
import tools.hfkt_tvar as htvar


import depot_gui
import depot_depot_anzeige_isin

def anzeige_mit_katalog_wahl(rd):
    '''

    :param rd:
    :return: status =  anzeige_mit_katalog_wahl(rd)
    '''
    
    status = hdef.OKAY
    
    # Kontoauswählen
    runflag = True
    while (runflag):
        
        katalog_liste = get_katalog_liste(rd)
        
        for i, katalog in enumerate(katalog_liste):
            if len(katalog) == 0:
                katalog_liste[i] = "leer"
            # end if
        # end for
        
        (index, katalog) = depot_gui.auswahl_liste(rd.gui,katalog_liste,"Katalog auswählen")
        
        
        if index < 0:
            return status
        elif katalog in katalog_liste:
            
            rd.log.write(f"depot  \"{katalog}\" ausgewählt")
            break
        else:
            status = hdef.NOT_OKAY
            errtext = f"Katalog Auswahl: {katalog} nicht bekannt"
            rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
            return status
        # endif
    # endwhile
    
    if katalog == "leer":
        katalog = ""
    
    # choice = 0 Zusammenfassung
    #        = 1 Auswahl isin
    #        = 2 csv-Anzeige
    #        = -1 Ende
    choice = 0  # Zusammenfassung
    runflag = True
    depot_name = None
    while runflag:
        
        if choice < 0:
            return status
        elif choice == 0:
            
            (status,errtext,ttable, row_color_dliste,icol_isin,icol_depot) \
                = get_depot_daten_sets_einer_katalog(rd,katalog)
                
            if status != hdef.OKAY:  # Abbruch
                status = status
                rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
                return status
            
            # Overview Anzeigen
            # --------------------------------------
            titlename = f"Alle WPs der katalog: {katalog}"
            
            (sw, depot_name,isin) = anzeige_overview(rd, ttable, icol_isin,icol_depot, titlename, row_color_dliste,katalog)
            
            if sw < 0:
                runflag = False
            else:   # if sw == 1:
                choice = 1  # auswahl isin
                runflag = True
            # end if
        elif choice == 1:
            
            depot_dict = rd.depot_dict[depot_name].data_dict
            depot_obj = rd.depot_dict[depot_name].depot_obj
            
            print(f"Depot: {depot_name} isin: {isin}")
            pyperclip.copy(isin)
            
            (sw, status) = depot_depot_anzeige_isin.anzeige_depot_isin(rd, isin, depot_obj)
            
            if sw < 0:
                runflag = False
            else: # if sw == 0:  # zurück
                choice = 0
                runflag = True
            # end if
        # end if
    # end while
    
    return status
# end def
def get_katalog_liste(rd):
    '''
    
    :param rd:
    :return: katalog_liste = get_katalog_liste(rd)
    '''
    
    katalog_liste = []
    
    for depot_name in rd.ini.ddict[rd.par.INI_DEPOT_DATA_LIST_NAMES_NAME]:
        katalog_liste += rd.depot_dict[depot_name].depot_obj.get_katalog_liste()
    # end for
    
    katalog_liste = list(set(katalog_liste))
    
    return katalog_liste
# end def
def get_depot_daten_sets_einer_katalog(rd,katalog):
    '''
    
    :param rd:
    :param katalog:
    :return: (status,errtext,data_lliste, header_liste, type_liste, row_color_dliste,icol_isin)
               = get_depot_daten_sets_einer_katalog(rd,katalog)
    '''
    
    status = hdef.OKAY
    errtext = ""
    ttable = None
    row_color_dliste = []
    for depot_name in rd.ini.ddict[rd.par.INI_DEPOT_DATA_LIST_NAMES_NAME]:
        
        (ttable0, row_color_dliste0) \
            = rd.depot_dict[depot_name].depot_obj.get_depot_daten_sets_overview_katalog(katalog)
        
        if rd.depot_dict[depot_name].depot_obj.status != hdef.OKAY:
            status = rd.depot_dict[depot_name].depot_obj.status
            errtext = rd.depot_dict[depot_name].depot_obj.errtext
            rd.depot_dict[depot_name].depot_obj.reset_status()
            return (status,errtext,[],[],[],[],-1,"")
        # end if
        if ttable is None:
            ttable = ttable0
        else:
            ttable = htvar.add_table_to_table(ttable,ttable0)
        # end if
        row_color_dliste += row_color_dliste0                

        icol_isin = htvar.get_index_from_table(ttable,rd.depot_dict[depot_name].depot_obj.par.DEPOT_DATA_NAME_ISIN)
        icol_depot = htvar.get_index_from_table(ttable,rd.depot_dict[depot_name].depot_obj.par.DEPOT_DATA_NAME_DEPOT)
    # end for
    
    return (status,errtext,ttable, row_color_dliste,icol_isin,icol_depot)
# end def
def anzeige_overview(rd, ttable, icol_isin,icol_depot, titlename, row_color_dliste,katalog):
    '''

    :param data_lliste:
    :param header_liste:
    :return: (sw, isin) = anzeige_overview(data_lliste, header_liste)
    sw = 1  Auswahl isin
       = -1 Ende
    '''
    abfrage_liste = ["ende", "wp auswahl","csv(reopen)"]
    i_end = 0
    i_auswahl = 1
    i_csv_anzeige = 2
    runflag = True
    isin = None
    depot = None
    n = ttable.ntable
    
    while (runflag):
        
        (status,errtext,sw, irow) = depot_gui.depot_overview(rd.gui,ttable, abfrage_liste, titlename, row_color_dliste)

        if status != hdef.OKAY:
            rd.log.write_err(errtext,screen=rd.par.LOG_SCREEN_OUT)
            sw = i_end
        # end if

        if sw <= i_end:
            sw = -1
            runflag = False
        elif sw == i_auswahl:
            
            if irow < 0:
                rd.log.write_warn("Keine Zeile ausgewählt", screen=rd.par.LOG_SCREEN_OUT)
                runflag = True
            else:
                isin = htvar.get_val_from_table(ttable,irow,icol_isin)
                depot = htvar.get_val_from_table(ttable,irow,icol_depot)
                runflag = False
                sw = 1
            # end if
        else: # if sw == i_csv_anzeige
            
            status = anzeige_csv_ausgabe(rd, ttable, katalog)
            
            if status != hdef.OKAY:
                sw = -1
                runflag = False
            else:
                sw = 0
                runflag = True
            # end if
        # end if
    # end while
    return (sw, depot,isin)
# end def
def anzeige_csv_ausgabe(rd,ttable,katalog):
    """

    :param rd:
    :return: status = anzeige_csv_ausgabe(ttable,katalog)
    """
    
    status = hdef.OKAY
    errtext = ""
    
    # Filename
    # filename = htime.get_name_by_dat_time(pre_text=f"depot_katalog_{katalog}_") + ".csv"
    filename = f"depot_katalog_{katalog}_" + ".csv"

    status = hio.write_csv_file_ttable(filename, ttable, delim=rd.par.CSV_AUSGABE_TRENN_ZEICHEN)
    
    if status != hdef.OKAY:
        rd.log.write_err(f"CSV-Ausgabe von Konto: <{katalog}> nicht möglich", screen=rd.par.LOG_SCREEN_OUT)
    # else:
    #     rd.log.write_info(f"CSV-Ausgabe von Konto: <{katalog}> in Datei <{filename}>", screen=rd.par.LOG_SCREEN_OUT)
    # # end if
    
    os.startfile(filename)
    
    return status
# end def




    
    