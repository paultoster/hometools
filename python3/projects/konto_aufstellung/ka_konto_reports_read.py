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
# import hfkt_log as hlog
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
        
        (index,choice) = ka_gui.auswahl_konto(rd)
        
        if index < 0:
            return status
        elif choice in rd.ini.konto_names:
            
            rd.log.write(f"konto  \"{choice}\" ausgewählt")
            break
        else:
            status = hdef.NOT_OKAY
            errtext = f"Konto Auswahl: {choice} nicht bekannt"
            rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
            return status
        # endif
    # endwhile
    
    # Konto data in ini
    ddict = rd.data[choice].ddict
    
    # csv lesen
    if( ddict[rd.par.AUSZUGS_TYP_NAME] == 'ing_csv'):
        
        # csv-Datei auswählen
        filename = sgui.abfrage_file(file_types="*.csv",
                                     comment=f"Wähle ein report von ING-DiBa für den Kontoumsatz von Konto: {choice}",
                                     start_dir=os.getcwd())
        
        if (len(filename) == 0):  # Abbruch
            return status
        # endif
        
        (status, ddict) = ka_konto_report_read_ing.read_csv(rd, ddict, filename)
        
        if status != hdef.OKAY:  # Abbruch
            return status
        # write back modified ddict
        rd.data[choice].ddict = ddict
        
    else:
        errtext = f"Der Auszugstype von [{choice}].{rd.ini.AUSZUGS_TYP_NAME} = {ddict[rd.ini.AUSZUGS_TYP_NAME]} stimmt nicht"
        rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        status  = hdef.NOT_OKAY
    #endif
        
    return status
# enddef

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
