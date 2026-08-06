


import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import wp_screen_gui
import wp_screen_katalog

import tools.hfkt_def as hdef
import tools.hfkt_type as htype
import tools.hfkt_tvar as htvar

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
def get_katalog_auswahl(rd):

    wp_screen_katalog.katalog_set(rd)

    (index, _) = wp_screen_gui.listen_abfrage(rd.gui, rd.kat["katalog_liste"], auswahl_title="Auswahl Katalog")

    if index >= 0:
        katalog = rd.kat["katalog_liste"][index]

    else:
        katalog = None
    # end if

    return katalog
# end def
def katalog_command(rd):

    global STATUS
    global ERRTEXT
    global INFOTEXT

    auswahl_title = "Katalognamen editieren"
    abfrage_liste = ["edit(wps)","add", "delete", "rename","ende"]
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
                katalog_gruppe_isin_dict_edit_command(rd, index)
                if get_status() != hdef.OKAY:
                    runflag = False
            # end if
        elif indexAbfrage == i_add:
            katalog_command_add(rd)
        elif indexAbfrage == i_delete:
            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("katalog_command delete: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                katalog_command_del(rd, index)
            # end if
        else:  # if indexAbfrage == i_rename:
            if (index < 0) or (index >= n_auswahl_liste):
                rd.log.write_err("katalog_command rename: index out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                katalog_command_rename(rd, index)
            # end if
    # end while
    return
# end def
def katalog_command_add(rd):
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
def katalog_command_del(rd,index):
    """
    :param rd:

    :param index:
    :return: return
    """
    flag = wp_screen_gui.janein_abfrage(rd.gui, f"Soll wirklich das Element {index = } name = \"{rd.sig["katalog_liste"][index]}\" gelöscht werden?",
                                    "Löschen ja/nein")
    if flag:
        del rd.kat["katalog_liste"][index]
        rd.kat["katalog_liste_jsonobj"].save(rd.kat["katalog_liste"])
    # end if


    return
# end def
def katalog_command_rename(rd, index):

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

def katalog_gruppe_isin_dict_edit_command(rd, index):
    """

    :param rd:
    :param index:
    :return: katalog_isin_edit_command(rd, index)
    """
    global STATUS
    global ERRTEXT

    rd.kat["katalog"] = rd.kat["katalog_liste"][index]

    wp_screen_katalog.katalog_gruppe_isin_dict_read(rd)

    if wp_screen_katalog.get_status() != hdef.OKAY:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = wp_screen_katalog.get_errtext()
        wp_screen_katalog.reset_status()
        return
    # end if


    abfrage_liste = ["update(dict)","modify(dict)","ende"]

    index_update = 0
    index_modify = 1
    index_end = 2

    runflag = True
    while (runflag):



        ttable = katalog_dict_set_tabelle(rd)
        if get_status() != hdef.OKAY:
            return
        # end if

        title = f"Zeigt den Katalog: {rd.kat["katalog"]} ( die Gruppe ist der key und value eine liste mit wks)"

        (ttable_mod,index_abfrage,irow,data_change_irow_icol_liste) = wp_screen_gui.katalog_dict_table_abfrage(rd.gui,ttable, abfrage_liste, title)

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
                katalog_gruppe_isin_dict_edit_update(rd, data_change_irow_icol_liste,ttable_mod)
                if get_status() != hdef.OKAY:
                    return
                # end if
            # end if
        else:  # index_abfrage == index_modify:
            katalog_gruppe_isin_dict_modify(rd)
            if get_status() != hdef.OKAY:
                return
            # end if
        # end if
    return
# end def
def katalog_dict_set_tabelle(rd):
    """

    :param rd:
    :return: ttable = katalog_isin_tabelle(rd)
    """


    m = 0
    for gruppe in rd.kat["katalog_gruppe_isin_dict"].keys():
        if isinstance(rd.kat["katalog_gruppe_isin_dict"][gruppe],list):
            m = max(m,len(rd.kat["katalog_gruppe_isin_dict"][gruppe]))
        else:
            m = max(m,1)
        # end if
    # end for

    if m == 0:
        m = 5 # 5 leerspalten
    else:
         m += 2  # plus zwei spalten
    # end if

    data_lliste = []
    for gruppe in rd.kat["katalog_gruppe_isin_dict"].keys():

        table_dat = ["" for i in range(m)]

        table_dat[0] = gruppe
        if isinstance(rd.kat["katalog_gruppe_isin_dict"][gruppe],list):
            for j,wp in enumerate(rd.kat["katalog_gruppe_isin_dict"][gruppe]):
                table_dat[j+1] = wp
        else:
            table_dat[1] = rd.kat["katalog_gruppe_isin_dict"][gruppe]
        # end if

        data_lliste.append(table_dat)
    else:
        table_dat = ["" for i in range(m)]
        data_lliste.append(table_dat)
    # end for
    name_liste    = ["wp" for i in range(m)]
    name_liste[0] = "gruppe"
    type_liste    = ["str" for i in range(m)]
    ttable = htvar.build_table(name_liste, data_lliste, type_liste)

    return ttable
# end def
def katalog_gruppe_isin_dict_edit_update(rd, data_change_irow_icol_liste,ttable_mod):
    """
    :param rd:
    :param data_change_irow_icol_liste:
    :param ttable_mod:
    :return: katalog_gruppe_isin_dict_edit_update(rd, data_change_irow_icol_liste,ttable_mod)
    """
    global STATUS
    global ERRTEXT

    flag_change = False
    for (irow, icol) in data_change_irow_icol_liste:
        value = ttable_mod.table[irow][icol]
        name = ttable_mod.names[icol]
        type = ttable_mod.types[icol]

        liste = list(rd.kat["katalog_gruppe_isin_dict"].keys())

        if name == "gruppe": # "name" kann nicht geändert werden


            (status,wert) = htype.type_proof(value,type)
            if status != hdef.OKAY:
                rd.log.write_info(f"katalog_gruppe_isin_dict_edit_update: In {irow = }, {icol = } : isin = {value} ist falsch", screen=rd.par.LOG_SCREEN_OUT)
            else:
                flag_change = True
                if irow >= len(liste):
                    rd.kat["katalog_gruppe_isin_dict"][wert] = []
                else:
                    old_key = liste[irow]
                    rd.kat["katalog_gruppe_isin_dict"][wert] = rd.kat["katalog_gruppe_isin_dict"][old_key]

                    del rd.kat["katalog_gruppe_isin_dict"][old_key]
                # end if
            # end if
        else:
            (status,wert) = htype.type_proof(value,type)
            if status != hdef.OKAY:
                rd.log.write_info(f"katalog_gruppe_isin_dict_edit_update: In {irow = }, {icol = } : sektor = {value} ist falsch", screen=rd.par.LOG_SCREEN_OUT)
            else:
                key = liste[irow]
                i = icol-1
                if i < len(rd.kat["katalog_gruppe_isin_dict"][key]):
                    rd.kat["katalog_gruppe_isin_dict"][key][icol-1] = wert
                else:
                    rd.kat["katalog_gruppe_isin_dict"][key].append(wert)
            # end if
        # end if
    # end for


    if flag_change:

        # Proof
        wp_screen_katalog.katalog_gruppe_isin_dict_proof(rd)

        if wp_screen_katalog.get_status() != hdef.OKAY:
            STATUS = hdef.NOT_OKAY
            ERTEXT = wp_screen_katalog.get_errtext()
            wp_screen_katalog.reset_status()
            return
        # end if

        rd.kat["katalog_gruppe_isin_dict_jsonobj"].save(rd.kat["katalog_gruppe_isin_dict"])
    # end if
    return
# end def
def katalog_gruppe_isin_dict_modify(rd):
    """
    :param rd:
    :return: katalog_gruppe_isin_dict_modify(rd)
    """

    global STATUS
    global ERRTEXT

    runflag = True
    while runflag:

        ddict_mod = wp_screen_gui.katalog_gruppe_isin_dict_modify(rd.gui,
                                                                rd.kat["katalog"],
                                                                rd.kat["katalog_gruppe_isin_dict"])
        flag_change = False
        for gruppe in ddict_mod.keys():

            if not isinstance(ddict_mod[gruppe], list):
                liste = [ddict_mod[gruppe]]
                ddict_mod[gruppe] = liste
            # end if


            for wp in ddict_mod[gruppe]:

                if not rd.wpfunc.is_wp(wp):
                    rd.log.write_info(f"katalog_gruppe_isin_dict_modify: In Gruppe = {gruppe} Wertpapier = {wp} ist keine gültiges wertpapier (isin oder indice)", screen=rd.par.LOG_SCREEN_OUT)
                    flag_change = False
                    break
                else:
                    flag_change = True
                # end if
            # end for
        # end for


        if flag_change:

            # Proof
            wp_screen_katalog.katalog_gruppe_isin_dict_proof(rd)

            if wp_screen_katalog.get_status() != hdef.OKAY:
                STATUS = hdef.NOT_OKAY
                ERTEXT = wp_screen_katalog.get_errtext()
                wp_screen_katalog.reset_status()
                return
            # end if

            rd.kat["katalog_gruppe_isin_dict"] = ddict_mod
            rd.kat["katalog_gruppe_isin_dict_jsonobj"].save(rd.kat["katalog_gruppe_isin_dict"])
            runflag = False
        # end if
    # end while
    return
# end def

