
import os, sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif


import hfkt_def as hdef
import hfkt_log as hlog
import sgui
import ka_gui
import ka_konto_reports_read
import ka_konto_anzeige

def bearbeiten(rd):
    status = hdef.OKAY
    runflag = True

    start_auswahl = ["Cancel","Umsatz einlesen","DataSet anzeigen" ]
    index_cancel  = 0
    index_read_umsatz  = 1
    index_anzeige = 2
    
    while (runflag):

        index = ka_gui.listen_abfrage(rd,start_auswahl,"Auswahl Konto")
        
        rd.log.write(f"Konto Abfrage  \"{start_auswahl[index]}\" ausgewählt")
        
        if ((index == index_cancel) or (index < 0)):
            runflag = False
        elif (index == index_read_umsatz):

            status = ka_konto_reports_read.report_einlesen(rd)
            runflag = False
            
        elif(index == index_anzeige):
            
            status = ka_konto_anzeige.anzeige_mit_wahl(rd)
            runflag = False
            
        else:
            errtext = f"Konto Abfrage Auswahl: {index} nicht bekannt"
            rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        #endif

        # # enddef

    # endwhile

    return status
# enddef