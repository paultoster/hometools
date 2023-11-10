# -*- coding: cp1252 -*-
#
# AdressBookGui:
#              Gui
#
# verionen:
# 0.0
#
# self.actual_group_name      aktueller Gruppenname
#

import AdressBookDef as ABDef
import tkinter as Tk
import tkinter.filedialog as tkFileDialog
import tkinter.messagebox as tkMessageBox
import os
import sys

if("D:\\tools\\python" not in sys.path):
    sys.path.append("D:\\tools\\python")

import hfkt as h

GROUP_NAME_ID       = 1
ADRESS_LIST_ID      = 2

class AdressBookGui:
  state = ABDef.OKAY
  actual_group_name = ""
  act_frame_id = 0

  def __init__(self,base,log):
    """
    """
    self.base = base
    self.log  = log
    # TK-Grafik anlegen
    #------------------
    self.root = Tk.Tk()
    self.root.protocol("WM_DELETE_WINDOW", self.m_exitMenu)
    geo = str(self.base.GUI_GEOMETRY_WIDTH)+"x"+str(self.base.GUI_GEOMETRY_HEIGHT)
    self.root.geometry(geo)
    if( os.path.isfile(ABDef.GUI_ICON_FILE) ):
        self.root.wm_iconbitmap(ABDef.GUI_ICON_FILE)
    self.root.title('AdressBook')
    # Guis anlegen
    #--------------
    self.createGuiGroupName()
    self.createGuiAdressOfGroup()
    # Menue anlegen
    #--------------
    self.createMenu()
    self.makeGuiGroupName()
    self.root.mainloop()

  def createMenu(self):
    self.menuleiste = Tk.Menu(self.root)
    self.root.configure(menu=self.menuleiste)

    self.menu1 = Tk.Menu(master=self.menuleiste)
    self.menuleiste.add_cascade(label='Bearbeiten', menu=self.menu1)

    self.menu1.add_radiobutton(label='Neue Datenbasis', command=self.makeNewDatabase)
    self.menu1.add_radiobutton(label='Gruppenname anzeigen', command=self.makeGuiGroupName)
    self.menu1.add_radiobutton(label='Ende', command=self.m_exitMenu)

    self.menu2 = Tk.Menu(master=self.menuleiste)
    self.menuleiste.add_cascade(label='Extra', menu=self.menu2)

    self.menu2.add_radiobutton(label='Adressen aus Outlook laden', command=self.loadOutlookData)
    self.menu2.add_radiobutton(label='csv-Export(Komma) Thunderbird laden', command=self.m_loadCSVThunderbird)
    self.menu2.add_radiobutton(label='csv-Export(Komma) Outlook laden', command=self.m_loadCSVOutlook)

##    self.menu2.add_radiobutton(label='save base in csv', command=self.m_saveCSV)
##    self.menu2.add_radiobutton(label='load base in csv', command=self.m_loadCSV)
##    self.menu2.add_radiobutton(label='clear container', command=self.m_clearContainer)

###############################################################################
###############################################################################
  def makeNewDatabase(self):
    '''
    Es wird eine neue Datenbasis angelegt
    '''
    # Vor neuanlegen abfragen
    ans = tkMessageBox.askyesno(parent=self.root,title='Neu Datenbasis', message='Soll neue Datenbasis angelegt werden')
    if( ans ): self.base.create_new_database()
###############################################################################
###############################################################################
  def createGuiGroupName(self):
    '''
    Gui um Gruppennamen in einer Liste anzeigen
    '''
    self.sGN_rahmen = Tk.LabelFrame(self.root,bd=2,text='GuiGroupName',font=('Verdana',10,'bold'))
    # self.sC_rahmen.pack(expand=1,fill=Tk.BOTH)

    gr_buttonbox = Tk.Frame(self.sGN_rahmen)
    gr_buttonbox.pack(expand=1,fill=Tk.BOTH)

    # Scrollbar
    scroll_buttonbox = Tk.Scrollbar(gr_buttonbox)
    scroll_buttonbox.pack(side=Tk.RIGHT,fill=Tk.Y)

    self.sGN_ListBox = Tk.Listbox(gr_buttonbox,selectmode=Tk.SINGLE)
    self.sGN_ListBox.pack(fill=Tk.BOTH, expand=1)

    scroll_buttonbox.config(command=self.sGN_ListBox.yview)


    gr_buts = Tk.Frame(self.sGN_rahmen,relief=Tk.GROOVE, bd=2)
    gr_buts.pack(fill=Tk.X,pady=5)

    b_neu = Tk.Button(gr_buts,text='Neue Gruppe anlegen', command=self.makeNewGroup)
    b_neu.pack(side=Tk.LEFT,pady=4,padx=2)

    b_ausw = Tk.Button(gr_buts,text='Gruppe auswählen', command=self.decideForOneGroup)
    b_ausw.pack(side=Tk.LEFT,pady=4,padx=2)

    b_chang = Tk.Button(gr_buts,text='Gruppename ändern', command=self.changeGroupName)
    b_chang.pack(side=Tk.LEFT,pady=4,padx=2)

    b_chang = Tk.Button(gr_buts,text='Adressen anzeigen', command=self.makeGuiAdressOfGroup)
    b_chang.pack(side=Tk.LEFT,pady=4,padx=2)

###############################################################################
###############################################################################
  def makeGuiGroupName(self):
    ''' Gruppennamen anzeigen
    '''
    # delete Listbox
    n = self.sGN_ListBox.size()
    if( n > 0 ): self.sGN_ListBox.delete(0, n)
    self.setActFrameID(GROUP_NAME_ID)

    # Gruppenname zeigen
    liste = self.base.getGroupNameList()
    i = 0

    # aktueller Gruppenname vorwählen, wenn noch nicht ausgewählt
    if( self.actual_group_name == "" and len(liste) > 0 ):
      self.actual_group_name = liste[0]

    for item in liste:
      self.sGN_ListBox.insert(Tk.END,item)
      if( item == self.actual_group_name ):
        self.sGN_ListBox.itemconfig(i,fg='red')
      i += 1
###############################################################################
###############################################################################
  def createGuiAdressOfGroup(self):
    ''' Gui für Adressen einer Gruppe anzeigen
    '''
    self.sA_rahmen = Tk.LabelFrame(self.root,bd=2,text='GuiAdressOfGroup',font=('Verdana',10,'bold'))

    gr_listbox = Tk.Frame(self.sA_rahmen)
    gr_listbox.pack(expand=1,fill=Tk.BOTH)

    # Scrollbar
    scroll_listbox = Tk.Scrollbar(gr_listbox)
    scroll_listbox.pack(side=Tk.RIGHT,fill=Tk.Y)

    # Listbox
    self.sA_ListBox = Tk.Listbox(gr_listbox,selectmode=Tk.SINGLE,yscrollcommand=scroll_listbox.set)
    self.sA_ListBox.pack(fill=Tk.BOTH, expand=1)

    scroll_listbox.config(command=self.sA_ListBox.yview)


    gr_buts = Tk.Frame(self.sA_rahmen,relief=Tk.GROOVE, bd=2)
    gr_buts.pack(fill=Tk.X,pady=5)

    b_edit = Tk.Button(gr_buts,text='Editieren', command=self.m_editAdress)
    b_edit.pack(side=Tk.LEFT,pady=4,padx=2)

    b_new = Tk.Button(gr_buts,text='Neu',command=self.m_editNewAdress)
    b_new.pack(side=Tk.LEFT,pady=4,padx=2)

    b_back = Tk.Button(gr_buts,text='Zurück',command=self.makeGuiGroupName)
    b_back.pack(side=Tk.LEFT,pady=4,padx=2)

###############################################################################
###############################################################################
  def makeGuiAdressOfGroup(self):
    ''' Adressen einer Gruppe anzeigen
    '''
    # delete listbox
    n = self.sA_ListBox.size()
    if( n > 0 ): self.sA_ListBox.delete(0, n)

    # Gruppenname aktualisieren
    self.selectActualGroupName()
    # fill listbox
    index_liste = self.base.getListOfIndexFromAdressByGroupname(self.actual_group_name)
    if( len(index_liste) > 0 ):
      for index in index_liste:
        dict = self.base.getAdressByIndex(index)

        #print base_item
        text = dict[ABDef.A_NACHNAME]+"  -  "+dict[ABDef.A_VORNAME]
        self.sA_ListBox.insert(Tk.END,text)
    else:
      text = 'keine Adressen der Gruppe <%s> vorhanden' % self.actual_group_name
      self.sA_ListBox.insert(Tk.END,text)

    self.setActFrameID(ADRESS_LIST_ID)
###############################################################################
###############################################################################
  def setActFrameID(self,id):
    ''' Setzt Gui mit ID
    '''
    if( self.act_frame_id == GROUP_NAME_ID ):
      self.sGN_rahmen.pack_forget()
    elif( self.act_frame_id ==  ADRESS_LIST_ID):
      self.sA_rahmen.pack_forget()

    self.act_frame_id = id
    if( self.act_frame_id == GROUP_NAME_ID ):
      self.sGN_rahmen.pack(expand=1,fill=Tk.BOTH)
    elif( self.act_frame_id ==  ADRESS_LIST_ID):
      self.sA_rahmen.pack(expand=1,fill=Tk.BOTH)

###############################################################################
###############################################################################
  def editAdress(self):
    ''' Gui für Editieren einer Adresse einer Gruppe
    '''
###############################################################################
###############################################################################
  def m_editAdress(self):
    ''' Bearbeiten Gui für Editieren einer Adresse einer Gruppe
    '''
###############################################################################
###############################################################################
  def m_editNewAdress(self):
    ''' Bearbeiten Gui für Editieren einer neuen Adresse einer Gruppe
    '''
###############################################################################
###############################################################################
  def makeNewGroup(self):
    ''' neuer Gruppenname
    '''
    groupname = h.abfrage_str_box("neuer Gruppenname",800)
    if( len(groupname) == 0 ):
      self.log.write_warning("Gruppenname ist leer !!!",display=1)
    else:
      if( self.base.addGroupName(groupname) ):
        self.actual_group_name = groupname
    self.makeGuiGroupName()

###############################################################################
###############################################################################
  def decideForOneGroup(self):
    ''' eine Gruppe auswählen
    '''
    self.selectActualGroupName()
    self.makeGuiGroupName()
###############################################################################
###############################################################################
  def selectActualGroupName(self):
    ''' eine Gruppe auswählen über selection, wenn nicht dann weiter
        aktuellen Namen verwenden
        Ergebnis wird in self.actual_group_name gespeichert
        Rückgabewert:
        Wenn self.actual_group_name belegt ist, dann True
        ansonasten False
    '''
    # Nimmt den aktuellen Cursorstellung
    select = self.sGN_ListBox.curselection()
    if( len(select) > 0  ):
      self.actual_group_name = self.base.getGroupByID(int(select[0]))
    if( len(self.actual_group_name) > 0 ):
      return True
    else:
      return False
###############################################################################
###############################################################################
  def changeGroupName(self):
    ''' Gruppennamen ändern
    '''
    if(  self.selectActualGroupName() ):
      tt = "neuer Gruppenname fuer <%s>" % self.actual_group_name
      groupname = h.abfrage_str_box(tt,800)
      if( len(groupname) == 0 ):
        self.log.write_warning("Gruppenname ist leer !!!",display=1)
      else:
        self.actual_group_name = self.base.changeGroupNameByName(self.actual_group_name,groupname)
    self.makeGuiGroupName()
###############################################################################
###############################################################################
  def loadOutlookData(self):
    ''' Outlook Adressen laden
    '''
    self.state = self.base.loadOutlookData()

    self.makeGuiGroupName()

###############################################################################
###############################################################################
  def m_loadCSVThunderbird(self):
    ''' csv - Datei von Thunderbird exportiert (Komma)
    '''
    # Datei abfregen
    filename = tkFileDialog.askopenfilename(parent=self.root, title="Thunderbird csv-Datei (kommagetrennt)", filetypes=[('csv','*.csv')])
    # Datei einlesen
    (self.state, csv_header, csv_data) = self.base.read_csv_file(file_name=filename,trennzeichen=",")

    for csv_adress_list in csv_data:
      (option, ndict, adict) = self.base.add_address_from_thunderbird_csv_data(self.actual_group_name,csv_header,csv_adress_list)

      # keine Namen
      if( option == 1 ):
        i = 0
        for attribut in csv_header:
          value = csv_adress_list[i]
          print("%s = %s\n"%(attribut,value))
          i += 1
        ans = tkMessageBox.askquestion(parent=self.root,title='csv-Adresse', message='Die angegebene Adresse hat keinen NAmen (Vor- oder NAchname)')
      # gleiche Namen
      elif( option == 2 ):
        # guibearbeitung(ndict, adict)
        tt = ""
###############################################################################
###############################################################################
  def m_loadCSVOutlook(self):
    ''' csv - Datei von Outlook exportiert (Komma) laden
    '''
    # Datei abfregen
    filename = tkFileDialog.askopenfilename(parent=self.root, title="Outlook csv-Datei (kommagetrennt)", filetypes=[('csv','*.csv')])
    # Datei einlesen
    (self.state, csv_header, csv_data) = self.base.read_csv_file(file_name=filename,trennzeichen=",")

    for csv_adress_list in csv_data:
      (option, ndict, adict) = self.base.add_address_from_outlook_csv_data(self.actual_group_name,csv_header,csv_adress_list)

      # keine Namen
      if( option == 1 ):
        i = 0
        for attribut in csv_header:
          value = csv_adress_list[i]
          print("%s = %s\n"%(attribut,value))
          i += 1
        ans = tkMessageBox.askquestion(parent=self.root,title='csv-Adresse', message='Die angegebene Adresse hat keinen NAmen (Vor- oder NAchname)')
      # gleiche Namen
      elif( option == 2 ):
        # guibearbeitung(ndict, adict)
        tt = ""
###############################################################################
###############################################################################
  def m_exitMenu(self):
    ''' Beenden der Gui
    '''
    # Vor Beenden Speichern abfragen
    ans = tkMessageBox.askyesno(parent=self.root,title='Sichern', message='Soll Datenbasis gesichert werden')
    if( ans ): self.base.save_db_file()

    self.root.destroy()


##  def m_makeQuestion(self):
##
##    # nächste Karte
##    self.IDCounter += 1
##
##    # Ende abfragen
##    if( self.IDCounter > self.NIDs ):
##      # Ende und Abrechnen
##      # wenn Pool, dann Pool u. ersten Container, ansonsten aktuellen container
##      if(self.ContainerIndex == -1 ):
##        self.base.set_pool_new_repetition()
##        self.ContainerIndex = 0
##      self.base.set_container_new_stage(self.ContainerIndex)
##      del self.IDListe[0:len(self.IDListe)]
##      self.NIDs = 0
##      # zurück zu showContainer
##      self.m_showContainer()
##    else:
##
##      self.ContainerID   = self.IDListe[self.IDCounter-1]
##      self.ContainerCard = self.base.get_card_from_base_by_id(self.ContainerID)
##
##      # nicht None
##      if( self.ContainerCard ):
##
##        # tag löschen, wenn vorhanden
##        liste = self.mQ_Text.tag_names()
##        if( 'frage' in liste ):
##          self.mQ_Text.tag_delete('frage')
##
##        # Frage einfügen
##        tt = "%i Karte(%i): <%s>" % (self.IDCounter,self.NIDs,self.ContainerCard[ABDef.A_BASE_NAME])
##        self.mQ_Text.insert('1.0',"%s\n" % tt )
##        self.mQ_Text.tag_add('frage','1.0','1.end')
##        self.mQ_Text.tag_configure('frage',font=('Times',20,'bold'),foreground='red')
##        self.mQ_Text.insert('1.0',"\n")
##        # Frage stellen
##        self.setActFrameID(MAKE_QUESTION_ID)
##
##
##  def m_setAnswerOk(self):
##
##    # setzte neue stage
##    if( self.ContainerIndex == -1 ):
##      self.base.set_next_stage_of_item_in_pool(self.ContainerID)
##      # wenn aus Pool, dann Karten item in ersten Container
##      self.base.set_item_from_pool_to_container(self.ContainerID)
##    else:
##      self.base.set_next_stage_of_item_in_container(self.ContainerIndex,self.ContainerID)
##
##
##    self.m_makeQuestion()
##
##  def m_setAnswerNotOk(self):
##
##    # redutziert stage
##    if( self.ContainerIndex == -1 ):
##      self.base.reduce_stage_of_item_in_pool(self.ContainerID)
##    else:
##      self.base.reduce_stage_of_item_in_container(self.ContainerIndex,self.ContainerID)
##      # wenn aus Container, dann Karten item in Pool
##      self.base.set_item_from_container_to_pool(self.ContainerIndex,self.ContainerID)
##
##    self.m_makeQuestion()
##
##  def m_makeAnswer(self):
##
##    # nicht None
##    if( self.ContainerCard ):
##
##      # Tag löschen, wenn vorhanden
##      liste = self.mA_Text.tag_names()
##      if( 'antwort' in liste ):
##        self.mA_Text.tag_delete('antwort')
##
##      i = 0
##      # Antwort einfügen
##      if( len(self.ContainerCard[ABDef.A_BASE_NAME]) > 0 ):
##        tt = "%i(%i)%s:---------------------------" % (self.IDCounter,self.NIDs,self.ContainerCard[ABDef.A_BASE_NAME])
##        i += 1
##        index = "%i.0" % i
##        self.mA_Text.insert(index,"%s\n" % tt )
##
##      if( len(self.ContainerCard[ABDef.A_BASE_DEUTSCH]) > 0 ):
##        tt = "Deutsch\t<%s>" % self.ContainerCard[ABDef.A_BASE_DEUTSCH]
##        i += 1
##        index = "%i.0" % i
##        self.mA_Text.insert(index,"%s\n" % tt )
##
##      if( len(self.ContainerCard[ABDef.A_BASE_FORMEN]) > 0 ):
##        tt = "Form\t<%s>" % self.ContainerCard[ABDef.A_BASE_FORMEN]
##        i += 1
##        index = "%i.0" % i
##        self.mA_Text.insert(index,"%s\n" % tt )
##
##      if( len(self.ContainerCard[ABDef.A_BASE_ZUSATZ]) > 0 ):
##        tt = "Zusatz\t<%s>" % self.ContainerCard[ABDef.A_BASE_ZUSATZ]
##        i += 1
##        index = "%i.0" % i
##        self.mA_Text.insert(index,"%s\n" % tt )
##
##      if( len(self.ContainerCard[ABDef.A_BASE_WORTTYP]) > 0 ):
##        tt = "Worttype\t<%s>" % self.ContainerCard[ABDef.A_BASE_WORTTYP]
##        i += 1
##        index = "%i.0" % i
##        self.mA_Text.insert(index,"%s\n" % tt )
##      if( len(self.ContainerCard[ABDef.A_BASE_HILFE]) > 0 ):
##        tt = "Hilfe\t<%s>" % self.ContainerCard[ABDef.A_BASE_HILFE]
##        i += 1
##        index = "%i.0" % i
##        self.mA_Text.insert(index,"%s\n" % tt )
##      if( self.ContainerCard[ABDef.A_BASE_KAPITEL] > 0 ):
##        tt = "Kapitel\t<%i>" % self.ContainerCard[ABDef.A_BASE_KAPITEL]
##        i += 1
##        index = "%i.0" % i
##        self.mA_Text.insert(index,"%s\n" % tt )
##      if( i > 0 ):
##        index = "%i.end" % i
##        self.mA_Text.tag_add('antwort','1.0',index)
##        self.mA_Text.tag_configure('antwort',font=('Times',16,'bold'),foreground='green')
##        self.mA_Text.insert('1.0',"\n")
##
##    self.setActFrameID(MAKE_ANSWER_ID)
##
##
##  def m_newCards(self):
##    # neuen Container anlegen
##    self.base.set_nstart_cards(int(self.dNC_entry.get()))
##
##    self.base.put_new_items_in_container_pool(self.TkNewCardsFromOneChapter.get()  \
##                                                    ,self.base.get_nstart_cards() )
##    # show Container
##    self.m_showContainer()
##
##  def m_showBasis(self):
##
##    # delete listbox
##    n = self.sB_ListBox.size()
##    if( n > 0 ): self.sB_ListBox.delete(0, n)
##
##    # fill listbox
##    for base_item in self.base.D["base_liste"]:
##      #print base_item
##      text = base_item[ABDef.A_BASE_NAME]+"  -  "+base_item[ABDef.A_BASE_WORTTYP]
##      self.sB_ListBox.insert(Tk.END,text)
##
##    self.setActFrameID(SHOW_BASIS_ID)
##
##  def m_editBasis(self):
##    ''' startet das Editieren eines item aus Basis-liste
##    '''
##    #ausgesuchtes item aus Basis entnehmen
##    self.base_item_list_index = int(self.sB_ListBox.curselection()[0])
##    self.base_item_to_edit = self.base.get_item_from_base_liste_by_index(self.base_item_list_index)
##
##    # Hole alle keys aus der D["base_liste"]
##    keys = self.base.keys_from_base_key_liste_but_not_ID()
##
##    for key in keys:
##      if( key == ABDef.A_BASE_WORTTYP ):
##        wtyp = self.entry_d_base_items[key][0]
##        wtyp.set(self.base_item_to_edit[key])
##      else:
##        ent = self.entry_d_base_items[key][1]
##        ent.delete(0,len(ent.get()))
##        ent.insert(0,self.base_item_to_edit[key])
##
##    self.NewBaseItemFlag = 0
##
##    # reset old gui-frame-id set acutal gui-frame-id
##    self.setActFrameID(EDIT_BASIS_ID)
##
##  def m_newEditBasis(self):
##    ''' startet das Editieren eines neuen item aus Basis-Liste
##    '''
##    #neues item anlegen und aus Basis entnehmen
##    self.base_item_list_index = int(self.base.new_item_in_base_liste())
##    self.base_item_to_edit = self.base.get_item_from_base_liste_by_index(self.base_item_list_index)
##
##    # Hole alle keys aus der D["base_liste"] (sollten leer sein)
##    keys = self.base.keys_from_base_key_liste_but_not_ID()
##    for key in keys:
##      if( key == ABDef.A_BASE_WORTTYP ):
##        wtyp = self.entry_d_base_items[key][0]
##        wtyp.set(ABDef.WORT_TYP_LISTE[0])
##      else:
##        ent = self.entry_d_base_items[key][1]
##        ent.delete(0,len(ent.get()))
##        ent.insert(0,self.base_item_to_edit[key])
##
##    self.NewBaseItemFlag = 1
##
##    # reset old gui-frame-id set acutal gui-frame-id
##    self.setActFrameID(EDIT_BASIS_ID)
##
##  def m_loadCSV(self):
##    name = tkFileDialog.askopenfilename(parent=self.root, filetypes=[('csv','*.csv')])
##    self.base.read_and_evaluate_csv_file(name)
##
##  def m_saveCSV(self):
##    name = tkFileDialog.asksaveasfilename(parent=self.root, filetypes=[('csv','*.csv')])
##    self.base.write_db_to_csv_file(name)
##
##  def m_clearContainer(self):
##    ans = tkMessageBox.askyesno(parent=self.root,title='Container löschen', message='Soll Container und Pool wirklich gelöäscht werden ?')
##    if( ans ): self.base.delete_container_and_pool()
##    self.m_showContainer()
##
##  def m_showEndContainer(self):
##
##    # delete listbox
##    n = self.sEC_ListBox.size()
##    if( n > 0 ): self.sEC_ListBox.delete(0, n)
##
##    # fill listbox
##    for i in range(self.base.get_nitems_container_end()):
##      #print base_item
##      text = self.base.get_base_name_from_item_of_container_end(i)
##      self.sEC_ListBox.insert(Tk.END,text)
##
##    self.setActFrameID(SHOW_END_CONTAINER_ID)
##
##  def m_returnItemsFromEnd(self):
##    ''' Nimmt Items wieder aus Endcontainer
##    '''
##    #
##    liste = self.sEC_ListBox.curselection()
##    for select in liste:
##      iselect = int(select)
##      self.base.free_container_end_item_by_index(iselect)
##
##    self.m_showContainer()
##
##
##  def decideNewCard(self):
##    ''' Soll neuen KArten anlegt werden
##    '''
##    self.dNC_rahmen = Tk.LabelFrame(self.root,bd=2,text='decideNewContainer',font=('Verdana',10,'bold'))
##    # self.sC_rahmen.pack(expand=1,fill=Tk.BOTH)
##
##    dNC_checkbox = Tk.Frame(self.dNC_rahmen)
##    dNC_checkbox.pack(expand=1,fill=Tk.BOTH)
##
##    # Intvariable für checkbox anlegen und initilaisieren
##    self.TkNewCardsFromOneChapter = Tk.IntVar(self.root)
##    self.TkNewCardsFromOneChapter.set(self.base.NEW_CARDS_FROM_ONE_CHAPTER)
##
##    # checkbox
##    checkbox = Tk.Checkbutton(dNC_checkbox \
##                             ,indicatoron = 1 \
##                             ,onvalue = 1 \
##                             ,offvalue = 0 \
##                             ,variable = self.TkNewCardsFromOneChapter \
##                             ,text = "Neue Karten von einem Kapitel" \
##                             )
##    #checkbox.pack(side=Tk.LEFT,fill=Tk.Y)
##    checkbox.pack(side=Tk.LEFT)
##    label = Tk.Label(dNC_checkbox, text="Anzahl Karten",anchor=Tk.W)
##    label.place(x=40,y=200,width=100)
##    self.dNC_entry = Tk.Entry(dNC_checkbox)
##    self.dNC_entry.insert(0,str(self.base.get_nstart_cards()))
##    self.dNC_entry.place(x=10,y=200,width=20)
##
##    dnc_buts = Tk.Frame(self.dNC_rahmen,relief=Tk.GROOVE, bd=2)
##    dnc_buts.pack(fill=Tk.X,pady=5)
##
##    b_neu = Tk.Button(dnc_buts,text='Bestätigen', command=self.m_newCards)
##    b_neu.pack(side=Tk.LEFT,pady=4,padx=2)
##
##  def showBasis(self):
##    ''' Zeigt alle Basis woerter an
##    '''
##    self.sB_rahmen = Tk.LabelFrame(self.root,bd=2,text='showBasis',font=('Verdana',10,'bold'))
##    # self.sB_rahmen.pack(expand=1,fill=Tk.BOTH)
##
##    gr_listbox = Tk.Frame(self.sB_rahmen)
##    gr_listbox.pack(expand=1,fill=Tk.BOTH)
##
##    # Scrollbar
##    scroll_listbox = Tk.Scrollbar(gr_listbox)
##    scroll_listbox.pack(side=Tk.RIGHT,fill=Tk.Y)
##
##    # Listbox
##    self.sB_ListBox = Tk.Listbox(gr_listbox,selectmode=Tk.SINGLE,yscrollcommand=scroll_listbox.set)
##    self.sB_ListBox.pack(fill=Tk.BOTH, expand=1)
##
##    scroll_listbox.config(command=self.sB_ListBox.yview)
##
##
##    gr_buts = Tk.Frame(self.sB_rahmen,relief=Tk.GROOVE, bd=2)
##    gr_buts.pack(fill=Tk.X,pady=5)
##
##    b_edit = Tk.Button(gr_buts,text='Editieren', command=self.m_editBasis)
##    b_edit.pack(side=Tk.LEFT,pady=4,padx=2)
##
##    b_new = Tk.Button(gr_buts,text='Neu',command=self.m_newEditBasis)
##    b_new.pack(side=Tk.LEFT,pady=4,padx=2)
##
##  def editBasis(self):
##    ''' editiert ein item aus Basis
##    '''
##    self.eB_rahmen = Tk.LabelFrame(self.root,bd=2,text='editBasis',font=('Verdana',10,'bold'))
##    # self.eB_rahmen.pack(expand=1,fill=Tk.BOTH)
##
##    # WIdth-calulation
##    x0 = 20
##    w0 = 80
##    x1 = x0+w0
##    w1 = self.base.GUI_GEOMETRY_WIDTH - 20 - x0 - w0
##    y0 = 40
##    dy = 40
##
##    gr_edit = Tk.Frame(self.eB_rahmen)
##    gr_edit.pack(expand=1,fill=Tk.BOTH)
##
##    # Hole alle keys aus der D["base_liste"]
##    keys = self.base.keys_from_base_key_liste_but_not_ID()
##
##    #
##    self.entry_d_base_items = {}
##    for i in range(len(keys)):
##      yy = y0 + dy * i
##      if( keys[i] == ABDef.A_BASE_WORTTYP ):
##         wtyp   = Tk.StringVar()
##         wtypom = Tk.OptionMenu(gr_edit,wtyp,*ABDef.WORT_TYP_LISTE)
##         wtypom.place(x=x0,y=yy)
##         self.entry_d_base_items[keys[i]]=(wtyp,wtypom)
##      else:
##        lab = Tk.Label(gr_edit, text=keys[i],anchor=Tk.W)
##        lab.place(x=x0,y=yy,width=w0)
##        ent = Tk.Entry(gr_edit)
##        ent.place(x=x1,y=yy,width=w1)
##        self.entry_d_base_items[keys[i]]=(lab,ent)
##
##
##    ## Scrollbar
###    scroll = Tk.Scrollbar(gr_text)
###    scroll.pack(side=Tk.RIGHT,fill=Tk.Y)
###
###    self.text = Tk.Text(gr_text,padx=4,pady=4, font=('Verdana',10),wrap=Tk.WORD,yscrollcommand=scroll.set)
###    self.text.pack(side=Tk.TOP,expand=1,fill=Tk.BOTH)
###
###    scroll.config(command=self.text.yview)
##
##    gr_buts = Tk.Frame(self.eB_rahmen,relief=Tk.GROOVE, bd=2)
##    gr_buts.pack(fill=Tk.X,pady=5)
##
##    b_open = Tk.Button(gr_buts,text='Speichern', command=self.save_edit_base_item)
##    b_open.pack(side=Tk.LEFT,pady=4,padx=2)
##
##    b_save = Tk.Button(gr_buts,text='Zuruck',command=self.cancel_edit_base_item)
##    b_save.pack(side=Tk.LEFT,pady=4,padx=2)
##
##  def makeQuestion(self):
##    ''' Soll die Frage aus Lerncontainer anzeigen
##    '''
##    self.mQ_rahmen = Tk.LabelFrame(self.root,bd=2,text='makeQuestion',font=('Verdana',10,'bold'))
##    # self.sC_rahmen.pack(expand=1,fill=Tk.BOTH)
##
##    gr_buttonbox = Tk.Frame(self.mQ_rahmen)
##    gr_buttonbox.pack(expand=1,fill=Tk.BOTH)
##
##    # Scrollbar
##    scroll_buttonbox = Tk.Scrollbar(gr_buttonbox)
##    scroll_buttonbox.pack(side=Tk.RIGHT,fill=Tk.Y)
##
##    self.mQ_Text = Tk.Text(gr_buttonbox,wrap=Tk.WORD)
##    self.mQ_Text.pack(fill=Tk.BOTH, expand=1)
##
##    scroll_buttonbox.config(command=self.mQ_Text.yview)
##
##
##    gr_buts = Tk.Frame(self.mQ_rahmen,relief=Tk.GROOVE, bd=2)
##    gr_buts.pack(fill=Tk.X,pady=5)
##
##    b_antw = Tk.Button(gr_buts,text='Antwort', command=self.m_makeAnswer)
##    b_antw.pack(side=Tk.LEFT,pady=4,padx=2)
##
##    b_abbr = Tk.Button(gr_buts,text='Abbruch', command=self.m_showContainer)
##    b_abbr.pack(side=Tk.LEFT,pady=4,padx=2)
##
##  def makeAnswer(self):
##    ''' Antwort aus Lerncontainer anzeigen
##    '''
##    self.mA_rahmen = Tk.LabelFrame(self.root,bd=2,text='makeAnswer',font=('Verdana',10,'bold'))
##    # self.sC_rahmen.pack(expand=1,fill=Tk.BOTH)
##
##    gr_buttonbox = Tk.Frame(self.mA_rahmen)
##    gr_buttonbox.pack(expand=1,fill=Tk.BOTH)
##
##    # Scrollbar
##    scroll_buttonbox = Tk.Scrollbar(gr_buttonbox)
##    scroll_buttonbox.pack(side=Tk.RIGHT,fill=Tk.Y)
##
##    self.mA_Text = Tk.Text(gr_buttonbox,wrap=Tk.WORD,tabs=('5c','10c'))
##    self.mA_Text.pack(fill=Tk.BOTH, expand=1)
##
##    scroll_buttonbox.config(command=self.mA_Text.yview)
##
##    gr_buts = Tk.Frame(self.mA_rahmen,relief=Tk.GROOVE, bd=2)
##    gr_buts.pack(fill=Tk.X,pady=5)
##
##    b_rich = Tk.Button(gr_buts,text='Richtig', command=self.m_setAnswerOk)
##    b_rich.pack(side=Tk.LEFT,pady=4,padx=2)
##
##    b_fals = Tk.Button(gr_buts,text='Falsch', command=self.m_setAnswerNotOk)
##    b_fals.pack(side=Tk.LEFT,pady=4,padx=2)
##
##    b_abbr = Tk.Button(gr_buts,text='Abbruch', command=self.m_showContainer)
##    b_abbr.pack(side=Tk.LEFT,pady=4,padx=2)
##
##  def showEndContainer(self):
##    ''' Zeigt alle Basis woerter an
##    '''
##    self.sEC_rahmen = Tk.LabelFrame(self.root,bd=2,text='showEndContainer',font=('Verdana',10,'bold'))
##    # self.sB_rahmen.pack(expand=1,fill=Tk.BOTH)
##
##    gr_listbox = Tk.Frame(self.sEC_rahmen)
##    gr_listbox.pack(expand=1,fill=Tk.BOTH)
##
##    # Scrollbar
##    scroll_listbox = Tk.Scrollbar(gr_listbox)
##    scroll_listbox.pack(side=Tk.RIGHT,fill=Tk.Y)
##
##    # Listbox
##    self.sEC_ListBox = Tk.Listbox(gr_listbox,selectmode=Tk.MULTIPLE)
##    self.sEC_ListBox.pack(fill=Tk.BOTH, expand=1)
##
##    scroll_listbox.config(command=self.sEC_ListBox.yview)
##
##
##    gr_buts = Tk.Frame(self.sEC_rahmen,relief=Tk.GROOVE, bd=2)
##    gr_buts.pack(fill=Tk.X,pady=5)
##
##    b_edit = Tk.Button(gr_buts,text='Zurück', command=self.m_showContainer)
##    b_edit.pack(side=Tk.LEFT,pady=4,padx=2)
##
##    b_new = Tk.Button(gr_buts,text='Auswahl zurücknehmen',command=self.m_returnItemsFromEnd)
##    b_new.pack(side=Tk.LEFT,pady=4,padx=2)
##
##  def save_edit_base_item(self):
##    ''' Liest Werte aus und speichert sie in die base Liste
##    '''
##    # Hole alle keys aus der D["base_liste"] (sollten leer sein)
##    keys = self.base.keys_from_base_key_liste_but_not_ID()
##    # Gehe alle entrys durch und übernehme die Änderung
##    for key in keys:
##      # entry bei Namen auf bestehenden Inhalt prüfen
##      if( (key == ABDef.A_BASE_NAME) ):
##        # entry aus tupel (label,entry) holen
##        ent = self.entry_d_base_items[key][1]
##        if( len(ent.get()) == 0 ):
##          self.m_showBasis()
##          return
##        else:
##          self.base_item_to_edit[key] = h.change(ent.get(),";","-")
##      elif( key == ABDef.A_BASE_WORTTYP ):
##        wtyp = self.entry_d_base_items[key][0]
##        self.base_item_to_edit[key] = wtyp.get()
##      elif( key == ABDef.A_BASE_KAPITEL):
##        # entry aus tupel (label,entry) holen
##        ent = self.entry_d_base_items[key][1]
##        # Änderung übernehmen
##        try:
##          self.base_item_to_edit[key] = int(ent.get())
##        except:
##          self.base_item_to_edit[key] = 0
##      else:
##        # entry aus tupel (label,entry) holen
##        ent = self.entry_d_base_items[key][1]
##        # Änderung übernehmen
##        self.base_item_to_edit[key] = h.change(ent.get(),";","-")
##    # geändertes item an basis liste wieder übergeben
##    self.base.set_item_from_base_liste_by_index(self.base_item_list_index,self.base_item_to_edit)
##    # Gui-Fenster mit liste basis items anzeigen
##    self.m_showBasis()
##
##  def cancel_edit_base_item(self):
##    # Wenn neues Item erzeugt wurde, bei cancel wieder rauslöschen:
##    if( self.NewBaseItemFlag ):
##      self.base.delete_last_item_in_base()
##      self.NewBaseItemFlag = 0
##
##    # Gui-Fenster mit liste basis items ohne Änderung anzeigen
##    self.m_showBasis()
##
##