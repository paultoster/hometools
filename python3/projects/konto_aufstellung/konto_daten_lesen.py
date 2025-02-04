# Hilfsfunktionen
import hfkt_def as hdef
import hfkt_log as hlog
import sgui

import konto_gui

def konto_daten_lesen(rd):
    """

    :param rd:
    :return: status
    """
    
    status = hdef.OKAY
    errtext = ""
    
    # Kontoauswählen
    runflag = True
    
    while (runflag):
        
        choice = konto_gui.auswahl_konto(rd)
        
        if (choice == rd.ini.ENDE_RETURN_TXT):
            runflag = False
        elif (choice in rd.ini.konto_names):
            
            rd.log.write(f"konto  \"{choice}\" ausgewählt")
            break
        else:
            errtext = f"Auswahl: {choice} nicht bekannt"
            rd.log.write_err(errtext, screen=rd.log.GUI_SCREEN)
        # endif
    # endwhile
    
    # Konto data in ini
    d = rd.ini.konto_data[choice]
    
    # pdf lesen
    if( d[rd.ini.AUSZUGS_TYP_TXT] == rd.ini.PDF_TYPE_TXT):
        
        status = read_pdf(rd,d)
        
    else:
        errtext = f"Der Auszugstype von [{choice}].{rd.ini.AUSZUGS_TYP_TXT} = {d[rd.ini.AUSZUGS_TYP_TXT]} stimmt nicht"
        status  = hdef.NOT_OKAY
    #endif
    
    # proof error
    if( status != hdef.OKAY):
        rd.log.write_err(errtext, screen=rd.log.GUI_SCREEN)
        
    return status
# enddef

#--------------------------------------------------------------------------------
# pdf lesen
#--------------------------------------------------------------------------------
def read_pdf(rd,d):
    """
    
    :param rd:
    :param d:
    :return: status
    """
    status = hdef.OKAY
    
    return status
#enddef