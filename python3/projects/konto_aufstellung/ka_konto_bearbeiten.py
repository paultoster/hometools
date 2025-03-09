
import os, sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import ka_konto_reports_read as ka_konto_read

import hfkt_def as hdef
import hfkt_log as hlog
import sgui
def bearbeiten(rd):
    status = hdef.OKAY
    return status
# enddef