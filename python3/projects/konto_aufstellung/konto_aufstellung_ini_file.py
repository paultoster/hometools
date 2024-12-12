import os, sys
import tomllib

tools_path = os.getcwd() + "\\.."
if( tools_path not in sys.path ):
    sys.path.append(tools_path)
#endif

# Hilfsfunktionen
import hfkt_def as hdef

status  = hdef.OKAY
errtext = ""
logtext = ""

def read(ini_file_name:str):
  global status
  global errtext
  
  status  = hdef.OKAY
  data    = []
  
  if( not os.path.isfile(ini_file_name) ):
    status  = hdef.NOT_OKAY
    errtext = f"ini_file_name = {ini_file_name} does not exist !!!!"
  else:
    with open(ini_file_name, "rb") as f:
      data = tomllib.load(f)
  
  
  return data
#enddef