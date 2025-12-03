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
    IBAN_DATA_INDEX_NUM: int = 3
    IBAN_DATA_INDEX_BLZ: int = 4
    IBAN_DATA_INDEX_COMMENT: int = 5
    
    IBAN_DATA_INDEX_LIST = [IBAN_DATA_INDEX_IBAN, IBAN_DATA_INDEX_BANK, IBAN_DATA_INDEX_WER,
                            IBAN_DATA_INDEX_NUM, IBAN_DATA_INDEX_BLZ,IBAN_DATA_INDEX_COMMENT]
        
    IBAN_DATA_NAME_IBAN: str = "iban"
    IBAN_DATA_NAME_BANK = "bank"
    IBAN_DATA_NAME_WER = "wer"
    IBAN_DATA_NAME_NUM = "kontonummer"
    IBAN_DATA_NAME_BLZ = "blz"
    IBAN_DATA_NAME_COMMENT = "comment"
    
    IBAN_DATA_LLIST = [
        [IBAN_DATA_INDEX_IBAN, IBAN_DATA_NAME_IBAN, "str", "str"],
        [IBAN_DATA_INDEX_BANK, IBAN_DATA_NAME_BANK, "str", "str"],
        [IBAN_DATA_INDEX_WER, IBAN_DATA_NAME_WER, "str", "str"],
        [IBAN_DATA_INDEX_NUM, IBAN_DATA_NAME_NUM, "str", "str"],
        [IBAN_DATA_INDEX_BLZ, IBAN_DATA_NAME_BLZ, "str", "str"],
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
    
    (status,ertext) = obj.add(iban,bank,blz,comment)      add new iban
    (status,ertext) = obj.add(iban,bank)
    (status,ertext) = obj.add(iban)
    
    (table , color_list) = obj.get_data_table()
    (status,errtext)     = obj.delete_data_set(irow)
    
    found           = self.iban_find(iban)                  find specific iban

    

    '''
    OKAY = hdef.OK
    NOT_OKAY = hdef.NOT_OK
    
    def __init__(self, iban_data_table: htvar.TTable, banknamefunc = None):
        self.par = IbanParam()
        self.status = hdef.OK
        self.errtext = ""
        self.data_set_obj = hdset.DataSet(self.par.NAME)
        self.banknamefunc = banknamefunc

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
    def reset_status(self):
        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""
    # end def

    def get_data_table(self):
        '''
        
        :return: table = self.get_to_store_data_set_tvar()
        '''
    
        ttable = self.data_set_obj.get_data_set_ttable()
        
        ttable = htvar.transform_icol_table(ttable, self.par.IBAN_DATA_NAME_LIST)
        
        ttable = htvar.transform_type_table(ttable, self.par.IBAN_DATA_TYPE_LIST)
        
        row_color_dliste = self.data_set_obj.get_line_color_set_liste()
        
        return (ttable, row_color_dliste)
    
    def write_anzeige_back_data(self, ttable_anzeige, data_changed_pos_list, header_liste=[]):
        '''

        :param new_data_llist:
        :param data_changed_pos_list:
        :param header_liste=[]:  Liste mit den Headernamen, die geändert werden können, leer: alle ändern
        :return: self.write_anzeige_back_data(ttable_anzeige, data_changed_pos_list)
        '''
        self.infotext = ""
        self.errtext = ""
        
        if not isinstance(header_liste, list):
            header_liste = [header_liste]
        # end if
        
        if len(header_liste) == 0:
            noproof = True
        else:
            noproof = False
        
        # index_liste = list(self.par.IBAN_DATA_NAME_DICT.keys())
        
        changed = False
        for (irow, icol) in data_changed_pos_list:
            
            value = ttable_anzeige.table[irow][icol]
            name = ttable_anzeige.names[icol]
            type = ttable_anzeige.types[icol]
            
            if noproof or name in header_liste:
                
                if self.data_set_obj.set_data_item(value, self.par.LINE_COLOR_EDIT, irow, name, type):
                    
                    if self.data_set_obj.status != hdef.OKAY:
                        self.status = hdef.NOT_OKAY
                        self.errtext = f"write_anzeige_back_data: Fehler set_data_item  errtext: {self.data_set_obj.errtext}"
                        return
                    # end if
                    changed = True
                # end if
        # end for
        
        if changed:
            # sort
            self.data_set_obj.update_order_name(self.par.IBAN_DATA_NAME_BANK)
        # end if
    
    # end def
    def get_extern_default_tlist(self):
        '''
        index_in_header_liste index in header list für buch type
        :return: (tlist, buchungs_type_list, buchtype_index_in_header_liste) =  self.get_extern_default_tlist()
        '''
        
        header_liste = self.par.IBAN_DATA_NAME_LIST
        type_liste = self.par.IBAN_DATA_TYPE_LIST
        tlist = htvar.build_default_list(header_liste, type_liste)
        
        return tlist
    
    # end def
    def add(self, iban, wer=None,bank=None,num=None, blz=None, comment=""):
        '''
        add a new iban number into a data_set

        data_set = [iban,bank,wer,num,blz,comment]

        :param iban:     IBAN-Nummer
        :param bank:     Welche Bank
        :param wer:      Wem gehört die IBAN
        :param comment:
        :return: (status,ertext)
        '''
        
        status = hdef.OKAY
        errtext = ""
        
        if isinstance(iban,htvar.TList):
            tlist = iban
            iban = htvar.get_val_from_list(tlist,self.par.IBAN_DATA_NAME_IBAN,self.par.IBAN_DATA_TYPE_LIST[self.par.IBAN_DATA_INDEX_IBAN])
            
            if (len(iban) == 0) or (iban == None):
                status = hdef.NOT_OKAY
                errtext = f"add: error input tlist = {tlist} kann iban nicht auflösen"
                return (status, errtext)
            # end if
            
            bank = htvar.get_val_from_list(tlist, self.par.IBAN_DATA_NAME_BANK,
                                          self.par.IBAN_DATA_TYPE_LIST[self.par.IBAN_DATA_INDEX_BANK])
            if (len(bank) == 0) or (bank == None):
                bank = None
            # end if
            
            wer = htvar.get_val_from_list(tlist, self.par.IBAN_DATA_NAME_WER,
                                          self.par.IBAN_DATA_TYPE_LIST[self.par.IBAN_DATA_INDEX_WER])
            if (len(wer) == 0) or (wer == None):
                wer = None
            # end if

            num = htvar.get_val_from_list(tlist, self.par.IBAN_DATA_NAME_NUM,
                                           self.par.IBAN_DATA_TYPE_LIST[self.par.IBAN_DATA_INDEX_NUM])
            if (len(num) == 0) or (num == None):
                num = None
            # end if
            
            blz = htvar.get_val_from_list(tlist, self.par.IBAN_DATA_NAME_BLZ,
                                          self.par.IBAN_DATA_TYPE_LIST[self.par.IBAN_DATA_INDEX_BLZ])
            if (len(blz) == 0) or (blz == None):
                blz = None
            # end if

            comment = htvar.get_val_from_list(tlist, self.par.IBAN_DATA_NAME_COMMENT,
                                          self.par.IBAN_DATA_TYPE_LIST[self.par.IBAN_DATA_INDEX_COMMENT])
            if (len(comment) == 0) or (comment == None):
                comment = ""
            # end if
        # end if
        
        # proof iban
        (okay, wert) = htype.type_proof_iban(iban)
        if (okay != hdef.OKAY):
            status = hdef.NOT_OKAY
            errtext = f"iban_data: error input iban = {iban} is not valid"
            return (status, errtext)
        # endif
        
        # if iban == 'DE88760700120500154008':
        #     a = 0
            
        # proof if iban already in
        if (not self.iban_find(iban)):
            # build iban_data_set as list data_set = [iban,bank,wer,comment]
            
            daten = None
            
            #------------------------------------
            # Bank
            #------------------------------------
            if bank == None:
                daten = self.banknamefunc.bankdatensatz_von_iban(iban)
                if self.banknamefunc.status != hdef.OKAY:
                    self.status  = self.banknamefunc.status
                    self.errtext =  self.banknamefunc.errtext
                    return (self.status, self.errtext)
                # end if
                # try:
                bank = daten["Kurzbezeichnung"]
                # except:
                #     a = 0
            # end if
            
            (okay, wert) = htype.type_transform(bank,
                                            self.par.IBAN_DATA_TYPE_LIST[self.par.IBAN_DATA_INDEX_BLZ],
                                            self.par.IBAN_DATA_STORE_TYPE_LIST[self.par.IBAN_DATA_INDEX_BLZ])

            if okay != hdef.OKAY:
                self.status  = hdef.NOT_OKAY
                self.errtext = f"BLZ zu iban: {iban} = {bank = } kann nicht gewandelt werden type_in={self.par.IBAN_DATA_TYPE_LIST[self.par.IBAN_DATA_INDEX_BANK]} => type_store={self.par.IBAN_DATA_STORE_TYPE_LIST[self.par.IBAN_DATA_INDEX_BANK]}"
                return (self.status, self.errtext)
            # end if

            # ------------------------------------
            # Wer
            # ------------------------------------
            if wer == None:
                wer = ""
            # end if

            # ------------------------------------
            # Num
            # ------------------------------------
            if num == None:
                if daten == None:
                    daten = self.banknamefunc.bankdatensatz_von_iban(iban)
                    if self.banknamefunc.status != hdef.OKAY:
                        self.status = self.banknamefunc.status
                        self.errtext = self.banknamefunc.errtext
                        return (self.status, self.errtext)
                    # end if
                # end if
                num = daten["Kontonummer"]
            # end if
            
            (okay, wert) = htype.type_transform(num,
                                                self.par.IBAN_DATA_TYPE_LIST[self.par.IBAN_DATA_INDEX_NUM],
                                                self.par.IBAN_DATA_STORE_TYPE_LIST[self.par.IBAN_DATA_INDEX_NUM])
            
            if okay != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = f"Bank zu iban: {iban} = {num = } kann nicht gewandelt werden type_in={self.par.IBAN_DATA_TYPE_LIST[self.par.IBAN_DATA_INDEX_BLZ]} => type_store={self.par.IBAN_DATA_STORE_TYPE_LIST[self.par.IBAN_DATA_INDEX_BLZ]}"
                return (self.status, self.errtext)
            # end if

            # ------------------------------------
            # BLZ
            # ------------------------------------
            if blz == None:
                if daten == None:
                    daten = self.banknamefunc.bankdatensatz_von_iban(iban)
                    if self.banknamefunc.status != hdef.OKAY:
                        self.status = self.banknamefunc.status
                        self.errtext = self.banknamefunc.errtext
                        return (self.status, self.errtext)
                    # end if
                # end if
                blz = daten["Bankleitzahl"]
            # end if
            
            (okay, wert) = htype.type_transform(blz,
                                            self.par.IBAN_DATA_TYPE_LIST[self.par.IBAN_DATA_INDEX_BLZ],
                                            self.par.IBAN_DATA_STORE_TYPE_LIST[self.par.IBAN_DATA_INDEX_BLZ])
            
            if okay != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = f"Bank zu iban: {iban} = {blz = } kann nicht gewandelt werden type_in={self.par.IBAN_DATA_TYPE_LIST[self.par.IBAN_DATA_INDEX_BLZ]} => type_store={self.par.IBAN_DATA_STORE_TYPE_LIST[self.par.IBAN_DATA_INDEX_BLZ]}"
                return (self.status, self.errtext)
            # end if
            
            tlist = htvar.build_list(self.par.IBAN_DATA_NAME_LIST,[iban,bank,wer,num,blz,comment],self.par.IBAN_DATA_STORE_TYPE_LIST)
            
            self.data_set_obj.add_data_set_tvar(tlist,self.par.LINE_COLOR_NEW)
        # endif
        
        return (self.status, self.errtext)
    
    # enddef
    def delete_data_set(self, irow):
        '''

        :param irow:
        :return: (status,errtext) = delete_data_set(irow)
        '''
        if irow < 0:
            self.status = hdef.NOT_OKAY
            self.errtext = f"IbanDataSet.delete_data_set: irow = {irow} is negative"
        
        elif irow >= self.data_set_obj.get_n_data():
            self.status = hdef.NOT_OKAY
            self.errtext = f"IbanDataSet.delete_data_set: irow = {irow} >= len(data_set_llist) = {self.data_set_obj.get_n_data()}"
        else:
            self.data_set_obj.delete_row_in_data_set(irow)
            if self.data_set_obj.status != hdef.OKAY:
                self.status = self.data_set_obj.status
                self.errtext = self.data_set_obj.errtext
            # end if
        # end if
        
        return (self.status, self.errtext)
    
    # end def


    def iban_find(self, iban):
        """
        find iban number in data_list with data_set = [iban,bank,wer,comment]
        :param iban:
        :return: True/False
        """
        
        irow_list = self.data_set_obj.find_in_col(iban, self.par.IBAN_DATA_TYPE_LIST[self.par.IBAN_DATA_INDEX_IBAN], self.par.IBAN_DATA_NAME_IBAN)
        
        if len(irow_list) == 0:
            return False
        else:
            return True
        # end if
    # enddef
# end class
# def iban_mod(data_list,d_new):
#
#     status = hdef.OKAY
#     errtext = ""
#
#     # proof what has changed and store in index_tri = [ilist,idataset,value]
#     index_tri = []
#     for i, d in enumerate(data_list):
#         if (d[I_IBAN] != d_new[i][I_IBAN]):
#             # proof iban
#             (okay, wert) = htype.type_proof_iban(d_new[i][I_IBAN])
#             if (okay != hdef.OKAY):
#                 status = hdef.NOT_OKAY
#                 errtext = f"iban_data: error input iban = {d_new[i][I_IBAN]} from Bank:{d[I_BANK]} and Comment:{d[I_COM]} is not valid"
#                 return (status, errtext,data_list)
#             else:
#                 index_tri.append((i, I_IBAN, wert))
#             # endif
#         # endif iban
#         if (d[I_BANK] != d_new[i][I_BANK]):
#             index_tri.append((i, I_BANK, d_new[i][I_BANK]))
#         # endif
#         if (d[I_WER] != d_new[i][I_WER]):
#             index_tri.append((i, I_WER, d_new[i][I_WER]))
#         # endif
#         if (d[I_COM] != d_new[i][I_COM]):
#             index_tri.append((i, I_COM, d_new[i][I_COM]))
#         # endif
#     # endif
#
#     # set changed values
#     for [i, j, value] in index_tri:
#         data_list[i][j] = value
#     # end for
#
#     return (status, errtext,data_list)
# # end def
# def iban_add_data_set(gui,header_list,data_list,id_max):
#     """
#         Use header_list[1,:] because id is automatically added
#     """
#     status = hdef.OKAY
#     errtext = ""
#
#     ddict = {}
#     ddict["liste_abfrage"] = header_list[1:]
#     ddict["title"]         =  'Neue IBAN-Nummer eingeben'
#
#     listeErgebnis = gui.abfrage_n_eingabezeilen_dict(ddict)
#
#     if (len(listeErgebnis) == 0):
#         status = hdef.NOT_OKAY
#         errtext = f"iban_data: Keine IBAN-Nummer eingegeben"
#         return (status, errtext, data_list)
#     # endif
#
#     iban = hstr.elim_ae(listeErgebnis[I_IBAN-1], ' ')
#     bank = hstr.elim_ae(listeErgebnis[I_BANK-1], ' ')
#     wer = hstr.elim_ae(listeErgebnis[I_WER-1], ' ')
#     comment = hstr.elim_ae(listeErgebnis[I_COM-1], ' ')
#
#     (okay, wert) = htype.type_proof_iban(iban)
#     if (okay != hdef.OKAY):
#         status = hdef.NOT_OKAY
#         errtext = f"iban_data: error input iban = {iban} from Bank:{bank} and Comment:{comment} is not valid"
#         return (status, errtext, data_list)
#     else:
#         iban = wert
#     # endif
#
#     (status, errtext,warntext,data_list) = iban_add(data_list, id_max, iban, bank, wer, comment)
#
#     if( len(warntext) ):
#         errtext = warntext
#         status = hdef.NOT_OKAY
#     # end if
#
#     return (status, errtext,data_list)
#
# # end def
# def iban_delete_data_set(data_list, irow):
#
#     status = hdef.OKAY
#     errtext = ""
#
#     if (irow < 0) or (irow >= len(data_list)):
#         status = hdef.NOT_OKAY
#         errtext = f"iban_data: error irow = {irow} is not in range of data_list len(data_list) = {len(data_list)}"
#         return (status, errtext, data_list)
#     else:
#         del data_list[irow]
#     # end if
#
#     return (status, errtext, data_list)
# # end def
