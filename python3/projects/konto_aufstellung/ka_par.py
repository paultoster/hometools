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
import hfkt_def as hdef
import hfkt_type as htype
import hfkt_date_time as hdt

import ka_konto_data_set_class


@dataclass
class Parameter:
    OKAY: int = hdef.OK
    NOT_OKAY: int = hdef.NOT_OK
    # logging
    LOG_SCREEN_OUT: int = field(default_factory=int)
    
    STR_EURO_TRENN_BRUCH_DEFAULT: str = ","
    STR_EURO_TRENN_TAUSEN_DEFAULT: str = "."
    
    KONTO_SHOW_NUMBER_OF_LINES: int = 1000
    COLOR_SHOW_NEW_DATA_SETS: str = 'brown1'
    
    TYPE_SONST_DATA: str = "sonst"
    TYPE_KONTO_DATA: str = "konto"
    TYPE_IBAN_DATA:  str = "iban"
    
    DDICT_TYPE_NAE: str = "dicct_type"
    
    # ini-file attributes
    KONTO_DATA_DICT_NAMES_NAME: str = "konto_names"
    
    IBAN_LIST_FILE_NAME: str = "iban_list_file_name"
    
    DATA_PICKLE_USE_JSON: str = "data_pickle_use_json"
    DATA_PICKLE_JSONFILE_LIST: str = "data_pickle_jsonfile_list"
    DATA_PICKLE_USE_JSON_NO: int = 0
    DATA_PICKLE_USE_JSON_WRITE: int = 1
    DATA_PICKLE_USE_JSON_READ: int = 2

    BASE_PROOF_LISTE = [(KONTO_DATA_DICT_NAMES_NAME,"list_str")
                       ,(IBAN_LIST_FILE_NAME,"str")
                        ,(DATA_PICKLE_USE_JSON,"int")
                        ,(DATA_PICKLE_JSONFILE_LIST, "list_str")]
    
    # konto daten in ini-file
    KONTO_PREFIX: str = "konto"
    IBAN_NAME: str = "iban"
    BANK_NAME: str = "bank"
    WER_NAME: str = "wer"
    START_WERT_NAME: str = "start_wert"
    START_TAG_NAME: str = "start_tag"
    START_TAG_NAME: str = "start_zeit"
    START_DATUM_NAME: str = "start_datum"
    UMSATZ_DATA_TYPE_NAME: str = "umsatz_data_type"
    
    HEADER_BUCHDATUM_NAME: str = "header_buchdatum"
    HEADER_WERTDATUM_NAME: str = "header_wertdatum"
    HEADER_WER_NAME: str       = "header_wer"
    HEADER_COMMENT_NAME: str   = "header_comment"
    HEADER_WERT_NAME: str      = "header_wert"
    HEADER_BUCHTYPE_NAME: str   = "header_buchtype"
    
    
    INI_KONTO_BUCH_EINZAHLUNG_NAME: str   = "buchung_einzahlung"
    INI_KONTO_BUCH_AUSZAHLUNG_NAME: str   = "buchung_auszahlung"
    INI_KONTO_BUCH_KOSTEN_NAME: str       = "buchung_kosten"
    INI_KONTO_BUCH_WP_KAUF_NAME: str      = "buchung_wp_kauf"
    INI_KONTO_BUCH_WP_VERKAUF_NAME: str   = "buchung_wp_verkauf"
    INI_KONTO_BUCH_WP_KOSTEN_NAME: str    = "buchung_wp_kosten"
    INI_KONTO_BUCH_WP_EINNAHMEN_NAME: str = "buchung_wp_einnahmen"
    
    INI_KONTO_STR_EURO_TRENN_BRUCH   = "string_euro_trenn_bruch"
    INI_KONTO_STR_EURO_TRENN_TAUSEND = "string_euro_trenn_tausend"

    # Liste der zu checkenden Daten
    # ------------------------------
    INI_KONTO_PROOF_LISTE = [(IBAN_NAME, "iban")
                        , (BANK_NAME, "str")
                        , (WER_NAME, "str")
                        , (START_WERT_NAME, "float")
                        , (START_DATUM_NAME, "dat")
                        , (UMSATZ_DATA_TYPE_NAME, "str")]
    
    IBAN_PREFIX = "iban"
    IBAN_DATA_DICT_NAME: str = "iban_data_dict"
    IBAN_DATA_LIST_NAME: str = "iban_data_list"
    IBAN_DATA_ID_MAX_NAME: str    = "iban_data_id_max"
    IBAN_ITEM_LIST: List[str] = ("id","iban", "bank", "wer", "comment")

    # konto names from ini
    KONTO_NAMES: str = field(default_factory=str)
    
    # konto data
    KONTO_NAME_NAME: str = "name"
    KONTO_DATA_SET_NAME: str = "konto_data_set"
    KONTO_DATA_ID_MAX_NAME: str = "konto_id_max"
    KONTO_DATA_ID_NEW_LIST: str = "konto_id_new_list"
    
    
    # Parameter konto_data_set
    


  
def get(log):
    
    p = Parameter()
    
    # change if not printing on screen
    p.LOG_SCREEN_OUT = log.GUI_SCREEN
    
    return p
# end def

