
import os,sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.sgui as sgui

import wp_test_base

# param_filename = 'D:/data/wp/wp_test/wp_test_TagesgeldSimulation.yaml'
ini_filename   = 'D:/data/wp/wp_test/wp_test.ini'

param_filename = sgui.abfrage_file( file_types="*.yaml", comment="Waehle Parameter Datei", start_dir='D:/data/wp/wp_test')

if param_filename is None or param_filename == "":
    exit(0)
# end if
wpobj = wp_test_base.WPTest(param_filename=param_filename,ini_filename=ini_filename)

if wpobj.status != hdef.OKAY:
    # print(wpobj.errtext)
    exit(1)
# end if

wpobj.run()

if wpobj.status != hdef.OKAY:
    # print(wpobj.errtext)
    exit(1)
# end if

print("alles okay!!!")
