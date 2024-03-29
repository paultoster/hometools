import sys

# Hilfsfunktionen
from tools import hfkt as h
from tools import hfkt_def as hdef
from tools import hfkt_log as hlog
from tools import sguicommand

from .FktSteuerungAnlage import fkt_steu_anlage
from .FktSteuerungAnlagekontoUmsatzCSV import fkt_steu_anlage_konto_umsatz_csv


class steuerung:
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  status     = hdef.OK
  OKAY       = hdef.OK
  NOT_OKAY   = hdef.NOT_OK
  DEBUG_FLAG = False
  #-------------------------------------------------------------------------------
  #-------------------------------------------------------------------------------
  def __init__(self,log,db,commands,stat,par):

    self.stat     = stat
    self.log      = log
    self.db       = db
    self.commands = commands
    self.par      = par

    self.log.write_e(text="AASteuerung Init done",screen=0)
  #enddef

  #-----------------------------------------------------------------------------
  # handle first level of Gui
  #-----------------------------------------------------------------------------
  def runStart(self):



    while(True ):

      #------------------------------------------------------------
      # Abfrage LIST0
      #------------------------------------------------------------
      index  = sguicommand.abfrage_liste_index(["Anlagekonto","Anlage","Ende"],self.commands)

      #------------------------------------------------------------
      # Anlagekonto
      #------------------------------------------------------------
      if( index == 0 ):

        self.runAnlagenkonto()

        if( self.stat.is_NOT_OKAY() ):

          self.stat.setErrTextFront("Error hfkt_db_handle:")

        #endif

      #------------------------------------------------------------
      # Anlage bearbeiten
      #------------------------------------------------------------
      elif( index == 1 ):

        fkt_steu_anlage(self)

      #------------------------------------------------------------
      # Ende der Steuerung
      #------------------------------------------------------------
      else:

        print("Ende Steuerung")
        return

  #enddef
  #-----------------------------------------------------------------------------
  # Bearbeitung Anlagenkonto
  #-----------------------------------------------------------------------------
  def runAnlagenkonto(self):


    while(True ):

      #------------------------------------------------------------
      # Abfrage LIST0
      #------------------------------------------------------------
      index  = sguicommand.abfrage_liste_index(["Umsatz csv einlesen","Ende"],self.commands)

      #------------------------------------------------------------
      # umsatz csv abfrage
      #------------------------------------------------------------
      if( index == 0 ):

        fkt_steu_anlage_konto_umsatz_csv(self)

        if( self.stat.is_NOT_OKAY() ):
          self.stat.setErrTextFront("Error fkt_steu_anlage_konto_umsatz_csv:")
          t = self.stat.getErrText()
          self.log.write_err(t,screen=0)
          sguicommand.anzeige_error(texteingabe=t,commands=self.commands,title="Error Kontostand bearbeiten")
        #endif
     #------------------------------------------------------------
      # Ende der Steuerung
      #------------------------------------------------------------
      else:

        return
      #endif
    #endwhile
  #enddef
#endclass




