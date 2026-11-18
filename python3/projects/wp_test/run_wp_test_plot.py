import os, sys
import copy

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_list as hlist
import tools.hfkt_io as hio
import tools.hfkt_file_path as hfp
import tools.hfkt_ini as hini
import tools.hfkt_tvar as hfkt_tvar
import tools.sgui as sgui
import tools.hfkt_np_dataclass as hnp_dataclass
import tools.hfkt_def as hdef

import wp_test_def as wpdef

BASE_PATH   = 'D:/data/wp'

def suche_alle_joblib_files(ini):

    # ini['ergebnis_path_pre_name']
    erg_paths = hfp.get_liste_of_subdirs(ini['store_path'])

    liste_joblib_files = []
    simname_list = []
    for erg_path in erg_paths:

        if erg_path.find(ini['ergebnis_path_pre_name']) > -1:

            filename = hfp.set_pfe(erg_path, ini['np_datei_name'], "joblib")
            if os.path.isfile(filename):
                liste_joblib_files.append(filename)
                subpath = hfp.get_last_subdir_name(erg_path)
                simname = subpath.replace(ini['ergebnis_path_pre_name'],"")
                simname_list.append(simname)
            else:
                raise Exception(f"Datei {filename} konnte in {erg_path} nicht gefunden werden.")
            # end if
        # end if
    # end for

    return (simname_list,liste_joblib_files)
# end def
def get_np_arrays(index_liste,liste_joblib_files,simname_list):
    np_data_obj_liste = []

    for i,filename in enumerate(liste_joblib_files):

        if i in index_liste:
            np_data_obj = hnp_dataclass.NpDataHandlingClass(filename)
            np_data_obj.read()
            if np_data_obj.get_status() != hdef.OKAY:
                raise Exception(f"Datei {filename} konnte nicht geladen werden.")
            # end if
            np_dat_array = np_data_obj.get_signal("np_dat_array")
            np_cash_array = np_data_obj.get_signal("np_cash_array")


            np_data_obj2 = hnp_dataclass.NpDataHandlingClass(filename=None,name=simname_list[i])
            np_data_obj2.add_signal(np_dat_array,"np_dat_array")
            np_data_obj2.add_signal(np_cash_array,"np_cash_array")
            np_data_obj_liste.append(np_data_obj2)
    # end for
    return np_data_obj_liste
# end def
def do_plot(np_data_obj_liste):
    cnames = sgui.matplot_get_colors_list(nmax = len(np_data_obj_liste))
    data_dict_list = []
    for i,np_data_obj in  enumerate(np_data_obj_liste):
        B0 = np_data_obj.np_cash_array[0]
        dict_data = {}
        dict_data["xdat"] = np_data_obj.np_dat_array
        dict_data["y"] = (np_data_obj.np_cash_array-B0)/B0 * 100.
        dict_data["color"] = cnames[i]
        dict_data["linewidth"] = 1
        dict_data["linestyle"] = "-"
        dict_data["marker"] = ""
        dict_data["label"] = np_data_obj.get_name()
        data_dict_list.append(dict_data)
    # end for

    dict_subplot1 = {}
    dict_subplot1["name"] = "Cash"
    dict_subplot1["title"] = "Ergebnis in Prozent"
    dict_subplot1["xlabel"] = "Date"
    dict_subplot1["ylabel"] = "%"
    dict_subplot1["legend"] = "best"
    dict_subplot1["data_list"] = data_dict_list

    ddict = {}
    ddict["rows"] = 1
    ddict["cols"] = 1
    ddict["sharex"] = False
    ddict["sharey"] = False
    ddict["width"] = 30
    ddict["height"] = 20
    ddict["title"] = "Relative Delta Cash in Prozent"
    ddict["title_add_date_range"] = True

    ddict["subplot_list"] = [dict_subplot1]

    dict_input = {}
    dict_input["plot"] = ddict
    dict_input["widget"] = False
    dict_input["show"] = True
    # dict_input["plotfile"] = self.PlotProzentFilename

    sgui.matplot_date_data(dict_input)

    return
# end def

def sort_list_dict(list_dict,keyname,aufsteigend=True):

    newlist_dict = hlist.sort_list_of_dict(list_dict, keyname, aufsteigend=int(aufsteigend))

    return newlist_dict
# end if
def run_wp_test_plot(base_path):

    ini_filename = os.path.join(base_path,'wp.ini')

    # ini-Datei lesen
    ini = hini.get_section_of_ini_file(ini_filename, "wp_test", ("@base_path@", base_path), wpdef.INI_DICT_PROOF_LISTE)

    # excel-Filename
    excel_filename = os.path.join(ini["store_path"],'wp_test_zusammenfassung.xlsx')

    # joblib-Files
    (simname_list,liste_joblib_files) = suche_alle_joblib_files(ini)


    # Auswahl
    index_liste = sgui.checkbutton_dialog(simname_list, title="Welche Auswertung soll geplottet werden")



    np_data_obj_liste = get_np_arrays(index_liste,liste_joblib_files,simname_list)

    do_plot(np_data_obj_liste)

    return
# end def