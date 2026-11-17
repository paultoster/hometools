
import os,sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.sgui as sgui

import wp_opt_base

# param_filename = 'D:/data/wp/wp_test/wp_test_TagesgeldSimulation.yaml'

base_path      = 'D:/data/wp'
start_path     = os.path.join(base_path,'wp_test')

param_filenames = sgui.abfrage_files( file_types="*.yaml",
                                    comment="Waehle Yaml-Parameter Datei",
                                    start_dir=start_path)
for param_filename in param_filenames:
    if param_filename is None or param_filename == "":
        exit(0)
    # end if

    wpobj = wp_opt_base.WPOpt(param_filename=param_filename,base_path=base_path)

    if wpobj.status != hdef.OKAY:
        print(wpobj.errtext)
        exit(1)
    # end if

    wpobj.run_opt()

    if wpobj.status != hdef.OKAY:
        print(wpobj.errtext)
        exit(1)
    # end if

    del wpobj
# end for



if wpobj.status != hdef.OKAY:
    # print(wpobj.errtext)
    exit(1)
# end if

print("alles okay!!!")

