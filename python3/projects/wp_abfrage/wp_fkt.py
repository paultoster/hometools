
# from bs4 import BeautifulSoup as bs
# import urllib.request
import os
import sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)

import tools.hfkt_def as hdef
# import tools.hfkt_str as hstr
import tools.hfkt_type as htype
import tools.hfkt_date_time as hdt

if os.path.isfile('wp_base.py'):
    import wp_storage as wp_storage
    import wp_playright as wp_pr
    import wp_isin as wp_isin
else:
    import wp_abfrage.wp_storage as wp_storage
    import wp_abfrage.wp_playright as wp_pr
    import wp_abfrage.wp_isin as wp_isin
# end if

FEIERTAGE_XETRA_LLISTE = [
    (1,1,2026,"Neujahr"),
    (3,4,2026,"Karfreitag"),
    (6, 4, 2026, "Ostermontag"),
    (1, 5, 2026, "Tag der Arbeit"),
    (24, 12, 2026, "Heiligabend"),
    (25, 12, 2026, "1. Weihnachtstag"),
    (26, 12, 2026, "2. Weihnachtstag"),
    (31, 12, 2026, "Silvetser")]

XETRA_HANDEL_ENDE_TIME_TUP = (22,0,0)

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
def letzter_beendeter_handelstag_dat_list(boerse):
    """

    :param boerse:
    :return: dat_time_list = letzter_beendeter_handelstag_dat_list(boerse)
    """
    # letzte Handelszeit Zeit
    dat_time_list = hdt.get_akt_dat_time_list()

    # wenn kein Handelstag, dann ein Tag zurück bis Handelstag
    while ist_kein_handestag(dat_time_list,boerse):
        dat_time_list = hdt.verschiebe_dat_tup_in_tagen(dat_time_list,-1)

    # Handelstag auf Handelsschluss setzen
    if boerse == "xetra":
        dat_time_list[3:6] = XETRA_HANDEL_ENDE_TIME_TUP[0:3]
    else:
        raise Exception(f"ausgewählte Börse {boerse} ist nicht implementiert")
    # end if

    # aktuelle Zeit
    akt_dat_time_list = hdt.get_akt_dat_time_list()

    # Wenn aktuelle Zeit nach Handelschluß dann Handelstag nehmen
    if hdt.is_dat_time_list_a_to_b(akt_dat_time_list,dat_time_list,'>'):
        pass
    # Ansosnten einen Tag zurück und prüfen, ob Handelstag
    else:
        dat_time_list = hdt.verschiebe_dat_list_in_tagen(dat_time_list, -1)
        while ist_kein_handestag(dat_time_list, boerse):
            dat_time_list = hdt.verschiebe_dat_tup_in_tagen(dat_time_list, -1)
    # end if
    return dat_time_list
# end def
def ist_kein_handestag(date_tuple,boerse):
    """

    :param date_tuple: (tag,monat,jahr,...)
    :param boerse: 'xetra' bisher
    :return: flag = ist_handestag(date_tuple,boerse)
    """

    # Wochenende
    if hdt.get_isoweekday(date_tuple) > 5:
        return True

    # Feiertage
    if boerse == "xetra":
        if hdt.is_dat_list_a_to_b(date_tuple,FEIERTAGE_XETRA_LLISTE[-1],'>'):
            raise Exception(f"aktuelles Datum: {hdt.str_dat_from_dat_list(date_tuple)} ist später als letzter Feiertag eintrag: {hdt.str_dat_from_dat_list(FEIERTAGE_XETRA_LLISTE[-1])}")
        # end if

        for liste in FEIERTAGE_XETRA_LLISTE:
            if hdt.is_dat_list_a_to_b(date_tuple,liste,'=='):
                return True
            # end if
        # end for
    else:
        raise Exception(f"ausgewählte Börse {boerse} ist nicht implementiert")
    # end if
    return False
# end def
###########################################################################
# testen mit main
###########################################################################
if __name__ == '__main__':

    dat_tup = letzter_beendeter_handelstag_dat_list("xetra")

    print(hdt.str_dat_from_dat_list(dat_tup))