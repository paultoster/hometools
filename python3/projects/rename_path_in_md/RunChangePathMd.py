#-------------------------------------------------------------------------------
# Name:        RunChangePathMd
# Purpose:     change in md - files path of embedded image files
#
# Author:      lino
#
# Created:     18.06.2023
# Copyright:   (c) lino 2023
# Licence:     <your licence>
#-------------------------------------------------------------------------------
import sys, os

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)

from tools import hfkt_io as hio
from tools import hfkt_file_path as hfp
from tools import hfkt_str as hstr

EXT_LISTE = ["png","jpg","jpeg"]

def change_path_in_md(src_path):


  file_liste = hfp.get_liste_of_subdir_files(src_path,liste=[],search_ext=["md"])

  for file in file_liste:

    (okay,txt) = hio.read_ascii(file_name=file)

    if( hstr.such(txt,"png") > -1):
      print(txt)
    #ednif

    if( okay ):

      txt = chnage_first(txt)
      (txt,flag) = chnage_second(txt)


      if( flag ):
        okay = hio.write_ascii(file_name=file,data=txt)

        print(f"Changed: {file}")
      #endif
    #endif

  #endfor
def chnage_first(txt):

  index_tuple_list = hstr.get_index_quoted(txt,"![[","]]")

  flag = False
  if( len(index_tuple_list) > 0 ):

    flag = True
    if( len(index_tuple_list) > 1 ):
      index_tuple_list.reverse()

  if( flag ) :
    for item in index_tuple_list:

        t = txt[item[0]:item[1]]
        i1 = item[1]+2
        i0 = item[0]-2
        if( i0 < 0 ): i0 = 0

        txt = txt[:i0]+"[]("+t+")"+txt[i1:]
    #endfor
  #endif

  return txt

def chnage_second(txt):

  index_tuple_list = hstr.get_index_quoted(txt,"(",")")

  liste =  []

  for tup in index_tuple_list:

      t = txt[tup[0]:tup[1]]

      (path,fbody,ext) = hfp.get_pfe(t)
      newfilename      = hfp.set_pfe("../_bilder/",fbody,ext)
      newfilename      = hstr.change_max(newfilename,"\\","/")

      for extsuch in EXT_LISTE:
          index = hstr.such(ext,extsuch)

          if( index > -1):

              liste.append([tup[0],tup[1],newfilename])
              break
          #endif
      #endfor
  #endfor

  flag = False
  if( len(liste) > 0 ):
      flag = True
      if( len(liste) > 1):
        liste.reverse()
      #endif
  #endif
  for item in liste:

      txt = txt[:item[0]]+item[2]+txt[item[1]:]
  #endfor
  return (txt,flag)

if __name__ == '__main__':
    src_path = "K:/data/md/Tagebuch"
    change_path_in_md(src_path)

    print("End----------------------------------------")
