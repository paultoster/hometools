import os, sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif


import wp_base
from tools import sgui
from tools import hfkt_def as hdef

STORE_PATH = "K:/data/orga/wp_store"
USE_JSON   = 0 # 0: don't 1: write, 2: read

wp_obj = wp_base.WPData(STORE_PATH,USE_JSON)

if wp_obj.status != hdef.OKAY:
    print(f"Error build wp_base.WPData({STORE_PATH},{USE_JSON}) errtext = {wp_obj.errtext}")
    exit(1)
# end if

def run_wp_abfrage():

    runflag = True
    
    start_auswahl = ["Ende", "edit basic info"]
    index_ende = 0
    index_basic_info = 1
    index_iban = 3
    index_konto = 4
    index_depot = 5
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
            print(f"Start Abfrage  \"{start_auswahl[index]}\" ausgewählt")
            (status, errtext, wpname_isin_dict) = wp_obj.get_basic_info_wpname_isin_dict()
            if status != hdef.OKAY:
                print(f"Error wp_obj.get_basic_info_wpname_isin_dict() errtext = {errtext}")
                exit(1)
            # end if
            (status,errtext) = wp_abfrage_edit_basic_info(wpname_isin_dict)
            if status != hdef.OKAY:
                print(f"Error wp_abfrage_edit_basic_info(wpname_isin_dict) errtext = {errtext}")
                exit(1)
            # end if
        else:
            print(f"Auswahl: {index} nicht bekannt")
        # endif
    # endwhile
# end def
def wp_abfrage_edit_basic_info(wpname_isin_dict):
    '''
    
    :param wpname_isin_dict:
    :return: (status,errtext) = edit_basic_info(wpname_isin_dict)
    '''
    status = hdef.OKAY
    errtext = ""
    
    print(f"wpname_isin_dict = {wpname_isin_dict}")
    isin_wpname_liste = []
    isin_liste = []
    for i,isin in enumerate(wpname_isin_dict.keys()):
        isin_wpname_liste.append(f"{i}:{isin} : {wpname_isin_dict[isin]}")
        isin_liste.append(isin)
    # end for

    abfrage_liste = ["edit","ende", "neu","delete"]
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
                isin = isin_liste[index]
                wpname   = wpname_isin_dict[isin]
                print(isin_wpname_liste[index])
                (status,errtext) = wp_abfrage_edit_isin_basic_info(wpname,isin)
                if status != hdef.OKAY:
                    return (status,errtext)
                # end if
            # end if
        elif indexAbfrage == i_abfrage_neu:
            runflag = True
        else:  # if indexAbfrage == i_abfrage_delete:
            runflag = True
        # end if
    # end while

    return (status,errtext)
# end def
def wp_abfrage_edit_isin_basic_info(wpname,isin):
    '''
    
    :param wpname:
    :param isin:
    :return: (status,errtext) = wp_abfrage_edit_isin_basic_info(wpname,isin)
    '''
    status = hdef.OKAY
    errtext = ""

    (status, errtext, output_dict) = wp_obj.get_basic_info(isin)
    if status != hdef.OKAY:
        return (status, errtext)
    # end if
    title = f"Edit values of isin: {isin} name: {wpname}"
    # print(title)
    (output_dict,changed_key_liste) = sgui.abfrage_dict(output_dict, title=title)
    
    if len(changed_key_liste):
        (status,errtext) = wp_obj.save_basic_info(isin,output_dict)
        
    return (status,errtext)

if __name__ == '__main__':
    
    run_wp_abfrage()
    

# endif

