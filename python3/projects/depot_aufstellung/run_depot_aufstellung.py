#
# run koonto Aufstellung ka
#
# rd.log
# rd.data
# rd.ini
#

import os, sys
from dataclasses import dataclass, field

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import depot_par
import depot_ini_file
import depot_data_init
import depot_base



# Hilfsfunktionen
import tools.hfkt_def as hdef
import tools.hfkt_log as hlog
# import tools.hfkt_pickle as hpickle
import tools.sgui_protocol_class as sgui_prot

# import wp_abfrage.wp_base as wp_base

@dataclass
class RootData:
    gui = None
    par: depot_par.Parameter = field(default_factory=depot_par.Parameter)
    log: hlog.log = field(default_factory=hlog.log)
    ini: depot_ini_file.ini = field(default_factory=depot_ini_file.ini)
    allg = None
    iban = None
    konto_dict: dict = field(default_factory=dict)
    depot_dict: dict = field(default_factory=dict)
    
    


def depot_aufstellung(log_filename,ini_filename):

    rd = RootData

    rd.gui = sgui_prot.SguiProtocol()

    # Log-File start
    rd.log = hlog.log(log_filename,rd.gui)
    #-------------------------------
    if (rd.log.state != hdef.OK):
        print("Logfile not working !!!!")
        return
    # endif
        
    # read ini-File
    # --------------
    rd.par = depot_par.get(rd.log)
    rd.ini = depot_ini_file.ini(rd.par,ini_filename)
    depot_base.print_some_ini_ddict_parameter(rd.par,rd.ini.ddict)

    if (rd.ini.status != hdef.OK):
        rd.log.write_err(rd.ini.errtext, screen=rd.par.LOG_SCREEN_OUT)
        return
    # end if
    
    # set protocol
    rd.gui.set_protcol_type_file(rd.ini.ddict[rd.par.INI_PROTOCOL_TYPE_NAME] \
                                ,rd.ini.ddict[rd.par.INI_PROTOCOL_FILE_NAME] \
                                ,True)
    
    # set parameter from ini
    rd.par.LOG_SCREEN_OUT = rd.ini.ddict[rd.par.INI_LOG_SCREEN_OUT_NAME]
    
    
    # # wp funktion wert papier rd.ini.ddict["wp_abfrage"]["store_path"]
    # rd.wpfunc = wp_base.WPData(rd.ini.ddict[rd.par.INI_WP_DATA_STORE_PATH_NAME]
    #                          ,rd.ini.ddict[rd.par.INI_WP_DATA_USE_JSON_NAME])
    # if (rd.wpfunc.status != hdef.OK):
    #     rd.log.write_err(rd.wpfunc.errtext, screen=rd.par.LOG_SCREEN_OUT)
    #     return
    # # endif

    # data_base
    # -----------
    rd.allg = None
    rd.iban = None
    rd.konto_dict = {}
    rd.csv_dict = {}
    rd.depot_dict = {}
    (status, errtext) = depot_data_init.data_set(rd)

    if (status != hdef.OK):
        rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        return
    # endif

    # id consistency check
    #---------------------
    (status, errtext) = depot_base.rd_consistency_check(rd)
    if (status != hdef.OK):
        rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        return
    # endif
    
    depot_base.first_question_loop(rd)

    # close log-file
    rd.log.close()
    
    # close protokoll
    rd.gui.save()
    
    return
    
# enddef
if __name__ == '__main__':
    
    if (len(sys.argv) > 1) and isinstance(sys.argv[1],str):
        if sys.argv[1].lower() == "depot":
            switch = 0
        else: # "konto"
            switch = 1
        # end if
    else:
        switch = 1
    # end if
    
    if switch == 1:
        WORKING_DIRECTORY = "K:/data/orga/Otnok"
        LOG_FILE_NAME = "konto_aufstellung.log"
        INI_FILE_NAME = "konto_aufstellung.ini"
    else:
        WORKING_DIRECTORY = "K:/data/orga/Toped"
        LOG_FILE_NAME = "depot_aufstellung.log"
        INI_FILE_NAME = "depot_aufstellung.ini"
    # end if
    # chnage to directory of data-Files
    os.chdir(WORKING_DIRECTORY)
    
    depot_aufstellung(LOG_FILE_NAME,INI_FILE_NAME)

    print(f"Ende siehe logfile: {os.path.join(WORKING_DIRECTORY, LOG_FILE_NAME)}")

# endif
