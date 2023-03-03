


from anlage_class import Anlage

import configparser as cp
import wand
from auswahl_liste import auswahl_liste
from daten_laden import daten_laden
from ausgabe_excel import ausgabe_excel



CONFIG_FILE = "config.ini"

# Einlesen der Config-Datei
#--------------------------
par = cp.ConfigParser()
par.read(CONFIG_FILE)
anlagen_liste = par.sections()

# Wandeln der Daten
# wert_... wird von € in Cent gerechnet
# datum_... wird von str in epochenzeit gewandelt
# dataclass anlegen 
# in liste eintragen
#-------------------------------------------------
a_liste = []
for anlage in anlagen_liste:  

  if( anlage == 'allg' ):
    pass
  else:
    p = wand.wand_anlagen_config_to_intern(anlage,par[anlage])
    a = Anlage(anlage,p)
    a_liste.append(a)
  #endif
#endfor

INDEX_DATEN_LADEN   = 0
INDEX_AUSGABE_EXCEL = 1
INDEX_ENDE          = 2
liste = ['Daten einladen','Ausgabe Excel erstellen','Ende']


index = 0
while( index >= 0):

  (a,index) = auswahl_liste(liste)

  if( index == INDEX_DATEN_LADEN ):
      
      a_liste = daten_laden(a_liste)
    
  elif( index == INDEX_AUSGABE_EXCEL ):
      
      a_liste = ausgabe_excel(a_liste)
    
  else:
      
      index = -1 
    
  #endif
#endwhile




# Wandeln der Daten zurück
# wert_... wird von Cent in € gerechnet
# datum_... wird von epochenzeit in str gewandelt
#-------------------------------------------------
pout = cp.ConfigParser()

for a in a_liste:  
  pout[a.name] = wand.wand_anlagen_config_to_extern(a.name,a.par)
#endfor

# Speichern der Konfigdaten (Überprüfung)
#----------------------------------------
with open('test.ini', 'w') as config:
  pout.write(config)
#endwith

