#
#
#   beinhaltet die data_llist ´für eingelesene KontoDaten und funktion dafür
#
import os, sys
import copy

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif


import hfkt_def as hdef
import hfkt_type as htype
import hfkt_list as hlist
import hfkt_date_time as hdate
import hfkt_str as hstr

import os, sys
from dataclasses import dataclass, field
from typing import List

#
# 1. Parameter dafür
#-------------------
class KontoDataSet:
    # Welche items/header hat die Doppelliste
    KONTO_DATA_ITEM_LIST: List[str] = ( "id"         # set internally
                                      , "buchdatum"  # int read from csv/pdf
                                      , "wertdatum"  # int read from csv/pdf
                                      , "wer"        # str read from csv/pdf
                                      , "buchtype"   # int raed from csv/pdf
                                      , "wert"       # int read from csv/pdf
                                      , "sumwert"    # set internally
                                      , "comment"    # str read from csv/pdf
                                      , "chash"      # set internally
                                      , "isin"       # str extracted from data
                                      , "kategorie") # internally set
    
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
                            ,KONTO_DATA_INDEX_WER, KONTO_DATA_INDEX_BUCHTYPE, KONTO_DATA_INDEX_WERT
                            ,KONTO_DATA_INDEX_SUMWERT, KONTO_DATA_INDEX_COMMENT, KONTO_DATA_INDEX_CHASH
                            ,KONTO_DATA_INDEX_ISIN, KONTO_DATA_INDEX_KATEGORIE]
    
    KONTO_DATA_INMUTABLE_INDEX_LIST = [KONTO_DATA_INDEX_ID,KONTO_DATA_INDEX_BUCHTYPE,KONTO_DATA_INDEX_CHASH]
    
    KONTO_BUCHTYPE_TEXT_LIST = ["unbekannt",
                                "einzahlung",
                                "auszahlung",
                                "kosten",
                                "wp_kauf",
                                "wp_verkauf",
                                "wp_kosten",
                                "wp_einnahmen"]
    # BUchungs Typ
    KONTO_BUCHTYPE_UNBEKANNT: int     = 0
    KONTO_BUCHTYPE_EINZAHLUNG: int    = 1
    KONTO_BUCHTYPE_AUSZAHLUNG: int    = 2
    KONTO_BUCHTYPE_KOSTEN: int        = 3
    KONTO_BUCHTYPE_WP_KAUF: int       = 4
    KONTO_BUCHTYPE_WP_VERKAUF: int    = 5
    KONTO_BUCHTYPE_WP_KOSTEN: int     = 6
    KONTO_BUCHTYPE_WP_EINNAHMEN:int   = 7
    
    KONTO_DATA_BUCHTYPE_DICT          = { KONTO_BUCHTYPE_UNBEKANNT: KONTO_BUCHTYPE_TEXT_LIST[KONTO_BUCHTYPE_UNBEKANNT]
                                        , KONTO_BUCHTYPE_EINZAHLUNG: KONTO_BUCHTYPE_TEXT_LIST[KONTO_BUCHTYPE_EINZAHLUNG]
                                        , KONTO_BUCHTYPE_AUSZAHLUNG: KONTO_BUCHTYPE_TEXT_LIST[KONTO_BUCHTYPE_AUSZAHLUNG]
                                        , KONTO_BUCHTYPE_KOSTEN: KONTO_BUCHTYPE_TEXT_LIST[KONTO_BUCHTYPE_KOSTEN]
                                        , KONTO_BUCHTYPE_WP_KAUF: KONTO_BUCHTYPE_TEXT_LIST[KONTO_BUCHTYPE_WP_KAUF]
                                        , KONTO_BUCHTYPE_WP_VERKAUF: KONTO_BUCHTYPE_TEXT_LIST[KONTO_BUCHTYPE_WP_VERKAUF]
                                        , KONTO_BUCHTYPE_WP_KOSTEN: KONTO_BUCHTYPE_TEXT_LIST[KONTO_BUCHTYPE_WP_KOSTEN]
                                        , KONTO_BUCHTYPE_WP_EINNAHMEN: KONTO_BUCHTYPE_TEXT_LIST[KONTO_BUCHTYPE_WP_EINNAHMEN]
                                        }
                                         
    OKAY = hdef.OK
    NOT_OKAY = hdef.NOT_OK
    
    
    def __init__(self):
        self.KONTO_DATA_HEADER_CSV_NAME_DICT = {}
        self.KONTO_DATA_HEADER_ABFRAGE_DICT = {}
    
        self.KONTO_DATA_BUCHTYPE_CSV_NAME_DICT = {}
        self.KONTO_DATA_TO_SHOW_DICT = {}
    
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

    def set_csv_header_name(self,dat_set_index: int,header_csv_name: str):
        self.KONTO_DATA_HEADER_CSV_NAME_DICT[dat_set_index] = header_csv_name
        self.KONTO_DATA_HEADER_ABFRAGE_DICT[dat_set_index] = self.KONTO_DATA_ITEM_LIST[dat_set_index]
    # enddef
    def set_buchtype_csv_name(self,buchtype_index: int,buchtype_dict_csv_name: str | list):
        self.KONTO_DATA_BUCHTYPE_CSV_NAME_DICT[buchtype_index] = buchtype_dict_csv_name
    # enddef
    def set_data_show_dict_list(self,dat_set_index: int):
        self.KONTO_DATA_TO_SHOW_DICT[dat_set_index] = self.KONTO_DATA_ITEM_LIST[dat_set_index]
    # enddef

    def set_starting_data_llist(self,data_set_llist,idmax,konto_start_datum,konto_start_wert,decimal_trenn="",tausend_trenn=""):
        self.data_set_llist = copy.deepcopy(data_set_llist)
        self.n_data_sets = len(self.data_set_llist)
        self.idmax = copy.deepcopy(idmax)
        self.konto_start_datum =  copy.deepcopy(konto_start_datum)
        self.konto_start_wert = copy.deepcopy(konto_start_wert)
        self.DECIMAL_TRENN_STR = copy.deepcopy(decimal_trenn)
        self.TAUSEND_TRENN_STR = copy.deepcopy(tausend_trenn)
        
        if self.n_data_sets == 0:
            
            header_liste = []
            for key in self.KONTO_DATA_HEADER_ABFRAGE_DICT.keys():
                header_liste.append(self.KONTO_DATA_HEADER_ABFRAGE_DICT[key])
            
            new_data_list = []
            for item in header_liste:
                if item == self.KONTO_DATA_ITEM_LIST[self.KONTO_DATA_INDEX_BUCHDATUM]:
                    new_data_list.append(hdate.secs_time_epoch_to_str(self.konto_start_datum))
                elif item == self.KONTO_DATA_ITEM_LIST[self.KONTO_DATA_INDEX_WERTDATUM]:
                    new_data_list.append(hdate.secs_time_epoch_to_str(self.konto_start_datum))
                elif item == self.KONTO_DATA_ITEM_LIST[self.KONTO_DATA_INDEX_WER]:
                    new_data_list.append("Startwert")
                elif item == self.KONTO_DATA_ITEM_LIST[self.KONTO_DATA_INDEX_BUCHTYPE]:
                    new_data_list.append(self.KONTO_BUCHTYPE_TEXT_LIST[self.KONTO_BUCHTYPE_EINZAHLUNG])
                elif item == self.KONTO_DATA_ITEM_LIST[self.KONTO_DATA_INDEX_WERT]:
                    new_data_list.append("0,00")
                elif item == self.KONTO_DATA_ITEM_LIST[self.KONTO_DATA_INDEX_COMMENT]:
                    new_data_list.append("Startwert")
                elif item == self.KONTO_DATA_ITEM_LIST[self.KONTO_DATA_INDEX_ISIN]:
                    new_data_list.append("")
                elif item == self.KONTO_DATA_ITEM_LIST[self.KONTO_DATA_INDEX_KATEGORIE]:
                    new_data_list.append("")
                else:
                    new_data_list.append(0)
            # end for
            (i, status, errtext) = self.add_new_data_set(new_data_list, header_liste)
        # end if
        
        
    def read_csv(self,csv_lliste,filename):
        '''
        
        :param csv_lliste:  eingelesene csv-Datei
        :param konto_dict:  das Konto ictionary mit allen ini-Infos
        :param filename:    Name der eingelsenen Datei für errtext
        :return: (new_data_set_flag,status,errtex) =  self.read_csv(self,csv_lliste,konto_dict,filename)
        '''
        self.status = hdef.OKAY
        
        (index_start, index_dict) = self.search_header_line(csv_lliste ,filename)
        if( self.status != hdef.OKAY ):
            return(False,self.status,self.errtext)
        # endif
        
        new_data_dict_list = self.get_data_from_csv_lliste(csv_lliste,index_start, index_dict,filename)
        if( self.status != hdef.OKAY ):
            return(False,self.status,self.errtext)
        # endif
        
        new_data_dict_list = self.filt_and_sort_new_data_dict(new_data_dict_list)
        if( self.status != hdef.OKAY ):
            return(False,self.status,self.errtext)
        # endif

        new_data_dict_list = self.build_internal_values_new_data_dict(new_data_dict_list)
        if( self.status != hdef.OKAY ):
            return(False,self.status,self.errtext)
        # endif
        
        new_data_set_flag = self.add_new_data_dict_and_recalc_sum(new_data_dict_list)
        if( self.status != hdef.OKAY ):
            return(False,self.status,self.errtext)
        # endif

        return(new_data_set_flag,self.status,self.errtext)
    # enddef
    def get_anzeige_data_llist(self, istart: int, dir:int, number_of_lines: int):
        '''
        
        :param istart:           aktuelle start zeile
        :param dir:              dir=1 vorwärts blättern, dir=0 starten, dir=-1 rückwärts blättern
        :param number_of_lines:  Anzahl der zeilen, die gezeigt werden soll
        :return: (istart,header_list,data_llist,new_data_list) = self.get_anzeige_data_llist(istart, dir, number_of_lines)
        '''
        
        # build range
        #=========================
        (istart, iend) = self.build_range_to_show_dataset(istart, number_of_lines, dir)
        
        # build to show data_llist
        #=========================
        (header_list, data_llist, new_data_list) = self.build_data_table_list_and_color_list(istart,iend)
        
        return (istart,header_list, data_llist, new_data_list)
    # end def
    def write_anzeige_back_data(self, new_data_llist, data_changed_pos_list, istart):
        '''
        
        :param new_data_llist:
        :param data_changed_pos_list:
        :param istart:
        :return: self.write_anzeige_back_data(new_data_llist, data_changed_pos_list, istart)
        '''
        
        icol_liste = list(self.KONTO_DATA_TO_SHOW_DICT.keys())
        
        wert_changed = False
        for (irow, icol) in data_changed_pos_list:
            
            icol_data_set = icol_liste[icol]
            if icol_data_set not in self.KONTO_DATA_INMUTABLE_INDEX_LIST:
                
                wert = self.transform_value( new_data_llist[irow][icol], icol_data_set, self.KONTO_DATA_BUCHTYPE_DICT)
                if self.status == hdef.OKAY:
                    self.data_set_llist[istart + irow][icol_data_set] = wert
                    if (icol_data_set == self.KONTO_DATA_INDEX_WERT):
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
    def get_data_add_listen(self):
        '''
        index_in_header_liste index in header list für buch type
        :return: (header_liste, buchungs_type_list, index_in_header_liste) =  self.get_data_add_litsen()
        '''
        
        index_in_header_liste = -1
        header_liste = []
        for key in self.KONTO_DATA_HEADER_ABFRAGE_DICT.keys():
            header_liste.append(self.KONTO_DATA_HEADER_ABFRAGE_DICT[key])
            
            if key == self.KONTO_DATA_INDEX_BUCHTYPE:
                index_in_header_liste = len(header_liste)-1
            # endif
        # end for
        
        buchungs_type_list = self.KONTO_BUCHTYPE_TEXT_LIST
        
        return (header_liste,buchungs_type_list,index_in_header_liste)
    # end def

    def add_new_data_set(self,new_data_list,header_liste):
        '''
        
        :new_data_list:
        :param header_liste:
        :return: (new_data_set_flag, status, serrtext) = self.add_new_data_set(new_data_list,header_liste)
        '''
        
        new_data_dict = self.get_data_from_new_data_list(new_data_list, header_liste)
        
        new_data_dict_list = [new_data_dict]
        
        new_data_dict_list = self.filt_and_sort_new_data_dict(new_data_dict_list)
        if (self.status != hdef.OKAY):
            return (False, self.status, self.errtext)
        # endif
        
        new_data_dict_list = self.build_internal_values_new_data_dict(new_data_dict_list)
        if (self.status != hdef.OKAY):
            return (False, self.status, self.errtext)
        # endif
        
        new_data_set_flag = self.add_new_data_dict_and_recalc_sum(new_data_dict_list)
        if (self.status != hdef.OKAY):
            return (False, self.status, self.errtext)
        # endif
        
        return (new_data_set_flag, self.status, self.errtext)
    
    # end def
    def delete_data_list(self,irow):
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
    #----------------------------------------------------------------------------------------
    # Internen Funktionen
    #----------------------------------------------------------------------------------------
    def search_header_line(self,csv_lliste,filename):
        '''
        
        :param csv_lliste:
        :param filename:
        :return: (start_index, index_dict) = self.search_header_line(csv_lliste,filename)
        '''
        
        nheader = len(self.KONTO_DATA_HEADER_CSV_NAME_DICT.keys())
        if nheader == 0:
            Exception(f"search_header_line: self.KONTO_DATA_HEADER_CSV_NAME_DICT is empty must be set during setup Parameter in KontoDataSetParameter() ")
        # end if
        
        notfound = True
        
        start_index = 0
        
        for i, csv_liste in enumerate(csv_lliste):
            
            # for each new line in csv_lliste reset index_liste
            index_dict = {}
            
            for j,key in enumerate(self.KONTO_DATA_HEADER_CSV_NAME_DICT.keys()):
                if( self.KONTO_DATA_HEADER_CSV_NAME_DICT[key] in csv_liste):
                    if( j == 0):
                        header_found_liste = []
                    # end if
                    index_dict[key] = csv_liste.index(self.KONTO_DATA_HEADER_CSV_NAME_DICT[key])
                    header_found_liste.append(self.KONTO_DATA_HEADER_CSV_NAME_DICT[key])
                # end if
            # end for
            if len(index_dict.keys()) == nheader:
                start_index = i+1
                notfound = False
                break
            # end if
        # end for
        else:
            index_dict = {}  # liste mit position in csv-datei Spalte und mit index in konto_dataset
        # end for
        if notfound:
            okay = hdef.NOT_OKAY
            item = ""
            for key in self.KONTO_DATA_HEADER_CSV_NAME_DICT.keys():
                if self.KONTO_DATA_HEADER_CSV_NAME_DICT[key] not in header_found_liste:
                    item = self.KONTO_DATA_HEADER_CSV_NAME_DICT[key]
                    break
                # end if
            # end for
            self.errtext = f"header item: {item} not found in csv_file: {filename}"
        # end if
        return (start_index,index_dict)
    # end def
    def get_data_from_csv_lliste(self,csv_lliste,index_start, index_dict,filename):
        '''
        
        :param csv_lliste:
        :param index_start:
        :param index_dict:
        :param delim:           text für Komma
        :param trennt:          text für tausender Trennung
        :return: new_data_dict_list = self.get_data_from_csv_lliste(csv_lliste,index_start, index_dict)
        '''
        new_data_dict_list = []
        n = len(csv_lliste)
        for iline in range(index_start, n):
            csv_data_liste = csv_lliste[iline]
        
            nitems = len(csv_data_liste)
            new_data_dict = {}
            
            add_err_text = f"iline = {iline}, filename = {filename}"
            
            for key in index_dict.keys():
                i_csv = index_dict[key]
                i_dataset = key
                
                wert = self.transform_value(csv_data_liste[i_csv], i_dataset,self.KONTO_DATA_BUCHTYPE_CSV_NAME_DICT , add_err_text)
                if self.status != hdef.OKAY:
                    return []
                else:
                    new_data_dict[self.KONTO_DATA_ITEM_LIST[i_dataset]] = wert
                # endif
                
            # end for
            new_data_dict_list.append(new_data_dict)
        # end for
        
        return new_data_dict_list
    # end def
    def get_data_from_new_data_list(self,new_data_list, header_liste):
        '''
        
        :param new_data_list:
        :param header_liste:
        :return: new_data_dict = self.get_data_from_new_data_list(new_data_list, header_liste)
        '''
        new_data_dict = {}
        for index in range(min(len(new_data_list), len(header_liste))):
            
            header = header_liste[index]
            value = new_data_list[index]
            flagfound = False
            for key in self.KONTO_DATA_HEADER_ABFRAGE_DICT.keys():
                if header == self.KONTO_DATA_HEADER_ABFRAGE_DICT[key]:
                    flagfound = True
                    index = key
                    break
                # end if
            # endfor
            if flagfound:
                wert = self.transform_value(value, index, self.KONTO_DATA_BUCHTYPE_DICT)
                if self.status != hdef.OKAY:
                    return []
                else:
                    new_data_dict[header] = wert
                # endif
            else:
                self.errtext = f"add_new_data_set: header: {header} with value {value} not found in self.KONTO_DATA_HEADER_ABFRAGE_DICT"
                self.status = hdef.NOT_OKAY
            # end if
        # end for
        return new_data_dict
        
    def transform_value(self,wert_in,i_col_dataset,buch_type_dict,add_err_text=None):
        '''
        
        :param wert_in:
        :param i_col_dataset:
        :param buch_type_dict:
        :param add_err_text:
        :return: wert = self.transform_value(wert_in,i_col_dataset,buch_type_dict,add_err_text="")
        '''
    
        # buchdatum
        if (i_col_dataset == self.KONTO_DATA_INDEX_BUCHDATUM):
            (okay, wert) = htype.type_proof_dat(wert_in)
            if (okay != hdef.OKAY):
                self.status = hdef.NOT_OKAY
                self.errtext = f"transform_value_datum: error input buchdatum = <{wert_in}> is not valid "
                if add_err_text : self.errtext += add_err_text
                return wert
            # endif
        # wertdatum
        elif (i_col_dataset == self.KONTO_DATA_INDEX_WERTDATUM):
            (okay, wert) = htype.type_proof_dat(wert_in)
            if okay != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = f"transform_value_datum: error input wertdatum = <{wert_in}> is not valid "
                if add_err_text : self.errtext += add_err_text
                return wert
            # endif
        # wert
        elif i_col_dataset == self.KONTO_DATA_INDEX_WERT:
            (okay, wert) = htype.type_convert_euro_to_cent(wert_in, delim=self.DECIMAL_TRENN_STR,
                                                           thousandsign=self.TAUSEND_TRENN_STR)
            if okay != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = f"get_data_from_csv_lliste: error input wert = <{wert_in}> is not valid "
                if add_err_text : self.errtext += add_err_text
                return wert
            # endif
        elif i_col_dataset == self.KONTO_DATA_INDEX_SUMWERT:
            (okay, wert) = htype.type_convert_euro_to_cent(wert_in, delim=self.DECIMAL_TRENN_STR,
                                                           thousandsign=self.TAUSEND_TRENN_STR)
            if okay != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = f"get_data_from_csv_lliste: error input sumwert = <{wert_in}> is not valid  "
                if add_err_text : self.errtext += add_err_text
                return wert
            # endif
        elif (i_col_dataset == self.KONTO_DATA_INDEX_BUCHTYPE):
            (okay, wert) = htype.type_proof_string(wert_in)
            if (okay != hdef.OKAY):
                self.status = hdef.NOT_OKAY
                self.errtext = f"get_data_from_csv_lliste: error input buchtype = <{wert_in}> is not valid "
                if add_err_text : self.errtext += add_err_text
                return wert
            else:
                if len(buch_type_dict.keys()) == 0:
                    self.status = hdef.NOT_OKAY
                    self.errtext = f"get_data_from_csv_lliste: error input buchtype = <{wert_in}>: buch_type_dict is not set with KontoDataSetParameter()"
                    if add_err_text: self.errtext += add_err_text
                    return None
                else:
                    buchtype = self.get_data_buchtype(wert,buch_type_dict)
                    if (self.status != hdef.OKAY):
                        self.errtext = f"get_data_from_csv_lliste: error input buchtype = <{wert_in}> is not found "
                        if add_err_text: self.errtext += add_err_text
                        return None
                    # end if
                # end if
                wert = buchtype
            # end if
        elif i_col_dataset == self.KONTO_DATA_INDEX_WER:
            (okay, wert) = htype.type_proof_string(wert_in)
            if (okay != hdef.OKAY):
                self.status = hdef.NOT_OKAY
                self.errtext = f"get_data_from_csv_lliste: error input wer = <{wert_in}> is not valid "
                if add_err_text : self.errtext += add_err_text
                return wert
            # endif
        elif i_col_dataset == self.KONTO_DATA_INDEX_COMMENT:
            (okay, wert) = htype.type_proof_string(wert_in)
            if (okay != hdef.OKAY):
                self.status = hdef.NOT_OKAY
                self.errtext = f"get_data_from_csv_lliste: error input comment = <{wert_in}> is not valid "
                if add_err_text : self.errtext += add_err_text
                return wert
            # endif
        else:
            Exception(f"i_col_dataset = {i_col_dataset} nicht gefunden")
        # endif
        
        try:
            print(wert_in)
            print(wert)
        except:
            a = 0
        # end try
        return wert
    # end def
    def get_data_buchtype(self,wert,buch_type_dict):
        '''

        :param wert:
        :param par:
        :return: (okay, buchtype) =  get_data_buchtype(wert,buch_type_dict):
        '''
        
        okay = hdef.OKAY
        
        if len(buch_type_dict.keys()) == 0:
            Exception(f"")
        # endif
        not_found = True
        for key in buch_type_dict.keys():
            
            if isinstance(buch_type_dict[key], str):
                liste = [buch_type_dict[key]]
            else:
                liste = buch_type_dict[key]
            # end if
            
            for item in liste:
                if wert == item:
                    buchtype = key
                    not_found = False
                    break
                # end if
            # end for
            if not not_found:
                break
        # end for

        if not_found:
            buchtype = self.KONTO_BUCHTYPE_UNBEKANNT
            self.status = hdef.NOT_OKAY
        # end if
        
        return buchtype
    # end def
    def filt_and_sort_new_data_dict(self,new_data_dict_list):
        '''
        
        :param new_data_dict_list:
        :return: new_data_dict_list = self.filt_and_sort_new_data_dict(new_data_dict_list)
        '''
        new_filt_data_dict_list = []
        # filt new data
        for new_data_dict in new_data_dict_list:
            
            chash_new = self.build_chash(new_data_dict[self.KONTO_DATA_ITEM_LIST[self.KONTO_DATA_INDEX_COMMENT]] \
                                        ,new_data_dict[self.KONTO_DATA_ITEM_LIST[self.KONTO_DATA_INDEX_BUCHDATUM]] \
                                        ,new_data_dict[self.KONTO_DATA_ITEM_LIST[self.KONTO_DATA_INDEX_WERT]])
                
                
            flag = True
            for data_set in self.data_set_llist:
                
                chash = data_set[self.KONTO_DATA_INDEX_CHASH]
                
                if (chash_new == chash):
                    flag = False
                    break
                # end if
            # end for
            
            if flag:
                new_filt_data_dict_list.append(new_data_dict)
            # end if
        # end for
        
        # sort new data
        # sortiere neue Einträge nach buchdatum
        keyname = self.KONTO_DATA_ITEM_LIST[self.KONTO_DATA_INDEX_BUCHDATUM]
        new_filt_data_dict_list = hlist.sort_list_of_dict(new_filt_data_dict_list, keyname, aufsteigend=1)

        return new_filt_data_dict_list
    # end def
    def build_internal_values_new_data_dict(self,new_data_dict_list):
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
            
            if (data_dict[self.KONTO_DATA_ITEM_LIST[self.KONTO_DATA_INDEX_BUCHTYPE]] == self.KONTO_BUCHTYPE_WP_KAUF) or \
                (data_dict[self.KONTO_DATA_ITEM_LIST[self.KONTO_DATA_INDEX_BUCHTYPE]] == self.KONTO_BUCHTYPE_WP_VERKAUF) or \
                (data_dict[self.KONTO_DATA_ITEM_LIST[self.KONTO_DATA_INDEX_BUCHTYPE]] == self.KONTO_BUCHTYPE_WP_KOSTEN) or \
                (data_dict[self.KONTO_DATA_ITEM_LIST[self.KONTO_DATA_INDEX_BUCHTYPE]] == self.KONTO_BUCHTYPE_WP_EINNAHMEN):
                
                (okay, isin) = htype.type_proof(data_dict[self.KONTO_DATA_ITEM_LIST[self.KONTO_DATA_INDEX_COMMENT]], 'isin')
                
                if (okay != hdef.OKAY):
                    isin = "isinnotfound"
                # end if
            else:
                isin = ""
            # end if
            
            # ISIN if detected
            data_dict[self.KONTO_DATA_ITEM_LIST[self.KONTO_DATA_INDEX_ISIN]] = isin
            
            # count up IDMAX
            self.idmax += 1
            data_dict[self.KONTO_DATA_ITEM_LIST[self.KONTO_DATA_INDEX_ID]] = self.idmax
            
            # build hash value with three items
            
            data_dict[self.KONTO_DATA_ITEM_LIST[self.KONTO_DATA_INDEX_CHASH]] = \
                self.build_chash(data_dict[self.KONTO_DATA_ITEM_LIST[self.KONTO_DATA_INDEX_COMMENT]] \
                            ,data_dict[self.KONTO_DATA_ITEM_LIST[self.KONTO_DATA_INDEX_BUCHDATUM]] \
                            ,data_dict[self.KONTO_DATA_ITEM_LIST[self.KONTO_DATA_INDEX_WERT]])
                
            data_dict[self.KONTO_DATA_ITEM_LIST[self.KONTO_DATA_INDEX_KATEGORIE]] = ""
            data_dict[self.KONTO_DATA_ITEM_LIST[self.KONTO_DATA_INDEX_SUMWERT]] = 0
            
            new_data_dict_list[index] = data_dict
        # endfor
        
        return new_data_dict_list
    # end def
    def build_chash(self,comment,dat,wert):
        '''
        
        :param self:
        :param comment:
        :param dat:
        :param wert:
        :return: chash = self.build_chash(self,comment,dat,wert)
        '''
        
        strval = comment + str(dat) + str(wert)
        return htype.type_convert_to_hashkey(strval)
    # end def
    def add_new_data_dict_and_recalc_sum(self,new_data_dict_list):
        '''
        
        :param new_data_dict_list:
        :return: self.add_new_data_dict_and_recalc_sum(new_data_dict_list)
        '''
        self.new_read_id_list = []
        new_data_flag = False
        for data_dict in new_data_dict_list:
            data_set_list = []
            for index in self.KONTO_DATA_INDEX_LIST:
                data_set_list.append(data_dict[self.KONTO_DATA_ITEM_LIST[index]])
            # end for
            
            if len(data_set_list) > 0:
                self.data_set_llist.append(data_set_list)
                self.new_read_id_list.append(data_set_list[self.KONTO_DATA_INDEX_ID])
                new_data_flag = True
            # end for
        
        # sort
        self.data_set_llist = hlist.sort_list_of_list(self.data_set_llist, self.KONTO_DATA_INDEX_BUCHDATUM, aufsteigend=1)
        
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
    def build_data_table_list_and_color_list(self,istart,iend):
        '''
        
        :param istart:
        :param iend:
        :return: (header_list, data_llist, new_data_list) = self.build_data_table_list_and_color_list(istart,iend)
        '''
        
        # 1) header_liste
        #===========================
        header_list = []
        for key in self.KONTO_DATA_TO_SHOW_DICT.keys():
            header_list.append(self.KONTO_DATA_TO_SHOW_DICT[key])
        # end for
        
        # 2) data_llist,new_data_list
        #============================
        data_llist = []
        new_data_list = []
        index = istart
        while (index <= iend) and (index < self.n_data_sets):
            data_set_list = self.data_set_llist[index]
            data_list = []
            for key in self.KONTO_DATA_TO_SHOW_DICT.keys():
                if key == self.KONTO_DATA_INDEX_BUCHDATUM:
                    data_list.append(hdate.secs_time_epoch_to_str(data_set_list[key]))
                elif key == self.KONTO_DATA_INDEX_WERTDATUM:
                    data_list.append(hdate.secs_time_epoch_to_str(data_set_list[key]))
                elif key == self.KONTO_DATA_INDEX_BUCHTYPE:
                    data_list.append(self.KONTO_BUCHTYPE_TEXT_LIST[data_set_list[key]])
                elif key == self.KONTO_DATA_INDEX_WERT:
                    data_list.append(hstr.convert_int_cent_to_string_euro(data_set_list[key],self.DECIMAL_TRENN_STR))
                elif key == self.KONTO_DATA_INDEX_SUMWERT:
                    data_list.append(hstr.convert_int_cent_to_string_euro(data_set_list[key],self.DECIMAL_TRENN_STR))
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