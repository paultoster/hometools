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

    Name                format      default     Beispiel        Erklärung
    Start               datStrP                 "01.01.2000"    Beginn  der Simulation
    End                 datStrP                 "31.12.2010"    Ende der Simulation
    ErsterTagPruefung   str/int                 "Do",1          Erste Prüfung der Strategie kann Wochentag sein Mo,Di,Mi,Do,Fr,Sa,So oder ein Tag zwischen 1 ... (30,31),
    NTageBisPruefung    int                      8              Intervall der wiederholenen StrategiePrüfung
    ErterTagErgebnis    str/int                 "Mo",1          Erste Ergebinsausgabe kann Wochentag sein Mo,Di,Mi,Do,Fr,Sa,So oder ein Tag zwischen 1 ... (30,31),
    NTageBisErgebnis    int                      8              Intervall der wiederholenen Ergebinsausgabe
    StartCash           euroStrK                 "10.000,00"    Startkapital in Euro
    CashAufteilung      str/list(int)            "gleich"       Aufteilung des Cash auf die Kataloggruppen
    SimName             str                      "TestLauf"     Name der Simulation
    Katalog             dict[gruppe]:list(isin)                 Die zu betrachtenden Wps in Gruppen z.B. "{'Tagesgeld':['ezbleitzins']}"
    ParameterVariation  str                      "parallel"     alle Parameter werden Parralell in ihrer sequenz verabrbeitet





"""
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

PARAMKEYS = ["Start","End","ErsterTagPruefung","NTageBisPruefung","ErterTagErgebnis",
             "NTageBisErgebnis","StartCash","CashAufteilung","SimName","Katalog","ParameterVariation"]


def set_param(master,param_filename):
    """

    param_liste = set_param(master,param_filename)

    :param master:          contains infos and status,errtext, etc
    :param param_filename:  Parameterfile
    :return: param_liste    List mit Parameter-sets
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
        master.status = hdef.NOT_OKAY
        master.errtext = f"invalid YAML in {path}{where}: {getattr(exc, 'problem', exc)}"
    # end try

    # Parameterplatzhalter ersetzen
    #------------------------------
    par_liste = build_par_liste(master,par_raw_dict)

    return par_liste
# end def
def build_par_liste(master,par_raw_dict):
    """

    par_liste = build_par_liste(master,par_raw_dict)

    :param master:              contains infos and status,errtext, etc
    :param par_raw_dict:        eingelesenes yaml-File
    :return: par_liste          Liste mit allen Parametersätzen
    """
    global PARAMETERFILE

    par_liste = []

    (par_dict,platzhalter_dict_liste) = build_par_liste_sep_platzh(master,par_raw_dict)

    par_liste_erste_pruefung(master,par_dict)
    if master.status != hdef.OKAY:
        return []

    par_liste = build_par_liste_ersetze_platzh(master,par_dict,platzhalter_dict_liste)
    if master.status != hdef.OKAY:
        return []

    par_liste_zweite_pruefung(master, par_liste)
    if master.status != hdef.OKAY:
        return []

    par_liste = build_par_liste_konvertieren(master, par_liste)
    if master.status != hdef.OKAY:
        return []


    par_struct_liste = build_struktur_liste(master,par_liste)

    return par_struct_liste
# end def
def build_par_liste_sep_platzh(master,par_raw_dict):
    """

    (par_dict,platzhalter_dict_liste) = build_par_liste_sep_platzh(master,par_raw_dict)

    :param master:
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
                master.status = hdef.NOT_OKAY
                master.errtext = f"build_par_liste_sep_platzh: In File {PARAMETERFILE} ist für Parameter {key} kein Unterparameter: {key2} definiert"
                return (None,None)
            # end if

            if par_raw_dict[key][key2] == "liste":
                key3 = "liste"
                if key3 not in par_raw_dict[key]:
                    master.status = hdef.NOT_OKAY
                    master.errtext = f"build_par_liste_sep_platzh: In File {PARAMETERFILE} ist für Parameter {key} kein Unterparameter: {key3} definiert"
                    return (None, None)
                # end if
                if not isinstance(par_raw_dict[key][key3],list):
                    master.status = hdef.NOT_OKAY
                    master.errtext = f"build_par_liste_sep_platzh: In File {PARAMETERFILE} ist für Parameter {key} ist  Unterparameter: {key3} keine Liste"
                    return (None, None)
                # end if
            else:
                master.status = hdef.NOT_OKAY
                master.errtext = f"build_par_liste_sep_platzh: In File {PARAMETERFILE} ist für Parameter {key} mit Unterparameter: {key2} nicht korrekt definiert"
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
def par_liste_erste_pruefung(master,par_dict):
    """
        Es werden alle keys geprüft und der Inhalt zur Parameterbestimmung

        par_liste_erste_pruefung(master,par_dict)

    :param master:
    :param par_dict:
    :return:
    """
    global PARAMETERFILE
    for key in PARAMKEYS:
        if key not in par_dict:
            master.status = hdef.NOT_OKAY
            master.errtext = f"par_liste_erste_pruefung: In File {PARAMETERFILE} fehlt Parameter {key}"
            return
        # end if
    # end for

    if par_dict["ParameterVariation"].lower() != "parallel":
        master.status = hdef.NOT_OKAY
        master.errtext = f"par_liste_erste_pruefung: In File {PARAMETERFILE} ist Parameter {"ParameterVariation"} nicht richt gesetzt."
        return
    else:
        par_dict["ParameterVariation"] = "parallel"
    # end if

    return
# end def
def build_par_liste_ersetze_platzh(master,par_dict,platzhalter_dict_liste):
    """

    par_liste = build_par_liste_ersetze_platzh(master, par_dict, platzhalter_dict_liste)

    :param master:
    :param par_dict:
    :param platzhalter_dict_liste:
    :return: par_liste
    """

    global PARAMETERFILE

    par_liste = []

    if par_dict["ParameterVariation"] == "parallel":

        n_par_liste = 0
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
def par_liste_zweite_pruefung(master, par_liste):
    """

    par_liste_zweite_pruefung(master, par_liste):

    :param master:
    :param par_liste:
    :return:

    """
    global PARAMETERFILE

    for (i,pdict) in enumerate(par_liste):

        # Start
        #------
        key = "Start"
        (okay, wert) = htype.type_proof(pdict[key], "datStrP")
        if okay != hdef.OKAY:
            master.status = hdef.NOT_OKAY
            master.errtext = f"par_liste_zweite_pruefung: In File {PARAMETERFILE} ist Parameter {key} = {pdict[key]} ist kein Datum"
            return
        # end if

        # End
        #------
        key = "End"
        (okay, wert) = htype.type_proof(pdict[key], "datStrP")
        if okay != hdef.OKAY:
            master.status = hdef.NOT_OKAY
            master.errtext = f"par_liste_zweite_pruefung: In File {PARAMETERFILE} ist Parameter {key} = {pdict[key]} ist kein Datum"
            return
        # end if

        # ErsterTagPruefung
        # ------------------
        key = "ErsterTagPruefung"
        if isinstance(pdict[key], str):
            wochentage = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"]
            if pdict[key] not in wochentage:
                master.status = hdef.NOT_OKAY
                master.errtext = f"par_liste_zweite_pruefung: In File {PARAMETERFILE} ist Parameter {key} = {pdict[key]} ist kein Wochentag: {wochentage}"
                return
            # end if
        else:
            value = int(pdict[key])
            if value < 1:
                value = 1
            elif value > 31:
                value = 31
        # end if

        # NTageBisPruefung
        # -----------------
        key = "NTageBisPruefung"
        value = int(pdict[key])

        # ErterTagErgebnis
        # ------------------
        key = "ErterTagErgebnis"
        if isinstance(pdict[key], str):
            wochentage = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"]
            if pdict[key] not in wochentage:
                master.status = hdef.NOT_OKAY
                master.errtext = f"par_liste_zweite_pruefung: In File {PARAMETERFILE} ist Parameter {key} = {pdict[key]} ist kein Wochentag: {wochentage}"
                return
            # end if
        else:
            value = int(pdict[key])
            if value < 1:
                value = 1
            elif value > 31:
                value = 31
        # end if

        # NTageBisErgebnis
        # -----------------
        key = "NTageBisErgebnis"
        value = int(pdict[key])


        key = "StartCash"
        (okay, wert) = htype.type_proof(pdict[key], "euroStrK")
        if okay != hdef.OKAY:
            master.status = hdef.NOT_OKAY
            master.errtext = f"par_liste_zweite_pruefung: In File {PARAMETERFILE} ist Parameter {key} = {pdict[key]} ist kein euroStrK"
            return
        # end if

        key = "CashAufteilung"
        if not isinstance(pdict[key], str):
            master.status = hdef.NOT_OKAY
            master.errtext = f"par_liste_zweite_pruefung: In File {PARAMETERFILE} ist Parameter {key} = {pdict[key]} ist nicht \"gleichverteilt\""
            return
        elif pdict[key] != "gleichverteilt":
            master.status = hdef.NOT_OKAY
            master.errtext = f"par_liste_zweite_pruefung: In File {PARAMETERFILE} ist Parameter {key} = {pdict[key]} ist nicht \"gleichverteilt\""
            return
        # end if

        key = "SimName"
        if not isinstance(pdict[key], str):
            master.status = hdef.NOT_OKAY
            master.errtext = f"par_liste_zweite_pruefung: In File {PARAMETERFILE} ist Parameter {key} = {pdict[key]} ist nicht string"
            return
        # end if

        key = "Katalog"
        if not isinstance(pdict[key], str):
            master.status = hdef.NOT_OKAY
            master.errtext = f"par_liste_zweite_pruefung: In File {PARAMETERFILE} ist Parameter {key} = {pdict[key]} ist kein string"
            return
        try:
            var = json.loads(pdict[key])
        except Exception as e:
            master.status = hdef.NOT_OKAY
            master.errtext = f"par_liste_zweite_pruefung: In File {PARAMETERFILE} while reading the json-text \n\n\"{pdict[key]}\" \n message with {e}"
            return
        # end try

        if not isinstance(var, dict):
            master.status = hdef.NOT_OKAY
            master.errtext = f"par_liste_zweite_pruefung: In File {PARAMETERFILE} ist Parameter {key} = {pdict[key]} ist var: {var} kein dictionary"
            return
        # end if

        for key2 in var.keys():
            if not isinstance(var[key2], list):
                master.status = hdef.NOT_OKAY
                master.errtext = f"par_liste_zweite_pruefung: In File {PARAMETERFILE} ist Parameter {key} = {pdict[key]} wird zu dict: {var} und die Wps der Gruppe {key2} is keine Liste"
                return
            # endif
        # end for
    # end for

    return
# end def
def build_par_liste_konvertieren(master, par_liste):
    """
    Konvertiert z.B. json obj und weiteres
    :param master:
    :param par_liste:
    :return: par_liste
    """

    for (i,pdict) in enumerate(par_liste):

        # Katalog
        #--------
        pdict["Katalog"] = json.loads(pdict["Katalog"])

        par_liste[i] = pdict
    # end for
    return par_liste
def build_struktur_liste(master,par_liste):
    """

    :param master:
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
