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

import os, sys
from dataclasses import dataclass, field
from typing import List

#
# 1. Parameter dafür
#-------------------
@dataclass
class KontoDataSetParameter:
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
                            ,KONTO_DATA_INDEX_SUMWERT, KONTO_DATA_INDEX_COMMENT, KONTO_DATA_INDEX_ISIN
                            ,KONTO_DATA_INDEX_CHASH, KONTO_DATA_INDEX_KATEGORIE]
    
    KONTO_DATA_INMUTABLE_INDEX_LIST = [KONTO_DATA_INDEX_ID,KONTO_DATA_INDEX_BUCHTYPE,KONTO_DATA_INDEX_CHASH]
    
    # KONTO_DATA_HEADER_INI_NAME_DICT = \
    # {   KONTO_DATA_INDEX_ID: "",
    #     KONTO_DATA_INDEX_BUCHDATUM: "",
    #     KONTO_DATA_INDEX_WERTDATUM: "",
    #     KONTO_DATA_INDEX_WER: "",
    #     KONTO_DATA_INDEX_BUCHTYPE: "",
    #     KONTO_DATA_INDEX_WERT: "",
    #     KONTO_DATA_INDEX_SUMWERT: "",
    #     KONTO_DATA_INDEX_COMMENT: "",
    #     KONTO_DATA_INDEX_ISIN: "",
    #     KONTO_DATA_INDEX_CHASH: "",
    #     KONTO_DATA_INDEX_KATEGORIE: ""
    # }
    KONTO_DATA_HEADER_INI_NAME_DICT = {}
    KONTO_DATA_HEADER_ABFRAGE_DICT  = {}

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
    
    # KONTO_DATA_BUCHTYPE_INI_NAME_DICT = {KONTO_BUCHTYPE_EINZAHLUNG:""
    #                                     ,KONTO_BUCHTYPE_AUSZAHLUNG:""
    #                                     ,KONTO_BUCHTYPE_KOSTEN:""
    #                                     ,KONTO_BUCHTYPE_WP_KAUF:""
    #                                     ,KONTO_BUCHTYPE_WP_VERKAUF:""
    #                                     ,KONTO_BUCHTYPE_WP_KOSTEN:""
    #                                     ,KONTO_BUCHTYPE_WP_EINNAHMEN:""
    #                                      }
    KONTO_DATA_BUCHTYPE_INI_NAME_DICT = {}
    
    KONTO_DATA_TO_SHOW_DICT ={}
   


    def set_buchtype_ini_name(self,buchtype_index: int,buchtype_dict_ini_name: str):
        self.KONTO_DATA_BUCHTYPE_INI_NAME_DICT[buchtype_index] = buchtype_dict_ini_name
    # enddef
    def set_header_ini_name(self,dat_set_index: int,header_ini_name: str):
        self.KONTO_DATA_HEADER_INI_NAME_DICT[dat_set_index] = header_ini_name
        self.KONTO_DATA_HEADER_ABFRAGE_DICT[dat_set_index] = self.KONTO_DATA_ITEM_LIST[dat_set_index]
    # enddef
    def set_data_show_dict_list(self,dat_set_index: int):
        self.KONTO_DATA_TO_SHOW_DICT[dat_set_index] = self.KONTO_DATA_ITEM_LIST[dat_set_index]
    # enddef


class KontoDataSet:
    
    status = hdef.OK
    errtext = ""
    OKAY = hdef.OK
    NOT_OKAY = hdef.NOT_OK
    
    idmax: int = 0
    data_set_llist: list = []
    n_data_sets: int = 0
    new_read_id_list: list = []
    
    
    par = 0
    def __init__(self,par,data_set_llist,idmax):
        self.par = par
        self.data_set_llist = data_set_llist
        self.n_data_sets = len(self.data_set_llist)
        self.idmax = idmax
        
    def read_csv(self,csv_lliste,header_name_dict,buch_type_dict,konto_start_wert,wert_delim,wert_trennt,filename):
        '''
        
        :param csv_lliste:  eingelesene csv-Datei
        :param konto_dict:  das Konto ictionary mit allen ini-Infos
        :param filename:    Name der eingelsenen Datei für errtext
        :return: (new_data_set_flag,status,errtex) =  self.read_csv(self,csv_lliste,konto_dict,filename)
        '''
        self.status = hdef.OKAY
        
        (index_start, index_dict) = self.search_header_line(csv_lliste,header_name_dict ,filename)
        if( self.status != hdef.OKAY ):
            return(False,self.status,self.errtext)
        # endif
        
        new_data_dict_list = self.get_data_from_csv_lliste(csv_lliste,index_start, index_dict,buch_type_dict,wert_delim,wert_trennt,filename)
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
        
        new_data_set_flag = self.add_new_data_dict_and_recalc_sum(new_data_dict_list,konto_start_wert)
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
        :return: (header_list,data_llist,new_data_list) = self.get_anzeige_data_llist(istart, dir, number_of_lines)
        '''
        
        # build range
        #=========================
        (istart, iend) = self.build_range_to_show_dataset(istart, number_of_lines, dir)
        
        # build to show data_llist
        #=========================
        (header_list, data_llist, new_data_list) = self.build_data_table_list_and_color_list(istart,iend)
        
        return (header_list, data_llist, new_data_list)
    # end def
    def write_anzeige_back_data(self, new_data_llist, data_changed_pos_list, istart,konto_start_wert):
        '''
        
        :param new_data_llist:
        :param data_changed_pos_list:
        :param istart:
        :param konto_start_wert:
        :return: self.write_anzeige_back_data(new_data_llist, data_changed_pos_list, istart,konto_start_wert)
        '''
        
        icol_liste = self.par.KONTO_DATA_TO_SHOW_DICT.keys()
        
        wert_changed = False
        for (irow, icol) in data_changed_pos_list:
            
            icol_data_set = icol_liste[icol]
            if icol_data_set not in self.par.KONTO_DATA_INMUTABLE_INDEX_LIST:
                
                self.data_set_llist[istart + irow][icol_data_set] = new_data_llist[irow][icol]
                
                if (icol_data_set == self.par.KONTO_DATA_INDEX_WERT):
                    wert_changed = True
            # end if
        # end for
        
        if wert_changed:
            if istart == 0:
                sumwert = konto_start_wert
            else:
                sumwert = self.data_set_llist[istart - 1][self.par.KONTO_DATA_INDEX_SUMWERT]
            # end if
            
            i = istart
            while (i < self.n_data_sets):
                sumwert += self.data_set_llist[i][self.par.KONTO_DATA_INDEX_WERT]
                
                self.data_set_llist[i][self.par.KONTO_DATA_INDEX_SUMWERT] = int(sumwert)
                
                i += 1
            # end while
        # end if
    
    # end def
    def delete_new_data_list(self):
        '''
        
        :return: self.delete_new_data_list()
        '''
        self.new_read_id_list = []
    #----------------------------------------------------------------------------------------
    # Internen Funktionen
    #----------------------------------------------------------------------------------------
    def search_header_line(self,csv_lliste, header_name_dict,filename):
        '''
        
        :param csv_lliste:
        :param header_name_dict:
        :param filename:
        :return: (start_index, index_dict) = self.search_header_line(csv_lliste, header_name_dict,filename)
        '''
        
        nheader = len(self.par.KONTO_DATA_HEADER_INI_NAME_DICT.keys())
        notfound = True
        
        start_index = 0
        
        for i, csv_liste in enumerate(csv_lliste):
            
            # for each new line in csv_lliste reset index_liste
            index_dict = {}
            
            for j,key in enumerate(header_name_dict.keys()):
                if( header_name_dict[key] in csv_liste):
                    if( j == 0):
                        header_found_liste = []
                    # end if
                    index_dict[key] = csv_liste.index(header_name_dict[key])
                    header_found_liste.append(header_name_dict[key])
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
            for key in header_name_dict.keys():
                if header_name_dict[key] not in header_found_liste:
                    item = header_name_dict[key]
                    break
                # end if
            # end for
            self.errtext = f"header item: {item} not found in csv_file: {filename}"
        # end if
        return (start_index,index_dict)
    # end def
    def get_data_from_csv_lliste(self,csv_lliste,index_start, index_dict,buch_type_dict,delim,trennt,filename):
        '''
        
        :param csv_lliste:
        :param index_start:
        :param index_dict:
        :param buch_type_dict:
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
            
            for key in index_dict.keys():
                i_csv = index_dict[key]
                i_dataset = key
                
                # buchdatum
                if (i_dataset == self.par.KONTO_DATA_INDEX_BUCHDATUM):
                    (okay, wert) = htype.type_proof_dat(csv_data_liste[i_csv])
                    if (okay != hdef.OKAY):
                        self.status = hdef.NOT_OKAY
                        self.errtext = f"get_data_from_csv_lliste: error input buchdatum = <{csv_data_liste[i_csv]}> is not valid (iline={iline + 1}, file={filename})"
                        return []
                    else:
                        new_data_dict[self.par.KONTO_DATA_ITEM_LIST[i_dataset]] = wert
                    # endif
                # wertdatum
                elif (i_dataset == self.par.KONTO_DATA_INDEX_WERTDATUM):
                    (okay, wert) = htype.type_proof_dat(csv_data_liste[i_csv])
                    if (okay != hdef.OKAY):
                        self.status = hdef.NOT_OKAY
                        self.errtext = f"get_data_from_csv_lliste: error input wertdatum = <{csv_data_liste[i_csv]}> is not valid (iline={iline + 1}, file={filename})"
                        return []
                    else:
                        new_data_dict[self.par.KONTO_DATA_ITEM_LIST[i_dataset]] = wert
                    # endif
                # wer
                elif (i_dataset == self.par.KONTO_DATA_INDEX_WER):
                    (okay, wert) = htype.type_proof_string(csv_data_liste[i_csv])
                    if (okay != hdef.OKAY):
                        self.status = hdef.NOT_OKAY
                        self.errtext = f"get_data_from_csv_lliste: error input wer = <{csv_data_liste[i_csv]}> is not valid (iline={iline + 1}, file={filename})"
                        return []
                    else:
                        new_data_dict[self.par.KONTO_DATA_ITEM_LIST[i_dataset]] = wert
                    # endif
                elif (i_dataset == self.par.KONTO_DATA_INDEX_BUCHTYPE):
                    (okay, wert) = htype.type_proof_string(csv_data_liste[i_csv])
                    if (okay != hdef.OKAY):
                        self.status = hdef.NOT_OKAY
                        self.errtext = f"get_data_from_csv_lliste: error input buchtype = <{csv_data_liste[i_csv]}> is not valid (iline={iline + 1}, file={filename})"
                        return []
                    else:
                        buchtype = self.get_data_buchtype(wert, buch_type_dict)
                        if (self.status != hdef.OKAY):
                            self.errtext = f"get_data_from_csv_lliste: error input buchtype = <{wert}> is not found with keywords (iline={iline + 1}, file={filename})"
                            return []
                        # end if
                        new_data_dict[self.par.KONTO_DATA_ITEM_LIST[i_dataset]] = buchtype
                    # end if
                elif i_dataset == self.par.KONTO_DATA_INDEX_WERT:
                    (okay, wert) = htype.type_convert_euro_to_cent(csv_data_liste[i_csv], delim=delim,
                                                                   thousandsign=trennt)
                    if (okay != hdef.OKAY):
                        self.status = hdef.NOT_OKAY
                        self.errtext = f"get_data_from_csv_lliste: error input wert = <{csv_data_liste[i_csv]}> is not valid (iline={iline + 1}, file={filename})"
                        return []
                    else:
                        new_data_dict[self.par.KONTO_DATA_ITEM_LIST[i_dataset]] = wert
                    # endif
                elif i_dataset == self.par.KONTO_DATA_INDEX_COMMENT:
                    (okay, wert) = htype.type_proof_string(csv_data_liste[i_csv])
                    if (okay != hdef.OKAY):
                        self.status = hdef.NOT_OKAY
                        self.errtext = f"get_data_from_csv_lliste: error input comment = <{csv_data_liste[i_csv]}> is not valid (iline={iline + 1}, file={filename})"
                        return []
                    else:
                        new_data_dict[self.par.KONTO_DATA_ITEM_LIST[i_dataset]] = wert
                    # endif
                # end if
            # end for
            new_data_dict_list.append(new_data_dict)
        # end for
        
        return new_data_dict_list
    # end def
    def get_data_buchtype(self,wert, buch_type_dict):
        '''

        :param wert:
        :param par:
        :return: (okay, buchtype) =  get_data_buchtype(wert, par):
        '''
        
        okay = hdef.OKAY
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
            buchtype = self.par.KDSP.KONTO_BUCHUNG_UNBEKANNT
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
            
            wertdat_new = new_data_dict[self.par.KONTO_DATA_ITEM_LIST[self.par.KONTO_DATA_INDEX_WERTDATUM]]
            wert_new = new_data_dict[self.par.KONTO_DATA_ITEM_LIST[self.par.KONTO_DATA_INDEX_WERT]]
            comment_new = new_data_dict[self.par.KONTO_DATA_ITEM_LIST[self.par.KONTO_DATA_INDEX_COMMENT]]
            flag = True
            for data_set in self.data_set_llist:
                
                wertdat = data_set[self.par.KONTO_DATA_INDEX_WERTDATUM]
                wert = data_set[self.par.KONTO_DATA_INDEX_WERT]
                comment = data_set[self.par.KONTO_DATA_INDEX_COMMENT]
                
                if (wertdat_new == wertdat and wert_new == wert and comment_new == comment):
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
        keyname = self.par.KONTO_DATA_ITEM_LIST[self.par.KONTO_DATA_INDEX_BUCHDATUM]
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
            
            if (data_dict[self.par.KONTO_DATA_ITEM_LIST[self.par.KONTO_DATA_INDEX_BUCHTYPE]] == self.par.KONTO_BUCHTYPE_WP_KAUF) or \
                (data_dict[self.par.KONTO_DATA_ITEM_LIST[self.par.KONTO_DATA_INDEX_BUCHTYPE]] == self.par.KONTO_BUCHTYPE_WP_VERKAUF) or \
                (data_dict[self.par.KONTO_DATA_ITEM_LIST[self.par.KONTO_DATA_INDEX_BUCHTYPE]] == self.par.KONTO_BUCHTYPE_WP_KOSTEN) or \
                (data_dict[self.par.KONTO_DATA_ITEM_LIST[self.par.KONTO_DATA_INDEX_BUCHTYPE]] == self.par.KONTO_BUCHTYPE_WP_EINNAHMEN):
                
                (okay, isin) = htype.type_proof(data_dict[self.par.KONTO_DATA_ITEM_LIST[self.par.KONTO_DATA_INDEX_COMMENT]], 'isin')
                
                if (okay != hdef.OKAY):
                    isin = "isinnotfound"
                # end if
            else:
                isin = ""
            # end if
            
            data_dict[self.par.KONTO_DATA_ITEM_LIST[self.par.KONTO_DATA_INDEX_ISIN]] = isin
            self.idmax += 1
            data_dict[self.par.KONTO_DATA_ITEM_LIST[self.par.KONTO_DATA_INDEX_ID]] = self.idmax
            data_dict[self.par.KONTO_DATA_ITEM_LIST[self.par.KONTO_DATA_INDEX_CHASH]] = hash(data_dict[self.par.KONTO_DATA_ITEM_LIST[self.par.KONTO_DATA_INDEX_COMMENT]])
            data_dict[self.par.KONTO_DATA_ITEM_LIST[self.par.KONTO_DATA_INDEX_KATEGORIE]] = ""
            data_dict[self.par.KONTO_DATA_ITEM_LIST[self.par.KONTO_DATA_INDEX_SUMWERT]] = 0
            
            new_data_dict_list[index] = data_dict
        # endfor
        
        return new_data_dict_list
    # end def
    def add_new_data_dict_and_recalc_sum(self,new_data_dict_list,konto_start_wert):
        '''
        
        :param new_data_dict_list:
        :param konto_start_wert Startwert Konto nach ini-File
        :return: self.add_new_data_dict_and_recalc_sum(new_data_dict_list,konto_start_wert)
        '''
        self.new_read_id_list = []
        new_data_flag = False
        for data_dict in new_data_dict_list:
            data_set_list = []
            for index in self.par.KONTO_DATA_INDEX_LIST:
                data_set_list.append(data_dict[self.par.KONTO_DATA_ITEM_LIST[index]])
            # end for
            
            if len(data_set_list) > 0:
                self.data_set_llist.append(data_set_list)
                self.new_read_id_list.append(data_set_list[self.par.KONTO_DATA_INDEX_ID])
                new_data_flag = True
            # end for
        
        # sort
        self.data_set_llist = hlist.sort_list_of_list(self.data_set_llist, self.par.KONTO_DATA_INDEX_BUCHDATUM, aufsteigend=1)
        
        sumwert = konto_start_wert
        for i in range(len(self.data_set_llist)):
            sumwert += self.data_set_llist[i][self.par.KONTO_DATA_INDEX_WERT]
            
            self.data_set_llist[i][self.par.KONTO_DATA_INDEX_SUMWERT] = sumwert
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
                if key == self.par.KONTO_DATA_INDEX_BUCHDATUM:
                    data_list.append(hdate.secs_time_epoch_to_str(data_set_list[key]))
                elif key == self.par.KONTO_DATA_INDEX_WERTDATUM:
                    data_list.append(hdate.secs_time_epoch_to_str(data_set_list[key]))
                elif key == self.par.KONTO_DATA_INDEX_BUCHTYPE:
                    data_list.append(self.par.KONTO_BUCHTYPE_TEXT_LIST[data_set_list[key]])
                elif key == self.par.KONTO_DATA_INDEX_WERT:
                    data_list.append(hstr.convert_int_cent_to_string_euro(data_set_list[key]))
                elif key == self.par.KONTO_DATA_INDEX_SUMWERT:
                    data_list.append(hstr.convert_int_cent_to_string_euro(data_set_list[key]))
                else:
                    data_list.append(data_set_list[key])
                # end if
            # end for
            data_llist.append(data_list)
            if data_list[self.par.KONTO_DATA_INDEX_ID] in self.new_read_id_list:
                new_data_list.append(True)
            else:
                new_data_list.append(False)
            # end if
            index += 1
        # end while
        return (header_list, data_llist, new_data_list)
    # end def
# end class