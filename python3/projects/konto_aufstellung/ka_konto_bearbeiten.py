
import os, sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import ka_konto_reports_read as ka_konto_read

import hfkt_def as hdef
import hfkt_log as hlog
import sgui
import ka_gui
import ka_konto_reports_read

def bearbeiten(rd):
    status = hdef.OKAY
    runflag = True

    start_auswahl = ["Cancel","lese_umsatz" ]
    index_cancel  = 0
    index_read_umsatz  = 1
    
    while (runflag):

        index = ka_gui.listen_abfrage(rd,start_auswahl,"Auswahl Konto")

        if ((index == index_cancel) or (index < 0)):
            runflag = False
        elif (index == index_read_umsatz):

            rd.log.write(f"Konto Abfrage  \"{start_auswahl[index]}\" ausgewählt")
            status = ka_konto_reports_read.report_einlesen(rd)
            runflag = False
        else:
            errtext = f"Konto Abfrage Auswahl: {index} nicht bekannt"
            rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        #endif

        # # enddef

    # endwhile

    return status
# enddef