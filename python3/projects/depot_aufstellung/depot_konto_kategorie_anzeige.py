#
# datensatz anzeigen und Kategorien bearbeiten
#
#
#
import os
import sys

import hfkt_tvar
import hfkt_type

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

# Hilfsfunktionen
import tools.hfkt_def as hdef
# import tools.hfkt_date_time as hdate
# import tools.hfkt_str as hstr
import tools.hfkt_tvar as htvar
# import tools.sgui as sgui

import depot_kategorie_auswertung

def anzeige(rd):
    
    
    (tval_min_time,tval_max_time) = get_limits_epocht_time_of_year(rd.ini.dict_tvar[rd.par.INI_KONTO_AUSWERTUNG_JAHR_NAME].val)
    
    if len(rd.ini.ddict[rd.par.INI_KONTO_DATA_LIST_NAMES_NAME]) == 0:
        rd.log.write_err("anzeige  kategorie: kein Konto eingerichtet", screen=rd.par.LOG_SCREEN_OUT)
        return hdef.NOT_OKAY
    # end if
    
    kont_name = rd.ini.ddict[rd.par.INI_KONTO_DATA_LIST_NAMES_NAME][0]
    konto_obj = rd.konto_dict[kont_name].konto_obj
    
    header_list = [konto_obj.par.KONTO_DATA_NAME_BUCHDATUM,
                   konto_obj.par.KONTO_DATA_NAME_WER,
                   konto_obj.par.KONTO_DATA_NAME_WERT,
                   konto_obj.par.KONTO_DATA_NAME_COMMENT,
                   konto_obj.par.KONTO_DATA_NAME_KATEGORIE]
    type_list = ["dat", "str", "cent", "str", "str"]
    
    # Erstelle Auswert Klassenobjekt
    # zur headerlist kommt noch der Kontoname:
    katauswertfunc = depot_kategorie_auswertung.KategorieAuswertungClass(konto_obj.par,
                                                                         header_list + [konto_obj.par.KONTO_NAME],
                                                                         type_list + ["str"],
                                                                         rd.allg.katfunc)
    
    # Loop over each konto
    for kont_name in rd.ini.ddict[rd.par.INI_KONTO_DATA_LIST_NAMES_NAME]:
        
        konto_obj = rd.konto_dict[kont_name].konto_obj
        
        ttable = konto_obj.get_timedepend_data_set_dict_ttable(header_list, type_list,
                                                               tval_min_time, tval_max_time,
                                                               with_start=False)
        
        if konto_obj.status != hdef.OKAY:
            rd.log.write_err("anzeige  kategorie " + konto_obj.errtext, screen=rd.par.LOG_SCREEN_OUT)
            return konto_obj.status
        # end if
        
        
    
    # end for
    

    status = hdef.OKAY
    
    return status
# end def
def get_limits_epocht_time_of_year(str_year):
    '''
    
    :param str_jear:
    :return: (min_epoch_time, max_epoch_time) = get_limits_epocht_time_of_year(str_year)
    '''
    
    str_year_next = str(int(str_year) + 1)
    
    (okay,wert) = hfkt_type.type_transform_yearStr(str_year,"dat")
    
    if okay != hdef.OKAY:
        raise Exception(f"get_limits_epocht_time_of_year: {str_year = } kann nicht in epochaler Zeit gewandelt werten")
    # end if
    tval_min_epoch_time = htvar.build_val("min_epoch_time",wert,"dat")
    
    (okay,wert) = hfkt_type.type_transform_yearStr(str_year_next,"dat")
    if okay != hdef.OKAY:
        raise Exception(f"get_limits_epocht_time_of_year: {str_year_next = } kann nicht in epochaler Zeit gewandelt werten")
    # end if
    tval_max_epoch_time = htvar.build_val("max_epoch_time", wert, "dat")
    
    return (tval_min_epoch_time, tval_max_epoch_time)
# end def
