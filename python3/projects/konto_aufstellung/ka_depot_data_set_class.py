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

import ka_depot_wp_data_set_class as wpclass

#
# 1. Parameter dafür
#-------------------
class DepotParam:
    ISIN: str = "isin"

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
    index:int = 0
    DEPOT_DATA_INDEX_KONTO_ID = index
    index += 1
    DEPOT_DATA_INDEX_BUCHDATUM = index
    index += 1
    DEPOT_DATA_INDEX_BUCHTYPE = index
    index += 1
    DEPOT_DATA_INDEX_ISIN = index
    index += 1
    DEPOT_DATA_INDEX_ANZAHL = index
    index += 1
    DEPOT_DATA_INDEX_WERT = index
    index += 1
    DEPOT_DATA_INDEX_KOSTEN = index
    index += 1
    DEPOT_DATA_INDEX_STEUER = index
    # index += 1
    # DEPOT_DATA_INDEX_SUMWERT = index
    index += 1
    DEPOT_DATA_INDEX_KATEGORIE = index
    
    DEPOT_DATA_INDEX_LIST = [DEPOT_DATA_INDEX_KONTO_ID, DEPOT_DATA_INDEX_BUCHDATUM
        , DEPOT_DATA_INDEX_BUCHTYPE, DEPOT_DATA_INDEX_ISIN, DEPOT_DATA_INDEX_ANZAHL
        , DEPOT_DATA_INDEX_WERT, DEPOT_DATA_INDEX_KOSTEN, DEPOT_DATA_INDEX_STEUER
        , DEPOT_DATA_INDEX_KATEGORIE]
    
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
    # DEPOT_DATA_NAME_SUMWERT = "sumwert"
    DEPOT_DATA_NAME_KATEGORIE = "kategorie"
    DEPOT_DATA_NAME_WP_NAME = "wp_name"
    DEPOT_DATA_NAME_ZAHLTDIV = "zahltdiv"
    
    DEPOT_DATA_LLIST = [
        [DEPOT_DATA_INDEX_KONTO_ID, DEPOT_DATA_NAME_KONTO_ID, "int"],
        [DEPOT_DATA_INDEX_BUCHDATUM, DEPOT_DATA_NAME_BUCHDATUM, "dat"],
        [DEPOT_DATA_INDEX_BUCHTYPE, DEPOT_DATA_NAME_BUCHTYPE, DEPOT_BUCHTYPE_INDEX_LIST],
        [DEPOT_DATA_INDEX_ISIN, DEPOT_DATA_NAME_ISIN, "isin"],
        [DEPOT_DATA_INDEX_ANZAHL, DEPOT_DATA_NAME_ANZAHL, "int"],
        [DEPOT_DATA_INDEX_WERT, DEPOT_DATA_NAME_WERT, "cent"],
        [DEPOT_DATA_INDEX_KOSTEN, DEPOT_DATA_NAME_KOSTEN, "cent"],
        [DEPOT_DATA_INDEX_STEUER, DEPOT_DATA_NAME_STEUER, "cent"],
        [DEPOT_DATA_INDEX_KATEGORIE, DEPOT_DATA_NAME_KATEGORIE, "str"],
    ]
    # [DEPOT_DATA_INDEX_SUMWERT, DEPOT_DATA_NAME_SUMWERT, "cent"],
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
    
    DEPOT_WP_STORE_PATH = "."
    DEPOT_WP_USE_JSON   = False
    

class DepotDataSet:
    def __init__(self,depot_name,isin_liste,wp_func_obj):
    
        self.depot_name = depot_name
        self.par = DepotParam()
        
        self.DEPOT_DATA_TO_SHOW_DICT = {}
    
        self.status = hdef.OK
        self.errtext = ""
        self.infotext = ""
        
        
        self.wp_data_obj_dict  = {}
        self.n_wp_data_obj     = 0
        for isin in isin_liste:
            self.wp_data_obj_dict[isin] = None
            self.n_wp_data_obj += 1
            
        self.wp_func_obj = wp_func_obj
    
    # def set_data_show_dict_list(self,dat_set_index: int):
    #     self.DEPOT_DATA_TO_SHOW_DICT[dat_set_index] = self.DEPOT_DATA_ITEM_LIST[dat_set_index]
    
    # end def
    def delete_infotext(self):
        self.infotext = ""
    # end def
    def set_stored_wp_data_set_dict(self,isin,depot_wp_name,wp_data_set_dict):
        '''
        
        Die gespeicherten Daten aus pickle werden an interne Datenbank übergeben
        init-Phase
        
        :param isin:
        :param depot_wp_name:
        :param wp_data_set_dict:
        :return: self.set_stored_wp_data_set_dict(self,isin,depot_wp_name,wp_data_set_dict)
        '''
        if isin not in self.wp_data_obj_dict.keys():
            raise Exception(f"isin: {isin} ist nicht in wp_data_obj_dict")
        elif self.wp_data_obj_dict.keys[isin] is not None:
            raise Exception(f"set_stored_wp_data_set_dict: isin: {isin} ist doppelt")
        else:
            wp_obj = self.get_wp_data_obj(isin)
            if wp_obj.status != hdef.OKAY:
                raise Exception(f"set_stored_wp_data_set_dict: isin: {isin} Problem Erstellen Data Klasse {wp_obj.errtext}")
            wp_obj.set_stored_wp_data_set_dict(wp_data_set_dict)
            if wp_obj.status != hdef.OKAY:
                raise Exception(
                    f"set_stored_wp_data_set_dict: isin: {isin} Problem Füllen Data Klasse {wp_obj.errtext}")
        # end if
    # end def
    def get_wp_data_set_dict_to_store(self,isin):
        '''

        Die interne Daten für Datenspeicherung mit pickle vorbereiten
        Ende
        
        :param isin:
        :return: wp_data_set_dict = self.get_wp_data_set_dict_to_store(isin)
        '''
        
        if isin not in self.wp_data_obj_dict.keys():
            raise Exception(f"get_wp_data_set_dict_to_store: isin: {isin} ist nicht dictonary self.wp_data_obj_dict")
        else:
            wp_data_set_dict =  self.wp_data_obj_dict[isin].get_wp_data_set_dict_to_store()
        # end if
        
        return wp_data_set_dict
    def get_to_store_isin_list(self):
        return list(self.wp_data_obj_dict.keys())
    # end def
    def get_to_store_depot_wp_name_list(self):
        
        liste = []
        for isin in self.wp_data_obj_dict.keys():
            
            liste.append(self.wp_data_obj_dict[isin].get_depot_wp_name())
        
        return liste
        
    # end def
    def get_wp_data_set_dict_to_store(self,isin):
        '''
        
        :param isin:
        :return: ddict = self.get_wp_data_set_dict_to_store(isin)
        '''
        
        if isin in self.wp_data_obj_dict.keys():
            return self.wp_data_obj_dict[isin].get_wp_data_set_dict_to_store()
        else:
            self.status = hdef.NOT_OKAY
            self.errtext = f"get_wp_data_set_dict_to_store: isin = {isin} not inwp_data_obj_dict"
            return {}
        # end def
    # end def
    def update_from_konto_data(self,konto_obj):
        '''
        
        :return:
        '''
        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""
        
        n = konto_obj.get_number_of_data()
        flag_read = False
        new_data_dict_list = []
        for i in range(n):
            buchtype_str = konto_obj.get_buchtype_str(i)
            
            if buchtype_str in self.par.DEPOT_DATA_BUCHTYPE_DICT.values():
                
                buch_type \
                    = self.par.DEPOT_BUCHTYPE_INDEX_LIST[
                    self.par.DEPOT_BUCHTYPE_TEXT_LIST.index(buchtype_str)]
                
                (new_data_dict, new_header_dict, new_type_dict) = self.get_konto_data_at_i(i,buch_type,konto_obj)
                
                (flag_read,isin) = self.proof_raw_dict_isin_id(new_data_dict)
                if self.status != hdef.OKAY:
                    return
                # end if
                
                if flag_read:
                    self.wp_data_obj_dict[isin].add_data_set_dict_to_table(new_data_dict,new_header_dict,new_type_dict)
                    
                    if self.wp_data_obj_dict[isin].status != hdef.OKAY:
                        self.status = hdef.NOT_OKAY
                        self.errtext = self.wp_data_obj_dict[isin].errtext
                        return
                    # end if
                # end if
            # end if
            
        # end for
        
        if not flag_read:
            if n == 0:
                self.infotext = f"Im Konto: <{konto_obj.set_konto_name()}> sind keine Daten vorhanden"
            else:
                self.infotext = f"Vom Konto: <{konto_obj.set_konto_name()}> keine neuen Daten eingelesen"
            # end if
        else:
            self.infotext = f"Vom Konto: <{konto_obj.set_konto_name()}> n: {n} neuen Daten eingelesen"
        # end if
    # end if
    def get_konto_data_at_i(self,i,buch_type,konto_obj):
        '''
        
        :param i:
        :param buch_type:
        :return:  (new_data_dict,new_header_dict,new_type_dict) = self.get_konto_data_at_i(i,buch_type,konto_obj)
        '''
        new_data_dict = {}
        new_type_dict = {}
        new_header_dict = {}
        for index in self.par.DEPOT_KONTO_DATA_INDEX_LIST:
            
            # buchtype
            if index == self.par.DEPOT_DATA_INDEX_BUCHTYPE:
                new_data_dict[index] = buch_type
            else: # sonst
                new_data_dict[index] = konto_obj.get_data_item_at_i(i,self.par.DEPOT_DATA_NAME_DICT[index],self.par.DEPOT_DATA_TYPE_DICT[index])
            # end if
            new_type_dict[index] = self.par.DEPOT_DATA_TYPE_DICT[index]
            new_header_dict[index] = self.par.DEPOT_DATA_NAME_DICT[index]
        # end ofr
        
        return (new_data_dict,new_header_dict,new_type_dict)
    # end def
    def proof_raw_dict_isin_id(self,new_data_dict):
        '''
        Prüft ob isin okay und ob isin es Stammdaten vorhanden und ob schon ein wp-objekt angelegt ist
        
        :param raw_data_dict:
        :return: (flag,isin_index) = self.get_from_konto_data_raw_dict(raw_data_dict,new_type_dict)
        '''
        
        # proof isin
        # -----------
        (okay, isin) = htype.type_proof(new_data_dict[self.par.DEPOT_DATA_INDEX_ISIN]
                                          ,self.par.DEPOT_DATA_TYPE_DICT[self.par.DEPOT_DATA_INDEX_ISIN])
        if okay != hdef.OKAY:
            self.status  = okay
            self.errtext = f"proof_raw_dict_isin_id: isin: <{new_data_dict[self.par.DEPOT_DATA_INDEX_ISIN]}> has not correct type: <{self.DEPOT_DATA_TYPE_DICT[self.DEPOT_DATA_INDEX_ISIN]}> !!!"
            return (False,-1)
        # end if
        
        # search isin in self.wp class
        wp_obj = self.get_wp_data_obj(isin)
        if self.status != hdef.OKAY:
            return (False,isin)
        # end if
        
        # proof id in data object
        if wp_obj.exist_id_in_table(new_data_dict[self.par.DEPOT_DATA_INDEX_KONTO_ID]):
            flag = False
        else:
            flag = True
            
        return (flag,isin)
    # end def
    def get_wp_data_obj(self,isin):
        
        if isin not in self.wp_data_obj_dict.keys():
            depot_wp_name = self.depot_name + "_" + isin
            self.wp_data_obj_dict[isin] = wpclass.WpDataSet(isin,depot_wp_name,self.par,self.wp_func_obj)
            if self.wp_data_obj_dict[isin].status != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = self.wp_data_obj_dict[isin].errtext
                return None
            # end if
            self.n_wp_data_obj += 1
        return self.wp_data_obj_dict[isin]
    # end def
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
    # end def
    def get_depot_daten_sets_overview(self):
        '''
        hole von jedem WP die Zusammenfassungen
        :return: (data_lliste, header_liste,type_liste) = self.get_depot_daten_sets_overview()
        '''
        
        
        header_liste = [self.par.DEPOT_DATA_NAME_ISIN,
                        self.par.DEPOT_DATA_NAME_WP_NAME,
                        self.par.DEPOT_DATA_NAME_ZAHLTDIV,
                        self.par.DEPOT_DATA_NAME_ANZAHL]
        type_liste = ["isin",
                      "str",
                      "int"
                      "int"]
        data_lliste = []
        for isin in self.wp_data_obj_dict.keys():
            dataliste = []
            
            # 1. isin
            #---------
            dataliste.append(isin)
            
            # 2. Name
            #--------
            name = self.wp_data_obj_dict[isin].get_name()
            dataliste.append(isin)
            
            # 3. Zahlt Dividende
            dataliste.append(self.wp_data_obj_dict[isin].get_zahltdiv())

            # 4. Anzahl
            dataliste.append(self.wp_data_obj_dict[isin].get_summen_anzahl())

            data_lliste.append(dataliste)
        # end for
        
        return (data_lliste, header_liste,type_liste)

        
    # end def
# end class