import numpy as np
import os,sys

t_path, _ = os.path.split(__file__)
if( t_path == os.getcwd() ):

  import hfkt_type as htype
  import hfkt_def  as hdef
  import hfkt_np_fkt  as hnp_fkt
else:
  p_list     = os.path.normpath(t_path).split(os.sep)
  if( len(p_list) > 1 ): p_list = p_list[ : -1]
  t_path = ""
  for i,item in enumerate(p_list): t_path += item + os.sep
  if( os.path.normpath(t_path) not in sys.path ): sys.path.append(t_path)

  from tools import hfkt_type as htype
  from tools import hfkt_def  as hdef
  from tools import hfkt_np_fkt as hnp_fkt
#endif--------------------------------------------------------------------------

CM_TO_INCH = 1. / 2.54
WIDTH_DEFAULT_CM = 30.
HEIGHT_DEFAULT_CM = 20.
HSPACE_DEFAULT = 0.05
WSPACE_DEFAULT = 0.05
LEFT_DEFAULT = 0.05
RIGHT_DEFAULT = 0.95
BOTTOM_DEFAULT = 0.1
TOP_DEFAULT = 0.9



def check_dict_plot(dict_plot):
    """
    Plotten eine Diagramms mit mehreren zeitreihen


    dict_input["plot"] = ddict["rows"] = 1  (defaultwert, Anzahl der senkrechten Plots)
                         ddict["cols"] = 1  (defaultwert, Anzahl der waagrechten Plots)
                         ddict["sharex"] = False  (defaultwert, True, 'col', Für alle eine x-Achse)
                         ddict["sharey"] = False  (defaultwert, True, 'row', Für alle eine y-Achse)
                         ddict["width"] = 30 (default, Plot Breite in cm)
                         ddict["height"] = 30 (default, Plot Breite in cm)
                         ddict["hspace"] = 0.05 Anteil Zwischenraum höhe
                         ddict["wspace"] = 0.05 Anteil Zwischenraum breite
                         ddict["left"] = 0.05 in Anteilen linke Position Diagramm
                         ddict["right"] = 0.95
                         ddict["top"] = 0.9
                         ddict["bottom"] = 0.1
                         ddict["title"] = text
                         ddict["subplot_list"] = [dict_subplot1, dict_subplot2, dict_subplot3] Liste von dictionaries

                         dict_plot["height_rows_sum"] errechnet

                         dict_subplot1["name"]   = "subplot1"  (default)
                         dict_subplot1["title"]   = "title"
                         dict_subplot1["xlabel"]   = "xname""
                         dict_subplot1["ylabel"]   = "yname"
                         dict_subplot1["height_rows"] = 1 (default, Wieviele Reihen im Verhältnis zu den anderen Diagrammen soll es einenehmen, Ganzzahl)
                         dict_subplot1["grid"] = True (default, False)
                         dict_subplot1["legend"] = "upper left","upper center","upper right","center left","center","center right","lower left","lower center","lower right"
                         dict_subplot1["data_list"]   = [dict_data1, dictr_data2, ...]

                         dict_data1["xdat"] = np.array([secs1,secs2, ...])
                         dict_data1["y"]   = np.array([val1,val2, ...])
                         dict_data1["color"]   = 'k', (default,'b', 'g', 'r', 'c', 'm', 'y', 'k', 'w', ...)
                         dict_data1["linewidth"]    = 1 (default)
                         dict_data1["linestyle"]    = '-' (default, '--', '-.', ':', '')
                         dict_data1["marker"]    = '' (default, '.', 'o', 'd', 'v', '^', '>', '<', ...)
                         dict_data1["label"]    = 'linex' (default)

                         dict_data1["n"]        errechnet
                         data_dict["xdate_time"] errechnet

    """

    status = hdef.OKAY
    errtext = ""

    # ddict["rows"] = 1  (defaultwert, Anzahl der senkrechten Plots)
    key = "rows"
    if key not in dict_plot:
        dict_plot[key] = 1
    else:
        dict_plot[key] = int(dict_plot[key])
    # end if


    # ddict["cols"] = 1  (defaultwert, Anzahl der waagrechten Plots)
    key = "cols"
    if key not in dict_plot:
        dict_plot[key] = 1
    else:
        dict_plot[key] = int(dict_plot[key])
    # end if
    # dict_plot["sharex"] = False  (defaultwert, True, 'col', Für alle eine x-Achse)
    key = "sharex"
    if key not in dict_plot:
        dict_plot[key] = False
    else:
        dict_plot[key] = bool(dict_plot[key])
    # end if

   # dict_plot["sharey"] = False  (defaultwert, True, 'row', Für alle eine y-Achse)
    key = "sharey"
    if key not in dict_plot:
        dict_plot[key] = False
    else:
        dict_plot[key] = bool(dict_plot[key])
    # end if

    # dict_plot["width"] = 30 (default, Plot Breite in cm)
    key = "width"
    if key not in dict_plot:
        dict_plot[key] = WIDTH_DEFAULT_CM
    else:
        dict_plot[key] = float(dict_plot[key])
    # end if
    dict_plot[key] *= CM_TO_INCH

    # dict_plot["height"] = 20 (default, Plot Breite in cm)
    key = "height"
    if key not in dict_plot:
        dict_plot[key] = HEIGHT_DEFAULT_CM
    else:
        dict_plot[key] = float(dict_plot[key])
    # end if
    dict_plot[key] *= CM_TO_INCH

    liste  = ["hspace"      , "wspace"      , "left"      , "right"      , "top"      , "bottom"]
    dliste = [HSPACE_DEFAULT, WSPACE_DEFAULT, LEFT_DEFAULT, RIGHT_DEFAULT, TOP_DEFAULT, BOTTOM_DEFAULT]

    for id,key in enumerate(liste):
        if key not in dict_plot:
            dict_plot[key] = dliste[id]
        else:
            dict_plot[key] = float(dict_plot[key])
        # end fi
    # ened for

    # ddict["title"] = text
    key = "title"
    if key not in dict_plot:
        dict_plot[key] = ""
    else:
        dict_plot[key] = str(dict_plot[key])
    # end if

    # dict_plot["subplot_list"] = [dict_subplot1, dict_subplot2, dict_subplot3] Liste von dictionaries
    dict_plot["height_rows_sum"] = 0
    for i,subplot_dict in enumerate(dict_plot["subplot_list"]):
        (status,errtext,dict_plot["subplot_list"][i]) = check_dict_subplot(subplot_dict,i)

        dict_plot["height_rows_sum"] += subplot_dict["height_rows"]
        if status != hdef.OKAY:
            return (status, errtext, dict_plot)
        # end if
    # end for


    return (status, errtext, dict_plot)
# end def
def check_dict_subplot(subplot_dict,i):

    status = hdef.OKAY
    errtext = ""


    # dict_subplot1["name"] = "subplot1"(default)
    key = "name"
    if key not in subplot_dict:
        subplot_dict[key] = f"subplot_{i}"
    else:
        subplot_dict[key] = str(subplot_dict[key])
    # end if

    # dict_subplot1["title"] = "title"
    key = "title"
    if key not in subplot_dict:
        subplot_dict[key] = ""
    else:
        subplot_dict[key] = str(subplot_dict[key])
    # end if

    # dict_subplot1["xlabel"] = "xname""
    key = "xlabel"
    if key not in subplot_dict:
        subplot_dict[key] = ""
    else:
        subplot_dict[key] = str(subplot_dict[key])
    # end if


    # dict_subplot1["ylabel"] = "yname""
    key = "ylabel"
    if key not in subplot_dict:
        subplot_dict[key] = ""
    else:
        subplot_dict[key] = str(subplot_dict[key])
    # end if

    # dict_subplot1["height_rows"] = 1 (default, Wieviele Reihen im Verhältnis zu den anderen Diagrammen soll es einenehmen, Ganzzahl)
    key = "height_rows"
    if key not in subplot_dict:
        subplot_dict[key] = 1
    else:
        subplot_dict[key] = max(1,int(subplot_dict[key]))
    # end if

    # dict_subplot1["grid"] = True (default, False)
    key = "grid"
    if key not in subplot_dict:
        subplot_dict[key] = True
    else:
        subplot_dict[key] = bool(subplot_dict[key])
    # end if

    # dict_subplot1["legend"] = "best","upper left","upper center","upper right","center left","center","center right","lower left","lower center","lower right"
    key = "legend"
    if key not in subplot_dict:
        subplot_dict[key] = ""
    else:
        subplot_dict[key] = str(subplot_dict[key])
        if subplot_dict[key] not in ["best","upper left","upper center","upper right","center left","center","center right","lower left","lower center","lower right"]:
            subplot_dict[key] = ""
    # end if

    # dict_subplot1["data_list"] = [dict_data1, dictr_data2, ...]
    for i,data_dict in enumerate(subplot_dict["data_list"]):
        (status,errtext,subplot_dict["data_list"][i]) = check_dict_data(data_dict,i)
        if status != hdef.OKAY:
            return (status, errtext, subplot_dict)
        # end if
    # end for
    return (status, errtext, subplot_dict)
# end def
def check_dict_data(data_dict,i):

    status = hdef.OKAY
    errtext = ""


    # dict_data1["y"] = np.array([val1, val2, ...])
    key = "y"
    if key not in data_dict:
        status = hdef.NOT_OKAY
        errtext = f"{key} in {i+1}. data set does not exist"
        return (status, errtext, data_dict)
    else:

        if not isinstance(data_dict[key],np.ndarray):
            status = hdef.NOT_OKAY
            errtext = f"{key = } in {i + 1}. dataset ydata is not numpy array"
            return (status, errtext, data_dict)
        else:
            pass
    # end if


    # dict_data1["xdat"] = np.array([secs1, secs2, ...])
    key = "xdat"
    if key not in data_dict:
        data_dict[key] = np.arange(0, len(data_dict["y"] ), 1)
    else:

        if not isinstance(data_dict[key],np.ndarray):
            data_dict[key] = np.arange(0, len(data_dict["y"] ), 1)
        else:
            pass
    # end if

    data_dict["n"] = min(len(data_dict["y"]),len(data_dict["xdat"]))
    np_y_array     =np.resize(data_dict["y"], (1, data_dict["n"]))
    np_y_array     = np_y_array.reshape(np.prod(np_y_array.shape))
    data_dict["y"] = np_y_array

    np_dat_array      = np.resize(data_dict["xdat"], (1, data_dict["n"]))
    np_dat_array      = np_dat_array.reshape(np.prod(np_dat_array.shape))
    data_dict["xdat"] = np_dat_array

    # dict_data1["color"] = 'k', (default, 'b', 'g', 'r', 'c', 'm', 'y', 'k', 'w', ...)
    key = "color"
    if key not in data_dict:
        data_dict["color"] = "k"
    # end if

    # dict_data1["linewidth"] = 1(default)
    key = "linewidth"
    if key not in data_dict:
        data_dict[key] = 1
    else:
        data_dict[key] = int(data_dict[key])
    # end if

    # dict_data1["linestyle"] = '-'(default, '--', '-.', ':', '')
    key = "linestyle"
    if key not in data_dict:
        data_dict[key] = '-'
    else:
        data_dict[key] = str(data_dict[key])
    # end if

    # dict_data1["marker"] = ''(default, '.', 'o', 'd', 'v', '^', '>', '<', ...)
    key = "marker"
    if key not in data_dict:
        data_dict[key] = ''
    else:
        data_dict[key] = str(data_dict[key])
    # end if

    # dict_data1["label"] = 'linex'(default)
    key = "label"
    if key not in data_dict:
        data_dict[key] = f"line_{i}"
    else:
        data_dict[key] = str(data_dict[key])
    # end if

    return (status, errtext, data_dict)
# end def
def build_date_time(data_dict,i):
    """
    (status, errtext, data_dict) = build_date_time(data_dict)
    """
    status = hdef.OKAY
    errtext = ""

    if data_dict["xdat"][0].dtype != np.int64:
        status = hdef.NOT_OKAY
        errtext = f"xdat in {i+1}.data is not atimestamp (np.int54)"
        return (status, errtext, data_dict)
    # end if

    np_date_time_array = data_dict["xdat"].astype('datetime64[s]')
    np_date_time_array = np_date_time_array.reshape(np.prod(np_date_time_array.shape))

    np_date_str_array = np_date_time_array.astype(str)
    np_date_str_array = np_date_str_array.reshape(np.prod(np_date_str_array.shape))

    data_dict["xdate_time"] = np_date_time_array
    data_dict["xdate_str"] = np_date_str_array

    return (status, errtext, data_dict)
# end def