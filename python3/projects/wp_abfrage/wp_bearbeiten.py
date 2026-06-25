import os, sys
import numpy as np
from hfkt_log import log

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

from tools import sgui
from tools import hfkt_def as hdef
from tools import hfkt_dict as hdict
from tools import hfkt_type as htype
from tools import hfkt_date_time as hdate
from tools import hfkt_file_path as hpf
from tools import hfkt_io as hio
from tools import hfkt_list as hlist

from wp_abfrage import wp_price_volume
from wp_abfrage import wp_fkt
from wp_abfrage import wp_storage as wp_storage

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
    #---------------------------------------------
    (status, errtext,isin_liste,isin_wpname_liste)  = get_isin_and_wpname_list(wb_obj)
    if status != hdef.OKAY:
        return (status, errtext,infotext)
    # end if

    abfrage_liste = ["edit", "ende", "neu", "delete","update(empty)","update(all)","update(one)","dump(ods)","proof_url(subsequent)","backup"]
    i_abfrage_ende = 1
    i_abfrage_edit = 0
    i_abfrage_neu = 2
    i_abfrage_delete = 3
    i_abfrage_update_empty = 4
    i_abfrage_update_all = 5
    i_abfrage_update_one = 6
    i_abfrage_dump_ods = 7
    i_abfrage_proof_url_subsequent = 8
    #i_backup = 8
    runflag = True
    while (runflag):
        [index, indexAbfrage] = sgui.abfrage_liste_index_abfrage_index(isin_wpname_liste, abfrage_liste, "WP edit isin")
        
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
                (status, errtext) = edit_isin_basic_info(wb_obj,wpname, isin)
                if status != hdef.OKAY:
                    return (status, errtext,infotext)
                # end if
            # end if
        elif indexAbfrage == i_abfrage_neu:

            # Eingabe neue ISIN Beispiel ETF (IE0006FQAF69)
            isin = sgui.abfrage_eingabezeile(anzeigename="isin",title="Eine isin oder wkn eingeben")
            if isin != "":

                if isin in isin_liste:
                    infotext = f"Die isin: {isin} is bereits in der Liste {isin_liste =}"
                    return (hdef.OKAY, errtext,infotext)

                (status, errtext, output_dict) = wb_obj.get_basic_info(isin)
                if status != hdef.OKAY:
                    return (status, errtext,infotext)
                # end if

                isin = output_dict["isin"]
                wpname = output_dict["name"]
                (status, errtext) = edit_isin_basic_info(wb_obj, wpname, isin)
                if status != hdef.OKAY:
                    return (status, errtext,infotext)
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
            abfrage_liste2 = ["choice","zurück"]
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
                    (status, errtext) = wb_obj.update_one_basic_infos(isin,True)
                    if status != hdef.OKAY:
                        return (status, errtext, infotext)
                    # end if
                # end if


            if status != hdef.OKAY:
                return (status, errtext, infotext)
            runflag = True
        elif indexAbfrage == i_abfrage_dump_ods:
            (status, errtext) = dump_in_ods(wb_obj,isin_liste)
            if status != hdef.OKAY:
                return (status, errtext, infotext)
            runflag = True
        elif indexAbfrage == i_abfrage_proof_url_subsequent:
            (status, errtext,infotext) = proof_url_subsequent(wb_obj,isin_liste,isin_wpname_liste)
            if (status != hdef.OKAY) or (len(infotext)>0):
                return (status, errtext, infotext)
            runflag = True
        else: # indexAbfrage == i_backup
            (status, errtext) = make_backup_basic_infos(wb_obj)
        # end if
    # end while
    
    return (status, errtext,infotext)


# end def
def edit_isin_basic_info(wb_obj,wpname, isin):
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
def choose_from_gui_for_one_isin(wb_obj):
    """

    - Demand: run_wp_abfrage.py

    Gibt Liste aller WPs mit ISIN und Name an zur Auswahl.
    Auswahl einer isin

    :param wb_obj:
    :return: (status, errtext,isin) = wp_bearbeiten.choose_from_gui_for_one_isin(wb_obj)
    """

    status = hdef.OKAY
    errtext = ""
    isin = ""

    # Hole die dict-Liste mit allen WPs name[isin]
    # ---------------------------------------------
    (status, errtext, wpname_isin_dict) = \
        wb_obj.get_stored_basic_info_wpname_isin_dict()

    if status != hdef.OKAY:
        errtext = f"Error wb_obj.get_stored_basic_info_wpname_isin_dict() errtext = {errtext}"
        return (status, errtext,isin)
    # end if

    # print(f"wpname_isin_dict = {wpname_isin_dict}")
    isin_wpname_liste = []
    isin_liste = []
    for i, isin in enumerate(wpname_isin_dict.keys()):
        isin_wpname_liste.append(f"{i}:{isin} : {wpname_isin_dict[isin]}")
        isin_liste.append(isin)
    # end for

    abfrage_liste = ["get", "ende"]
    i_abfrage_ende = 1
    i_abfrage_get = 0

    runflag = True
    while (runflag):
        [index, indexAbfrage] = sgui.abfrage_liste_index_abfrage_index(isin_wpname_liste, abfrage_liste, "WP edit isin")

        if indexAbfrage < 0:
            runflag = True
        elif indexAbfrage == i_abfrage_ende:
            runflag = False
        elif indexAbfrage == i_abfrage_get:
            if index < 0:
                print("Keine isin ausgewählt")
                runflag = True
            else:
                isin = isin_liste[index]
                runflag = False
            # end if
        # end if
    # end while

    return (status, errtext,isin)
# end def

def get_isin_and_wpname_list(wb_obj):
    """

    :param wb_obj:
    :return: (status,errtext,isin_liste,isin_wpname_liste)  = get_isin_and_wpname_list(wb_obj)
    """
    isin_wpname_liste = []
    isin_liste = []
    (status, errtext, wpname_isin_dict) = \
        wb_obj.get_stored_basic_info_wpname_isin_dict()

    if status != hdef.OKAY:
        errtext = f"Error wb_obj.get_stored_basic_info_wpname_isin_dict() errtext = {errtext}"
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

        isin_wpname_liste.append(f"{i}:{isin} : {output_dict["type"]} : {wpname_isin_dict[isin]}")
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
        (status, errtext) = hpf.make_backup_file(file_name, backup_dir, no_act_date=True)

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
    (status, errtext,isin_liste,isin_wpname_liste)  = get_isin_and_wpname_list(wb_obj)
    if status != hdef.OKAY:
        return (status, errtext,"")
    # end if

    abfrage_liste = ["update one isin","ende", "update all-isins","update avira-csv","backup","dump basic_info(ods)"]
    i_abfrage_ende = 1
    i_abfrage_update_isin = 0
    i_abfrage_update_ariva_csv = 3
    i_abfrage_update_all = 2
    i_backup = 4
    # i_dump_basic = 5
    runflag = True

    while (runflag):
        [index, indexAbfrage] = sgui.abfrage_liste_index_abfrage_index(isin_wpname_liste, abfrage_liste, "WP update isin")

        if indexAbfrage < 0:
            runflag = True
        elif indexAbfrage == i_abfrage_ende:
            runflag = False
        elif indexAbfrage == i_abfrage_update_isin:

            if index < 0:
                wb_obj.log.write_info("Keine isin ausgewählt")
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
                    t = f"Error wp_bearbeiten.edit_price_volume(wb_obj) \n errtext = {errtext}"
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
                runflag = False
            # end if
        elif indexAbfrage == i_abfrage_update_ariva_csv:

            wb_obj.log.write_info(f"WP update ariva-csv:")

            (status, errtext, infotext) = wb_obj.update_price_volume_csv()

            if len(infotext):
                t = f"Info wb_obj.wp_bearbeiten.update_ariva_csv() \n infotext = {infotext}"
                sgui.anzeige_text(t, textcolor='green')
                wb_obj.log.write_info(t)
                infotext = ""
            # end if

            if status != hdef.OKAY:
                t = f"Error wb_obj.wp_bearbeiten.update_ariva_csv() \n errtext = {errtext}"
                sgui.anzeige_text(t, textcolor='red')
                wb_obj.log.write_err(t)
                runflag = False
            # end if
        elif indexAbfrage == i_backup:
            (status, errtext) = make_backup_price_volumen(wb_obj)
            if status != hdef.OKAY:
                return (status, errtext, infotext)
            runflag = True
        else: # indexAbfrage == i_dumP-basic:
            (status, errtext) = dump_in_ods(wb_obj,isin_liste)
            if status != hdef.OKAY:
                return (status, errtext, infotext)
            runflag = True
        # end if
    # end while
    return (status, errtext, infotext)
# end def
def make_backup_price_volumen(wb_obj):
    """
    :param wb_obj:
    :return: (status, errtext) = make_backup_basic_infos(wb_obj)
    """

    (status, errtext, isin_liste) = wb_obj.get_basic_info_isin_liste()
    if status != hdef.OKAY:
        return (status, errtext)
    # end if

    (status,errtext,backup_dir) = make_backup_build_new_dir_price_volume(wb_obj)
    if status != hdef.OKAY:
        return (status, errtext)
    #  end if

    (status, errtext, filename_list) = wb_obj.get_exist_filenames_of_privce_volume(isin_liste)
    if status != hdef.OKAY:
        return (status, errtext)
    #  end if

    for file_name in filename_list:

        wb_obj.log.write_info(f"copy {file_name = } into {backup_dir = }")
        (status, errtext) = hpf.make_backup_file(file_name, backup_dir, no_act_date=True)

        if status != hdef.OKAY:
            return (status, errtext)
        # end if
    # end for

    # end for


    return (status, errtext)
# end if
def make_backup_build_new_dir_price_volume(wb_obj):
    """
    (status, errtext) = make_backup_build_new_dir_price_volume(wb_obj)
    """

    status = hdef.OKAY
    errtext = ""

    backup_dir = os.path.join(wb_obj.base_ddict["store_path"],
                            hdate.get_name_by_dat_time("price_volume_", ""))


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
def get_price_volume_data_from_ariva_csv_file(csv_file,delim,np_classdef,currency):
    """
    :param csv_file:
    :param delim:
    :param np_classdef:
    :param currency:
    :return: (status, errtext, infotext, np_obj_csv) = wp_fkt.get_price_volume_data_from_ariva_csv_file(csv_file,delim,np_classdef,currency)
    """

    status = hdef.OKAY
    errtext = ""
    infotext = ""
    np_obj = np_classdef()

    # read csv-File
    # ==============
    csv_lliste = hio.read_csv_file(file_name=csv_file, delim=delim)

    if (len(csv_lliste) == 0):
        errtext = f"Fehler in read_ing_csv read_csv_file()  filename = {csv_file}"
        status = hdef.NOT_OKAY
        return (status, errtext, infotext,np_obj)
    # end if

    csv_lliste = hlist.erase_empty_rows_in_llist(csv_lliste)

    llist = []
    for i,csv_list in enumerate(csv_lliste):

        if i > 0:

            liste = [htype.type_transform_direct(csv_list[0], "datStrB", "dat"),
                     htype.type_transform_direct(csv_list[1], "euroStrK", "float"),
                     htype.type_transform_direct(csv_list[2], "euroStrK", "float"),
                     htype.type_transform_direct(csv_list[3], "euroStrK", "float"),
                     htype.type_transform_direct(csv_list[4], "euroStrK", "float"),
                     htype.type_transform_direct(csv_list[5], "str", "float")]

            llist.append(liste)
        # end if
    # end for

    llist = hlist.sort_list_of_list(llist, 0)

    dat_list = hlist.get_col_list_by_index(llist, 0)
    start_list = hlist.get_col_list_by_index(llist, 1)
    high_list = hlist.get_col_list_by_index(llist, 2)
    low_list = hlist.get_col_list_by_index(llist, 3)
    end_list = hlist.get_col_list_by_index(llist, 4)
    vol_list = hlist.get_col_list_by_index(llist, 5)

    dat_np_array  = np.array(dat_list, copy=True)
    start_np_array = np.array(start_list, copy=True)
    high_np_array = np.array(high_list, copy=True)
    low_np_array = np.array(low_list, copy=True)
    end_np_array = np.array(end_list, copy=True)
    vol_np_array = np.array(vol_list, copy=True)

    np_obj.from_np_array_list([dat_np_array,
                               start_np_array,
                               high_np_array,
                               low_np_array,
                               end_np_array,
                               vol_np_array])
    np_obj.currency = currency

    np_obj.sort_by_dat()

    return (status, errtext, infotext, np_obj)
# end def