
from bs4 import BeautifulSoup as bs
import urllib.request
import os


import tools.hfkt_def as hdef
import tools.hfkt_str as hstr
import tools.hfkt_type as htype
import time

if os.path.isfile('wp_base.py'):
    import wp_storage as wp_storage
    import wp_playright as wp_pr
    import wp_isin as wp_isin
else:
    import wp_abfrage.wp_storage as wp_storage
    import wp_abfrage.wp_playright as wp_pr
    import wp_abfrage.wp_isin as wp_isin
# end if
def check_store_path(ddict):
    '''

    :return:
    '''
    status  = hdef.OKAY
    errtext = ""
    if not os.path.isdir(ddict["store_path"]):
        try:
            os.mkdir(ddict["store_path"])
        except:
            t = ddict["store_path"]
            errtext = f"Der store_path: {t} konnte nicht erstellt werden"
            status = hdef.NOT_OKAY
        # end try
    # end if
    return (status,errtext)

def check_isin_input(isin_input):
    '''
    
    :param isin_input:
    :param ddict:
    :return: (status,errtext,isin_input_is_list,isin_list) = check_isin_input(isin_input)
    '''
    
    isin_input_is_list = False
    isin_list = []
    status = hdef.OKAY
    errtext = ""
    
    if isinstance(isin_input, str):
        isin_list = [isin_input]
    elif isinstance(isin_input, list):
        (okay, value) = htype.type_proof(isin_input, "listStr")
        if okay != hdef.OKAY:
            status = hdef.NOT_OKAY
            errtext = f"isin = {isin_input} ist keine Liste mit strings"
            return (status,errtext,isin_input_is_list, isin_list)
        else:
            isin_input_is_list = True
            isin_list = value
    else:
        errtext = f"isin = {isin_input} ist kein string"
        status = hdef.NOT_OKAY
        return (status,errtext,isin_input_is_list, isin_list)
    # end if
    
    for isin in isin_list:
        (okay, value) = htype.type_proof(isin, 'isin')
        if okay != hdef.OKAY:
            
            (okay, value) = htype.type_proof(isin, 'wkn')
            if okay != hdef.OKAY:
                status = hdef.NOT_OKAY
                errtext = f"isin = {isin} ist kein passender Wert"
                return (status,errtext,isin_input_is_list, isin_list)
            # end if
        # end if
    # end for

    return (status,errtext,isin_input_is_list, isin_list)
# end def

