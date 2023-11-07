#-------------------------------------------------------------------------------
# Name:        module1
# Purpose:
#
# Author:      lino
#
# Created:     04.11.2023
# Copyright:   (c) lino 2023
# Licence:     <your licence>
#-------------------------------------------------------------------------------
from dataclasses import dataclass
from typing import List

import small_vector_graphic_classes as c
import small_vector_graphic_defines as d

from hfkt import hfkt_str as hs

def prepare_input_lines(input_liste: List[str]) -> (bool, str,c.CCommandStrData):

  okay    = True
  errtext = ""
  csd     = c.CCommandStrData()

  # reduce Kommentar und Leerzeile und hänge mehrzeilige Befehle zusammen (concat_line)
  concat_line = ""
  concat_line_number = ""
  count = 0
  for i,line in enumerate(input_liste):

    iline = i + 1

    # elim Kommentar
    line = hs.elim_comment_not_quoted(line,[d.KOMMENTAR_ZEICHEN],d.QUOT0_FUNCTION,d.QUOT1_FUNCTION)

    # elim Leerzeichen
    line = hs.elim_ae_liste(line, [" ","\t"])

    # bearbeite wenn nicht leer
    if( len(line) > 0 ):

      # Anzahl quots, type=0 qouts passen > 0 quot nicht geschlossen, < 0 quot nicht geöffnet
      (num,type) = hs.has_quots(line,d.QUOT0_FUNCTION,d.QUOT1_FUNCTION)

      if( count > 0):

        if( type == 0 ):

          concat_line = concat_line + line
          concat_line_number = concat_line_number + "/" + str(iline)

        elif( type < 0 ):

          concat_line = concat_line + line
          concat_line_number = concat_line_number + "/" + str(iline)
          count = count + type

          if( count != 0 ):
            errtext = f"in Linie {i} sind Funktions-Quots {d.QUOT0_FUNCTION} falsch line: {concat_line}"
            okay = False
            return (okay,errtext,csd)
          else:
            csd.add(command_str=concat_line,linenum_str=concat_line_number)
          #endif
        #endif
      else:

        if( type > 0 ):

          concat_line = line
          concat_line_number = str(iline)
          count = type
        elif( type < 0 ):
          errtext = f"in Linie {i} sind Funktions-Quots {d.QUOT0_FUNCTION} falsch line: {line}"
          okay = False
          return (okay,errtext,csd)
        else:

          csd.add(command_str=line,linenum_str=str(iline))
        #endif
      #endif
    #endif
  #endfor
  return (okay,errtext,csd)

def get_keys_from_line_input(line: str,din: dict) -> (bool,str,dict):
  okay = True
  errtext = ""
  dout = din

  tt = hs.get_string_quoted(line,d.QUOT0_FUNCTION,d.QUOT1_FUNCTION)
  if( len(tt)>0 ):

    ll = hs.split_text(tt[0],d.SEPERATOR_FUNCTION)

    for item in ll:

      lll = hs.split_text(item,d.ASSIGN_FUNCTION)

      if( len(lll)>1 ):

        tkey = hs.elim_ae_liste(lll[0], [" ","\t"])
        tval = hs.elim_ae_liste(lll[1], [" ","\t"])

        dout.update({tkey: tval})

      #endif
    #endfor
  #endif

  return (okay,errtext,dout)

def get_value_from_input_float(dfuncdef: dict,keyname: str, set_default: bool,default_val=float(0.0),line_str="") -> (bool,str,float):
  """
    (okay,errtext,UnitWidth) = h.get_value_from_input_float(dfuncdef,'UnitWidth',True,10.0)
  """
  okay = True
  errtext = ""
  fval = float(0.0)

  if keyname in dfuncdef.keys():
    try:
      fval = float(dfuncdef[keyname])
    except ValueError as e:
      okay = False
      errtext = f"keyname: {keyname} (line {line_str}) has err: {e}"
      return (okay,errtext,fval)
    #endtry
  elif(set_default):
    # predefinition
    fval = default_val
  else:
    okay = False
    errtext = f"keyname: {keyname} (line {line_str}) was not found"
    return (okay,errtext,fval)
  #end

  return (okay,errtext,fval)

def get_value_from_input_int(dfuncdef: dict,keyname: str, set_default: bool,default_val=int(0),line_str="") -> (bool,str,int):
  """
    (okay,errtext,PointWidth) = h.get_value_from_input_int(dfuncdef,'PointWidth',True,100)
  """
  okay = True
  errtext = ""
  ival = int(0)

  if keyname in dfuncdef.keys():
    try:
      ival = int(dfuncdef[keyname])
    except ValueError as e:
      okay = False
      errtext = f"keyname: {keyname} (line {line_str}) has err: {e}"
      return (okay,errtext,ival)
    #endtry
  elif(set_default):
    # predefinition
    ival = default_val
  else:
    okay = False
    errtext = f"keyname: {keyname} (line {line_str}) was not found"
    return (okay,errtext,ival)
  #end

  return (okay,errtext,ival)

def get_value_from_input_str(dfuncdef: dict,keyname: str, set_default: bool,default_val="",line_str="") -> (bool,str,str):
  """
    (okay,errtext,Name) = h.get_value_from_input_int(dfuncdef,'Name',True,100)
  """
  okay = True
  errtext = ""
  sval = ""

  if keyname in dfuncdef.keys():
    try:
      sval = dfuncdef[keyname]
    except ValueError as e:
      okay = False
      errtext = f"keyname: {keyname} (line {line_str}) has err: {e}"
      return (okay,errtext,sval)
    #endtry
  elif(set_default):
    # predefinition
    sval = default_val
  else:
    okay = False
    errtext = f"keyname: {keyname} (line {line_str}) was not found"
    return (okay,errtext,sval)
  #end

  return (okay,errtext,sval)
#enddef
def proof_name_in_command_liste(DefName: str,command_liste: List[c.CBasic]) -> (bool,str):

  okay = True;
  errtext = ""

  for obj in command_liste:

    if( obj.Name == DefName ):
      okay = False
      errtext = f"Name: {DefName} is already define in Line: {obj.LineNum} "
      return (okay,errtext)
    #endif
  #endfor

  return (okay,errtext)
#enddef



def find_name_in_command_liste(TypeName: str,SearchName: str,linenum: str,command_liste: List[c.CBasic]) -> (bool,str):

  okay = True;
  errtext = ""

  for obj in command_liste:

    if( TypeName == obj.TypeName):
      if( obj.Name == SearchName ):
        return (okay,errtext)
      #endif
    #endif
  #endfor

  okay = False
  errtext = f"Type: {TypeName}: SearchName: {SearchName} was not found before line {linenum}"

  return (okay,errtext)
#enddef

def get_index_of_name_in_command_liste(TypeName: str,SearchName: str,linenum: str,command_liste: List[c.CBasic]) -> (bool,str,int):

  okay = True;
  errtext = ""
  index   = -1
  for index,obj in enumerate(command_liste):

    if( TypeName == obj.TypeName):

      if( obj.Name == SearchName ):
        return (okay,errtext,index)
      #endif
    #endif
  #endfor

  okay = False
  errtext = f"Type: {TypeName}: SearchName: {SearchName} was not found before line {linenum}"

  return (okay,errtext,index)
#enddef

def get_object_from_command_liste(TypeName: str,SearchName: str,linenum: str,command_liste: List[c.CBasic]) -> (bool,str,c.CBasic):

  okay = True
  errtext = ""

  (okay,errtext,index) = get_index_of_name_in_command_liste(TypeName,SearchName,"",command_liste)

  if( okay ):
    obj = command_liste[index]
  else:
    obj = c.CBasic()
  #endif

  return (okay,errtext,obj)
#enddef

def calculat_screen_width_height(canvas_width: int,canvas_height: int,screen_width: int,screen_height: int) -> (int,int,float):
  """
  calculate screen sizes based on canvas_width and height in same ratio
  """
  if( canvas_width == 0 ): canvas_width = 1
  if( canvas_height == 0 ): canvas_height = 1
  if( screen_width == 0 ): screen_width = 1
  if( screen_height == 0 ): screen_height = 1

  ratio_w = float(canvas_width)/float(screen_width)
  ratio_h = float(canvas_height)/float(screen_height)

  if( ratio_w > ratio_h ):
    ratio_canvas_to_screen = 1./ratio_w

    screen_height = int(float(canvas_height)*ratio_canvas_to_screen)
  else:
    ratio_canvas_to_screen = 1./ratio_h

    screen_width = int(float(canvas_width)*ratio_canvas_to_screen)
  #endif

  return (screen_width,screen_height,ratio_canvas_to_screen)
#enddef

def transform_from_coord_to_base( tuple_list,cobj):
  """
  [(x0,y0),(x1,y1)]
  """
  tuple_list_out = []
  for tup in tuple_list:

    X0 = cobj.CosDir0 * tup[0]  - cobj.SinDir0 * tup[1] + cobj.X0
    Y0 = cobj.SinDir0 * tup[0]  + cobj.CosDir0 * tup[1] + cobj.Y0
    tuple_list_out.append((X0,Y0))

  #endfor

  return tuple_list_out
#enddef



  return tuple_list