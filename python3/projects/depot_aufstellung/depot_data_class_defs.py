#
#
#   beinhaltet verschiedene Definitionen
#
import os, sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif


import tools.hfkt_def as hdef
import tools.hfkt_type as htype
import tools.hfkt_list as hlist

class IDCount:
    '''
    self.set_act_id(id) setzt die die id (sollte bei initialisierung benutzt werden)
    self.get_act_id()   gibt actual idmax zurück
    self.get_new_id()   zählt idmax um eins hoch und gibt id zurück
    '''
    idmax: int = 0
    def __init__(self):
        pass
    # end def
    def set_act_id(self,id:int):
        IDCount.idmax = id
    # end def
    def get_act_id(self):
        return IDCount.idmax
    # end def
    def set_new_id(self,id:int):
        if  id-IDCount.idmax != 1:
            raise Exception(f"set id = {id} is not idmax+1: idmax = {IDCount.idmax}")
        else:
            IDCount.idmax = id
        # end if
        return
    # end def
    def get_new_id(self):
        IDCount.idmax += 1
        return IDCount.idmax
    # end def
    def reset_consistency_check(self):
        IDCount.id_consistency_check_dict = {}
    def proof_and_add_consistency_check_id(self,id,konto_name):
        '''
        
        :param id: used id
        :return: (okay,errtext) = self.proof_and_add_consistency_check_id(id)
        '''
        
        if id in IDCount.id_consistency_check_dict.keys():
            okay = hdef.NOT_OKAY
            errtext = f"proof_and_add_consistency_check_id: id = <{id}> is already in konto_name: <{IDCount.id_consistency_check_dict[id]}>"
        elif id > IDCount.idmax:
            okay = hdef.NOT_OKAY
            errtext = f"proof_and_add_consistency_check_id: id = <{id}> is greater then idmx: <{IDCount.idmax}> in konto_name: <{konto_name}>"
        else:
            IDCount.id_consistency_check_dict[id] = konto_name
            okay = hdef.OKAY
            errtext = ""
        # end if
        return (okay,errtext)
# end class
