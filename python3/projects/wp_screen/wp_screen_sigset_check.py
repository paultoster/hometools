
import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
# import tools.hfkt_pickle as hfkt_pickle
# import tools.hfkt_tvar as htvar
# import tools.hfkt_type as htype

STATUS   = hdef.OKAY
ERRTEXT  = ""
INFOTEXT = ""


def get_status():
    return STATUS
def get_errtext():
    return ERRTEXT
def get_infotext():
    return INFOTEXT
def reset_status():
    STATUS = hdef.OKAY
    ERRTEXT = ""
    INFOTEXT = ""
# end def

def check(rd,ddict):
    """
    check dicctionary signal definition set
    :param rd:
    :param ddict:
    :return: okay = check(rd,ddict)
    """
    okay = hdef.OKAY
    infotext = ""

    return (okay,infotext)
# end def
def hilfe(rd):
    """

    :param rd:
    :return: infotext = hilfe(rd)
    """
    n1 = 20
    n2 = 20

    infotext = ""

    val1 = rd.par.SIG_NULL
    val2 = "Signal wird ignoriert"

    infotext += format_text(val1,val2,rd.par.SIG_COMMENT)

    val1 = rd.par.SIG_COMMENT
    val2 = "Kommentar"

    infotext += "\n" + format_text(val1,val2,rd.par.SIG_COMMENT)


    return infotext
# end def
def format_text(val1,val2,comment):
    n1 = 20
    n2 = 20
    text = f"={val1:<{n1}}{comment}{val2:<{n2}}"
    return text
# end def