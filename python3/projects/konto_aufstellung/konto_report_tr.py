#
# report TradeRepublic auslesen
#
#    =>  type tr_pdf
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


def read(text,filename):
    errtext = ""
    status  = hdef.OKAY
    data    = []
    
    # Suche KONTOÜBERSICHT im Text
    #-----------------------------
    keyword = "KONTOÜBERSICHT"
    index = hstr.such(text, keyword, "vs")
    
    # Fehler
    if( index < 0 ):
        errtext = f"In file {filename} konnte nicht keyword {keyword} gefunden werden"
        status = hdef.NOT_OKAY
        return (data, status, errtext)
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
def read_wert_start_end(txt):
    '''
    Zerlegung von Cashkonto 0,00 € 79.335,90 € 60.316,34 € 19.019,56 €
    mit           PRODUKT ANFANGSSALDO ZAHLUNGSEINGANG ZAHLUNGSAUSGANG ENDSALDO
    
    :param txt:
    :return: (status,errtext,wert_start)
    '''
    status  = hdef.OKAY
    errtext = " "
    wert0   = 0.0
    liste = hstr.split_text(txt, ' ', flagmulti=1)
    
    n = len(liste)
    
    if( n < 5 ):
        errtext = f"txt=\"{txt}\" kann nicht in 5 Teile zerlegt werden"
        status = hdef.NOT_OKAY
        return (status,errtext,wert0)
    # endif
    
    wert = liste[1]
    wert = hstr.elim_ae_liste(wert,["€","\xa0"," "])

    (status, wert0) = htype.hfkt_type_proof_str_excel_float(wert)
    
    if( status != hdef.OKAY ):
        errtext = f"txt=\"{txt}\" kann für wert_start der value \"{wert}\" nicht in float gewandelt werden"
        status = hdef.NOT_OKAY
        return (status,errtext,wert0)
    # endif
    
    return (status, errtext, wert0)

# enddef
def is_line_w_number(txt):
    '''
    Prüft ob erster Wert bis eine Zahl ist (Datum)
    :param txt:
    :return: True/False
    '''
    liste = hstr.split_text(txt," ",flagmulti=1)
    if( len(liste) == 0 ):
        return False
    (okay, wert) = htype.hfkt_type_proof_int(liste[0])
    if( okay != hdef.OKAY):
        return False
    return True
# end def

# end def