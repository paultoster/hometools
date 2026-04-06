import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

from wp_abfrage import wp_base
from wp_abfrage import wp_bearbeiten

from tools import sgui
from tools import hfkt_def as hdef

INT_FILENAME = "D:/data/orga/wp_store/wp_abfrage.ini"

wp_obj = wp_base.WPData(INT_FILENAME)

if wp_obj.status != hdef.OKAY:
    print(f"Error build wp_base.WPData({INT_FILENAME}) errtext = {wp_obj.errtext}")
    exit(1)
# end if

def run_wp_abfrage():

    runflag = True
    
    start_auswahl = ["Ende", "edit basic info","get last price and volume","EURUSD-Kurs lese aus EZB-xml-data", "EURUSD-Kurs hole aktuellen aus yfinance"]
    index_ende = 0
    index_basic_info = 1
    index_price_volume = 2
    index_eurousd_ezb_xml = 3
    index_eurousd_ezb_yfinance = 4
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
            
            
            (status,errtext,infotext) = wp_bearbeiten.edit_basic_info(wp_obj)

            if len(infotext) > 0 :
                sgui.anzeige_text(f"Info wp_bearbeiten.edit_basic_info(wp_obj): {infotext}",textcolor='orange')
            
            if status != hdef.OKAY:
                sgui.anzeige_text(f"Error wp_bearbeiten.edit_basic_info(wp_obj) errtext = {errtext}",textcolor='red')
                exit(1)
            # end if

        elif index == index_price_volume:

            print(f"Start Abfrage  \"{start_auswahl[index]}\" ausgewählt")

            (status, errtext,isin) = wp_bearbeiten.choose_from_gui_for_one_isin(wp_obj)
            (status, errtext) = wp_obj.update_price_volume(isin)wp_bearbeiten.get_last_price_volume(wp_obj)
            
            if status != hdef.OKAY:
                print(f"Error wp_bearbeiten.get_last_price_volume(wp_obj) \n errtext = {errtext}")
                exit(1)
            # end if

        elif index == index_eurousd_ezb_xml:

            print(f"Start Abfrage  \"{start_auswahl[index]}\" ausgewählt")
            print("Siehe: https://www.ecb.europa.eu/stats/policy_and_exchange_rates/euro_reference_exchange_rates/html/eurofxref-graph-usd.de.html")
            print("Download XML unter dem Chart")

            # Abfrage xml-File
            xmlfilename = sgui.abfrage_file(file_types="*.xml",comment=f"Wähle eine xml-Datei von EZB",start_dir=wp_obj.base_ddict["store_path"])
            if len(xmlfilename) > 0 :
                # Einlesen xml-File
                (status, errtext) = wp_obj.process_usdeuro_ezb_xml(xmlfilename)

                if status != hdef.OKAY:
                    print(f"Error wp_obj.process_usdeuro_ezb_xml(xmlfilename) \n errtext = {errtext}")
                # end if
            # end if

        elif index == index_eurousd_ezb_yfinance:

            print(f"Start Abfrage  \"{start_auswahl[index]}\" ausgewählt")
            print("Wird mit yfinace eingelesen")

            (status, errtext) = wp_obj.process_akt_usdeuro()

            if status != hdef.OKAY:
                print(f"Error wp_obj.process_akt_usdeuro() \n errtext = {errtext}")

        else:
            print(f"Auswahl: {index} nicht bekannt")
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

