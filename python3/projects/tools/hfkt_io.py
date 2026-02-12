# -*- coding: utf8 -*-
#
# 18.06.23 von hfkt.py
#############################

###################################################################################
# Eingabe/Ausgabe
###################################################################################
'''
 def abfrage_listbox1(liste,smode):
 def abfrage_listbox(liste,smode):
 def abfrage_liste_scroll(liste,comment=None,cols=70,rows=20,multi=0):
 def abfrage_liste(liste,comment=None):
 def eingabe_int(comment):
 def eingabe_float(comment):
 def eingabe_string(comment):
 def eingabe_jn(comment,default=None):
 bool abfrage_ok_box(text="Ist das okay") Rückgabe True/False
 def abfrage_dir(comment=None,start_dir=None):
 def abfrage_sub_dir(comment=None,start_dir=None):
 def filename = abfrage_file(file_types="*.*",comment=None,start_dir=None):
 def eingabe_file(file_types="*",comment="Waehle oder benenne neue Datei",start_dir=None):
 def abfrage_str_box(comment="",width=400): String aus eigenem Fenster einlesen (width Fenster-Breite)

###########################################################################################
# DAten lesen/schreiben
##################################################################################
 def read_csv_file(file_name=name,delimiter=";")
 def (state,header,data)=read_csv_file_header_data(file_name,delim=";")
 def write_csv_file_header_data(file_name,csv_header,csv_data,delim=";")
 (okay,data) = read_ascii(file_name=name) entire ascii-text with all carriage return (\n)
 (okay,lines) =  read_ascii_build_list_of_lines(file_name) return(okay,lines) list of lines from ascii-text
 okay = write_ascii(file_name=name,data) write ascii with carriage return (\n)
okay = read_http_file(http_filename,local_filename)
##################################################################################
# Schreiben in HTML-File
##################################################################################
 def html_write_start(f,title) Beginn HTML-Seite
 def html_write_end(f):Ende HTML-Seite
 def html_write_start_tab(f,title) Start Tabelle
 def html_write_end_tab(f) Ende TAbelle
 def html_write_start_colgroup(f): Start Spaltengruppe
 def html_write_end_colgroup(f):Ende Spaltengruppe
 def html_write_set_col_align(f,ausr):Ausrichtung "center","right","left"
 def html_write_start_tab_zeile(f): Zeilenstart einer Tabelle
 def html_write_end_tab_zeile(f): Ende einer Zeile in TAbelle
 def html_write_tab_zelle(f,h_flag,fett_flag,farbe,inhalt): Beschreib eine Zelle in einer Tabellezeile
 def html_write_leer_zeile(f,n_spalten): Leerzeilen über n Spalten
 def html_get_filename_for_browser(filename): Umsetzen für browser

'''

from tkinter import *
#from tkinter.constants import *
import tkinter.filedialog
import tkinter.messagebox
import tkinter.ttk
import string
#import types
#import copy
import sys
import os
#import stat
#import time
#import datetime
#import calendar
import csv
#import array
#import shutil
#import math
#import struct
# import ftfy
#import fnmatch
import codecs
import requests
import locale

#-------------------------------------------------------------------------------
t_path, _ = os.path.split(__file__)
if( t_path == os.getcwd() ):

  import hfkt_type as htype
  import hfkt_def  as hdef
  import hfkt_str  as hstr
else:
  p_list     = os.path.normpath(t_path).split(os.sep)
  if( len(p_list) > 1 ): p_list = p_list[ : -1]
  t_path = ""
  for i,item in enumerate(p_list): t_path += item + os.sep
  if( os.path.normpath(t_path) not in sys.path ): sys.path.append(t_path)

  from tools import hfkt_type as htype
  from tools import hfkt_def  as hdef
  from tools import hfkt_str as hstr
#endif--------------------------------------------------------------------------


KITCHEN_MODUL_AVAILABLE = False

QUOT    = 1
NO_QUOT = 0
TCL_ALL_EVENTS = 0


def abfrage_listbox1(liste,smode):
    """ Listenabfrage Auswahl eines oder mehrere items aus einer Liste
        Beispiel:
        liste       Liste von auszuwählend
        smode       "s" singlemode, nur ein item darf ausgewählt werden
                    "e" extended mehrere items
        Beispiel
        liste = ["Dieter","Roland","Dirk"]
        items = abfrage_listbox1(liste,"s")
        for item in items:
            print "\nName: %s" % liste[item]
    """

    tk = Tk()
    t = slistbox1(tk,liste,smode)

    return t.items

def abfrage_listbox(liste,smode):
    """ Listenabfrage Auswahl eines oder mehrere items aus einer Liste
        Beispiel:
        liste       Liste von auszuwählend
        smode       "s" singlemode, nur ein item darf ausgewählt werden
                    "e" extended mehrere items
        Beispiel
        liste = ["Dieter","Roland","Dirk"]
        items = abfrage_listbox(liste,"s")
        for item in items:
            print "\nName: %s" % liste[item]
    """

    t = slistbox(liste,smode)
    t.mainloop()
    return t.items

def abfrage_liste_scroll(liste,comment=None,cols=70,rows=20,multi=0):
    """ Listenabfrage Auswahl eines items aus einer Liste
        wobei auf dem Bildschirm gescrollt wird (da lange und groß)
        Wenn kein Wert zurückgegeben, dann okay = 0
        Es werden die Werte in einer Liste zurückgegeben, wenn multi=1
        Es können mehrere Werte getrennt mit Komma eingeben werden.
        Es wird nur ein Wert zurückgegeben, wenn multi=0 (default)

        Beispiel:
        liste = (("","Ueberschrift"),
                 ("a","Daten einladen/anlegen"),
                 ("b","Daten speichern"),
                 ("c","Daten speichern"))
        (val,okay) = abfrage_liste(liste,cols=70,rows=20,multi=0)

        EIngabe a   => val = "a", okay = 1

        val = abfrage_liste(liste,cols=70,rows=20,multi=0)
        Eingabe a,c => val = ["a","c"]
        oder Beispiel:
        liste = ("Daten einladen/anlegen",
                 "Daten speichern",
                 "Daten speichern")
        val = abfrage_liste(liste,cols=70,rows=20)

        EIngabe 1   => val = 0, okay = 1

    """
    icount = 0
    if(  not isinstance(liste[0],list) \
      and not isinstance(liste[0],tuple) ):

        nliste = []
        ic     = 0
        for item in liste:
            ic = ic+1
            nliste.append(["%i"%ic,item])
        liste = nliste
##        print "abfrage_liste.error: liste hat nicht das korrekte Format"
##        print liste
##        return None

    # alles in eine Liste formatieren
    lliste = []
    if( comment ):
        t = comment
        while len(t) > 0:
            idum = min(cols,len(t))
            tdum = t[0:idum]
            lliste.append(tdum)
            t    = t[idum:len(t)]

    auswahl_liste = []
    for i in range(len(liste)):

        if( isinstance(liste[i][0], str) ):
            tdum = "%3s" % liste[i][0]
        elif( isinstance(liste[i][0],int) ):
            tdum = "%3i" % liste[i][0]
        elif( isinstance(liste[i][0],float) ):
            tdum = "%3f" % liste[i][0]
        else:
            print("abfrage_liste_scroll.error: liste[i][0] hat nicht das korrekte Format")
            print(liste[i][0])
            return None, 0
        auswahl_liste.append(elim_ae(tdum,' '))
        if( len(tdum) > 0 ):
            tdum = tdum + ":"
        else:
            tdum = tdum + " "

        t = liste[i][1]

        while len(t) > 0:
            if( len(tdum) >= cols ):
                lliste.append(tdum)
                tdum = "    "
            l1 = min(cols-len(tdum),len(t))
            tdum = tdum + t[0:l1]
            t    = t[l1:len(t)]
        lliste.append(tdum)

    end_sign = "e"
    while( end_sign in auswahl_liste ):
        end_sign = end_sign+"e"

    iact = 0
    inp  = "-"
    l1   = len(lliste)
    while( True ):

        if( inp == "+" ):
            iact = min(iact + rows - 1,max(0,l1-rows+1))
        if( inp == "-" ):
            iact = max(0,iact-rows+1)

        ic = iact
        ie = max(min(l1,iact+rows-1),0)
        while( ic < ie ):
            print(lliste[ic])
            ic = ic + 1
        if( l1 > rows-1 ):
            if( multi ):
                inp = input("<+,-,"+end_sign+",Wert(e)(,)> : ")
            else:
                inp = input("<+,-,"+end_sign+",Wert> : ")
        else:
            if( multi ):
                inp = input("<"+end_sign+",Wert(e)(,)> : ")
            else:
                inp = input("<"+end_sign+",Wert> : ")

        if( inp == end_sign ):
            return None, 0

        if( not(l1 > rows-1 and (inp == "+" or inp == "-")) ):
            if( multi ):
                linp = inp.split(",")
                liste = []
                for inp in linp:
                    if( inp in auswahl_liste and len(inp) > 0):
                        for i in range(len(auswahl_liste)):
                            if( inp == auswahl_liste[i] ):
                                liste.append(inp)
                if( len(liste) > 0 ):
                    return liste, 1
            else:
                if( inp in auswahl_liste and len(inp) > 0 ):
                    for i in range(len(auswahl_liste)):
                        if( inp == auswahl_liste[i]):
                            return inp, 1

def abfrage_liste(liste,comment=None):
    """ Listenabfrage Auswahl eines items aus einer Liste
        Beispiel:
        liste = (("0","Daten einladen/anlegen"),
                 ("1","Daten speichern"),
                 ("","Ist nur Kommenatr"))
        val = abfrage_liste(liste)
    """
    icount = 0
    if(  not isinstance(liste[0],list) \
      and not isinstance(liste[0],tuple) ):

        print("abfrage_liste.error: liste hat nicht das korrekte Format")
        print(liste)
        return None
    else:
        print(" ")
        if( comment ):
            print(comment)
            print(" ")
        while icount < 10:
            icount = icount + 1
            for i in range(0,len(liste),1):

                if( isinstance(liste[i][0], str)  ):
                    print("%3s  %s" % (liste[i][0],liste[i][1]))
                elif( isinstance(liste[i][0], int) ):
                    print("%3i  %s" % (liste[i][0],liste[i][1]))
                elif( isinstance(liste[i][0], float) ):
                    print("%3f  %s" % (liste[i][0],liste[i][1]))
                else:
                    print("abfrage_liste.error: liste[i][0] hat nicht das korrekte Format")
                    print(liste[i][0])
                    return None

            x = input("\nAuswahl : ")

            if( len(x) > 0 ):

                for i in range(0,len(liste),1):

                    if( isinstance(liste[i][0], str) ):
                        if x == liste[i][0]:
                            return x
                    elif( isinstance(liste[i][0], int) ):
                        if int(x) == liste[i][0]:
                            return int(x)
                    elif( isinstance(liste[i][0], float) ):
                        if( abs(float(x)-liste[i][0]) < 1.0e-10 ):
                            return float(x)

            print("\nFalsche Eingabe: %s " % x)
        return None
    return None

def eingabe_int(comment):
    """ Eingabe von einem int-Wert mit Kommentar abgefragt """
    ival = int(0)
    io_flag = 0
    c = comment+" : "
    while( io_flag == 0 ):
        x = input(c)
        if( len(x) == 0 ):
            ival = int(0)
        else:
            try:
                ival = int(x)
                io_flag = 1
            except ValueError:
                print("\n Falsche Eingabe, nochmal !!!")

    return ival
def eingabe_string(comment):
    """ Eingabe von string-Wert mit Kommentar abgefragt """
    strval = ""
    io_flag = 0
    c = comment+" : "
    while( io_flag == 0 ):
        x = input(c)
        if( len(x) > 0 ):
            try:
                strval = x
                io_flag = 1
            except ValueError:
                print("\n Falsche Eingabe, nochmal !!!")

    return strval
def eingabe_float(comment):
    """ Eingabe von einem float-Wert mit Kommentar abgefragt """
    fval = float(0)
    io_flag = 0
    c = comment+" : "
    while( io_flag == 0 ):
        x = input(c)
        if( len(x) == 0 ):
            fval = float(0)
        else:
            try:
                fval = float(x)
                io_flag = 1
            except ValueError:
                print("\n Falsche Eingabe, nochmal !!!")

    return fval

def eingabe_jn(comment,default=None):
    """ Eingabe von einem ja oder nein-Wert mit Kommentar abgefragt
        comment: Kommentar
        default: True oder "ja", False oder "nein"
        Rückgabe True (ja) oder False (nein)
    """
    if( default != None ):
        if( isinstance(default, bool) ):
            if( default ):
                def_sign = 'j'
            else:
                def_sign = 'n'
        elif( isinstance(default, str) ):
            if( default[0] == 'j' or default[0] == 'J' or \
                default[0] == 'y' or default[0] == 'Y' ):
                def_sign = 'j'
            else:
                def_sign = 'n'
        else:
            def_sign = 'n'

    if( default != None ):
        frage = "j/n <def:%s> : " % def_sign
    else:
        frage = "j/n : "

    io_flag = 0
    while( io_flag == 0 ):
        print(comment)
        x = input(frage)
        if( len(x) == 0 ):
            if( default != None ):
                x = def_sign
            else:
                x = 'p'
        if( x[0] == 'j'  or x[0] == 'J' or \
            x[0] == 'y' or x[0] == 'Y' ):

            erg = True
            io_flag = 1
        elif( x[0] == 'n'  or x[0] == 'N' ):
            erg = False
            io_flag = 1
        else:
            print("\n Falsche Eingabe, nochmal !!!")

    return erg
#===============================================================================
def abfrage_ok_box(text="Ist das okay"):
    ''' Fragt nach einem Ja für Okay
        return True, wenn okay (ja)
        return False, wenn nicht okay (nein)
    '''
    ans = tkinter.messagebox.askyesno(title='OkBox', message=text)

    return ans

def abfrage_dir(comment=None,start_dir=None):
    """ gui für Pfad auszuwählen """
##    import tkinter.messagebox, traceback, tkinter.ttk
##
##    global dirlist
##
##    dirname = None
##
##    if( not start_dir ):
##        start_dir = abfrage_root_dir()
##
##    try:
##        root=tkinter.ttk.Tk()
##        dirlist = DirList(root,start_dir,comment)
##        dirlist.mainloop()
##
##        if( dirlist.quit_flag ):
##            dirlist.destroy()
##            return None
##
##        if( dirlist.dlist_dir == "" ):
##            dirname = None
##        else:
##            dirname = dirlist.dlist_dir+"\\"
##        dirlist.destroy()
##
##        if(dirname and not os.path.exists(dirname) ):
##
##            comment = "Soll das Verzeichnis <%s> angelegt werden??" % dirname
##            if( abfrage_ok_box(comment) ):
##                os.makedirs(dirname)
##            else:
##                dirname = None
##
##        return dirname
##    except:
##        t, v, tb = sys.exc_info()
##        dirname = None
##        text = "Error running the demo script:\n"
##        for line in traceback.format_exception(t,v,tb):
##            text = text + line + '\n'
##            d = tkinter.messagebox.showerror ( 'tkinter.ttk Demo Error', text)
##    return dirname
    root = Tk()
    dir = tkinter.filedialog.askdirectory(master=root, title=comment, initialdir=start_dir)
    root.destroy()
    dir = change(dir,"/",os.sep)
    return dir
def abfrage_sub_dir(comment=None,start_dir=None):
    """ gui für Unterpfad von start_dir auszuwählen """
    import tkinter.messagebox, traceback, tkinter.ttk

    global dirlist

    if( not os.path.exists(start_dir) ):

        print("Das angegebene Start-Verzeichnis <%s> exsistiert nicht !!!" % start_dir)
        return None

    dirname = None
    dir_not_found = True
    while dir_not_found :
        try:
            root=tkinter.ttk.Tk()
            dirlist = DirList(root,start_dir,comment,True)
            dirlist.mainloop()

            if( dirlist.quit_flag ):
                dirlist.destroy()
                return None

            if( dirlist.dlist_dir == "" ):
                dirname = None
            else:
                dirname = dirlist.dlist_dir+"\\"
            dirlist.destroy()
        except:
            t, v, tb = sys.exc_info()
            dirname = None
            text = "Error running the demo script:\n"
            for line in traceback.format_exception(t,v,tb):
                text = text + line + '\n'
                d = tkinter.messagebox.showerror ( 'tkinter.ttk Demo Error', text)

        dirname = change_max(dirname,"/","\\")

        if( (not os.path.exists(dirname))           or \
            (not dirname)                           or \
            (such(string.lower(dirname),          \
                  string.lower(start_dir),"vs") != 0) ):

            print("Verzeichnis <%s> liegt nicht in der start_dir <%s>" \
                  % (dirname,start_dir))
        else:
            dir_not_found = False


    return dirname
##def abfrage_root_dir():
##    """
##        abfrage_root_dir: welche root-dir will man
##        erstellt erst ein Liste möglicher root-dirs (aber nur mit einem Buchstaben)
##        und fragt nach der gewünschten
##    """
##    abc_str ="abcdefghijklmnopqrstuvwxyz"
##    liste = []
##    for i in range(len(abc_str)):
##        item = abc_str[i]+":"
##        if( os.path.isdir(item)):
##            liste.append(item)
##    if( len(liste) > 0 ):
##        item = abfrage_listbox(liste,"s")
##    else:
##        item = None
##
##    return item
def abfrage_file(file_types="*.*",comment=None,start_dir=None,default_extension=None,file_names=None):
    """
    filename = abfrage_file (FileSelectBox) um ein bestehendes Fiele einzuladen mit folgenden Parameter
    file_types = ["*.c","*.h"]      Filetypen (auch feste namen möglich "abc.py")
    comment    = "Suche Datei"  Windows Leisten text
    start_dir  = "d:\\abc"	Anfangspfad
    default_extension = "txt"
    file_names = ["C-Files","H-Files"]

    """
##    root = tkinter.ttk.Tk()
##    f = SFileSelectBox(root,file_types,comment,start_dir)
##    f.mainloop()
##    f.destroy()
##    return f.SELECTED_FILE

    if( default_extension and such(default_extension,".","vs") != 0 ):
        default_extension = "."+default_extension


    if( isinstance(file_types, str) ):
        file_types = [file_types]

    format_liste = []
    if( file_names and isinstance(file_names, str)  ):
        file_names = [file_names]
    for i in range(len(file_types)):
        if( file_names and i < len(file_names) ):
            format_liste.append([file_types[i],file_names[i]])
        else:
            format_liste.append((file_types[i],file_types[i]))

    root = Tk()
    name = tkinter.filedialog.askopenfilename(master=root,
                                        defaultextension=default_extension,
                                        filetypes=format_liste,
                                        initialdir=start_dir,
                                        title=comment)
    root.destroy()
    name = change(name,"/",os.sep)

    return name
def eingabe_file(file_types="*",comment="Waehle oder benenne neue Datei",start_dir=None):
    """
    eingabe_file (FileSelectBox) um ein neues File zu generieren
                                mit folgenden Parameter
    file_types = "*.c *.h"      Filetypen (auch feste namen möglich "abc.py")
    start_dir  = "d:\\abc"	Anfangspfad
    comment    = "Suche Datei"  Windows Leisten text
    """
    selected_file = None
    count = 0
    while( count < 10 ):
        count = count + 1
        root = tkinter.ttk.Tk()
        f = SFileSelectBox(root,file_types,comment,start_dir)
        f.mainloop()
        f.destroy()
        print(f.SELECTED_FILE)
        selected_file = f.SELECTED_FILE
        del f


        if( os.path.exists(selected_file) ):

            if( abfrage_ok_box(text="Die Datei <%s> existiert bereits" % selected_file) == hdef.OK ):
                return selected_file
        else:
            return selected_file

def abfrage_str_box(comment="",width=400):
    root = tkinter.ttk.Tk()

    geotext = str(max(width,300))+"x90"
    root.geometry(geotext)
    f = SStringBox(root,comment)
    f.mainloop()
    f.destroy()
    return f.SELECTED_STRING

###########################################################################################
# DAten lesen
##################################################################################
def read_csv_file(file_name,delim=";"):
    liste = []
    if( os.path.isfile(file_name) ):
        
        flag = 0
        with codecs.open(file_name,'r',encoding='utf-8') as f:
            try:
                lines = f.read()
                index = hstr.such(lines, "\r\n")
                if index >= 0:
                    line_liste = lines.split("\r\n")
                else:
                    line_liste = lines.split("\n")
                    line_liste = hstr.split_text(lines, "\n")
                # end if
                f.close()
                flag = 1
            except:
                f.close()
            if flag == 1:
                while len(line_liste[-1]) == 0:
                    del line_liste[-1]
                # end if
                n = len(line_liste)
                i = 0
                while i < n:
                    line = hstr.change(line_liste[i],'\ufeff','')
                    # line = hstr.elim_e(line,'\n')
                    abostroph_liste = hstr.such_alle(line, "\"")
                    
                    while (len(abostroph_liste) % 2 != 0) and (i + 1 < n):
                        i = i + 1
                        # line += hstr.elim_e(line_liste[i],'\n')
                        line += line_liste[i]
                        abostroph_liste = hstr.such_alle(line, "\"")
                    # end if
                    
                    row = hstr.split_text(line, delim)
                    
                    liste.append(row)
                    i = i + 1
                # end while
            # end if
        # end with
        if flag == 0:
            with open(file_name, newline='') as csvfile:
                try:
                    spamreader  = csv.reader(csvfile, delimiter=delim, quotechar='"')
                    for row in spamreader:
                        liste.append(row)
                    flag = 1
                except:
                    raise Exception("Problem read_csv_file() ")
                # end try
            # end with
        # end if

    # end if
    # reader = csv.reader(open(file_name, "rb"), delimiter=delim, quoting=csv.QUOTE_MINIMAL)
    # try:
    #     for row in reader:
    #         liste.append(row)

    # except csv.Error:
    #     sys.exit('file %s, line %d: %s' % (file_name, reader.line_num))

    return liste
def read_csv_file_header_data(file_name,delim=";"):
    ''' (NOT_OK, csv_header, csv_data)=read_csv_file_header_data(file_name,delim=";")
        csv_header = ['name1','name2',...]
        csv_data   = [[val_name1_zeile1,val_name2_zeile1,...],[val_name1_zeile2,val_name2_zeile2,...],...]
    '''
    csv_header = []
    csv_data = []
    if(os.path.isfile(file_name)):

        csv_liste = read_csv_file(file_name, delim)

        if(len(csv_liste) < 2):
            print("csv Datei <%s> zu klein (1. Zeile Header, weitere Zeilen Vokabeln)" % file_name)
            return (hdef.NOT_OK, csv_header, csv_data)
        # header separieren
        csv_header = csv_liste[0]
        n = len(csv_header)
        # Alle Spalten so groß wie header line
        csv_data = []
        for i in range(1, len(csv_liste), 1):
            row = csv_liste[i]
            m = len(row)
            if(m > n):
                del row[n:m]
            elif(m < n):
                for j in range(m, n, 1):
                    row.append("")
            csv_data.append(row)
    else:
        print("DAtei nicht vorhanden <%s>" % file_name)
        return (hdef.NOT_OK, csv_header, csv_data)

    return (hdef.OK, csv_header, csv_data)

def write_csv_file_header_data(file_name,csv_header,csv_data,delim=";"):
    ''' Write DAta with
        csv_header = ['name1','name2',...]
        csv_data   = [[val_name1_zeile1,val_name2_zeile1,...],[val_name1_zeile2,val_name2_zeile2,...],...]
        in file as

        name1;name2
        val_name1_zeile1;val_name2_zeile1
        val_name1_zeile2;val_name2_zeile2

        return hdef.OK/NOT_OKAY

    '''
    with open(file_name, 'w') as f:
    
        n = len(csv_header)
        for i in range(n):
          f.write(str(csv_header[i]))
          if( i+1 < n ):
            f.write(delim)
          else:
            f.write("\n")
        for line in csv_data:
          n = len(line)
          for i in range(n):
            f.write(str(line[i]))
            if( i+1 < n ):
              f.write(delim)
            else:
              f.write("\n")
    
    return hdef.OK
# end def
def write_csv_file_ttable(file_name,ttable,delim=";"):
    ''' Write DAta with ttable from hfkt_tvar

    '''
    
    return write_csv_file_header_data(file_name,ttable.names,ttable.table,delim)
# end def

def read_ascii_build_list_of_lines(file_name):

    (okay,txt) = read_ascii(file_name)

    lines = []
    if( okay):

        index = hstr.such(txt, "\r\n")
        if index >= 0:
            line_list = txt.split("\r\n")
        else:
            line_list = hstr.split_text(txt, "\n")
            # index = hstr.such(txt, "\n\n")
            # if index >= 0:
            #     line_list = txt.split("\n\n")
            # else:
            #     line_list = hstr.split_text(txt, "\n")
            # # end if
        # end if
        n = len(line_list)
        while (n > 0 ) and (len(line_list[-1]) == 0):
            del line_list[-1]
            n = len(line_list)
        # end while
        n = len(line_list)
        i = 0
        while i < n:
            line = hstr.change(line_list[i], '\ufeff', '')

            # line = hstr.elim_e(line,'\n')
            lines.append(line)
            i = i + 1
        # end while
    # end if

    return (okay,lines)

def read_ascii(file_name):
    okay  = hdef.NOT_OK
    data = ""

    if( os.path.isfile(file_name) ):

        with open(file_name, mode='r', encoding='utf-8') as f:
            try:
                data = f.read()
                okay = hdef.OK
            except:
                okay = hdef.NOT_OKAY
        # end with
        if okay != hdef.OK:
            with codecs.open(file_name, 'r', encoding='utf-8') as f:
                try:
                    data = f.read()
                    f.close()
                    okay = hdef.OK
                except:
                    f.close()
            # end with
        # end if
        if okay != hdef.OK:
            with open(file_name) as f:
                try:
                    data = f.read()
                    okay = hdef.OK
                except:
                    okay = hdef.NOT_OKAY
            # end with

    else:
        print("Datei: "+file_name+" besteht nicht !!!")
    #endif
    return (okay,data)
# end def
def write_ascii(file_name,data,preferred_encoding=None):
    """
     write ascii with carriage return (\n)
    """
    okay  = hdef.OK

    if not preferred_encoding:
        preferred_encoding = locale.getpreferredencoding()

    if( htype.is_list(data) ):

        try:
            with open(file_name, mode='w', encoding=preferred_encoding) as f:
                for line in data:
                    f.write(line)
                    f.write('\n')
                #endfor
            #endwith
        except:
            okay = hdef.NOT_OK

    else:
        try:
            with open(file_name, mode='w', encoding=preferred_encoding) as f:
                f.write(data)
            #endwith
        except:
            okay = hdef.NOT_OK

    #endif
    return okay
# end def
def read_http_file(http_filename,local_filename):
    """

    :param http_filename:
    :param local_filename:
    :return: okay = read_http_file(http_filename,local_filename)
    """
    # Bild von der URL herunterladen
    response = requests.get(http_filename)

    # Überprüfen, ob der Abruf erfolgreich war (Status Code 200)
    if response.status_code == 200:
        # Bild im "Write Binary" Modus ('wb') speichern
        with open(local_filename, 'wb') as f:
            f.write(response.content)
        okay = hdef.OK
    else:
        okay = hdef.NOT_OKAY
    # end if
    return okay
# end def
def exist_http_file(http_filename):
    """

    :param http_filename:
    :return: okay = exist_http_file(http_filename)
    """
    # Bild von der URL herunterladen
    response = requests.get(http_filename)

    # Überprüfen, ob der Abruf erfolgreich war (Status Code 200)
    if response.status_code == 200:
        okay = hdef.OK
    else:
        okay = hdef.NOT_OKAY
    # end if
    return okay
# end def
##################################################################################
# Schreiben in HTML-File
##################################################################################
def html_write_start(f,title):

    if( f.closed != 1 ):
        f.write("<!DOCTYPE html>")
        # f.write("\n<html>\n<head>\n<meta charset=\"utf-8\">\n<title>")
        f.write("\n<html>\n<head>\n<title>")
        f.write(text_to_write(title))
        f.write("</title>\n</head>")
def html_write_end(f):

    if( f.closed != 1 ):
        f.write("\n</html>\n")

def html_write_Ueberschrift(f,text,size=100,font='verdana'):
    if( f.closed != 1 ):
         tt = "\n<body><h1 style=\"font-size:%i%%;font-family:%s;\">%s</h1></body>" % (size,font,text)
         f.write(text_to_write(tt))
def html_write_text(f,text,size=100,font='verdana'):
    if( f.closed != 1 ):
        tt = "\n<body><p style=\"font-size:%i%%;font-family:%s;\">%s</p></body>" % (size,font,text)
        f.write(text_to_write(tt))

def html_write_start_tab(f,title):

    if( f.closed != 1 ):

        f.write("\n\n<body>")

        if( len(title) > 0 ):
            tt = "\n<h1><font size=\"3\">%s</font></h1>" % title
            f.write(text_to_write(tt))

        f.write("\n\n<table border=1 cellspacing=0 cellpadding=0 style='border-collapse:collapse;border:none;'>")

def html_write_end_tab(f):

    if( f.closed != 1 ):
        f.write("\n\n</table>\n</body>")

def html_write_start_colgroup(f):
    if( f.closed != 1 ):
        f.write("\n<colgroup>")

def html_write_end_colgroup(f):
    if( f.closed != 1 ):
        f.write("\n</colgroup>")

def html_write_set_col_align(f,ausr):

    if( ausr[0] == "c" or ausr[0] == "C" ):
        name = "center"
    elif( ausr[0] == "r" or ausr[0] == "R" ):
        name = "right"
    else:
        name = "left"

    if( f.closed != 1 ):
        f.write("\n\n  <col align=\"%s\">" % name)



def html_write_start_tab_zeile(f):
    """ Zeilenstart einer Tabelle
        f               file-Objekt
    """


    if( f.closed != 1 ):
        f.write("\n\n  <tr>")

def html_write_end_tab_zeile(f):

    if( f.closed != 1 ):
        f.write("\n  </tr>")

def html_write_tab_zelle(f,h_flag,fett_flag,farbe,inhalt):
    """ Beschreib eine Zelle in einer Tabellezeile:
        f file-objekt
        h_flag      1/0     Headerflag
        fett_flag   1/0     Fett drucken
        farbe       string  black (def), red, blue, green, yellow, ...
        inhalt      string  Zelleninhalt, Trennung mit \n wird beachtet
    """

    if( h_flag != 0 ):
        tstr = "th"
    else:
        tstr = "td"

    if( len(farbe) == 0 ):
        farbe = "black"


    if( f.closed != 1 ):
        # start
        f.write(("\n    <%s style='border:solid windowtext 2 pt;'>" % tstr))
        # font
        f.write(("<font color=\"%s\">" % farbe))
        # fett
        if( fett_flag != 0 ):
            f.write("<b>")
        # inhalt in Zeile aufteilen
        inhalt1 = convert_to_unicode(inhalt)
        words = inhalt1.split("\n")
        n_words = len(words)
        i_words = 0
        #### Das muss noch besser gemacht werden
        for word in words:
            i_words += 1
            try:
                f.write(word)
            except:

                for w in word:
                    try:
                        f.write(w)
                    except:
                        f.write('|')
               # w= word.encode('utf-8')
               # f.write(w)

            if( i_words < n_words ):
                f.write("<br>")
        # end fett
        if( fett_flag != 0 ):
            f.write("</b>")
        # end font
        f.write("</font>")
        # end
        f.write(("</%s>" % tstr))

def html_write_leer_zeile(f,n_spalten):

    html_write_start_tab_zeile(f)

    for i in range(1,n_spalten,1):
        html_write_tab_zelle(f,0,0,"black","")

    html_write_end_tab_zeile(f)

def html_get_filename_for_browser(filename):

  return "file:///"+change_max(filename,'\\','/')

###########################################################################
# testen mit main
###########################################################################
if __name__ == '__main__':



    okay = read_http_file(http_filename,local_filename)