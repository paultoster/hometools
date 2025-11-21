
import os, sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif


import tools.hfkt_def as hdef
import tools.hfkt_date_time as htime
import tools.hfkt_io as hio

import depot_gui
import depot_konto_reports_read
import depot_konto_anzeige
import depot_konto_kategorie
import depot_konto_kategorie_anzeige

def bearbeiten(rd):
    status = hdef.OKAY
    runflag = True

    start_auswahl = ["Cancel","DataSet csv-Umsatz einlesen","DataSet anzeigen/bearbeiten","DataSet csv-Ausgabe (reopen)" ]
    index_cancel  = 0
    index_read_umsatz  = 1
    index_anzeige = 2
    index_csv_ausgabe = 3
    
    if rd.allg.katfunc is not None:
        start_auswahl.append("Kategorie DataSet")
        start_auswahl.append("Kategorie Auswertung")
    # end if
    index_kategorie = 4
    index_kategorie_auswertung = 5

    while (runflag):

        (index,_) = depot_gui.listen_abfrage(rd.gui,start_auswahl,"Auswahl Konto")
        
        rd.log.write(f"Konto Abfrage  \"{start_auswahl[index]}\" ausgewählt")
        
        if (index == index_cancel) or (index < 0):
            runflag = False
        elif index == index_read_umsatz:
            
            status = depot_konto_read_umsatz(rd)
            runflag = False
            
        elif index == index_anzeige:
            
            status = depot_konto_bearbeiten_anzeige(rd)
            runflag = False

        elif index == index_csv_ausgabe:
    
            status = depot_konto_bearbeiten_csv_ausgabe(rd)
            runflag = False

        elif index == index_kategorie:
        
            status = depot_konto_bearbeiten_kategorie(rd)
        
            runflag = False
        
        elif index == index_kategorie_auswertung:
        
            status = depot_konto_bearbeiten_kategorie_auswertung(rd)
            runflag = False
        
        else:
            errtext = f"Konto Abfrage Auswahl: {index} nicht bekannt"
            rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        #endif

        # # enddef

    # endwhile

    return status
# enddef
def depot_konto_read_umsatz(rd):
    
    (status, choice) = depot_konto_bearbeiten_konto_auswahl(rd)
    
    if status == hdef.OKAY:
        # Konto data in ini
        konto_dict  = rd.konto_dict[choice].data_dict
        konto_obj   = rd.konto_dict[choice].konto_obj
        csv_obj     = rd.csv_dict[rd.ini.ddict[choice][rd.par.INI_IMPORT_CONFIG_TYPE_NAME]].csv_obj

        # Umsatz einelesen
        status = depot_konto_reports_read.report_einlesen(rd,choice,konto_dict,konto_obj,csv_obj)
    # end if
    return status
# end def
def depot_konto_bearbeiten_anzeige(rd):
    """
    
    :param rd:
    :return: status =  depot_konto_bearbeiten_anzeige(rd)
    """
    (status, choice) = depot_konto_bearbeiten_konto_auswahl(rd)
    
    if status == hdef.OKAY:
        # Anzeigen
        (status,konto_obj) = depot_konto_anzeige.anzeige(rd,rd.konto_dict[choice].konto_obj)
        
        rd.konto_dict[choice].konto_obj = konto_obj
    # end if
    
    return status
# end def
def depot_konto_bearbeiten_csv_ausgabe(rd):
    """

    :param rd:
    :return: status
    """
    
    (status,choice) = depot_konto_bearbeiten_konto_auswahl(rd)
    
    if status == hdef.OKAY:
        # Filename
        filename = htime.get_name_by_dat_time(pre_text=f"{choice}_")+".csv"
        
        
        # Konto data in ini
        konto_obj = rd.konto_dict[choice].konto_obj
        
        (ttable, _) = konto_obj.get_anzeige_ttable()
        
        status = hio.write_csv_file_ttable(filename, ttable, delim=rd.par.CSV_AUSGABE_TRENN_ZEICHEN)
        
        if status != hdef.OKAY:
            rd.log.write_err(f"CSV-Ausgabe von Konto: <{choice}> nicht möglich", screen=rd.par.LOG_SCREEN_OUT)
        else:
            rd.log.write_info(f"CSV-Ausgabe von Konto: <{choice}> in Datei <{filename}>", screen=rd.par.LOG_SCREEN_OUT)
        # end if
        
        os.startfile(filename)
    # end if
    return status
# end def
def depot_konto_bearbeiten_kategorie(rd):
    
    (status,choice) = depot_konto_bearbeiten_konto_auswahl(rd)

    if status == hdef.OKAY:
        # Anzeigen und Kategorie bearbeiten
        (status,konto_obj) = depot_konto_kategorie.anzeige(rd,rd.konto_dict[choice].konto_obj)
        
        rd.konto_dict[choice].konto_obj = konto_obj

    return status
# end def
def depot_konto_bearbeiten_kategorie_auswertung(rd):

    # Anzeigen excel
    status = depot_konto_kategorie_anzeige.anzeige(rd)

    return status

def depot_konto_bearbeiten_konto_auswahl(rd):
    
    # Kontoauswählen
    runflag = True
    while (runflag):
        
        (index, choice) = depot_gui.auswahl_konto(rd.gui, rd.ini.ddict[rd.par.INI_KONTO_DATA_LIST_NAMES_NAME])
        
        if index < 0:
            choice = ""
            status = hdef.AT_END
            runflag = False
        elif choice in rd.ini.ddict[rd.par.INI_KONTO_DATA_LIST_NAMES_NAME]:
            status = hdef.OKAY
            rd.log.write(f"konto  \"{choice}\" ausgewählt")
            runflag = False
        else:
            errtext = f"Konto Auswahl: {choice} nicht bekannt"
            rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        # endif
    # endwhile
    
    return (status,choice)
# end def