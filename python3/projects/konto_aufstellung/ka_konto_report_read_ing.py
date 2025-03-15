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


def read(csv_lliste,header_lliste,filename):
    '''
    
    :param csv_lliste:
    :param header_lliste
    :param filename:
    :return: (data_lliste,status,errtext) = read(csv_lliste,header_lliste,filename)
    '''
    errtext = ""
    status  = hdef.OKAY
    data_lliste    = []
    
    
    (okay, errtext, linestartindex, index_liste) = search_header(csv_lliste, header_lliste, filename)
    
    # Suche header-Zeile
    #-----------------------------
    
    
    index = hstr.such(text, keyword, "vs")
    
    # Fehler
    if( index < 0 ):
        errtext = f"In file {filename} konnte nicht keyword {keyword} gefunden werden"
        status = hdef.NOT_OKAY
        return (data_lliste, status, errtext)
    # endif
    
    # Lösche alles bis key word
    text = hstr.delete_str_by_index(text, 0, index + len(keyword) - 1)
    
    # Erstelle Zeilen Texte
    liste = hstr.split_text(text,'\n',flagmulti=1) # split_text(t,trenn,flagmulti=0)
    
    # Suche keyword Cashkonto für Anfangswert
    # Sollte sein: Cashkonto 0,00 € 79.335,90 € 60.316,34 € 19.019,56 €
    #------------------------------------------------------------------------------
    keyword = "Cashkonto"
    ifound = -1
    for index,zeile in enumerate(liste):
        i0 = hstr.such(zeile, keyword, "vs")
        if( i0 >= 0 ): # gefunden
            ifound = index
            break
        # endif
    # endfor
    if( ifound < 0 ):
        errtext = f"In file {filename} konnte nicht keyword {keyword} gefunden werden"
        status = hdef.NOT_OKAY
        return (data, status, errtext)
    # end if
    
    (status,errtext,wert0) = read_wert_start_end(liste[ifound])
    
    if( status != hdef.OKAY ):
        errtext = f"In file {filename} und keyword {keyword} : {errtext}"
        return (data, status, errtext)
    # end if
    
    # Suche keyword UMSATZÜBERSICHT für Einzel Buchungen in der übernächsten Zeile
    # Das sollte sein: z,B. 11 Dez. 2024 Überweisung Incoming transfer from Thomas Paul Berthold 100,00 € 100,00 €
    #------------------------------------------------------------------------------
    keyword = "UMSATZÜBERSICHT"
    ifound = -1
    for index,zeile in enumerate(liste):
        i0 = hstr.such(zeile, keyword, "vs")
        if( i0 >= 0 ): # gefunden
            ifound = index
            break
        # endif
    # endfor
    if( ifound < 0 ):
        errtext = f"In file {filename} konnte nicht keyword {keyword} gefunden werden"
        status = hdef.NOT_OKAY
        return (data, status, errtext)
    # end if
    
    # übernächste Zeile:
    ifound += 2
    
    for index in range(ifound,len(liste)):
        
        if( is_line_w_number(liste[index]) ):
            ####
            print(liste[index])
        else:
            break
        # endif
    #endfor

    return (data,status,errtext)
    
#enddef
def search_header(csv_lliste,header_lliste,filename):
    '''
    
    :param csv_lliste:
    :param header_lliste:
    :return: (okay,errtext,linestartindex,index_liste) =  search_header(csv_lliste,header_lliste,filename):
    '''
    nheader = len(header_lliste)
    notfound   = True
    header_found_liste = []
    for i,liste in enumerate(csv_lliste):
        index_liste = []
        for j,hliste in enumerate(header_lliste):
            
            if hliste[0] in liste:
                index_liste.append(j)
                header_found_liste.append(hliste[0])
            # end if
        # end for
        if( len(index_liste) == nheader ):
            index = i
            notfound = False
            break
        # end if
    # end fo
    
    if( notfound ):
        okay = hdef.NOT_OKAY
        item = ""
        for hliste in header_lliste:
            if hliste[0] not in header_found_liste:
                item = hliste[0]
                break
            # end if
        # end for
        errtext = f"header item: {item} not found in csv_file: {filename}"
        start_index = 0
        index_liste = []
    else:
        okay = hdef.OKAY
        errtext = ""
        start_index = index + 1
    # end if
    return (okay,errtext,start_index,index_liste)