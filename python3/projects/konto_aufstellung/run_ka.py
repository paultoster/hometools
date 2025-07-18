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

WORKING_DIRECTORY = "K:/data/orga/Otnok"
LOG_FILE_NAME = "ka.log"
INI_FILE_NAME = "ka.ini"


import ka_par
import ka_ini_file
import ka_data_set
import ka_konto_bearbeiten as kb
import ka_iban_bearbeiten as ib
import ka_depot_bearbeiten as db
import ka_gui


# Hilfsfunktionen
import hfkt_def as hdef
import hfkt_log as hlog

import wp_abfrage.wp_base

@dataclass
class RootData:
    par: ka_par.Parameter = field(default_factory=ka_par.Parameter)
    log: hlog.log = field(default_factory=hlog.log)
    ini: ka_ini_file.ini = field(default_factory=ka_ini_file.ini)
    data: dict = field(default_factory=dict)
    wpfunc: wp_abfrage.wp_base.WPData = field(default_factory=wp_abfrage.wp_base.WPData)


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
    rd.par = ka_par.get(rd.log)
    rd.ini = ka_ini_file.ini(rd.par,INI_FILE_NAME)

    if (rd.ini.status != hdef.OK):
        rd.log.write_err(rd.ini.errtext, screen=rd.par.LOG_SCREEN_OUT)
        return
    # else:
    #     rd.par = rd.ini.get_par(rd.par)
    # endif
        
    # wp funktion wert papier rd.ini.ddict["wp_abfrage"]["store_path"]
    rd.wpfunc = wp_abfrage.wp_base.WPData(rd.ini.ddict[rd.par.INI_PROG_DATA_NAME][rd.par.INI_WP_DATA_STORE_PATH_NAME]
                                         ,rd.ini.ddict[rd.par.INI_PROG_DATA_NAME][rd.par.INI_WP_DATA_USE_JSON_NAME])
    if (rd.wpfunc.status != hdef.OK):
        rd.log.write_err(rd.wpfunc.errtext, screen=rd.par.LOG_SCREEN_OUT)
        return
    # endif

    # data_base
    # -----------
    (status, errtext, rd.data) = ka_data_set.data_get(rd.par,rd.ini.ddict,rd.wpfunc)

    if (status != hdef.OK):
        rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        return
    # endif

    # id consistency check
    #---------------------
    (status, errtext) = rd_consistency_check(rd.par,rd.ini.ddict,rd.data)
    if (status != hdef.OK):
        rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        return
    # endif
    


    runflag = True

    start_auswahl = ["Cancel (no save)","Ende","Iban","Konto","Depot"]
    index_cancel_no_save  = 0
    index_ende    = 1
    index_iban    = 2
    index_konto   = 3
    index_depot   = 4
    save_flag = True
    abfrage_liste = ["okay","cancel","ende"]
    i_abfrage_okay = 0
    i_abfrage_cancel = 1
    i_abfrage_ende = 2

    while (runflag):
        
        save_flag = True
        (index,indexAbfrage) = ka_gui.listen_abfrage(rd,start_auswahl,"Startauswahl",abfrage_liste)
        
        if indexAbfrage == i_abfrage_cancel:
            index = index_cancel_no_save
        elif indexAbfrage == i_abfrage_ende:
            index = index_ende
        
        if index < 0: # cancel button
            runflag = True
        elif index == index_cancel_no_save:
            
            flag = ka_gui.janein_abfrage(rd, "Soll wirklich nicht gespeichert werden?", "Nicht Speichern ja/nein")
            if flag:
                runflag = False
                save_flag = False
            # end if
        elif index == index_ende :
            runflag = False
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
        (status, errtext) = ka_data_set.data_save(rd.data,rd.par,rd.ini.ddict)

        if (status != hdef.OK):
            rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        # end if
    # else:
    #     rd.log.write_info("Keine Datensicherung",screen=rd.par.LOG_SCREEN_OUT)
    # end if

    # close log-file
    rd.log.close()

    return
    
# enddef
def rd_consistency_check(par,ini_dict,data):
    '''
    
    :param data:
    :return: (status, errtext) = rd_consistency_check(rd.data)
    '''
    # proof id-consistency konto-pickle-file
    data[par.PROG_DATA_TYPE_NAME].idfunc.reset_consistency_check()
    for konto_name in ini_dict[par.INI_KONTO_DATA_DICT_NAMES_NAME]:
        n = data[konto_name].obj.get_number_of_data()
        
        for i in range(n):
            # get id
            id = data[konto_name].obj.get_data_item_at_irow(i
                , data[konto_name].obj.KONTO_DATA_NAME_DICT[data[konto_name].obj.KONTO_DATA_INDEX_ID]
                , data[konto_name].obj.KONTO_DATA_TYPE_DICT[data[konto_name].obj.KONTO_DATA_INDEX_ID])
            # proof
            (okay, errtext) = data[par.PROG_DATA_TYPE_NAME].idfunc.proof_and_add_consistency_check_id(id, konto_name)
            
            if okay != hdef.OKAY:
                data[par.PROG_DATA_TYPE_NAME].idfunc.reset_consistency_check()
                return (okay,errtext)
            # end if
        # end ofr
    # end for
    # reset dict
    data[par.PROG_DATA_TYPE_NAME].idfunc.reset_consistency_check()
    return (hdef.OKAY, "")
# end def

if __name__ == '__main__':

    # chnage to directory of data-Files
    os.chdir(WORKING_DIRECTORY)
    
    konto_auswerten()

    print(f"Ende siehe logfile: {os.path.join(WORKING_DIRECTORY, LOG_FILE_NAME)}")

# endif
