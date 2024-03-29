import os, sys

tools_path = os.getcwd() + "\\.."
if( tools_path not in sys.path ):
    sys.path.append(tools_path)

# Hilfsfunktionen
from tools import hfkt_def as hdef
from tools import hfkt_log as hlog
from tools import hfkt_commands as hcommand
from tools import hfkt_status as hstatus

from AAPar import AAPar
import AADatabase
import AASteuerung



INIFILENAME = "inifile.txt"

#===============================================================================
#===============================================================================
class AAMain:
  #-------------------------------------------------------------------------------
  #-------------------------------------------------------------------------------
  def __init__(self,steuerfile = None):

    # Status
    #========
    self.stat = hstatus.status()

    # Parameter from ini-File
    #========================
    self.par = AAPar.AAPar()

    self.par.read_ini_file(INIFILENAME)

    if( self.par.status != hdef.OK ):
      print("%-20s: %s" % ("Error",self.par.errtext))
      exit()
    #endif

    # Open Logfile
    # ==========================
    self.log = hlog.log(self.par.allg.logfilename)

    if( self.log.state != hdef.OK):
      print("Logfile not working !!!!")
      exit()
    else:
      self.log.write_e('Parameter: from ini-File %s' % INIFILENAME)
      self.log.write_e(self.log.errtext)
    #endif


    # Start Database
    # ==========================
    self.db = AADatabase.db(self.log,self.par.allg.dbdatafilename,backup_flag=self.par.allg.backup_flag, backup_dir=self.par.allg.backup_dir)

    if( self.db.status != hdef.OK):
      self.log.write_e("see Logfile database not working !!!!",1)
      exit()
    #endif


    self.db.pruefeAnlagenkontoTabelle(self.par)

    if( self.db.status != hdef.OK):
      self.log.write_e("see Logfile database table not working !!!!",1)
      exit()
    #endif

    # Start DataCalculation
    # self.dbcalc = AADataCalc.AADataCalc(self.log,self.db,self.par)

    # Start Steuerung
    #================
    self.commands = hcommand.commands(log=self.log,command_file=steuerfile)

    # print(dir(Steuerung.steu))

    self.steu = AASteuerung.steuerung(self.log,self.db,self.commands,self.stat,self.par)

  #enddef
  def run(self):

    # Start Sequence
    #=============================
    self.steu.runStart()

  #enddef
  def close(self):

    if( hasattr(self, 'db') ):
      self.db.__del__()

    print(f"Close logfile: {self.par.logfilename}")
    self.log.close()

  #enddef
  def __del__(self):

    if( hasattr(self, 'db') ):
      self.db.__del__()

    if( hasattr(self, 'log') ):
      print(f"Close logfile: {self.par.logfilename}")
      self.log.close()
  #enddef
#endclass



if __name__ == '__main__':

  print(sys.argv)

  steurfile = None
  if( len(sys.argv) > 1 ):
    steuerfile = sys.argv[1]



  aa = AAMain()
  aa.run()
  aa.close()
