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

WORKING_DIRECTORY = "K:/data/orga/Toped"
LOG_FILE_NAME = "depot_aufstellung.log"
INI_FILE_NAME = "depot_aufstellung.ini"


import depot_par
import depot_ini_file
import depot_data_init
import depot_konto_bearbeiten as kb
import depot_iban_bearbeiten as ib
import depot_depot_bearbeiten as db
import depot_gui
import depot_konto_data_set_class as dkonto



# Hilfsfunktionen
import tools.hfkt_def as hdef
import tools.hfkt_log as hlog
import tools.hfkt_pickle as hpickle
import tools.sgui_protocol_class as sgui_prot


import wp_abfrage.wp_base as wp_base





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
    
    


def depot_aufstellung():

    rd = RootData

    rd.gui = sgui_prot.SguiProtocol()

    # Log-File start
    rd.log = hlog.log(LOG_FILE_NAME,rd.gui)
    #-------------------------------
    if (rd.log.state != hdef.OK):
        print("Logfile not working !!!!")
        return
    # endif
        
    # read ini-File
    # --------------
    rd.par = depot_par.get(rd.log)
    rd.ini = depot_ini_file.ini(rd.par,INI_FILE_NAME)
    print_some_ini_ddict_parameter(rd.par,rd.ini.ddict)

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
    (status, errtext) = rd_consistency_check(rd)
    if (status != hdef.OK):
        rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        return
    # endif
    


    runflag = True

    start_auswahl = ["Cancel (no save)","Ende","Save","Iban","Konto","Depot"]
    index_cancel_no_save  = 0
    index_ende    = 1
    index_save    = 2
    index_iban    = 3
    index_konto   = 4
    index_depot   = 5
    save_flag = True
    abfrage_liste = ["okay","cancel","ende"]
    i_abfrage_okay = 0
    i_abfrage_cancel = 1
    i_abfrage_ende = 2

    while (runflag):
        
        save_flag = True
        (index,indexAbfrage) = depot_gui.listen_abfrage(rd.gui,start_auswahl,"Startauswahl",abfrage_liste)
        
        if indexAbfrage < 0:
            index = -1
        elif indexAbfrage == i_abfrage_cancel:
            index = index_cancel_no_save
        elif indexAbfrage == i_abfrage_ende:
            index = index_ende
        
        if index < 0: # cancel button
            runflag = True
        elif index == index_cancel_no_save:
            
            flag = depot_gui.janein_abfrage(rd.gui, "Soll wirklich nicht gespeichert werden?", "Nicht Speichern ja/nein")
            if flag:
                runflag = False
                save_flag = False
            # end if
        elif index == index_ende:
                runflag = False
        elif index == index_save:
            rd.log.write(f"Start Abfrage  \"{start_auswahl[index]}\" ausgewählt")

            (status, errtext) = depot_data_init.data_save(rd)
            if (status != hdef.OK):
                rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
            # end if
            
            
        elif index == index_konto:
            rd.log.write(f"Start Abfrage  \"{start_auswahl[index]}\" ausgewählt")
            status = kb.bearbeiten(rd)
            # if (status != hdef.OKAY):
            #    runflag = False
            # endif
        elif index == index_iban:
            rd.log.write(f"Start Abfrage  \"{start_auswahl[index]}\" ausgewählt")
            status = ib.bearbeiten(rd)
            # if (status != hdef.OKAY):
            #     runflag = False
            # endif
        elif index == index_depot:
            rd.log.write(f"Start Abfrage  \"{start_auswahl[index]}\" ausgewählt")
            status = db.bearbeiten(rd)
        else:
            errtext = f"Auswahl: {index} nicht bekannt"
            rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        #endif

        # # enddef

    # endwhile
    
    if save_flag:
        (status, errtext) = depot_data_init.data_save(rd)

        if (status != hdef.OK):
            rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        # end if
    # else:
    #     rd.log.write_info("Keine Datensicherung",screen=rd.par.LOG_SCREEN_OUT)
    # end if

    # close log-file
    rd.log.close()
    
    # close protokoll
    rd.gui.save()
    
    return
    
# enddef
def rd_consistency_check(rd):
    '''
    
    :param data:
    :return: (status, errtext) = rd_consistency_check(rd.data)
    '''
    # proof id-consistency konto-pickle-file
    rd.allg.idfunc.reset_consistency_check()
    for konto_name in rd.ini.ddict[rd.par.INI_KONTO_DATA_LIST_NAMES_NAME]:
        n = rd.konto_dict[konto_name].konto_obj.get_number_of_data()
        
        for i in range(n):
            # get id
            i_id = rd.konto_dict[konto_name].konto_obj.par.KONTO_DATA_INDEX_ID
            name = rd.konto_dict[konto_name].konto_obj.par.KONTO_DATA_NAME_DICT[i_id]
            type = rd.konto_dict[konto_name].konto_obj.par.KONTO_DATA_TYPE_DICT[i_id]
            id = rd.konto_dict[konto_name].konto_obj.get_data_item_at_irow(i,name,type)
            # proof
            (okay, errtext) = rd.allg.idfunc.proof_and_add_consistency_check_id(id, konto_name)
            
            if okay != hdef.OKAY:
                rd.allg.idfunc.reset_consistency_check()
                return (okay,errtext)
            # end if
        # end ofr
    # end for
    # reset dict
    rd.allg.idfunc.reset_consistency_check()
    return (hdef.OKAY, "")
# end def
def print_some_ini_ddict_parameter(par,ddict):
    
    liste = [par.INI_DATA_PICKLE_USE_JSON,
             par.INI_DATA_PICKLE_JSONFILE_LIST,
             par.INI_LOG_SCREEN_OUT_NAME,
             par.INI_IBAN_LIST_FILE_NAME,
             par.INI_WP_DATA_STORE_PATH_NAME,
             par.INI_WP_DATA_USE_JSON_NAME,
             par.INI_PROTOCOL_TYPE_NAME,
             par.INI_PROTOCOL_FILE_NAME]
    max_width = max([len(word) for word in liste])
    
    for name in liste:
        if name in ddict.keys():
            name1 = f"ini.ddict[\"{name}\"]"
            name2 = f"{ddict[name]}"
            print(f"{name1:<{max_width}} = {name2:<100}")
        # end if
    # end for
    
if __name__ == '__main__':

    # chnage to directory of data-Files
    os.chdir(WORKING_DIRECTORY)
    
    depot_aufstellung()

    print(f"Ende siehe logfile: {os.path.join(WORKING_DIRECTORY, LOG_FILE_NAME)}")

# endif
