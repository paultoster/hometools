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
    def __init__(self,protocol_type: int=0,protocol_file: str=None,store_each_demand=False):
        '''
        
        :param protocol_type: 0: no protocol, 1: save protocol, 2, use protocol
        :param protocol_file: file name
        '''
        
        self.status = hdef.OKAY
        self.errtext = ""

        self.setup(protocol_type,protocol_file)
        
        self.store_each_demand = store_each_demand
    
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
    def set_protcol_type_file(self,protocol_type: int,protocol_file:str = None,store_each_demand=None):

        self.setup(protocol_type,protocol_file)
    
        if store_each_demand != None:
            self.store_each_demand = store_each_demand
    
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
    def is_valid_protocol_n(self):
        '''
        
        :return: flag
        '''
        if self.protocol_counter < self.protocol_n:
            return True
        else:
            return False
        # end if
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
        
        if self.store_each_demand:
            self.save()
    # end def
    def set_act_protocol_data(self, key, data,comment_data=None):
        
        ddict = self.protocol_data[self.protocol_counter]
        ddict[key] = data
        if comment_data != None:
            ddict["comment_"+key] = f"{comment_data}"
        self.protocol_data[self.protocol_counter] = ddict

        if self.store_each_demand:
            self.save()

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
    def abfrage_liste_indexList(self, liste, title=None):
        '''

        :param liste:
        :param title:
        :return: index = self.abfrage_liste_index(self,liste, title=None)
        '''
        if self.run_protocol_data:
            
            (success, indexListe) = self.get_next_protocol_data("indexListe")
            
            if success:
                return indexListe
            else:
                self.run_protocol_data = False
            # end if
        # end if
        
        if not self.run_protocol_data:
            
            indexListe = sgui.abfrage_liste_indexListe(liste, title)
            
            if self.save_protocol_data:
                self.set_next_protocol_data("title", title)
                self.set_act_protocol_data("indexListe", indexListe, liste)
            
            # end if
        # end if
        
        return indexListe
    
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
    # end def
    def abfrage_liste_indexListe_abfrage_index(self, liste, listeAbfrage, title=None):
        '''

        :param liste:
        :param listeAbfrage:
        :param title:
        :return: (index,indexAbfrage) = self.abfrage_liste_index_abfrage_index(liste,listeAbfrage)
        '''
        if self.run_protocol_data:
            
            (success1, indexListe) = self.get_next_protocol_data("indexListe")
            (success2, indexAbfrage) = self.get_act_protocol_data("indexAbfrage")
            
            if success1 and success2:
                return (indexListe, indexAbfrage)
            else:
                self.run_protocol_data = False
            # end if
        # end if
        
        if not self.run_protocol_data:
            
            (indexListe, indexAbfrage) = sgui.abfrage_liste_indexListe_abfrage_index(liste, listeAbfrage, title)
            
            if self.save_protocol_data:
                self.set_next_protocol_data("title", title)
                self.set_act_protocol_data("indexListe", indexListe, liste)
                self.set_act_protocol_data("indexAbfrage", indexAbfrage, listeAbfrage)
            # end if
        # end if
        
        return (indexListe, indexAbfrage)
    
    # end def
    def abfrage_tabelle(self, dict_inp):
        '''

        :param dict_inp:
        :return: ddict_out = self.abfrage_tabelle(dict_inp)
        '''
        if self.run_protocol_data:
            ddict_out = {}
            (s1, ddict_out["status"]) = self.get_next_protocol_data("status")
            (s2, ddict_out["errtext"]) = self.get_act_protocol_data("errtext")
            (s3, ddict_out["index_abfrage"]) = self.get_act_protocol_data("index_abfrage")
            (s4, ddict_out["irow_select"]) = self.get_act_protocol_data("irow_select")
            (s5, ddict_out["data_change_irow_icol_liste"]) = self.get_act_protocol_data("data_change_irow_icol_liste")
            (s6, ddict_out["data_change_flag"]) = self.get_act_protocol_data("data_change_flag")
            
            (s7, ddict_out["ttable"]) = self.get_act_protocol_data("ttable")
            (s8, ddict_out["data_set"]) = self.get_act_protocol_data("data_set")
            
            if s1 and s2 and s3 and s4 and s5 and s6 and (s7 or s8):
                
                return ddict_out
            else:
                self.run_protocol_data = False
            # end if
        # end if
        
        if not self.run_protocol_data:
            
            ddict_out = sgui.abfrage_tabelle(dict_inp)
            
            if self.save_protocol_data:
                self.set_next_protocol_data("status", ddict_out["status"])
                self.set_act_protocol_data("errtext", ddict_out["errtext"])
                
                if "ttable" in ddict_out.keys():
                    self.set_act_protocol_data("ttable", ddict_out["ttable"])
                # end if
                if "data_set" in ddict_out.keys():
                    self.set_act_protocol_data("data_set", ddict_out["data_set"])
                # end if
                
                if "abfrage_liste" in dict_inp.keys():
                    self.set_act_protocol_data("index_abfrage", ddict_out["index_abfrage"], dict_inp["abfrage_liste"])
                else:
                    self.set_act_protocol_data("index_abfrage", ddict_out["index_abfrage"])
                # end if
                self.set_act_protocol_data("irow_select", ddict_out["irow_select"])
                self.set_act_protocol_data("data_change_irow_icol_liste", ddict_out["data_change_irow_icol_liste"])
                self.set_act_protocol_data("data_change_flag", ddict_out["data_change_flag"])
            # end if
        # end if
        
        return ddict_out
    
    # end def
    def abfrage_dict(self,ddict,title=None):
        '''
        
        :param title:
        :return: (ddict, changed_key_liste) = self.abfrage_dict(ddict, title=None)
        '''
        
        if self.run_protocol_data:
            ddict_out = {}
            (s1, ddict) = self.get_next_protocol_data("ddict")
            (s2, changed_key_liste) = self.get_act_protocol_data("changed_key_liste")
            
            if s1 and s2:
                
                return (ddict,changed_key_liste)
            else:
                self.run_protocol_data = False
            # end if
        # end if
        
        if not self.run_protocol_data:
            
            ddict = sgui.abfrage_dict(ddict)
            
            if self.save_protocol_data:
                self.set_next_protocol_data("ddict", ddict)
                self.set_act_protocol_data("changed_key_liste", changed_key_liste)
            # end if
        # end if
        
        return (ddict,changed_key_liste)
    
    # end def
    def abfrage_n_eingabezeilen_dict(self, dict_inp):
        '''

        :param dict_inp:
        :return:
        '''
        if self.run_protocol_data:
            ddict_out = {}
            (s1, liste) = self.get_next_protocol_data("liste")
            
            if s1:
                return liste
            else:
                self.run_protocol_data = False
            # end if
        # end if
        
        if not self.run_protocol_data:
            
            liste = sgui.abfrage_n_eingabezeilen_dict(dict_inp)
            
            if self.save_protocol_data:
                if "liste_abfrage" in dict_inp.keys():
                    self.set_next_protocol_data("liste", liste, dict_inp["liste_abfrage"])
                else:
                    self.set_next_protocol_data("liste", liste)
                # end if
            # end if
        # end if
        
        return liste
    
    # end def
    def abfrage_janein(self,text=None,title=None):
        '''
        
        :param text:
        :param title:
        :return:
        '''
        if self.run_protocol_data:
            
            (success, flag) = self.get_next_protocol_data("flag")
            
            if success:
                return flag
            else:
                self.run_protocol_data = False
            # end if
        # end if
        
        if not self.run_protocol_data:
            
            flag = sgui.abfrage_janein(text, title)
            
            if self.save_protocol_data:
                self.set_next_protocol_data("flag", flag)
            # end if
        # end if
        
        return flag
    # end def
    def anzeige_text(self,texteingabe,title=None,textcolor='black'):
        '''
        
        :param texteingabe:
        :param title:
        :param textcolor:
        :return: self.anzeige_text(texteingabe, title=None, textcolor='black')
        '''
        
        if self.run_protocol_data:
            print(f"anzeige_text: ",texteingabe)
        # end if
        
        if not self.run_protocol_data:
            
            sgui.anzeige_text(texteingabe, title,textcolor)
            
            if self.save_protocol_data:
                self.set_next_protocol_data("texteingabe", texteingabe)
                self.set_act_protocol_data("title", title)
                self.set_act_protocol_data("textcolor", textcolor)
            # end if
        # end if
    # end def
    def abfrage_file(self,file_types="*.*",comment=None,start_dir=None):
        '''
        
        :param file_types:
        :param comment:
        :param start_dir:
        :return: filename = self.abfrage_file(file_types="*.*",comment=None,start_dir=None):
        '''
        if self.run_protocol_data:
            
            (success, filename) = self.get_next_protocol_data("filename")
            
            if success:
                return filename
            else:
                self.run_protocol_data = False
            # end if
        # end if
        
        if not self.run_protocol_data:
            
            filename = sgui.abfrage_file(file_types, comment,start_dir)
            
            if self.save_protocol_data:
                self.set_next_protocol_data("filename", filename)
            # end if
        # end if
        
        return filename


    