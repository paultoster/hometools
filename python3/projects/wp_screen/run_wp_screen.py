
import os, sys
from dataclasses import dataclass, field


t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import wp_screen_param
import wp_screen_ini
import wp_screen_gui
import wp_screen_katalog

import wp_abfrage.wp_base as wp_base

import tools.hfkt_def as hdef
import tools.hfkt_log as hlog
import tools.sgui as sgui
import tools.sgui_protocol_class as sgui_prot

@dataclass
class RootData:
    gui = None
    par = None
    log:  hlog.log = field(default_factory=hlog.log)
    ini = None
    wpfunc = None
    kat: dict = field(default_factory=lambda: {
                        "katalog_liste": [],
                        "katalog_liste_filename":"",
                        "katalog_liste_jsonobj": None,
                        "katalog": "",
                        "isin_liste":[],
                        "isin_liste_filename": "",
                        "isin_liste_jsonobj":None
                        })
# end class


def wp_screener(log_filename,ini_filename):
    """

    :param log_filename:
    :param ini_filename:
    :return:
    """
    rd = RootData()

    # gui
    rd.gui = sgui_prot.SguiProtocol()

    # Log-File start ---------------
    rd.log = hlog.log(log_file=log_filename,consol_func=True, log_window=False)
    if (rd.log.state != hdef.OK):
        print("Logfile not working !!!!")
        return
    # endif

    # Parameter
    rd.par = wp_screen_param.Param()

    # ini
    rd.ini = wp_screen_ini.get_ini_dict(ini_filename,rd.par.INI_DICT_PROOF_LISTE)

    if wp_screen_ini.get_status() != hdef.OK:
        rd.log.write_e(wp_screen_ini.get_errtext(), screen=1)
        wp_screen_ini.reset_status()
        return
    # end if

    # wp_abfrage
    rd.wpfunc = wp_base.WPData(ini_filename=rd.ini["wp_func_ini_file_name"],
                                 log_obj=rd.log)

    # run Command
    wp_screener_command(rd)

    return

def wp_screener_command(rd):
    runflag = True

    start_auswahl = ["Ende", "katalog", "signale", "tabelle","screener"]

    index_ende = 0
    index_katalog = 1
    index_signale = 2
    index_tabelle = 3
    index_screener = 4

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
                t = f"Error wp_bearbeiten.edit_basic_info(wp_obj) errtext = {wp_screen_katalog.get_errtext()}"
                sgui.anzeige_text(t, textcolor='red')
                rd.log.write_err(t, screen=rd.par.LOG_SCREEN_OUT)
                runflag = False
            # end if

            wp_screen_katalog.reset_status()

        elif index == index_signale:

            pass

        elif index == index_tabelle:

            pass

        elif index == index_screener:

            pass

        else:
            pass
        # endif
    # end while

    return
# end def
if __name__ == '__main__':
    log_filename = "D:/data/orga/wp_screen/wp_screen.log"
    ini_filename = "D:/data/orga/wp_screen/wp_screen.ini"

    wp_screener(log_filename, ini_filename)