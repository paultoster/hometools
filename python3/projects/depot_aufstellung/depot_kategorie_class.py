"""

Bearbeitet Kategorien für Konto

"""

import os, sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif


import tools.hfkt_def as hdef
import tools.hfkt_type as htype
# import tools.hfkt_tvar as htvar
import tools.hfkt_list as hlist
import tools.hfkt_str as hstr



class KategorieClass:
    '''
    obj = KategorieClass(grup_dict,kat_dict,regel_list)

        :param grup_dict:  Liste Gruppenkategorie {"gruppe":zeit, ...}
        :param kat_dict:   Dict Kategorie mit {"verbrauch":gruppe, ...}
        :param regel_list: Regel list mit  dict of header z.B.
                           {"wer": "ARNDT","comment": "MIETE MARTINSTR. 64","kategorie":"miete"}
    Funktionen:
    obj.reset_status()                   resetet Status und Text
    obj,add_kat_grup_zeit(kat,grup,zeit)
    obj.add_dicts(grup_dict,kat_dict,regel_list) Setzt geänderte Dict, siehe  status für fehler
    
    obj.set_grup_list(grup_dict)         setzt von dict in zwei Listen um self.grup_list, self.grup_zeit_list
    obj.set_kat_list(kat_dict)           setzt von dict in zweiListen um self.kat_list self.kat_grup_index_list
    obj.proof_regel(regel_list)          prüft die regel-liste mit den jeweiligen dict einträgen, siehe status
    obj.set_regel_list(regel_list)       das gleiche
    
    grup_list = obj.get_grup_list()
    grup_dict = obj.get_grup_dict()
    kat_list  = obj.get_kat_list()
    katliste = obj.get_kat_list_von_grup(group)
    zeit_str_liste = obj.get_zeit_str_von_kat_list(katliste)
    regel_list = obj.get_regel_list()
    (gruppe,zeit) = obj.get_grup_type_from_kat(kategorie)
    
    obj.add_regel_dict(regel_dict)
    obj.regel_anwedung_data_set(tlist)   Wendet Regel set auf eine Datenzeile aus Tabelle an, überschreibt kategorie Eintrag
    
    flag = obj.is_kat_set(kat)           Prüft, ob es die Kategorie gibt
    
    
    obj.reset_status()
    
    (found,kat) = obj.regel_anwedung_data_set(tlist)
    
    '''
    def __init__(self,kat_dict_list,regel_list,tausch_kategorie_dict,grup_zusam_llist):
        self.status = hdef.OK
        self.errtext = ""
        self.infotext = ""
        
        self.kat_name = "kategorie"
        self.grup_name = "gruppe"
        self.zeit_name = "zeit"
        
        self.TYPE_MONAT = 1
        self.TYPE_JAHR  = 12
        
        # self.type_str_monat = 'm'
        # self.type_str_jahr = 'j'

        self.kat_separator = ";"
        self.kat_val_separator = ":"
        self.kat_empty = "empty"
        
        self.grup_list = []
        self.kat_zeit_list = []
        self.kat_list = []
        self.kat_grup_index_list = []
        self.regel_list  = []
        self.tausch_kategorie_dict = tausch_kategorie_dict
        
        (kat_dict_list,regel_list) = self.tausche_kategorie(kat_dict_list,regel_list)
        
        

        self.set_dicts(kat_dict_list,regel_list)
        
        self.grup_zusam_llist = self.proof_grup_zusam_llist(grup_zusam_llist)

        if  self.status != hdef.OKAY:
            return
        
        return
    # end def
    def reset_status(self):
        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""
    
    # end def
    def tausche_kategorie(self,kat_list,regel_list):
        '''
        
        :param kat_list:
        :param regel_list:
        :return: (kat_list,regel_list) = self.tausche_kategorie(kat_list,regel_list)
        '''
        kat_list_out = []
        for katdict in kat_list:
            kat_dict_out = katdict
            if self.kat_name in katdict.keys():
                if katdict[self.kat_name] in self.tausch_kategorie_dict.keys():
                    kat_dict_out[self.kat_name] = self.tausch_kategorie_dict[katdict[self.kat_name]]
                # end if
            # end if
            kat_list_out.append(kat_dict_out)
        # end for
        
        regel_list_out = []
        for regel_dict in regel_list:
            if self.kat_name in regel_dict.keys():
                if regel_dict[self.kat_name] in self.tausch_kategorie_dict.keys():
                    regel_dict[self.kat_name] = self.tausch_kategorie_dict[regel_dict[self.kat_name]]
                # end if
            # end if
            regel_list_out.append(regel_dict)
        # end for
        
        return (kat_list_out,regel_list_out)
    # end def
    def get_tausch_kategorie(self,kat_old):
        '''
        
        :param kat_old:
        :return: tausch_kat = self.katfunc.get_tausch_kategorie(kat_old)
        '''
        
        if kat_old in self.tausch_kategorie_dict.keys():
            kat_new = self.tausch_kategorie_dict[kat_old]
        else:
            kat_new = self.kat_empty
        # end if
        
        return kat_new
    # end def
    def set_dicts(self,kat_dict_list,regel_list):
        '''
        
        :param grup_dict:
        :param kat_dict:
        :param regel_list:
        :return:
        '''
        
        
        grup_list_inter           = self.grup_list
        kat_zeit_list_inter       = self.kat_zeit_list
        kat_list_inter            = self.kat_list
        kat_grup_index_list_inter = self.kat_grup_index_list
        regel_list_inter          = self.regel_list
        
        self.grup_list = []
        self.kat_list = []
        self.kat_zeit_list = []
        self.kat_grup_index_list = []

        for i,katdict in enumerate(kat_dict_list):
            
            # proof
            for key in [self.kat_name,self.grup_name,self.zeit_name]:
                if key not in katdict.keys():
                    self.status  = hdef.NOT_OKAY
                    self.errtext = f" kat_name: key: {key} is not in kat_dict_list with index {i} in kategorie-Files"
                    break
                # end if
            # end for
            
            self.add_kat_grup_zeit(katdict[self.kat_name],katdict[self.grup_name],katdict[self.zeit_name])
            
        # end for
        
        self.regel_list  = regel_list
        self.proof_regel(self.regel_list)
        
        if  self.status != hdef.OKAY:
            self.grup_list = grup_list_inter
            self.kat_zeit_list = kat_zeit_list_inter
            self.kat_list = kat_list_inter
            self.kat_grup_index_list = kat_grup_index_list_inter
            self.regel_list = regel_list_inter
    
    def proof_grup_zusam_llist(self,grup_zusam_llist):
        '''
        
        :param grup_zusam_llist:
        :return: grup_zusam_llist = self.proof_grup_zusam_llist(grup_zusam_llist)
        '''
        grup_zusam_llist_out = []
        for liste in grup_zusam_llist:
            grup_zusam_list_out = []
            for group in liste:
                if group in self.grup_list:
                    grup_zusam_list_out.append(group)
                # end if
            # end for
            grup_zusam_llist_out.append(grup_zusam_list_out)
        # end for
        
        return grup_zusam_llist_out
    # end def
    # def set_grup_list(self,grup_dict):
    #     '''
    #
    #     :param grup_dict:
    #     :return:
    #     '''
    #     self.grup_list = list(grup_dict.keys())
    #     self.grup_zeit_list = list(grup_dict.values())
    #
    #     for i,num in enumerate(self.grup_zeit_list):
    #         try:
    #             self.grup_zeit_list[i] = int(num)
    #         except:
    #             self.grup_zeit_list[i] = 1
    #         # end if
    #     # end for
    #     return
    # # end def
    # def proof_and_get_grup_index(self,grup):
    #     if grup not in self.grup_list:
    #         self.grup_list.append(grup)
    #         self.grup_zeit_list.append(1)
    #     # end if
    #     return self.grup_list.index(grup)
    # # end def
    def add_kat_grup_zeit(self,kat,grup,zeit):
        '''

        :param kat:
        :param grup:
        :param zeit:
        :return: self.add_kat_grup_zeit(kat,grup,zeit)
        '''
        if zeit not in [self.TYPE_MONAT, self.TYPE_JAHR]:
            self.status = hdef.NOT_OKAY
            self.errtext = f"add_kat_grup_zeit  {zeit = } ist nicht {self.TYPE_MONAT = } oder {self.TYPE_JAHR = }"
        # end if
        
        if kat not in self.kat_list:
            self.kat_list.append(kat)
            self.kat_zeit_list.append(zeit)

            if grup not in self.grup_list:
                self.grup_list.append(grup)
            
            self.kat_grup_index_list.append(self.grup_list.index(grup))
        else:
            self.status = hdef.NOT_OKAY
            self.errtext = f"add_kat_grup_zeit: Kategorie: {kat} ist bereits in kat_list: {self.kat_list}"
        # end if
        return
    # end def
    def proof_regel(self,regel_list):
        '''
        
        :param regel_list:
        :return:
        '''
        self.regel_list = []
        for i,reg_dict in enumerate(regel_list):
            
            if self.kat_name not in reg_dict.keys():
                self.status = hdef.NOT_OKAY
                self.errtext = f"In regel_list[{i}] ist key: \"{self.kat_name}\"  nicht enthalten !!!"
                return
            # end if
            if reg_dict[self.kat_name] not in self.kat_list:
                self.status = hdef.NOT_OKAY
                self.errtext = f"In regel_list[{i}] ist kategorie: \"{reg_dict[self.kat_name]}\"  nicht kategorie_liste enthalten {self.kat_list =} "
                return
            # end if
            self.regel_list.append(reg_dict)
        # end for
        return
    # end def
    def get_grup_list(self):
        return self.grup_list
    # def get_grup_dict(self):
    #     grup_dict = {}
    #     for i,grup in enumerate(self.grup_list):
    #         grup_dict[grup] = self.grup_zeit_list[i]
    #     # end for
    #     return grup_dict
    def get_kat_list(self):
        '''
        
        :return: kat_liste = self.get_kat_list()
        '''
        return self.kat_list
    # end def
    def get_kat_list_von_grup(self,grup):
        '''
        
        :param grup:
        :return: katliste = obj.get_kat_list_von_grup(group)
        '''
        
        kat_list = []
        for i,kat in enumerate(self.kat_list):
            if self.grup_list[self.kat_grup_index_list[i]] == grup:
                kat_list.append(kat)
            # end if
        # end for
        
        return kat_list
    # end def
    # def get_zeit_str_von_kat_list(self,katliste):
    #     '''
    #
    #     :param katliste:
    #     :return: zeit_str_liste = obj.get_zeit_str_von_kat_list(katliste)
    #     '''
    #
    #     zeit_str_liste = []
    #     for kat in katliste:
    #         if kat in self.kat_list:
    #             zeit = self.kat_zeit_list[self.kat_list.index(kat)]
    #             if zeit == self.TYPE_MONAT:
    #                 zeit_str_liste.append(self.type_str_monat)
    #             else:
    #                 zeit_str_liste.append(self.type_str_jahr)
    #             # end if
    #         # end if
    #     # end for
    #     return zeit_str_liste
    #
    # def get_kat_dict(self):
    #     kat_dict = {}
    #     for i,kat in enumerate(self.kat_list):
    #         index = self.kat_grup_index_list[i]
    #         kat_dict[kat] = self.grup_list[index]
    #     # end for
    #     return kat_dict
    # # end def
    # def set_kat_dict(self,kat_dict):
    #     '''
    #
    #     :param kat_dict:
    #     :return:
    #     '''
    #     self.set_kat_list(kat_dict)
    #     return
    #
    def get_kat_dict_list(self):
        '''
        
        :return: kat_dict_list = obj.get_kat_dict_list()
        '''
        kat_dict_list = []
        
        for i,kat in enumerate(self.kat_list):
            
            katdict = {}
            katdict[self.kat_name] = kat
            katdict[self.grup_name] = self.grup_list[self.kat_grup_index_list[i]]
            katdict[self.zeit_name] = self.kat_zeit_list[i]
            
            kat_dict_list.append(katdict)
        # end for
        
        return kat_dict_list
    # end def
    def get_regel_list(self):
        return self.regel_list
    # end def
    def get_grup_type_from_kat(self,kat):
        '''
        
        :param kategorie:
        :return: (gruppe, zeit) = get_grup_type_from_kat(kategorie)
        '''
        if kat in self.kat_list:
            i = self.kat_list.index(kat)
            index  = self.kat_grup_index_list[i]
            
            gruppe = self.grup_list[index]
            zeit   = self.kat_zeit_list[i]
            return (gruppe, zeit)
        #end if
        return (None,None)
    # end def
    def set_regel_list(self,regel_list):
        '''
        
        :param regel_liste_mod:
        :return:
        '''
        
        self.proof_regel(regel_list)
        return
    # end def
    def add_regel_dict(self,regel_dict):
        '''
        
        :param regel_dict:
        :return:
        '''
        if self.kat_name not in regel_dict.keys():
            self.status = hdef.NOT_OKAY
            self.errtext = f"In regel_dict ist key \"{self.kat_name}\"  nicht  enthalten  "
            return
        
        if regel_dict[self.kat_name] not in self.kat_list:
            self.status = hdef.NOT_OKAY
            self.errtext = f"In regel_dict ist \"{self.kat_name}\" =  \"{regel_dict[self.kat_name]}\"  nicht kategorie_liste enthalten {self.kat_list =} "
            return
        
        self.regel_list.append(regel_dict)
        return
    # end def
    def regel_anwedung_data_set(self,tlist):
        '''
        
        :param tlist:
        :return: (found, kat) = obj.regel_anwedung_data_set(tlist)
        '''
        found = False
        kategorie   = None
        
        # loop over all regel-sätze
        for rdict in self.regel_list:
            
            kategorie = rdict[self.kat_name]
            
            # Anzahl zu prüfenden Kategorien
            nregel = len(rdict.keys())-1
            
            if nregel > 0:
                # Prüfe jeden header der regel
                for header in rdict.keys():
                    
                    if header != self.kat_name:
                    
                        # Suche header in Liste
                        index = hlist.find_first_value_in_list(tlist.names,header)
                    
                        # Wenn in Liste enthalten
                        if index != None:
                            found = False
                            if isinstance(rdict[header],list):
                                found = False
                                for val in rdict[header]:
                                    ind = hstr.such(tlist.vals[index], val, "vs")
                                    
                                    if ind >= 0:
                                        found = True
                                        break
                                    # end if
                                # end for
                            elif isinstance(rdict[header],str):
                                # Suche Inhalt der regel in dem data set
                                ind = hstr.such(tlist.vals[index],rdict[header],"vs")
                        
                                # Wenn entahlten
                                if ind >= 0:
                                    found = True
                                # end if
                            # end if
                            if found:
                                # Zähle die Anzahl der Regeln runter
                                nregel -= 1
                            # end if
                        # end if
                    # end for
                
                # Wenn Anzahl der Regeln runter gezählt ist (aller Inhalt der Regel ist enthalten)
                if nregel == 0:
                    
                    # Kategorie und found übergeben
                    found = True
                    break
                # end if
            # end if
        # end for
        
        return (found,kategorie)
    # end def
    def is_katval_set_and_correct(self,katval,wert):
        '''
        
        :param kat:
        :return: True/False
        '''
        
        if len(katval) == 0: # leer gleich keine kategorie
            return (True,katval)
        else:
            katdict = self.build_katdict(katval,wert)
            
            if katdict == None:
                return (False,katval)
            # end if
            
            n = len(katdict.keys())
            for kat in katdict.keys():
                if (kat == self.kat_empty) and (len(katdict.keys()) == 1):  # Wenn empty und nur ein item
                        return (True,katval)
                elif kat in self.kat_list:
                    n -= 1
                # end if
            # end for
            
            if n == 0:
                katval = self.build_katval(katdict)
                return (True,katval)
            # end if
        # end if
        return (False,katval)
    # end def
    def build_katdict(self,katval,wert_cent):
        '''
        
        :param katval: Kategorie und Euro Anteil
                        Beispiele
                        "transport"  eine Kategorie fertig
                        "transport,kauf" zwei Kategorie zu jeweils der Hälfte
                        "transport:10,41,kauf" zwei Kategorie 10,41 € für Transport Rest kauf
                        "transport:10,41,kauf:2,0,sonst" zwei Kategorie 10,41 € für Transport und 2 € für Kauf Rest sonst
        :param wert_cent:
        :return: katdict = self.build_katdict(katval, wert_cent) katdict = {kat1:wert1_cent,kat2:wert2_cent}
        '''
        
        liste = katval.split(self.kat_separator)
        
        kat_list = []
        wert_list = []
        for index,item in enumerate(liste):
            nlist = item.split(self.kat_val_separator)
            
            if len(nlist) == 1:  # nur katergorie z.B. "transport" steht da
                kat_list.append(nlist[0])
                wert_list.append(0)
            elif len(nlist) > 1: # katergorie und wert z.B. "transport:20,48" steht da
                kat_list.append(nlist[0])
                (okay,wert) = htype.type_transform(nlist[1],"euroStrK", "cent")
                # Immer positive
                if wert < 0:
                    wert *= -1
                # end if
                if okay != hdef.OKAY:
                    self.status = hdef.NOT_OKAY
                    self.errtext = f"Aus Kategoriewert: \"{katval}\" kann an der Stelle {index =} der Eurowert: {nlist[1]} nicht in cent gewandelt werden"
                    return None
                # end if
                wert_list.append(wert)
            # end if
        # end for
        
        # Wertliste überprüfen
        summe = 0
        n_ohne_wert = 0
        for wert in wert_list:
            if wert == 0:
                n_ohne_wert += 1
            else:
                summe += wert
            # end if
        # end for
        
        # Immer positiv
        if wert_cent >= 0:
            gesamt_wert = wert_cent
        else:
            gesamt_wert = -wert_cent
        # end
        
        # Summe zu groß
        if summe > gesamt_wert:
            self.status = hdef.NOT_OKAY
            self.errtext = f"Aus Kategoriewert: \"{katval}\" ist der Summenwert {summe =} größer als der wert: {gesamt_wert =}"
            return None
        # end if
        else:
            # Differenz
            diff = gesamt_wert - summe
            index_list = []
            if n_ohne_wert > 0:
            
                delta = int(diff/n_ohne_wert)
            
                for index,wert in enumerate(wert_list):
                    if wert == 0:
                        wert_list[index] = delta
                        index_list.append(index)
                    # end if
                # end for
            elif diff != 0:
                self.status = hdef.NOT_OKAY
                self.errtext = f"Aus Kategoriewert: \"{katval}\"  die Differenz {diff =} zwischen der Summenwert {summe =} und wert: {gesamt_wert =} kann nicht verteilt werden"
                return None
            # end if
        # end if

        # Rundungsfehler einfach addieret
        summe = 0
        for wert in wert_list:
            summe += wert
        # end for
        
        diff = gesamt_wert - summe
        if diff != 0:
            if len(index_list) > 0:
                wert_list[index_list[0]] += diff
            else:
                wert_list[0] += diff
            # end if
        # end if
        
        katdict = {}
        for index,kat in enumerate(kat_list):
            
            if len(kat) == 0:
                katdict[self.kat_empty] = wert_list[index]
            else:
                katdict[kat] = wert_list[index]
            # end if
        # endfor
        
        return katdict
    # end def
    def build_katval(self,katdict):
        '''
        
        :param self:
        :param katdict:
        :return: katval = self.katfunc.build_katval(katdict)
        '''
    
        katval = ""
        
        n = len(katdict.keys())
        for index,kat in enumerate(katdict.keys()):
            
            if kat != self.kat_empty:
                
                if index > 0:
                    katval += self.kat_separator
                # end if
                
                katval += kat
                
                if n > 1:
                    (okay, wert) = htype.type_transform(katdict[kat], "cent","euroStrK")
                    if okay != hdef.OKAY:
                        raise Exception("Soll nicht vorkommen")
                    # end if
                    katval += self.kat_val_separator + wert
                # end if
            # end if
        # end ofr
        return katval
    # end def
        
        
        
        
        
        
        