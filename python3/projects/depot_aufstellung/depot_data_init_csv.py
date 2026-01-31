import os, sys
from dataclasses import dataclass, field

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# # endif

# Hilfsfunktionen
import tools.hfkt_def as hdef
import tools.hfkt_type as htype
import tools.hfkt_pickle as hpickle
import tools.hfkt_tvar as htvar


# import wp_abfrage.wp_base as wp_base
# import bank_name_bestimmen.blz_class as blz_class

import depot_data_init_allg
import depot_data_init_iban
import depot_data_init_konto

# import depot_iban_data_class
import depot_konto_data_set_class
import depot_konto_csv_read_class
import depot_depot_data_set_class
# import depot_data_class_defs
# import depot_kategorie_class

@dataclass
class CsvData:
    data_dict: dict = field(default_factory=dict)
    data_dict_tvar: dict = field(default_factory=dict)
    csv_obj = None

def read(rd, csv_config_name):
    """
    
    :param rd:
    :param csv_config_name:
    :return: (csv_data_obj, status, errtext) = depot_data_init_csv.read(rd, csv_config_name)
    """
    
    status       = hdef.OK
    errtext      = ""
    csv_data_obj = CsvData()
    
    # Bilde data_dict von ini-Daten
    csv_data_obj.data_dict = get_csv_dict_values_from_ini(csv_config_name, rd.par, rd.ini.ddict[csv_config_name])
    
    # Tvariable bilden
    csv_data_obj.data_dict_tvar = build_csv_transform_data_dict(csv_config_name, rd.par, csv_data_obj.data_dict)
    
    # Klassen-Objekt erstellen
    csv_data_obj.csv_obj = depot_konto_csv_read_class.KontoCsvRead(csv_data_obj.data_dict_tvar[rd.par.CSV_TRENNZEICHEN]
                                                                   , csv_data_obj.data_dict_tvar[rd.par.CSV_WERT_PRUEFUNG]
                                                                   , csv_data_obj.data_dict_tvar[rd.par.CSV_PFAD_CSV_DATEI]
                                                                   , csv_data_obj.data_dict_tvar[
                                                                       rd.par.CSV_BUCHTYPE_ZUORDNUNG_NAME]
                                                                   , csv_data_obj.data_dict_tvar[
                                                                       rd.par.CSV_HEADER_ZUORDNUNG_NAME]
                                                                   , csv_data_obj.data_dict_tvar[
                                                                       rd.par.CSV_HEADER_TYPE_ZUORDNUNG_NAME])
    
    return (csv_data_obj, status, errtext)
# end def
def get_csv_dict_values_from_ini(csv_config_name, par, ini_dict):
    '''

    :param par:
    :param ini:
    :return: data_dict = get_csv_dict_values_from_ini(par,ini)
    '''
    
    data_dict = {}
    
    # type
    data_dict[par.DDICT_TYPE_NAME] = par.CSV_DATA_TYPE_NAME
    
    # Trennungszeichen in csv-Datei
    # --------------------------------
    data_dict[par.CSV_TRENNZEICHEN] = ini_dict[par.INI_CSV_TRENNZEICHEN]
    
    # Datei-Pfad-Vorschlag in csv-Datei
    # --------------------------------
    data_dict[par.CSV_PFAD_CSV_DATEI] = ini_dict[par.INI_CSV_PFAD_CSV_DATEI]
    
    # wert prüfung in csv-Datei
    # --------------------------------
    data_dict[par.CSV_WERT_PRUEFUNG] = ini_dict[par.INI_CSV_WERT_PRUEFUNG]
    
    # build buchungstype list from ini-File for csv-file
    # ---------------------------------------------------
    n = min(len(ini_dict[par.INI_CSV_BUCHTYPE_NAMEN]), len(ini_dict[par.INI_CSV_BUCHTYPE_ZUORDNUNG]))
    
    csv_buchungs_zuordnung_dict = {}
    for i in range(n):
        buchtype_zuordnung = ini_dict[par.INI_CSV_BUCHTYPE_ZUORDNUNG][i]
        buchtype_name = ini_dict[par.INI_CSV_BUCHTYPE_NAMEN][i]
        
        csv_buchungs_zuordnung_dict[buchtype_zuordnung] = buchtype_name
    # end for
    
    # unbekannt hinzu fügen
    if "unbekannt" not in csv_buchungs_zuordnung_dict.keys():
        csv_buchungs_zuordnung_dict["unbekannt"] = ""
    
    data_dict[par.CSV_BUCHTYPE_DICT] = csv_buchungs_zuordnung_dict
    
    # Bilde list für header name csv, index und buchungstype
    # -------------------------------------------------------
    n = len(ini_dict[par.INI_CSV_HEADER_NAMEN])
    n2 = len(ini_dict[par.INI_CSV_HEADER_ZUORDNUNG])
    n3 = len(ini_dict[par.INI_CSV_HEADER_DATA_TYPE])
    
    if (n != n2) or (n != n3):
        raise Exception(
            f"get_csv_dict_values_from_ini: In ini-data für section [{csv_config_name}] sind die Listen {par.INI_CSV_HEADER_NAMEN}, {par.INI_CSV_HEADER_ZUORDNUNG} und {par.INI_CSV_HEADER_DATA_TYPE} nicht gleich lange.")
    # end if
    
    csv_header_name_liste = []
    csv_header_zuordnung_liste = []
    csv_header_type_liste = []
    for i in range(n):
        header_name = ini_dict[par.INI_CSV_HEADER_NAMEN][i]
        header_zuordnung = ini_dict[par.INI_CSV_HEADER_ZUORDNUNG][i]
        header_data_type = ini_dict[par.INI_CSV_HEADER_DATA_TYPE][i]
        csv_header_name_liste.append(header_name)
        csv_header_type_liste.append(header_data_type)
        csv_header_zuordnung_liste.append(header_zuordnung)
    # end for
    
    data_dict[par.CSV_HEADER_NAME_LISTE] = csv_header_name_liste
    data_dict[par.CSV_HEADER_TYPE_LISTE] = csv_header_type_liste
    data_dict[par.CSV_HEADER_ZUORDNUNG_LISTE] = csv_header_zuordnung_liste
    
    return data_dict


# end def
def build_csv_transform_data_dict(csv_config_name, par, data_dict):
    '''

    :param par:
    :param data_dict:
    :return: data_dict_tvar = build_csv_transform_data_dict(par,data_dict)
    '''
    data_dict_tvar = {}
    
    # DDICT_TYPE_NAME
    data_dict_tvar[par.DDICT_TYPE_NAME] = htvar.build_val(par.DDICT_TYPE_NAME, data_dict[par.DDICT_TYPE_NAME], 'str')
    
    # CSV_TRENNZEICHEN
    data_dict_tvar[par.CSV_TRENNZEICHEN] = htvar.build_val(par.CSV_TRENNZEICHEN, data_dict[par.CSV_TRENNZEICHEN], 'str')
    
    # CSV_PFAD_CSV_DATEI
    data_dict_tvar[par.CSV_PFAD_CSV_DATEI] = htvar.build_val(par.CSV_PFAD_CSV_DATEI, data_dict[par.CSV_PFAD_CSV_DATEI],
                                                             'str')
    
    # CSV_WERT_PRUEFUNG
    data_dict_tvar[par.CSV_WERT_PRUEFUNG] = htvar.build_val(par.CSV_WERT_PRUEFUNG, data_dict[par.CSV_WERT_PRUEFUNG],
                                                            'str')
    
    # CSV_BUCHTYPE_ZUORDNUNG_NAME
    names = list(data_dict[par.CSV_BUCHTYPE_DICT].keys())
    vals = list(data_dict[par.CSV_BUCHTYPE_DICT].values())
    types = []
    for val in vals:
        if isinstance(val, str):
            types.append("str")
        else:
            types.append("list_str")
        # end if
    # end for
    data_dict_tvar[par.CSV_BUCHTYPE_ZUORDNUNG_NAME] = htvar.build_list(names, vals, types)
    
    # CSV_HEADER_ZUORDNUNG_NAME
    names = data_dict[par.CSV_HEADER_ZUORDNUNG_LISTE]
    vals = data_dict[par.CSV_HEADER_NAME_LISTE]
    types = []
    for val in vals:
        if isinstance(val, str):
            types.append("str")
        else:
            types.append("list_str")
        # end if
    # end for
    
    data_dict_tvar[par.CSV_HEADER_ZUORDNUNG_NAME] = htvar.build_list(names, vals, types)
    
    # CSV_HEADER_TYPE_ZUORDNUNG_NAME
    names = data_dict[par.CSV_HEADER_ZUORDNUNG_LISTE]
    vals = data_dict[par.CSV_HEADER_TYPE_LISTE]
    types = []
    for val in vals:
        if isinstance(val, str):
            types.append("str")
        else:
            types.append("list_str")
        # end if
    # end for
    
    data_dict_tvar[par.CSV_HEADER_TYPE_ZUORDNUNG_NAME] = htvar.build_list(names, vals, types)
    
    for type_name in vals:
        if htype.type_name_proof(type_name) != hdef.OKAY:
            raise Exception(
                f"data_set.build_csv_transform_data_dict: In section  {csv_config_name = } ist {type_name = } nicht korrekt")
        # end if
    # end for
    
    return data_dict_tvar
# end def
