# -*- coding: cp1252 -*-
#
# AdressBookDef:
#              Defines von Werten
#
# verionen:
# 0.0
#

OKAY     = 1
OK       = 1
NOT_OKAY = 0
NOT_OK   = 0

# default log-file
LOG_FILE_NAME_DEFAULT = "AdressBook.log"

# Icon
GUI_ICON_FILE = "AdressBook.ico"

# default ini-file name
INI_FILE_NAME_DEFAULT = "AdressBook.ini"
INI_FILE_SECTION = "AdressBook"
INI_FILE_READ_CSV_FILE = "csv_file"
INI_FILE_DB_FILE = "db_file"
INI_FILE_GUI_SECTION  = "AdressBookGui"
INI_FILE_GUI_GEOMETRY_WIDTH  = "gui_geometry_width"
INI_FILE_GUI_GEOMETRY_HEIGHT = "gui_geometry_height"

# Log-File
A_LOG_ERROR   = "Fehler: "
A_LOG_WARNING = "Warnung: "

# interne Attribute
#
A_ID                = "ID"
A_GROUPNAME         = "groupname"
A_ANREDE            = "Anrede"
A_VORNAME           = "Vorname"
A_NACHNAME          = "Nachname"
A_ANZEIGENAME       = "Anzeigename"
A_SPITZNAME         = "Spitzname"
A_EMAIL_PRIVAT      = "Email_privat"
A_TELEFON_PRIVAT    = "Telefon_privat"
A_FAX_PRIVAT        = "Fax_privat"
A_MOBIL_PRIVAT      = "Mobil_privat"
A_ADRESSE_PRIVAT    = "Adresse_privat"
A_ORT_PRIVAT        = "Ort_privat"
A_PLZ_PRIVAT        = "PLZ_privat"
A_BUNDESLAND_PRIVAT = "Bundesland_privat"
A_LAND_PRIVAT       = "Land_privat"
A_WEBSEITE_PRIVAT   = "Webseite_privat"
A_EMAIL_DIENST      = "Email_dienst"
A_TELEFON_DIENST    = "Telefon_dienst"
A_FAX_DIENST        = "Fax_dienst"
A_MOBIL_DIENST      = "Mobil_dienst"
A_ADRESSE_DIENST    = "Adresse_dienst"
A_ORT_DIENST        = "Ort_dienst"
A_PLZ_DIENST        = "PLZ_dienst"
A_BUNDESLAND_DIENST = "Bundesland_dienst"
A_LAND_DIENST       = "Land_dienst"
A_TITEL_DIENST      = "Titel_dienst"
A_ABTEILUNG_DIENST  = "Abteilung_dienst"
A_ORGANISATION_DIENST = "Organisation_dienst"
A_WEBSEITE_DIENST     = "Webseite_dienst"
A_GEBURTSJAHR         = "Geburtsjahr"
A_GEBURTSMONAT        = "Geburtsmonat"
A_GEBURTSTAG          = "Geburtstag"
A_NOTIZEN             = "Notizen"
A_TRENNZEICHEN        = ";;;"

# Liste der internen Attribute
#
INTERN_HEADER_LIST = [A_ID \
                     ,A_GROUPNAME \
                     ,A_NACHNAME \
                     ,A_VORNAME \
                     ,A_ANREDE \
                     ,A_ANZEIGENAME \
                     ,A_SPITZNAME \
                     ,A_ANZEIGENAME \
                     ,A_EMAIL_PRIVAT\
                     ,A_TELEFON_PRIVAT \
                     ,A_FAX_PRIVAT \
                     ,A_MOBIL_PRIVAT \
                     ,A_ADRESSE_PRIVAT \
                     ,A_ORT_PRIVAT \
                     ,A_PLZ_PRIVAT \
                     ,A_BUNDESLAND_PRIVAT \
                     ,A_LAND_PRIVAT \
                     ,A_WEBSEITE_PRIVAT \
                     ,A_EMAIL_DIENST\
                     ,A_TELEFON_DIENST \
                     ,A_FAX_DIENST \
                     ,A_MOBIL_DIENST \
                     ,A_ADRESSE_DIENST \
                     ,A_ORT_DIENST \
                     ,A_PLZ_DIENST \
                     ,A_BUNDESLAND_DIENST \
                     ,A_LAND_DIENST \
                     ,A_TELEFON_DIENST \
                     ,A_TITEL_DIENST \
                     ,A_ABTEILUNG_DIENST \
                     ,A_ORGANISATION_DIENST \
                     ,A_WEBSEITE_DIENST \
                     ,A_GEBURTSJAHR \
                     ,A_GEBURTSMONAT \
                     ,A_GEBURTSTAG \
                     ,A_NOTIZEN ]
# Import Thunderbird
# Dictionary mit Namen der Importdatei csv aus Thunderbird
# und Zuweisung auf Attribute
#
A_CSV_THUN_VORNAME   = "Vorname"
A_CSV_THUN_NACHNAME  = "Nachname"
CSV_THUNDERBIRD_DICT = {A_CSV_THUN_VORNAME:           A_VORNAME \
                       ,A_CSV_THUN_NACHNAME:          A_NACHNAME \
                       ,"Anzeigename":                A_ANZEIGENAME \
                       ,"Spitzname":                  A_SPITZNAME \
                       ,"Primäre E-Mail-Adresse":     A_EMAIL_PRIVAT \
                       ,"Sekundäre E-Mail-Adresse":   A_EMAIL_PRIVAT \
                       ,"Tel. dienstlich":            A_TELEFON_DIENST \
                       ,"Tel. privat":                A_TELEFON_PRIVAT \
                       ,"Fax-Nummer":                 A_FAX_PRIVAT \
                       ,"Pager-Nummer":               A_NOTIZEN \
                       ,"Mobil-Tel.-Nr.":             A_MOBIL_PRIVAT \
                       ,"Privat: Adresse":            A_ADRESSE_PRIVAT \
                       ,"Privat: Adresse 2":          A_ADRESSE_PRIVAT \
                       ,"Privat: Ort":                A_ORT_PRIVAT \
                       ,"Privat: Bundesland":         A_BUNDESLAND_PRIVAT \
                       ,"Privat: PLZ":                A_PLZ_PRIVAT \
                       ,"Privat: Land":               A_LAND_PRIVAT \
                       ,"Dienstlich: Adresse":        A_ADRESSE_DIENST \
                       ,"Dienstlich: Adresse 2":      A_ADRESSE_DIENST \
                       ,"Dienstlich: Ort":            A_ORT_DIENST \
                       ,"Dienstlich: Bundesland":     A_BUNDESLAND_DIENST \
                       ,"Dienstlich: PLZ":            A_PLZ_DIENST \
                       ,"Dienstlich: Land":           A_LAND_DIENST \
                       ,"Arbeitstitel":               A_TITEL_DIENST \
                       ,"Abteilung":                  A_ABTEILUNG_DIENST \
                       ,"Organisation":               A_ORGANISATION_DIENST \
                       ,"Webseite 1":                 A_WEBSEITE_DIENST \
                       ,"Webseite 2":                 A_WEBSEITE_DIENST \
                       ,"Geburtsjahr":                A_GEBURTSJAHR \
                       ,"Geburtsmonat":               A_GEBURTSMONAT \
                       ,"Geburtstag":                 A_GEBURTSTAG \
                       ,"Benutzerdef. 1":             A_NOTIZEN \
                       ,"Benutzerdef. 2":             A_NOTIZEN \
                       ,"Benutzerdef. 3":             A_NOTIZEN \
                       ,"Benutzerdef. 4":             A_NOTIZEN \
                       ,"Notizen":                    A_NOTIZEN }

# Import Outlook
# Dictionary mit Namen der Importdatei csv aus Outlook
# und Zuweisung auf Attribute
#
A_CSV_OUTL_VORNAME   = "Vorname"
A_CSV_OUTL_NACHNAME  = "Nachname"
A_CSV_OUTL_GEBURTSDATUM = "Geburtstag"
A_CSV_OUTL_KATEGORIE = "Kategorien"

CSV_OUTL_DICT        = {A_CSV_OUTL_VORNAME:           A_VORNAME \
                       ,A_CSV_OUTL_NACHNAME:          A_NACHNAME \
                       ,"Anrede":                     A_ANREDE \
                       ,"Weitere Vornamen":           A_VORNAME \
                       ,"Suffix":                     A_NOTIZEN \
                       ,"Firma":                      A_ORGANISATION_DIENST \
                       ,"Abteilung":                  A_ABTEILUNG_DIENST \
                       ,"Position":                   A_TITEL_DIENST \
                       ,"Straße_geschäftlich":        A_ADRESSE_DIENST \
                       ,"Straße_geschäftlich 2":      A_ADRESSE_DIENST \
                       ,"Straße_geschäftlich 3":      A_ADRESSE_DIENST \
                       ,"Ort_geschäftlich":           A_ORT_DIENST \
                       ,"Region_geschäftlich":        A_BUNDESLAND_DIENST \
                       ,"Postleitzahl_geschäftlich":  A_PLZ_DIENST \
                       ,"Land_geschäftlich":          A_LAND_DIENST \
                       ,"Straße_privat":              A_ADRESSE_PRIVAT \
                       ,"Straße_privat 2":            A_ADRESSE_PRIVAT \
                       ,"Straße_privat 3":            A_ADRESSE_PRIVAT \
                       ,"Ort_privat":                 A_ORT_PRIVAT \
                       ,"Region_privat":              A_BUNDESLAND_PRIVAT \
                       ,"Postleitzahl_privat":        A_PLZ_PRIVAT \
                       ,"Land_privat":                A_LAND_PRIVAT \
                       ,"Weitere_Straße":             A_NOTIZEN \
                       ,"Weitere_Straße 2":           A_NOTIZEN \
                       ,"Weitere_Straße 3":           A_NOTIZEN \
                       ,"Weiterer_Ort":               A_NOTIZEN \
                       ,"Weitere_Region":             A_NOTIZEN \
                       ,"Weitere_Postleitzahl":       A_NOTIZEN \
                       ,"Weiteres_Land":              A_NOTIZEN \
                       ,"Telefon_Assistent":          A_NOTIZEN \
                       ,"Fax_geschäftlich":           A_FAX_DIENST \
                       ,"Telefon_geschäftlich":       A_TELEFON_DIENST \
                       ,"Telefon_geschäftlich 2":     A_TELEFON_DIENST \
                       ,"Rückmeldung":                A_NOTIZEN \
                       ,"Autotelefon":                A_NOTIZEN \
                       ,"Telefon_Firma":              A_TELEFON_DIENST \
                       ,"Fax_privat":                 A_FAX_PRIVAT \
                       ,"Telefon_privat":             A_TELEFON_PRIVAT \
                       ,"Telefon_privat 2":           A_TELEFON_PRIVAT \
                       ,"ISDN":                       A_NOTIZEN \
                       ,"Mobiltelefon":               A_MOBIL_PRIVAT \
                       ,"Weiteres_Fax":               A_FAX_PRIVAT \
                       ,"Weiteres_Telefon":           A_TELEFON_PRIVAT \
                       ,"Pager":                      A_NOTIZEN \
                       ,"Haupttelefon":               A_NOTIZEN \
                       ,"Mobiltelefon_2":             A_MOBIL_PRIVAT \
                       ,"Telefon_für_Hörbehinderte":  A_NOTIZEN \
                       ,"Telex":                      A_NOTIZEN \
                       ,"Abrechnungsinformation":     A_NOTIZEN \
                       ,"Benutzer_1":                 A_NOTIZEN \
                       ,"Benutzer_2":                 A_NOTIZEN \
                       ,"Benutzer_3":                 A_NOTIZEN \
                       ,"Benutzer_4":                 A_NOTIZEN \
                       ,"Beruf":                      A_NOTIZEN \
                       ,"Büro":                       A_NOTIZEN \
                       ,"E-Mail-Adresse":             A_EMAIL_PRIVAT \
                       ,"E-Mail-Typ":                 A_NOTIZEN \
                       ,"E-Mail:_Angezeigter Name":   A_NOTIZEN \
                       ,"E-Mail_2:_Adresse":          A_EMAIL_PRIVAT \
                       ,"E-Mail_2:_Typ":              A_NOTIZEN \
                       ,"E-Mail_2:_Angezeigter Name": A_NOTIZEN \
                       ,"E-Mail_3:_Adresse":          A_EMAIL_PRIVAT \
                       ,"E-Mail_3:_Typ":              A_NOTIZEN \
                       ,"E-Mail_3:_Angezeigter Name": A_NOTIZEN \
                       ,"Empfohlen_von":              A_NOTIZEN \
                       ,A_CSV_OUTL_GEBURTSDATUM:                 A_CSV_OUTL_GEBURTSDATUM \
                       ,"Geschlecht":                 A_NOTIZEN \
                       ,"Hobby":                      A_NOTIZEN \
                       ,"Initialen":                  A_NOTIZEN \
                       ,"Internet-Frei/Gebucht":      A_NOTIZEN \
                       ,"Jahrestag":                  A_NOTIZEN \
                       ,A_CSV_OUTL_KATEGORIE:         A_CSV_OUTL_KATEGORIE \
                       ,"Kinder":                     A_NOTIZEN \
                       ,"Konto":                      A_NOTIZEN \
                       ,"Name_Assistent":             A_NOTIZEN \
                       ,"Name_des/der_Vorgesetzten":  A_NOTIZEN \
                       ,"Notizen":                    A_NOTIZEN \
                       ,"Organisations-Nr.":          A_NOTIZEN \
                       ,"Ort":                        A_NOTIZEN \
                       ,"Partner":                    A_NOTIZEN \
                       ,"Postfach_geschäftlich":      A_NOTIZEN \
                       ,"Postfach_privat":            A_NOTIZEN \
                       ,"Priorität":                  A_NOTIZEN \
                       ,"Privat":                     A_NOTIZEN \
                       ,"Regierungs-Nr.":             A_NOTIZEN \
                       ,"Reisekilometer":             A_NOTIZEN \
                       ,"Sprache":                    A_NOTIZEN \
                       ,"Stichwörter":                A_NOTIZEN \
                       ,"Vertraulichkeit":            A_NOTIZEN \
                       ,"Verzeichnisserver":          A_NOTIZEN \
                       ,"Webseite":                   A_WEBSEITE_DIENST \
                       ,"Weiteres_Postfach":          A_NOTIZEN \
                       }
A_MS_OUTL_KATEGORIE = "Kategorien"
MS_OUTL_DICT        = {"FirstName":                   A_VORNAME \
                       ,"LastName":                   A_NACHNAME \
                       ,"Initials":                   A_ANREDE \
                       ,"JobTitle":                   A_TITEL_DIENST
                       ,"CompanyName":                A_ORGANISATION_DIENST \
                       ,"Department":                 A_ABTEILUNG_DIENST \
                       ,"BusinessAddress":            A_ADRESSE_DIENST \
                       ,"BusinessAddressCity":        A_ORT_DIENST \
                       ,"BusinessAddressState":       A_BUNDESLAND_DIENST \
                       ,"BusinessAddressCountry":     A_LAND_DIENST \
                       ,"BusinessAddressPostalCode":  A_PLZ_DIENST \
                       ,"HomeAddress":                A_ADRESSE_PRIVAT \
                       ,"HomeAddressCity":            A_ORT_PRIVAT \
                       ,"HomeAddressState":           A_BUNDESLAND_PRIVAT \
                       ,"HomeAddressCountry":         A_LAND_PRIVAT \
                       ,"HomeAddressPostalCode":      A_PLZ_PRIVAT \
                       ,"BusinessFaxNumber":          A_FAX_DIENST \
                       ,"BusinessTelephoneNumber":    A_TELEFON_DIENST \
                       ,"HomeFaxNumber":              A_FAX_PRIVAT \
                       ,"HomeTelephoneNumber":        A_TELEFON_PRIVAT \
                       ,"MobileTelephoneNumber":      A_MOBIL_PRIVAT \
                       ,"Email1Address":              A_EMAIL_PRIVAT \
                       ,"Email2Address":              A_EMAIL_PRIVAT \
                       ,"Email3Address":              A_EMAIL_PRIVAT \
                       ,"WebPage":                    A_WEBSEITE_DIENST \
                       ,"Body":                       A_NOTIZEN \
                       ,"Categories":                 A_MS_OUTL_KATEGORIE \
                       }