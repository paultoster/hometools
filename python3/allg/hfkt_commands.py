import os

class commands:

  log    = None
  is_log = False

  command_file  = ""             # Datei um remote steuerung durch zu führen
  is_steuerung = False      # wird remote gesteuert

  command_log_file = "steuerlog_file.dat"
  is_command_log   = False

  commandlines = []

  


  def __init__(self, log=None, command_file = None, command_log_file = "steuerlog_file.dat" ):

    if( log != None ):
      self.log     = log
      self.is_log  = True
    #endif

    if( command_file ):

      self.command_file = command_file

      if( not os.path.isfile(self.command_file)):

        if( self.log ):
          self.log.write_e(f'Steuerdatei <{self.command_file} wurde ncicht gefunden.>',screen=1)
        #endif
      #endif

      with open(self.command_file) as f:
         self.commandlines = f.readlines()
      #endwith
    
    #endif

    if( command_log_file ):

      self.command_log_file = command_log_file
      self.is_command_log   = True

    #endif

  #enddef

  def has_command(self):
    """
    Indicates if Command available
    """

    if( len(self.commandlines) > 0 ):
      return True
    else:
      return False
    #endif
  #enddef

  def get_next_command(self):
    """
    returns next command line as list
    and removes commanad from stack
    """
    commands = []
    if(len(self.commandlines) > 0 ):

      tt = self.commandlines.pop(0)
      commands = tt.split(' ')
    #endif

    return commands
  #enddef

  def reset_command(self):
    """
    reset command-list because handling error in parant function
    """
    self.commmandlines = []

  def set_last_command(self,commands):
    """
    writes command into File
    """

    if( self.is_command_log and isinstance(commands,list) ):

      ll = len(commands)
      ll -= 1
      line = ""
      for i, val in enumerate(commands):

        line += val
        if( i != ll ):
          line += " "

        with open(self.command_log_file,"a") as f:
          f.write(f'{line}\n')
        #endif
      #endif
    #endif

    