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
import run_wp_test_plot

BASE_PATH   = 'D:/data/wp'

auswahl_liste = ["yaml", "tabelle","plot"]
i_yaml = 0
i_tabelle = 1
i_plot = 2
index = sgui.radiobutton_dialog(auswahl_liste, title="Welche Auswertung soll laufen")
print(f"index_out = {index}")
if index == -1:
    exit(1)
elif index == i_yaml:
    print("yaml")
    run_wp_test_yaml.run_wp_test_yaml(BASE_PATH)
elif index == i_tabelle:
    print("tabelle")
    run_wp_test_tabelle.run_wp_test_tabelle(BASE_PATH)
else:
    print("plot")
    run_wp_test_plot.run_wp_test_plot(BASE_PATH)
# ed if
