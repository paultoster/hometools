#
#
#   beinhaltet die data_llist ´für eingelesene KontoDaten und funktion dafür
#
import os, sys

# from hfkt_tvar import transform_type_table

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif


import tools.hfkt_def as hdef
import tools.hfkt_type as htype
import tools.hfkt_list as hlist
# import tools.hfkt_str as hstr
import tools.hfkt_tvar as htvar
import tools.hfkt_data_set as hdset


import depot_data_class_defs as depot_class

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

class KontoParam:
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
    
    KONTO_DATA_IMMUTABLE_NAME_LIST = [KONTO_DATA_NAME_ID, KONTO_DATA_NAME_CHASH]
    
    KONTO_DATA_LLIST = [
        [KONTO_DATA_INDEX_ID, KONTO_DATA_NAME_ID, "int","int"],
        [KONTO_DATA_INDEX_BUCHDATUM, KONTO_DATA_NAME_BUCHDATUM, "dat","datStrP"],
        [KONTO_DATA_INDEX_WERTDATUM, KONTO_DATA_NAME_WERTDATUM, "dat","datStrP"],
        [KONTO_DATA_INDEX_WER, KONTO_DATA_NAME_WER, "str","str"],
        [KONTO_DATA_INDEX_BUCHTYPE, KONTO_DATA_NAME_BUCHTYPE, KONTO_BUCHTYPE_INDEX_LIST, KONTO_BUCHTYPE_TEXT_LIST],
        [KONTO_DATA_INDEX_WERT, KONTO_DATA_NAME_WERT, "cent","euroStrK"],
        [KONTO_DATA_INDEX_SUMWERT, KONTO_DATA_NAME_SUMWERT, "cent","euroStrK"],
        [KONTO_DATA_INDEX_COMMENT, KONTO_DATA_NAME_COMMENT, "str","str"],
        [KONTO_DATA_INDEX_CHASH, KONTO_DATA_NAME_CHASH, "int","int"],
        [KONTO_DATA_INDEX_ISIN, KONTO_DATA_NAME_ISIN, "str","str"],
        [KONTO_DATA_INDEX_KATEGORIE, KONTO_DATA_NAME_KATEGORIE, "str","str"],
    ]
    KONTO_DATA_NAME_DICT = {}
    KONTO_DATA_TYPE_DICT = {}
    KONTO_DATA_STORE_TYPE_DICT = {}
    KONTO_DATA_NAME_LIST = []
    KONTO_DATA_TYPE_LIST = []
    KONTO_DATA_STORE_TYPE_LIST = []
    # KONTO_DATA_INDEX_LIST = []
    for liste in KONTO_DATA_LLIST:
        KONTO_DATA_NAME_DICT[liste[0]] = liste[1]
        KONTO_DATA_TYPE_DICT[liste[0]] = liste[2]
        KONTO_DATA_STORE_TYPE_DICT[liste[0]] = liste[3]
        KONTO_DATA_NAME_LIST.append(liste[1])
        KONTO_DATA_TYPE_LIST.append(liste[2])
        KONTO_DATA_STORE_TYPE_LIST.append(liste[3])
    
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
    
    KONTO_IBAN_SUCH_HEADER_LIST = [KONTO_DATA_NAME_WER,KONTO_DATA_NAME_COMMENT]
    KONTO_IBAN_SUCH_TYPE_LIST = ["str","str"]

    LINE_COLOR_BASE = ""
    LINE_COLOR_NEW = "aquamarine1"  # "aliceblue"
    LINE_COLOR_EDIT = "orange1"

    KONTO_NAME = "konto_name"  #  für Kategorie Auswertung
    
# end class
class KontoDataSet:
    '''
    obj                           = KontoDataSet(konto_name,idfunc,wpfunc)
                                    obj.set_stored_data_set_tvar(data_set,konto_start_datum,konto_start_wert)
                                    obj.set_start_row()  set with start_wert and date
                                    obj.get_to_store_data_set_tvar()
    ndata                         = self.get_number_of_data()
    irow                          = self.get_irow_by_id(id)
    konto_name                    = self.get_konto_name()
    status                        = obj.proof_csv_read_buchtype_zuordnung_names(buchtype_zuordnungs_liste)
    status                        = obj.proof_csv_read_header_zuordnung_names(header_zuordnungs_liste)
                                    obj.set_csvfunc(csvfunc)
    csvfunc                       = obj.get_csvfunc()
    titlename                     = obj.get_titlename()
    (new_flag, status, errtext)   = self.set_data_set_extern_liste(new_tlist,irow)
    (new_flag, status, errtext)   = self.set_data_set_value(self, headername,value,typename, irow)
    (new_data_set_flag,status,errtext,infotext) =  self.set_new_data(new_data_table)
    (new_data_set_flag,status,errtext,infotext) =  self.set_new_data(new_data_table,flag_proof_wert)
                                          self.update_isin_find()
    (tlist, change_flag)               = self.update_isin_data_set_tlist(tlist)
    ttable                             = self.get_data_set_dict_ttable()
    ttable                             = self.get_data_set_dict_ttable(header_list,type_list)
    ttable                             = self.get_timedepend_data_set_dict_ttable(header_list,type_list,min_epoch_time,max_epoch_time)
    (ttable,row_color_dliste)          = self.get_anzeige_ttable()
    
                                         self.write_anzeige_back_data(ttable_anzeige, data_changed_pos_list)
    (tlist, buchungs_type_list, buchtype_index_in_header_liste) = self.get_edit_data(irow)
    (tlist, buchungs_type_list, buchtype_index_in_header_liste) =  self.get_extern_default_tlist()
     (status,errtext)                  = delete_data_set(irow)
     status                            = obj.update_isin_w_wpname_wkn(isin, wpname, wkn)
     
     # intern
     
     (modified_new_data_table)         = self.add_chash_to_table(new_data_table)
     new_data_table                    = self.filter_by_chash_to_table(new_data_table)
     new_data_table                    = self.proof_wert_in_table_mit_buchtype(new_data_table)
     new_data_table                    = self.build_internal_values_new_data_table(new_data_table)
     isin                              = self.search_isin(isin_in, comment)
     (okay, wkn,isin)                  = self.search_wkn_from_comment(comment)
                                         self.recalc_sum_data_set()
                                         self.reset_line_color()
                                         self.check_iban()
                                         self.check_iban(irow)
    '''
    
    OKAY = hdef.OK
    NOT_OKAY = hdef.NOT_OK
    
    def __init__(self,konto_name: str,idfunc,wpfunc,katfunc,iban_obj):
        
        self.konto_name: str = konto_name
        self.par = KontoParam()
        self.KONTO_DATA_CSV_NAME_DICT = {}
        self.KONTO_DATA_CSV_TYPE_DICT = {}
        
        self.status = hdef.OK
        self.errtext = ""
        self.infotext = ""
        self.konto_start_wert: int = 0
        self.konto_start_datum: int = 0
        self.konto_start_comment: str = "Startwert Konto"
        self.konto_start_irow: int = 0
        # self.DECIMAL_TRENN_STR: str = ","
        # self.TAUSEND_TRENN_STR: str = "."
        self.data_set_obj = hdset.DataSet(konto_name)

        for index in self.par.KONTO_DATA_NAME_DICT.keys():
            self.data_set_obj.set_definition(index, self.par.KONTO_DATA_NAME_DICT[index]
                                             , self.par.KONTO_DATA_TYPE_DICT[index]
                                             , self.par.KONTO_DATA_STORE_TYPE_DICT[index])
            if self.data_set_obj.status != hdef.OKAY:
                self.status = self.data_set_obj.status
                self.errtext = self.data_set_obj.errtext
                self.data_set_obj.reset_status()
                break
            # end if
        # end for

        self.new_read_id_list: list = []
        self.idfunc = idfunc
        self.wpfunc = wpfunc
        self.katfunc = katfunc
        self.iban_obj = iban_obj
        self.csvfunc = None
    
        return
    # end def
    def reset_status(self):
        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""
    # end def
    def set_stored_data_set_tvar(self, ttable: htvar.TTable, tkonto_start_datum: htvar.TVal, tkonto_start_wert: htvar.TVal):
        '''
        
        :param data_set:
        :param konto_start_datum:
        :param konto_start_wert:
        :return: self.set_stored_data_set_tvar(data_set,konto_start_datum,konto_start_wert)
        '''
        
        # ttable = self.recalc_chash_wo_comment(ttable)
        
        if( self.data_set_obj.add_data_set_tvar(ttable,self.par.LINE_COLOR_BASE) != hdef.OKAY):
            raise Exception(f"Fehler set_stored_data_set_tvar errtext={self.errtext} !!!")
        # end if
        
        self.konto_start_datum = htvar.get_val(tkonto_start_datum,"dat")
        self.konto_start_wert  = htvar.get_val(tkonto_start_wert,"cent")
        
        if self.data_set_obj.get_n_data() > 0:
            
            
            irow_list = self.data_set_obj.find_in_col(self.konto_start_comment, "str", self.par.KONTO_DATA_NAME_COMMENT)
            
            if len(irow_list) == 0:
                # Vorübergehend
                irow_list = self.data_set_obj.find_in_col("Startwert", "str",self.par.KONTO_DATA_NAME_COMMENT)
                if len(irow_list):
                    self.data_set_obj.set_data_item(self.konto_start_comment, self.par.LINE_COLOR_EDIT, irow_list[0],
                                                    self.par.KONTO_DATA_NAME_COMMENT, "str")
                else:
                    self.status = hdef.NOT_OKAY
                    self.errtext = f"set_stored_data_set_tvar: Start Kommentar: Konto: {self.konto_name}, {self.konto_start_comment} kann nicht im Kommentar gefunden werden"
                    return
                # end if
            # end if
            self.konto_start_irow = irow_list[0]
            value = self.data_set_obj.get_data_item(self.konto_start_irow, self.par.KONTO_DATA_NAME_BUCHDATUM, "dat")
            if value != self.konto_start_datum: # value,line_color,irow, icol, type
                self.data_set_obj.set_data_item(value,self.par.LINE_COLOR_EDIT,self.konto_start_irow,self.par.KONTO_DATA_NAME_BUCHDATUM, "dat")
                self.data_set_obj.set_data_item(value,self.par.LINE_COLOR_EDIT,self.konto_start_irow,self.par.KONTO_DATA_NAME_BUCHDATUM, "dat")
                self.data_set_obj.update_order_name(self.par.KONTO_DATA_NAME_BUCHDATUM)
            # end if

            value = self.data_set_obj.get_data_item(self.konto_start_irow, self.par.KONTO_DATA_INDEX_SUMWERT, "cent")
            if value != self.konto_start_wert:
                self.data_set_obj.set_data_item(self.konto_start_wert,self.par.LINE_COLOR_NEW,self.konto_start_irow,self.par.KONTO_DATA_NAME_SUMWERT, "cent")
                self.recalc_sum_data_set()
            # end if
            
            if self.katfunc:
                self.proof_kategorie_in_data_set()
            
            
        else:
            self.set_start_row()
        # end if
        
        self.check_iban()
        
        return
    # end def
    def check_iban(self,irow_in=None):
        '''
        
        :return:
        '''
    
        if irow_in == None:
            irow_list = list(range(self.data_set_obj.get_n_data()))
        else:
            irow_list = [irow_in]
        # end if
        for irow in irow_list:
            
            # DE44520604101906432654
            
            tlist = self.data_set_obj.get_one_data_set_tlist(irow,
                                                             self.par.KONTO_IBAN_SUCH_HEADER_LIST,
                                                             self.par.KONTO_IBAN_SUCH_TYPE_LIST)
            
            
            wer = htvar.get_val_from_list(tlist,self.par.KONTO_DATA_NAME_WER,'str')
            
            (hits, iban_liste) = htype.eval_iban(wer) # wer
            iban = None
            if hits:
                iban = iban_liste[0]
            else:
                comment = htvar.get_val_from_list(tlist, self.par.KONTO_DATA_NAME_COMMENT, 'str')
                
                # index = hstr.such(comment, "DE71503302002320969002", "vs")
                # if index >= 0:
                #     a = 0
                (hits, iban_liste) = htype.eval_iban(comment)
                if hits:
                    iban = iban_liste[0]
                # end if
            # end if
            
            if iban != None:
                self.iban_obj.add(iban,wer)
            # end if
        # end for
    # end def
    # def add_tlist_to_data_set(self,data_set: htvar.TList):
    #     '''
    #
    #     :param data_set:
    #     :return:
    #     '''
    def set_start_row(self):
        
        names = [self.par.KONTO_DATA_NAME_ID
                ,self.par.KONTO_DATA_NAME_BUCHDATUM
                ,self.par.KONTO_DATA_NAME_WERTDATUM
                ,self.par.KONTO_DATA_NAME_WER
                ,self.par.KONTO_DATA_NAME_BUCHTYPE
                ,self.par.KONTO_DATA_NAME_WERT
                ,self.par.KONTO_DATA_NAME_SUMWERT
                ,self.par.KONTO_DATA_NAME_COMMENT]
        
        vals  = [self.idfunc.get_new_id()
                ,self.konto_start_datum
                ,self.konto_start_datum
                ,"Thomas"
                ,self.par.KONTO_DATA_BUCHTYPE_DICT[self.par.KONTO_BUCHTYPE_INDEX_EINZAHLUNG]
                ,0
                ,self.konto_start_wert
                ,self.konto_start_comment]
        types = ["int"
                ,"dat"
                ,"dat"
                ,"str"
                ,self.par.KONTO_BUCHTYPE_TEXT_LIST
                ,"cent"
                ,"cent"
                ,"str"]
        
        data_tlist = htvar.build_list(names,vals,types)

        if( self.data_set_obj.add_data_set_tvar(data_tlist,self.par.LINE_COLOR_BASE) != hdef.OKAY):
            raise Exception(f"Fehler set_stored_data_set_tvar errtext={self.errtext} !!!")
        else:
            irow_list = self.data_set_obj.find_in_col(self.konto_start_comment, "str", self.par.KONTO_DATA_NAME_COMMENT)
            self.konto_start_irow = irow_list[0]
        # end if
    # end def
    def get_konto_start_irow(self):
        '''
        
        :return:
        '''
        return self.konto_start_irow
    # end def
    def get_to_store_data_set_tvar(self):
        '''
        
        :return: ttable =  self.get_to_store_data_set_tvar()
        '''
        
        ttable = self.data_set_obj.get_data_set_ttable()
        
        ttable = htvar.transform_icol_table(ttable, self.par.KONTO_DATA_NAME_LIST)
        
        ttable = htvar.transform_type_table(ttable, self.par.KONTO_DATA_STORE_TYPE_LIST)
        
        row_color_dliste = self.data_set_obj.get_line_color_set_liste()
        
        return (ttable, row_color_dliste)
    # end def
    def get_konto_name(self):
        return self.konto_name
    def proof_kategorie_in_data_set(self,irow_inp=None):
        '''
        Prüft über alle Einträge, ob Kategorie mit der Liste passt
        :return: self.proof_kategorie_in_data_set()
        '''
        
        icol_kat = self.data_set_obj.find_header_index(self.par.KONTO_DATA_NAME_KATEGORIE)
        icol_wert = self.data_set_obj.find_header_index(self.par.KONTO_DATA_NAME_WERT)

        kat_list = self.katfunc.get_kat_list()
        
        if irow_inp == None:
            irow_list = range(self.data_set_obj.get_n_data())
        else:
            irow_list = [irow_inp]
        # end if
        
        for irow in irow_list:
            
            katval    = self.data_set_obj.get_data_item(irow, icol_kat, "str")
            wert_cent = self.data_set_obj.get_data_item(irow, icol_wert, "cent")

            if katval == "jentnahme:7.494,32;transfer:7.505,68":
                a = 0
            # end if
            katdict = self.katfunc.build_katdict(katval,wert_cent)
            
            if katdict is None:
                self.status = self.katfunc.status
                self.errtext = self.katfunc.status
                self.katfunc.reset_status()
                return
            # end if
            
            new_katdict = {}
            flag_change = False
            for kat in katdict.keys():
                if (kat != self.katfunc.kat_empty) and (kat not in kat_list):
                
                    tausch_kat = self.katfunc.get_tausch_kategorie(kat) # ist leer "" wenn kein Tausch
                    new_katdict[tausch_kat] = katdict[kat]
                    flag_change = True
                else:
                    new_katdict[kat] = katdict[kat]
                # end if
            # end for
            
            if flag_change:
            
                katval = self.katfunc.build_katval(new_katdict)
                
                self.data_set_obj.set_data_item(katval,self.par.LINE_COLOR_EDIT,irow, icol_kat, "str")
                
            # end if
        # end for
    # end def
    def proof_csv_read_buchtype_zuordnung_names(self,buchtype_zuordnungs_liste: list):
        '''
        
        :param buchtype_zuordnung:
        :return: status = self.proof_csv_read_buchtype_zuordnung_names(buchtype_zuordnung):
        '''
        
        for zuordnung in buchtype_zuordnungs_liste:
            if zuordnung not in self.par.KONTO_DATA_BUCHTYPE_DICT.values():
                self.status = hdef.NOT_OKAY
                self.errtext = f"proof_csv_read_buchtype_zuordnung_names: csv_buchtype_zuordnung = {zuordnung} ist nicht im Konto vorhanden"
                return self.status
            # end if
        # end for
        
        return self.status
    # end def
    def proof_csv_read_header_zuordnung_names(self, header_zuordnungs_liste: list):
        '''

        :param buchtype_zuordnung:
        :return: status = self.proof_csv_read_header_zuordnung_names(header_zuordnungs_liste):
        '''
        
        for header in header_zuordnungs_liste:
            if header not in self.par.KONTO_DATA_NAME_DICT.values():
                self.status = hdef.NOT_OKAY
                self.errtext = f"proof_csv_read_header_zuordnung_names: csv_header_zuordnung = {header} ist nicht im Konto vorhanden"
                return self.status
            # end if
        # end for
        
        return self.status
    
    # end def
    def set_csvfunc(self,csvfunc):
        '''
        
        :param csvfunc:
        :return: self.set_csvfunc(csvfunc)
        '''
        self.csvfunc = csvfunc
    # end def
    def get_csvfunc(self):
        '''
        
        :return: csvfunc = self.get_csvfunc()
        '''
        return self.csvfunc
    
    # end def
    
    # def get_buchtype_index(self,buchttype_name: str):
    #     index = None
    #     for key, val in self.par.KONTO_DATA_BUCHTYPE_DICT.items():
    #         if val == buchttype_name:
    #             index = key
    #             break
    #         # end if
    #     # end for
    #     return index
    # # end def
    # def get_name_index(self, konto_data_name: str):
    #     index = None
    #     for key, val in self.par.KONTO_DATA_NAME_DICT.items():
    #         if val == konto_data_name:
    #             index = key
    #             break
    #         # end if
    #     # end for
    #     return index
    # # end def
    def get_titlename(self):
        '''

        :return: titlename = self.get_titlename()
        '''
        titlename = f"Konto: {self.konto_name} "
        
        return titlename
    
    # end def
    
    
    # def set_starting_data_llist(self,konto_data_set_dict_list,konto_data_type_dict, idfunc,wpfunc, konto_start_datum, konto_start_wert, decimal_trenn="",
    #                             tausend_trenn=""):
    #
    #     self.data_set_llist = self.set_dat_set_dict_list(konto_data_set_dict_list,konto_data_type_dict)
    #     self.data_set_obj.get_n_data() = len(self.data_set_llist)
    #     # self.idfunc = idfunc
    #     # self.wpfunc = wpfunc
    #     self.konto_start_datum = konto_start_datum
    #     self.konto_start_wert = konto_start_wert
    #     self.DECIMAL_TRENN_STR = decimal_trenn
    #     self.TAUSEND_TRENN_STR = tausend_trenn
    #
    #     # Liste neu anlegen
    #     if self.data_set_obj.get_n_data() == 0:
    #
    #         new_data_list = []
    #         new_data_index_list = []
    #         new_data_type_list = []
    #         for index in self.KONTO_DATA_EXTERN_NAME_DICT.keys():
    #             # --------------------------------------
    #             # buchdatum
    #             if index == self.KONTO_DATA_INDEX_BUCHDATUM:
    #                 (okay, wert) = htype.type_transform(self.konto_start_datum, self.KONTO_DATA_TYPE_DICT[index],self.KONTO_DATA_EXTERN_TYPE_DICT[index])
    #                 if okay != hdef.OKAY:
    #                     raise Exception(
    #                         f"Fehler initialisierung  buchdatum {self.konto_start_datum} von type: {self.KONTO_DATA_TYPE_DICT[index]} in type {self.KONTO_DATA_EXTERN_TYPE_DICT[index]} wandeln !!!")
    #                 # end if
    #                 new_data_list.append(wert)
    #                 new_data_index_list.append(index)
    #                 new_data_type_list.append(self.KONTO_DATA_EXTERN_TYPE_DICT[index])
    #             # --------------------------------------
    #             # wertdatum
    #             elif index == self.KONTO_DATA_INDEX_WERTDATUM:
    #                 (okay, wert) = htype.type_transform(self.konto_start_datum, self.KONTO_DATA_TYPE_DICT[index],self.KONTO_DATA_EXTERN_TYPE_DICT[index])
    #                 if okay != hdef.OKAY:
    #                     raise Exception(
    #                         f"Fehler initialisierung  buchdatum {self.konto_start_datum} von type: {self.KONTO_DATA_TYPE_DICT[index]} in type {self.KONTO_DATA_EXTERN_TYPE_DICT[index]} wandeln !!!")
    #                 # end if
    #                 new_data_list.append(wert)
    #                 new_data_index_list.append(index)
    #                 new_data_type_list.append(self.KONTO_DATA_EXTERN_TYPE_DICT[index])
    #             # --------------------------------------
    #             # wer
    #             elif index == self.KONTO_DATA_INDEX_WER:
    #                 new_data_list.append("Startwert")
    #                 new_data_index_list.append(index)
    #                 new_data_type_list.append("str")
    #             # --------------------------------------
    #             # buchtype
    #             elif index == self.KONTO_DATA_INDEX_BUCHTYPE:
    #                 new_data_list.append(self.KONTO_DATA_BUCHTYPE_DICT[self.KONTO_BUCHTYPE_INDEX_EINZAHLUNG])
    #                 new_data_index_list.append(index)
    #                 new_data_type_list.append(self.KONTO_BUCHTYPE_TEXT_LIST)
    #             # --------------------------------------
    #             # wert
    #             elif index == self.KONTO_DATA_INDEX_WERT:
    #                 new_data_list.append(0.0)
    #                 new_data_index_list.append(index)
    #                 new_data_type_list.append("euro")
    #             # --------------------------------------
    #             # sumwert
    #             elif index == self.KONTO_DATA_INDEX_SUMWERT:
    #                 (okay, wert) = htype.type_transform(self.konto_start_wert, "cent",self.KONTO_DATA_EXTERN_TYPE_DICT[index])
    #                 if okay != hdef.OKAY:
    #                     raise Exception(
    #                         f"Fehler initialisierung  summe {self.konto_start_wert} von type: {self.KONTO_DATA_TYPE_DICT[index]} in type {self.KONTO_DATA_EXTERN_TYPE_DICT[index]} wandeln !!!")
    #                 # end if
    #                 new_data_list.append(wert)
    #                 new_data_index_list.append(index)
    #                 new_data_type_list.append(self.KONTO_DATA_EXTERN_TYPE_DICT[index])
    #             # --------------------------------------
    #             # comment
    #             elif index == self.KONTO_DATA_INDEX_COMMENT:
    #                 new_data_list.append("Startwert")
    #                 new_data_index_list.append(index)
    #                 new_data_type_list.append("str")
    #             # --------------------------------------
    #             # isin
    #             elif index == self.KONTO_DATA_INDEX_ISIN:
    #                 new_data_list.append("")
    #                 new_data_index_list.append(index)
    #                 new_data_type_list.append("str")
    #             # --------------------------------------
    #             # kategorie
    #             elif index == self.KONTO_DATA_INDEX_KATEGORIE:
    #                 new_data_list.append("")
    #                 new_data_index_list.append(index)
    #                 new_data_type_list.append("str")
    #             else:
    #                 raise Exception(f"Problem start Zeile erzeugen index = {index} in if-struct nicht gefunden !!!")
    #         # end for
    #         new_data_matrix = [new_data_list]
    #
    #         # ---------------------------------------------------------
    #         # add data set as first data
    #         ((new_data_set_flag,status,errtext,infotext) ) = self.set_new_data(new_data_matrix , new_data_index_list, new_data_type_list)
    #         if status != hdef.OKAY:
    #             raise Exception(f"Problem start Zeile erzeugen set_new_data() errtext = {errtext} !!!")
    #         # end
    #     else:
    #         if self.data_set_llist[0][self.KONTO_DATA_INDEX_SUMWERT] != self.konto_start_wert:
    #             self.update_sumwert_in_lliste(0)
    #         # end if
    #     # end if
    #
    # # end def
    def set_data_set_extern_liste(self, new_tlist: htvar.TList, irow):
        '''

        :param new_data_set:
        :param irow:
        :return: (new_data_set_flag, status, errtext) = self.set_data_set_extern_liste(new_tlist,irow)
        '''
        new_data_set_flag       = False
        new_data_buchdatum_flag = False
        new_data_wert_flag      = False

        # set data_set
        # ============================
        if self.data_set_obj.get_n_data() == 0:
            raise Exception(f"set_data_set_extern_liste Error n_data_sets = 0")

        index_row = irow
        if index_row >= self.data_set_obj.get_n_data():
            index_row = self.data_set_obj.get_n_data() - 1

        for i,name in enumerate(new_tlist.names):
            new_val = new_tlist.vals[i]
            new_type = new_tlist.types[i]
            (new_data_set_flag,self.status,self.errtext) = self.set_data_set_value(name, new_val, new_type, index_row)
            if new_data_set_flag:
                if name == self.par.KONTO_DATA_NAME_BUCHDATUM:
                    new_data_buchdatum_flag = True
                # end if
                if name == self.par.KONTO_DATA_NAME_WERT:
                    new_data_wert_flag = True
                # end if
            # endif
            
            #
            # new_type = new_tlist.types[i]
            # index    = htvar.get_index_from_list(tlist, name)
            # val      = tlist.vals[index]
            # type     = tlist.types[index]
            #
            # (okay, wert) = htype.type_transform(new_val, new_type,type)
            # if okay != hdef.OKAY:
            #     self.status = hdef.NOT_OKAY
            #     self.errtext = f"Fehler transform Wert {new_val} von {new_type} zu type: {type}  !!!"
            #     return (new_data_set_flag, self.status, self.errtext)
            # # end if
            #
            # if wert != val:
            #     new_data_set_flag = self.data_set_obj.set_data_item(wert, self.par.LINE_COLOR_EDIT, index_row, name)
            #
            #
            #
            #
        # end for
        
        # new id
        if  new_data_set_flag:
            id = self.data_set_obj.get_data_item(index_row, self.par.KONTO_DATA_NAME_ID)
            if id not in self.new_read_id_list:
                self.new_read_id_list.append(id)
            # end if
            
            

        # sort
        if new_data_buchdatum_flag:
            self.data_set_obj.update_order_name(self.par.KONTO_DATA_NAME_BUCHDATUM)
        # end if

        # recalc_sum
        if new_data_wert_flag:
            self.recalc_sum_data_set()
        # end if
        
        

        return (new_data_set_flag,self.status,self.errtext)
    # end def
    def set_data_set_value(self, headername,value,typename, irow):
        '''
        
        :param header:
        :param value:
        :param type:
        :param irow:
        :return: (new_data_set_flag,status,errtext) = obj.set_data_set_value(header,value,type, irow)
        '''
        
        new_data_set_flag = False
        
        # set value
        # ============================
        if self.data_set_obj.get_n_data() == 0:
            raise Exception(f"set_data_set_extern_liste Error n_data_sets = 0")
        index_row = irow
        if index_row >= self.data_set_obj.get_n_data():
            index_row = self.data_set_obj.get_n_data() - 1
        
        value_old = self.data_set_obj.get_data_item(index_row, headername, typename)
        type_intern = self.data_set_obj.get_type_of_header(headername)
        
        if self.data_set_obj.status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = f"Fehler self.data_set_obj.get_data_item({index_row =},{headername =},{typename =}  !!!"
            return (new_data_set_flag, self.status, self.errtext)
        # end if
        
        if value != value_old:
            (okay, wert) = htype.type_transform(value, typename,type_intern)
            if okay != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = f"Fehler transform Wert {value} von {typename} zu type: {type_intern}  !!!"
                return (new_data_set_flag, self.status, self.errtext)
            # end if
            
            new_data_set_flag = self.data_set_obj.set_data_item(wert, self.par.LINE_COLOR_EDIT, index_row, headername)
            
        # end if
        
        return (new_data_set_flag, self.status, self.errtext)
    # end def
    def set_new_data(self, new_data_table: htvar.TTable | htvar.TList,flag_proof_wert = False):
        '''
        
        :param new_data_matrix:  eingelesene Daten (z.B. csv-Datei)
        :param konto_dict:  das Konto ictionary mit allen ini-Infos
        :param new_data_idenx_list:    Name der eingelsenen Datei für errtext
        :return: (new_data_set_flag,status,errtext,infotext) =  self.set_new_data(new_data_table)
        '''
        self.status = hdef.OKAY
        new_data_set_flag = False
        self.infotext = ""
        
        if isinstance(new_data_table,htvar.TList):
            new_data_table = htvar.build_table_from_list(new_data_table)
        # end if
        
        new_data_table = self.add_chash_to_table(new_data_table)
        if self.status != hdef.OKAY:
            return (False, self.status, self.errtext)
        # endif

        new_data_table = self.filter_by_chash_to_table(new_data_table)
        if self.status != hdef.OKAY:
            return (False, self.status, self.errtext)
        # endif
        
        if new_data_table.ntable > 0:
            
            n_data_old = self.data_set_obj.get_n_data()

            # sort buchtypes in correct order
            new_data_table = self.proof_and_set_correct_order_buchttypes(new_data_table)

            if flag_proof_wert:
                new_data_table = self.proof_wert_in_table_mit_buchtype(new_data_table)
            else:
                new_data_table = self.proof_buchtype_in_table_mit_wert(new_data_table)
            # end if
            
            if self.status != hdef.OKAY:
                return (False, self.status, self.errtext)
            # endif
        
        
            # sort new data
            #--------------
            new_data_table = htvar.sort_col_in_table(new_data_table,self.par.KONTO_DATA_NAME_BUCHDATUM)
            
            new_data_table = self.build_internal_values_new_data_table(new_data_table)
            if self.status != hdef.OKAY:
                return (False, self.status, self.errtext)
            # endif
            
            # find suspicious
            self.infotext = self.find_suspiciuos_doubles_for_info(new_data_table)
            
            status = self.data_set_obj.add_data_set_tvar(new_data_table,line_color = self.par.LINE_COLOR_NEW)

            if status != hdef.OKAY:
                self.status = status
                self.errtext = self.data_set_obj.errtext
                self.data_set_obj.reset_status()
                return (False, self.status, self.errtext)
            # endif
            
            # check iban
            if self.data_set_obj.get_n_data() > n_data_old:
                for irow in range(n_data_old,self.data_set_obj.get_n_data()):
                    self.check_iban(irow)
                # end for
            # end if

            # sort
            self.data_set_obj.update_order_name(self.par.KONTO_DATA_NAME_BUCHDATUM)

            # recalc_sum
            self.recalc_sum_data_set()
            
            new_data_set_flag = True
        else:
            
            new_data_set_flag = False
            self.infotext = "Keine neuen Daten eingelesen !!!!"

        return (new_data_set_flag, self.status, self.errtext,self.infotext)
    
    # enddef
    def update_isin_find(self):
        '''
        
        :return: self.update_isin_find()
        '''
        
        for irow in range(self.data_set_obj.get_n_data()):
            
            ttlist = self.data_set_obj.get_one_data_set_tlist(irow)
            
            (ttlist, change_flag) = self.update_isin_data_set_tlist(ttlist)
            
            if change_flag:
                status = self.data_set_obj.set_data_tlist(ttlist, self.par.LINE_COLOR_NEW, irow)
                id     = self.data_set_obj.get_data_item(irow,self.par.KONTO_DATA_NAME_ID)
                self.new_read_id_list.append(id)
            # end if
        # end
    # end def
    def update_isin_data_set_tlist(self, tlist):
        '''

        :param data_set:
        :return: (tlist, change_flag) = self.update_isin_data_set_tlist(tlist)
        '''
        
        change_flag = False
        
        buch_type = htvar.get_val_from_list(tlist, self.par.KONTO_DATA_NAME_BUCHTYPE)
        
        if isinstance(buch_type,str):
            (okay,wert) = htype.type_transform(buch_type, self.par.KONTO_BUCHTYPE_TEXT_LIST, self.par.KONTO_BUCHTYPE_INDEX_LIST)
            if okay == hdef.OKAY:
                buch_type = wert
            else:
                raise Exception(f"update_isin_data_set_tlist: Problem buch_type")
            # end if
        # end if
        
        isin_in = htvar.get_val_from_list(tlist, self.par.KONTO_DATA_NAME_ISIN)
        comment = htvar.get_val_from_list(tlist, self.par.KONTO_DATA_NAME_COMMENT)
        
        if (buch_type == self.par.KONTO_BUCHTYPE_INDEX_WP_KAUF) or \
            (buch_type == self.par.KONTO_BUCHTYPE_INDEX_WP_VERKAUF) or \
            (buch_type == self.par.KONTO_BUCHTYPE_INDEX_WP_KOSTEN) or \
            (buch_type == self.par.KONTO_BUCHTYPE_INDEX_WP_EINNAHMEN):
            
            if (len(isin_in) == 0) or (isin_in == "isinnotfound"):
                isin_in = None
            
            isin = self.search_isin(isin_in, comment)
        else:
            isin = ""
        # endif
        
        if (len(isin) > 0) and (isin != isin_in):
            tlist = htvar.set_val_in_list(tlist, isin, self.par.KONTO_DATA_NAME_ISIN)
            change_flag = True
        # end if
        
        return (tlist, change_flag)
    
    # end def
    def get_data_set_dict_ttable(self,header_liste=None ,type_liste=None):
        '''
        :return: ttable = get_data_set_dict_ttable()
        '''
        
        
        ttable = self.data_set_obj.get_data_set_ttable(header_liste,type_liste)
        return  ttable
    # end def
    def get_timedepend_data_set_dict_ttable(self,header_list, type_list, tval_min_time, tval_max_time,with_start=True) :
        '''
        
        :param header_list:
        :param type_list:
        :param min_time:
        :param max_time:
        :param with_start: True/False
        :return: ttable = self.get_timedepend_data_set_dict_ttable(header_list, type_list, min_time, max_time,with_start)
        '''

        ttable = htvar.build_table(header_list,[],type_list)

        irowlist = self.data_set_obj.get_irowlist_in_limits(self.par.KONTO_DATA_NAME_BUCHDATUM
                                                           ,tval_min_time,tval_max_time)
        
        if self.data_set_obj.status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = f"get_timedepend_data_set_dict_ttable: \n{self.data_set_obj.errtext}"
            self.data_set_obj.reset_status()
            return ttable
        # end if
        
        if not with_start:
            
            irowlist = hlist.erase_from_list_by_value(irowlist, self.konto_start_irow)
        # end if
        
        for irow in irowlist:
           
            tlist =  self.data_set_obj.get_one_data_set_tlist(irow,header_list,type_list)
            
            if self.data_set_obj.status != hdef.OKAY:
                self.status = hdef.NOT_OKAY
                self.errtext = f"get_timedepend_data_set_dict_ttable: \n{self.data_set_obj.errtext}"
                self.data_set_obj.reset_status()
                return ttable
            # end if
            
            ttable = htvar.add_list_to_table(ttable,tlist)
        # end for
        
        return ttable
    
    # # end def
    def get_anzeige_ttable(self):
        '''
        
        :param istart:           aktuelle start zeile
        :param dir:              dir=1 vorwärts blättern, dir=0 starten, dir=-1 rückwärts blättern
        :param number_of_lines:  Anzahl der zeilen, die gezeigt werden soll
        :return:                 (ttable,row_color_dliste) = self.get_anzeige_ttable()
        '''
        
        ttable = self.data_set_obj.get_data_set_ttable()
        
        ttable = htvar.transform_icol_table(ttable,self.par.KONTO_DATA_EXTERN_NAME_LIST)
        
        ttable = htvar.transform_type_table(ttable, self.par.KONTO_DATA_EXTERN_TYPE_LIST)
        
        row_color_dliste = self.data_set_obj.get_line_color_set_liste()
        
        return (ttable,row_color_dliste)
        
    # end def
    def write_anzeige_back_data(self, ttable_anzeige, data_changed_pos_list,header_liste=[]):
        '''
        
        :param new_data_llist:
        :param data_changed_pos_list:
        :param header_liste=[]:  Liste mit den Headernamen, die geändert werden können, leer: alle ändern
        :return: self.write_anzeige_back_data(ttable_anzeige, data_changed_pos_list)
        '''
        self.infotext = ""
        self.errtext = ""
        
        if not isinstance(header_liste,list):
            header_liste = [header_liste]
        # end if
        
        if len(header_liste) == 0:
            noproof = True
        else:
            noproof = False
        
        index_liste = list(self.par.KONTO_DATA_EXTERN_NAME_DICT.keys())
        
        changed = False
        for (irow, icol) in data_changed_pos_list:
            
            value = ttable_anzeige.table[irow][icol]
            name  = ttable_anzeige.names[icol]
            type  = ttable_anzeige.types[icol]
            
            if noproof or name in header_liste:
            
                if name in self.par.KONTO_DATA_IMMUTABLE_NAME_LIST:
                    self.infotext = f"Der Wert von {name} mit dem Wert in table.vals[{irow}][{icol}] = {value} darf nicht verändert werden !!!!!!!"
                else:
                    if self.data_set_obj.set_data_item(value, self.par.LINE_COLOR_EDIT, irow, name, type):
                        
                        if self.data_set_obj.status != hdef.OKAY:
                            self.status = hdef.NOT_OKAY
                            self.errtext = f"write_anzeige_back_data: Fehler set_data_item  errtext: {self.data_set_obj.errtext}"
                            return
                        # end if
                        changed = True
                    # end if
                # end if
        # end for
        

        
        if changed:
            # sort
            self.data_set_obj.update_order_name(self.par.KONTO_DATA_NAME_BUCHDATUM)
            # recalc
            self.recalc_sum_data_set()
        # end if
    
    # end def
    #
    # def update_sumwert_in_lliste(self,istart):
    #     '''
    #
    #     :return:
    #     '''
    #
    #     if istart == 0:
    #         sumwert = self.konto_start_wert
    #     else:
    #         sumwert = self.data_set_obj.get_data_item(istart - 1,self.par.KONTO_DATA_NAME_SUMWERT)
    #     # end if
    #
    #     i = istart
    #     while i < self.data_set_obj.get_n_data():
    #         sumwert += self.data_set_obj.get_data_item(i,self.par.KONTO_DATA_NAME_WERT)
    #         self.data_set_obj.set_data_item(int(sumwert), self.par.KONTO_DATA_NAME_SUMWERT, "cent")
    #         i += 1
    #     # end while
    #
    # def delete_new_data_list(self):
    #     '''
    #
    #     :return: self.delete_new_data_list()
    #     '''
    #     self.new_read_id_list = []
    #
    # # end def
    def get_edit_data(self,irow):
        '''
        
        :param irow:
        :return: (tlist, buchungs_type_list, buchtype_index_in_header_liste) = self.get_edit_data(irow)
        '''
        
        tlist = self.data_set_obj.get_one_data_set_tlist(irow)
        
        tlist = htvar.transform_icol_list(tlist, self.par.KONTO_DATA_EXTERN_NAME_LIST)
        
        tlist = htvar.transform_type_list(tlist, self.par.KONTO_DATA_EXTERN_TYPE_LIST)
        
        if self.par.KONTO_DATA_NAME_BUCHTYPE in tlist.names:
            buchtype_index_in_header_liste = htvar.get_index_from_list(tlist,self.par.KONTO_DATA_NAME_BUCHTYPE)
        else:
            buchtype_index_in_header_liste = -1
        # endif

        return (tlist, self.par.KONTO_BUCHTYPE_TEXT_LIST, buchtype_index_in_header_liste)
    
    # end def
    def get_extern_default_tlist(self):
        '''
        index_in_header_liste index in header list für buch type
        :return: (tlist, buchungs_type_list, buchtype_index_in_header_liste) =  self.get_extern_default_tlist()
        '''
        
        header_liste = self.par.KONTO_DATA_EXTERN_NAME_LIST
        type_liste   = self.par.KONTO_DATA_EXTERN_TYPE_LIST
        tlist        = htvar.build_default_list(header_liste,type_liste)

        if self.par.KONTO_DATA_NAME_BUCHTYPE in self.par.KONTO_DATA_EXTERN_NAME_LIST:
            buchtype_index_in_header_liste = self.par.KONTO_DATA_EXTERN_NAME_LIST.index(self.par.KONTO_DATA_NAME_BUCHTYPE)
        else:
            buchtype_index_in_header_liste = -1
        # endif
        
        return (tlist, self.par.KONTO_BUCHTYPE_TEXT_LIST, buchtype_index_in_header_liste)
    
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
    #     new_data_dict_list = self.build_internal_values_new_data_table(new_data_dict_list)
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
    def delete_data_set(self, irow):
        '''
        
        :param irow:
        :return: (status,errtext) = delete_data_set(irow)
        '''
        if irow < 0:
            self.status = hdef.NOT_OKAY
            self.errtext = f"KontoDataSet.delete_data_set: irow = {irow} is negative"
        
        elif irow >= self.data_set_obj.get_n_data():
            self.status = hdef.NOT_OKAY
            self.errtext = f"KontoDataSet.delete_data_set: irow = {irow} >= len(data_set_llist) = {self.data_set_obj.get_n_data()}"
        else:
            self.data_set_obj.delete_row_in_data_set(irow)
            if self.data_set_obj.status != hdef.OKAY:
                self.status = self.data_set_obj.status
                self.errtext = self.data_set_obj.errtext
            # end if
        # end if
        
        return (self.status, self.errtext)
    
    # end def
    def update_isin_w_wpname_wkn(self,isin, wpname, wkn):
        '''
        
        :param isin:
        :param wpname:
        :param wkn:
        :return: status = obj.update_isin_w_wpname_wkn(isin, wpname, wkn)
        '''
    
        status = self.wpfunc.update_isin_w_wpname_wkn(isin, wpname, wkn)
        
        self.status = status
        self.errtext = self.wpfunc.errtext
        
        return status
    # end def
    #-------------------------------------------------------------------------------------------------------------------
    # intern functions
    #-------------------------------------------------------------------------------------------------------------------
    def find_suspiciuos_doubles_for_info(self, new_data_table):
        '''

        :param new_data_table:
        :return: infotext = self.find_suspiciuos_doubles_for_info(new_data_table)
        '''
        itext = ""
        index_buchdatum = htvar.get_index_from_table(new_data_table, self.par.KONTO_DATA_NAME_BUCHDATUM)
        index_wert      = htvar.get_index_from_table(new_data_table, self.par.KONTO_DATA_NAME_WERT)
        index_comment   = htvar.get_index_from_table(new_data_table, self.par.KONTO_DATA_NAME_COMMENT)

        type_buchdatum = self.par.KONTO_DATA_TYPE_DICT[self.par.KONTO_DATA_INDEX_BUCHDATUM]
        type_wert = self.par.KONTO_DATA_TYPE_DICT[self.par.KONTO_DATA_INDEX_WERT]

        for irow in range(new_data_table.ntable):
            buchdatum = htvar.get_val_from_table(new_data_table, irow, index_buchdatum,type_buchdatum)
            wert = htvar.get_val_from_table(new_data_table, irow, index_wert,type_wert)
            
            irow_list = self.data_set_obj.find_in_col(wert, type_wert, self.par.KONTO_DATA_INDEX_WERT)
            
            for irow_data in irow_list:
                buchdatum_proof \
                    = self.data_set_obj.get_data_item(irow_data,self.par.KONTO_DATA_INDEX_BUCHDATUM,type_buchdatum)
                
                if buchdatum == buchdatum_proof:
                    bdat = htvar.get_val_from_table(new_data_table, irow, index_buchdatum,'datStrP')
                    w    = htvar.get_val_from_table(new_data_table, irow, index_wert,'euroStrK')
                    c = htvar.get_val_from_table(new_data_table, irow, index_comment,'str')
                    itext += f"Vorsicht in neuer Buchung ist buchdatum: {bdat} und wert = {w} und comment = {c} gleich \n"
                # end if
            # end for

        return itext
    
    # end def
    def proof_and_set_correct_order_buchttypes(self,new_data_table):
        '''
        
        :param new_data_table:
        :return: new_data_table = self.proof_and_set_correct_order_buchttypes(new_data_table)
        '''
        
        index =  htvar.get_index_from_table(new_data_table,self.par.KONTO_DATA_NAME_BUCHTYPE)
        
        buchtype_liste  = new_data_table.types[index]
        
        for buchtype in buchtype_liste:
            
            if buchtype not in self.par.KONTO_BUCHTYPE_TEXT_LIST:
                raise Exception(f"proof_and_set_correct_order_buchttypes: buchtype: {buchtype} (aus ini) ist nicht in KONTO_BUCHTYPE_TEXT_LIST: {self.par.KONTO_BUCHTYPE_TEXT_LIST} !!!")
            # end if
        # end for
        new_data_table.types[index] = self.par.KONTO_BUCHTYPE_TEXT_LIST
        
        return new_data_table
    # end def
    # def recalc_chash_wo_comment(self,ttable):
    #     '''
    #
    #     :param ttable:
    #     :return: ttable = self.recalc_chash_wo_comment(ttable)
    #     '''
    #     if ttable.ntable:
    #         index_buchdatum = htvar.get_index_from_table(ttable, self.par.KONTO_DATA_NAME_BUCHDATUM)
    #         index_wert      = htvar.get_index_from_table(ttable, self.par.KONTO_DATA_NAME_WERT)
    #         index_chash     = htvar.get_index_from_table(ttable, self.par.KONTO_DATA_NAME_CHASH)
    #     # end if
    #     for irow in range(ttable.ntable):
    #         buchdatum = htvar.get_val_from_table(ttable, irow, index_buchdatum)
    #         wert = htvar.get_val_from_table(ttable, irow, index_wert)
    #         value = str(buchdatum) + str(wert)
    #         chash_new = htype.type_convert_to_hashkey(value)
    #         ttable = htvar.set_val_in_table(ttable,chash_new,irow,index_chash,'int')
    #     # end for
    #
    #     return ttable
    # # end def
    def add_chash_to_table(self, new_data_table):
        '''
        
        :param new_data_table:
        :return: (modified_new_data_table) = self.add_chash_to_table(new_data_table)
        '''
        
        # index_comment = htvar.get_index_from_table(new_data_table, self.par.KONTO_DATA_NAME_COMMENT)
        index_buchdatum = htvar.get_index_from_table(new_data_table, self.par.KONTO_DATA_NAME_BUCHDATUM)
        index_wert = htvar.get_index_from_table(new_data_table, self.par.KONTO_DATA_NAME_WERT)
        
        chash_liste = []
        for irow in range(new_data_table.ntable):
            
            # comment = htvar.get_val_from_table(new_data_table,irow,index_comment)
            buchdatum = htvar.get_val_from_table(new_data_table,irow,index_buchdatum)
            wert = htvar.get_val_from_table(new_data_table,irow,index_wert)
            value = str(buchdatum) + str(wert)
            chash_new = htype.type_convert_to_hashkey(value)
            print(f"{irow =} {chash_new =}")
            chash_liste.append(chash_new)
        # end for
        new_data_table = htvar.add_row_liste_to_table(new_data_table, self.par.KONTO_DATA_NAME_CHASH,chash_liste,"int")
        
        return new_data_table
    # end def
    def filter_by_chash_to_table(self,new_data_table):
        '''
        
        :param new_data_table:
        :return: new_data_table = self.filter_by_chash_to_table(new_data_table)
        '''
        
        index_chash = htvar.get_index_from_table(new_data_table, self.par.KONTO_DATA_NAME_CHASH)
        type_chash = htvar.get_type_from_table(new_data_table, self.par.KONTO_DATA_NAME_CHASH)
        
        icol_chash = self.par.KONTO_DATA_INDEX_CHASH
        
        
        irow_erase_list = []
        for irow in range(new_data_table.ntable):
            chash = htvar.get_val_from_table(new_data_table,irow,index_chash,type_chash)
            
            irow_list = self.data_set_obj.find_in_col(chash, type_chash,icol_chash )
            if len(irow_list) > 0:
                irow_erase_list.append(irow)
            else:
                nnn = len(irow_erase_list)
            # end if
        # end for
        nnn = len(irow_erase_list)
        if len(irow_erase_list) > 0:
            new_data_table = htvar.erase_irows_in_table(new_data_table,irow_erase_list)
        return new_data_table
    # end def
    # def transform_new_data_table(self, new_data_table):
    #     '''
    #
    #     :param new_data_table:
    #
    #     :return: new_data_table = self.transform_new_data_table(new_data_table)
    #     '''
    #
    #     # get wanted types
    #     types = []
    #     for name in new_data_table.names:
    #
    #         type = self.data_set_obj.get_type_of_header(name)
    #         if self.data_set_obj.status != hdef.OKAY:
    #             self.status = hdef.NOT_OKAY
    #             self.errtext = self.data_set_obj.errtext
    #             self.data_set_obj.reset_status()
    #             return new_data_table
    #
    #     for index in range(n):
    #         data_dict = new_data_dict_list[index]
    #         for konto_data_index in data_dict.keys():
    #             value_to_transform = data_dict[konto_data_index]
    #             value_typ = new_type_dict[konto_data_index]
    #             # if( value_to_transform == '"-70,04"'):
    #             #     print(value_to_transform)
    #             (okay, wert) = htype.type_transform(value_to_transform, value_typ,self.par.KONTO_DATA_TYPE_DICT[konto_data_index])
    #             if okay != hdef.OKAY:
    #                 raise Exception(
    #                     f"Fehler transform  <{value_to_transform}> von type: {value_typ} in type {self.par.KONTO_DATA_TYPE_DICT[konto_data_index]} wandeln !!!")
    #             # end if
    #
    #             # schreibe gewandelten Wert wieder zurück
    #             data_dict[konto_data_index] = wert
    #         # end for
    #         new_data_dict_list[index] = data_dict
    #     # end for
    #
    #     return new_data_dict_list
    
    # end def
    def proof_buchtype_in_table_mit_wert(self,new_data_table):
        '''
        
        :param new_data_table:
        :return: new_data_table = self.proof_buchtype_in_table_mit_wert(new_data_table)
 
        '''
        
        for irow in range(new_data_table.ntable):
            
            if htvar.check_name_from_table(new_data_table, self.par.KONTO_DATA_NAME_BUCHTYPE) \
               and htvar.check_name_from_table(new_data_table, self.par.KONTO_DATA_NAME_WERT) :
            
                buchtype = htvar.get_val_from_table(new_data_table,irow,self.par.KONTO_DATA_NAME_BUCHTYPE)
            
                if buchtype in self.par.KONTO_BUCHTYPE_TEXT_LIST:
                    buchtype_index = self.par.KONTO_BUCHTYPE_TEXT_LIST.index(buchtype)
                else:
                    buchtype_index = -1
                # end if
                if buchtype_index in self.par.KONTO_DATA_BUCHTYPE_PROOF_DICT.keys():
                    change_flag = False
                    wert = htvar.get_val_from_table(new_data_table,irow,self.par.KONTO_DATA_NAME_WERT,'cent')
                    wert_type = self.par.KONTO_DATA_BUCHTYPE_PROOF_DICT[buchtype_index][0]
                    if  wert_type > 0: # soll positiv sein
                        if wert < 0:
                            buchtype = self.par.KONTO_DATA_BUCHTYPE_PROOF_DICT[buchtype_index][1]
                            change_flag = True
                        # end if
                    else: # soll negative sein
                        if wert > 0:
                            buchtype = self.par.KONTO_DATA_BUCHTYPE_PROOF_DICT[buchtype_index][1]
                            change_flag = True
                        # end if
                    # end if
                    
                    if change_flag:
                        
                        (okay, wert) = htype.type_transform(buchtype, self.par.KONTO_BUCHTYPE_INDEX_LIST,
                                                            self.par.KONTO_BUCHTYPE_TEXT_LIST)
                        if okay == hdef.OKAY:
                            buchtype = wert
                        else:
                            raise Exception(f"proof_buchtype_in_table_mit_wert: Problem buchtype")
                        # end if
                        
                        new_data_table = htvar.set_val_in_table(new_data_table, buchtype, irow, self.par.KONTO_DATA_NAME_BUCHTYPE)
                    # end if
                # end if
            # end if
        # end for
        return new_data_table
    # end def
    def proof_wert_in_table_mit_buchtype(self, new_data_table):
        '''

        :param new_data_table:
        :return: new_data_table = self.proof_wert_in_table_mit_buchtype(new_data_table)

        '''
        
        for irow in range(new_data_table.ntable):
            
            if htvar.check_name_from_table(new_data_table, self.par.KONTO_DATA_NAME_BUCHTYPE) \
                and htvar.check_name_from_table(new_data_table, self.par.KONTO_DATA_NAME_WERT):
                
                buchtype = htvar.get_val_from_table(new_data_table, irow, self.par.KONTO_DATA_NAME_BUCHTYPE)
                
                if buchtype in self.par.KONTO_BUCHTYPE_TEXT_LIST:
                    buchtype_index = self.par.KONTO_BUCHTYPE_TEXT_LIST.index(buchtype)
                else:
                    buchtype_index = -1
                # end if
                if buchtype_index in self.par.KONTO_DATA_BUCHTYPE_PROOF_DICT.keys():
                    change_flag = False
                    wert = htvar.get_val_from_table(new_data_table, irow, self.par.KONTO_DATA_NAME_WERT, 'cent')
                    wert_type = self.par.KONTO_DATA_BUCHTYPE_PROOF_DICT[buchtype_index][0]
                    if wert_type > 0:  # soll positiv sein
                        if wert < 0:
                            wert *= -1
                            change_flag = True
                        # end if
                    else:  # soll negative sein
                        if wert > 0:
                            wert *= -1
                            change_flag = True
                        # end if
                    # end if
                    
                    if change_flag:
                        
                        (okay, value) = htype.type_transform(wert, 'cent',self.par.KONTO_DATA_TYPE_DICT[self.par.KONTO_DATA_INDEX_WERT])
                        if okay == hdef.OKAY:
                            wert = value
                        else:
                            raise Exception(f"proof_wert_in_table_mit_buchtype: Problem wert")
                        # end if
                        
                        new_data_table = htvar.set_val_in_table(new_data_table
                                                                , wert
                                                                , irow
                                                                , self.par.KONTO_DATA_NAME_WERT
                                                                , self.par.KONTO_DATA_TYPE_DICT[self.par.KONTO_DATA_INDEX_WERT])
                    # end if
                # end if
            # end if
        # end for
        return new_data_table
    
    # end def
    def build_internal_values_new_data_table(self, new_data_table):
        '''
        
        :param new_data_dict_list:
        :return: new_data_table = self.build_internal_values_new_data_table(new_data_table)
        '''
        
        # isin Nummer, wenn eine wp Buchungs type
        # id wert mit self.idfunc.get_new_id()
        # chash hash.Wert vom ursprünglichen Kommentar
        # kategorie als leerer string
        isin_liste = []
        id_liste = []
        kat_liste = []
        sum_liste = []
        for irow in range(new_data_table.ntable):
            
            buchtype = htvar.get_val_from_table(new_data_table, irow, self.par.KONTO_DATA_NAME_BUCHTYPE)
            
            if isinstance(buchtype, str):
                (okay, wert) = htype.type_transform(buchtype, self.par.KONTO_BUCHTYPE_TEXT_LIST,
                                                    self.par.KONTO_BUCHTYPE_INDEX_LIST)
                if okay == hdef.OKAY:
                    buchtype = wert
                else:
                    raise Exception(f"build_internal_values_new_data_table: Problem buch_type")
                # end if
            # end if
            
            if (buchtype == self.par.KONTO_BUCHTYPE_INDEX_WP_KAUF) or \
                (buchtype == self.par.KONTO_BUCHTYPE_INDEX_WP_VERKAUF) or \
                (buchtype == self.par.KONTO_BUCHTYPE_INDEX_WP_KOSTEN) or \
                (buchtype == self.par.KONTO_BUCHTYPE_INDEX_WP_EINNAHMEN):
                
                if htvar.check_name_from_table(new_data_table,self.par.KONTO_DATA_NAME_ISIN):
                    isin_in = htvar.get_val_from_table(new_data_table, irow, self.par.KONTO_DATA_NAME_ISIN)
                else:
                    isin_in = None
                # end if
                if htvar.check_name_from_table(new_data_table, self.par.KONTO_DATA_NAME_COMMENT):
                    comment = htvar.get_val_from_table(new_data_table, irow, self.par.KONTO_DATA_NAME_COMMENT)
                else:
                    comment = ""
                # end if
                
                isin = self.search_isin(isin_in,comment)
            else:
                isin = ""
            # end if
            
            # ISIN if detected
            isin_liste.append(isin)
            
            # count up IDMAX
            id_liste.append(self.idfunc.get_new_id())
            
            kat_liste.append("")
            sum_liste.append(0)
            
        # endfor
        
        new_data_table = htvar.add_row_liste_to_table(new_data_table, self.par.KONTO_DATA_NAME_ISIN, isin_liste,"isin")
        new_data_table = htvar.add_row_liste_to_table(new_data_table, self.par.KONTO_DATA_NAME_ID, id_liste,"int")
        new_data_table = htvar.add_row_liste_to_table(new_data_table, self.par.KONTO_DATA_NAME_KATEGORIE, kat_liste,"str")
        new_data_table = htvar.add_row_liste_to_table(new_data_table, self.par.KONTO_DATA_NAME_SUMWERT, sum_liste,"cent")

        
        return new_data_table
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
            (okay, wkn,isin) = self.search_wkn_from_comment(comment)
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
            isin = ""
            wkn = ""
            okay = hdef.NOT_OKAY
        else:
            print(f"Start getting isin from wkn: {wkn} ")
            (okay, isin) = self.wpfunc.get_isin_from_wkn(wkn)
            print(f"End getting isin from wkn: {wkn}, isin = {isin} ")
        # end if
        
        # search wpname in comment
        if okay != hdef.OKAY:
            (okay,isin) = self.wpfunc.find_wpname_in_comment_get_isin(comment)
        # end if
        
        return (okay,wkn,isin)
    # end def
    
    # def add_new_data_dict(self, new_data_dict_list):
    #     '''
    #
    #     :param new_data_dict_list:
    #     :return: self.add_new_data_dict_and_recalc_sum(new_data_dict_list)
    #     '''
    #     self.new_read_id_list = []
    #     new_data_flag = False
    #     for data_dict in new_data_dict_list:
    #         data_set_list = []
    #         for index in self.par.KONTO_DATA_INDEX_LIST:
    #             data_set_list.append(data_dict[index])
    #         # end for
    #
    #         if len(data_set_list) > 0:
    #             self.data_set_llist.append(data_set_list)
    #             self.new_read_id_list.append(data_set_list[self.par.KONTO_DATA_INDEX_ID])
    #             new_data_flag = True
    #         # end for
    #
    #
    #
    #     return new_data_flag
    # end def
    # def sort_data_set_llist(self):
    #     # sort
    #     self.data_set_llist = hlist.sort_list_of_list(self.data_set_llist, self.par.KONTO_DATA_INDEX_BUCHDATUM,
    #                                                   aufsteigend=1)
    # # end def
    def recalc_sum_data_set(self):
        '''
        
        :return: self.recalc_sum_data_set()
        '''

        sumwert = self.data_set_obj.get_data_item(0,self.par.KONTO_DATA_NAME_SUMWERT)
        for i in range(self.data_set_obj.get_n_data()):
            sumwert += self.data_set_obj.get_data_item(i,self.par.KONTO_DATA_NAME_WERT)
            old_sumwert = self.data_set_obj.get_data_item(i,self.par.KONTO_DATA_NAME_SUMWERT)
            if sumwert != old_sumwert:
                self.data_set_obj.set_data_item(sumwert, self.par.LINE_COLOR_EDIT, i, self.par.KONTO_DATA_NAME_SUMWERT)
            # end if
        # end for
    # end def
    # def build_range_to_show_dataset(self, istart, number_of_lines, dir):
    #     '''
    #
    #     :param nlines:  maximale Anzahl an Zeilen
    #     :param istart:  letzte startzeile (-1 ist beginn)
    #     :param number_of_lines:   Wieviele Zeile zeigen
    #     :param dir:     -1 zurück, +1 vorwärts, dir = 0 start
    #     :return:     (istart,iend) = build_range_to_show_dataset(istart,number_of_lines,dir)
    #     '''
    #     if dir == 0:  # Start with newest part
    #         istart = max(0, self.data_set_obj.get_n_data() - number_of_lines)
    #     elif dir > 0:
    #         istart = min(istart + number_of_lines, max(0, self.data_set_obj.get_n_data() - number_of_lines))
    #     else:
    #         istart = max(istart - number_of_lines, 0)
    #     # endif
    #     iend = min(istart + number_of_lines - 1, max(0, self.data_set_obj.get_n_data() - 1))
    #     return (istart, iend)
    #
    # # end def
    # def build_data_table_list_and_color_list(self, istart=0, iend=-1):
    #     '''
    #
    #     :param istart:
    #     :param iend:
    #     :return: (header_list, data_llist, new_data_list) = self.build_data_table_list_and_color_list(istart,iend)
    #     '''
    #
    #     if iend < 0:
    #         iend = self.data_set_obj.get_n_data()-1
    #     # end if
    #
    #     # 1) header_liste
    #     # ===========================
    #     header_list = []
    #     for key in self.par.KONTO_DATA_EXTERN_NAME_DICT.keys():
    #         header_list.append(self.par.KONTO_DATA_EXTERN_NAME_DICT[key])
    #     # end for
    #
    #     # 2) data_llist,new_data_list
    #     # ============================
    #     data_llist = []
    #     new_data_list = []
    #     index = istart
    #     while (index <= iend) and (index < self.data_set_obj.get_n_data()):
    #         data_set_list = self.data_set_llist[index]
    #         data_list = []
    #         for key in self.par.KONTO_DATA_EXTERN_NAME_DICT.keys():
    #             (okay, wert) = htype.type_transform(data_set_list[key],self.par.KONTO_DATA_TYPE_DICT[key],self.par.KONTO_DATA_EXTERN_TYPE_DICT[key])
    #             if okay != hdef.OKAY:
    #                 raise Exception(
    #                     f"Fehler transform  {data_set_list[key]} von type: {self.par.KONTO_DATA_TYPE_DICT[key]} in type {self.par.KONTO_DATA_EXTERN_TYPE_DICT[key]} wandeln !!!")
    #             # end if
    #             data_list.append(wert)
    #             # if key == self.par.KONTO_DATA_INDEX_BUCHDATUM:
    #             #     data_list.append(hdate.secs_time_epoch_to_str(data_set_list[key]))
    #             # elif key == self.par.KONTO_DATA_INDEX_WERTDATUM:
    #             #     data_list.append(hdate.secs_time_epoch_to_str(data_set_list[key]))
    #             # elif key == self.par.KONTO_DATA_INDEX_BUCHTYPE:
    #             #     data_list.append(self.par.KONTO_BUCHTYPE_TEXT_LIST[data_set_list[key]])
    #             # elif key == self.par.KONTO_DATA_INDEX_WERT:
    #             #     data_list.append(hstr.convert_int_cent_to_string_euro(data_set_list[key], self.DECIMAL_TRENN_STR))
    #             # elif key == self.par.KONTO_DATA_INDEX_SUMWERT:
    #             #     data_list.append(hstr.convert_int_cent_to_string_euro(data_set_list[key], self.DECIMAL_TRENN_STR))
    #             # else:
    #             #     data_list.append(data_set_list[key])
    #             # # end if
    #         # end for
    #         data_llist.append(data_list)
    #         if data_set_list[self.par.KONTO_DATA_INDEX_ID] in self.new_read_id_list:
    #             new_data_list.append(True)
    #         else:
    #             new_data_list.append(False)
    #         # end if
    #         index += 1
    #     # end while
    #     return (header_list, data_llist, new_data_list)
    # # end def
    #-------------------------------------------------------------------------------------------------------------------
    # Werte abfrage
    #-------------------------------------------------------------------------------------------------------------------
    def get_number_of_data(self):
        return self.data_set_obj.get_n_data()
    # endif
    def get_irow_by_id(self,id):
        '''
        
        :param id:
        :return:
        '''
        
        irow_list = self.data_set_obj.find_in_col(id
                                                  , self.par.KONTO_DATA_TYPE_DICT[self.par.KONTO_DATA_INDEX_ID]
                                                  , self.par.KONTO_DATA_NAME_ID)
        if self.data_set_obj.status != hdef.OKAY:
            self.status = self.data_set_obj.status
            self.errtext = self.data_set_obj.errtext
        # end if
        
        if len(irow_list) > 1:
            raise Exception(
                f"Fehler mit  id = {id}, kommt im data_set mehrfach vor index_liste = {irow_list} !!!")
        # end if
        
        if len(irow_list) == 1:
            irow = irow_list[0]
        else:
            irow = -1
        # end if
        
        return irow
    # end def
    def get_konto_name(self):
        return self.konto_name
    def get_buchtype_str(self,irow):
        if irow < self.data_set_obj.get_n_data():
            value = self.data_set_obj.get_data_item(irow,self.par.KONTO_DATA_NAME_BUCHTYPE,self.par.KONTO_DATA_BUCHTYPE_DICT)
            return value
        else:
            return None
    # end def
    def get_data_item_at_irow(self,irow,data_name,data_type):
        '''
        
        :param irow:
        :param data_name:
        :param data_taype:
        :return: value = self.get_data_item_at_irow(irow,data_name,data_type)
        '''
        if irow < self.data_set_obj.get_n_data():
            if irow == 2:
                a=0
                
            value = self.data_set_obj.get_data_item(irow,data_name,data_type)
            
            if self.data_set_obj.status != hdef.OKAY:
                org_data_type = self.data_set_obj.get_type_of_header(data_name)
                raise Exception(
                    f"get_data_item_at_irow: Fehler get_data_item irow: {irow} has no data_name: {data_name} and/or type: <{org_data_type}> in type <{data_type}> !!!")
            # end if
            return value
        else:
            return None
    # end def
    def kategorie_regel_anwenden(self):
        '''
        Anwenden der Kategorie Regeln auf nicht gesetzte Kategorien
        :return:
        '''
        
        # Zuerst prüfen, falls geändert
        if self.katfunc:
            self.proof_kategorie_in_data_set()
            
        if self.status != hdef.OKAY:
            return
        
        icol_kat = self.par.KONTO_DATA_EXTERN_NAME_LIST.index(self.par.KONTO_DATA_NAME_KATEGORIE)
        
        for irow in range(self.data_set_obj.get_n_data()):
            
            if irow == 5:
                iii = 1
            
            tlist = self.data_set_obj.get_one_data_set_tlist(
                irow,
                self.par.KONTO_DATA_EXTERN_NAME_LIST,
                self.par.KONTO_DATA_EXTERN_TYPE_LIST)
            
            if self.katfunc and (len(tlist.vals[icol_kat]) == 0):
                
                (found,kat) = self.katfunc.regel_anwedung_data_set(tlist)
                
                if found:
                    self.data_set_obj.set_data_item(kat,self.par.LINE_COLOR_EDIT,irow, self.par.KONTO_DATA_NAME_KATEGORIE)
                    if self.data_set_obj.status != hdef.OKAY:
                        self.status = hdef.NOT_OKAY
                        self.errtext = self.data_set_obj.errtext
                        self.data_set_obj.reset_status()
                        return
                # end if
            # end if
        # end for
        
        return
    # end def
    def reset_line_color(self):
        '''
        
        :return:
        '''
        self.data_set_obj.reset_line_color(self.par.LINE_COLOR_BASE)
        return
    # end def