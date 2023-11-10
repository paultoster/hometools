# -*- coding: cp1252 -*-
import sys
import os
import string
from tkinter import *
from tkinter.constants import *
import tkinter.filedialog
import py7zr

import hfkt as h


  
def abfrage_dir(comment=None,start_dir=None):
    """ gui für Pfad auszuw�hlen """
    root = Tk()
    dir = tkinter.filedialog.askdirectory(master=root, title=comment, initialdir=start_dir)
    root.destroy()
    dir = dir.replace("/",os.sep)
    return dir

############################################################################

if __name__ == '__main__':

  ii = len(sys.argv)
  if( ii > 1 ):
    MAIN_PATH = sys.argv[1]
  else:
    MAIN_PATH = "D:\\"

  flag = True
 
  path_list = []
  file_name_list = []
  n = 0

  while(flag):
    mdir = str(abfrage_dir("Verzeichnis auswaehlen",MAIN_PATH))

    if( os.path.exists(mdir) ):

      liste = mdir.split(os.sep)

      MAIN_PATH = h.join_list(liste[0:-1],os.sep)

      path_list.append(mdir)     
      file_name_list.append(os.path.join(MAIN_PATH,liste[-1]+".7z"))
      n += 1
    else:
      flag = False
    #endif
  #endwhile

  for i in range(n): 

    zip_file_name = file_name_list[i]

    with py7zr.SevenZipFile(zip_file_name,'w') as archive:
      print("Start 7zip: %s with %s" % (zip_file_name,path_list[i]))
      archive.writeall(path_list[i],'d')
      print("End 7zip: %s" % zip_file_name)
    #endwith
  #endfor

  print ("Finish")
  input("Ende copy (return)")




