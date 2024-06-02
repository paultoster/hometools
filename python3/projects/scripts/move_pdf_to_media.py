#
# Verschiebe pdf-Dateien aus einem Verzeichnis aus md in das entsprechende Verzeichnis in media
# example root_src = "K:\\data\\md"
#         root_trg = "K:\\media\\wort\\mdscripts"
# pdf: "K:\\data\\md\\Kochen\\Kuchen\\Apple Crumle.pdf" => "K:\\media\\wort\\mdscripts\\Kochen\\Kuchen\\Apple Crumle.pdf"
#
import os, sys

t=__file__.split(os.sep)
t[0]=t[0]+os.sep
tools_path = os.path.join(*(t[0:len(t)-2]))

if( tools_path not in sys.path ):
  sys.path.append(tools_path)
  
from tools import hfkt_file_path as hpf

