# -*- coding: utf8 -*-
#
# 18.06.23 von hfkt.py
#############################

##################################################################################
# Sonstiges
###################################################################################
'''
 value = str_to_float_possible(string_val),  if not possible value = None
 ival  = str_to_int_possible(string_val),  if not possible ival = None
 def int_to_dec36(int_val,digits=0):
 def dec36_to_int(string_val):
 def summe_euro_to_cent(text,delim=","):
 def suche_in_liste(liste,gesucht):
 def int_akt_datum():
 def int_akt_time():
 def str_akt_datum():
 def str_datum(int_dat):
 secs = secs_akt_time_epoch()
 secs = secs_time_epoch_from_int(intval)
 secs = secs_time_epoch_from_str_re(str_dat)
 secs = secs_time_epoch_from_str(str_dat,delim=".")
 secs = secs_time_epoch_from_int(intval,plus_hours)
 string = secs_time_epoch_to_str(secs): Wandelt in string Datum
 int    = secs_time_epoch_to_int(secs): Wandelt in int Datum
 flag   = datum_str_is_correct(str_dat,delim=".")
 strnew = datum_str_make_correction(str_dat,delim=".")
 daystr = day_from_secs_time_epoch(secs): Man bekommt den Tag in Mo,Di,Mi,Do,Fr,Sa,So
 daystr = day_from_datum_str(str_dat,delim="."): Man bekommt den Tag in Mo,Di,Mi,Do,Fr,Sa,So
 def datum_str_to_intliste(str_dat,delim="."): Wandelt string in eine Liste
 def datum_intliste_to_int(dat_l):  Wandelt Liste in ein int
 def datum_int_to_intliste(intval): int -> liste
 def datum_str_to_int(str_dat,delim="."): Wandelt string in ein int
 def datum_intliste_to_str(int_liste,delim="."):
 def datum_str_to_year_int(str_dat,delim="."):
 def datum_str_to_month_int(str_dat,delim="."):
 def datum_str_to_day_int(str_dat,delim="."):
 def secs_time_epoch_find_next_day(secs,idaynext):
 flag =  is_datum_str(str_dat,delim=".")   flag = True/False
 def get_name_by_dat_time(pre_text,post_text) Gibt Name gebildet aus localtime und text
 def diff_days_from_time_tuples(time_tuple_start,time_tuple_end) Bildet die Differenz der Tage über 0:00
 def string_cent_in_euro(cents):
 def num_cent_in_euro(cents):
 int = string_euro_in_int_cent(teuro,delim=",") Wandelt einen String mit Euro in Cent
 def dat_last_act_workday_datelist(year,mon,day): Sucht letzten aktuellen Werktag in  [year,month,day]
 int days_of_month(mon,year): gibt anzahl Tage für den Monat
 (okay,value) =  str_to_float(string) wandelt string in float, wenn nicht erreichr okay = false
 flag = is_string(val)  Prüft, ob Type string flag = True/False
 flag = is_unicode(val)  Prüft, ob Type unicode flag = True/False
 flag = is_list(val)  Prüft, ob Type liste flag = True/False
 flag = is_dict(val)  Prüft, ob Type dictionary flag = True/False
 flag = isfield(c,'valname') Prüft ob eine Klasse oder ein dict die instance hat
 flag = isempty(val) Prüft, ob leer nach type
 print_python_is_32_or_64_bit
 ---------------------------------
 multiply_constant(list,const)  multiplies a list with const value

'''

from tkinter import *
from tkinter.constants import *
import tkinter.filedialog
import tkinter.messagebox
import string
import types
import copy
import sys
import os
import re
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

###################################################################################
# Sonstiges
###################################################################################
def str_to_float_possible(string_val):
  """
  value= str_to_float_possible(string_val)
  if okay value = float(string_val)
  else    value = None
  """
  okay = 0
  index0 = 0
  n1     = 0
  maxdig = 0
  n = len(string_val)
  try:
    return float(string_val)
  except ValueError:
    for istart in range(n):
      for nend in range(istart+1,n+1,1):
        tt = string_val[istart:nend]
        try:
          f = float(tt)
          if( len(tt) > maxdig ):
            maxdig = len(tt)
            index0 = istart
            n1     = nend
          #endif
        except ValueError:
          pass
        #endtry
      #endfor
    #endfor
  #endtry
  if( maxdig > 0 ):
    return float(string_val[index0:n1])
  else:
    return None
#enddef
def str_to_int_possible(string_val):
  """
  value= str_to_int_possible(string_val)
  if okay value = int(string_val)
  else    value = None
  """
  try:
    return int(string_val)
  except ValueError:
    value = str_to_float_possible(string_val)
    if( value ): return int(value)
    else:        return None
#enddef

dec36_dict={0 :'0', 1:'1', 2:'2', 3:'3', 4:'4', 5:'5', 6:'6', 7:'7', 8:'8', 9:'9', \
            10:'a',11:'b',12:'c',13:'d',14:'e',15:'f',16:'g',17:'h',18:'i',19:'j', \
            20:'k',21:'l',22:'m',23:'n',24:'o',25:'p',26:'q',27:'r',28:'s',29:'t', \
            30:'u',31:'v',32:'w',33:'x',34:'y',35:'z'}

def int_to_dec36(int_val,digits=0):


    int_val = int(int_val)
    liste = []
##    if( int_val < 36 ):
##
##        value = dec36_dict[int_val]
##    else:

    while True :

        if( int_val > 35 ):

            liste.append(int_val%36)
            int_val = int_val/36
        else:
            liste.append(int_val)
            break

    value = ''
    if( len(liste) < digits ):
        for i in range(digits,len(liste),-1):
            value += '0'

    try:
      for i in range(len(liste)-1,-1,-1):
          value += dec36_dict[liste[i]]

    except:
      print("wraning: int_to_dec36(int_val) ging schief")

    return value

def dec36_to_int(string_val):

    string_val = str(string_val)
    erg = 0
    for s in string_val:
        for (i0,a0) in dec36_dict.items():

            if( a0 == s ):

                erg = erg*36+i0
                break

    return erg
def summe_euro_to_cent(text,delim=","):
    """ Umrechnung Euro (Text) in Cent (int) """
    text1 = elim_ae(text," ")

    fact = 1
##    if( text1 == "-92,7" ):
##        flag = True
##    else:

    flag = False

    if( text1[0] == "-" ):
        fact  = -1
        text1 = text1[1:]
    elif( text[0] == "+" ):
        fact  = 1
        text1 = text1[1:]

    text1 = elim_ae(text1," ")

    liste = text1.split(delim)

    if( flag ):
        print(liste)
    summe = 0

    if( len(liste) >= 1 ):
        summe = summe + int(liste[0])*100

    if( len(liste) >= 2 ):
        tdum = liste[1]
        if( len(tdum) >= 1 ):
            summe = summe + int(tdum[0])*10
        if( len(tdum) >= 2 ):
            summe = summe + int(tdum[1])


    return summe*fact

def suche_in_liste(liste,gesucht):
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

def secs_akt_time_epoch():
  """
  Aktuelle Zeit in Sekunden seit 1.1.1970 12:00 am
  """
  return int(time.time())

def secs_time_epoch_from_int(intval,plus_hours=0):
  """
  Das Int-Datum intval (z.B. 20161217) wird in Sekunden in epochaler Zeit umgerechnet
  Zusätzlich können Stunden dazu addiert werden
  secs = secs_time_epoch_from_int(intval)
  secs = secs_time_epoch_from_int(intval,12)
  """
  liste = datum_int_to_intliste(intval)
  t = (liste[2], liste[1], liste[0], plus_hours, 0, 0, 0, 0, 0)
  return time.mktime( t )

def secs_time_epoch_from_str_re(str_dat):
  """
  Das Str-Datum  (z.B. "17.12.2004", "17-12-2004", "17/12/2004") wird mit re versucht zu erkennen und
  in Sekunden in epochaler Zeit umgerechnet
  secs = secs_time_epoch_from_str_datefinder(str_dat)
  """
  pattern = r"\b([1-9]|0[1-9]|1[0-9]|2[0-9]|3[0-1])[-/\.]([1-9]|0[1-9]|[12]\d|3[01])[-/\.](19\d\d|20\d\d|\d\d)\b"
  form    = "%d.%m.%Y"

  dates = re.findall(pattern, str_dat)
  liste = []
  for d in dates:
    strdat = d[0]+"."+d[1]+"."
    if( len(d) == 2 ):
      strdat += str(datetime.datetime.now().year)
    else:
      if( len(d[2]) <= 2 ):
        strdat += "20"+d[2]
      else:
        strdat += d[2]
      #endif
    #endif

    t = datetime.datetime.strptime(strdat, form)
    liste.append(int(t.timestamp()))
  # endfor
  
  if( len(liste) == 1 ):
    return liste[0]
  elif( len(liste) > 1 ):
    return liste
  else:
    return int(0)
  #endif
#enddef
#----------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------
def secs_time_epoch_from_str(str_dat,delim="."):
  """
  Das Str-Datum intval (z.B. "17.12.2004") wird in Sekunden in epochaler Zeit umgerechnet
  secs = secs_time_epoch_from_str(str_dat,delim=".")
  """
  form = "%d"+delim+"%m"+delim+"%Y"
  if( isinstance(str_dat,list) ):
    ll = []
    for stri in str_dat:
        str_to_dt = datetime.datetime.strptime(stri, form)
        ll.append(int(str_to_dt.timestamp()))
    #endfor
    return ll
  else:
    str_to_dt = datetime.datetime.strptime(str_dat, form)
    return int(str_to_dt.timestamp())
def secs_time_epoch_to_str(secs):
  """
  Wandelt epochen Zeist in secs nach Datum tt.m.yyyy
  """
  if( isinstance(secs,list)):
      strtime = []
      for seci in secs:
          strtime.append(datetime.datetime.fromtimestamp(seci).strftime("%d.%m.%Y"))
      return strtime
  else:
      dt = datetime.datetime.fromtimestamp(secs)
      return dt.strftime("%d.%m.%Y")
def secs_time_epoch_to_int(secs):
  """
  Wandelt epochen Zeit in secs nach int jjjjmmtt
  """
  return datum_str_to_int(secs_time_epoch_to_str(secs))
def datum_str_to_secs(str_dat,delim="."):
  """
  Wandelt Datum tt.m.yyyy nach epochen Zeist in secs
  """
  int_dat = datum_str_to_int(str_dat,delim)
  return secs_time_epoch_from_int(int_dat)
def intliste_akt_datum():
    """ Das aktuelle Datum wird in integer liste zurückgegeben
        format: [tag,monat,jahr]
    """
    t = time.localtime()
    return [t[2],t[1],t[0]]

def int_akt_datum():
    """ Das aktuelle Datum wird in integer zurückgegeben
        format: jjjjmmtt
    """
    t = time.localtime()
    return t[2]+t[1]*100+t[0]*10000

def int_akt_time():
    """ Das aktuelle Datum wird in integer zurückgegeben
        format: hhmmss
    """
    t = time.localtime()
    return t[5]+t[4]*100+t[3]*10000

def str_akt_datum():
    """ Das aktuelle Datum wird als string zurückgegeben
        format: tt.mm.jjjj
    """
    t = time.localtime()

    st = get_str_from_int(t.tm_mday,2)+"."+get_str_from_int(t.tm_mon,2)+"."+get_str_from_int(t.tm_year,4)
    return st

def str_akt_time():
    """ Das aktuelle Zeit wird als string zurückgegeben
        format: hh.mm.ss
    """
    t = time.localtime()
    st = get_str_from_int(t.tm_hour,2)+":"+get_str_from_int(t.tm_min,2)+":"+get_str_from_int(t.tm_sec,2)
    return st
def str_datum(int_dat):
    """ Das mit int_akt_datum erstellte Datum int_dat wird als string zurückgegeben
        format: jjjjmmtt -> tt.mm.jjjj
    """
    jahr  = int(int_dat/10000)
    monat = int((int_dat - jahr*10000)/100)
    tag   = int(int_dat - jahr*10000 - monat*100)

    st = ("%s" % tag) + (".%s" % monat) + (".%s" % jahr)
    return st
#----------------------------------------------
def datum_str_make_correction(str_dat,delim="."):
    """
    string datum muss tt.mm.jjjj sein
    Korrigiert tt.mm.jj zu tt.mm.jjjj
    """


    liste = datum_str_to_intliste(str_dat,delim=delim)
    liste2 = datum_intliste_make_correction(liste)
    str_dat = datum_intliste_to_str(liste2)

    return str_dat
#enddef
def datum_intliste_make_correction(intliste):
    """
    intliste datum mit [tt,mm,jjjj] wird
    korrigiert
    """

    if( len(intliste) >= 3 ):

        # Monat
        if( intliste[1] > 12 ):
            intliste[1] = 12

        # Jahr
        liste_akt = intliste_akt_datum()

        ty_akt = math.floor(liste_akt[2]/100)*100
        ty = math.floor(intliste[2]/100)*100

        if( ty == 0 ):
            intliste[2] += ty_akt
        elif( ty > ty_akt ):
           intliste[2] -= ty
           intliste[2] += ty_akt
        #endif

        # Tage
        days = days_of_month(intliste[1],intliste[2])
        if( intliste[0] > days):
            intliste[0] = days
        #endif
    #endif

    return intliste
#enddef
def days_of_month(mon,year):
    """
     gibt anzahl Tage für den Monat
    """
    mon = int(mon)
    year = int(year)

    if( mon > 12):
        mon = 12
    #endfi

    if( mon in [1,3,5,7,8,10,12]):
        days = 31
    elif( mon == 2):
        if( (year % 4) == 0 ):
            days = 29
        else:
            days = 28
    else:
        days = 30
    #endif
    return days
#enddef

#----------------------------------------------
def datum_str_is_correct(str_dat,delim="."):
    """
    string datum muss tt.mm.jjjj sein
    flag = datum_str_is_correct(str_dat)
    flag = True/False
    """
    liste  = str_dat.split(delim)

    if( len(liste) < 3 ): return False

    intliste = datum_str_to_intliste(str_dat=str_dat,delim=delim)

    if( intliste[0] == 0 ): return False
    if( intliste[1] == 0 ): return False
    if( intliste[0] > 31 ): return False
    if( intliste[1] > 12 ): return False

    return True

#----------------------------------------------
def day_from_secs_time_epoch(secs):
    """
    Man bekommt den Tag in Mo,Di,Mi,Do,Fr,Sa,So
    """
    return day_from_datum_str(secs_time_epoch_to_str(secs))
#----------------------------------------------
def day_from_datum_str(str_dat,delim="."):
    """
    Man bekommt den Tag in Mo,Di,Mi,Do,Fr,Sa,So
    von 'dd.mm.yyyy'
    """
    days =["Mo", "Di", "Mi", "Do","Fr", "Sa", "So"]
    return days[daynum_from_datum_str(str_dat,delim)]
#----------------------------------------------
def daynum_from_secs_time_epoch(secs):
    """
    Man bekommt den Tag in 0-6  0:Mo, 6:So
    """
    return daynum_from_datum_str(secs_time_epoch_to_str(secs))
#----------------------------------------------
def daynum_from_datum_str(str_dat,delim="."):
    """
    Man bekommt den Tag in 0-6  0:Mo, 6:So
    von 'dd.mm.yyyy'
    """
    day, month, year = (int(i) for i in str_dat.split(delim))
    dayNumber = calendar.weekday(year, month, day)

    return dayNumber
#----------------------------------------------
def secs_time_epoch_find_next_day(secs,idaynext):
    """
    von akt_datum (in secs_time_epoch) den nächsten Wochentag finden
    idaynext = 0:Mo - 6:So
    """
    idayact = daynum_from_secs_time_epoch(secs)

    diday = idaynext - idayact

    if( diday <= 0 ):
        diday = 7+diday

    return (secs + 86400*diday)
#----------------------------------------------
def datum_str_to_intliste(str_dat,delim="."):
    """ Das string-Datum z.B <12.5.04> wird
        in [tag,monat,jahr] gewandelt [12,5,2004]
    """

    if( len(str_dat) == 0 ):
        return [0,0,0]

    liste  = str_dat.split(delim)

    l=[]
    for v in liste:
        l.append(int(v))

    n = len(l)

    if( n == 0 ):
        return [0,0,0]
    else:
        if( l[n-1] < 70 ):
            l[n-1] = l[n-1]+2000
        elif( l[n-1] < 100 ):
            l[n-1] = l[n-1]+1900

    if( n == 1 ):
            return [1,1,l[0]]
    if( n == 2 ):
            return [1,l[0],l[1]]
    if( n >= 3 ):
            return [l[0],l[1],l[2]]
#----------------------------------------------
def datum_intliste_to_int(dat_l):
    """ Die Liste [tag,monat,jahr] wird in int gewandelt
        [12,5,2004] => 20040512
    """
    return dat_l[0]+dat_l[1]*100+dat_l[2]*10000
#----------------------------------------------
def datum_int_to_intliste(intval):
    """ Die Zahle intval wird in eine Liste [tag,monat,jahr] gewandelt
        20040512 => [12,5,2004]
    """
    dat_l = []
    dat_l.append(intval - int(intval /100)*100)
    dat_l.append(int((intval - int(intval /10000)*10000)/100))
    dat_l.append(int(intval /10000))

    return dat_l
#----------------------------------------------
def datum_str_to_int(str_dat,delim="."):
    """
    Das string-Datum z.B <12.5.04> wird
    in eine int Zahl gewandelt z.B. 20040504
    """
    return datum_intliste_to_int(datum_str_to_intliste(str_dat,delim))

def datum_intliste_to_str(int_liste,delim="."):
    """ Wandelt Datumliste z.B (12,5,2004) in
        in "tag.monat.jahr" um "12.05.2004"
    """
    if( len(int_liste) >= 1 ):
        datum = "%2.2i"%int_liste[0] + delim
    if( len(int_liste) >= 2 ):
        datum += "%2.2i"%int_liste[1] + delim
    if( len(int_liste) >= 3 ):
        datum += "%2.2i"%int_liste[2]
    return datum
def datum_akt_year_int():
    """
    aktuelle Jahr in int z.B. 2017
    """
    t = time.localtime()
    return t.tm_year

def datum_str_to_year_int(str_dat,delim="."):
    """ Das string-Datum z.B <12.5.04> wird
        in 2004 gewandelt Nur das Jahr
    """
    liste  = str_dat.split(delim)

    year = int(liste[-1])

    if( year < 70 ):
            year = year+2000
    elif( year < 100 ):
            year = year+1900
def datum_str_to_month_int(str_dat,delim="."):
    """ Das string-Datum z.B <12.5.04> wird
        in 5 gewandelt Nur den Monat
    """
    liste  = str_dat.split(delim)

    month = int(liste[1])

    if( month < 1 ):
            month = 1
    elif( month > 12 ):
            month = 12

    return month
def datum_str_to_day_int(str_dat,delim="."):
    """ Das string-Datum z.B <12.5.04> wird
        in 12 gewandelt Nur den Tag
    """
    liste  = str_dat.split(delim)

    day = int(liste[0])

    if( day < 1 ):
            day = 1
    elif( day > 31 ):
            day = 12

    return day
def is_datum_str(str_dat,delim="."):
    """ Prüft, ob str_dat ein Datum wie 01.03.2005 ist
    """
    flag = True
    liste  = str_dat.split(delim)
    try:
        if( len(liste) < 3 ): #dreiteilig
            flag = False
        elif( int(liste[0]) > 31 or int(liste[0]) < 1 ): #tag 1-31
            flag = False
        elif( int(liste[1]) > 12 or int(liste[1]) < 1 ): #monat 1-12
            flag = False
        elif( int(liste[2]) > 99 and int(liste[2]) < 1970 ): #jahr 0-99 oder 1970-20xx
            flag = False
    except:
        flag = False
    return flag
def get_name_by_dat_time(pre_text="",post_text="",form_type=0):
    """
    Gibt Name gebildet aus localtime und pre_text und post_text
    form_type == 0
    zB 25.8.2006 12:43:02 => pre_text+20060825_124302+post_text
    form_type == 1
    zB 25.8.2006 12:43:02 => pre_text+0608251243+post_text
    """
    t = time.localtime()
    text =  pre_text
    if( form_type == 0 ):
      text += "%4.4i" % t[0]  #jahr
      text += "%2.2i" % t[1]  # mon
      text += "%2.2i_" % t[2] # tag
      text += "%2.2i" % t[3]  # stunde
      text += "%2.2i" % t[4]  # minute
      text += "%2.2i" % t[5]  # sekunde
    elif( form_type == 1 ):
      jahr = t[0]-int(t[0]/100)*100
      text += "%2.2i" % jahr  #jahr
      text += "%2.2i" % t[1]  # mon
      text += "%2.2i" % t[2]  # tag
      text += "%2.2i" % t[3]  # stunde
      text += "%2.2i" % t[4]  # minute
    text += post_text
    return text

def diff_days_from_time_tuples(time_tuple_start,time_tuple_end):
  """
  Gibt an die Differenz an Tagen zu time_tuple
  z.B. time_tuple = time.localtime()
  """
  fac = 1.0
  time_sec_start = time.mktime(time_tuple_start)
  time_sec_end   = time.mktime(time_tuple_end)

  if( time_sec_start > time_sec_end ):
    fac = -1.0
    dum = time_sec_start
    time_sec_start = time_sec_end
    time_sec_end   = dum

  delta_sec = time_sec_end -time_sec_start
  days      = int(delta_sec / 86400.)
  time_tuple = time.gmtime(time_sec_start+days*86400.)
  if( (time_tuple[0] == time_tuple_end[0]) and \
      (time_tuple[1] == time_tuple_end[1]) and \
      (time_tuple[2] == time_tuple_end[2])     ):
    pass
  else:
    days += 1

  return int(days*fac)

def string_cent_in_euro(cents):
    """ Wandelt string cents in "xx,yy €"
    """
    return str(float(cents)/100)+" €"

def num_cent_in_euro(cents):
    """ Wandelt num cents in "xx,yy €"
    """
    return "%.2f"%(float(cents)/100)+" €"
def string_euro_in_int_cent(teuro,delim=","):
    """
    Wandelt einen String mit Euro z.B. "4.885,66"
    in (int)488566
    """
    # Wenn Trennzeichen nicht Punkt, dann
    # nehm den Tausender-Punkt raus
    if( delim != "." ):
        teuro = change(teuro,delim,"")
    # Tausche Trennzeichen gegen Punkt
    teuro = change(teuro,delim,".")
    # Wandele in cent
    return int(float(teuro)*100)
##def dat_last_act_workday_datelist(year=None,month=None,day=None):
##    """
##    Sucht letzten Werktag von year,month,day Ausgabe in  [year,month,day]
##    bzw. aktuelles Datum, wenn kein Argument
##    """
##    if( is_list(year) ):
##        ll = len(year)
##        if( ll >= 3 ):
##            d = datetime.date(int(year[0]) \
##                             ,max(1,min(int(year[1]),12)) \
##                             ,max(1,min(int(year[2]),)
##        elif( ll == 2 ):
##            d = datetime.date(int(year[0]),int(year[1]),1)
##        elif( ll == 1 ):
##            d = datetime.date(int(year[0]),1,1)
##    elif( year == None or month == None or day == None):
##        d = datetime.date.today()
##    else:
##        d = datetime.date(int(year),int(month),int(day))
##
##    if( d.weekday() == 5 ):    # Samstag
##        d = d + datetime.timedelta(days=-1)
##    elif( d.weekday() == 6 ):    # Sonntag
##        d = d + datetime.timedelta(days=-2)
##
##    return d.timetuple()[0:3]
##
def str_to_float(txt):
  try:
    value = float(txt)
    okay  = True
  except:
    value = 0.0
    okay = False

  return (okay,value)
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
  return isinstance(val,list)
def is_tuple(val):
  '''
  Prüft, ob Type Tuple flag = True/False
  '''
  return isinstance(val,tuple)
def is_dict(val):
  '''
  Prüft, ob Type Liste flag = True/False
  '''
  return isinstance(val,dict)

def isfield(c,valname):
  '''
  Prüft ob eine Klasse oder ein dict die instance hat
  '''
  flag = False
  if( isinstance(valname, str) ):
    if( not isinstance(c,dict) ):
      a = c.__dict__
      flag = valname in a
    elif( isinstance(c,dict)  ):
      flag = valname in c

  return flag

#-------------------------------------------------------
def isempty(val):
  """
  prüft nach type, ob wert leer
  """
  flag = True
  if( val == None ):
    pass
  elif( isinstance(val, str)):
    if( len(val) > 0 ): flag = False
  elif( is_list(val) or is_tuple(val) or isinstance(val,dict) ):
    if( len(val) > 0 ): flag = False
  elif( isinstance(val, int) or isinstance(val, float) ):
    flag = False
  else:
    print("hfkt.isempty kennt den type nicht: %s" % type(val))
    raise NameError('hfkt.isempty')

  return flag

#-------------------------------------------------------
def print_python_is_32_or_64_bit():
  print(struct.calcsize("P") * 8)

def multiply_constant(ll,value):
    """
    multiplies a list with const value
    """
    if( isinstance(ll,list)):
        out = []
        for i in range(len(ll)):
            if( isinstance(ll[i],str)):
                val = float(ll[i])*value
                out.append(str(val))
            else:
                out.append(ll[i] * value)
    else:
        if( isinstance(ll,str)):
            val = float(ll)*value
            out = str(val)
        else:
           out =  ll * value

    return out

def add_constant(ll,value):
    """
    add to a list const value
    """
    if( isinstance(ll,list)):
        for i in range(len(ll)):
            if( isinstance(ll[i],str)):
                ll[i] = float(ll[i]) + value
                ll[i] = str(ll[i])
            else:
                ll[i] += value
    else:
        if( isinstance(ll,str)):
            ll = float(ll) + value
            ll = str(ll)
        else:
            ll += value

    return ll

###########################################################################
# testen mit main
###########################################################################
if __name__ == '__main__':
  
    
    string_with_dates = "05.10.23"
    
    
    text = " Oder aber 01.11.65 Das Datum ist 09/02/2023 und der andere Termin ist am 12-12-2024  "


    epochdate =  secs_time_epoch_from_str_re(text)


    print(epochdate,secs_time_epoch_to_str(epochdate))


    # pattern = r"\b(0[1-9]|1[0-9]|2[0-9]|3[0-1])[-/\.](0[1-9]|[12]\d|3[01])[-/\.](19\d\d|20\d\d|\d\d)\b"
    # dates = re.findall(pattern, text)
    # for d in dates:
    #  s = d[0]
    #  s += "."+d[1]
    #  if( len(d[2]) == 2 ):
    #    s += ".20" + d[2]
    #  else:
    #    s += "." + d[2]
    #  #endif

    # fullpathname = 'https://files.realpython.com/media/haversine_formula_150.fb2b87d122a4.png'
    # t = get_last_subdir_name(fullpathname)
    #
    # (p,b,e) = get_pfe('https://files.realpython.com/media/haversine_formula_150.fb2b87d122a4.png')
    # str_replace("abcdefghi","12",8,2)
    #
    # #secs_time_epoch_from_str('14.01.2020')
    # liste = string_to_num_list('[1.2, 3.2, 4.55]')
    # print(liste)
    # t = "abcd|efgh"
    # liste = split_text(t,"|")
    # print(t)
    # print(liste)
    # print("gdgdg")
    #i0 = such("abcdef",'cd',"vs")
    #b=get_free_size('d:\\temp')
    #liste = get_parent_path_dirs('d:\\temp\\Grid')
    #liste = get_parent_path_files('d:\\temp\\Grid')
    #a = elim_comment_not_quoted("abcdef{l12#3ghi}",["#","%"],"{","}")
    #text = "aaaabcdefccc"
    #print "text = %s" % text

    #print such(text,"a","vn")
    #print split_with_quot("abc{def}ghi{jkl}","{","}")
    #print split_not_quoted("abc|edf||{|||}|ghi","|","{","}",0)
    #print such_in_liste(["abc","1abc"],"abc")
    #for i in range(0,100):
    #    print i,int_to_dec36(i,6)
    #    #print i,int_to_dec36(i,6),dec36_to_int(int_to_dec36(i,6))

    #print "%-30.0f" % get_dattime_float("sos.py")
    #print get_name_by_dat_time(pre_text="backup_")
    #d = dat_last_act_workday_datelist([2009,11,7])

##    liste = ["a","b","c"]
##    item = abfrage_listbox(liste,"s")

    #filename = abfrage_file(file_types="*.*",comment="Wähle aus",start_dir="d:\\temp")

    #(p,b,e) = file_split("..\\abc\\ssj.f")
    #print (p,b,e)

    #os.chdir("d:\\tools\\python\\_entw\\AdressBook")
    #read_mab_file("abook.mab")

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