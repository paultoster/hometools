# -*- coding: cp1252 -*-
#
# build parameter
#
# data.structure:
#
# self.IBAN_NAME                        Iban
# self.WER_NAME                         Inhaber
# self.START_WERT_NAME                  Startwert
# self.START_TAG_NAME                   Starttag
# self.START_TAG_NAME                  Startzeit
# self.START_DATUM_NAME                 Startdatum
# self.AUSZUGS_TYP_NAME                 Type von Kontoauszug
#
#


import os, sys
from dataclasses import dataclass, field
from typing import List

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
#endif

# Hilfsfunktionen
import tools.hfkt_def as hdef


@dataclass
class Parameter:
    OKAY: int = hdef.OK
    NOT_OKAY: int = hdef.NOT_OK
    # logging
    LOG_SCREEN_OUT: int = field(default_factory=int)
    
    STR_EURO_TRENN_BRUCH_DEFAULT: str = ","
    STR_EURO_TRENN_TAUSEN_DEFAULT: str = "."
    CSV_AUSGABE_TRENN_ZEICHEN: str = ";"
    
    KONTO_SHOW_NUMBER_OF_LINES: int = 100000
    COLOR_SHOW_NEW_DATA_SETS: str = 'brown1'

    
    
    # ini-file attributes base
    
    INI_KONTO_DATA_LIST_NAMES_NAME: str = "konto_names"
    INI_DEPOT_DATA_LIST_NAMES_NAME: str = "depot_names"
    INI_CSV_IMPORT_CONFIG_NAMES_NAME: str = "csv_import_config_names"
    INI_IBAN_LIST_FILE_NAME: str = "iban_list_file_name"
    
    INI_DATA_PICKLE_USE_JSON: str = "data_pickle_use_json"
    INI_DATA_PICKLE_JSONFILE_LIST: str = "data_pickle_jsonfile_list"
    INI_DATA_PICKLE_USE_JSON_NO: int = 0
    INI_DATA_PICKLE_USE_JSON_WRITE: int = 1
    INI_DATA_PICKLE_USE_JSON_READ: int = 2
    INI_LOG_SCREEN_OUT_NAME: str = "log_screen_out"
    INI_IBAN_LIST_FILE_NAME: str = "iban_list_file_name"
    INI_WP_DATA_STORE_PATH_NAME: str = "wp_data_store_path"
    INI_WP_DATA_USE_JSON_NAME: str = "wp_data_use_json"

    INI_BASE_PROOF_LISTE = [(INI_KONTO_DATA_LIST_NAMES_NAME,"list_str")
                           ,(INI_DEPOT_DATA_LIST_NAMES_NAME,"list_str")
                           ,(INI_CSV_IMPORT_CONFIG_NAMES_NAME,"list_str")
                           ,(INI_DATA_PICKLE_USE_JSON,"int","int")
                           ,(INI_DATA_PICKLE_JSONFILE_LIST, "list_str")
                           ,(INI_LOG_SCREEN_OUT_NAME,"str")
                           ,(INI_IBAN_LIST_FILE_NAME,"str")
                           ,(INI_WP_DATA_STORE_PATH_NAME,"str")
                           ,(INI_WP_DATA_USE_JSON_NAME,"str")
                           ]
    

    INI_IBAN_NAME: str = "iban"
    INI_BANK_NAME: str = "bank"
    INI_WER_NAME: str = "wer"
    INI_START_WERT_NAME: str = "start_wert"
    INI_START_TAG_NAME: str = "start_tag"
    INI_START_ZEIT_NAME: str = "start_zeit"
    INI_START_DATUM_NAME: str = "start_datum"
    INI_IMPORT_CONFIG_TYPE_NAME: str = "import_config_type"

    # Liste der zu checkenden Daten
    # ------------------------------
    INI_KONTO_PROOF_LISTE = [(INI_IBAN_NAME, "iban")
                            , (INI_BANK_NAME, "str")
                            , (INI_WER_NAME, "str")
                            , (INI_START_WERT_NAME, "euroStrK","cent")
                            , (INI_START_DATUM_NAME, "datStrP","dat")
                            , (INI_IMPORT_CONFIG_TYPE_NAME, "str")]
    
    INI_DEPOT_KONTO_NAME: str = "konto"
    
    # Liste der zu checkenden Daten von DEPOT
    # ---------------------------------------
    INI_DEPOT_PROOF_LISTE = [ (INI_BANK_NAME, "str")
                            , (INI_WER_NAME, "str")
                            , (INI_DEPOT_KONTO_NAME,"str")]
    
    INI_CSV_TRENNZEICHEN: str = "trenn_zeichen"
    INI_CSV_HEADER_NAMEN: str = "header_namen"
    INI_CSV_HEADER_ZUORDNUNG: str = "header_zuordnung"
    INI_CSV_HEADER_DATA_TYPE: str = "header_data_type"
    
    INI_CSV_BUCHTYPE_NAMEN: str = "buchtype_namen"
    INI_CSV_BUCHTYPE_ZUORDNUNG: str = "buchtype_zuordnung"
    
    INI_CSV_PROOF_LISTE = [(INI_CSV_TRENNZEICHEN, "str")
        , (INI_CSV_HEADER_NAMEN, "list")
        , (INI_CSV_HEADER_ZUORDNUNG, "list_str")
        , (INI_CSV_HEADER_DATA_TYPE, "list_str")
        , (INI_CSV_BUCHTYPE_NAMEN, "list")
        , (INI_CSV_BUCHTYPE_ZUORDNUNG, "list_str")]
    
    # HEADER_BUCHDATUM_NAME: str = "header_buchdatum"
    # HEADER_WERTDATUM_NAME: str = "header_wertdatum"
    # HEADER_WER_NAME: str       = "header_wer"
    # HEADER_COMMENT_NAME: str   = "header_comment"
    # HEADER_WERT_NAME: str      = "header_wert"
    # HEADER_BUCHTYPE_NAME: str   = "header_buchtype"
    
    # INI_KONTO_BUCH_EINZAHLUNG_NAME: str   = "buchung_einzahlung"
    # INI_KONTO_BUCH_AUSZAHLUNG_NAME: str   = "buchung_auszahlung"
    # INI_KONTO_BUCH_KOSTEN_NAME: str       = "buchung_kosten"
    # INI_KONTO_BUCH_WP_KAUF_NAME: str      = "buchung_wp_kauf"
    # INI_KONTO_BUCH_WP_VERKAUF_NAME: str   = "buchung_wp_verkauf"
    # INI_KONTO_BUCH_WP_KOSTEN_NAME: str    = "buchung_wp_kosten"
    # INI_KONTO_BUCH_WP_EINNAHMEN_NAME: str = "buchung_wp_einnahmen"
    
    INI_KONTO_STR_EURO_TRENN_BRUCH = "string_euro_trenn_bruch"
    INI_KONTO_STR_EURO_TRENN_TAUSEND = "string_euro_trenn_tausend"
    INI_KONTO_CSV_TRENN_DATA = "string_csv_trenn_zeichen"
    

    DDICT_TYPE_NAME: str = "dict_type"
    PROG_DATA_TYPE_NAME: str = "prog_data"
    KONTO_DATA_TYPE_NAME: str = "konto"
    CSV_DATA_TYPE_NAME: str = "csv"
    DEPOT_DATA_TYPE_NAME: str = "depot"
    DEPOT_WP_DATA_TYPE_NAME: str = "depot_wp"
    DEPOT_WP_DEPOT_NAME_KEY: str = "depot_name_key"
    IBAN_DATA_TYPE_NAME:  str = "iban"

    # konto daten data set
    KONTO_PREFIX: str = "konto"
    KONTO_NAME: str = "konto_name"
    # konto daten data set
    DEPOT_PREFIX: str = "depot"
    DEPOT_NAME: str = "depot_name"
    DEPOT_WP_PREFIX: str = "depot_wp"
    
    # allgemeine Daten
    ID_MAX_NAME: str = "id_max"
    
    ALLG_PREFIX_NAME = "allg"
    IBAN_PREFIX = "iban"

    ALLG_DATA_NAME = "prog_data"

    IBAN_DATA_DICT_NAME: str = "iban_data_dict"
    IBAN_DATA_LIST_NAME: str = "iban_data_list"
    
    IBAN_DATA_TABLE_NAME: str = "iban_data_table"

    # konto names from ini
    # KONTO_NAMES: str = field(default_factory=str)
    
    # KONTO_DATA_ID_MAX_NAME: str = "konto_id_max"
    
    # konto data
    KONTO_DATA_SET_NAME: str = "konto_data_set"
    KONTO_DATA_BANK_NAME: str = "bank"
    KONTO_DATA_SET_DICT_LIST_NAME: str = "konto_data_set_dict_list"
    KONTO_DATA_TYPE_DICT_NAME: str = "konto_data_type_dict"
    KONTO_DATA_SET_TABLE_NAME: str = "konto_data_set_table"
    KONTO_DATA_ID_NEW_LIST: str = "konto_id_new_list"
    
    INI_DATA_KEYS_NAME: str = "ini_data_keys"
    
    
    CSV_TRENNZEICHEN: str = "trenn_zeichen"
    CSV_BUCHTYPE_DICT: str = "buchtype_dict"
    CSV_HEADER_NAME_DICT: str = "header_name_dict"
    CSV_HEADER_TYPE_DICT: str = "header_type_dict"
    
    CSV_BUCHTYPE_ZUORDNUNG_NAME: str = "buchtype_zuordnung"
    CSV_HEADER_ZUORDNUNG_NAME: str = "header_zuordnung"
    CSV_HEADER_TYPE_ZUORDNUNG_NAME: str = "header_type_zuordnung"

    # depot data
    # DEPOT_DATA_SET_NAME: str = "depot_data_set"
    DEPOT_DATA_ISIN_LIST_NAME: str = "depot_data_isin_list"
    DEPOT_DATA_DEPOT_WP_LIST_NAME: str = "depot_wp_name_list"
    
    # Parameter wp_data_set
    ISIN: str = "isin"
    WP_NAME: str = "wp_name"
    WP_KATEGORIE: str = "wp_kategorie"
    WP_DATA_SET_DICT_LIST: str = "wp_data_set_dict_list"
    WP_DATA_SET_NAME_DICT: str = "wp_data_set_name_dict"
    WP_DATA_SET_TYPE_DICT: str = "wp_data_set_type_dict"
    WP_DATA_SET_TABLE_NAME: str = "wp_data_set_table"


  
def get(log):
    
    p = Parameter()
    
    # change if not printing on screen
    p.LOG_SCREEN_OUT = log.GUI_SCREEN
    
    return p
# end def

