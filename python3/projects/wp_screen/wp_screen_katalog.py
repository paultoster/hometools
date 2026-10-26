
import os, sys

from win32cryptcon import CRYPT_UNICODE_NAME_ENCODE_DISABLE_CHECK_TYPE_FLAG

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import wp_screen.wp_screen_katalog_command as wp_screen_katalog_command

import tools.hfkt_def as hdef
import tools.hfkt_pickle as hfkt_pickle
import tools.hfkt_io as hio
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
def katalog_start(rd):

    katalog_set(rd)

    if get_status() != hdef.OKAY:
        return
    # end if

    wp_screen_katalog_command.katalog_command(rd)
    if wp_screen_katalog_command.get_status() != hdef.OKAY:
        global STATUS, ERRTEXT
        STATUS = wp_screen_katalog_command.get_status()
        ERRTEXT = wp_screen_katalog_command.get_errtext()
        wp_screen_katalog_command.reset_status()
    # end def
    return
# end def
def katalog_set(rd):
    # Katalog Json-Liste einladen
    if rd.kat["katalog_liste_jsonobj"] is None:

        rd.kat["katalog_liste_filename"] = os.path.join(rd.ini["store_path"],
                                rd.ini["katalog_liste_file_name"]+".json")

        rd.kat["katalog_liste_jsonobj"] = hio.DataJson(rd.kat["katalog_liste_filename"])
    # end if

    rd.kat["katalog_liste"] = rd.kat["katalog_liste_jsonobj"].read_and_get_data()

    if rd.kat["katalog_liste_jsonobj"].get_status() == hdef.NOT_FOUND:
        rd.kat["katalog_liste"] = []
        rd.kat["katalog_liste_jsonobj"].reset_status()
    elif rd.kat["katalog_liste_jsonobj"].get_status() != hdef.OKAY:

        rd.log.write_err(rd.kat["katalog_liste_jsonobj"].get_errtext(), screen=rd.par.LOG_SCREEN_OUT)
        rd.kat["katalog_liste_jsonobj"].reset_status()
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
    rd.kat["katalog_gruppe_isin_dict_jsonobj"] = hio.DataJson(rd.kat["katalog_gruppe_isin_dict_filename"])

    rd.kat["katalog_gruppe_isin_dict"] = rd.kat["katalog_gruppe_isin_dict_jsonobj"].read_and_get_data()

    if rd.kat["katalog_gruppe_isin_dict_jsonobj"].get_status() == hdef.NOT_FOUND:
        rd.kat["katalog_gruppe_isin_dict"] = {}
        rd.kat["katalog_gruppe_isin_dict_jsonobj"].reset_status()
    elif rd.kat["katalog_gruppe_isin_dict_jsonobj"].get_status() != hdef.OKAY:
        rd.log.write_err(rd.kat["katalog_gruppe_isin_dict_jsonobj"].get_errtext(), screen=rd.par.LOG_SCREEN_OUT)
        global STATUS, ERRTEXT
        STATUS = rd.kat["katalog_gruppe_isin_dict_jsonobj"].get_status()
        ERRTEXT = rd.kat["katalog_gruppe_isin_dict_jsonobj"].get_errtext()
        rd.kat["katalog_gruppe_isin_dict_jsonobj"].reset_status()
        return
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
        rd.kat["katalog_gruppe_isin_dict"] = {}
    # end if
    return rd.kat["katalog_gruppe_isin_dict"]
# end def
def get_katalog_isin_liste(rd,katalog):
    """
    :param rd:
    :param katalog:
    :return: isin_liste = wp_screen_katalog.get_katalog_isin_liste(rd,katalog)
    """

    ddict = get_katalog_gruppe_isin_dict(rd,katalog)

    isin_liste = []
    for gruppe in rd.kat["katalog_gruppe_isin_dict"].keys():
        for wert in rd.kat["katalog_gruppe_isin_dict"][gruppe]:
            (status, isin) = htype.type_proof_isin(wert)
            if status == hdef.OKAY:
                isin_liste.append(isin)
            # end if
        # end for
    # end ofr
    return list(set(isin_liste))
# end def
def get_katalog_indice_liste(rd,katalog):
    """
    :param rd:
    :param katalog:
    :return: isin_liste = wp_screen_katalog.get_katalog_isin_liste(rd,katalog)
    """

    ddict = get_katalog_gruppe_isin_dict(rd,katalog)

    indice_liste = []
    for gruppe in rd.kat["katalog_gruppe_isin_dict"].keys():
        for wert in rd.kat["katalog_gruppe_isin_dict"][gruppe]:

            if rd.wpfunc.is_an_indice(wert):
                indice_liste.append(wert)
            # end if
        # end for
    # end ofr
    return list(set(indice_liste))
# end def
def add_katalogname(rd,katalogname):
    """
    :param rd:
    :param katalogname:
    :return:
    """

    # entfernt Leerzeichen, Tabulator (\t), Zeilenumbrüche (\n), geschützte Leerzeichen (\xa0)
    katalog = "".join(katalogname.split()).replace(" ", "")

    if katalog not in rd.kat["katalog_liste"]:

        rd.kat["katalog_liste"].append(katalog)
        rd.kat["katalog_liste_jsonobj"].save(rd.kat["katalog_liste"])

        rd.log.write_info(f"{katalog = } wurde der katalog_liste hinzugefügt")
    else:
        rd.log.write_info(f"{katalog = } gibt es schon in Liste")
    # end if

    return katalog
# end def
def del_katalogname(rd,katalogname):
    """
    :param rd:
    :param katalogname:
    :return:
    """

    if katalogname in rd.kat["katalog_liste"]:
        index = rd.kat["katalog_liste"].index(katalogname)
        del rd.kat["katalog_liste"][index]
        rd.kat["katalog_liste_jsonobj"].save(rd.kat["katalog_liste"])
    # end if
    return
# end def
def modify_gruppe_isin_dict(rd, ddict_mod):
    """
    :param rd:
    :param ddict_mod:
    :return: flag_change
    """
    global STATUS, ERRTEXT, INFOTEXT


    for gruppe in ddict_mod.keys():

        if not isinstance(ddict_mod[gruppe], list):
            liste = [ddict_mod[gruppe]]
            ddict_mod[gruppe] = liste
        # end if
    # end for


    # Proof
    rd.kat["katalog_gruppe_isin_dict"] = ddict_mod
    katalog_gruppe_isin_dict_proof(rd)

    if STATUS != hdef.OKAY:
        return
    # end if


    rd.kat["katalog_gruppe_isin_dict_jsonobj"].save(rd.kat["katalog_gruppe_isin_dict"])

    return
# end def
def add_gruppe_isin_dict(rd,katalogname,katalog_dict):
    """
    :param rd:
    :param katalogname: Name dieses Katalogs
    :param katalog_dict:  dictionary mit gruppe und liste von isins
    """
    global STATUS, ERRTEXT

    katalog_set(rd)

    rd.kat["katalog"] = add_katalogname(rd, katalogname)

    katalog_gruppe_isin_dict_read(rd)
    if STATUS != hdef.OKAY:
        del_katalogname(rd, katalogname)
        return

    modify_gruppe_isin_dict(rd, katalog_dict)
    if STATUS != hdef.OKAY:
        del_katalogname(rd, katalogname)
        return

    return
# end if
