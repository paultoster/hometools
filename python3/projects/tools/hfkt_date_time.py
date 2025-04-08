# -*- coding: utf8 -*-
#
# 07.01.24 von hfkt_type.py
#############################
"""
 def int_to_dec36(int_val,digits=0):
 def dec36_to_int(string_val):
 def int_akt_datum():
 def intliste_akt_datum():
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
from typing import Any
import dateparser

# import hfkt_def as hdef
import hfkt_str as hstr

# import datetime


dec36_dict: dict[int | Any, str | Any] = {0: '0', 1: '1', 2: '2', 3: '3', 4: '4', 5: '5', 6: '6', 7: '7', 8: '8',
                                          9: '9', 10: 'a', 11: 'b', 12: 'c',
                                          13: 'd', 14: 'e', 15: 'f', 16: 'g', 17: 'h', 18: 'i', 19: 'j', 20: 'k',
                                          21: 'l', 22: 'm', 23: 'n',
                                          24: 'o', 25: 'p', 26: 'q', 27: 'r', 28: 's', 29: 't', 30: 'u', 31: 'v',
                                          32: 'w', 33: 'x', 34: 'y',
                                          35: 'z'}


# #######################################################################################################################
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


########################################################################################################################
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
def int_akt_datum():
    """ Das aktuelle Datum wird in integer zurückgegeben
          format: jjjjmmtt
      """
    t = time.localtime()
    return t[2] + t[1] * 100 + t[0] * 10000


# enddef

########################################################################################################################
def intliste_akt_datum():
    """ Das aktuelle Datum wird in integer liste zurückgegeben
        format: [tag, monat, jahr]
    """
    t = time.localtime()
    return [t[2], t[1], t[0]]


# enddef


########################################################################################################################
def int_akt_time():
    """ Das aktuelle Datum wird in integer zurückgegeben
          format: hhmmss
      """
    t = time.localtime()
    return t[5] + t[4] * 100 + t[3] * 10000


# enddef


########################################################################################################################
def str_akt_datum():
    """ Das aktuelle Datum wird als string zurückgegeben
          format: tt.mm.jjjj
      """
    t = time.localtime()

    st = hstr.get_str_from_int(t.tm_mday, 2) + "."
    st += hstr.get_str_from_int(t.tm_mon, 2) + "."
    st += hstr.get_str_from_int(t.tm_year, 4)
    return st


# enddef


########################################################################################################################
def str_akt_time():
    """ Die aktuelle Zeit wird als string zurückgegeben
          format: hh.mm.ss
      """
    t = time.localtime()
    st = (hstr.get_str_from_int(t.tm_hour, 2)
          + ":" + hstr.get_str_from_int(t.tm_min, 2)
          + ":" + hstr.get_str_from_int(t.tm_sec, 2))
    return st


# enddef


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
def is_datum_str(str_dat, delim="."):
    """ Prüft, ob str_dat ein Datum wie 01.03.2005 ist
    """

    liste = str_dat.split(delim)
    if len(liste) < 3:  # dreiteilig
        flag = False
    elif int(liste[0]) > 31 or int(liste[0]) < 1:  # tag 1-31
        flag = False
    elif int(liste[1]) > 12 or int(liste[1]) < 1:  # monat 1-12
        flag = False
    elif 99 < int(liste[2]) < 1970:  # jahr 0-99 oder 1970-20xx
        flag = False
    else:
        flag = False

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

def secs_akt_time_epoch():
    """
    Aktuelle Zeit in Sekunden seit 1.1.1970 12:00 am
    """
    return int(time.time())


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


def secs_time_epoch_from_str_re(str_dat):
    """
    Das Str-Datum (z.B. "17.12.2004", "17-12-2004", "17/12/2004") wird mit re versucht zu erkennen und
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
    
    if( found == 0 ):
        
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


########################################################################################################################
def secs_time_epoch_to_str(secs,delim="."):
    """
    Wandelt epochen Zeist in secs nach Datum tt.m.yyyy
    """
    
    format = "%d"+delim+"%m"+delim+"%Y"
    
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
