"""

Bearbeitet Kategorien für Konto

"""

import os, sys

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif


import tools.hfkt_def as hdef
# import tools.hfkt_type as htype
# import tools.hfkt_tvar as htvar
import tools.hfkt_list as hlist
import tools.hfkt_str as hstr



class KategorieClass:
    '''
    obj = KategorieClass(hkat_list,kat_dict,regel_list,kat_name)

        :param hkat_list:  Liste Hauptkategorie
        :param kat_dict:   Dict Kategorie mit "haupt":hkat_list[i]
        :param regel_list: Regel list mit  dict of header z.B.
                           {"wer": "ARNDT","comment": "MIETE MARTINSTR. 64","kategorie":"miete"}
    Funktionen:
    hkat_list = obj.get_hkat_list()
    kat_dict = obj.get_kat_dict()
    regel_list = obj.get_regel_list()
    
    obj.reset_status()
    
    (found,kat) = obj.regel_anwedung_data_set(tlist)
    
    '''
    def __init__(self,gruppen_dict,hkat_dict,kat_dict,regel_list):
        self.status = hdef.OK
        self.errtext = ""
        self.infotext = ""
        
        self.kat_name = "kategorie"
        self.gruppen_list = []
        self.gruppen_zeit_list = []
        self.hkat_list = []
        self.hkat_grup_index_list = []
        self.kat_list = []
        self.kat_hkat_index_list = []
        self.regel_list  = regel_list
        
        self.set_grup_list(gruppen_dict)
        self.set_hkat_list(hkat_dict)
        self.set_kat_list(kat_dict)
        # prüfe Regeln
        self.proof_regel(self.regel_list)

        if  self.status != hdef.OKAY:
            return
        
        return
    # end def
    def set_grup_list(self,gruppen_dict):
        '''
        
        :param gruppen_dict:
        :return:
        '''
        self.gruppen_list = list(gruppen_dict.keys())
        self.gruppen_zeit_list = list(gruppen_dict.values())
        
        for i,num in enumerate(self.gruppen_zeit_list):
            try:
                self.gruppen_zeit_list[i] = int(num)
            except:
                self.gruppen_zeit_list[i] = 1
            # end if
        # end for
        return
    # end def
    def set_hkat_list(self, hkat_dict):
        '''

        :param hkat_dict:
        :return: self.set_hkat_list(hkat_dict)
        '''
        
        # Prüfen ob hkey in jeder Hauptkategorie vorhanden eine gruppe hat
        self.hkat_list = []
        self.hkat_grup_index_list = []
        for key in hkat_dict.keys():
            
            self.hkat_list.append(key)
            self.hkat_grup_index_list.append(self.proof_and_get_gruppen_index(hkat_dict[key]))
        # end for
        
        return
    
    # end def
    def proof_and_get_gruppen_index(self,grup):
        if grup not in self.gruppen_list:
            self.gruppen_list.append(grup)
            self.gruppen_zeit_list.append(1)
        # end if
        return self.gruppen_list.index(grup)
    # end def
    def set_kat_list(self, kat_dict):
        '''

        :param hkat_dict:
        :return: self.set_kat_list(kat_dict)
        '''
        
        # Prüfen ob hkey in jeder Hauptkategorie vorhanden eine gruppe hat
        self.kat_list = []
        self.kat_hkat_index_list = []
        for key in kat_dict.keys():
            
            # Hauptkategorie nicht in gruppen_dict:
            if kat_dict[key] not in self.hkat_list:
                self.hkat_list.append(kat_dict[key])
                self.hkat_grup_index_list.append(self.proof_and_gruppen_index(kat_dict[key]))
            # end if
            
            self.kat_list.append(key)
            self.kat_hkat_index_list.append(self.hkat_list.index(kat_dict[key]))
        # end for
        
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
        return self.gruppen_list
    def get_grup_dict(self):
        grup_dict = {}
        for i,grup in enumerate(self.gruppen_list):
            grup_dict[grup] = self.gruppen_zeit_list[i]
        # end for
        return grup_dict
    def get_hkat_list(self):
        return self.hkat_list
    def get_hkat_dict(self):
        hkat_dict = {}
        for i,hkat in enumerate(self.hkat_list):
            index = self.hkat_grup_index_list[i]
            hkat_dict[hkat] = self.gruppen_list[index]
        # end for
        return hkat_dict
    # def set_hkat_list(self,hkat_list):
    #
    #     hkat_list_mod = hkat_list
    #     hkey = "haupt"
    #     self.infotext = ""
    #     for i,kat in enumerate(self.kat_list):
    #
    #         index = self.kat_hkat_index_list[i]
    #         hkat  = self.hkat_list[index]
    #
    #         # Hauptkategorie nicht in hkat_list:
    #         if hkat not in hkat_list_mod:
    #             if len(self.infotext) == 0:
    #                 self.infotext = "In modifizierte Hauptkategorie-Liste fehlen Namen, die noch inder kategorie stehen:"
    #             # endif
    #             self.infotext += f"\n In Katgegorie \"{kat =}\" wird die Hauptkategorie \"{hkat =}\" benutzt"
    #
    #             hkat_list_mod.append(hkat)
    #         # end if
    #
    #         self.kat_hkat_index_list[i] = hkat_list_mod.index(hkat)
    #
    #     # end for
    #     self.hkat_list = hkat_list_mod
    # # end def
    def get_kat_list(self):
        '''
        
        :return: kat_liste = self.get_kat_list()
        '''
        return self.kat_list
    # end def
    def get_kat_dict(self):
        kat_dict = {}
        for i,kat in enumerate(self.kat_list):
            index = self.kat_hkat_index_list[i]
            kat_dict[kat] = self.hkat_list[index]
        # end for
        return kat_dict
    # end def
    def set_kat_dict(self,kat_dict):
        '''
        
        :param kat_dict:
        :return:
        '''
        self.set_kat_list(kat_dict)
        return
        
    def get_regel_list(self):
        return self.regel_list
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
    def reset_status(self):
        self.status = hdef.OKAY
        self.errtext = ""
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
                        
                            # Suche Inhalt der regel in dem data set
                            ind = hstr.such(tlist.vals[index],rdict[header],"vs")
                        
                            # Wenn entahlten
                            if ind >= 0:
                            
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
        