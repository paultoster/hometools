
import os
import sys


tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

# Hilfsfunktionen
import tools.hfkt_def as hdef

import depot_gui

def anzeige_depot_isin(rd,isin,depot_obj,depot_dict):
    '''
    
    :param rd:
    :param isin:
    :param depot_obj:
    :return: (sw,status) = depot_depot_anzeige_isin.anzeige_depot_isin(rd,isin,depot_obj)
    '''
    status = hdef.OKAY
    irow = -1
    sw = -1
    
    runflag = True
    choice_isin_overview = 0
    choice_isin_edit = 1
    choice_isin_delete = 2
    choice_isin_kurs = 3
    choice_isin_update = 4
    choice_isin = choice_isin_overview
    while runflag :
        if choice_isin == choice_isin_overview:
            
            (ttable, row_color_dliste) = depot_obj.get_depot_daten_sets_isin(isin)
            if depot_obj.status != hdef.OKAY:  # Abbruch
                status = depot_obj.status
                rd.log.write_err(depot_obj.errtext, screen=rd.par.LOG_SCREEN_OUT)
                depot_obj.reset_status()
                return (sw,status)
            # end if
            
            title = depot_obj.get_titlename(isin)
            
            # isin Anzeige
            # --------------------------------------
            (sw, irow, changed_pos_list, ttable_update) = anzeige_isin(rd, ttable, title, row_color_dliste)
            
            if sw <= 0: # ende
                runflag = False
                sw = -1
            elif sw == 1:  # zurück zu overview
                sw = 0
                runflag = False
            elif sw == 2:  # edit
                choice_isin = choice_isin_edit
                runflag = True
            elif sw == 3:  # delete
                choice_isin = choice_isin_delete
                runflag = True
            elif sw == 4:  # kurs
                choice_isin = choice_isin_kurs
                runflag = True
            else:  # update
                choice_isin = choice_isin_update
                runflag = True
            # end if
        elif choice_isin == choice_isin_edit:
            
            print(f"Depot: {depot_obj.get_depot_name()} isin: {isin} irow: {irow}")
            
            # get data
            (tliste, buchungs_type_list, buchtype_index_in_header_liste) \
                = depot_obj.get_depot_daten_sets_isin_irow(isin, irow)
            
            if depot_obj.status != hdef.OKAY:  # Abbruch
                status = depot_obj.status
                rd.log.write_err(depot_obj.errtext, screen=rd.par.LOG_SCREEN_OUT)
                depot_obj.reset_status()
                return (sw,status)
            # end if
            
            immutable_liste = depot_obj.get_immutable_list_from_header_list(isin, tliste.names)
            
            if depot_obj.status != hdef.OKAY:  # Abbruch
                status = depot_obj.status
                rd.log.write_err(depot_obj.errtext, screen=rd.par.LOG_SCREEN_OUT)
                depot_obj.reset_status()
                return (sw,status)
            # end if
            
            titlename = depot_obj.get_titlename(isin)
            
            # edit data
            (tlist_new,change_flag) = depot_gui.konto_depot_data_set_eingabe(rd.gui,tliste, buchtype_index_in_header_liste,
                                                                buchungs_type_list,  titlename,
                                                                immutable_liste)
            
            if change_flag:
                new_data_set_flag = depot_obj.set_data_set_isin_irow(tlist_new, isin, irow)
                
                if depot_obj.status != hdef.OKAY:
                    status = depot_obj.status
                    rd.log.write_err("anzeige_mit_depot_wahl edit " + depot_obj.errtext, screen=rd.par.LOG_SCREEN_OUT)
                    depot_obj.reset_status()
                    return (sw,status)
                elif len(depot_obj.infotext) != 0:
                    rd.log.write_info("anzeige_mit_depot_wahl edit " + depot_obj.infotext, screen=rd.par.LOG_SCREEN_OUT)
                    depot_obj.reset_infotext()
                # endif
            # endif
            
            choice_isin = choice_isin_overview
            runflag = True
        
        elif choice_isin == choice_isin_delete:
            # get data
            (tliste, _, _) = depot_obj.get_depot_daten_sets_isin_irow(isin, irow)
            ddict0 = {}
            for i, name in enumerate(tliste.names):
                ddict0[name] = tliste.vals[i]
            # end for
            titlename = depot_obj.get_titlename(isin)
            flag = depot_gui.janein_abfrage(rd.gui,
                                         f"Soll wirklich isin/name/zahltdiv = {titlename} mit datasetdict : {ddict0} gelöscht werden",
                                         "Nicht Löschen ja/nein")
            
            if flag:
                # konto_obj set anlegen
                # ----------------------
                # konto_name = depot_dict[rd.par.INI_DEPOT_KONTO_NAME]
                #
                # if konto_name not in rd.konto_dict:
                #     status = hdef.NOT_OKAY
                #     errtext = f"Von Depot Auswahl: {depot_obj.get_depote_name()} benutztes Konto: {konto_name} ist nicht im data-dict"
                #     rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
                #     return status
                # # end if
                konto_name = depot_obj.get_konto_name()
                status = depot_obj.delete_in_data_set(rd.konto_dict[konto_name].konto_obj,isin, irow)
                
                if status != hdef.OKAY:  # Abbruch
                    rd.log.write_err(depot_obj.errtext, screen=rd.par.LOG_SCREEN_OUT)
                    status = depot_obj.reset_status()
                    return (sw,status)
                # end if
            # end if
            
            choice_isin = choice_isin_overview
            runflag = True
        
        elif choice_isin == choice_isin_kurs:
            # set kurs
            status = depot_obj.set_kurs_value(isin, irow)
            
            if status != hdef.OKAY:  # Abbruch
                rd.log.write_err(depot_obj.errtext, screen=rd.par.LOG_SCREEN_OUT)
                status = depot_obj.reset_status()
                return (sw,status)
            # end if
            
            choice_isin = choice_isin_overview
            runflag = True
        
        else: #  if choice_isin == choice_isin_update:
            (status, new_data_set_flag) = depot_obj.update_data_ttable(isin, changed_pos_list, ttable_update)
            
            if status != hdef.OKAY:  # Abbruch
                rd.log.write_err(depot_obj.errtext, screen=rd.par.LOG_SCREEN_OUT)
                status = depot_obj.reset_status()
                return (sw,status)
            # end if
            
            choice_isin = choice_isin_overview
            runflag = True
        # end if
    # end while
    return (sw,status)

# end def
def anzeige_isin(rd, ttable, title, row_color_dliste):
    '''

    :param data_lliste:
    :param header_liste:
    :return: (sw, isin) = anzeige_isin(data_lliste, header_liste,title)
    sw = 1  zurück
       = 2  edit
       = 3  delete
       = -1 Ende
    '''
    abfrage_liste = ["ende", "zurück", "edit", "delete", "kurs", "update(edit)"]
    i_end = 0
    i_zurueck = 1
    i_edit = 2
    i_delete = 3
    i_kurs = 4
    # i_update = 5
    
    runflag = True
    while (runflag):
        
        (sw, irow, changed_pos_list, ttable_out) = depot_gui.depot_isin(rd.gui,ttable, abfrage_liste, title,row_color_dliste)
        
        if sw <= i_end:
            sw = -1
            runflag = False
        elif sw == i_zurueck:
            runflag = False
        elif (sw == i_edit) or (sw == i_delete) or (sw == i_kurs):
            if irow < 0:
                rd.log.write_warn("Keine Zeile ausgewählt", screen=rd.par.LOG_SCREEN_OUT)
                runflag = True
            else:
                runflag = False
            # end if
        else:  # if sw == i_update
            if len(changed_pos_list) == 0:
                rd.log.write_warn("Keine Daten in Tabelle geändert", screen=rd.par.LOG_SCREEN_OUT)
                runflag = True
            else:
                runflag = False
        # end if
    
    # end while
    return (sw, irow, changed_pos_list, ttable_out)

# end def

