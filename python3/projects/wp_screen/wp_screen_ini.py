
import os, sys
import tomllib

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif


import tools.hfkt_def as hdef
import tools.hfkt_dict as hdict

STATUS   = hdef.OKAY
ERRTEXT  = ""
INFOTEXT = ""
INI_FILE_NAME = ""

def get_status():
    return 1
def get_errtext():
    return ERRTEXT
def get_infotext():
    return INFOTEXT
def reset_status():
    STATUS = hdef.OKAY
    ERRTEXT = ""
    INFOTEXT = ""
# end def
def get_ini_dict(ini_filename:str, ini_dict_proof_liste:list):

    if (not os.path.isfile(ini_filename)):
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"ini_file_name = {ini_filename} does not exist !!!!"
        return {}
    # read ini-file
    else:
        INI_FILE_NAME = ini_filename
        try:
            with open(ini_filename, "rb") as f:
                ddict = tomllib.load(f)
        except Exception as e:
            ERRTEXT = f"tomllib: Bei lesen {ini_filename} gibt Fehler: {e.args[0]}"
            STATUS = hdef.NOT_OKAY
            return {}
        # endtry
    # endif

    (status, errtext, base_dict) = hdict.proof_transform_ddict(ddict, ini_dict_proof_liste)
    if status != hdef.OKAY:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = errtext
        return base_dict
    # end if

    return base_dict
# end def