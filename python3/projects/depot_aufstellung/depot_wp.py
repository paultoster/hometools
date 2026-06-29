import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif


import tools.hfkt_def as hdef
import tools.sgui as sgui
import tools.hfkt_dict as hdict

import depot_gui

def wp_bearbeiten(rd):

    # get list of isins
    (status, errtext, wpname_isin_dict) = rd.allg.wpfunc.get_stored_basic_info_wpname_isin_dict()

    isin_liste = list(wpname_isin_dict.keys())

    auswahl_liste = [isin + " " + wpname_isin_dict[isin] for isin in wpname_isin_dict.keys()]

    if status != hdef.OKAY:
        rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        return status
    # end if

    abfrage_liste = ["edit wp_info","update price-vol","dump(wp_info)","cancel"]
    index_edit_wp_info = 0
    index_update_price_vol = 1
    index_dump_wp_info = 2
    index_cancel       = 3
    runflag = True
    while runflag:
        (index, _, indexAbfrage) = depot_gui.auswahl_liste_abfrage_liste(rd.gui, auswahl_liste, abfrage_liste,
                                                                         "Wähle ein Funktion aus")

        if index >= 0:
            isin = isin_liste[index]
        else:
            isin = None
        # end if

        if (indexAbfrage < 0) or (indexAbfrage == index_cancel):
            runflag = False
        elif indexAbfrage == index_edit_wp_info:

            rd.log.write(f"Start Abfrage  \"{abfrage_liste[indexAbfrage]}\" ausgewählt")
            if (index == None) or (index < 0):
                rd.log.write_err("Keine isin ausgewählt", screen=rd.par.LOG_SCREEN_OUT)
                runflag = True
            else:
                status = wp_info_dict_bearbeiten_isin(rd,isin)
                if status != hdef.OKAY:
                    return status
                # end if
                runflag = False
            # end if
        elif indexAbfrage == index_update_price_vol:
            if isin is None:
                rd.log.write_info("Update price Volume alle isins")
            else:
                # Bearbeite basic infos von isin
                isin = isin_liste[index]
                wpname = wpname_isin_dict[isin]

                rd.log.write_info(f"WP update isin: {isin} Name: {wpname}")
            # end if
            (status, errtext, infotext) = rd.allg.wpfunc.update_price_volume(isin)

            if len(infotext):
                t = f"Info pfunc.update_price_volume(isin) \n infotext = {infotext}"
                sgui.anzeige_text(t, textcolor='green')
                rd.log.write_info(t)
            # end if

            if status != hdef.OKAY:
                t = f"Error pfunc.update_price_volume(isin) \n errtext = {errtext}"
                sgui.anzeige_text(t, textcolor='red')
                rd.log.write_err(t)
            # end if
            runflag = False
        else: # indexAbfrage == index_dump_wp_info
            (status, errtext, output_dict_list) = rd.allg.wpfunc.get_basic_info(isin_liste)
            if status != hdef.OKAY:
                return (status, errtext)
            # end if

            (status, errtext, file_name) = hdict.write_dict_list_in_ods_table(output_dict_list, "basic_info_dict",
                                                                              "basic_info_dict")

            os.startfile(file_name)
            runflag = False

        # end if
    # end while
    return status
# end def
# def wp_info_dict_bearbeiten(rd):
#
#     status = hdef.OKAY
#
#     # get list of isins
#     (status,errtext, wpname_isin_dict)         = rd.allg.wpfunc.get_stored_basic_info_wpname_isin_dict()
#
#     isin_liste = list(wpname_isin_dict.keys())
#
#     auswahl_liste = [isin + " " + wpname_isin_dict[isin] for isin in wpname_isin_dict.keys()]
#
#     if status != hdef.OKAY:
#         rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
#         return status
#     # end if
#
#     abfrage_liste = ["waehle","neu","cancel"]
#     index_waehle = 0
#     index_neu    = 1
#     index_cancel = 2
#     runflag = True
#     while runflag:
#
#         (index,_,indexAbfrage) = depot_gui.auswahl_liste_abfrage_liste(rd.gui, auswahl_liste,abfrage_liste, "Wähle isin aus")
#
#
#         if (indexAbfrage < 0) or (indexAbfrage == index_cancel):
#             return status
#         elif indexAbfrage == index_waehle:
#
#         else:  # indexAbfrage == index_neu
#             pass
#         # end if
#     return status
# # end def
def wp_info_dict_bearbeiten_isin(rd,isin):
    '''
    
    :param rd:
    :param wp_func:
    :param isin:
    :return: status = wp_info_dict_bearbeiten(rd,wp_func,isin)
    '''
    
    status = hdef.OKAY
    
    (status, errtext, isin_dict) = rd.allg.wpfunc.get_basic_info(isin)
    
    if status != hdef.OKAY:
        rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        return status
    # end if
    
    (isin_result_dict, changed_key_liste) \
        = depot_gui.abfrage_dict(rd.gui,isin_dict,"Edit wp_info(isin)")

    if len(changed_key_liste):
        (status, errtext) = rd.allg.wpfunc.save_basic_info(isin, isin_result_dict)
    # end if
    
    if status != hdef.OKAY:
        rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        return status
    # end if

    return status
# end def
