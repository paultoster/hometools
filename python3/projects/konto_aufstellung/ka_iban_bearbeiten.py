

import os, sys


tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import hfkt_def as hdef
import hfkt_log as hlog

import ka_gui
import ka_iban_data

def bearbeiten(rd):
    
    status = hdef.OKAY
    
    
    header_liste = rd.par.IBAN_ITEM_LIST
    abfrage_liste = ["end", "update edit", "add","delete"]
    i_end = 0
    i_update  = 1
    i_add  = 2
    i_delete = 3
    
    runflag = True
    while (runflag):
        
        data_list = rd.data[rd.par.IBAN_DICT_DATA_NAME].ddict[rd.par.IBAN_DATA_LIST_NAME]
        id_max = rd.data[rd.par.IBAN_DICT_DATA_NAME].ddict[rd.par.IBAN_ID_MAX_NAME]

        (d_new,index_abfrage,irow) = ka_gui.iban_abfrage(rd, header_liste, data_list, abfrage_liste)
        
        # Beenden
        #----------------------------
        if( index_abfrage == i_end ):
            runflag = False
        
        # Update des editierten
        # ----------------------------
        elif( index_abfrage == i_update ):
            (status, errtext, rd.data[rd.par.IBAN_DICT_DATA_NAME].ddict[rd.par.IBAN_DATA_LIST_NAME]) \
                = ka_iban_data.iban_mod(data_list,d_new)
            
            if (status != hdef.OK):
                rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
                return status
            # end fi
            
            runflag = False
            
        # Hinzufügen
        # ----------------------------
        elif( index_abfrage == i_add ):
            
            id_max = id_max+1
            (status, errtext,rd.data[rd.par.IBAN_DICT_DATA_NAME].ddict[rd.par.IBAN_DATA_LIST_NAME]) \
                = ka_iban_data.iban_add_data_set(header_liste,data_list,id_max)
        
            if (status != hdef.OK):
                rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
                return status
            else:
                rd.data[rd.par.IBAN_DICT_DATA_NAME].ddict[rd.par.IBAN_ID_MAX_NAME] = id_max
            # end fi
            
        # Eintrag Löschen
        # ----------------------------
        else:
            if irow >= 0:
                
                (status, errtext, rd.data[rd.par.IBAN_DICT_DATA_NAME].ddict[rd.par.IBAN_DATA_LIST_NAME]) \
                    = ka_iban_data.iban_delete_data_set(data_list, irow)
                
                if status != hdef.OK:
                    rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
                    return status
                # end if
            else:
                rd.log.write_warn("Markiere eine Reihe in der TAbelle bevor 'delete'-klicken ",screen=rd.par.LOG_SCREEN_OUT)
            #end if
    
    return status
# enddef