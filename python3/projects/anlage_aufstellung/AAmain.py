import os, sys

tools_path = os.getcwd() + "\\.."
if( tools_path not in sys.path ):
    sys.path.append(tools_path)

# Hilfsfunktionen
from hfkt import hfkt_def as hdef
from hfkt import hfkt_log as hlog
from hfkt import hfkt_commands as hcommand
from hfkt import hfkt_status as hstatus

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
    self.log = hlog.log(self.par.logfilename)

    if( self.log.state != hdef.OK):
      print("Logfile not working !!!!")
      exit()
    else:
      self.log.write_e('Parameter: from ini-File %s' % INIFILENAME)
      self.log.write_e(self.par.logtext)
    #endif


    # Start Database
    # ==========================
    self.db = AADatabase.db(self.log,self.par.dbdatafilename,backup_flag=self.par.backup_flag, backup_dir=self.par.backup_dir)

    if( self.db.status != hdef.OK):
      self.log.write_e("see Logfile database not working !!!!",1)
      exit()
    #endif

    # Start DataCalculation
    # self.dbcalc = AADataCalc.AADataCalc(self.log,self.db,self.par)

    # Start Steuerung
    #================
    self.commands = hcommand.commands(log=self.log,command_file=steuerfile)

    # print(dir(Steuerung.steu))

    self.steu = AASteuerung.steuerung(self.log,self.db,self.commands,self.stat)

  #enddef
  def run(self):

    # Start Sequence
    #=============================
    self.steu.runStart()

  #enddef
  def close(self):

    self.db.__del__()

    print(f"Close logfile: {self.par.logfilename}")
    self.log.close()

  #enddef
  def __del__(self):

    self.db.__del__()

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
