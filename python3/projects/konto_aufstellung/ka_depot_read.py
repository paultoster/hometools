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

import ka_gui
import ka_konto_anzeige

def konto_einlesen(rd):
    """

    :param rd:
    :return: status
    """
    
    status = hdef.OKAY
    errtext = ""
    
    # Depot auswählen
    runflag = True
    while (runflag):
        
        (index,choice) = ka_gui.auswahl_depot(rd)
        
        if index < 0:
            return status
        elif choice in rd.ini.konto_names:
            
            rd.log.write(f"depot  \"{choice}\" ausgewählt")
            break
        else:
            status = hdef.NOT_OKAY
            errtext = f"Depot Auswahl: {choice} nicht bekannt"
            rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
            return status
        # endif
    # endwhile
    
    # Konto data in ini
    depot_dict  = rd.data[choice].ddict
    depot_obj   = rd.data[choice].obj


    return status
# enddef
