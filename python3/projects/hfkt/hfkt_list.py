# -*- coding: utf8 -*-
#
# 18.06.23 von hfkt.py
#############################



###################################################################################
# Listenbearbeitung
###################################################################################
'''
 such_in_liste(liste,muster,regel='n') Suche nach dem string-Muster in der Liste nach der Regel
                                       Input:
                                       liste   list    mit strings zu durchsuchen
                                       muster  string  muster nachdem gesucht wird
                                       regel   string  Regel nach der gesucht wird:
                                               e  exakt in den items der liste
                                               n  nicht exakt, d.h. muß enthalten sein, auch groß/klein
                                      Output:
                                       index_list liste(int)   Index Liste mit den Übereinstimmungen
                                                               wenn keine liste ist leer []

 reduce_double_items_in_liste(liste)  Reduziert doppelte Einträge in Liste
                                      liste_r = reduce_double_items_in_liste(liste)

 string_is_in_liste(tt,liste)  True wenn tt vollständig in einem item der Liste
                               False wenn nicht
 string_is_not_in_liste(tt,liste)

 list_out = erase_from_list(list_in,index/index_list) löscht index oder indexliste von list_in

'''
###################################################################################
# Fileoperating
###################################################################################
# def get_free_size(path): freie Größe Verzeichnis
# def get_parent_path_files(path): dir auf parent path and get files
# def get_parent_path_dirs(path): dir auf parent path and get dirs
# def get_dattime_float(full_filename): gibt int-Wert für datum und zeit jjjjmmtthhmmss
# get_subdir_files(path):  Kann in Iteration genutzt werden >>> for a in get_subdir_files("D:\\temp")
# def get_liste_of_subdir_files(Path,liste=[],search_ext=[]):Gibt eine Liste von allen Dateien in Unterverzeichnissen an (ext kann angegeben werden), liste als input wird weiter gefüllt
# def get_liste_of_subdir_files(Path,liste=[],search_ext=[],exlude_main_path=True): Exlude Path for search
# def get_liste_of_subdirs(Path,liste=[]):Gibt eine Liste von allen Unterverzeichnissen an liste=get_liste_of_subdirs(path1,[])
# def get_liste_of_files_in_dir(DirName,extensionListe=[],subdirFlag=0,liste=[]) Sucht nach Dateien mit der angegbene extension (default alle)
#                                                                                trägt sie in die Liste ein, und untersucht auch subdirs (default nicht)
#                                                                                Rückgabe der Liste
# def get_size_of_dir(Path,size=0): Gibt Größe des gesamten Unterverzeichnispfad an
# def join(part0="",part1="",part2="",part3="",part4="",part5=""):Setzt Dateiname zusammen
# (path,fbody,ext) = get_pfe(full_file): Gibt Pfad,Filebody und Extension zurück
# def remove_dir_all(dir_name): Löscht den Pfad
# def remove_named_dir(dir_name,delete_name,recursive): Loescht von dir_name die Ordber delete_name rekursiv oder nicht weg
# def is_textfile(filename, blocksize = 512) checks if file is an text-file
# def copy(s_path_filename,t_path_filename,silent=1)  kopiert s_path_filename nach t_path_filename return hfkt.OK=1
# def make_backup_file(fullfilename,backup_dir)
# def move_file(filename,target)
# def change_text_in_file(filename,textsearch,textreplace):
# def build_path(pathname): erstellt Pfad wenn nicht vorhanden
# def clear_path(pathname): löscht Inhalt des Pfades
# def find_file_pattern(pattern, path): find_file_pattern(pattern, path) returns a list of file: find('*.txt', 'D:\\temp') => ["D:\\temp\\filea.txt","D:\\temp\\filea.txt"]
# def get_last_subdir_name(fullpathname): gebe letzte Ebene des Unterpfadsnamen zurück
###################################################################################
# Eingabe/Ausgabe
###################################################################################
# def abfrage_listbox1(liste,smode):
# def abfrage_listbox(liste,smode):
# def abfrage_liste_scroll(liste,comment=None,cols=70,rows=20,multi=0):
# def abfrage_liste(liste,comment=None):
# def eingabe_int(comment):
# def eingabe_float(comment):
# def eingabe_string(comment):
# def eingabe_jn(comment,default=None):
# bool abfrage_ok_box(text="Ist das okay") Rückgabe True/False
# def abfrage_dir(comment=None,start_dir=None):
# def abfrage_sub_dir(comment=None,start_dir=None):
# def filename = abfrage_file(file_types="*.*",comment=None,start_dir=None):
# def eingabe_file(file_types="*",comment="Waehle oder benenne neue Datei",start_dir=None):
# def abfrage_str_box(comment="",width=400): String aus eigenem Fenster einlesen (width Fenster-Breite)
###########################################################################################
# DAten lesen/schreiben
##################################################################################
# def read_csv_file(file_name=name,delimiter=";")
# def (state,header,data)=read_csv_file_header_data(file_name,delim=";")
# def write_csv_file_header_data(file_name,csv_header,csv_data,delim=";")
# def read_ascii(file_name=name) return (okay,txt) entire ascii-text
# def read_ascii_build_list_of_lines(file_name) return(okay,lines) list of lines from ascii-text
##################################################################################
# Schreiben in HTML-File
##################################################################################
# def html_write_start(f,title) Beginn HTML-Seite
# def html_write_end(f):Ende HTML-Seite
# def html_write_start_tab(f,title) Start Tabelle
# def html_write_end_tab(f) Ende TAbelle
# def html_write_start_colgroup(f): Start Spaltengruppe
# def html_write_end_colgroup(f):Ende Spaltengruppe
# def html_write_set_col_align(f,ausr):Ausrichtung "center","right","left"
# def html_write_start_tab_zeile(f): Zeilenstart einer Tabelle
# def html_write_end_tab_zeile(f): Ende einer Zeile in TAbelle
# def html_write_tab_zelle(f,h_flag,fett_flag,farbe,inhalt): Beschreib eine Zelle in einer Tabellezeile
# def html_write_leer_zeile(f,n_spalten): Leerzeilen über n Spalten
# def html_get_filename_for_browser(filename): Umsetzen für browser
###################################################################################
# Sonstiges
###################################################################################
# value = str_to_float_possible(string_val),  if not possible value = None
# ival  = str_to_int_possible(string_val),  if not possible ival = None
# def int_to_dec36(int_val,digits=0):
# def dec36_to_int(string_val):
# def summe_euro_to_cent(text,delim=","):
# def suche_in_liste(liste,gesucht):
# def int_akt_datum():
# def int_akt_time():
# def str_akt_datum():
# def str_datum(int_dat):
# secs = secs_akt_time_epoch()
# secs = secs_time_epoch_from_int(intval)
# secs = secs_time_epoch_from_str(str_dat,delim=".")
# secs = secs_time_epoch_from_int(intval,plus_hours)
# string = secs_time_epoch_to_str(secs): Wandelt in string Datum
# int    = secs_time_epoch_to_int(secs): Wandelt in int Datum
# flag   = datum_str_is_correct(str_dat,delim=".")
# strnew = datum_str_make_correction(str_dat,delim=".")
# daystr = day_from_secs_time_epoch(secs): Man bekommt den Tag in Mo,Di,Mi,Do,Fr,Sa,So
# daystr = day_from_datum_str(str_dat,delim="."): Man bekommt den Tag in Mo,Di,Mi,Do,Fr,Sa,So
# def datum_str_to_intliste(str_dat,delim="."): Wandelt string in eine Liste
# def datum_intliste_to_int(dat_l):  Wandelt Liste in ein int
# def datum_int_to_intliste(intval): int -> liste
# def datum_str_to_int(str_dat,delim="."): Wandelt string in ein int
# def datum_intliste_to_str(int_liste,delim="."):
# def datum_str_to_year_int(str_dat,delim="."):
# def datum_str_to_month_int(str_dat,delim="."):
# def datum_str_to_day_int(str_dat,delim="."):
# def secs_time_epoch_find_next_day(secs,idaynext):
# flag =  is_datum_str(str_dat,delim=".")   flag = True/False
# def get_name_by_dat_time(pre_text,post_text) Gibt Name gebildet aus localtime und text
# def diff_days_from_time_tuples(time_tuple_start,time_tuple_end) Bildet die Differenz der Tage über 0:00
# def string_cent_in_euro(cents):
# def num_cent_in_euro(cents):
# int = string_euro_in_int_cent(teuro,delim=",") Wandelt einen String mit Euro in Cent
# def dat_last_act_workday_datelist(year,mon,day): Sucht letzten aktuellen Werktag in  [year,month,day]
# int days_of_month(mon,year): gibt anzahl Tage für den Monat
# (okay,value) =  str_to_float(string) wandelt string in float, wenn nicht erreichr okay = false
# flag = is_string(val)  Prüft, ob Type string flag = True/False
# flag = is_unicode(val)  Prüft, ob Type unicode flag = True/False
# flag = is_list(val)  Prüft, ob Type liste flag = True/False
# flag = is_dict(val)  Prüft, ob Type dictionary flag = True/False
# flag = isfield(c,'valname') Prüft ob eine Klasse oder ein dict die instance hat
# flag = isempty(val) Prüft, ob leer nach type
# print_python_is_32_or_64_bit
#---------------------------------
# multiply_constant(list,const)  multiplies a list with const value

from tkinter import *
from tkinter.constants import *
import tkinter.filedialog
import tkinter.messagebox
import tkinter.tix
import string
import types
import copy
import sys
import os
import stat
import time
import datetime
import calendar
# import csv
import array
import shutil
import math
import struct
# import ftfy
import fnmatch


KITCHEN_MODUL_AVAILABLE = False


OK     = 1
NOT_OK = 0
QUOT    = 1
NO_QUOT = 0
TCL_ALL_EVENTS = 0
#############################
#Stringbearbeitung
##################
def get_str_from_int(intval,intwidth):
#-------------------------------------------------------
  """
  gibt string mit vorangestellten nullen aus
  """
  if( intval == 0 ):
    mzeichen = 0
    width    = 1
    val      = intval
  elif( intval < 0 ):
    mzeichen = 1
    width    = int(math.floor(math.log10(-intval)))+1
    val      = -intval
  else:
    mzeichen = 0
    width    = int(math.floor(math.log10(intval)))+1
    val      = intval

  if( mzeichen == 1 ): t = "-"
  else:                t = ""

  n = int(math.floor(math.fabs(intwidth))) - width
  i = 0
  while( (n > 0) and (i < n) ):
    t = t + "0"
    i += 1

  t = t + "%s" % val

  return t
#-------------------------------------------------------
def such(text,muster,regel="vs"):
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

        if n_flag == 1: # nicht mehr vorkommen

            ireturn = -1
            for i in range(0,lt,1):

                if( text[i:i+lm].find(muster) == -1 ):
                    ireturn = i
                    break
                #endif
            #endof
            return ireturn

        else: #soll vorkommen

            ireturn = text.find(muster)
            # print "ireturn = %i" % ireturn
            return ireturn
        #endif
    else: # rueckwaerts

        if n_flag == 1:

            ireturn = -1
#           print "lm=%i" % lm
#           print "lt=%i" % lt
            for i in range(0,lt,1):

#               print "i=%i" % i
                i0 = text.rfind(muster,0,lt-i)
#               print "i0=%i" % i0
#               print "lt-lm-i=%i" % (lt-lm-i)

                if i0 < lt-lm-i:
                    ireturn = lt-i-1
                    break
            return ireturn

        else:

            ireturn = text.rfind(muster)
            return ireturn
#-------------------------------------------------------
def such_alle(t,muster):
    """
    Suche nach dem Muster in gesamten Text
    erstellt eine Index-Liste, wenn leer
    dann nixhts gefunden
    """
    liste = []
    i0    = 0
    i1    =  such(t[i0:],muster)
    while( i1 >= 0 ):
      liste.append(i1+i0)
      i0 = i0+i1+1
      i1    =  such(t[i0:],muster)
    return liste

def such_in_liste(liste,item):
    """
    Suche nach dem item in der Liste
    Input:
    liste   list    mit strings zu durchsuchen
    item            nachdem wird gesucht

    Output:
    index_list liste(int)   Index Liste mit den �bereinstimmungen
                            wenn keine liste ist leer []
    """
    len1 = len(liste)
    index_liste = []
    for il in range(len1):
        if( liste[il] == muster):
            index_liste.append(il)
    return index_liste
#-------------------------------------------------------
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
      if( newitem == item ):
        flag = False
        break
      #endif
    #endfor
    if( flag ):
      liste_new.append(item)
    #endif
  #endfor
  return liste_new
#-------------------------------------------------------
def elim_a(text,muster):
    """
    Schneidet muster am Anfang von text weg, wenn vorhanden
    """
    liste = []
    if( isinstance(muster, str) ):
        liste.append(muster)
    elif( isinstance(muster,list) ):
        liste = muster
    else:
        return text

    if( len(text) == 0 ):
        return text

    lt = len(text)
    if(  lt == 0 ):
        return text

    l = len(liste)
    check_liste = [1 for i in range(l)]

    while( True ):
        for i in range(l):
            i0 = such(text,liste[i],"vn")
            if( i0 < 0 ):
                text = ""
            elif( i0 == 0 ):
                check_liste[i] = 0
            else:
                text = text[i0:len(text)]
                check_liste[i] = 1
        if( sum(check_liste) == 0 or len(text) == 0 ):
            break
    return text
#-------------------------------------------------------
def elim_e(text,muster):
    """
    Schneidet muster am Ende von text weg, wenn vorhanden
    """
    liste = []
    if( isinstance(muster, str) ):
        liste.append(muster)
    elif( isinstance(muster,list) ):
        liste = muster
    else:
        return text
    lt = len(text)
    if(  lt == 0 ):
        return text

    l = len(liste)
    check_liste = [1 for i in range(l)]

    while( True ):
        for i in range(l):
            i0 = such(text,liste[i],"rn")
            if( i0 < 0 ):
                text = ""
            elif( i0 == lt-1 ):
                check_liste[i] = 0
            else:
                text = text[0:i0+1]
                lt = len(text)
                check_liste[i] = 1
        if( sum(check_liste) == 0 or len(text) == 0 ):
            break
    return text
#-------------------------------------------------------
def elim_ae(text,muster):
    """
    Schneidet muster am Anfang und Ende von text weg, wenn vorhanden
    """
    text = elim_a(text,muster)
    text = elim_e(text,muster)
    return text
#
#-------------------------------------------------------
def elim_a_liste(text,muster_liste):
    """
    elim_a_liste(text,muster_liste) Eliminiert text am Anfnag mit einer liste von mustern z.B. [" ","\t"]
    """
    flag = True

    while( flag ):
      n1 = len(text)
      for muster in muster_liste:
        text = elim_a(text,muster)
      n2 = len(text)
      if( n1 == n2 ):
        flag = False
    return text
#
#-------------------------------------------------------
def elim_e_liste(text,muster_liste):
    """
    elim_e_liste(text,muster_liste) Eliminiert text am Ende mit einer liste von mustern z.B. [" ","\t"]
    """
    flag = True

    while( flag ):
      n1 = len(text)
      for muster in muster_liste:
        text = elim_e(text,muster)
      n2 = len(text)
      if( n1 == n2 ):
        flag = False
    return text
#
# elim_ae_liste(text,muster_liste) Eliminiert text am Anfang und Ende mit einer liste von mustern z.B. [" ","\t"]
#
#-------------------------------------------------------
def elim_ae_liste(text,muster_liste):
    """
    elim_a_liste(text,muster_liste) Eliminiert text am Anfang mit einer liste von mustern z.B. [" ","\t"]
    """
    text = elim_a_liste(text,muster_liste)
    text = elim_e_liste(text,muster_liste)
    return text

def get_index_quoted(text,quot0,quot1):
    return get_index_quot(text,quot0,quot1)
def get_index_quot(text,quot0,quot1):
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

    i0  = 0
    i1  = len(text)
    # print "i1 = %i" % i1
    lq0 = len(quot0)
    lq1 = len(quot1)

    while i0 < i1:

        istart = text.find(quot0,i0,i1)
#       print "istart = %i" % istart
        if istart > -1:

            iend = text.find(quot1,istart+lq0,i1)
#           print "iend = %i" % iend

            if iend == -1:
                iend = i1

            tup = (istart+lq0,iend)
            liste.append(tup)

            i0 = iend+lq1
        else:

            i0 = i1

    return liste

def get_index_not_quoted(text,quot0,quot1):
    return get_index_no_quot(text,quot0,quot1)
def get_index_no_quot(text,quot0,quot1):
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

    i0  = 0
    i1  = len(text)
#   print "i1 = %i" % i1
    lq0 = len(quot0)
    lq1 = len(quot1)

    istart = 0

    while istart < i1:

        iend = text.find(quot0,istart,i1)
#       print "iend = %i" % iend
        if iend == -1:
            iend = i1

        tup = (istart,iend-1)
        if( istart != iend ):
            liste.append(tup)

        i0 = text.find(quot1,iend+lq0,i1)

        if i0 == -1:
            istart = i1
        else:
            istart = i0+lq1


    return liste
def get_string_quoted(text,quot0,quot1):
    """
    Gibt Liste mit string in dem der gequotet Text steht z.B.

    text  = "abc {nest} efg  {plab}"
    #        0123456789012345678901
    quot0 = "{"
    quot1 = "}"

    a = get_string_quoted(text,quot0,quot1)

    a ergibt ["nest","plab"]
    """
    iliste = get_index_quot(text,quot0,quot1)
    liste = []
    for t in iliste:
        tdum = text[t[0]:t[1]]
        liste.append(tdum)
    return liste
def get_string_not_quoted(text,quot0,quot1):
    """
    Gibt Liste mit string in dem der nicht gequotet Text steht z.B.

    text  = "abc {nest} efg  {plab}"
    #        0123456789012345678901
    quot0 = "{"
    quot1 = "}"

    a = get_string_not_quoted(text,quot0,quot1)

    a ergibt ["abc "," efg "]
    """
    iliste = get_index_not_quoted(text,quot0,quot1)
    liste = []
    for t in iliste:
        tdum = text[t[0]:t[1]]
        liste.append(tdum)
    return liste
def elim_comment_not_quoted(text,comment_liste,quot0,quot1):
    """
    eliminiert Kommentar nichtgequoteten aus dem Text, wenn ein Kommentarzeichen
    aus der Liste comment_list vorkommt z.B.
    text = "abc{abc#def} # ddd"
    tneu = elim_comment_not_quoted(text,["#","%"],"{","}")
    tneu = "abc{abc#def} "
    """
    text1 = text
    a_liste = get_index_no_quot(text,quot0,quot1)
    i0 = len(text1)
#   print "i0= %i" % i0
#   print a_liste
    for a in a_liste:
        for comment in comment_liste:
#           print "a[0]= %i" % a[0]
#           print "a[1]= %i" % a[1]
            b = text1.find(comment,a[0],a[1])
#           print "b= %i" % b
            if b > -1:
                i0 = min(b,i0)
#               print "i0= %i" % i0
    return text1[0:i0]
def split_not_quoted(text,spl,quot0,quot1,elim_leer=0):
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
    ls     = len(spl)
    i_list = get_index_quoted(text,quot0,quot1)

    flag = 1
    i0   = 0
    i01  = 0
    i1   = len(text)
    liste = []
    while( flag ):
        i= text.find(spl,i01,i1)

        # Kein spl gefunden
        if( i < 0 ):
            liste.append(text[i0:i1])
            flag = 0
        else:
            # Prüfen ob i im quot liegt
            nimm_flag = 1
            for ii in i_list:
                # Wenn im quot nimm nicht
                if( i >= ii[0] and i <= ii[1] ):
                    nimm_flag = 0
                    break
            if( nimm_flag ):
                # Wenn leer
                if( i0 == i ):
                    liste.append("")
                else:
                    liste.append(text[i0:i])
                i0  = i+ls
                i01 = i0
                # Wenn Ende erreicht
                if( i0 > i1 ):
                    # Wenn am Ende noch ein spl zu finden
                    if( i0 == i1-1 ):
                        liste.append("")
                    flag = 0
            # weiter suchen
            else:
                i01 = i+ls

    # Wenn leere Listen-Items
    # gelöscht werden sollen
    if( elim_leer ):
        liste1 = []
        for t in liste:
            if( len(t) > 0 ):
                liste1.append(t)
        liste = liste1
    return liste
def split_text(t,trenn):
  """
  sucht in text nach trenn und bildet
  eine Liste den verbleibenden Textteile
  """
  liste = []

  ltrenn = len(trenn)


  flag = 1

  while(flag):

    i = such(t,trenn,"vs")

    if( i < 0 ):
      liste.append(t)
      flag = 0
      t = ""

    elif( i == 0 ):
      liste.append("")
    else:
      liste.append(t[0:i])
    #endif

    if( i+ltrenn <= len(t) ):

      t = t[i+ltrenn:]

    else:
      t = ""
    #endif

    if( len(t) <= ltrenn ):
      flag = 0
  #endwhile
  return liste

def split_with_quot(text,quot0,quot1):
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
    i_list = get_index_no_quot(text,quot0,quot1)
    #print "no_quot"
    #print i_list

    liste = []
    # kein nicht quotierter Text
    if( len(i_list) == 0 ):
        i_list = get_index_quot(text,quot0,quot1)
        if( len(i_list) > 0 ):
            i0 = i_list[0][0]
            i1 = i_list[0][1]
            liste.append([text[i0:i1],QUOT]) #alles im quot
    else:
        i     = 0
        ilast = 0
        for il in i_list:
            i0 = il[0]
            i1 = il[1]
            if( i == 0 ):
                if( i0 != 0 ): #als erstes kommt gequoteter Text
                    liste.append([text[0:i0],QUOT])
                liste.append([text[i0:i1],NO_QUOT])
                ilast = i1
            else:
                liste.append([text[ilast:i0],QUOT])
                liste.append([text[i0:i1],NO_QUOT])
                ilast = i1
                i = i+1

        if( ilast+1 < len(text) ): # noch ein Rest vorhanden
            liste.append([text[ilast:],QUOT])

    return liste
def join_list(liste,delim):
    """
    Fügt list sofern text mit delim zusammen
    """
    txt = ""
    n   = len(liste)
    for i in range(n):
        if( isinstance(liste[i],str) ):
            if( i > 0 ):
                txt = txt + os.sep
            #endif
            txt = txt+liste[i]
        #endif
    #endif
    return txt

def change(text,muster_alt,muster_neu):
    """
    ersetzt einmal alle muster_alt mit muster_neu im Text
    """
    if( isinstance(text,str) ):
        text = text.replace(muster_alt,muster_neu)
    #liste = string.split(text,muster_alt)
    #n0 = len(liste)
    #if( n0 <= 1 ):
    #    text1 = text
    #else:
    #    text1 = ""
    #text1 = ""
    #for i in range(0,n0-1):
    #    text1=text1+liste[i]+muster_neu
    #text1=text1+liste[n0-1]
    return text

def change_max(text,muster_alt,muster_neu):
    """
    ersetzt sooft es geht alle muster_alt mit muster_neu im Text
    """
    while( 1 ):
        text1 = change(text,muster_alt,muster_neu)

        if( text1 == text ):
            break
        else:
            text = text1

    return text1
def str_replace(text,textreplace,i0,l):
    """ löscht in text von position i0 l Zeichen und fügt textreplace ein
    """
    t = str_elim(text,i0,l)
    tt = str_insert(t,textreplace,i0)

    return tt
#enddef
def str_insert(text,textinsert,i0):

    n = len(text)

    if( i0 < n ):
        t = text[0:i0]
        t += textinsert
        t += text[i0:]
    else:
        t = text + textinsert
    #endif

    return t
def str_elim(text,i0,l):

    """ löscht in text von position i0 l Zeichen
    """
    n = len(text)
    if( i0 < n):
        i1 = i0+l
        t = text[0:i0]
        if( i1 < n ):
            t += text[i1:]
        #endif
    else:
        t = text
    #endif
    return t
#enddef
def slice(text,l1):
    """
    Zerlegt text in Stücke von l1-Länge
    """
    liste = []
    t  = text
    while( len(t) > l1 ):
        liste.append(t[0:l1])
        t = t[l1:]
    if( len(t) > 0 ):
        liste.append(t)
    return liste

def file_splitext(file_name):
    """
    ZErlegt file_name in body,ext
    file_name = "d:\\abc\\def\\ghj.dat"
    body      = "d:\\abc\\def\\ghj"
    ext       = "dat"
    """
    name = change_max(file_name,"/","\\")

    i0 = such(name,"\\","rs")
    i1 = such(name,".","rs")
    n  = len(name)

    if( i1 > 0 and i1 > i0 ):
        b = file_name[0:i1]
        e = file_name[i1+1:n]
    else:
        b = file_name[0:n]
        e = ""

    return (b,e)
def file_split(file_name):
    """
    ZErlegt file_name in path,body,ext
    file_name = "d:\\abc\\def\\ghj.dat"
    path      = "d:\\abc\\def"
    body      = "ghj"
    ext       = "dat"
    """
    name = change_max(file_name,"/","\\")

    i0 = such(name,"\\","rs")
    i1 = such(name,".","rs")
    n  = len(name)

    if( i0 > 0 ):
        p = file_name[0:i0]
    else:
        p = ""

    if( i1 > 0 and i1 > i0 ):
        b = file_name[i0+1:i1]
        e = file_name[i1+1:n]
    else:
        b = file_name[i0+1:n]
        e = ""

    return (p,b,e)
def search_file_extension(file):

    i1 = such(file,".","rs")
    return file[i1+1:len(file)]

def file_exchange_path(file_name,source_path,target_path):
  okay = NOT_OK
  new_file_name = ""
  file_name   = os.path.normcase(change_max(file_name,'\\','/'))
  source_path = os.path.normcase(change_max(source_path,'\\','/'))
  target_path = os.path.normcase(change_max(target_path,'\\','/'))

  if( such(file_name,source_path,"vs") == 0 ): # Am Anfang gefunden
    ll = len( source_path )
    new_file_name = os.path.join(target_path,file_name[ll:])
    okay          = OK
  return (okay,new_file_name)

def string_to_num_list(txt):
  ''' Zerlegt string wie '2, 3,  10, 1 ' oder '[1.2, 3.2, 4.55]'
      in eine numerische Liste
  '''

  txt = elim_a(txt,[' ','[','('])
  txt = elim_e(txt,[' ',']',')'])

  tliste = txt.split(',')

  liste = []

  for item in tliste:

    (okay,value) = str_to_float(item)
    if( okay ):
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
    if( t in string.ascii_letters ):
      liste.append(1)
    else:
      liste.append(0)
def is_letter_flag(tt):
  n = len(tt)
  ncount = 0
  for t in tt:
    if( t in string.ascii_letters ):
      ncount += 1

  if( ncount == n ): return True
  return False
def is_digit(tt):
  '''  ist text ein Digit Rückgabe Liste mit 1/0
       "et23sf" => [0,0,1,1,0,0]
  '''
  liste = []
  for t in tt:
    if( t in string.digits ):
      liste.append(1)
    else:
      liste.append(0)
def is_digit_flag(tt):
  n = len(tt)
  ncount = 0
  for t in tt:
    if( t in string.digits ):
      ncount += 1

  if( ncount == n ): return True
  return False
def merge_string_liste(liste):
  '''
     merged die Liste mit strings in einen string
  '''
  tt = ""
  for l in liste:
    if( isinstance(type(l), str) ):
      tt += l
  return tt
def convert_string_to_float(text):
    '''
    convert from string into float
    check for komma, point
    '''

    return float(change_max(text=text,muster_alt=",",muster_neu="."))


def vergleiche_text(text1,text2):
  '''
  vergleiche_text(text1,text2) Vergleicht, Ausgabe in Anteil, text als ganzes
  '''
  l1 = len(text1)
  l2 = len(text2)
  # Abruchbeingung
  if( (l1 == 0) or (l2 == 0) ):
    return 0.0
  elif(  isinstance(type(text1), str)  ):
    return 0.0
  elif( isinstance(type(text2), str) ):
    return 0.0

  # der grössere Text wird base
  if( l1 > l2 ):
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
    lvar     = lvar0
    tvar     = tvar0
    while( run_flag ):
      i0 = such(tbase,tvar,"vs")
      if( i0 >= 0 ):
        if( lvar > lfound ):
          lfound = lvar
        run_flag = False
        break
      else:
        # Ende wenn tvar leer wird
        if( lvar == 1 ):
          run_flag = False
        else:
          if( i == 0 ):
            tvar = tvar[0:lvar-1]
          else:
            tvar = tvar[1:lvar]
          lvar = len(tvar)

  return float(lfound)/float(lbase)

def vergleiche_worte(text1,text2):
  '''
  vergleiche_worte(text1,text2) Vergleicht, Ausgabe in Anteil
  dir Leerzeichen getrennt Worte, und jedes Wort dem anderen
  '''

  if(  not isinstance(text1, str)  ):
    return 0.0
  if(  not isinstance(text2, str)  ):
    return 0.0

  t1 = change_max(text1,'\t',' ')
  t1 = change_max(t1,'  ',' ')
  t1 = elim_ae(t1,' ')
  t1 = t1.split(' ')
  l1 = len(t1)
  t2 = change_max(text2,'\t',' ')
  t2 = change_max(t2,'  ',' ')
  t2 = elim_ae(t2,' ')
  t2 = t2.split(' ')
  l2 = len(t2)

  if( (l2 == 0) or (l1 == 0) ):
    return 0.0

  if( l1 > l2 ):
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
  lmax = float(max(max(lmax1,lmax2),1))


  # Var-Wort von hinten i=0 u. von vorne i=1 kürzen
  lfound = 0.0
  for i in range(2):
    run_flag = True
    lvar     = lvar0
    tvar     = tvar0
    while( run_flag ):
      for j in range(lbase-lvar+1):
        lfz = 0.0
        for k in range(lvar):
          lmz = float(max(len(tvar[k]),len(tbase[k+j])))
          lfz += vergleiche_text(tvar[k],tbase[k+j])*lmz/lmax
        if( lfz > lfound ):
          lfound = lfz

      # Ende wenn tvar leer wird
      if( lvar == 1 ):
        run_flag = False
      else:
        if( i == 0 ):
          tvar = tvar[0:lvar-1]
        else:
          tvar = tvar[1:lvar]
        lvar = len(tvar)

  return lfound

##def doubledecode(s, as_unicode=True):
##  s = s.decode('utf8')
##  # remove the windows gremlins O^1
##  for src, dest in cp1252_liste.items():
##    s = s.replace(src, dest)
##  s = s.encode('raw_unicode_escape')
##  if as_unicode:
##    # return as unicode string
##    s = s.decode('utf8', 'ignore')
##  return s
##
##cp1252_liste = {
### from http://www.microsoft.com/typography/unicode/1252.htm
##u"\u20AC": u"\x80", # EURO SIGN
##u"\u201A": u"\x82", # SINGLE LOW-9 QUOTATION MARK
##u"\u0192": u"\x83", # LATIN SMALL LETTER F WITH HOOK
##u"\u201E": u"\x84", # DOUBLE LOW-9 QUOTATION MARK
##u"\u2026": u"\x85", # HORIZONTAL ELLIPSIS
##u"\u2020": u"\x86", # DAGGER
##u"\u2021": u"\x87", # DOUBLE DAGGER
##u"\u02C6": u"\x88", # MODIFIER LETTER CIRCUMFLEX ACCENT
##u"\u2030": u"\x89", # PER MILLE SIGN
##u"\u0160": u"\x8A", # LATIN CAPITAL LETTER S WITH CARON
##u"\u2039": u"\x8B", # SINGLE LEFT-POINTING ANGLE QUOTATION MARK
##u"\u0152": u"\x8C", # LATIN CAPITAL LIGATURE OE
##u"\u017D": u"\x8E", # LATIN CAPITAL LETTER Z WITH CARON
##u"\u2018": u"\x91", # LEFT SINGLE QUOTATION MARK
##u"\u2019": u"\x92", # RIGHT SINGLE QUOTATION MARK
##u"\u201C": u"\x93", # LEFT DOUBLE QUOTATION MARK
##u"\u201D": u"\x94", # RIGHT DOUBLE QUOTATION MARK
##u"\u2022": u"\x95", # BULLET
##u"\u2013": u"\x96", # EN DASH
##u"\u2014": u"\x97", # EM DASH
##u"\u02DC": u"\x98", # SMALL TILDE
##u"\u2122": u"\x99", # TRADE MARK SIGN
##u"\u0161": u"\x9A", # LATIN SMALL LETTER S WITH CARON
##u"\u203A": u"\x9B", # SINGLE RIGHT-POINTING ANGLE QUOTATION MARK
##u"\u0153": u"\x9C", # LATIN SMALL LIGATURE OE
##u"\u017E": u"\x9E", # LATIN SMALL LETTER Z WITH CARON
##u"\u0178": u"\x9F", # LATIN CAPITAL LETTER Y WITH DIAERESIS
##}
###################################################################################
# Listenbearbeitung
###################################################################################
def such_in_liste(liste,muster,regel=""):
    """
    Suche nach dem string-Muster in der Liste nach der Regel
    Input:
    liste   list    mit strings zu durchsuchen
    muster  string  muster nachdem gesucht wird
    regel   string  Regel nach der gesucht wird:
                    e  exakt in den items der liste
                    n  nicht exakt, d.h. muß enthalten sein, auch groß/klein

    Output:
    index_list liste[int]   Index Liste mit den Übereinstimmungen
                            wenn keine liste ist leer []
    """
    len1 = len(liste)
    index_liste = []
    for il in range(len1):
        if( regel == "e" ):
            if( liste[il] == muster):
                index_liste.append(il)
        else:
            ll = liste[il].lower()
            mm = muster.lower()
            i0 = ll.find(mm);
            if( i0 > -1 ):
                index_liste.append(il)
    return index_liste
def string_is_in_liste(tt,liste):
  """
    True wenn tt vollständig in einem item der Liste
    False wenn nicht
  """
  index_list_liste = such_in_liste(liste,tt,regel="e")

  if( len(index_list_liste) > 0 ):
    return True
  else:
    return False
def string_is_not_in_liste(tt,liste):
  """
    False wenn tt vollständig in einem item der Liste
    True wenn nicht
  """
  return not string_is_in_liste(tt,liste)

def erase_from_list(list_in,index_list):
  """
   löscht index oder indexliste von list_in
  """

  if( isinstance(type(index_list), int) ):
    index_list = [index_list]
  #endif
  if( isinstance(type(index_list), float) ):
    index_list = [int(index_list)]
  #endif

  ioffset = 0

  index_list.sort()

  for index in index_list:
    if( (index-ioffset) < len(list_in)):
      del list_in[index-ioffset]
      ioffset += 1
    #endif
  #endfor

  return list_in


###########################################################################
# testen mit main
###########################################################################
if __name__ == '__main__':
    pass