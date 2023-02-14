import hlpfu_date as hd
import hlpfu_str as hs
import sys
#==================================================
def wand_anlagen_config_to_intern(anlagen_name : str, d : dict ) -> dict:
  # Wandelt alle Daten umd
  # keyword startet mit "wert_..." wandelt in Cent (int)
  # keyword startet mit "datum_..." wandelt in epochenzeit
  # ------------------------------------------------------
  keywords = d.keys()
  dout = {}
  for keyw in keywords:
    flag = True
    #----------------------------------------
    # wert
    # ---------------------------------------
    if( flag ):        
      i0 = hs.str_such(keyw,"wert_",regel="vs")    

      if( i0 == 0 ):
        try:
          a = float(d[keyw])
          dout[keyw] = int(a*100.+0.5)
          flag = False
        except:
          sys.exit(f"{anlagen_name}[{keyw}] = {d[keyw]} kann nicht in Cent gewandelt werden") 
      #endif
    #endif
    #----------------------------------------
    # datum
    # ---------------------------------------
    if( flag ):        
      i0 = hs.str_such(keyw,"datum_",regel="vs")    

      if( i0 == 0 ):
        try:
          dout[keyw] = hd.secs_time_epoch_from_str(d[keyw])
          flag = False
        except:
          sys.exit(f"{anlagen_name}[{keyw}] = {d[keyw]} kann nicht als Datum gewandelt werden") 
      #endif
    #endif
    if(flag):
      dout[keyw]=d[keyw]
    #endif
  #endfor
  return dout
#enddef
#==================================================
def wand_anlagen_config_to_extern(anlagen_name : str, d : dict ):
  # Wandelt alle internen Daten um
  # keyword startet mit "wert_..." wandelt von Cent (int) in € (float)
  # keyword startet mit "datum_..." wandelt von epochenzeit in str
  # ------------------------------------------------------
  keywords = d.keys()
  dout = {}
  for keyw in keywords:
    flag = True
    #----------------------------------------
    # wert
    # ---------------------------------------
    if( flag ):        
      i0 = hs.str_such(keyw,"wert_",regel="vs")    

      if( i0 == 0 ):
        try:
          dout[keyw] = float(d[keyw])/100.
          flag = False
        except:
          sys.exit(f"{anlagen_name}[{keyw}] = {d[keyw]} kann nicht von Cent in Euro gewandelt werden") 
      #endif
    #endif
    #----------------------------------------
    # datum
    # ---------------------------------------
    if( flag ):        
      i0 = hs.str_such(keyw,"datum_",regel="vs")    

      if( i0 == 0 ):
        try:
          dout[keyw] = hd.str_from_secs_time_epoch(d[keyw])
          flag = False
        except:
          sys.exit(f"{anlagen_name}[{keyw}] = {d[keyw]} kann nicht als Datum gewandelt werden") 
      #endif
    #endif
    if(flag):
      dout[keyw]=d[keyw]
    #endif
  #endfor
  return dout
#enddef
