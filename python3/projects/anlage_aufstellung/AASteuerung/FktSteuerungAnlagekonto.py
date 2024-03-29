import sys

tools_path = "D:\\tools\\tools_tb\\python3"

if( tools_path not in sys.path ):
  sys.path.append(tools_path)

# Hilfsfunktionen
from tools import hfkt as h
from tools import hfkt_def as hdef
from tools import hfkt_log as hlog
from tools import hfkt_status as status
from tools import sguicommand
from tools import hfkt_commands as hcommand

from .FktSteuerungAnlagekontoBearbeiten import fkt_steu_anlage_konto_bearbeit


#------------------------------------------------------------
# Anlagekonto bearbeiten
#------------------------------------------------------------
def fkt_steu_anlage_konto(obj):

  INDEX_ABFRAGE_NEU       = 0
  INDEX_ABFRAGE_BEARB     = 1
  INDEX_ABFRAGE_LOESCHEN  = 2
  INDEX_ABFRAGE_BACK      = 3

  # Auswahl buttons
  #----------------------------------------------------------
  abfrage_liste = [u"neu",u"bearbeiten",u"löschen",u"zurück"]

  # Abfrage der  Anlagekonten db
  #----------------------------------------------------------
  (primkey_liste,liste_anlagekonto) = obj.db.getAnlagekontenListe()

  # Erstellen der Auswahlliste primkey + Kontname
  #----------------------------------------------------------
  auswahlliste   = []
  for p, a in zip(primkey_liste,liste_anlagekonto):
    auswahlliste.append("("+str(p)+")"+a)
  #endfor

  # Hinweis einfügen wenn Liste leer
  #----------------------------------------------------------
  if( len(auswahlliste) == 0 ):
    auswahlliste = ["noch keine Anlagekonto eingegeben"]
  #endif

  #-----------------------------------------------------------
  # Schleife für Abfrage
  #-----------------------------------------------------------
  condition = True
  while condition:

    #------------------------------------------------------------
    # Abfrage auswahlliste
    #------------------------------------------------------------
    (index,index_abfrage)  = sguicommand.abfrage_liste_index_abfrage_index(auswahlliste,abfrage_liste,obj.commands,"Anlagekonto")

    #------------------------------------------------------------
    # Abfrage Zurück
    #------------------------------------------------------------
    if( index_abfrage == INDEX_ABFRAGE_BACK ):

      condition = False

    #------------------------------------------------------------
    # Abfrage neues Konto
    #------------------------------------------------------------
    elif( index_abfrage == INDEX_ABFRAGE_NEU ):

      # neues Konto anlegen
      #------------------------------------------------------------
      fkt_steu_anlage_konto_bearbeit(obj.db,obj.commands,obj.stat,"")

      if( obj.stat.is_NOT_OKAY() ):
        t = obj.stat.getErrText()
        obj.log.write_err(t,screen=0)
        sguicommand.anzeige_error(texteingabe=t,commands=obj.commands,title="Error Kontostand bearbeiten")
      else:
        condition = False
      #endif


    #------------------------------------------------------------
    # Abfrage konto bearbeiten
    #------------------------------------------------------------
    elif( index_abfrage == INDEX_ABFRAGE_BEARB ):

      # Check index, ob Konto ausgewählt
      #------------------------------------------------------------
      if( index < 0 ):
        t = "kein Anlagekonto zum Bearbeiten ausgewählt"
        obj.log.write_err(t,screen=0)
        sguicommand.anzeige_error(texteingabe=t,commands=obj.commands,title="Error Anlagenkonto")
      # Konto bearbeiten
      #------------------------------------------------------------
      else:

        fkt_steu_anlage_konto_bearbeit(obj.db,obj.commands,obj.stat,liste_anlagekonto[index]) # db : Database.db,commands : hcommand.commands, stat : status.status,anlagekontoname : str
        condition = False
        if( obj.stat.is_NOT_OKAY() ):
          t = obj.stat.getErrText()
          obj.log.write_err(t,screen=0)
          sguicommand.anzeige_error(texteingabe=t,commands=obj.commands,title="Error Anlagenkonto")
        #endif
      #endif

    #------------------------------------------------------------
    # Abfrage Konto löschen
    #------------------------------------------------------------
    elif( index_abfrage == INDEX_ABFRAGE_LOESCHEN):

      # Check index, ob Konto ausgewählt
      #------------------------------------------------------------
      if( (index < 0) or (len(liste_anlagekonto)==0) or (index >= len(liste_anlagekonto))):

        t = "kein Anlagekonto zum Löschen ausgewählt"
        obj.log.write_err(t,screen=0)
        sguicommand.anzeige_error(texteingabe=t,commands=obj.commands,title="Error Anlagenkonto")

      # Konto aus db löschen
      #------------------------------------------------------------
      else:

        Anlagenkontoname = liste_anlagekonto[index]
        sguicommand

        obj.db.loescheAnlagenkonto(Anlagenkontoname)
        obj.stat.setStatus(obj.db.stat)

        if( obj.stat.is_NOT_OKAY() ):
          t = f"run_Anlagekonto:  Konto {Anlagenkontoname} konnte nicht gelöscht werden" + "\n" + obj.stat.getErrText()
          obj.log.write_err(t,screen=0)
          sguicommand.anzeige_error(texteingabe=t,commands=obj.commands,title="Error Analgenkontoname")
        else:
          condition = False
        #endif

      #endif
    #endif
  #endwhile
#enddef
