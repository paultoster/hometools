#
# AdressBookLog:
#              Logfile und terminal ausgabe
#
# verionen:
# 0.0
#
import types
import AdressBookDef as ABDef


import tkinter.messagebox as tkMessageBox

class AdressBookLog:
    state = ABDef.OKAY
    def __init__(self,log_file=None):
      """ Log-Datei oeffnen
      """

      if( not log_file ):
          self.log_file = ABDef.LOG_FILE_NAME_DEFAULT
      else:
          self.log_file = log_file

      try:
          self.fid = open(log_file,"a")

      except IOError:

          print("IO-error of opening log_file <%s>" % log_file)
          self.state = ABDef.NOT_OK
          self.logfile_out_flag = false
          self.fid = 0
          return

    def __del__(self):
      try:
          self.fid.close()
      except IOError:
          print("IO-error of close log_file <%s>" % self.log_file)
      else:
          print("Close <%s>" % self.log_file)

    def write(self,text,num_of_space=0,display=0):

      for i in range(num_of_space):
        self.fid.write(" ")
      self.fid.write(text)
      if( display ):
        n = len(text)
        if( n > 0):
          if( text[n-1] == '\n' ):
            n -= 1
          tkMessageBox.askyesno(title='Ausgabe', message=text[0:n])

    def write_e(self,text,num_of_space=0,display=0):

      for i in range(num_of_space):
        self.fid.write(" ")
      self.write(text+"\n",display=display)

    def write_error(self,text,num_of_space=0,display=0):

      for i in range(num_of_space):
        self.fid.write(" ")
      self.write(ABDef.A_LOG_ERROR+text+"\n",display=display)

    def write_warning(self,text,num_of_space=0,display=0):

      for i in range(num_of_space):
        self.fid.write(" ")
      self.write(ABDef.A_LOG_WARNING+text+"\n",display=display)


    def write_dict(self,text,dict,num_of_space=0,display=0):

      if( len(text) > 0 ):
        self.write_e(text,num_of_space=num_of_space,display=display)

      keys = dict.keys()
      for key in keys:
        if( type(key) is types.StringType or type(key) is types.UnicodeType ):
          self.write(key+" : ",num_of_space=num_of_space,display=display)
        else:
          self.write(str(key)+" : ",num_of_space=num_of_space,display=display)

        if( type(dict[key]) is types.StringType or type(dict[key]) is types.UnicodeType ):
          self.write_e(dict[key],display=display)
        elif(  (type(dict[key]) is types.BooleanType) or (type(dict[key]) is types.FloatType) \
            or (type(dict[key]) is types.IntType) or (type(dict[key]) is types.LongType) ):
          self.write_e( str(dict[key]),display=display)
        elif( (type(dict[key]) is types.DictionaryType) ):
          self.write_dict("dict : ",dict[key],num_of_space=num_of_space+9,display=display)
        elif( (type(dict[key]) is types.ListType) ):
          self.write_liste("liste : ",dict[key],num_of_space=num_of_space+10,display=display)

    def write_liste(self,text,liste,num_of_space=0,display=0):

      if( len(text) > 0 ):
        self.write_e(text,num_of_space=num_of_space,display=display)

      for item in liste:
        if( type(item) is types.StringType or type(item) is types.UnicodeType ):
          self.write_e(item,display=display)
        elif(  (type(item) is types.BooleanType) or (type(item) is types.FloatType) \
            or (type(item) is types.IntType) or (type(item) is types.LongType) ):
          self.write_e( str(item),display=display)
        elif( (type(item) is types.DictionaryType) ):
          self.write_dict("dict : ",item,num_of_space=num_of_space+9,display=display)
        elif( (type(item) is types.ListType) ):
          self.write_liste("liste : ",item,num_of_space=num_of_space+10,display=display)