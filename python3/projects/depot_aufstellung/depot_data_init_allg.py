# import copy
import os, sys
from dataclasses import dataclass, field

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# # endif

# Hilfsfunktionen
import tools.hfkt_def as hdef
# import tools.hfkt_type as htype
import tools.hfkt_pickle as hpickle
# import tools.hfkt_tvar as htvar


import wp_abfrage.wp_base as wp_base
import bank_name_bestimmen.blz_class as blz_class


# import depot_iban_data_class
# import depot_konto_data_set_class
# import depot_konto_csv_read_class
# import depot_depot_data_set_class
import depot_data_class_defs
import depot_kategorie_class

@dataclass
class AllgData:
    pickle_obj = None
    data_dict: dict = field(default_factory=dict)
    idfunc = None   # : dclassdef.IDCount = field(default_factory=dclassdef.IDCount)
    wpfunc = None   # : wp_base.WPData = field(default_factory=wp_base.WPData)
    banknamefunc = None
    kat_json_obj = None
    katfunc = None  # konto kategorie
    kat_dict: dict = field(default_factory=dict)


def read(rd):
    """
    
    :param rd:  rd-struktur
    :return: (allg,status,errtext) = depot_data_init_allg.data_read(rd)
    : ouput  allg  allg-struktur
    
    """
    status  = hdef.OK
    errtext = ""
    allg    = AllgData()
    
    if rd.par.ALLG_DATA_NAME in rd.ini.ddict[rd.par.INI_DATA_PICKLE_JSONFILE_LIST]:
        use_json = rd.ini.ddict[rd.par.INI_DATA_PICKLE_USE_JSON]
    else:
        use_json = 0
    # end if
    
    make_backup = rd.ini.ddict[rd.par.INI_DATA_PICKLE_MAKE_BACKUP]
    path_backup = rd.ini.ddict[rd.par.INI_BACKUP_PATH]
    
    # pickle object
    allg.pickle_obj = hpickle.DataPickle(rd.par.ALLG_PREFIX_NAME,
                                            rd.par.ALLG_DATA_NAME,
                                            use_json,
                                            make_backup,
                                            path_backup)
    
    if (allg.pickle_obj.status != hdef.OK):
        status = hdef.NOT_OKAY
        errtext = allg.pickle_obj.errtext
        return (allg,status, errtext)
    # endif
    
    allg.data_dict = allg.pickle_obj.get_ddict()
    
    # class id anlegen
    # -----------------
    if rd.par.ID_MAX_NAME in allg.data_dict:
        idmax = allg.data_dict[rd.par.ID_MAX_NAME]
    else:
        idmax = 0
    # end if
    
    allg.idfunc = depot_data_class_defs.IDCount()
    allg.idfunc.set_act_id(idmax)
    
    # function wp-data anlgene
    # -------------------------
    # wp funktion wert papier rd.ini.ddict["wp_abfrage"]["store_path"]
    allg.wpfunc = wp_base.WPData(rd.ini.ddict[rd.par.INI_WP_FUNC_INI_FILE_NAME])
    
    if (allg.wpfunc.status != hdef.OK):
        status = hdef.NOT_OKAY
        errtext = allg.wpfunc.errtext
        return (allg,status, errtext)
    # endif
    
    # function Banknamen bestimmen
    # -------------------------
    allg.banknamefunc = blz_class.Bankdaten()
    
    # konto_kategorie func if filename is set
    # ----------------------------------------
    if os.path.isfile(rd.ini.ddict[rd.par.INI_KONTO_KAT_JSON_FILE_NAME]):
        
        allg.kat_json_obj = hpickle.DataJson(rd.ini.ddict[rd.par.INI_KONTO_KAT_JSON_FILE_NAME])
        
        if rd.ini.ddict[rd.par.INI_DATA_PICKLE_MAKE_BACKUP]:
            path_backup = rd.ini.ddict[rd.par.INI_BACKUP_PATH]
            allg.kat_json_obj.make_backup(path_backup)
        
        allg.kat_json_obj.read()
        if allg.kat_json_obj.status != hdef.OKAY:
            status = hdef.NOT_OKAY
            errtext = allg.kat_json_obj.errtext
            return (status, errtext)
        # end if
        allg.kat_dict = allg.kat_json_obj.get_data()
        
        for key in [rd.par.KONTO_KAT_LIST_NAME, rd.par.KONTO_KAT_REGEL_LIST_NAME]:
            if key not in allg.kat_dict.keys():
                status = hdef.NOT_OKAY
                errtext = f"In json-File \"{allg.kat_json_obj.get_filename()}\" kein dict[\"{key}\"] vorhanden"
                return (status, errtext)
            # end if
        # end for
        
        if rd.par.KONTO_TAUSCH_DICT_NAME not in allg.kat_dict.keys():
            allg.kat_dict[rd.par.KONTO_TAUSCH_DICT_NAME] = {}
        # end if
        
        if rd.par.KONTO_GRUPPEN_ZUSAMMENFASSUNG_DICT_NAME not in allg.kat_dict.keys():
            allg.kat_dict[rd.par.KONTO_GRUPPEN_ZUSAMMENFASSUNG_DICT_NAME] = {}
        # end if
        
        allg.katfunc = depot_kategorie_class.KategorieClass(
            allg.kat_dict[rd.par.KONTO_KAT_LIST_NAME],
            allg.kat_dict[rd.par.KONTO_KAT_REGEL_LIST_NAME],
            allg.kat_dict[rd.par.KONTO_TAUSCH_DICT_NAME],
            allg.kat_dict[rd.par.KONTO_GRUPPEN_ZUSAMMENFASSUNG_DICT_NAME])
        
        if allg.katfunc.status != hdef.OKAY:
            status = hdef.NOT_OKAY
            errtext = allg.katfunc.errtext
            allg.katfunc.reset_status()
            return (status, errtext)
        # end if
    else:
        allg.kat_dict = {}
        allg.katfunc = None
    # end if
    
    return (allg,status,errtext)
# end def
def save(rd):
    """
    #     rd.allg.pickle_obj
    #     rd.allg.data_dict
    #     rd.allg.idfunc
    #     rd.allg.wpfunc
    #     rd.allg.katfunc
    
    save rd.allg.pickle_obj with rd.allg.data_dict
    save kat_json_obj with rd.allg.kat_dict
    
    :param rd:
    :return: (status,errtext) = depot_data_init_allg.save(rd)
    """
    status = hdef.OKAY
    errtext = ""
    
    rd.allg.data_dict[rd.par.ID_MAX_NAME] = rd.allg.idfunc.get_act_id()
    # rd.allg.pickle_obj.set_ddict(rd.allg.data_dict)
    
    # save
    # -----
    rd.allg.pickle_obj.save(rd.allg.data_dict)
    
    if (rd.allg.pickle_obj.status != hdef.OKAY):
        status = hdef.NOT_OKAY
        errtext = f"{errtext}/ allg: {rd.allg.pickle_obj.errtext}"
    # endif
    
    # Kategorie
    if rd.allg.katfunc is not None:
        
        rd.allg.kat_dict[rd.par.KONTO_TAUSCH_DICT_NAME] = {}
        rd.allg.kat_dict[rd.par.KONTO_KAT_LIST_NAME] = rd.allg.katfunc.get_kat_dict_list()
        rd.allg.kat_dict[rd.par.KONTO_KAT_REGEL_LIST_NAME] = rd.allg.katfunc.get_regel_list()
        
        # save
        #-----
        rd.allg.kat_json_obj.save(rd.allg.kat_dict)
        
        if rd.allg.kat_json_obj.status != hdef.OKAY:
            status = hdef.NOT_OKAY
            errtext = f"{errtext}/ allg: {rd.allg.kat_json_obj.errtext}"
        # end if
    # end if
    
    return (status,errtext)
# end def