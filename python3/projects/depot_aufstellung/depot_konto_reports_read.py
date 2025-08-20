#
# reports einlesen
#
# Ing-Bank  ing_bank_giro  =>  type ing_csv
#
import os
import sys

# import pymupdf
import PyPDF2

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

# Hilfsfunktionen
import hfkt_def as hdef
# import hfkt_list as hlist
# import hfkt_type as htype

import sgui

import depot_gui
import depot_konto_anzeige

def report_einlesen(rd):
    """

    :param rd:
    :return: status
    """
    
    status = hdef.OKAY
    errtext = ""
    
    # Kontoauswählen
    runflag = True
    while (runflag):
        
        (index,choice) = depot_gui.auswahl_konto(rd)
        
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
    konto_dict  = rd.data[choice].ddict
    konto_obj   = rd.data[choice].obj
    konto_csv   = rd.data[choice].csv
    
    # csv lesen
    if konto_csv is None:
        rd.log.write_warn(f"Für Konto <{choice}> gibt es keinen import_data_type ", screen=rd.par.LOG_SCREEN_OUT)
        return status
    
    elif( konto_dict[rd.par.INI_IMPORT_DATA_TYPE_NAME] in rd.ini.ddict[rd.par.INI_CSV_IMPORT_TYPE_NAMES_NAME] ):
        
        # csv-Datei auswählen
        filename = sgui.abfrage_file(file_types="*.csv",
                                     comment=f"Wähle ein report von ING-DiBa für den Kontoumsatz von Konto: {choice}",
                                     start_dir=os.getcwd())
        
        if (len(filename) == 0):  # Abbruch
            return status
        # endif
    
        # csv-
        # csv-Daten einlesen
        #--------------------
        (status,errtext,data_matrix,identlist,typelist) = konto_csv.read_data(filename)
        
        if status != hdef.OKAY:
            rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
            return status
        # end if
        
        # eingelsene Daten in konto einsortieren
        #---------------------------------------
        (flag_newdata,status,errtext) = konto_obj.set_new_data(data_matrix,identlist,typelist)
        
        if status != hdef.OKAY:
            rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
            return status
        # end if
        
        if flag_newdata :
            (status,konto_dict,konto_obj) = depot_konto_anzeige.anzeige(rd,konto_dict,konto_obj)
        else:
            rd.log.write_info("Keine neuen Daten eingelesen !!!!", screen=rd.par.LOG_SCREEN_OUT)
        # end if

        if status != hdef.OKAY:  # Abbruch
            return status
        # end if
        
        # write back modified konto_dict
        rd.data[choice].ddict = konto_dict
        rd.data[choice].obj   = konto_obj

    else:
        errtext = f"Der Umsatz data type von [{choice}].{rd.ini.UMSATZ_DATA_TYPE_NAME} = {konto_dict[rd.ini.UMSATZ_DATA_TYPE_NAME]} stimmt nicht"
        rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        status  = hdef.NOT_OKAY
    #endif
        
    return status
# enddef
