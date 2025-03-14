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
    LOG_SCREEN_OUT: int = field(default_factory=int)
    KONTO_NAMES_NAME: str = "konto_names"
    IBAN_LIST_FILE_NAME: str = "iban_list_file_name"
    DATA_PICKLE_USE_JSON: str = "data_pickle_use_json"
    DATA_PICKLE_JSONFILE_LIST: str = "data_pickle_jsonfile_list"
    DATA_PICKLE_USE_JSON_NO: int = 0
    DATA_PICKLE_USE_JSON_WRITE: int = 1
    DATA_PICKLE_USE_JSON_READ: int = 2

    BASE_PROOF_LISTE = [(KONTO_NAMES_NAME,"list_str")
                       ,(IBAN_LIST_FILE_NAME,"str")
                        ,(DATA_PICKLE_USE_JSON,"int")
                        ,(DATA_PICKLE_JSONFILE_LIST, "list_str")]
    # konto daten
    KONTO_PREFIX: str = "konto"
    IBAN_NAME: str = "iban"
    BANK_NAME: str = "bank"
    WER_NAME: str = "wer"
    START_WERT_NAME: str = "start_wert"
    START_TAG_NAME: str = "start_tag"
    START_TAG_NAME: str = "start_zeit"
    START_DATUM_NAME: str = "start_datum"
    AUSZUGS_TYP_NAME: str = "auszug_type"
    # Liste der zu checkenden Daten
    # ------------------------------
    KONTO_PROOF_LISTE = [(IBAN_NAME, "iban")
                        , (BANK_NAME, "str")
                        , (WER_NAME, "str")
                        , (START_WERT_NAME, "float")
                        , (START_DATUM_NAME, "dat")
                        , (AUSZUGS_TYP_NAME, "str")]

    # IBAN_PICKLE_NAME = "iban_liste"
    IBAN_DICT_DATA_NAME: str = "iban_dict_data"
    IBAN_DATA_LIST_NAME: str = "iban_data_list"
    IBAN_ID_MAX_NAME: str    = "iban_id_max"
    IBAN_ITEM_LIST: List[str] = ("id","iban", "bank", "wer", "comment")
    # konto names from ini
    KONTO_NAMES: str = field(default_factory=str)
    



def get(log):
    
    p = Parameter()
    
    # change if not printing on screen
    p.LOG_SCREEN_OUT = log.GUI_SCREEN
    
    return p
# end def

