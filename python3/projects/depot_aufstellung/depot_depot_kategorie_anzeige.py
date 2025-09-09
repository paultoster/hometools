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
import tools.hfkt_io as hio


import depot_gui
import depot_depot_anzeige_isin

def anzeige_mit_kategorie_wahl(rd):
    '''

    :param rd:
    :return: status =  anzeige_mit_depot_wahl(rd)
    '''
    
    status = hdef.OKAY
    
    # Kontoauswählen
    runflag = True
    while (runflag):
        
        kategorie_liste = get_kategorie_liste(rd)
        
        for i, kategorie in enumerate(kategorie_liste):
            if len(kategorie) == 0:
                kategorie_liste[i] = "leer"
            # end if
        # end for
        
        (index, kategorie) = depot_gui.auswahl_depot_kategorie_liste(kategorie_liste)
        
        
        if index < 0:
            return status
        elif kategorie in kategorie_liste:
            
            rd.log.write(f"depot  \"{kategorie}\" ausgewählt")
            break
        else:
            status = hdef.NOT_OKAY
            errtext = f"Kategorie Auswahl: {kategorie} nicht bekannt"
            rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
            return status
        # endif
    # endwhile
    
    if kategorie == "leer":
        kategorie = ""
    
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
            
            (status,errtext,data_lliste, header_liste, type_liste, row_color_dliste,icol_isin,icol_depot) \
                = get_depot_daten_sets_einer_kategorie(rd,kategorie)
                
            if status != hdef.OKAY:  # Abbruch
                status = status
                rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
                return status
            
            # Overview Anzeigen
            # --------------------------------------
            titlename = f"Alle WPs der kategorie: {kategorie}"
            
            (sw, depot_name,isin) = anzeige_overview(rd, data_lliste, header_liste, icol_isin,icol_depot, titlename, row_color_dliste,kategorie)
            
            if sw < 0:
                runflag = False
            else:   # if sw == 1:
                choice = 1  # auswahl isin
                runflag = True
            # end if
        elif choice == 1:
            
            depot_dict = rd.data[depot_name].ddict
            depot_obj = rd.data[depot_name].obj
            
            print(f"Depot: {depot_name} isin: {isin}")
            pyperclip.copy(isin)
            
            (sw, status) = depot_depot_anzeige_isin.anzeige_depot_isin(rd, isin, depot_obj, depot_dict)
            
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
def get_kategorie_liste(rd):
    '''
    
    :param rd:
    :return: kategorie_liste = get_kategorie_liste(rd)
    '''
    
    kategorie_liste = []
    
    for depot_name in rd.ini.ddict[rd.par.INI_DEPOT_DATA_LIST_NAMES_NAME]:
        kategorie_liste += rd.data[depot_name].obj.get_kategorie_liste()
    # end for
    
    kategorie_liste = list(set(kategorie_liste))
    
    return kategorie_liste
# end def
def get_depot_daten_sets_einer_kategorie(rd,kategorie):
    '''
    
    :param rd:
    :param kategorie:
    :return: (status,errtext,data_lliste, header_liste, type_liste, row_color_dliste,icol_isin)
               = get_depot_daten_sets_einer_kategorie(rd,kategorie)
    '''
    
    status = hdef.OKAY
    errtext = ""
    data_lliste = []
    row_color_dliste = []
    for depot_name in rd.ini.ddict[rd.par.INI_DEPOT_DATA_LIST_NAMES_NAME]:
        
        (data_lliste0, header_liste, type_liste, row_color_dliste0) \
            = rd.data[depot_name].obj.get_depot_daten_sets_overview_kategorie(kategorie)
        
        if rd.data[depot_name].obj.status != hdef.OKAY:
            status = rd.data[depot_name].obj.status
            errtext = rd.data[depot_name].obj.errtext
            rd.data[depot_name].obj.reset_status()
            return (status,errtext,[],[],[],[],-1,"")
        # end if
        
        data_lliste += data_lliste0
        row_color_dliste +=row_color_dliste0
        
        icol_isin = header_liste.index(rd.data[depot_name].obj.par.DEPOT_DATA_NAME_ISIN)
        icol_depot = header_liste.index(rd.data[depot_name].obj.par.DEPOT_DATA_NAME_DEPOT)
    # end for
    
    return (status,errtext,data_lliste, header_liste, type_liste, row_color_dliste,icol_isin,icol_depot)
# end def
def anzeige_overview(rd, data_lliste, header_liste, icol_isin,icol_depot, titlename, row_color_dliste,kategorie):
    '''

    :param data_lliste:
    :param header_liste:
    :return: (sw, isin) = anzeige_overview(data_lliste, header_liste)
    sw = 1  Auswahl isin
       = -1 Ende
    '''
    abfrage_liste = ["ende", "wp auswahl","anzeige csv"]
    i_end = 0
    i_auswahl = 1
    i_csv_anzeige = 2
    runflag = True
    isin = None
    depot = None
    n = len(data_lliste)
    
    while (runflag):
        
        (sw, irow) = depot_gui.depot_overview(header_liste, data_lliste, abfrage_liste, titlename, row_color_dliste)
        
        if sw <= i_end:
            sw = -1
            runflag = False
        elif sw == i_auswahl:
            
            if irow < 0:
                rd.log.write_warn("Keine Zeile ausgewählt", screen=rd.par.LOG_SCREEN_OUT)
                runflag = True
            else:
                isin = data_lliste[irow][icol_isin]
                depot = data_lliste[irow][icol_depot]
                runflag = False
                sw = 1
            # end if
        else: # if sw == i_csv_anzeige
            
            status = anzeige_csv_ausgabe(rd, data_lliste, header_liste, kategorie)
            
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
def anzeige_csv_ausgabe(rd,data_lliste, header_liste,kategorie):
    """

    :param rd:
    :return: status = anzeige_csv_ausgabe(data_lliste, header_liste,kategorie)
    """
    
    status = hdef.OKAY
    errtext = ""
    
    # Filename
    # filename = htime.get_name_by_dat_time(pre_text=f"depot_kategorie_{kategorie}_") + ".csv"
    filename = f"depot_kategorie_{kategorie}_" + ".csv"

    status = hio.write_csv_file_header_data(filename, header_liste, data_lliste, delim=rd.par.CSV_AUSGABE_TRENN_ZEICHEN)
    
    if status != hdef.OKAY:
        rd.log.write_err(f"CSV-Ausgabe von Konto: <{kategorie}> nicht möglich", screen=rd.par.LOG_SCREEN_OUT)
    # else:
    #     rd.log.write_info(f"CSV-Ausgabe von Konto: <{kategorie}> in Datei <{filename}>", screen=rd.par.LOG_SCREEN_OUT)
    # # end if
    
    os.startfile(filename)
    
    return status
# end def




    
    