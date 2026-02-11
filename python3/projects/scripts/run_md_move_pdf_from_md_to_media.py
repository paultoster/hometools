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

t=__file__.split(os.sep)
t[0]=t[0]+os.sep
tools_path = os.path.join(*(t[0:len(t)-2]))
if( tools_path not in sys.path ):
    sys.path.append(tools_path)

from tools import hfkt_file_path as hfp
from tools import hfkt_str as hs

md_dir = "K:\\data\\md\\"
nmd_dir = len(md_dir)

script_dir = "K:\\media\\wort\\mdscripts"

def main(item):

  # sfilename = hs.change_max(item,"\\","/")

  tleaf =  item[nmd_dir:]

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

  shutil.move(item,tfilename)
  print(f"{item} -> {tfilename}")

if __name__ == '__main__':


    liste = hfp.find_file_pattern('*.pdf', md_dir)

    for item in liste:


      main(item)
