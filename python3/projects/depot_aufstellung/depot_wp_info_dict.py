import os, sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif


import tools.hfkt_def as hdef

import depot_gui

def wp_info_dict_bearbeiten(rd):
    
    status = hdef.OKAY
    
    # get list of isins
    (status,errtext, wpname_isin_dict)         = rd.allg.wpfunc.get_stored_basic_info_wpname_isin_dict()
    
    isin_liste = list(wpname_isin_dict.keys())
    
    auswahl_liste = [isin + " " + wpname_isin_dict[isin] for isin in wpname_isin_dict.keys()]
    
    if status != hdef.OKAY:
        rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        return status
    # end if
    
    abfrage_liste = ["waehle","neu"]
    index_waehle = 0
    index_neu    = 1
    runflag = True
    while runflag:
        
        (index,_,indexAbfrage) = depot_gui.auswahl_liste_abfrage_liste(rd.gui, auswahl_liste,abfrage_liste, "Wähle isin aus")
        
        if index >= 0:
            isin = isin_liste[index]
        else:
            isin = None
        # end if
    
        if indexAbfrage < 0:
            return status
        elif indexAbfrage == index_waehle:
            
            if (index == None) or (index < 0):
                rd.log.write_err("Keine isin ausgewählt", screen=rd.par.LOG_SCREEN_OUT)
                runflag = True
            else:
                status = wp_info_dict_bearbeiten_isin(rd,isin)
                if status != hdef.OKAY:
                    return status
                # end if
                runflag = False
            # end if
        else:  # indexAbfrage == index_neu
            pass
        # end if
    return status
# end def
def wp_info_dict_bearbeiten_isin(rd,isin):
    '''
    
    :param rd:
    :param wp_func:
    :param isin:
    :return: status = wp_info_dict_bearbeiten(rd,wp_func,isin)
    '''
    
    status = hdef.OKAY
    
    (status, errtext, isin_dict) = rd.allg.wpfunc.get_basic_info(isin)
    
    if status != hdef.OKAY:
        rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        return status
    # end if
    
    (isin_result_dict, changed_key_liste) \
        = depot_gui.abfrage_dict(rd.gui,isin_dict,"Edit wp_info(isin)")

    if len(changed_key_liste):
        (status, errtext) = rd.allg.wpfunc.save_basic_info(isin, isin_result_dict)
    # end if
    
    if status != hdef.OKAY:
        rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        return status
    # end if

    return status
# end def
