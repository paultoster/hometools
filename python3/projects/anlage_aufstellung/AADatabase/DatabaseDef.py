import sys

# Hilfsfunktionen
from hfkt import hfkt_def as hdef
from hfkt import hfkt_db_handle  as hdbh
from hfkt import hfkt_db         as hdb

OKAY       = hdef.OK
NOT_OKAY   = hdef.NOT_OK
DEBUG_FLAG = False


AKTIVESTAT_AKTIV    = 1
AKTIVESTAT_PASSIV   = 2

CSV_FILENAME = "CsvFileName"

CURRENCY            = "€"

CELL_KEY1           = 'Key1'
CELL_KEY2           = 'Key2'
CELL_DATUM          = 'Datum'

TAB_ANLAGEKONTO     = 'Anlagekonto'
CELL_KONTONAME      = 'Kontoname'
CELL_KONTONR        = 'Kontonummer'
CELL_KONTOBLZ       = 'Kontobankleitzahl'
CELL_KONTOIBAN      = 'KontoIBAN'
CELL_KONTOSTAND     = 'Kontstand'
CELL_ANFANGSDATUM   = 'Anfangsdatum'
CELL_CSV_HEAD_NAME       = 'CsvHeadName'
CELL_CSV_HEAD_DATUM      = 'CsvHeadDatum'
CELL_CSV_HEAD_WERT       = 'CsvHeadWert'
CELL_CSV_HEAD_KOMMENTAR  = 'CsvHeadKommentar'
CELL_CSV_HEAD_IBAN       = 'CsvHeadIBAN'
CELL_CSV_HEAD_BIC        = 'CsvHeadBIC'




# CELL_TAB_NAME_CSV_KEYWORDS = 'TabNameCsvKeyWords'

TAB_BUCHUNG         = 'Buchung'
CELL_TEXT           = 'Text'
CELL_BUCH_TYPE      = 'Buchungstype'


TAB_ANLAGE          = 'Anlage'
CELL_ANLAGENAME     = 'Name'
CELL_ANLAGEWKN      = 'eWKN'
CELL_ANLAGEISIN     = 'ISIN'
CELL_INTERNETLINK   = 'InternetLink'

TAB_INTERNETTYPE     = 'Internettype'
CELL_INTERNETTYPNAME = "Typename"

TAB_ANLAGENKAUF      = "Anlagenkauf"
CELL_PREIS           = "Preis"
CELL_STUECKZAHL      = "Stueckzahl"

TAB_ANLAGENVERKAUF   = "Anlagenverkauf"

TAB_KONTOKOSTEN      = "Kontokosten"

TAB_ANLAGEKOSTEN     = "Anlagekosten"

TAB_ANLAGEEINNAHME   = "AnlageEinnahme"

TAB_KONTOEINNAHME   = "AnlageEinnahme"


DBDEFLISTE = {TAB_ANLAGEKONTO:  {'type':hdbh.DB_TAB_TYPE_BUILD,'comment':'Tabelle mit den Anlagekonto'            \
                                ,'cells': {CELL_KONTONAME: {'type':hdb.DB_DATA_TYPE_STR,'unit':'[]','comment':'Kontoname'} \
                                          ,CELL_KONTONR:   {'type':hdb.DB_DATA_TYPE_STR,'unit':'[]','comment':'Kontonummer'} \
                                          ,CELL_KONTOBLZ:  {'type':hdb.DB_DATA_TYPE_STR,'unit':'[]','comment':'Kontobankleitzahl'} \
                                          ,CELL_KONTOIBAN: {'type':hdb.DB_DATA_TYPE_STR,'unit':'[]','comment':'Konto IBAN Nummer'} \
                                          ,CELL_KONTOSTAND: {'type':hdb.DB_DATA_TYPE_CENT,'unit':'[Cent]','comment':'Kontoanfangsstand'} \
                                          ,CELL_ANFANGSDATUM: {'type':hdb.DB_DATA_TYPE_DATUM,'unit':'[]','comment':'Konto Datum Anfangsstand'}\
                                          ,CELL_CSV_HEAD_NAME: {'type':hdb.DB_DATA_TYPE_STR,'unit':'[]','comment':'csv Header String Variable für Name'}\
                                          ,CELL_CSV_HEAD_DATUM: {'type':hdb.DB_DATA_TYPE_STR,'unit':'[]','comment':'csv Header String Variable für Datum'}\
                                          ,CELL_CSV_HEAD_WERT: {'type':hdb.DB_DATA_TYPE_STR,'unit':'[]','comment':'csv Header String Variable für Wert'}\
                                          ,CELL_CSV_HEAD_KOMMENTAR: {'type':hdb.DB_DATA_TYPE_STR,'unit':'[]','comment':'csv Header String Variable für Kommentar'}\
                                          ,CELL_CSV_HEAD_IBAN: {'type':hdb.DB_DATA_TYPE_STR,'unit':'[]','comment':'csv Header String Variable für IBAN'}\
                                          ,CELL_CSV_HEAD_BIC: {'type':hdb.DB_DATA_TYPE_STR,'unit':'[]','comment':'csv Header String Variable für BIC'}\
                                          } \
                                } \
              ,TAB_BUCHUNG:      {'type':hdbh.DB_TAB_TYPE_BUILD,'comment':'einzelne Buchung eines Anlagenkontos'   \
                                ,'cells': {CELL_KEY1+'@'+TAB_ANLAGEKONTO:  {'type':hdb.DB_DATA_TYPE_KEY,'unit':'[]','comment':'Zu welchem Konto gehört die Buchung'} \
                                          ,CELL_DATUM:                     {'type':hdb.DB_DATA_TYPE_DATUM,'unit':'[Cent]','comment':'Datum Buchung'} \
                                          ,CELL_TEXT:                      {'type':hdb.DB_DATA_TYPE_STR,'unit':'[]','comment':'Text Buchung'} \
                                          ,CELL_KONTOIBAN:                 {'type':hdb.DB_DATA_TYPE_STR,'unit':'[]','comment':'Konto IBAN Nummer Herkunft'} \
                                          ,CELL_BUCH_TYPE:                 {'type':hdb.DB_DATA_TYPE_INT,'unit':'enum','comment':'Buchungstype Einnahme,Ausgabe,Kauf Anlage,Verkauf Anlage,Gewinn Anlage, Kosten Anlage'} \
                                          ,CELL_KEY2+'@'+TAB_ANLAGE:       {'type':hdb.DB_DATA_TYPE_KEY,'unit':'[]','comment':'Zu welchem Anlage gehört die Buchung, leer keine Zugehörigkeit'} \
                                          } \
                                }\
              ,TAB_ANLAGE:       {'type':hdbh.DB_TAB_TYPE_BUILD,'comment':'Tabelle für eine Anlage'            \
                                ,'cells': {CELL_KEY1+'@'+TAB_ANLAGEKONTO:  {'type':hdb.DB_DATA_TYPE_KEY,'unit':'[]','comment':'Zu welchem Konto gehört die Anlage'}        \
                                          ,CELL_ANLAGENAME:                {'type':hdb.DB_DATA_TYPE_STR,'unit':'[]','comment':'Name der Anlage'} \
                                          ,CELL_ANLAGEWKN:                 {'type':hdb.DB_DATA_TYPE_STR,'unit':'[Cent]','comment':'Wertpapier-Kennnummer wenn vorhanden'} \
                                          ,CELL_ANLAGEISIN:                {'type':hdb.DB_DATA_TYPE_STR,'unit':'[]','comment':'International Security Identification Number wenn vorhanden'} \
                                          }   \
                                }  \
              ,TAB_INTERNETTYPE: {'type':hdbh.DB_TAB_TYPE_BUILD,'comment':'Tabelle für die Infos Interdatenabfruf'            \
                                ,'cells': {CELL_INTERNETTYPNAME:       {'type':hdb.DB_DATA_TYPE_STR,'unit':'[]','comment':'Welcher Internettype zu Abruf der Daten'} \
                                          } \
                                } \
              ,TAB_ANLAGENKAUF:  {'type':hdbh.DB_TAB_TYPE_BUILD,'comment':'Tabelle für den Kauf einer Anlage'            \
                                ,'cells': {CELL_DATUM:                 {'type':hdb.DB_DATA_TYPE_DATUM,'unit':'[]','comment':'Datum'} \
                                          ,CELL_KEY1+'@'+TAB_ANLAGE:   {'type':hdb.DB_DATA_TYPE_KEY,'unit':'[]','comment':'Key von Tabelle Anlage'}        \
                                          ,CELL_PREIS:             {'type':hdb.DB_DATA_TYPE_CENT,'unit':'[Cent]','comment':'Kaufpreis der Anlage'} \
                                          ,CELL_STUECKZAHL:            {'type':hdb.DB_DATA_TYPE_INT,'unit':'[Num]','comment':'Stückzahl des Kaufs'} \
                                          } \
                                } \
              ,TAB_ANLAGENVERKAUF: {'type':hdbh.DB_TAB_TYPE_BUILD,'comment':'Tabelle für Verkauf einer Anlage'            \
                                  ,'cells': {CELL_DATUM:                 {'type':hdb.DB_DATA_TYPE_DATUM,'unit':'[]','comment':'Datum'} \
                                            ,CELL_KEY1+'@'+TAB_ANLAGE:   {'type':hdb.DB_DATA_TYPE_KEY,'unit':'[]','comment':'Key von Tabelle Anlage'}        \
                                            ,CELL_PREIS:                 {'type':hdb.DB_DATA_TYPE_CENT,'unit':'[Cent]','comment':'Kaufpreis der Anlage'} \
                                            ,CELL_STUECKZAHL:            {'type':hdb.DB_DATA_TYPE_INT,'unit':'[Num]','comment':'Stückzahl des Kaufs'} \
                                            } \
                                  }   \
              ,TAB_ANLAGEKOSTEN:   {'type':hdbh.DB_TAB_TYPE_BUILD,'comment':'Kosten der Anlage oder Anlagekonto'            \
                                  ,'cells': {CELL_DATUM:                    {'type':hdb.DB_DATA_TYPE_DATUM,'unit':'[]','comment':'Datum'} \
                                            ,CELL_KEY1+'@'+TAB_ANLAGE:      {'type':hdb.DB_DATA_TYPE_KEY,'unit':'[]','comment':'Key von Tabelle Anlage'}        \
                                            ,CELL_PREIS:                    {'type':hdb.DB_DATA_TYPE_CENT,'unit':'[Cent]','comment':'Kosten der Anlage'} \
                                            }
                                  }                                  \
              ,TAB_KONTOKOSTEN:    {'type':hdbh.DB_TAB_TYPE_BUILD,'comment':'Kosten der Anlage oder Anlagekonto'            \
                                  ,'cells': {CELL_DATUM:                    {'type':hdb.DB_DATA_TYPE_DATUM,'unit':'[]','comment':'Datum'} \
                                            ,CELL_KEY1+'@'+TAB_ANLAGEKONTO: {'type':hdb.DB_DATA_TYPE_KEY,'unit':'[]','comment':'Key von Tabelle Anlagekonto'}        \
                                            ,CELL_PREIS:                    {'type':hdb.DB_DATA_TYPE_CENT,'unit':'[Cent]','comment':'Kaufpreis der Anlage'} \
                                            }  \
                                  }  \
              ,TAB_ANLAGEEINNAHME: {'type':hdbh.DB_TAB_TYPE_BUILD,'comment':'Einnahme der Anlage '       \
                                  ,'cells': {CELL_DATUM:                    {'type':hdb.DB_DATA_TYPE_DATUM,'unit':'[]','comment':'Datum'} \
                                            ,CELL_KEY1+'@'+TAB_ANLAGE:      {'type':hdb.DB_DATA_TYPE_KEY,'unit':'[]','comment':'Key von Tabelle Anlage'}        \
                                            ,CELL_PREIS:                    {'type':hdb.DB_DATA_TYPE_CENT,'unit':'[Cent]','comment':'Kosten der Anlage'} \
                                            }
                                  }   \
              ,TAB_KONTOEINNAHME:   {'type':hdbh.DB_TAB_TYPE_BUILD,'comment':'Einnahme Anlagekonto'            \
                                  ,'cells': {CELL_DATUM:                    {'type':hdb.DB_DATA_TYPE_DATUM,'unit':'[]','comment':'Datum'} \
                                            ,CELL_KEY1+'@'+TAB_ANLAGEKONTO: {'type':hdb.DB_DATA_TYPE_KEY,'unit':'[]','comment':'Key von Tabelle Anlagekonto'}        \
                                            ,CELL_PREIS:                    {'type':hdb.DB_DATA_TYPE_CENT,'unit':'[Cent]','comment':'Kaufpreis der Anlage'} \
                                            }  \
                                  }   \
              }
