import os, sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

# Hilfsfunktionen
import hfkt_def as hdef

status = hdef.OKAY
errtext = ""
logtext = ""


def abfrage_root(data,):
  global status
  global errtext
  
  status  = hdef.OKAY
  
