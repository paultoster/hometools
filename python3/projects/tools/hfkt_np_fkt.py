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
def vergleich(np_dat1_array,np1_array,vergleich,np_dat2_array,np2_array):
    """
    (status,errtext,np_dat_array,np_array) = hnpfkt.vergleich(np_dat1_array,np1_array,vergleich,np_dat2_array,np2_array)
    """

    status = hdef.OKAY
    errtext = ""
    np_array = None
    # np_dat_array = None

    (status, errtext, np_dat_array, np1_array,np2_array) = bilde_gleiche_basis(np_dat1_array,np1_array,np_dat2_array,np2_array)

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
    else:
        status = hdef.NOT_OKAY
        errtext = f"Das Vergleichszeichen {vergleich} ist nicht >,<,>=,<= ???"
    # end if
    return (status,errtext,np_dat_array,np_array)
# end def
def bilde_gleiche_basis(np_dat1_array,np1_array,np_dat2_array,np2_array):
    """
    (status, errtext, np_dat_array, np1_array,np2_array) = bilde_gleiche_basis(np_dat1_array,np1_array,np_dat2_array,np2_array)
    """

    status = hdef.OKAY
    errtext = ""
    np_dat_array = None

    if np.array_equal(np_dat1_array,np_dat2_array):
        np_dat_array = np_dat1_array.copy()
        np_array_1 = np1_array.copy()
        np_array_2 = np2_array.copy()
    else:
        overlap = 60*60*24
        (i0,i1,j0,j1) = suche_ueberlappung(np_dat1_array,np_dat2_array,overlap)

        if i0 < 0:
            status = hdef.NOT_OKAY
            errtext = "bilde_gleiche_basis: np_dat1_array und np_dat2_array überlappen sich nicht!!!!"
            return (status, errtext, np_dat_array, np1_array,np2_array)
        # end if

        np_dat_array = np_dat1_array[i0:i1].copy()
        np_array_1 = np1_array[i0:i1].copy()
        np_array_2 = np2_array[j0:j1].copy()

    # end if
    return (status, errtext, np_dat_array, np_array_1, np_array_2)
# end dfe
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

if __name__ == '__main__':


    np_array1 = np.array([10.,20.])
    np_array2 = np.array([20., 30., 40.,50.])
    overlap = 10.
    (np1_i0, np1_i1, np2_i0, np2_i1) = suche_ueberlappung(np_array1, np_array2, overlap)

    print(f"{np1_i0 = },{np1_i1 = },{np2_i0 = },{np2_i1 = }")