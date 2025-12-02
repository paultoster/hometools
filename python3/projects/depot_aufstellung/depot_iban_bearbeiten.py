

import os, sys


tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef

import depot_gui

def bearbeiten(rd):
    
    status = hdef.OKAY
    
    
    header_liste = []
    abfrage_liste = ["end", "update edit", "add","delete"]
    i_end = 0
    i_update  = 1
    i_add  = 2
    i_delete = 3
    
    runflag = True
    while (runflag):
        
        (ttable,color_liste) = rd.iban.iban_obj.get_data_table()
        
        (status, errtext, ttable_out, index_abfrage, irow_select,data_change_irow_icol_liste) = \
            depot_gui.iban_abfrage(rd, ttable, abfrage_liste,color_liste)
        
        if (status != hdef.OK):
            rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
            return status
        # end fi

        # Beenden
        #----------------------------
        if( index_abfrage == i_end ):
            runflag = False
        
        # Update des editierten
        # ----------------------------
        elif( index_abfrage == i_update ):
            
            rd.iban.iban_obj.write_anzeige_back_data(ttable_out, data_change_irow_icol_liste)
            
            if (rd.iban.iban_obj.status != hdef.OK):
                rd.log.write_err(rd.iban.iban_obj.errtext, screen=rd.par.LOG_SCREEN_OUT)
                return rd.iban.iban_obj.status
            # end fi
            
            runflag = False
            
        # Hinzufügen
        # ----------------------------
        elif( index_abfrage == i_add ):
            
            tlist = rd.iban.iban_obj.get_extern_default_tlist()
            
            # Erstelle die Eingabe liste
            eingabeListe = tlist.names
            
            titlename = "IBAN hinzufügen"
            
            (tlist_out, change_flag) = depot_gui.iban_data_set_eingabe(rd.gui, tlist,titlename, None)
            
            if change_flag:
                (status, errtext) = rd.iban.iban_obj.add(tlist_out)
                
                if status != hdef.OKAY:
                    rd.log.write_err("konto__anzeige add " + errtext, screen=rd.par.LOG_SCREEN_OUT)
                    return status
                # endif
            # endif
            runflag = True
            
        # Eintrag Löschen
        # ----------------------------
        else:
            if irow_select >= 0:
                (status, errtext) = rd.iban.iban_obj.delete_data_set(irow_select)
                if status != hdef.OK:
                    rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
                    return status
                # end if
            else:
                rd.log.write_warn("Markiere eine Reihe in der TAbelle bevor 'delete'-klicken ",screen=rd.par.LOG_SCREEN_OUT)
            #end if
    
    return status
# enddef