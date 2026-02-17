# -*- coding: utf8 -*-
#
# 07.01.24 von hfkt_type.py
#############################
"""
########################################################################################################################
[d, m, y] = get_akt_dat_list()    aktuelle Datum als liste [Tag, Monat, Jahr]
    [d, m, y] = intliste_akt_datum()e
[tt,mm,jjjj,hh,mm,ss] = get_akt_dat_time_list()    aktuells Datum und Zeit als liste [Tag, Monat, Jahr, Stunde, Minute, Sekunhde]
[hh,mm,ss] = get_akt_time_list() aktuells Zeit als liste [Tag, Monat, Jahr]
    [hh,mm,ss] = int_akt_time()
n =  get_akt_dat_int() Datum in Integer gestreckt: jjjjmmtt
    n = int_akt_datum()
str = get_akt_dat_str() Datum: "tt.mm.jjjj"
      get_akt_dat_str(delim="-") Datum: "tt-mm-jjjj"
    str = str_akt_datum()
str = get_akt_dat_time_str() Datum und Zeit: "tt.mm.jjjj hh:mm:ss"
      get_akt_dat_time_str(datdelim="-",timedelim".") Datum und Zeit: "tt-mm-jjjj hh.mm.ss"
str = get_akt_time_str() Zeit in "hh:mm:ss"
      get_akt_time_str(delim="-") Zeit in "hh-mm-ss"
    str = str_akt_time()
secs = get_akt_dat_time_secs() AktuelleDatum und Zeit in Sekunden seit 1.1.1970 12:00 am
    secs = secs_akt_time_epoch()
########################################################################################################################
int_dat = calc_date_list_to_int(liste)  liste = (12,05,1959) (tt,mm,jjjj) => int_dat : 19590512 jjjjmmtt
str_dat = calc_dat_list_to_str(liste,delim=".") int_dat : 19590512 jjjjmmtt =>  str_dat = "12.05.1959!
secs = calc_dat_list_to_secs(liste) liste = (12,05,1959) (tt,mm,jjjj) => secs : 11311200

int_dat_time = calc_dat_time_list_to_int(liste) liste = [12,05,1959,12,01,23] [tt,mm,jjjj,hh,mm,ss] =>
                                                    int_dat_time : 19590512120123 jjjjmmtthhmmss
str_dat_time = calc_dat_time_list_to_str(liste,delimdat=".",delimtime=":") liste = [12,05,1959,12,01,23] [tt,mm,jjjj,hh,mm,ss] =>
                                                                            str_dat_time : "12.05.1959 12:01:23"
secs = calc_dat_time_list_to_secs(liste) liste = (12,05,1959) (tt,mm,jjjj) => secs : 11311200

int_dat = calc_time_list_to_int(liste) liste = (12,05,13) (hh,mm,ss) => int_dat : 120513 hhmmss
str = calc_time_list_to_str(liste,delim=":") liste = [12,05,13] [hh,mm,ss] => str = "12:05:13"
secs = calc_time_list_to_secs(liste) liste = [10,5,0] (hh,mm,ss) => secs : 205500

liste = calc_int_to_dat_list(int_dat)   int_dat : 120513 ttmmjjjj => liste = (12,05,13) (tt,mm,jjjj)
liste = calc_int_to_dat_time_list(int_dat) int_dat : 120513102323 jjjjmmtthhmmss => liste = (12,05,13,10,23,23) (tt,mm,jjjj,hh,mm,ss)
liste = calc_int_to_time_list(int_dat) int_dat : 120513102323 jjjjmmtthhmmss => liste = (12,05,13) (hh,mm,ss)
str = calc_int_to_str(int_dat,delimdat=".",delimtime=":") dat_int = jjjjmmtt => str = "tt.mm.jjjj"
                                                    oder dat_int = hhmmss => str = "hh:mm:ss"
                                                    oder dat_int = jjjjmmtthhmmss => str = "tt.mm.jjjj hh:mm:ss"
secs = calc_int_to_secs(int_dat) int_dat : 19590512 jjjjmmtt => secs : 11311200
liste = calc_secs_to_dat_list(secs) secs : 11311200 => liste = (12,05,13) (tt,mm,jjjj)
liste = calc_secs_to_dat_time_list(secs) secs = 737157600 => liste =[12, 5, 1993, 0, 0, 0]
liste = calc_secs_to_time_list(secs) secs = 737194811 => liste = (10,20,11) (hh,mm,ss)
int_dat = calc_secs_to_int(secs) secs = 737194811 => int_dat : 19930512102011 jjjjmmtthhmmss
str = calc_secs_to_str(secs,delimdat=".",delimtime=":") secs  => 737194811 => str = "12.05.1993 10:20:11" "tt.mm.jjjj hh:mm:ss"
str = calc_secs_to_dat_str(secs,delimdat=".") secs=> 737194811 => str = "12.05.1993" "tt.mm.jjjj"
liste = calc_str_to_dat_list(str_text) str = "12.05.1993 10:20:11" "tt.mm.jjjj hh:mm:ss" => liste = (12,05,1993) (tt,mm,jjjj)
liste = calc_str_to_dat_time_list(str_text) str = "12.05.1993 10:20:11" "tt.mm.jjjj hh:mm:ss" => liste =[12, 5, 1993, 10, 20, 11]
liste = calc_str_to_time_list(str_text) str = "12.05.1993 10:20:11" "tt.mm.jjjj hh:mm:ss" =>  liste : [1993,05,12]
int_dat = calc_str_to_int(str_text) str = "12.05.1993 10:20:11" "tt.mm.jjjj hh:mm:ss" => int_dat : 19930512102011 jjjjmmtthhmmss
secs = calc_str_to_secs(str) str = "12.05.1993 10:20:11" "tt.mm.jjjj hh:mm:ss" => secs  => 737194811
dat_list = calc_dat_str_to_dat_list(dat_str, delim=".") dat_str = "10.02.2004" => dat_list = [10,2,2004]
time_list = calc_time_str_to_time_list(dat_str, delim=":") time_str = "10:20:00" => time_list = [10,2,2004]
########################################################################################################################
str_dat        = find_str_dat(str_text,flag_liste=False), str_text = "17.12.2004 20-01-2020" => str_dat = "17.12.2004"
str_dat_liste  = find_str_dat(str_text,flag_liste=True), str_text = "17.12.2004 20-01-2020" => str_dat_liste = ["17.12.2004","20.01.2020"]
secs           = secs_time_epoch_from_str_datefinder(str_text) str_text = "17.12.2004"
secs-liste     = secs_time_epoch_from_str_datefinder(str_text) str_text = "17.12.2004 20-01-2020"
str_time       = find_str_time(str_text,flag_liste=False), str_text = "20:12:20 11:10:05" => str_time = "20:12:20"
str_time_liste = find_str_time(str_text,flag_liste=True), str_text = "17.12.2004 20:12:20 11:10:05" => str_dat_liste = ["20:12:20","11:10:05"]
########################################################################################################################
flag = is_dat_str(str_dat,delim='.') str_dat = "10.03.2005" => flag = True
flag   = datum_str_is_correct(str_dat,delim=".")
flag = is_dat_int(int_val)  int_val = jjjjmmtt
flag = is_dat_list(liste)  liste = (12,05,1959) (tt,mm,jjjj)
flag = is_time_list(liste)  liste = (03,05,10) (hh,mm,ss)
flag = is_dat_list_a_to_b(a_dat_list, b_dat_list,sign) a_dat_list:  (12,05,1959) (tt,mm,jjjj);
                                                       b_dat_list:   (13,05,1959) (tt,mm,jjjj)
                                                       sign: '>','>=','==','<=','<'  =>
                                                       flag = True/False
########################################################################################################################
 def int_to_dec36(int_val,digits=0):
 def dec36_to_int(string_val):
########################################################################################################################

 def str_datum(int_dat):
 dat_in  = calc_dat_tuple_to_int_dat(date_tuple)
 (d,m,j) = get_akt_dat_tuple()
 flag    = is_dat_tuple_a_to_b(a_date_tuple,b_dat_list,'>','>=','==','<=','<')
 str_dat = str_dat_from_dat_tuple(date_tuple)

 secs = secs_akt_time_epoch()
 secs = secs_time_epoch_from_int(intval)
 secs = secs_time_epoch_from_str_re(str_dat)
 secs = secs_time_epoch_from_str(str_dat,delim=".")
 secs = secs_time_epoch_from_year_str(str_year)
 secs = secs_time_epoch_from_int(intval,plus_hours)
 string = secs_time_epoch_to_str(secs,delim=".",date_inverse_flag=False,with_time_flag=False): Wandelt in string Datum
 int    = secs_time_epoch_to_int(secs): Wandelt in int Datum
 int_list = secs_time_epoch_to_int_list(secs): Wandelt in int Datum liste int_liste = [year,month,day,hour,minute,second]

 strnew = datum_str_make_correction(str_dat,delim=".")
 daystr = day_from_secs_time_epoch(secs): Man bekommt den Tag in Mo,Di,Mi,Do,Fr,Sa,So
 daystr = day_from_datum_str(str_dat,delim="."): Man bekommt den Tag in Mo,Di,Mi,Do,Fr,Sa,So
 def datum_str_to_intliste(str_dat,delim="."): Wandelt string in eine Liste
 def datum_intliste_to_int(dat_l):  Wandelt Liste in ein int
 def datum_int_to_intliste(intval): int -> liste
 def datum_str_to_int(str_dat,delim="."): Wandelt string in ein int
 def datum_intliste_to_str(int_liste,delim="."):
 int days_of_month(mon,year): gibt anzahl Tage für den Monat
 def datum_str_to_year_int(str_dat,delim="."):
 def datum_str_to_month_int(str_dat,delim="."):
 def datum_str_to_day_int(str_dat,delim="."):
 def secs_time_epoch_find_next_day(secs,idaynext):
 flag =  is_datum_str(str_dat,delim=".")   flag = True/False
 def get_name_by_dat_time(pre_text,post_text) Gibt Name gebildet aus localtime und text
 def diff_days_from_time_tuples(time_tuple_start,time_tuple_end) Bildet die Differenz der Tage über 0:00
 (eday,edaysecs) = secs_time_epoch_to_epoch_day_time(secs)
 (secs) = epoch_day_time_to_secs_time_epoch_to_(eday,edaysecs)



"""
import time
import datetime
import calendar
import math
import re
# from sys import excepthook
from typing import Any
import dateparser

import os

# import hfkt_def as hdef
if os.path.isfile('hfkt_def.py'):
    import hfkt_str as hstr
else:
    import tools.hfkt_str as hstr
# import datetime


dec36_dict: dict[int | Any, str | Any] = {0: '0', 1: '1', 2: '2', 3: '3', 4: '4', 5: '5', 6: '6', 7: '7', 8: '8',
                                          9: '9', 10: 'a', 11: 'b', 12: 'c',
                                          13: 'd', 14: 'e', 15: 'f', 16: 'g', 17: 'h', 18: 'i', 19: 'j', 20: 'k',
                                          21: 'l', 22: 'm', 23: 'n',
                                          24: 'o', 25: 'p', 26: 'q', 27: 'r', 28: 's', 29: 't', 30: 'u', 31: 'v',
                                          32: 'w', 33: 'x', 34: 'y',
                                          35: 'z'}


# #######################################################################################################################
def get_akt_dat_list():
    """
    retun dat_list day month year oder [tag, monat, jahr]
    :return: [d, m, y] = get_akt_dat_list()
    """
    current_date = datetime.datetime.now()

    return [current_date.day, current_date.month, current_date.year]
# end def
def intliste_akt_datum():
    # t = time.localtime()
    # return [t[2], t[1], t[0]]
    return get_akt_dat_list()
# enddef
#-----------------------------------------------------------------------------------------------------------------------
def get_akt_dat_time_list():
    """
    format: (tt,mm,jjjj,hh,mm,ss)
    :return: tup = get_akt_dat_time_list()
    """
    current_date = datetime.datetime.now()

    return [current_date.day, current_date.month, current_date.year,current_date.hour,current_date.minute,current_date.second]
# end def
#-----------------------------------------------------------------------------------------------------------------------
def get_akt_time_list():
    """
    format: (hh,mm,ss)
    :return: tup = get_akt_dat_time_list()
    """
    current_date = datetime.datetime.now()

    return [current_date.hour,current_date.minute,current_date.second]
# end def
#-----------------------------------------------------------------------------------------------------------------------
def get_akt_dat_int():
    return int_akt_datum()
# end def
def int_akt_datum():
    """ Das aktuelle Datum wird in integer zurückgegeben
          format: jjjjmmtt
      """
    t = time.localtime()
    return t[2] + t[1] * 100 + t[0] * 10000
# enddef
#-----------------------------------------------------------------------------------------------------------------------
def get_akt_time_int():
    return int_akt_time()
# end def
def int_akt_time():
    """ Das aktuelle Datum wird in integer zurückgegeben
          format: hhmmss
      """
    t = time.localtime()
    return t[5] + t[4] * 100 + t[3] * 10000
# enddef
#-----------------------------------------------------------------------------------------------------------------------
def get_akt_dat_str(delim="."):
    return str_akt_datum(delim)
# end def
def get_akt_dat_time_str(datdelim=".",timedelim=":"):
    return str_akt_datum(datdelim)+" "+str_akt_time(timedelim)
# end def
def get_akt_time_str(delim=":"):
    return  str_akt_time(delim)
# end def
def str_akt_datum(delim="."):
    """ Das aktuelle Datum wird als string zurückgegeben
          delim = ".": format: tt.mm.jjjj
          delim = "-": format: tt-mm-jjjj
      """
    t = time.localtime()

    st = hstr.get_str_from_int(t.tm_mday, 2) + delim
    st += hstr.get_str_from_int(t.tm_mon, 2) + delim
    st += hstr.get_str_from_int(t.tm_year, 4)
    return st
# enddef
def str_akt_time(delim=":"):
    """ Die aktuelle Zeit wird als string zurückgegeben
          format: hh.mm.ss
      """
    t = time.localtime()
    st = (hstr.get_str_from_int(t.tm_hour, 2)
          + delim + hstr.get_str_from_int(t.tm_min, 2)
          + delim + hstr.get_str_from_int(t.tm_sec, 2))
    return st
# enddef
#-----------------------------------------------------------------------------------------------------------------------
def get_akt_dat_time_secs():
    return secs_akt_time_epoch()
# end def
def secs_akt_time_epoch():
    """
    Aktuelle Zeit in Sekunden seit 1.1.1970 12:00 am
    """
    return int(time.time())
########################################################################################################################
def calc_dat_list_to_int(liste):
    """
        liste = (12,05,1959) (tt,mm,jjjj)
        int_dat = calc_dat_list_to_int(liste)
        int_dat : 19590512 jjjjmmtt
    :param liste:
    :return: int_dat = calc_date_listele_to_int_dat(liste)
    """
    return liste[2]*10000 + liste[1]*100 + liste[0]
# end def
def calc_dat_list_to_str(liste,delim="."):
    """
        liste = (12,05,1959) (tt,mm,jjjj)
        str_dat = calc_dat_list_to_str(liste,delim=".")
        str_dat = "12.05.1959"
    :param liste:
    :return: str_dat = calc_date_listele_to_int_dat(liste,delim=".")
    """
    return f"{liste[0]}{delim}{liste[1]}{delim}{liste[2]}"
# end def
def calc_dat_list_to_secs(liste):
    """
        liste = (12,05,1959) (tt,mm,jjjj)
        secs = calc_dat_list_to_secs(liste)
        secs : 11311200
    :param liste:
    :return: secs = calc_dat_list_to_secs(liste)
    """
    year = max(1970,liste[2])
    month = max(1,liste[1])
    if (year == 1970) and (month == 1):
        day   = max(3,liste[0])
    else:
        day = max(1, liste[0])

    epoch_time = datetime.datetime(year, month, day).timestamp()


    return int(epoch_time)
# end def
#-----------------------------------------------------------------------------------------------------------------------
def calc_dat_time_list_to_int(liste):
    """
        liste = [12,05,1959,12,01,23] [tt,mm,jjjj,hh,mm,ss]
        int_dat_time = calc_dat_time_list_to_int(liste)
        int_dat_time : 19590512120123 jjjjmmtthhmmss
    :param liste:
    :return: int_dat_time = calc_dat_time_list_to_int(liste)
    """
    val = liste[2]*10000 + liste[1]*100 + liste[0]
    val = val*1000000 + liste[3]*10000 + liste[4]*100 + liste[5]
    return val
# end def
def calc_dat_time_list_to_str(liste,delimdat=".",delimtime=":"):
    """
        liste = [12,05,1959,12,01,23] [tt,mm,jjjj,hh,mm,ss]
        str_dat_time = calc_dat_time_list_to_str(liste,delimdat=".",delimtime=":")
        str_dat_time : "12.05.1959 12:01:23"
    :param liste:
    :return: str_dat_time = calc_dat_time_list_to_str(liste,delimdat=".",delimtime=":")
    """
    return f"{liste[0]}{delimdat}{liste[1]}{delimdat}{liste[2]} {liste[3]}{delimtime}{liste[4]}{delimtime}{liste[5]}"
# end def
def calc_dat_time_list_to_secs(liste):
    """
        liste = (12,05,1959) (tt,mm,jjjj)
        secs = calc_dat_time_list_to_secs(liste)
        secs : 11311200
    :param liste:
    :return: secs = calc_date_listele_to_int_dat(liste)
    """
    year = max(1970,liste[2])
    month = max(1,liste[1])
    if (year == 1970) and (month == 1):
        day   = max(3,liste[0])
    else:
        day = max(1, liste[0])

    hh = min(23,max(0,liste[3]))
    mm = min(59,max(0,liste[4]))
    ss = min(59,max(0,liste[5]))

    epoch_time = datetime.datetime(year, month, day,hh,mm,ss).timestamp()

    return int(epoch_time)
# end def
#-----------------------------------------------------------------------------------------------------------------------
def calc_time_list_to_int(liste):
    """
        liste = (12,05,13) (hh,mm,ss)
        int_dat = calc_time_list_to_int(liste)
        int_dat : 120513 hhmmss
    :param liste:
    :return: int_dat = calc_time_list_to_int(liste)
    """
    return liste[0]*10000 + liste[1]*100 + liste[2]
# end def
def calc_time_list_to_str(liste,delim=":"):
    """
        liste = [12,05,13] [hh,mm,ss]
        str = calc_time_list_to_str(liste,delim=":")
        str = "12:05:13"
    :param liste:
    :return: str = calc_time_list_to_str(liste,delim=":")
    """
    return f"{liste[0]}{delim}{liste[1]}{delim}{liste[2]}"
# end def
def calc_time_list_to_secs(liste):
    """
        liste = [10,5,0] (hh,mm,ss)
        secs = calc_time_list_to_secs(liste)
        secs : 205500
    :param liste:
    :return: secs = calc_time_list_to_secs(liste)
    """
    year = 1970
    month = 1
    day = 3

    hh = min(23, max(0, liste[0]))
    mm = min(59, max(0, liste[1]))
    ss = min(59, max(0, liste[2]))

    epoch_time = datetime.datetime(year, month, day,hh,mm,ss).timestamp()
    return int(epoch_time)
# end def
#-----------------------------------------------------------------------------------------------------------------------
def calc_int_to_dat_list(int_dat):
    """
        int_dat : 120513 ttmmjjjj
        liste = calc_int_to_dat_list(int_dat)
        liste = (12,05,13) (tt,mm,jjjj)
    :param liste:
    :return: liste = calc_int_to_dat_list(int_dat)
    """
    if int_dat > 99999999:
        jahr = int(int_dat / 10000000000)
        monat = int((int_dat - jahr * 10000000000) / 100000000)
        tag = int((int_dat - jahr * 10000000000 - monat * 100000000)/1000000)
    else:
        jahr = int(int_dat / 10000)
        monat = int((int_dat - jahr * 10000) / 100)
        tag = int(int_dat - jahr * 10000 - monat * 100)
    # end if

    return [tag,monat,jahr]
# end def
def calc_int_to_dat_time_list(int_dat):
    """
        int_dat : 120513102323 jjjjmmtthhmmss
        liste = calc_int_to_dat_time_list(int_dat)
        liste = (12,05,13,10,23,23) (tt,mm,jjjj,hh,mm,ss)
    :param liste:
    :return: liste = calc_int_to_dat_time_list(int_dat)
    """
    if int_dat > 99999999:
        jahr = int(int_dat / 10000000000)
        monat = int((int_dat - jahr * 10000000000) / 100000000)
        tag = int((int_dat - jahr * 10000000000 - monat * 100000000)/1000000)
        hh  = int((int_dat - jahr * 10000000000 - monat * 100000000 - tag*1000000)/10000)
        mm  = int((int_dat - jahr * 10000000000 - monat * 100000000 - tag*1000000 - hh*10000)/100)
        ss  = int(int_dat - jahr * 10000000000 - monat * 100000000 - tag*1000000 - hh*10000 - mm*100)
    else:
        jahr = int(int_dat / 10000)
        monat = int((int_dat - jahr * 10000) / 100)
        tag = int(int_dat - jahr * 10000 - monat * 100)
        hh  = 0
        mm  = 0
        ss  = 0
    # end if

    return [tag,monat,jahr,hh,mm,ss]
# end def
def calc_int_to_time_list(int_dat):
    """
        int_dat : 120513102323 jjjjmmtthhmmss
        liste = calc_int_to_time_list(int_dat)
        liste = (12,05,13) (hh,mm,ss)
    :param liste:
    :return: liste = calc_int_to_time_list(int_dat)
    """
    if int_dat < 999999:
        hh  = int(int_dat/10000)
        mm  = int((int_dat - hh*10000)/100)
        ss  = int(int_dat - hh*10000 - mm*100)
    elif int_dat > 99999999:
        jahr = int(int_dat / 10000000000)
        monat = int((int_dat - jahr * 10000000000) / 100000000)
        tag = int((int_dat - jahr * 10000000000 - monat * 100000000)/1000000)
        hh  = int((int_dat - jahr * 10000000000 - monat * 100000000 - tag*1000000)/10000)
        mm  = int((int_dat - jahr * 10000000000 - monat * 100000000 - tag*1000000 - hh*10000)/100)
        ss  = int(int_dat - jahr * 10000000000 - monat * 100000000 - tag*1000000 - hh*10000 - mm*100)
    else:
        jahr = int(int_dat / 10000)
        monat = int((int_dat - jahr * 10000) / 100)
        tag = int(int_dat - jahr * 10000 - monat * 100)
        hh  = 0
        mm  = 0
        ss  = 0
    # end if

    return [hh,mm,ss]
# end def
def calc_int_to_str(int_dat,delimdat=".",delimtime=":"):
    """
        dat_int = jjjjmmtt => str = "tt.mm.jjjj"
        dat_int = hhmmss => str = "hh:mm:ss"
        dat_int = jjjjmmtthhmmss => str = "tt.mm.jjjj hh:mm:ss"
        str = calc_int_to_str(int_dat,delimdat=".",delimtime=":")

    :param liste:
    :return: str = calc_int_to_str(liste,delimdat=".",delimtime=":")
    """
    if int_dat < 999999:
        liste = calc_int_to_time_list(int_dat)
        return f"{liste[0]}{delimtime}{liste[1]}{delimtime}{liste[2]}"
    elif int_dat > 99999999:
        liste = calc_int_to_dat_time_list(int_dat)
        return f"{liste[0]}{delimdat}{liste[1]}{delimdat}{liste[2]} {liste[3]}{delimtime}{liste[4]}{delimtime}{liste[5]}"
    else:
        liste = calc_int_to_dat_list(int_dat)
        return f"{liste[0]}{delimdat}{liste[1]}{delimdat}{liste[2]}"
    # end if
# end def
def calc_int_to_secs(int_dat):
    """
        int_dat : 19590512 jjjjmmtt
        secs = calc_int_to_secs(int_dat)

    :param liste:
    :return: secs = calc_int_to_secs(int_dat)
    """
    if int_dat < 999999:
        liste = calc_int_to_time_list(int_dat)
        t = (0, 0, 0, liste[0], liste[1], liste[3], 0, 0, 0)
    elif int_dat > 99999999:
        liste = calc_int_to_dat_time_list(int_dat)
        if liste[2] < 1970:
            raise Exception(f"Das Jahr {liste[2]} kann nicht in epoch time gewandelt werden")
        secs = datetime.datetime(liste[2], liste[1], liste[0], liste[3], liste[4], liste[5]).timestamp()
    else:
        liste = calc_int_to_dat_list(int_dat)
        if liste[2] < 1970:
            raise Exception(f"Das Jahr {liste[2]} kann nicht in epoch time gewandelt werden")
        secs = datetime.datetime(liste[2], liste[1], liste[0],0,0,0).timestamp()
    # end if
    return int(secs)
# end def
#-----------------------------------------------------------------------------------------------------------------------
def calc_secs_to_dat_list(secs):
    """
        secs : 11311200
        liste = calc_secs_to_dat_list(secs)
        liste = (12,05,13) (tt,mm,jjjj)
    :param liste:
    :return: liste = calc_secs_to_dat_list(secs)
    """
    dt = datetime.datetime.fromtimestamp(secs)
    return [dt.day, dt.month, dt.year]
# end def
def calc_secs_to_dat_time_list(secs):
    """
        secs = 737157600
        liste = calc_secs_to_dat_time_list(secs)
        liste =[12, 5, 1993, 0, 0, 0]
    :param liste:
    :return: liste = calc_secs_to_dat_time_list(secs)
    """
    dt = datetime.datetime.fromtimestamp(secs)
    return [dt.day, dt.month, dt.year,dt.hour,dt.minute,dt.second]
# end def
def calc_secs_to_time_list(secs):
    """
        secs = 737194811
        liste = calc_secs_to_time_list(secs)
        liste = (10,20,11) (hh,mm,ss)
    :param liste:
    :return: liste = calc_int_to_dat_list(secs)
    """
    dt = datetime.datetime.fromtimestamp(secs)
    return [dt.hour,dt.minute,dt.second]
# end def
def calc_secs_to_int(secs):
    """
        secs = 737194811
        int_dat = calc_secs_to_int(secs)
        int_dat : 19930512102011 jjjjmmtthhmmss
    :param liste:
    :return: int_dat = calc_secs_to_int(liste)
    """
    dt = datetime.datetime.fromtimestamp(secs)
    return calc_dat_time_list_to_int([dt.day, dt.month, dt.year, dt.hour, dt.minute, dt.second])
# end def
def calc_secs_to_str(secs,delimdat=".",delimtime=":"):
    """
        secs  => 737194811
        str = calc_secs_to_str(secs,delimdat=".",delimtime=":")
        str = "tt.mm.jjjj hh:mm:ss"
    :param liste:
    :return: str = calc_secs_to_str(secs,delimdat=".",delimtime=":")
    """
    dt = datetime.datetime.fromtimestamp(secs)
    return calc_dat_time_list_to_str([dt.day, dt.month, dt.year, dt.hour, dt.minute, dt.second],delimdat,delimtime)
# end def
def calc_secs_to_dat_str(secs,delimdat="."):
    """
        secs => str = "tt.mm.jjjj"
        str = calc_secs_to_dat_str(secs,delimdat=".")

    :param liste:
    :return: str = calc_secs_to_dat_str(secs,delimdat=".")
    """
    dt = datetime.datetime.fromtimestamp(secs)
    return calc_dat_list_to_str([dt.day, dt.month, dt.year],delimdat)
# end def
def calc_str_to_dat_list(str_text):
    """
        str = "12.05.1993 10:20:11" "tt.mm.jjjj hh:mm:ss"
        liste = calc_str_to_dat_list(str_text)
        liste = (12,05,1993) (tt,mm,jjjj)
    :param str_text:
    :return: liste = calc_str_to_dat_list(str_text)
    """
    dat_str = find_str_dat(str_text, flag_liste=False)
    dat_list = calc_dat_str_to_dat_list(dat_str)

    return dat_list
# end def
def calc_str_to_dat_time_list(str_text):
    """
        str = "12.05.1993 10:20:11" "tt.mm.jjjj hh:mm:ss"
        liste = calc_str_to_dat_time_list(str_text)
        liste =[12, 5, 1993, 10, 20, 11]
    :param liste:
    :return: liste = calc_str_to_dat_time_list(str_text)
    """
    dat_str = find_str_dat(str_text, flag_liste=False)
    time_str = find_str_time(str_text, flag_liste=False)
    dat_list = calc_dat_str_to_dat_list(dat_str)
    time_list = calc_time_str_to_time_list(time_str)
    liste = dat_list + time_list

    return liste
# end def
def calc_str_to_time_list(str_text):
    """
        str = "12.05.1993 10:20:11" "tt.mm.jjjj hh:mm:ss"
        time_list = calc_str_to_time_list(str_text)
        time_list : [1993,05,12]
    :param liste:
    :return: liste = calc_int_to_dat_list(secs)
    """
    time_str = find_str_time(str_text, flag_liste=False)
    time_list = calc_time_str_to_time_list(time_str)

    return time_list
# end def
def calc_str_to_int(str_text):
    """
        str = "12.05.1993 10:20:11" "tt.mm.jjjj hh:mm:ss"
        int_dat = calc_str_to_int(str_text)
        int_dat : 19930512102011 jjjjmmtthhmmss
    :param liste:
    :return: int_dat = calc_str_to_int(str_text)
    """
    dat_str = find_str_dat(str_text, flag_liste=False)
    time_str = find_str_time(str_text, flag_liste=False)
    dat_list = calc_dat_str_to_dat_list(dat_str)
    time_list = calc_time_str_to_time_list(time_str)
    liste = dat_list + time_list

    return calc_dat_time_list_to_int(liste)
# end def
def calc_str_to_secs(str_text):
    """
        str = "12.05.1993 10:20:11" "tt.mm.jjjj hh:mm:ss"
        secs = calc_str_to_secs(str)
        secs  => 737194811
    :param str:
    :return: secs = calc_str_to_secs(str)
    """
    dat_str = find_str_dat(str_text, flag_liste=False)
    time_str = find_str_time(str_text, flag_liste=False)
    dat_list  = calc_dat_str_to_dat_list(dat_str)
    time_list = calc_time_str_to_time_list(time_str)
    liste     = dat_list + time_list

    return calc_dat_time_list_to_secs(liste)
# end def
def calc_dat_str_to_dat_list(dat_str, delim="."):
    """
    dat_str = "10.02.2004"
    dat_list = calc_dat_str_to_dat_list(dat_str, delim=".")
    dat_list = [10,2,2004]
    :param dat_str:
    :return: dat_list = calc_dat_str_to_dat_list(dat_str, delim=".")
    """

    liste = dat_str.split(delim)
    rliste = []
    for item in liste:
        rliste.append(int(item))
    # end ofr
    return rliste


# end def
def calc_time_str_to_time_list(dat_str, delim=":"):
    """
    time_str = "10:20:00"
    time_list = calc_time_str_to_time_list(dat_str, delim=":")
    time_list = [10,2,2004]
    :param dat_str:
    :return: time_list = calc_time_str_to_time_list(dat_str, delim=":")
    """

    liste = dat_str.split(delim)
    rliste = []
    for item in liste:
        rliste.append(int(item))
    # end ofr
    return rliste


# end def

########################################################################################################################
def find_str_dat(str_text,flag_liste=False):
    """
    Das Str-Datum (z.B. "17.12.2004", "17-12-2004", "17/12/2004", 2004.12.17, 2004-12-17 2004/12/17) wird mit re versucht zu erkennen
    und format "datStrP" zurückgeben
    flag_liste = False wird nur der erste Wert zurückgegeben
    flag_liste = True  wird alle Werte in einer Liste zurückgegeben

    :param str:
    :return: str_dat       = find_str_dat(str_text,flag_liste=False), str_text = "17.12.2004 20-01-2020" => str_dat = "17.12.2004"
             str_dat_liste = find_str_dat(str_text,flag_liste=True), str_text = "17.12.2004 20-01-2020" => str_dat_liste = ["17.12.2004","20.01.2020"]
    """

    erg_secs = secs_time_epoch_from_str_re(str_text)

    if isinstance(erg_secs,list):

        str_dat_liste = []
        for erg in erg_secs:
            str_dat_liste.append(calc_secs_to_dat_str(erg))
        # end for

        if flag_liste:
            return str_dat_liste
        else:
            return str_dat_liste[0]
        # end if
    else:

        str_dat = calc_secs_to_dat_str(erg_secs)

        if flag_liste:
            return [str_dat]
        else:
            return str_dat
        # end if
    # end if
# end def
def secs_time_epoch_from_str_re(str_dat):
    """
    Das Str-Datum (z.B. "17.12.2004", "17-12-2004", "17/12/2004", 2004.12.17, 2004-12-17 2004/12/17) wird mit re versucht zu erkennen und
    in Sekunden in epochaler Zeit umgerechnet
    secs = secs_time_epoch_from_str_datefinder(str_dat)
    """

    liste = []
    found = 0
    try:

        pattern = r"\b([1-9]|0[1-9]|1[0-9]|2[0-9]|3[0-1])[-/\.]([1-9]|0[1-9]|[12]\d|3[01])[-/\.](19\d\d|20\d\d|\d\d)\b"
        form = "%d.%m.%Y"

        dates = re.findall(pattern, str_dat)
        for d in dates:
            strdat = d[0] + "." + d[1] + "."
            if len(d) == 2:
                strdat += str(datetime.datetime.now().year)
            else:
                if len(d[2]) <= 2:
                    strdat += "20" + d[2]
                else:
                    strdat += d[2]  # endif
            # endif

            t = datetime.datetime.strptime(strdat, form)
            liste.append(int(t.timestamp()))
            found = 1
        # endfor
    except:
        found = 0
    # end if

    if found == 0:
        try:

            pattern = r"\b(19\d\d|20\d\d|\d\d)[-/\.]([1-9]|0[1-9]|[12]\d|3[01])[-/\.]([1-9]|0[1-9]|1[0-9]|2[0-9]|3[0-1])\b"
            form = "%d.%m.%Y"

            dates = re.findall(pattern, str_dat)
            for d in dates:
                strdat = d[2] + "." + d[1] + "."
                if len(d) == 2:
                    strdat += str(datetime.datetime.now().year)
                else:
                    if len(d[0]) <= 2:
                        strdat += "20" + d[0]
                    else:
                        strdat += d[0]  # endif
                # endif

                t = datetime.datetime.strptime(strdat, form)
                liste.append(int(t.timestamp()))
                found = 1
            # endfor
        except:
            found = 0
        # end except
    # end if

    if found == 0:
        try:

            pattern = r"(19\d\d|20\d\d|\d\d)[-/\.]([1-9]|0[1-9]|[12]\d|3[01])[-/\.]([1-9]|0[1-9]|1[0-9]|2[0-9]|3[0-1])"
            form = "%d.%m.%Y"

            dates = re.findall(pattern, str_dat)
            for d in dates:
                strdat = d[2] + "." + d[1] + "."
                if len(d) == 2:
                    strdat += str(datetime.datetime.now().year)
                else:
                    if len(d[0]) <= 2:
                        strdat += "20" + d[0]
                    else:
                        strdat += d[0]  # endif
                # endif

                t = datetime.datetime.strptime(strdat, form)
                liste.append(int(t.timestamp()))
                found = 1
            # endfor
        except:
            found = 0
        # end except
    # end if

    if found == 0:
        try:

            pattern = r"([1-9]|0[1-9]|1[0-9]|2[0-9]|3[0-1])[-/\.]([1-9]|0[1-9]|[12]\d|3[01])[-/\.](19\d\d|20\d\d|\d\d)"
            form = "%d.%m.%Y"

            dates = re.findall(pattern, str_dat)
            for d in dates:
                strdat = d[2] + "." + d[1] + "."
                if len(d) == 2:
                    strdat += str(datetime.datetime.now().year)
                else:
                    if len(d[0]) <= 2:
                        strdat += "20" + d[0]
                    else:
                        strdat += d[0]  # endif
                # endif

                t = datetime.datetime.strptime(strdat, form)
                liste.append(int(t.timestamp()))
                found = 1
            # endfor
        except:
            found = 0
        # end except
    # end if

    if (found == 0):

        try:
            t = dateparser.parse(str_dat)
            liste.append(int(t.timestamp()))
            found = 1
        except:
            found = 0
    # endif

    if len(liste) == 1:
        return liste[0]
    elif len(liste) > 1:
        return liste
    else:
        return int(0)
    # endif


# enddef
def find_str_time(str_text,flag_liste=False):
    """
    Das Str-Time (z.B. "20:12:20") wird mit re versucht zu erkennen
    und format "timeStr:" zurückgeben
    flag_liste = False wird nur der erste Wert zurückgegeben
    flag_liste = True  wird alle Werte in einer Liste zurückgegeben

    :param str:
    :return: str_time       = find_str_time(str_text,flag_liste=False), str_text = "20:12:20 11:10:05" => str_time = "20:12:20"
             str_time_liste = find_str_time(str_text,flag_liste=True), str_text = "17.12.2004 20:12:20 11:10:05" => str_dat_liste = ["20:12:20","11:10:05"]
    """

    time_liste = time_liste_from_str_time_re(str_text)

    if isinstance(time_liste,list):

        str_time_liste = []
        for erg in time_liste:
            str_time_liste.append(calc_time_list_to_str(erg))
        # end for

        if flag_liste:
            return str_time_liste
        else:
            return str_time_liste[0]
        # end if
    else:

        str_time = calc_time_list_to_str(time_liste)

        if flag_liste:
            return [str_time]
        else:
            return str_time
        # end if
    # end if
# end def
def time_liste_from_str_time_re(str_time):
    """
    Das Str-Time (z.B. "17.12.2004 20:12:20", "11:10:05") wird mit re versucht zu erkennen und
    in time liste [hh,mm,ss] zurückgegeben
    time_liste = time_liste_from_str_time_re(str_time)
    """

    liste = []
    found = 0
    try:

        pattern = r"\b([01]\d|2[0-3])[:-]([0-5]\d)[:-]([0-5]\d)\b"
        # r"\b([01]\d|2[0-3]):[0-5]\d:[0-5]\d\b"    # r"\b\d{2}[:-]\d{2}[:-]\d{2}\b"

        times = re.findall(pattern, str_time)
        for t in times:

            t_list = [int(t[0]),int(t[1]),int(t[2])]
            liste.append(t_list)
            found = 1
        # endfor
    except:
        found = 0
    # end if

    if len(liste) == 1:
        return liste[0]
    elif len(liste) > 1:
        return liste
    else:
        return int(0)
    # endif

# enddef
########################################################################################################################
def is_dat_str(str_dat,delim='.'):
    """
    str_dat = "10.03.2005"
    flag = is_dat_str(str_dat,delim='.')
    flag = True
    :param str_dat:
    :param delim:
    :return:
    """
    return datum_str_is_correct(str_dat,delim)
# end def
def datum_str_is_correct(str_dat, delim="."):
    """
      string datum muss tt.mm.jjjj sein
      flag = datum_str_is_correct(str_dat)
      flag = True/False
      """
    liste = str_dat.split(delim)

    if len(liste) < 3:
        return False

    intliste = datum_str_to_intliste(str_dat=str_dat, delim=delim)

    if intliste[0] == 0:
        return False
    if intliste[1] == 0:
        return False
    if intliste[0] > 31:
        return False
    if intliste[1] > 12:
        return False

    return True


# enddef
def is_time_str(str_time,delim=':'):
    """

    :param str_time:
    :param delim: flag = is_time_str(str_time,delim=':')
    :return:
    """


    liste = str_time.split(delim)

    if len(liste) < 3:
        return False

    intliste = calc_str_to_time_list(str_time, delim)

    # Stunden
    if (intliste[0] < 0) or (intliste[0] > 23):
        return False
    # minuten
    if (intliste[1] < 0) or (intliste[1] > 59):
        return False
    # sekunden
    if (intliste[2] < 0) or (intliste[2] > 59):
        return False

    return True


def is_dat_int(int_val):
    """

    :param int_val: jjjjmmtt
    :return: flag = is_dat_int(int_val)
            flag = True/False
    """

    jahr = int(int_val / 10000)
    monat = int((int_val - jahr * 10000) / 100)
    tag = int(int_val - jahr * 10000 - monat * 100)

    jahr = min(9999, max(0, jahr))
    monat = min(12, max(1, monat))
    if monat in [1, 3, 5, 7, 8, 10, 12]:
        tag = min(31, max(1, tag))
    elif monat in [4, 6, 9, 11]:
        tag = min(30, max(1, tag))
    elif (jahr % 4) == 0:
        tag = min(29, max(1, tag))
    else:
        tag = min(28, max(1, tag))
    # end if

    if (jahr * 10000 + monat * 100 + tag) == int_val:
        flag = True
    else:
        flag = False
    # end if

    return flag
# end def
def is_time_int(int_val):
    """

    :param int_val: hhmmss
    :return: flag = is_time_int(int_val)
    """
    hh = int(int_val / 10000)
    mm = int((int_val - hh * 10000) / 100)
    ss = int(int_val - hh * 10000 - mm * 100)

    hh = min(23, max(0, hh))
    mm = min(59, max(0, mm))
    ss = min(59, max(0, ss))

    if (hh * 10000 + mm * 100 + ss) == int_val:
        flag = True
    else:
        flag = False
    # end if

    return flag
# end def
def is_dat_list(liste):
    """

    :param liste: liste = (12,05,1959) (tt,mm,jjjj)
    :return: flag = is_dat_list(liste) True/False
    """

    if len(liste) < 3:
        return False
    else:
        # jahr
        if (liste[2] > 9999) or (liste[2] < 0):
            return False
        # end if

        # monat
        if (liste[1] > 12) or (liste[1] < 1):
            return False
        # end if
        if liste[1] in [1, 3, 5, 7, 8, 10, 12]:
            tagmax = 31
        elif liste[1] in [4, 6, 9, 11]:
            tagmax = 30
        elif (liste[2] % 4) == 0:
            tagmax = 29
        else:
            tagmax = 28
        # end if

        # Tag
        if (liste[0] > tagmax) or (liste[0] < 1):
            return False
        # end if
    # end if

    return True
# end def
def is_time_list(liste):
    """

    :param liste: liste = (12,05,10) (hh,mm,ss)
    :return: flag = is_time_list(liste) True/False
    """

    if len(liste) < 3:
        return False
    else:
        # hour
        if (liste[0] > 23) or (liste[0] < 0):
            return False
        # end if

        # minute
        if (liste[1] > 59) or (liste[1] < 0):
            return False
        # end if

        # sekunde
        if (liste[2] > 59) or (liste[2] < 0):
            return False
        # end if

    # end if

    return True
# end def
def  is_dat_list_a_to_b(a_dat_list, b_dat_list,sign):
    """

    :param a_dat_list:  (12,05,1959) (tt,mm,jjjj)
    :param b_dat_list:   (13,05,1959) (tt,mm,jjjj)
    :param sign: '>','>=','==','<=','<'
    :return: flag = is_dat_list_a_to_b(a_dat_list, b_dat_list,sign)
    """
    a_int_dat = calc_dat_list_to_int(a_dat_list)
    b_int_dat = calc_dat_list_to_int(b_dat_list)
    if sign == '>':
        return a_int_dat > b_int_dat
    elif sign == '>=':
        return a_int_dat >= b_int_dat
    elif sign == '==':
        return a_int_dat == b_int_dat
    elif sign == '<=':
        return a_int_dat <= b_int_dat
    elif sign == '<':
        return a_int_dat < b_int_dat
    else:
        raise Exception(f"is_dat_list_a_to_b: sign = {sign} is unkown")
    # end
# end def

########################################################################################################################
def int_to_dec36(int_val, digits=0):
    """

    :param int_val:
    :param digits:
    :return:
    """
    int_val = int(int_val)
    liste = []
    #    if( int_val < 36 ):
    #
    #        value = dec36_dict[int_val]
    #    else:

    while True:

        if int_val > 35:

            liste.append(int_val % 36)
            int_val = int_val / 36
        else:
            liste.append(int_val)
            break  # endif
    # endwhile

    value = ''
    if len(liste) < digits:
        for i in range(digits, len(liste), -1):
            value += '0'
            # endfor
    # endif

    try:
        for i in range(len(liste) - 1, -1, -1):
            value += dec36_dict[liste[i]]
        # endfor

    except KeyError as error:
        print("wraning: int_to_dec36(int_val) ging schief")
        print(error)
    # endtry

    return value


# edndef
def dec36_to_int(string_val):
    """

    :param string_val:
    :return:
    """
    string_val = str(string_val)
    erg = 0
    for s in string_val:
        for (i0, a0) in dec36_dict.items():

            if a0 == s:
                erg = erg * 36 + i0
                break  # endif  # endfor
    # endfor

    return erg


# enddef


########################################################################################################################
########################################################################################################################


########################################################################################################################
def str_datum(int_dat):
    """ Das mit int_akt_datum erstellte Datum int_dat wird als string zurückgegeben
          format: jjjjmmtt → tt.mm.jjjj
      """
    jahr = int(int_dat / 10000)
    monat = int((int_dat - jahr * 10000) / 100)
    tag = int(int_dat - jahr * 10000 - monat * 100)

    st = ("%s" % tag) + (".%s" % monat) + (".%s" % jahr)
    return st


# enddef
def get_isoweekday(dat_tup):
    """
    1: montag, ... 7:Sonntag

    :param dat_tup: Tuple mit mindestens Datum (tt,mm,jjjj)
    :return: isoweekday =  get_isoweekday(dat_tup)
    """
    datum = datetime.date(dat_tup[2], dat_tup[1], dat_tup[0])
    return datum.isoweekday()
# end if
def verschiebe_dat_list_in_tagen(dat_list,tage):
    """
        tage > 0 nach vorne
        tage < 0 zurück

    :param dat_list:
    :param tage:
    :return: dat_tup = verschiebe_dat_tup_in_tagen(dat_tup,tage)
    """
    datum = datetime.date(dat_list[2], dat_list[1], dat_list[0])

    if tage < 0:
        datum -= datetime.timedelta(days=abs(tage))
    elif tage > 0:
        datum += datetime.timedelta(days=tage)
    # endif

    dat_list[0] = datum.day
    dat_list[1] = datum.month
    dat_list[2] = datum.year

    return dat_list
# end if
def str_dat_from_dat_list(dat_tup):
    """
    format: (tt,mm,jjjj) → tt.mm.jjjj
    :param dat_tup:
    :return: str_dat = str_dat_from_dat_list(date_tuple)
    """
    st = ("%s" % dat_tup[0]) + (".%s" % dat_tup[1]) + (".%s" % dat_tup[2])
    return st
# end def
def  is_dat_time_list_a_to_b(a_dat_time_list, b_dat_time_list,sign):

    a_int_dat_time = calc_dat_time_list_to_int(a_dat_time_list)
    b_int_dat_time = calc_dat_time_list_to_int(b_dat_time_list)
    if sign == '>':
        return a_int_dat_time > b_int_dat_time
    elif sign == '>=':
        return a_int_dat_time >= b_int_dat_time
    elif sign == '==':
        return a_int_dat_time == b_int_dat_time
    elif sign == '<=':
        return a_int_dat_time <= b_int_dat_time
    elif sign == '<':
        return a_int_dat_time < b_int_dat_time
    else:
        raise Exception(f"is_date_tuple_a_to_b: sign = {sign} is unkown")
    # end
# end def
def str_dat_time_from_dat_time_list(dat_time_list):
    """
    format: (tt,mm,jjjj,hh,mm,ss) → tt.mm.jjjj
    :param dat_tup:
    :return: str_dat = str_dat_from_dat_list(date_tuple)
    """
    st = ("%s" % dat_time_list[0]) + (".%s" % dat_time_list[1]) + (".%s" % dat_time_list[2])
    st += (" %s" % dat_time_list[3]) + (":%s" % dat_time_list[4]) + (":%s" % dat_time_list[5])
    return st
# end def

########################################################################################################################
def datum_str_make_correction(str_dat, delim="."):
    """
      string datum muss tt.mm.jjjj sein
      Korrigiert tt.mm.jj zu tt.mm.jjjj
      """

    liste = datum_str_to_intliste(str_dat, delim=delim)
    liste2 = datum_intliste_make_correction(liste)
    str_dat = datum_intliste_to_str(liste2)

    return str_dat


# enddef


########################################################################################################################
def datum_intliste_make_correction(hintliste):
    """
      intliste datum mit [tt, mm, jjjj] wird
      korrigiert
    """

    if len(hintliste) >= 3:

        # Monat
        if hintliste[1] > 12:
            hintliste[1] = 12

        # Jahr
        liste_akt = intliste_akt_datum()

        ty_akt = math.floor(liste_akt[2] / 100) * 100
        ty: int | Any = math.floor(hintliste[2] / 100) * 100

        if ty == 0:
            hintliste[2] += ty_akt
        elif ty > ty_akt:
            hintliste[2] -= ty
            hintliste[2] += ty_akt
        # endif

        # Tage
        days = days_of_month(hintliste[1], hintliste[2])
        if hintliste[0] > days:
            hintliste[0] = days  # endif
    # endif

    return hintliste


# enddef


########################################################################################################################
def days_of_month(mon, year):
    """
       gibt Anzahl Tage für den Monat
      """
    mon = int(mon)
    year = int(year)

    if mon > 12:
        mon = 12
    # endfi

    if mon in [1, 3, 5, 7, 8, 10, 12]:
        days = 31
    elif mon == 2:
        if (year % 4) == 0:
            days = 29
        else:
            days = 28
    else:
        days = 30
    # endif
    return days


# enddef


########################################################################################################################


########################################################################################################################
def day_from_secs_time_epoch(secs):
    """
      Man bekommt den Tag in Mo, Di, Mi, Do, Fr, Sa, So
      """
    return day_from_datum_str(secs_time_epoch_to_str(secs))


# enddef


########################################################################################################################
def day_from_datum_str(str_dat, delim="."):
    """
      Man bekommt den Tag in Mo, Di, Mi, Do, Fr, Sa, So
      von 'dd.mm.yyyy'
      """
    days = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"]
    return days[daynum_from_datum_str(str_dat, delim)]


# enddef


########################################################################################################################
def daynum_from_secs_time_epoch(secs):
    """
      Man bekommt den Tag in 0-6; 0: Mo, 6: So
      """
    return daynum_from_datum_str(secs_time_epoch_to_str(secs))


# enddef


########################################################################################################################
def daynum_from_datum_str(str_dat: str, delim: str = ".") -> int:
    """
      Man bekommt den Tag in 0-6; 0: mo, 6: so
      von 'dd.mm.yyyy'
      """
    day, month, year = (int(i) for i in str_dat.split(delim))
    daynumber: int = calendar.weekday(year, month, day)

    return daynumber


# enddef


########################################################################################################################
def secs_time_epoch_find_next_day(secs, idaynext):
    """
      von akt_datum (in secs_time_epoch) den nächsten Wochentag finden
      idaynext = 0:Mo - 6:So
      """
    idayact = daynum_from_secs_time_epoch(secs)

    diday = idaynext - idayact

    if diday <= 0:
        diday = 7 + diday

    return secs + 86400 * diday


# enddef


########################################################################################################################
def datum_str_to_intliste(str_dat: str, delim: str = "."):
    """ Das string-Datum z.B <12.5.04> wird
          in [tag,monat,jahr] gewandelt [12,5,2004]
          :param delim:
          :type str_dat: object
      """

    if len(str_dat) == 0:
        return [0, 0, 0]

    str_dat.split(delim)

    liste = []
    for v in str_dat:
        liste.append(int(v))

    n = len(liste)

    if n == 0:
        return [0, 0, 0]
    else:
        if liste[n - 1] < 70:
            liste[n - 1] = liste[n - 1] + 2000
        elif liste[n - 1] < 100:
            liste[n - 1] = liste[n - 1] + 1900

    if n == 1:
        return [1, 1, liste[0]]
    if n == 2:
        return [1, liste[0], liste[1]]
    if n >= 3:
        return [liste[0], liste[1], liste[2]]


# enddef


########################################################################################################################
def datum_intliste_to_int(dat_l):
    """ Die Liste [tag, monat, jahr] wird in int gewandelt
          [12,5,2004] → 20040512
      """
    return dat_l[0] + dat_l[1] * 100 + dat_l[2] * 10000


# enddef


########################################################################################################################
def datum_int_to_intliste(intval):
    """ Die Zahle intval wird in eine Liste [tag, monat, jahr] gewandelt
          20040512 → [12,5,2004]
      """
    dat_l = [intval - int(intval / 100) * 100, int((intval - int(intval / 10000) * 10000) / 100), int(intval / 10000)]

    return dat_l


# enddef


########################################################################################################################
def datum_str_to_int(str_dat, delim="."):
    """
      Das string-Datum z. B. <12.5.04> wird
      in eine int Zahl gewandelt z.B. 20040504
      """
    return datum_intliste_to_int(datum_str_to_intliste(str_dat, delim))


# enddef


########################################################################################################################
def datum_intliste_to_str(int_liste: list[int], delim: str = "."):
    """ Wandelt Datumliste z. B. (12,5,2004)
          in "tag.monat.jahr" um "12.05.2004"
      """
    ddd = ""
    if len(int_liste) >= 1:
        ddd = "%2.2i" % int_liste[0] + delim
    if len(int_liste) >= 2:
        ddd += "%2.2i" % int_liste[1] + delim
    if len(int_liste) >= 3:
        ddd += "%2.2i" % int_liste[2]
    return ddd


# enddef


########################################################################################################################
def datum_akt_year_int():
    """
      aktuelle Jahr in int z.B. 2017
    """
    t = time.localtime()
    return t.tm_year


# enddef
def datum_akt_year_str():
    """
      aktuelle Jahr in string z.B. "2017"
    """
    t = time.localtime()
    return str(t.tm_year)


# enddef

def datum_akt_mont_int_str():
    '''
    
    :return: aktueller Monat in int z.B. 1
    '''
    t = time.localtime()
    return int(t.tm_mon)
# end def

########################################################################################################################
def datum_str_to_year_int(str_dat, delim="."):
    """ Das string-Datum z. B. <12.5.04> wird
          in 2004 gewandelt. Nur das Jahr
      """
    liste = str_dat.split(delim)

    year = int(liste[-1])

    if year < 70:
        year = year + 2000
    elif year < 100:
        year = year + 1900
    # endif

    return year


# enddef


########################################################################################################################
def datum_str_to_month_int(str_dat, delim="."):
    """ Das string-Datum z. B. <12.5.04> wird
          in 5 gewandelt. Nur den Monat
      """
    liste = str_dat.split(delim)

    month = int(liste[1])

    if month < 1:
        month = 1
    elif month > 12:
        month = 12

    return month


# enddef


########################################################################################################################
def datum_str_to_day_int(str_dat, delim="."):
    """ Das string-Datum z. B. <12.5.04> wird
          in 12 gewandelt. Nur den Tag
      """
    liste = str_dat.split(delim)

    day = int(liste[0])

    if day < 1:
        day = 1
    elif day > 31:
        day = 12

    return day


# enddef


########################################################################################################################
def is_year_str(str_year_in):
    '''
    Prüft, ob str_year ein Jahr wie 2005 ist
    
    :param str_year:
    :return: flag = is_year_str("2015")
    '''
    lliste = str_year_in.split(' ')
    if (len(lliste) > 1):
        str_year = lliste[0]
    else:
        str_year = str_year_in
    # end if
    if 99 < int(str_year) < 1970:  # jahr 0-99 oder 1970-20xx
        flag = False
    else:
        flag = True
    # end if
    return flag
# enddef
def is_datum_str(str_dat, delim="."):
    """ Prüft, ob str_dat ein Datum wie 01.03.2005 ist
    """

    liste = str_dat.split(delim)
    
    for i,item in enumerate(liste):
    
        lliste = item.split(' ')
        if( len(lliste) > 1):
            liste[i] = lliste[0]
        # end if
    # end for
    
    if len(liste) < 3:  # dreiteilig
        flag = False
    elif int(liste[0]) > 31 or int(liste[0]) < 1:  # tag 1-31
        flag = False
    elif int(liste[1]) > 12 or int(liste[1]) < 1:  # monat 1-12
        flag = False
    elif 99 < int(liste[2]) < 1970:  # jahr 0-99 oder 1970-20xx
        flag = False
    else:
        flag = True

    return flag
# enddef
def is_datum_reverse_str(str_dat, delim="."):
    """
    Prüft, ob str_dat ein Datum wie 2005.04.01 ist
    """

    liste = str_dat.split(delim)
    if len(liste) < 3:  # dreiteilig
        flag = False
    elif int(liste[2]) > 31 or int(liste[2]) < 1:  # tag 1-31
        flag = False
    elif int(liste[1]) > 12 or int(liste[1]) < 1:  # monat 1-12
        flag = False
    elif 99 < int(liste[0]) < 1970:  # jahr 0-99 oder 1970-20xx
        flag = False
    else:
        flag = True

    return flag


# enddef
########################################################################################################################
def get_name_by_dat_time(pre_text="", post_text="", form_type=0):
    """
      Gibt Name gebildet aus localtime und pre_text und post_text
      form_type == 0
      zB 25.8.2006 12:43:02 => pre_text+20060825_124302+post_text
      form_type == 1
      zB 25.8.2006 12:43:02 => pre_text+0608251243+post_text
      """
    t = time.localtime()
    text = pre_text
    if form_type == 0:
        text += "%4.4i" % t[0]  # jahr
        text += "%2.2i" % t[1]  # mon
        text += "%2.2i_" % t[2]  # tag
        text += "%2.2i" % t[3]  # stunde
        text += "%2.2i" % t[4]  # minute
        text += "%2.2i" % t[5]  # sekunde
    elif form_type == 1:
        jahr = t[0] - int(t[0] / 100) * 100
        text += "%2.2i" % jahr  # jahr
        text += "%2.2i" % t[1]  # mon
        text += "%2.2i" % t[2]  # tag
        text += "%2.2i" % t[3]  # stunde
        text += "%2.2i" % t[4]  # minute
    text += post_text
    return text


# enddef


########################################################################################################################
def diff_days_from_time_tuples(ttuple_start, ttuple_end):
    """
    Gibt an die Differenz an Tagen zu ttuple
    z.B. ttuple = time.localtime()
    """
    fac = 1.0
    time_sec_start = time.mktime(ttuple_start)
    time_sec_end = time.mktime(ttuple_end)

    if time_sec_start > time_sec_end:
        fac = -1.0
        dum = time_sec_start
        time_sec_start = time_sec_end
        time_sec_end = dum

    delta_sec = time_sec_end - time_sec_start
    days = int(delta_sec / 86400.)

    ttuple = time.gmtime(time_sec_start + days * 86400.)

    if (ttuple[0] == ttuple_end[0]) and (ttuple[1] == ttuple_end[1]) and (ttuple[2] == ttuple_end[2]):
        pass
    else:
        days += 1

    return int(days * fac)


# enddef



def secs_time_epoch_from_int(intval, plus_hours=0):
    """
    Das Int-Datum intval (z.B. 20161217) wird in Sekunden in epochaler Zeit umgerechnet
    Zusätzlich können Stunden dazu addiert werden
    secs = secs_time_epoch_from_int(intval)
    secs = secs_time_epoch_from_int(intval,12)
    """
    liste = datum_int_to_intliste(intval)
    t = (liste[2], liste[1], liste[0], plus_hours, 0, 0, 0, 0, 0)
    return time.mktime(t)




# ----------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------
def secs_time_epoch_from_str(str_dat, delim="."):
    """
    Das Str-Datum intval (z.B. "17.12.2004") wird in Sekunden in epochaler Zeit umgerechnet
    secs = secs_time_epoch_from_str(str_dat, delim=".")
    """
    form = "%d" + delim + "%m" + delim + "%Y"
    if not isinstance(str_dat, list):
        str_to_dt = datetime.datetime.strptime(str_dat, form)
        return int(str_to_dt.timestamp())
    else:
        ll = []
        for stri in str_dat:
            str_to_dt = datetime.datetime.strptime(stri, form)
            ll.append(int(str_to_dt.timestamp()))
        # endfor
        return ll


# enddef
# ----------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------
def secs_time_epoch_from_year_str(str_year):
    """
    Das Str-Datum str_year (z.B. "2004") wird in Sekunden in epochaler Zeit umgerechnet
    secs = secs_time_epoch_from_year_str(str_year)
    """
    form = "%Y"
    if not isinstance(str_year, list):
        str_to_dt = datetime.datetime(int(str_year), 1, 1, 0, 0,0)
        # str_to_dt = datetime.datetime.strptime(str_year, form)
        return int(str_to_dt.timestamp()+3600)
    else:
        ll = []
        for stri in str_year:
            str_to_dt = datetime.datetime(int(stri), 1, 1, 0, 0, 0)
            # str_to_dt = datetime.datetime.strptime(stri, form)
            ll.append(int(str_to_dt.timestamp()+3600))
        # endfor
        return ll
# enddef
########################################################################################################################
def secs_time_epoch_to_str(secs,delim=".",date_inverse_flag=False,with_time_flag=False):
    """
    Wandelt epochen Zeist in secs nach Datum tt.m.yyyy
    """
    if date_inverse_flag:
        format = "%Y"+delim+"%m"+delim+"%d"
    else:
        format = "%d" + delim + "%m" + delim + "%Y"
    # end if
    if with_time_flag:
        format += delim + "%H"+ delim + "%M"+ delim + "%S"
    # end if
    
    if isinstance(secs, list):
        strtime = []
        for seci in secs:
            strtime.append(datetime.datetime.fromtimestamp(seci).strftime(format))
        return strtime
    else:
        dt = datetime.datetime.fromtimestamp(secs)
        # ttt = dt.strftime("%d.%m.%Y,%H:%M:%S")
        
        return dt.strftime(format)


# enddef


########################################################################################################################
def secs_time_epoch_to_int(secs):
    """
    Wandelt epochen Zeit in secs nach int jjjjmmtt
    """
    return datum_str_to_int(secs_time_epoch_to_str(secs))


# enddef
def secs_time_epoch_to_int_list(secs):
    '''
    int_liste = [year,month,day,hour,minute,second]
    :param secs:
    :return: int_list = secs_time_epoch_to_int_list(secs)
    '''
    dt = datetime.datetime.fromtimestamp(secs)
    liste = [dt.year,dt.month,dt.day,dt.hour,dt.minute,dt.second]
    return liste
# end def
########################################################################################################################
def datum_str_to_secs(str_dat, delim="."):
    """
    Wandelt Datum tt.m.yyyy nach epochen Zeit in secs
    """
    int_dat = datum_str_to_int(str_dat, delim)
    return secs_time_epoch_from_int(int_dat)


# enddef


########################################################################################################################
def secs_time_epoch_to_epoch_day_time(secs: int) -> (int, int):
    """

    :param secs:
    :return: (eday,edaysecs)
    """
    (eday, edaysecs) = divmod(secs+3600, 86400)
    return eday, edaysecs


# enddef


########################################################################################################################
def epoch_day_time_to_secs_time_epoch(eday: int, edaysecs: int) -> int:
    """

      :param edaysecs:
      :param eday:
      :return: secs
    """
    secs = eday * 86400 + edaysecs - 3600
    return secs  # enddef

# enddef
###########################################################################
# testen mit main
###########################################################################
if __name__ == '__main__':
    time_liste_from_str_time_re("abc 10:30:29 99:56:40 11-30-00 5:34:5")

    secs = calc_int_to_secs(19930512102011)
    print(f"{secs = }")
    liste = calc_secs_to_dat_time_list(secs)
    print(f" {liste =}")

    str = calc_secs_to_str(secs,"-")

    print(str)