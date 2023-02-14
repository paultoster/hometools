# -*- coding: cp1252 -*-
# rename path and filenames and content
#
import os
import sys
import hfkt as h


if __name__ == "__main__":
    
  print(" ")
  print("Pfad <%s> " % os.getcwd())
  if( len(sys.argv) > 3 ):
    
    filename = sys.argv[1]
    textold  = sys.argv[2]
    textnew  = sys.argv[3]
    
    print(" ")
    print("filename <%s> " % filename)
    print(" ")
    print("textold <%s> " % textold)
    print(" ")
    print("textnew <%s> " % textnew)
    print(" ")
    
      
    if( not os.path.isfile(filename) ):
      print("Datei <%s> konnte nicht gefunden werden" % filename)
      exit(1)
    else:
      h.change_text_in_file(filename,textold,textnew)
    #endif
    
  else:
    print("Fif len(sys.argv) <= 3:")
    exit(1)
  #endif
