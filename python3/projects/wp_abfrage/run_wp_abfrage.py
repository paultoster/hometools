import os, sys

t_path, _ = os.path.split(__file__)
if len(t_path) > 0 :
    tools_path = t_path + "\\.."
else:
    tools_path = ".."
# end if
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif
from tools.hfkt_log import log
from tools import sgui
from tools import hfkt_def as hdef
from tools import hfkt_dict as hdict
from tools import hfkt_date_time as hdate
from tools import hfkt_type as htype
from tools import hfkt_file_path as hfp

from wp_abfrage import wp_base
from wp_abfrage import wp_bearbeiten
from wp_abfrage import wp_storage


INT_FILENAME = "D:/data/orga/wp_store/wp_abfrage.ini"

wb_obj = wp_base.WPData(INT_FILENAME)

if wb_obj.status != hdef.OKAY:
    print(f"Error build wp_base.WPData({INT_FILENAME}) errtext = {wb_obj.errtext}")
    exit(1)
# end if

def run_wp_abfrage():



    # # Read all data and store in new dataclass
    # (status, errtext, backup_dir) = wp_bearbeiten.make_backup_build_new_dir_price_volume(wb_obj)
    # if status != hdef.OKAY:
    #     return
    # #  end if
    # (status, errtext, isin_liste) = wb_obj.get_basic_info_isin_liste()
    #
    # for isin in isin_liste:
    #     (status, errtext, np_obj) = wp_bearbeiten.read_np_obj(wb_obj, isin)
    #
    #     if status == hdef.OKAY:
    #         np_obj_new = wp_bearbeiten.build_price_volumen_np_obj(wb_obj,isin)
    #
    #         np_obj_new.put_signal(np_obj.dat_np_array,
    #                               np_obj.start_np_array,
    #                               np_obj.high_np_array,
    #                               np_obj.low_np_array,
    #                               np_obj.end_np_array,
    #                               np_obj.volume_np_array)
    #
    #         np_obj_new.set_currency(np_obj.currency)
    #
    #         np_obj_new.save()
    #
    #         del np_obj_new
    #
    #
    #         file_name = wp_storage.build_file_name_json(wb_obj.base_ddict["price_volumen_pre_file_name"] + isin,
    #                                                     wb_obj.base_ddict["store_path"])
    #         if os.path.isfile(file_name):
    #             status = hfp.move_file(file_name, backup_dir)
    #             if status != hdef.OKAY:
    #                 errtext = f"file {file_name = } was moved into {backup_dir = }"
    #                 return
    #
    #         file_name = wp_storage.build_file_name_pickle(wb_obj.base_ddict["price_volumen_pre_file_name"] + isin,
    #                                                     wb_obj.base_ddict["store_path"])
    #
    #         if os.path.isfile(file_name):
    #             status = hfp.move_file(file_name, backup_dir)
    #             if status != hdef.OKAY:
    #                 errtext = f"file {file_name = } was moved into {backup_dir = }"
    #                 return
    #         # end if
    #     # end if
    #     del np_obj
    # # end for


    # # Read all data and store in new dataclass
    # (status, errtext, backup_dir) = wp_bearbeiten.make_backup_build_new_dir_price_volume(wb_obj)
    # if status != hdef.OKAY:
    #     return
    # #  end if
    # (status, errtext, indice_liste) = wb_obj.get_indices_liste()
    #
    # for indice in indice_liste:
    #     (status, errtext, np_obj) = wp_bearbeiten.read_np_indice_obj(wb_obj, indice)
    #
    #     if status == hdef.OKAY:
    #         np_obj_new = wp_bearbeiten.build_indice_np_obj(wb_obj,indice)
    #
    #         np_obj_new.put_signal(np_obj.dat_np_array,
    #                               np_obj.indice_np_array)
    #
    #
    #         np_obj_new.save()
    #
    #         del np_obj_new
    #
    #
    #         file_name = wp_storage.build_file_name_json(wb_obj.base_ddict["indices_pre_file_name"] + indice,
    #                                                     wb_obj.base_ddict["store_path"])
    #         if os.path.isfile(file_name):
    #             status = hfp.move_file(file_name, backup_dir)
    #             if status != hdef.OKAY:
    #                 errtext = f"file {file_name = } was moved into {backup_dir = }"
    #                 return
    #
    #         file_name = wp_storage.build_file_name_pickle(wb_obj.base_ddict["indices_pre_file_name"] + indice,
    #                                                     wb_obj.base_ddict["store_path"])
    #
    #         if os.path.isfile(file_name):
    #             status = hfp.move_file(file_name, backup_dir)
    #             if status != hdef.OKAY:
    #                 errtext = f"file {file_name = } was moved into {backup_dir = }"
    #                 return
    #         # end if
    #     # end if
    #     del np_obj



    runflag = True
    
    start_auswahl = ["Ende", "edit basic info","edit price volume","edit indices","update wps"]
    index_ende = 0
    index_basic_info = 1
    index_price_volume = 2
    index_indices = 3
    index_update_wps = 4
    save_flag = True
    abfrage_liste = ["okay", "cancel", "ende"]
    i_abfrage_okay = 0
    i_abfrage_cancel = 1
    i_abfrage_ende = 2
    
    while (runflag):
        
        [index, indexAbfrage] = sgui.abfrage_liste_index_abfrage_index(start_auswahl, abfrage_liste, "WP edit")
        
        
        if indexAbfrage < 0:
            index = -1
        elif indexAbfrage == i_abfrage_cancel:
            index = index_ende
        elif indexAbfrage == i_abfrage_ende:
            index = index_ende
        
        if index < 0:  # cancel button
            runflag = True
        elif index == index_ende:
            runflag = False
        elif index == index_basic_info:

            wb_obj.log.write_info(f"Start Abfrage  \"{start_auswahl[index]}\" ausgewählt")
            
            
            (status,errtext,infotext) = edit_basic_info(wb_obj)

            if len(infotext) > 0 :
                t = f"Info wp_bearbeiten.edit_basic_info(wb_obj): {infotext}"
                sgui.anzeige_text(t,textcolor='orange')
                wb_obj.log.write_info(t)
            
            if status != hdef.OKAY:
                t = f"Error wp_bearbeiten.edit_basic_info(wb_obj) errtext = {errtext}"
                sgui.anzeige_text(t,textcolor='red')
                wb_obj.log.write_err(t)
                exit(1)
            # end if

        elif index == index_price_volume:

            wb_obj.log.write_info(f"Start Abfrage  \"{start_auswahl[index]}\" ausgewählt")

            (status, errtext, infotext) = edit_price_volume(wb_obj)

            if len(infotext):
                t = f"Info wp_bearbeiten.get_last_price_volume(wb_obj) \n infotext = {infotext}"
                sgui.anzeige_text(t,textcolor='green')
                wb_obj.log.write_info(t)
            # end if

            if status != hdef.OKAY:
                t = f"Error wp_bearbeiten.get_last_price_volume(wb_obj) \n errtext = {errtext}"
                sgui.anzeige_text(t,textcolor='red')
                wb_obj.log.write_err(t)
                exit(1)
            # end if

        elif index == index_indices:

            wb_obj.log.write_info(f"Start Abfrage  \"{start_auswahl[index]}\" ausgewählt")

            (status, errtext,infotext) = edit_indices(wb_obj)
            if status != hdef.OKAY:
                t = f"Error wp_bearbeiten.edit_indices(wb_obj) \n errtext = {errtext}"
                sgui.anzeige_text(t,textcolor='red')
                wb_obj.log.write_err(t)
                exit(1)
            # end if

            if len(infotext):
                t = f"Info wp_bearbeiten.edit_indices(wb_obj) \n infotext = {infotext}"
                sgui.anzeige_text(t,textcolor='green')
                wb_obj.log.write_info(t)
            # end if


        elif index == index_update_wps:

            (status, errtext, infotext) = wb_obj.update_price_volume()

            if len(infotext):
                t = f"Info wb_obj.update_price_volume() \n infotext = {infotext}"
                sgui.anzeige_text(t, textcolor='green')
                wb_obj.log.write_info(t)
                infotext = ""
            # end if

            if status != hdef.OKAY:
                t = f"Error wb_obj.update_price_volume() \n errtext = {errtext}"
                sgui.anzeige_text(t, textcolor='red')
                wb_obj.log.write_err(t)
                runflag = False
            # end if

            (status, errtext, infotext) = wb_obj.update_indices()

            if len(infotext):
                t = f"Info wb_obj.update_indices() \n infotext = {infotext}"
                sgui.anzeige_text(t, textcolor='green')
                wb_obj.log.write_info(t)
                infotext = ""
            # end if

            if status != hdef.OKAY:
                t = f"Error wb_obj.update_indices() \n errtext = {errtext}"
                sgui.anzeige_text(t, textcolor='red')
                wb_obj.log.write_err(t)
                runflag = False
            # end if

        else:
            wb_obj.log.write_info(f"Auswahl: {index} nicht bekannt")
        # endif
    # end while
# end def
def edit_basic_info(wb_obj):
    '''

    - Demand: run_wp_abfrage.py
    Gibt Liste aller WPs mit ISIN und Name an zur Auswahl.
    Die Auswahl wird mit den basic infos bearbeitet
    - Call: edit_isin_basic_info(wpname, isin)

    :param wb_obj:            wp_base.WPData Data Objekt
    :return: (status,errtext,infotext) = edit_basic_info(wb_obj)
    '''
    status = hdef.OKAY
    errtext = ""
    infotext = ""

    # Hole die dict-Liste mit allen WPs name[isin]
    # ---------------------------------------------
    (status, errtext, isin_liste, isin_wpname_liste) = get_isin_and_wpname_list(wb_obj)
    if status != hdef.OKAY:
        return (status, errtext, infotext)
    # end if

    abfrage_liste = ["edit",
                     "neu",
                     "delete",
                     "update(empty)",
                     "update(all)",
                     "update(one)",
                     "dump(ods)",
                     "proof_url(subsequent)",
                     "backup",
                     "ende"]
    i_abfrage_ende = 9
    i_abfrage_edit = 0
    i_abfrage_neu = 1
    i_abfrage_delete = 2
    i_abfrage_update_empty = 3
    i_abfrage_update_all = 4
    i_abfrage_update_one = 5
    i_abfrage_dump_ods = 6
    i_abfrage_proof_url_subsequent = 7
    # i_backup = 8
    runflag = True
    while (runflag):
        [index, indexAbfrage] = sgui.abfrage_liste_index_abfrage_index(isin_wpname_liste, abfrage_liste,
                                                                       "WP edit basic info")

        if indexAbfrage < 0:
            runflag = True
        elif indexAbfrage == i_abfrage_ende:
            runflag = False
        elif indexAbfrage == i_abfrage_edit:
            if index < 0:
                wb_obj.log.write_info("Keine isin ausgewählt")
                runflag = True
            else:

                # Bearbeite basic infos von isin
                isin = isin_liste[index]
                wpname = isin_wpname_liste[index]
                wb_obj.log.write_info(f"Bearbeiten isin: {isin} Name: {wpname}")
                (status, errtext) = edit_isin_basic_info(wb_obj, wpname, isin)
                if status != hdef.OKAY:
                    return (status, errtext, infotext)
                # end if
            # end if
        elif indexAbfrage == i_abfrage_neu:

            # Eingabe neue ISIN Beispiel ETF (IE0006FQAF69)
            isin = sgui.abfrage_eingabezeile(anzeigename="isin", title="Eine isin oder wkn eingeben")
            if isin != "":

                if isin in isin_liste:
                    infotext = f"Die isin: {isin} is bereits in der Liste {isin_liste =}"
                    return (hdef.OKAY, errtext, infotext)

                (status, errtext, output_dict) = wb_obj.get_basic_info(isin)
                if status != hdef.OKAY:
                    return (status, errtext, infotext)
                # end if

                isin = output_dict["isin"]
                wpname = output_dict["name"]
                (status, errtext) = edit_isin_basic_info(wb_obj, wpname, isin)
                if status != hdef.OKAY:
                    return (status, errtext, infotext)
                # end if

                (status, errtext, isin_liste, isin_wpname_liste) = get_isin_and_wpname_list(wb_obj)
                if status != hdef.OKAY:
                    return (status, errtext, infotext)
                # end if
            # end if

            runflag = True
        elif indexAbfrage == i_abfrage_delete:
            wb_obj.log.write_info("delete ist noch nicht programmiert")
            runflag = True
        elif indexAbfrage == i_abfrage_update_empty:
            (status, errtext) = wb_obj.update_all_basic_infos(False)
            if status != hdef.OKAY:
                return (status, errtext, infotext)
            runflag = True
        elif indexAbfrage == i_abfrage_update_all:
            (status, errtext) = wb_obj.update_all_basic_infos(True)
            if status != hdef.OKAY:
                return (status, errtext, infotext)
            runflag = True
        elif indexAbfrage == i_abfrage_update_one:
            abfrage_liste2 = ["choice", "zurück"]
            [index, indexAbfrage] = sgui.abfrage_liste_index_abfrage_index(isin_wpname_liste, abfrage_liste2,
                                                                           "WP choose isin")

            if indexAbfrage < 0:
                runflag = True
            elif indexAbfrage == 1:
                runflag = False
            elif indexAbfrage == 0:
                if index < 0:
                    wb_obj.log.write_info("Keine isin ausgewählt")
                    runflag = True
                else:

                    # Bearbeite basic infos von isin
                    isin = isin_liste[index]
                    wpname = isin_wpname_liste[index]
                    wb_obj.log.write_info(f"update isin: {isin} Name: {wpname}")
                    (status, errtext) = wb_obj.update_one_basic_infos(isin, True)
                    if status != hdef.OKAY:
                        return (status, errtext, infotext)
                    # end if
                # end if

            if status != hdef.OKAY:
                return (status, errtext, infotext)
            runflag = True
        elif indexAbfrage == i_abfrage_dump_ods:
            (status, errtext) = dump_in_ods(wb_obj, isin_liste)
            if status != hdef.OKAY:
                return (status, errtext, infotext)
            runflag = True
        elif indexAbfrage == i_abfrage_proof_url_subsequent:
            (status, errtext, infotext) = proof_url_subsequent(wb_obj, isin_liste, isin_wpname_liste)
            if (status != hdef.OKAY) or (len(infotext) > 0):
                return (status, errtext, infotext)
            runflag = True
        else:  # indexAbfrage == i_backup
            (status, errtext) = make_backup_basic_infos(wb_obj)
        # end if
    # end while

    return (status, errtext, infotext)


# end def
def edit_isin_basic_info(wb_obj, wpname, isin):
    '''

    Demand: wp_abfrage.edit_basic_info()

    Macht ein Editierfenster der basic Infos von der gewünschten isin
    Call: wb_obj.get_basic_info(isin)
    Call: sgui.abfrage_dict(output_dict, title=title)
    Call: wb_obj.save_basic_info(isin, output_dict)

    :param wpname:
    :param isin:
    :return: (status,errtext) = wp_abfrage_edit_isin_basic_info(wpname,isin)
    '''
    status = hdef.OKAY
    errtext = ""

    # Hole alle basic-Infos
    (status, errtext, output_dict) = wb_obj.get_basic_info(isin)
    if status != hdef.OKAY:
        return (status, errtext)
    # end if
    title = f"Edit values of isin: {isin} name: {wpname}"
    wb_obj.log.write_info(title)

    # Ändere basic-info dict
    (output_dict, changed_key_liste) = sgui.abfrage_dict(output_dict, title=title)

    if len(changed_key_liste):
        (status, errtext) = wb_obj.save_basic_info(isin, output_dict)

    return (status, errtext)


# end def
def get_isin_and_wpname_list(wb_obj,flag_first_last=False):
    """

    :param wb_obj:
    :return: (status,errtext,isin_liste,isin_wpname_liste)  = get_isin_and_wpname_list(wb_obj)
    """
    isin_wpname_liste = []
    isin_liste = []
    (status, errtext, wpname_isin_dict) = \
        wb_obj.get_stored_basic_info_isin_wpname_dict()

    if status != hdef.OKAY:
        errtext = f"Error wb_obj.get_stored_basic_info_isin_wpname_dict() errtext = {errtext}"
        return (status, errtext,isin_liste,isin_wpname_liste)
    # end if

    # print(f"wpname_isin_dict = {wpname_isin_dict}")
    isin_wpname_liste = []
    isin_liste = []
    for i, isin in enumerate(wpname_isin_dict.keys()):

        (status, errtext, output_dict) = wb_obj.get_basic_info(isin)
        if status != hdef.OKAY:
            return (status, errtext, isin_liste, isin_wpname_liste)
        # end if

        if flag_first_last:
            (first_dat_str,last_dat_str) = wb_obj.get_first_and_last_dat_price_volume_np_obj(output_dict["isin"],"datStr")

            if  first_dat_str is None:
                first_dat_str = "-"
                last_dat_str = "-"
            # end if
            isin_wpname_liste.append(
                f"{i}:{isin}/{output_dict["wkn"]}/{first_dat_str}/{last_dat_str} : {output_dict["type"]} : {wpname_isin_dict[isin]}")
        else:
            isin_wpname_liste.append(f"{i}:{isin}/{output_dict["wkn"]} : {output_dict["type"]} : {wpname_isin_dict[isin]}")
        # end if

        isin_liste.append(isin)
    # end for

    return (status, errtext, isin_liste, isin_wpname_liste)
# end def
def dump_in_ods(wb_obj,isin_liste):
    """!
    :param wb_obj:
    :return: (status, errtext) = dump_in_ods(wb_obj)
    """

    (status, errtext, output_dict_list) = wb_obj.get_basic_info(isin_liste)
    if status != hdef.OKAY:
        return (status, errtext)
    # end if

    (status, errtext,file_name) = hdict.write_dict_list_in_ods_table(output_dict_list,"basic_info_dict", "basic_info_dict")

    os.startfile(file_name)

    return (status, errtext)
# end dfe
def proof_url_subsequent(wb_obj,isin_liste,isin_wpname_liste):
    """
    (status, errtext) = proof_url_subsequent(wb_obj,isin_liste,isin_wpname_liste)
    """
    infotext = ""
    (status, errtext, output_dict_list) = wb_obj.get_basic_info(isin_liste)

    for i,isin in enumerate(isin_liste):

        okay1 = proof_url_ariva(output_dict_list[i]["url_ariva"])

        okay2 = proof_url_onvista(output_dict_list[i]["url_onvista"])

        if (okay1 != hdef.OKAY) or (okay2 != hdef.OKAY):

            isin = isin_liste[i]
            wpname = isin_wpname_liste[i] + "no url => none"
            print(isin_wpname_liste[i])
            (status, errtext) = edit_isin_basic_info(wb_obj, wpname, isin)
            return (status, errtext, infotext)
        # end if
    # end for
    infotext = "Alle url_avira und url_onvista scjeinen keinen Fehler zu haben. Wenn keine Adresse vorhanden, dann \"none\""
    return (status,errtext,infotext)
# end def
def proof_url_ariva(url_ariva):
    if url_ariva == "":
        return hdef.NOT_OKAY
    elif url_ariva.lower() == "https://www.ariva.de/silber-kurs":
        return hdef.NOT_OKAY
    elif url_ariva.lower() == "https://www.ariva.de":
        return hdef.NOT_OKAY
    else:
        return hdef.OKAY
    # end if
# end def
def proof_url_onvista(url_onvista):
    if url_onvista == "":
        return hdef.NOT_OKAY
    elif url_onvista.lower().find("https://www.onvista.de/suche")>-1:
        return hdef.NOT_OKAY
    else:
        return hdef.OKAY
    # end if
# end def
def make_backup_basic_infos(wb_obj):
    """
    :param wb_obj:
    :return: (status, errtext) = make_backup_basic_infos(wb_obj)
    """

    (status, errtext, isin_liste) = wb_obj.get_basic_info_isin_liste()
    if status != hdef.OKAY:
        return (status, errtext)
    # end if

    (status,errtext,backup_dir) = make_backup_build_new_dir(wb_obj)
    if status != hdef.OKAY:
        return (status, errtext)
    #  end if

    (status, errtext, filename_list) = wb_obj.get_exist_filenames_of_basic_info(isin_liste)
    if status != hdef.OKAY:
        return (status, errtext)
    #  end if

    for file_name in filename_list:

        print(f"copy {file_name = } into {backup_dir = }")
        (status, errtext) = hfp.make_backup_file(file_name, backup_dir, no_act_date=True)

        if status != hdef.OKAY:
            return (status, errtext)
        # end if
    # end for

    # end for


    return (status, errtext)
# end if
def make_backup_build_new_dir(wb_obj):
    """
    :param wb_obj:
    :return: (status, errtext,backup_dir) = make_backup_build_new_dir(wb_obj)
    """

    status = hdef.OKAY
    errtext = ""
    backup_dir = os.path.join(wb_obj.base_ddict["store_path"],
                            hdate.get_name_by_dat_time("backup_basic_infos_", ""))


    if not os.path.isdir(backup_dir):
        try:
            os.mkdir(backup_dir)
        except:

            errtext = f"Der BACKUP_store_path: {backup_dir} konnte nicht erstellt werden"
            status = hdef.NOT_OKAY
        # end try
    # end if

    return (status, errtext,backup_dir)
# end def


def edit_price_volume(wb_obj):
    """

    :param wb_obj:            wp_base.WPData Data Objekt
    :return: (status,errtext,infotext) = edit_price_volume(wb_obj)
    """
    infotext = ""
    # Hole die dict-Liste mit allen WPs name[isin]
    #---------------------------------------------

    abfrage_liste = ["update 1-isin",
                     "update all-isin",
                     "ariva-power-automate",
                     "backup",
                     "proof one-isin",
                     "proof all-isin",
                     "plot isin",
                     "ende"]
    i_abfrage_ende = 7
    i_abfrage_update_isin = 0
    i_abfrage_update_all = 1
    i_abfrage_ariva_power_automate = 2
    i_backup = 3
    i_abfrage_proof_one_isin = 4
    i_abfrage_proof_all_isin = 5
    # i_plot_isin = 6
    runflag = True

    while (runflag):

        (status, errtext, isin_liste, isin_wpname_liste) = get_isin_and_wpname_list(wb_obj, True)
        if status != hdef.OKAY:
            return (status, errtext, "")
        # end if

        [index, indexAbfrage] = sgui.abfrage_liste_index_abfrage_index(isin_wpname_liste, abfrage_liste, "WP edit price volume")
        print(f"{index = }, {indexAbfrage = }")
        if indexAbfrage < 0:
            runflag = True
        elif indexAbfrage == i_abfrage_ende:
            runflag = False
        elif indexAbfrage == i_abfrage_update_isin:

            if index < 0:
                wb_obj.log.write_info("A Keine isin ausgewählt")
                runflag = True
            else:

                # Bearbeite basic infos von isin
                isin = isin_liste[index]
                wpname = isin_wpname_liste[index]

                wb_obj.log.write_info(f"WP update isin: {isin} Name: {wpname}")

                (status, errtext, infotext) = wb_obj.update_price_volume(isin)

                if len(infotext):
                    t = f"Info wp_bearbeiten.get_last_price_volume(wb_obj) \n infotext = {infotext}"
                    sgui.anzeige_text(t, textcolor='green')
                    wb_obj.log.write_info(t)
                # end if

                if status != hdef.OKAY:
                    t = f"Error wp_bearbeiten.get_last_price_volume(wb_obj) \n errtext = {errtext}"
                    sgui.anzeige_text(t, textcolor='red')
                    wb_obj.log.write_err(t)
                    runflag = False
                # end if
        elif indexAbfrage == i_abfrage_update_all:

            wb_obj.log.write_info(f"WP update all:")

            (status, errtext, infotext) = wb_obj.update_price_volume()

            if len(infotext):
                t = f"Info wp_bearbeiten.get_last_price_volume(wb_obj) \n infotext = {infotext}"
                sgui.anzeige_text(t, textcolor='green')
                wb_obj.log.write_info(t)
                infotext = ""
            # end if

            if status != hdef.OKAY:
                t = f"Error wp_bearbeiten.edit_price_volume(wb_obj) \n errtext = {errtext}"
                sgui.anzeige_text(t, textcolor='red')
                wb_obj.log.write_err(t)
                status = hdef.OKAY
                runflag = False
            # end if
        elif indexAbfrage == i_abfrage_ariva_power_automate:

            wb_obj.log.write_info(f"WP build ariva-csv:")

            (status, errtext, infotext) = edit_price_volume_ariva_power_automate(wb_obj)

            if len(infotext):
                t = f"Info wp_bearbeiten.get_last_price_volume(wb_obj) \n infotext = {infotext}"
                sgui.anzeige_text(t, textcolor='green')
                wb_obj.log.write_info(t)
                infotext = ""
            # end if

            if status != hdef.OKAY:
                t = f"Error wp_bearbeiten.edit_price_volume(wb_obj) \n errtext = {errtext}"
                sgui.anzeige_text(t, textcolor='red')
                wb_obj.log.write_err(t)
                status = hdef.OKAY
                runflag = False
            # end if

        elif indexAbfrage == i_backup:
            (status, errtext) = wb_obj.make_backup_price_volumen()
            if status != hdef.OKAY:
                return (status, errtext, infotext)
            runflag = True

        elif indexAbfrage == i_abfrage_proof_one_isin:

            if index < 0:
                wb_obj.log.write_info("B Keine isin ausgewählt")
                runflag = True
            else:

                # Bearbeite basic infos von isin
                isin = isin_liste[index]
                wpname = isin_wpname_liste[index]

                wb_obj.log.write_info(f"WP proof isin: {isin} Name: {wpname}")

                (status, errtext, infotext) = wb_obj.proof_price_volume(isin)

                if len(infotext):
                    t = f"Info wp_bearbeiten.proof_price_volume({isin}) \n infotext = {infotext}"
                    sgui.anzeige_text(t, textcolor='green')
                    wb_obj.log.write_info(t)
                # end if

                if status != hdef.OKAY:
                    t = f"Error wp_bearbeiten.proof_price_volume({isin}) \n errtext = {errtext}"
                    sgui.anzeige_text(t, textcolor='red')
                    wb_obj.log.write_err(t)
                    runflag = False
                # end if
        elif indexAbfrage == i_abfrage_proof_all_isin:

            wb_obj.log.write_info(f"WP proof all:")

            (status, errtext, infotext) = wb_obj.proof_price_volume()

            if len(infotext):
                t = f"Info wp_bearbeiten.proof_price_volume() \n infotext = {infotext}"
                sgui.anzeige_text(t, textcolor='green')
                wb_obj.log.write_info(t)
                infotext = ""
            # end if

            if status != hdef.OKAY:
                t = f"Error wp_bearbeiten.proof_price_volume() \n errtext = {errtext}"
                sgui.anzeige_text(t, textcolor='red')
                wb_obj.log.write_err(t)
                runflag = False
            # end if

        else: # i_plot_isin
            if index < 0:
                wb_obj.log.write_info("C Keine isin ausgewählt")
                runflag = True
            else:

                # Bearbeite basic infos von isin
                isin = isin_liste[index]
                wpname = isin_wpname_liste[index]

                wb_obj.log.write_info(f"WP plot isin: {isin} Name: {wpname}")

                (status, errtext, infotext) = plot_price_volume(wb_obj,isin)

                if len(infotext):
                    t = f"Info plot_price_volume() \n infotext = {infotext}"
                    sgui.anzeige_text(t, textcolor='green')
                    wb_obj.log.write_info(t)
                    infotext = ""
                # end if

                if status != hdef.OKAY:
                    t = f"Error plot_price_volume() \n errtext = {errtext}"
                    sgui.anzeige_text(t, textcolor='red')
                    wb_obj.log.write_err(t)
                    status = hdef.OKAY
                    errtext = ""
                    runflag = False
                # end if
        # end if
    # end while
    return (status, errtext, infotext)
# end def
def edit_price_volume_ariva_power_automate(wb_obj):
    """
    update gesamte data-set mit ariva-power-automate routine
    """
    infotext = ""

    # Hole die dict-Liste mit allen WPs name[isin]
    #---------------------------------------------
    (status, errtext,isin_liste,isin_wpname_liste)  = get_isin_and_wpname_list(wb_obj)
    if status != hdef.OKAY:
        return (status, errtext,"")
    # end if

    abfrage_liste = ["build ariva-isin-csv-liste",
                   "update ariva-csv-download",
                   "ende"]
    button_liste = ["okay","cancel","ende"]

    # button_abfrage_okay = 0
    button_abfrage_cancel = 1
    button_abfrage_ende = 2

    abfrage_liste_ende = 2
    abfrage_liste_build_ariva_isin_csv = 0
    abfrage_lsite_update_ariva_csv_download = 1
    runflag = True




    while (runflag):

        [index_abfrage, index_button] = sgui.abfrage_liste_index_abfrage_index(abfrage_liste, button_liste, "Ariva-power-automate edit")

        if (index_button == button_abfrage_cancel) or (index_button == button_abfrage_ende) or (index_abfrage < 0) or (index_abfrage == abfrage_liste_ende):
            runflag = False
        else:
            runflag = True
            if index_abfrage == abfrage_liste_build_ariva_isin_csv:

                (status, errtext, isin_liste, isin_wpname_liste) = get_isin_and_wpname_list(wb_obj)
                if status != hdef.OKAY:
                    return (status, errtext, "")
                # end if

                indexListe = sgui.abfrage_liste_indexListe(isin_wpname_liste,
                                                           title="Wähle isins für ariva-csv aus aktuelle Daten-Dateien werden weggeschrieben(backup)")
                isin_ariva_liste = [isin for i, isin in enumerate(isin_liste) if i in indexListe]

                # zusätzliche Werte aus json auch in csv schreiben und backup-en
                (stat,errtext,isin_ariva_liste2) = wp_storage.read_dict("SpezialISINListe_BuildArivaCsv.json", 2)
                if stat == hdef.OKAY:

                    for isin in isin_ariva_liste2:

                        if isin not in isin_ariva_liste:
                            isin_ariva_liste.append(isin)
                        # end if
                    # end for
                # end if

                # Suche nach fehlenden data-Dateien:
                for isin in isin_liste:
                    if not wp_bearbeiten.exist_price_volumen_np_data(wb_obj, isin):
                        if isin not in isin_ariva_liste:
                            isin_ariva_liste.append(isin)
                        # end if
                    # end if
                # end for

                (status, errtext, infotext) = wb_obj.build_ariva_isin_csv_liste(isin_ariva_liste)

                if len(infotext):
                    t = f"Info wb_obj.build_ariva_isin_csv_liste() \n infotext = {infotext}"
                    sgui.anzeige_text(t, textcolor='green')
                    wb_obj.log.write_info(t)
                    infotext = ""
                # end if

                if status != hdef.OKAY:
                    t = f"Error wb_obj.wp_bearbeiten.build_ariva_isin_csv_liste() \n errtext = {errtext}"
                    sgui.anzeige_text(t, textcolor='red')
                    wb_obj.log.write_err(t)
                    runflag = True
                # end if

            elif index_abfrage == abfrage_lsite_update_ariva_csv_download:

                wb_obj.log.write_info(f"WP update ariva-csv-download:")

                (status, errtext, infotext) = wb_obj.update_price_volume_ariva_csv_download()

                if len(infotext):
                    t = f"Info wb_obj.update_price_volume_ariva_csv_download() \n infotext = {infotext}"
                    sgui.anzeige_text(t, textcolor='green')
                    wb_obj.log.write_info(t)
                    infotext = ""
                # end if

                if status != hdef.OKAY:
                    t = f"Error wb_obj.update_price_volume_ariva_csv_download() \n errtext = {errtext}"
                    sgui.anzeige_text(t, textcolor='red')
                    wb_obj.log.write_err(t)
                    runflag = False
                # end if

            # end if
        # end if
    # end while
    return (status, errtext, infotext)
# end if

def plot_price_volume(wb_obj,isin):
    """
    (status, errtext, infotext) = plot_price_volume(isin)
    """
    infotext = ""
    (status,errtext,name) = wb_obj.get_basic_info_key_value(isin, "name")
    if status != hdef.OKAY:
        return (status, errtext, infotext)

    (status,errtext,curr) = wb_obj.get_basic_info_key_value(isin, "waehrung")
    if status != hdef.OKAY:
        return (status, errtext, infotext)

    (status, errtext, np_obj) = wb_obj.get_act_price_volume_np_obj(isin)
    if status != hdef.OKAY:
        return (status, errtext, infotext)

    tit = f"Price-Volume {isin = }, {name = } Währung: {curr}"
    (status, errtext, infotext) = wp_bearbeiten.plot_price_volume(np_obj,tit)
    if status != hdef.OKAY:
        return (status, errtext, infotext)

    return (status, errtext, infotext)
#end def
def edit_indices(wb_obj):
    """

    :param wb_obj:            wp_base.WPData Data Objekt
    :return: (status,errtext,infotext) = edit_indices(wb_obj)
    """
    infotext = ""
    # Hole die Liste mit allen indice name[isin]
    #---------------------------------------------
    (status, errtext,indices_liste)  = wb_obj.get_indices_liste()
    if status != hdef.OKAY:
        return (status, errtext,"")
    # end if




    abfrage_liste = ["update one-inidce", "update all-indices","read-ezbchange-xml","read-leitzins-csv","backup","ende"]
    i_abfrage_ende = 5
    i_abfrage_update_indice = 0
    i_abfrage_update_all = 1
    i_abfrage_ezb_xml = 2
    i_abfrage_leitzins_csv = 3
    i_abfrage_backup = 4
    runflag = True

    while (runflag):

        (status, errtext, indices_value_liste) = get_indice_and_value_list(wb_obj, indices_liste)
        if status != hdef.OKAY:
            return (status, errtext, "")
        # end if

        [index, indexAbfrage] = sgui.abfrage_liste_index_abfrage_index(indices_value_liste, abfrage_liste, "WP edit indices")

        if indexAbfrage < 0:
            runflag = True
        elif indexAbfrage == i_abfrage_ende:
            runflag = False
        elif indexAbfrage == i_abfrage_update_indice:

            if index < 0:
                wb_obj.log.write_info("Keine indice ausgewählt")
                runflag = True
            else:

                # Bearbeite basic infos von isin
                indice = indices_liste[index]

                wb_obj.log.write_info(f"Indice update: {indice}")

                (status, errtext, infotext) = wb_obj.update_indices(indice)

                if len(infotext):
                    t = f"Info wp_bearbeiten.edit_indices(wb_obj) \n infotext = {infotext}"
                    sgui.anzeige_text(t, textcolor='green')
                    wb_obj.log.write_info(t)
                # end if

                if status != hdef.OKAY:
                    t = f"Error wp_bearbeiten.edit_indices(wb_obj) \n errtext = {errtext}"
                    sgui.anzeige_text(t, textcolor='red')
                    wb_obj.log.write_err(t)
                    runflag = True
                # end if

        elif indexAbfrage == i_abfrage_update_all:

            wb_obj.log.write_info(f"WP update all:")

            (status, errtext, infotext) = wb_obj.update_indices()

            if len(infotext):
                t = f"Info wp_bearbeiten.edit_indices(wb_obj) \n infotext = {infotext}"
                sgui.anzeige_text(t, textcolor='green')
                wb_obj.log.write_info(t)
                infotext = ""
            # end if

            if status != hdef.OKAY:
                t = f"Error wp_bearbeiten.edit_indices(wb_obj) \n errtext = {errtext}"
                sgui.anzeige_text(t, textcolor='red')
                wb_obj.log.write_err(t)
                runflag = False
            # end if
        elif indexAbfrage == i_abfrage_ezb_xml:

            if index < 0:
                wb_obj.log.write_info("Keine indice ausgewählt")
                runflag = True
            else:

                # Bearbeite basic infos von isin
                indice = indices_liste[index]

                wb_obj.log.write_info(f"Indice update: {indice}")

            print(f"Start Abfrage  \"{indice}\" ausgewählt")
            print("Siehe: https://www.ecb.europa.eu/stats/policy_and_exchange_rates/euro_reference_exchange_rates/html/index.en.html")
            print("Download XML unter dem Chart")

            # Abfrage xml-File
            xmlfilename = sgui.abfrage_file(file_types="*.xml",comment=f"Wähle eine xml-Datei von EZB",start_dir=wb_obj.base_ddict["store_path"])
            if len(xmlfilename) > 0 :
                # Einlesen xml-File
                (status, errtext) = wb_obj.process_indice_ezb_xml(xmlfilename,indice)

                if status != hdef.OKAY:
                    print(f"Error wp_obj.process_usdeuro_ezb_xml(xmlfilename) \n errtext = {errtext}")
                # end if
            # end if

        elif indexAbfrage == i_abfrage_leitzins_csv:

            indice = wb_obj.get_leitzins_indice_name()

            wb_obj.log.write_info(f"Indice update: {indice}")


            # Abfrage csv-File
            csvfilename = sgui.abfrage_file(file_types="*.csv",comment=f"Wähle die csv-Datei von EZB für den leitzins",start_dir=wb_obj.base_ddict["store_path"])
            if len(csvfilename) > 0 :
                # Einlesen csv-File
                (status, errtext) = wb_obj.process_indice_ezb_leitzins_csv(csvfilename)

                if status != hdef.OKAY:
                    print(f"Error wp_obj.process_usdeuro_ezb_xml(xmlfilename) \n errtext = {errtext}")
                # end if
            # end if
        elif indexAbfrage == i_abfrage_backup:
            (status, errtext) = wb_obj.make_backup_indice()
            if status != hdef.OKAY:
                return (status, errtext, infotext)
            runflag = True

        else: # indexAbfrage == i_dumP-basic:

            runflag = True
        # end if
    # end while
    return (status, errtext, infotext)
# end def
def get_indice_and_value_list(wb_obj,indices_liste):


    (status, errtext, np_obj_dict) = wb_obj.get_dict_indice_from_act(indices_liste)
    if status != hdef.OKAY:
        return (status, errtext, [])

    indices_value_liste = []

    for i,key in enumerate(indices_liste):

        if np_obj_dict[key] is None:
            dat_str = ""
            val_str = ""
            dat_first_str = ""
        else:
            (dat,val) = np_obj_dict[key].get_last_data()
            (dat_first,_) = np_obj_dict[key].get_first_data()

            if dat is not None:

                dat_str = htype.type_transform_direct(dat, "dat","datStrP")
                val_str = htype.type_transform_direct(val, "float","str")
                dat_first_str = htype.type_transform_direct(dat_first, "dat","datStrP")
            else:

                dat_str = ""
                val_str = ""
                dat_first_str = ""
            # end if
        # end if
        indices_value_liste.append(f"{i}:{key} : {dat_first_str}/{dat_str} : {val_str}")
    # end for

    return (status, errtext,indices_value_liste)
# end def
if __name__ == '__main__':

    # import xml.etree.ElementTree as ET
    # import pandas as pd
    #
    # tree = ET.parse("usd.xml")
    # root = tree.getroot()
    #
    # ns = {
    #     "exr": "http://www.ecb.europa.eu/vocabulary/stats/exr/1"
    # }
    #
    # rows = []
    #
    # for obs in root.findall(".//exr:Obs", ns):
    #     rows.append({
    #         "date": obs.attrib["TIME_PERIOD"],
    #         "value": float(obs.attrib["OBS_VALUE"])
    #     })
    #
    # df = pd.DataFrame(rows)
    # df["date"] = pd.to_datetime(df["date"])
    #
    # print(df.head())





    run_wp_abfrage()
    

# endif

