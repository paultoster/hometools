"""

 Wertet datensätze mit Kategorie aus

"""

import os, sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import copy

import tools.hfkt_def as hdef
import tools.hfkt_type as htype
import tools.hfkt_tvar as htvar
import tools.hfkt_list as hlist
import tools.hfkt_str as hstr
import tools.hfkt_data_set as hdset


class GroupDataClass:
    def __init__(self,group):
        self.group = group
        self.summe_monat_liste = [0 for i in range(12)]
        self.summe_jahr = 0
    def add_monat_summen_liste(self,summe_monat_liste):
        
        summe = 0
        for i in range(12):
            self.summe_monat_liste[i] += summe_monat_liste[i]
            summe += summe_monat_liste[i]
        # end for
        self.summe_jahr += summe
        return
    
    def get_summe_monat_liste(self):
        return self.summe_monat_liste
    def get_summe_jahr(self):
        return self.summe_jahr
    def get_sumwert_monat_liste(self, type_out):
        '''
    
        :param type:
        :return: sumwert_monat_liste = obj.get_sumwert_monat_liste(self,type)
        '''
    
        sumwert_monat_liste = []
        for i in range(12):
            (okay, wert) = htype.type_transform(self.summe_monat_liste[i], "cent", type_out)
            if okay != hdef.OKAY:
                raise Exception(
                    f"get_sumwert_monat_liste:  Fehler transform self.sumwert_monat_liste[{i}] = <{self.summe_monat_liste[i]}> von type: <{"cent"}> in type {type_out} wandeln !!!!!!")
            # end if
        
            sumwert_monat_liste.append(wert)
    
        # end for
    
        return sumwert_monat_liste
    # end def
    def get_sumwert_jahr(self, type_out):
        '''
    
        :param type_out:
        :return: sumwert_jahr = obj.get_sumwert_jahr(type_out)
        '''
        
        (okay, sumwert_jahr) = htype.type_transform(self.summe_jahr, "cent", type_out)
        if okay != hdef.OKAY:
            raise Exception(
                f"get_sumwert_jahr:  Fehler transform self.sumwert_jahr = <{self.summe_jahr}> von type: <{"cent"}> in type {type_out} wandeln !!!!!!")
        # end if
        
        return sumwert_jahr
    # end def
# end class
class ZusammfassDataClass(GroupDataClass):
    def __init__(self, zusammenfass):
        """ Initalisieren über Eltern-Klasse """
        super().__init__(zusammenfass)
        
        self.zusammenfass = zusammenfass
# end class
class KatDataClass:
    '''
    obj = KatDataClass(kategorie,kattype,header_list,type_list)

    Funktionen:
    obj.reset_status()                   resetet Status und Text

    '''
    
    def __init__(self,par, kat,group,katzeit,header_list, type_list):
        '''
        
        :param kategorie: Kategoriename
        :param kattype:   Type der Verarbeitung =1 monatlich, =12 jährlich
        :param header_list: dateset header Liste
        :param type_list: dateset type Liste
        '''

        self.TYPE_MONAT = 1
        self.TYPE_JAHR  = 12
        self.status = hdef.OK
        self.errtext = ""
        self.infotext = ""

        self.par       = par
        self.kategorie = kat
        self.group     = group
        self.katzeit   = katzeit
        
        if katzeit not in [self.TYPE_MONAT, self.TYPE_JAHR]:
            raise Exception(f"KatDataClass int() {katzeit = } ist nicht {self.TYPE_MONAT = } oder {self.TYPE_JAHR = }")
        # end if
        
        if katzeit == self.TYPE_MONAT:
            self.zeit_str = 'm'
        else:
            self.zeit_str = 'j'
        # end if
        
        self.sumwert_monat_liste = [0 for i in range(12)]
        self.sumwert_jahr = 0
        self.sumwert_monat_mittel = 0
        
        self.build_data_set_obj(header_list,type_list)
        
    # end def
    def reset_status(self):
        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""
    def get_group(self):
        return self.group
    # end def
    def get_monats_summen_liste(self):
        return self.get_sumwert_monat_liste('cent')
    # end def
    def build_data_set_obj(self,header_list,type_list):
        
        # Data-Set anlegen
        self.data_set_obj = hdset.DataSet(self.kategorie)
        
        # Header un Type bestimmen
        for index, header in enumerate(header_list):
            
            self.data_set_obj.set_definition(index, header, type_list[index], type_list[index])
            if self.data_set_obj.status != hdef.OKAY:
                self.status = self.data_set_obj.status
                self.errtext = self.data_set_obj.errtext
                self.data_set_obj.reset_status()
                break
            # end if
        # end for
        
        return
    # end def
    def add_data_set(self,tlist):
        '''
        
        :param tlist:
        :return: self.add_data_set(tlist)
        '''


        self.data_set_obj.add_data_set_tvar(tlist)
        
        if self.data_set_obj.status != hdef.OKAY:
            self.status = self.data_set_obj.status
            self.errtext = self.data_set_obj.errtext
            self.data_set_obj.reset_status()
        # end if
        
        return
    # end def
    def run_auswert(self):
        '''
        
        :return:
        '''
        
        # Sortieren nach Datum
        #---------------------
        self.data_set_obj.update_order_name(self.par.KONTO_DATA_NAME_BUCHDATUM)

        if self.data_set_obj.status != hdef.OKAY:
            self.status = self.data_set_obj.status
            self.errtext = self.data_set_obj.errtext
            self.data_set_obj.reset_status()
        # end if
        
        self.sumwert_jahr = 0
        for i in range(12):
            
            irowlist = self.data_set_obj.find_in_col( i+1, "monthInt", self.par.KONTO_DATA_NAME_BUCHDATUM)
            
            self.sumwert_monat_liste[i] = 0
            icol = self.data_set_obj.find_header_index(self.par.KONTO_DATA_NAME_WERT)
            
            for irow in irowlist:
                self.sumwert_monat_liste[i] += self.data_set_obj.get_data_item(irow, icol ,"cent")
            # end for
            self.sumwert_jahr += self.sumwert_monat_liste[i]
        # end for
        self.sumwert_monat_mittel = int(self.sumwert_jahr/12.)
        return
    # end def
    def get_kat_zeit_str_group_liste(self):
        '''
        
        :return: [kat,zeit_str,group] = obj.get_kat_zeit_str_group_liste()
        '''
        
        return [self.kategorie,self.zeit_str,self.group]
    def get_sumwert_monat_liste(self,type_out):
        '''
        
        :param type:
        :return: sumwert_monat_liste = obj.get_sumwert_monat_liste(self,type)
        '''
        
        sumwert_monat_liste = []
        for month in range(1,13):
            wert = self.get_sumwert_monat(month,type_out)
            sumwert_monat_liste.append(wert)
        # end for
        
        return sumwert_monat_liste
    # end def
    def get_sumwert_monat(self,month,type_out):
        '''
        
        :param type_out:
        :return: wert = self.get_sumwert_monat(month,type_out)
        '''
        
        i = min(max(month-1,0),12)
        if self.katzeit == self.TYPE_MONAT:
            (okay, wert) = htype.type_transform(self.sumwert_monat_liste[i], "cent", type_out)
            if okay != hdef.OKAY:
                raise Exception(
                    f"get_sumwert_monat_liste:  Fehler transform self.sumwert_monat_liste[{i}] = <{self.sumwert_monat_liste[i]}> von type: <{"cent"}> in type {type_out} wandeln !!!!!!")
            # end if
        else:
            (okay, sumwert_monat_mittel) = htype.type_transform(self.sumwert_monat_mittel, "cent", type_out)
            if okay != hdef.OKAY:
                raise Exception(
                    f"get_sumwert_monat_liste:  Fehler transform self.sumwert_monat_mittel = <{self.sumwert_monat_mittel}> von type: <{"cent"}> in type {type_out} wandeln !!!!!!")
            # end if
            wert = sumwert_monat_mittel
        
        # end if
        
        return wert
    # end def
    def is_sumwert_monat_gemittelt(self):
        return self.katzeit == self.TYPE_JAHR
    # end def
    def get_sumwert_jahr(self,type_out):
        '''
        
        :param type_out:
        :return: sumwert_jahr = obj.get_sumwert_jahr(type_out)
        '''
        
        (okay, sumwert_jahr) = htype.type_transform(self.sumwert_jahr, "cent", type_out)
        if okay != hdef.OKAY:
            raise Exception(
                f"get_sumwert_jahr:  Fehler transform self.sumwert_jahr = <{self.sumwert_jahr}> von type: <{"cent"}> in type {type_out} wandeln !!!!!!")
        # end if

        return sumwert_jahr
    # end def
    def get_ttable_and_month_list(self,header_liste,type_liste,dat_header):
        
        ttable = self.data_set_obj.get_data_set_ttable(header_liste,type_liste)
        if self.data_set_obj.status != hdef.OKAY:
            
            self.status = self.data_set_obj.status
            self.errtext = self.data_set_obj.errtext
            self.data_set_obj.reset_status()
            return ([],[])
        # end if
        
        month_list = self.data_set_obj.get_row_list_of_header(dat_header, "monthInt")
        if self.data_set_obj.status != hdef.OKAY:
            self.status = self.data_set_obj.status
            self.errtext = self.data_set_obj.errtext
            self.data_set_obj.reset_status()
            return ([], [])
        # end if
        
        return (ttable,month_list)
# end class
class KategorieAuswertungClass:
    '''
    obj = KategorieAuswertungClass(par,header_list,type_list,katfunc)

    Funktionen:
    obj.reset_status()                   resetet Status und Text

    '''
    
    def __init__(self, par,header_list,type_list,katfunc,jahr):
        self.status = hdef.OK
        self.errtext = ""
        self.infotext = ""
        
        self.par = par
        self.header_list = copy.copy(header_list)
        self.header_list += [par.KONTO_DATA_NAME_SUMWERT]
        self.type_list = copy.copy(type_list)
        self.type_list += ["cent"]
        self.katfunc = katfunc
        self.jahr = jahr
        
        self.kat_data_obj_dict  = {}
        self.n_kat_data_obj     = 0
        
        self.group_data_obj_dict = {}
        self.zusammfass_data_obj_dict = {}
        
        self.build_kategorie_data_sets()
    # end def
    def reset_status(self):
        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""
    
    # end def
    def build_kategorie_data_sets(self):
        
        self.kat_data_obj_dict  = {}
        self.n_kat_data_obj     = 0

        for kat in self.katfunc.get_kat_list():
            (group, zeit) = self.katfunc.get_grup_type_from_kat(kat)
            self.kat_data_obj_dict[kat] = KatDataClass(self.par,kat,group, zeit,self.header_list,self.type_list)
            self.n_kat_data_obj += 1
        # end for
        
        # add leer
        kat = "leer"
        (group, zeit) = self.katfunc.get_grup_type_from_kat(kat)
        if group is None:
            group = "leer"
            zeit = 1
        # end if
        self.kat_data_obj_dict[kat] = KatDataClass(self.par,kat, group, zeit, self.header_list, self.type_list)
        self.n_kat_data_obj += 1
        
        return
    # end def
    def add_ttable(self,ttable: htvar.TTable):
        '''
        
        
        
        :param ttable:
        :return:
        '''
        
        icol_kat = htvar.get_index_from_table(ttable,self.par.KONTO_DATA_NAME_KATEGORIE)
        icol_wert = htvar.get_index_from_table(ttable,self.par.KONTO_DATA_NAME_WERT)

        for irow in range(ttable.ntable):
            
            tlist = htvar.get_list_from_table(ttable,irow)
            
            katval    = htvar.get_val_from_list(tlist,icol_kat,"str")
            wert_cent = htvar.get_val_from_list(tlist,icol_wert,"cent")
            
            katdict = self.katfunc.build_katdict(katval, wert_cent)
            
            if len(katdict.keys()) == 1:
                self.add_tlist_to_data_set(katval,tlist)
            else:
                for kat in katdict.keys():
                    tlist_part = copy.copy(tlist)
                    tlist_part = htvar.set_val_in_list(tlist_part,kat,icol_kat,"str")
                    tlist_part = htvar.set_val_in_list(tlist_part, katdict[kat], icol_wert, "cent")
                    
                    self.add_tlist_to_data_set(kat, tlist_part)
                # end for
        # end for
        
        return self.status
    # end def
    def add_tlist_to_data_set(self,kat,tlist):
        '''
        
        :param kat:
        :param tlist:
        :return: self.add_tlist_to_data_set(kat, tlist)
        '''
        
        if kat in self.kat_data_obj_dict.keys():
            self.kat_data_obj_dict[kat].add_data_set(tlist)
        elif len(kat) == 0:
            kat = "leer"
            self.kat_data_obj_dict[kat].add_data_set(tlist)
        else:
            self.status = hdef.NOT_OKAY
            self.errtext = f"add_tlist_to_data_set: Die Kategorie {kat = } ist nicht angelegt als DatenSatz"
        # end if

        if self.kat_data_obj_dict[kat].status != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = f"add_tlist_to_data_set: Fehler bei {kat = } \n{self.kat_data_obj_dict[kat].errtext}"
            self.kat_data_obj_dict[kat].reset_status()
        # end if
        return
    # end def
    def run_auswert(self):
        '''
        
        :return:
        '''
        for kat in self.kat_data_obj_dict.keys():
            self.kat_data_obj_dict[kat].run_auswert()
        # end for
        
        self.run_auswert_summe_gruppe()
        self.run_auswert_summe_zusammfass()

        return
    # end def
    def run_auswert_summe_gruppe(self):
        '''
        
        :return:
        '''
        grup_liste = self.katfunc.get_grup_list()
        
        for grup in grup_liste:
            
            self.group_data_obj_dict[grup] = GroupDataClass(grup)
            
            for kat in self.kat_data_obj_dict.keys():
                if grup == self.kat_data_obj_dict[kat].get_group():
                    
                    monats_summen_liste = self.kat_data_obj_dict[kat].get_monats_summen_liste()
                    self.group_data_obj_dict[grup].add_monat_summen_liste(monats_summen_liste)
                # end if
            # end for
        # end for
        return
    def run_auswert_summe_zusammfass(self):
        
        grup_zusam_dict = self.katfunc.get_grup_zusam_dict()
        
        for zusammfass in grup_zusam_dict.keys():
            self.zusammfass_data_obj_dict[zusammfass] = ZusammfassDataClass(zusammfass)
            
            for group in grup_zusam_dict[zusammfass]:
                if group in self.group_data_obj_dict.keys():
                    monats_summen_liste = self.group_data_obj_dict[group].get_summe_monat_liste()
                    self.zusammfass_data_obj_dict[zusammfass].add_monat_summen_liste(monats_summen_liste)
                # end if
            # end for
        
        # end for
        return
    # end def
    def get_auswert_ueberblick(self):
        '''
        
        :return: (ttable,index_ttable) = obj.get_auswert_ueberblick()
        '''
    
        # Header
        header_liste = ["kategorie","type","gruppe",
                        "Jan","Feb","Mrz","Apr","Mai","Jun",
                        "Jul","Aug","Sep","Okt","Nov","Dez",
                        str(self.jahr)]
        # Type
        type_liste = ["str","str","str",
                      "str", "str", "str", "str", "str", "str",
                      "str", "str", "str", "str", "str", "str",
                      "str"]
        
        type_index_liste = ["int" for type in type_liste]
        
        # Bilde Data Block
        group_liste = self.katfunc.get_grup_list()
        
        table = []
        table_color_index = []
        
        for i,group in enumerate(group_liste):
            
            katliste = self.katfunc.get_kat_list_von_grup(group)
            # zeit_str_liste = self.katfunc.get_zeit_str_von_kat_list(katliste)
            for kat in katliste:
                
                val_liste   =  self.kat_data_obj_dict[kat].get_kat_zeit_str_group_liste()    # [kat,zeit_str_liste[i],group]
                index_liste =  [-1,-1,i]
                val_liste += self.kat_data_obj_dict[kat].get_sumwert_monat_liste("euroStrK")
                index_liste += [-1 for i in range(12)]
                val_liste += [self.kat_data_obj_dict[kat].get_sumwert_jahr("euroStrK")]
                index_liste += [i]

                table.append(val_liste)
                table_color_index.append(index_liste)
                
            
            # end for
        # end for
        
        if "leer" in self.kat_data_obj_dict.keys():
            kat = "leer"
            val_liste = self.kat_data_obj_dict[kat].get_kat_zeit_str_group_liste()  # [kat,zeit_str_liste[i],group]
            index_liste = [-1, -1, len(group_liste)]
            val_liste += self.kat_data_obj_dict[kat].get_sumwert_monat_liste("euroStrK")
            index_liste += [-1 for i in range(12)]
            val_liste += [self.kat_data_obj_dict[kat].get_sumwert_jahr("euroStrK")]
            index_liste += [len(group_liste)]
            
            table.append(val_liste)
            table_color_index.append(index_liste)
        # end if
        

        
        # Summe der Gruppen und Zusammenfassung
        #--------------------------------------
        grup_zusam_dict = self.katfunc.get_grup_zusam_dict()
        
        for zusammfass in grup_zusam_dict.keys():
            
            # Zwischen zeile
            val_liste = ["" for s in header_liste]
            table.append(val_liste)
            index_liste = [-1 for s in header_liste]
            table_color_index.append(index_liste)
            
            for group in grup_zusam_dict[zusammfass]:
                
                index = group_liste.index(group)
                
                val_liste = [zusammfass,"summe",group]
                index_liste = [-1, -1, index]
                val_liste += self.group_data_obj_dict[group].get_sumwert_monat_liste("euroStrK")
                index_liste += [index for i in range(12)]
                val_liste += [self.group_data_obj_dict[group].get_sumwert_jahr("euroStrK")]
                index_liste += [index]
                
                table.append(val_liste)
                table_color_index.append(index_liste)
            # end for
            
            # Summe über  die Zusammenfassung
            if len(grup_zusam_dict[zusammfass]) > 1:
                
                val_liste = [zusammfass,"","summe"]
                val_liste += self.zusammfass_data_obj_dict[zusammfass].get_sumwert_monat_liste("euroStrK")
                val_liste += [self.zusammfass_data_obj_dict[zusammfass].get_sumwert_jahr("euroStrK")]
                index_liste = [-1 for s in header_liste]

                table.append(val_liste)
                table_color_index.append(index_liste)
        # end for

        return (htvar.build_table(header_liste,table,type_liste),htvar.build_table(header_liste,table_color_index,type_index_liste))
    # end def
    def get_auswert_einzel_liste(self):
        '''
        
        :return: ttable_einzel_liste = obj.get_auswert_einzel_liste() ttable = ttable_einzel_liste[i]
        '''
        
        # Header
        header_liste = [self.par.KONTO_NAME,self.par.KONTO_DATA_NAME_WER,
                        self.par.KONTO_DATA_NAME_COMMENT,self.par.KONTO_DATA_NAME_BUCHDATUM,
                        self.par.KONTO_DATA_NAME_WERT]
        
        # Type
        type_liste = ["str","str","str","datStrP","euroStrK"]
        
        type_index_liste = ["int" for type in type_liste]

        ttable_liste = []
        ttable_color_index_liste = []
        
        kat_liste    = list(self.kat_data_obj_dict.keys())
        for kat in kat_liste:
            
            (ttable,month_list) = self.kat_data_obj_dict[kat].get_ttable_and_month_list(header_liste,type_liste,self.par.KONTO_DATA_NAME_BUCHDATUM)
            
            if self.kat_data_obj_dict[kat].status != hdef.OKAY:
                self.status = self.kat_data_obj_dict[kat].status
                self.errtext = self.kat_data_obj_dict[kat].errtext
                self.kat_data_obj_dict[kat].reset_status()
                return []
            # end if
            
            ttable_color_index = htvar.build_table_default_value(header_liste,-1,ttable.ntable,type_index_liste)

            section_list = self.build_section_liste(month_list)
            for section in section_list:
                
                month = month_list[section[0]]
                iinsert = section[1]+1
                
                wert = self.kat_data_obj_dict[kat].get_sumwert_monat(month, "euroStrK")
                
                vals = ["Summe","","","",wert]
                
                tlist = htvar.build_list(header_liste,vals,type_liste)
                
                if self.kat_data_obj_dict[kat].is_sumwert_monat_gemittelt():
                    tlist.vals[3] = (htype.get_MonthName_from_MonthInt(1)
                                     + " - "
                                     + htype.get_MonthName_from_MonthInt(12))
                else:
                    tlist.vals[3] = htype.get_MonthName_from_MonthInt(month)
                # end if
                
                htvar.insert_list_to_table(ttable, tlist, iinsert)

                vals = [0, 0, 0, 0, 0]
                tlist = htvar.build_list(header_liste, vals, type_index_liste)
                ttable_color_index = htvar.insert_list_to_table(ttable_color_index, tlist, iinsert)

                
            # end for

            ttable_liste.append(ttable)
            ttable_color_index_liste.append(ttable_color_index)
        # end for
        
        return (kat_liste,ttable_liste,ttable_color_index_liste)
    # end def
    def build_section_liste(self,month_list):
        '''
        
        :param month_list:
        :return: section_list = self.build_section_liste(month_list)
        '''
        
        istart = 0
        section_list = []
        for index,month in enumerate(month_list):
            
            if month != month_list[istart]:
                iend = index - 1
                section_list.append((istart,iend))
                istart = index
            # end if
        # end for
        if len(month_list):
            iend = len(month_list)-1
            section_list.append((istart, iend))
        # end if
        
        return reversed(section_list)
        
# end class