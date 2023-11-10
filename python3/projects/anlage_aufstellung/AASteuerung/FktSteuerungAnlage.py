import sys

# Hilfsfunktionen
from hfkt import hfkt as h
from hfkt import hfkt_def as hdef
from hfkt import hfkt_log as hlog
from hfkt import sguicommand

#------------------------------------------------------------
# Anlage bearbeiten
#------------------------------------------------------------
def fkt_steu_anlage(self):


  return self.OKAY
#enddef

  #  def run_Anlagekonto_neu(self):

  #   status = self.OKAY

  #   title = "Neues Konto"
  #   liste = []
  #   liste.append(self.db.CELL_KONTONAME)
  #   liste.append(self.db.CELL_KONTONR)
  #   liste.append(self.db.CELL_KONTOBLZ)
  #   liste.append(self.db.CELL_KONTOIBAN)
  #   liste.append(self.db.CELL_KONTOSTAND+"("+self.db.CURRENCY+")")
  #   liste.append(self.db.CELL_ANFANGSDATUM)
  #   vorgabe_list = None
  #   run_flag = True
  #   while(run_flag ):

  #     # gui neues Konto anlegen
  #     #------------------------------------------------------------
  #     out_liste = sguicommand.abfrage_n_eingabezeilen(liste,vorgabe_liste=vorgabe_list,commands=self.commands,title=title)

  #     # Check ausgabe liste
  #     #------------------------------------------------------------
  #     if( len(out_liste)==0):
  #       t = sguicommand.abfrage_n_eingabezeilen.ERROR_TEXT
  #       self.log.write_err(t,screen=0)
  #       sguicommand.anzeige_error(texteingabe=t,commands=self.commands,title="Error Anlagenkonto")
  #       status = self.NOT_OKAY

  #       run_flag = False
  #     # Kontowerte in db setzen
  #     #------------------------------------------------------------
  #     elif(len(out_liste) == 6):

  #       Kontoname_str         = h.elim_ae(out_liste[0],' ')
  #       Kontonummer_str       = h.elim_ae(out_liste[1],' ')
  #       Kontobankleitzahl_str = h.elim_ae(out_liste[2],' ')
  #       KontoIBAN_str         = h.elim_ae(out_liste[3],' ')
  #       Kontostand_str        = h.elim_ae(out_liste[4],' ')
  #       Anfangsdatum_str      = h.elim_ae(out_liste[5],' ')

  #       run_flag = False

  #       Kontostand_float = h.str_to_float_possible(h.change_max(Kontostand_str,',','.'))
  #       if( Kontostand_float == None ):
  #         t = f"run_Anlagekonto_neu: Kontostand {Kontostand_str} von neuen Konto {Kontoname_str} ist nicht richtig geschrieben"
  #         self.log.write_err(t,screen=0)
  #         sguicommand.anzeige_error(texteingabe=t,commands=self.commands,title="Error Anlagenkonto")
  #         Kontostand_str = ""
  #         run_flag = True
  #       #endif

  #       Anfangsdatum_str = h.datum_str_make_correction(Anfangsdatum_str)

  #       if( h.datum_str_is_correct(Anfangsdatum_str) == False ):
  #         t = f"run_Anlagekonto_neu: Anfangsdatum von neuen Konto {Kontoname_str} ist nicht richtig geschrieben"
  #         self.log.write_err(t,screen=0)
  #         sguicommand.anzeige_error(texteingabe=t,commands=self.commands,title="Error Anlagenkonto")
  #         Anfangsdatum_str = ""
  #         run_flag = True
  #       #endif

  #       if( run_flag ):

  #         vorgabe_list =  [Kontoname_str,Kontonummer_str,Kontobankleitzahl_str,KontoIBAN_str,Kontostand_str,Anfangsdatum_str]

  #       else:
  #         liste_neu =  [Kontoname_str,Kontonummer_str,Kontobankleitzahl_str,KontoIBAN_str,Kontostand_float,Anfangsdatum_str]
  #         okay = self.db.set_anlagenkonten_daten("",liste_neu)

  #         # Fehlerabfrage
  #         #------------------------------------------------------------
  #         if( not okay):
  #           t =f"run_Anlagekonto_neu: Daten von neuen Konto {Kontoname_str} konnten nicht in db gespeichert werden"
  #           self.log.write_err(t,screen=0)
  #           sguicommand.anzeige_error(texteingabe=t,commands=self.commands,title="Error Anlagenkonto")
  #           status = self.NOT_OKAY
  #         #endif
  #       #endif

  #     # Keine Kontowerte gesetzt
  #     #------------------------------------------------------------
  #     else:

  #       t = f"run_Anlagekonto_neu: Daten von neuen Konto sind nicht korrekt"
  #       self.log.write_err(t,screen=0)
  #       sguicommand.anzeige_error(texteingabe=t,commands=self.commands,title="Error Anlagenkonto")
  #       status = self.NOT_OKAY
  #       run_flag = False
  #     #endif
  #   #endWhile

  #   return status
  # #enddef
