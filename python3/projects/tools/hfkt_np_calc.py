"""
    Integer Berechnungen

    liste = devide_in_nparts(102,5) => liste = np.array([21,21,20,20,20])
    (mean_zins,np_mean_zins_curve_array) = build_mean_zins_curve(np_dyears_array,np_value_array)
    (median_zins,np_median_zins_curve_array) = build_median_zins_curve(np_dyears_array,np_value_array)

"""

import numpy as np
import math
import scipy

def divide_in_int_nparts(ival:int,nparts:int):
    """
    param:  ival: int               Zum Divividieren
    param:  nparts: int             In wieviel anteile
    return: list_ivals: list[int]   Liste mit Anteilen
    """

    val = int(float(ival)/float(nparts))

    np_int_array = np.repeat(val, nparts)

    if np.sum(np_int_array) > ival:
        for i in reversed(range(nparts)):
            np_int_array[i] -= 1
            if np.sum(np_int_array) == ival:
                break
            # end if
        # end for
    else:
        for i in range(nparts):
            if np.sum(np_int_array) == ival:
                break
            else:
                np_int_array[i] += 1
            # end if
        # end for
    # end if
    return np_int_array
# end def
def build_mean_zins_curve(np_dyears_array,np_value_array):
    """

    :param np_dyears_array:
    :param np_vale_array_:
    :return: (mean_zins,np_mean_zins_curve_array)
    """
    def build_mean_zins_curve_function(mean_zins,np_dy_array,np_val_array):


        ferror = 0.0
        for i, dy in np.ndenumerate(np_dy_array):
            try:
                zinseszins = np_val_array[0] * math.pow(max(0.0,mean_zins[0] + 1.0), dy)
            except:
                zinseszins = 0.
            diff       = zinseszins - np_val_array[i]
            ferror += diff*diff
        # end for

        return ferror
    # end def
    def build_mean_zins_curve_derive(mean_zins,np_dy_array,np_val_array):

        zins_fact = mean_zins[0] + 1.
        fderive = 0.0
        for i, dy in np.ndenumerate(np_dy_array):
            A0          = np_val_array[0]*math.pow(zins_fact, dy)
            ableitung_i = 2.*dy*A0/zins_fact
            ableitung_i *= (A0 - np_val_array[i])
            fderive += ableitung_i
        # end for

        return fderive
    # end def

    # Startpunkt
    Kn_K0 = np_value_array[-1] / np_value_array[0]
    years = np_dyears_array[-1]
    zins_fact = math.pow(Kn_K0, 1. / years)
    mean_zins = zins_fact - 1.

    result = scipy.optimize.minimize(build_mean_zins_curve_function,
                                     x0= mean_zins,
                                     args=(np_dyears_array,np_value_array),
                                     method = "BFGS",
                                     options = { "maxiter": 1000,
                                                 "gtol": 1e-10
                                               }
                                     )

    # jac = build_mean_zins_curve_derive,

    mean_zins = result.x[0]
    zins_fact = mean_zins + 1.
    np_mean_zins_curve_array = np.array(np_dyears_array)

    for index, x in np.ndenumerate(np_mean_zins_curve_array):
        np_mean_zins_curve_array[index] = (np_value_array[0] *
                                          math.pow(zins_fact, x))

    return (mean_zins,np_mean_zins_curve_array)
# end def
def build_median_zins_curve(np_dyears_array,np_value_array):
    """

    :param np_dyears_array:
    :param np_vale_array_:
    :return: (median_zins,np_median_zins_curve_array)
    """
    def build_median_zins_curve_function(mean_zins,np_dy_array,np_val_array):


        ferror = 0.0
        for i, dy in np.ndenumerate(np_dy_array):
            zinseszins = np_val_array[0] * math.pow(max(0.0,mean_zins + 1.0), dy)
            diff       = zinseszins - np_val_array[i]
            ferror += diff
        # end for

        return ferror
    # end def

    # Startpunkt
    Kn_K0 = np_value_array[-1] / np_value_array[0]
    years = np_dyears_array[-1]
    zins_fact = math.pow(Kn_K0, 1. / years)
    median_zins = zins_fact - 1.

    result = scipy.optimize.root_scalar(build_median_zins_curve_function,
                                        args=(np_dyears_array,np_value_array),
                                        bracket=(0, median_zins*100)
                                        )
    median_zins = result.root
    zins_fact = median_zins + 1.
    np_median_zins_curve_array = np.array(np_dyears_array)

    for index, x in np.ndenumerate(np_median_zins_curve_array):
        np_median_zins_curve_array[index] = (np_value_array[0] *
                                          math.pow(zins_fact, x))

    return (median_zins,np_median_zins_curve_array)
# end def
def build_klassen_einteilung(np_array,delta):
    """
    
    :param np_array: 
    :return: (np_klassen_schwerpunkt_array,np_klassen_haeufigkeit_array)
    """
    (ymin,ymax) = build_klassen_min_max(np_array,delta)

    liste = [ymin]
    while liste[-1] < ymax:
        liste.append(liste[-1]+delta)
    # end if
    if liste[-1] > ymax:
        del liste[-1]
        liste[-1] = ymax
    # end if

    np_klassen_grenzen_array = np.array(liste)
    np_klassen_haeufigkeit_array, _ = np.histogram(np_array, bins=np_klassen_grenzen_array)


    np_klassen_schwerpunkt_array = np.array([])
    for i in range(1, np_klassen_grenzen_array.shape[0]):
        np_klassen_schwerpunkt_array = np.append(np_klassen_schwerpunkt_array,
                                                 0.5 * (np_klassen_grenzen_array[i] + np_klassen_grenzen_array[i - 1]))
    # end for

    return (np_klassen_schwerpunkt_array,np_klassen_haeufigkeit_array)
# end def
def build_klassen_min_max(np_array,delta):
    """
    Bilde im Raster von delta val_min und val_max, so dass val_max-vel_min ein vielfaches von delta ist
    :param np_array:
    :param delta:
    :return:
    """

    y0 = np.min(np_array)
    y1 = np.max(np_array)
    dy = np.abs(delta)
    if dy > 0.0000001:
        n0 = np.floor(y0/dy)
        n1 = np.ceil(y1/dy)

        if n0 == n1:
            n0 = n0 - 1
            n1 = n1 + 1
        # end if
        ymin = n0*dy
        ymax = n1*dy
    else:
        ymin = 0.
        ymax = 0.
    # end if
    return (ymin,ymax)
# end def

