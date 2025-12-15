# -*- coding: cp1252 -*-
# rename path and filenames and content
#
import os
import sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)

from tools import hfkt as h



"""
start_dir_vorschlag="K:/media/ton/mp3/m3u"
old_name_list = ["K:\\media\ton"]
new_name_list = ["K:\\media\\ton"]
extension_list = ["m3u"]
"""


start_dir_vorschlag="K:\\media\\bilder\\2025\\Suedamerika\\7_Iguazu_Brasilien"


start_dir = h.abfrage_dir(comment="Welches Verzeichnis �ndern",start_dir=start_dir_vorschlag)
liste = []

liste = h.get_liste_of_subdir_files(start_dir,liste=liste)

for item in liste:

    
    (path,body,ext) = h.file_split(item)

    i0 = h.such(body,"_TZ81_","vs")
    if i0 >= 0:
        print(item)
        hour = body[9:11]
        hournew = str(int(hour)-5)
        body_new = body[0:9]+hournew+body[11:]
        new_item = os.path.join(path, body_new + "." + ext)
        os.rename(item, new_item)
        print(new_item)
    # end if
# end ofr


