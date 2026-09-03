import pandas as pd
import numpy as np
import datetime
import os,sys
import matplotlib.pyplot as plt
from matplotlib.dates import AutoDateLocator, DateFormatter, AutoDateFormatter, date2num
import copy

t_path, _ = os.path.split(__file__)
if( t_path == os.getcwd() ):

  import hfkt_type as htype
  import hfkt_def  as hdef
  import hfkt_np_fkt  as hnp_fkt
  import sgui_matplot_date_data_fkt as matplot_fkt
else:
  p_list     = os.path.normpath(t_path).split(os.sep)
  if( len(p_list) > 1 ): p_list = p_list[ : -1]
  t_path = ""
  for i,item in enumerate(p_list): t_path += item + os.sep
  if( os.path.normpath(t_path) not in sys.path ): sys.path.append(t_path)

  from tools import hfkt_type as htype
  from tools import hfkt_def  as hdef
  from tools import hfkt_np_fkt as hnp_fkt
  from tools import sgui_matplot_date_data_fkt as matplot_fkt
#endif--------------------------------------------------------------------------

class maplot_date_plot:
    """
    Plotten eine Diagramms mit mehreren zeitreihen


    dict_input["plot"] = ddict["rows"] = 1  (defaultwert, Anzahl der senkrechten Plots)
                         ddict["cols"] = 1  (defaultwert, Anzahl der waagrechten Plots)
                         ddict["sharex"] = False  (defaultwert, True, 'col', Für alle eine x-Achse)
                         ddict["sharey"] = False  (defaultwert, True, 'row', Für alle eine y-Achse)
                         ddict["width"] = 30 (default, Plot Breite in cm)
                         ddict["height"] = 30 (default, Plot Breite in cm)
                         ddict["subplot_list"] = [dict_subplot1, dict_subplot2, dict_subplot3] Liste von dictionaries

                         dict_subplot1["name"]   = "subplot1"  (default)
                         dict_subplot1["title"]   = "title"
                         dict_subplot1["xlabel"]   = "xname""
                         dict_subplot1["ylabel"]   = "yname"
                         dict_subplot1["height_rows"] = 1 (default, Wieviele Reihen im Verhältnis zu den anderen Diagrammen soll es einenehmen, Ganzzahl)
                         dict_subplot1["data_list"]   = [dict_data1, dictr_data2, ...]

                         dict_data1["xdat"] = np.array([secs1,secs2, ...])
                         dict_data1["y"]   = np.array([val1,val2, ...])
                         dict_data1["color"]   = 'k', (default,'b', 'g', 'r', 'c', 'm', 'y', 'k', 'w', ...)
                         dict_data1["linewidth"]    = 1 (default)
                         dict_data1["linestyle"]    = '-' (default, '--', '-.', ':', '')
                         dict_data1["marker"]    = '' (default, '.', 'o', 'd', 'v', '^', '>', '<', ...)

    """

    def __init__(self, dict_inp):
        """
        """
        self.status = hdef.OKAY
        self.errtext = ""

        # Check dictionary plot from input
        #---------------------------------
        (self.status,self.errtext,self.plot_dict) = matplot_fkt.check_dict_plot(dict_input["plot"])
        if self.status != hdef.OKAY:
            return


        # Build date-time
        for i, subplot_dict in enumerate(self.plot_dict["subplot_list"]):

            for j,data_dict in enumerate(subplot_dict["data_list"]):
                # Build date-time for each dataset
                # ---------------------------------
                (self.status, self.errtext, data_dict) = matplot_fkt.build_date_time(data_dict,j)
                if self.status != hdef.OKAY:
                    return
                subplot_dict["data_list"][j] = data_dict
            # end for

            self.plot_dict["subplot_list"][i] = subplot_dict
        # end for


        # Figure setting
        fig = plt.figure(figsize=(self.plot_dict["width"] , self.plot_dict["height"] ), facecolor='lightblue')

        gs = fig.add_gridspec(nrows=self.plot_dict["height_rows_sum"],ncols=1,
                              hspace=self.plot_dict["hspace"],wspace=self.plot_dict["wspace"],
                              left=self.plot_dict["left"],right=self.plot_dict["right"],
                              top=self.plot_dict["top"],bottom=self.plot_dict["bottom"])

        if len(self.plot_dict["title"]):
            fig.suptitle(self.plot_dict["title"], fontsize=16)

        # locator = AutoDateLocator()
        irow0 = 0
        irow1 = 0
        for i,subplot_dict in enumerate(self.plot_dict["subplot_list"]):
            irow1 += subplot_dict["height_rows"]
            ax = fig.add_subplot(gs[irow0:irow1,:])
            irow0 += subplot_dict["height_rows"]
            irow1 = irow0

            # subplot_dict["ax"].xaxis.set_major_locator(locator)
            # subplot_dict["ax"].xaxis.set_major_formatter(AutoDateFormatter(locator))

            # Plotting
            for j, data_dict in enumerate(subplot_dict["data_list"]):

                # ax.plot(data_dict["xdat"], data_dict["y"], linestyle='solid', color='black',marker="o")
                ax.plot(data_dict["xdate_str"],
                        data_dict["y"],
                        linestyle=data_dict["linestyle"],
                        marker=data_dict["marker"],
                        linewidth=data_dict["linewidth"],
                        color=data_dict["color"],
                        label=data_dict["label"])


            # end for
            ax.grid(subplot_dict["grid"])
            ax.xaxis.set_major_locator(plt.MaxNLocator(20))
            ax.xaxis.set_major_formatter(DateFormatter('%d.%m.%Y'))

            if len(subplot_dict["title"]):
                ax.set_title(subplot_dict["title"])
            if len(subplot_dict["xlabel"]):
                ax.set_xlabel(subplot_dict["xlabel"])
            if len(subplot_dict["ylabel"]):
                ax.set_ylabel(subplot_dict["ylabel"])
            if len(subplot_dict["legend"]):
                ax.legend(loc=subplot_dict["legend"])

            subplot_dict["ax"] = ax
            self.plot_dict["subplot_list"][i] = subplot_dict
        # end for

        try:
            fig.autofmt_xdate()  # Datum drehen/ausrichten
        except:
            pass


    def run(self):
        plt.show()


###########################################################################
# testen mit main
###########################################################################
if __name__ == '__main__':

    df = pd.read_csv("wp_price_volume_data_DE0007164600.csv",parse_dates=["Date"],sep=';')
    print(df.head())

    liste = df['Date'].to_list()
    date_str_liste =[datetime.datetime.strptime(htype.type_transform_direct(s,"datStr","datStrP"), "%d.%m.%Y") for s in liste]
    np_dat_array = hnp_fkt.transform_date_time_liste_in_np_dat_array_d(date_str_liste)
    np_open_array = df['Open'].to_numpy()
    np_high_array = df['High'].to_numpy()
    np_low_array = df['Low'].to_numpy()
    np_close_array = df['Close'].to_numpy()
    np_volume_array = df['Volume'].to_numpy()

    n=int(len(np_dat_array)/10)
    np_dat_array = np_dat_array[0:n]
    np_open_array = np_open_array[0:n]
    np_high_array = np_high_array[0:n]
    np_low_array = np_low_array[0:n]
    np_close_array = np_close_array[0:n]
    np_volume_array = np_volume_array[0:n]

    np_dat_array   = np_dat_array.reshape(np.prod(np_dat_array.shape))
    np_open_array   = np_open_array.reshape(np.prod(np_open_array.shape))
    np_high_array   = np_high_array.reshape(np.prod(np_high_array.shape))
    np_low_array   = np_low_array.reshape(np.prod(np_low_array.shape))
    np_close_array   = np_close_array.reshape(np.prod(np_close_array.shape))
    np_volume_array   = np_volume_array.reshape(np.prod(np_volume_array.shape))

    # fig = plt.figure(figsize=(11, 8), facecolor='lightblue')
    # gs = fig.add_gridspec(nrows=1, ncols=1)
    # ax = fig.add_subplot(gs[0:1, :])
    # ax.plot(np_dat_array, np_close_array, linestyle='solid', color='red')
    # plt.show()


    dict_data1 = {}
    dict_data1["xdat"] = np_dat_array
    dict_data1["y"] = np_close_array
    dict_data1["color"] = "k"
    dict_data1["linewidth"] = 1
    dict_data1["linestyle"] = "-"
    dict_data1["marker"] = "o"
    dict_data1["label"] = "closing"

    dict_data2 = {}
    dict_data2["xdat"] = np_dat_array
    dict_data2["y"] = np_open_array
    dict_data2["color"] = "b"
    dict_data2["linewidth"] = 2
    dict_data2["linestyle"] = "--"
    dict_data2["marker"] = ""
    dict_data2["label"] = "open"

    dict_subplot1 = {}
    dict_subplot1["name"] = "WP"
    dict_subplot1["title"] = "Zeigt den Kurs"
    dict_subplot1["xlabel"] = "Date"
    dict_subplot1["ylabel"] = "€"
    dict_subplot1["height_rows"] = 3
    dict_subplot1["legend"] = "best"
    dict_subplot1["data_list"] = [dict_data1,dict_data2]

    dict_data1 = {}
    dict_data1["xdat"] = np_dat_array
    dict_data1["y"] = np_high_array
    dict_data1["color"] = "r"
    dict_data1["linewidth"] = 1
    dict_data1["linestyle"] = "-"
    dict_data1["marker"] = ""
    dict_data1["label"] = "high"

    dict_subplot2 = {}
    dict_subplot2["name"] = "WP"
    dict_subplot2["title"] = "Zeigt den Kurs"
    dict_subplot2["xlabel"] = "Date"
    dict_subplot2["ylabel"] = "€"
    dict_subplot2["height_rows"] = 1
    dict_subplot2["data_list"] = [dict_data1]

    ddict = {}
    ddict["rows"] = 1
    ddict["cols"] = 1
    ddict["sharex"] = False
    ddict["sharey"] = False
    ddict["width"] = 30
    ddict["height"] = 20
    ddict["title"] = "Gesamtplot"
    ddict["subplot_list"] = [dict_subplot1,dict_subplot2]

    dict_input = {}
    dict_input["plot"] = ddict



    obj = maplot_date_plot(dict_input)
    obj.run()

    exit(0)