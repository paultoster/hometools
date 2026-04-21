import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

from tools import sgui
from tools import hfkt_def as hdef
from tools import hfkt_dict as hdict
from tools import hfkt_type as htype

from wp_abfrage import wp_price_volume
from wp_abfrage import wp_fkt
from wp_abfrage import wp_storage as wp_storage

def edit_basic_info(wp_obj):
    '''
    
    - Demand: run_wp_abfrage.py
    Gibt Liste aller WPs mit ISIN und Name an zur Auswahl.
    Die Auswahl wird mit den basic infos bearbeitet
    - Call: edit_isin_basic_info(wpname, isin)
    
    :param wp_obj:            wp_base.WPData Data Objekt
    :return: (status,errtext,infotext) = edit_basic_info(wp_obj)
    '''
    status = hdef.OKAY
    errtext = ""
    infotext = ""

    # Hole die dict-Liste mit allen WPs name[isin]
    #---------------------------------------------
    (status, errtext,isin_liste,isin_wpname_liste)  = get_isin_and_wpname_list(wp_obj)
    if status != hdef.OKAY:
        return (status, errtext,infotext)
    # end if

    abfrage_liste = ["edit", "ende", "neu", "delete","update(empty)","update(all)","dump(ods)","proof_url(subsequent)"]
    i_abfrage_ende = 1
    i_abfrage_edit = 0
    i_abfrage_neu = 2
    i_abfrage_delete = 3
    i_abfrage_update_empty = 4
    i_abfrage_update_all = 5
    i_abfrage_dump_ods = 6
    #i_abfrage_proof_url_subsequent = 7
    runflag = True
    while (runflag):
        [index, indexAbfrage] = sgui.abfrage_liste_index_abfrage_index(isin_wpname_liste, abfrage_liste, "WP edit isin")
        
        if indexAbfrage < 0:
            runflag = True
        elif indexAbfrage == i_abfrage_ende:
            runflag = False
        elif indexAbfrage == i_abfrage_edit:
            if index < 0:
                print("Keine isin ausgewählt")
                runflag = True
            else:
                
                # Bearbeite basic infos von isin
                isin = isin_liste[index]
                wpname = isin_wpname_liste[index]
                print(isin_wpname_liste[index])
                (status, errtext) = edit_isin_basic_info(wp_obj,wpname, isin)
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

                (status, errtext, output_dict) = wp_obj.get_basic_info(isin)
                if status != hdef.OKAY:
                    return (status, errtext,infotext)
                # end if
                (status, errtext, isin_liste, isin_wpname_liste) = get_isin_and_wpname_list(wp_obj)
                if status != hdef.OKAY:
                    return (status, errtext,infotext)
                # end if
                isin = output_dict["isin"]
                wpname = output_dict["name"]
                (status, errtext) = edit_isin_basic_info(wp_obj, wpname, isin)
                if status != hdef.OKAY:
                    return (status, errtext,infotext)
                # end if
            # end if

            runflag = True
        elif indexAbfrage == i_abfrage_delete:
            print("delete ist noch nicht programmiert")
            runflag = True
        elif indexAbfrage == i_abfrage_update_empty:
            (status, errtext) = wp_obj.update_all_basic_infos(False)
            if status != hdef.OKAY:
                return (status, errtext, infotext)
            runflag = True
        elif indexAbfrage == i_abfrage_update_all:
            (status, errtext) = wp_obj.update_alla_basic_infos(True)
            if status != hdef.OKAY:
                return (status, errtext, infotext)
            runflag = True
        elif indexAbfrage == i_abfrage_dump_ods:
            (status, errtext) = dump_in_ods(wp_obj,isin_liste)
            if status != hdef.OKAY:
                return (status, errtext, infotext)
            runflag = True
        else:  #if indexAbfrage == i_abfrage_proof_url_subsequent
            (status, errtext,infotext) = proof_url_subsequent(wp_obj,isin_liste,isin_wpname_liste)
            if (status != hdef.OKAY) or (len(infotext)>0):
                return (status, errtext, infotext)
            runflag = True
        # end if
    # end while
    
    return (status, errtext,infotext)


# end def
def edit_isin_basic_info(wp_obj,wpname, isin):
    '''

    Demand: wp_abfrage.edit_basic_info()
    
    Macht ein Editierfenster der basic Infos von der gewünschten isin
    Call: wp_obj.get_basic_info(isin)
    Call: sgui.abfrage_dict(output_dict, title=title)
    Call: wp_obj.save_basic_info(isin, output_dict)
    
    :param wpname:
    :param isin:
    :return: (status,errtext) = wp_abfrage_edit_isin_basic_info(wpname,isin)
    '''
    status = hdef.OKAY
    errtext = ""
    
    # Hole alle basic-Infos
    (status, errtext, output_dict) = wp_obj.get_basic_info(isin)
    if status != hdef.OKAY:
        return (status, errtext)
    # end if
    title = f"Edit values of isin: {isin} name: {wpname}"
    print(title)
    
    # Ändere basic-info dict
    (output_dict, changed_key_liste) = sgui.abfrage_dict(output_dict, title=title)
    
    
    if len(changed_key_liste):
        (status, errtext) = wp_obj.save_basic_info(isin, output_dict)
    
    return (status, errtext)
# end def
def choose_from_gui_for_one_isin(wp_obj):
    """

    - Demand: run_wp_abfrage.py

    Gibt Liste aller WPs mit ISIN und Name an zur Auswahl.
    Auswahl einer isin

    :param wp_obj:
    :return: (status, errtext,isin) = wp_bearbeiten.choose_from_gui_for_one_isin(wp_obj)
    """

    status = hdef.OKAY
    errtext = ""
    isin = ""

    # Hole die dict-Liste mit allen WPs name[isin]
    # ---------------------------------------------
    (status, errtext, wpname_isin_dict) = \
        wp_obj.get_stored_basic_info_wpname_isin_dict()

    if status != hdef.OKAY:
        errtext = f"Error wp_obj.get_stored_basic_info_wpname_isin_dict() errtext = {errtext}"
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

def get_isin_and_wpname_list(wp_obj):
    """

    :param wp_obj:
    :return: (status,errtext,isin_liste,isin_wpname_liste)  = get_isin_and_wpname_list(wp_obj)
    """
    isin_wpname_liste = []
    isin_liste = []
    (status, errtext, wpname_isin_dict) = \
        wp_obj.get_stored_basic_info_wpname_isin_dict()

    if status != hdef.OKAY:
        errtext = f"Error wp_obj.get_stored_basic_info_wpname_isin_dict() errtext = {errtext}"
        return (status, errtext,isin_liste,isin_wpname_liste)
    # end if

    # print(f"wpname_isin_dict = {wpname_isin_dict}")
    isin_wpname_liste = []
    isin_liste = []
    for i, isin in enumerate(wpname_isin_dict.keys()):

        (status, errtext, output_dict) = wp_obj.get_basic_info(isin)
        if status != hdef.OKAY:
            return (status, errtext, isin_liste, isin_wpname_liste)
        # end if

        isin_wpname_liste.append(f"{i}:{isin} : {output_dict["type"]} : {wpname_isin_dict[isin]}")
        isin_liste.append(isin)
    # end for

    return (status, errtext, isin_liste, isin_wpname_liste)
# end def
def dump_in_ods(wp_obj,isin_liste):
    """!
    :param wp_obj:
    :return: (status, errtext) = dump_in_ods(wp_obj)
    """

    (status, errtext, output_dict_list) = wp_obj.get_basic_info(isin_liste)
    if status != hdef.OKAY:
        return (status, errtext)
    # end if

    (status, errtext,file_name) = hdict.write_dict_list_in_ods_table(output_dict_list,"basic_info_dict", "basic_info_dict")

    os.startfile(file_name)

    return (status, errtext)
# end dfe
def proof_url_subsequent(wp_obj,isin_liste,isin_wpname_liste):
    """
    (status, errtext) = proof_url_subsequent(wp_obj,isin_liste,isin_wpname_liste)
    """
    infotext = ""
    (status, errtext, output_dict_list) = wp_obj.get_basic_info(isin_liste)

    for i,isin in enumerate(isin_liste):

        okay1 = proof_url_ariva(output_dict_list[i]["url_ariva"])

        okay2 = proof_url_onvista(output_dict_list[i]["url_onvista"])

        if (okay1 != hdef.OKAY) or (okay2 != hdef.OKAY):

            isin = isin_liste[i]
            wpname = isin_wpname_liste[i] + "no url => none"
            print(isin_wpname_liste[i])
            (status, errtext) = edit_isin_basic_info(wp_obj, wpname, isin)
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


