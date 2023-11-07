
#-------------------------------------------------------------------------------
t_path, _ = os.path.split(__file__)
if( t_path == os.getcwd() ):

  import hfkt_def as h_def

else:
  p_list     = os.path.normpath(t_path).split(os.sep)
  if( len(p_list) > 1 ): p_list = p_list[ : -1]
  t_path = ""
  for i,item in enumerate(p_list): t_path += item + os.sep
  if( os.path.normpath(t_path) not in sys.path ): sys.path.append(t_path)

  from hfkt import hfkt_def as h_def

#endif--------------------------------------------------------------------------


class status:
  OKAY       = hdef.OK
  NOT_OKAY   = hdef.NOT_OK

  #-------------------------------------------------------------------------------
  #-------------------------------------------------------------------------------
  def __init__(self):
    self.status     = self.OKAY
    self.errtext    = ""
    self.infotext   = ""
    self.errcount   = 0
  #enddef

  def set_NOT_OKAY(self,text="" ):
    self.status = self.NOT_OKAY
    self.errcount += 1
    if( len(text) ):
      self.errtext = f"{self.errtext} \n ({self.errcount}): {text}"
    #endif
  #enddef
  def reset(self):
    self.status     = self.OKAY
    self.errtext    = ""
    self.infotext   = ""
  #enddef
  def set_OKAY(self,text=""):
    self.status = self.OKAY
    if( len(text) ):
      if( len(self.infotext)):
        self.infotext = f"{self.infotext} \n {text}"
      else:
        self.infotext = f"{text}"
      #endif
    #endif
  #enddef
  def is_OKAY(self):
    if( self.status == self.OKAY ):
      return True
    else:
      return False
    #endif
  #enddef
  def is_NOT_OKAY(self):
    if( self.status != self.OKAY ):
      return True
    else:
      return False
    #endif
  #enddef
  def setErrTextFront(self,text):
    if( len(text) ):
      if( len(self.errtext)):
        self.errtext = f"{text} \n {self.errtext}"
      else:
        self.errtext = f"{text}"
  #enddef
  def getErrText(self):
    errtext = self.errtext
    self.errtext = ""
    return errtext
  #enddef
  def hasInfoText(self):
    if( len(self.infotext)):
      return True
    else:
      return False
  def setInfoText(self,text):
    self.infotext
    if( len(text) ):
      if( len(self.infotext)):
        self.infotext = f"{self.infotext} \n {text}"
      else:
        self.infotext = f"{text}"
  #enddef
  def getInfoText(self):
    infotext = self.infotext
    self.infotext = ""
    return infotext
  #enddef
  def setStatus(self,stat):
    self.status     = stat.status
    if( self.is_NOT_OKAY() ):
      self.set_NOT_OKAY(stat.errtext )

    if( len(stat.infotext) ):
      if( len(self.infotext)):
        self.infotext = f"{self.infotext} \n {stat.infotext}"
      else:
        self.infotext = f"{stat.infotext}"
      #endif
    #endif
    stat.reset()




#endclass