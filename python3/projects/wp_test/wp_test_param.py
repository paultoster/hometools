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
("ErsterTagPruefung",      "Erste Prüfung der Strategie kann Wochentag oder ein Tag (Mo,Di,Mi,Do,Fr,Sa,So, 1 ... (30,31))",{"wert":["Mo","Di","Do","Fr","Sa","So"],"type":["int","str"]}),
("WiederholTagPruefung",   "Wiederholtag zu Prüfung ist Wochentag oder Monatsdatume  (Mo,Di,Mi,Do,Fr,Sa,So, 1 ... (30,31))",{"wert":["Mo","Di","Do","Fr","Sa","So"],"type":["int","str"]}),
("ErsterTagErgebnis",       "Erste Ergebnisausgabe (Zwischenergebnis) der Strategie kann Wochentag oder ein Tag (Mo,Di,Mi,Do,Fr,Sa,So, 1 ... (30,31))",{"wert":["Mo","Di","Do","Fr","Sa","So"],"type":["int","str"]}),
("WiederholTagErgebnis",    "Wiederholtag Ergebinsausgabe ist Wochentag oder Monatsdatume  (Mo,Di,Mi,Do,Fr,Sa,So, 1 ... (30,31))",{"wert":["Mo","Di","Do","Fr","Sa","So"],"type":["int","str"]}),
("StartCash",               "Startkapital in Euro  (10,000,00 )",{"type":"euroStrK"}),
("ZinsKontoPruefung",       "Soll verbleibender Cash auf Zinskonto gelegt werden  (True/False, bool)",{"type":"bool"}),
("ErsterTagZinsAbrechnung", "Erste Zinsabrechnung der Strategie kann Wochentag oder ein Tag (Mo,Di,Mi,Do,Fr,Sa,So, 1 ... (30,31))",{"wert":["Mo","Di","Do","Fr","Sa","So"],"type":["int","str"]}),
("WiederholTagZinsAbrechnung", "Wiederholtag Ergebinsausgabe ist Wochentag oder Monatsdatume  (Mo,Di,Mi,Do,Fr,Sa,So, 1 ... (30,31))",{"wert":["Mo","Di","Do","Fr","Sa","So"],"type":["int","str"]}),
("ErtragsSteuerAnteil",     "Steueranteil an einem Gewinn oder Zinsertrag (28.,float)",{"type":"float"}),
("WPKostenFest",            "Feste Kosten bei WP-Handel an einem Gewinn  (4.,euro)",{"type":"euroStrK"}),
("WPKostenAnteil",           "Kostenanteil bei WP-Handel an einem Gewinn  (0.,float)",{"type":"float"}),
("WPKostenMax",            "Maximaler Kostenanteil bei WP-Handel an einem Gewinn  (40.,euro)",{"type":"euroStrK"}),
("ScreKat",                 "wp_screen: Die zu betrachtenden WPs in Gruppen als ScreKat ('{'Tagesgeld':['ezbleitzins']}', json von dict)",{"type":"str"}),
("ScreSig",                  "wp_screen: Signal set als dict, json von dict)",{"type":"str"}),
("SreTab",                  "wp_screen: Tabellen set als dict, json von dict)",{"type":"str"}),
("NAuswahlWPGruppe",        "Anzahl WP aus Anzahl Katlaog-Gruppen  (1, int)",{"type":"int"}),
("NAuswahlWP",              "Anzahl WP aus Liste pro Katlaog-Gruppe  (1, int)",{"type":"int"}),
("WPExistDays",             "Anzahl Tage, die das entsprechende WP schon besteht, Daten hat  (1, int)",{"type":"int"}),
("WPTriggerVerkauf",        "Wann soll verkauft werden.'Vsig': nur nach Verkaufssignal , 'Vsig+Rank': Auch zusätzlich nach rang  ",{"wert":["Vsig","Vsig+Rank"],"type":"str"}),
("ParameterVariation",      "Beschreibung  (parallel, format)",{"wert":["parallel"]}),
("WPBuildSigSetNew",        "Soll immer eine neue DatenBasis geniert werden (zeitaufwendig)  (True/False, bool)", {"type": "bool"}),
("BildeAusgabe",            "Soll die ausgabe geniert werden geniert werden (zeitaufwendig)  (True/False, bool)", {"type": "bool"}),

]
# ("SimName",                 "Name der Simulation  (TestLauf, str)",{"type":"str"}),

# import copy
import os, sys
import yaml
import yaml_include
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
import tools.hfkt_file_path as hfp
import tools.hfkt_list as hlist


PARAMETERFILE = ""



# def yaml_include(loader, node):
#     """Constructor für das !include Tag.
#     Löst Pfade relativ zur aktuellen YAML-Datei auf.
#     """
#     # Holt den Dateinamen aus dem YAML-Knoten
#     filename = loader.construct_scalar(node)
#
#     # Ermittelt das Verzeichnis der aktuellen Haupt-YAML-Datei
#     base_dir = os.path.dirname(loader.name) if loader.name else os.getcwd()
#     full_path = os.path.join(base_dir, filename)
#
#     with open(full_path, 'r', encoding='utf-8') as f:
#         # Nutzt safe_load, um Sicherheitsrisiken zu vermeiden
#         return yaml.safe_load(f)
#
#
# # Registriert das !include Tag für den SafeLoader
# yaml.add_constructor('!include', yaml_include, Loader=yaml.SafeLoader)
#
#
# class UniqueIncludeLoader(yaml.SafeLoader):
#     """Ein SafeLoader, der die Basis-Struktur der Hauptdatei kennt,
#
#     um relative Pfade für !include korrekt aufzulösen.
#     """
#
#     def __init__(self, stream):
#         # Den Pfad der aktuell gelesenen Datei speichern
#         self._root = os.path.dirname(stream.name) if hasattr(stream, 'name') else os.getcwd()
#         super().__init__(stream)
#
#
# def include_constructor(loader: UniqueIncludeLoader, node: yaml.Node):
#     """Konstruktor, der den !include-Tag verarbeitet."""
#     # Den angegebenen Dateinamen aus dem YAML-Knoten extrahieren
#     filename = loader.construct_scalar(node)
#
#     # Absoluten Pfad basierend auf der Ursprungsdatei erstellen
#     full_path = os.path.normpath(os.path.join(loader._root, filename))
#
#     # Die inkludierte Datei mit demselben Loader-Typ laden (erlaubt verschachtelte Includes)
#     with open(full_path, 'r', encoding='utf-8') as f:
#         return yaml.load(f, Loader=UniqueIncludeLoader)
#
#
# # Den Konstruktor an unseren benutzerdefinierten Loader binden
# yaml.add_constructor('!include', include_constructor, Loader=UniqueIncludeLoader)
#
#
# class Loader(yaml.SafeLoader):
#
#     def __init__(self, stream):
#
#         self._root = os.path.split(stream.name)[0]
#
#         super(Loader, self).__init__(stream)
#
#     def include(self, node):
#
#         filename = os.path.join(self._root, self.construct_scalar(node))
#
#         with open(filename, 'r') as f:
#             return yaml.load(f, Loader)
#
# Loader.add_constructor('!include', Loader.include)
def get_split_param_dicts(mobj,param_filename):

    global PARAMETERFILE
    PARAMETERFILE = param_filename

    # Einlesen der yaml-Datei
    #-------------------------
    par_raw_dict = read_yaml(mobj,param_filename)
    if mobj.status != hdef.OKAY:
        return (None,None)

    # Auftrennen von platzhalter Parmeter und eigentlichen Parameter
    #---------------------------------------------------------------
    (par_dict,platzhalter_dict_liste) = build_par_liste_sep_platzh(mobj,par_raw_dict)
    if mobj.status != hdef.OKAY:
        return (None,None)

    return (par_dict,platzhalter_dict_liste)
# end def
def get_par_struct_liste(mobj,par_dict,platzhalter_dict_liste):

    global PARAMETERFILE

    par_liste_pruefung_existenz(mobj,par_dict)
    if mobj.status != hdef.OKAY:
        return (None,None)

    par_liste_set_simname(mobj,par_dict)
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
def set_param(mobj,param_filename):
    """

    "param_struct_liste,comment_struct" = set_param(mobj,param_filename)

    :param mobj:          contains infos and status,errtext, etc
    :param param_filename:  Parameterfile
    :return: param_struct_liste,comment_struct    List mit Parameter-sets und ein comment-set
    """

    # Einlesen der yaml-Datei
    # und Auftrennen von platzhalter Parmeter und eigentlichen Parameter
    #-------------------------------------------------------------------
    (par_dict, platzhalter_dict_liste) = get_split_param_dicts(mobj,param_filename)

    if mobj.status != hdef.OKAY:
        return (None,None)

    (par_struct_liste,comment_struct) = get_par_struct_liste(mobj, par_dict, platzhalter_dict_liste)

    if mobj.status != hdef.OKAY:
        return (None,None)

    return (par_struct_liste,comment_struct)

# end def
def read_yaml(mobj,param_filename):

    path = Path(param_filename)

    yaml.add_constructor("!include", yaml_include.Constructor(), yaml.Loader)

    try:
        par_raw_dict = yaml.load(path.read_text(encoding="utf-8"), yaml.Loader) or {}
        print(par_raw_dict)
    except yaml.YAMLError as exc:
        mark = getattr(exc, "problem_mark", None)
        where = f" at line {mark.line + 1}, column {mark.column + 1}" if mark else ""
        mobj.status = hdef.NOT_OKAY
        mobj.errtext = f"invalid YAML in {path}{where}: {getattr(exc, 'problem', exc)}"
        return (None, None)
    # end try

    if "database" in par_raw_dict.keys():
        for key in par_raw_dict["database"].keys():
            par_raw_dict[key] = par_raw_dict["database"][key]
        # end of
        del par_raw_dict["database"]
    # end if

    return par_raw_dict
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

            platzhalter_dict = get_platzhalter_dict(mobj,par_raw_dict[key],key)
            if mobj.status != hdef.OKAY:
                return (None,None)

            platzhalter_dict_liste.append(platzhalter_dict)
        else:
            par_dict[key] = par_raw_dict[key]
        # end if
    # end for

    return (par_dict,platzhalter_dict_liste)
# end def
def get_platzhalter_dict(mobj,platzhalter_raw_dict,key):


    key1 = "platzhalter"
    if key1 not in platzhalter_raw_dict:
        mobj.status = hdef.NOT_OKAY
        mobj.errtext = f"get_platzhalter_dict: In File {PARAMETERFILE} ist für Parameter {key} kein Unterparameter: {key1} definiert"
        return None
    # end if

    key2 = "type"
    if key2 not in platzhalter_raw_dict:
        mobj.status = hdef.NOT_OKAY
        mobj.errtext = f"get_platzhalter_dict: In File {PARAMETERFILE} ist für Parameter {key} kein Unterparameter: {key2} definiert"
        return None
    # end if

    if platzhalter_raw_dict[key2] == "liste":
        key3 = "liste"
        if key3 not in platzhalter_raw_dict:
            mobj.status = hdef.NOT_OKAY
            mobj.errtext = f"get_platzhalter_dict: In File {PARAMETERFILE} ist für Parameter {key} kein Unterparameter: {key3} definiert"
            return None
        # end if
        if not isinstance(platzhalter_raw_dict[key3], list):
            mobj.status = hdef.NOT_OKAY
            mobj.errtext = f"get_platzhalter_dict: In File {PARAMETERFILE} ist für Parameter {key} ist  Unterparameter: {key3} keine Liste"
            return None
        # end if

        key4 = "delta"
        if key4 not in platzhalter_raw_dict:
            platzhalter_raw_dict[key4] = None
        key5 = "minvalue"
        if key5 not in platzhalter_raw_dict:
            platzhalter_raw_dict[key5] = None  # default
        # end if

        key6 = "maxvalue"
        if key6 not in platzhalter_raw_dict:
            platzhalter_raw_dict[key6] = None  # default
        # end if

    elif platzhalter_raw_dict[key2] == "delta":

        key4 = "delta"
        if key4 not in platzhalter_raw_dict:
            mobj.status = hdef.NOT_OKAY
            mobj.errtext = f"get_platzhalter_dict: In File {PARAMETERFILE} ist für Parameter {key} kein Unterparameter: {key4} definiert"
            return None
        # end if
        if not isinstance(platzhalter_raw_dict[key4], (int, float)):
            mobj.status = hdef.NOT_OKAY
            mobj.errtext = f"get_platzhalter_dict: In File {PARAMETERFILE} ist für Parameter {key} ist  Unterparameter: {key4} kein int oder float"
            return None
        # end if

        key5 = "minvalue"
        if key5 not in platzhalter_raw_dict:
            mobj.status = hdef.NOT_OKAY
            mobj.errtext = f"get_platzhalter_dict: In File {PARAMETERFILE} ist für Parameter {key} kein Unterparameter: {key5} definiert"
            return None
        # end if
        if not isinstance(platzhalter_raw_dict[key5], (int, float)):
            mobj.status = hdef.NOT_OKAY
            mobj.errtext = f"get_platzhalter_dict: In File {PARAMETERFILE} ist für Parameter {key} ist  Unterparameter: {key5} kein int oder float"
            return None
        # end if

        key6 = "maxvalue"
        if key6 not in platzhalter_raw_dict:
            mobj.status = hdef.NOT_OKAY
            mobj.errtext = f"get_platzhalter_dict: In File {PARAMETERFILE} ist für Parameter {key} kein Unterparameter: {key6} definiert"
            return None
        # end if
        if not isinstance(platzhalter_raw_dict[key6], (int, float)):
            mobj.status = hdef.NOT_OKAY
            mobj.errtext = f"get_platzhalter_dict: In File {PARAMETERFILE} ist für Parameter {key} ist  Unterparameter: {key6} kein int oder float"
            return None
        # end if

        key3 = "liste"
        platzhalter_raw_dict[key3] = hlist.build_aequidistant_liste(platzhalter_raw_dict[key5],
                                                                 platzhalter_raw_dict[key6],
                                                                 platzhalter_raw_dict[key4])

    else:
        mobj.status = hdef.NOT_OKAY
        mobj.errtext = f"get_platzhalter_dict: In File {PARAMETERFILE} ist für Parameter {key} mit Unterparameter: {key2} nicht korrekt definiert"
        return None
    # end if

    key7 = "format"
    if key7 not in platzhalter_raw_dict:
        platzhalter_raw_dict[key7] = "str"  # default
    # end if

    key8 = "format_value"
    if key8 not in platzhalter_raw_dict:
        platzhalter_raw_dict[key8] = "str"  # default
    # end if

    platzh = platzhalter_raw_dict[key1]
    type = platzhalter_raw_dict[key2]
    liste = platzhalter_raw_dict[key3]
    n = len(liste)
    delta = platzhalter_raw_dict[key4]
    minvalue = platzhalter_raw_dict[key5]
    maxvalue = platzhalter_raw_dict[key6]
    format = platzhalter_raw_dict[key7]
    format_value = platzhalter_raw_dict[key8]

    platzhalter_dict = {"name": platzh, "type": type, "liste": liste, "n": n,
                       "delta": delta, "minvalue": minvalue, "maxvalue": maxvalue,
                       "format": format, "format_value": format_value, }

    return platzhalter_dict
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
def par_liste_set_simname(mobj, pardict):
    """ Bilde Simulationsname
    :param mobj:"""

    global PARAMETERFILE

    (_, fbody, _) = hfp.get_pfe(PARAMETERFILE)

    if fbody.find("wp_test_") != -1:  # Correct
        fbody = fbody.replace("wp_test_","")

    pardict["SimName"] = fbody

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
                        searchstr = pdict["name"]
                        i0 = value.find(searchstr)
                        if i0 > -1:

                            if (pdict["format"] == "int") or (pdict["format"] == "float"):
                                value = pdict["akt"]
                            else:
                                value = value.replace(searchstr,str(pdict["akt"]))
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

            type_proof = False
            wert_proof = False
            if "type" in ddict.keys():
                type = ddict["type"]
                if isinstance(type,list):
                    type_list = type
                else:
                    type_list = [type]
                # end if
                type_proof = True
                type_ergebnis = None
                okayt = hdef.NOT_OKAY
                for type in type_list:
                    if type == "str":
                        if isinstance(pdict[key],str):
                            okayt = hdef.OKAY
                            type_ergebnis = type
                            break
                        # end if
                    elif type == "int":
                        if isinstance(pdict[key],int):
                            okayt = hdef.OKAY
                            type_ergebnis = type
                            break
                        # end if
                    elif type == "float":
                        if isinstance(pdict[key],float):
                            okayt = hdef.OKAY
                            type_ergebnis = type
                            break
                        # end if
                    else:
                        (okayt, wert) = htype.type_proof(pdict[key],type)
                        if okayt == hdef.OKAY:
                            type_ergebnis = type
                            break
                    # end if
                # end for
            # end if
            if "wert" in ddict.keys():
                wert_proof = True


                wert = ddict["wert"]
                if isinstance(wert,list):
                    wert_list = wert
                else:
                    wert_list = [wert]
                # end if

                okayw = hdef.NOT_OKAY
                if type_ergebnis == "str":

                    if len([wert for wert in wert_list if isinstance(wert,str) ]) > 0:
                        for wert in wert_list:
                            if  pdict[key] == wert:
                                okayw = hdef.OKAY
                                break
                            # end if
                        # end for
                    else:
                        okayw = hdef.OKAY
                    # end if
                elif type_ergebnis == "int":

                    if len([wert for wert in wert_list if isinstance(wert, int)]) > 0:
                        for wert in wert_list:
                            if pdict[key] == wert:
                                okayw = hdef.OKAY
                                break
                            # end if
                        # end for
                    else:
                        okayw = hdef.OKAY
                    # end if
                elif type_ergebnis == "float":

                    if len([wert for wert in wert_list if isinstance(wert, int)]) > 0:
                        for wert in wert_list:
                            if pdict[key] == wert:
                                okayw = hdef.OKAY
                                break
                            # end if
                        # end for
                    else:
                        okayw = hdef.OKAY
                    # end if
                else:
                    for wert in wert_list:
                        if pdict[key] == wert:
                            okayw = hdef.OKAY
                            break
                        # end if
                    # end for
                # end if
            # end if

            if type_proof :
                if okayt != hdef.OKAY:
                    mobj.status = hdef.NOT_OKAY
                    mobj.errtext = f"par_liste_pruefung_inhalt: In File {PARAMETERFILE} ist Parameter {key} = {pdict[key]} ist nicht vom type: {ddict["type"]}"
                    return
                # end if
            # end if
            if wert_proof :
                if okayw != hdef.OKAY:
                    mobj.status = hdef.NOT_OKAY
                    mobj.errtext = f"par_liste_pruefung_inhalt: In File {PARAMETERFILE} ist Parameter {key} = {pdict[key]} ist nicht in der Werte-Liste: {ddict["wert"]}"
                    return
                # end if
            # end if
            if not type_proof and not wert_proof:
                mobj.status = hdef.NOT_OKAY
                mobj.errtext = f"par_liste_pruefung_inhalt: In File {PARAMETERFILE} ist Parameter {key} = {pdict[key]} promblematisch kein: ddict[\"wert\"] oder ddict[\"type\"]"
                return
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

        # ScreKat
        #--------
        key = "ScreKat"
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
        pdict["ScreKat"] = var

        # ScreSig:
        #--------
        key = "ScreSig"
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
        pdict["ScreSig"] = var

        # Werte überprüfen
        if len(pdict[key].keys()):
            for key_check in ["KursFilt"]:
                if key_check not in pdict[key]:
                    mobj.status = hdef.NOT_OKAY
                    mobj.errtext = f"par_liste_zweite_pruefung: Fehler in File {PARAMETERFILE} bei Parameter {key} = {var}.\n Der key: {key_check} ist nicht vorhanden"
                    return
                # end if
            # end for
        # end if
        # SreTab:
        #--------
        key = "SreTab"
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
        pdict[key] = var

        # Werte überprüfen
        if len(pdict[key].keys()):
            for key_check in ["ISIN","NAME","KURS","RANKING","KAUFEN","VERKAUFEN"]:
                if key_check not in pdict[key]:
                    mobj.status = hdef.NOT_OKAY
                    mobj.errtext = f"par_liste_zweite_pruefung: Fehler in File {PARAMETERFILE} bei Parameter {key} = {var}.\n Der key: {key_check} ist nicht vorhanden"
                    return
                # end if
            # end for
        # end if

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
