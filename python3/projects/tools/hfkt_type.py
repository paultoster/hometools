# -*- coding: utf8 -*-
#
# 18.06.23 von hfkt.py
#############################

##################################################################################
# Sonstiges
###################################################################################
# value = str_to_float_possible(string_val),  if not possible value = None
# ival  = str_to_int_possible(string_val),  if not possible ival = None
# def summe_euro_to_cent(text,delim=","):
# def suche_in_liste(liste,gesucht):
# def string_cent_in_euro(cents):
# def num_cent_in_euro(cents):
# int = string_euro_in_int_cent(teuro,delim=",") Wandelt einen String mit Euro in Cent
# (okay,value) =  str_to_float(string) wandelt string in float, wenn nicht erreichr okay = false
# flag = is_string(val)  Prüft, ob Type string flag = True/False
# flag = is_unicode(val)  Prüft, ob Type unicode flag = True/False
# flag = is_list(val)  Prüft, ob Type liste flag = True/False
# flag = is_dict(val)  Prüft, ob Type dictionary flag = True/False
# flag = isfield(c,'valname') Prüft ob eine Klasse oder ein dict die instance hat
# flag = isempty(val) Prüft, ob leer nach type
# (okay,wert) = hfkt_type_proof(wert_in, type) Prüft den Wert auf seine type: "str","float","int","dat"
#
# print_python_is_32_or_64_bit
# ---------------------------------
# multiply_constant(list,const)  multiplies a list with const value

# import types
# import copy
# import sys
# import os
# from tkinter import *
# from tkinter.constants import *
# import tkinter.filedialog
# import tkinter.messagebox
import string
# import csv
# import array
# import shutil
import struct

import hfkt as h
import hfkt_def as hdef
import hfkt_str as hstr
import hfkt_date_time as hdt

# import stat

# import ftfy
# import fnmatch

KITCHEN_MODUL_AVAILABLE = False

OK = 1
NOT_OK = 0
QUOT = 1
NO_QUOT = 0
TCL_ALL_EVENTS = 0


###################################################################################
# Sonstiges
###################################################################################
def str_to_float_possible(string_val):
    """
    value= str_to_float_possible(string_val)
    if okay value = float(string_val)
    else    value = None
    """

    index0 = 0
    n1 = 0
    maxdig = 0
    n = len(string_val)
    try:
        return float(string_val)
    except ValueError:
        for istart in range(n):
            for nend in range(istart + 1, n + 1, 1):
                tt = string_val[istart:nend]
                try:
                    if len(tt) > maxdig:
                        maxdig = len(tt)
                        index0 = istart
                        n1 = nend
                        # endif
                except ValueError:
                    pass
                    # endtry
            # endfor
        # endfor
    # endtry
    if maxdig > 0:
        return float(string_val[index0:n1])
    else:
        return None


# enddef


def str_to_int_possible(string_val):
    """
    value= str_to_int_possible(string_val)
    if okay value = int(string_val)
    else    value = None
    """
    try:
        return int(string_val)
    except ValueError:
        try:
            value: float | None = str_to_float_possible(string_val)
            if value:
                return int(value)
            else:
                return None
            # endif
        except ValueError:
            return None
        # end try
    # endtry


# enddef


def summe_euro_to_cent(text, delim=","):
    """ Umrechnung Euro (Text) in Cent (int) """
    text1 = hstr.elim_ae(text, " ")

    fact = 1

    if text1[0] == "-":
        fact = -1
        text1 = text1[1:]
    elif text[0] == "+":
        fact = 1
        text1 = text1[1:]

    text1 = hstr.elim_ae(text1, " ")

    liste = text1.split(delim)

    # print(liste)
    summe = 0

    if len(liste) >= 1:
        summe = summe + int(liste[0]) * 100

    if len(liste) >= 2:
        tdum = liste[1]
        if len(tdum) >= 1:
            summe = summe + int(tdum[0]) * 10
        if len(tdum) >= 2:
            summe = summe + int(tdum[1])

    return summe * fact


def suche_in_liste(liste, gesucht):
    """ Sucht in liste nach gesucht """
    #    print "start find_in_list"
    #    print "gesucht:"
    #    print gesucht
    for item in liste:
        #        print "item:"
        #        print item
        if item == gesucht:
            return True
    return False


def string_cent_in_euro(cents):
    """ Wandelt string cents in "xx,yy €"
      """
    return str(float(cents) / 100) + " €"


def num_cent_in_euro(cents):
    """ Wandelt num cents in "xx,yy €"
      """
    return "%.2f" % (float(cents) / 100) + " €"


def string_euro_in_int_cent(teuro, delim=","):
    """
      Wandelt einen String mit Euro z.B. "4.885,66"
      in (int)488566
      """
    # Wenn Trennzeichen nicht Punkt, dann
    # nehme den Tausender-Punkt raus,
    if delim != ".":
        teuro = hstr.change(teuro, delim, "")
    # Tausche Trennzeichen gegen Punkt
    teuro = hstr.change(teuro, delim, ".")
    # Wandele in cent
    return int(float(teuro) * 100)


def str_to_float(txt):
    try:
        value = float(txt)
        okay = True
    except:
        value = 0.0
        okay = False

    return (okay, value)


###########################################################################
###########################################################################
def is_int(val):
    '''
    Prüft, ob Type int flag = True/False
    '''
    return isinstance(val, int)


def is_string(val):
    '''
    Prüft, ob Type string flag = True/False
    '''
    return isinstance(val, str)


def is_unicode(val):
    '''
    Prüft, ob Type unicode flag = True/False
    '''
    return isinstance(val, str)


def is_list(val):
    '''
    Prüft, ob Type Liste flag = True/False
    '''
    return isinstance(val, list)


def is_tuple(val):
    '''
    Prüft, ob Type Tuple flag = True/False
    '''
    return isinstance(val, tuple)


def is_dict(val):
    '''
    Prüft, ob Type Liste flag = True/False
    '''
    return isinstance(val, dict)


def isfield(c, valname):
    '''
    Prüft ob eine Klasse oder ein dict die instance hat
    '''
    flag = False
    if (isinstance(valname, str)):
        if (not isinstance(c, dict)):
            a = c.__dict__
            flag = valname in a
        elif (isinstance(c, dict)):
            flag = valname in c

    return flag


# -------------------------------------------------------
def isempty(val):
    """
    prüft nach type, ob wert leer
    """
    flag = True
    if (val == None):
        pass
    elif (isinstance(val, str)):
        if (len(val) > 0): flag = False
    elif (is_list(val) or is_tuple(val) or isinstance(val, dict)):
        if (len(val) > 0): flag = False
    elif (isinstance(val, int) or isinstance(val, float)):
        flag = False
    else:
        print("hfkt.isempty kennt den type nicht: %s" % type(val))
        raise NameError('hfkt.isempty')

    return flag

# -------------------------------------------------------

def hfkt_type_proof_str_excel_float(wert_in):
    if (isinstance(wert_in, str)):
        wert_in = hstr.change_excel_value_str(wert_in)
        wert = str_to_float_possible(wert_in)
        if (wert == None):
            okay = hdef.NOT_OKAY
        else:
            okay = hdef.OKAY
        # endif
    else:
        wert = None
        okay = hdef.NOT_OKAY
        # endtry
    # endif
    return (okay, wert)


# enddef

# -------------------------------------------------------
def hfkt_type_proof(wert_in, type):
    '''
    (okay,wert) = hfkt_type_proof(wert_in, type) Prüft den Wert auf seine
    type: "str","float","int","dat","iban"
    "dat": Convert to epoch seconds
    "iban": string, 2 letters and 20 digits, could be with spaces
    '''
    if (type == "str"):
        return hfkt_type_proof_string(wert_in)
    elif (type == "float"):
        return hfkt_type_proof_float(wert_in)
    elif (type == "int"):
        return hfkt_type_proof_int(wert_in)
    elif ((type == "dat") or (type == "date")):
        return hfkt_type_proof_dat(wert_in)
    elif (type == "iban"):
        return hfkt_type_proof_iban(wert_in)
    else:
        return (hdef.NOT_OKAY, None)  # endif


# enddef


def hfkt_type_proof_string(wert_in):
    if (isinstance(wert_in, str)):
        return (hdef.OKAY, wert_in)
    elif (isinstance(wert_in, list) or isinstance(wert_in, tuple)):
        try:
            return hfkt_type_proof_string(wert_in[0])
        except:
            return (hdef.NOT_OKAY, None)  # endtry
    else:
        try:
            wert = str(wert_in)
            okay = hdef.OKAY
        except:
            wert = None
            okay = hdef.NOT_OKAY
        # endtry
        return (okay, wert)  # endif


# enddef


def hfkt_type_proof_float(wert_in):
    if (isinstance(wert_in, float)):
        return (hdef.OKAY, wert_in)
    elif (isinstance(wert_in, list) or isinstance(wert_in, tuple)):
        try:
            return hfkt_type_proof_float(wert_in[0])
        except:
            return (hdef.NOT_OKAY, None)  # endtry
    elif (isinstance(wert_in, str)):
        wert = str_to_float_possible(wert_in)
        if (wert == None):
            okay = hdef.NOT_OKAY
        else:
            okay = hdef.OKAY
        # endif
        return (okay, wert)
    else:
        try:
            wert = float(wert_in)
            okay = hdef.OKAY
        except:
            wert = None
            okay = hdef.NOT_OKAY
        # endtry
        return (okay, wert)  # endif


# enddef
def hfkt_type_proof_int(wert_in):
    if (isinstance(wert_in, int)):
        return (hdef.OKAY, wert_in)
    elif (isinstance(wert_in, list) or isinstance(wert_in, tuple)):
        try:
            return hfkt_type_proof_int(wert_in[0])
        except:
            return (hdef.NOT_OKAY, None)  # endtry
    elif (isinstance(wert_in, str)):
        wert = str_to_int_possible(wert_in)
        if (wert == None):
            okay = hdef.NOT_OKAY
        else:
            okay = hdef.OKAY
        # endif
        return (okay,
                wert)  # try:  #   wert = int(float(wert_in))  #   okay = hdef.OKAY  # except:  #   wert = None  #   okay = hdef.NOT_OKAY  # endtry  # return (okay, wert)
    else:
        try:
            wert = int(wert_in)
            okay = hdef.OKAY
        except:
            wert = None
            okay = hdef.NOT_OKAY
        # endtry
        return (okay, wert)  # endif


# enddef


def hfkt_type_proof_dat(wert_in):
    """ return value in epoch seconds"""
    if (isinstance(wert_in, str)):
        secs = hdt.secs_time_epoch_from_str_re(wert_in)

        if (isinstance(wert_in, list)):
            secs = secs[0]
        # endif

        if (secs == 0):
            return (hdef.NOT_OKAY, None)
        else:
            return (hdef.OKAY, secs)
    elif (isinstance(wert_in, list) or isinstance(wert_in, tuple)):
        try:
            return hfkt_type_proof_dat(wert_in[0])
        except:
            return (hdef.NOT_OKAY, None)  # endtry
    else:
        try:
            datum = h.datum_int_to_str(int(wert_in))
            return hfkt_type_proof_dat(datum)
        except:
            return (hdef.NOT_OKAY, None)  # endtry  # endif


# enddef


def hfkt_type_proof_iban(wert_in):
    """ return value in epoch seconds"""

    (okay, wert) = hfkt_type_proof_string(wert_in)

    if (okay == hdef.OKAY):

        (hit, hitliste) = eval_iban(wert_in)
        if (hit == 1):
            wert = hitliste[0]
            okay = hdef.OKAY
        else:
            wert = None
            okay = hdef.NOT_OKAY  # endif
    # endif

    return (okay, wert)


# enddef


country_iban_dic = {"AL": [28, "Albania"], "AD": [24, "Andorra"], "AT": [20, "Austria"], "BE": [16, "Belgium"],
                    "BA": [20, "Bosnia"], "BG": [22, "Bulgaria"], "HR": [21, "Croatia"], "CY": [28, "Cyprus"],
                    "CZ": [24, "Czech Republic"], "DK": [18, "Denmark"], "EE": [20, "Estonia"],
                    "FO": [18, "Faroe Islands"], "FI": [18, "Finland"], "FR": [27, "France"], "DE": [22, "Germany"],
                    "GI": [23, "Gibraltar"], "GR": [27, "Greece"], "GL": [18, "Greenland"], "HU": [28, "Hungary"],
                    "IS": [26, "Iceland"], "IE": [22, "Ireland"], "IL": [23, "Israel"], "IT": [27, "Italy"],
                    "LV": [21, "Latvia"], "LI": [21, "Liechtenstein"], "LT": [20, "Lithuania"],
                    "LU": [20, "Luxembourg"], "MK": [19, "Macedonia"], "MT": [31, "Malta"], "MU": [30, "Mauritius"],
                    "MC": [27, "Monaco"], "ME": [22, "Montenegro"], "NL": [18, "Netherlands"],
                    "NO": [15, "Northern Ireland"], "PO": [28, "Poland"], "PT": [25, "Portugal"], "RO": [24, "Romania"],
                    "SM": [27, "San Marino"], "SA": [24, "Saudi Arabia"], "RS": [22, "Serbia"], "SK": [24, "Slovakia"],
                    "SI": [19, "Slovenia"], "ES": [24, "Spain"], "SE": [24, "Sweden"], "CH": [21, "Switzerland"],
                    "TR": [26, "Turkey"], "TN": [24, "Tunisia"],
                    "GB": [22, "United Kingdom"]}  # dictionary with IBAN-length per country-code


def eval_iban(input):
    # Evaluates how many IBAN's are found in the input string
    try:
        if input:
            hits = 0
            ibans = []
            for word in input.upper().split():
                iban = word.replace(" ", "")
                correct_length = country_iban_dic[iban[:2]]
                if len(iban) == correct_length[0]:
                    flag = True
                    for d in iban[2:]:
                        if (d not in string.digits):
                            flag = False
                            break  # endif
                    # endfor
                    if (flag):
                        hits += 1
                        ibans.append(iban)  # endif  # endif
            # endfor
            #
            #
            # #endif
            #
            # iban = word.strip()
            # letter_dic = {ord(d): str(i) for i, d in enumerate(string.digits + string.ascii_uppercase)} # Matches letter to number for 97-proof method
            # correct_length = country_iban_dic[iban[:2]]
            # if len(iban) == correct_length[0]: # checks whether country-code matches IBAN-length
            #   if int((iban[4:] + iban[:4]).translate(letter_dic)) % 97 == 1:
            #     # checks whether converted letters to numbers result in 1 when divided by 97
            #     # this validates the IBAN
            #     hits += 1
            return (hits, ibans)
        # endif
        return (0, [])
    except KeyError:
        return (0, [])
    except Exception:
        # logging.exception('Could not evaluate IBAN')
        return (0, [])


# enddef
# -------------------------------------------------------
def print_python_is_32_or_64_bit():
    print(struct.calcsize("P") * 8)


###########################################################################
# testen mit main
###########################################################################
if __name__ == '__main__':
    (okay, out) = hfkt_type_proof("11 Dez. 2024", "date")

    print(f"okay: {okay}, out : {out}")

    # string_with_dates = "05.10.23"  #  # text = " Oder aber 01.11.65 Das Datum ist 09/02/2023 und der andere Termin ist am 12-12-2024  "  #  # epochdate = secs_time_epoch_from_str_re(text)  #  # print(epochdate, secs_time_epoch_to_str(epochdate))

    # pattern = r"\b(0[1-9]|1[0-9]|2[0-9]|3[0-1])[-/\.](0[1-9]|[12]\d|3[01])[-/\.](19\d\d|20\d\d|\d\d)\b"  # dates = re.findall(pattern, text)  # for d in dates:  #  s = d[0]  #  s += "."+d[1]  #  if( len(d[2]) == 2 ):  #    s += ".20" + d[2]  #  else:  #    s += "." + d[2]  #  #endif

    # fullpathname = 'https://files.realpython.com/media/haversine_formula_150.fb2b87d122a4.png'  # t = get_last_subdir_name(fullpathname)  #  # (p,b,e) = get_pfe('https://files.realpython.com/media/haversine_formula_150.fb2b87d122a4.png')  # str_replace("abcdefghi","12",8,2)  #  # #secs_time_epoch_from_str('14.01.2020')  # liste = string_to_num_list('[1.2, 3.2, 4.55]')  # print(liste)  # t = "abcd|efgh"  # liste = split_text(t,"|")  # print(t)  # print(liste)  # print("gdgdg")  # i0 = such("abcdef",'cd',"vs")  # b=get_free_size('d:\\temp')  # liste = get_parent_path_dirs('d:\\temp\\Grid')  # liste = get_parent_path_files('d:\\temp\\Grid')  # a = elim_comment_not_quoted("abcdef{l12#3ghi}",["#","%"],"{","}")  # text = "aaaabcdefccc"  # print "text = %s" % text

    # print such(text,"a","vn")  # print split_with_quot("abc{def}ghi{jkl}","{","}")  # print split_not_quoted("abc|edf||{|||}|ghi","|","{","}",0)  # print such_in_liste(["abc","1abc"],"abc")  # for i in range(0,100):  #    print i,int_to_dec36(i,6)  #    #print i,int_to_dec36(i,6),dec36_to_int(int_to_dec36(i,6))

    # print "%-30.0f" % get_dattime_float("sos.py")  # print get_name_by_dat_time(pre_text="backup_")  # d = dat_last_act_workday_datelist([2009,11,7])

##    liste = ["a","b","c"]
##    item = abfrage_listbox(liste,"s")

# filename = abfrage_file(file_types="*.*",comment="Wähle aus",start_dir="d:\\temp")

# (p,b,e) = file_split("..\\abc\\ssj.f")
# print (p,b,e)

# os.chdir("d:\\tools\\python\\_entw\\AdressBook")
# read_mab_file("abook.mab")

##    for a in get_subdir_files("d:\\temp"):
##
##      print a

##    t1 = 'aébßcò'
##    tu = to_unicode(t1)
##
##    t2 = to_bytes(tu,'utf-8')
##    #t3 = to_cp1252(tu)
##
##    print tu
##    print t1
##    print t2

##     liste = datum_int_to_intliste(20161219)
##     t = (liste[2], liste[1], liste[0], 12, 0, 0, 0, 0, 0)
##     #t = time.localtime()
##     secs1 = time.mktime( t )
##     print liste
##     print (time.time() - secs1)/60/60
##
##     secs2 = secs_time_epoch_from_int(20161219,12)
##     print secs1 - secs2
##
##     print secs_time_epoch_to_str(int(time.time()))

##    v = str_to_float_possible("e10.0nwklnkn20354")
##    if( v ): print "v = %f" % v

##    val  = str_to_float_possible('')
##    if( val == None ): print "not okay"
##    else:              print "okay"

##    print_python_is_32_or_64_bit()
