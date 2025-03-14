#
#
#
#
import os, sys
from dataclasses import dataclass, field
from typing import List

tools_path = os.getcwd() + "\\.."
if (tools_path not in sys.path):
  sys.path.append(tools_path)
# endif

# Hilfsfunktionen
import hfkt_def as hdef
import hfkt_type as htype
import hfkt_str as hstr
import sgui

I_IBAN = 0
I_BANK = 1
I_WER  = 2
I_COM  = 3

class iban_data:
    '''
    members:
    idmax              highest id number to be unique
    data_list          list of data_set = [iban,bank,wer,comment]
                       iban = data_set[I_IBAN]
                       bank = data_set[I_BANK]
                       wer = data_set[I_WER]
                       comment = data_set[I_COM]
    functions:
    (status,ertext) = self.add(iban,bank,comment)      add new iban
    (status,ertext) = self.add(iban,bank)
    found           = self.find(iban)                  find specific iban
    
    (status,ertext) = self.show()                      show in GUI
    
    '''
    idmax: int            = 0   #  id which is counted up for each data set for iban
    data_list: list       = [] # a list with iban dada
    item_list: List[str]  = ("iban", "bank", "wer", "comment")
    
    def add(self,iban,bank,wer,comment=""):
        '''
        add a new iban number into a data_set
        
        data_set = [iban,bank,wer,comment]
        
        :param iban:     IBAN-Nummer
        :param bank:     Welche Bank
        :param wer:      Wem gehört die IBAN
        :param comment:
        :return: (status,ertext)
        '''
        
        status  = hdef.OKAY
        errtext = ""
        
        # proof iban
        (okay, wert) = htype.hfkt_type_proof_iban(iban)
        if( okay != hdef.OKAY)
            status  = hdef.NOT_OKAY
            errtext = f"iban_data: error input iban = {iban} is not valid"
            return (status,errtext)
        # endif
        
        # proof if iban already in
        if( not self.find(iban) ):
            # build iban_data_set as list data_set = [iban,bank,wer,comment]
            # and add to data_list
            self.idmax += 1
            self.data_list.append([self.idmax,iban,wer,bank,comment])
        # endif
        
        return (status,errtext)
    # enddef
    
    def find(self,iban):
        """
        find iban number in data_list with data_set = [iban,bank,wer,comment]
        :param iban:
        :return:
        """
        found = False
        for data_set in self.data_list:
            if( iban == data_set[0]):
                found = True
                break
            # end if
        # end for
        return found
    # enddef
    
    
    
    def show(self):
        '''
        show data in gui and possibly correct in gui
        :return: (status,errtext)
        '''
        status = hdef.OKAY
        errtext = ""
        
        (d_new, indexAbfrage) = sgui.abfrage_tabelle(header_liste=self.item_list
                                                       ,data_set=self.data_list
                                                       , listeAbfrage=["okay","change","add"])
        
        if( indexAbfrage == 0 ): # okay , cancel
            return (status,errtext)
        elif( indexAbfrage == 1 ):                                            # change
            # data_set = [iban,bank,wer,comment]
            
            # proof what has changed and store in index_tri = [ilist,idataset,value]
            index_tri = []
            for i,d in enumerate(self.data_list):
                if( d[I_IBAN] != d_new[i][I_IBAN]):
                    # proof iban
                    (okay, wert) = htype.hfkt_type_proof_iban(d_new[i][I_IBAN])
                    if (okay != hdef.OKAY):
                        status = hdef.NOT_OKAY
                        errtext = f"iban_data: error input iban = {d_new[i][I_IBAN]} from Bank:{d[I_BANK]} and Comment:{d[I_COM]} is not valid"
                        return (status, errtext)
                    else:
                        index_tri.append((i,I_IBAN,wert))
                    # endif
                # endif iban
                if( d[I_BANK] != d_new[i][I_BANK]):
                    index_tri.append((i, I_BANK, d_new[i][I_BANK]))
                # endif
                if( d[I_WER] != d_new[i][I_WER]):
                    index_tri.append((i,I_WER, d_new[i][I_WER]))
                # endif
                if( d[I_COM] != d_new[i][I_COM]):
                    index_tri.append((i,I_COM, d_new[i][I_COM]))
                # endif
            # endif
            
            # set changed values
            for [i,j,value] in index_tri:
                self.data_list[i][j] = value
            # end for
        else: # add
            
            title = 'Neue IBAN-Nummer eingeben'
            listeErgebnis = sgui.abfrage_n_eingabezeilen(liste=self.item_list, title=title)
            
            if (len(listeErgebnis) == 0):
                status = hdef.NOT_OKAY
                errtext = f"iban_data: Keine IBAN-Nummer eingegeben"
                return (status, errtext)
            # endif
            
            iban    = hstr.elim_ae(listeErgebnis[I_IBAN], ' ')
            bank    = hstr.elim_ae(listeErgebnis[I_BANK], ' ')
            wer     = hstr.elim_ae(listeErgebnis[I_WER],' ')
            comment = hstr.elim_ae(listeErgebnis[I_COM],' ')

            (okay, wert) = htype.hfkt_type_proof_iban(iban)
            if (okay != hdef.OKAY):
                status = hdef.NOT_OKAY
                errtext = f"iban_data: error input iban = {iban} from Bank:{bank} and Comment:{comment} is not valid"
                return (status, errtext)
            else:
                iban = wert
            # endif
            
            (status,errtext) = self.add(self, iban, bank, wer, comment)
        
        # endif
        
        return (status,errtext)
    # enddef