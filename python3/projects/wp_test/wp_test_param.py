"""
    Platzhalter Parameter
    In den einzelnen Parameter können mit Wertzuweiseung "@Platzhaltername@" Parametervariationen durchgeführt werden

    par_Name                Name des Parameters muss mit "par_" beginnen und der Name entspricht dem Platzhalter @Name@
        type:               Unterparameter mit Werten: "liste",
        format:             (default = "str") Gibt das Format an "str", "float" oder "int" um den string in das richtige Format zu brinegn
        liste:              Unterparameter mit den Werten des Platzhalters als Liste
            - wert1
            - wert2
            ...

    Parameter:

"""
PARAM_LLIST = [
("StartDat_str",           "Beginn der Simulation (01.01.2000)",{"type":"datStrP"}),
("EndDat_str",             "Ende der Simulation  (31.10.2015)",{"type":"datStrP"}),
("ErsterTagPruefung",      "Erste Prüfung der Strategie kann Wochentag oder ein Tag (Mo,Di,Mi,Do,Fr,Sa,So, 1 ... (30,31))",{"wert":["Mo","Di","Do","Fr","Sa","So"],"type":"int"}),
("WiederholTagPruefung",   "Wiederholtag zu Prüfung ist Wochentag oder Monatsdatume  (Mo,Di,Mi,Do,Fr,Sa,So, 1 ... (30,31))",{"wert":["Mo","Di","Do","Fr","Sa","So"],"type":"int"}),
("ErsterTagErgebnis",       "Erste Ergebnisausgabe (Zwischenergebnis) der Strategie kann Wochentag oder ein Tag (Mo,Di,Mi,Do,Fr,Sa,So, 1 ... (30,31))",{"wert":["Mo","Di","Do","Fr","Sa","So"],"type":"int"}),
("WiederholTagErgebnis",    "Wiederholtag Ergebinsausgabe ist Wochentag oder Monatsdatume  (Mo,Di,Mi,Do,Fr,Sa,So, 1 ... (30,31))",{"wert":["Mo","Di","Do","Fr","Sa","So"],"type":"int"}),
("StartCash",               "Startkapital in Euro  (10,000,00 )",{"type":"euroStrK"}),
("ZinsKontoPruefung",       "Soll verbleibender Cash auf Zinskonto gelegt werden  (True/False, bool)",{"type":"bool"}),
("ErsterTagZinsAbrechnung", "Erste Zinsabrechnung der Strategie kann Wochentag oder ein Tag (Mo,Di,Mi,Do,Fr,Sa,So, 1 ... (30,31))",{"wert":["Mo","Di","Do","Fr","Sa","So"],"type":"int"}),
("WiederholTagZinsAbrechnung", "Wiederholtag Ergebinsausgabe ist Wochentag oder Monatsdatume  (Mo,Di,Mi,Do,Fr,Sa,So, 1 ... (30,31))",{"wert":["Mo","Di","Do","Fr","Sa","So"],"type":"int"}),
("SimName",                 "Name der Simulation  (TestLauf, str)",{"type":"str"}),
("Katalog",                 "Die zu betrachtenden WPs in Gruppen als Katalog ('{'Tagesgeld':['ezbleitzins']}', json von dict)",{"type":"str"}),
("NAuswahlWPGruppe",        "Anzahl WP aus Anzahl Katlaog-Gruppen  (1, int)",{"type":"int"}),
("NAuswahlWP",              "Anzahl WP aus Liste pro Katlaog-Gruppe  (1, int)",{"type":"int"}),
("ParameterVariation",      "Beschreibung  (parallel, format)",{"wert":["parallel"]})
]

import copy
import os, sys
import yaml
import copy
import json
from types import SimpleNamespace

from pathlib import Path

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_type as htype


PARAMETERFILE = ""



def set_param(mobj,param_filename):
    """

    "param_struct_liste,comment_struct" = set_param(mobj,param_filename)

    :param mobj:          contains infos and status,errtext, etc
    :param param_filename:  Parameterfile
    :return: param_struct_liste,comment_struct    List mit Parameter-sets und ein comment-set
    """

    par_liste = []

    global PARAMETERFILE
    PARAMETERFILE = param_filename

    # Einlesen der yaml-Datei
    #-------------------------
    path = Path(param_filename)
    try:
        par_raw_dict = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
        print(par_raw_dict)
    except yaml.YAMLError as exc:
        mark = getattr(exc, "problem_mark", None)
        where = f" at line {mark.line + 1}, column {mark.column + 1}" if mark else ""
        mobj.status = hdef.NOT_OKAY
        mobj.errtext = f"invalid YAML in {path}{where}: {getattr(exc, 'problem', exc)}"
    # end try

    par_liste = []

    # Auftrennen von platzhalter Parmeter und eigentlichen Parameter
    #---------------------------------------------------------------
    (par_dict,platzhalter_dict_liste) = build_par_liste_sep_platzh(mobj,par_raw_dict)

    par_liste_pruefung_existenz(mobj,par_dict)
    if mobj.status != hdef.OKAY:
        return (None,None)

    par_liste = build_par_liste_ersetze_platzh(mobj,par_dict,platzhalter_dict_liste)
    if mobj.status != hdef.OKAY:
        return (None,None)

    par_liste_pruefung_inhalt(mobj, par_liste)
    if mobj.status != hdef.OKAY:
        return (None,None)

    par_liste = build_par_liste_konvertieren(mobj, par_liste)
    if mobj.status != hdef.OKAY:
        return (None,None)

    comment_struct = build_comment_liste(par_liste)

    par_struct_liste = build_struktur_liste(mobj,par_liste)

    return (par_struct_liste,comment_struct)
# end def
def build_par_liste_sep_platzh(mobj,par_raw_dict):
    """

    (par_dict,platzhalter_dict_liste) = build_par_liste_sep_platzh(mobj,par_raw_dict)

    :param mobj:
    :param par_raw_dict:
    :return par_dict                 separierte Parameter
    :return platzhalter_dict_liste   Liste mit Platzhaltern
    """
    global PARAMETERFILE

    platzhalter_dict_liste = []
    par_dict = {}

    for key in par_raw_dict.keys():

        if key.find("par_") == 0:

            key2 = "type"
            if key2 not in par_raw_dict[key]:
                mobj.status = hdef.NOT_OKAY
                mobj.errtext = f"build_par_liste_sep_platzh: In File {PARAMETERFILE} ist für Parameter {key} kein Unterparameter: {key2} definiert"
                return (None,None)
            # end if

            if par_raw_dict[key][key2] == "liste":
                key3 = "liste"
                if key3 not in par_raw_dict[key]:
                    mobj.status = hdef.NOT_OKAY
                    mobj.errtext = f"build_par_liste_sep_platzh: In File {PARAMETERFILE} ist für Parameter {key} kein Unterparameter: {key3} definiert"
                    return (None, None)
                # end if
                if not isinstance(par_raw_dict[key][key3],list):
                    mobj.status = hdef.NOT_OKAY
                    mobj.errtext = f"build_par_liste_sep_platzh: In File {PARAMETERFILE} ist für Parameter {key} ist  Unterparameter: {key3} keine Liste"
                    return (None, None)
                # end if
            else:
                mobj.status = hdef.NOT_OKAY
                mobj.errtext = f"build_par_liste_sep_platzh: In File {PARAMETERFILE} ist für Parameter {key} mit Unterparameter: {key2} nicht korrekt definiert"
                return (None, None)
            # end if

            key2 = "format"
            if key2 not in par_raw_dict[key]:
                par_raw_dict[key][key2] = "str"  # default
            # end if
            platzh = key[4:]
            type   = par_raw_dict[key][key2]
            liste  = par_raw_dict[key][key3]
            n      = len(liste)
            format = par_raw_dict[key][key2]
            platzhalter_dict_liste.append({"name":platzh,"type": type,"liste":liste,"n":n,"format":format})
        else:
            par_dict[key] = par_raw_dict[key]
        # end if
    # end for

    return (par_dict,platzhalter_dict_liste)
# end def
def par_liste_pruefung_existenz(mobj,par_dict):
    """
        Es werden alle keys geprüft und der Inhalt zur Parameterbestimmung

        par_liste_erste_pruefung(mobj,par_dict)

    :param mobj:
    :param par_dict:
    :return:
    """
    global PARAMETERFILE
    for liste in PARAM_LLIST:
        key = liste[0]
        if key not in par_dict:
            mobj.status = hdef.NOT_OKAY
            mobj.errtext = f"par_liste_erste_pruefung: In File {PARAMETERFILE} fehlt Parameter {key}"
            return
        # end if
    # end for

    return
# end def
def build_par_liste_ersetze_platzh(mobj,par_dict,platzhalter_dict_liste):
    """

    par_liste = build_par_liste_ersetze_platzh(mobj, par_dict, platzhalter_dict_liste)

    :param mobj:
    :param par_dict:
    :param platzhalter_dict_liste:
    :return: par_liste
    """

    global PARAMETERFILE

    par_liste = []

    if par_dict["ParameterVariation"] == "parallel":

        n_par_liste = 1  #  Minimal eins
        for pdict in platzhalter_dict_liste:
            n_par_liste = max(n_par_liste,pdict["n"])
        # end for

        for i_par_liste in range(n_par_liste):

            par_dict_i = copy.deepcopy(par_dict)

            for pdict in platzhalter_dict_liste:

                if i_par_liste < pdict["n"]:
                    pdict["akt"] = pdict["liste"][i_par_liste]
                else:
                    pdict["akt"] = pdict["liste"][-1]
                # end if

                for key in par_dict_i.keys():
                    if isinstance(par_dict_i[key],str):
                        value = par_dict_i[key]
                        searchstr = "@"+pdict["name"]+"@"
                        i0 = value.find(searchstr)
                        if i0 > -1:

                            if (pdict["format"] == "int") or (pdict["format"] == "float"):
                                value = pdict["akt"]
                            else:
                                value = value.replace(searchstr,pdict["akt"])
                            # end if

                            par_dict_i[key] = value
                        # end if
                    # end if
                # end for
            # end for
            par_liste.append(par_dict_i)
        # end for
    else:
        raise Exception("Da ging was schief")
    # end if

    return par_liste
# end def
def par_liste_pruefung_inhalt(mobj, par_liste):
    """

    par_liste_pruefung_inhalt(mobj, par_liste):

    :param mobj:
    :param par_liste:
    :return:

    """
    global PARAMETERFILE

    for pdict in par_liste:

        for liste in PARAM_LLIST:
            key = liste[0]
            ddict = liste[2]

            okay = hdef.NOT_OKAY

            if len(ddict) == 0:
                okay = hdef.OKAY

            if "type" in ddict.keys():
                (okay, wert) = htype.type_proof(pdict[key],ddict["type"])
                if ("wert" not in ddict.keys()) and (okay != hdef.OKAY):
                    mobj.status = hdef.NOT_OKAY
                    mobj.errtext = f"par_liste_pruefung_inhalt: In File {PARAMETERFILE} ist Parameter {key} = {pdict[key]} ist nicht vom type: {ddict["type"]}"
                    return
                # end if
            # end if
            if okay != hdef.OKAY:
                if "wert" in ddict.keys():
                    if pdict[key] not in ddict["wert"]:
                        mobj.status = hdef.NOT_OKAY
                        mobj.errtext = f"par_liste_pruefung_inhalt: In File {PARAMETERFILE} ist Parameter {key} = {pdict[key]} ist nicht in der Werte-Liste: {ddict["wert"]}"
                        return
                    # end if
                else:
                    mobj.status = hdef.NOT_OKAY
                    mobj.errtext = f"par_liste_pruefung_inhalt: In File {PARAMETERFILE} ist Parameter {key} = {pdict[key]} promblematisch kein: ddict[\"wert\"] oder ddict[\"type\"]"
                    return
                # end if
            # end if
        # end for
    # end for

    return
# end def
def build_par_liste_konvertieren(mobj, par_liste):
    """
    Konvertiert z.B. json obj und weiteres
    :param mobj:
    :param par_liste:
    :return: par_liste
    """

    for (i,pdict) in enumerate(par_liste):

        # Katalog
        #--------
        key = "Katalog"
        try:
            var = json.loads(pdict[key])
        except Exception as e:
            mobj.status = hdef.NOT_OKAY
            mobj.errtext = f"par_liste_zweite_pruefung: In File {PARAMETERFILE} while reading the json-text \n\n\"{pdict[key]}\" \n message with {e}"
            return
        # end try

        if not isinstance(var, dict):
            mobj.status = hdef.NOT_OKAY
            mobj.errtext = f"par_liste_zweite_pruefung: In File {PARAMETERFILE} ist Parameter {key} = {var} ist var: {var} kein dictionary"
            return
        # end if
        pdict["Katalog"] = var

        # WiederholTagPruefung
        # -----------------
        key = "WiederholTagPruefung"
        if not isinstance(pdict[key], str):

            value = int(pdict[key])
            if value < 1:
                value = 1
            elif value > 31:
                value = 31
            # end if
            pdict[key] = value
        # end if

        # WiederholTagErgebnis
        # -----------------
        key = "WiederholTagErgebnis"
        if not isinstance(pdict[key], str):
            value = int(pdict[key])
            if value < 1:
                value = 1
            elif value > 31:
                value = 31
            # end if
            pdict[key] = value
        # end if

        # WiederholTagZinsAbrechnung
        # -----------------
        key = "WiederholTagZinsAbrechnung"
        if not isinstance(pdict[key], str):
            value = int(pdict[key])
            if value < 1:
                value = 1
            elif value > 31:
                value = 31
            # end if
            pdict[key] = value
        # end if

        par_liste[i] = pdict

    # end for
    return par_liste
def build_comment_liste(par_liste):

    comdict = {}
    pardict = par_liste[0]

    for liste in PARAM_LLIST:
        key     = liste[0]
        comment = liste[1]

        if key in pardict.keys():
            comdict[key] = comment
        # end if
    # end for

    comment_struct = SimpleNamespace(**comdict)
    return comment_struct
# end if
def build_struktur_liste(mobj,par_liste):
    """

    :param mobj:
    :param par_liste:
    :return: par_struct_liste
    """

    par_struct_liste = []

    for pardict in par_liste:

        parstruct = SimpleNamespace(**pardict)

        par_struct_liste.append(parstruct)
    # end if
    return par_struct_liste
# end def
