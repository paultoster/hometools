"""
    Integer Berechnungen

    liste = devide_in_nparts(102,5) => liste = np.array([21,21,20,20,20])

"""

import numpy as np

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
