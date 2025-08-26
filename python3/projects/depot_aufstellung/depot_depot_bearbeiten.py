
import os, sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif


import tools.hfkt_def as hdef

import depot_gui
import depot_depot_read
import depot_depot_anzeige
import depot_depot_kategorie_anzeige
import depot_depot_write

def bearbeiten(rd):
    status = hdef.OKAY
    runflag = True

    start_auswahl = ["Cancel","DepotDatenSet von KontoDaten einlesen","DepotDatenSet anzeigen/bearbeiten","KategorieDatenSet anzeigen/bearbeiten","DepotDatenSet in ods (excel) ausgeben"]
    index_cancel  = 0
    index_read_konto  = 1
    index_anzeige = 2
    index_kategorie_anzeige = 3
    index_ods = 4
    
    while (runflag):

        (index,_) = depot_gui.listen_abfrage(rd,start_auswahl,"Auswahl Depot")
        
        rd.log.write(f"Depot Abfrage  \"{start_auswahl[index]}\" ausgewählt")
        
        if ((index == index_cancel) or (index < 0)):
            runflag = False
        elif (index == index_read_konto):

            status = depot_depot_read.depot_konto_einlesen(rd)
            runflag = False
            
        elif (index == index_anzeige):
            
            status = depot_depot_anzeige.anzeige_mit_depot_wahl(rd)
            runflag = False

        elif (index == index_kategorie_anzeige):
        
            status = depot_depot_kategorie_anzeige.anzeige_mit_kategorie_wahl(rd)
            
            runflag = False
        
        elif (index == index_ods):
            
            status = depot_depot_write.ods_ausgabe_mit_depot_wahl(rd)
            runflag = False
        
        else:
            errtext = f"Depot Abfrage Auswahl: {index} nicht bekannt"
            rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        #endif

        # # enddef

    # endwhile

    return status
# enddef