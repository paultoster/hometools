#
#
#   beinhaltet die data_llist ´für eingelesene DepotDaten und funktion dafür
#
import os, sys
import copy

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif


import hfkt_def as hdef
import hfkt_type as htype
import ka_data_class_defs
#
# 1. Parameter dafür
#-------------------
class DepotDataSet:
    
    # BUchungs Typ
    DEPOT_BUCHTYPE_INDEX_UNBEKANNT: int = 0
    DEPOT_BUCHTYPE_INDEX_WP_KAUF: int = 1
    DEPOT_BUCHTYPE_INDEX_WP_VERKAUF: int = 2
    DEPOT_BUCHTYPE_INDEX_WP_KOSTEN: int = 3
    DEPOT_BUCHTYPE_INDEX_WP_EINNAHMEN: int = 4
    
    DEPOT_DATA_BUCHTYPE_DICT = {DEPOT_BUCHTYPE_INDEX_UNBEKANNT: "unbekannt"
        , DEPOT_BUCHTYPE_INDEX_WP_KAUF: "wp_kauf"
        , DEPOT_BUCHTYPE_INDEX_WP_VERKAUF: "wp_verkauf"
        , DEPOT_BUCHTYPE_INDEX_WP_KOSTEN: "wp_kosten"
        , DEPOT_BUCHTYPE_INDEX_WP_EINNAHMEN: "wp_einnahmen"}
    
    DEPOT_BUCHTYPE_TEXT_LIST = []
    DEPOT_BUCHTYPE_INDEX_LIST = []
    for key in DEPOT_DATA_BUCHTYPE_DICT.keys():
        DEPOT_BUCHTYPE_TEXT_LIST.append(DEPOT_DATA_BUCHTYPE_DICT[key])
        DEPOT_BUCHTYPE_INDEX_LIST.append(key)
    # end for
    
    # Indizes in erinem data_set
    DEPOT_DATA_INDEX_KONTO_ID: int = 0
    DEPOT_DATA_INDEX_BUCHDATUM: int = 1
    DEPOT_DATA_INDEX_BUCHTYPE: int = 2
    DEPOT_DATA_INDEX_ISIN: int = 3
    DEPOT_DATA_INDEX_ANZAHL: int = 4
    DEPOT_DATA_INDEX_WERT: int = 5
    DEPOT_DATA_INDEX_KOSTEN: int = 6
    DEPOT_DATA_INDEX_STEUER: int = 7
    DEPOT_DATA_INDEX_SUMWERT: int = 8
    DEPOT_DATA_INDEX_KATEGORIE: int = 9
    
    DEPOT_DATA_INDEX_LIST = [DEPOT_DATA_INDEX_KONTO_ID, DEPOT_DATA_INDEX_BUCHDATUM
        , DEPOT_DATA_INDEX_BUCHTYPE, DEPOT_DATA_INDEX_ISIN, DEPOT_DATA_INDEX_ANZAHL
        , DEPOT_DATA_INDEX_WERT, DEPOT_DATA_INDEX_KOSTEN, DEPOT_DATA_INDEX_STEUER
        , DEPOT_DATA_INDEX_SUMWERT, DEPOT_DATA_INDEX_KATEGORIE]
    
    # Diese Daten kommen vom Konto
    DEPOT_KONTO_DATA_INDEX_LIST = [DEPOT_DATA_INDEX_KONTO_ID, DEPOT_DATA_INDEX_BUCHDATUM
        , DEPOT_DATA_INDEX_BUCHTYPE, DEPOT_DATA_INDEX_ISIN, DEPOT_DATA_INDEX_WERT]
    
    DEPOT_DATA_NAME_KONTO_ID: str = "id"
    DEPOT_DATA_NAME_BUCHDATUM = "buchdatum"
    DEPOT_DATA_NAME_BUCHTYPE = "buchtype"
    DEPOT_DATA_NAME_ISIN = "isin"
    DEPOT_DATA_NAME_ANZAHL = "anzahl"
    DEPOT_DATA_NAME_WERT = "wert"
    DEPOT_DATA_NAME_KOSTEN = "kosten"
    DEPOT_DATA_NAME_STEUER = "steuer"
    DEPOT_DATA_NAME_SUMWERT = "sumwert"
    DEPOT_DATA_NAME_KATEGORIE = "kategorie"
    
    DEPOT_DATA_LLIST = [
        [DEPOT_DATA_INDEX_KONTO_ID, DEPOT_DATA_NAME_KONTO_ID, "int"],
        [DEPOT_DATA_INDEX_BUCHDATUM, DEPOT_DATA_NAME_BUCHDATUM, "dat"],
        [DEPOT_DATA_INDEX_BUCHTYPE, DEPOT_DATA_NAME_BUCHTYPE, DEPOT_BUCHTYPE_INDEX_LIST],
        [DEPOT_DATA_INDEX_ISIN, DEPOT_DATA_NAME_ISIN, "str"],
        [DEPOT_DATA_INDEX_ANZAHL, DEPOT_DATA_NAME_ANZAHL, "int"],
        [DEPOT_DATA_INDEX_WERT, DEPOT_DATA_NAME_WERT, "cent"],
        [DEPOT_DATA_INDEX_KOSTEN, DEPOT_DATA_NAME_KOSTEN, "cent"],
        [DEPOT_DATA_INDEX_STEUER, DEPOT_DATA_NAME_STEUER, "cent"],
        [DEPOT_DATA_INDEX_SUMWERT, DEPOT_DATA_NAME_SUMWERT, "cent"],
        [DEPOT_DATA_INDEX_KATEGORIE, DEPOT_DATA_NAME_KATEGORIE, "str"],
    ]
    DEPOT_DATA_NAME_DICT = {}
    DEPOT_DATA_TYPE_DICT = {}
    DEPOT_DATA_NAME_LIST = []
    DEPOT_DATA_TYPE_LIST = []
    # DEPOT_DATA_INDEX_LIST = []
    for liste in DEPOT_DATA_LLIST:
        DEPOT_DATA_NAME_DICT[liste[0]] = liste[1]
        DEPOT_DATA_TYPE_DICT[liste[0]] = liste[2]
        DEPOT_DATA_NAME_LIST.append(liste[1])
        DEPOT_DATA_TYPE_LIST.append(liste[2])
        # DEPOT_DATA_INDEX_LIST.append(liste[0])
    
    # end for
    
    
    OKAY = hdef.OK
    NOT_OKAY = hdef.NOT_OK
    
    
    def __init__(self,depot_name):
    
        self.depot_name = depot_name
        self.DEPOT_DATA_TO_SHOW_DICT = {}
    
        self.status = hdef.OK
        self.errtext = ""
        self.infotext = ""
        self.depot_start_datum: int = 0
        self.DECIMAL_TRENN_STR: str = ","
        self.TAUSEND_TRENN_STR: str = "."
        self.isin_list = []
        self.isin_data_obj_list  = []
        self.n_isin_list = 0
        self.konto_obj = None
    # def set_data_show_dict_list(self,dat_set_index: int):
    #     self.DEPOT_DATA_TO_SHOW_DICT[dat_set_index] = self.DEPOT_DATA_ITEM_LIST[dat_set_index]
    # # enddef

    def set_stored_data(self,isin_list,depot_data_set_dict_list,depot_data_type_dict):
        
        # lösche objekte, wenn vorhanden
        if len(self.isin_data_obj_list):
            del self.isin_data_obj_list
            self.isin_data_obj_list = []
        # end if
        
        self.isin_list   = copy.deepcopy(isin_list)
        self.n_isin_list = len(isin_list)
        
        self.isin_data_obj_list = []
        for isin in self.isin_list:
            data_dict_list = self.filter_isin_data_set_dict_list(isin,depot_data_set_dict_list)

            isin_obj = self.build_isin_data_obj(isin)
            if self.status != hdef.OKAY:
                return
            isin_obj.set_dat_set_named_dict_list(data_dict_list,depot_data_type_dict)
            if isin_obj.status != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = isin_obj.errtext
                return
            self.isin_data_obj_list.append(isin_obj)
        # end for
    # end def
    def get_to_store_data_isin_list(self):
        return self.isin_list
    # end def
    def set_konto_obj(self,konto_obj):
        self.konto_obj = konto_obj
    # end def
    def update_konto_data(self):
        '''
        
        :return:
        '''
        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""
        
        n = self.konto_obj.get_num_data()
        flag = False
        new_data_dict_list = []
        for i in range(n):
            buchtype_str = self.konto_obj.get_buchtype_str(i)
            
            if buchtype_str in self.DEPOT_DATA_BUCHTYPE_DICT.values():
                (new_data_dict, new_type_dict) = self.get_konto_data_at_i(i,buchtype_str)
                
                (flag,isin_index) = self.proof_raw_dict_isin_id(new_data_dict)
                if self.status != hdef.OKAY:
                    return
                # end if
                
                if flag:
                    self.isin_data_obj_list[isin_index].add_data_set_dict(new_data_dict,new_type_dict)
                    
                    if self.isin_data_obj_list[isin_index].status != hdef.OKAY:
                        self.status = hdef.NOT_OKAY
                        self.errtext = self.isin_data_obj_list[isin_index].errtext
                        return
                    # end if
                # end if
            # end if
            
        # end for
        
        if not flag:
            if n == 0:
                self.infotext = f"Im Konto: <{self.konto_obj.set_konto_name()}> sind keine Daten vorhanden"
            else:
                self.infotext = f"Vom Konto: <{self.konto_obj.set_konto_name()}> keine neuen daten eingelesen"
            # end if
        # end if
    # end if
    def get_konto_data_at_i(self,i,buchtype_str):
        '''
        
        :param i:
        :param buchtype_str:
        :return:  (new_data_dict,new_type_dict) = self.get_konto_data_at_i(i,buchtype_str)
        '''
        new_data_dict = {}
        new_type_dict = {}
        for index in self.DEPOT_KONTO_DATA_INDEX_LIST:
            
            # buchtype
            if index == self.DEPOT_DATA_INDEX_BUCHTYPE:
                new_data_dict[index] = self.DEPOT_BUCHTYPE_INDEX_LIST[self.DEPOT_BUCHTYPE_TEXT_LIST.index(buchtype_str)]
            else: # sonst
                new_data_dict[index] = self.konto_obj.get_data_item_at_i(i,self.DEPOT_DATA_NAME_DICT[index],self.DEPOT_DATA_TYPE_DICT[index])
            # end if
            new_type_dict[index] = self.DEPOT_DATA_TYPE_DICT[index]
        # end ofr
        
        return (new_data_dict,new_type_dict)
    # end def
    def proof_raw_dict_isin_id(self,new_data_dict):
        '''
        
        :param raw_data_dict:
        :return: (flag,isin_index) = self.get_from_konto_data_raw_dict(raw_data_dict,new_type_dict)
        '''
        
        flag = False
        
        # proof isin
        # -----------
        (okay, value) = htype.type_proof(new_data_dict[self.DEPOT_DATA_INDEX_ISIN]
                                          ,self.DEPOT_DATA_TYPE_DICT[self.DEPOT_DATA_INDEX_ISIN])
        if okay != hdef.OKAY:
            self.status  = okay
            self.errtext = f"proof_raw_dict_isin_id: isin: <{new_data_dict[self.DEPOT_DATA_INDEX_ISIN]}> has not correct type: <{self.DEPOT_DATA_TYPE_DICT[self.DEPOT_DATA_INDEX_ISIN]}> !!!"
            return (flag,-1)
        # end if
        
        # search isin in self.isin_list
        if value not in self.isin_list:
            # build data object for isin
            self.isin_data_obj_list.append(self.build_isin_data_obj(value))
            if self.status != hdef.OKAY:
                return
            self.isin_list.append(value)
            self.n_isin_list += 1
        # edn if
        
        # get index
        isin_index = self.isin_list.index(value)
        
        # proof id in data object
        new_id = new_data_dict[self.DEPOT_DATA_INDEX_KONTO_ID]
        
        liste = self.isin_data_obj_list[isin_index].find_in_col(new_id, self.DEPOT_DATA_TYPE_DICT[self.DEPOT_DATA_INDEX_KONTO_ID], self.DEPOT_DATA_INDEX_KONTO_ID)
        if self.isin_data_obj_list[isin_index].status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.isin_data_obj_list[isin_index].errtext
            return (flag,isin_index)
        # end if
        
        # wenn liste gefüllt, dann existiert id schon
        if len(liste) == 0:
            flag = True
        # end if
        
        return (flag,isin_index)
    # end def
    def build_isin_data_obj(self,isin):
        isin_data_obj = ka_data_class_defs.DataSet(isin)
        for index in self.DEPOT_DATA_NAME_DICT.keys():
            isin_data_obj.set_definition(index, self.DEPOT_DATA_NAME_DICT[index], self.DEPOT_DATA_TYPE_DICT[index])
            if isin_data_obj.status != hdef.OKAY:
                self.status = isin_data_obj.status
                self.errtext = isin_data_obj.errtext
                break
            # end if
        # end for
        return isin_data_obj
    def get_data_set_dict_list(self):
        '''
        
        :return:
        '''
        data_dict_list = []
        for i in range(self.n_isin_list):
            dict_liste = self.isin_data_obj_list[i].get_data_set_dict_list()
            data_dict_list += dict_liste
        # end for
        return data_dict_list
    # end def
    def get_data_type_dict(self):
        '''
        
        :return:
        '''
        if( self.n_isin_list):
            data_type_dict = self.isin_data_obj_list[0].get_data_type_dict()
        else:
            data_type_dict = {}
        # end if
        
        return data_type_dict
    # end def
    def filter_isin_data_set_dict_list(self,isin,depot_data_set_dict_list):
        '''
        
        :param isin:
        :param depot_data_set_dict_list:
        :return: data_dict_list = self.filter_isin_data_set_dict_list(isin,depot_data_set_dict_list)
        '''
        data_dict_list = []
        for ddict in depot_data_set_dict_list:
            if isin == ddict[self.DEPOT_DATA_NAME_ISIN]:
                data_dict_list.append(ddict)
            # end if
        # end for
        return data_dict_list
# end class