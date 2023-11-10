#
# AdressBook:
#
# verionen:
# 0.0
#
import AdressBookDef  as ABDef
import AdressBookLog  as ABLog
import AdressBookBase as ABBase
import AdressBookGui as ABGui

class AdressBook:
    def __init__(self,ini_file=None):

        # LogFile erstellen
        self.log = ABLog.AdressBookLog(ABDef.LOG_FILE_NAME_DEFAULT)
        #base-Fkt aufrufen mit ini_file einlesen
        self.base = ABBase.AdressBookBase(self.log,ini_file)
        if( self.base.state != ABDef.OKAY ): return
        #Grafik
        self.gui = ABGui.AdressBookGui(self.base,self.log)
        if( self.gui.state != ABDef.OKAY ): return

if __name__ == '__main__':

    a=AdressBook('AdressBook.ini')