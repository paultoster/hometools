# -*- coding: cp1252 -*-
# import csv
import os
import sys

# import hfkt_tvar

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

# Hilfsfunktionen
import tools.hfkt_dict as hdict
import tools.hfkt_io as hio
import tools.hfkt_def as hdef
import tools.hfkt_pickle as hpic
# class Katalogdaten:
#     """
#     Laedt eine CSV-Datei mit Bankdaten und speichert die Zeilen intern als Dictionaries,
#     wobei die Keys die Header-Namen sind.
#     Name;Platz;WKN;ISIN;WPArt;Waehrung;Branche;Segment;Notiz
#     """
#
#     def __init__(self, csv_pfad: str):
#         self.csv_pfad = csv_pfad
#         self.daten = []
#         self.header = [
#             "Name",
#             "Platz",
#             "WKN",
#             "ISIN",
#             "WPArt",
#             "Waehrung",
#             "Branche",
#             "Segment",
#             r"Prüfzifferberechnungsmethode",
#             "Notiz"
#         ]
#         self._lade_csv()
#
#     def _lade_csv(self):
#         """Interne Methode zum Laden der CSV-Datei."""
#         with open(self.csv_pfad, mode="r", encoding="utf-8") as csv_datei:
#             reader = csv.DictReader(csv_datei, delimiter=';')
#
#             # Sicherstellen, dass die Header stimmen
#             if reader.fieldnames != self.header:
#                 raise ValueError(
#                     f"CSV-Header stimmen nicht überein!\n"
#                     f"Erwartet: {self.header}\n"
#                     f"Gefunden: {reader.fieldnames}"
#                 )
#
#             # Daten einlesen
#             for zeile in reader:
#                 self.daten.append(zeile)
#
#     def get_alle_daten(self):
#         """Gibt alle geladenen Datensätze zurück."""
#         return self.daten
#
#     def filter_kondensieren(self):
#         """Filtert die Datensätze nach Bankleitzahl."""
#
#         data_liste = []
#
#         for d in self.daten:
#             ddict = {}
#             ddict["ISIN"] = d["ISIN"]
#             ddict["Name"] = d["Name"]
#             ddict["Notiz"] = d["Notiz"]
#             ddict["Waehrung"] = d["Waehrung"]
#             data_liste.append(ddict)
#
#         return data_liste
#
def filter_kondensieren(daten):
    """Filtert die Datensätze nach Bankleitzahl."""

    dictliste = []

    for d in daten:
        ddict = {}
        ddict["ISIN"] = d["ISIN"]
        ddict["Name"] = d["Name"]
        ddict["Notiz"] = d["Notiz"]
        ddict["Waehrung"] = d["Waehrung"]
        dictliste.append(ddict)

    return dictliste


file_name = "C:/Users/tom/Documents/Lenz + Partner AG/Tai-Pan/21.0/Prot/tb_ivv11.csv"

(state,header,data)=hio.read_csv_file_header_data(file_name,delim=";")

(stat,errtext,dictliste) = hdict.transform_llist_and_header_in_dictlist(header,data)

if stat != hdef.OKAY:
    print(errtext)
else:
    dictliste1 = filter_kondensieren(dictliste)

    file_name = "D:/data/orga/wp_screener/tb_ivv11.json"
    obj = hpic.DataJson(file_name)
    obj.save(dictliste1)

    # obj = hfkt_pickle.DataJson(file_name)
    #
    #       proof obj.status and obj.errtext
    #
    #        obj.read()
    # data = obj.get_data():  get read dictionary
    #        obj.set_data(data)
    #        obj.save()
    #        obj.save(data)

    print(data)
    print(header)
    print(dictliste1)













# Name;Platz;WKN;ISIN;WPArt;Waehrung;Branche;Segment;Notiz;