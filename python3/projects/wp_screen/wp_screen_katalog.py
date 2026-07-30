
import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import wp_screen_gui

import tools.hfkt_def as hdef
import tools.hfkt_pickle as hfkt_pickle
import tools.hfkt_list as hlist
import tools.hfkt_type as htype

STATUS   = hdef.OKAY
ERRTEXT  = ""
INFOTEXT = ""


def get_status():
    global STATUS
    return STATUS
def get_errtext():
    global ERRTEXT
    return ERRTEXT
def get_infotext():
    global INFOTEXT
    return INFOTEXT
def reset_status():
    global STATUS
    global ERRTEXT
    global INFOTEXT
    STATUS = hdef.OKAY
    ERRTEXT = ""
    INFOTEXT = ""
# end def
def katalog_set(rd):
    # Katalog Json-Liste einladen
    if rd.kat["katalog_liste_jsonobj"] is None:

        rd.kat["katalog_liste_filename"] = os.path.join(rd.ini["store_path"],
                                rd.ini["katalog_liste_file_name"]+".json")

        rd.kat["katalog_liste_jsonobj"] = hfkt_pickle.DataJson(rd.kat["katalog_liste_filename"])
    # end if

    rd.kat["katalog_liste"] = rd.kat["katalog_liste_jsonobj"].read_and_get_data()

    if rd.kat["katalog_liste_jsonobj"].get_status() == hdef.NOT_FOUND:
        rd.kat["katalog_liste"] = []
    elif rd.kat["katalog_liste_jsonobj"].get_status() != hdef.OKAY:
        rd.log.write_err(rd.kat["katalog_liste_jsonobj"].get_errtext(), screen=rd.par.LOG_SCREEN_OUT)
        return
    # end if
    return
def katalog_gruppe_isin_dict_read(rd):
    """

    :param rd:
    :return: katalog_isin_liste_read(rd)
    """
    rd.kat["katalog_gruppe_isin_dict_filename"] = os.path.join(rd.ini["store_path"],
                            rd.ini["katalog_gruppe_isin_dict_pre_file_name"] + rd.kat["katalog"] + ".json")

    if rd.kat["katalog_gruppe_isin_dict_jsonobj"] is not None:
        del rd.kat["katalog_gruppe_isin_dict_jsonobj"]
    # end if
    rd.kat["katalog_gruppe_isin_dict_jsonobj"] = hfkt_pickle.DataJson(rd.kat["katalog_gruppe_isin_dict_filename"])

    rd.kat["katalog_gruppe_isin_dict"] = rd.kat["katalog_gruppe_isin_dict_jsonobj"].read_and_get_data()

    if rd.kat["katalog_gruppe_isin_dict_jsonobj"].get_status() == hdef.NOT_FOUND:
        rd.kat["katalog_gruppe_isin_dict"] = {}
    elif rd.kat["katalog_gruppe_isin_dict_jsonobj"].get_status() != hdef.OKAY:
        rd.log.write_err(rd.kat["katalog_gruppe_isin_dict_jsonobj"].get_errtext(), screen=rd.par.LOG_SCREEN_OUT)
        global STATUS, ERRTEXT
        STATUS = rd.kat["katalog_gruppe_isin_dict_jsonobj"].get_status()
        ERRTEXT = rd.kat["katalog_gruppe_isin_dict_jsonobj"].get_errtext()
        rd.kat["katalog_gruppe_isin_dict_jsonobj"].reset_status()
    # end if

    # Proof
    katalog_gruppe_isin_dict_proof(rd)

    return
# end
def katalog_gruppe_isin_dict_proof(rd):
    """
    :param rd:
    :return: katalog_gruppe_isin_dict_proof(rd)
    """
    global STATUS, ERRTEXT

    # Proof gruppe darf nur einmal vorkommen
    liste = list(rd.kat["katalog_gruppe_isin_dict"].keys())

    double_liste = hlist.find_multiple_items_list(liste)

    for item in double_liste:
        STATUS  = hdef.NOT_OKAY
        ERRTEXT =ERRTEXT+f"Katalog: {rd.kat["katalog"]} ist die gruppe: {item} mehrfach definiert (Darf nicht sein) \n"
    # end if
    if STATUS != hdef.OKAY:
        return

    # Proof isin oder Indice
    for gruppe in rd.kat["katalog_gruppe_isin_dict"].keys():

        wp_liste =rd.kat["katalog_gruppe_isin_dict"][gruppe]

        for wp in wp_liste:
            (status, wert) = htype.type_proof_isin(wp)
            if status != hdef.OKAY:
                flag = rd.wpfunc.is_an_indice(wp)

                if not flag:
                    STATUS = hdef.NOT_OKAY
                    ERRTEXT = ERRTEXT+f"Katalog: {rd.kat["katalog"]} ist in gruppe: {gruppe} das wp: {wp} keine isin und kein definierter Indice \n"
                # end if
            # end if
        # end for
    # end for

    return
# end def
# #-----------------------------------------------------------
# # Externe Funktionen
# #------------------------------------------------------------
def exist_katalog(rd,katalog):
    if katalog in rd.kat["katalog_liste"]:
        return True
    else:
        return False
    # end if
# end def
def get_katalog_gruppe_isin_dict(rd,katalog):
    if katalog in rd.kat["katalog_liste"]:

        rd.kat["katalog"] = katalog
        katalog_gruppe_isin_dict_read(rd)
    else:
        rd.kat["isin_liste"] = []
    # end if
    return rd.kat["isin_liste"]
# end def