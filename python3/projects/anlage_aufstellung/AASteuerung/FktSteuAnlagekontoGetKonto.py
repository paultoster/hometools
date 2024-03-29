import sys

# Hilfsfunktionen
from tools import sguicommand

#------------------------------------------------------------
# Anlage bearbeiten
#------------------------------------------------------------
def fkt_steu_anlage_konto_get_konto(obj):

  anlagenkontoname = ""
  primekey         = ""
  okay             = 1
  # Auswahl buttons
  #----------------------------------------------------------
  #                    0           1
  abfrage_liste = [u"auswahl",u"zurück"]

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
    t = "kein Anlagekonto erstellt gehe zu Anlagenkonto bearbeiten"
    obj.log.write_err(t,screen=0)
    sguicommand.anzeige_error(texteingabe=t,commands=obj.commands,title="Error Anlagenkonto")
    okay = 0
    return (anlagenkontoname,primekey,okay)
  #endif

  #-----------------------------------------------------------
  # Schleife für Abfrage
  #-----------------------------------------------------------
  condition = True
  while condition:

    #------------------------------------------------------------
    # Abfrage auswahlliste
    #------------------------------------------------------------
    (index,index_abfrage)  = sguicommand.abfrage_liste_index_abfrage_index(auswahlliste,abfrage_liste,obj.commands,"Anlagekonto auswählen")


    #------------------------------------------------------------
    # Abfrage Kontoname
    #------------------------------------------------------------
    if( index_abfrage == 0 ):

      condition = False
      anlagenkontoname = liste_anlagekonto[index]
      primekey         = primkey_liste[index]
      return (anlagenkontoname,primekey,okay)
    #------------------------------------------------------------
    # Abfrage Zurück
    #------------------------------------------------------------
    elif( index_abfrage == 0 ):
      okay = 0
      return (anlagenkontoname,primekey,okay)
    # endif
  #endwhile

#enddef
