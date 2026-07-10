#
#
#   beinhaltet die data_llist ´für eingelesene DepotDaten und funktion dafür
#
import os, sys

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif


import tools.hfkt_def as hdef
import tools.hfkt_type as htype
import tools.hfkt_tvar as htvar
import tools.hfkt_list as hlist

import depot_depot_wp_data_set_class as wpclass

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
    # DEPOT_DATA_INDEX_KATALOG = index
    
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
    
    DEPOT_DATA_NAME_KATALOG = "katalog"
    DEPOT_DATA_NAME_WP_NAME = "wp_name"
    DEPOT_DATA_NAME_ZAHLTDIV = "zahltdiv"
    DEPOT_DATA_NAME_EINNAHME = "einnahme"
    DEPOT_DATA_NAME_KURSWERT = "kurswert"
    DEPOT_DATA_NAME_DEPOT    = "depot"

    DEPOT_WP_STORE_PATH = "."
    DEPOT_WP_USE_JSON   = False
    
    LINE_COLOR_BASE = ""
    LINE_COLOR_NEW  = "aquamarine1"  # "aliceblue"
    LINE_COLOR_EDIT = "orange1"
    
    DEPOT_SHOW_TYPE_INDEX_ALL = 0
    DEPOT_SHOW_TYPE_INDEX_ACTIVE = 1
    DEPOT_SHOW_TYPE_INDEX_INACTIVE = 2
    
    DEPOT_KATALOG_LEER = "leer"


class DepotDataSet:
    '''
    obj                            = DepotDataSet(depot_name,isin_liste,wp_func_obj)
                                     obj.reset_status()
                                     obj.reset_infotext()
                                     obj.delete_infotext()
    katalog:str                  = obj.get_katalog(isin)
    katalog_liste:liste[str]     = obj.get_katalog_liste()
                                     obj.set_katalog(isin,katalog)
    isin_liste:list[str]           = obj.get_isin_liste()
    depot_name:str                 = obj.get_depot_name()
                                     obj.self.set_stored_wp_data_set_ttable(isin,katalog,wp_data_set_table)
    data_set_ttable: TTable        = obj.get_wp_data_set_dict_to_store(isin)
    isin_list: list[str]           = obj.get_to_store_isin_list()
    depot_wp_name_list: list[str]  = obj.get_to_store_depot_wp_name_list()
                                     obj.update_from_konto_data()
    tlist: TList                   = obj.get_konto_data_at_irow_tlist(irow,buch_type)
    (flag,isin_index,id)           = obj.proof_raw_dict_isin_id(new_data_tlist)
    wp_data_obj_dict: dict         = obj.get_wp_data_obj(isin)
    wp_obj: class                  = obj.build_wp_data_obj(isin)
     titlename:str                 = obj.get_titlename(isin)
     (ttable,row_color_dliste)     = obj.get_depot_daten_sets_overview(nur_was_im_depot)
     (ttable,row_color_dliste)     = obj.get_depot_daten_sets_overview_katalog(katalog)
     (ttable,titlename)            = obj.get_depot_daten_sets_isin(isin)
     (tliste,buchungs_type_list, buchtype_index_in_header_liste)
                                   = obj.get_depot_daten_sets_isin_irow(isin,irow)
     immutable_liste               = obj.get_immutable_list_from_header_list(isin,header_liste)
     new_data_set_flag             = obj.set_data_set_isin_irow(tliste, isin, irow)
     status                        = obj.delete_wp_isin(isin)
     status                        = obj.delete_in_data_set(isin,irow)
     status                        = obj.set_kurs_value(isin,irow)
     status                        = obj.update_data_ttable(isin,changed_pos_list,ttable_update)
    '''
    def __init__(self,depot_name,depot_kurz_name, isin_liste,wp_name_liste,wp_func_obj,konto_obj):
    
        self.depot_name = depot_name
        self.depot_kurz_name = depot_kurz_name
        self.konto_obj  = konto_obj
        self.konto_name = konto_obj.get_konto_name()
        self.par = DepotParam()
        
        self.DEPOT_DATA_TO_SHOW_DICT = {}
    
        self.status = hdef.OK
        self.errtext = ""
        self.infotext = ""

        self.wp_func_obj = wp_func_obj
        
        
        (self.isin_liste,self.wp_name_liste) = hlist.sort_two_list(isin_liste,wp_name_liste)
        # self.isin_liste = sorted(isin_liste)
        self.wp_data_obj_dict  = {}
        self.wp_color_dict     = {}   # sets color if isin is new or stores new data
        self.n_wp_data_obj     = 0
        for isin in self.isin_liste:
            
            self.wp_data_obj_dict[isin] = self.build_wp_data_obj(isin)
            if self.status == hdef.OKAY:
                self.n_wp_data_obj += 1
                self.wp_color_dict[isin] = self.par.LINE_COLOR_NEW
    
        # print
    
    # def set_data_show_dict_list(self,dat_set_index: int):
    #     self.DEPOT_DATA_TO_SHOW_DICT[dat_set_index] = self.DEPOT_DATA_ITEM_LIST[dat_set_index]
    
    # end def
    def reset_status(self):
        
        self.status = hdef.OKAY
        self.errtext = ""
        
        for isin in self.isin_liste:
            self.wp_data_obj_dict[isin].reset_status()
        # end for
        # print
    # end def
    def reset_infotext(self):
        self.infotext = ""
        # print
    # end def
    def delete_infotext(self):
        self.infotext = ""
        # print
    # end def
    def get_konto_name(self):
        return self.konto_name
    def get_katalog(self,isin):
        if isin in self.isin_liste:
            katalog = self.wp_data_obj_dict[isin].get_katalog()
        else:
            raise Exception(f"get_katalog: isin = {isin} nicht vorhanden")
        # end if
        # print
        return katalog
    # end def
    def get_katalog_liste(self):
        '''

        :return: katalog_liste = self.get_katalog_liste()
        '''
        katalog_liste = []
        for isin in self.isin_liste:
            katalog = self.wp_data_obj_dict[isin].get_katalog()
            katalog_liste.append(katalog)
        # end for
        
        katalog_liste = list(set(katalog_liste))
        # print
        return katalog_liste
    
    # end def
    def set_katalog(self,isin,katalog):
        '''
        
        :param isin:
        :param katalog:
        :return: self.set_katalog(isin,katalog)
        '''
        if isin in self.isin_liste:
            self.wp_data_obj_dict[isin].set_katalog(katalog)
            self.wp_color_dict[isin] = self.par.LINE_COLOR_EDIT
        else:
            raise Exception(f"set_katalog: isin = {isin} nicht vorhanden")
        # end if
        # print
        return
    # end def
    def reget_wp_info(self,isin):

        if isin in self.isin_liste:
            self.wp_data_obj_dict[isin].reget_wp_info()
        else:
            raise Exception(f"set_katalog: isin = {isin} nicht vorhanden")
        # end if
        # print
        return

    # end def
    def get_isin_liste(self):
        '''
        
        :return: isin_liste = self.get_isin_liste()
        '''
        # print
        return list(self.isin_liste)
    # end def
    def get_wp_name_liste(self):
        '''
        
        :return: wp_name_liste = self.get_wp_name_liste[]
        '''
        liste = []
        for isin in self.isin_liste:
            liste.append(self.wp_data_obj_dict[isin].get_depot_wp_name())
        # print
        return liste
    # end def
    def get_depot_name(self):
        # print
        return self.depot_name
    # end def
    def get_depot_kurz_name(self):
        # print
        return self.depot_kurz_name
    # end def
    def set_stored_wp_data_set_ttable(self,isin: str,katalog: str,wp_data_set_table: htvar.TTable):
        '''
        
        Die gespeicherten Daten aus pickle werden an interne Datenbank übergeben
        init-Phase
        
        :param isin:
        :param depot_wp_name:
        :param wp_data_set_dict:
        :return: self.set_stored_wp_data_set_ttable(self,isin,katalog,wp_data_set_table)
        '''
        
        if isin not in self.isin_liste:
            raise Exception(f"isin: {isin} ist nicht in wp_data_obj_dict")
        else:
            
            # hand over data set
            wp_obj = self.get_wp_data_obj(isin)
            if wp_obj.status != hdef.OKAY:
                raise Exception(f"set_stored_wp_data_set_ttable: isin: {isin} Problem Erstellen Data Klasse {wp_obj.errtext}")
            wp_obj.set_stored_wp_data_set_ttable(wp_data_set_table,self.par.LINE_COLOR_BASE)
            if wp_obj.status != hdef.OKAY:
                raise Exception(
                    f"set_stored_wp_data_set_ttable: isin: {isin = } Problem Füllen Data Klasse {wp_obj.errtext}")
            
            # set color
            self.wp_color_dict[isin] = self.par.LINE_COLOR_BASE

            # set katalog
            wp_obj.set_katalog(katalog)
        # end
        # print
    # end def
    # def get_wp_data_set_dict_to_store(self,isin):
    #     '''
    #
    #     Die interne Daten für Datenspeicherung mit pickle vorbereiten
    #     Ende
    #
    #     :param isin:
    #     :return: data_set_ttable = self.get_wp_data_set_dict_to_store(isin)
    #     '''
    #
    #     if isin not in self.isin_liste:
    #         self.status = hdef.NOT_OKAY
    #         self.errtext = f"get_wp_data_set_dict_to_store: isin: {isin} ist nicht dictonary self.wp_data_obj_dict"
    #         data_set_ttable = None
    #     else:
    #         data_set_ttable =  self.wp_data_obj_dict[isin].get_wp_data_set_ttable_to_store()
    #         if self.wp_data_obj_dict[isin].status != hdef.OKAY:
    #             self.status = hdef.NOT_OKAY
    #             self.errtext = self.wp_data_obj_dict[isin].errtext
    #         # end if
    #     # end if
    #
    #     return data_set_ttable
    # def get_to_store_isin_list(self):
    #     '''
    #
    #     :return: isin_list = self.get_to_store_isin_list()
    #     '''
    #     return list(self.isin_liste)
    # # end def
    # def get_to_store_depot_wp_name_list(self):
    #     '''
    #
    #     :return: depot_wp_name_list = self.get_to_store_depot_wp_name_list()
    #     '''
    #
    #     liste = []
    #     for isin in self.isin_liste:
    #
    #         liste.append(self.wp_data_obj_dict[isin].get_depot_wp_name())
    #
    #     return liste
    #
    # # end def
    # def get_wp_data_set_dict_to_store(self,isin):
    #     '''
    #
    #     :param isin:
    #     :return: ddict = self.get_wp_data_set_dict_to_store(isin)
    #     '''
    #
    #     if isin not in self.isin_liste:
    #         self.status = hdef.NOT_OKAY
    #         self.errtext = f"get_wp_data_set_dict_to_store: isin = {isin} not inwp_data_obj_dict"
    #         return {}
    #     # end def
    #     return self.wp_data_obj_dict[isin].get_wp_data_set_dict_to_store()
    # # end def
    def update_from_konto_data(self,konto_obj):
        '''
        
        :return: flag_changed = update_from_konto_data()
        '''
        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""
        
        # print test
        if self.konto_obj != konto_obj:
            print('-=-' * 30)
            print(f"set konto_obj {self.konto_obj = } does not fit with external set {konto_obj =}")
            print('-=-' * 30)
            raise Exception(f"set konto_obj {self.konto_obj = } does not fit with external set {konto_obj =}")
        # end if
        
        n = konto_obj.get_number_of_data()
        flag_read = False
        # new_data_dict_list = []
        n_new_read = 0
        n_update   = 0
        isin_new_or_update_liste = []
        for irow in range(n):
            buchtype_str = konto_obj.get_buchtype_str(irow)
            
            if buchtype_str == self.par.DEPOT_BUCHTYPE_NAME_UNBEKANNT:
                self.status = hdef.NOT_OKAY
                self.errtext = f"Error update_from_konto_data: In {irow =} ist buchttype = {buchtype_str}. Korrigiere in Konto wp-Buchungen!!! "
                return False
            # end if
            
            if buchtype_str in self.par.DEPOT_DATA_BUCHTYPE_DICT.values():
                
                buch_type = self.par.DEPOT_BUCHTYPE_INDEX_LIST[self.par.DEPOT_BUCHTYPE_TEXT_LIST.index(buchtype_str)]
                
                new_data_tlist = self.get_konto_data_at_irow_tlist(konto_obj,irow,buch_type)
                
                (flag_read,isin,id) = self.proof_raw_dict_isin_id(new_data_tlist) # proof id
                if self.status != hdef.OKAY:
                    return
                # end if
                
                anzahl = self.wp_data_obj_dict[isin].get_summen_anzahl("float")
                
                
                if flag_read:
                    n_new_read += 1
                    self.wp_data_obj_dict[isin].add_data_set_dict_to_table(new_data_tlist,self.par.LINE_COLOR_NEW)
                    
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
                    irow_last = self.wp_data_obj_dict[isin].get_n_data() - 1
                    if (irow_last >= 0) and (anzahl is not None) and (anzahl > 0.0):
                        self.wp_data_obj_dict[isin].set_item_in_irow(anzahl, self.par.DEPOT_DATA_NAME_ANZAHL,
                                                                     'float',irow_last,self.par.LINE_COLOR_NEW)
                        
                else: # proof for update
                    
                    flag_update = self.wp_data_obj_dict[isin].update_item_if_different(id,new_data_tlist,self.par.LINE_COLOR_EDIT)
                
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
            self.infotext = f"{self.errtext}\nVom Konto: <{konto_obj.get_konto_name()}> n_new: {n_new_read} neuen Daten eingelesen"
        # end if
        if n_update > 0:
            self.infotext = f"{self.errtext}\nVom Konto: <{konto_obj.get_konto_name()}> n_update: {n_update}  Daten upgedatet"
        # end if
        if (n_new_read == 0) and (n_update == 0):
            if n == 0:
                self.infotext = f"{self.errtext}\nIm Konto: <{konto_obj.get_konto_name()}> sind keine Daten vorhanden"
            else:
                self.infotext = f"{self.errtext}\nVom Konto: <{konto_obj.get_konto_name()}> keine neuen Daten eingelesen"
            # end if
        # end if
        # print
        return (n_new_read > 0) or (n_update>0)
    # end def
    def get_konto_data_at_irow_tlist(self,konto_obj,irow,buch_type):
        '''
        
        :param irow:
        :param buch_type:
        :return:  tlist = self.get_konto_data_at_irow_tlist(irow,buch_type)
        '''
        
        # print test
        if self.konto_obj != konto_obj:
            print('-=-' * 30)
            print(f"set konto_obj {self.konto_obj = } does not fit with external set {konto_obj =}")
            print('-=-' * 30)
            raise Exception(f"set konto_obj {self.konto_obj = } does not fit with external set {konto_obj =}")
        # end if

        new_vals    = [None for i in self.par.DEPOT_KONTO_DATA_INDEX_LIST]
        new_types   = [None for i in self.par.DEPOT_KONTO_DATA_INDEX_LIST]
        new_headers = [None for i in self.par.DEPOT_KONTO_DATA_INDEX_LIST]
        for i,index in enumerate(self.par.DEPOT_KONTO_DATA_INDEX_LIST):
            
            # buchtype
            if index == self.par.DEPOT_DATA_INDEX_BUCHTYPE:
                new_vals[i] = buch_type
            else: # sonst
                new_vals[i] = konto_obj.get_data_item_at_irow(irow,self.par.DEPOT_DATA_NAME_DICT[index],self.par.DEPOT_DATA_TYPE_DICT[index])
            # end if
            new_types[i] = self.par.DEPOT_DATA_TYPE_DICT[index]
            new_headers[i] = self.par.DEPOT_DATA_NAME_DICT[index]
            
            if self.par.DEPOT_DATA_NAME_DICT[index] == self.par.DEPOT_DATA_NAME_WERT:
                    new_vals[i] = abs(new_vals[i])
            # end if
        # end ofr
        tlist = htvar.build_list(new_headers,new_vals,new_types)
        # print
        return tlist
    # end def
    def proof_raw_dict_isin_id(self,new_data_tlist: htvar.TList):
        '''
        Prüft ob isin okay und ob isin es Stammdaten vorhanden und ob schon ein wp-objekt angelegt ist
        
        :param raw_data_dict:
        :return: (flag,isin_index,id) = self.proof_raw_dict_isin_id(new_data_tlist)
        '''
        
        isin_proof = htvar.get_val_from_list(new_data_tlist,self.par.DEPOT_DATA_NAME_ISIN)
        id = htvar.get_val_from_list(new_data_tlist,self.par.DEPOT_DATA_NAME_KONTO_ID)
        
        if len(isin_proof) == 0:
            self.status = hdef.NOT_OKAY
            self.errtext = f"Error proof_raw_dict_isin_id: Von new_data_tlist isin ist leer Korrigiere in Konto wp-Buchungen müssen eine isin haben {new_data_tlist =} "
            return (False,isin_proof,id)
        # end if
        
        # proof isin
        # -----------
        (okay, isin) = htype.type_proof(isin_proof,self.par.DEPOT_DATA_TYPE_DICT[self.par.DEPOT_DATA_INDEX_ISIN])
        if okay != hdef.OKAY:
            self.status  = okay
            self.errtext = f"proof_raw_dict_isin_id: isin: <{isin_proof}> has not correct type: <{self.DEPOT_DATA_TYPE_DICT[self.DEPOT_DATA_INDEX_ISIN]}> !!!"
            return (False,-1,id)
        # end if
        
        # search isin in self.wp class
        wp_obj = self.get_wp_data_obj(isin)
        if self.status != hdef.OKAY:
            return (False,isin,id)
        # end if
        
        # proof id in data object
        if wp_obj.exist_id_in_table(id):
            flag = False
        else:
            flag = True
        # end if
        
        # print
        return (flag,isin,id)
    # end def
    def get_wp_data_obj(self,isin):
        '''
        
        :param isin:
        :return: wp_data_obj_dict = self.get_wp_data_obj(isin)
        '''
        
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
        
        # print
        
        return self.wp_data_obj_dict[isin]
    # end def
    def build_wp_data_obj(self,isin):
        '''
        
        :param isin:
        :return: wp_obj = self.build_wp_data_obj(isin)
        '''
        depot_wp_name = self.depot_name + "_" + isin
        wp_obj = wpclass.WpDataSet(isin, depot_wp_name, self.par, self.wp_func_obj)
    
        if wp_obj.status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = wp_obj.errtext
        # end if
        
        # print
        
        return wp_obj
    # end def
    
    # def get_data_set_dict_ttable(self):
    #     '''
    #
    #     :return:
    #     '''
    #     data_dict_list = []
    #     for isin in self.isin_liste:
    #         dict_liste = self.wp_data_obj_dict[isin].get_data_set_dict_ttable()
    #         data_dict_list += dict_liste
    #     # end for
    #     return data_dict_list
    # # end def
    # def get_data_type_dict(self):
    #     '''
    #
    #     :return:
    #     '''
    #     if( self.n_isin_list):
    #         data_type_dict = self.isin_data_obj_list[0].get_data_type_dict()
    #     else:
    #         data_type_dict = {}
    #     # end if
    #
    #     return data_type_dict
    # # end def
    # def filter_isin_data_set_dict_list(self,isin,depot_data_set_dict_list):
    #     '''
    #
    #     :param isin:
    #     :param depot_data_set_dict_list:
    #     :return: data_dict_list = self.filter_isin_data_set_dict_list(isin,depot_data_set_dict_list)
    #     '''
    #     data_dict_list = []
    #     for ddict in depot_data_set_dict_list:
    #         if isin == ddict[self.DEPOT_DATA_NAME_ISIN]:
    #             data_dict_list.append(ddict)
    #         # end if
    #     # end for
    #     return data_dict_list
    # # end def
    def get_titlename(self,isin):
        '''
        
        :return: titlename = self.get_titlename(isin)
        '''
        if isin in self.isin_liste:
            titlename = f"Depot: {self.depot_name},WP: {isin}/{self.wp_data_obj_dict[isin].wp_info_dict['name']}/zahltdiv:{self.wp_data_obj_dict[isin].wp_info_dict['zahltdiv']}"
        else:
            titlename = f"WP: {isin}//"
        # end if
        
        # print
        
        return titlename
    # end def
    def get_depot_daten_sets_overview(self,depot_show_type):
        '''
        hole von jedem WP die Zusammenfassungen
        :param nur_was_im_depot = False alle zeigen
                                = True nur die nch im Depot sinf (anzahl > 0)
        :return: (ttable,row_color_dliste,steuer_flag) = self.get_depot_daten_sets_overview(nur_was_im_depot)
        '''

        # Schauen ob in diesem Depot Steuer abgezogen wird
        steuer_flag = False
        for isin in self.isin_liste:
            steuer = self.wp_data_obj_dict[isin].get_sum_Steuer("euro")
            if abs(steuer) > 0.01:
                steuer_flag = True
                break
            # end if
        # end for

        #

        lliste        = [[self.par.DEPOT_DATA_NAME_ISIN,"str"],
                         [self.par.DEPOT_DATA_NAME_WP_NAME, "str"],
                         ["n","int"],
                         ["nK","int"],
                         ["nV","int"],
                         ["Kkurs","float"],
                         ["Vkurs/Akurs","float"],
                         ["Verhältnis","float"],
                         ["Kwert","euroStrK"],
                         ["Vwert","euroStrK"],
                         ["Div","euroStrK"],
                         ["Kosten","euroStrK"],
                         ["Bilanz","euroStrK"],
                         ["Katalog","str"]]

        header_liste = hlist.get_clist_from_llist(lliste, 0)
        type_liste   = hlist.get_clist_from_llist(lliste, 1)
        
        data_lliste = []
        row_color_dliste = []
        
        summe_bilanz = 0.0
        
        for isin in self.isin_liste:

            dataliste = []

            # calc Anzahl
            anzahl = self.wp_data_obj_dict[isin].get_summen_anzahl("float")
            if anzahl is None:
                self.status = self.wp_data_obj_dict[isin].status
                self.errtext = self.wp_data_obj_dict[isin].errtext
                return ([],[],steuer_flag)
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

                # update Kurse
                self.wp_data_obj_dict[isin].update_kurse()

                # 1. isin
                #---------
                dataliste.append(isin)

                # 2. Name
                #--------
                dataliste.append(self.wp_data_obj_dict[isin].get_name())

                # 3. n = Anzahl
                dataliste.append(anzahl)

                # 4. n-Kauf
                nK = self.wp_data_obj_dict[isin].get_summen_anzahl_gekauft("float")
                dataliste.append(nK)

                # 5. n-Verkauf
                nV = self.wp_data_obj_dict[isin].get_summen_anzahl_verkauft("float")
                dataliste.append(nV)

                # 6. Kauf-kurs
                Kkurs = self.wp_data_obj_dict[isin].get_mittel_Kkurs("float")
                dataliste.append(Kkurs)

                # 7. Verkauf-kurs
                Verhaeltnis = 0.
                if  anzahl <= 0.01: # keine WP mehr im depot
                    Vkurs = self.wp_data_obj_dict[isin].get_mittel_Vkurs("float")
                    dataliste.append(Vkurs)
                    if abs(Kkurs) >= 0.000001:
                        Verhaeltnis = Vkurs/Kkurs
                    # end if
                else:
                # Abfrage
                    (self.status, self.errtext, Akurs, Adatum) = \
                        self.wp_func_obj.get_act_price_volume(isin=isin,
                                                              pricetype="float",
                                                              dattype="datStrP")
                    if self.status != hdef.OKAY:
                        return ([], [], steuer_flag)

                    if abs(Kkurs) >= 0.000001:
                        Verhaeltnis = Akurs/Kkurs
                    # end if

                    dataliste.append(Akurs)
                # end if

                # 8. Verhaeltnis
                dataliste.append(float(int(Verhaeltnis * 1000. + 0.5)) / 1000.)

                # 9. Kaufwert
                Kwert = self.wp_data_obj_dict[isin].get_sum_Kwert("euroStrK")
                dataliste.append(Kwert)

                # 10. Verkaufwert
                Vwert = self.wp_data_obj_dict[isin].get_sum_Vwert("euroStrK")
                dataliste.append(Vwert)

                # 11. Dividenen-Wert
                Dwert = self.wp_data_obj_dict[isin].get_sum_Dwert("euroStrK")
                dataliste.append(Dwert)

                # 12. Kosten
                Kosten = self.wp_data_obj_dict[isin].get_sum_Kosten("euroStrK")
                dataliste.append(Kosten)

                # 13. Bilanz
                vwert = htype.type_transform_direct(Vwert, 'euroStrK', "euro")
                kwert = htype.type_transform_direct(Kwert, 'euroStrK', "euro")
                dwert = htype.type_transform_direct(Dwert, 'euroStrK', "euro")
                # kostwert = self.wp_data_obj_dict[isin].get_sum_Kostwert("euro")

                bilanz_euro = vwert + dwert - kwert
                if anzahl <= 0.01: # alles abgewickelt
                    pass
                else:

                    Verkauf_schaetzwert = ((nK - nV) * Akurs)
                    bilanz_euro         += Verkauf_schaetzwert
                    if steuer_flag: # mit grober Steuerannahme

                        bilanz_euro -= max(0.0,(Verkauf_schaetzwert - kwert)) * 0.5
                    # end if
                # end if
                summe_bilanz += bilanz_euro
                dataliste.append(htype.type_transform_direct(bilanz_euro, "euro", 'euroStrK'))

                # 14 Katalg
                katalog = self.wp_data_obj_dict[isin].get_katalog()
                dataliste.append(katalog)

                data_lliste.append(dataliste)
                row_color_dliste.append(self.wp_color_dict[isin])
            # end if
        # end for
        
        # Summenzeile
        index = header_liste.index("Bilanz")
        (okay, summe_bilanz) = htype.type_transform(summe_bilanz, 'euro', type_liste[index])

        end_zeile = htype.type_get_default(type_liste,value_flag=False)
        
        end_zeile[1] = "Summe:"
        end_zeile[index] = summe_bilanz

        data_lliste.append(end_zeile)
        
        ttable = htvar.build_table(header_liste,data_lliste,type_liste)
        
        # print
        
        return (ttable,row_color_dliste,steuer_flag)

        
    # end def
    def get_depot_daten_sets_overview_katalog(self,katalog):
        '''
                hole von jedem WP die Zusammenfassungen wenn es die gewünschte Katalog hat

        :param katalog:
        :return: (ttable,row_color_dliste) = self.get_depot_daten_sets_overview_katalog(katalog)
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
            kat = self.wp_data_obj_dict[isin].get_katalog()
            
            flag = False
            if kat == katalog:
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
                anzahl = self.wp_data_obj_dict[isin].get_summen_anzahl("float")
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
        
        ttable = htvar.build_table(header_liste, data_lliste, type_liste)
        
        # print
        
        return (ttable, row_color_dliste)
    # end def
    def get_depot_daten_sets_isin(self,isin):
        '''
        
        :param isin: isin number
        :return: (ttable,titlename) = self.get_depot_daten_sets_isin(isin)
        
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
        
        ttable = self.wp_data_obj_dict[isin].get_data_set_ttable(header_liste,type_liste)

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
        
        # print
        
        return (ttable, line_color_liste)
        
    # end def


    def get_depot_daten_sets_isin_irow(self, isin,irow):
        '''
    
        :param isin: isin number
        :param irow: row number
        :return: (tliste,buchungs_type_list, buchtype_index_in_header_liste) = self.get_depot_daten_sets_isin_irow(isin,irow)
    
        '''
        
        if isin not in self.isin_liste:
            self.status = hdef.NOT_OKAY
            self.errtext = f"get_depot_daten_sets_isin: gewünschte isin = {isin} is nicht in Depot enthalten"
            return (None, [],0)
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
        
        data_set_tlist = self.wp_data_obj_dict[isin].get_one_data_set_tlist(irow,header_liste, type_liste)
        
        if self.wp_data_obj_dict[isin].status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.wp_data_obj_dict[isin].errtext
            return (None, [],0)
        # end if
        
        buchtype_index_in_header_liste = header_liste.index(self.par.DEPOT_DATA_NAME_BUCHTYPE) # siehe header_liste
        buchungs_type_list = self.par.DEPOT_BUCHTYPE_TEXT_LIST
        
        # print
        
        return (data_set_tlist,buchungs_type_list,buchtype_index_in_header_liste)
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
        
        # print
        
        return immutable_liste
    # end def
    def set_data_set_isin_irow(self,tliste:htvar.TList,isin, irow):
        '''
        
        :param new_data_list:
        :param isin:
        :param irow:
        :return: new_data_set_flag = self.set_data_set_isin_irow(tliste, isin, irow)
        '''
    
        new_data_set_flag = False
        
        if isin not in self.isin_liste:
            self.status = hdef.NOT_OKAY
            self.errtext = f"get_depot_daten_sets_isin: gewünschte isin = {isin} is nicht in Depot enthalten"
            return False
        # end if
        
        new_data_set_flag = self.wp_data_obj_dict[isin].set_edit_data_set_in_irow(tliste,irow,self.par.LINE_COLOR_EDIT)

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
        
        # print
        
        return new_data_set_flag
    # end def
    def delete_wp_isin(self,isin):
        """
        :param isin:
        :return: status  = obj.delete_wp_isin(isin)
        """
        if isin not in self.isin_liste:
            self.status = hdef.NOT_OKAY
            self.errtext = f"delete_wp_isin: gewünschte isin = {isin} is nicht in Depot enthalten"
            return self.status
        # end if
        if isin not in self.wp_data_obj_dict.keys():
            self.status = hdef.NOT_OKAY
            self.errtext = f"delete_wp_isin: gewünschte isin = {isin} is nicht in wp_data_obj_dict enthalten"
            return self.status
        # end if

        index = self.isin_liste.index(isin)
        self.isin_liste    = hlist.erase_from_list(self.isin_liste, index )
        self.wp_name_liste = hlist.erase_from_list(self.wp_name_liste, index )

        del self.wp_data_obj_dict[isin]
        self.n_wp_data_obj -= 1

        del self.wp_color_dict[isin]

        return self.status
    # end def
    def delete_in_data_set(self,konto_obj,isin,irow):
        '''
        
        :param isin:
        :param irow:
        :return: status = self.delete_in_data_set(isin,irow)
        '''

        # print test
        if self.konto_obj != konto_obj:
            print('-=-' * 30)
            print(f"set konto_obj {self.konto_obj = } does not fit with external set {konto_obj =}")
            print('-=-' * 30)
            raise Exception(f"set konto_obj {self.konto_obj = } does not fit with external set {konto_obj =}")
        # end if


        # id
        id = self.wp_data_obj_dict[isin].get_id_of_irow(irow)

        if self.wp_data_obj_dict[isin].status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.wp_data_obj_dict[isin].errtext
            return self.status
        # end if

        # Lösche id in wp-Datensatz
        self.wp_data_obj_dict[isin].delete_in_wp_data_set(irow)

        if self.wp_data_obj_dict[isin].status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.wp_data_obj_dict[isin].errtext
            return self.status
        # end if

        # Im Konto soll nicht gelöscht werden
        # # finde konto row in konto_data_set
        # irow_konto = konto_obj.get_irow_by_id(id)
        # if irow_konto < 0:
        #     self.status = hdef.NOT_OKAY
        #     self.errtext = f"In Konto: {konto_obj.konto_name} konnte id = {id} nicht gefunden werden !!!!"
        #     return self.status
        # # end if
        #
        # # Lösche in Konto
        # (self.status, self.errtext) = konto_obj.delete_data_set(irow_konto)
        
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
        
        
        tliste = self.wp_data_obj_dict[isin].get_one_data_set_tlist(irow, header_liste, type_liste)
        if self.wp_data_obj_dict[isin].status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.wp_data_obj_dict[isin].errtext
            return self.status
        # end if
        flag = False
        buchtype = htvar.get_val_from_list(tliste,self.par.DEPOT_DATA_NAME_BUCHTYPE)
        anzahl   = htvar.get_val_from_list(tliste,self.par.DEPOT_DATA_NAME_ANZAHL)
        wert     = htvar.get_val_from_list(tliste,self.par.DEPOT_DATA_NAME_WERT)
        kosten   = htvar.get_val_from_list(tliste,self.par.DEPOT_DATA_NAME_KOSTEN)
        steuer   = htvar.get_val_from_list(tliste,self.par.DEPOT_DATA_NAME_STEUER)
        if buchtype == self.par.DEPOT_BUCHTYPE_NAME_WP_KAUF:
            if anzahl > 0.01:
                kurs = (wert-kosten-steuer)/anzahl
                kurs = int(kurs + 0.5)
                flag = True
        elif buchtype == self.par.DEPOT_BUCHTYPE_NAME_WP_VERKAUF:
            if anzahl > 0.01:
                kurs = (wert+kosten+steuer)/anzahl
                kurs = int(kurs+0.5)
                flag = True
        elif buchtype == self.par.DEPOT_BUCHTYPE_NAME_WP_KOSTEN:
            print("Kursabfrage fehlt!!")
            kurs = 0
        elif buchtype == self.par.DEPOT_BUCHTYPE_NAME_WP_EINNAHMEN:
            print("Kursabfrage fehlt!!")
            kurs = 0
        # end if
        
        if flag:
            self.wp_data_obj_dict[isin].set_item_in_irow(kurs, self.par.DEPOT_DATA_NAME_KURS, "cent", irow,self.par.LINE_COLOR_EDIT)

            if self.wp_data_obj_dict[isin].status != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = self.wp_data_obj_dict[isin].errtext
                return self.status
            # end if
            
            self.wp_color_dict[isin] = self.par.LINE_COLOR_EDIT
        
        # print
        
        return self.status
    # end dfe
    def update_data_ttable(self,isin,changed_pos_list,ttable_update ):
        '''
        
        :param isin:
        :param update_date_lliste:
        :param changed_pos_list:
        :return: status = self.update_data_ttable(isin,changed_pos_list,ttable_update)
        '''
        if isin not in self.isin_liste:
            self.status = hdef.NOT_OKAY
            self.errtext = f"update_data_llist: gewünschte isin = {isin} is nicht in Depot enthalten"
            return self.status
        # end if
        
        new_flag = False

        for (irow, icol) in changed_pos_list:
            header = ttable_update.names[icol]
            type   = ttable_update.types[icol]
            value = ttable_update.table[irow][icol]

            if header == self.par.DEPOT_DATA_NAME_ANZAHL:
                kurs = self.verify_value_anzahl(isin, irow, value, type)
                if kurs is not None:
                    self.wp_data_obj_dict[isin].set_item_in_irow(kurs, self.par.DEPOT_DATA_NAME_KURS, type, irow,
                                                                 self.par.LINE_COLOR_EDIT)
                # endif
            elif header == self.par.DEPOT_DATA_NAME_KOSTEN:
                
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
        # print
        return (self.status,new_flag)
    # end def
    def verify_value_anzahl(self,isin, irow, value, type):
        """
        :param isin:
        :param irow:
        :param value:
        :param type:
        :return: kurs = self.verify_value_anzahl(isin, irow, value, type)
        """
        kurs = None
        if isin not in self.isin_liste:
            self.status = hdef.NOT_OKAY
            self.errtext = f"update_data_llist: gewünschte isin = {isin} is nicht in Depot enthalten"
            return kurs
        # end if
        # convert in float
        (okay, anzahl) = htype.type_transform(value, type, 'float')
        if okay != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = f"verify_value:  Fehler transform data_item = <{value}> von type: <{type}> in type {'cent'} wandeln !!!!!!"
            return kurs
        # end if
        buchtype_index = self.wp_data_obj_dict[isin].get_one_data_item(irow, self.par.DEPOT_DATA_NAME_BUCHTYPE, 'int')
        if self.wp_data_obj_dict[isin].status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.wp_data_obj_dict[isin].errtext
            return kurs
        # end if

        wert = self.wp_data_obj_dict[isin].get_one_data_item(irow, self.par.DEPOT_DATA_NAME_WERT, 'euro')
        kosten = self.wp_data_obj_dict[isin].get_one_data_item(irow, self.par.DEPOT_DATA_NAME_KOSTEN, 'euro')
        steuer = self.wp_data_obj_dict[isin].get_one_data_item(irow, self.par.DEPOT_DATA_NAME_STEUER, 'euro')
        if self.wp_data_obj_dict[isin].status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.wp_data_obj_dict[isin].errtext
            return kurs
        # end if

        if buchtype_index == self.par.DEPOT_BUCHTYPE_INDEX_WP_KAUF:
            if abs(anzahl) >= 1e-6:
                kurs = (wert - kosten - steuer) / anzahl
            # end if
        elif buchtype_index == self.par.DEPOT_BUCHTYPE_INDEX_WP_VERKAUF:
            if abs(anzahl) >= 1e-6:
                kurs = (wert + kosten + steuer) / anzahl
            # end if
        # end if

        return kurs
    # end if
    def verify_value_kosten(self,isin,irow,value,type):
        # print
        return self.verify_value(isin,irow,'kosten',value,type)
    # end def
    def verify_value_steuer(self,isin,irow,value,type):
        # print
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
        if (kurswert is not None) and (anzahl > 0.01):
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
        
        # print
        
        return (value,kurs,kosten_calc,steuer_calc)
    # end def
    def reset_line_color(self):
        '''
        
        :return:
        '''
        for isin in self.isin_liste:
            self.wp_data_obj_dict[isin].reset_line_color()
            self.wp_color_dict[isin] = self.par.LINE_COLOR_BASE
        # end for
    # end def
    def save_katalog_from_active_isin_in_wp_store(self):

        (status, errtext) = self.wp_func_obj.erase_active_isin_katalog_for_depot(self.depot_kurz_name)
        if status != hdef.OKAY:
            return (status, errtext)

        # isin_dict_katalog = {'isin1': 'katalogx', 'isin2': 'katalogy', ...}
        isin_dict_katalog = {}
        change_flag = False
        for isin in self.isin_liste:

            anzahl = self.wp_data_obj_dict[isin].get_summen_anzahl("float")

            if anzahl > 0.01:
                katalog = self.wp_data_obj_dict[isin].get_katalog()

                if len(katalog) != 0:
                    isin_dict_katalog[isin] = katalog
                    change_flag = True
                # end if
            # end if
        # end for
        if change_flag:
            (status, errtext) = self.wp_func_obj.set_active_isin_katalog_for_depot(self.depot_kurz_name,isin_dict_katalog)
        # end if

        return (status, errtext)
    # end def
# end class