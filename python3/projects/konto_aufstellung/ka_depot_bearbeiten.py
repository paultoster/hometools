
import os, sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif


import hfkt_def as hdef
import hfkt_log as hlog
import sgui
import ka_gui
import ka_depot_read
import ka_depot_anzeige

def bearbeiten(rd):
    status = hdef.OKAY
    runflag = True

    start_auswahl = ["Cancel","Daten von Konto einlesen","DataSet anzeigen/bearbeiten" ]
    index_cancel  = 0
    index_read_konto  = 1
    index_anzeige = 2
    
    while (runflag):

        (index,_) = ka_gui.listen_abfrage(rd,start_auswahl,"Auswahl Depot")
        
        rd.log.write(f"Depot Abfrage  \"{start_auswahl[index]}\" ausgewählt")
        
        if ((index == index_cancel) or (index < 0)):
            runflag = False
        elif (index == index_read_konto):

            status = ka_depot_read.konto_einlesen(rd)
            runflag = False
            
        elif(index == index_anzeige):
            
            status = ka_depot_anzeige.anzeige_mit_depot_wahl(rd)
            runflag = False
            
        else:
            errtext = f"Depot Abfrage Auswahl: {index} nicht bekannt"
            rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        #endif

        # # enddef

    # endwhile

    return status
# enddef