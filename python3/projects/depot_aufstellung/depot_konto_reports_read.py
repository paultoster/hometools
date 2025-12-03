#
# reports einlesen
#
# Ing-Bank  ing_bank_giro  =>  type ing_csv
#
import os
import sys

# import pymupdf
# import PyPDF2

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

# Hilfsfunktionen
import tools.hfkt_def as hdef
# import hfkt_list as hlist
# import hfkt_type as htype

import tools.sgui as sgui

import depot_gui
import depot_konto_anzeige

def report_einlesen(rd,choice,konto_dict,konto_obj,csv_obj):
    """

    :param rd:
    :return: status
    """
    
    status = hdef.OKAY
    
    # csv lesen
    if csv_obj is None:
        rd.log.write_warn(f"Für Konto <{choice}> gibt es keinen import_data_config ", screen=rd.par.LOG_SCREEN_OUT)
        return status
    
    else:  # if( konto_dict[rd.par.INI_IMPORT_CONFIG_TYPE_NAME] in rd.ini.ddict[rd.par.INI_CSV_IMPORT_TYPE_NAMES_NAME] ):
        
        start_pfad = csv_obj.get_csv_datei_pfad()
        if not os.path.isdir(start_pfad):
            start_pfad = os.getcwd()
        # end if
        
        # csv-Datei auswählen
        filename = rd.gui.abfrage_file(file_types="*.csv",
                                     comment=f"Wähle ein report von ING-DiBa für den Kontoumsatz von Konto: {choice}",
                                     start_dir=start_pfad)
        
        if (len(filename) == 0):  # Abbruch
            return status
        # endif
    
        # csv-
        # csv-Daten einlesen
        #--------------------
        (status,errtext,ttable,flag_proof_wert) = csv_obj.read_data(filename)
        
        if status != hdef.OKAY:
            rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
            return status
        # end if
        
        # eingelsene Daten in konto einsortieren
        #---------------------------------------
        # print(f"{choice =}: {rd.konto_dict[choice].konto_obj =} ; {hex(id(rd.konto_dict[choice].konto_obj))}")
        # print(f"{choice =}: {konto_obj =} ; {hex(id(konto_obj))}")

        (flag_newdata,status,errtext,infotext) = konto_obj.set_new_data(ttable,flag_proof_wert)
        
        if status != hdef.OKAY:
            rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
            return status
        # end if
        if len(infotext):
            rd.log.write_info(infotext, screen=rd.par.LOG_SCREEN_OUT)
        # end if
        if flag_newdata :
            
            konto_obj.kategorie_regel_anwenden()
            
            if konto_obj.status != hdef.OKAY:
                rd.log.write_err("konto_kategorie regel anwenden" + konto_obj.errtext, screen=rd.par.LOG_SCREEN_OUT)
                return konto_obj.status
            else:
                if len(konto_obj.infotext):
                    rd.log.write_info("konto_kategorie regel anwenden" + konto_obj.infotext, screen=rd.par.LOG_SCREEN_OUT)
                # end if
            # endif
            
            (status,konto_obj) = depot_konto_anzeige.anzeige(rd,konto_obj)
        # end if

        if status != hdef.OKAY:  # Abbruch
            return status
        # end if
        
        # write back modified konto_dict
        rd.konto_dict[choice].data_dict   = konto_dict
        rd.konto_dict[choice].konto_obj   = konto_obj

    #endif
        
    return status
# enddef
