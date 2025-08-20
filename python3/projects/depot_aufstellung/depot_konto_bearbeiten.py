
import os, sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif


import hfkt_def as hdef
import hfkt_date_time as htime
import hfkt_io as hio
import depot_gui
import depot_konto_reports_read
import depot_konto_anzeige

def bearbeiten(rd):
    status = hdef.OKAY
    runflag = True

    start_auswahl = ["Cancel","Umsatz einlesen","DataSet anzeigen/bearbeiten","DataSet csv-Ausgabe" ]
    index_cancel  = 0
    index_read_umsatz  = 1
    index_anzeige = 2
    index_csv_ausgabe = 3
    
    while (runflag):

        (index,_) = depot_gui.listen_abfrage(rd,start_auswahl,"Auswahl Konto")
        
        rd.log.write(f"Konto Abfrage  \"{start_auswahl[index]}\" ausgewählt")
        
        if (index == index_cancel) or (index < 0):
            runflag = False
        elif index == index_read_umsatz:

            status = depot_konto_reports_read.report_einlesen(rd)
            runflag = False
            
        elif index == index_anzeige:
            
            status = depot_konto_anzeige.anzeige_mit_konto_wahl(rd)
            runflag = False
        
        elif index == index_csv_ausgabe:

            status = depot_konto_bearbeiten_csv_ausgabe(rd)
            runflag = False
        else:
            errtext = f"Konto Abfrage Auswahl: {index} nicht bekannt"
            rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        #endif

        # # enddef

    # endwhile

    return status
# enddef
def depot_konto_bearbeiten_csv_ausgabe(rd):
    """

    :param rd:
    :return: status
    """
    
    status = hdef.OKAY
    errtext = ""
    
    # Kontoauswählen
    runflag = True
    while (runflag):
        
        (index, choice) = depot_gui.auswahl_konto(rd)
        
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
    
    
    # Filename
    filename = htime.get_name_by_dat_time(pre_text=f"{choice}_")+".csv"
    
    
    # Konto data in ini
    konto_obj = rd.data[choice].obj
    
    (header_list, data_llist, _) = konto_obj.build_data_table_list_and_color_list()
    
    status = hio.write_csv_file_header_data(filename, header_list, data_llist, delim=rd.par.CSV_AUSGABE_TRENN_ZEICHEN)
    
    if status != hdef.OKAY:
        rd.log.write_err(f"CSV-Ausgabe von Konto: <{choice}> nicht möglich", screen=rd.par.LOG_SCREEN_OUT)
    else:
        rd.log.write_info(f"CSV-Ausgabe von Konto: <{choice}> in Datei <{filename}>", screen=rd.par.LOG_SCREEN_OUT)
    # end if
    
    os.startfile(filename)
    
    return status
# end def
    
