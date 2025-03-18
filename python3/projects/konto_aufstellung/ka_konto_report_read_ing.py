#
# report Ing-csv-Daten auslesen
#
#    =>  type und_csv
#
import os
import sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

# Hilfsfunktionen
import hfkt_def as hdef
import hfkt_str as hstr
import hfkt_type as htype
import hfkt_io as hio


def read_csv(rd,d,filename):
    '''
    
    :param csv_lliste:
    :param header_lliste
    :param filename:
    :return: (status,data_lliste) = read(rd,d,filename)
    '''
    status  = hdef.OKAY
    data_lliste    = []
    
    # read csv-File
    #==============
    csv_lliste = hio.read_csv_file(file_name=filename, delim=";")
    
    if (len(csv_lliste) == 0):
        rd.log.write_err(f"Fehler in read_ing_csv read_csv_file()  filename = {filename}", screen=rd.par.LOG_SCREEN_OUT)
        status = hdef.NOT_OKAY
        return (status,data_lliste)
    # end if
    
    # build header_liste from ini-File
    header_liste = []
    for head_name in rd.par.INI_KONTO_HEADER_NAME_LIST:
        if( head_name in d.keys() ):
            header_liste.append(d[head_name])
        else:
            rd.log.write_err(f"Fehler in building hear_liste header name: {head_name} not found in ini-File for konto  {d['name']} ",
                             screen=rd.par.LOG_SCREEN_OUT)
            status = hdef.NOT_OKAY
            return (status, data_lliste)
        # end if
    # end for
    
    # Suche header-Zeile
    #-----------------------------
    (okay, errtext, linestartindex, index_liste) = search_header(csv_lliste, header_liste , filename)

    if okay != hdef.OKAY:
        rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        status = hdef.NOT_OKAY
        return (status, data_lliste)
    # end if

    # get data mit linestartindex, index_liste
    #-----------------------------
    (okay, errtext, data_lliste) = get_data(csv_lliste,linestartindex, index_liste)

    # Fehler
    if okay != hdef.OKAY:
        rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        status = hdef.NOT_OKAY
        return (status, data_lliste)
    # end if
    

    return (status,data_lliste)
    
#enddef
def search_header(csv_lliste,header_liste,filename):
    '''
    
    :param csv_lliste:
    :param header_liste:
    :return: (okay,errtext,linestartindex,index_liste) =  search_header(csv_lliste,header_lliste,filename):
    '''
    nheader = len(header_liste)
    notfound   = True
    header_found_liste = []
    start_index = 0
    index_liste = []
    for i,liste in enumerate(csv_lliste):
        
        # for each new line in csv_lliste reset index_liste
        index_liste = []
        
        # search header_liste in csv_lliste[i] (one line)
        for j,head_name in enumerate(header_liste):
            
            if head_name in liste:
                index_liste.append(j)
                header_found_liste.append(head_name)
            # end if
        # end for
        
        # if index_liste is full stop for-loop and build start_index (next line)
        if len(index_liste) == nheader:
            start_index = i+1
            notfound = False
            break
        # end if
    # end fo
    
    if notfound:
        okay = hdef.NOT_OKAY
        item = ""
        for head_name in header_liste:
            if head_name not in header_found_liste:
                item = head_name
                break
            # end if
        # end for
        errtext = f"header item: {item} not found in csv_file: {filename}"
        start_index = 0
        index_liste = []
    else:
        okay = hdef.OKAY
        errtext = ""
        # start_index = start_index
        # index_liste = index_liste
    # end if
    return (okay,errtext,start_index,index_liste)
# end def
def get_data(csv_lliste,linestartindex, index_liste):
    '''
    
    :param csv_lliste:
    :param linestartindex:
    :param index_liste:
    :return: (okay, errtext, data_lliste) = get_data(csv_lliste,linestartindex, index_liste)
    '''
    okay = hdef.OKAY
    errtext = ""
    data_lliste = []
    n = len(csv_lliste)
    for i in range(linestartindex,n):
        csv_data = csv_lliste[i]
        nline    = len(csv_data)
        data_liste = []
        for j in index_liste:
            if j < nline:
                data_liste.append(csv_data[j])
            else:
                data_liste.append("")
            # end if
        # end for
        data_lliste.append(data_liste)
    # end for
    
    return (okay, errtext, data_lliste)
# end def