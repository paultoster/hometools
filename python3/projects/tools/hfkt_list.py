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

 llist = erase_from_llist(llist,index_list)
 
 list_moved =  list_move_items(list_in,index_liste,index_end = -1):
                list_move_items(list_in,[0,1,2,10,12])    moves index 0,1,2,10,12 to new list
                list_move_items(list_in,1,12)             moves index 1,2,... 10,11,12 to new list
    csd = CCommandStrData()
    for i in index_liste:
      if( i < self.n ):
        csd.add(self.command_str_list[i],self.linenum_str_list[i])
      #endif
    #endfor
    self.erase(index_liste)
    self.n = len(self.command_str_list)
    return csd


liste = multiply_constant(liste, value)

liste = add_constant(liste, value)

lliste = [[0,10,'a',2.],[0,5,'b',2.],[0,5,'bbbbb',3.],[0,15,'rrr',2.]]

lliste = sort_list_of_list(lliste,index,aufsteigend=1) sortiere nach dem index lliste[i][index]

(liste = search_double_value_in_list_return_indexlist(liste,value))

index_liste = search_double_value_in_list_return_indexllist(liste)

index_liste = search_value_in_list_return_indexlist(liste,value)

index_liste = search_value_in_llist_return_indexlist(lliste,icol,value)

newlist = sort_list_of_dict(lliste, keyname, aufsteigend=1)

keylist = find_keys_of_dict_value_as_list(ddict,value)

value = find_first_key_dict_value(ddict,value) if not in value = None


'''

# from tkinter import *
# from tkinter.constants import *
# import tkinter.filedialog
# import tkinter.messagebox
# import tkinter.tix
import string
# import types
# import copy
# import sys
import os
# import stat
# import time
# import datetime
# import calendar
# import csv
# import array
# import shutil
import math
# import struct
# import ftfy
# import fnmatch
from operator import itemgetter


KITCHEN_MODUL_AVAILABLE = False


OK     = 1
NOT_OK = 0
QUOT    = 1
NO_QUOT = 0
TCL_ALL_EVENTS = 0


def join_list(liste,delim=None):
    """
    Fügt list sofern text mit delim zusammen
    """
    txt = ""
    if delim is None:
        ddelim = os.sep
    else:
        ddlim = delim
    # end if

    n   = len(liste)
    for i in range(n):
        if( isinstance(liste[i],str) ):
            if( i > 0 ):
                txt = txt + ddlim
            #endif
            txt = txt+liste[i]
        #endif
    #endif
    return txt

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

def get_clist_from_llist(llist,index):
    '''
    get column list from llist
    llist = [[1,2,3,4],[10,20,30,40],[100,200,300,400]]
    index = 1
    return clist = [2,20,200]
    '''
    clist = []
    for liste in llist:
        if index < len(liste):
            clist.append(liste[index])
        else:
            clist.append('')
        # end if
    # end for
    return clist
# end def
def get_condensed_list_by_index_list(liste,index_liste):
    '''
    liste = [10,20,30,40,50]
    index_liste = [1,3,4]
    return [20,40,50]
    '''

    condens_liste = []
    n = len(liste)
    for i in index_liste:
        if i < n:
            condens_liste.append(liste[i])
        # end if
    # end for
    return condens_liste
# end def
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

def erase_from_llist(llist,index_list):
    '''
    löscht von eine doppellist
    :param llist_in:
    :param index_list:
    :return: llist = erase_from_llist(llist,index_list)
    '''
    
    for i,liste in enumerate(llist):
        llist[i] = erase_from_list(liste, index_list)
    # end for
    return llist
# end def

def list_move_items(list_in,index_liste,index_end = -1):
  """
    list_moved = list_move_items(list_in,[0,1,2,10,12])    moves index 0,1,2,10,12 to new list
    list_moved = list_move_items(list_in,1,12)             moves index 1,2,... 10,11,12 to new list
  """
  list_moved = []
  if( index_end > -1 and not isinstance(index_liste,list)):
    i0 = int(index_liste)
    i1 = int(index_end)
    index_liste = [*range(i0,i1+1,1)]
  elif(not isinstance(index_liste,list)):
    index_liste = [index_liste]
  #endif

  for i in index_liste:
    if( i < len(list_in) ):
      list_moved.append(list_in[i])
    #endif
  #endfor

  list_in = erase_from_list(list_in,index_liste)

  return list_moved



def multiply_constant(ll, value):
  """
    multiplies a list with const value
    """
  if (isinstance(ll, list)):
    out = []
    for i in range(len(ll)):
      if (isinstance(ll[i], str)):
        val = float(ll[i]) * value
        out.append(str(val))
      else:
        out.append(ll[i] * value)
  else:
    if (isinstance(ll, str)):
      val = float(ll) * value
      out = str(val)
    else:
      out = ll * value

  return out


def add_constant(ll, value):
  """
    add to a list const value
    """
  if (isinstance(ll, list)):
    for i in range(len(ll)):
      if (isinstance(ll[i], str)):
        ll[i] = float(ll[i]) + value
        ll[i] = str(ll[i])
      else:
        ll[i] += value
  else:
    if (isinstance(ll, str)):
      ll = float(ll) + value
      ll = str(ll)
    else:
      ll += value

  return ll


#enddef

def sort_list_of_list(lliste,index,aufsteigend=1):
    '''
    z.B. lliste = [[0,10,'a',2.],[0,5,'b',2.],[0,5,'bbbbb',3.],[0,15,'rrr',2.]]
    sortiere nach dem index lliste[i][index]
    
    :param lliste:
    :param index:
    :param aufsteigend:
    :return: lliste = sort_list_of_list(lliste,index,aufsteigend=1)
    '''
    
    if aufsteigend:
        new_llist = sorted(lliste, key=lambda v: (v[index]))
    else:
        new_llist = sorted(lliste, key=lambda v: (v[index]), reverse=True)
    # edn fi
    
    return new_llist

def search_double_value_in_list_return_indexlist(liste,value):
    '''
    
    :param liste:
    :param value:
    :return: index_liste = search_value_in_list_retunr_indexlist(liste,value)
    '''
    return [i for i, x in enumerate(liste) if x == value]
# end def

def search_double_value_in_list_return_indexllist(liste):
    indexllist = []
    set_liste = set(liste)
    if( len(set_liste) != len(liste) ):
        for val in set_liste:
            liste1 = search_double_value_in_list_return_indexlist(liste,val)
            if len(liste1) > 1:
                indexllist.append(liste1)
            # end if
        # end for
    # end if
    return indexllist
# end def

def search_value_in_list_return_indexlist(liste,value):
    '''
    
    :param liste:
    :param value:
    :return: index_liste = search_value_in_list_return_indexlist(liste,value)
    '''
    
    index_liste = []
    for i,item in enumerate(liste):
        if value == item:
            index_liste.append(i)
        # end if
    # end for
    return index_liste
# end def
def search_value_in_llist_return_indexlist(lliste, icol,value):
    '''

    :param liste:
    :param value:
    :return: index_liste = search_value_in_llist_return_indexlist(lliste,icol,value)
    '''
    
    index_liste = []
    for i, liste in enumerate(lliste):
        if (icol >= 0) and (icol < len(liste)):
            if value == liste[icol]:
                index_liste.append(i)
            # end if
        # end if
    # end for
    return index_liste
# end def

def sort_list_of_dict(lliste, keyname, aufsteigend=1):
    '''
    z.B. lliste = [[0,10,'a',2.],[0,5,'b',2.],[0,5,'bbbbb',3.],[0,15,'rrr',2.]]
    sortiere nach dem item

    :param lliste:
    :param index:
    :param aufsteigend:
    :return: lliste = sort_list_of_list(lliste,index,aufsteigend=1)
    '''
    
    if aufsteigend:
        new_llist = sorted(lliste, key=itemgetter(keyname))
    else:
        new_llist = sorted(lliste, key=itemgetter(keyname), reverse=True)
    # edn fi
    
    return new_llist

def find_keys_of_dict_value_as_list(ddict,value):
    keys = [key for key, val in ddict.items() if val == value]
    return keys
# end def
def find_first_key_dict_value(ddict,value):
    keys = find_keys_of_dict_value_as_list(ddict,value)
    if len(keys):
        return keys[0]
    else:
        return None
# end def
###########################################################################
# testen mit main
###########################################################################
if __name__ == '__main__':
    # lliste = [[0, 10, 'a', 2.], [0, 5, 'b', 2.], [0, 5, 'bbbbb', 3.], [0, 15, 'rrr', 2.]]
    # print(sort_list_of_list(lliste, 1))
    # print(sort_list_of_list(lliste, 1,aufsteigend=0))
    
    lliste = [{'name': 'Homer', 'age': 39}, {'name': 'Bart', 'age': 10}, {'name': 'Constantin', 'age': 10}, {'name': 'Alfred', 'age': 10}]
    print(sort_list_of_dict(lliste, 'name', aufsteigend=1))
    print(sort_list_of_dict(lliste, 'name', aufsteigend=0))
    print(sort_list_of_dict(lliste, 'age', aufsteigend=1))
    print(sort_list_of_dict(lliste, 'age', aufsteigend=0))
