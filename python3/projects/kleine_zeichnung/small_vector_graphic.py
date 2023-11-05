"""
# Kommentar
# Grafikbefehle als Beispiele

Base( UnitWidth=10.0,UnitHeight=10.0,PointWidth=800,PointHeight=800)

CoordSys(Name=coord1,X0=2.0,Y0=2.0,Dir0=90)

Point( Name=P1, X0=10.0, Y0=0.0)
Line(Name=L1,PO=P1,P1=P2)
#
RectAngleDef(Name=RADef1,XWidth=10,YWidth=10)
TextDef(Name=TDef1,Text=abcdef\nijjk)
#
RectAngle(Name=RA1,RectAbgleName=RADef1,X0=5.0,Y0=20.0,Dir0=0)
Text(Name=T1,TextName=TDef1,X0=5.0,Y0=20.0,Dir0=0)

PlotCoordSys(DefName=coord1,NameX=x,NameY=y,LineWidth=1,ArrowWidth=10,
             ArrowLength=10,LineColor=k)
PlotLine(DefName=L1,LineColor=r,LineWidth=2,LineType=0)
PlotPoint(DefName=L1,NameP=,PointColor=r,PointWidth=2)
PlotRectAngle(DefName=RA1,LineColor=b,LineWidth=2,LineType=0)
PlotText(DefName=T1,TextColor=k)



"""


from dataclasses import dataclass
from typing import List

import small_vector_graphic_classes as c
import small_vector_graphic_defines as d
import small_vector_graphic_Base as base
import small_vector_graphic_CoordSys as coordsys
import small_vector_graphic_Plot as plot
import small_vector_graphic_Geo as geo

import hfkt_str as hs
import hfkt_list as hl




def build_and_proof_input(input_liste: List[str]) -> (bool, str,List[c.CBasic]):


   # eleminiere Komentare und leere Zeilen und füge mehrzeilge kommandos zusammen
  (okay,errtext,csd) = prepare_input_lines(input_liste)

  if( not okay ):
    return (okay,errtext,[])
  #endif

  (okay,errtext,command_liste) = prepare_commands(csd)

  if( not okay ):
    return (okay,errtext,[])
  #endif

  return (okay,errtext,command_liste)


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


def prepare_commands(csd: c.CCommandStrData) -> (bool, str,List[c.CBasic]):

  okay = True
  errtext = ""
  command_liste = []

  #--------------------------------------------------------------------------------------------
  # Base definition
  #--------------------------------------------------------------------------------------------

  (okay,errtext,base_obj,index_liste) = base.build_base_object(csd)

  if( not okay ):
    return (okay,errtext,command_liste)
  #endif
  csd.erase(index_liste)

  command_liste = [base_obj]

  #---------------------------------------------------------------------------------------------
  # seperate all Plot Demands
  #-----------------------------------------------------------------------------------------------
  index_liste = plot.find_plot_commands(csd)

  csdplot = csd.move(index_liste)

  #--------------------------------------------------------------------------------------------
  # find coordinate systems, read and devide definition
  #--------------------------------------------------------------------------------------------

  (okay,errtext,list_coordsys_obj,line_index_tuple_liste) = coordsys.build_coordsys_object_list(csd)
  if( not okay ):
    return (okay,errtext,command_liste)
  #endif

  #--------------------------------------------------------------------------------------------
  # loop over list of coordsy and line demands, read geometric function, proof and
  # add to command_liste
  #--------------------------------------------------------------------------------------------

  for i,obj in enumerate(list_coordsys_obj):

    command_liste.append(obj)
    csdgeo = csd.cpy_i0_i1(line_index_tuple_liste[i][0],line_index_tuple_liste[i][1])
    coordsysname = obj.Name

    (okay,errtext,command_liste) = geo.build_geo_objects(csdgeo,command_liste,coordsysname)

    if( not okay ):
      return (okay,errtext,command_liste)

  #endfor

  return (okay,errtext,command_liste)
