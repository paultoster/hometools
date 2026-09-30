
import os, sys
import numpy as np


t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import wp_screen_gui
import wp_screen_katalog
# import wp_screen_sigset
import wp_screen_plotdef
import wp_screen_scre_build_rawtab
# import wp_screen_scre_build_signal
# import wp_screen_scre_build_fmttab
# import wp_screen_scre

import tools.hfkt_def as hdef
import tools.hfkt_list as hlist
# import tools.sgui as sgui
# import tools.hfkt_tvar as htvar
# import tools.hfkt_type as htype

STATUS   = hdef.OKAY
ERRTEXT  = ""
INFOTEXT = ""


def get_status():
    global STATUS
    return STATUS
def get_errtext():
    global ERRTEXT
    return ERRTEXT
def get_infotext():
    global INFOTEXT
    return INFOTEXT
def reset_status():
    global STATUS
    global ERRTEXT
    global INFOTEXT
    STATUS = hdef.OKAY
    ERRTEXT = ""
    INFOTEXT = ""
# end def

def plot_scre(rd,scre,scre_dict,index):
    """
    (status,errtext) = wp_screen_scre_plot.plot_scre(rd,scre_dict,index)
    """
    global INFOTEXT, STATUS, ERRTEXT

    # isin rauspicken und Daten lesen
    isin_liste  = wp_screen_katalog.get_katalog_isin_liste(rd, scre_dict[rd.par.SCRE_KATALOG])
    isin        = isin_liste[index]

    np_data_obj = wp_screen_scre_build_rawtab.get_np_data_obj(rd, isin)

    if wp_screen_scre_build_rawtab.get_status() != hdef.OKAY:
        STATUS = wp_screen_scre_build_rawtab.get_status()
        ERRTEXT = wp_screen_scre_build_rawtab.get_errtext()
        wp_screen_scre_build_rawtab.reset_status()
        return
    # end if

    # Checken ob ein Plot definiert ist
    if len(scre_dict[rd.par.SCRE_PLOTDEF]) == 0:
        STATUS = hdef.NOT_OKAY
        ERRTEXT = f"plotdef in screen definition {scre} nicht definiert"
        return
    # end if

    plotdef_dict = wp_screen_plotdef.get_plotdef_dict(rd, scre_dict[rd.par.SCRE_PLOTDEF])

    plotdef_werte_dict_list = wp_screen_plotdef.get_plotdef_werte_dict_liste(rd, plotdef_dict)

    if wp_screen_plotdef.get_status() != hdef.OKAY:
        STATUS = wp_screen_plotdef.get_status()
        ERRTEXT = wp_screen_plotdef.get_errtext()
        INFOTEXT = wp_screen_plotdef.get_infotext()
        wp_screen_plotdef.reset_status()
        return
    # end if

    (plotdef_werte_dict_list,max_subplot,nrows) = build_all_diagram_data(rd,
                                                                         plotdef_werte_dict_list,
                                                                         np_data_obj,
                                                                         scre,
                                                                         scre_dict)

    if STATUS != hdef.OKAY:
        return

    fig_dict = build_figure_dictionary(plotdef_werte_dict_list,max_subplot,nrows,isin)


    # Bilde Diagramm
    wp_screen_gui.matplot_date_data(rd.gui, fig_dict)

    return
# end def
def build_all_diagram_data(rd,plotdef_werte_dict_list,np_data_obj,scre,scre_dict):

    global INFOTEXT, STATUS, ERRTEXT

    # proof ob subplot von 1 hochzählt ohne Lücke
    #--------------------------------------------
    # in liste schreiben
    liste = []
    for plotdef_werte_dict in plotdef_werte_dict_list:
        liste.append(plotdef_werte_dict["subplot"])
    # end if

    # liste prüfen und ändern
    liste_out = hlist.recalc_integer_liste(liste)
    max_subplot = max(liste_out)

    # liste zurück schreiben
    for i,plotdef_werte_dict in enumerate(plotdef_werte_dict_list):
        plotdef_werte_dict["subplot"] = liste_out[i]
        plotdef_werte_dict_list[i] = plotdef_werte_dict
    # end for

    # proof if signal available, count number of rows
    nrows = 0
    for i,plotdef_werte_dict in enumerate(plotdef_werte_dict_list):

        type = check_special_line_for_type(rd, np_data_obj, plotdef_werte_dict["signal"])

        if type == rd.par.SIG_TYPE_2PAR_LINGRAD:

            plotdef_werte_dict = build_line_for_lingrad(rd, np_data_obj, plotdef_werte_dict)

        else:

            if not np_data_obj.exist_signal_as_nparray(plotdef_werte_dict["signal"]):
                STATUS = hdef.NOT_OKAY
                ERRTEXT = f"plotdef: screen definition {scre}: in position {i} of plotdef_dict {scre_dict[rd.par.SCRE_PLOTDEF]} is signal: {plotdef_werte_dict['signal']} not available"
                return
            # end if

            plotdef_werte_dict["y"]    = np_data_obj.get_signal(plotdef_werte_dict["signal"])
            plotdef_werte_dict["xdat"] = np_data_obj.Datum
        # end if

        if plotdef_werte_dict["subplot"] > nrows:
            nrows = plotdef_werte_dict["subplot"]
        # end if

        # zurückschreiben
        plotdef_werte_dict_list[i] = plotdef_werte_dict

    # end for

    return (plotdef_werte_dict_list,max_subplot,nrows)
# end def
def check_special_line_for_type(rd,np_data_obj,signalname):

    # LinGrad
    signal_name_n  = signalname + "_" + rd.par.SIG_STORE_LINGRAD_N
    signal_name_y0 = signalname + "_" + rd.par.SIG_STORE_LINGRAD_Y0
    signal_name_y1 = signalname + "_" + rd.par.SIG_STORE_LINGRAD_Y1

    if  np_data_obj.exist_signal_as_nparray(signal_name_n)  and \
        np_data_obj.exist_signal_as_nparray(signal_name_y0) and \
        np_data_obj.exist_signal_as_nparray(signal_name_y1):

        return rd.par.SIG_TYPE_2PAR_LINGRAD
    # end if

    return "None"
# end def
def  build_line_for_lingrad(rd, np_data_obj, plotdef_werte_dict):

    # LinGrad
    signal_name_n  = plotdef_werte_dict["signal"] + "_" + rd.par.SIG_STORE_LINGRAD_N
    signal_name_y0 = plotdef_werte_dict["signal"] + "_" + rd.par.SIG_STORE_LINGRAD_Y0
    signal_name_y1 = plotdef_werte_dict["signal"] + "_" + rd.par.SIG_STORE_LINGRAD_Y1

    np_array_n  = np_data_obj.get_signal(signal_name_n)
    np_array_y0 = np_data_obj.get_signal(signal_name_y0)
    np_array_y1 = np_data_obj.get_signal(signal_name_y1)

    ngradlin = np_array_n[-1]
    y0 = np_array_y0[-1]
    y1 = np_array_y1[-1]

    n = len(np_data_obj.Dataum)
    i0 = max(0,n-ngradlin)
    np_array_xdat = np_data_obj.Dataum[i0:n]
    np_array_y    = np.linspace(start=y0, stop=y1, num=ngradlin)

    plotdef_werte_dict["y"] = np_array_y
    plotdef_werte_dict["xdat"] = np_array_xdat

    return plotdef_werte_dict
# end if
def build_figure_dictionary(plotdef_werte_dict_list,max_subplot,nrows,isin):

    # Build plot-dict
    dict_subplot_liste = []
    for i in range(max_subplot):
        isubplot = i+1
        dict_data_liste = []
        for plotdef_werte_dict in plotdef_werte_dict_list:
            height_rows = 0
            if plotdef_werte_dict["subplot"] == isubplot:
                dict_data = {}
                dict_data["xdat"]      = plotdef_werte_dict["xdat"]
                dict_data["y"]         = plotdef_werte_dict["y"]
                dict_data["color"]     = plotdef_werte_dict["color"]
                dict_data["linewidth"] = plotdef_werte_dict["linewidth"]
                dict_data["linestyle"] = plotdef_werte_dict["linestyle"]
                dict_data["marker"]    = plotdef_werte_dict["marker"]
                dict_data["label"]     = plotdef_werte_dict["plotsignal"]
                dict_data_liste.append(dict_data)

                height_rows = max(height_rows,plotdef_werte_dict["height_rows"])
            # end if
        # end for
        dict_subplot = {}
        dict_subplot["xlabel"]      = "date"
        dict_subplot["ylabel"]      = "€"
        dict_subplot["height_rows"] = height_rows
        dict_subplot["data_list"]   = dict_data_liste
        dict_subplot["legend"]      = "best"
        # dict_subplot["name"]        = "subplot1"(default)
        # dict_subplot["title"]       = "title"
        dict_subplot_liste.append(dict_subplot)
    # end for

    fig_dict = {}
    fig_dict["rows"] = nrows
    fig_dict["sharex"] = True
    fig_dict["title"]  = f"ISIN: {isin}"
    fig_dict["title_add_date_range"] = True
    fig_dict["subplot_list"] = dict_subplot_liste

    return fig_dict
# end def