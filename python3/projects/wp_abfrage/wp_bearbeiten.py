import os, sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

from tools import sgui
from tools import hfkt_def as hdef


def edit_basic_info(wp_obj):
    '''
    
    - Demand: run_wp_abfrage.py
    Gibt Liste aller WPs mit ISIN und Name an zur Auswahl.
    Die Auswahl wird mit den basic infos bearbeitet
    - Call: edit_isin_basic_info(wpname, isin)
    
    :param wp_obj:            wp_base.WPData Data Objekt
    :return: (status,errtext) = edit_basic_info(wp_obj)
    '''
    status = hdef.OKAY
    errtext = ""
  
    # Hole die dict-Liste mit allen WPs name[isin]
    #---------------------------------------------
    (status, errtext, wpname_isin_dict) = \
        wp_obj.get_stored_basic_info_wpname_isin_dict()
    
    if status != hdef.OKAY:
        errtext = f"Error wp_obj.get_stored_basic_info_wpname_isin_dict() errtext = {errtext}"
        return (status, errtext)
    # end if
    
    # print(f"wpname_isin_dict = {wpname_isin_dict}")
    isin_wpname_liste = []
    isin_liste = []
    for i, isin in enumerate(wpname_isin_dict.keys()):
        isin_wpname_liste.append(f"{i}:{isin} : {wpname_isin_dict[isin]}")
        isin_liste.append(isin)
    # end for
    
    abfrage_liste = ["edit", "ende", "neu", "delete"]
    i_abfrage_ende = 1
    i_abfrage_edit = 0
    i_abfrage_neu = 2
    # i_abfrage_delete = 3
    
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
                wpname = wpname_isin_dict[isin]
                print(isin_wpname_liste[index])
                (status, errtext) = edit_isin_basic_info(wp_obj,wpname, isin)
                if status != hdef.OKAY:
                    return (status, errtext)
                # end if
            # end if
        elif indexAbfrage == i_abfrage_neu:
            runflag = True
        else:  # if indexAbfrage == i_abfrage_delete:
            runflag = True
        # end if
    # end while
    
    return (status, errtext)


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
def get_last_price_volume(wp_obj):
    """
    - Demand: run_wp_abfrage.py

    Gibt Liste aller WPs mit ISIN und Name an zur Auswahl.
    Die Auswahl wird die letzten Tagespreise und Volumen abgefragt
    - Call: get_last_price_volume_isin(wp_obj,isin)
    
    :param wp_obj:            wp_base.WPData Data Objekt
    :return: (status,errtext) = get_last_price_volume(wp_obj)
    """
    status = hdef.OKAY
    errtext = ""
    
    # Hole die dict-Liste mit allen WPs name[isin]
    # ---------------------------------------------
    (status, errtext, wpname_isin_dict) = \
        wp_obj.get_stored_basic_info_wpname_isin_dict()
    
    if status != hdef.OKAY:
        errtext = f"Error wp_obj.get_stored_basic_info_wpname_isin_dict() errtext = {errtext}"
        return (status, errtext)
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
                
                # Bearbeite basic infos von isin
                isin = isin_liste[index]
                wpname = wpname_isin_dict[isin]
                print(isin_wpname_liste[index])
                (status, errtext) = get_last_price_volume_isin(wp_obj, isin)
                if status != hdef.OKAY:
                    return (status, errtext)
                # end if
            # end if
        else:  # if indexAbfrage == i_abfrage_delete:
            runflag = True
        # end if
    # end while
    
    return (status, errtext)
# end def
def get_last_price_volume_isin(wp_obj, isin):
    """

    :param wp_obj:
    :param isin:
    :return: (status, errtext) = get_last_price_volume_isin(wp_obj, isin)
    """

    last_active_date =
