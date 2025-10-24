#
# datensatz anzeigen
#
#
#
import os
import sys

import hfkt_tvar

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

# Hilfsfunktionen
import tools.hfkt_def as hdef
import tools.hfkt_date_time as hdate
import tools.hfkt_str as hstr
import tools.hfkt_type as htype
import tools.sgui as sgui

import depot_gui

def anzeige(rd, konto_obj):
    '''

    :param rd:
    :param ddict:
    :return: (status, konto_obj) =  anzeige(rd,konto_obj)
    '''
    
    status = hdef.OKAY
    abfrage_liste = ["ende", "set kat", "del kat","regel(run)","regel(edit)", "regel(build)","kat(edit)","hkat(edit)"]
    i_end = 0
    i_set_kat = 1
    i_del_kat = 2
    i_regel_anwenden = 3
    i_regel_edit = 4
    i_regel_build = 5
    i_edit_kategorie = 6
    i_edit_haupt_kategorie = 7

    data_changed_pos_list = []
    ttable_anzeige = None
    non_use_kat_list = [konto_obj.par.KONTO_DATA_NAME_ID
        , konto_obj.par.KONTO_DATA_NAME_BUCHTYPE
        , konto_obj.par.KONTO_DATA_NAME_SUMWERT]
    runflag = True
    while (runflag):
        
        (ttable, row_color_dlist) = konto_obj.get_anzeige_ttable()
        
        if ttable.ntable > 0:
            (status, errtext, ttable_anzeige, index_abfrage, irow, data_changed_pos_list) = \
                depot_gui.konto_abfrage(rd.gui, ttable, abfrage_liste, row_color_dlist)
            if status != hdef.OKAY:
                rd.log.write_err(errtext, screen=rd.par.LOG_SCREEN_OUT)
                index_abfrage = i_end
            # end if
        else:
            rd.log.write_warn("Noch keine Daten für dieses Konto angelegt, es geht weiter zu Add ",
                              screen=rd.par.LOG_SCREEN_OUT)
            index_abfrage = i_end
        # end if
        
        # Beenden
        # ----------------------------
        if index_abfrage == i_end:
            
            runflag = False
            
        # setze eine kategorie
        # ----------------------------
        elif index_abfrage == i_set_kat:
            
            if irow < 0:
                rd.log.write_err("konto_kategorie set kat: irow out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                (tlist, _, _) = konto_obj.get_edit_data(irow)
                
                eingabeListe = []
                vorgabeListe = []
                immutableListe = []
                
                i_count = 0
                i_kat = 0
                for i, name in enumerate(tlist.names):
                    if name not in non_use_kat_list:
                        if name == konto_obj.par.KONTO_DATA_NAME_KATEGORIE:
                            kat_liste = rd.allg.katfunc.get_kat_list()
                            eingabeListe.append(["kategorie", kat_liste])
                            vorgabeListe.append("")
                            immutableListe.append(0)
                            i_kat = i_count
                    
                        else:
                            eingabeListe.append(name)
                            vorgabeListe.append(tlist.vals[i])
                            immutableListe.append(1)
                        # end if
                        i_count += 1
                    # end if
                # end for
            
                title = "Wähle Kategorie aus:"
                ergebnisListe = depot_gui.konto_set_kat(rd.gui, eingabeListe, vorgabeListe,immutableListe, title)
                
                if len(ergebnisListe) != 0:
                    (flag,status,errtext) = \
                    konto_obj.set_data_set_value( konto_obj.par.KONTO_DATA_NAME_KATEGORIE
                                                  , ergebnisListe[i_kat]
                                                  , "str", irow)
                    
                    if status != hdef.OKAY:
                        rd.log.write_err("konto_kategorie set kat " + errtext,screen=rd.par.LOG_SCREEN_OUT)
                        return (status, konto_obj)
                    # end if
                # end if
            # end if
            
            runflag = True
            
        # Delete Kat
        # ----------------------------
        elif index_abfrage == i_del_kat:
            
            if irow < 0:
                rd.log.write_err("konto_kategorie set kat: irow out of range or not set", screen=rd.par.LOG_SCREEN_OUT)
            else:
                
                (flag, status, errtext) = \
                        konto_obj.set_data_set_value(konto_obj.par.KONTO_DATA_NAME_KATEGORIE
                                                     , ""
                                                     , "str", irow)
                    
                if status != hdef.OKAY:
                    rd.log.write_err("konto_kategorie set kat " + errtext, screen=rd.par.LOG_SCREEN_OUT)
                    return (status, konto_obj)
                # end if
            # end if
            
            runflag = True
        
        # Regel anwenden
        # ----------------------------
        elif index_abfrage == i_regel_anwenden:
            
            # Daten updaten, wenn Kategorie in der Eingabe geändert
            if len(data_changed_pos_list) > 0:
                konto_obj.write_anzeige_back_data(ttable_anzeige, data_changed_pos_list,"kategorie")
                if konto_obj.status != hdef.OKAY:
                    status = hdef.NOT_OKAY
                    rd.log.write_err("konto_anzeige update " + konto_obj.errtext, screen=rd.par.LOG_SCREEN_OUT)
                    runflag = True
                # end if
            # end if

            if status == hdef.OKAY:
                
                # Regeln anwenden
                konto_obj.kategorie_regel_anwenden()
                
                if konto_obj.status != hdef.OKAY:
                    rd.log.write_err("konto_kategorie regel anwenden" + konto_obj.errtext, screen=rd.par.LOG_SCREEN_OUT)
                    return (konto_obj.status, konto_obj)
                else:
                    if len(konto_obj.infotext):
                        rd.log.write_info("konto_kategorie regel anwenden" + konto_obj.infotext, screen=rd.par.LOG_SCREEN_OUT)
                    # end if
                # endif
                runflag = True
            # end if
        elif index_abfrage == i_regel_edit:
            
            regel_list = rd.allg.katfunc.get_regel_list()
            
            regel_list_mod = depot_gui.konto_regel_edit_abfrage(rd.gui, regel_list)
            
            if len(regel_list_mod) > 0:
                rd.allg.katfunc.set_regel_list(regel_list_mod)
                
                if rd.allg.katfunc.status != hdef.OKAY:
                    rd.log.write_err("konto_kategorie edit regel" + rd.allg.katfunc.errtext,
                                     screen=rd.par.LOG_SCREEN_OUT)
                    return (rd.allg.katfunc.status, konto_obj)
                
                if len(rd.allg.katfunc.infotext) > 0:
                    rd.log.write_info("konto_kategorie regel(edit): " + rd.allg.katfunc.infotext,
                                      screen=rd.par.LOG_SCREEN_OUT)
                # end if
            # end if
            runflag = True
            
        elif index_abfrage == i_regel_build:
            
            
            eingabeListe = []
            vorgabeListe = []
            
            if irow >= 0: # Take values as default
                (tlist, _, _) = konto_obj.get_edit_data(irow)
            else:
                (tlist, _, _) = konto_obj.get_extern_default_tlist()
            # end if
            i_count = 0
            i_kat = 0
            for i,name in enumerate(tlist.names):
                if name not in non_use_kat_list:
                    if name == konto_obj.par.KONTO_DATA_NAME_KATEGORIE:
                        kat_liste = rd.allg.katfunc.get_kat_list()
                        eingabeListe.append(["kategorie", kat_liste])
                        vorgabeListe.append("")
                        i_kat = i_count
                        
                    else:
                        eingabeListe.append(name)
                        vorgabeListe.append(tlist.vals[i])
                        
                    # end if
                    i_count += 1
                # end if
            # end for

            title = "Erstelle Regel: %s (keine Regel heißt value leer lassen)" % ("{kategorie:{header1:value,header2:value,...}}")
            flag = True
            while flag:
                ergebnisListe = depot_gui.konto_regel_edit(rd.gui, eingabeListe, vorgabeListe,title)
            
                if len(ergebnisListe) == 0: #cancel
                    flag = False
                elif len(ergebnisListe[i_kat]) == 0:
                    rd.log.write_err("depot_konto_kategorie build regel: kategorie ist leer !!! ", screen=rd.par.LOG_SCREEN_OUT)
                    flag = True
                else:
                    # neue regel dict
                    inner_dict = {}
                    for i,name in enumerate(eingabeListe):
                        # wenn value nicht leer
                        if (len(ergebnisListe[i]) > 0) and (i != i_kat):
                            inner_dict[eingabeListe[i]]=ergebnisListe[i]
                        # end if
                    # end ofr
                    regel_dict = {}
                    regel_dict[eingabeListe[i_kat][0]] = ergebnisListe[i_kat]
                    
                    
                    rd.allg.katfunc.add_regel_dict(regel_dict)
                    
                    if rd.allg.katfunc.status != hdef.OKAY:
                        rd.log.write_err("konto_kategorie build regel " + rd.allg.katfunc.errtext,
                                         screen=rd.par.LOG_SCREEN_OUT)
                        return (rd.allg.katfunc.status, konto_obj)
                    # end if
                    flag = False
                # end if
            # end while
            runflag = True
        elif index_abfrage == i_edit_kategorie:
            
            kat_dict = rd.allg.katfunc.get_kat_dict()
            
            kat_dict_mod = depot_gui.konto_kat_abfrage(rd.gui, kat_dict)
            
            if len(kat_dict_mod) > 0:
                rd.allg.katfunc.set_kat_dict(kat_dict_mod)
                
                if rd.allg.katfunc.status != hdef.OKAY:
                    rd.log.write_err("konto_kategorie edit kategorie" + rd.allg.katfunc.errtext, screen=rd.par.LOG_SCREEN_OUT)
                    return (rd.allg.katfunc.status, konto_obj)

                if len(rd.allg.katfunc.infotext) > 0:
                    rd.log.write_info("konto_kategorie kat(edit): " + rd.allg.katfunc.infotext,
                                      screen=rd.par.LOG_SCREEN_OUT)
                # end if
            # end if
            runflag = True
            
        elif index_abfrage == i_edit_haupt_kategorie:
            
            hkat_list = rd.allg.katfunc.get_hkat_list()
            
            hkat_list_mod = depot_gui.konto_hkat_abfrage(rd.gui, hkat_list)
            
            if len(hkat_list_mod) > 0:
                rd.allg.katfunc.set_hkat_list(hkat_list_mod)
                
                if rd.allg.katfunc.status != hdef.OKAY:
                    rd.log.write_err("konto_kategorie edit haupt kategorie" + rd.allg.katfunc.errtext, screen=rd.par.LOG_SCREEN_OUT)
                    return (rd.allg.katfunc.status, konto_obj)

                if len(rd.allg.katfunc.infotext) > 0:
                    rd.log.write_info("konto_kategorie hkat(edit): " + rd.allg.katfunc.infotext,
                                      screen=rd.par.LOG_SCREEN_OUT)
                # end if
            # end if
            runflag = True
        else:
            runflag = True
    # end while
    
    return (status, konto_obj)
# end def
def build_range_to_show_dataset(nlines, istart, nshow, dir):
    '''

    :param nlines:  maximale Anzahl an Zeilen
    :param istart:  letzte startzeile (-1 ist beginn)
    :param nshow:   Wieviele Zeile zeigen
    :param dir:     -1 zurück, +1 vorwärts
    :return:     (istart,iend) = build_range_to_show_dataset(nlines,istart,nshow,dir)
    '''
    if istart < 0:  # Start with newest part
        istart = max(0, nlines - nshow)
    elif dir > 0:
        istart = min(istart + nshow, max(0, nlines - nshow))
    else:
        istart = max(istart - nshow, 0)
    # endif
    iend = min(istart + nshow - 1, max(0, nlines - 1))
    return (istart, iend)


# end def
def build_data_table_list_and_color_list(par, ddict, istart, iend):
    '''

    :param rd:
    :param ddict:
    :param istart:
    :param iend:
    :return: (data_llist, color_list) = build_data_table_list_and_color_list(rd, ddict, istart, iend)
    '''
    
    data_llist = []
    color_list = []
    n = len(ddict[par.KONTO_DATA_SET_NAME])
    index = istart
    while (index <= iend) and (index < n):
        data_list = []
        data_set_list = ddict[par.KONTO_DATA_SET_NAME][index]
        # 1) id
        data_list.append(data_set_list[par.KONTO_DATA_INDEX_ID])
        # 2)    KONTO_DATA_INDEX_BUCHDATUM
        data_list.append(hdate.secs_time_epoch_to_str(data_set_list[par.KONTO_DATA_INDEX_BUCHDATUM]))
        # 3)    KONTO_DATA_INDEX_WERTDATUM
        data_list.append(hdate.secs_time_epoch_to_str(data_set_list[par.KONTO_DATA_INDEX_WERTDATUM]))
        # 4)    KONTO_DATA_INDEX_WER:
        data_list.append(data_set_list[par.KONTO_DATA_INDEX_WER])
        # 5)    KONTO_DATA_INDEX_BUCHTYPE
        data_list.append(par.KONTO_BUCHUNGS_TEXT_LIST[data_set_list[par.KONTO_DATA_INDEX_BUCHTYPE]])
        # 6)    KONTO_DATA_INDEX_WERT:
        data_list.append(hstr.convert_int_cent_to_string_euro(data_set_list[par.KONTO_DATA_INDEX_WERT]))
        # 7)    KONTO_DATA_INDEX_SUMWERT
        data_list.append(hstr.convert_int_cent_to_string_euro(data_set_list[par.KONTO_DATA_INDEX_SUMWERT]))
        # 8)    KONTO_DATA_INDEX_COMMENT
        data_list.append(data_set_list[par.KONTO_DATA_INDEX_COMMENT])
        # 9)    KONTO_DATA_INDEX_ISIN
        data_list.append(data_set_list[par.KONTO_DATA_INDEX_ISIN])
        # 10)    KONTO_DATA_INDEX_KATEGORIE
        data_list.append(data_set_list[par.KONTO_DATA_INDEX_KATEGORIE])
        
        # add to llist
        data_llist.append(data_list)
        
        # color list
        if data_set_list[par.KONTO_DATA_INDEX_ID] in ddict[par.KONTO_DATA_ID_NEW_LIST]:
            color_list.append(par.COLOR_SHOW_NEW_DATA_SETS)
        else:
            color_list.append("")
        # end if
        
        index += 1
    # end while
    
    return (data_llist, color_list)


# end def
def write_back_data(par, d_new_llist, data_changed_pos_list, istart, ddict):
    '''

    :param par:
    :param d_new_llist:
    :param data_changed_pos_list:
    :param istart:
    :param ddict:
    :return: ddict =  write_back_data(par,d_new_llist,data_changed_pos_list,istart,ddict)
    '''
    
    wert_changed = False
    for (irow, icol) in data_changed_pos_list:
        
        if (icol != par.KONTO_DATA_INDEX_ID) and (icol != par.KONTO_DATA_INDEX_BUCHTYPE) and \
            (icol != par.KONTO_DATA_INDEX_COMMENT) and (icol != par.KONTO_DATA_INDEX_SUMWERT):
            
            ddict[par.KONTO_DATA_SET_NAME][istart + irow][icol] = d_new_llist[irow][icol]
            
            if (icol == par.KONTO_DATA_INDEX_WERT):
                wert_changed = True
        # end if
    # end for
    
    if wert_changed:
        if istart == 0:
            sumwert = ddict[par.START_WERT_NAME]
        else:
            sumwert = ddict[par.KONTO_DATA_SET_NAME][istart - 1][par.KONTO_DATA_INDEX_SUMWERT]
        # end if
        
        i = istart
        n = len(ddict[par.KONTO_DATA_SET_NAME])
        while (i < n):
            sumwert += ddict[par.KONTO_DATA_SET_NAME][i][par.KONTO_DATA_INDEX_WERT]
            
            ddict[par.KONTO_DATA_SET_NAME][i][par.KONTO_DATA_INDEX_SUMWERT] = int(sumwert)
            
            i += 1
        # end while
    # end if
    
    return ddict
# end def
