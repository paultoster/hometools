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
import tools.hfkt_def as hdef
# import hfkt_list as hlist
# import hfkt_type as htype
import depot_depot_anzeige

import depot_gui
# import depot_konto_anzeige

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
        
        (index,choice) = depot_gui.auswahl_depot(rd.gui,rd.ini.ddict[rd.par.INI_DEPOT_DATA_LIST_NAMES_NAME])
        
        if index < 0:
            return status
        elif choice in rd.ini.ddict[rd.par.INI_DEPOT_DATA_LIST_NAMES_NAME]:
            
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
    # depot_dict  = rd.depot_dict[choice].data_dict
    # depot_obj   = rd.depot_dict[choice].depot_obj
    
    konto_name = rd.depot_dict[choice].depot_obj.get_konto_name()
    flag_changed = rd.depot_dict[choice].depot_obj.update_from_konto_data(rd.konto_dict[konto_name].konto_obj)
    
    if len(rd.depot_dict[choice].depot_obj.infotext):
        rd.log.write_info("konto_einlesen: " + rd.depot_dict[choice].depot_obj.infotext, screen=rd.par.LOG_SCREEN_OUT)
        rd.depot_dict[choice].depot_obj.delete_infotext()
    # end if
    
    if rd.depot_dict[choice].depot_obj.status != hdef.OKAY:
        status = hdef.NOT_OKAY
        rd.log.write_err(rd.depot_dict[choice].depot_obj.errtext, screen=rd.par.LOG_SCREEN_OUT)
        return status
    elif flag_changed:
        status = depot_depot_anzeige.anzeige_depot(rd,choice,rd.depot_dict[choice].data_dict
                                                   ,rd.depot_dict[choice].depot_obj,True)
    # end if

    return status
# enddef
