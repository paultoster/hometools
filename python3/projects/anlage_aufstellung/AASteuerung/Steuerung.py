import sys

# Hilfsfunktionen
from hfkt import hfkt as h
from hfkt import hfkt_def as hdef
from hfkt import hfkt_log as hlog
from hfkt import sguicommand

from .FktSteuerungAnlage import fkt_steu_anlage
from .FktSteuerungAnlagekonto import fkt_steu_anlage_konto
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
  def __init__(self,log,db,commands,stat):

    self.stat     = stat
    self.log      = log
    self.db       = db
    self.commands = commands


    self.log.write_e(text="AASteuerung Init done",screen=0)
  #enddef


  def runStart(self):

    LISTE0 = ["Anlagekonto","Anlage","Ende"]

    while(True ):

      #------------------------------------------------------------
      # Abfrage LIST0
      #------------------------------------------------------------
      index  = sguicommand.abfrage_liste_index(LISTE0,self.commands)

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
  def runAnlagenkonto(self):

    LISTE0 = ["Anlagenkonto bearbeiten","Umsatz csv einlesen","Ende"]

    while(True ):

      #------------------------------------------------------------
      # Abfrage LIST0
      #------------------------------------------------------------
      index  = sguicommand.abfrage_liste_index(LISTE0,self.commands)

     #------------------------------------------------------------
      # bearbeiten
      #------------------------------------------------------------
      if( index == 0 ):

        fkt_steu_anlage_konto(self)

        if( self.stat.is_NOT_OKAY() ):

          self.stat.setErrTextFront("Error fkt_steu_anlage_konto:")

        #endif

      #------------------------------------------------------------
      # umsatz csv abfrage
      #------------------------------------------------------------
      elif( index == 1 ):
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




