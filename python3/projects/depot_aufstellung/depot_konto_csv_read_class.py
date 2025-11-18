import os, sys
import copy

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif


import tools.hfkt_def as hdef
import tools.hfkt_io as hio
import tools.hfkt_list as hlist
import tools.hfkt_str as hstr
import tools.hfkt_tvar as htvar

class KontoCsvRead:
    '''
    obj                        = KontoCsvRead(trennzeichen_tval,buchtype_zuordnung_tlist,header_zuordnung_tlist,header_type_zuordnung_tlist)
    (okay,errtext,ttable,flag_proof_wert) = obj.read_data(filename,names_possible_merge_list)
                                                 flag_proof_wert = True  Überprüfen den Wert zu buchttype
                                                                 = False Überprüfe buchttype zu wert
    
    Interne Funktionen
    csv_lliste                  = self.fix_length_for_missing_items(csv_lliste)
    (start_irow, csv_icol_list,name_csv_list,name_list,type_list)
                                = self.search_header_line(csv_lliste)
    (flag_found, csv_icol_list,name_csv_list,name_list,type_list)
                                = self.search_header_line_csv_list(csv_liste)
    (flag, name, name_csv,type) = self.search_header_name(item)
    new_data_matrix             = self.get_data_from_csv_lliste(csv_lliste,index_start, csv_icol_list)
    (name_list,merged_data_matrix, type_set_list)
                                = self.proof_merge_double_items(new_data_matrix,name_list,type_list,names_possible_merge_list)
    '''
    def __init__(self,trennzeichen_tval,wert_pruefung_tval,csv_datei_pfad_tval,buchtype_zuordnung_tlist,header_zuordnung_tlist,header_type_zuordnung_tlist):
        
        self.status = hdef.OK
        self.errtext = ""
        self.trennzeichen = htvar.get_val(trennzeichen_tval,"str")
        self.wert_pruefung = htvar.get_val(wert_pruefung_tval,"str")
        if self.wert_pruefung == "wert":
            self.flag_proof_wert = False
        else:
            self.flag_proof_wert = True
        # end if
        self.csv_datei_pfad = htvar.get_val(csv_datei_pfad_tval,"str")
        self.buchtype_zuordnung_tlist  = buchtype_zuordnung_tlist
        self.header_zuordnung_tlist = header_zuordnung_tlist
        self.header_type_zuordnung_tlist = header_type_zuordnung_tlist
        self.filename           = ""
    # end def
    def get_csv_datei_pfad(self):
        return self.csv_datei_pfad
    # end def
    def read_data(self,filename: str):
        '''
        
        :param filename: Filename mit csv-Daten
        :return: (okay,errtext,ttable) = self.read_data(filename,names_possible_merge_list)
        '''
        self.status = hdef.OK
        self.filename = filename
        
        # read csv-File
        # ==============
        csv_lliste = hio.read_csv_file(file_name=filename, delim=self.trennzeichen)
        
        if (len(csv_lliste) == 0):
            self.errtext = f"Fehler in read_ing_csv read_csv_file()  filename = {self.filename}"
            self.status = hdef.NOT_OKAY
            return (self.status,self.errtext,None,None)
        # end if
        
        csv_lliste = self.fix_length_for_missing_items(csv_lliste)
        
        # Suche in csv-Daten header line
        # ==============================
        (index_start, csv_icol_list,name_csv_list,name_list,type_list) = self.search_header_line(csv_lliste)
        if self.status != hdef.OKAY:
            return (self.status,self.errtext,None,None)
        # endif
        
        # Lese Daten aus  csv-liste aus
        new_data_matrix = self.get_data_from_csv_lliste(csv_lliste, index_start, csv_icol_list)
        if self.status != hdef.OKAY:
            return (self.status,self.errtext,None,None)
        # end if
        
        
        # merge incase of double e.g. comments
        (merged_data_matrix,name_list, type_list) = self.proof_merge_double_items(new_data_matrix,name_list,type_list)

        # make type conversion buchtype
        (merged_data_matrix,name_list, type_list) = self.make_buchtype_conversion(merged_data_matrix,name_list,type_list)
        if self.status != hdef.OKAY:
            return (self.status,self.errtext,None,None)
        # end if
        
        # proof each line if readable
        (merged_data_matrix, name_list, type_list) = self.proof_each_data_set(merged_data_matrix, name_list,
                                                                                   type_list)
        if self.status != hdef.OKAY:
            return (self.status,self.errtext,None,None)
        # end if

        ttable = htvar.build_table(name_list,merged_data_matrix,type_list)
        
        return (self.status,self.errtext,ttable,self.flag_proof_wert)
    # end def
    
    # ----------------------------------------------------------------------------------------
    # Internen Funktionen
    # ----------------------------------------------------------------------------------------
    def fix_length_for_missing_items(self,csv_lliste):
        '''
        
        :param csv_lliste:
        :return: csv_lliste = self.fix_length_for_missing_items(csv_lliste)
        '''
        n = 0
        for csv_liste in csv_lliste:
            n = max(n,len(csv_liste))
        # end for
        
        for i,csv_liste in enumerate(csv_lliste):
            flag = False
            for j in range(len(csv_liste),n):
                csv_liste.append("")
                flag = True
            # end for
            # cutoff empty space
            for j in range(n):
                t = hstr.elim_ae_liste(csv_liste[j], [" ","\t"])
                if t != csv_liste[j]:
                    flag = True
                    csv_liste[j] = t
                # end if
            # end for
            if flag:
                csv_lliste[i] = csv_liste
            # end if
        # end for

        return csv_lliste
    def search_header_line(self, csv_lliste):
        '''

        :param csv_lliste:
        :return: (start_irow, csv_icol_list,name_csv_list,name_list,type_list) = self.search_header_line(csv_lliste)
        :out start_irow: start line to read data
        :out csv_icol_list: list of ordered index in csv-data according to name-list
        :out name_csv_list: list of header names in csv-data according to csv_icol_list
        :out name_list: list of header names for konto-data according to csv_icol_list
        '''
        
        if self.header_zuordnung_tlist.n == 0:
            raise Exception(
                f"search_header_line: self.header_zuordnung_tlist is empty must be set during setup Parameter in KontoDataSetParameter() ")
        # end if
        
        for i, csv_liste in enumerate(csv_lliste):
            
            (flag_found,csv_icol_list,name_csv_list,name_list,type_list) = self.search_header_line_csv_list(csv_liste)
            
            if flag_found:
                start_irow = i + 1
                return (start_irow,csv_icol_list,name_csv_list,name_list,type_list)
            # end if
        # end for

        self.status = hdef.NOT_OKAY
        self.errtext = f"header Zeile nicht gefunden in csv_file: <{self.filename}>"
        
        return (None,[],[],[],[])
    # end def
    def search_header_line_csv_list(self,csv_liste):
        '''
        
        :param csv_liste:
        :return: (flag_found, csv_icol_list,name_csv_list,name_list,type_list) = self.search_header_line_csv_list(csv_liste)
        '''
        
        flag_found,csv_icol_list, name_csv_list, name_list,type_list = False,[],[],[],[]
        
        n = self.header_zuordnung_tlist.n
        
        for index,item in enumerate(csv_liste):
            
            (flag,name,name_csv,type) = self.search_header_name(item)
            if flag:
                csv_icol_list.append(index)
                name_csv_list.append(name_csv)
                name_list.append(name)
                type_list.append(type)
            # end if
        # end for
        
        if len(csv_icol_list) >= n:
            flag_found = True
        # end if
        
        return (flag_found,csv_icol_list, name_csv_list, name_list,type_list)
    # end def
    def search_header_name(self,item):
        '''
        
        :param item:
        :return: (flag, name, name_csv,type) = self.search_header_name(item)
        '''
        
        for i in range(self.header_zuordnung_tlist.n):
            
            if (self.header_zuordnung_tlist.types[i] == "list_str") or (self.header_zuordnung_tlist.types[i] == "listStr"):
                for csv_name in self.header_zuordnung_tlist.vals[i]:
                    if csv_name == item:
                        return (True,self.header_zuordnung_tlist.names[i],csv_name,self.header_type_zuordnung_tlist.vals[i])
                    # end if
                # end ofr
            elif self.header_zuordnung_tlist.types[i] == "str":
                if self.header_zuordnung_tlist.vals[i] == item:
                    return (True, self.header_zuordnung_tlist.names[i],self.header_zuordnung_tlist.vals[i],self.header_type_zuordnung_tlist.vals[i])
                # end if
            else:
                raise Exception(f"search_header_name: self.header_zuordnung_tlist.types[{i}] = {self.header_zuordnung_tlist.types[i]} is not str nor list type = {self.header_zuordnung_tlist.types[i]}")
            # end if
        return (False,"","","")
    # end if
    # def search_header_line_find_name_in_list(csv_liste: list):
    #     '''
    #     name is a string or a list of strings
    #     index is position in csv_liste
    #     if found index is an integer
    #     if not found index is None
    #
    #     :param name:
    #     :param csv_liste:
    #     :return: (index,name_csv,name) = self.search_header_line_find_name_in_list(csv_liste)
    #     '''
    #     if isinstance(name,str):
    #         name_list = [name]
    #     elif isinstance(name,list):
    #         name_list = name
    #     else:
    #         raise Exception(f"search_header_line_find_name_in_list: name is not str nor list name = {name}")
    #     # end if
    #
    #     for namename in name_list:
    #         for index,item in enumerate(csv_liste):
    #             tt = hstr.elim_ae(item," ")
    #             if( namename == tt):
    #                 return (index,namename
    #         # if namename in csv_liste:
    #         #     return csv_liste.index(namename)
    #         # end if
    #     # end for
    #     return None
    # # end def
    # def search_header_line_get_missing_item(self,header_found_liste):
    #     '''
    #     searches for missing item in CSV_DATA_NAME_LIST
    #     :param header_found_liste:
    #     :return: item = self.search_header_line_get_missing_item(header_found_liste)
    #     '''
    #     item = "not found!!"
    #     for i in range(self.header_zuordnung_tlist.n):
    #         index = self.search_header_line_find_name_in_list(self.header_zuordnung_tlist.vals[i] ,header_found_liste)
    #         if not isinstance(index,int):
    #             if isinstance(self.header_zuordnung_tlist.vals[i],str):
    #                 item = self.header_zuordnung_tlist.vals[i]
    #                 break
    #             elif isinstance(self.header_zuordnung_tlist.vals[i],list):
    #                 item = ""
    #                 for name in self.header_zuordnung_tlist.vals[i]:
    #                     item += name + "/"
    #                 # end for
    #                 break
    #             # end if
    #         # end if
    #     # end for
    #     return item
    # # end def
    def get_data_from_csv_lliste(self, csv_lliste, index_start, csv_icol_list):
        '''

        :param csv_lliste:
        :param index_start:
        :param csv_icol_list:
        :return: new_data_matrix = self.get_data_from_csv_lliste(csv_lliste,index_start, csv_icol_list)
        :out new_data_matrix: matrix with sorted data-inputs from csv-file in order of self.CSV_DATA_NAME_LIST
        '''
        new_data_matrix = []
        n = len(csv_lliste)
        for iline in range(index_start, n):
            csv_data_liste = csv_lliste[iline]
            
            nitems = len(csv_data_liste)
            new_data_list = []
            
            for i_csv in csv_icol_list:
                
                if len(csv_data_liste) < (i_csv+1):
                    print("halt")
                    raise Exception(
                        f"halt  len(csv_data_liste): {len(csv_data_liste)} < (i_csv+1): {(i_csv+1)}")
                new_data_list.append(csv_data_liste[i_csv])
            # end for
            new_data_matrix.append(new_data_list)
        # end for
        
        return new_data_matrix
    # end def
    def proof_merge_double_items(self,new_data_matrix,name_list,type_list):
        '''
        
        :param new_data_matrix:
        :return: (name_list,merged_data_matrix, type_set_list) = self.proof_merge_double_items(new_data_matrix,name_list,type_list)
        '''
        
        name_set = set(name_list)
        if len(name_set) == len(name_list):
            return (new_data_matrix,name_list,type_list)
        else:
            
            merged_name_list = []
            merged_type_list = []
            index_list = []
            for i,name in enumerate(name_list):
                if name in merged_name_list:
                    index = merged_name_list.index(name)
                else:
                    index = len(merged_name_list)
                    merged_name_list.append(name)
                    merged_type_list.append(type_list[i])
                # end if
                
                index_list.append(index)
            # end for
            
            merged_data_matrix = []
            for data_set in new_data_matrix:
        
                merged_data_set = [None for i in range(len(name_set))]
                
                for i,name in enumerate(name_list):
                    
                    index = index_list[i]
                    type  = type_list[i]
                    
                    if merged_data_set[index] == None:
                        merged_data_set[index] = data_set[i]
                    else:
                        if type == "str":
                            merged_data_set[index] = merged_data_set[index] + " " + data_set[i]
                        # end if
                    # end if
                # end for
                merged_data_matrix.append(merged_data_set)
            # end for
        # end if
        return (merged_data_matrix,merged_name_list,merged_type_list)
    # end def
    def make_buchtype_conversion(self,new_data_matrix,name_list,type_list):
        '''
        
        :param new_data_matrix:
        :param name_list:
        :return: (new_data_matrix,name_list,type_list) = self.make_buchtype_conversion(new_data_matrix, name_list)
        '''
    
        if "buchtype" in name_list:
            icol = name_list.index("buchtype")
        else:
            raise Exception(f" Name des buchtypes = \"{"buchtype"}\" nicht in name_list = {name_list}")
        # end if
    
        for irow,data_set in enumerate(new_data_matrix):
            
            val = data_set[icol]
            
            index = htvar.find_value_in_list_list(self.buchtype_zuordnung_tlist,val)
            
            if index == None:
                self.status = hdef.NOT_OKAY
                self.errtext = f"make_buchtype_conversion: der buchtype: {val} in irow: {irow} kann nicht in buchtype_zuordnung_tlist: {self.buchtype_zuordnung_tlist} gefunden werden !!"
                return (None,None,None)
            # end if
            
            data_set[icol] = self.buchtype_zuordnung_tlist.names[index]
            
            new_data_matrix[irow] = data_set
        # end for
        
        type_list[icol] = self.buchtype_zuordnung_tlist.names
        
        return (new_data_matrix,name_list,type_list)
    # end def
    def proof_each_data_set(self,data_matrix,name_list,type_list):
        '''
        
        :param new_data_matrix:
        :param name_list:
        :return: (new_data_matrix,name_list,type_list) = self.proof_each_data_set(new_data_matrix, name_list)
        '''
        
        new_data_matrix = []
        for data_set in data_matrix:
            
            (status, errtext) = htvar.proof_list(name_list, data_set, type_list)
            
            if status != hdef.OKAY:
                
                self.status = hdef.NOT_OKAY
                self.errtext = f"{errtext}\n{name_list =}\n{data_set =}\n{type_list =}"
                return (None,None,None)
            # end if
            new_data_matrix.append(data_set)
        # end for
        
        return (new_data_matrix,name_list,type_list)
    # end def