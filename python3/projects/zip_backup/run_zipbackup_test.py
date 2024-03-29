import sys,os

tools_path = os.getcwd()

if( tools_path not in sys.path ):
    sys.path.append(tools_path)

import zip_backup as zb

dir(zb)

d = {}
# Quellpafad
d[zb.A_SOURCE_PATH]       = os.getcwd()
# Zielpfad
d[zb.A_TARGET_PATH]       = "K:\\tools\\testbackup"
# maximale Backups aufheben
d[zb.A_MAX_BACKUPS]       = 1

# Ausschlusspfade
d[zb.A_EXCLUDE_PATH]      = ["$RECYCLE.BIN","Config.Msi","DSBackupRestore","DSRestore","DSUsers","IPG","msys-2003","PortablePrograms","Program Files","Program Files (x86)","Programme (x86)","MatlabR2011b","Python26","RTAS","System Volume Information","temp","transfer"]
# Ausschlussextensions
d[zb.A_EXCLUDE_EXT]       = [".obj",".sbr",".pdb","bak","ppc","zpp"]
# relativer Ausschlusspfad
d[zb.A_EXCLUDE_REL_PATH]  = [".svn","tmp","out","SimOut"]

a = zb.Backup(dict=d)
if( a.STATUS == zb.OKAY ):
    a.make_backup()


input("Ende  <return>")


