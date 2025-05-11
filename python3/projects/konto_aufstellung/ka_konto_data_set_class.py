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
    
    KONTO_DATA_BUCHTYPE_DICT = {KONTO_BUCHTYPE_INDEX_UNBEKANNT: "unbekannt"
        , KONTO_BUCHTYPE_INDEX_EINZAHLUNG: "einzahlung"
        , KONTO_BUCHTYPE_INDEX_AUSZAHLUNG: "auszahlung"
        , KONTO_BUCHTYPE_INDEX_KOSTEN: "kosten"
        , KONTO_BUCHTYPE_INDEX_WP_KAUF: "wp_kauf"
        , KONTO_BUCHTYPE_INDEX_WP_VERKAUF: "wp_verkauf"
        , KONTO_BUCHTYPE_INDEX_WP_KOSTEN: "wp_kosten"
        , KONTO_BUCHTYPE_INDEX_WP_EINNAHMEN: "wp_einnahmen"}
    KONTO_BUCHTYPE_TEXT_LIST = []
    for key in KONTO_DATA_BUCHTYPE_DICT.keys():
        KONTO_BUCHTYPE_TEXT_LIST.append(KONTO_DATA_BUCHTYPE_DICT[key])
    # end for
    
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
    
    KONTO_DATA_IMMUTABLE_INDEX_LIST = [KONTO_DATA_INDEX_ID, KONTO_DATA_INDEX_BUCHTYPE, KONTO_DATA_INDEX_CHASH]
    
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
        [KONTO_DATA_INDEX_BUCHTYPE, KONTO_DATA_INDEX_BUCHTYPE, "int"],
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
        [KONTO_DATA_INDEX_BUCHDATUM, "buchdatum", "datStrP"],
        [KONTO_DATA_INDEX_WERTDATUM, "wertdatum", "datStrP"],
        [KONTO_DATA_INDEX_WER, "wer", "str"],
        [KONTO_DATA_INDEX_BUCHTYPE, "buchtype", KONTO_BUCHTYPE_TEXT_LIST],
        [KONTO_DATA_INDEX_WERT, "wert", "euroStrK"],
        [KONTO_DATA_INDEX_SUMWERT, "sumwert", "euroStrK"],
        [KONTO_DATA_INDEX_COMMENT, "comment", "str"],
        [KONTO_DATA_INDEX_ISIN, "isin", "str"],
        [KONTO_DATA_INDEX_KATEGORIE, "kategorie", "str"],
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
    
    def __init__(self):
        self.KONTO_DATA_CSV_NAME_DICT = {}
        self.KONTO_DATA_CSV_TYPE_DICT = {}
        
        self.status = hdef.OK
        self.errtext = ""
        self.idmax: int = 0
        self.konto_start_wert: int = 0
        self.konto_start_datum: int = 0
        self.DECIMAL_TRENN_STR: str = ","
        self.TAUSEND_TRENN_STR: str = "."
        self.data_set_llist: list = []
        self.n_data_sets: int = 0
        self.new_read_id_list: list = []
    
    def get_index(self, konto_data_name: str):
        index = None
        for key, val in self.KONTO_DATA_NAME_DICT.items():
            if val == konto_data_name:
                index = key
                break
            # end if
        # end for
        return index
    # end def
    
    def set_starting_data_llist(self, data_set_llist, idmax, konto_start_datum, konto_start_wert, decimal_trenn="",
                                tausend_trenn=""):
        self.data_set_llist = data_set_llist
        self.n_data_sets = len(self.data_set_llist)
        self.idmax = idmax
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
                    new_data_type_list.append("dat")
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
                    new_data_type_list.append("dat")
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
                    new_data_type_list.append("float")
                # --------------------------------------
                # sumwert
                elif index == self.KONTO_DATA_INDEX_SUMWERT:
                    (okay, wert) = htype.type_transform(self.konto_start_wert, self.KONTO_DATA_TYPE_DICT[index],self.KONTO_DATA_EXTERN_TYPE_DICT[index])
                    if okay != hdef.OKAY:
                        raise Exception(
                            f"Fehler initialisierung  summe {self.konto_start_wert} von type: {self.KONTO_DATA_TYPE_DICT[index]} in type {self.KONTO_DATA_EXTERN_TYPE_DICT[index]} wandeln !!!")
                    # end if
                    new_data_list.append(wert)
                    new_data_index_list.append(index)
                    new_data_type_list.append("cent")
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
            # end if
        # end if
    
    # end def
    def set_new_data(self, new_data_matrix: list, new_data_idenx_list: list, new_data_type_list: list):
        '''
        
        :param new_data_matrix:  eingelesene Daten (z.B. csv-Datei)
        :param konto_dict:  das Konto ictionary mit allen ini-Infos
        :param new_data_idenx_list:    Name der eingelsenen Datei für errtext
        :return: (new_data_set_flag,status,errtex) =  self.set_new_data(self,new_data_matrix,new_data_idenx_list,new_data_type_list)
        '''
        self.status = hdef.OKAY
        
        (new_data_dict_list, new_type_dict) = self.filt_and_sort_new_data_dict(new_data_matrix, new_data_idenx_list,new_data_type_list)
        if self.status != hdef.OKAY:
            return (False, self.status, self.errtext)
        # endif
        
        new_data_dict_list = self.transform_new_data_dict(new_data_dict_list, new_type_dict)
        if self.status != hdef.OKAY:
            return (False, self.status, self.errtext)
        # endif
        
        new_data_dict_list = self.build_internal_values_new_data_dict(new_data_dict_list)
        if self.status != hdef.OKAY:
            return (False, self.status, self.errtext)
        # endif
        
        new_data_set_flag = self.add_new_data_dict_and_recalc_sum(new_data_dict_list)
        if self.status != hdef.OKAY:
            return (False, self.status, self.errtext)
        # endif
        
        return (new_data_set_flag, self.status, self.errtext)
    
    # enddef
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
        
        index_liste = list(self.KONTO_DATA_EXTERN_NAME_DICT.keys())
        
        wert_changed = False
        for (irow, icol) in data_changed_pos_list:
            
            index_data_set = index_liste[icol]
            if index_data_set not in self.KONTO_DATA_IMMUTABLE_INDEX_LIST:
                
                wert = self.transform_value(new_data_llist[irow][icol],
                                            self.KONTO_DATA_EXTERN_TYPE_DICT[index_data_set],
                                            self.KONTO_DATA_TYPE_DICT[index_data_set])
                if self.status == hdef.OKAY:
                    self.data_set_llist[istart + irow][index_data_set] = wert
                    if (index_data_set == self.KONTO_DATA_INDEX_WERT):
                        wert_changed = True
                # end if
            # end if
        # end for
        
        if wert_changed:
            if istart == 0:
                sumwert = self.konto_start_wert
            else:
                sumwert = self.data_set_llist[istart - 1][self.KONTO_DATA_INDEX_SUMWERT]
            # end if
            
            i = istart
            while (i < self.n_data_sets):
                sumwert += self.data_set_llist[i][self.KONTO_DATA_INDEX_WERT]
                
                self.data_set_llist[i][self.KONTO_DATA_INDEX_SUMWERT] = int(sumwert)
                
                i += 1
            # end while
        # end if
    
    # end def
    def delete_new_data_list(self):
        '''
        
        :return: self.delete_new_data_list()
        '''
        self.new_read_id_list = []
    
    # end def
    
    def get_data_to_add_lists(self):
        '''
        index_in_header_liste index in header list für buch type
        :return: (header_liste, buchungs_type_list, index_in_header_liste) =  self.get_data_to_add_lists()
        '''
        
        header_liste = []
        for key in self.KONTO_DATA_EXTERN_NAME_DICT.keys():
            header_liste.append(self.KONTO_DATA_EXTERN_NAME_DICT[key])
        # end for
        
        if self.KONTO_DATA_INDEX_BUCHTYPE in self.KONTO_DATA_EXTERN_NAME_DICT.keys():
            index_in_header_liste = self.KONTO_DATA_INDEX_BUCHTYPE
        else:
            index_in_header_liste = -1
        # endif
        
        return (header_liste, self.KONTO_BUCHTYPE_TEXT_LIST, index_in_header_liste)
    
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
            self.data_set_llist.pop(irow)
            self.n_data_sets = len(self.data_set_llist)
        # end if
        
        return (self.status, self.errtext)
    
    # end def
    # def get_data_from_new_data_list(self, new_data_list, header_liste):
    #     '''
    #
    #     :param new_data_list:
    #     :param header_liste:
    #     :return: new_data_dict = self.get_data_from_new_data_list(new_data_list, header_liste)
    #     '''
    #     new_data_dict = {}
    #     for index in range(min(len(new_data_list), len(header_liste))):
    #
    #         header = header_liste[index]
    #         value = new_data_list[index]
    #         flagfound = False
    #         for key in self.KONTO_DATA_TYPE_DICT.keys():
    #             if header == self.KONTO_DATA_TYPE_DICT[key]:
    #                 flagfound = True
    #                 index = key
    #                 break
    #             # end if
    #         # endfor
    #         if flagfound:
    #             wert = self.transform_value(value, index)
    #             if self.status != hdef.OKAY:
    #                 return []
    #             else:
    #                 new_data_dict[header] = wert
    #             # endif
    #         else:
    #             self.errtext = f"add_new_data_set: header: {header} with value {value} not found in self.KONTO_DATA_TYPE_INTERN_DICT"
    #             self.status = hdef.NOT_OKAY
    #         # end if
    #     # end for
    #     return new_data_dict
    #
    # def transform_value(self, wert_in, data_type_from, data_type_to, add_err_text=None):
    #     '''
    #
    #     :param wert_in:
    #     :param i_col_dataset:
    #     :param buch_type_dict:
    #     :param add_err_text:
    #     :return: wert = self.transform_value(wert_in,i_col_dataset,buch_type_dict,add_err_text="")
    #     '''
    #
    #     (okay, wert) = htype.type_transform(wert_in, data_type_from, data_type_to)
    #     if (okay != hdef.OKAY):
    #         self.status = hdef.NOT_OKAY
    #         self.errtext = f"transform_value_datum: error input = {wert_in} from type {data_type_from} into type {data_type_to} is not valid "
    #         if add_err_text: self.errtext += add_err_text
    #         return wert
    #     # endif
    #
    #     return wert
    #
    #     # # buchdatum
    #     # if (i_col_dataset == self.KONTO_DATA_INDEX_BUCHDATUM):
    #     #     (okay, wert) = htype.type_proof_dat(wert_in)
    #     #     if (okay != hdef.OKAY):
    #     #         self.status = hdef.NOT_OKAY
    #     #         self.errtext = f"transform_value_datum: error input buchdatum = <{wert_in}> is not valid "
    #     #         if add_err_text : self.errtext += add_err_text
    #     #         return wert
    #     #     # endif
    #     # # wertdatum
    #     # elif (i_col_dataset == self.KONTO_DATA_INDEX_WERTDATUM):
    #     #     (okay, wert) = htype.type_proof_dat(wert_in)
    #     #     if okay != hdef.OKAY:
    #     #         self.status = hdef.NOT_OKAY
    #     #         self.errtext = f"transform_value_datum: error input wertdatum = <{wert_in}> is not valid "
    #     #         if add_err_text : self.errtext += add_err_text
    #     #         return wert
    #     #     # endif
    #     # # wert
    #     # elif i_col_dataset == self.KONTO_DATA_INDEX_WERT:
    #     #     (okay, wert) = htype.type_convert_euro_to_cent(wert_in, delim=self.DECIMAL_TRENN_STR,
    #     #                                                    thousandsign=self.TAUSEND_TRENN_STR)
    #     #     if okay != hdef.OKAY:
    #     #         self.status = hdef.NOT_OKAY
    #     #         self.errtext = f"get_data_from_csv_lliste: error input wert = <{wert_in}> is not valid "
    #     #         if add_err_text : self.errtext += add_err_text
    #     #         return wert
    #     #     # endif
    #     # elif i_col_dataset == self.KONTO_DATA_INDEX_SUMWERT:
    #     #     (okay, wert) = htype.type_convert_euro_to_cent(wert_in, delim=self.DECIMAL_TRENN_STR,
    #     #                                                    thousandsign=self.TAUSEND_TRENN_STR)
    #     #     if okay != hdef.OKAY:
    #     #         self.status = hdef.NOT_OKAY
    #     #         self.errtext = f"get_data_from_csv_lliste: error input sumwert = <{wert_in}> is not valid  "
    #     #         if add_err_text : self.errtext += add_err_text
    #     #         return wert
    #     #     # endif
    #     # elif (i_col_dataset == self.KONTO_DATA_INDEX_BUCHTYPE):
    #     #     (okay, wert) = htype.type_proof_string(wert_in)
    #     #     if (okay != hdef.OKAY):
    #     #         self.status = hdef.NOT_OKAY
    #     #         self.errtext = f"get_data_from_csv_lliste: error input buchtype = <{wert_in}> is not valid "
    #     #         if add_err_text : self.errtext += add_err_text
    #     #         return wert
    #     #     else:
    #     #         if len(buch_type_dict.keys()) == 0:
    #     #             self.status = hdef.NOT_OKAY
    #     #             self.errtext = f"get_data_from_csv_lliste: error input buchtype = <{wert_in}>: buch_type_dict is not set with KontoDataSetParameter()"
    #     #             if add_err_text: self.errtext += add_err_text
    #     #             return None
    #     #         else:
    #     #             buchtype = self.get_data_buchtype(wert,buch_type_dict)
    #     #             if (self.status != hdef.OKAY):
    #     #                 self.errtext = f"get_data_from_csv_lliste: error input buchtype = <{wert_in}> is not found "
    #     #                 if add_err_text: self.errtext += add_err_text
    #     #                 return None
    #     #             # end if
    #     #         # end if
    #     #         wert = buchtype
    #     #     # end if
    #     # elif i_col_dataset == self.KONTO_DATA_INDEX_WER:
    #     #     (okay, wert) = htype.type_proof_string(wert_in)
    #     #     if (okay != hdef.OKAY):
    #     #         self.status = hdef.NOT_OKAY
    #     #         self.errtext = f"get_data_from_csv_lliste: error input wer = <{wert_in}> is not valid "
    #     #         if add_err_text : self.errtext += add_err_text
    #     #         return wert
    #     #     # endif
    #     # elif i_col_dataset == self.KONTO_DATA_INDEX_COMMENT:
    #     #     (okay, wert) = htype.type_proof_string(wert_in)
    #     #     if (okay != hdef.OKAY):
    #     #         self.status = hdef.NOT_OKAY
    #     #         self.errtext = f"get_data_from_csv_lliste: error input comment = <{wert_in}> is not valid "
    #     #         if add_err_text : self.errtext += add_err_text
    #     #         return wert
    #     #     # endif
    #     # else:
    #     #     raise Exception(f"i_col_dataset = {i_col_dataset} nicht gefunden")
    #     # # endif
    #
    # # end def
    # def get_data_buchtype(self, wert, buch_type_dict):
    #     '''
    #
    #     :param wert:
    #     :param par:
    #     :return: (okay, buchtype) =  get_data_buchtype(wert,buch_type_dict):
    #     '''
    #
    #     okay = hdef.OKAY
    #
    #     if len(buch_type_dict.keys()) == 0:
    #         raise Exception(f"get_data_buchtype: Parameter buch_type_dict is empty")
    #     # endif
    #     not_found = True
    #     for key in buch_type_dict.keys():
    #
    #         if isinstance(buch_type_dict[key], str):
    #             liste = [buch_type_dict[key]]
    #         else:
    #             liste = buch_type_dict[key]
    #         # end if
    #
    #         for item in liste:
    #             if wert == item:
    #                 buchtype = key
    #                 not_found = False
    #                 break
    #             # end if
    #         # end for
    #         if not not_found:
    #             break
    #     # end for
    #
    #     if not_found:
    #         buchtype = self.KONTO_BUCHTYPE_INDEX_UNBEKANNT
    #         self.status = hdef.NOT_OKAY
    #     # end if
    #
    #     return buchtype
    #
    # # end def
    #-------------------------------------------------------------------------------------------------------------------
    # intern functions
    #-------------------------------------------------------------------------------------------------------------------
    def filt_and_sort_new_data_dict(self, new_data_matrix, new_data_idenx_list, new_data_type_list):
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
                new_data_dict[self.KONTO_DATA_INDEX_CHASH] = chash_new
                new_filt_data_dict_list.append(new_data_dict)
            # end if
        # end for
        
        # sort new data
        # sortiere neue Einträge nach buchdatum
        keyname = self.KONTO_DATA_INDEX_BUCHDATUM
        new_filt_data_dict_list = hlist.sort_list_of_dict(new_filt_data_dict_list, keyname, aufsteigend=1)

        if self.KONTO_DATA_INDEX_CHASH in new_data_dict.keys():
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
                
                (okay, wert) = htype.type_transform(value_to_transform, value_typ,self.KONTO_DATA_TYPE_DICT[konto_data_index])
                if okay != hdef.OKAY:
                    raise Exception(
                        f"Fehler transform  {value_to_transform} von type: {value_typ} in type {self.KONTO_DATA_TYPE_DICT[konto_data_index]} wandeln !!!")
                # end if
                
                # schreibe gewandelten Wert wieder zurück
                data_dict[konto_data_index] = wert
            # end for
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
        # id wert mit self.idmax+1
        # chash hash.Wert vom ursprünglichen Kommentar
        # kategorie als leerer string
        n = len(new_data_dict_list)
        for index in range(n):
            
            data_dict = new_data_dict_list[index]
            
            if (data_dict[self.KONTO_DATA_INDEX_BUCHTYPE] == self.KONTO_BUCHTYPE_INDEX_WP_KAUF) or \
                (data_dict[self.KONTO_DATA_INDEX_BUCHTYPE] == self.KONTO_BUCHTYPE_INDEX_WP_VERKAUF) or \
                (data_dict[self.KONTO_DATA_INDEX_BUCHTYPE] == self.KONTO_BUCHTYPE_INDEX_WP_KOSTEN) or \
                (data_dict[self.KONTO_DATA_INDEX_BUCHTYPE] == self.KONTO_BUCHTYPE_INDEX_WP_EINNAHMEN):
                
                (okay, isin) = htype.type_proof_isin(data_dict[self.KONTO_DATA_INDEX_COMMENT])
                
                if (okay != hdef.OKAY):
                    isin = "isinnotfound"
                # end if
            else:
                isin = ""
            # end if
            
            # ISIN if detected
            data_dict[self.KONTO_DATA_INDEX_ISIN] = isin
            
            # count up IDMAX
            self.idmax += 1
            data_dict[self.KONTO_DATA_INDEX_ID] = self.idmax
            
            data_dict[self.KONTO_DATA_INDEX_KATEGORIE] = ""
            data_dict[self.KONTO_DATA_INDEX_SUMWERT] = 0
            
            new_data_dict_list[index] = data_dict
        # endfor
        return new_data_dict_list
    # end def
    def add_new_data_dict_and_recalc_sum(self, new_data_dict_list):
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
        
        # sort
        self.data_set_llist = hlist.sort_list_of_list(self.data_set_llist, self.KONTO_DATA_INDEX_BUCHDATUM,
                                                      aufsteigend=1)
        
        sumwert = self.konto_start_wert
        for i in range(len(self.data_set_llist)):
            sumwert += self.data_set_llist[i][self.KONTO_DATA_INDEX_WERT]
            
            self.data_set_llist[i][self.KONTO_DATA_INDEX_SUMWERT] = sumwert
        # end for
        
        self.n_data_sets = len(self.data_set_llist)
        
        return new_data_flag
    
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
    def build_data_table_list_and_color_list(self, istart, iend):
        '''
        
        :param istart:
        :param iend:
        :return: (header_list, data_llist, new_data_list) = self.build_data_table_list_and_color_list(istart,iend)
        '''
        
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
                if key == self.KONTO_DATA_INDEX_BUCHDATUM:
                    data_list.append(hdate.secs_time_epoch_to_str(data_set_list[key]))
                elif key == self.KONTO_DATA_INDEX_WERTDATUM:
                    data_list.append(hdate.secs_time_epoch_to_str(data_set_list[key]))
                elif key == self.KONTO_DATA_INDEX_BUCHTYPE:
                    data_list.append(self.KONTO_BUCHTYPE_TEXT_LIST[data_set_list[key]])
                elif key == self.KONTO_DATA_INDEX_WERT:
                    data_list.append(hstr.convert_int_cent_to_string_euro(data_set_list[key], self.DECIMAL_TRENN_STR))
                elif key == self.KONTO_DATA_INDEX_SUMWERT:
                    data_list.append(hstr.convert_int_cent_to_string_euro(data_set_list[key], self.DECIMAL_TRENN_STR))
                else:
                    data_list.append(data_set_list[key])
                # end if
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
# end class
