"""
    (status,errtext) = wp_fkt.check_store_path(store_path)
    - Existiert der Pfad, wenn nein bilde ihn

    (status,errtext,isin_input_is_list,isin_list) = wp_fkt.check_isin_input(isin_input)
    - Prüft ob isin_input eine Liste oder einzelwert => isin_input_is_list = True/False
    - Schreibt immer eine Liste raus => isin_list
    - Prüft jeden Wert, ob eine echte isin

    dat_time_list = wp_fkt.letzter_beendeter_handelstag_dat_list(boerse)
    - Berechnet anhand aktuellem Datum und Zeit den letzten abgeschlossenen Handelstag
    - boerse bisher nur "xetra"

    flag = wp_fkt.ist_kein_handestag(date_tuple,boerse)
    - Prüft ob das Datum kein Handelstag ist
    - date_tuple: (tag,monat,jahr,...)  type = datList oder datTimeList

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
"""




# from bs4 import BeautifulSoup as bs
# import urllib.request
import os
import sys
# import pandas as pd

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
def letzter_beendeter_handelstag_dat_list(boerse):
    """

    :param boerse:
    :return: dat_time_list = letzter_beendeter_handelstag_dat_list(boerse)
    """
    # letzte Handelszeit Zeit
    dat_time_list = hdt.get_akt_dat_time_list()

    # wenn kein Handelstag, dann ein Tag zurück bis Handelstag
    while ist_kein_handestag(dat_time_list,boerse):
        dat_time_list = hdt.verschiebe_dat_list_in_tagen(dat_time_list,-1)

    # Handelstag auf Handelsschluss setzen
    if boerse == "xetra":
        dat_time_list[3:6] = XETRA_HANDEL_ENDE_TIME_TUP[0:3]
    else:
        raise Exception(f"ausgewählte Börse {boerse} ist nicht implementiert")
    # end if

    # aktuelle Zeit
    akt_dat_time_list = hdt.get_akt_dat_time_list()

    # Wenn aktuelle Zeit nach Handelschluß dann Handelstag nehmen
    if hdt.is_dat_time_list_a_to_b(akt_dat_time_list,dat_time_list,'>'):
        pass
    # Ansosnten einen Tag zurück und prüfen, ob Handelstag
    else:
        dat_time_list = hdt.verschiebe_dat_list_in_tagen(dat_time_list, -1)
        while ist_kein_handestag(dat_time_list, boerse):
            dat_time_list = hdt.verschiebe_dat_list_in_tagen(dat_time_list, -1)
    # end if
    return dat_time_list
# end def
def ist_kein_handestag(date_tuple,boerse):
    """

    :param date_tuple: (tag,monat,jahr,...)
    :param boerse: 'xetra' bisher
    :return: flag = ist_kein_handestag(date_tuple,boerse)
    """

    # Wochenende
    if hdt.get_isoweekday(date_tuple) > 5:
        return True

    # Feiertage
    if boerse == "xetra":
        if hdt.is_dat_list_a_to_b(date_tuple,FEIERTAGE_XETRA_LLISTE[-1],'>'):
            raise Exception(f"aktuelles Datum: {hdt.str_dat_from_dat_list(date_tuple)} ist später als letzter Feiertag eintrag: {hdt.str_dat_from_dat_list(FEIERTAGE_XETRA_LLISTE[-1])}")
        # end if

        for liste in FEIERTAGE_XETRA_LLISTE:
            if hdt.is_dat_list_a_to_b(date_tuple,liste,'=='):
                return True
            # end if
        # end for
    else:
        raise Exception(f"ausgewählte Börse {boerse} ist nicht implementiert")
    # end if
    return False
# end def
# def build_overlap_dict_of_index(list1, list2,distbetween):
#     """
#     Was ist aus Sicht liste1 (key=index1) gleich bzw. im distbetween Bereich von liste2 (value=index2)
#
#     :param list1: erste Liste mit Daten
#     :param list2: zweite Liste mit Daten
#     :param distbetween: distbetween offset
#     :return: distbetween_index_dict = build_index_class_of_euro_dict(list1,list2,distbetween) => overlap_index_dict[key] = value key: index of liste1 value: index of liste2
#     """
#
#
#     distbetween_ndex_dict = {}
#     distbetweenhalf = distbetween / 2
#     index2 = 0
#     n2 = len(list2)
#
#     for index1, dat in enumerate(list1):
#
#         while (index2 < (n2-1)) and (dat > (list2[index2] + distbetweenhalf)):
#             index2 += 1
#         # end while
#
#         while (index2 > 0) and (dat < (list2[index2] - distbetweenhalf)):
#             index2 -= 1
#         # end while
#
#         if abs(dat - list2[index2]) < distbetweenhalf:
#             distbetween_ndex_dict[index1] = index2
#             index2 += 1
#         # end if
#     # end for
#     # print("overlap_ndex_dict:", overlap_ndex_dict)
#     return distbetween_ndex_dict
# # end def
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
# def merge_usdeuro_dfnew_to_df(df,df_new, dat_name,usdeuro_name):
#     """
#
#     :param df:
#     :param df_new:
#     :param dat_name:
#     :param usdeuro_name: (status, errtext, df_merge) = wp_fkt.merge_usdeuro_dfnew_to_df(df,df_new, dat_name,usdeuro_name)
#     :return:
#     """
#     status = hdef.OKAY
#     errtext = ""
#
#     np_dat_akt = df[dat_name].to_numpy()
#     np_dat_new = df_new[dat_name].to_numpy()
#
#     half_day_seconds = 24 * 60 * 60
#     sort_index_list = build_sort_list_of_index(list(np_dat_akt), list(np_dat_new), half_day_seconds)
#
#     if len(sort_index_list):
#         np_usdeuro_akt = df[usdeuro_name].to_numpy()
#         np_usdeuro_new = df_new[usdeuro_name].to_numpy()
#
#         np_dat_merge = np.array([], dtype=np.int64)
#         np_usdeuro_merge = np.array([], dtype=np.float64)
#
#
#         for index,val in enumerate(sort_index_list):
#
#             if val[0] == 0:
#                 np_dat_merge = np.append(np_dat_merge,np_dat_akt[val[1]:val[2]+1])
#                 np_usdeuro_merge = np.append(np_usdeuro_merge,np_usdeuro_akt[val[1]:val[2]+1])
#             else:
#                 np_dat_merge = np.append(np_dat_merge,np_dat_new[val[1]:val[2]+1])
#                 np_usdeuro_merge = np.append(np_usdeuro_merge,np_usdeuro_new[val[1]:val[2] + 1])
#             # end if
#         # end for
#         (status, errtext, df) = build_usdeuro_df(np_dat_merge, dat_name, np_usdeuro_merge, usdeuro_name)
#     # end if
#     return (status, errtext, df )
# # end def
# def get_usdeuro_df_with_dat(df,first_dat,last_dat,dat_name,usdeuro_name):
#     """
#
#     :param df:
#     :param first_dat:
#     :param last_dat:
#     :param dat_name:
#     :param usdeuro_name:
#     :return: (status, errtext, dfpart,first_df_dat,last_df_dat) = wp_fkt.get_usdeuro_df_with_dat(df,first_dat,last_dat,dat_name,usdeuro_name)
#     """
#     status = hdef.OKAY
#     errtext = ""
#     dfpart = None
#     first_df_dat = None
#     last_df_dat = None
#
#     np_dat_akt = df[dat_name].to_numpy()
#     np_usdeuro_akt = df[usdeuro_name].to_numpy()
#
#     half_day_seconds = 12 * 60 * 60
#     (start_index,last_index,start_in_range,last_in_range) = find_index_range(list(np_dat_akt), first_dat,last_dat, half_day_seconds)
#
#     if (start_index is None) or (last_index is None):
#         status = hdef.NOT_OKAY
#         errtext = f"Das Datum zwischen {first_dat = } und {last_dat = } konnte nicht gefunden werden."
#         return (status,errtext,dfpart,first_df_dat,last_dat,first_df_dat,last_df_dat)
#     else:
#         np_dat_part = np.array(np_dat_akt[start_index:last_index+1])
#         np_usdeuro_part = np.array(np_usdeuro_akt[start_index:last_index+1])
#         first_df_dat = np_dat_part[0]
#         last_df_dat = np_dat_part[-1]
#         dfpart = build_usdeuro_df(np_dat_part, dat_name, np_usdeuro_part, usdeuro_name)
#     # end if
#     return (status,errtext,dfpart,first_df_dat,last_dat,first_df_dat,last_df_dat)
# # end def
###########################################################################
# testen mit main
###########################################################################
if __name__ == '__main__':

    # dat_tup = letzter_beendeter_handelstag_dat_list("xetra")

    # print(hdt.str_dat_from_dat_list(dat_tup))

    liste1 = [11.0, 12.0, 14.0, 15.0]
    liste2 = [1.0,2.0, 9.0,13.0, 14.0, 15.0, 16.0, 17.0]
    distbetween = 1

    print(f"{liste1 = }")
    print(f"{liste2 = }")
    pre_sort_index_list = build_sort_list_of_index(liste1, liste2, distbetween)

    for index,val in enumerate(pre_sort_index_list):
        print(f"{index =},{val = }")