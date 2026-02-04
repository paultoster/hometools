# Base question loop
#
#
#----------------------
import os, sys
tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef

import depot_gui
import depot_ini_file
import depot_konto_bearbeiten as kb
import depot_iban_bearbeiten as ib
import depot_depot_bearbeiten as db
# import depot_konto_data_set_class as dkonto
import depot_wp_info_dict

def first_question_loop(rd):
    '''
    
    :param rd:
    :return:  (runflag, save_flag,init_flag) = first_question_loop(rd)
    '''
    
    runflag = True
    save_flag = True
    init_flag = False
    
    if len(rd.ini.ddict[rd.par.INI_DEPOT_DATA_LIST_NAMES_NAME]) == 0:
        start_auswahl = ["Cancel (no save)", "Ende", "Save", "Ini edit (and save)", "Iban", "Konto"]
    else:
        start_auswahl = ["Cancel (no save)", "Ende", "Save", "Ini edit and save", "Iban", "Konto", "Depot",
                         "edit wp_info"]  # ["Cancel (no save)","Ende","Iban","Save","Konto","Depot"]
    # end if
    index_cancel_no_save = 0
    index_ende = 1
    index_save = 2
    index_ini = 3
    index_iban = 4
    index_konto = 5
    index_depot = 6
    index_wp_edit = 7
    
    
    abfrage_liste = ["okay", "cancel", "ende"]
    # i_abfrage_okay = 0
    i_abfrage_cancel = 1
    i_abfrage_ende = 2
    
    while (runflag):
        
        save_flag = True
        (index, indexAbfrage) = depot_gui.listen_abfrage(rd.gui,
                                                         start_auswahl,
                                                         "Startauswahl",
                                                         abfrage_liste)
        
        if indexAbfrage < 0:
            index = -1
        elif indexAbfrage == i_abfrage_cancel:
            index = index_cancel_no_save
        elif indexAbfrage == i_abfrage_ende:
            index = index_ende
        
        if index < 0:  # cancel button
            runflag = True
        elif index == index_cancel_no_save:
            
            flag = depot_gui.janein_abfrage(rd.gui, "Soll wirklich nicht gespeichert werden?",
                                            "Nicht Speichern ja/nein")
            if flag:
                runflag = False
                save_flag = False
            # end if
        elif index == index_ende:
            runflag = False
        elif index == index_save:
            rd.log.write(f"Start Abfrage  \"{start_auswahl[index]}\" ausgewählt")
            
            return (runflag, save_flag, init_flag)

        elif index == index_ini:
            rd.log.write(f"Start Abfrage  \"{start_auswahl[index]}\" ausgewählt")

            (status,errtext) = rd.ini.edit_save_data(rd.par,rd.gui)
            init_flag = True
            
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
        #     #     runflag = False
        #     # endif
        elif index == index_depot:
            
            rd.log.write(f"Start Abfrage  \"{start_auswahl[index]}\" ausgewählt")
            status = db.bearbeiten(rd)
        
        elif index == index_wp_edit:
            
            rd.log.write(f"Start Abfrage  \"{start_auswahl[index]}\" ausgewählt")
            status = depot_wp_info_dict.wp_info_dict_bearbeiten(rd)
        
        else:
            errtext = f"Auswahl: {index} nicht bekannt"
            rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        # endif
    
    # endwhile

    # if save_flag:
    #     (status, errtext) = depot_data_init.data_save(rd)
    #
    #     if (status != hdef.OK):
    #         rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
    #     # end if
    # else:
    #     rd.log.write_info("Keine Datensicherung",screen=rd.par.LOG_SCREEN_OUT)
    # end if

    return (runflag, save_flag,init_flag)
# end def
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
            id = rd.konto_dict[konto_name].konto_obj.get_data_item_at_irow(i, name, type)
            # proof
            (okay, errtext) = rd.allg.idfunc.proof_and_add_consistency_check_id(id, konto_name)
            
            if okay != hdef.OKAY:
                rd.allg.idfunc.reset_consistency_check()
                return (okay, errtext)
            # end if
        # end ofr
    # end for
    # reset dict
    rd.allg.idfunc.reset_consistency_check()
    return (hdef.OKAY, "")
# end def
def print_some_ini_ddict_parameter(par, ddict):
    liste = [par.INI_DATA_PICKLE_USE_JSON,
             par.INI_DATA_PICKLE_JSONFILE_LIST,
             par.INI_LOG_SCREEN_OUT_NAME,
             par.INI_IBAN_LIST_FILE_NAME,
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
    return
# end def
