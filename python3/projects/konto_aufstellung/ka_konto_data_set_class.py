#
#
#   beinhaltet die data_llist ´für eingelesene KontoDaten und funktion dafür
#
import os, sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif


import hfkt_def as hdef
import hfkt_type as htype
import hfkt_list as hlist
import hfkt_date_time as hdate
import hfkt_str as hstr
import ka_data_class_defs

# import os, sys
# from dataclasses import dataclass, field
# from typing import List


#
# 1. Parameter dafür
# KONTO_BUCHTYPE_TEXT_LIST          Buchungs typen liste
# KONTO_BUCHTYPE_INDEX_XXX          der entsprechende Index
# KONTO_DATA_BUCHTYPE_DICT          das ganze als dictionary
#
# KONTO_DATA_ITEM_LLIST             liste von Liste mit (name,type_intern,type_extern)
# KONTO_DATA_INDEX_XXX              der entsprechende index
# KONTO_DATA_INDEX_LIST             liste mit allen indices
# KONTO_DATA_INMUTABLE_INDEX_LIST   indizes die nicht geändert werden dürfen, weil fest oder berechnet
# KONTO_DATA_ITEM_LIST             einfache Liste mit nur namen
# KONTO_DATA_TYPE_INTERN_DICT      interne Datentypen
# KONTO_DATA_EXTERN_TYPE_DICT      externe (zum Zeigen) Datentypen
#
# KONTO_DATA_HEADER_CSV_NAME_DICT   Namens dictionary mit key = index und value = Header Name in csv
# KONTO_DATA_HEADER_EXTERN_DICT    Namens dictionry mit gleichem key und interne Name für die Abfrage
# KONTO_DATA_BUCHTYPE_CSV_NAME_DICT Namens (string oder list[string]) dictionary mit möglichen Namen in csv für die Zuordnung
# KONTO_DATA_TO_EXTERN_DICT         Welche Werte sollen extern über Maske eingelesen werden
# -------------------
class KontoDataSet:
    # BUchungs Typ
    KONTO_BUCHTYPE_INDEX_UNBEKANNT: int = 0
    KONTO_BUCHTYPE_INDEX_EINZAHLUNG: int = 1
    KONTO_BUCHTYPE_INDEX_AUSZAHLUNG: int = 2
    KONTO_BUCHTYPE_INDEX_KOSTEN: int = 3
    KONTO_BUCHTYPE_INDEX_WP_KAUF: int = 4
    KONTO_BUCHTYPE_INDEX_WP_VERKAUF: int = 5
    KONTO_BUCHTYPE_INDEX_WP_KOSTEN: int = 6
    KONTO_BUCHTYPE_INDEX_WP_EINNAHMEN: int = 7
    KONTO_BUCHTYPE_INDEX_EINNAHMEN: int = 8

    KONTO_DATA_BUCHTYPE_DICT = {KONTO_BUCHTYPE_INDEX_UNBEKANNT: "unbekannt"
        , KONTO_BUCHTYPE_INDEX_EINZAHLUNG: "einzahlung"
        , KONTO_BUCHTYPE_INDEX_AUSZAHLUNG: "auszahlung"
        , KONTO_BUCHTYPE_INDEX_KOSTEN: "kosten"
        , KONTO_BUCHTYPE_INDEX_WP_KAUF: "wp_kauf"
        , KONTO_BUCHTYPE_INDEX_WP_VERKAUF: "wp_verkauf"
        , KONTO_BUCHTYPE_INDEX_WP_KOSTEN: "wp_kosten"
        , KONTO_BUCHTYPE_INDEX_WP_EINNAHMEN: "wp_einnahmen"
        , KONTO_BUCHTYPE_INDEX_EINNAHMEN:"einnahmen"}
    
    KONTO_BUCHTYPE_TEXT_LIST = []
    KONTO_BUCHTYPE_INDEX_LIST = []
    for key in KONTO_DATA_BUCHTYPE_DICT.keys():
        KONTO_BUCHTYPE_TEXT_LIST.append(KONTO_DATA_BUCHTYPE_DICT[key])
        KONTO_BUCHTYPE_INDEX_LIST.append(key)
    # end for
    # dict[index][0] = '+' muss größer gleich null sein
    #                  '-' muss kleiner null sein
    # dict[index][1] = wenn Bedignung nicht erfüllt, dann nehme das
    
    KONTO_DATA_BUCHTYPE_PROOF_DICT = {KONTO_BUCHTYPE_INDEX_EINZAHLUNG:[+1,KONTO_BUCHTYPE_INDEX_AUSZAHLUNG]
                                     ,KONTO_BUCHTYPE_INDEX_AUSZAHLUNG:[-1,KONTO_BUCHTYPE_INDEX_EINZAHLUNG]
                                     , KONTO_BUCHTYPE_INDEX_KOSTEN:    [-1, KONTO_BUCHTYPE_INDEX_EINNAHMEN]
                                     , KONTO_BUCHTYPE_INDEX_EINNAHMEN: [+1, KONTO_BUCHTYPE_INDEX_KOSTEN]
                                     , KONTO_BUCHTYPE_INDEX_WP_KAUF:    [-1, KONTO_BUCHTYPE_INDEX_WP_VERKAUF]
                                     , KONTO_BUCHTYPE_INDEX_WP_VERKAUF: [+1, KONTO_BUCHTYPE_INDEX_WP_KAUF]
                                     , KONTO_BUCHTYPE_INDEX_WP_KOSTEN:    [-1, KONTO_BUCHTYPE_INDEX_WP_EINNAHMEN]
                                     , KONTO_BUCHTYPE_INDEX_WP_EINNAHMEN: [+1, KONTO_BUCHTYPE_INDEX_WP_KOSTEN]
                                      }
    
    
    # Indizes in erinem data_set
    KONTO_DATA_INDEX_ID: int = 0
    KONTO_DATA_INDEX_BUCHDATUM: int = 1
    KONTO_DATA_INDEX_WERTDATUM: int = 2
    KONTO_DATA_INDEX_WER: int = 3
    KONTO_DATA_INDEX_BUCHTYPE: int = 4
    KONTO_DATA_INDEX_WERT: int = 5
    KONTO_DATA_INDEX_SUMWERT: int = 6
    KONTO_DATA_INDEX_COMMENT: int = 7
    KONTO_DATA_INDEX_CHASH: int = 8
    KONTO_DATA_INDEX_ISIN: int = 9
    KONTO_DATA_INDEX_KATEGORIE: int = 10
    
    KONTO_DATA_INDEX_LIST = [KONTO_DATA_INDEX_ID, KONTO_DATA_INDEX_BUCHDATUM, KONTO_DATA_INDEX_WERTDATUM
        , KONTO_DATA_INDEX_WER, KONTO_DATA_INDEX_BUCHTYPE, KONTO_DATA_INDEX_WERT
        , KONTO_DATA_INDEX_SUMWERT, KONTO_DATA_INDEX_COMMENT, KONTO_DATA_INDEX_CHASH
        , KONTO_DATA_INDEX_ISIN, KONTO_DATA_INDEX_KATEGORIE]
    
    KONTO_DATA_IMMUTABLE_INDEX_LIST = [KONTO_DATA_INDEX_ID, KONTO_DATA_INDEX_CHASH]
    
    KONTO_DATA_NAME_ID: str = "id"
    KONTO_DATA_NAME_BUCHDATUM = "buchdatum"
    KONTO_DATA_NAME_WERTDATUM = "wertdatum"
    KONTO_DATA_NAME_WER = "wer"
    KONTO_DATA_NAME_BUCHTYPE = "buchtype"
    KONTO_DATA_NAME_WERT = "wert"
    KONTO_DATA_NAME_SUMWERT = "sumwert"
    KONTO_DATA_NAME_COMMENT = "comment"
    KONTO_DATA_NAME_CHASH = "chash"
    KONTO_DATA_NAME_ISIN = "isin"
    KONTO_DATA_NAME_KATEGORIE = "kategorie"
    
    KONTO_DATA_LLIST = [
        [KONTO_DATA_INDEX_ID, KONTO_DATA_NAME_ID, "int"],
        [KONTO_DATA_INDEX_BUCHDATUM, KONTO_DATA_NAME_BUCHDATUM, "dat"],
        [KONTO_DATA_INDEX_WERTDATUM, KONTO_DATA_NAME_WERTDATUM, "dat"],
        [KONTO_DATA_INDEX_WER, KONTO_DATA_NAME_WER, "str"],
        [KONTO_DATA_INDEX_BUCHTYPE, KONTO_DATA_NAME_BUCHTYPE, KONTO_BUCHTYPE_INDEX_LIST],
        [KONTO_DATA_INDEX_WERT, KONTO_DATA_NAME_WERT, "cent"],
        [KONTO_DATA_INDEX_SUMWERT, KONTO_DATA_NAME_SUMWERT, "cent"],
        [KONTO_DATA_INDEX_COMMENT, KONTO_DATA_NAME_COMMENT, "str"],
        [KONTO_DATA_INDEX_CHASH, KONTO_DATA_NAME_CHASH, "int"],
        [KONTO_DATA_INDEX_ISIN, KONTO_DATA_NAME_ISIN, "str"],
        [KONTO_DATA_INDEX_KATEGORIE, KONTO_DATA_NAME_KATEGORIE, "str"],
    ]
    KONTO_DATA_NAME_DICT = {}
    KONTO_DATA_TYPE_DICT = {}
    KONTO_DATA_NAME_LIST = []
    KONTO_DATA_TYPE_LIST = []
    # KONTO_DATA_INDEX_LIST = []
    for liste in KONTO_DATA_LLIST:
        KONTO_DATA_NAME_DICT[liste[0]] = liste[1]
        KONTO_DATA_TYPE_DICT[liste[0]] = liste[2]
        KONTO_DATA_NAME_LIST.append(liste[1])
        KONTO_DATA_TYPE_LIST.append(liste[2])
        # KONTO_DATA_INDEX_LIST.append(liste[0])
    
    # end for
    
    KONTO_DATA_EXTERN_LLIST = [
        [KONTO_DATA_INDEX_BUCHDATUM, KONTO_DATA_NAME_BUCHDATUM, "datStrP"],
        [KONTO_DATA_INDEX_WERTDATUM, KONTO_DATA_NAME_WERTDATUM, "datStrP"],
        [KONTO_DATA_INDEX_WER, KONTO_DATA_NAME_WER, "str"],
        [KONTO_DATA_INDEX_BUCHTYPE, KONTO_DATA_NAME_BUCHTYPE, KONTO_BUCHTYPE_TEXT_LIST],
        [KONTO_DATA_INDEX_WERT, KONTO_DATA_NAME_WERT, "euroStrK"],
        [KONTO_DATA_INDEX_SUMWERT,KONTO_DATA_NAME_SUMWERT, "euroStrK"],
        [KONTO_DATA_INDEX_COMMENT, KONTO_DATA_NAME_COMMENT, "str"],
        [KONTO_DATA_INDEX_ISIN, KONTO_DATA_NAME_ISIN, "str"],
        [KONTO_DATA_INDEX_KATEGORIE, KONTO_DATA_NAME_KATEGORIE, "str"],
    ]
    KONTO_DATA_EXTERN_NAME_DICT = {}
    KONTO_DATA_EXTERN_TYPE_DICT = {}
    KONTO_DATA_EXTERN_NAME_LIST = []
    KONTO_DATA_EXTERN_TYPE_LIST = []
    KONTO_DATA_EXTERN_INDEX_LIST = []
    for liste in KONTO_DATA_EXTERN_LLIST:
        KONTO_DATA_EXTERN_NAME_DICT[liste[0]] = liste[1]
        KONTO_DATA_EXTERN_TYPE_DICT[liste[0]] = liste[2]
        KONTO_DATA_EXTERN_NAME_LIST.append(liste[1])
        KONTO_DATA_EXTERN_TYPE_LIST.append(liste[2])
        KONTO_DATA_EXTERN_INDEX_LIST.append(liste[0])
    # end for
    
    OKAY = hdef.OK
    NOT_OKAY = hdef.NOT_OK
    
    def __init__(self,konto_name):
        self.konto_name: str = konto_name
        self.KONTO_DATA_CSV_NAME_DICT = {}
        self.KONTO_DATA_CSV_TYPE_DICT = {}
        
        self.status = hdef.OK
        self.errtext = ""
        self.infotext = ""
        self.konto_start_wert: int = 0
        self.konto_start_datum: int = 0
        self.DECIMAL_TRENN_STR: str = ","
        self.TAUSEND_TRENN_STR: str = "."
        self.data_set_llist: list = []
        self.n_data_sets: int = 0
        self.new_read_id_list: list = []
        self.idfunc = None
        self.wpfunc = None
        
    def get_buchtype_index(self,buchttype_name: str):
        index = None
        for key, val in self.KONTO_DATA_BUCHTYPE_DICT.items():
            if val == buchttype_name:
                index = key
                break
            # end if
        # end for
        return index
    # end def
    def get_name_index(self, konto_data_name: str):
        index = None
        for key, val in self.KONTO_DATA_NAME_DICT.items():
            if val == konto_data_name:
                index = key
                break
            # end if
        # end for
        return index
    # end def
    def get_titlename(self):
        '''

        :return:
        '''
        titlename = f"Konto: {self.konto_name} "
        
        return titlename
    
    # end def
    
    def set_starting_data_llist(self,konto_data_set_dict_list,konto_data_type_dict, idfunc,wpfunc, konto_start_datum, konto_start_wert, decimal_trenn="",
                                tausend_trenn=""):
        
        self.data_set_llist = self.set_dat_set_dict_list(konto_data_set_dict_list,konto_data_type_dict)
        self.n_data_sets = len(self.data_set_llist)
        self.idfunc = idfunc
        self.wpfunc = wpfunc
        self.konto_start_datum = konto_start_datum
        self.konto_start_wert = konto_start_wert
        self.DECIMAL_TRENN_STR = decimal_trenn
        self.TAUSEND_TRENN_STR = tausend_trenn
        
        # Liste neu anlegen
        if self.n_data_sets == 0:
            
            new_data_list = []
            new_data_index_list = []
            new_data_type_list = []
            for index in self.KONTO_DATA_EXTERN_NAME_DICT.keys():
                # --------------------------------------
                # buchdatum
                if index == self.KONTO_DATA_INDEX_BUCHDATUM:
                    (okay, wert) = htype.type_transform(self.konto_start_datum, self.KONTO_DATA_TYPE_DICT[index],self.KONTO_DATA_EXTERN_TYPE_DICT[index])
                    if okay != hdef.OKAY:
                        raise Exception(
                            f"Fehler initialisierung  buchdatum {self.konto_start_datum} von type: {self.KONTO_DATA_TYPE_DICT[index]} in type {self.KONTO_DATA_EXTERN_TYPE_DICT[index]} wandeln !!!")
                    # end if
                    new_data_list.append(wert)
                    new_data_index_list.append(index)
                    new_data_type_list.append(self.KONTO_DATA_EXTERN_TYPE_DICT[index])
                # --------------------------------------
                # wertdatum
                elif index == self.KONTO_DATA_INDEX_WERTDATUM:
                    (okay, wert) = htype.type_transform(self.konto_start_datum, self.KONTO_DATA_TYPE_DICT[index],self.KONTO_DATA_EXTERN_TYPE_DICT[index])
                    if okay != hdef.OKAY:
                        raise Exception(
                            f"Fehler initialisierung  buchdatum {self.konto_start_datum} von type: {self.KONTO_DATA_TYPE_DICT[index]} in type {self.KONTO_DATA_EXTERN_TYPE_DICT[index]} wandeln !!!")
                    # end if
                    new_data_list.append(wert)
                    new_data_index_list.append(index)
                    new_data_type_list.append(self.KONTO_DATA_EXTERN_TYPE_DICT[index])
                # --------------------------------------
                # wer
                elif index == self.KONTO_DATA_INDEX_WER:
                    new_data_list.append("Startwert")
                    new_data_index_list.append(index)
                    new_data_type_list.append("str")
                # --------------------------------------
                # buchtype
                elif index == self.KONTO_DATA_INDEX_BUCHTYPE:
                    new_data_list.append(self.KONTO_DATA_BUCHTYPE_DICT[self.KONTO_BUCHTYPE_INDEX_EINZAHLUNG])
                    new_data_index_list.append(index)
                    new_data_type_list.append(self.KONTO_BUCHTYPE_TEXT_LIST)
                # --------------------------------------
                # wert
                elif index == self.KONTO_DATA_INDEX_WERT:
                    new_data_list.append(0.0)
                    new_data_index_list.append(index)
                    new_data_type_list.append("euro")
                # --------------------------------------
                # sumwert
                elif index == self.KONTO_DATA_INDEX_SUMWERT:
                    (okay, wert) = htype.type_transform(self.konto_start_wert, "cent",self.KONTO_DATA_EXTERN_TYPE_DICT[index])
                    if okay != hdef.OKAY:
                        raise Exception(
                            f"Fehler initialisierung  summe {self.konto_start_wert} von type: {self.KONTO_DATA_TYPE_DICT[index]} in type {self.KONTO_DATA_EXTERN_TYPE_DICT[index]} wandeln !!!")
                    # end if
                    new_data_list.append(wert)
                    new_data_index_list.append(index)
                    new_data_type_list.append(self.KONTO_DATA_EXTERN_TYPE_DICT[index])
                # --------------------------------------
                # comment
                elif index == self.KONTO_DATA_INDEX_COMMENT:
                    new_data_list.append("Startwert")
                    new_data_index_list.append(index)
                    new_data_type_list.append("str")
                # --------------------------------------
                # isin
                elif index == self.KONTO_DATA_INDEX_ISIN:
                    new_data_list.append("")
                    new_data_index_list.append(index)
                    new_data_type_list.append("str")
                # --------------------------------------
                # kategorie
                elif index == self.KONTO_DATA_INDEX_KATEGORIE:
                    new_data_list.append("")
                    new_data_index_list.append(index)
                    new_data_type_list.append("str")
                else:
                    raise Exception(f"Problem start Zeile erzeugen index = {index} in if-struct nicht gefunden !!!")
            # end for
            new_data_matrix = [new_data_list]
            
            # ---------------------------------------------------------
            # add data set as first data
            ((new_data_set_flag,status,errtext) ) = self.set_new_data(new_data_matrix , new_data_index_list, new_data_type_list)
            if status != hdef.OKAY:
                raise Exception(f"Problem start Zeile erzeugen set_new_data() errtext = {errtext} !!!")
            # end
        else:
            if self.data_set_llist[0][self.KONTO_DATA_INDEX_SUMWERT] != self.konto_start_wert:
                self.update_sumwert_in_lliste(0)
            # end if
        # end if
    
    # end def
    def set_data_set_extern_liste(self, new_data_set, irow):
        '''

        :param new_data_set:
        :param irow:
        :return: (new_data_set_flag, status, errtext) = self.set_data_set_extern_liste(,new_data_list,irow)
        '''
        new_data_set_flag       = False
        new_data_buchdatum_flag = False
        new_data_wert_flag      = False

        # set data_set
        # ============================
        if self.n_data_sets == 0:
            raise Exception(f"set_data_set_extern_liste Error n_data_sets = 0")
        index_row = irow
        if index_row >= self.n_data_sets:
            index_row = self.n_data_sets - 1
            
        data_set_list = self.data_set_llist[index_row]
        
        for i,item in enumerate(new_data_set):
            index = self.KONTO_DATA_EXTERN_INDEX_LIST[i]
            (okay, wert) = htype.type_transform(item, self.KONTO_DATA_EXTERN_TYPE_DICT[index],self.KONTO_DATA_TYPE_DICT[index])
            if okay != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = f"Fehler transform {self.KONTO_DATA_EXTERN_NAME_DICT[index]} mit Wert {item} von type: {self.KONTO_DATA_EXTERN_TYPE_DICT[index]} lässt sich nicht in {self.KONTO_DATA_TYPE_DICT[index]}  wandeln !!!"
                return (new_data_set_flag, self.status, self.errtext)
            # end if
            if wert != data_set_list[index]:
                data_set_list[index] = wert
                new_data_set_flag = True
                if index == self.KONTO_DATA_INDEX_BUCHDATUM:
                    new_data_buchdatum_flag = True
                # end if
                if index == self.KONTO_DATA_INDEX_WERT:
                    new_data_wert_flag = True
                # end if
            # endif
        # end for
        self.data_set_llist[index_row] = data_set_list
        
        if  new_data_set_flag and  (data_set_list[self.KONTO_DATA_INDEX_ID] not in self.new_read_id_list):
            self.new_read_id_list.append(data_set_list[self.KONTO_DATA_INDEX_ID])

        # sort
        if new_data_buchdatum_flag:
            self.sort_data_set_llist()
        # end if

        # recalc_sum
        if new_data_wert_flag:
            self.recalc_sum_data_set_llist()
        # end if

        return (new_data_set_flag,self.status,self.errtext)
    # end def
    def set_one_new_data_set_extern_liste(self,new_data_set: list):
        return self.set_new_data([new_data_set],self.KONTO_DATA_EXTERN_INDEX_LIST,self.KONTO_DATA_EXTERN_TYPE_LIST)
    def set_new_data(self, new_data_matrix: list, new_data_idenx_list: list, new_data_type_list: list):
        '''
        
        :param new_data_matrix:  eingelesene Daten (z.B. csv-Datei)
        :param konto_dict:  das Konto ictionary mit allen ini-Infos
        :param new_data_idenx_list:    Name der eingelsenen Datei für errtext
        :return: (new_data_set_flag,status,errtex) =  self.set_new_data(self,new_data_matrix,new_data_idenx_list,new_data_type_list)
        '''
        self.status = hdef.OKAY
        
        (new_data_dict_list, new_type_dict) = self.filt_and_new_data_dict(new_data_matrix, new_data_idenx_list,new_data_type_list)
        if self.status != hdef.OKAY:
            return (False, self.status, self.errtext)
        # endif
        
        new_data_dict_list = self.transform_new_data_dict(new_data_dict_list, new_type_dict)
        if self.status != hdef.OKAY:
            return (False, self.status, self.errtext)
        # endif
        
        # proof data dict list 1) buchtype zu Wert
        #------------------------------------------
        new_data_dict_list = self.proof_new_data_dict(new_data_dict_list)
        
        # sort new data
        #--------------
        new_data_dict_list = hlist.sort_list_of_dict(new_data_dict_list, self.KONTO_DATA_INDEX_BUCHDATUM, aufsteigend=1)

        
        new_data_dict_list = self.build_internal_values_new_data_dict(new_data_dict_list)
        if self.status != hdef.OKAY:
            return (False, self.status, self.errtext)
        # endif
        
        new_data_set_flag = self.add_new_data_dict(new_data_dict_list)
        if self.status != hdef.OKAY:
            return (False, self.status, self.errtext)
        # endif

        # sort
        self.sort_data_set_llist()

        # recalc_sum
        self.recalc_sum_data_set_llist()

        return (new_data_set_flag, self.status, self.errtext)
    
    # enddef
    def update_isin_find(self):
        
        index_id = self.KONTO_DATA_INDEX_LIST.index(self.KONTO_DATA_INDEX_ID)
        
        for i,data_set in enumerate(self.data_set_llist):
            (data_set,change_flag) = self.update_isin_data_set_list(data_set)
            if change_flag:
                self.data_set_llist[i] = data_set
                self.new_read_id_list.append(data_set[index_id])
            # end if
            
        # end ofr
    def get_data_set_dict_list(self):
        '''
         konto_data_set_dict =
        :return:
        '''
        
        konto_data_dict_list = []
        for liste in self.data_set_llist:
            ddict = {}
            for index in self.KONTO_DATA_INDEX_LIST:
                ddict[self.KONTO_DATA_NAME_DICT[index]] = liste[index]
            # end for
            konto_data_dict_list.append(ddict)
        # end for
        
        return konto_data_dict_list
    # end def
    def set_dat_set_dict_list(self,konto_data_dict_list,konto_data_type_dict):
        '''
        
        :param konto_data_dict_list:
        :param konto_data_type_dict:
        :return:
        '''
        # base_konto_data_set_list = [None for item in self.KONTO_DATA_INDEX_LIST]
        
        konto_data_llist = []
        for data_dict in konto_data_dict_list:
            konto_data_set_list = [None for item in self.KONTO_DATA_INDEX_LIST]
            for name in data_dict.keys():
                index = hlist.find_first_key_dict_value(self.KONTO_DATA_NAME_DICT, name)
                if index is not None:
                    (okay, wert) = htype.type_transform(data_dict[name],konto_data_type_dict[name],self.KONTO_DATA_TYPE_DICT[index])
                    if okay == hdef.OK:
                        konto_data_set_list[index]= wert
                    else:
                        raise Exception("Problem")
                    # end if
                # end if
            # end for
            konto_data_llist.append(konto_data_set_list)
            del konto_data_set_list
        # end for

        return konto_data_llist
    def get_data_type_dict(self):
        '''
        
        :return:
        '''
        data_type_dict = {}
        for key in self.KONTO_DATA_NAME_DICT.keys():
            data_type_dict[self.KONTO_DATA_NAME_DICT[key]] = self.KONTO_DATA_TYPE_DICT[key]
        # end for
        
        return  data_type_dict
    # end def
    def get_anzeige_data_llist(self, istart: int, dir: int, number_of_lines: int):
        '''
        
        :param istart:           aktuelle start zeile
        :param dir:              dir=1 vorwärts blättern, dir=0 starten, dir=-1 rückwärts blättern
        :param number_of_lines:  Anzahl der zeilen, die gezeigt werden soll
        :return: (istart,header_list,data_llist,new_data_list) = self.get_anzeige_data_llist(istart, dir, number_of_lines)
        '''
        
        # build range
        # =========================
        (istart, iend) = self.build_range_to_show_dataset(istart, number_of_lines, dir)
        
        # build to show data_llist
        # =========================
        (header_list, data_llist, new_data_list) = self.build_data_table_list_and_color_list(istart, iend)
        
        return (istart, header_list, data_llist, new_data_list)
    
    # end def
    def write_anzeige_back_data(self, new_data_llist, data_changed_pos_list, istart):
        '''
        
        :param new_data_llist:
        :param data_changed_pos_list:
        :param istart:
        :return: self.write_anzeige_back_data(new_data_llist, data_changed_pos_list, istart)
        '''
        self.infotext = ""
        self.errtext = ""
        
        index_liste = list(self.KONTO_DATA_EXTERN_NAME_DICT.keys())
        
        changed = False
        for (irow, icol) in data_changed_pos_list:
            
            index_data_set = index_liste[icol]
            if index_data_set not in self.KONTO_DATA_IMMUTABLE_INDEX_LIST:
                (okay, wert) = htype.type_transform(new_data_llist[irow][icol], self.KONTO_DATA_EXTERN_TYPE_DICT[index_data_set],
                                                    self.KONTO_DATA_TYPE_DICT[index_data_set])
                if okay != hdef.OKAY:
                    self.status = hdef.NOT_OKAY
                    self.errtext = f"Fehler transform  {new_data_llist[irow][icol]} von type: {self.KONTO_DATA_EXTERN_TYPE_DICT[index_data_set]} in type {self.KONTO_DATA_TYPE_DICT[index_data_set]} wandeln !!!"
                    return
                # end if
                self.data_set_llist[istart + irow][index_data_set] = wert
                # if index_data_set == self.KONTO_DATA_INDEX_WERT:
                changed = True
                # end if
            else:
                self.infotext = f"Der Wert von {self.KONTO_DATA_EXTERN_NAME_DICT[index_data_set]} mit dem Wert {new_data_llist[irow][icol]} darf nicht verändert werden !!!!!!!"
            # end if
        # end for
        

        
        if changed:
            # sort
            self.sort_data_set_llist()
            # recalc
            self.update_sumwert_in_lliste(istart)
        # end if
    
    # end def
    def update_sumwert_in_lliste(self,istart):
        '''
        
        :return:
        '''
        
        if istart == 0:
            sumwert = self.konto_start_wert
        else:
            sumwert = self.data_set_llist[istart - 1][self.KONTO_DATA_INDEX_SUMWERT]
        # end if
        
        i = istart
        while i < self.n_data_sets:
            sumwert += self.data_set_llist[i][self.KONTO_DATA_INDEX_WERT]
            
            self.data_set_llist[i][self.KONTO_DATA_INDEX_SUMWERT] = int(sumwert)
            
            print(f"i={i} wert = {self.data_set_llist[i][self.KONTO_DATA_INDEX_WERT]} sumwert = {self.data_set_llist[i][self.KONTO_DATA_INDEX_SUMWERT]} | {sumwert} ")
            
            i += 1
        
        # end while
        
    def delete_new_data_list(self):
        '''
        
        :return: self.delete_new_data_list()
        '''
        self.new_read_id_list = []
    
    # end def
    def get_edit_data(self,irow):
        '''
        
        :param irow:
        :return: (data_set, buchungs_type_list, buchtype_index_in_header_liste) = self.get_edit_data(irow)
        '''
        header_liste = []
        for key in self.KONTO_DATA_EXTERN_NAME_DICT.keys():
            header_liste.append(self.KONTO_DATA_EXTERN_NAME_DICT[key])
        # end for
        
        if self.KONTO_DATA_INDEX_BUCHTYPE in self.KONTO_DATA_EXTERN_NAME_DICT.keys():
            buchtype_index_in_header_liste = self.KONTO_DATA_EXTERN_INDEX_LIST.index(self.KONTO_DATA_INDEX_BUCHTYPE)
        else:
            buchtype_index_in_header_liste = -1
        # endif
        
        # data_set
        # ============================
        if self.n_data_sets == 0:
            raise Exception(f"get_edit_data Error n_data_sets = 0")
        index = irow
        if( index >= self.n_data_sets ):
            index = self.n_data_sets - 1
            
        data_set_list = self.data_set_llist[index]
        data_set = []
        for key in self.KONTO_DATA_EXTERN_NAME_DICT.keys():
            (okay, wert) = htype.type_transform(data_set_list[key],self.KONTO_DATA_TYPE_DICT[key],self.KONTO_DATA_EXTERN_TYPE_DICT[key])
            if okay != hdef.OKAY:
                raise Exception(
                    f"Fehler transform  {data_set_list[key]} von type: {self.KONTO_DATA_TYPE_DICT[key]} in type {self.KONTO_DATA_EXTERN_TYPE_DICT[key]} wandeln !!!")
            # end if
            data_set.append(wert)
        # end for

        return (data_set,header_liste, self.KONTO_BUCHTYPE_TEXT_LIST, buchtype_index_in_header_liste)
    
    # end def
    def get_data_to_add_lists(self):
        '''
        index_in_header_liste index in header list für buch type
        :return: (header_liste, buchungs_type_list, buchtype_index_in_header_liste) =  self.get_data_to_add_lists()
        '''
        
        header_liste = []
        for key in self.KONTO_DATA_EXTERN_NAME_DICT.keys():
            header_liste.append(self.KONTO_DATA_EXTERN_NAME_DICT[key])
        # end for
        
        if self.KONTO_DATA_INDEX_BUCHTYPE in self.KONTO_DATA_EXTERN_NAME_DICT.keys():
            buchtype_index_in_header_liste = self.KONTO_DATA_EXTERN_INDEX_LIST.index(self.KONTO_DATA_INDEX_BUCHTYPE)
        else:
            buchtype_index_in_header_liste = -1
        # endif
        
        return (header_liste, self.KONTO_BUCHTYPE_TEXT_LIST, buchtype_index_in_header_liste)
    
    # end def
    
    # def add_new_data_set(self, new_data_list, header_liste, type_liste):
    #     '''
    #
    #     :new_data_list:
    #     :param header_liste:
    #     :return: (new_data_set_flag, status, serrtext) = self.add_new_data_set(new_data_list,header_liste)
    #     '''
    #
    #     new_data_dict = self.get_data_from_new_data_list(new_data_list, header_liste)
    #
    #     new_data_dict_list = [new_data_dict]
    #
    #     new_data_dict_list = self.filt_and_sort_new_data_dict(new_data_dict_list)
    #     if (self.status != hdef.OKAY):
    #         return (False, self.status, self.errtext)
    #     # endif
    #
    #     new_data_dict_list = self.build_internal_values_new_data_dict(new_data_dict_list)
    #     if (self.status != hdef.OKAY):
    #         return (False, self.status, self.errtext)
    #     # endif
    #
    #     new_data_set_flag = self.add_new_data_dict_and_recalc_sum(new_data_dict_list)
    #     if (self.status != hdef.OKAY):
    #         return (False, self.status, self.errtext)
    #     # endif
    #
    #     return (new_data_set_flag, self.status, self.errtext)
    #
    # # end def
    def delete_data_list(self, irow):
        '''
        
        :param irow:
        :return: (status,errtext) = delete_data_list(irow)
        '''
        if irow < 0:
            self.status = hdef.NOT_OKAY
            self.errtext = f"KontoDataSet.delete_data_list: irow = {irow} is negative"
        
        elif irow >= len(self.data_set_llist):
            self.status = hdef.NOT_OKAY
            self.errtext = f"KontoDataSet.delete_data_list: irow = {irow} >= len(data_set_llist) = {len(self.data_set_llist)}"
        else:
            del self.data_set_llist[irow]
            self.n_data_sets = len(self.data_set_llist)
        # end if
        
        return (self.status, self.errtext)
    
    # end def
    #-------------------------------------------------------------------------------------------------------------------
    # intern functions
    #-------------------------------------------------------------------------------------------------------------------
    def filt_and_new_data_dict(self, new_data_matrix, new_data_idenx_list, new_data_type_list):
        '''
        
        :param new_data_matrix:
        :param new_data_idenx_list:
        :param new_data_type_list:
        :return: (new_data_dict_list,new_type_dict) = self.filt_and_sort_new_data_dict(new_data_matrix,new_data_idenx_list,new_data_type_list)
        '''
        
        # new data type dict
        # -------------------
        index = 0
        new_type_dict = {}
        for konto_index in new_data_idenx_list:
            new_type_dict[konto_index] = new_data_type_list[index]
            index += 1
        # end for
        
        # filt new data
        # --------------
        new_filt_data_dict_list = []
        chash_is_set = False
        for new_data_list in new_data_matrix:
            index = 0
            new_data_dict = {}
            for konto_index in new_data_idenx_list:
                new_data_dict[konto_index] = new_data_list[index]
                index += 1
            # end for
            
            value = new_data_dict[self.KONTO_DATA_INDEX_COMMENT] + new_data_dict[self.KONTO_DATA_INDEX_BUCHDATUM] + \
                    str(new_data_dict[self.KONTO_DATA_INDEX_WERT])
            
            chash_new = htype.type_convert_to_hashkey(value)
            
            flag = True
            for data_set in self.data_set_llist:
                
                chash = data_set[self.KONTO_DATA_INDEX_CHASH]
                
                if (chash_new == chash):
                    flag = False
                    break
                # end if
            # end for
            
            if flag:
                # add new chash to filtered dictionary
                chash_is_set = True
                new_data_dict[self.KONTO_DATA_INDEX_CHASH] = chash_new
                new_filt_data_dict_list.append(new_data_dict)
            # end if
        # end for
        
        # sort new data
        # sortiere neue Einträge nach buchdatum

        if chash_is_set:
            new_type_dict[self.KONTO_DATA_INDEX_CHASH] = self.KONTO_DATA_TYPE_DICT[self.KONTO_DATA_INDEX_CHASH]

        return (new_filt_data_dict_list, new_type_dict)
    
    # end def
    def transform_new_data_dict(self, new_data_dict_list, new_type_dict):
        '''
        
        :param new_data_dict_list:
        :param new_type_dict:
        :return: new_data_dict_list = self.transform_new_data_dict(new_data_dict_list, new_type_dict)
        '''
        n = len(new_data_dict_list)
        for index in range(n):
            data_dict = new_data_dict_list[index]
            for konto_data_index in data_dict.keys():
                value_to_transform = data_dict[konto_data_index]
                value_typ = new_type_dict[konto_data_index]
                # if( value_to_transform == '"-70,04"'):
                #     print(value_to_transform)
                (okay, wert) = htype.type_transform(value_to_transform, value_typ,self.KONTO_DATA_TYPE_DICT[konto_data_index])
                if okay != hdef.OKAY:
                    raise Exception(
                        f"Fehler transform  <{value_to_transform}> von type: {value_typ} in type {self.KONTO_DATA_TYPE_DICT[konto_data_index]} wandeln !!!")
                # end if
                
                # schreibe gewandelten Wert wieder zurück
                data_dict[konto_data_index] = wert
            # end for
            new_data_dict_list[index] = data_dict
        # end for
        
        return new_data_dict_list
    
    # end def
    
    def proof_new_data_dict(self,new_data_dict_list):
        '''
        
        :param new_data_dict_list:
        :return: new_data_dict_list = self.proof_new_data_dict(new_data_dict_list)
        '''
        n = len(new_data_dict_list)
        for index in range(n):
            data_dict = new_data_dict_list[index]
            change_flag = False
            if (self.KONTO_DATA_INDEX_BUCHTYPE in data_dict) and (self.KONTO_DATA_INDEX_WERT in data_dict):
                buchtype_index = data_dict[self.KONTO_DATA_INDEX_BUCHTYPE]
                if buchtype_index in self.KONTO_DATA_BUCHTYPE_PROOF_DICT.keys():
                    wert_type = self.KONTO_DATA_BUCHTYPE_PROOF_DICT[buchtype_index][0]
                    
                    if  wert_type > 0: # soll positiv sein
                        if data_dict[self.KONTO_DATA_INDEX_WERT] < 0:
                            data_dict[self.KONTO_DATA_INDEX_BUCHTYPE] = self.KONTO_DATA_BUCHTYPE_PROOF_DICT[buchtype_index][1]
                            change_flag = True
                        # end if
                    else: # soll negative sein
                        if data_dict[self.KONTO_DATA_INDEX_WERT] > 0:
                            data_dict[self.KONTO_DATA_INDEX_BUCHTYPE] = self.KONTO_DATA_BUCHTYPE_PROOF_DICT[buchtype_index][1]
                            change_flag = True
                        # end if
                    # end if
                # end if
            # end if
            
            if change_flag:
                new_data_dict_list[index] = data_dict
        
        # end for
        
        return new_data_dict_list
    # end def
    def build_internal_values_new_data_dict(self, new_data_dict_list):
        '''
        
        :param new_data_dict_list:
        :return: new_data_dict_list = self.build_internal_values_new_data_dict(new_data_dict_list)
        '''
        
        # isin Nummer, wenn eine wp Buchungs type
        # id wert mit self.idfunc.get_new_id()
        # chash hash.Wert vom ursprünglichen Kommentar
        # kategorie als leerer string
        n = len(new_data_dict_list)
        for i in range(n):
            
            data_dict = new_data_dict_list[i]
            
            if (data_dict[self.KONTO_DATA_INDEX_BUCHTYPE] == self.KONTO_BUCHTYPE_INDEX_WP_KAUF) or \
                (data_dict[self.KONTO_DATA_INDEX_BUCHTYPE] == self.KONTO_BUCHTYPE_INDEX_WP_VERKAUF) or \
                (data_dict[self.KONTO_DATA_INDEX_BUCHTYPE] == self.KONTO_BUCHTYPE_INDEX_WP_KOSTEN) or \
                (data_dict[self.KONTO_DATA_INDEX_BUCHTYPE] == self.KONTO_BUCHTYPE_INDEX_WP_EINNAHMEN):
                if self.KONTO_DATA_INDEX_ISIN in data_dict.keys():
                    isin_in = data_dict[self.KONTO_DATA_INDEX_ISIN]
                else:
                    isin_in = None
                # end if
                if self.KONTO_DATA_INDEX_COMMENT in data_dict.keys():
                    comment = data_dict[self.KONTO_DATA_INDEX_COMMENT]
                else:
                    comment = ""
                # end if
                
                isin = self.search_isin(isin_in,comment)
            else:
                isin = ""
            # end if
            
            # ISIN if detected
            data_dict[self.KONTO_DATA_INDEX_ISIN] = isin
            
            # count up IDMAX
            data_dict[self.KONTO_DATA_INDEX_ID] = self.idfunc.get_new_id()
            
            data_dict[self.KONTO_DATA_INDEX_KATEGORIE] = ""
            data_dict[self.KONTO_DATA_INDEX_SUMWERT] = 0
            
            # proof if evry index is set
            for index in self.KONTO_DATA_INDEX_LIST:
                if index not in data_dict.keys():
                    data_dict[index] = htype.type_get_default(self.KONTO_DATA_TYPE_DICT[index])
                # end if
            # end ofr
            
            new_data_dict_list[i] = data_dict
        # endfor
        return new_data_dict_list
    # end def
    def update_isin_data_set_list(self,data_set):
        '''
        
        :param data_set:
        :return: (data_set, change_flag) = self.update_isin_data_set_list(data_set)
        '''
    
        change_flag = False
        
        index_buch_type = self.KONTO_DATA_INDEX_LIST.index(self.KONTO_DATA_INDEX_BUCHTYPE)
        index_isin = self.KONTO_DATA_INDEX_LIST.index(self.KONTO_DATA_INDEX_ISIN)
        index_comment = self.KONTO_DATA_INDEX_LIST.index(self.KONTO_DATA_INDEX_COMMENT)

        if (data_set[index_buch_type] == self.KONTO_BUCHTYPE_INDEX_WP_KAUF) or \
            (data_set[index_buch_type] == self.KONTO_BUCHTYPE_INDEX_WP_VERKAUF) or \
            (data_set[index_buch_type] == self.KONTO_BUCHTYPE_INDEX_WP_KOSTEN) or \
            (data_set[index_buch_type] == self.KONTO_BUCHTYPE_INDEX_WP_EINNAHMEN):
        
            isin_in = data_set[index_isin]
            
            if (len(isin_in) == 0) or (isin_in == "isinnotfound"):
                isin_in = None
                
            comment = data_set[index_comment]
        
            isin = self.search_isin(isin_in, comment)
        else:
            isin = ""
        # endif
        
        if( isin != data_set[index_isin]):
            data_set[index_isin] = isin
            change_flag = True
        # end if
    
        return (data_set, change_flag)
    # end def
    def search_isin(self,isin_in, comment):
        '''
        
        :param isin_in:
        :param comment:
        :return: isin = self.search_isin(isin_in, comment)
        '''
    
        # if isin is explicit set use proofed isin
        if isin_in is not None:
            (okay, isin) = htype.type_proof_isin(isin_in)
        else:
            okay = hdef.NOT_OKAY
        # end if
    
        # if not search isin from comment
        if (okay != hdef.OKAY) and (len(comment) > 0):
            (okay, isin) = htype.type_proof_isin(comment)
        # end if
    
        # if not search wkn from comment
        if (okay != hdef.OKAY) and (len(comment) > 0):
            (okay, isin) = self.search_wkn_from_comment(comment)
        # end if
    
        if (okay != hdef.OKAY):
            isin = "isinnotfound"
        # end if
        
        return isin
    
    def search_wkn_from_comment(self,comment):
        '''
        
        :param comment:
        :return: (okay, wkn,isin) = self.search_wkn_from_comment(comment)
        '''
        
        isin = ""
        
        (okay, wkn) = htype.type_proof_wkn(comment)
        
        # search for special
        if okay != hdef.OKAY:
                index = hstr.such(comment, "XETRA-GOLD")
                if index >= 0:
                    isin = "DE000A0S9GB0"
                    wkn  = "A0S9GB"
                    okay = hdef.OKAY
                else:
                    isin = ""
                    wkn = ""
                    okay = hdef.NOT_OKAY
                # end if
            # end if
        else:
            print(f"Start getting isin from wkn: {wkn} ")
            (okay, isin) = self.wpfunc.get_isin_from_wkn(wkn)
            print(f"End getting isin from wkn: {wkn}, isin = {isin} ")
        # end if
        
        # search wpname in comment
        if okay != hdef.OKAY:
            (okay,isin) = self.wpfunc.find_wpname_in_comment_get_isin(comment)
        # end if
        
        return (okay,isin)
    # end def
    
    def add_new_data_dict(self, new_data_dict_list):
        '''
        
        :param new_data_dict_list:
        :return: self.add_new_data_dict_and_recalc_sum(new_data_dict_list)
        '''
        self.new_read_id_list = []
        new_data_flag = False
        for data_dict in new_data_dict_list:
            data_set_list = []
            for index in self.KONTO_DATA_INDEX_LIST:
                data_set_list.append(data_dict[index])
            # end for
            
            if len(data_set_list) > 0:
                self.data_set_llist.append(data_set_list)
                self.new_read_id_list.append(data_set_list[self.KONTO_DATA_INDEX_ID])
                new_data_flag = True
            # end for

        self.n_data_sets = len(self.data_set_llist)

        return new_data_flag
    # end def
    def sort_data_set_llist(self):
        # sort
        self.data_set_llist = hlist.sort_list_of_list(self.data_set_llist, self.KONTO_DATA_INDEX_BUCHDATUM,
                                                      aufsteigend=1)
    # end def
    def recalc_sum_data_set_llist(self):

        sumwert = self.konto_start_wert
        for i in range(len(self.data_set_llist)):
            sumwert += self.data_set_llist[i][self.KONTO_DATA_INDEX_WERT]
            
            self.data_set_llist[i][self.KONTO_DATA_INDEX_SUMWERT] = sumwert
        # end for
    # end def
    def build_range_to_show_dataset(self, istart, number_of_lines, dir):
        '''

        :param nlines:  maximale Anzahl an Zeilen
        :param istart:  letzte startzeile (-1 ist beginn)
        :param number_of_lines:   Wieviele Zeile zeigen
        :param dir:     -1 zurück, +1 vorwärts, dir = 0 start
        :return:     (istart,iend) = build_range_to_show_dataset(istart,number_of_lines,dir)
        '''
        if dir == 0:  # Start with newest part
            istart = max(0, self.n_data_sets - number_of_lines)
        elif dir > 0:
            istart = min(istart + number_of_lines, max(0, self.n_data_sets - number_of_lines))
        else:
            istart = max(istart - number_of_lines, 0)
        # endif
        iend = min(istart + number_of_lines - 1, max(0, self.n_data_sets - 1))
        return (istart, iend)
    
    # end def
    def build_data_table_list_and_color_list(self, istart=0, iend=-1):
        '''
        
        :param istart:
        :param iend:
        :return: (header_list, data_llist, new_data_list) = self.build_data_table_list_and_color_list(istart,iend)
        '''
        
        if iend < 0:
            iend = self.n_data_sets-1
        # end if
        
        # 1) header_liste
        # ===========================
        header_list = []
        for key in self.KONTO_DATA_EXTERN_NAME_DICT.keys():
            header_list.append(self.KONTO_DATA_EXTERN_NAME_DICT[key])
        # end for
        
        # 2) data_llist,new_data_list
        # ============================
        data_llist = []
        new_data_list = []
        index = istart
        while (index <= iend) and (index < self.n_data_sets):
            data_set_list = self.data_set_llist[index]
            data_list = []
            for key in self.KONTO_DATA_EXTERN_NAME_DICT.keys():
                (okay, wert) = htype.type_transform(data_set_list[key],self.KONTO_DATA_TYPE_DICT[key],self.KONTO_DATA_EXTERN_TYPE_DICT[key])
                if okay != hdef.OKAY:
                    raise Exception(
                        f"Fehler transform  {data_set_list[key]} von type: {self.KONTO_DATA_TYPE_DICT[key]} in type {self.KONTO_DATA_EXTERN_TYPE_DICT[key]} wandeln !!!")
                # end if
                data_list.append(wert)
                # if key == self.KONTO_DATA_INDEX_BUCHDATUM:
                #     data_list.append(hdate.secs_time_epoch_to_str(data_set_list[key]))
                # elif key == self.KONTO_DATA_INDEX_WERTDATUM:
                #     data_list.append(hdate.secs_time_epoch_to_str(data_set_list[key]))
                # elif key == self.KONTO_DATA_INDEX_BUCHTYPE:
                #     data_list.append(self.KONTO_BUCHTYPE_TEXT_LIST[data_set_list[key]])
                # elif key == self.KONTO_DATA_INDEX_WERT:
                #     data_list.append(hstr.convert_int_cent_to_string_euro(data_set_list[key], self.DECIMAL_TRENN_STR))
                # elif key == self.KONTO_DATA_INDEX_SUMWERT:
                #     data_list.append(hstr.convert_int_cent_to_string_euro(data_set_list[key], self.DECIMAL_TRENN_STR))
                # else:
                #     data_list.append(data_set_list[key])
                # # end if
            # end for
            data_llist.append(data_list)
            if data_set_list[self.KONTO_DATA_INDEX_ID] in self.new_read_id_list:
                new_data_list.append(True)
            else:
                new_data_list.append(False)
            # end if
            index += 1
        # end while
        return (header_list, data_llist, new_data_list)
    # end def
    #-------------------------------------------------------------------------------------------------------------------
    # Werte abfrage
    #-------------------------------------------------------------------------------------------------------------------
    def get_number_of_data(self):
        return self.n_data_sets
    # endif
    def get_irow_by_id(self,id):
        '''
        
        :param id:
        :return:
        '''
        (okay, wert) = htype.type_proof(id, self.KONTO_DATA_TYPE_DICT[self.KONTO_DATA_INDEX_ID])
        if okay != hdef.OKAY:
            raise Exception(
                f"Fehler type proof of  id = {id} von type: {self.KONTO_DATA_TYPE_DICT[self.KONTO_DATA_INDEX_ID]} !!!")
        # end if
        
        index_liste = hlist.search_value_in_llist_return_indexlist(self.data_set_llist, self.KONTO_DATA_INDEX_ID, wert)
        
        if len(index_liste) > 1:
            raise Exception(
                f"Fehler mit  id = {id}, kommt im data_set mehrfach vor index_liste = {index_liste} !!!")
        # end if
        
        if len(index_liste) == 1:
            irow = index_liste[0]
        else:
            irow = -1
        # end if
        
        return irow
    # end def
    def set_konto_name(self):
        return self.konto_name
    def get_buchtype_str(self,i):
        if i < self.n_data_sets:
            return self.KONTO_DATA_BUCHTYPE_DICT[self.data_set_llist[i][self.KONTO_DATA_INDEX_BUCHTYPE]]
        else:
            return None
    # end def
    def get_data_item_at_irow(self,irow,data_name,data_type):
        '''
        
        :param irow:
        :param data_name:
        :param data_taype:
        :return: value = self.get_data_item_at_irow(i,data_name,data_type)
        '''
        if irow < self.n_data_sets:
            if data_name in self.KONTO_DATA_NAME_LIST:
                index = self.KONTO_DATA_NAME_LIST.index(data_name)
                val = self.data_set_llist[irow][index]
                (okay,value) = htype.type_transform(val,self.KONTO_DATA_TYPE_DICT[index],data_type)
                if okay != hdef.OKAY:
                    raise Exception(
                        f"get_data_item_at_irow: Fehler type_transform <{val}> von type: <{self.KONTO_DATA_TYPE_DICT[index]}> in type <{data_type}> wandeln !!!")
                # end if
                return value
            else:
                raise Exception(
                    f"get_data_item_at_irow: Fehler data_name: <{data_name}> not in KONTO_DATA_NAME_LIST: <{self.KONTO_DATA_NAME_LIST}> !!!")
            # end if
        else:
            return None
    # end def
# end class
