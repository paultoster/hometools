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

import depot_depot_wp_data_set_class as wpclass

#
# 1. Parameter dafür
#-------------------
class DepotParam:
    ISIN: str = "isin"
    WP_NAME: str = "wp_name"
    WP_KATEGORIE: str = "wp_kategorie"
    WP_DATA_SET_DICT_LIST: str = "wp_data_set_dict_list"
    WP_DATA_SET_NAME_DICT: str = "wp_data_set_name_dict"
    WP_DATA_SET_TYPE_DICT: str = "wp_data_set_type_dict"
    # BUchungs Typ
    DEPOT_BUCHTYPE_INDEX_UNBEKANNT: int = 0
    DEPOT_BUCHTYPE_INDEX_WP_KAUF: int = 1
    DEPOT_BUCHTYPE_INDEX_WP_VERKAUF: int = 2
    DEPOT_BUCHTYPE_INDEX_WP_KOSTEN: int = 3
    DEPOT_BUCHTYPE_INDEX_WP_EINNAHMEN: int = 4

    DEPOT_BUCHTYPE_NAME_UNBEKANNT: str = "unbekannt"
    DEPOT_BUCHTYPE_NAME_WP_KAUF: str = "wp_kauf"
    DEPOT_BUCHTYPE_NAME_WP_VERKAUF: str = "wp_verkauf"
    DEPOT_BUCHTYPE_NAME_WP_KOSTEN: str = "wp_kosten"
    DEPOT_BUCHTYPE_NAME_WP_EINNAHMEN: str = "wp_einnahmen"

    DEPOT_DATA_BUCHTYPE_DICT = {DEPOT_BUCHTYPE_INDEX_UNBEKANNT: DEPOT_BUCHTYPE_NAME_UNBEKANNT
        , DEPOT_BUCHTYPE_INDEX_WP_KAUF: DEPOT_BUCHTYPE_NAME_WP_KAUF
        , DEPOT_BUCHTYPE_INDEX_WP_VERKAUF: DEPOT_BUCHTYPE_NAME_WP_VERKAUF
        , DEPOT_BUCHTYPE_INDEX_WP_KOSTEN: DEPOT_BUCHTYPE_NAME_WP_KOSTEN
        , DEPOT_BUCHTYPE_INDEX_WP_EINNAHMEN: DEPOT_BUCHTYPE_NAME_WP_EINNAHMEN}

    DEPOT_BUCHTYPE_TEXT_LIST = []
    DEPOT_BUCHTYPE_INDEX_LIST = []
    for key in DEPOT_DATA_BUCHTYPE_DICT.keys():
        DEPOT_BUCHTYPE_TEXT_LIST.append(DEPOT_DATA_BUCHTYPE_DICT[key])
        DEPOT_BUCHTYPE_INDEX_LIST.append(key)
    # end for
    DEPOT_DATA_NAME_KONTO_ID: str = "id"
    DEPOT_DATA_NAME_BUCHDATUM = "buchdatum"
    DEPOT_DATA_NAME_BUCHTYPE = "buchtype"
    DEPOT_DATA_NAME_ISIN = "isin"
    DEPOT_DATA_NAME_ANZAHL = "anzahl"
    DEPOT_DATA_NAME_KURS = "kurs"
    DEPOT_DATA_NAME_WERT = "wert"
    DEPOT_DATA_NAME_KOSTEN = "kosten"
    DEPOT_DATA_NAME_STEUER = "steuer"
    # DEPOT_DATA_NAME_SUMWERT = "sumwert"

    DEPOT_DATA_INDEX_LIST = []
    DEPOT_DATA_LLIST = []
    # Indizes in erinem data_set
    index:int = 0
    DEPOT_DATA_INDEX_KONTO_ID = index
    DEPOT_DATA_INDEX_LIST.append(index)
    DEPOT_DATA_LLIST.append([index, DEPOT_DATA_NAME_KONTO_ID, "int","int"])
    index += 1
    DEPOT_DATA_INDEX_BUCHDATUM = index
    DEPOT_DATA_INDEX_LIST.append(index)
    DEPOT_DATA_LLIST.append([index, DEPOT_DATA_NAME_BUCHDATUM, "dat","datStrP"])
    index += 1
    DEPOT_DATA_INDEX_ISIN = index
    DEPOT_DATA_INDEX_LIST.append(index)
    DEPOT_DATA_LLIST.append([index, DEPOT_DATA_NAME_ISIN, "isin","isin"])
    index += 1
    DEPOT_DATA_INDEX_BUCHTYPE = index
    DEPOT_DATA_INDEX_LIST.append(index)
    DEPOT_DATA_LLIST.append([index, DEPOT_DATA_NAME_BUCHTYPE, DEPOT_BUCHTYPE_INDEX_LIST,DEPOT_BUCHTYPE_TEXT_LIST])
    index += 1
    DEPOT_DATA_INDEX_ANZAHL = index
    DEPOT_DATA_INDEX_LIST.append(index)
    DEPOT_DATA_LLIST.append([index, DEPOT_DATA_NAME_ANZAHL, "float","float"])
    index += 1
    DEPOT_DATA_INDEX_KURS = index
    DEPOT_DATA_INDEX_LIST.append(index)
    DEPOT_DATA_LLIST.append([index, DEPOT_DATA_NAME_KURS, "cent","euroStrK"])
    index += 1
    DEPOT_DATA_INDEX_WERT = index
    DEPOT_DATA_INDEX_LIST.append(index)
    DEPOT_DATA_LLIST.append([index, DEPOT_DATA_NAME_WERT, "cent","euroStrK"])
    index += 1
    DEPOT_DATA_INDEX_KOSTEN = index
    DEPOT_DATA_INDEX_LIST.append(index)
    DEPOT_DATA_LLIST.append([index, DEPOT_DATA_NAME_KOSTEN, "cent","euroStrK"])
    index += 1
    DEPOT_DATA_INDEX_STEUER = index
    DEPOT_DATA_INDEX_LIST.append(index)
    DEPOT_DATA_LLIST.append([index, DEPOT_DATA_NAME_STEUER, "cent","euroStrK"])
    # index += 1
    # DEPOT_DATA_INDEX_SUMWERT = index
    # index += 1
    # DEPOT_DATA_INDEX_KATEGORIE = index
    
    # Diese Daten kommen vom Konto
    DEPOT_KONTO_DATA_INDEX_LIST = [DEPOT_DATA_INDEX_KONTO_ID,
                                   DEPOT_DATA_INDEX_BUCHDATUM,
                                   DEPOT_DATA_INDEX_ISIN,
                                   DEPOT_DATA_INDEX_BUCHTYPE,
                                   DEPOT_DATA_INDEX_WERT]
    
    DEPOT_DATA_IMMUTABLE_INDEX_LIST = [DEPOT_DATA_INDEX_KONTO_ID,
                                       DEPOT_DATA_INDEX_BUCHDATUM,
                                       DEPOT_DATA_INDEX_ISIN,
                                       DEPOT_DATA_INDEX_WERT]
    

    # [DEPOT_DATA_INDEX_SUMWERT, DEPOT_DATA_NAME_SUMWERT, "cent"],
    DEPOT_DATA_NAME_DICT = {}
    DEPOT_DATA_TYPE_DICT = {}
    DEPOT_DATA_STORE_TYPE_DICT = {}
    DEPOT_DATA_NAME_LIST = []
    DEPOT_DATA_TYPE_LIST = []
    
    # DEPOT_DATA_INDEX_LIST = []
    for liste in DEPOT_DATA_LLIST:
        DEPOT_DATA_NAME_DICT[liste[0]] = liste[1]
        DEPOT_DATA_TYPE_DICT[liste[0]] = liste[2]
        DEPOT_DATA_STORE_TYPE_DICT[liste[0]] = liste[3]
        DEPOT_DATA_NAME_LIST.append(liste[1])
        DEPOT_DATA_TYPE_LIST.append(liste[2])
        
        # DEPOT_DATA_INDEX_LIST.append(liste[0])
    
    # end for
    
    DEPOT_DATA_NAME_KATEGORIE = "kategorie"
    DEPOT_DATA_NAME_WP_NAME = "wp_name"
    DEPOT_DATA_NAME_ZAHLTDIV = "zahltdiv"
    DEPOT_DATA_NAME_EINNAHME = "einnahme"
    DEPOT_DATA_NAME_KURSWERT = "kurswert"
    DEPOT_DATA_NAME_DEPOT    = "depot"

    DEPOT_WP_STORE_PATH = "."
    DEPOT_WP_USE_JSON   = False
    
    LINE_COLOR_NEW = "aquamarine1"  # "aliceblue"
    LINE_COLOR_EDIT = "orange1"
    
    DEPOT_SHOW_TYPE_INDEX_ALL = 0
    DEPOT_SHOW_TYPE_INDEX_ACTIVE = 1
    DEPOT_SHOW_TYPE_INDEX_INACTIVE = 2
    
    DEPOT_KKATEGORIE_LEER = "leer"


class DepotDataSet:
    def __init__(self,depot_name,isin_liste,wp_func_obj):
    
        self.depot_name = depot_name
        self.par = DepotParam()
        
        self.DEPOT_DATA_TO_SHOW_DICT = {}
    
        self.status = hdef.OK
        self.errtext = ""
        self.infotext = ""

        self.wp_func_obj = wp_func_obj
        
        self.isin_liste = sorted(isin_liste)
        self.wp_data_obj_dict  = {}
        self.wp_color_dict     = {}   # sets color if isin is new or stores new data
        self.n_wp_data_obj     = 0
        for isin in self.isin_liste:
            
            self.wp_data_obj_dict[isin] = self.build_wp_data_obj(isin)
            if self.status == hdef.OKAY:
                self.n_wp_data_obj += 1
                self.wp_color_dict[isin] = self.par.LINE_COLOR_NEW
    
    # def set_data_show_dict_list(self,dat_set_index: int):
    #     self.DEPOT_DATA_TO_SHOW_DICT[dat_set_index] = self.DEPOT_DATA_ITEM_LIST[dat_set_index]
    
    # end def
    def reset_status(self):
        
        self.status = hdef.OKAY
        self.errtext = ""
        
        for isin in self.isin_liste:
            self.wp_data_obj_dict[isin].reset_status()
        # end for
    # end def
    def reset_infotext(self):
        self.infotext = ""
    # end def
    def delete_infotext(self):
        self.infotext = ""
    # end def
    def get_kategorie(self,isin):
        if isin in self.isin_liste:
            kategorie = self.wp_data_obj_dict[isin].get_kategorie()
        else:
            raise Exception(f"get_kategorie: isin = {isin} nicht vorhanden")
        # end if
        return kategorie
    # end def
    def get_kategorie_liste(self):
        '''

        :return: kategorie_liste = self.get_kategorie_liste()
        '''
        kategorie_liste = []
        for isin in self.isin_liste:
            kategorie = self.wp_data_obj_dict[isin].get_kategorie()
            kategorie_liste.append(kategorie)
        # end for
        
        kategorie_liste = list(set(kategorie_liste))
        
        return kategorie_liste
    
    # end def
    def set_kategorie(self,isin,kategorie):
        if isin in self.isin_liste:
            self.wp_data_obj_dict[isin].set_kategorie(kategorie)
            self.wp_color_dict[isin] = self.par.LINE_COLOR_EDIT
        else:
            raise Exception(f"set_kategorie: isin = {isin} nicht vorhanden")
        # end if
        return
    # end def
    def get_isin_liste(self):
        '''
        
        :return: isin_liste = self.get_isin_liste()
        '''
        return self.isin_liste
    def get_depot_name(self):
        return self.depot_name
    # end def
    def set_stored_wp_data_set_dict(self,wp_data_set_dict):
        '''
        
        Die gespeicherten Daten aus pickle werden an interne Datenbank übergeben
        init-Phase
        
        :param isin:
        :param depot_wp_name:
        :param wp_data_set_dict:
        :return: self.set_stored_wp_data_set_dict(self,isin,depot_wp_name,wp_data_set_dict)
        '''
        if self.par.ISIN in wp_data_set_dict:
            isin =  wp_data_set_dict[self.par.ISIN]
            # depot_wp_name = wp_data_set_dict[self.par.WP_NAME]
            
            if isin not in self.isin_liste:
                raise Exception(f"isin: {isin} ist nicht in wp_data_obj_dict")
            else:
                wp_obj = self.get_wp_data_obj(isin)
                if wp_obj.status != hdef.OKAY:
                    raise Exception(f"set_stored_wp_data_set_dict: isin: {isin} Problem Erstellen Data Klasse {wp_obj.errtext}")
                wp_obj.set_stored_wp_data_set_dict(wp_data_set_dict[self.par.WP_DATA_SET_DICT_LIST],
                                                   "",
                                                   wp_data_set_dict[self.par.WP_DATA_SET_NAME_DICT],
                                                   wp_data_set_dict[self.par.WP_DATA_SET_TYPE_DICT])
                if wp_obj.status != hdef.OKAY:
                    raise Exception(
                        f"set_stored_wp_data_set_dict: isin: {isin} Problem Füllen Data Klasse {wp_obj.errtext}")
                
                self.wp_color_dict[isin] = ""
                
                if self.par.WP_KATEGORIE in wp_data_set_dict.keys():
                    wp_obj.set_kategorie(wp_data_set_dict[self.par.WP_KATEGORIE])
                # end if
            # end
        # end if
    # end def
    def get_wp_data_set_dict_to_store(self,isin):
        '''

        Die interne Daten für Datenspeicherung mit pickle vorbereiten
        Ende
        
        :param isin:
        :return: wp_data_set_dict = self.get_wp_data_set_dict_to_store(isin)
        '''
        
        if isin not in self.isin_liste:
            self.status = hdef.NOT_OKAY
            self.errtext = f"get_wp_data_set_dict_to_store: isin: {isin} ist nicht dictonary self.wp_data_obj_dict"
            wp_data_set_dict = {}
        else:
            wp_data_set_dict =  self.wp_data_obj_dict[isin].get_wp_data_set_dict_to_store()
            if self.wp_data_obj_dict[isin].status != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = self.wp_data_obj_dict[isin].errtext
            # end if
        # end if
        
        return wp_data_set_dict
    def get_to_store_isin_list(self):
        return list(self.isin_liste)
    # end def
    def get_to_store_depot_wp_name_list(self):
        
        liste = []
        for isin in self.isin_liste:
            
            liste.append(self.wp_data_obj_dict[isin].get_depot_wp_name())
        
        return liste
        
    # end def
    def get_wp_data_set_dict_to_store(self,isin):
        '''
        
        :param isin:
        :return: ddict = self.get_wp_data_set_dict_to_store(isin)
        '''
        
        if isin not in self.isin_liste:
            self.status = hdef.NOT_OKAY
            self.errtext = f"get_wp_data_set_dict_to_store: isin = {isin} not inwp_data_obj_dict"
            return {}
        # end def
        return self.wp_data_obj_dict[isin].get_wp_data_set_dict_to_store()
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
        # new_data_dict_list = []
        n_new_read = 0
        n_update   = 0
        isin_new_or_update_liste = []
        for i in range(n):
            buchtype_str = konto_obj.get_buchtype_str(i)
            
            if buchtype_str in self.par.DEPOT_DATA_BUCHTYPE_DICT.values():
                
                buch_type = self.par.DEPOT_BUCHTYPE_INDEX_LIST[self.par.DEPOT_BUCHTYPE_TEXT_LIST.index(buchtype_str)]
                
                (new_data_dict, new_header_dict, new_type_dict) = self.get_konto_data_at_i(i,buch_type,konto_obj)
                
                (flag_read,isin,id) = self.proof_raw_dict_isin_id(new_data_dict) # proof id
                if self.status != hdef.OKAY:
                    return
                # end if
                
                anzahl = self.wp_data_obj_dict[isin].get_summen_anzahl()
                
                
                if flag_read:
                    n_new_read += 1
                    self.wp_data_obj_dict[isin].add_data_set_dict_to_table(new_data_dict,new_header_dict,new_type_dict,self.par.LINE_COLOR_NEW)
                    
                    if self.wp_data_obj_dict[isin].status != hdef.OKAY:
                        self.status = hdef.NOT_OKAY
                        self.errtext = self.wp_data_obj_dict[isin].errtext
                        return
                    # end if
                    self.wp_color_dict[isin] = self.par.LINE_COLOR_EDIT
                    if isin not in isin_new_or_update_liste:
                        isin_new_or_update_liste.append(isin)
                    # end if
                    
                    # claculate anzahl as guess
                    irow = self.wp_data_obj_dict[isin].get_n_data() - 1
                    if (irow >= 0) and (anzahl is not None) and (anzahl > 0.0):
                        self.wp_data_obj_dict[isin].set_item_in_irow(anzahl, self.par.DEPOT_DATA_NAME_ANZAHL,
                                                                     'float',irow,self.par.LINE_COLOR_NEW)
                        
                else: # proof for update
                    
                    flag_update = self.wp_data_obj_dict[isin].update_item_if_different(id,new_data_dict,new_header_dict,new_type_dict,self.par.LINE_COLOR_EDIT)
                
                    if self.wp_data_obj_dict[isin].status != hdef.OKAY:
                        self.status = hdef.NOT_OKAY
                        self.errtext = self.wp_data_obj_dict[isin].errtext
                        return
                    # end if
                    
                    if flag_update:
                        n_update += 1
                        self.wp_color_dict[isin] = self.par.LINE_COLOR_EDIT
                        if isin not in isin_new_or_update_liste:
                            isin_new_or_update_liste.append(isin)
                    # end if
                # end if
            # end if
        # end for
        
        for isin in isin_new_or_update_liste:
            self.wp_data_obj_dict[isin].update_order_by_date()
        
        if n_new_read > 0:
            self.infotext = f"{self.errtext}\nVom Konto: <{konto_obj.set_konto_name()}> n_new: {n_new_read} neuen Daten eingelesen"
        # end if
        if n_update > 0:
            self.infotext = f"{self.errtext}\nVom Konto: <{konto_obj.set_konto_name()}> n_update: {n_update}  Daten upgedatet"
        # end if
        if (n_new_read == 0) and (n_update == 0):
            if n == 0:
                self.infotext = f"{self.errtext}\nIm Konto: <{konto_obj.set_konto_name()}> sind keine Daten vorhanden"
            else:
                self.infotext = f"{self.errtext}\nVom Konto: <{konto_obj.set_konto_name()}> keine neuen Daten eingelesen"
            # end if
        # end if
        return
    # end def
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
                new_data_dict[index] = konto_obj.get_data_item_at_irow(i,self.par.DEPOT_DATA_NAME_DICT[index],self.par.DEPOT_DATA_TYPE_DICT[index])
            # end if
            new_type_dict[index] = self.par.DEPOT_DATA_TYPE_DICT[index]
            new_header_dict[index] = self.par.DEPOT_DATA_NAME_DICT[index]
            
            if self.par.DEPOT_DATA_NAME_DICT[index] == self.par.DEPOT_DATA_NAME_WERT:
                    new_data_dict[index] = abs(new_data_dict[index])
            # end if
        # end ofr
        
        return (new_data_dict,new_header_dict,new_type_dict)
    # end def
    def proof_raw_dict_isin_id(self,new_data_dict):
        '''
        Prüft ob isin okay und ob isin es Stammdaten vorhanden und ob schon ein wp-objekt angelegt ist
        
        :param raw_data_dict:
        :return: (flag,isin_index,id) = self.get_from_konto_data_raw_dict(raw_data_dict,new_type_dict)
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
        
        id = new_data_dict[self.par.DEPOT_DATA_INDEX_KONTO_ID]
        # proof id in data object
        if wp_obj.exist_id_in_table(id):
            flag = False
        else:
            flag = True
            
        return (flag,isin,id)
    # end def
    def get_wp_data_obj(self,isin):
        
        if (isin not in self.isin_liste) or (self.wp_data_obj_dict[isin] is None):
            self.wp_data_obj_dict[isin] = self.build_wp_data_obj(isin)
            self.isin_liste.append(isin)
            self.isin_liste = sorted(self.isin_liste)
            if self.status != hdef.OKAY:
                return None
            # end if
            
            self.wp_color_dict[isin] = self.par.LINE_COLOR_NEW
            
            self.n_wp_data_obj += 1
        # end if
        return self.wp_data_obj_dict[isin]
    # end def
    def build_wp_data_obj(self,isin):
        '''
        
        :param isin:
        :return:
        '''
        depot_wp_name = self.depot_name + "_" + isin
        wp_obj = wpclass.WpDataSet(isin, depot_wp_name, self.par, self.wp_func_obj)
    
        if wp_obj.status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = wp_obj.errtext
        return wp_obj
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
    def get_titlename(self,isin):
        '''
        
        :return:
        '''
        if isin in self.isin_liste:
            titlename = f"Depot: {self.depot_name},WP: {isin}/{self.wp_data_obj_dict[isin].wp_info_dict['name']}/zahltdiv:{self.wp_data_obj_dict[isin].wp_info_dict['zahltdiv']}"
        else:
            titlename = f"WP: {isin}//"
        # end if
        return titlename
    # end def
    def get_depot_daten_sets_overview(self,depot_show_type):
        '''
        hole von jedem WP die Zusammenfassungen
        :param nur_was_im_depot = False alle zeigen
                                = True nur die nch im Depot sinf (anzahl > 0)
        :return: (data_lliste, header_liste,type_liste,row_color_dliste) = self.get_depot_daten_sets_overview(nur_was_im_depot)
        '''
        
        
        header_liste = [self.par.DEPOT_DATA_NAME_ISIN,
                        self.par.DEPOT_DATA_NAME_WP_NAME,
                        self.par.DEPOT_DATA_NAME_ZAHLTDIV,
                        self.par.DEPOT_DATA_NAME_ANZAHL,
                        self.par.DEPOT_DATA_NAME_WERT+" (kauf=neg)",
                        self.par.DEPOT_DATA_NAME_EINNAHME,
                        self.par.DEPOT_DATA_NAME_KURSWERT,
                        self.par.DEPOT_DATA_NAME_KATEGORIE]
        type_liste = ["isin",
                      "str",
                      "int",
                      "float",
                      "euroStrK",
                      "euroStrK",
                      "euroStrK",
                      "str"]
        
        end_zeile = htype.type_get_default(type_liste)
        data_lliste = []
        row_color_dliste = []
        
        summe_wert = 0.0
        summe_einnahmen = 0.0
        
        for isin in self.isin_liste:

            # Precalc Anzahl
            anzahl = self.wp_data_obj_dict[isin].get_summen_anzahl()
            if anzahl is None:
                self.status = self.wp_data_obj_dict[isin].status
                self.errtext = self.wp_data_obj_dict[isin].errtext
                return ([],[],[],[])
            # end if
            
            flag = False
            if depot_show_type == self.par.DEPOT_SHOW_TYPE_INDEX_ALL:
                flag = True
            elif (depot_show_type == self.par.DEPOT_SHOW_TYPE_INDEX_ACTIVE) and (anzahl > 0.01):
                flag = True
            elif (depot_show_type == self.par.DEPOT_SHOW_TYPE_INDEX_INACTIVE) and (anzahl <= 0.01):
                flag = True
            # end if
            if flag:

                dataliste = []
                
                # 1. isin
                #---------
                dataliste.append(isin)
                
                # 2. Name
                #--------
                name = self.wp_data_obj_dict[isin].get_name()
                dataliste.append(name)
                
                # 3. Zahlt Dividende
                dataliste.append(self.wp_data_obj_dict[isin].get_zahltdiv())
    
                # 4. Anzahl
                dataliste.append(anzahl)
    
                # 5. wert
                sumwert = self.wp_data_obj_dict[isin].get_summen_wert()
                if sumwert is None:
                    self.status = self.wp_data_obj_dict[isin].status
                    self.errtext = self.wp_data_obj_dict[isin].errtext
                    return ([],[],[],[])
                # end if
                summe_wert += sumwert
                (okay,sumwert) = htype.type_transform(sumwert,'euro',type_liste[4])
                dataliste.append(sumwert)
                
                # 6. einnahmen
                einnahmen = self.wp_data_obj_dict[isin].get_einnahmen_wert()
                if einnahmen is None:
                    self.status = self.wp_data_obj_dict[isin].status
                    self.errtext = self.wp_data_obj_dict[isin].errtext
                    return ([],[],[],[])
                # end if
                summe_einnahmen += einnahmen
                (okay,einnahmen) = htype.type_transform(einnahmen,'euro',type_liste[5])
                dataliste.append(einnahmen)
                
                # 7. Kurswert
                kurs = 0.0  # self.wp_func_obj.get_act_kurs()
                kurswert = kurs * anzahl
                (okay,kurswert) = htype.type_transform(kurswert,'euro',type_liste[6])
                dataliste.append(kurswert)


                # 8. Kategorie
                kategorie = self.wp_data_obj_dict[isin].get_kategorie()
                dataliste.append(kategorie)
                
                data_lliste.append(dataliste)
                row_color_dliste.append(self.wp_color_dict[isin])
            # end if
        # end for
        
        # Summenzeile
        (okay, summe_wert) = htype.type_transform(summe_wert, 'euro', type_liste[4])
        (okay, summe_einnahmen) = htype.type_transform(summe_einnahmen, 'euro', type_liste[5])
        
        end_zeile[1] = "Summe:"
        end_zeile[4] = summe_wert
        end_zeile[5] = summe_einnahmen

        data_lliste.append(end_zeile)
        
        return (data_lliste, header_liste,type_liste,row_color_dliste)

        
    # end def
    def get_depot_daten_sets_overview_kategorie(self,kategorie):
        '''
                hole von jedem WP die Zusammenfassungen wenn es die gewünschte Kategorie hat

        :param kategorie:
        :return: (data_lliste, header_liste,type_liste,row_color_dliste) = self.get_depot_daten_sets_overview_kategorie(kategorie)
        '''
        
        header_liste = [self.par.DEPOT_DATA_NAME_ISIN,
                        self.par.DEPOT_DATA_NAME_DEPOT,
                        self.par.DEPOT_DATA_NAME_WP_NAME,
                        self.par.DEPOT_DATA_NAME_ZAHLTDIV,
                        self.par.DEPOT_DATA_NAME_ANZAHL,
                        self.par.DEPOT_DATA_NAME_WERT + " (kauf=neg)",
                        self.par.DEPOT_DATA_NAME_EINNAHME,
                        self.par.DEPOT_DATA_NAME_KURSWERT]
        type_liste = ["isin",
                      "str",
                      "str",
                      "int",
                      "float",
                      "euroStrK",
                      "euroStrK",
                      "euroStrK"]
        
        data_lliste = []
        row_color_dliste = []
        
        summe_wert = 0.0
        summe_einnahmen = 0.0
        
        for isin in self.isin_liste:
            
            # get aktegorie
            kat = self.wp_data_obj_dict[isin].get_kategorie()
            
            flag = False
            if kat == kategorie:
                flag = True

            if flag:
                
                dataliste = []
                
                # 1. isin
                # ---------
                dataliste.append(isin)
                
                # 2. depot
                #----------
                dataliste.append(self.depot_name)
                
                # 3. Name
                # --------
                name = self.wp_data_obj_dict[isin].get_name()
                dataliste.append(name)
                
                # 4. Zahlt Dividende
                dataliste.append(self.wp_data_obj_dict[isin].get_zahltdiv())
                
                # 5. Anzahl
                anzahl = self.wp_data_obj_dict[isin].get_summen_anzahl()
                if anzahl is None:
                    self.status = self.wp_data_obj_dict[isin].status
                    self.errtext = self.wp_data_obj_dict[isin].errtext
                    return ([], [], [], [])
                # end if
                dataliste.append(anzahl)
                
                # 6. wert
                sumwert = self.wp_data_obj_dict[isin].get_summen_wert()
                if sumwert is None:
                    self.status = self.wp_data_obj_dict[isin].status
                    self.errtext = self.wp_data_obj_dict[isin].errtext
                    return ([], [], [])
                # end if
                summe_wert += sumwert
                (okay, sumwert) = htype.type_transform(sumwert, 'euro', type_liste[5])
                dataliste.append(sumwert)
                
                # 7. einnahmen
                einnahmen = self.wp_data_obj_dict[isin].get_einnahmen_wert()
                if einnahmen is None:
                    self.status = self.wp_data_obj_dict[isin].status
                    self.errtext = self.wp_data_obj_dict[isin].errtext
                    return ([], [], [])
                # end if
                summe_einnahmen += einnahmen
                (okay, einnahmen) = htype.type_transform(einnahmen, 'euro', type_liste[6])
                dataliste.append(einnahmen)
                
                # 8. Kurswert
                kurs = 0.0  # self.wp_func_obj.get_act_kurs()
                kurswert = kurs * anzahl
                (okay, kurswert) = htype.type_transform(kurswert, 'euro', type_liste[7])
                dataliste.append(kurswert)
                
                data_lliste.append(dataliste)
                row_color_dliste.append(self.wp_color_dict[isin])
            # end if
        # end for
        
        return (data_lliste, header_liste, type_liste, row_color_dliste)
    
    # end def
    def get_depot_daten_sets_isin(self,isin):
        '''
        
        :param isin: isin number
        :return: (data_lliste, header_liste,type_liste,titlename) = self.get_depot_daten_sets_isin(isin)
        
    DEPOT_DATA_NAME_WP_NAME = "wp_name"
    DEPOT_DATA_NAME_ZAHLTDIV = "zahltdiv"
    DEPOT_DATA_NAME_ISIN
        '''
        
        if isin not in self.isin_liste:
            self.status = hdef.NOT_OKAY
            self.errtext = f"get_depot_daten_sets_isin: gewünschte isin = {isin} is nicht in Depot enthalten"
            return ([], [], [],"")
        # end if
        
        header_liste = [self.par.DEPOT_DATA_NAME_BUCHDATUM,
                        self.par.DEPOT_DATA_NAME_BUCHTYPE,
                        self.par.DEPOT_DATA_NAME_ANZAHL,
                        self.par.DEPOT_DATA_NAME_KURS,
                        self.par.DEPOT_DATA_NAME_WERT,
                        self.par.DEPOT_DATA_NAME_KOSTEN,
                        self.par.DEPOT_DATA_NAME_STEUER]
        type_liste = ["datStrP",
                      self.par.DEPOT_BUCHTYPE_TEXT_LIST,
                      "float",
                      "euroStrK",
                      "euroStrK",
                      "euroStrK",
                      "euroStrK"]
        
        data_lliste = self.wp_data_obj_dict[isin].get_data_set_lliste(header_liste,type_liste)

        if self.wp_data_obj_dict[isin].status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.wp_data_obj_dict[isin].errtext
            return ([], [], [], "")
        # end if

        line_color_liste = self.wp_data_obj_dict[isin].get_line_color_set_liste()

        if self.par.DEPOT_DATA_INDEX_BUCHTYPE in self.par.DEPOT_DATA_NAME_DICT.keys():
            buchtype_index_in_header_liste = self.par.DEPOT_DATA_INDEX_LIST.index(self.par.DEPOT_DATA_INDEX_BUCHTYPE)
        else:
            buchtype_index_in_header_liste = -1
        # endif

        return (data_lliste, header_liste,type_liste,line_color_liste)
    # end def


    def get_depot_daten_sets_isin_irow(self, isin,irow):
        '''
    
        :param isin: isin number
        :param irow: row number
        :return: (data_lliste, header_liste,type_liste,titlename,buchungs_type_list, buchtype_index_in_header_liste)
                                                                             = self.get_depot_daten_sets_isin_irow(isin,irow)
    
        '''
        
        if isin not in self.isin_liste:
            self.status = hdef.NOT_OKAY
            self.errtext = f"get_depot_daten_sets_isin: gewünschte isin = {isin} is nicht in Depot enthalten"
            return ([], [], [], [],0)
        # end if
        
        header_liste = [self.par.DEPOT_DATA_NAME_BUCHDATUM,
                        self.par.DEPOT_DATA_NAME_BUCHTYPE,
                        self.par.DEPOT_DATA_NAME_ANZAHL,
                        self.par.DEPOT_DATA_NAME_KURS,
                        self.par.DEPOT_DATA_NAME_WERT,
                        self.par.DEPOT_DATA_NAME_KOSTEN,
                        self.par.DEPOT_DATA_NAME_STEUER]
                
        type_liste = ["datStrP",
                      self.par.DEPOT_BUCHTYPE_TEXT_LIST,
                      "float",
                      "euroStrK",
                      "euroStrK",
                      "euroStrK",
                      "euroStrK"]
        
        output_data_set = self.wp_data_obj_dict[isin].get_one_data_set_liste(irow,header_liste, type_liste)
        if self.wp_data_obj_dict[isin].status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.wp_data_obj_dict[isin].errtext
            return ([], [], [], [],0)
        # end if
        
        buchtype_index_in_header_liste = 1 # siehe header_liste
        buchungs_type_list = self.par.DEPOT_BUCHTYPE_TEXT_LIST

        return (output_data_set, header_liste, type_liste,buchungs_type_list,buchtype_index_in_header_liste)
    # end def
    def get_immutable_list_from_header_list(self,isin,header_liste):
        '''
        
        :param isin
        :param header_liste:
        :return: immutable_liste = self.get_immutable_list_from_header_list(isin,header_liste)
        '''
        immutable_liste = []
        
        if isin not in self.isin_liste:
            self.status = hdef.NOT_OKAY
            self.errtext = f"get_depot_daten_sets_isin: gewünschte isin = {isin} is nicht in Depot enthalten"
            return immutable_liste
        
        # end if
        
        immutable_liste = self.wp_data_obj_dict[isin].get_wp_immutable_list_from_header_list(header_liste)
        
        if self.wp_data_obj_dict[isin].status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.wp_data_obj_dict[isin].errtext
            return False
        # end if
        
        return immutable_liste
    # end def
    def set_data_set_isin_irow(self,new_data_list, header_liste, type_liste,isin, irow):
        '''
        
        :param new_data_list:
        :param isin:
        :param irow:
        :return: new_data_set_flag = self.set_data_set_isin_irow(new_data_list,header_liste, type_liste, isin, irow)
        '''
    
        new_data_set_flag = False
        
        if isin not in self.isin_liste:
            self.status = hdef.NOT_OKAY
            self.errtext = f"get_depot_daten_sets_isin: gewünschte isin = {isin} is nicht in Depot enthalten"
            return False
        # end if
        
        new_data_set_flag = self.wp_data_obj_dict[isin].set_edit_data_set_in_irow(new_data_list, header_liste, type_liste,irow,self.par.LINE_COLOR_EDIT)

        if self.wp_data_obj_dict[isin].status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.wp_data_obj_dict[isin].errtext
            return False
        elif len(self.wp_data_obj_dict[isin].infotext) != 0:
            self.infotext = f"set_data_set_isin_irow: {self.wp_data_obj_dict[isin].infotext}"
            self.wp_data_obj_dict[isin].infotext = ""
        # end if
        
        if new_data_set_flag:
            self.wp_color_dict[isin] = self.par.LINE_COLOR_NEW
        
        return new_data_set_flag
    # end def
    def delete_in_data_set(self,isin,irow,konto_obj):
        '''
        
        :param isin:
        :param irow:
        :param konto_obj:
        :return:
        '''

        if isin not in self.isin_liste:
            self.status = hdef.NOT_OKAY
            self.errtext = f"delete_in_data_set: gewünschte isin = {isin} is nicht in Depot enthalten"
            return False
        # end if
        
        # id
        id = self.wp_data_obj_dict[isin].get_id_of_irow(irow)

        if self.wp_data_obj_dict[isin].status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.wp_data_obj_dict[isin].errtext
            return self.status
        # end if

        # finde konto row in konto_data_set
        irow_konto = konto_obj.get_irow_by_id(id)
        if irow_konto < 0:
            self.status = hdef.NOT_OKAY
            self.errtext = f"In Konto: {konto_obj.konto_name} konnte id = {id} nicht gefunden werden !!!!"
            return self.status
        # end if

        self.wp_data_obj_dict[isin].delete_in_wp_data_set(irow)

        if self.wp_data_obj_dict[isin].status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.wp_data_obj_dict[isin].errtext
            return self.status
        # end if
        
        (self.status, self.errtext) = konto_obj.delete_data_list(irow_konto)
        
        return self.status
    def set_kurs_value(self,isin,irow):
        '''
        
        :param isin:
        :param irow:
        :return: status = self.set_kurs_value(isin,irow)
        '''
        
        if isin not in self.isin_liste:
            self.status = hdef.NOT_OKAY
            self.errtext = f"set_kurs_value: gewünschte isin = {isin} is nicht in Depot enthalten"
            return self.status
        # end if
        
        header_liste = [self.par.DEPOT_DATA_NAME_BUCHDATUM,
                        self.par.DEPOT_DATA_NAME_BUCHTYPE,
                        self.par.DEPOT_DATA_NAME_ANZAHL,
                        self.par.DEPOT_DATA_NAME_KURS,
                        self.par.DEPOT_DATA_NAME_WERT,
                        self.par.DEPOT_DATA_NAME_KOSTEN,
                        self.par.DEPOT_DATA_NAME_STEUER]
        
        type_liste = ["dat",
                      self.par.DEPOT_BUCHTYPE_TEXT_LIST,
                      "float",
                      "cent",
                      "cent",
                      "cent",
                      "cent"]
        index_datum = 0
        index_buchtype = 1
        index_anzahl = 2
        index_kurs = 3
        index_wert = 4
        index_kosten = 5
        index_steuer = 6
        
        
        data_set = self.wp_data_obj_dict[isin].get_one_data_set_liste(irow, header_liste, type_liste)
        if self.wp_data_obj_dict[isin].status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.wp_data_obj_dict[isin].errtext
            return self.status
        # end if
        flag = False
        if data_set[index_buchtype] == self.par.DEPOT_BUCHTYPE_NAME_WP_KAUF:
            if data_set[index_anzahl] > 0.01:
                kurs = (data_set[index_wert]-data_set[index_kosten]-data_set[index_steuer])/data_set[index_anzahl]
                data_set[index_kurs] = int(kurs + 0.5)
                flag = True
        elif data_set[index_buchtype] == self.par.DEPOT_BUCHTYPE_NAME_WP_VERKAUF:
            if data_set[index_anzahl] > 0.01:
                kurs = (data_set[index_wert]+data_set[index_kosten]+data_set[index_steuer])/data_set[index_anzahl]
                data_set[index_kurs] = int(kurs+0.5)
                flag = True
        elif data_set[index_buchtype] == self.par.DEPOT_BUCHTYPE_NAME_WP_KOSTEN:
            print("Kursabfrage fehlt!!")
        elif data_set[index_buchtype] == self.par.DEPOT_BUCHTYPE_NAME_WP_EINNAHMEN:
            print("Kursabfrage fehlt!!")
        # end if
        
        if flag:
            self.wp_data_obj_dict[isin].set_item_in_irow(data_set[index_kurs], self.par.DEPOT_DATA_NAME_KURS, "cent", irow,self.par.LINE_COLOR_EDIT)

            if self.wp_data_obj_dict[isin].status != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = self.wp_data_obj_dict[isin].errtext
                return self.status
            # end if
            
            self.wp_color_dict[isin] = self.par.LINE_COLOR_EDIT

        return self.status
    # end dfe
    def update_data_llist(self,isin,changed_pos_list,update_date_lliste,header_liste, type_liste ):
        '''
        
        :param isin:
        :param update_date_lliste:
        :param changed_pos_list:
        :return: status = self.update_data_llist(isin,update_date_lliste, changed_pos_list)
        '''
        if isin not in self.isin_liste:
            self.status = hdef.NOT_OKAY
            self.errtext = f"update_data_llist: gewünschte isin = {isin} is nicht in Depot enthalten"
            return self.status
        # end if
        
        new_flag = False

        for (irow, icol) in changed_pos_list:
            header = header_liste[icol]
            type   = type_liste[icol]
            value = update_date_lliste[irow][icol]
            
            if header == self.par.DEPOT_DATA_NAME_KOSTEN:
                
                (value,kurs,_,steuer) = self.verify_value_kosten(isin,irow,value,type)
                if self.status != hdef.OKAY:
                    return (self.status,False)
                if kurs is not None:
                    self.wp_data_obj_dict[isin].set_item_in_irow(kurs, self.par.DEPOT_DATA_NAME_KURS, type, irow,
                                                                 self.par.LINE_COLOR_EDIT)
                # end if
                if steuer is not None:
                    self.wp_data_obj_dict[isin].set_item_in_irow(steuer, self.par.DEPOT_DATA_NAME_STEUER, type, irow,
                                                                 self.par.LINE_COLOR_EDIT)
                # end if
            elif header == self.par.DEPOT_DATA_NAME_STEUER:
                
                (value,kurs,kosten,_) = self.verify_value_steuer(isin,irow,value,type)
                if self.status != hdef.OKAY:
                    return (self.status, False)
                if kurs is not None:
                    self.wp_data_obj_dict[isin].set_item_in_irow(kurs, self.par.DEPOT_DATA_NAME_KURS, type, irow,
                                                                 self.par.LINE_COLOR_EDIT)
                # endif
                if kosten is not None:
                    self.wp_data_obj_dict[isin].set_item_in_irow(kosten, self.par.DEPOT_DATA_NAME_KOSTEN, type, irow,
                                                                 self.par.LINE_COLOR_EDIT)
                # end if
            # end if
            
            new_flag = self.wp_data_obj_dict[isin].set_item_in_irow(value, header, type, irow,self.par.LINE_COLOR_EDIT)
            if new_flag:
                self.wp_color_dict[isin] = self.par.LINE_COLOR_EDIT
        # end for
        
        return (self.status,new_flag)
    # end def
    def verify_value_kosten(self,isin,irow,value,type):
        return self.verify_value(isin,irow,'kosten',value,type)
    # end def
    def verify_value_steuer(self,isin,irow,value,type):
        return self.verify_value(isin,irow,'steuer',value,type)
    # end def
    def verify_value(self,isin,irow,value_type,value,type):
        '''
        
        :param isin:
        :param irow:
        :param value:
        :param value_type = 'kosten','steuer'
        :return: (kosten,kurs) = self.verify_value_kosten(isin,irow,kosten)
        '''
        if isin not in self.isin_liste:
            self.status = hdef.NOT_OKAY
            self.errtext = f"update_data_llist: gewünschte isin = {isin} is nicht in Depot enthalten"
            return (None,None,None,None)
        # end if
        
        # convert in cent
        (okay, value) = htype.type_transform(value, type, 'cent')
        if okay != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = f"verify_value:  Fehler transform data_item = <{value}> von type: <{type}> in type {'cent'} wandeln !!!!!!"
            return (None,None,None,None)
        # end if
        
        buchtype_index = self.wp_data_obj_dict[isin].get_one_data_item(irow, self.par.DEPOT_DATA_NAME_BUCHTYPE, 'int')
        if self.wp_data_obj_dict[isin].status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.wp_data_obj_dict[isin].errtext
            return (None,None,None,None)
        # end if
        
        wert   = self.wp_data_obj_dict[isin].get_one_data_item(irow, self.par.DEPOT_DATA_NAME_WERT, 'cent')
        kosten = self.wp_data_obj_dict[isin].get_one_data_item(irow, self.par.DEPOT_DATA_NAME_KOSTEN, 'cent')
        steuer = self.wp_data_obj_dict[isin].get_one_data_item(irow, self.par.DEPOT_DATA_NAME_STEUER, 'cent')
        kurs   = self.wp_data_obj_dict[isin].get_one_data_item(irow, self.par.DEPOT_DATA_NAME_KURS, 'cent')
        anzahl = self.wp_data_obj_dict[isin].get_one_data_item(irow, self.par.DEPOT_DATA_NAME_ANZAHL, 'float')
        if self.wp_data_obj_dict[isin].status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.wp_data_obj_dict[isin].errtext
            return (None,None,None,None)
        # end if
        
        kurswert = None
        steuer_calc   = None
        kosten_calc   = None
        if value_type == 'kosten':
            kosten = value
            # bei Kauf Wenn kosten größer den 0.5*wert, dann sind ist kosten = kurswert und kosten werden berechnet
            # Wert = Kurswert+kosten+steuer
            if (wert != 0) and (buchtype_index == self.par.DEPOT_BUCHTYPE_INDEX_WP_KAUF):
                if (2*kosten > wert):
                    kurswert = kosten
                    kosten = wert - kurswert - steuer
                else:
                    kurswert = wert - kosten - steuer
                # end if
            # bei Verkauf Wenn kosten größer der wert, dann sind ist kosten = kurswert und kosten werden berechnet
            # Wert = Kurswert-kosten-steuer
            elif (wert != 0) and (buchtype_index == self.par.DEPOT_BUCHTYPE_INDEX_WP_VERKAUF):
                if (kosten > wert):
                    kurswert = kosten
                    kosten = kurswert - wert - steuer
                else:
                    kurswert = wert + kosten + steuer
                # end if
            elif (wert != 0) and (buchtype_index == self.par.DEPOT_BUCHTYPE_INDEX_WP_KOSTEN):
                steuer_calc = wert - kosten
            elif (wert != 0) and (buchtype_index == self.par.DEPOT_BUCHTYPE_INDEX_WP_EINNAHMEN) and (kosten > wert):
                
                einnahme = kosten
                kosten = einnahme - wert - steuer
            # end if
            value = kosten
        elif value_type == 'steuer':
            steuer = value
            # bei Kauf Wenn kosten größer den 0.5*wert, dann sind ist kosten = kurswert und kosten werden berechnet
            # Wert = Kurswert+kosten+steuer
            if (wert != 0) and (buchtype_index == self.par.DEPOT_BUCHTYPE_INDEX_WP_KAUF):
                if (2*steuer > wert):
                    kurswert = steuer
                    steuer = wert - kurswert - kosten
                else:
                    kurswert = wert - steuer - kosten
                # end if
            # bei Verkauf Wenn kosten größer der wert, dann sind ist kosten = kurswert und kosten werden berechnet
            # Wert = Kurswert-kosten-steuer
            elif (wert != 0) and (buchtype_index == self.par.DEPOT_BUCHTYPE_INDEX_WP_VERKAUF):
                if (steuer > wert):
                    kurswert = steuer
                    steuer = kurswert - wert - kosten
                else:
                    kurswert = wert + steuer + kosten
                # end if
            elif (wert != 0) and (buchtype_index == self.par.DEPOT_BUCHTYPE_INDEX_WP_KOSTEN):
                kosten_calc = wert - steuer
            elif (wert != 0) and (buchtype_index == self.par.DEPOT_BUCHTYPE_INDEX_WP_EINNAHMEN) and (steuer > wert):
                
                einnahme = steuer
                steuer = einnahme - wert - kosten
            # end if
            
            value = steuer
        # end if
        
        # Bilde kurs
        if (kurswert is not None) and (kurs == 0) and (anzahl > 0.01):
            kurs = int( (kurswert / anzahl)+0.5)
            (okay, kurs) = htype.type_transform(kurs, 'cent', type)
        else:
            kurs = None
        # end if

        # convert in type
        (okay, value) = htype.type_transform(value, 'cent',type)
        if okay != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = f"verify_value_kosten:  Fehler transform data_item = <{value}> von type: {'cent'} in type <{type}>  wandeln !!!!!!"
            return (None,None,None,None)
        # end if
        
        if kosten_calc is not None:
            (okay, kosten_calc) = htype.type_transform(kosten_calc, 'cent', type)
        if steuer_calc is not None:
            (okay, steuer_calc) = htype.type_transform(steuer_calc, 'cent', type)

        return (value,kurs,kosten_calc,steuer_calc)
# end class