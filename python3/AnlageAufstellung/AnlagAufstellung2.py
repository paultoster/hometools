import configparser as cp
import wand

CONFIG_FILE = "config.ini"

# Einlesen der Config-Datei
#--------------------------
par = cp.ConfigParser()
par.read(CONFIG_FILE)
anlagen_liste = par.sections()

# Wandeln der Daten
# wert_... wird von € in Cent gerechnet
# datum_... wird von str in epochenzeit gewandelt
#-------------------------------------------------
p = {}
for anlage in anlagen_liste:  
  p[anlage] = wand.wand_anlagen_config_to_intern(anlage,par[anlage])
#endfor




# Wandeln der Daten zurück
# wert_... wird von Cent in € gerechnet
# datum_... wird von epochenzeit in str gewandelt
#-------------------------------------------------
pout = cp.ConfigParser()
for anlage in anlagen_liste:  
  pout[anlage] = wand.wand_anlagen_config_to_extern(anlage,p[anlage])
#endfor

# Speichern der Konfigdaten (Überprüfung)
#----------------------------------------
with open('test.ini', 'w') as config:
  pout.write(config)
#endwith

