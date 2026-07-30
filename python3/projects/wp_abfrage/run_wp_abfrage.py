import os, sys

from hfkt_log import log

t_path, _ = os.path.split(__file__)
if len(t_path) > 0 :
    tools_path = t_path + "\\.."
else:
    tools_path = ".."
# end if
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

from tools import sgui
from tools import hfkt_def as hdef

from wp_abfrage import wp_base
from wp_abfrage import wp_bearbeiten


INT_FILENAME = "D:/data/orga/wp_store/wp_abfrage.ini"

wb_obj = wp_base.WPData(INT_FILENAME)

if wb_obj.status != hdef.OKAY:
    print(f"Error build wp_base.WPData({INT_FILENAME}) errtext = {wb_obj.errtext}")
    exit(1)
# end if

def run_wp_abfrage():

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
            
            
            (status,errtext,infotext) = wp_bearbeiten.edit_basic_info(wb_obj)

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

            (status, errtext, infotext) = wp_bearbeiten.edit_price_volume(wb_obj)

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

            (status, errtext,infotext) = wp_bearbeiten.edit_indices(wb_obj)
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

