from tokenize import endpats

import numpy as np
import os,sys
import datetime
import calendar

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
TOP_DEFAULT = 0.85



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
                         ddict["title_add_date_range"] = False (default,True)
                         ddict["subplot_list"] = [dict_subplot1, dict_subplot2, dict_subplot3] Liste von dictionaries

                         dict_plot["height_rows_sum"] errechnet
                         dict_plot["first_date_time"] errechnet
                         dict_plot["last_date_time"] errechnet

                         dict_subplot1["name"]   = "subplot1"  (default)
                         dict_subplot1["title"]   = "title"
                         dict_subplot1["xlabel"]   = "xname""
                         dict_subplot1["ylabel"]   = "yname"
                         dict_subplot1["height_rows"] = 1 (default, Wieviele Reihen im Verhältnis zu den anderen Diagrammen soll es einenehmen, Ganzzahl)
                         dict_subplot1["grid"] = True (default, False)
                         dict_subplot1["legend"] = "upper left","upper center","upper right","center left","center","center right","lower left","lower center","lower right"
                         dict_subplot1["data_list"]   = [dict_data1, dictr_data2, ...]

                         dict_subplot1["first_date_time"] errechnet
                         dict_subplot1["last_date_time"] errechnet

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

    # ddict["title_add_date_range"] = False(default, True)
    key = "title_add_date_range"
    if key not in dict_plot:
        dict_plot[key] = False
    else:
        dict_plot[key] = bool(dict_plot[key])
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
def build_date_time(plot_dict):

    status = hdef.OKAY
    errtext = ""

    plot_dict["first_date_time"] = datetime.datetime
    plot_dict["last_date_time"] = datetime.datetime

    for i, subplot_dict in enumerate(plot_dict["subplot_list"]):

        subplot_dict["first_date_time"] = datetime.datetime
        subplot_dict["last_date_time"] = datetime.datetime

        for j, data_dict in enumerate(subplot_dict["data_list"]):
            # Build date-time for each dataset
            # ---------------------------------
            (status, errtext, data_dict) = build_date_time_data_dict(data_dict, j)
            if status != hdef.OKAY:
                return
            subplot_dict["data_list"][j] = data_dict

            if (j == 0) or (data_dict["first_date_time"] < subplot_dict["first_date_time"]):
                subplot_dict["first_date_time"] = data_dict["first_date_time"]
            # end if
            if (j == 0) or (data_dict["last_date_time"] > subplot_dict["last_date_time"]):
                subplot_dict["last_date_time"] = data_dict["last_date_time"]
            # end if

        # end for
        if (i == 0) or (subplot_dict["first_date_time"] < plot_dict["first_date_time"]):
            plot_dict["first_date_time"] = subplot_dict["first_date_time"]
        # end if
        if (i == 0) or (subplot_dict["last_date_time"] > plot_dict["last_date_time"]):
            plot_dict["last_date_time"] = subplot_dict["last_date_time"]
        # end if

        plot_dict["subplot_list"][i] = subplot_dict
    # end for
    return (status, errtext, plot_dict)
# end def
def build_date_time_data_dict(data_dict,i):
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

    data_dict["first_date_time"] = to_datetime( np_date_time_array[0] )
    data_dict["last_date_time"] = to_datetime( np_date_time_array[-1] )


    return (status, errtext, data_dict)
# end def
def detect_change_date_range(text,first_date_time,last_date_time):
    """
    (status, start_date_time,end_date_time) = detect_change_date_range(text,first_date_time,last_date_time)

    10T                     :       plotte die letzten 10 tage
    2M                      :       plotte die letzten 2 Monate
    2025                    :       plotte das Jahr 2025
    10.2026                 :       plotte das den Monat Okt 2026
    1.10.2026-31.11.2026    :       Plotte den zeitbereich
    1.10.2026-200T          :       Plotte von 1.10.2026 200 Tage
    1.10.2026-2M            :       Plotte von 1.10.2026 2 Monate
    """
    status = hdef.OKAY
    start_date_time = None
    end_date_time = None

    # Split Zeitbereich mit "-"
    liste = text.split("-")
    if len(liste) > 2:
        return (hdef.NOT_OKAY,None,None)
    elif (len(liste) == 2) and (len(liste[0]) == 0):
        liste = liste[1:]
    # end if

    if len(liste) == 1:
        return detect_change_date_range_1item(liste[0],first_date_time,last_date_time)
    else:
        return detect_change_date_range_2item(liste[0],liste[1],first_date_time,last_date_time)
    # end if
# end def
def detect_change_date_range_1item(date_str_range,first_date_time,last_date_time):
    """
    (status, start_date_time,end_date_time) = detect_change_date_range(date_str_range)

    10T                     :       plotte die letzten 10 tage
    2W                      :       plotte die letzten 2 Wochen
    2025                    :       plotte das Jahr 2025
    10.2026                 :       plotte das den Monat Okt 2026
    """

    if len(date_str_range.replace(" ","")) == 0:
        return (hdef.NOT_OKAY,None,None)
    # end if

    # Tage
    days = finde_tage(date_str_range)
    if days is not None:

        start_date_time = last_date_time + datetime.timedelta(days=days * (-1))
        if start_date_time < first_date_time:
            start_date_time = first_date_time
        # end if
        end_date_time = last_date_time
        return (hdef.OKAY, start_date_time, end_date_time)
    # end if

    # Wochen
    weeks = finde_wochen(date_str_range)
    if weeks is not None:

        start_date_time = last_date_time + datetime.timedelta(weeks=weeks*(-1))
        if start_date_time < first_date_time:
            start_date_time = first_date_time
        # end if
        end_date_time = last_date_time
        return (hdef.OKAY, start_date_time, end_date_time)
    # end if

    # Monat.Jahr
    (okay, wert) = htype.type_proof(date_str_range, "month.yearStr")
    if okay == hdef.OKAY:
        liste = wert.split(".")
        month = int(liste[0])
        year = int(liste[1])
        (day0,day1) = calendar.monthrange(year,month)
        start_date_time = datetime.datetime(year, month, day0)
        end_date_time = datetime.datetime(year, month, day1)
        return (hdef.OKAY, start_date_time, end_date_time)
    # end if

    # Jahr
    (okay, wert) = htype.type_proof(date_str_range, "yearStr")
    if okay == hdef.OKAY:
        liste = wert.split(".")
        month = int(liste[0])
        year = int(wert)
        month0,month1 = 1,12
        day0 = 1
        (_,day1) = calendar.monthrange(year,month1)
        start_date_time = datetime.datetime(year, month0, day0)
        end_date_time = datetime.datetime(year, month1, day1)
        return (hdef.OKAY, start_date_time, end_date_time)
    # end if

    return (hdef.OKAY,None,None)
# end def
def finde_tage(date_str_range):
    """
    days = finde_tage(date_str_range)
    """
    iTage = date_str_range.lower().find("t")
    if iTage != -1:

        try:
            days = int(float(date_str_range[0:iTage]))
        except:
            days =  None
        # end try
        return days
    # end if
    return None
# end def
def finde_wochen(date_str_range):
    """
    weeks = finde_wochen(date_str_range)
    """
    iWochen = date_str_range.lower().find("w")
    if iWochen != -1:
        try:
            weeks = int(float(date_str_range[0:iWochen]))
        except:
            weeks = None
        # end try
        return weeks
    # end if
    return None
# end def
def detect_change_date_range_2item(date_str_start,date_str_end_or_range,first_date_time,last_date_time):
    """
    (status, start_date_time,end_date_time) = detect_change_date_range(date_str_start,date_str_end_or_range)

    1.10.2026-31.11.2026    :       Plotte den zeitbereich
    1.10.2026-200T          :       Plotte von 1.10.2026 200 Tage
    1.10.2026-2W            :       Plotte von 1.10.2026 2 Wochen
    """

    # Anfangsdatum
    (status, start_date_time) = htype.type_transform(date_str_start, "datStrP", "datetimeclass")

    if status == hdef.OKAY:

        if start_date_time < first_date_time:
            start_date_time = first_date_time
        # end if

        # Tage
        days = finde_tage(date_str_end_or_range)
        if days is not None:
            end_date_time = start_date_time + datetime.timedelta(days=days)
            if end_date_time > last_date_time:
                end_date_time = last_date_time
            # end if
            return (hdef.OKAY, start_date_time, end_date_time)
        # end if

        # Wochen
        weeks = finde_wochen(date_str_end_or_range)
        if weeks is not None:

            end_date_time = start_date_time + datetime.timedelta(weeks=weeks)
            if end_date_time > last_date_time:
                end_date_time = last_date_time
            # end if
            return (hdef.OKAY, start_date_time, end_date_time)
        # end if

        # Enddatum
        (status, end_date_time) = htype.type_transform(date_str_end_or_range, "datStrP", "datetimeclass")
        if status == hdef.OKAY:
            if end_date_time > last_date_time:
                end_date_time = last_date_time
            # end if
            return (hdef.OKAY, start_date_time, end_date_time)
        # end if
    # end if

    return (hdef.OKAY, None, None)
# end def
def to_datetime(date):
    """
    Converts a numpy datetime64 object to a python datetime object
    Input:
      date - a np.datetime64 object
    Output:
      DATE - a python datetime object
    """
    timestamp = ((date - np.datetime64('1970-01-01T00:00:00'))
                 / np.timedelta64(1, 's'))
    return datetime.datetime.fromtimestamp(timestamp)
# end def
