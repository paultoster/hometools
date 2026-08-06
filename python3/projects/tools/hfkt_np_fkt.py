import numpy as np
import os, sys, copy

t_path, _ = os.path.split(__file__)
if (t_path == os.getcwd()):

    import hfkt_def as hdef
#    import hfkt_file_path as hfile_path
else:
    p_list = os.path.normpath(t_path).split(os.sep)
    if (len(p_list) > 1): p_list = p_list[: -1]
    t_path = ""
    for i, item in enumerate(p_list): t_path += item + os.sep
    if (os.path.normpath(t_path) not in sys.path): sys.path.append(t_path)

    from tools import hfkt_def as hdef
#    from tools import hfkt_file_path as hfile_path
# end if



def sma(np_array: np.ndarray, k:int):
    """
    simple moving avarage
    :param np_array:
    :param k:
    :return: np_sma_array (copy) = sma(np_arry,k)
    """
    np_sma_array = np.zeros(np_array.shape)
    n = len(np_array)

    sum = 0.
    for i in range(n):
        i1 = i+1
        if i1 <= k:
            sum += np_array[i]
            np_sma_array[i] = sum / float(i1)
        else:
            np_sma_array[i] = np_sma_array[i-1] + (np_array[i]-np_array[i-k])/float(k)
        # end if
    # end for
    return np_sma_array
# end def
def ema(np_array: np.ndarray, k:int):
    """
    exponential moving avarge
    :param np_array:
    :param k:
    :return: np_sma_array (copy) = sma(np_arry,k)
    """
    np_ema_array = np.zeros(np_array.shape)
    n = len(np_array)

    fac = 2./(k+1)
    einsmfac = 1.-fac
    for i in range(n):
        if i == 0:
            np_ema_array[i] = np_array[i]
        else:
            np_ema_array[i] = np_array[i] * fac + np_ema_array[i-1] * einsmfac
        # end if
    # end for
    return np_ema_array
# end def
def lingrad(np_array: np.ndarray, npoints:int, grad_faktor:float ):
    """
    Bilde ein lineare Funktion über npoints erstelle y0_np_array,y1_np_array die Eckpunkte der gerade über
    n_np_arry Punkten. Bilde den relativen Anstieg bezogen auf den Mittelwert von y0 und y1 multipliziert mit grad_faktor
    damit wird es auf einen anderen Zeitraum gerechnet (Tageschart, grad_faktor = 252 => Jahres Anstieg relativ )

    (n_np_array,y0_np_array,y1_np_array,rel_anstieg_np_array) = hfkt.lingrad(np_array,npoints,grad_faktor)
    """

    n = len(np_array)
    n_np_array = np.zeros((n,), dtype=np.int_)
    y0_np_array = np.zeros(np_array.shape)
    y1_np_array = np.zeros(np_array.shape)
    rel_anstieg_np_array = np.zeros(np_array.shape)

    for i in  range(n):

        if i == 0:

            y0 = y1 = np_array[i]
            ny = 1
            rel_anstieg = 0.0
        else:

            ny = min(npoints,i+1)

            x_np_array = np.arange(ny).astype(float)
            y_np_array = np_array[i-ny+1:i+1]
            A = np.vstack([x_np_array, np.ones(ny).astype(float)]).T
            grad, c = np.linalg.lstsq(A, y_np_array)[0]

            y0 = c
            y1 = c + grad * (ny-1)
            rel_anstieg = grad * grad_faktor * 2. / (y0+y1)
        # end if

        n_np_array[i] = ny
        y0_np_array[i] = y0
        y1_np_array[i] = y1
        rel_anstieg_np_array[i] = rel_anstieg
    # end for

    return (n_np_array, y0_np_array, y1_np_array, rel_anstieg_np_array)
# end def
def minvalue(np_array: np.ndarray, minvalue:int|float):
    """
    minimum value
    :param np_array:
    :param k:
    :return: np_sma_array (copy) = sma(np_arry,k)
    """
    minval = np_array.dtype.type(minvalue)
    np_min_array = np.zeros(np_array.shape)
    n = len(np_array)

    for i in range(n):
        if np_array[i] < minval:
            np_min_array[i] = np_array[i]
        else:
            np_min_array[i] = minval
        # end if
    # end for
    return np_min_array
# end def
def maxvalue(np_array: np.ndarray, maxvalue:int|float):
    """
    maximum value
    :param np_array:
    :param k:
    :return: np_sma_array (copy) = sma(np_arry,k)
    """
    maxval = np_array.dtype.type(maxvalue)
    np_max_array = np.zeros(np_array.shape)
    n = len(np_array)

    for i in range(n):
        if np_array[i] > maxval:
            np_max_array[i] = np_array[i]
        else:
            np_max_array[i] = maxval
        # end if
    # end for
    return np_max_array
# end def
def vergleich(np_dat1_array,np1_array,vergleich,np_dat2_array,np2_array):
    """
    (status,errtext,np_dat_array,np_array) = hnpfkt.vergleich(np_dat1_array,np1_array,vergleich,np_dat2_array,np2_array)
    """

    status = hdef.OKAY
    errtext = ""
    np_array = None
    # np_dat_array = None

    (status, errtext, np_dat_array, np_array_liste) = bilde_gleiche_basis([np_dat1_array,np_dat2_array],[np1_array,np2_array])

    np1_array = np_array_liste[0]
    np2_array = np_array_liste[1]

    if status != hdef.OKAY:
        return (status, errtext, np_dat_array, np_array)

    np_array = np.zeros(np_dat_array.shape).astype(int)

    if vergleich == ">":
        for i,val in enumerate(np1_array):

            if val > np2_array[i]:
                np_array[i] = 1
            # end if
        # end for
    elif vergleich == "<":
        for i, val in enumerate(np1_array):

            if val < np2_array[i]:
                np_array[i] = 1
            # end if
        # end for
    elif vergleich == ">=":
        for i, val in enumerate(np1_array):

            if val >= np2_array[i]:
                np_array[i] = 1
            # end if
        # end for
    elif vergleich == "<=":
        for i, val in enumerate(np1_array):

            if val <= np2_array[i]:
                np_array[i] = 1
            # end if
        # end for
    elif vergleich == "==":
        for i, val in enumerate(np1_array):

            if val == np2_array[i]:
                np_array[i] = 1
            # end if
        # end for
    elif vergleich == "!=":
        for i, val in enumerate(np1_array):

            if val != np2_array[i]:
                np_array[i] = 1
            # end if
        # end for
    else:
        status = hdef.NOT_OKAY
        errtext = f"Das Vergleichszeichen {vergleich} ist nicht >,<,>=,<=,==,!= ???"
    # end if
    return (status,errtext,np_dat_array,np_array)
# end def
def bedingung(np_dat_array_liste,np_array_liste):
    """
    Bilde die gemeinsame Datumsbasis und vergleiche auf > 0/0.0
    np_dat_array_liste = [np_dat_array1, np_dat_array2,,...]
    np_array_liste = [np_array1, np_array2,...]
    return (status,errtext,np_dat_array,np_bedignung_array) = hnpfkt.bedigung(np_dat_array_liste,np_array_liste)
    """
    np_bedignung_array = None

    (status, errtext, np_dat_array, np_array_liste) = bilde_gleiche_basis(np_dat_array_liste, np_array_liste)

    if status != hdef.OKAY:
        return (status, errtext, np_dat_array, np_bedignung_array)

    np_bedignung_array = np.zeros(len(np_dat_array), dtype=np.int64)

    for i,np_array in enumerate(np_array_liste):
        flag = True
        for j,val in enumerate(np_array):

            if isinstance(val,int):
                if val <= 0:
                    flag = False
                    break
                # end if
            else:
                if val <= 0.0:
                    flag = False
                    break
                # end if
            # end if
        # end for
        if flag:
            np_bedignung_array[j] = 1
        # end if
    # end for

    return (status,errtext,np_dat_array,np_bedignung_array)
# end def
# def bilde_gleiche_basis(np_dat1_array,np1_array,np_dat2_array,np2_array):
#     """
#     (status, errtext, np_dat_array, np1_array,np2_array) = bilde_gleiche_basis(np_dat1_array,np1_array,np_dat2_array,np2_array)
#     """
#
#     status = hdef.OKAY
#     errtext = ""
#     np_dat_array = None
#
#     if np.array_equal(np_dat1_array,np_dat2_array):
#         np_dat_array = np_dat1_array.copy()
#         np_array_1 = np1_array.copy()
#         np_array_2 = np2_array.copy()
#     else:
#         overlap = 60*60*24
#         (i0,i1,j0,j1) = suche_ueberlappung(np_dat1_array,np_dat2_array,overlap)
#
#         if i0 < 0:
#             status = hdef.NOT_OKAY
#             errtext = "bilde_gleiche_basis: np_dat1_array und np_dat2_array überlappen sich nicht!!!!"
#             return (status, errtext, np_dat_array, np1_array,np2_array)
#         # end if
#
#         np_dat_array = np_dat1_array[i0:i1].copy()
#         np_array_1 = np1_array[i0:i1].copy()
#         np_array_2 = np2_array[j0:j1].copy()
#
#     # end if
#     return (status, errtext, np_dat_array, np_array_1, np_array_2)
# # end def
def bilde_gleiche_basis(np_dat_array_liste,np_array_liste_in):
    """
    Bilde die gemeinsame Datumsbasis

    np_dat_array_liste = [np_dat_array1, np_dat_array2,,...]
    np_array_liste = [np_array1, np_array2,...]

    (status, errtext, np_dat_array, np_array_liste) = bilde_gleiche_basis(np_dat_array_liste,np_array_liste)
    """

    n = min(len(np_dat_array_liste),len(np_array_liste_in))

    status = hdef.OKAY
    errtext = ""

    np_array_liste = [None]*n

    overlap = 60 * 60 * 24
    np_dat_array = bilde_gemeinsame_dat_basis(np_dat_array_liste,overlap)

    for i in range(n):
        sort_index_list = build_sort_list_of_index(np_dat_array, np_dat_array_liste[i], overlap)
        if len(sort_index_list):
            np_old_array = np_array_liste_in[i]
            np_array = np.array([], dtype=np_old_array.dtype)
            for index, val in enumerate(sort_index_list):

                if val[0] == 0:
                    np_array = np.append(np_array, np_old_array[val[1]:val[2] + 1])
                else:
                    np_array = np.append(np_array, np_old_array[val[1]:val[2] + 1])
                # end if
            # end for
            np_array_liste[i] = np_array
        # end if
    # end for
    return (status, errtext, np_dat_array, np_array_liste)
# end def
def build_sort_list_of_index(np_data_array1, np_data_array2, overlap):
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
    n1 = len(np_data_array1)
    n2 = len(np_data_array2)
    LIST1 = 0
    LIST2 = 1

    flag_run_liste1 = True
    flag_run_liste2 = True
    overlaphalf = overlap / 2

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

            if flag_run_liste2 and (np_data_array2[index2] + overlaphalf < np_data_array1[index1]):
                pre_sort_index_list.append((LIST2, index2))
                index2 += 1
            elif flag_run_liste1 and (np_data_array1[index1] + overlaphalf < np_data_array2[index2]):
                pre_sort_index_list.append((LIST1, index1))
                index1 += 1
            elif abs(np_data_array1[index1] - np_data_array2[index2]) <= overlaphalf:
                pre_sort_index_list.append((LIST1, index1))
                index1 += 1
                index2 += 1
            elif flag_run_liste2 and (np_data_array2[index2] > np_data_array1[index1] + overlaphalf):
                pre_sort_index_list.append((LIST2, index2))
                index2 += 1
            elif flag_run_liste1 and (np_data_array1[index1] > np_data_array2[index2] + overlaphalf):
                pre_sort_index_list.append((LIST1, index1))
                index1 += 1
            # end if

            if flag_run_liste1:
                if index1 == n1:
                    flag_run_liste1 = False
                    index1 = n1 - 1
                # end if
            # end if
            if flag_run_liste2:
                if index2 == n2:
                    flag_run_liste2 = False
                    index2 = n2 - 1
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
        for index, val in enumerate(pre_sort_index_list):

            if akt_liste1_flag:
                if val[0] == LIST2:
                    i2 = pre_sort_index_list[index - 1][1]
                    sort_index_list.append((LIST1, i1, i2))
                    akt_liste1_flag = False
                    i1 = val[1]
                # end if
            else:
                if val[0] == LIST1:
                    i2 = pre_sort_index_list[index - 1][1]
                    sort_index_list.append((LIST2, i1, i2))
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


def bilde_gemeinsame_dat_basis(np_dat_array_liste,overlap):
    """
    np_data_array = bilde_gemeinsame_dat_basis(np_dat_array_liste,overlap)
    """
    n = len(np_dat_array_liste)

    overlap_half = overlap/2

    liste = []
    for i in range(len(np_dat_array_liste[0])):

        dat0 = np_dat_array_liste[0][i]
        flag = True
        for j in range(1,n):
            dat1 = find_nearest_value(dat0,np_dat_array_liste[j])
            if (dat1 is None) or (abs(dat1 - dat0) > overlap_half):
                flag = False
                break
            # end if
        # end for
        if flag:
            liste.append(dat0)
        # end if
    # end if

    np_dat_array = np.array(liste)
    index_arr = np.argsort(np_dat_array)
    np_dat_array = np.array(np_dat_array)[index_arr]

    return np_dat_array
# end def
def find_nearest_value(val,np_array):
    """
    val1 = find_nearest_value(value,np_array)
    """

    val1 = None
    if  len(np_array):
        dval = abs(val-np_array[0])
        idval = 0
        for i in range(1,len(np_array)):
            if abs(val-np_array[i]) < dval:
                dval = abs(val-np_array[i])
                idval = i
            # end if
        # end for
        val1 = np_array[idval]
    # end if
    return val1
# end def
def suche_ueberlappung(np1_array,np2_array,overlap):
    """
    (np1_i0,np1_i1,np2_i0,np2_i1) = suche_ueberlappung(np1_array,np2_array,overlap)
    """

    overlaphalf = overlap/2.

    np1_i0 = -1
    np1_i1 = -1
    np2_i0 = -1
    np2_i1 = -1

    if (len(np1_array) == 0) or (len(np2_array) == 0):
        return (np1_i0,np1_i1,np2_i0,np2_i1)
    else:
        start_np1 = np1_array[0]
        start_np2 = np2_array[0]

        end_np1 = np1_array[-1]
        end_np2 = np2_array[-1]

        if (start_np1 >= start_np2 + overlaphalf) and (start_np1 <end_np2+overlaphalf):
            np1_i0 = 0

            for i,val in enumerate(np2_array):
                if abs(val - start_np1) < overlaphalf:
                    np2_i0 = i
                    break
                # end if
            # end for

        elif (start_np2 >= start_np1 + overlaphalf) and (start_np2 <end_np1+overlaphalf):
            np2_i0 = 0

            for i,val in enumerate(np1_array):
                if abs(val - start_np2) < overlaphalf:
                    np1_i0 = i
                    break
                # end if
            # end for
        elif abs(start_np1 - start_np2) < overlaphalf:
            np1_i0 = 0
            np2_i0 = 0
        # end if


        if (end_np1 + overlaphalf < end_np2) and  (end_np1 + overlaphalf > start_np2):
            np1_i1 = len(np1_array)-1
            for i in range(len(np2_array)-1,-1,-1):
                if abs(np2_array[i] - end_np1) < overlaphalf:
                    np2_i1 = i
                    break
                # end if
            # end for
        elif (end_np2 + overlaphalf < end_np1) and (end_np2 + overlaphalf > start_np1) :
            np2_i1 = len(np2_array)-1
            for i in range(len(np1_array)-1,-1,-1):
                if abs(np1_array[i] - end_np2) < overlaphalf:
                    np1_i1 = i
                    break
                # end if
            # end for
        elif abs(end_np1 - end_np2) < overlaphalf:
            np1_i1 = len(np1_array)-1
            np2_i1 = len(np2_array)-1
        # end if
    # end if

    return (np1_i0,np1_i1,np2_i0,np2_i1)
# end def
def is_monoton_steigend(x_np_array):  # Monoton  steigend
    if np.all(np.diff(x_np_array) > 0):
        return True
    else:
        return False
# end if

def interpoliere(x,x_np_array,y_np_array,type='lin'):
    """
        x  Interpoliere für x, kann single oder np_array sein
        x_np_array x-Werte Array
        y_np_array y-Werte Array
        type = 'lin' linear oder 'const'

        retunr y = interpoliere(x,x_np_array,y_np_array,type)
    """

    if isinstance(x,np.ndarray) or isinstance(x,list):

        index_liste = []
        d_liste = []
        for i in range(len(x)):
            (index,d) = find_index_d(x_np_array,x[i])
            index_liste.append(index)
            d_liste.append(d)
        # end for
    else:
        (index, d) = find_index_d(x_np_array, x)
        index_liste = [index]
        d_liste = [d]
    # end if

    f_liste = []
    for (index,d) in zip(index_liste,d_liste):
        f = y_np_array[index]
        if type == 'lin':
            f += (y_np_array[index+1]-y_np_array[index]) * d
        #end if
        if (d < 0.0) or (d > 1.0):
            f = 0.0
        # end if

        f_liste.append(f)
    # end ofr
    if isinstance(x, np.ndarray):
        y = np.array(f_liste)
    elif isinstance(x, list):
        y = f_liste
    else:
        y = f_liste[0]
    # end if

    return y
# end if

def find_index_d(x_np_array,x):


    n = len(x_np_array)

    if x < x_np_array[0]:
        index = 0
        d     = 0.0
        if n > 1:
            d = (x - x_np_array[0])/(x_np_array[1]-x_np_array[0])
        # end if
    elif x >= x_np_array[n-1]:
        index = n-2
        d     = 0.0
        if n > 1:
            d = (x - x_np_array[n-1])/(x_np_array[n-2]-x_np_array[n-1])
        # end if
    else:
        for i in range(n-1):

            if (x >= x_np_array[i]) and (x < x_np_array[i+1]):
                index = i
                d = (x - x_np_array[i])/(x_np_array[i+1]-x_np_array[i])
                break
            # end if
        # end for
    # end if
    return (index,d)
# end def
if __name__ == '__main__':


    np_array1 = np.array([10.,20.])
    np_array2 = np.array([20., 30., 40.,50.])
    overlap = 10.
    (np1_i0, np1_i1, np2_i0, np2_i1) = suche_ueberlappung(np_array1, np_array2, overlap)

    print(f"{np1_i0 = },{np1_i1 = },{np2_i0 = },{np2_i1 = }")