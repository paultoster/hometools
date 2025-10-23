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
    def __init__(self,hkat_list,kat_dict,regel_dict):
        self.status = hdef.OK
        self.errtext = ""
        self.infotext = ""
        
        self.kat_list = []
        self.kat_hkat_index_list = []
        self.hkat_list = hkat_list
        
        self.set_kat_list(kat_dict)
        
        if  self.status != hdef.OKAY:
            return
        
        self.proof_regel(regel_dict)
        
        return
    # end def
    def proof_regel(self,regel_dict):
        '''
        
        :param regel_dict:
        :return:
        '''
        self.regel_dict = {}
        for rkat_name in regel_dict:
            
            if rkat_name not in self.kat_list:
                self.status = hdef.NOT_OKAY
                self.errtext = f"In regel_dict ist kategorie \"{rkat_name}\"  nicht kategorie_liste enthalten {self.kat_list =} "
                return
            # end if
            self.regel_dict[rkat_name] = regel_dict[rkat_name]
        # end for
    
    def set_kat_list(self,kat_dict):
        '''
        
        :param kat_dict:
        :return: self.set_kat_list(kat_dict)
        '''
        kat_list_org = self.kat_list
        kat_hkat_index_list_org = self.kat_hkat_index_list
        hkat_list_org = self.hkat_list

        
        # Prüfen ob hkey in jeder Kategorie vorhanden ist und
        # ob die Hauptkategorie in hkat_list existiert
        hkey = "haupt"
        for kat in kat_dict.keys():
            
            # hkey nicht in kategorie-dict
            if hkey not in kat_dict[kat].keys():
                self.status = hdef.NOT_OKAY
                self.errtext = f"dict mit Kategorie: \"{kat}\" hat kein key \"{hkey}\" "
                return
            # end if
            
            # Hauptkategorie nicht in hkat_list:
            if kat_dict[kat][hkey] not in self.hkat_list:
                self.hkat_list.append(kat_dict[kat][hkey])
            # end if
            
            if kat in self.kat_list:
                index = self.kat_list.index(kat)
                self.kat_hkat_index_list[index] = self.hkat_list.index(kat_dict[kat][hkey])
            else:
                self.kat_list.append(kat)
                self.kat_hkat_index_list.append(self.hkat_list.index(kat_dict[kat][hkey]))
        # end for
        
        # prüfen, ob etwas weg muss
        flagrun = True
        while(flagrun):
            flagrun = False
            for i,kat in enumerate(self.kat_list):
                
                if kat not in kat_dict.keys():
                    del self.kat_list[i]
                    del self.kat_hkat_index_list[i]
                    flagrun = True
                    break
                # end if
            # end for
        # end while
        
        # prüfe Regeln
        self.proof_regel(self.regel_dict)
        
        # Zurücksetzen bei Fehler
        if self.status != hdef.OKAY:
            self.kat_list = kat_list_org
            self.kat_hkat_index_list = kat_hkat_index_list_org
            self.hkat_list = hkat_list_org
        
        return
    #end def
    def get_hkat_list(self):
        return self.hkat_list
    def set_hkat_list(self,hkat_list):
        
        hkat_list_mod = hkat_list
        hkey = "haupt"
        self.infotext = ""
        for i,kat in enumerate(self.kat_list):
            
            index = self.kat_hkat_index_list[i]
            hkat  = self.hkat_list[index]
            
            # Hauptkategorie nicht in hkat_list:
            if hkat not in hkat_list_mod:
                if len(self.infotext) == 0:
                    self.infotext = "In modifizierte Hauptkategorie-Liste fehlen Namen, die noch inder kategorie stehen:"
                # endif
                self.infotext += f"\n In Katgegorie \"{kat =}\" wird die Hauptkategorie \"{hkat =}\" benutzt"
                
                hkat_list_mod.append(hkat)
            # end if
            
            self.kat_hkat_index_list[i] = hkat_list_mod.index(hkat)

        # end for
        self.hkat_list = hkat_list_mod
        
    def get_kat_dict(self):
        kat_dict = {}
        for i,kat in enumerate(self.kat_list):
            index = self.kat_hkat_index_list[i]
            kat_dict[kat] = {"haupt":self.hkat_list[index]}
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
        
    def get_regel_dict(self):
        return self.regel_dict
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
        kat   = None
        
        # loop over all regel-sätze
        for rkat_name,rdict in self.regel_dict.items():
            
            # Anzahl zu prüfenden Kategorien
            nregel = len(rdict.keys())
            
            # Prüfe jeden header der regel
            for header in rdict.keys():
                
                # Suche header in Liste
                index = hlist.find_first_value_in_list(tlist.names,header)
                
                # Wenn in Liste enthalten
                if index != None:
                    
                    # Suche Inhalt der regel in dem data set
                    ind = hstr.such(tlist.vals[index],rdict[header],"vs")
                    
                    # Wenn entahlten
                    if ind >= 0:
                        
                        # Zähle die Anzhl der Regeln runter
                        nregel -= 1
                    # end if
                # end if
            # end for
            
            # Wenn Anzahl der Regeln runter gezählt ist (aller Inhalt der Regel ist enthalten)
            if nregel == 0:
                
                # Kategorie und found übergeben
                kat = rkat_name
                found = True
                break
            # end if
        # end for
        
        return (found,kat)
        