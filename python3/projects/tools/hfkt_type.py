# -*- coding: utf8 -*-
#
# 18.06.23 von hfkt.py
#############################
import os.path
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
# (okay,wert) = type_proof(wert_in, type) Prüft den Wert auf seine type: "str","float","int","dat","iban","euro"
# (okay,wert_cent) = type_convert_euro_to_cent(wert_euro)
# wert type_get_default(type)
#
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
import re
import math
import zlib

# from pandas.core.dtypes.inference import is_float

if os.path.isfile('hfkt_def.py'):
    import hfkt_def as hdef
    import hfkt_str as hstr
    import hfkt_date_time as hdate
else:
    import tools.hfkt_def as hdef
    import tools.hfkt_str as hstr
    import tools.hfkt_date_time as hdate
# import tools.hfkt as h

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
        list = re.findall(r"[-+]?(?:\d*\.*\d+)", string_val)
        
        if len(list) > 0:
            try:
                return float(list[0])
            except:
                return None
            # end try
        # end if
    # end try
    


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


def string_cent_in_euroStr(cents,delim=",",thousandsign="."):
    """ Wandelt string cents in "xx,yy"
      """
    
    return num_cent_in_euroStr(float(cents), delim=delim, thousandsign=thousandsign)


def num_cent_in_euro(cents):
    """ Wandelt num cents in float
      """
    return float(cents) / 100.

def num_euro_in_euroStr(euro,delim=",",thousandsign="."):
    return num_cent_in_euroStr(euro*100., delim=delim, thousandsign=thousandsign)
def num_cent_in_euroStr(cents,delim=",",thousandsign="."):
    """ Wandelt num cents in "xx,yy €"
      """
    if cents < 0 :
        negflag = True
        value = -cents
    else:
        negflag = False
        value = cents
    # end if
    if isinstance(value,float):
        value = int(value + math.copysign(0.5, value))
    # end if
    
    numeric_string = "%.2f" % (float(value) / 100)
    list = numeric_string.split(".")
    
    thousands = []
    n = len(list[0])
    count = 0
    if n < 4:
        thousands.append(list[0])
        count += 1
    else:
        n0 = n%3
        if n0 != 0:
            thousands.append(list[0][0:n0])
            count += 1
        # end if
        for i in range(int((n-n0)/3)):
            thousands.append(list[0][n0+i*3:n0+(i+1)*3])
            count += 1
        # end for
    # end if
    
    euroStr = ''
    for i,thousand in enumerate(thousands):
        euroStr += thousand
        if i < (count-1):
            euroStr += thousandsign
        # end if
    # end for
    euroStr += delim
    euroStr += list[1]
    
    if negflag:
        euroStr = "-" + euroStr
    # endif
    
    return euroStr
# end def
def numeric_string_to_float(numeric_string,delim=",",thousandsign="."):
    parts = [part.strip().replace(thousandsign, '') for part in numeric_string.split(delim)]
    return float('.'.join(parts))

def string_euro_in_int_cent(numeric_string, delim=",",thousandsign="."):
    """
      Wandelt einen String mit Euro z.B. "4.885,66" => thousandsign="." und delim=","
      in (int)488566
      """
    # Wenn Trennzeichen nicht Punkt, dann
    # nehme den Tausender-Punkt raus,
    #-------------------------------------
    value = numeric_string_to_float(numeric_string,delim=delim,thousandsign=thousandsign)
    return int(value* 100.+ math.copysign(0.5, value) )

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
def is_float(val):
    '''
    Prüft, ob Type float flag = True/False
    '''
    return isinstance(val, float)


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

def type_proof_str_excel_float(wert_in):
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
def type_get_default(type):
    '''
    
    :param type: siehe unten
    :return: wert = type_get_default(type)
    '''
    
    if isinstance(type, list):
        return type_get_default_list(type)
    else:
        return type_get_default_single(type)
    # end if
# end def
def type_get_default_list(type_list):
    liste = [None for j in range(len(type_list))]
    for i,type in enumerate(type_list):
        liste[i] = type_get_default(type)
    # end for
    return liste
# end def
def type_get_default_single(type):
    if type == "str":
        return ""
    elif type == "datStrP":
        return hdate.str_akt_datum(delim=".")
    elif type == "datStrB":
        return hdate.str_akt_datum(delim="-")
    elif type == "float":
        return 0.0
    elif type == "int":
        return 0
    elif type == "list":
        return []
    elif isinstance(type,list):
        return type[0]
    elif type == "list_str":
        return []
    elif (type == "dat") or (type == "date"):
        return 0
    elif type == "iban":
        return ""
    elif type == "isin":
        return ""
    elif type == "wkn":
        return ""
    elif type == "euro":
        return 0.0
    elif type == "euroStrK":
        return "0,0"
    elif type == "cent":
        return 0
    else:
        return None
    # endif

# end def
# -------------------------------------------------------
def type_proof(wert_in, type):
    '''
    (okay,wert) = type_proof(wert_in, type) Prüft den Wert auf seine
    type: "str","float","int","dat","iban"
    "dat": Convert to epoch seconds
    "datStrP": Convert to date string mit Punkt "20.03.2024"
    "datStrB": Convert to date string mit Bindesttrich "20-03-2024"
    "iban": string, 2 letters and 20 digits, could be with spaces
    "wkn": string, 6 alphanum big letters
    "str": string
    "int": integer
    "float": floating point
    "list": any list
    "list_str": a list with strings
    "euro": float
    "euroStrK": string mit Komma Trennung ('.' 1000er)   10,34
    "cent": int
    "percentStr" string mit '%'
    '''
    if type == "str":
        return type_proof_string(wert_in)
    elif type == "float":
        return type_proof_float(wert_in)
    elif type == "int":
        return type_proof_int(wert_in)
    elif type == "list":
        return type_proof_list(wert_in, "")
    elif isinstance(type,list):
        return type_proof_list(wert_in, type)
    elif (type == "list_str") or (type == "listStr"):
        return type_proof_list(wert_in, "str")
    elif (type == "dat") or (type == "date"):
        return type_proof_dat(wert_in)
    elif (type == "datStr") or (type == "datStrP"):
        return type_proof_datStrP(wert_in)
    elif (type == "datStrB"):
        return type_proof_datStrB(wert_in)
    elif type == "iban":
        return type_proof_iban(wert_in)
    elif type == "isin":
        return type_proof_isin(wert_in)
    elif type == "wkn":
        return type_proof_wkn(wert_in)
    elif type == "euro":
        return type_proof_euro(wert_in)
    elif type == "euroStrK":
        return type_proof_euroStrK(wert_in)
    elif type == "cent":
        return type_proof_cent(wert_in)
    elif type == "percentStr":
        return type_proof_percentStr(wert_in)
    else:
        return (hdef.NOT_OKAY, None)
    # endif


# enddef


def type_proof_string(wert_in):
    if (isinstance(wert_in, str)):
        wert = hstr.elim_ae(wert_in,"\"")
        return (hdef.OKAY, wert)
    elif (isinstance(wert_in, list) or isinstance(wert_in, tuple)):
        try:
            return type_proof_string(wert_in[0])
        except:
            return (hdef.NOT_OKAY, None)  # endtry
    elif( wert_in == None ):
        return(hdef.NOT_OKAY,None)
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
def type_proof_float(wert_in):
    if (isinstance(wert_in, float)):
        return (hdef.OKAY, wert_in)
    elif (isinstance(wert_in, list) or isinstance(wert_in, tuple)):
        try:
            return type_proof_float(wert_in[0])
        except:
            return (hdef.NOT_OKAY, None)  # endtry
    elif (isinstance(wert_in, str)):
        
        (okay, val_in) = type_transform_str(wert_in,"float")
        if okay == hdef.OKAY:
            wert = float(val_in)
        else:
            wert = str_to_float_possible(wert_in)
        # end if
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
def type_proof_int(wert_in):
    if (isinstance(wert_in, int)):
        return (hdef.OKAY, wert_in)
    elif (isinstance(wert_in, list) or isinstance(wert_in, tuple)):
        try:
            return type_proof_int(wert_in[0])
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

def type_proof_list(wert_in,type):
    
    
    if isinstance(wert_in,list):
        if( len(type) == 0 ):
            return (hdef.OKAY, wert_in)
        elif( type == "str" ):
            for i,item_raw in enumerate(wert_in):
                
                (okay,item) = type_proof_string(item_raw)
                if( okay == hdef.OKAY):
                    wert_in[i] = item
                else:
                    return (hdef.NOT_OKAY,wert_in)
                # end if
            # end for
        else:
            return (hdef.NOT_OKAY,wert_in)
        #end if
    elif isinstance(type,list):
        if wert_in in type:
            return (hdef.OKAY, wert_in)
        else:
            return (hdef.NOT_OKAY, None)
    else:
        return (hdef.NOT_OKAY,wert_in)
    # end if
    return (hdef.OKAY,wert_in)
# end def
def type_proof_dat(wert_in):
    """ return value in epoch seconds"""
    if (isinstance(wert_in, str)):
        secs = hdate.secs_time_epoch_from_str_re(wert_in)

        if (isinstance(wert_in, list)):
            secs = secs[0]
        # endif

        if (secs == 0):
            return (hdef.NOT_OKAY, None)
        else:
            return (hdef.OKAY, secs)
    elif (isinstance(wert_in, list) or isinstance(wert_in, tuple)):
        try:
            return type_proof_dat(wert_in[0])
        except:
            return (hdef.NOT_OKAY, None)  # endtry

    elif isinstance(wert_in, int) and wert_in >= 0:
        return (hdef.OKAY,wert_in)
    else:
        return (hdef.NOT_OKAY, None)  # endtry  # endif


# enddef

def type_proof_datStrP(wert_in):
    """ return value in epoch seconds"""
    if (isinstance(wert_in, str)):
        
        flag = hdate.is_datum_str(wert_in, delim=".")
        
        if flag:
            return (hdef.OKAY, wert_in)
    
    elif (isinstance(wert_in, list) or isinstance(wert_in, tuple)):
        
        for item in wert_in:
            flag = hdate.is_datum_str(item, delim=".")
            if not flag:
                return (hdef.NOT_OKAY, None)
            # end if
        # end ofr
        return (hdef.OKAY, wert_in)
    
    # end if
    
    return (hdef.NOT_OKAY, None)


# enddef
def type_proof_datStrB(wert_in):
    """ return value in epoch seconds"""
    if (isinstance(wert_in, str)):
        
        flag = hdate.is_datum_str(wert_in, delim="-")
        
        if flag:
            return (hdef.OKAY, wert_in)
    
    elif (isinstance(wert_in, list) or isinstance(wert_in, tuple)):
        
        for item in wert_in:
            flag = hdate.is_datum_str(item, delim="-")
            if not flag:
                return (hdef.NOT_OKAY, None)
            # end if
        # end ofr
        return (hdef.OKAY, wert_in)
    
    # end if
    
    return (hdef.NOT_OKAY, None)


# enddef

def type_proof_iban(wert_in):
    """ return value in epoch seconds"""

    (okay, wert) = type_proof_string(wert_in)

    if (okay == hdef.OKAY):
        
        wert = hstr.elim_whitespace(wert)

        (hit, hitliste) = eval_iban(wert)
        if (hit >= 1):
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

def type_proof_isin(wert_in):
    """ return value str
    """
    
    (okay, wert) = type_proof_string(wert_in)
    
    if (okay == hdef.OKAY):
        
        isins = find_ISIN(wert)
        if( len(isins) > 0 ):
            (okay, errtext, number) = isin_validate(isins[0])
            if okay == hdef.OKAY:
                wert = number
            else:
                wert = None
            # end if
        else:
            wert = None
            okay = hdef.NOT_OKAY
        # end if
    # end if
    return (okay, wert)
# end def


#----------------------------------------------------------------------------------------------------
# isin functions start  -----------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------
def find_ISIN(S):
    
    
    found = 0
    try:
        
        pattern = r"\b[A-Z]{2}[A-Z0-9]{9}[0-9]\b"
        ISIN_list = re.findall(pattern, S)
        if len(ISIN_list): found = 1
    except:
        found = 0
    # end try
    if found == 0:
        try:
            
            pattern = r"[A-Z]{2}[A-Z0-9]{9}[0-9]"
            ISIN_list = re.findall(pattern, S)
            if len(ISIN_list): found = 1
        except:
            found = 0
        # end try
    # end if
    if found == 0:
        try:
            
            pattern = r"^[A-Z]{2}[A-Z0-9]{9}[0-9]$"
            ISIN_list = re.findall(pattern, S)
            if len(ISIN_list): found = 1
        except:
            found = 0
        # end try
    # end if
    
    if found == 0:
        ISIN_list = []
        i = 0
        while i <= len(S) - 12:
            if S[i:i + 2].isalpha() and S[i + 2:i + 12].isdigit():
                ISIN_list.append(S[i:i + 12])
                i += 12
            else:
                i += 1
    # endif
    return ISIN_list


# end def

# isin.py - functions for handling ISIN numbers
#
# Copyright (C) 2015-2017 Arthur de Jong
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301 USA

# ISIN (International Securities Identification Number).
#
# The ISIN is a 12-character alpha-numerical code specified in ISO 6166 used to
# identify exchange listed securities such as bonds, commercial paper, stocks
# and warrants. The number is formed of a two-letter country code, a nine
# character national security identifier and a single check digit.
#
# This module does not currently separately validate the embedded national
# security identifier part (e.g. when it is a CUSIP).
#
# More information:
#
# * https://en.wikipedia.org/wiki/International_Securities_Identification_Number
#
# >>> validate('US0378331005')
# 'US0378331005'
# >>> validate('US0378331003')
# Traceback (most recent call last):
#     ...
# InvalidChecksum: ...
# >>> from_natid('gb', 'BYXJL75')
# 'GB00BYXJL758'



# all valid ISO 3166-1 alpha-2 country codes
_iso_3116_1_country_codes = [
    'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AN', 'AO', 'AQ', 'AR', 'AS',
    'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH',
    'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW',
    'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM',
    'CN', 'CO', 'CR', 'CS', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ',
    'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI',
    'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH',
    'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY',
    'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO',
    'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI',
    'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK',
    'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG',
    'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU',
    'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL',
    'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK',
    'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS',
    'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK',
    'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC',
    'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT',
    'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE',
    'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'YE', 'YT', 'ZA', 'ZM', 'ZW']

# These special codes are allowed for ISIN
_country_codes = set(_iso_3116_1_country_codes + [
    'EU',  # European Union
    'QS',  # internally used by Euroclear France
    'QS',  # temporarily assigned in Germany
    'QT',  # internally used in Switzerland
    'XA',  # CUSIP Global Services substitute agencies
    'XB',  # NSD Russia substitute agencies
    'XC',  # WM Datenservice Germany substitute agencies
    'XD',  # SIX Telekurs substitute agencies
    'XF',  # internally assigned, not unique numbers
    'XK',  # temporary country code for Kosovo
    'XS',  # international securities
])

# the letters allowed in an ISIN
_alphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'


def isin_compact(number):
    """Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace."""
    number.replace(" ", "")
    return number.strip().upper()


def isin_calc_check_digit(number):
    """Calculate the check digits for the number."""
    # convert to numeric first, then double some, then sum individual digits
    number = ''.join(str(_alphabet.index(n)) for n in number)
    number = ''.join(
        str((2, 1)[i % 2] * int(n)) for i, n in enumerate(reversed(number)))
    return str((10 - sum(int(n) for n in number)) % 10)


def isin_validate(number):
    """Check if the number provided is valid. This checks the length and
    check digit.
    (okay,errtext,number) = isin_validate(number)
    """
    okay = hdef.OKAY
    errtext = ""
    number = isin_compact(number)
    if not all(x in _alphabet for x in number):
        okay = hdef.NOT_OKAY
        errtext = f"isin_validate: isin-number {number} has invalid format"
    elif len(number) != 12:
        okay = hdef.NOT_OKAY
        errtext = f"isin_validate: isin-number {number} has invalid length"
    elif number[:2] not in _country_codes:
        okay = hdef.NOT_OKAY
        errtext = f"isin_validate: isin-number {number} has not known country code"
    elif isin_calc_check_digit(number[:-1]) != number[-1]:
        okay = hdef.NOT_OKAY
        errtext = f"isin_validate: isin-number {number} has invalid checksum"
    # end if
    
    return (okay,errtext,number)
# end if

def isin_is_valid(number):
    """Check if the number provided is valid. This checks the length and
    check digit."""
    try:
        (okay,errtext,number) = isin_validate(number)
        if( okay != hdef.OKAY):
            return False
        else:
            return True
    except:
        return False


def isin_from_natid(country_code, number):
    """Generate an ISIN from a national security identifier."""
    number = country_code.upper() + isin_compact(number).zfill(9)
    return number + isin_calc_check_digit(number)
#----------------------------------------------------------------------------------------------------
# isin functions ------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------
def type_proof_wkn(wert_in):
    """ return value str
    """
    
    (okay, wert) = type_proof_string(wert_in)
    
    if (okay == hdef.OKAY):
        
        wkns = find_WKN(wert)
        if (len(wkns) > 0):
            wert = wkns[0]
        else:
            wert = None
            okay = hdef.NOT_OKAY
        # end if
    # end if
    return (okay, wert)


# end def

#----------------------------------------------------------------------------------------------------
# wkn functions start  -----------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------
def find_WKN(S):
    
    
    found = 0
    WKN_list = []
    if found == 0:
        s_liste = S.split()
        n       = len(s_liste)
        indices = [i for i, x in enumerate(s_liste) if (x == "WKN:") or (x == "wkn:")]
        for ind in indices:
            if ind+1 < n:
                canidate = s_liste[ind+1]
                if (len(canidate)==6) and (canidate.isalnum()):
                    WKN_list.append(canidate)
                    found = 1
                # end if
            # end if
        # end if
    # end if
    if found == 0:
        try:
            pattern = r"\b[A-Z0-9]{6}\b"
            WKN_list = re.findall(pattern, S)
            if len(WKN_list): found = 1
        except:
            found = 0
    # end if
    
    # end try
    # if found == 0:
    #     try:
    #
    #         pattern = r"[A-Z0-9]{6}"
    #         WKN_list = re.findall(pattern, S)
    #         if len(WKN_list): found = 1
    #     except:
    #         found = 0
    #     # end try
    # # end if
    if found == 0:
        try:
            
            pattern = r"^[A-Z0-9]{6}$"
            WKN_list = re.findall(pattern, S)
            if len(WKN_list): found = 1
        except:
            found = 0
        # end try
    # end if

    return WKN_list


# end def


def type_proof_euro(wert_in,delim=",",thousandsign="."):
    '''
    
    :param wert_in:
    :param delim:
    :param thousandsign:
    :return: (okay,wert_euro) =  type_proof_euro(wert_in,delim=",",thousandsign=".")
    '''
    okay = hdef.OKAY
    if isinstance(wert_in,float):
        val = wert_in
    elif isinstance(wert_in,int):
        val = float(wert_in)
    else:
        if len(wert_in) == 0:
            val = 0.0
        else:
            try:
                val = numeric_string_to_float(wert_in, delim=delim, thousandsign=thousandsign)
            except:
                val = None
                okay = hdef.NOT_OKAY
            # end try
        # end if
    # end if
    if isinstance(val,float):
        val = float(int((val*100.)+0.5))/100.
    
    return (okay,val)
# end def
def type_proof_euroStrK(wert_in, delim=",", thousandsign="."):
    '''

    :param wert_in:
    :param delim:
    :param thousandsign:
    :return: (okay,wert) =  type_proof_euroStrK(wert_in,delim=",",thousandsign=".")
    '''
    (okay,wert_in) = type_proof_string(wert_in)
    if okay == hdef.OKAY:
        if delim == ",":
            wert_in = check_euroStrK_witheuroStrP(wert_in, delim=delim, thousandsign=thousandsign)
        (okay, wert_euro) = type_proof_euro(wert_in, delim=delim, thousandsign=thousandsign)
        if okay == hdef.OKAY:
            wert = num_euro_in_euroStr(float(wert_euro), delim,thousandsign)
            # wert = hstr.convert_float_euro_to_string_euro(float(wert_euro), delim,thousandsign)
        else:
            wert = None
        # end if
    else:
        wert = None
    # end if
    return (okay, wert)
# end def
def  check_euroStrK_witheuroStrP(wert_in, delim, thousandsign):
    '''
    Prüft, ob nicht ausversehen ein Punkt anstatt Komma gesetzt ist
    
    :param wert_in:
    :param delim:
    :param thousandsign:
    :return: wert_in =  check_euroStrK_witheuroStrP(wert_in, delim, thousandsign)
    '''
    
    list1 = wert_in.split(".")
    n1 = len(list1)
    list2 = list1[-1].split(",")
    n2 = len(list2)
    list = []
    n = 0
    for i in range(n1-1):
        list.append(list1[i])
        n += 1
    # end if
    for i in range(n2):
        list.append(list2[i])
        n += 1
    # end if
    if( n2 > 1 ):
        flag_delim = True
    else:
        flag_delim = False
    # end if
    if (n == 1) or ((thousandsign == ".") and (len(list[-1]) == 3)):        # kein Punkt wird verwendet or wenn das letzte Päcken 3 Stellen sind dann wir von tausender ausgegangen
        pass
    else:
        wert_in = ""
        if flag_delim:
            for i in range(n-1):
                wert_in += list[i]
                if i < (n-2):
                    wert_in += thousandsign
            # end for
            wert_in += delim
            wert_in += list[-1]
        else:
            for i in range(n-1):
                wert_in += list[i]
                if i < (n-2):
                    wert_in += thousandsign
            # end for
            wert_in += list[-1]
        # end if
    # end if
    return wert_in
# end def
def type_proof_cent(wert_in):
    okay = hdef.OKAY
    if is_int(wert_in):
        wert = wert_in
    elif is_float(wert_in):
        wert = int(wert_in + math.copysign(0.5, wert_in))
    elif is_string(wert_in):
        wert = string_euro_in_int_cent(wert_in, delim=",", thousandsign=".")
    else:
        wert = None
        okay = hdef.NOT_OKAY
    # end if
    return (okay,wert)
# end def
def type_proof_percentStr(wert_in):
    '''
    
    :param wert_in:
    :return:
    '''
    (okay, wert) = type_proof_string(wert_in)
    
    if (okay == hdef.OKAY):
        
        wert_val = hstr.elim_ae(wert.replace('%',''),' ')
        (okay,value) = type_transform_euroStrK(wert_val,'euro')
        if okay != hdef.OKAY:
            wert = None
    # end if
    return (okay, wert)


# end def

def type_convert_euro_to_cent(wert_euro,delim=",", thousandsign="."):
    '''
    string_euro_in_int_cent(wert_euro, delim=delim, thousandsign=thousandsign)
    :param wert_euro:
    :return: (okay,wert_cent) =  type_convert_euro_to_cent(wert_euro)
    '''
    (okay, out) = type_proof_euro(wert_euro,delim=delim,thousandsign=thousandsign)
    if okay == hdef.OKAY:
        wert_cent = int(out*100.+math.copysign(0.5,out))
    else:
        wert_cent = None
    # end if
    return (okay,wert_cent)
# end def
def type_convert_to_hashkey(obj, salt=0):
    """
    Create a key suitable for use in hashmaps
  
    :param obj: object for which to create a key
    :type: str, bytes, :py:class:`datetime.datetime`, object
    :param salt: an optional salt to add to the key value
    :type salt: int
    :return: numeric key to `obj`
    :rtype: int
    """
    if obj is None:
        return 0
    if isinstance(obj, str):
        return zlib.crc32(obj.encode(), salt) & 0xffffffff
    elif isinstance(obj, bytes):
        return zlib.crc32(obj, salt) & 0xffffffff
    elif isinstance(obj, int):
        return zlib.crc32(str(obj).encode(), salt) & 0xffffffff
    elif isinstance(obj, float):
        return zlib.crc32(str(obj).encode(), salt) & 0xffffffff
    return hash(obj) & 0xffffffff

# -------------------------------------------------------
def type_transform(wert_in: any, type_in: str | list, type_out: str | list):
    '''
    
    type: "str","float","int","dat","iban"
    "dat": Convert to epoch seconds
    "datStrP": Convert to date string mit Punkt "20.03.2024"
    "datStrB": Convert to date string mit Bindesttrich "20-03-2024"
    "iban": string, 2 letters and 20 digits, could be with spaces
    "str": string
    "int": integer
    "float": floating point
    "list": any list
    "listStr": a list with strings
    "euro": float
    "euroStrK": string mit Komma Trennung ('.' 1000er)   10,34
    "cent": int
    "percentStr"

    (okay,wert) = type_transform(wert_in, type_in, type_out) Prüft den Wert auf seine
    '''
    okay = hdef.OKAY
    if type_in == type_out:
        wert_out = wert_in
    elif type_in == "dat":
        (okay, wert_out) = type_transform_dat(wert_in,type_out)
    elif (type_in == "datStr") or (type_in == "datStrP") or (type_in == "datStrB"):
        (okay, wert_out) = type_transform_datStr(wert_in, type_out)
    elif type_in == "str":
        (okay, wert_out) = type_transform_str(wert_in, type_out)
    elif type_in == "int":
        (okay, wert_out) = type_transform_int(wert_in, type_out)
    elif type_in == "float":
        (okay, wert_out) = type_transform_float(wert_in, type_out)
    elif type_in == "euro":
        (okay, wert_out) = type_transform_euro(wert_in, type_out)
    elif type_in == "euroStrK":
        (okay, wert_out) = type_transform_euroStrK(wert_in, type_out)
    elif type_in == "cent":
        (okay, wert_out) = type_transform_cent(wert_in, type_out)
    elif type_in == "percentStr":
        (okay, wert_out) = type_transform_percentStr(wert_in, type_out)
    elif isinstance(type_in, list):
        # if wert_in == "Kirchensteuer":
        #    print("halt")
        (okay, wert_out) = type_transform_list(wert_in, type_in,type_out)
        
    else:
        okay = hdef.NOT_OKAY
        wert_out = None
        raise Exception(f"type_transform: type_in = {type_in} not known")
    # end if
    return (okay,wert_out)
# end def
def  type_transform_dat(wert_in,type_out):
    '''
    :param wert_in:
    :param type_out:
    :return: (okay, wert_out) =  type_transform_dat(wert_in,type_out)
    '''
    (okay, wert) = type_proof(wert_in, 'dat')
    if( okay == hdef.OKAY):
        if (type_out == "datStr") or (type_out == "datStrP"):
            wert_out = hdate.secs_time_epoch_to_str(wert,delim=".")
        elif type_out == "datStrB":
            wert_out = hdate.secs_time_epoch_to_str(wert,delim="-")
        elif type_out == "int":
            wert_out = int(wert)
        else:
            raise Exception(f"In type_transform_dat ist type_out: {type_out} nicht möglich")
        # end if
    else:
        wert_out = wert
    # end if
    return (okay,wert_out)
# end def
def  type_transform_datStr(wert_in,type_out):
    '''
    :param wert_in:
    :param type_out:
    :return: (okay, wert_out) =  type_transform_dat_StrP(wert_in,type_out)
    '''
    (okay, wert) = type_proof(wert_in, 'dat')
    if( okay == hdef.OKAY):
        if type_out == "dat":
            wert_out = wert
        elif type_out == "int":
            wert_out = int(wert)
        else:
            raise Exception(f"In type_transform_datStrP ist type_out: {type_out} nicht möglich")
        # end if
    else:
        wert_out = wert
    # end if
    return (okay,wert_out)
# end def
def  type_transform_str(wert_in,type_out):
    '''
    :param wert_in:
    :param type_out:
    :return: (okay, wert_out) =  type_transform_dat_str(wert_in,type_out)
    '''
    (okay, wert) = type_proof(wert_in, "str")
    if( okay == hdef.OKAY):
        if (type_out == "float"):
            index = hstr.such(wert_in,",","rs")
            if index >= 0:
                wert = hstr.change_at_index(wert_in, index, 1, '.')
            else:
                wert = wert_in
            # end if
            try:
                wert_out = float(wert)
            except:
                okay = hdef.NOT_OKAY
                wert_out = None
            # end try
        elif (type_out == "euro"):
            index = hstr.such(wert_in,",","vs")
            if index >= 0:
                (okay, wert_out) = type_transform_euroStrK(wert_in,"float")
                if okay == hdef.OKAY:
                    wert = wert_out
                else:
                    wert = wert_in
                # end if
            else:
                wert = wert_in
            # end if
            try:
                wert_out = float(wert)
            except:
                okay = hdef.NOT_OKAY
                wert_out = None
            # end try

        elif (type_out == "int"):
            index = hstr.such(wert_in,",","vs")
            if index >= 0:
                (okay, wert_out) = type_transform_euroStrK(wert_in,"euro")
                if okay == hdef.OKAY:
                    wert = wert_out
                else:
                    wert = wert_in
                # end if
            else:
                wert = wert_in
            # end if
            try:
                wert_out = int(wert)
            except:
                okay = hdef.NOT_OKAY
                wert_out = None
            # end try
        elif (type_out == "cent"):
            index = hstr.such(wert_in,",","vs")
            if index >= 0:
                (okay, wert_out) = type_transform_euroStrK(wert_in,"cent")
                if okay == hdef.OKAY:
                    wert = wert_out
                else:
                    wert = wert_in
                # end if
            else:
                wert = wert_in
            # end if
            try:
                wert_out = int(wert)
            except:
                okay = hdef.NOT_OKAY
                wert_out = None
            # end try

        elif type_out == "euroStrK":
            (okay, wert_out) = type_proof(wert, "euro")
            if okay == hdef.OKAY:
                wert_out = hstr.convert_float_euro_to_string_euro(wert_out, ",")
            # end if
        elif type_out == "dat" or type_out == "date":
            (okay, wert_out) = type_proof(wert, type_out)
        elif (type_out == "list") or (type_out == "listStr") or (type_out == "list_str"):
            wert_out = [wert]
        elif type_out == "isin":
            (okay, wert_out) = type_proof(wert, type_out)
        else:
            raise Exception(f"type_transform_str: In type_transform_str ist type_out: {type_out} nicht möglich")
        # end if
    else:
        wert_out = wert
    # end if
    return (okay,wert_out)
# end def
def  type_transform_int(wert_in,type_out):
    '''
    :param wert_in:
    :param type_out:
    :return: (okay, wert_out) =  type_transform_dat_int(wert_in,type_out)
    '''
    (okay, wert) = type_proof(wert_in, "int")
    if( okay == hdef.OKAY):
        if isinstance(type_out, list):
            if wert in range(len(type_out)) :
                wert_out = type_out[wert]
            else:
                okay = hdef.NOT_OKAY
                wert_out = None
            # end if
        if (type_out == "float") or (type_out == "euro"):
            (okay, wert_out) = type_proof(wert, type_out)
        elif type_out == "cent":
            wert_out = wert
        elif type_out == "str":
            (okay, wert_out) = type_proof(wert, "str")
        elif type_out == "euroStrK":
            wert_out = num_cent_in_euroStr(float(wert))
        elif type_out == "list":
            wert_out = [wert]
        elif (type_out == "listStr") or (type_out == "list_str") :
            wert_out = [str(wert)]
        else:
            raise Exception(f"In type_transform_int ist type_out: {type_out} nicht möglich")
        # end if
    else:
        wert_out = wert
    # end if
    return (okay,wert_out)
# end def
def  type_transform_float(wert_in,type_out):
    '''
    :param wert_in:
    :param type_out:
    :return: (okay, wert_out) =  type_transform_dat_int(wert_in,type_out)
    '''
    (okay, wert) = type_proof(wert_in, "float")
    if( okay == hdef.OKAY):
        if (type_out == "euro"):
            wert_out = wert
        elif  (type_out == "int") or (type_out == "cent"):
            wert_out = int(wert)
        elif type_out == "str":
            (okay, wert_out) = type_proof(wert, "str")
        elif type_out == "euroStrK":
            (okay, wert_out) = type_proof(wert, "euro")
            if okay == hdef.OKAY:
                wert_out = num_cent_in_euroStr(wert_out)
            # end if
        elif type_out == "list":
            wert_out = [wert]
        elif (type_out == "listStr") or (type_out == "list_str") :
            wert_out = [str(wert)]
        else:
            raise Exception(f"In type_transform_int ist type_out: {type_out} nicht möglich")
        # end if
    else:
        wert_out = wert
    # end if
    return (okay,wert_out)
# end def
def  type_transform_euro(wert_in,type_out):
    '''
    :param wert_in:
    :param type_out:
    :return: (okay, wert_out) =  type_transform_dat_euro(wert_in,type_out)
    '''
    (okay, wert) = type_proof(wert_in, "euro")
    if( okay == hdef.OKAY):
        if (type_out == "euro"):
            wert_out = wert
        elif  (type_out == "int") or (type_out == "cent"):
            wert_out = int(wert)
        elif type_out == "str":
            (okay, wert_out) = type_proof(wert, "str")
        elif type_out == "float":
            wert_out = float(wert)
        elif type_out == "euroStrK":
            wert_out = num_euro_in_euroStr(wert)
        elif type_out == "list":
            wert_out = [wert]
        elif (type_out == "listStr") or (type_out == "list_str") :
            wert_out = [str(wert)]
        else:
            raise Exception(f"In type_transform_int ist type_out: {type_out} nicht möglich")
        # end if
    else:
        wert_out = wert
    # end if
    return (okay,wert_out)
# end def
def  type_transform_euroStrK(wert_in,type_out):
    '''
    :param wert_in:
    :param type_out:
    :return: (okay, wert_out) =  type_transform_dat_euroStrK(wert_in,type_out)
    '''
    (okay, wert) = type_proof(wert_in, "euroStrK")
    if( okay == hdef.OKAY):
        if (type_out == "euro") or (type_out == "float"):
            wert_out = numeric_string_to_float(wert)
        elif type_out == "int":
            wert_out = int(numeric_string_to_float(wert))
        elif type_out == "cent":
            wert_out = string_euro_in_int_cent(wert)
        elif type_out == "str":
            (okay, wert_out) = type_proof(wert, "str")
        elif (type_out == "list") or (type_out == "listStr") or (type_out == "list_str"):
            wert_out = [wert]
        else:
            raise Exception(f"In type_transform_int ist type_out: {type_out} nicht möglich")
        # end if
    else:
        wert_out = wert
    # end if
    return (okay,wert_out)
# end def
def  type_transform_cent(wert_in,type_out):
    '''
    :param wert_in:
    :param type_out:
    :return: (okay, wert_out) =  type_transform_dat_int(wert_in,type_out)
    '''
    (okay, wert) = type_proof(wert_in, "cent")
    if( okay == hdef.OKAY):
        if (type_out == "float") or (type_out == "euro"):
            wert_out = num_cent_in_euro(wert)
        elif type_out == "int":
            wert_out = int(wert)
        elif type_out == "str":
            (okay, wert_out) = type_proof(wert, "str")
        elif type_out == "euroStrK":
            wert_out = num_cent_in_euroStr(float(wert))
        elif type_out == "list":
            wert_out = [wert]
        elif (type_out == "listStr") or (type_out == "list_str") :
            wert_out = [str(wert)]
        else:
            wert_out = None
            raise Exception(f"type_transform_cent: In type_transform_int ist type_out: {type_out} nicht möglich")
        # end if
    else:
        wert_out = wert
    # end if
    return (okay,wert_out)
# end def
def type_transform_percentStr(wert_in, type_out):
    '''
    
    :param wert_in:
    :param type_out:
    :return: (okay, wert_out) = type_transform_percentStr(wert_in, type_out):
    '''
    (okay, wert) = type_proof(wert_in, "percentStr")
    if okay == hdef.OKAY:
        if type_out == "str":
            wert_out = wert
        elif type_out == "int":
            wert = hstr.elim_ae(wert.replace('%', ''),' ')
            (okay, wert_out) = type_transform(wert, "str", "int")
        elif type_out == "float":
            wert = hstr.elim_ae(wert.replace('%', ''), ' ')
            (okay,wert_out) = type_transform(wert,"str","float")
        else:
            wert_out = None
            raise Exception(f"type_transform_percentStr: In type_transform_int ist type_out: {type_out} nicht möglich")
        # end if
    else:
        wert_out = None
    # end if
    return (okay,wert_out)
# end def
def type_transform_list(wert_in,liste,type_out):
    '''
    :param wert_in:
    :param type_out:
    :return: (okay, wert_out) =  type_transform_list(wert_in,type_out)
    '''
    okay = hdef.NOT_OKAY
    if isinstance(liste,list):
        if (type_out == "int"):
            wert_out = find_value_in_list(wert_in,liste)
            if wert_out != None:
                okay = hdef.OKAY
            # end if
        elif isinstance(type_out,list):
            index = find_value_in_list(wert_in, liste)
            if index != None:
                n = len(type_out)
                if n > index:
                    wert_out = type_out[index]
                    okay = hdef.OKAY
                else:
                    wert_out = None
                # end if
            else:
                wert_out = None
            # end if
        else:
            wert_out = None
            raise Exception(f"In type_transform_int ist type_out: {type_out} nicht möglich")
        # end if
    else:
        wert_out = None
    # end if
    return (okay,wert_out)
# end def
def find_value_in_list(wert_in,liste):
    index = None
    counter = 0
    for item in liste:
        if isinstance(item,list):
            index1 = find_value_in_list(wert_in,item)
            if index1 != None:
                index = counter
                break
            # end if
        else:
            if wert_in == item:
                index = counter
                break
            # end if
        # end if
        counter += 1
    # end for
    return index
# end def
def print_python_is_32_or_64_bit():
    print(struct.calcsize("P") * 8)


###########################################################################
# testen mit main
###########################################################################
if __name__ == '__main__':
    
    wert = numeric_string_to_float("154.372,55",delim=",",thousandsign=".")
    (okay,value) = type_proof_isin("DE0007030009")
    (okay,value) = type_proof_isin("EU000A1HBXS7")

    (okay,val) = type_proof_euro("10,220.23",delim=".",thousandsign=",")
    val = string_euro_in_int_cent("10.220,23", delim=",", thousandsign=".")
    
    print(f" val : {val}")
    
    (okay, out) = type_proof("Zins/Dividende ISIN IE00BM8R0J59 GL X-N.10", "isin")

    print(f"okay: {okay}, out : {out}")
    
    # ^([A-Z]{2})([A-Z0-9]{9})([0-9]{1})$

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
