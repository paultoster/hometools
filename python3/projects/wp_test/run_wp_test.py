import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

# Hilfsfunktionen
# from tools import hfkt_def as hdef
import tools.sgui as sgui

import run_wp_test_yaml
import run_wp_test_tabelle

BASE_PATH   = 'D:/data/wp'

auswahl_liste = ["yaml", "tabelle"]
i_yaml = 0
i_tabelle = 1
index = sgui.radiobutton_dialog(auswahl_liste, title="Welche Auswertung soll laufen")
if index == -1:
    exit(1)
elif index == i_yaml:
    run_wp_test_yaml.run_wp_test_yaml(BASE_PATH)
else:
    run_wp_test_tabelle.run_wp_test_tabelle(BASE_PATH)
# ed if
