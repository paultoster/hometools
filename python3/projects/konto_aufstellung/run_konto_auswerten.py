#

import os, sys
from dataclasses import dataclass, field

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

LOG_FILE_NAME = "konto_aufstellung.log"
INI_FILE_NAME = "konto_aufstellung.ini"



import konto_aufstellung_ini_file as ka_ini_file
import konto_aufstellung_data_pickle as ka_data_pickle
import konto_reports_einlesen as kr_lesen
import konto_gui


# Hilfsfunktionen
import hfkt_def as hdef
import hfkt_log as hlog
import sgui



@dataclass
class RootData:
    log: hlog.log = field(default_factory=hlog.log)
    ini: ka_ini_file.ini_file = field(default_factory=ka_ini_file.ini_file)
    data: dict = field(default_factory=dict)


def konto_auswerten():

    rd = RootData
    

        
    rd.log = hlog.log(LOG_FILE_NAME)
        
    if (rd.log.state != hdef.OK):
        print("Logfile not working !!!!")
        return
    # endif
        
    # read ini-File
    # --------------
    rd.ini = ka_ini_file.ini_file(INI_FILE_NAME)

    if (rd.ini.status != hdef.OK):
        rd.log.write_err(rd.ini.errtext, screen=rd.log.GUI_SCREEN)
        return
    # endif
        
    # data_base
    # -----------
    (status, errtext, rd.data) = ka_data_pickle.data_get(rd.ini)

    if (status != hdef.OK):
        rd.log.write_err(errtext, screen=rd.log.GUI_SCREEN)
        return
    # endif
    
        # enddef

    runflag = True

    while (runflag):
        
        choice = konto_gui.bearbeitung_konto(rd)

        if (choice == rd.ini.ENDE_RETURN_TXT):
            runflag = False
        elif( choice == rd.ini.KONTO_DATEN_LESEN_TXT):
            
            rd.log.write(f"konto  \"{choice}\" ausgewählt")
            status= kr_lesen.report_einlesen(rd)
            
            if( status != hdef.OKAY ):
                break
            #endif
        else:
            errtext = f"Auswahl: {choice} nicht bekannt"
            rd.log.write_err(errtext, screen=rd.log.GUI_SCREEN)
        #endif
        
    # endwhile
    

    (status, errtext) = ka_data_pickle.data_save(rd.data)

    if (status != hdef.OK):
        rd.log.write_err(errtext, screen=rd.log.GUI_SCREEN)
        # endif

    # close log-file
    rd.log.close()

    return
    
# enddef


if __name__ == '__main__':
    
    konto_auswerten()

    print(f"Ende siehe logfile: {LOG_FILE_NAME}")

# endif
