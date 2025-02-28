# -*- coding: utf8 -*-
#
# 18.06.23 von hfkt.py
#############################
#Stringbearbeitung
##################
'''
 str = get_str_from_int(intval,intwidth) gibt string mit vorangestellten nullen aus

 index = such(text,muster,regel) Sucht muster im text return index or -1
 
 index = such_mit_liste(text,muster_liste,type) type = 'l' lower oder 'e' exakt
                                                return index or -1 => muster_liste[index]

 index_liste = such_alle(t,muster) Sucht nach Muster und erstellt Index-Liste, die leer sein kann

 index_liste = such_in_liste(liste,muster,regel) Suche nach dem string-Muster in der Liste nach der Regel
                                                 'e'  exakt in den items der liste
                                                 'n'  nicht exakt, d.h. muß enthalten sein, auch groß/klein
                                                 't'  nicht exakt vollständig, aber groß/klein
                                                 Output:
                                                 index_list liste(int)   Index Liste mit den Übereinstimmungen
                                                                         wenn keine liste ist leer []


 (num,type) = has_quots(text,quot0,quot1) num: anzahl quots, type = 0   geöffnet und geschlossen
                                                                  = +n  n-fach zuviel geöffnet(quot0)
                                                                  = -n  n-fach zuviel geschlossen(quot1)

 index_liste_2tuple = get_index_quot(text,quot0,quot1) Gibt Indexpaare in dem der Text gequotet ist

    Gibt Indexpaare (Tuples) in dem der Text gequotet ist z.B.

    text  = "abc {nest} efg  {plab}"
    #        0123456789012345678901
    quot0 = "{"
    quot1 = "}"

    a = get_index_quot(text,quot0,quot1)

    a ergibt [(5,9),(17,21)]

 get_index_quoted(text,quot0,quot1) das gleiche

 get_index_no_quot(text,quot0,quot1) Gibt Indexpaare in dem der Text nicht gequotet ist

 get_index_not_quoted(text,quot0,quot1) das gleiche

 get_string_quoted(text,quot0,quot1) Gibt Liste mit string in dem der gequotet Text steht

 get_string_not_quoted(text,quot0,quot1) Gibt Liste mit string in dem der nicht gequotet Text steht

 elim_a(text,muster) Eliminiert text am Anfang

 elim_e(text,muster) Eliminiert text am Ende

 elim_ae(text,muster) Eliminiert text am Anfang und Ende

 elim_a_liste(text,muster_liste) Eliminiert text am Anfang mit einer liste von mustern z.B. [" ","\t"]

 elim_e_liste(text,muster_liste) Eliminiert text am Ende mit einer liste von mustern z.B. [" ","\t"]

 textm = elim_ae_liste(text,muster_liste) Eliminiert text am Anfang und Ende mit einer liste von mustern z.B. [" ","\t"]

 textmod = elim_comment_not_quoted(text,comment_list,quot0,quot1) eliminiert Kommentar aus dem Text

 t = delete_str_by_index(txt,i0,i1)  löscht txt[i0:i1]
 
 split_text(t,trenn)   trennt t nach trenn return list
 split_text(t,trenn,flagmulti=1) Mehrfache trennzeichen werden ignoriert

 split_not_quoted(text,split,quot0,quot1,elim_leer) Trennt nicht gequoteten text mit split auf
                                                    elim_leer=0/1 eliminiert leere zelle (def 0)

 split_with_quot(text,quot0,quot1) Trennt text mit quots

 join_list(list,delim)                  fügt textlist mit delim zusammen

 slice(text,length) Zerlegt text in Stücke von l1-Länge

 change(text,muster_alt,muster_neu) Ersetzt in text alt gegen neu (einmal durch)

 change_max(text,muster_alt,muster_neu) Ersetzt in text alt gegen neu (solange geht)

 change_excel_value_str(text) Ersetzt excel Notation für Werte in strings z.B. 10.000,23 => 10000.23
 
 str_replace(text,textreplace,i0,l) löscht in text von position i0 l Zeichen und fügt textreplace ein

 def str_insert(text,textinsert,i0) insert at i0 textinsert

 str_elim(text,i0,l) löscht in text von position i0 l Zeichen

 (body,ext) = file_splitext(file_name) Trennt in Pfad, Bodyname und Extension (ohne .)

 (path,body,ext) = file_split(file_name) Trennt in Pfad, Bodyname und Extension (ohne .)

 search_file_extension(file)             Sucht Fileextension in string file und gibt ihn zurÃ¼ck

 (okay,new_file_name) = file_exchange_path(file_name,source_path,target_path) exchanges source_path with target_path if possible

 liste =string_to_num_list(string) zerlegt string in eine numerische Liste

 vergleiche_text(text1,text2) Vergleicht, Ausgabe in Anteil, text als ganzes

 vergleiche_worte(text1,text2) Vergleicht, Ausgabe in Anteil, dir Leerzeichen getrennt Worte, und jedes Wort dem anderen

 to_unicode(string)   converts byte-string into unicode utf8
 to_bytes(unicode)    converts unicode into byte-string
 text_to_write(text)  convert text to writable form
 is_letter(t)  ist text ein Buchstabe RÃ¼ckgabe Liste mit 1/0  "et23sf" => [1,1,0,0,1,1]
 is_letter_flag(t) wenn alles Literale sind dann True ansonsten False
 is_digit(t)  ist text ein Digit Rückgabe Liste mit 1/0  "et23sf" => [0,0,1,1,0,0]
 is_digit_flag(t) wenn alles Digits sind dann True ansonsten False
 merge_string_liste(liste)   merged die Liste mit strings in einen string
 convert_string_to_float(value)

'''

# commented out: doubledecode(s, as_unicode=True): decodiert in cp1252 (as_unicode=False) oder zurÃ¼ck in unicode (as_unicode=True)
# make_unicode(object) makes unicode, if not already (utf8)
# convert_to_unicode(value) converts to string if int, float into unicode
# to_unicode(string)   converts byte-string into unicode utf8
# to_bytes(unicode)    converts unicode into byte-string
# text_to_write(text)  convert text to writable form
# is_letter(t)  ist text ein Buchstabe RÃ¼ckgabe Liste mit 1/0  "et23sf" => [1,1,0,0,1,1]
# is_letter_flag(t) wenn alles Literale sind dann True ansonsten False
# is_digit(t)  ist text ein Digit Rückgabe Liste mit 1/0  "et23sf" => [0,0,1,1,0,0]
# is_digit_flag(t) wenn alles Digits sind dann True ansonsten False
# merge_string_liste(liste)   merged die Liste mit strings in einen string
# convert_string_to_float(value)
###################################################################################
# Listenbearbeitung
###################################################################################
# such_in_liste(liste,muster,regel='n') Suche nach dem string-Muster in der Liste nach der Regel
#                                       Input:
#                                       liste   list    mit strings zu durchsuchen
#                                       muster  string  muster nachdem gesucht wird
#                                       regel   string  Regel nach der gesucht wird:
#                                               e  exakt in den items der liste
#                                               n  nicht exakt, d.h. muß enthalten sein, auch groß/klein
#                                      Output:
#                                       index_list liste(int)   Index Liste mit den Übereinstimmungen
#                                                               wenn keine liste ist leer []
#
# reduce_double_items_in_liste(liste)  Reduziert doppelte Einträge in Liste
#                                      liste_r = reduce_double_items_in_liste(liste)
#
# string_is_in_liste(tt,liste)  True wenn tt vollständig in einem item der Liste
#                               False wenn nicht
# string_is_not_in_liste(tt,liste)

import string
import os
import math

KITCHEN_MODUL_AVAILABLE = False

OK = 1
NOT_OK = 0
QUOT = 1
NO_QUOT = 0
TCL_ALL_EVENTS = 0


#############################
# Stringbearbeitung
##################
def get_str_from_int(intval, intwidth):
    # -------------------------------------------------------
    """
    gibt string mit vorangestellten nullen aus
    """
    if (intval == 0):
        mzeichen = 0
        width = 1
        val = intval
    elif (intval < 0):
        mzeichen = 1
        width = int(math.floor(math.log10(-intval))) + 1
        val = -intval
    else:
        mzeichen = 0
        width = int(math.floor(math.log10(intval))) + 1
        val = intval
    
    if (mzeichen == 1):
        t = "-"
    else:
        t = ""
    
    n = int(math.floor(math.fabs(intwidth))) - width
    i = 0
    while ((n > 0) and (i < n)):
        t = t + "0"
        i += 1
    
    t = t + "%s" % val
    
    return t


# -------------------------------------------------------
def such(text, muster, regel="vs"):
    """
    Suche nach dem Muster in dem Text nach der Regel:

    Input:
    text    string  zu durchsuchender String
    muster  string  muster nachdem gesucht wird
    regel   string  Regel nach der gesucht wird:
                    vs  vorwaerts muster suchen
                    vn  vorwaerts suchen, wann muster nicht mehr
                        vorhanden ist
                    rs  rueckwrts muster suchen
                    rn  rueckwaerts suchen, wann muster nicht mehr
                        vorhanden ist

    Output:
    index   int     Index im String in der die Regel wahr geworden ist
                    oder -1 wenn die Regel nicht wahr geworden ist
    """
    lt = len(text)
    lm = len(muster)
    
    if (regel.find("v") > -1) or (regel.find("V") > -1):
        v_flag = 1
    else:
        v_flag = 0
    
    if (regel.find("n") > -1) or (regel.find("n") > -1):
        n_flag = 1
    else:
        n_flag = 0
    
    if v_flag == 1:  # vorwaerts
        
        if n_flag == 1:  # nicht mehr vorkommen
            
            ireturn = -1
            for i in range(0, lt, 1):
                
                if (text[i:i + lm].find(muster) == -1):
                    ireturn = i
                    break
                # endif
            # endof
            return ireturn
        
        else:  # soll vorkommen
            
            ireturn = text.find(muster)
            # print "ireturn = %i" % ireturn
            return ireturn
        # endif
    else:  # rueckwaerts
        
        if n_flag == 1:
            
            ireturn = -1
            #           print "lm=%i" % lm
            #           print "lt=%i" % lt
            for i in range(0, lt, 1):
                
                #               print "i=%i" % i
                i0 = text.rfind(muster, 0, lt - i)
                #               print "i0=%i" % i0
                #               print "lt-lm-i=%i" % (lt-lm-i)
                
                if i0 < lt - lm - i:
                    ireturn = lt - i - 1
                    break
            return ireturn
        
        else:
            
            ireturn = text.rfind(muster)
            return ireturn

# -------------------------------------------------------
def such_mit_liste(text,muster_liste,type='e'):
    '''
    
    :param text:
    :param muster_liste:
    :param type:
    :return: index
    '''
    index = -1
    for i,muster in enumerate(muster_liste):
        if( type[0] == 'l'): # lower
            i0 = such(text.lower(),muster.lower(),"vs")
        else: # exakt
            i0 = such(text,muster,"vs")
        # endif
        
        if( i0 > -1 ):
            index = i
            break
        # endif
    # endofr
    
    return index

    
# -------------------------------------------------------
def such_alle(t, muster):
    """
    Suche nach dem Muster in gesamten Text
    erstellt eine Index-Liste, wenn leer
    dann nixhts gefunden
    """
    liste = []
    i0 = 0
    i1 = such(t[i0:], muster)
    while (i1 >= 0):
        liste.append(i1 + i0)
        i0 = i0 + i1 + 1
        i1 = such(t[i0:], muster)
    return liste


def such_in_liste(liste, muster, regel=""):
    """
    Suche nach dem string-Muster in der Liste nach der Regel
    Input:
    liste   list    mit strings zu durchsuchen
    muster  string  muster nachdem gesucht wird
    regel   string  Regel nach der gesucht wird:
                    e  exakt in den items der liste
                    n  nicht exakt, d.h. muß enthalten sein, auch groß/klein
                    t nicht exakt vollständig, aber groß/klein

    Output:
    index_list liste(int)   Index Liste mit den �bereinstimmungen
                            wenn keine liste ist leer []
    """
    len1 = len(liste)
    index_liste = []
    for il in range(len1):
        if (regel == "e"):
            if (liste[il] == muster):
                index_liste.append(il)
        elif (regel == "n"):
            ll = liste[il].lower()
            mm = muster.lower()
            i0 = ll.find(mm)
            if (i0 > -1):
                index_liste.append(il)
        else:  # "t"
            ll = liste[il]
            mm = muster
            i0 = ll.find(mm)
            if (i0 > -1):
                index_liste.append(il)
    
    return index_liste


# -------------------------------------------------------
def reduce_double_items_in_liste(liste):
    """
    Reduziert doppelte Einträge in Liste
    liste_r = reduce_double_items_in_liste(liste)
    """
    n = len(liste)
    liste_new = []
    for item in liste:
        flag = True
        for newitem in liste_new:
            if (newitem == item):
                flag = False
                break
            # endif
        # endfor
        if (flag):
            liste_new.append(item)
        # endif
    # endfor
    return liste_new


# -------------------------------------------------------
def elim_a(text, muster):
    """
    Schneidet muster am Anfang von text weg, wenn vorhanden
    """
    liste = []
    if (isinstance(muster, str)):
        liste.append(muster)
    elif (isinstance(muster, list)):
        liste = muster
    else:
        return text
    
    if (len(text) == 0):
        return text
    
    lt = len(text)
    if (lt == 0):
        return text
    
    l = len(liste)
    check_liste = [1 for i in range(l)]
    
    while (True):
        for i in range(l):
            i0 = such(text, liste[i], "vn")
            if (i0 < 0):
                text = ""
            elif (i0 == 0):
                check_liste[i] = 0
            else:
                text = text[i0:len(text)]
                check_liste[i] = 1
        if (sum(check_liste) == 0 or len(text) == 0):
            break
    return text


# -------------------------------------------------------
def elim_e(text, muster):
    """
    Schneidet muster am Ende von text weg, wenn vorhanden
    """
    liste = []
    if (isinstance(muster, str)):
        liste.append(muster)
    elif (isinstance(muster, list)):
        liste = muster
    else:
        return text
    lt = len(text)
    if (lt == 0):
        return text
    
    l = len(liste)
    check_liste = [1 for i in range(l)]
    
    while (True):
        for i in range(l):
            i0 = such(text, liste[i], "rn")
            if (i0 < 0):
                text = ""
            elif (i0 == lt - 1):
                check_liste[i] = 0
            else:
                text = text[0:i0 + 1]
                lt = len(text)
                check_liste[i] = 1
        if (sum(check_liste) == 0 or len(text) == 0):
            break
    return text


# -------------------------------------------------------
def elim_ae(text, muster):
    """
    Schneidet muster am Anfang und Ende von text weg, wenn vorhanden
    """
    text = elim_a(text, muster)
    text = elim_e(text, muster)
    return text


#
# -------------------------------------------------------
def elim_a_liste(text, muster_liste):
    """
    elim_a_liste(text,muster_liste) Eliminiert text am Anfnag mit einer liste von mustern z.B. [" ","\t"]
    """
    flag = True
    
    while (flag):
        n1 = len(text)
        for muster in muster_liste:
            text = elim_a(text, muster)
        n2 = len(text)
        if (n1 == n2):
            flag = False
    return text


#
# -------------------------------------------------------
def elim_e_liste(text, muster_liste):
    """
    elim_e_liste(text,muster_liste) Eliminiert text am Ende mit einer liste von mustern z.B. [" ","\t"]
    """
    flag = True
    
    while (flag):
        n1 = len(text)
        for muster in muster_liste:
            text = elim_e(text, muster)
        n2 = len(text)
        if (n1 == n2):
            flag = False
    return text


#
# elim_ae_liste(text,muster_liste) Eliminiert text am Anfang und Ende mit einer liste von mustern z.B. [" ","\t"]
#
# -------------------------------------------------------
def elim_ae_liste(text, muster_liste):
    """
    elim_a_liste(text,muster_liste) Eliminiert text am Anfang mit einer liste von mustern z.B. [" ","\t"]
    """
    text = elim_a_liste(text, muster_liste)
    text = elim_e_liste(text, muster_liste)
    return text


def delete_str_by_index(txt, i0, i1):
    '''
    
    :param text:  zu bearbeitender Text
    :param i0:    erster index startet mit 0 zu löschen
    :param i1:    letzter index endet zu löschen
    :return: rest text
    '''
    
    n = len(txt)
    
    if ((i0 <= 0) or (i0 >= n)):
        
        t = ""
    
    else:
        
        t = txt[0:i0 - 1]
    
    # endif
    
    if ((i1 >= i0) and (i1 < (n - 1))):
        t = t + txt[i1 + 1:n - 1]
    
    # endif
    
    return t


# end def
def has_quots(t, quot0, quot1):
    """
    (num,type) = has_quots(text,quot0,quot1) num: anzahl quots, type = 0   geöffnet und geschlossen
                                                                    = +n  n-fach zuviel geöffnet(quot0)
                                                                    = -n  n-fach zuviel geschlossen(quot1)
    """
    num = 0
    type = 0
    
    if (quot0 == quot1):
        iliste = such_alle(t, quot0)
        n = int(len(iliste))
        
        if (n % 2) == 0:  # even
            num = n / 2
            type = 0
        else:
            num = (n + 1) / 2
            type = 1
        # endif
    else:
        iliste0 = such_alle(t, quot0)
        iliste1 = such_alle(t, quot1)
        
        n0 = len(iliste0)
        n1 = len(iliste1)
        
        iliste = iliste0 + iliste1
        
        indexliste = sorted(range(len(iliste)), key=iliste.__getitem__)
        
        search_start_quot = True
        nopen = 0
        nclose = 0
        for index in indexliste:
            
            if (search_start_quot):
                
                if (index < n0):  # comes from first list
                    
                    nopen += 1
                    search_start_quot = False
                else:
                    nclose += 1
                # endif
            else:
                if (index >= n0):  # comes from second list
                    nclose += 1
                    search_start_quot = True
                else:
                    nopen += 1
                # endif
            # endif
        # endfor
        
        num = max(nopen, nclose)
        type = nopen - nclose
    # endif
    
    return (num, type)


def get_index_quoted(text, quot0, quot1):
    return get_index_quot(text, quot0, quot1)


def get_index_quot(text, quot0, quot1):
    """
    Gibt Indexpaare (Tuples) in dem der Text gequotet ist z.B.

    text  = "abc {nest} efg  {plab}"
    #        0123456789012345678901
    quot0 = "{"
    quot1 = "}"

    a = get_index_quot(text,quot0,quot1)

    a ergibt [(5,9),(17,21)]
    """
    
    liste = []
    
    i0 = 0
    i1 = len(text)
    # print "i1 = %i" % i1
    lq0 = len(quot0)
    lq1 = len(quot1)
    
    while i0 < i1:
        
        istart = text.find(quot0, i0, i1)
        #       print "istart = %i" % istart
        if istart > -1:
            
            iend = text.find(quot1, istart + lq0, i1)
            #           print "iend = %i" % iend
            
            if iend == -1:
                iend = i1
            
            tup = (istart + lq0, iend)
            liste.append(tup)
            
            i0 = iend + lq1
        else:
            
            i0 = i1
    
    return liste


def get_index_not_quoted(text, quot0, quot1):
    return get_index_no_quot(text, quot0, quot1)


def get_index_no_quot(text, quot0, quot1):
    """
    Gibt Indexpaare (Tuples) in dem der Text nicht gequotet ist z.B.

    text  = "abc {nest} efg  {plab}"
    #        0123456789012345678901
    quot0 = "{"
    quot1 = "}"

    a = get_index_quot(text,quot0,quot1)

    a ergibt [(0,4),(10,16)]
    """
    liste = []
    
    i0 = 0
    i1 = len(text)
    #   print "i1 = %i" % i1
    lq0 = len(quot0)
    lq1 = len(quot1)
    
    istart = 0
    
    while istart < i1:
        
        iend = text.find(quot0, istart, i1)
        #       print "iend = %i" % iend
        if iend == -1:
            iend = i1
        
        tup = (istart, iend)
        if (istart != iend):
            liste.append(tup)
        
        i0 = text.find(quot1, iend + lq0, i1)
        
        if i0 == -1:
            istart = i1
        else:
            istart = i0 + lq1
    
    return liste


def get_string_quoted(text, quot0, quot1):
    """
    Gibt Liste mit string in dem der gequotet Text steht z.B.

    text  = "abc {nest} efg  {plab}"
    #        0123456789012345678901
    quot0 = "{"
    quot1 = "}"

    a = get_string_quoted(text,quot0,quot1)

    a ergibt ["nest","plab"]
    """
    iliste = get_index_quot(text, quot0, quot1)
    liste = []
    for t in iliste:
        tdum = text[t[0]:t[1]]
        liste.append(tdum)
    return liste


def get_string_not_quoted(text, quot0, quot1):
    """
    Gibt Liste mit string in dem der nicht gequotet Text steht z.B.

    text  = "abc {nest} efg  {plab}"
    #        0123456789012345678901
    quot0 = "{"
    quot1 = "}"

    a = get_string_not_quoted(text,quot0,quot1)

    a ergibt ["abc "," efg "]
    """
    iliste = get_index_not_quoted(text, quot0, quot1)
    liste = []
    for t in iliste:
        tdum = text[t[0]:t[1]]
        liste.append(tdum)
    return liste


def elim_comment_not_quoted(text, comment_liste, quot0, quot1):
    """
    eliminiert Kommentar nichtgequoteten aus dem Text, wenn ein Kommentarzeichen
    aus der Liste comment_list vorkommt z.B.
    text = "abc{abc#def} # ddd"
    tneu = elim_comment_not_quoted(text,["#","%"],"{","}")
    tneu = "abc{abc#def} "
    """
    
    a_liste = get_index_no_quot(text, quot0, quot1)
    i0 = len(text)
    #   print "i0= %i" % i0
    #   print a_liste
    for a in a_liste:
        for comment in comment_liste:
            #           print "a[0]= %i" % a[0]
            #           print "a[1]= %i" % a[1]
            b = text.find(comment, a[0], a[1])
            #           print "b= %i" % b
            if b > -1:
                i0 = min(b, i0)
    #               print "i0= %i" % i0
    text1 = text[0:i0]
    return text1


def split_not_quoted(text, spl, quot0, quot1, elim_leer=0):
    """
    Trennt text nach dem split-string auf, aber nur in nicht quotierten
    Teil.
    Input:
    text        string  z.B.    "abc|edf||{|||}|ghi"
    split       string          "|"
    quot0       string          "{"
    quot1       string          "}"
    elim_leer   int     wenn gesetzt, werden leere Items der Liste gel�scht
                        z.B.    1
    Output:
                        Liste mit den String-Teilen
                        z.B.    ["abc","edf","{|||}","ghi"]
    """
    ls = len(spl)
    i_list = get_index_quoted(text, quot0, quot1)
    
    flag = 1
    i0 = 0
    i01 = 0
    i1 = len(text)
    liste = []
    while (flag):
        i = text.find(spl, i01, i1)
        
        # Kein spl gefunden
        if (i < 0):
            liste.append(text[i0:i1])
            flag = 0
        else:
            # Prüfen ob i im quot liegt
            nimm_flag = 1
            for ii in i_list:
                # Wenn im quot nimm nicht
                if (i >= ii[0] and i <= ii[1]):
                    nimm_flag = 0
                    break
            if (nimm_flag):
                # Wenn leer
                if (i0 == i):
                    liste.append("")
                else:
                    liste.append(text[i0:i])
                i0 = i + ls
                i01 = i0
                # Wenn Ende erreicht
                if (i0 > i1):
                    # Wenn am Ende noch ein spl zu finden
                    if (i0 == i1 - 1):
                        liste.append("")
                    flag = 0
            # weiter suchen
            else:
                i01 = i + ls
    
    # Wenn leere Listen-Items
    # gelöscht werden sollen
    if (elim_leer):
        liste1 = []
        for t in liste:
            if (len(t) > 0):
                liste1.append(t)
        liste = liste1
    return liste


def split_text(t, trenn, flagmulti=0):
    """
    sucht in text nach trenn und bildet
    eine Liste den verbleibenden Textteile
    flagmulti = 1 bedeutet, das mehrere trenn zeichen hintereinander kein Eintrag in die Liste gibt
    """
    liste = []
    
    ltrenn = len(trenn)
    
    flag = 1
    
    while (flag):
        
        i = such(t, trenn, "vs")
        
        if (i < 0):
            if (flagmulti):
                if (len(t)):
                    liste.append(t)
                # endif
            else:
                liste.append(t)
            flag = 0
            t = ""
        
        elif (i == 0):
            if (flagmulti == 0):
                liste.append("")
        else:
            liste.append(t[0:i])
        # endif
        
        if (i + ltrenn <= len(t)):
            
            t = t[i + ltrenn:]
        
        
        else:
            t = ""
        # endif
        
        if (len(t) == 0):
            flag = 0
    # endwhile
    return liste


# enddef
def split_with_quot(text, quot0, quot1):
    """
    Trennt Text mit den quots in seine Teile und gibt an, ob
    gequteter Text oder nichtgequotet (außerhalb)
    Input:
    text    string      z.B.    "abc[def]ghi"
    quot0   string              "["
    quot1   string              "]"
    Output
            Liste mit Tuple     [["abc",NO_QUOT],["def",QUOT],["ghi",NO_QUOT]]
                                QUOT == 1, NO_QUOT == 0
    """
    i_list = get_index_no_quot(text, quot0, quot1)
    # print "no_quot"
    # print i_list
    
    liste = []
    # kein nicht quotierter Text
    if (len(i_list) == 0):
        i_list = get_index_quot(text, quot0, quot1)
        if (len(i_list) > 0):
            i0 = i_list[0][0]
            i1 = i_list[0][1]
            liste.append([text[i0:i1], QUOT])  # alles im quot
    else:
        i = 0
        ilast = 0
        for il in i_list:
            i0 = il[0]
            i1 = il[1]
            if (i == 0):
                if (i0 != 0):  # als erstes kommt gequoteter Text
                    liste.append([text[0:i0], QUOT])
                liste.append([text[i0:i1], NO_QUOT])
                ilast = i1
            else:
                liste.append([text[ilast:i0], QUOT])
                liste.append([text[i0:i1], NO_QUOT])
                ilast = i1
                i = i + 1
        
        if (ilast + 1 < len(text)):  # noch ein Rest vorhanden
            liste.append([text[ilast:], QUOT])
    
    return liste


def join_list(liste, delim):
    """
    Fügt list sofern text mit delim zusammen
    """
    txt = ""
    n = len(liste)
    for i in range(n):
        if (isinstance(liste[i], str)):
            if (i > 0):
                txt = txt + os.sep
            # endif
            txt = txt + liste[i]
        # endif
    # endif
    return txt


def change(text, muster_alt, muster_neu):
    """
    ersetzt einmal alle muster_alt mit muster_neu im Text
    """
    if (isinstance(text, str)):
        text = text.replace(muster_alt, muster_neu)
    # liste = string.split(text,muster_alt)
    # n0 = len(liste)
    # if( n0 <= 1 ):
    #    text1 = text
    # else:
    #    text1 = ""
    # text1 = ""
    # for i in range(0,n0-1):
    #    text1=text1+liste[i]+muster_neu
    # text1=text1+liste[n0-1]
    return text


def change_max(text, muster_alt, muster_neu):
    """
    ersetzt sooft es geht alle muster_alt mit muster_neu im Text
    """
    while (1):
        text1 = change(text, muster_alt, muster_neu)
        
        if (text1 == text):
            break
        else:
            text = text1
    
    return text1

# end def
def change_excel_value_str(txt):
    '''
    Ersetzt excel Notation für Werte in strings z.B. 10.000,23 => 10000.23
    :param text:
    :return:
    '''
    
    txt = change_max(txt,".","")
    txt = change(txt,",",".")
    
    return txt
    
    
    
# end def
def str_replace(text, textreplace, i0, l):
    """ löscht in text von position i0 l Zeichen und fügt textreplace ein
    """
    t = str_elim(text, i0, l)
    tt = str_insert(t, textreplace, i0)
    
    return tt


# enddef
def str_insert(text, textinsert, i0):
    n = len(text)
    
    if (i0 < n):
        t = text[0:i0]
        t += textinsert
        t += text[i0:]
    else:
        t = text + textinsert
    # endif
    
    return t


def str_elim(text, i0, l):
    """ löscht in text von position i0 l Zeichen
    """
    n = len(text)
    if (i0 < n):
        i1 = i0 + l
        t = text[0:i0]
        if (i1 < n):
            t += text[i1:]
        # endif
    else:
        t = text
    # endif
    return t


# enddef
def slice(text, l1):
    """
    Zerlegt text in Stücke von l1-Länge
    """
    liste = []
    t = text
    while (len(t) > l1):
        liste.append(t[0:l1])
        t = t[l1:]
    if (len(t) > 0):
        liste.append(t)
    return liste


def file_splitext(file_name):
    """
    ZErlegt file_name in body,ext
    file_name = "d:\\abc\\def\\ghj.dat"
    body      = "d:\\abc\\def\\ghj"
    ext       = "dat"
    """
    name = change_max(file_name, "/", "\\")
    
    i0 = such(name, "\\", "rs")
    i1 = such(name, ".", "rs")
    n = len(name)
    
    if (i1 > 0 and i1 > i0):
        b = file_name[0:i1]
        e = file_name[i1 + 1:n]
    else:
        b = file_name[0:n]
        e = ""
    
    return (b, e)


def file_split(file_name):
    """
    ZErlegt file_name in path,body,ext
    file_name = "d:\\abc\\def\\ghj.dat"
    path      = "d:\\abc\\def"
    body      = "ghj"
    ext       = "dat"
    """
    name = change_max(file_name, "/", "\\")
    
    i0 = such(name, "\\", "rs")
    i1 = such(name, ".", "rs")
    n = len(name)
    
    if (i0 > 0):
        p = file_name[0:i0]
    else:
        p = ""
    
    if (i1 > 0 and i1 > i0):
        b = file_name[i0 + 1:i1]
        e = file_name[i1 + 1:n]
    else:
        b = file_name[i0 + 1:n]
        e = ""
    
    return (p, b, e)


def search_file_extension(file):
    i1 = such(file, ".", "rs")
    return file[i1 + 1:len(file)]


def file_exchange_path(file_name, source_path, target_path):
    okay = NOT_OK
    new_file_name = ""
    file_name = os.path.normcase(change_max(file_name, '\\', '/'))
    source_path = os.path.normcase(change_max(source_path, '\\', '/'))
    target_path = os.path.normcase(change_max(target_path, '\\', '/'))
    
    if (such(file_name, source_path, "vs") == 0):  # Am Anfang gefunden
        ll = len(source_path)
        new_file_name = os.path.join(target_path, file_name[ll:])
        okay = OK
    return (okay, new_file_name)


def string_to_num_list(txt):
    ''' Zerlegt string wie '2, 3,  10, 1 ' oder '[1.2, 3.2, 4.55]'
        in eine numerische Liste
    '''
    
    txt = elim_a(txt, [' ', '[', '('])
    txt = elim_e(txt, [' ', ']', ')'])
    
    tliste = txt.split(',')
    
    liste = []
    
    for item in tliste:
        
        (okay, value) = str_to_float(item)
        if (okay):
            liste.append(value)
        else:
            liste = []
            return liste
    
    return liste


def is_letter(tt):
    '''  ist text ein Buchstabe Rückgabe Liste mit 1/0
         "et23sf" => [1,1,0,0,1,1]
    '''
    liste = []
    for t in tt:
        if (t in string.ascii_letters):
            liste.append(1)
        else:
            liste.append(0)


def is_letter_flag(tt):
    n = len(tt)
    ncount = 0
    for t in tt:
        if (t in string.ascii_letters):
            ncount += 1
    
    if (ncount == n): return True
    return False


def is_digit(tt):
    '''  ist text ein Digit Rückgabe Liste mit 1/0
         "et23sf" => [0,0,1,1,0,0]
    '''
    liste = []
    for t in tt:
        if (t in string.digits):
            liste.append(1)
        else:
            liste.append(0)


def is_digit_flag(tt):
    n = len(tt)
    ncount = 0
    for t in tt:
        if (t in string.digits):
            ncount += 1
    
    if (ncount == n): return True
    return False


def merge_string_liste(liste):
    '''
       merged die Liste mit strings in einen string
    '''
    tt = ""
    for l in liste:
        if (isinstance(type(l), str)):
            tt += l
    return tt


def convert_string_to_float(text):
    '''
    convert from string into float
    check for komma, point
    '''
    
    return float(change_max(text=text, muster_alt=",", muster_neu="."))


def vergleiche_text(text1, text2):
    '''
    vergleiche_text(text1,text2) Vergleicht, Ausgabe in Anteil, text als ganzes
    '''
    l1 = len(text1)
    l2 = len(text2)
    # Abruchbeingung
    if ((l1 == 0) or (l2 == 0)):
        return 0.0
    elif (isinstance(type(text1), str)):
        return 0.0
    elif (isinstance(type(text2), str)):
        return 0.0
    
    # der grössere Text wird base
    if (l1 > l2):
        lbase = l1
        tbase = text1
        lvar0 = l2
        tvar0 = text2
    else:
        lbase = l2
        tbase = text2
        lvar0 = l1
        tvar0 = text1
    
    # Var-Wort von hinten i=0 u. von vorne i=1 kürzen
    lfound = 0
    for i in range(2):
        run_flag = True
        lvar = lvar0
        tvar = tvar0
        while (run_flag):
            i0 = such(tbase, tvar, "vs")
            if (i0 >= 0):
                if (lvar > lfound):
                    lfound = lvar
                run_flag = False
                break
            else:
                # Ende wenn tvar leer wird
                if (lvar == 1):
                    run_flag = False
                else:
                    if (i == 0):
                        tvar = tvar[0:lvar - 1]
                    else:
                        tvar = tvar[1:lvar]
                    lvar = len(tvar)
    
    return float(lfound) / float(lbase)


def vergleiche_worte(text1, text2):
    '''
    vergleiche_worte(text1,text2) Vergleicht, Ausgabe in Anteil
    dir Leerzeichen getrennt Worte, und jedes Wort dem anderen
    '''
    
    if (not isinstance(text1, str)):
        return 0.0
    if (not isinstance(text2, str)):
        return 0.0
    
    t1 = change_max(text1, '\t', ' ')
    t1 = change_max(t1, '  ', ' ')
    t1 = elim_ae(t1, ' ')
    t1 = t1.split(' ')
    l1 = len(t1)
    t2 = change_max(text2, '\t', ' ')
    t2 = change_max(t2, '  ', ' ')
    t2 = elim_ae(t2, ' ')
    t2 = t2.split(' ')
    l2 = len(t2)
    
    if ((l2 == 0) or (l1 == 0)):
        return 0.0
    
    if (l1 > l2):
        lbase = l1
        tbase = t1
        lvar0 = l2
        tvar0 = t2
    else:
        lbase = l2
        tbase = t2
        lvar0 = l1
        tvar0 = t1
    
    # Bezugsgrösse
    lmax1 = 0
    for t in tbase:
        lmax1 += len(t)
    lmax2 = 0
    for t in tvar0:
        lmax2 += len(t)
    lmax = float(max(max(lmax1, lmax2), 1))
    
    # Var-Wort von hinten i=0 u. von vorne i=1 kürzen
    lfound = 0.0
    for i in range(2):
        run_flag = True
        lvar = lvar0
        tvar = tvar0
        while (run_flag):
            for j in range(lbase - lvar + 1):
                lfz = 0.0
                for k in range(lvar):
                    lmz = float(max(len(tvar[k]), len(tbase[k + j])))
                    lfz += vergleiche_text(tvar[k], tbase[k + j]) * lmz / lmax
                if (lfz > lfound):
                    lfound = lfz
            
            # Ende wenn tvar leer wird
            if (lvar == 1):
                run_flag = False
            else:
                if (i == 0):
                    tvar = tvar[0:lvar - 1]
                else:
                    tvar = tvar[1:lvar]
                lvar = len(tvar)
    
    return lfound


# ===============================================================================
# (text2,errtext) = make_unicode(text1)
# (text2,errtext) = make_unicode(text1,type)
#
# errtext == "" wenn kein Fehler
# ansonsten Fehler Text
#
def make_unicode(text1, texttype="utf-8"):
    errtext = ""
    text2 = ""
    if (isinstance(text1, str)):
        text2 = to_unicode(text1, texttype)
    else:
        text2 = text1
    # endif
    if (not isinstance(text1, str)):
        errtext = "Text: %s kann nicht in unicode gewandelt werden " % text1
    # endif
    return (text2, errtext)


# ===============================================================================
def convert_to_unicode(text1, texttype="utf-8"):
    if (not isinstance(text1, str)):
        tt = str(text1)
    # endif
    tt = to_unicode(text1, texttype=texttype)
    
    return tt


# ===============================================================================
def to_unicode(text1, texttype="utf-8"):
    '''
    to_unicode(string)   converts byte-string into unicode utf8
    '''
    
    if (isinstance(text1, bytes)):
        text2 = text1.decode(texttype)
    else:
        text2 = text1  # unicode.encode(text1,'utf-8')
    
    return text2


def to_bytes(text1):
    '''
    to_bytes(unicode)    converts unicode into byte-string
    '''
    if (isinstance(text1, str)):
        text2 = str.encode(text1)
    else:
        text2 = text1  # unicode.decode(text1)
    return text2


##def to_cp1252(text1):
##  '''
##  to_cp1252(unicode)    converts unicode into byte-string
##  '''
##    text2 = unicode.encoode(text1,'cp1252')
##  return text2
def text_to_write(text):
    tt = ''
    for t in text:
        if (t == u'\x81'):
            t = 'ü'
        # endif
        tt += t
    return tt


#


###########################################################################
# testen mit main
###########################################################################
if __name__ == '__main__':
    pass
