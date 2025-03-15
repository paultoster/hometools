#
# reports einlesen
#
# Ing-Bank  ing_bank_giro  =>  type ing_csv
#
import os
import sys

# import pymupdf
import PyPDF2

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

# Hilfsfunktionen
import hfkt_def as hdef
import hfkt_io as hio
import hfkt_log as hlog
import sgui

import ka_gui
import ka_konto_report_read_ing

def report_einlesen(rd):
    """

    :param rd:
    :return: status
    """
    
    status = hdef.OKAY
    errtext = ""
    
    # Kontoauswählen
    runflag = True
    
    while (runflag):
        
        choice = konto_gui.auswahl_konto(rd)
        
        if (choice == rd.ini.ENDE_RETURN_TXT):
            runflag = False
        elif (choice in rd.ini.konto_names):
            
            rd.log.write(f"konto  \"{choice}\" ausgewählt")
            break
        else:
            errtext = f"Auswahl: {choice} nicht bekannt"
            rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        # endif
    # endwhile
    
    # Konto data in ini
    d = rd.ini.konto_data[choice]
    
    # pdf lesen
    if( d[rd.ini.AUSZUGS_TYP_NAME] == 'ing_csv'):
        
        status = read_ing_csv(rd,d)
        
    else:
        errtext = f"Der Auszugstype von [{choice}].{rd.ini.AUSZUGS_TYP_NAME} = {d[rd.ini.AUSZUGS_TYP_NAME]} stimmt nicht"
        rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        status  = hdef.NOT_OKAY
    #endif
        
    return status
# enddef

#--------------------------------------------------------------------------------
# csv von Ing-Bank lesen
#--------------------------------------------------------------------------------
def read_ing_csv(rd,d):
    """
    
    :param rd:
    :param d:
    :return: status
    """
    status = hdef.OKAY
    # proof header values  KONTO_ITEM_LIST: List[str] = ("buchdatum","wertdatum", "wer", "comment", "wert")
    header_lliste = [[rd.par.HEADER_BUCHDATUM, rd.par.KONTO_ITEM_LIST[0]]
                   ,[rd.par.HEADER_WERTDATUM, rd.par.KONTO_ITEM_LIST[1]]
                   ,[rd.par.HEADER_WER, rd.par.KONTO_ITEM_LIST[2]]
                   ,[rd.par.HEADER_COMMENT, rd.par.KONTO_ITEM_LIST[3]]
                   ,[rd.par.HEADER_WERT, rd.par.KONTO_ITEM_LIST[4]]
                   ]
    (status, errtext,header_lliste) = get_csv_header_list_names(d, header_lliste )
    if( status == hdef.NOT_OKAY):
        rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        status = hdef.NOT_OKAY
        return status
    #end if
    
    # csv-Datei auswählen
    filename = sgui.abfrage_file(file_types="*.csv",comment="Wähle ein report von traderepublic als pdf-File aus",start_dir=os.getcwd())
    
    if( len(filename) == 0 ): # Abbruch
        return status
    #endif
    
    
    csv_lliste = hio.read_csv_file(file_name=filename,delim=";")
    
    if( len(csv_lliste) == 0 ):
        rd.log.write_err(f"Fehler in read_ing_csv read_csv_file()  filename = {filename}", screen=rd.par.LOG_SCREEN_OUT)
        status = hdef.NOT_OKAY
        return status
    
    (data_lliste,status,errtext) = ka_konto_report_read_ing.read(csv_lliste,header_lliste,filename)
    
    if( status != hdef.OKAY ):
        rd.log.write_err(f"Fehler in ka_konto_report_read_ing.read()  errtext = {errtext}", screen=rd.par.LOG_SCREEN_OUT)
        status = hdef.NOT_OKAY
    # endif
    return status
# end def
def get_csv_header_list_names(d, header_lliste):
    '''
    writes header name for specifiv csv file into list
    
    header_lliste = [[rd.par.HEADER_BUCHDATUM, rd.par.KONTO_ITEM_LIST[0]]
                   ,[rd.par.HEADER_WERTDATUM, rd.par.KONTO_ITEM_LIST[1]]
                   ,[rd.par.HEADER_WER, rd.par.KONTO_ITEM_LIST[2]]
                   ,[rd.par.HEADER_COMMENT, rd.par.KONTO_ITEM_LIST[3]]
                   ,[rd.par.HEADER_WERT, rd.par.KONTO_ITEM_LIST[4]]
                   ]
   
    :param d:
    :param keyname:
    :return: (status,errtext,header_liste) =get_csv_header_list_names(d,header_liste)
    '''
    
    for i,list in enumerate(header_lliste):
        keyname = list[0]
        if keyname not in d.keys() :
            errtext = f"Fehler read_ing_csv  keyname: {keyname} of {d.name} is not in ini-File"
            status = hdef.NOT_OKAY
        elif len(d[keyname]) == 0 :
            errtext = f"Fehler read_ing_csv  keyname: {keyname} of {d.name} is not in ini-File"
            status = hdef.NOT_OKAY
        else:
            errtext = ""
            status  = hdef.OKAY
            header_lliste[i][0] = d[keyname]
        # end if
    # end for
    
    return (status,errtext,header_lliste)
# end def

# with open("beispieltext.txt", "w", encoding="utf-8") as file:
#     file.write(f"{'start----------------'}\n")
#     doc = pymupdf.open(filename)  # open a document
#     for page in doc:  # iterate the document pages
#         text = page.get_text()  # get plain text encoded as UTF-8
#         print(text)
#         file.write(f"{'Seite----------------'}\n")
#         file.write(f"{text}\n")
#     #endfor
#     doc.close()
#     file.write(f"{'Ende----------------'}\n")
# #endwith

# with open("beispieltext_PyPDF2.txt", "w", encoding="utf-8") as file:
#     file.write(f"{'start----------------'}\n")
#     with open(filename, "rb") as f:
#         reader = PyPDF2.PdfReader(f)
#
#         # n = len(reader.pages)
#         for page in reader.pages:
#             text = page.extract_text()
#             print(text)
#             file.write(f"{'Seite----------------'}\n")
#             file.write(f"{text}\n")

#    text = ""
#     with open(filename, "rb") as f:
#         reader = PyPDF2.PdfReader(f)
#
#         # n = len(reader.pages)
#         for page in reader.pages:
#             text = text + page.extract_text()
#     # enddef
