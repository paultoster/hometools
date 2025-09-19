import os
import sys

# -------------------------------------------------------------------------------
t_path, _ = os.path.split(__file__)
if (t_path == os.getcwd()):
    
    import sgui
    import hfkt_def as hdef
    import hfkt_pickle as hpickle
else:
    p_list = os.path.normpath(t_path).split(os.sep)
    if (len(p_list) > 1): p_list = p_list[: -1]
    t_path = ""
    for i, item in enumerate(p_list): t_path += item + os.sep
    if (os.path.normpath(t_path) not in sys.path): sys.path.append(t_path)
    
    from tools import sgui
    from tools import hfkt_def as hdef
    from tools import hfkt_pickle as hpickle
# endif--------------------------------------------------------------------------


NO_PROTOCOL = 0
SAVE_PROTOCOL = 1
READ_PROTOCOL = 2

class SguiProtocol:
    '''
    '''
    def __init__(self,protocol_type: int=0,protocol_file: str=None):
        '''
        
        :param protocol_type: 0: no protocol, 1: save protocol, 2, use protocol
        :param protocol_file: file name
        '''
        
        self.status = hdef.OKAY
        self.errtext = ""

        self.setup(protocol_type,protocol_file)
    
    def setup(self,protocol_type,protocol_file):
    
        if protocol_file == None:
            self.protocol_file = "protocol.json"
        else:
            self.protocol_file = protocol_file
        # end if
        if protocol_type == READ_PROTOCOL:
            self.jsonfunc = hpickle.DataJson(self.protocol_file)
            self.status = self.jsonfunc.status
            self.errtext = self.jsonfunc.errtext
            if self.status == hdef.OKAY:
                self.jsonfunc.read()
                self.status = self.jsonfunc.status
                self.errtext = self.jsonfunc.errtext
            # end if
            if self.status == hdef.OKAY:
                self.protocol_data = self.jsonfunc.get_data()
                self.status = self.jsonfunc.status
                self.errtext = self.jsonfunc.errtext
                self.run_protocol_data = True
                self.save_protocol_data = False
            else:
                self.protocol_data = []
                self.run_protocol_data = False
                self.save_protocol_data = False
            # end if
        elif protocol_type == SAVE_PROTOCOL:
            self.jsonfunc = hpickle.DataJson(self.protocol_file)
            self.status = self.jsonfunc.status
            self.errtext = self.jsonfunc.errtext
            if self.status == hdef.OKAY:
                self.protocol_data = []
                self.jsonfunc.set_data(self.protocol_data)
                self.status = self.jsonfunc.status
                self.errtext = self.jsonfunc.errtext
                self.run_protocol_data = False
                self.save_protocol_data = True
            else:
                self.protocol_data = []
                self.run_protocol_data = False
                self.save_protocol_data = False
            # end if
        else:
            self.jsonfunc = None
            self.protocol_data = []
            self.run_protocol_data = False
            self.save_protocol_data = False
        # end if
        self.protocol_counter = -1
        self.protocol_n       = len(self.protocol_data)
    # end def
    def set_protcol_type_file(self,protocol_type: int,protocol_file:str = None):
        self.setup(protocol_type,protocol_file)
    # end def
    def save(self):
        if self.save_protocol_data:
            self.jsonfunc.save(self.protocol_data)
        # end if
    # end def
    def get_next_protocol_data(self,key:str):
        
        self.protocol_counter += 1
        if self.protocol_counter < self.protocol_n:
            
            ddict = self.protocol_data[self.protocol_counter]
            
            
            if "protocol_counter" in ddict.keys():
                print(f"Read protocol protocol_counter = {ddict["protocol_counter"]} of protocol_n = {self.protocol_n}")
            # end if
            
            if key in ddict.keys():
                data = ddict[key]
                success = True
            else:
                data = None
                success = False
                print(f"get_next_protocol_data: key={key} war nicht im ddict={ddict} protocol_counter={self.protocol_counter-1}")
            # end if
        else:
            data = None
            success = False
            print(
                f"get_next_protocol_data: keine Daten in data für protocol_counter={self.protocol_counter}")
        # end if
        return (success,data)
    # end def
    def get_act_protocol_data(self, key: str):
        
        if self.protocol_counter < self.protocol_n:
            
            ddict = self.protocol_data[self.protocol_counter]
            
            if key in ddict.keys():
                data = ddict[key]
                success = True
            else:
                data = None
                success = False
                print(
                    f"get_next_protocol_data: key={key} war nicht im ddict={ddict} protocol_counter={self.protocol_counter - 1}")
            # end if
        else:
            data = None
            success = False
            print(
                f"get_next_protocol_data: keine Daten in data für protocol_counter={self.protocol_counter}")
        # end if
        return (success, data)
    
    # end def
    def set_next_protocol_data(self,key,data,comment_data=None):
        
        self.protocol_n       += 1
        self.protocol_counter  = self.protocol_n - 1
        ddict = {}
        ddict["protocol_counter"] = self.protocol_counter
        ddict[key] = data
        if comment_data != None:
            ddict["comment_"+key] = f"{comment_data}"
        self.protocol_data.append(ddict)
    # end def
    def set_act_protocol_data(self, key, data,comment_data=None):
        
        ddict = self.protocol_data[self.protocol_counter]
        ddict[key] = data
        if comment_data != None:
            ddict["comment_"+key] = f"{comment_data}"
        self.protocol_data[self.protocol_counter] = ddict
    
    # end def
    def abfrage_liste_index(self,liste, title=None):
        '''
        
        :param liste:
        :param title:
        :return: index = self.abfrage_liste_index(self,liste, title=None)
        '''
        if self.run_protocol_data:
            
            (success,index) = self.get_next_protocol_data("index")
            
            if success:
                return index
            else:
                self.run_protocol_data = False
            # end if
        # end if
        
        if not self.run_protocol_data:
            
            index = sgui.abfrage_liste_index(liste,title)
            
            if self.save_protocol_data:
                self.set_next_protocol_data("title", title)
                self.set_act_protocol_data("index",index,liste)
                
            # end if
        # end if
        
        return index
    # end def
    def abfrage_liste_index_abfrage_index(self,liste, listeAbfrage, title=None):
        '''
        
        :param liste:
        :param listeAbfrage:
        :param title:
        :return: (index,indexAbfrage) = self.abfrage_liste_index_abfrage_index(liste,listeAbfrage)
        '''
        if self.run_protocol_data:
            
            (success1, index) = self.get_next_protocol_data("index")
            (success2, indexAbfrage) = self.get_act_protocol_data("indexAbfrage")

            if success1 and success2:
                return (index,indexAbfrage)
            else:
                self.run_protocol_data = False
            # end if
        # end if
        
        if not self.run_protocol_data:
            
            (index,indexAbfrage) = sgui.abfrage_liste_index_abfrage_index(liste, listeAbfrage, title)
            
            if self.save_protocol_data:
                self.set_next_protocol_data("title", title)
                self.set_act_protocol_data("index", index,liste)
                self.set_act_protocol_data("indexAbfrage", indexAbfrage,listeAbfrage)
            # end if
        # end if
        
        return (index, indexAbfrage)
    