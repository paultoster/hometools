
import os, sys


t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import wp_screen_gui
import wp_screen_katalog
import wp_screen_sigset
import wp_screen_tab
import wp_screen_scre
import wp_screen_base
import wp_screen_plotdef



import tools.hfkt_def as hdef
import tools.sgui as sgui


def wp_screener_command(rd):
    runflag = True

    start_auswahl = ["Ende", "katalog", "sigset", "tabelle","plotdef","screener","update wps"]

    index_ende = 0
    index_katalog = 1
    index_sigset = 2
    index_tabelle = 3
    index_plot = 4
    index_screener = 5
    index_update_wps = 6

    abfrage_liste = ["okay", "cancel", "ende"]
    #i_abfrage_okay = 0
    i_abfrage_cancel = 1
    i_abfrage_ende = 2

    while (runflag):

        (index, indexAbfrage) = wp_screen_gui.listen_abfrage(rd.gui,
                                                         start_auswahl,
                                                         "Startauswahl",
                                                         abfrage_liste)

        if indexAbfrage < 0:
            index = -1
        elif indexAbfrage == i_abfrage_cancel:
            index = index_ende
        elif indexAbfrage == i_abfrage_ende:
            index = index_ende

        if (index < 0) or (index == index_ende):  # cancel button
            runflag = False
        elif index == index_katalog:

            wp_screen_katalog.katalog_start(rd)

            if len(wp_screen_katalog.get_infotext()) > 0:
                t = f"Info wp_katalog.katalog(rd): {wp_screen_katalog.get_infotext()}"
                sgui.anzeige_text(t, textcolor='orange')
                rd.log.write_info(t, screen=rd.par.LOG_SCREEN_OUT)

            if wp_screen_katalog.get_status() != hdef.OKAY:
                t = f"Error wp_katalog.katalog(rd) errtext = {wp_screen_katalog.get_errtext()}"
                sgui.anzeige_text(t, textcolor='red')
                rd.log.write_err(t, screen=rd.par.LOG_SCREEN_OUT)
                runflag = False
            # end if

            wp_screen_katalog.reset_status()

        elif index == index_sigset:  #

            wp_screen_sigset.sigset_start(rd)

            if len(wp_screen_sigset.get_infotext()) > 0:
                t = f"Info wp_sigset.sigset_start(rd): {wp_screen_sigset.get_infotext()}"
                sgui.anzeige_text(t, textcolor='orange')
                rd.log.write_info(t, screen=rd.par.LOG_SCREEN_OUT)

            if wp_screen_sigset.get_status() != hdef.OKAY:
                t = f"Error wp_sigset.sigset_start(rd) errtext = {wp_screen_sigset.get_errtext()}"
                sgui.anzeige_text(t, textcolor='red')
                rd.log.write_err(t, screen=rd.par.LOG_SCREEN_OUT)
                runflag = False
            # end if

            wp_screen_sigset.reset_status()

        elif index == index_tabelle:

            wp_screen_tab.tab_start(rd)

            if len(wp_screen_tab.get_infotext()) > 0:
                t = f"Info wp_tab.tab_start(rd): {wp_screen_tab.get_infotext()}"
                sgui.anzeige_text(t, textcolor='orange')
                rd.log.write_info(t, screen=rd.par.LOG_SCREEN_OUT)

            if wp_screen_tab.get_status() != hdef.OKAY:
                t = f"Error wp_tab.tab_start(rd) errtext = {wp_screen_tab.get_errtext()}"
                sgui.anzeige_text(t, textcolor='red')
                rd.log.write_err(t, screen=rd.par.LOG_SCREEN_OUT)
                runflag = False
            # end if

            wp_screen_tab.reset_status()

        elif index == index_plot:

            wp_screen_plotdef.plotdef_start(rd)

            if len(wp_screen_plotdef.get_infotext()) > 0:
                t = f"Info wp_screen_plotdef.plotdef_start(rd): {wp_screen_plotdef.get_infotext()}"

                sgui.anzeige_text(t, textcolor='orange')

                rd.log.write_info(t, screen=rd.par.LOG_SCREEN_OUT)

            if wp_screen_plotdef.get_status() != hdef.OKAY:
                t = f"Error wp_screen_plotdef.plotdef_start(rd) errtext = {wp_screen_plotdef.get_errtext()}"

                sgui.anzeige_text(t, textcolor='red')

                rd.log.write_err(t, screen=rd.par.LOG_SCREEN_OUT)

                runflag = False

            # end if


            wp_screen_plotdef.reset_status()

        elif index == index_screener:

            wp_screen_scre.scre_start(rd)

            if len(wp_screen_scre.get_infotext()) > 0:
                t = f"Info wp_scre.scre_start(rd): {wp_screen_scre.get_infotext()}"
                sgui.anzeige_text(t, textcolor='orange')
                rd.log.write_info(t, screen=rd.par.LOG_SCREEN_OUT)

            if wp_screen_scre.get_status() != hdef.OKAY:
                t = f"Error wp_scre.scre_start(rd) errtext = {wp_screen_scre.get_errtext()}"
                sgui.anzeige_text(t, textcolor='red')
                rd.log.write_err(t, screen=rd.par.LOG_SCREEN_OUT)
                runflag = False
            # end if

            wp_screen_scre.reset_status()

        elif index == index_update_wps:

            (status, errtext, infotext) = rd.wpfunc.update_indices()

            if len(infotext):
                t = f"Info wb_obj.update_indices() \n infotext = {infotext}"
                sgui.anzeige_text(t, textcolor='green')
                rd.log.write_info(t)
                infotext = ""
            # end if

            if status != hdef.OKAY:
                t = f"Error wb_obj.update_indices() \n errtext = {errtext}"
                sgui.anzeige_text(t, textcolor='red')
                rd.log.write_err(t)
                runflag = False
            # end if

            (status, errtext, infotext) = rd.wpfunc.update_price_volume()

            if len(infotext):
                t = f"Info wb_obj.update_price_volume() \n infotext = {infotext}"
                sgui.anzeige_text(t, textcolor='green')
                rd.log.write_info(t)
                infotext = ""
            # end if

            if status != hdef.OKAY:
                t = f"Error wb_obj.update_price_volume() \n errtext = {errtext}"
                sgui.anzeige_text(t, textcolor='red')
                rd.log.write_err(t)
                runflag = False
            # end if

        else:
            pass
        # endif
    # end while

    return
# end def
if __name__ == '__main__':
    ini_filename = "D:/data/wp/wp_screen/wp_screen.ini"

    rd = wp_screen_base.WPScreen(ini_filename)

    # run Command
    wp_screener_command(rd)


