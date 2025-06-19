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

def depot_konto_einlesen(rd):
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
        elif choice in rd.ini.ddict[rd.par.INI_DEPOT_DATA_DICT_NAMES_NAME]:
            
            rd.log.write(f"depot  \"{choice}\" ausgewählt")
            break
        else:
            status = hdef.NOT_OKAY
            errtext = f"Depot Auswahl: {choice} nicht bekannt"
            rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
            return status
        # endif
    # endwhile
    
    # Depot data
    depot_dict  = rd.data[choice].ddict
    depot_obj   = rd.data[choice].obj
    
    # konto_obj set anlegen
    #----------------------
    konto_key = depot_dict[rd.par.INI_DEPOT_KONTO_NAME]
    
    if konto_key not in rd.data:
        status = hdef.NOT_OKAY
        errtext = f"Von Depot Auswahl: {choice} benutztes Konto: {konto_key} ist nicht im data-dict"
        rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        return status
    # end if
    
    depot_obj.update_from_konto_data(rd.data[konto_key].obj)
    
    if len(depot_obj.infotext):
        rd.log.write_info("konto_einlesen: " + depot_obj.infotext, screen=rd.par.LOG_SCREEN_OUT)
        depot_obj.delete_infotext()
    # end if
    
    if depot_obj.status != hdef.OKAY:
        status = hdef.NOT_OKAY
        rd.log.write_err(depot_obj.errtext, screen=rd.par.LOG_SCREEN_OUT)
        return status
    # end if

    return status
# enddef
