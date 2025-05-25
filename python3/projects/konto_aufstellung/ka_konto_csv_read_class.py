import os, sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif


import hfkt_def as hdef
import hfkt_io as hio

class KontoCsvRead:
    def __init__(self):
        
        self.status = hdef.OK
        self.errtext = ""
        self.CSV_TRENN_ZEICHEN = ";"
        self.CSV_DATA_NAME_DICT  = {}
        self.CSV_DATA_IDENT_LIST = []
        self.CSV_DATA_TYPE_LIST  = []
        self.filename           = ""
    # end def
    def set_csv_trennzeichen(self, wert_trennzeichen):
        self.CSV_TRENN_ZEICHEN = wert_trennzeichen
    # end def
    def set_csv_header_name(self,dat_set_index: int,csv_name: str,csv_type: str | list):
        self.CSV_DATA_NAME_DICT[dat_set_index] = csv_name
        self.CSV_DATA_IDENT_LIST.append(dat_set_index)
        self.CSV_DATA_TYPE_LIST.append(csv_type)
    # end def
    
    def read_data(self,filename: str):
        '''
        
        :param filename: Filename mit csv-Daten
        :return: (okay,errtext,data_matrix,identlist,typelist) = self.read_data(filename)
        '''
        self.status = hdef.OK
        self.filename = filename
        
        # read csv-File
        # ==============
        csv_lliste = hio.read_csv_file(file_name=filename, delim=self.CSV_TRENN_ZEICHEN)
        
        if (len(csv_lliste) == 0):
            self.errtext = f"Fehler in read_ing_csv read_csv_file()  filename = {self.filename}"
            self.status = hdef.NOT_OKAY
            return (self.status,self.errtext,[],[],[])
        # end if
        
        # Suche in csv-Daten header line
        # ==============================
        (index_start, index_dict) = self.search_header_line(csv_lliste)
        if self.status != hdef.OKAY:
            return (self.status,self.errtext,[],[],[])
        # endif
        
        # Lese Daten aus  csv-liste aus
        new_data_matrix = self.get_data_from_csv_lliste(csv_lliste, index_start, index_dict)
        if self.status != hdef.OKAY:
            return (self.status,self.errtext,[],[],[])
        
        return (self.status,self.errtext,new_data_matrix,self.CSV_DATA_IDENT_LIST,self.CSV_DATA_TYPE_LIST)
    # end def
    
    # ----------------------------------------------------------------------------------------
    # Internen Funktionen
    # ----------------------------------------------------------------------------------------
    def search_header_line(self, csv_lliste):
        '''

        :param csv_lliste:
        :return: (start_index, index_dict) = self.search_header_line(csv_lliste)
        :out start_index: start line to read data
        :out index_dict: dictionary with key=index of konto_data referring to csv_headername, value: index of column in csv_list
        '''
        
        nheader = len(self.CSV_DATA_NAME_DICT.keys())
        if nheader == 0:
            raise Exception(
                f"search_header_line: self.KONTO_DATA_HEADER_CSV_NAME_DICT is empty must be set during setup Parameter in KontoDataSetParameter() ")
        # end if
        
        notfound = True
        
        start_index = 0
        header_found_liste = []
        
        for i, csv_liste in enumerate(csv_lliste):
            
            # for each new line in csv_lliste reset index_liste
            index_dict = {}
            
            if i == 13:
                print("halt")
            
            for j, key in enumerate(self.CSV_DATA_NAME_DICT.keys()):
                
                index = self.search_header_line_find_name_in_list(self.CSV_DATA_NAME_DICT[key],csv_liste)
                if isinstance(index,int):
                    if (j == 0):
                        header_found_liste = []
                    # end if
                    index_dict[key] = index
                    header_found_liste.append(self.CSV_DATA_NAME_DICT[key])
                # end if
            # end for
            if len(index_dict.keys()) == nheader:
                start_index = i + 1
                notfound = False
                break
            # end if
        # end for
        else:
            index_dict = {}  # liste mit position in csv-datei Spalte und mit index in konto_dataset
        # end for
        if notfound:
            self.status = hdef.NOT_OKAY
            item = self.search_header_line_get_missing_item(header_found_liste)
            self.errtext = f"header item: <{item}> not found in csv_file: <{self.filename}>"
        # end if
        return (start_index, index_dict)
    # end def
    def search_header_line_find_name_in_list(self,name: str|list,csv_liste: list):
        '''
        name is a string or a list of strings
        index is position in csv_liste
        if found index is an integer
        if not found index is None
        
        :param name:
        :param csv_liste:
        :return: index = self.search_header_line_find_name_in_list(name,csv_liste)
        '''
        if isinstance(name,str):
            name_list = [name]
        elif isinstance(name,list):
            name_list = name
        else:
            raise Exception(f"search_header_line_find_name_in_list: name is not str nor list name = {name}")
        # end if
        for namename in name_list:
            if namename in csv_liste:
                return csv_liste.index(namename)
            # end if
        # end for
        return None
    # end def
    def search_header_line_get_missing_item(self,header_found_liste):
        '''
        searches for missing item in CSV_DATA_NAME_DICT
        :param header_found_liste:
        :return: item = self.search_header_line_get_missing_item(header_found_liste)
        '''
        item = "not found!!"
        for key in self.CSV_DATA_NAME_DICT.keys():
            index = self.search_header_line_find_name_in_list(self.CSV_DATA_NAME_DICT[key] ,header_found_liste)
            if not isinstance(index,int):
                if isinstance(self.CSV_DATA_NAME_DICT[key],str):
                    item = self.CSV_DATA_NAME_DICT[key]
                    break
                elif isinstance(self.CSV_DATA_NAME_DICT[key],list):
                    item = ""
                    for name in self.CSV_DATA_NAME_DICT[key]:
                        item += name + "/"
                    # end for
                    break;
                # end if
            # end if
        # end for
        return item
    # end def
    def get_data_from_csv_lliste(self, csv_lliste, index_start, index_dict):
        '''

        :param csv_lliste:
        :param index_start:
        :param index_dict:
        :return: new_data_matrix = self.get_data_from_csv_lliste(csv_lliste,index_start, index_dict)
        :out new_data_matrix: matrix with sorted data-inputs from csv-file in order of self.CSV_DATA_NAME_DICT
        '''
        new_data_matrix = []
        n = len(csv_lliste)
        for iline in range(index_start, n):
            csv_data_liste = csv_lliste[iline]
            
            nitems = len(csv_data_liste)
            new_data_list = []
            
            for konto_dat_set_index in self.CSV_DATA_NAME_DICT.keys():
                i_csv = index_dict[konto_dat_set_index]
                new_data_list.append(csv_data_liste[i_csv])
            # end for
            new_data_matrix.append(new_data_list)
        # end for
        
        return new_data_matrix
    # end def
