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

import wp_test_def as wpdef

ini_filename   = 'D:/data/wp/wp_test/wp_test.ini'
excel_filename = 'D:/data/wp/wp_test/wp_test_zusammenfassung.xlsx'

def suche_alle_yamls_files(ini):

    # ini['ergebnis_path_pre_name']
    erg_paths = hfp.get_liste_of_subdirs(ini['store_path'])

    liste_json_files = []
    for erg_path in erg_paths:

        if erg_path.find(ini['ergebnis_path_pre_name']) > -1:

            filename = hfp.set_pfe(erg_path, ini['single_datei_name'], "json")
            if os.path.isfile(filename):
                liste_json_files.append(filename)
            else:
                raise Exception(f"Datei {filename} konnte in {erg_path} nicht gefunden werden.")
            # end if
        # end if
    # end for

    return liste_json_files
# end def
def read_all_jsons(liste_json_files):

    list_dict = []
    for filename in liste_json_files:

        jsonobj = hio.DataJson(filename)

        ddict = jsonobj.read_and_get_data()
        list_dict.append(ddict)
    # end for
    return list_dict
# end def
def sort_list_dict(list_dict,keyname,aufsteigend=True):

    newlist_dict = hlist.sort_list_of_dict(list_dict, keyname, aufsteigend=int(aufsteigend))

    return newlist_dict
# end if

def bilde_tabelle(list_dict,liste_json_files):

    lliste = [("sim_name","str","str"),
             ("ziel_value","float","float"),
             ("mean_zins","float","percentStr"),
             ("median_zins","float","percentStr"),
             ("gesamt_rel_delta_cash","float","percentStr"),
             ("gesamt_rel_delta_cash_pyear","float","percentStr","0"),
             ("gesamt_rel_steuer","float","percentStr"),
             ("gesamt_rel_kosten","float","percentStr"),
             ("mean_std","float","percentStr"),
             ("mean_neg_std","float","percentStr"),
             ("mean_diff_min","float","percentStr"),
             ("mean_diff_max","float","percentStr"),
             ("relvk_mean","float","percentStr"),
             ("relvkmax_mean","float","percentStr"),
             ("anzahl_deals_gesamt","int","int"),
             ("tage_gesamt","int","int","0"),
             ("start_dat_str", "str", "str","-"),
             ("end_dat_str", "str", "str", "-"),
             ("dyears", "float", "floatStr", "0"),
              ]
    data_table = [None]*len(list_dict)
    headers = []
    types = []
    types_store = []
    for liste in lliste:

        if len(liste) == 3:
            (name, type,type_store) = liste
            default = None
        else:
            (name, type, type_store,default) = liste

        headers.append(name)
        types.append(type)
        types_store.append(type_store)


        for i,ddict in enumerate(list_dict):

            data_set = data_table[i]
            if name in ddict.keys():
                if data_set is None:
                    data_set = [ddict[name]]
                else:
                    data_set.append(ddict[name])
                # end if
            elif default is not None:
                if data_set is None:
                    data_set = [default]
                else:
                    data_set.append(default)
                # end if

            else:
                raise Exception(f"Datei {liste_json_files[i]} kann der Name {name} nicht gefunden werden.")
            # end if

            data_table[i] = data_set

        # end ofr
    # end dofr

    ttable = hfkt_tvar.build_table(headers, data_table, types, types_store)



    return ttable

# ini-Datei lesen
ini = hini.get_tomlib_ini_dict(ini_filename, wpdef.INI_DICT_PROOF_LISTE)

# json-Files
liste_json_files = suche_alle_yamls_files(ini)
# liste mit dictionaries
list_dict = read_all_jsons(liste_json_files)
# Sortiere liste:
list_dict = sort_list_dict(list_dict,"ziel_value",True)
# Bilde eine Tabelle
ttable = bilde_tabelle(list_dict,liste_json_files)

ddict_inp = {"ttable": ttable}
ddict_inp["title"] = 'Zusammengefasste Ergenisse'
ddict_inp["abfrage_liste"] = ["okay","excel"]
ddict_out = sgui.abfrage_sheet(ddict_inp)

if ddict_out["index_abfrage"] == 1:
    status = hfkt_tvar.write_table_to_excel(ttable, excel_filename)
    os.startfile(excel_filename)

