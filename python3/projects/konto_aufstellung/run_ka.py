#
# run koonto Aufstellung ka
#

import os, sys
from dataclasses import dataclass, field

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

LOG_FILE_NAME = "ka.log"
INI_FILE_NAME = "ka.ini"



import ka_ini_file
import ka_data_pickle
import ka_konto_bearbeiten as kb
import ka_iban_bearbeiten as ib
import ka_gui


# Hilfsfunktionen
import hfkt_def as hdef
import hfkt_log as hlog



@dataclass
class RootData:
    log: hlog.log = field(default_factory=hlog.log)
    ini: ka_ini_file.ini_file = field(default_factory=ka_ini_file.ini_file)
    data: dict = field(default_factory=dict)


def konto_auswerten():

    rd = RootData

    # Lof-File start
    rd.log = hlog.log(LOG_FILE_NAME)
    #-------------------------------
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
    

    runflag = True

    start_auswahl = ["Ende","Iban","Konto" ]
    index_ende  = 0
    index_iban  = 1
    index_konto = 2

    while (runflag):

        index = ka_gui.listen_abfrage(rd,start_auswahl,"Startauswahl")

        if ((index == index_ende) or (index < 0)):
            runflag = False
        elif (index == index_konto):

            rd.log.write(f"Start Abfrage  \"{start_auswahl[index]}\" ausgewählt")
            status = kb.bearbeiten(rd)

            if (status != hdef.OKAY):
                runflag = False
            # endif
        elif (index == index_iban):

            rd.log.write(f"Start Abfrage  \"{start_auswahl[index]}\" ausgewählt")
            status = ib.bearbeiten(rd)

            if (status != hdef.OKAY):
                runflag = False
            # endif
        else:
            errtext = f"Auswahl: {index} nicht bekannt"
            rd.log.write_err(errtext, screen=rd.log.GUI_SCREEN)
        #endif

        # # enddef

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
