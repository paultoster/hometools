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
        return self.sumwert_monat_liste
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
        
        (okay, sumwert_monat_mittel) = htype.type_transform(self.sumwert_monat_mittel, "cent", type_out)
        if okay != hdef.OKAY:
            raise Exception(
                f"get_sumwert_monat_liste:  Fehler transform self.sumwert_monat_mittel = <{self.sumwert_monat_mittel}> von type: <{"cent"}> in type {type_out} wandeln !!!!!!")
        # end if

        sumwert_monat_liste = []
        for i in range(12):
            
            if self.katzeit == self.TYPE_MONAT:
                (okay,wert) = htype.type_transform(self.sumwert_monat_liste[i],"cent",type_out)
                if okay != hdef.OKAY:
                    raise Exception(f"get_sumwert_monat_liste:  Fehler transform self.sumwert_monat_liste[{i}] = <{self.sumwert_monat_liste[i]}> von type: <{"cent"}> in type {type_out} wandeln !!!!!!")
                # end if
            else:
                wert = sumwert_monat_mittel
            # end if
            
            sumwert_monat_liste.append(wert)
            
        # end for
        
        return sumwert_monat_liste
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
        
        icol = htvar.get_index_from_table(ttable,self.par.KONTO_DATA_NAME_KATEGORIE)
        
        for irow in range(ttable.ntable):
            
            tlist = htvar.get_list_from_table(ttable,irow)
            
            self.add_tlist_to_data_set(tlist.vals[icol],tlist)
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
        
        :return: ttable = obj.get_auswert_ueberblick()
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
        
        # Bilde Data Block
        group_liste = self.katfunc.get_grup_list()
        
        table = []
        
        for group in group_liste:
            
            katliste = self.katfunc.get_kat_list_von_grup(group)
            # zeit_str_liste = self.katfunc.get_zeit_str_von_kat_list(katliste)
            for kat in katliste:
                
                val_liste =  self.kat_data_obj_dict[kat].get_kat_zeit_str_group_liste()    # [kat,zeit_str_liste[i],group]
                val_liste += self.kat_data_obj_dict[kat].get_sumwert_monat_liste("euroStrK")
                val_liste += [self.kat_data_obj_dict[kat].get_sumwert_jahr("euroStrK")]
                
                table.append(val_liste)
            
            # end for
        # end for
        
        if "leer" in self.kat_data_obj_dict.keys():
            kat = "leer"
            val_liste = self.kat_data_obj_dict[kat].get_kat_zeit_str_group_liste()  # [kat,zeit_str_liste[i],group]
            val_liste += self.kat_data_obj_dict[kat].get_sumwert_monat_liste("euroStrK")
            val_liste += [self.kat_data_obj_dict[kat].get_sumwert_jahr("euroStrK")]
            
            table.append(val_liste)
        # end if
        

        
        # Summe der Gruppen und Zusammenfassung
        #--------------------------------------
        grup_zusam_dict = self.katfunc.get_grup_zusam_dict()
        
        for zusammfass in grup_zusam_dict.keys():
            
            # Zwischen zeile
            val_liste = ["" for s in header_liste]
            table.append(val_liste)
            
            for group in grup_zusam_dict[zusammfass]:
                
                val_liste = [zusammfass,"summe",group]
                val_liste += self.group_data_obj_dict[group].get_sumwert_monat_liste("euroStrK")
                val_liste += [self.group_data_obj_dict[group].get_sumwert_jahr("euroStrK")]
                
                table.append(val_liste)
            # end for
            
            # Summe über  die Zusammenfassung
            if len(grup_zusam_dict[zusammfass]) > 1:
                
                val_liste = [zusammfass,"","summe"]
                val_liste += self.zusammfass_data_obj_dict[zusammfass].get_sumwert_monat_liste("euroStrK")
                val_liste += [self.zusammfass_data_obj_dict[zusammfass].get_sumwert_jahr("euroStrK")]
                
                table.append(val_liste)
        # end for

        return htvar.build_table(header_liste,table,type_liste)
    # end def
# end class