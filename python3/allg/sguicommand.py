#
# run sgui with command handling
#
#
# index-liste
#------------------------------------------------------------------------------------------------------
# index = sguicommand.abfrage_liste_index(liste,commands=None)
#
# listeAnzeige = ["Materialname","Materialmesseinheit","Materialabrechnungseinheit"]
#
# commands = hfkt_steuerbefehle.steuerbefehle(steuer_file=steuerfile)
#
# index = sguicommand.abfrage_liste_index(listeAnzeige,commands)
#
# if commands has a command, value will be taken, no gui runs
#
#  index = -1       Cancel
#  index = 0 ... 2  Index Liste
#
#
# index-liste mit verschiedenen Abfrage-Buttons
#------------------------------------------------------------------------------------------------------
# (index,indexAbfrage) = sguicommand.abfrage_liste_index_abfrage_index(auswahlliste,abfrage_liste,commands=None,title=None):
#
#
# n_eingabezeilen
#------------------------------------------------------------------------------------------------------
# output_liste = sguicommand.abfrage_n_eingabezeilen(liste,vorgabe_liste=vorgabe_liste,commands=None,title=title)
#
#   Gui Abfrage verschiedener Eingaben
#   z.B.
#   listeAnzeige = ["Materialname","Materialmesseinheit","Materialabrechnungseinheit"]
#   listeErgebnis = sgui.abfrage_n_eingabezeilen(liste=listeAnzeige,commands=self.commands)
#
# #   oder mit Vorgabewert
#
#   listeAnzeige = ["Materialname","Materialmesseinheit","Materialabrechnungseinheit"]
#   listeWerte   = ["Kaffee","kg","Tassen"]
#   title        = "MAterialauswahl"
#   listeErgebnis = sgui.abfrage_n_eingabezeilen(liste=listeAnzeige, vorgabe_liste=listeWerte,commands=self.commands,title=title)



import sys

tools_path = "D:\\tools_tb\\python" 

if( tools_path not in sys.path ):
    sys.path.append(tools_path)

import sgui
import hfkt as h

EMPTY_COMMAND = "empty"
SEPERATOR_ASSIGN_COMMAND = "="

ERROR_TEXT = ""

def abfrage_liste_index(liste,commands=None,title=None):

  index = None
  auswahl = None

  if( commands ):

    if( commands.has_command() ):
      
      auswahl = commands.get_next_command()

      if(auswahl == EMPTY_COMMAND ):

        index = -1

      else:
        for i, j in enumerate(liste):
          if j == auswahl:
            index = i
            break
          #endif
        #endfor
      #endif
      
      if( not index ):
        ERROR_TEXT = f"command: <{auswahl}> could be found in list <{list}>\nswitch to gui"
        print(ERROR_TEXT)
        commands.reset_command()
      #endif

    #endif
  #endif

  # gui
  if(not index):

    index  = sgui.abfrage_liste_index(liste=liste,title=title)
    
    if( index > -1 ):
      auswahl = liste[index]
    else:
      auswahl = EMPTY_COMMAND
      
    #endif
  #endif

  # save command 
  if( auswahl and commands):
    commands.set_last_command([auswahl])
  
  return index
#enddef

def abfrage_liste_index_abfrage_index(auswahlliste,abfrage_liste,commands=None,title=None):
 
  index = None
  indexAbfrage = None
  auswahl = None
  abfrage = None

  if( commands ):

    if( commands.has_command() ):
      
      items = commands.get_next_command()

      if( len(items) >= 2 ):

        auswahl = items[0]
        abfrage = items[1]

        if(auswahl == EMPTY_COMMAND ):

          index = -1

        else:

          for i, j in enumerate(auswahlliste):
            if j == auswahl:
              index = i
              break
            #endif
          #endfor
        #endif

        if(abfrage == EMPTY_COMMAND ):

          indexAbfrage = -1

        else:
          for i, j in enumerate(abfrage_liste):
            if j == abfrage:
              indexAbfrage = i
              break
            #endif
          #endfor
        #endif

        if( not index ):

          ERROR_TEXT = f"command auswahl: <{auswahl}> could not be found in list <{auswahlliste}>\nswitch to gui"
          print(ERROR_TEXT)
          commands.reset_command()
        #endif
        if( not indexAbfrage ):

          ERROR_TEXT = f"command abfrage: <{abfrage}> could not be found in list <{abfrage_liste}>\nswitch to gui"
          print(ERROR_TEXT)
          commands.reset_command()
        #endif
    #endif
  #endif

  # gui
  if(not index or not indexAbfrage):

    (index,indexAbfrage) = sgui.abfrage_liste_index_abfrage_index(auswahlliste,abfrage_liste,title=title)
    
    if( index > -1 ):
      auswahl = auswahlliste[index]
    else:
      auswahl = EMPTY_COMMAND
    #endif
    if( indexAbfrage > -1 ):
      abfrage = abfrage_liste[index]
    else:
      abfrage = EMPTY_COMMAND
    #endif
  #endif

    # save command 
  if( auswahl and abfrage and commands):
    commands.set_last_command([auswahl,abfrage])
  #endif

  return (index,indexAbfrage)
#enddef
def  abfrage_n_eingabezeilen(liste,vorgabe_liste=None,commands=None,title=None):

  output_liste = []
  gui_abfrage  = True
  nliste       = len(liste)
  if( commands ):

    gui_abfrage = False

    if( commands.has_command() ):
      
      items = commands.get_next_command()

      if( len(items) != nliste ):

        ERROR_TEXT = f"command abfrage: liste von commands len={len(items)} ist ungleich liste von Input len={nliste}>\nswitch to gui"
        print(ERROR_TEXT)
        commands.reset_command()
        gui_abfrage  = True
      else:

        output_liste = ["" for i in range(nliste)]

        for item in items:

          ll = item.split(SEPERATOR_ASSIGN_COMMAND)
          if( len(ll) < 2 ):
            ERROR_TEXT = f"command abfrage: das item von commands {item} kann nicht mit {SEPERATOR_ASSIGN_COMMAND} getrennt werden\nswitch to gui"
            print(ERROR_TEXT)
            commands.reset_command()
            gui_abfrage  = True
            break
          else:
            var = [0]
            val = [1]

            if( var in liste):
              index = liste.index(var)

              output_liste[index] = val
            else:
              ERROR_TEXT = f"command abfrage: das item von commands {item} hat Variable {var} kann aber nicht in liste {liste} gefunden werden\nswitch to gui"
              print(ERROR_TEXT)
              commands.reset_command()
              gui_abfrage  = True
              break
            #endif
          #endif
        #endfor
      #endif
    else:
      gui_abfrage = True
    #endif
  #endif

  # gui
  if(gui_abfrage):

    output_liste = sgui.abfrage_n_eingabezeilen(liste,vorgabe_liste=vorgabe_liste,title=title)
    
  #endif

  # save command 
  if( (len(output_liste) == nliste) and  commands):
    commandliste = []
    for var, val in zip(liste,output_liste):
      commandliste.append(var+SEPERATOR_ASSIGN_COMMAND+val)
    commands.set_last_command(commandliste)
  #endif

  return output_liste
#enddef
def anzeige_error(texteingabe="error occured",commands=None,title=None):
  # (texteingabe,title=None,textcolor='black')

  makeAbfrage = True

  if( commands ):

    print(f"Error occured: \nswitch to gui")
    commands.reset_command()
    
  #endif

  if( makeAbfrage ):

    title = "Error"

    sgui.anzeige_text(texteingabe,title=title,textcolor='red')

#enddef
def anzeige_info(texteingabe="info",title=None):
  # (texteingabe,title=None,textcolor='black')

  title = "Info"

  sgui.anzeige_text(texteingabe,title=title,textcolor='black')

#enddef
