#
#
#
#
import os, sys
from dataclasses import dataclass, field
from typing import List

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

# Hilfsfunktionen
import tools.hfkt_def as hdef
import tools.hfkt_type as htype
import tools.hfkt_str as hstr
import tools.sgui as sgui
import tools.hfkt_data_set as hdset
import tools.hfkt_tvar as htvar

class IbanParam:
    
    NAME = "iban_name"
    
    # Indizes in erinem data_set ("iban", "bank", "wer", "comment")

    IBAN_DATA_INDEX_IBAN: int = 0
    IBAN_DATA_INDEX_BANK: int = 1
    IBAN_DATA_INDEX_WER: int = 2
    IBAN_DATA_INDEX_COMMENT: int = 3
    
    IBAN_DATA_INDEX_LIST = [IBAN_DATA_INDEX_IBAN, IBAN_DATA_INDEX_BANK, IBAN_DATA_INDEX_WER
                           ,IBAN_DATA_INDEX_COMMENT]
        
    IBAN_DATA_NAME_IBAN: str = "iban"
    IBAN_DATA_NAME_BANK = "bank"
    IBAN_DATA_NAME_WER = "wer"
    IBAN_DATA_NAME_COMMENT = "comment"
    
    IBAN_DATA_LLIST = [
        [IBAN_DATA_INDEX_IBAN, IBAN_DATA_NAME_IBAN, "str", "str"],
        [IBAN_DATA_INDEX_BANK, IBAN_DATA_NAME_BANK, "str", "str"],
        [IBAN_DATA_INDEX_WER, IBAN_DATA_NAME_WER, "str", "str"],
        [IBAN_DATA_INDEX_COMMENT, IBAN_DATA_NAME_COMMENT, "str", "str"],
    ]
    IBAN_DATA_NAME_DICT = {}
    IBAN_DATA_TYPE_DICT = {}
    IBAN_DATA_STORE_TYPE_DICT = {}
    IBAN_DATA_NAME_LIST = []
    IBAN_DATA_TYPE_LIST = []
    IBAN_DATA_STORE_TYPE_LIST = []
    # IBAN_DATA_INDEX_LIST = []
    for liste in IBAN_DATA_LLIST:
        IBAN_DATA_NAME_DICT[liste[0]] = liste[1]
        IBAN_DATA_TYPE_DICT[liste[0]] = liste[2]
        IBAN_DATA_STORE_TYPE_DICT[liste[0]] = liste[3]
        IBAN_DATA_NAME_LIST.append(liste[1])
        IBAN_DATA_TYPE_LIST.append(liste[2])
        IBAN_DATA_STORE_TYPE_LIST.append(liste[3])
    # end for
    LINE_COLOR_BASE = ""
    LINE_COLOR_NEW = "aquamarine1"  # "aliceblue"
    LINE_COLOR_EDIT = "orange1"

class IbanDataSet:
    '''
    members:
    functions:
    (status,ertext) = self.add(iban,bank,comment)      add new iban
    (status,ertext) = self.add(iban,bank)
    found           = self.find(iban)                  find specific iban

    (status,ertext) = self.show()                      show in GUI

    '''
    OKAY = hdef.OK
    NOT_OKAY = hdef.NOT_OK
    
    def __init__(self, iban_data_table: htvar.TTable ):
        self.par = IbanParam()
        self.status = hdef.OK
        self.errtext = ""
        self.data_set_obj = hdset.DataSet(self.par.NAME)

        for index in self.par.IBAN_DATA_NAME_DICT.keys():
            
            self.data_set_obj.set_definition(index, self.par.IBAN_DATA_NAME_DICT[index]
                                                  , self.par.IBAN_DATA_TYPE_DICT[index]
                                                  , self.par.IBAN_DATA_STORE_TYPE_DICT[index])
            
            if self.data_set_obj.status != hdef.OKAY:
                self.status = self.data_set_obj.status
                self.errtext = self.data_set_obj.errtext
                self.data_set_obj.reset_status()
                break
            # end if
        # end for
        
        self.data_set_obj.add_data_set_tvar(iban_data_table ,self.par.LINE_COLOR_BASE)
    
        if self.data_set_obj.status != hdef.OKAY:
            self.status = self.data_set_obj.status
            self.errtext = self.data_set_obj.errtext
            self.data_set_obj.reset_status()
        # end if
    
    def add(self, iban, bank, wer, comment=""):
        '''
        add a new iban number into a data_set

        data_set = [iban,bank,wer,comment]

        :param iban:     IBAN-Nummer
        :param bank:     Welche Bank
        :param wer:      Wem gehört die IBAN
        :param comment:
        :return: (status,ertext)
        '''
        
        status = hdef.OKAY
        errtext = ""
        
        # proof iban
        (okay, wert) = htype.type_proof_iban(iban)
        if (okay != hdef.OKAY):
            status = hdef.NOT_OKAY
            errtext = f"iban_data: error input iban = {iban} is not valid"
            return (status, errtext)
        # endif
        
        # proof if iban already in
        if (not self.find(iban)):
            # build iban_data_set as list data_set = [iban,bank,wer,comment]
            # and add to data_list
            self.idmax += 1
            self.data_list.append([self.idmax, iban, wer, bank, comment])
        # endif
        
        return (status, errtext)
    
    # enddef
    
    def show(self,gui):
        '''
        show data in gui and possibly correct in gui
        :return: (status,errtext)
        '''
        status = hdef.OKAY
        errtext = ""
        
        (d_new, indexAbfrage) = gui.abfrage_tabelle(header_liste=self.item_list
                                                     , data_set=self.data_list
                                                     , listeAbfrage=["okay", "change", "add"])
        
        if (indexAbfrage == 0):  # okay , cancel
            return (status, errtext)
        elif (indexAbfrage == 1):  # change
            # data_set = [iban,bank,wer,comment]
            
            # proof what has changed and store in index_tri = [ilist,idataset,value]
            index_tri = []
            for i, d in enumerate(self.data_list):
                if (d[I_IBAN] != d_new[i][I_IBAN]):
                    # proof iban
                    (okay, wert) = htype.type_proof_iban(d_new[i][I_IBAN])
                    if (okay != hdef.OKAY):
                        status = hdef.NOT_OKAY
                        errtext = f"iban_data: error input iban = {d_new[i][I_IBAN]} from Bank:{d[I_BANK]} and Comment:{d[I_COM]} is not valid"
                        return (status, errtext)
                    else:
                        index_tri.append((i, I_IBAN, wert))
                    # endif
                # endif iban
                if (d[I_BANK] != d_new[i][I_BANK]):
                    index_tri.append((i, I_BANK, d_new[i][I_BANK]))
                # endif
                if (d[I_WER] != d_new[i][I_WER]):
                    index_tri.append((i, I_WER, d_new[i][I_WER]))
                # endif
                if (d[I_COM] != d_new[i][I_COM]):
                    index_tri.append((i, I_COM, d_new[i][I_COM]))
                # endif
            # endif
            
            # set changed values
            for [i, j, value] in index_tri:
                self.data_list[i][j] = value
            # end for
        else:  # add
            
            ddict = {}
            ddict["liste_abfrage"] = self.item_list
            
            ddict["title"] = 'Neue IBAN-Nummer eingeben'
            
            listeErgebnis = gui.abfrage_n_eingabezeilen_dict(ddict)
            
            if (len(listeErgebnis) == 0):
                status = hdef.NOT_OKAY
                errtext = f"iban_data: Keine IBAN-Nummer eingegeben"
                return (status, errtext)
            # endif
            
            iban = hstr.elim_ae(listeErgebnis[I_IBAN], ' ')
            bank = hstr.elim_ae(listeErgebnis[I_BANK], ' ')
            wer = hstr.elim_ae(listeErgebnis[I_WER], ' ')
            comment = hstr.elim_ae(listeErgebnis[I_COM], ' ')
            
            (okay, wert) = htype.type_proof_iban(iban)
            if (okay != hdef.OKAY):
                status = hdef.NOT_OKAY
                errtext = f"iban_data: error input iban = {iban} from Bank:{bank} and Comment:{comment} is not valid"
                return (status, errtext)
            else:
                iban = wert
            # endif
            
            (status, errtext) = self.add(self, iban, bank, wer, comment)
        
        # endif
        
        return (status, errtext)
    # enddef

def iban_find(data_list, iban):
    """
    find iban number in data_list with data_set = [iban,bank,wer,comment]
    :param iban:
    :return: True/False
    """
    found = False
    for data_set in data_list:
        if (iban == data_set[I_IBAN]):
            found = True
            break
        # end if
    # end for
    return found


# enddef
def iban_add(data_list, idmax, iban, bank, wer, comment=""):
    '''
    add a new iban number into a data_set

    data_set = [iban,bank,wer,comment]

    :param iban:     IBAN-Nummer
    :param bank:     Welche Bank
    :param wer:      Wem gehört die IBAN
    :param comment:
    :return: (status,ertext,data_list)
    '''
    
    status = hdef.OKAY
    errtext = ""
    warntext = ""
    
    # proof iban
    (okay, wert) = htype.type_proof_iban(iban)
    if (okay != hdef.OKAY):
        status = hdef.NOT_OKAY
        errtext = f"iban_data: error input iban = {iban} is not valid"
        return (status, errtext,warntext,data_list)
    # endif
    
    # proof if iban already in
    if (not iban_find(data_list,iban)):
        # build iban_data_set as list data_set = [iban,bank,wer,comment]
        # and add to data_list
        
        data_list.append([idmax, iban, wer, bank, comment])
    else:
        warntext = f"iban_data: Eingabe iban = {iban} ist bereits vorhanden"
    # endif
    
    return (status, errtext,warntext,data_list)
# enddef
def iban_mod(data_list,d_new):
    
    status = hdef.OKAY
    errtext = ""

    # proof what has changed and store in index_tri = [ilist,idataset,value]
    index_tri = []
    for i, d in enumerate(data_list):
        if (d[I_IBAN] != d_new[i][I_IBAN]):
            # proof iban
            (okay, wert) = htype.type_proof_iban(d_new[i][I_IBAN])
            if (okay != hdef.OKAY):
                status = hdef.NOT_OKAY
                errtext = f"iban_data: error input iban = {d_new[i][I_IBAN]} from Bank:{d[I_BANK]} and Comment:{d[I_COM]} is not valid"
                return (status, errtext,data_list)
            else:
                index_tri.append((i, I_IBAN, wert))
            # endif
        # endif iban
        if (d[I_BANK] != d_new[i][I_BANK]):
            index_tri.append((i, I_BANK, d_new[i][I_BANK]))
        # endif
        if (d[I_WER] != d_new[i][I_WER]):
            index_tri.append((i, I_WER, d_new[i][I_WER]))
        # endif
        if (d[I_COM] != d_new[i][I_COM]):
            index_tri.append((i, I_COM, d_new[i][I_COM]))
        # endif
    # endif
    
    # set changed values
    for [i, j, value] in index_tri:
        data_list[i][j] = value
    # end for
    
    return (status, errtext,data_list)
# end def
def iban_add_data_set(gui,header_list,data_list,id_max):
    """
        Use header_list[1,:] because id is automatically added
    """
    status = hdef.OKAY
    errtext = ""

    ddict = {}
    ddict["liste_abfrage"] = header_list[1:]
    ddict["title"]         =  'Neue IBAN-Nummer eingeben'

    listeErgebnis = gui.abfrage_n_eingabezeilen_dict(ddict)
    
    if (len(listeErgebnis) == 0):
        status = hdef.NOT_OKAY
        errtext = f"iban_data: Keine IBAN-Nummer eingegeben"
        return (status, errtext, data_list)
    # endif
    
    iban = hstr.elim_ae(listeErgebnis[I_IBAN-1], ' ')
    bank = hstr.elim_ae(listeErgebnis[I_BANK-1], ' ')
    wer = hstr.elim_ae(listeErgebnis[I_WER-1], ' ')
    comment = hstr.elim_ae(listeErgebnis[I_COM-1], ' ')
    
    (okay, wert) = htype.type_proof_iban(iban)
    if (okay != hdef.OKAY):
        status = hdef.NOT_OKAY
        errtext = f"iban_data: error input iban = {iban} from Bank:{bank} and Comment:{comment} is not valid"
        return (status, errtext, data_list)
    else:
        iban = wert
    # endif
    
    (status, errtext,warntext,data_list) = iban_add(data_list, id_max, iban, bank, wer, comment)
    
    if( len(warntext) ):
        errtext = warntext
        status = hdef.NOT_OKAY
    # end if
    
    return (status, errtext,data_list)

# end def
def iban_delete_data_set(data_list, irow):

    status = hdef.OKAY
    errtext = ""
    
    if (irow < 0) or (irow >= len(data_list)):
        status = hdef.NOT_OKAY
        errtext = f"iban_data: error irow = {irow} is not in range of data_list len(data_list) = {len(data_list)}"
        return (status, errtext, data_list)
    else:
        del data_list[irow]
    # end if
    
    return (status, errtext, data_list)
# end def
