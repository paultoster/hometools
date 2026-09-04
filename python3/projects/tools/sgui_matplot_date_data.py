import pandas as pd
import numpy as np
import datetime
import os,sys
import matplotlib.pyplot as plt
# from matplotlib.dates import DateFormatter, AutoDateFormatter, date2num
from matplotlib.dates import DateFormatter,DayLocator
from matplotlib.widgets import TextBox
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
                         ddict["hspace"] = 0.05 Anteil Zwischenraum höhe
                         ddict["wspace"] = 0.05 Anteil Zwischenraum breite
                         ddict["left"] = 0.05 in Anteilen linke Position Diagramm
                         ddict["right"] = 0.95
                         ddict["top"] = 0.9
                         ddict["bottom"] = 0.1
                         ddict["title"] = text
                         ddict["subplot_list"] = [dict_subplot1, dict_subplot2, dict_subplot3] Liste von dictionaries

                         dict_plot["height_rows_sum"] errechnet
                         dict_plot["first_date_time"]
                         dict_plot["last_date_time"]

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
        (self.status,self.errtext,self.plot_dict) = matplot_fkt.build_date_time(self.plot_dict)
        if self.status != hdef.OKAY:
            return



        # Figure setting
        fig = plt.figure(figsize=(self.plot_dict["width"] , self.plot_dict["height"] ), facecolor='lightblue')


        gs = fig.add_gridspec(nrows=self.plot_dict["height_rows_sum"],ncols=1,
                              hspace=self.plot_dict["hspace"],wspace=self.plot_dict["wspace"],
                              left=self.plot_dict["left"],right=self.plot_dict["right"],
                              top=self.plot_dict["top"],bottom=self.plot_dict["bottom"])

        if len(self.plot_dict["title"]):
            tt = self.plot_dict["title"]
            if self.plot_dict["title_add_date_range"]:
                tt += f" ({self.plot_dict["first_date_time"].strftime("%d.%m.%Y")}-{self.plot_dict["last_date_time"].strftime("%d.%m.%Y")})"
            # end if

            fig.suptitle(tt, fontsize=16)


        # locator = AutoDateLocator()
        irow0 = 0
        irow1 = 0
        for i,subplot_dict in enumerate(self.plot_dict["subplot_list"]):
            irow1 += subplot_dict["height_rows"]
            ax = fig.add_subplot(gs[irow0:irow1,:])
            irow0 += subplot_dict["height_rows"]
            irow1 = irow0

            #ax.xaxis.set_major_formatter(DateFormatter('%d.%m.%Y'))
            #ax.xaxis.set_major_locator(DayLocator(interval=5))

            # Plotting
            for j, data_dict in enumerate(subplot_dict["data_list"]):


                #xarray = pd.to_datetime(data_dict["xdate_str"]).strftime('%d.%m.%Y')

                # ax.plot(data_dict["xdat"], data_dict["y"], linestyle='solid', color='black',marker="o")
                ax.plot(data_dict["xdate_time"],                         # data_dict["xdate_str"],
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

        # Textbox
        self.axtextbox = fig.add_axes([0.2, 0.9, 0.6, 0.05])
        self.textbox = TextBox(self.axtextbox,'Datum',initial='Test')
        self.textbox.on_submit(self.callback_change)



    def callback_change(self,event):

        (status,start_date_time,end_date_time) = matplot_fkt.detect_change_date_range(event,
                                                                                      self.plot_dict["first_date_time"],
                                                                                      self.plot_dict["last_date_time"])

        if status == hdef.OKAY:

            start_date_time_np = np.datetime64(start_date_time).astype('datetime64[s]')
            end_date_time_np = np.datetime64(end_date_time).astype('datetime64[s]')

            for subplot_dict in self.plot_dict["subplot_list"]:
                subplot_dict["ax"].set_xlim(start_date_time_np,end_date_time_np)
            # end for
            plt.draw()

        elif len(event) == 0:
            for subplot_dict in self.plot_dict["subplot_list"]:
                subplot_dict["ax"].relim()
                subplot_dict["ax"].autoscale()
            # end for
            plt.draw()
        # end if
        return
    # end def
    def run(self):
        plt.show()
    # end def

###########################################################################
# testen mit main
###########################################################################
if __name__ == '__main__':

    df = pd.read_csv("wp_price_volume_data_DE0007164600.csv",parse_dates=["Date"],sep=';')
    print(df.head())
    print(df.tail())

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
    ddict["title_add_date_range"] = True

    ddict["subplot_list"] = [dict_subplot1,dict_subplot2]

    dict_input = {}
    dict_input["plot"] = ddict



    obj = maplot_date_plot(dict_input)
    obj.run()

    exit(0)