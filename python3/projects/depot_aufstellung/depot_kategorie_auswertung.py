"""

 Wertet datensätze mit Kategorie aus

"""

import os, sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif


import tools.hfkt_def as hdef
import tools.hfkt_type as htype
import tools.hfkt_tvar as htvar
import tools.hfkt_list as hlist
import tools.hfkt_str as hstr
import tools.hfkt_data_set as hdset

class KatDataClass:
    '''
    obj = KatDataClass(kategorie,kattype,header_list,type_list)

    Funktionen:
    obj.reset_status()                   resetet Status und Text

    '''
    
    def __init__(self, kat,group,katzeit,header_list, type_list):
        '''
        
        :param kategorie: Kategoriename
        :param kattype:   Type der Verarbeitung =1 monatlich, =12 jährlich
        :param header_list: dateset header Liste
        :param type_list: dateset type Liste
        '''

        self.TYPE_MONAT = 1
        self.TYPE_JAHR  = 12
        self.status = hdef.OK
        self.errtext = ""
        self.infotext = ""

        self.kategorie = kat
        self.group     = group
        self.katzeit   = katzeit
        
        if (katzeit != self.TYPE_MONAT) or (katzeit != self.TYPE_JAHR):
            raise Exception(f"KatDataClass int() {katzeit = } ist nicht {self.TYPE_MONAT = } oder {self.TYPE_JAHR = }")
        # end if
        
        self.build_data_set_obj(header_list,type_list)
        
    # end def
    def build_data_set_obj(self,header_list,type_list):
        
        # Data-Set anlegen
        self.data_set_obj = hdset.DataSet(self.kategorie)
        
        # Header un Type bestimmen
        for index, header in enumerate(header_list):
            
            self.data_set_obj.set_definition(index, header, type_list[index], type_list[index])
            if self.data_set_obj.status != hdef.OKAY:
                self.status = self.data_set_obj.status
                self.errtext = self.data_set_obj.errtext
                self.data_set_obj.reset_status()
                break
            # end if
        # end for
        
        return
    # end def
# end class
class KategorieAuswertungClass:
    '''
    obj = KategorieAuswertungClass(par,header_list,type_list,katfunc)

    Funktionen:
    obj.reset_status()                   resetet Status und Text

    '''
    
    def __init__(self, par,header_list,type_list,katfunc):
        self.status = hdef.OK
        self.errtext = ""
        self.infotext = ""
        
        self.par = par
        self.header_list = header_list
        self.type_list = type_list
        self.katfunc = katfunc
        
        self.kat_data_obj_dict  = {}
        self.n_kat_data_obj     = 0

        self.build_kategorie_data_sets()
    # end def
    def reset_status(self):
        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""
    
    # end def
    def build_kategorie_data_sets(self):
        
        
        for kat in self.katfunc.get_kat_list():
            (group, zeit) = self.katfunc.get_grup_type_from_kat(kat)
            self.kat_data_obj_dict[kat] = KatDataClass(kat,group, zeit,self.header_list,self.type_list)
            self.n_kat_data_obj += 1
        # end for
    # end def
# end class