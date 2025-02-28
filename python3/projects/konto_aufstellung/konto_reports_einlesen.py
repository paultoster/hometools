#
# reports einlesen
#
# TradeRepublic   =>  type tr_pdf
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
import hfkt_log as hlog
import sgui

import konto_gui
import konto_report_tr

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
            rd.log.write_err(errtext, screen=rd.log.GUI_SCREEN)
        # endif
    # endwhile
    
    # Konto data in ini
    d = rd.ini.konto_data[choice]
    
    # pdf lesen
    if( d[rd.ini.AUSZUGS_TYP_TXT] == 'tr_pdf'):
        
        status = read_tr_pdf(rd,d)
        
    else:
        errtext = f"Der Auszugstype von [{choice}].{rd.ini.AUSZUGS_TYP_TXT} = {d[rd.ini.AUSZUGS_TYP_TXT]} stimmt nicht"
        rd.log.write_err(errtext, screen=rd.log.GUI_SCREEN)
        status  = hdef.NOT_OKAY
    #endif
        
    return status
# enddef

#--------------------------------------------------------------------------------
# pdf lesen
#--------------------------------------------------------------------------------
def read_tr_pdf(rd,d):
    """
    
    :param rd:
    :param d:
    :return: status
    """
    status = hdef.OKAY
    
    # pdf-Datei auswählen
    filename = sgui.abfrage_file(file_types="*.pdf",comment="Wähle ein report von traderepublic als pdf-File aus",start_dir=os.getcwd())
    
    if( len(filename) == 0 ): # Abbruch
        return status
    #endif
    
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
    
    text = ""
    with open(filename, "rb") as f:
        reader = PyPDF2.PdfReader(f)
        
        # n = len(reader.pages)
        for page in reader.pages:
            text = text + page.extract_text()
    # enddef
    
    (data,status,errtext) = konto_report_tr.read(text,filename)
    
    if( status != hdef.OKAY ):
        rd.log.write_err(f"Fehler in konto_report_tr.read()  errtext = {errtext}", screen=rd.log.GUI_SCREEN)
        status = hdef.NOT_OKAY
    # endif
    return status


