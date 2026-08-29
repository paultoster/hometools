"""
    (status,errtext) = wp_fkt.check_store_path(store_path)
    - Existiert der Pfad, wenn nein bilde ihn

    (status,errtext,isin_input_is_list,isin_list) = wp_fkt.check_isin_input(isin_input)
    - Prüft ob isin_input eine Liste oder einzelwert => isin_input_is_list = True/False
    - Schreibt immer eine Liste raus => isin_list
    - Prüft jeden Wert, ob eine echte isin

    dat_timestamp = wp_fkt.letzter_beendeter_handelstag_timestamp(boerse)
    - Berechnet anhand aktuellem Datum und Zeit den letzten abgeschlossenen Handelstag als timestamp (secs)
    - boerse bisher nur "xetra"

    flag = wp_fkt.ist_kein_handestag(date_time,boerse)
    - Prüft ob das Datum kein Handelstag ist
    - date_time: datetime.datetime  type = datTime

    sort_index_list = wp_fkt.build_sort_list_of_index(list1, list2,distbetween)
    - In welcher Reihen Folge werden liste1 und liste2 zusammengesetzt.
    - Dabei gilt z.B datum von liste1 zuerst und Datum von liste2, wenn es in liste1 fehlt
    - Ausgabe liste [(0/1,index0,index1), ....]
        erster index steht für welche liste 0: liste1, 1:liste2
        zweiter index steht für ersten index aus der entspr. liste
        dritter index steht für letzen index aus der entspr. liste
    - z.B. liste1 = [1.0,2.0,4.0,5.0] liste2 = [2.0,3.0,4.0,5.0,6.0,7.0] distbetween = 1.
            => sort_index_list = [(0,0,1),(1,1,1),(0,2,3),(1,4,5)]
            bei Zusammensetzen der Liste entsteht:
             liste1[sort_list[0][1]:sort_list[0][2]+1] + liste2[sort_list[1][1]:sort_list[1][2]+1] + ...

    flag = wp_fkt.is_in_range(val_proof,val_target,range)
    - Prüfe ob Wert val_proof innerhalb val_target +/- range/2 ist?
    - retunr True/False

    (start_index,end_index,start_in_range,end_in_range) = wp_fkt.find_index_range(liste, first_item, last_item, distbetween)
    - sucht aus Liste den index für first_item und den für last_item und sagt
    - ob first_item innerhalb der Liste steht start_in_range = True sowie
    - ob last_item innerhalb der Liste steht end_in_range = True


    currency = find_currency(liste|item)
"""




# from bs4 import BeautifulSoup as bs
# import urllib.request
import os
import sys
# import pandas as pd
import datetime
import numpy as np

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)

import tools.hfkt_def as hdef
import tools.hfkt_list as hlist
import tools.hfkt_type as htype
import tools.hfkt_date_time as hdt

if os.path.isfile('wp_base.py'):
    import wp_storage as wp_storage
    import wp_playwright as wp_pr

else:
    import wp_abfrage.wp_storage as wp_storage
    import wp_abfrage.wp_playwright as wp_pr

# end if

FEIERTAGE_XETRA_LLISTE = [
    (1,1,2026,"Neujahr"),
    (3,4,2026,"Karfreitag"),
    (6, 4, 2026, "Ostermontag"),
    (1, 5, 2026, "Tag der Arbeit"),
    (24, 12, 2026, "Heiligabend"),
    (25, 12, 2026, "1. Weihnachtstag"),
    (26, 12, 2026, "2. Weihnachtstag"),
    (31, 12, 2026, "Silvetser")]

XETRA_HANDEL_ENDE_TIME_TUP = (22,0,0)

def check_store_path(store_path):
    '''

    :return:
    '''
    status  = hdef.OKAY
    errtext = ""
    if not os.path.isdir(store_path):
        try:
            os.mkdir(store_path)
        except:
            t = store_path
            errtext = f"Der store_path: {t} konnte nicht erstellt werden"
            status = hdef.NOT_OKAY
        # end try
    # end if
    return (status,errtext)

def check_isin_input(isin_input):
    '''
    
    :param isin_input:
    :param ddict:
    :return: (status,errtext,isin_input_is_list,isin_list) = check_isin_input(isin_input)
    '''
    
    isin_input_is_list = False
    isin_list = []
    status = hdef.OKAY
    errtext = ""
    
    if isinstance(isin_input, str):
        isin_list = [isin_input]
    elif isinstance(isin_input, list):
        (okay, value) = htype.type_proof(isin_input, "listStr")
        if okay != hdef.OKAY:
            status = hdef.NOT_OKAY
            errtext = f"isin = {isin_input} ist keine Liste mit strings"
            return (status,errtext,isin_input_is_list, isin_list)
        else:
            isin_input_is_list = True
            isin_list = value
    else:
        errtext = f"isin = {isin_input} ist kein string"
        status = hdef.NOT_OKAY
        return (status,errtext,isin_input_is_list, isin_list)
    # end if
    
    for isin in isin_list:
        (okay, value) = htype.type_proof(isin, 'isin')
        if okay != hdef.OKAY:
            
            (okay, value) = htype.type_proof(isin, 'wkn')
            if okay != hdef.OKAY:
                status = hdef.NOT_OKAY
                errtext = f"isin = {isin} ist kein passender Wert"
                return (status,errtext,isin_input_is_list, isin_list)
            # end if
        # end if
    # end for

    return (status,errtext,isin_input_is_list, isin_list)
# end def
def letzter_beendeter_handelstag_timestamp(boerse=None):
    """

    :param boerse:
    :return: dat_timestamp = letzter_beendeter_handelstag_timestamp(boerse)
    """
    if boerse is None:
        boerse = "xetra"
    # end if

    # letzte Handelszeit Zeit
    date_time = datetime.datetime.today()

    # wenn kein Handelstag, dann ein Tag zurück bis Handelstag
    while ist_kein_handestag(date_time,boerse):
        date_time -= datetime.timedelta(days=1)

    # Handelstag auf Handelsschluss setzen
    if boerse == "xetra":
        date_time = date_time.replace(hour=XETRA_HANDEL_ENDE_TIME_TUP[0],
                                      minute=XETRA_HANDEL_ENDE_TIME_TUP[1],
                                      second=XETRA_HANDEL_ENDE_TIME_TUP[2],
                                      microsecond=0)
    else:
        raise Exception(f"ausgewählte Börse {boerse} ist nicht implementiert")
    # end if

    # aktuelle Zeit
    akt_dat_time = datetime.datetime.now()

    # Wenn aktuelle Zeit nach Handelschluß dann Handelstag nehmen
    if akt_dat_time > date_time:
        pass
    # Ansosnten einen Tag zurück und prüfen, ob Handelstag
    else:
        date_time -= datetime.timedelta(days=1)
        while ist_kein_handestag(date_time, boerse):
            date_time -= datetime.timedelta(days=1)
    # end if
    date_time = date_time.replace(hour=0,minute=0,second=0)
    return int(date_time.timestamp())
# end def
def naechster_handelstag_timestamp(dat,vorwaerts=True,boerse=None):
    """

    :param boerse:
    :return: dat = naechster_handelstag_timestamp(dat,vorwaerts=True,boerse=None)
    """
    if boerse is None:
        boerse = "xetra"
    # end if

    #
    date_time = datetime.datetime.fromtimestamp(dat).date()

    if vorwaerts:
        date_time += datetime.timedelta(days=1)
    else:
        date_time -= datetime.timedelta(days=1)

    # wenn kein Handelstag, dann ein Tag vor
    while ist_kein_handestag(date_time, boerse):
        if vorwaerts:
            date_time += datetime.timedelta(days=1)
        else:
            date_time -= datetime.timedelta(days=1)

    # Handelstag auf Handelsschluss setzen
    if boerse == "xetra":
        date_time.replace(hour=XETRA_HANDEL_ENDE_TIME_TUP[0],
                          minute=XETRA_HANDEL_ENDE_TIME_TUP[1],
                          second=XETRA_HANDEL_ENDE_TIME_TUP[2])
    else:
        raise Exception(f"ausgewählte Börse {boerse} ist nicht implementiert")
    # end if

    return  int(date_time.timestamp())
# end def
def ist_kein_handestag(datetimeproof,boerse=None):
    """

    :param date_tuple: (tag,monat,jahr,...)
    :param boerse: 'xetra' bisher
    :return: flag = ist_kein_handestag(date_tuple,boerse)
    """

    if boerse is None:
        boerse = "xetra"
    # end if

    # Wochenende
    if not datetimeproof.isoweekday():
        return True

    np_array_feiertage = build_np_array_feiertage_datetime_d(datetimeproof.year)
    np_datetimeproof = np.datetime64(datetimeproof).astype('datetime64[D]')

    # Feiertage
    if boerse == "xetra":
        if np_datetimeproof > np_array_feiertage[-1]:
            raise Exception(f"aktuelles Datum: {np_datetimeproof} ist später als letzter Feiertag eintrag: {hdt.str_dat_from_dat_list(FEIERTAGE_XETRA_LLISTE[-1])}")
        # end if

        for np_feiertag in np_array_feiertage:
            if np_datetimeproof == np_feiertag.astype('datetime64[D]'):
                return True
            # end if
        # end for
    else:
        raise Exception(f"ausgewählte Börse {boerse} ist nicht implementiert")
    # end if
    return False
# end def
def get_np_handels_tage_von_bis(datstart:int,datend:int):
    """
    Gibt alle Xetra-Handelstage des angegebenen Zeitraum zurück.
    Rückgabe in timestamp
    np_handelstage_dat_array = get_np_handels_tage_von_bis(datstart,datend)
    """

    datetimestart = datetime.datetime.fromtimestamp(datstart).date()
    datetimeend = datetime.datetime.fromtimestamp(datend).date()

    jahre = np.arange(datetimestart.year, datetimeend.year+1)
    n = len(jahre)
    np_handelstage_dat_array = np.array([],dtype='int64')
    for i,jahr in enumerate(jahre):

        feiertage = build_np_array_feiertage_datetime_d(jahr)

        # Börsenkalender
        kalender = np.busdaycalendar(
            weekmask='1111100',
            holidays=feiertage
        )
        if i == 0:
            startdatum = datetimestart
        else:
            startdatum = f'{jahr}-01-01'
        # end if

        if i == n-1:
            enddatum = datetimeend + datetime.timedelta(days=1)
        else:
            enddatum = f'{jahr+1}-01-01'
        # end if

        tage = np.arange(
            np.datetime64(startdatum),
            np.datetime64(enddatum),
            np.timedelta64(1, 'D')
        )

        werktage = tage[np.is_busday(tage, busdaycal=kalender)]

        ttt = werktage.astype('datetime64[s]').astype('int64')
        np_handelstage_dat_array = np.concatenate((np_handelstage_dat_array, ttt))

    # Alle Xetra-Handelstage
    return np_handelstage_dat_array
#end def
def build_np_array_feiertage_datetime_d(jahr):
    """
    :param jahr:
    :return: feiertage = build_np_array_feiertage_datetime_d(jahr)
    feiertage = array(datetime.date(2026,12,31),...)
    """
    # Ostersonntag nach dem Gregorianischen Kalender
    a = jahr % 19
    b = jahr // 100
    c = jahr % 100
    d = b // 4
    e = b % 4
    f = (b + 8) // 25
    g = (b - f + 1) // 3
    h = (19 * a + b - d - g + 15) % 30
    i = c // 4
    k = c % 4
    l = (32 + 2 * e + 2 * i - h - k) % 7
    m = (a + 11 * h + 22 * l) // 451
    monat = (h + l - 7 * m + 114) // 31
    tag = ((h + l - 7 * m + 114) % 31) + 1

    ostern = datetime.date(jahr, monat, tag)

    # Xetra handelsfreie Tage
    feiertage = [
        datetime.date(jahr, 1, 1),  # Neujahr
        ostern - datetime.timedelta(days=2),  # Karfreitag
        ostern + datetime.timedelta(days=1),  # Ostermontag
        datetime.date(jahr, 5, 1),  # Tag der Arbeit
        datetime.date(jahr, 12, 24),  # Heiligabend
        datetime.date(jahr, 12, 25),  # 1. Weihnachtstag
        datetime.date(jahr, 12, 26),  # 2. Weihnachtstag
        datetime.date(jahr, 12, 31),  # Silvester
    ]

    # NumPy-Datumsarray
    np_array_feiertage = np.array(feiertage, dtype='datetime64[D]')

    return np_array_feiertage
# end def
def build_sort_list_of_index(list1, list2,distbetween):
    """
    In welcher Reihen Folge werden liste1 und liste2 zusammengesetzt. Dabei gilt z.B datum von liste1 zuerst und Datum von liste2, wenn es in liste1 fehlt
    Ausgabe liste [(0 oder 1,index0,index1), ....]
    z.B. liste1 = [1.0,2.0,4.0,5.0] liste2 = [2.0,3.0,4.0,5.0,6.0,7.0] distbetween = 1.
    => sort_index_list = [(0,0,1),(1,1,1),(0,2,3),(1,4,5)]
        erster index steht für welche liste 0: liste1, 1:liste2
        zweiter index steht für ersten index aus der entspr. liste
        dritter index steht für letzen index aus der entspr. liste
    bei Zusammensetzen der Liste entsteht liste1[sort_list[0][1]:sort_list[0][2]+1] + liste2[sort_list[1][1]:sort_list[1][2]+1] + ...

    :param list1: erste Liste mit Daten
    :param list2: zweite Liste mit Daten
    :param distbetween: distance between each item
    :return: sort_index_list = build_sort_list_of_index(list1, list2,distbetween)
    """


    pre_sort_index_list = []

    index1 = 0
    index2 = 0
    n1 = len(list1)
    n2 = len(list2)
    LIST1 = 0
    LIST2 = 1

    flag_run_liste1 = True
    flag_run_liste2 = True
    distbetweenhalf = distbetween / 2

    if n1 == 0:
        for i in range(n2):
            pre_sort_index_list.append((LIST2, i))
        # end if
    elif n2 == 0:
        for i in range(n1):
            pre_sort_index_list.append((LIST1, i))
        # end if
    else:

        while index1 < n1 and index2 < n2:

            if flag_run_liste2 and (list2[index2]+distbetweenhalf < list1[index1]):
                pre_sort_index_list.append((LIST2,index2))
                index2 += 1
            elif flag_run_liste1 and (list1[index1]+distbetweenhalf < list2[index2]):
                pre_sort_index_list.append((LIST1,index1))
                index1 += 1
            elif abs(list1[index1] - list2[index2]) <= distbetweenhalf:
                pre_sort_index_list.append((LIST1,index1))
                index1 += 1
                index2 += 1
            elif flag_run_liste2 and (list2[index2] > list1[index1] + distbetweenhalf):
                pre_sort_index_list.append((LIST2, index2))
                index2 += 1
            elif flag_run_liste1 and (list1[index1] > list2[index2]+distbetweenhalf):
                pre_sort_index_list.append((LIST1,index1))
                index1 += 1
            # end if

            if flag_run_liste1:
                if index1 == n1:
                    flag_run_liste1 = False
                    index1 = n1 -1
                # end if
            # end if
            if flag_run_liste2:
                if index2 == n2:
                    flag_run_liste2 = False
                    index2 = n2 -1
                # end if
            # end if
            if not flag_run_liste1 and not flag_run_liste2:
                break
            # end if

        # end while
    # end if

    sort_index_list = []
    n = len(pre_sort_index_list)
    if n > 0:
        if pre_sort_index_list[0][0] == LIST1:
            akt_liste1_flag = True
        else:
            akt_liste1_flag = False
        # end if

        i1 = 0
        for index,val in enumerate(pre_sort_index_list):

            if akt_liste1_flag:
                if val[0] == LIST2:
                    i2 = pre_sort_index_list[index-1][1]
                    sort_index_list.append((LIST1,i1,i2))
                    akt_liste1_flag = False
                    i1 = val[1]
                # end if
            else:
                if val[0] == LIST1:
                    i2 = pre_sort_index_list[index-1][1]
                    sort_index_list.append((LIST2,i1,i2))
                    akt_liste1_flag = True
                    i1 = val[1]
                # end if
            # end if
            if index == (n - 1):
                i2 = val[1]
                if akt_liste1_flag:
                    sort_index_list.append((LIST1, i1, i2))
                else:
                    sort_index_list.append((LIST2, i1, i2))
                # end if
            # end if
        # end for
    # end if
    return sort_index_list
# end def
def dat_is_in_day_range(dat_proof,dat_target,days):
    """
    Prüft ob Datum sich um kleiner gleich days befinden days=0 gleiches Datum
    """

    date_time_proof = datetime.datetime.fromtimestamp(dat_proof).date()
    date_time_target = datetime.datetime.fromtimestamp(dat_target).date()

    if date_time_proof > date_time_target:

        if date_time_proof - date_time_target > datetime.timedelta(days=days):
            return False
        else:
            return True
        # end if
    else:
        if date_time_target - date_time_proof > datetime.timedelta(days=days):
            return False
        else:
            return True
        # end if
    # end if
# end def
def is_in_range(val_proof,val_target,range):
    """
    flag = wp_fkt.is_in_range(val_proof,val_target,range)
    """

    flag = False
    range_half = range/2
    if (val_proof > (val_target-range_half)) and (val_proof <= (val_target+range_half)):
        flag = True
    # end if
    return flag
# end def
def find_index_range(liste, start_item,last_item, distbetween):
    """
    Suche in Liste match mit start_item und last_item und gebe die dazugehörigen indizes aus der List
    zurück
    :param liste:
    :param first_item:
    :param last_item:
    :param distbetween:
    :return: (start_index,end_index,start_in_range,end_in_range) = find_index_range(liste, first_item,last_item, distbetween)
    start_index : int
    end_index : int
    start_in_range : bool
    end_in_range : bool
    """
    start_in_range = True
    end_in_range  = True
    distbetweenhalf    = distbetween/2

    if start_item is None:
        start_index = 0
    elif start_item <= liste[0] + distbetweenhalf:
        start_index = 0
        start_in_range = False
    elif start_item > liste[-1] + distbetweenhalf:
        start_index = None
        start_in_range = False
    else:
        start_index = hlist.search_nearest_item_in_list(liste,start_item)
        # for index,item in enumerate(liste):
        #     if (start_item > item - distbetweenhalf) and (start_item <= item + distbetweenhalf):
        #         start_index = index
        #         break
        #     # end if
        # # end for
    # end if

    if start_index is None:
        end_index = None
        end_in_range = False
    elif last_item is None:
        end_index = max(start_index,len(liste)-1)
    elif last_item < liste[0] - distbetweenhalf:
        start_index = None
        end_index = None
        end_in_range = False
    elif last_item >= liste[-1] - distbetweenhalf:
        end_index = max(start_index,len(liste)-1)
        end_in_range = False
    else:
        end_index = hlist.search_nearest_item_in_list(liste, last_item)
        # for index,item in enumerate(liste):
        #     if (last_item > item - distbetweenhalf) and (last_item <= item + distbetweenhalf):
        #         end_index = max(start_index,index)
        #         break
        #     # end if
        # # end for
    # end if

    return (start_index,end_index,start_in_range,end_in_range)
# end def
def interpol_with_dat_const(np_dat_array,np_value_array,np_dat_calc_array):
    """
    Sucht für den np_dat_calc_array in np_value_array(np_dat_array) die interpolierten Konstantwerte
    np_value_calc_array = interpol_with_dat_const(np_dat_array,np_value_array,np_dat_calc_array)
    """

    n = min(len(np_dat_array),len(np_value_array))
    np_value_calc_array = np.zeros_like(np_dat_calc_array).astype(np_value_array.dtype)

    i0 = 0
    for i,dat in enumerate(np_dat_calc_array):

        i0 = find_const_interpol_index(np_dat_array,dat, i0)

        if i0 >= n:
            i0 = n-1

        np_value_calc_array[i] = np_value_array[i0]
    # end for

    return np_value_calc_array
# end def
def find_const_interpol_index(np_array,value, istart):
    """
    i0 = find_const_interpol_index(np_array,value,istart)
    """
    n = len(np_array)
    index = max(min(istart, n), 0)

    while index < n:

        if value < np_array[index]:
            if index == 0:
                i0 = 0
                break
            else:
                index -= 1
            # end if
        else:
            if index == (n - 1):
                i0 = n - 1
                break
            elif value < np_array[index + 1]:
                i0 = index
                break
            else:
                index += 1
            # end if
        # end if
    # end while
    return i0
# end def


def find_linear_interpol(float_np_array, float_value, istart):
    """
    :param float_np_array:  numpy array
    :param float_value:  value
    :param istart: start index
    (value, istart) = wp_fkt.find_linear_interpol(float_array, float_value, istart)
    """



    (i0, i1, fact, istart) = find_linear_interpol_index(float_np_array,float_value, istart)

    value = float_np_array[i0] + (float_np_array[i1] - float_np_array[i0]) * fact

    return (value,istart)

# end def
def find_linear_interpol_index(float_np_array,float_value, istart):
    """
    :param float_np_array:  numpy array
    :param float_value:  value
    :param istart: start index
    (i0, i1, fact, istart) = find_linear_interpol_index(float_np_array,float_value, istart)
    """

    n     = len(float_np_array)
    index = max(min(istart,n),0)

    while index < n:

        if float_value < float_np_array[index]:
            if index == 0:
                i0 = 0
                i1 = 0
                fact = 0.0
                break
            else:
                index -= 1
            # end if
        else:
            if index == (n-1):
                i0 = n-2
                i1 = n-1
                fact = 1.0
                break
            elif float_value < float_np_array[index+1]:
                i0 = index
                i1 = index+1
                delta = (float_np_array[i1]-float_np_array[i0])
                if abs(delta) > 1.e-6:
                    fact = (float_value-float_np_array[i0])/(float_np_array[i1]-float_np_array[i0])
                else:
                    fact = 0.0
                # end if
                break
            else:
                index += 1
            # end if
        # end if
    # end while
    return (i0, i1, fact, index)
# end def
def find_currency(item):
    """
    currency = find_currency_in_list(liste)
    """

    if isinstance(item,list):
        liste = item
    else:
        liste = [item]
    # end if

    euro_count = 0
    dollar_count = 0
    schweiz_count = 0
    gbp_count = 0
    percent_count = 0
    for x in liste:
        if x.find("€") >= 0:
            euro_count += 1
        elif x.lower().find("euro") >= 0:
            euro_count += 1
        elif x.find("$") >= 0:
            dollar_count += 1
        elif x.lower().find("dollar") >= 0:
            dollar_count += 1
        elif x.lower().find("chf") >= 0:
            schweiz_count += 1
        elif x.lower().find("£") >= 0:
            gbp_count += 1
        elif x.lower().find("gbp") >= 0:
            gbp_count += 1
        elif x.find("%") >= 0:
            percent_count += 1
        elif x.lower().find("percent") >= 0:
            percent_count += 1
        else:
            euro_count += 1
        # end if
    # end for

    zahlen = [euro_count, dollar_count, schweiz_count, gbp_count, percent_count]
    max_wert = max(zahlen)
    max_index = zahlen.index(max_wert)

    if max_index == 0:
        return "euro"
    elif max_index == 1:
        return "dollar"
    elif max_index == 2:
        return "chf"
    elif max_index == 3:
        return "gbp"
    else:
        return "percent"
    # end if
# end def
###########################################################################
# testen mit main
###########################################################################
if __name__ == '__main__':

    a = datetime.date(2026, 5, 1)


    # dat_tup = letzter_beendeter_handelstag_timestamp("xetra")

    # print(hdt.str_dat_from_dat_list(dat_tup))

    liste1 = [11.0, 12.0, 14.0, 15.0]
    liste2 = [1.0,2.0, 9.0,13.0, 14.0, 15.0, 16.0, 17.0]
    distbetween = 1

    print(f"{liste1 = }")
    print(f"{liste2 = }")
    pre_sort_index_list = build_sort_list_of_index(liste1, liste2, distbetween)

    for index,val in enumerate(pre_sort_index_list):
        print(f"{index =},{val = }")