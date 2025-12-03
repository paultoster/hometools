import csv
import os
import sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif
from tools import hfkt_def as hdef

class Bankdaten:
    """
    Lädt eine CSV-Datei mit Bankdaten und ermöglicht das Abfragen per BLZ oder IBAN.
    """

    def __init__(self, csv_pfad=None):
        self.status = hdef.OK
        self.errtext = ""
        if csv_pfad == None:
            verzeichnis = os.path.dirname(os.path.abspath(__file__))
            self.csv_pfad = os.path.join(verzeichnis,"BLZ.csv")
        else:
            self.csv_pfad = csv_pfad
        # end if
        self.daten = []
        self.header = [
            "Bankleitzahl",
            "Merkmal",
            "Bezeichnung",
            "PLZ",
            "Ort",
            "Kurzbezeichnung",
            "PAN",
            "BIC",
            "Prüfzifferberechnungsmethode",
            "Datensatznummer",
            "Änderungskennzeichen",
            "Bankleitzahllöschung",
            "Nachfolge-Bankleitzahl"
        ]
        self.num_header = 'Kontonummer'
        self._lade_csv()
        
    def reset_status(self):
        self.status = hdef.OKAY
        self.errtext = ""

    def _lade_csv(self):
        """Interne Methode zum Laden der CSV-Datei."""
        with open(self.csv_pfad, mode="r", encoding="ansi") as csv_datei:
            reader = csv.DictReader(csv_datei, delimiter=';')

            if reader.fieldnames != self.header:
                print(f"{reader.fieldnames = }")
                print(f"{self.header = }")
                raise ValueError(
                    f"CSV-Header stimmen nicht überein!\n"
                    f"Erwartet: {self.header}\n"
                    f"Gefunden: {reader.fieldnames}"
                )

            for zeile in reader:
                self.daten.append(zeile)

    def get_alle_daten(self):
        return self.daten

    def filter_nach_blz(self, blz: str):
        return [d for d in self.daten if d["Bankleitzahl"] == blz]

    def get_datensatz_by_blz(self, blz: str):
        treffer = self.filter_nach_blz(blz)
        
        if len(treffer) == 0:
            return None
        else:
            return treffer[0]

    # -------------------------------------------------------------
    # IBAN-Features
    # -------------------------------------------------------------
    def _iban_validieren(self, iban: str) -> bool:
        """Prüft eine IBAN gemäß ISO 7064 Mod-97."""
        iban = iban.replace(" ", "").upper()

        if len(iban) < 15 or len(iban) > 34:
            return False

        # Alphabet in Zahlen umwandeln (A = 10, B = 11, ..., Z = 35)
        iban_rearranged = iban[4:] + iban[:4]
        iban_numeric = ""
        for char in iban_rearranged:
            if char.isdigit():
                iban_numeric += char
            else:
                iban_numeric += str(ord(char) - 55)

        return int(iban_numeric) % 97 == 1

    def bankdatensatz_von_iban(self, iban: str):
        """
        Extrahiert die BLZ aus einer deutschen IBAN und liefert den passenden Datensatz.

        Rückgaben:
        - Dictionary:    Datensatz gefunden
        - None:         keine passende BLZ oder ungültige IBAN
        """

        iban = iban.replace(" ", "").upper()

        # 1. Länderprüfung
        if not iban.startswith("DE"):
            self.status  = hdef.NOT_OKAY
            self.errtext = "Nur deutsche IBANs (DE...) werden unterstützt."
            return None
        # end if
        
        # 2. Prüfen, ob IBAN formal gültig ist
        if not self._iban_validieren(iban):
            self.status  = hdef.NOT_OKAY
            self.errtext = "Die IBAN ist nicht gültig (Mod-97-Prüfung fehlgeschlagen)."
            return None
        # end if

        # 3. BLZ extrahieren (Stellen 5–12)
        blz = iban[4:12]

        datensatz = self.get_datensatz_by_blz(blz)
        
        num = iban[12:]
        
        datensatz[self.num_header] = num

        if datensatz is None:
            self.status  = hdef.NOT_OKAY
            self.errtext = f"Die IBAN: {iban} ist nicht gültig (Mod-97-Prüfung fehlgeschlagen)."
            return None

        return datensatz

###########################################################################
# testen mit main
###########################################################################
if __name__ == '__main__':
    
    bankdaten = Bankdaten("BLZ.csv")
    
    # Beispiel-IBAN einer Sparkasse / Volksbank / etc.
    iban = "DE89370400440532013000"
    
    try:
        daten = bankdaten.bankdatensatz_von_iban(iban)
        if bankdaten.status == hdef.OKAY:
            print("Gefundener Datensatz:", daten)
        else:
            print(f"Keine Bank zur IBAN-BLZ {iban = } gefunden: \\n{bankdaten.errtext}")
            bankdaten.reset_status()
            
    except ValueError as e:
        print("Fehler:", e)

