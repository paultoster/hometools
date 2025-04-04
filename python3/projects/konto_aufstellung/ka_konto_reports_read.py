#
# reports einlesen
#
# Ing-Bank  ing_bank_giro  =>  type ing_csv
#
import os
import sys

# import pymupdf
import PyPDF2

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

# Hilfsfunktionen
import hfkt_def as hdef
# import hfkt_list as hlist
# import hfkt_type as htype
import hfkt_io as hio
import sgui

import ka_gui
import ka_konto_anzeige

def report_einlesen(rd):
    """

    :param rd:
    :return: status
    """
    
    status = hdef.OKAY
    errtext = ""
    
    # Kontoauswählen
    runflag = True
    while (runflag):
        
        (index,choice) = ka_gui.auswahl_konto(rd)
        
        if index < 0:
            return status
        elif choice in rd.ini.konto_names:
            
            rd.log.write(f"konto  \"{choice}\" ausgewählt")
            break
        else:
            status = hdef.NOT_OKAY
            errtext = f"Konto Auswahl: {choice} nicht bekannt"
            rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
            return status
        # endif
    # endwhile
    
    # Konto data in ini
    konto_dict = rd.data[choice].ddict
    konto_obj   = rd.data[choice].obj
    
    # csv lesen
    if( konto_dict[rd.par.UMSATZ_DATA_TYPE_NAME] == 'ing_csv'):
        
        # csv-Datei auswählen
        filename = sgui.abfrage_file(file_types="*.csv",
                                     comment=f"Wähle ein report von ING-DiBa für den Kontoumsatz von Konto: {choice}",
                                     start_dir=os.getcwd())
        
        if (len(filename) == 0):  # Abbruch
            return status
        # endif
        
        (status, konto_dict,konto_obj, flag_newdata) = read_ing_csv(rd, konto_dict,konto_obj, filename)
        
        if status != hdef.OKAY:  # Abbruch
            return status
        # end if
        
        if flag_newdata :
            (status,konto_dict,konto_obj) = ka_konto_anzeige.anzeige(rd,konto_dict,konto_obj)
        else:
            rd.log.write_info("Keine neuen Daten eingelesen !!!!", screen=rd.par.LOG_SCREEN_OUT)
        # end if


        if status != hdef.OKAY:  # Abbruch
            return status
        # end if
        
        # write back modified konto_dict
        rd.data[choice].ddict = konto_dict
        rd.data[choice].obj   = konto_obj

    else:
        errtext = f"Der Umsatz data type von [{choice}].{rd.ini.UMSATZ_DATA_TYPE_NAME} = {konto_dict[rd.ini.UMSATZ_DATA_TYPE_NAME]} stimmt nicht"
        rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
        status  = hdef.NOT_OKAY
    #endif
        
    return status
# enddef
def read_ing_csv(rd, konto_dict, konto_obj,filename):
    '''

    :param csv_lliste:
    :param header_lliste
    :param filename:
    :return: (status,konto_dict,flag_newdata) = read(rd,konto_dict,filename)
    '''
    status = hdef.OKAY
    errtext = ""
    new_data_set_flag = False
    
    # read csv-File
    # ==============
    csv_lliste = hio.read_csv_file(file_name=filename, delim=";")
    
    if (len(csv_lliste) == 0):
        rd.log.write_err(f"Fehler in read_ing_csv read_csv_file()  filename = {filename}", screen=rd.par.LOG_SCREEN_OUT)
        status = hdef.NOT_OKAY
        return (status, konto_dict, new_data_set_flag)
    # end if
    
    # build header dict names
    # ========================
    # (status, errtext, header_name_dict) = build_ing_csv_header_name_dict(konto_dict, rd.par)
    # if status != hdef.OKAY:
    #     rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
    #     return (status, konto_dict, new_data_set_flag)
    # # endif
    
    # build buch_type_dict
    # =====================
    # (status, errtext, buch_type_dict) = build_ing_csv_buch_type_dict(konto_dict, rd.par)
    # if status != hdef.OKAY:
    #     rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
    #     return (status, konto_dict, new_data_set_flag)
    # # endif
    
    # csv-daten einlesen
    # ===================
    (new_data_set_flag, status, errtex) = konto_obj.read_csv( csv_lliste,  filename)
    
    if status != hdef.OKAY:
        rd.log.write_err(f"Fehler in konto_obj.read_csv(): {errtex}", screen=rd.par.LOG_SCREEN_OUT)
    
    return (status, konto_dict,konto_obj, new_data_set_flag)


# enddef
# # def build_ing_csv_header_name_dict(konto_dict, par):
# #     '''
# #
# #     :param konto_dict:
# #     :param par:
# #     :return: (status,errtext,header_name_dict) = build_header_name_dict(konto_dict,par)
# #     '''
# #     header_name_dict = {}
# #     status = hdef.OKAY
# #     errtext = ""
# #     for key in par.KDSP.KONTO_DATA_HEADER_INI_NAME_DICT.keys():
# #         # no data
# #         if (len(par.KDSP.KONTO_DATA_HEADER_INI_NAME_DICT[key]) == 0):
# #             status = hdef.NOT_OKAY
# #             errtext = f"par.KONTO_DATA_HEADER_INI_NAME_DICT[{key}] is empty"
# #             return (status, errtext, header_name_dict)
# #         elif (par.KDSP.KONTO_DATA_HEADER_INI_NAME_DICT[key] in konto_dict):
# #             header_name_dict[key] = konto_dict[par.KDSP.KONTO_DATA_HEADER_INI_NAME_DICT[key]]
# #         else:
# #             status = hdef.NOT_OKAY
# #             errtext = f"key =  from par.KONTO_DATA_HEADER_INI_NAME_DICT[{key}] = {par.KDSP.KONTO_DATA_HEADER_INI_NAME_DICT[key]} is not in konto_dict"
# #             return (status, errtext, header_name_dict)
# #         # end if
# #     # end for
# #     return (status, errtext, header_name_dict)
# #
# #
# # # end def
# def build_ing_csv_buch_type_dict(konto_dict, par):
#     '''
#
#     :param konto_dict ist das dictionary vom Konto mit allen Datan
#     :param par
#     :return: (status,errtext,buch_type_dict) = self.build_buch_type_dict(konto_dict,par)
#     '''
#
#     status = hdef.OKAY
#     errtext = ""
#     buch_type_dict = {}
#
#     for key in par.KDSP.KONTO_DATA_BUCHTYPE_INI_NAME_DICT.keys():
#
#         if (len(par.KDSP.KONTO_DATA_BUCHTYPE_INI_NAME_DICT[key]) == 0):
#             status = hdef.NOT_OKAY
#             errtext = f"key =  from par.KONTO_DATA_BUCHTYPE_INI_NAME_DICT[{key}] = {par.KDSP.KONTO_DATA_BUCHTYPE_INI_NAME_DICT[key]} is empty"
#             return (status, errtext, buch_type_dict)
#         elif (par.KDSP.KONTO_DATA_BUCHTYPE_INI_NAME_DICT[key] in konto_dict):
#             buch_type_dict[key] = konto_dict[par.KDSP.KONTO_DATA_BUCHTYPE_INI_NAME_DICT[key]]
#         else:
#             status = hdef.NOT_OKAY
#             errtext = f"key =  from par.KONTO_DATA_BUCHTYPE_INI_NAME_DICT[{key}] = {self.par.KDSP.KONTO_DATA_BUCHTYPE_INI_NAME_DICT[key]} is not in konto_dict"
#             return (status, errtext, buch_type_dict)
#         # end if
#     # end for
#     return (status, errtext, buch_type_dict)
# # end def

