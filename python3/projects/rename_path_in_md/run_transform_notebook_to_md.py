# -*- coding: cp1252 -*-
# -------------------------------------------------------------------------------
# Name:        run_transform_notebook_to_md
# Purpose:     Aus einem Verzeichnis werden die notes page.html gelesen und in markdown format gewandelt
#
# Author:      tom
#
# Created:     03.06.2023
# Copyright:   (c) tom 2023
# Licence:     <your licence>
# -------------------------------------------------------------------------------

import sys, os

tools_path = os.getcwd() + "\\.."
if( tools_path not in sys.path ):
    sys.path.append(tools_path)

from tools import hfkt as h
from markdownify import markdownify


if __name__ == '__main__':

    # source dir mit allen html-files
    src_dir = "K:/data/NotebookKultur/bücher"
    # target dir, indem die Texte in md abgelegt werden sollen
    trg_dir = "K:/data/md/Media/GeleseneBücher"

    # Suche alle Unterverzeichnisse in einer Liste
    folder_list = h.get_liste_of_subdirs(src_dir, [])

    # Gehe durch die Liste
    for folder in folder_list:
        print(f"Folder: {folder}")

        # Finde die html-Seite
        filename = os.path.join(folder,"page.html")

        # Wenn File vorhanden
        if( os.path.isfile(filename) ):

            # Lese html-Daei
            htmltext = open(filename,"r", encoding="utf8").read()

            # Wandele in md
            mdtext   = markdownify(htmltext, heading_style="ATX")

            # suche alle Bilder in folder
            imagefile_list = h.get_liste_of_subdir_files(folder,[],search_ext=["png"],exlude_main_path=False)

            # Benenne image-Datei um, wenn vorhanden
            if( len(imagefile_list) > 0 ):

                name = h.get_last_subdir_name(folder)


                for i,ifile in enumerate(imagefile_list):

                    (p,body,e) = h.get_pfe(ifile)
                    bodyneu   = name + str(i)
                    cpyname = h.set_pfe(p=folder, b=bodyneu, e=e)

                    h.copy(ifile,cpyname)

                    mdtext = h.change_max(mdtext, body, bodyneu)


            # Bilde filnamen
            filenameout = h.set_pfe(p=folder, b=name, e="md")

            with open(filenameout, 'w') as f:
                f.write(mdtext)






