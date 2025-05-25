# -*- coding: cp1252 -*-
# rename path and filenames and content
#
import sys,os,re

tools_path = os.getcwd() + "\\.."
if( tools_path not in sys.path ):
    sys.path.append(tools_path)

from tools import hfkt as h

def find_date(fbody):

  str0 = ""
  fbody_out = fbody

  i0 = h.such(fbody,"dat")

  if( i0 > -1 ):

    n  = len(fbody)
    i1 = min(n,i0+11)

    str1 = fbody[i0+3:i1]
    rest_str = fbody[0:i0]+fbody[i1:]
    try:
      i2 = int(str1)
    except:
      i2 = 0
    #endtry

    if( h.is_datum_str(h.datum_int_to_str(i2)) ):
      str0 = str1
      fbody_out = rest_str
    #endif
  else:

    liste = re.findall(r'\d+', fbody)

    for item in liste:

      try:
        if( h.is_datum_int(int(item)) ):

          i0 = h.such(fbody,item)

          if( i0 > -1 ):
            i1 = i0+len(item)
            str0 = item
            fbody_out = fbody[0:i0]+fbody[i1:]
            break
          #endif
        #endif
      except:
        i0 = 0
      #endtry
    #endfor

  #endif


    #endfor
  #endif

  return (str0,fbody_out)

def change_body_name(fullfile,fbody):

  # suche Datum im filenamen z.B. dat20130905
  (str0,fbody_rest) = find_date(fbody)

  # Wenn gefunden
  if( len(str0) ):

     new_fbody = str0+"_"+fbody_rest

  else:

    # Nehme Enstehungsdatum
    int0 = h.secs_time_epoch_to_int(os.path.getctime(fullfile))

    str0 = str(int0)

    new_fbody = str0+"_"+fbody

  #endif

  return new_fbody
#enddef

if __name__ == '__main__':

  # start_dir_vorschlag=os.getcwd()
  # start_dir_vorschlag="M:/pdata/Bank/ING/2024"
  start_dir_vorschlag="M:/pdata/Bank/Smartbroker/2024"

  start_dir = h.abfrage_dir(comment="In welchem Verzeichnis Datum in Filename bringen",start_dir=start_dir_vorschlag)

  liste = []
  liste = h.get_liste_of_subdir_files(start_dir,liste=liste)

  for fullfile in liste:

    (path,fbody,ext) = h.get_pfe(fullfile)


    # check if first 8 digits are not a date
    try:
      i0 = int(fbody[0:8])
      # a = h.is_datum_str(h.datum_int_to_str(i0))
    except:
      i0 = 0
      # a = h.is_datum_str(h.datum_int_to_str(i0))
    #endtry

    if( not h.is_datum_str(h.datum_int_to_str(i0)) ):

      new_fbody = change_body_name(fullfile,fbody)


      fullfile_new = h.set_pfe(p=path,b=new_fbody,e=ext)

      os.rename(fullfile,fullfile_new)


      print(f"file: {fbody}{'.'}{ext} new: {new_fbody}{'.'}{ext})")
    else:

      print(f"no change file: {fbody}{'.'}{ext} ")
  #endfor
#endif


print("---- Ende ----")



