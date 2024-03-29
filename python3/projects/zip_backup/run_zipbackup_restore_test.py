import os,sys

tools_path = os.getcwd()
if (tools_path not in sys.path):
    sys.path.append(tools_path)

import zip_backup as zb

d = {}

# Zielpfad
##d[zb.A_TARGET_PATH]       = "K:\\temp"
##if( not os.path.isdir(d[zb.A_TARGET_PATH]) ):
##    print("!!!! Verzeichnis %s existiert nicht, bitte noch mal pruefen" % d[zb.A_TARGET_PATH])
##    d[zb.A_TARGET_PATH] = None
##    exit

# Version
#d[zb.A_RESTORE_VERSION]     = -1
# Welcher Pfad soll zurueckgeholt werden
d[zb.A_RESTORE_SOURCE_PATH] = "K:\\tools\\testbackup"
# Wohin soll es gesichert werden, None: Abfrage durchf?hren
d[zb.A_RESTORE_TARGET_PATH] = "K:\\temp"

a = zb.Restore(dict=d)
if( a.STATUS == zb.OKAY ):
    a.make_restore()


input("Ende <return>")


