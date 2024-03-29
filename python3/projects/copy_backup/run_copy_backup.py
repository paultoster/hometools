import sys
project_path = "K:\\tools\\hometools\\python3\\projects\\copy_backup"
if( project_path not in sys.path ):
    sys.path.append(project_path)

import copy_backup

dict = {}
# Quellpafad
dict[copy_backup.NAME_SOURCE_PATH]  = "K:\\data\\md"
# Zielpfad
dict[copy_backup.NAME_TARGET_PATH]  = "K:\\temp"
# Ausschlusspfade
dict[copy_backup.NAME_EXCLUDE_ABS_PATH_LIST] = ["RECYCLER","System Volume Information","ctNotWin2011","found.000"]
dict[copy_backup.NAME_EXCLUDE_REL_PATH_LIST] = [".svn","ctNotWin2011","RECYCLER","System Volume Information"]
# Ausschlussextensions
dict[copy_backup.NAME_EXCLUDE_EXT_LIST]  = [".obj","bak"]
dict[copy_backup.NAME_EXACT_COPY_FLAG] = 1


a = copy_backup.copybackup(dict)
if( a.STATUS == copy_backup.OKAY ):
    a.make_backup()

x = input("<pause>")
