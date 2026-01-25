import os, sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif


import wp_base
import wp_bearbeiten

from tools import sgui
from tools import hfkt_def as hdef

INT_FILENAME = "K:/data/orga/wp_store/wp_abfrage.ini"

wp_obj = wp_base.WPData(INT_FILENAME)

if wp_obj.status != hdef.OKAY:
    print(f"Error build wp_base.WPData({INT_FILENAME}) errtext = {wp_obj.errtext}")
    exit(1)
# end if

def run_wp_abfrage():

    runflag = True
    
    start_auswahl = ["Ende", "edit basic info","get last price and volume"]
    index_ende = 0
    index_basic_info = 1
    index_price_volume = 2
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
            
            
            (status,errtext) = wp_bearbeiten.edit_basic_info(wp_obj)
            
            if status != hdef.OKAY:
                print(f"Error wp_bearbeiten.edit_basic_info(wp_obj) errtext = {errtext}")
                exit(1)
            # end if
        elif index == index_price_volume:
            print(f"Start Abfrage  \"{start_auswahl[index]}\" ausgewählt")
        
            (status, errtext) = wp_bearbeiten.get_last_price_volume(wp_obj)
            
            if status != hdef.OKAY:
                print(f"Error wp_bearbeiten.get_last_price_volume(wp_obj) errtext = {errtext}")
                exit(1)
            # end if
        
        else:
            print(f"Auswahl: {index} nicht bekannt")
        # endif
    # endwhile
# end def
if __name__ == '__main__':
    
    run_wp_abfrage()
    

# endif

