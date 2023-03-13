from dataclasses import dataclass, field
import sys
import hlpfu_data as hd

BESCHREIBUNG = "beschreibung"
BANK         = "bank"
IBAN         = "iban" 
WERT_START   = "wert_start"
DATUM_START  = "datum_start"
TYPE_READ    = "type_read"

CSV_HEADER_BESCHREIBUNG = "csv_header_beschreibung"
CSV_HEADER_WERT         = "csv_header_wert"
CSV_HEADER_DATUM        = "csv_header_datum"
CSV_SUCHEN              = "csv_suchen"


@dataclass
class Anlage():
  name: str = ''
  par: dict = field(default_factory=dict)
  
  def __post_init__(self):

    if( not hd.dict_has_key(self.par,BESCHREIBUNG,'str',1) ):
      sys.exit(f"par[{BESCHREIBUNG}] ist kein string")
    #endif
    if( not hd.dict_has_key(self.par,BANK,'str',1) ):
      sys.exit(f"par[{BANK}] ist kein string")
    #endif
    if( not hd.dict_has_key(self.par,IBAN,'str',1) ):
      sys.exit(f"par[{IBAN}] ist kein string")
    #endif
    if( not hd.dict_has_key(self.par,WERT_START,'int',1) ):
      self.par[WERT_START] = 0
    #endif
    if( not hd.dict_has_key(self.par,DATUM_START,'int',1) ):
      sys.exit(f"par[{DATUM_START}] ist kein int")
    #endif
    if( not hd.dict_has_key(self.par,TYPE_READ,'str',1) ):
      sys.exit(f"par[{TYPE_READ}] ist kein string")
    #endif
    if( hd.dict_has_key(self.par,CSV_HEADER_BESCHREIBUNG,'str',1) ):
      self.par[CSV_HEADER_BESCHREIBUNG] = [self.par[CSV_HEADER_BESCHREIBUNG]]
    #endif
    if( not hd.dict_has_key(self.par,CSV_HEADER_BESCHREIBUNG,'list',1) ):
      self.par[CSV_HEADER_BESCHREIBUNG] = ""
    #endif
    if( not hd.dict_has_key(self.par,CSV_HEADER_WERT,'str',1) ):
      self.par[CSV_HEADER_WERT] = ""
    #endif
    if( not hd.dict_has_key(self.par,CSV_HEADER_DATUM,'str',1) ):
      self.par[CSV_HEADER_DATUM] = ""
    #endif
    if( not hd.dict_has_key(self.par,CSV_SUCHEN,'list',1) ):
      sys.exit(f"par[{CSV_SUCHEN}] ist keine liste")
    #endif
        
  #enddef    
#endclass
