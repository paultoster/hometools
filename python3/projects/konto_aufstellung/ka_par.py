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


@dataclass
class Parameter:
    OKAY: int = hdef.OK
    NOT_OKAY: int = hdef.NOT_OK
    # logging
    LOG_SCREEN_OUT: int = field(default_factory=int)
    
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
    AUSZUGS_TYP_NAME: str = "auszug_type"
    
    HEADER_BUCHDATUM_NAME: str = "header_buchdatum"
    HEADER_WERTDATUM_NAME: str = "header_wertdatum"
    HEADER_WER_NAME: str       = "header_wer"
    HEADER_COMMENT_NAME: str   = "header_comment"
    HEADER_WERT_NAME: str      = "header_wert"
    HEADER_BUCHTYPE_NAME: str   = "header_buchtype"
    
    # Reihenfolge entspricht KONTO_DATA_ITEM_LIST
    INI_KONTO_HEADER_NAME_LIST     = (HEADER_BUCHDATUM_NAME
                                 ,HEADER_WERTDATUM_NAME
                                 ,HEADER_WER_NAME
                                 ,HEADER_BUCHTYPE_NAME
                                 ,HEADER_WERT_NAME
                                 ,HEADER_COMMENT_NAME)
    
    INI_KONTO_BUCH_EINZAHLUNG_NAME: str = "buchung_einzahlung"
    INI_KONTO_BUCH_AUSZAHLUNG_NAME: str = "buchung_auszahlung"
    INI_KONTO_BUCH_KOSTEN_NAME: str = "buchung_kosten"
    INI_KONTO_BUCH_WP_KAUF_NAME: str = "buchung_wp_kauf"
    INI_KONTO_BUCH_WP_VERKAUF_NAME: str = "buchung_wp_verkauf"
    INI_KONTO_BUCH_WP_KOSTEN_NAME: str = "buchung_wp_kosten"
    INI_KONTO_BUCH_WP_EINNAHMEN_NAME: str = "buchung_wp_einnahmen"

    # Liste der zu checkenden Daten
    # ------------------------------
    INI_KONTO_PROOF_LISTE = [(IBAN_NAME, "iban")
                        , (BANK_NAME, "str")
                        , (WER_NAME, "str")
                        , (START_WERT_NAME, "float")
                        , (START_DATUM_NAME, "dat")
                        , (AUSZUGS_TYP_NAME, "str")]
    
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
    KONTO_DATA_ITEM_LIST: List[str] = ( "id"         # set internally
                                      , "buchdatum"  # int read from csv/pdf
                                      , "wertdatum"  # int read from csv/pdf
                                      , "wer"        # str read from csv/pdf
                                      , "buchtype"   # int raed from csv/pdf
                                      , "wert"       # int read from csv/pdf
                                      , "comment"    # str read from csv/pdf
                                      , "isin")      # str extracted from data
    
    KONTO_DATA_INDEX_ID: int        = 0
    KONTO_DATA_INDEX_BUCHDATUM: int = 1
    KONTO_DATA_INDEX_WERTDATUM: int = 2
    KONTO_DATA_INDEX_WER: int       = 3
    KONTO_DATA_INDEX_BUCHTYPE: int  = 4
    KONTO_DATA_INDEX_WERT: int      = 5
    KONTO_DATA_INDEX_COMMENT: int   = 6
    KONTO_DATA_INDEX_ISIN: int      = 7
    
    KONTO_BUCHUNG_UNBEKANNT: int     = 0
    KONTO_BUCHUNG_EINZAHLUNG: int    = 1
    KONTO_BUCHUNG_AUSZAHLUNG: int    = 2
    KONTO_BUCHUNG_KOSTEN: int        = 3
    KONTO_BUCHUNG_WP_KAUF: int       = 4
    KONTO_BUCHUNG_WP_VERKAUF: int    = 5
    KONTO_BUCHUNG_WP_KOSTEN: int     = 6
    KONTO_BUCHUNG_WP_EINNAHMEN:int   = 7
    
    KONTO_DATA_BUCHTYPE_LIST = [(INI_KONTO_BUCH_EINZAHLUNG_NAME,KONTO_BUCHUNG_EINZAHLUNG)
                               ,(INI_KONTO_BUCH_AUSZAHLUNG_NAME,KONTO_BUCHUNG_AUSZAHLUNG)
                               ,(INI_KONTO_BUCH_KOSTEN_NAME,KONTO_BUCHUNG_KOSTEN)
                               ,(INI_KONTO_BUCH_WP_KAUF_NAME,KONTO_BUCHUNG_WP_KAUF)
                               ,(INI_KONTO_BUCH_WP_VERKAUF_NAME,KONTO_BUCHUNG_WP_VERKAUF)
                               ,(INI_KONTO_BUCH_WP_KOSTEN_NAME,KONTO_BUCHUNG_WP_KOSTEN)
                               ,(INI_KONTO_BUCH_WP_EINNAHMEN_NAME,KONTO_BUCHUNG_WP_EINNAHMEN)
                               ]

def get(log):
    
    p = Parameter()
    
    # change if not printing on screen
    p.LOG_SCREEN_OUT = log.GUI_SCREEN
    
    return p
# end def

