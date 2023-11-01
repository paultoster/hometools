"""
# Kommentar
# Grafikbefehle als Beispiele

Base( X0=0.0,Y0=0.0,Dir0=0.0,PointsPerUnit=100,PointWidth=1000,PointHeight=800)
Coordsys(Name=coord1,X0=2.0,Y0=2.0,Dir0=90)
Point( Name=P1, X0=10.0, Y0=0.0)
Line(Name=L1,POName=P1,P1Name=P2)
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

import hfkt_str as hs


def build_and_proof_input(input_liste: List[str]) -> (bool, str,List[c.CBasic]):

  flag_okay = True
  errtext   = ""
  command_list = []

   # eleminiere Komentare und leere Zeilen und füge mehrzeilge kommandos zusammen
  (okay,errtext,liste) = prepare_input(input_liste)

  if( not okay ):
    return (okay,errtext,liste)
  #endif


  item = c.CCoordSys("test")
  b = [item]

  return (flag_okay,errtext,command_list)


def prepare_input(input_liste: List[str]) -> (bool, str,List[str]):

  okay = True
  errtext = ""
  liste = []

  # reduce Kommentar und Leerzeile und hänge mehrzeilige Befehle zusammen (concat_line)
  concat_line = ""
  count = 0
  for i,line in enumerate(input_liste):

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

        elif( type < 0 ):

          concat_line = concat_line + line
          count = count + type

          if( count != 0 ):
            errtext = f"in Linie {i} sind Funktions-Quots {d.QUOT0_FUNCTION} falsch line: {concat_line}"
            okay = False
            return (okay,errtext,liste)
          else:
            liste.append(concat_line)
          #endif
        #endif
      else:

        if( type > 0 ):

          concat_line = line
          count = type
        elif( type < 0 ):
          errtext = f"in Linie {i} sind Funktions-Quots {d.QUOT0_FUNCTION} falsch line: {line}"
          okay = False
          return (okay,errtext,liste)
        else:

          liste.append(line)
        #endif
      #endif
    #endif
  #endfor
  return (okay,errtext,liste)