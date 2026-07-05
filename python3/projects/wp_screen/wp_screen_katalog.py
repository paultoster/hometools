
import os, sys
import tomllib

from hfkt_log import log

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import wp_screen_gui

import tools.hfkt_def as hdef
import tools.hfkt_pickle as hfkt_pickle
import tools.hfkt_tvar as htvar
import tools.hfkt_type as htype

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
def katalog_start(rd):

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

    katalog_command(rd)

    return
# end def
def katalog_command(rd):


    auswahl_title = "Katalognamen editieren"
    abfrage_liste = ["edit(isins)","add", "delete", "rename","ende"]
    i_edit = 0
    i_add = 1
    i_delete = 2
    i_rename = 3
    i_ende = 4

    runflag = True

    while runflag:

        auswahl_liste = rd.kat["katalog_liste"]
        n_auswahl_liste = len(auswahl_liste)

        (index, indexAbfrage) = wp_screen_gui.listen_abfrage(rd.gui, auswahl_liste, auswahl_title, abfrage_liste)

        if (indexAbfrage < 0) or (indexAbfrage == i_ende):
            runflag = False
        elif indexAbfrage == i_edit:
            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("katalog_command edit: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                katalog_isin_edit_command(rd, index)
                if get_status() != hdef.OKAY:
                    runflag = False
            # end if
        elif indexAbfrage == i_add:
            katalog_add(rd)
        elif indexAbfrage == i_delete:
            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("katalog_command delete: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                katalog_del(rd, index)
            # end if
        else:  # if indexAbfrage == i_rename:
            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("katalog_command rename: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                katalog_rename(rd, index)
            # end if
    # end while
    return
# end def
def katalog_isin_edit_command(rd, index):
    """

    :param rd:
    :param index:
    :return: katalog_isin_edit_command(rd, index)
    """

    rd.kat["katalog"] = rd.kat["katalog_liste"][index]

    katalog_isin_liste_read(rd)

    if get_status() != hdef.OKAY:
        return


    abfrage_liste = ["ende","update(edit)","modiy(list)", "add", "delete"]

    index_end = 0
    index_update = 1
    index_modify = 2
    index_add = 3
    # index_delete = 4

    runflag = True
    while (runflag):

        ttable = katalog_isin_set_tabelle(rd)
        if get_status() != hdef.OKAY:
            return
        # end if

        (ttable_out, index_abfrage, irow_select, data_change_irow_icol_liste) = \
            wp_screen_gui.katalog_isin_abfrage(rd.gui, ttable, abfrage_liste)

        if (wp_screen_gui.get_status() != hdef.OK):
            STATUS = wp_screen_gui.get_status()
            ERRTEXT = wp_screen_gui.get_errtext()
            wp_screen_gui.reset_status()
            return
        # end if

        # Beenden
        # ----------------------------
        if index_abfrage == index_end:
            runflag = False
        elif index_abfrage == index_update:
            if len(data_change_irow_icol_liste) > 0:
                katalog_isin_edit_update(rd, data_change_irow_icol_liste,ttable_out)
                if get_status() != hdef.OKAY:
                    return
                # end if
            # end if
        elif index_abfrage == index_modify:
            katalog_isin_edit_modify(rd)
            if get_status() != hdef.OKAY:
                return
            # end if
        elif index_abfrage == index_add:
            katalog_isin_edit_add(rd)
            if get_status() != hdef.OKAY:
                return
            # end if
        else: # index_abfrage == index_delete:
            if irow_select < 0:
                rd.log.write_err("katalog_isin_edit_command delete: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                katalog_isin_edit_delete(rd)

    return
# end def
def katalog_add(rd):
    """

    :param rd:
    :return: katalog_add(rd)
    """

    liste_abfrage = ["katalogname"]
    title = "neuem Katalognamen eingeben"
    (liste_ergebnis, status) = wp_screen_gui.eingabe_n_zeilen(rd.gui, liste_abfrage,
                                                              liste_vorgabe=None, title=title)

    if (status != hdef.OKAY) or (liste_ergebnis == []):
        return

    text = liste_ergebnis[0]
    # entfernt Leerzeichen, Tabulator (\t), Zeilenumbrüche (\n), geschützte Leerzeichen (\xa0)
    katalog = "".join(text.split()).replace(" ", "")

    if katalog not in rd.kat["katalog_liste"]:
        rd.log.write_info(f"{katalog = } wurde der katalog_liste hinzugefügt")
    else:
        rd.log.write_info(f"{katalog = } gibt es schon in Liste")
        return
    # end if

    rd.kat["katalog_liste"].append(katalog)

    rd.kat["katalog_liste_jsonobj"].save(rd.kat["katalog_liste"])

    return
# end def
def katalog_del(rd,index):
    """
    :param rd:

    :param index:
    :return: return
    """

    del rd.kat["katalog_liste"][index]
    rd.kat["katalog_liste_jsonobj"].save(rd.kat["katalog_liste"])

    return
# end def
def katalog_rename(rd, index):

    liste_abfrage = ["katalogname"]
    title = "Umbenennen Katalognamen"
    liste_vorgabe = [rd.kat["katalog_liste"][index]]
    (liste_ergebnis, status) = wp_screen_gui.eingabe_n_zeilen(rd.gui, liste_abfrage,
                                                              liste_vorgabe=liste_vorgabe, title=title)

    if (status != hdef.OKAY) or (liste_ergebnis == []):
        return

    text = liste_ergebnis[0]
    # entfernt Leerzeichen, Tabulator (\t), Zeilenumbrüche (\n), geschützte Leerzeichen (\xa0)
    katalog = "".join(text.split()).replace(" ", "")

    if katalog != rd.kat["katalog_liste"][index]:
        rd.kat["katalog_liste"][index] = katalog
        rd.kat["katalog_liste_jsonobj"].save(rd.kat["katalog_liste"])
    # end if
    return
# end def
def katalog_isin_liste_read(rd):
    """

    :param rd:
    :return: katalog_isin_liste_read(rd)
    """
    rd.kat["isin_liste_filename"] = os.path.join(rd.ini["store_path"],
                            rd.ini["katalog_isin_liste_pre_file_name"] + rd.kat["katalog"] + ".json")

    if rd.kat["isin_liste_jsonobj"] is not None:
        del rd.kat["isin_liste_jsonobj"]
    # end if
    rd.kat["isin_liste_jsonobj"] = hfkt_pickle.DataJson(rd.kat["isin_liste_filename"])

    rd.kat["isin_liste"] = rd.kat["isin_liste_jsonobj"].read_and_get_data()

    if rd.kat["isin_liste_jsonobj"].get_status() == hdef.NOT_FOUND:
        rd.kat["isin_liste"] = []
    elif rd.kat["isin_liste_jsonobj"].get_status() != hdef.OKAY:
        rd.log.write_err(rd.kat["isin_liste_jsonobj"].get_errtext(), screen=rd.par.LOG_SCREEN_OUT)
    # end if
    return
# end def
def katalog_isin_set_tabelle(rd):
    """

    :param rd:
    :return: ttable = katalog_isin_tabelle(rd)
    """

    data_lliste = []
    for isin in rd.kat["isin_liste"]:

        table_dat = []

        (status, errtext, wp_dict) = rd.wpfunc.get_basic_info(isin)

        if status != hdef.OKAY:
            STATUS = status
            ERRTEXT = errtext
            return
        # end if

        table_dat.append(isin)
        table_dat.append(wp_dict["name"])
        table_dat.append(wp_dict["sektor"])

        data_lliste.append(table_dat)

    # end for
    name_liste = ["isin","name","sektor"]
    type_lsite = ["str","str","str"]
    ttable = htvar.build_table(name_liste, data_lliste, type_lsite)

    return ttable
# end def
def katalog_isin_edit_update(rd, data_change_irow_icol_liste,ttable_out):
    """

    :param rd:
    :param data_change_irow_icol_liste:
    :param ttable_out:
    :return: return
    """
    flag_change = False
    for (irow, icol) in data_change_irow_icol_liste:
        value = ttable_out.table[irow][icol]
        name = ttable_out.names[icol]
        type = ttable_out.types[icol]

        if name == "isin": # "name" kann nicht geändert werden

            (status,wert) = htype.type_proof_isin(value)
            if status != hdef.OKAY:
                rd.log.write_info(f"In {irow = }, {icol = } : isin = {value} ist falsch", screen=rd.par.LOG_SCREEN_OUT)
            else:
                flag_change = True
                rd.kat["isin_liste"][irow] = wert
            # end if
        elif name == "sektor":
            (status,wert) = htype.type_proof_string(value)
            if status != hdef.OKAY:
                rd.log.write_info(f"In {irow = }, {icol = } : sektor = {value} ist falsch", screen=rd.par.LOG_SCREEN_OUT)
            else:
                isin = rd.kat["isin_liste"][irow]
                rd.wpfunc.set_value_in_basic_info(isin,"sektor",wert)
            # end if

        else:
            rd.log.write_info(f"Von {irow = }, {icol = } kann nicht editiert werden", screen=rd.par.LOG_SCREEN_OUT)
        # end if
    # end for
    if flag_change:
        rd.kat["isin_liste_jsonobj"].save(rd.kat["isin_liste"])
    # end if
    return
# end def
def katalog_isin_edit_modify(rd):
    """

    :param rd:
    :return: return
    """

    isin_list_mod = wp_screen_gui.katalog_isin_liste_modify(rd.gui,
                                                            rd.kat["katalog"],
                                                            rd.kat["isin_liste"])
    flag_change = False
    for i, isin_mod in enumerate(isin_list_mod):
        if i < len(rd.kat["isin_liste"]):
            if rd.kat["isin_liste"][i] != isin_mod:
                (status,wert) = htype.type_proof_isin(isin_mod)
                if status != hdef.OKAY:
                    rd.log.write_info(f"isin_mod = {isin_mod} ist keine isin", screen=rd.par.LOG_SCREEN_OUT)
                else:
                    flag_change = True
                    rd.kat["isin_liste"][i] = wert
                # end if
            # end if
        else:
            rd.kat["isin_liste"].append(isin_mod)
            flag_change = True
        # end if
    # end for
    if flag_change:
        rd.kat["isin_liste_jsonobj"].save(rd.kat["isin_liste"])
    # end if
    return
# end def
def katalog_isin_edit_add(rd):
    """

    :param rd:
    :return: katalog_isin_edit_add(rd)
    """

    liste_abfrage = ["isin"]
    title = f"neuem isin eingeben für katalog = {rd.kat["katalog"]}"
    (liste_ergebnis, status) = wp_screen_gui.eingabe_n_zeilen(rd.gui, liste_abfrage,
                                                              liste_vorgabe=None, title=title)

    if (status != hdef.OKAY) or (liste_ergebnis == []):
        return

    text = liste_ergebnis[0]
    # entfernt Leerzeichen, Tabulator (\t), Zeilenumbrüche (\n), geschützte Leerzeichen (\xa0)
    isin_mod = "".join(text.split()).replace(" ", "")

    (status, wert) = htype.type_proof_isin(isin_mod)
    if status != hdef.OKAY:
        rd.log.write_info(f"isin_mod = {isin_mod} ist keine isin", screen=rd.par.LOG_SCREEN_OUT)
    else:
        rd.kat["isin_liste"].append(wert)
        rd.kat["isin_liste_jsonobj"].save(rd.kat["isin_liste"])
    # end if
    return
# end def
def katalog_isin_edit_delete(rd,index):
    """

    :param rd:
    :return:
    """
    del rd.kat["isin_liste"][index]
    rd.kat["isin_liste_jsonobj"].save(rd.kat["isin_liste"])

    return
# end def
