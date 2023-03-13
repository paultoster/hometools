
#
# import hlpfu_data hd
#
#---------------------------------------------------
# flag = hd.dict_has_key(d,key) 
# flag = hd.dict_has_key(d,key,type) 
# flag = hd.dict_has_key(d,key,type,hasval) 
#
# Prüfe den key in dictionary, + type: ist der wert der type, + hasval: hat einen Wert
#
# Input:
# d       dict    zu untersuchendes dict
# key             gesuchter key
# type    str     'no'    keine Prüfung
#                 'str'   ist der Value eine string
#                 'list'  ist der Value eine liste
#                 'float' ist der Value eine float
#                 'int'   ist der Value eine integer
#                 'bool'  ist der Value eine bool
# hasval  int     0/1 Prüfen, ob ein Wert gesetzt ist
#
# return True/False bool
#----------------------------------------------------

#-------------------------------------------------------
def dict_has_key(d:dict,key,type:str='no',hasval=0) -> bool:    

  if( not isinstance(d,dict) ):
    return False
  #endif
    
  if( not key in d.keys() ):
    return False
  #endif

  if( type != "no" ):

    if( type == 'str'):
      if( not isinstance(d[key],str)):
        return False
      #endif
    #endif
    if( type == 'list'):
      if( not isinstance(d[key],list)):
        return False
      #endif
    #endif
    if( type == 'float'):
      if( not isinstance(d[key],float)):
        return False
      #endif
    #endif
    if( type == 'int'):
      if( not isinstance(d[key],int)):
        return False
      #endif
    #endif
    if( type == 'bool'):
      if( not isinstance(d[key],bool)):
        return False
      #endif
    #endif

    if(  hasval != 0 ):
      if( isinstance(d[key],str) or isinstance(d[key],list) or isinstance(d[key],dict) ):
        if(len(d[key]) == 0):
          return False
        #endif
      #endif
    #endif
    return True
  #endif