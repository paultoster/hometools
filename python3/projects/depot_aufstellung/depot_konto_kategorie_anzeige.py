#
# datensatz anzeigen und Kategorien bearbeiten
#
#
#
import os
import sys

import openpyxl

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

# Hilfsfunktionen
import tools.hfkt_def as hdef
import tools.hfkt_date_time as hdate
# import tools.hfkt_str as hstr
import tools.hfkt_tvar as htvar
import tools.hfkt_type as htype

import depot_kategorie_auswertung_class

def anzeige(rd):
    
    jahr = rd.ini.dict_tvar[rd.par.INI_KONTO_AUSWERTUNG_JAHR_NAME].val
    
    (tval_min_time,tval_max_time) = get_limits_epocht_time_of_year(jahr)
    
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
    katauswertfunc = depot_kategorie_auswertung_class.KategorieAuswertungClass(konto_obj.par,
                                                                         [konto_obj.par.KONTO_NAME] + header_list,
                                                                         ["str"] + type_list,
                                                                         rd.allg.katfunc,
                                                                         jahr)
    
    # Loop over each konto
    for kont_name in rd.ini.ddict[rd.par.INI_KONTO_DATA_LIST_NAMES_NAME]:
        
        konto_obj = rd.konto_dict[kont_name].konto_obj
        
        # print(f"vor: {header_list =}")
        
        ttable = konto_obj.get_timedepend_data_set_dict_ttable(header_list, type_list,
                                                               tval_min_time, tval_max_time,
                                                               with_start=False)
        
        # print(f"nach: {header_list =}")
        
        if konto_obj.status != hdef.OKAY:
            rd.log.write_err("anzeige  kategorie " + konto_obj.errtext, screen=rd.par.LOG_SCREEN_OUT)
            konto_obj.reset_status()
            return konto_obj.status
        # end if
        
        add_row_liste = [kont_name for i in range(ttable.ntable)]
        ttable = htvar.add_row_liste_to_table(ttable, konto_obj.par.KONTO_NAME, add_row_liste, "str")
        # print(f"nach1: {header_list =}")
        status = katauswertfunc.add_ttable(ttable)
        # print(f"nach2: {header_list =}")
        if status != hdef.OKAY:
            rd.log.write_err("anzeige  kategorie add ttable \n" + katauswertfunc.errtext, screen=rd.par.LOG_SCREEN_OUT)
            return status
        # end if
        # print(f"nach3: {header_list =}")
    
    # end for
    
    katauswertfunc.run_auswert()
    
    ttable_ueberblick = katauswertfunc.get_auswert_ueberblick()
    file_name         = hdate.get_name_by_dat_time("Kontoauswertung_" + str(jahr) + "_", "") + ".xlsx"

    status = bilde_ods_File(file_name,ttable_ueberblick)
    
    return status
# end def
def bilde_ods_File(file_name, ttable_ueberblick):
    '''
    
    :param file_name:
    :param ttable_ueberblick:
    :return: status = bilde_ods_File(file_name, ttable_ueberblick)
    '''
    
    # start ods-Output
    workbook = openpyxl.Workbook()
    
    worksheet = workbook.active
    
    # Übersichtsdaten von allen  WPs
    worksheet.title = "Zusammenfassung"

    row_num = 1
    for i,header in enumerate(ttable_ueberblick.names):
        col_num = i+1
        worksheet.cell(row=row_num,column=col_num,value=header)
    # end if
    for data_liste in ttable_ueberblick.table:
        row_num += 1
        for i,data in enumerate(data_liste):
            col_num = i + 1
            worksheet.cell(row=row_num, column=col_num, value=data)
        # end for
    # end for
    
    workbook.save(file_name)
    
    os.startfile(file_name)
    
    status = hdef.OKAY
    
    return status
# end def

def get_limits_epocht_time_of_year(str_year):
    '''
    
    :param str_jear:
    :return: (min_epoch_time, max_epoch_time) = get_limits_epocht_time_of_year(str_year)
    '''
    
    str_year_next = str(int(str_year) + 1)
    
    (okay,wert) = htype.type_transform_yearStr(str_year,"dat")
    
    if okay != hdef.OKAY:
        raise Exception(f"get_limits_epocht_time_of_year: {str_year = } kann nicht in epochaler Zeit gewandelt werten")
    # end if
    tval_min_epoch_time = htvar.build_val("min_epoch_time",wert,"dat")
    
    (okay,wert) = htype.type_transform_yearStr(str_year_next,"dat")
    if okay != hdef.OKAY:
        raise Exception(f"get_limits_epocht_time_of_year: {str_year_next = } kann nicht in epochaler Zeit gewandelt werten")
    # end if
    tval_max_epoch_time = htvar.build_val("max_epoch_time", wert, "dat")
    
    return (tval_min_epoch_time, tval_max_epoch_time)
# end def
