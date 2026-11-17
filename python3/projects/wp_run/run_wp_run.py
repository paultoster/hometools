
import os,sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
# import tools.sgui as sgui

import wp_run_base

ini_filename   = 'D:/data/wp/wp_run/wp_run.ini'

if (len(sys.argv) > 1) and isinstance(sys.argv[1],str):
    base_path = sys.argv[1]
else:
    base_path = 'D:/data/wp'
# end if

wpobj = wp_run_base.WPRun(base_path=base_path)

if wpobj.status != hdef.OKAY:
    # print(wpobj.errtext)
    exit(1)
# end if

wpobj.run()

if wpobj.status != hdef.OKAY:
    # print(wpobj.errtext)
    exit(1)
# end if

wpobj.last()
