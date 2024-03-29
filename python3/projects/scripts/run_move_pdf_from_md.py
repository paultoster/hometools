#-------------------------------------------------------------------------------
# Name:        run_move_pdf_from_md
# Purpose:
#
# Author:      tom
#
# Created:     21.07.2023
# Copyright:   (c) tom 2023
# Licence:     <your licence>
#-------------------------------------------------------------------------------

import sys
import os
import shutil

tools_path = os.getcwd() + "\\.."
if( tools_path not in sys.path ):
    sys.path.append(tools_path)

from tools import hfkt_file_path as hfp
from tools import hfkt_str as hs

md_dir = "K:/data/md/"
nmd_dir = len(md_dir)

script_dir = "K:/media/mdscripts"

def main(item):

  sfilename = hs.change_max(item,"\\","/")

  tleaf =  sfilename[nmd_dir:]

  tfilename = os.path.join(script_dir,tleaf)

  (tpath,tbody,text) = hs.file_split(tfilename)


  # Zielpfad pruefen
  if( not os.path.isdir(tpath) ):
    try:
      os.makedirs(tpath)
    except OSError:
      print("error: os.makedir(\"%s\") not possible" % tpath)
      exit(1)
    #try
  #endif

  shutil.move(sfilename,tfilename)
  print(f"{sfilename} -> {tfilename}")

if __name__ == '__main__':


    liste = hfp.find_file_pattern('*.pdf', md_dir)

    for item in liste:


      main(item)
