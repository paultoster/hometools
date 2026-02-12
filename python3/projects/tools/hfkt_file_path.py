# -*- coding: utf8 -*-
#
# 18.06.23 von hfkt.py
#############################

###################################################################################
# Fileoperating
###################################################################################

'''
 def get_free_size(path): freie Größe Verzeichnis
 def get_parent_path_files(path): dir auf parent path and get files
 def get_parent_path_dirs(path): dir auf parent path and get dirs
 def get_dattime_float(full_filename): gibt int-Wert für datum und zeit jjjjmmtthhmmss
 get_subdir_files(path):  Kann in Iteration genutzt werden >>> for a in get_subdir_files("D:\\temp")
 file_liste = get_liste_of_subdir_files(Path,liste=[],search_ext=[]):Gibt eine Liste von allen Dateien in Unterverzeichnissen an (ext kann angegeben werden), liste als input wird weiter gefüllt
 def get_liste_of_subdir_files(Path,liste=[],search_ext=[],exlude_main_path=True): Exlude Path for search
 def get_liste_of_subdirs(Path,liste=[]):Gibt eine Liste von allen Unterverzeichnissen an liste=get_liste_of_subdirs(path1,[])
 def get_liste_of_files_in_dir(DirName,extensionListe=[],subdirFlag=0,liste=[]) Sucht nach Dateien mit der angegbene extension (default alle)
                                                                                trägt sie in die Liste ein, und untersucht auch subdirs (default nicht)
                                                                                Rückgabe der Liste
 def get_size_of_dir(Path,size=0): Gibt Größe des gesamten Unterverzeichnispfad an
 def join(part0="",part1="",part2="",part3="",part4="",part5=""):Setzt Dateiname zusammen
 (path,fbody,ext) = get_pfe(full_file): Gibt Pfad,Filebody und Extension zurück
 fullfilename = set_pfe(path,filebody,ext)
 fullfilename = set_pfe(path,filename)
 leaves_path_name = get_path_leaves(full_path_name,root_path_name)
 def remove_dir_all(dir_name): Löscht den Pfad
 def remove_named_dir(dir_name,delete_name,recursive): Loescht von dir_name die Ordber delete_name rekursiv oder nicht weg
 def is_textfile(filename, blocksize = 512) checks if file is an text-file
 def copy(s_path_filename,t_path_filename,silent=1)  kopiert s_path_filename nach t_path_filename return hfkt.OK=1
 def make_backup_file(fullfilename,backup_dir)
 def move_file(filename,target)
 def change_text_in_file(filename,textsearch,textreplace):
 def build_path(pathname): erstellt Pfad wenn nicht vorhanden
 def clear_path(pathname): löscht Inhalt des Pfades
 def find_file_pattern(pattern, path): find_file_pattern(pattern, path) returns a list of file: find('*.txt', 'D:\\temp') => ["D:\\temp\\filea.txt","D:\\temp\\filea.txt"]
 def get_last_subdir_name(fullpathname): gebe letzte Ebene des Unterpfadsnamen zurück
 def file_split(file_name): ZErlegt file_name in path,body,ext
                                file_name = "d:\\abc\\def\\ghj.dat"
                                (path,body,ext)   = file_split(file_name)
                                path      = "d:\\abc\\def"
                                body      = "ghj"
                                ext       = "dat"

liste = build_list_from_path(path_name)
path = build_path_with_forward_slash(path_name)
path = build_path_from_list_with_forward_slash(p_list)
fullpath = get_abs_dir(rel_dir,base_dir)
rel_dir = get_rel_dir(target_dir,abs_dir)
'''

# from tkinter import *
# from tkinter.constants import *
# import tkinter.filedialog
# import tkinter.messagebox
# import tkinter.tix
import string
# import types
import copy
import sys
import os
import stat
import time
# import datetime
# import calendar
import array
import shutil
# import math
# import struct
import fnmatch

# -------------------------------------------------------------------------------
t_path, _ = os.path.split(__file__)
if (t_path == os.getcwd()):
    
    import hfkt_str as hstr
    import hfkt_def as hdef
else:
    p_list = os.path.normpath(t_path).split(os.sep)
    if (len(p_list) > 1): p_list = p_list[: -1]
    t_path = ""
    for i, item in enumerate(p_list): t_path += item + os.sep
    if (os.path.normpath(t_path) not in sys.path): sys.path.append(t_path)
    
    from tools import hfkt_str as hstr
    from tools import hfkt_def as hdef

# endif--------------------------------------------------------------------------


KITCHEN_MODUL_AVAILABLE = False

OK = hdef.OKAY
NOT_OK = hdef.NOT_OKAY
QUOT = 1
NO_QUOT = 0
TCL_ALL_EVENTS = 0


###################################################################################
# Fileoperating
###################################################################################
def is_file_type(file_type_list, file_name):
    return 0


def get_free_size(path):
    """ Gibt freie Groesse des Verzeichnis path in byte (int) an
    """
    if os.path.isdir(path):
        # print "test ",path
        dirlist = os.popen('dir ' + path).read()
        if (len(dirlist) == 0):
            print('Der Pfad <', path, '> ist nicht richtig')
            return 0
        liste = dirlist.split()
        # print liste
        t = liste[-3].replace('.', '')
        freesize = int(liste[-3].replace('.', ''))
        return freesize
    else:
        print("Der Pfad <", path, "> existiert nicht")
        return 0


def get_parent_path(pp):
    p = os.path.normpath(pp)
    
    ll = p.split('\\')
    
    n = len(ll)
    if (n > 1): n -= 1
    
    parent_dir = ''
    for i in range(n):
        parent_dir += ll[i]
        if (i < n - 1): parent_dir += '\\'
    # endFor
    return parent_dir


def get_parent_path_files(pp, name_only=0):
    """
    liste_of_fullfiles  = get_parent_path_files(path)
    liste_of_files      = get_parent_path_files(path,1)
    dir auf parent path and get files
    """
    liste = []
    if (os.path.isdir(pp)):
        
        parent_dir = get_parent_path(pp)
        
        dirlist = os.listdir(parent_dir)
        
        for basename in dirlist:
            name = os.path.join(parent_dir, basename)
            if (os.path.isfile(name)):
                if (name_only):
                    liste.append(basename)
                else:
                    liste.append(name)
            # endIf
        # endFor
    # endIf
    return liste


def get_parent_path_dirs(pp, name_only=0):
    """
    liste_of_dirs  = get_parent_path_dirs(path)
    liste_of_names = get_parent_path_dirs(path,1)
    dir auf parent path and get dirs
    """
    liste = []
    if (os.path.isdir(pp)):
        
        parent_dir = get_parent_path(pp)
        
        dirlist = os.listdir(parent_dir)
        
        for basename in dirlist:
            name = os.path.join(parent_dir, basename)
            if (os.path.isdir(name)):
                if (name_only):
                    liste.append(basename)
                else:
                    liste.append(name)
            # endIf
        # endFor
    # endIf
    return liste


def get_dattime_float(full_filename):
    """ gibt int-Wert für datum und zeit jjjjmmtthhmmss
    """
    dattime = 0
    if os.path.isfile(full_filename):
        t = time.gmtime(os.path.getmtime(full_filename))
        dattime = t[0] * 1e10 + t[1] * 1e8 + t[2] * 1e6 + t[3] * 1e4 + t[4] * 1e2 + t[5]
    
    return dattime


class get_subdir_files:
    def __init__(self, *rootDirs):
        self.dirQueue = list(rootDirs)
        self.includeDirs = None
        self.fileQueue = []
    
    def __getitem__(self, index):
        while len(self.fileQueue) == 0:
            self.nextDir()
        result = self.fileQueue[0]
        del self.fileQueue[0]
        return result
    
    def nextDir(self):
        dir = self.dirQueue[0]  # fails with IndexError, which is fine
        # for iterator interface
        del self.dirQueue[0]
        list = os.listdir(dir)
        join = os.path.join
        isdir = os.path.isdir
        for basename in list:
            fullPath = join(dir, basename)
            if isdir(fullPath):
                self.dirQueue.append(fullPath)
                if self.includeDirs:
                    self.fileQueue.append(fullPath)
            else:
                self.fileQueue.append(fullPath)


def get_liste_of_subdir_files(Path, liste=[], search_ext=[], exlude_main_path=False):
    """ Gibt eine Liste von allen Dateien in Unterverzeichnissen an
        trägt Ergebnis in liste ein un gibt sie zurück
        liste kann vorggeben werden
        liste = get_liste_of_subdir_files("d:\\abc"):
        oder
        vorgegebene_liste = get_liste_of_subdir_files("d:\\abc",vorgegebene_liste):
        oder
        liste = get_liste_of_subdir_files("d:\\abc",search_ext='mp3'): Alle mp3-Datein
        oder
        liste = get_liste_of_subdir_files("d:\\abc",search_ext=['mp3','wav']): Alle mp3- und wav-Datein

        liste = get_liste_of_subdir_files("d:\\abc",search_ext=['mp3','wav'],exlude_main_path=True):
                Alle mp3- und wav-Datein, aber nicht in d:\\abc

    """
    if (isinstance(search_ext, str)):
        search_ext = [search_ext]
    
    if (exlude_main_path):
        dirlist = get_liste_of_subdirs(Path, [])
    else:
        dirlist = os.listdir(Path)
    
    dirlist = os.listdir(Path)
    join = os.path.join
    isdir = os.path.isdir
    for basename in dirlist:
        fullPath = join(Path, basename)
        if isdir(fullPath):
            liste = get_liste_of_subdir_files(fullPath, liste, search_ext)
        else:
            if (len(search_ext) == 0):
                liste.append(fullPath)
            else:
                for extsearch in search_ext:
                    ext = hstr.search_file_extension(fullPath)
                    if (extsearch == ext):
                        liste.append(fullPath)
    return liste


def get_liste_of_files_in_dir(DirNameListe, extensionListe=[], subdirFlag=0, liste=[]):
    """ Sucht nach Dateien mit der angegbene extension (default alle),
        trägt sie in die Liste ein, und untersucht auch subdirs (default nicht)
        Rückgabe der Liste
    """
    if (isinstance(DirNameListe, str)):
        DirNameListe = [DirNameListe]
    if (isinstance(extensionListe, str)):
        extensionListe = [extensionListe]
    
    for DirName in DirNameListe:
        
        if (not os.path.isdir(DirName)):
            print("DirName <%s> ist nicht vorhanden !!!!!!!" % DirName)
            return liste
        
        dirlist = os.listdir(DirName)
        for basename in dirlist:
            fullPath = os.path.join(DirName, basename)
            if (subdirFlag and os.path.isdir(fullPath)):
                liste = get_liste_of_files_in_dir(fullPath, extensionListe, subdirFlag, liste)
            elif (os.path.isfile(fullPath)):
                (body, ext) = file_splitext(basename)
                flag = 0
                if (len(extensionListe) == 0):
                    flag = 1
                else:
                    for e in extensionListe:
                        if (e == "*"):
                            flag = 1
                        elif (ext == e):
                            flag = 1
                
                if (flag == 1):
                    liste.append(fullPath)
    
    return liste


def get_liste_of_subdirs(Path, liste=[], include_start_dir=0):
    """ Gibt eine Liste von allen Unterverzeichnissen an
        trägt Ergebnis in liste ein un gibt sie zurück
        liste kann vorggeben werden
        liste = get_liste_of_subdir_files("d:\\abc"):
        oder
        vorgegebene_liste = get_liste_of_subdir_files("d:\\abc",vorgegebene_liste):
    """
    
    if (include_start_dir):
        liste.append(Path)
    
    dirlist = os.listdir(Path)
    join = os.path.join
    isdir = os.path.isdir
    for basename in dirlist:
        fullPath = join(Path, basename)
        if isdir(fullPath):
            liste.append(fullPath)
            liste = get_liste_of_subdirs(Path=fullPath, liste=liste, include_start_dir=0)
    return liste


def get_size_of_dir(Path, size=0):
    """ Gibt Größe des gesamten Unterverzeichnispfad an
        get_size_of_dir(Path_name)
    """
    
    list = os.listdir(Path)
    join = os.path.join
    isdir = os.path.isdir
    for basename in list:
        fullPath = join(Path, basename)
        if isdir(fullPath):
            size = get_size_of_dir(fullPath, size)
        else:
            size = size + os.path.getsize(fullPath)
    return size


def join(part0="", part1="", part2="", part3="", part4="", part5=""):
    """ Setzt Dateiname zusammen aus maximal 6 Teilen
        fname = join("f:\\def","\\abc.dat")
    """
    list = []
    if (len(part0) > 0): list.append(part0)
    if (len(part1) > 0): list.append(part1)
    if (len(part2) > 0): list.append(part2)
    if (len(part3) > 0): list.append(part3)
    if (len(part4) > 0): list.append(part4)
    if (len(part5) > 0): list.append(part5)
    
    slist = []
    platzhalter = "263gw1?)81++++"
    platzhalterflag = False
    for item in list:
        
        if (item.find("//") > -1):
            platzhalterflag = True
            item = hstr.change_max(item, "//", platzhalter)
        
        list0 = item.split("/")
        for item0 in list0:
            
            list1 = item0.split(string.punctuation[23])  # "\\"
            
            for item1 in list1:
                
                if (len(item1) > 0): slist.append(item1)
    
    ret_text = ""
    for isl in range(len(slist)):
        
        if (isl == 0):
            ret_text = slist[isl]
        else:
            ret_text = ret_text + os.sep + slist[isl]
    
    if (platzhalterflag):
        ret_text = hstr.change_max(ret_text, platzhalter, "//")
    return ret_text


def set_pfe(path, filebody, ext=None):
    if (ext == None):
        filename = filebody
    else:
        if (ext[0] == '.'):
            filename = filebody + ext
        else:
            filename = filebody + '.' + ext
        # endif
    # endif
    
    return join(path, filename)


def get_pfe(full_file):
    """ Gibt Pfad, Filebody und Extension zurück
        (path,fbody,extension) = get_pfe("d:\\abc.dat")
    """
    ext = ""
    fbody = ""
    path = ""
    
    if (not isinstance(full_file, str)):
        full_file = str(full_file)
    # endif
    
    if (full_file and len(full_file) > 0):
        
        iex = full_file.rfind('.')
        if (iex > -1 and iex < len(full_file)):
            ext = full_file[iex + 1:]
            rest = full_file[0:iex]
        else:
            ext = ""
            rest = full_file
        
        rest = join(rest, os.sep)
        
        ipath = rest.rfind(os.sep)
        if (ipath > -1):
            
            if (ipath + 1 < len(rest)):
                
                path = rest[0:ipath + 1]
                fbody = rest[ipath + 1:]
            else:
                path = rest
                fbody = ""
        else:
            
            path = ""
            fbody = rest
    
    return path, fbody, ext


def set_pfe(p="", b="", e=""):
    """

    :param p: path
    :param b: bodyname
    :param e: extention
    :return: full_file_name
    """
    if (len(p)):
        full_file_name = p
    else:
        full_file_name = ""
    
    i0 = hstr.such(e, ".")
    
    if (i0 >= 0):
        ext = e[i0 + 1:]
    else:
        ext = e
    
    full_file_name = join(full_file_name, os.sep)
    
    full_file_name = os.path.join(full_file_name, b + "." + ext)
    
    return full_file_name


def get_path_leaves(full_path_name, root_path_name):
    leaves_path_name = ""
    
    rlist = root_path_name.split(os.sep)
    flist = full_path_name.split(os.sep)
    icount = 0
    for i in range(len(rlist)):
        if (len(flist) > i):
            t1 = rlist[i]
            t2 = flist[i]
            if (os.sep == "\\"):
                t1 = rlist[i].lower()
                t2 = flist[i].lower()
            # endif
            if (t1 == t2):
                icount += 1
            # endif
        # endif
    # endif
    if (len(rlist) == icount):
        leaves_path_name = os.path.join(*flist[icount:])
    # endif
    
    return leaves_path_name


# enddef

def remove_dir_all(dir_name):
    try:
        liste = os.listdir(dir_name)
    except WindowsError:
        print("remove_dir_all.error: os.listdir(\"%s\") not found" % dir_nam)
        return
    
    for aname in liste:
        
        aname = os.path.normcase(aname)
        bname = os.path.join(dir_name, aname)
        
        os.chmod(bname, stat.S_IWRITE)
        
        if (os.path.isdir(bname)):
            
            remove_dir_all(bname)
        
        elif (os.path.isfile(bname)):
            
            os.remove(bname)
    os.rmdir(dir_name)


def remove_all_in_dir(dir_name):
    try:
        liste = os.listdir(dir_name)
    except WindowsError:
        print("remove_dir_all.error: os.listdir(\"%s\") not found" % dir_name)
        return
    
    for aname in liste:
        
        aname = os.path.normcase(aname)
        bname = os.path.join(dir_name, aname)
        
        os.chmod(bname, stat.S_IWRITE)
        
        if (os.path.isdir(bname)):
            
            remove_dir_all(bname)
        
        elif (os.path.isfile(bname)):
            
            os.remove(bname)


def remove_named_dir(dir_name, delete_name, recursive):
    delete_name = os.path.normcase(delete_name)
    
    try:
        liste = os.listdir(dir_name)
    except WindowsError:
        print("loesche_ordner_function.error: os.listdir(\"%s\") not found" % dir_name)
        return
    
    for aname in liste:
        
        aname = os.path.normcase(aname)
        bname = os.path.join(dir_name, aname)
        
        if (os.path.isdir(bname)):
            
            if (aname == delete_name or bname == delete_name):
                print("remove %s" % bname)
                remove_dir_all(bname)
            elif (recursive):
                remove_named_dir(bname, delete_name, recursive)
        
        
        elif (os.path.isfile(bname)):
            
            if (aname == delete_name or bname == delete_name):
                print("remove %s" % bname)
                os.remove(bname)


def is_textfile(filename, blocksize=512):
    text_characters_in = "".join(list(map(chr, range(32, 127))) + list("\n\r\t\b"))
    
    text_characters_out = ""
    
    for i in range(len(text_characters_in)):
        text_characters_out += '#'
    
    _eins_trans = str.maketrans(text_characters_in, text_characters_out)
    
    try:
        s = open(filename).read(blocksize)
    except:
        return 0
    
    if "\0" in s:
        return 0
    
    if not s:  # Empty files are considered text
        return 1
    
    # Get the non-text characters (maps a character to itself then
    # use the 'remove' option to get rid of the text characters.)
    t = s.translate(_eins_trans)
    
    # count #
    n = 0
    for i in range(len(t)):
        if (t[i] == '#'):
            n += 1
        # endif
    # endfor
    
    # If more than 30% non-text characters, then
    # this is considered a binary file
    if n / len(s) < 0.30:
        return 0
    return 1


def copy_build_path(s_path_filename, t_path_filename, silent=1):
    # source prüfen
    if (not os.path.isfile(s_path_filename)):
        return NOT_OK
    
    # Zielpfad extrahieren
    (t_path, t_body, t_ext) = file_split(t_path_filename)
    
    # Zielpfad pruefen
    if (not os.path.isdir(t_path)):
        try:
            os.makedirs(t_path)
        except OSError:
            print("copybackup.backup_walk_tree.error: os.makedir(\"%s\") not possible" % t_path)
            return NOT_OK
    
    return copy(s_path_filename, t_path_filename, silent)


def copy(s_path_filename, t_path_filename, silent=1):
    """
      kopiert s_path_filename nach t_path_filename return hfkt.OK=1
    """
    
    if (not os.path.isfile(s_path_filename)):
        print("source_path_file: \"%s\" does not exist" % s_path_filename)
        return NOT_OK
    
    len_name = len(s_path_filename)
    
    copy_flag = 0
    
    (pathname, body, ext) = file_split(t_path_filename)
    
    if (len(pathname) and not os.path.isdir(pathname)):
        print("target_path: \"%s\" does not exist" % pathname)
        return NOT_OK
    
    if (not os.path.isfile(t_path_filename)):
        copy_flag = 1
        copy_text = "New"
    else:
        # maketime abfragen
        s_mtime = int(os.path.getmtime(s_path_filename))
        t_mtime = int(os.path.getmtime(t_path_filename))
        
        if (s_mtime > t_mtime):
            copy_flag = 1
            copy_text = "OVERWRITE"
    
    if (copy_flag):
        
        if (len_name > 32):
            # print "Voricht: Filenamelänge >32 File <%s>" % s_path_filename
            # print "Vorsicht:len>32"
            # print s_path_filename
            # copy_flag = 0
            if (not silent):
                print("%s(len>32): %s->%s" % (copy_text, s_path_filename, t_path_filename))
            
            bytelength = os.path.getsize(s_path_filename)
            stime = os.path.getmtime(s_path_filename)
            try:
                fileobj = open(s_path_filename, mode='rb')
                try:
                    fileobj1 = open(t_path_filename, mode='wb')
                    
                    while (bytelength):
                        binvalues = array.array('B')
                        if (bytelength < 1048576):
                            binvalues.fromfile(fileobj, bytelength)
                            bytelength = 0
                        else:
                            binvalues.fromfile(fileobj, 1048576)
                            bytelength -= 1048576
                        
                        binvalues.tofile(fileobj1)
                    
                    fileobj.close()
                    fileobj1.close()
                    os.utime(t_path_filename, (-1, stime))
                except IOError:
                    print("warning: (IOError) open file %s was not possible" % t_path_filename)
                    return NOT_OK
                except WindowsError:
                    print("warning: (WindowsError) open file %s was not possible" % t_path_filename)
                    return NOT_OK
            except IOError:
                print("warning: (IOError) open file %s was not possible" % s_path_filename)
                return NOT_OK
            except WindowsError:
                print("warning: (WindowsError) open file %s was not possible" % s_path_filename)
                return NOT_OK
        
        else:
            if (not silent):
                print("%s: %s->%s" % (copy_text, s_path_filename, t_path_filename))
            while (copy_flag != 3):
                try:
                    shutil.copy2(s_path_filename, t_path_filename)
                    # os.system("copy " + '"' + s_path_filename + '"' + " " + '"' + t_path_filename + '"' + " > .log")
                    # os.system("copy " + '"' + s_path_filename + '"' + " " + '"' + t_pathfilename + '"')
                    copy_flag = 3
                except IOError:
                    copy_flag += 1
                    # print "warning: (IOError) copy file %s was not possible" % s_path_filename
                except WindowsError:
                    copy_flag += 1
                    # print "warning: (WindowsError) copy file %s was not possible" % s_path_filename
                
                if (copy_flag != 3):
                    if (os.path.isfile(t_path_filename)):
                        try:
                            os.remove(t_path_filename)
                            # os.rename(t_path_filename,"M_"+t_path_filename)
                        except IOError:
                            print("warning: (IOError) copy/delete file %s was not possible" % t_path_filename)
                            copy_flag = 3
                        except WindowsError:
                            print("warning: (WindowsError) copy/delete file %s was not possible" % t_path_filename)
                            copy_flag = 3
                    else:
                        copy_flag = 3
                        print("warning: copy file %s was not possible" % s_path_filename)
        if (not silent):
            print("-----------------------------------------------------------")
        return OK
    else:
        return NOT_OK


def make_backup_file(fullfilename, backup_dir):
    """
    builds from fullfilename a backup filename with actual date and copies the file

    return (flag,errtext)
    if( flag == OK) => no Text
    if( flag == NOT_OK) => error text

    """
    
    errtext = ""
    
    if (not os.path.isfile(fullfilename)):
        errtext = "make_backup_file File: <%s> does not exist" % fullfilename
        return (NOT_OK, errtext)
    
    if (not os.path.isdir(backup_dir)):
        errtext = "make_backup_file Backup Dir: <%s> does not exist" % backup_dir
        return (NOT_OK, errtext)
    
    (path, fbody, ext) = get_pfe(fullfilename)
    backup_file_name = os.path.join(backup_dir,
                                    fbody + "_" + str(int_akt_datum()) + "_" + str(int_akt_time()) + "." + ext)
    try:
        flag = copy(fullfilename, backup_file_name, silent=1)
    except:
        flag = NOT_OK
    
    if (flag == NOT_OK):
        errtext = "copy(%s,%s) did not function" % (fullfilename, backup_file_name)
    
    return (flag, errtext)


def move_file(s_filename, targetdir):
    """
      verschiebt s_filename nach target-path
    """
    if (os.path.isfile(s_filename) and os.path.isdir(targetdir)):
        try:
            (path, fbody, ext) = get_pfe(s_filename)
            t_filename = join(targetdir, fbody + "." + ext)
            status = copy(s_filename, t_filename, silent=1)
            if (status == OK): os.remove(s_filename)
            
            return OK
        
        except IOError:
            print("warning: (IOError) copy/delete file %s was not possible" % s_filename)
            return NOT_OK
        except WindowsError:
            print("warning: (WindowsError) copy/delete file %s was not possible" % s_filename)
            return NOT_OK
    
    return NOT_OK


def change_text_in_file(filename, textsearch, textreplace):
    if (not os.path.isfile(filename)):
        print("Fehler change_words_in_file: zu bearbeitende Datei <%s> konnte nicht gefunden werden" % filename)
        exit(1)
    if (isinstance(textsearch, str) \
        and isinstance(textreplace, str)):
        with open(filename, "r") as f:
            
            lines = f.readlines()
        
        flag = False
        for i in range(len(lines)):
            if (such(lines[i], textsearch, 'vs') > -1):
                flag = True
                line = change(lines[i], textsearch, textreplace)
                lines[i] = line
        
        if (flag):
            with open(filename, "w") as f:
                
                for line in lines:
                    f.write("%s" % line)


# check_path(pathname)
# check if exist, if not build path
def check_path(pathname):
    if not os.path.isdir(pathname):
        return build_path(pathname)
    else:
        return OK


def build_path(pathname):
    if not os.path.isdir(pathname):
        try:
            os.makedirs(pathname)
            return OK
        except OSError:
            print("Das Zielverzeichnis %s kann nicht erstellt werden" % pathname)
            return NOT_OK
    else:
        return OK


#
# löscht Inhalt des Pfades
def clear_path(pathname):
    if os.path.isdir(pathname):
        try:
            shutil.rmtree(pathname)
            build_path(pathname)
            return OK
        except OSError:
            print("Das Zielverzeichnis %s kann nicht gelöscht werden" % pathname)
            return NOT_OK
    return OK

def find_file(filename,searchpath):
    """

    :param filename:
    :param path:
    :return: fullfilename =  find_file(filename,searchpath)

            e.g. fullfilename =  find_file("abcd.txt","D:/doku")

                fullfilename = None if not found
                fullfilename = "D:/doku/Texte/abcd.txt" wenn gefunden
    """

    (fpath, fbody, fext) = get_pfe(filename)
    fullfilename = None
    fbody_lower  = fbody.lower()
    liste = find_file_pattern("*."+fext,searchpath)

    for file in liste:
        (spath, sbody, sext) = get_pfe(file)
        if fbody_lower == sbody.lower():
            fullfilename = file
            break
        #end if
    # end if
    return fullfilename
# end def
def find_file_pattern(pattern, path):
    """
    find_file_pattern(pattern, path) returns a list of file

    find_file_pattern('*.txt', 'D:\\temp') => ["D:\\temp\\filea.txt","D:\\temp\\filea.txt"]
    """
    result = []
    for root, dirs, files in os.walk(path):
        for name in files:
            if fnmatch.fnmatch(name, pattern):
                result.append(os.path.join(root, name))
    return result


def get_last_subdir_name(fullpathname):
    """
    gebe letzte Ebene des Unterpfadsnamen zurück
    :param fullpathname:
    :return: last subdirname
    """
    pname = join(fullpathname, os.sep)
    
    liste = pname.split(os.sep)
    
    if (len(liste)):
        return liste[-1]
    else:
        return ""


def file_splitext(file_name):
    """
    ZErlegt file_name in body,ext
    file_name = "d:\\abc\\def\\ghj.dat"
    body      = "d:\\abc\\def\\ghj"
    ext       = "dat"
    (body,ext)   = file_splitext(file_name)
    """
    name = hstr.change_max(file_name, "/", "\\")
    
    i0 = hstr.such(name, "\\", "rs")
    i1 = hstr.such(name, ".", "rs")
    n = len(name)
    
    if (i1 > 0 and i1 > i0):
        b = file_name[0:i1]
        e = file_name[i1 + 1:n]
    else:
        b = file_name[0:n]
        e = ""
    
    return (b, e)


# end def
def file_split(file_name):
    """
    ZErlegt file_name in path,body,ext
    file_name = "d:\\abc\\def\\ghj.dat"
    path      = "d:\\abc\\def"
    body      = "ghj"
    ext       = "dat"
    (path,body,ext)   = file_split(file_name)
    """
    name = hstr.change_max(file_name, "/", "\\")
    
    i0 = hstr.such(name, "\\", "rs")
    i1 = hstr.such(name, ".", "rs")
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


# end def
def build_list_from_path(path_name):
    """

    :param path_name:
    :return: liste = build_list_from_path(path_name)
    """
    path_mod_name = hstr.change_max(path_name,"/",os.sep)
    path_liste = os.path.normpath(path_mod_name).split(os.sep)
    return path_liste
# end def
def build_path_with_forward_slash(path_name):
    """

    :param path_name:
    :return: path_name_mod = build_path_with_forward_slash(path_name)
    """
    p_list = os.path.normpath(path_name).split(os.sep)
    return build_path_from_list_with_forward_slash(p_list)
# end def
def build_path_from_list_with_forward_slash(p_list):
    """

    :param p_list:
    :return: path = build_path_from_list_with_forward_slash(p_list)
    """
    n = len(p_list)
    path_name_mod = ""
    for i,item in enumerate(p_list):
        path_name_mod += item
        if i < n-1:
            path_name_mod += '/'
    # end for
    return path_name_mod
# end def
def get_abs_dir(rel_dir,base_dir):
    """

    :param rel_dir:
    :param base_dir:
    :return: fullpath = get_abs_dir(rel_dir,base_dir)
             fullpath = get_abs_dir(rel_dir_list,base_dir_list)
    """

    if isinstance(rel_dir,list):
        rel_dir_list = rel_dir
    else:
        rel_dir_list = os.path.normpath(rel_dir).split(os.sep)
    # end if

    if isinstance(base_dir,list):
        base_dir_list = base_dir
    else:
        base_dir_list = os.path.normpath(base_dir).split(os.sep)
    # end if

    rev_base_dir_list = base_dir_list[::-1]

    t = '.'
    prev_fold = False
    curr_fold = True
    has_rel_path = False

    while prev_fold or curr_fold:

        if len(rel_dir_list):
            t = rel_dir_list[0]
            del rel_dir_list[0]
        else:
            t = ""

        prev_fold = (t == '..')
        curr_fold = (t == '.')

        if prev_fold and len(rev_base_dir_list):
            del rev_base_dir_list[0]
        # end if
        if prev_fold or curr_fold:
            has_rel_path = True
    # end while

    if has_rel_path:
        liste = rev_base_dir_list[::-1]
    else:
        liste = []
    # end if

    if len(t):
        liste.append(t)
    # end if

    liste += rel_dir_list

    return build_path_from_list_with_forward_slash(liste)
# end def
def get_rel_dir(target_dir,abs_dir):
    """
    
    :param target_dir: 
    :param abs_dir: 
    :return: rel_dir = get_rel_dir(target_dir,abs_dir)
    """

    if isinstance(abs_dir,list):
        abs_dir_list = abs_dir
    else:
        abs_dir_list = os.path.normpath(abs_dir).split(os.sep)
    # end if

    if isinstance(target_dir,list):
        target_dir_list = target_dir
    else:
        target_dir_list = os.path.normpath(target_dir).split(os.sep)
    # end if

    nabs = len(abs_dir_list)
    ntar = len(target_dir_list)

    n = min(nabs,ntar)

    if n == 1:

        rel_dir_list = ["."]
    else:

        istart = n-1
        for i in range(0,n):
            if abs_dir_list[i] != target_dir_list[i]:
                istart = i-1
                break
            # end if
        # end for

        rel_dir_list = []
        if (istart == n-1) and (nabs == ntar):
            rel_dir_list.append(".")
        else:
            if nabs > istart+1:
                rel_dir_list = [".."]
                for i in range(istart+2,nabs):
                    rel_dir_list.append("..")
                # end ofr
            else:
                rel_dir_list.append(".")
            # end if

            if ntar > istart+1:
                for i in range(istart+1,ntar):
                    rel_dir_list.append(target_dir_list[i])
                # end for
            # end if
        # end if
    # end if
    return build_path_from_list_with_forward_slash(rel_dir_list)
###########################################################################
# testen mit main
###########################################################################
if __name__ == '__main__':
    # path_name_mod = build_path_with_forward_slash("K:/data/md")
    # print(f"{path_name_mod = }")

    # p = get_rel_dir("K:/data/md/_bilder/erste",'K:/data/md/Music/Rock',)
    # print(f"{p = }")

    searchfile = "Newmont240905.jpg"
    base_path = "K:\\data\\md"
    f = find_file(searchfile,base_path )

    if f:
        print(f"fullfile = {f}")
    else:
        print(f"File {searchfile} not found")
