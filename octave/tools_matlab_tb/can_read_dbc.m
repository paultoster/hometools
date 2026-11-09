function dbc = can_read_dbc(files,sort_flag)
%
% dbc = can_read_dbc(file,sort_flag)
%
% Liest dbc-File ein in eine Struktur
%
% Input:
% ======
% file          char/cell mit char          Ein oder mehrere Files können
%                                           gleichzeitig eingelesen werden. 
%                                           Es wird alles in eine Struktur
%                                           eingelesen
% sort_flag     double                      = 0 ist nach HEX-Identifier
%                                           sortiert (default)
%                                           = 1 wird nach Namen sortiert
% Output:
% =======
% dbc(i).ident     double   Identifier Botschaft decimal
%       .id        double   Identifier Botschaft decimal 
%       .identhex  char     Identifier hex
%       .name      char     Name der Botschaft
%       .dlc       double   Länge bytes
%       .sender      char     Sender
%       .indexmz   double   Index mit Signal mit Multiplexzaehler
%       .comment   char     Kommentar
%       .cycle_time char     Zykluszeit aus Kommmentar ausgefiltert
%                           (Kennung im Kommentar @cycle_time:10 ms@, bleibt string)
% dbc(i).s_bus(i).name    char Name des Busses (Wird nur in der ersten Botschaft gespeichert)
% dbc(i).s_bus(i).comment char Kommentar
%       .CAN_bus   double   CAN-Bus-Nummer, wird bei doppeldeutigkeiten
%                           festgelegt. Normalerweise = 0, d.h. keine Zuordnung
%       .sig       struct   Struktur mit Signalen
%        sig(j).name            char    Name des Signals
%              .nr              double  laufende Nummer
%              .typ             double  -2 -> Signal (normal)
%                                       -1 -> Multiplexsignal (also Zähler)
%                                       i>=0 -> gemultiplexte Signal und Zählerwert
%              .mtyp            char    'N' -> Signal (normal)
%                                       'Z' -> Multiplexsignal (also Zähler)
%                                       'Mx' -> gemultiplexte Signal und
%                                               Zählerwert x=0,1,...
%              .startbit        double  Startbit  (bei Intel lsb, motorola msb)
%              .bitlength          double  bit Länge
%              .byteorder       double  0 -> Motorola
%                                       1 -> Intel
%              .wertetyp        double  0 -> unsigned
%                                       1 -> signed
%              .faktor          double  Faktor
%              .offset          double  Offset
%              .minval             double  Minimum
%              .maxval             double  Maximum
%              .einheit            char    Einheit
%              .empfang{k}      cell    Namen der BUs, die die Botschaft
%                                       bekommen
%              .comment   char     Kommentar
%              .s_val(i)        struct  Stuktur mit Wert und Bezeichnung
%              
%               s_val(k).val    double  Wert
%                       .comment char   Bezeichnung
%
% 
% BO_ ident name: dlc sender
%  SG_ name : startbit|bitlength@byteorderwertetyp (faktor,offset) [minval|maxval]  "einheit" empfang
%                             0        +
%                             1        -
% Beispiel
% BO_ 1394 mZAS_1: 1 Gateway_PQ35_A
%  SG_ ZA1_res07 : 7|1@1+ (1,0) [0|0] "" Vector__XXX
%


  % File auswählen, wenn notwendig
  %===============================
  if( ~exist('files','var') )

      s_frage.comment = 'Vector dbc-Datei auswählen, Solange bis <cancel>';
      s_frage.file_spec='*.dbc';
      s_frage.start_dir=pwd;
      [okay,files] = o_abfragen_files_f(s_frage);
      if( ~okay )
        return
      end
  end

  % alphabetisch sortieren
  %=======================
  if( ~exist('sort_flag','var') )
      sort_flag = 0;
  end

  % Überprüfen, ob character-Variable
  %==================================
  if( ischar(files) )
      dbc_file = {files};
  else
      dbc_file = files;
  end

  % Matname erstellen
  %==================
  for id=1:length(dbc_file)
      s_dbc = str_get_pfe_f(dbc_file{id});
      dbc_mat_file{id} = [s_dbc.dir,str_change_f(s_dbc.name,{'-','+','.',' '},'_'),'.mat'];
  end

  for id = 1:length(dbc_file)
      % Existenz und Datum MAt-File prüfen und einlesen
      %======================================
      if( exist(dbc_mat_file{id},'file') )
          dirmat = dir(dbc_mat_file{id});
          dirdbc = dir(dbc_file{id});
                                    % dirmat.date = str_change_f(dirmat.date,'Mrz','Mar');
                                    % dirdbc.date = str_change_f(dirdbc.date,'Mrz','Mar');
          datemat = dirmat.datenum; % datenum(dirmat.date,'dd-mmm-yyyy HH:MM:SS');
          datedbc = dirdbc.datenum; % datenum(dirdbc.date,'dd-mmm-yyyy HH:MM:SS');
      else
          datemat = 0;
          datedbc = 0;
      end
      flag = 1;
      if( exist(dbc_mat_file{id},'file') && datemat >= datedbc )
          try
          fprintf('-> dbc-mat <%s> einlesen\n',dbc_mat_file{id});
          command = ['load ''',dbc_mat_file{id},''];
          eval(command);
          fprintf('<- dbc-mat-einlesen\n');
          flag = 0;          
          end
      end
      if( flag )
          fprintf('-> dbc-mat aus <%s> erstellen\n',dbc_file{id});
          dbc = can_read_dbc_file(dbc_file{id},id);
          fprintf('<- dbc-mat-erstellen()\n');
          fprintf('-> dbc-mat <%s> speichern\n',dbc_mat_file{id});
          command=sprintf('save(''%s'',''dbc'')',dbc_mat_file{id});
          eval(command);
          fprintf('<- dbc-mat-speichern()\n');
      end

      % in cellaray zwischenspeichern
      dbc1{id} = dbc;
  end

  % Mergen
  ic = 0;
  for id = 1:length(dbc1)

      for idd = 1:length(dbc1{id})
          ic = ic + 1;
          dbc(ic) = dbc1{id}(idd);
      end
  end

  % Doppeldeutigkeiten
  %===================
  % Doppeldeutigkeit wird mit der reihenfolge der DBC-Files festgelegt
  %
  % ic = 0;
  % idb_st = struct([]);
  % for idb=1:length(dbc)
  %    
  %     found_already_flag = 0;
  %     for iv = 1:length(idb_st)
  %         if( idb_st(iv).ident == dbc(idb).ident ) % Ist schon als doppeldeutig erkannt
  %             found_already_flag = 1;
  %             break
  %         end
  %     end
  %     
  %     if( ~found_already_flag ) % Wenn noch keine Doppeldeutigkeit, dann prüfen
  %    
  %         count = 0;
  %         for idb1 = idb+1:length(dbc)
  % 
  %             if( dbc(idb).ident == dbc(idb1).ident ) % Doppeldeutigkeiten vorhanden
  % 
  %                 if( count == 0 ) %neu anlegen
  %                     ic = ic + 1;
  %                     idb_st(ic).ident = dbc(idb1).ident;
  %                     idb_st(ic).index = [idb,idb1];
  %                 else
  %                     idb_st(ic).index = [idb_st(ic).index,idb1];
  %                 end
  %             end
  %         end
  %     end
  % end
  % 
  % if( length(idb_st) > 0 )
  %     warning('can_read_dbc: Es sind Doppeldeutigkeiten mit folgenden Identifier aufgetreten')
  %     
  %     for id=1:length(idb_st)
  %         
  %         liste = [];
  %         fprintf('\nDer Identifier %s wird mehrfach belegt\n',dbc(idb_st(ic).index(1)).identhex);
  %         for is = 1:length(idb_st(id).index)
  %             while(1)
  %                 index = idb_st(ic).index(is);
  %                 fprintf('%i. Name:     %s\n   Kommentar: %s\n',is,dbc(index).name,dbc(index).comment)
  %                 value = str2num(input('Welcher CAN-Knoten verwenden (Integer >= 1 eingeben)','s'));
  %                 if( length(value) > 0 )
  %                     value = value(1);
  %                 end
  %                 value = round(value);
  %             
  %                 if( ~val_in_liste(value,liste) & value > 0 )
  %                     
  %                     liste = [liste,value];
  %                     dbc(index).CAN_bus = value;
  %                     break
  %                 else
  %                     fprintf('Falscher Wert eingegeben, noch mal')
  %                 end
  %             end
  %         end
  %     end
  % end

  %sortieren nach Namen
  %====================
  if( sort_flag )

      % Namen extrahieren in cell_array
      c_t = {};
      ndb = length(dbc);
      for idb = 1:ndb
          c_t{idb} = dbc(idb).name;
      end

      %Namen Sortieren
      c_t = sort(c_t);


      % Anhand der Namen Struktur sortieren
      clear dbc1
      idb1 = 0;
      for ict = 1:length(c_t)

          for idb = 1:ndb

              if( strcmp(c_t{ict},dbc(idb).name) )
                  idb1       = idb1 + 1;
                  dbc1(idb1) = dbc(idb);
                  break;
              end
          end
      end

      dbc = dbc1;

  end

end    
    
function dbc = can_read_dbc_file(file,idCAN)
  % function dbc = can_read_dbc(file)
  dbc = struct([]);

  % Datei prüfen
  if( ~exist(file,'file') ) 
      text = sprintf('dbc_read: übergebene Datei: <%s> ist nicht vorhanden',file);
      error(text);
  else
      s.file = file;
  end

  s.fid = fopen(file,'r');
  if( s.fid <= 0 )
      text = sprintf('dbc_read: Probleme bei Öffnen der Datei: <%s>',file);
      error(text);
  end

  status = 's';
  s.zeile  = 0;
  while 1
      tline = fgetl(s.fid);
      s.zeile = s.zeile + 1;
      % Abbrechnen wenn Ende
      if( ~ischar(tline) )
          break
      end
      % Leerzeichen weg
      tline = str_cut_e_f(tline,' ');
      if( s.zeile > 30 )
        a = 0;
      end


          switch status

              case 's' % Suche Botschaft


                  if( length(tline) >= 3 && strcmp(tline(1:3),'BO_') && ~strcmp(tline(1:9),'BO_TX_BU_') )


                      status   = 'b';
                      [dbc,idbc] = dbc_read_botschaft(dbc,tline,s,idCAN);

                  elseif( length(tline) >= 3 &&  strcmp(tline(1:3),'CM_') )

                      [dbc,s] = dbc_read_comment(dbc,tline,s);

                  elseif( length(tline) >= 4 &&  strcmp(tline(1:4),'VAL_') )

                      [dbc,s] = dbc_read_value(dbc,tline,s);
                  end

              case 'b' % Suche Signale

                  if( length(tline) >= 4 &&  strcmp(tline(1:4),' SG_') )

                      [dbc] = dbc_read_signal(dbc,idbc,tline,s);
                  else
                      dbc   = dbc_calc_signal(dbc,idbc,s);
                      status   = 's';

                  end


          end
  end

  fclose(s.fid);

  % Sortiere Botschaften nach Identifier
  dbc = dbc_read_bot_sort(dbc);

  % Sortiere Signale der Botschaft nach startbit
  for idbc = 1:length(dbc)

      dbc(idbc) = dbc_read_sig_sort(dbc(idbc));
  end
end    
%==========================================================================
%==========================================================================
function [dbc,idbc] = dbc_read_botschaft(dbc,tline,s,idCAN)

    % Splitten 
    [c_text,n] = str_split(tline,':');

    if( n < 2 )
        error('dbc_read_botschaft: In Datei: <%s> Zeile <%i> kann Botschaft (BO_ ) nicht durch '':'' nicht geteilt',s.file,s.zeile);
    end

    text = str_cut_ae_f(c_text{1},' ');
    text = str_change_f(text,'  ',' ','a');
    [c_t,n] = str_split(text,' ');

    try
        name  = c_t{3};
        ident = c_t{2};
    catch
        error('dbc_read_botschaft: In Datei: <%s> Zeile <%i> kann Botschaft (BO_ ) nicht gelesen werden !!!',s.file,s.zeile);
    end
        
    text = str_cut_ae_f(c_text{2},' ');
    text = str_change_f(text,'  ',' ','a');
    [c_t,n] = str_split(text,' ');

    dlc = c_t{1};
    sender = c_t{2};

    % Neue Botschaft generieren
    idbc = length(dbc)+1;

    dbc(idbc).name     = name;
    dbc(idbc).ident    = str2num(ident);
    dbc(idbc).id       = str2num(ident);
    dbc(idbc).identhex = dec2hex(dbc(idbc).ident);
    dbc(idbc).dlc      = str2num(dlc);
    dbc(idbc).sender   = sender;
    dbc(idbc).sig      = struct([]);
    dbc(idbc).comment    = '';
    dbc(idbc).cycle_time = '';
    dbc(idbc).s_bus      = struct([]);
    dbc(idbc).CAN_bus    = idCAN;

end
function dbc = dbc_read_signal(dbc,ib,tline,s)

    % Splitten nach ':'
    [c_text,n] = str_split(tline,':');

    if( n < 2 )
        text = sprintf('dbc_read_signal: In Datei: <%s> Zeile <%i> kann Signal ( SG_ ) nicht durch '':'' nicht geteilt',s.file,s.zeile);
        error(text);
    end

    % 1. Teil
    text = str_cut_ae_f(c_text{1},' ');
    text = str_change_f(text,'  ',' ','a');
    [c_t,n] = str_split(text,' ');
    
    % Name
    name  = c_t{2};
%     if( strcmp(name,'TarSteerWhlAgReq_Prim') )
%       a = 0;
%     end
        
    % Typ
    if( length(c_t) < 3 ) % normales Signal
        typ = -2;
        mtyp = 'N';
    else
        if( strcmp(c_t{3},'M') ) % Multiplexsignal
            typ = -1;
            mtyp = 'Z';
        elseif( c_t{3}(1) == 'm' ) % gemultiplexte Signal
            typ = str2num(c_t{3}(2:length(c_t{3})));
            mtyp = ['M',num2str(typ)];
        else
            text = sprintf('dbc_read_signal: In Datei: <%s> Zeile <%i> kann aus Signal ( SG_ ) nicht der typ: <%s> erkannt werden \n tline:<%s>',s.file,s.zeile,c_t{3},tline);
            error(text);
        end
    end
    
    
    % 2. Teil
    text = str_cut_ae_f(c_text{2},' ');
    text = str_change_f(text,'  ',' ','a');
    
    i0 = str_find_f(text,'|','vs');
    if( i0 < 1 )
      error('Trennung | konnte nicht gefunden werden');
    else
      t = text(1:i0-1);
      t = str_cut_ae_f(t,' ');
      startbit = str2num(t);
      text = text(i0+1:length(text));
    end
    i0 = str_find_f(text,'@','vs');
    if( i0 < 1 )
      error('Trennung @ konnte nicht gefunden werden');
    else
      t = text(1:i0-1);
      t = str_cut_ae_f(t,' ');
      bitlength = str2num(t);
      text = text(i0+1:length(text));
    end
    text = str_cut_ae_f(text,' ');
    if( text(1) == '1' ) %Intel
        byteorder = 1;
    else
        byteorder = 0; %Motorola
        startbit = dbc_read_signal_motorola_startbit(startbit,bitlength);
    end
    if( text(2) == '+' )
        wertetyp = 0; %unsigned
    else
        wertetyp = 1; %signed
    end
    text = text(3:length(text));
    text = str_cut_ae_f(text,' ');
    % 2. Teil  2.Block: (faktor,offset)
    i0 = str_find_f(text,'(','vs');
    i1 = str_find_f(text,')','vs');
    if( i0 < 1 || i1 < 1 || i1 < i0 )
      error('factor und offset konnten nicht gelesen werden (f,o) ')
    end
    t = text(i0+1:i1-1);
    text = text(i1+1:length(text));
    [c_t2,n] = str_split(t,',');
    if( n < 2 )
      error('factor und offset konnten nicht gelesen werden f,o ')
    end
    % faktor
    faktor = str2num(c_t2{1});
    % offset
    offset = str2num(c_t2{2});
    % 2. Teil  3.Block: [minval|maxval]
    i0 = str_find_f(text,'[','vs');
    i1 = str_find_f(text,']','vs');
    if( i0 < 1 || i1 < 1 || i1 < i0 )
      error('minval und maxval konnten nicht gelesen werden [minval|maxval] ')
    end
    t = text(i0+1:i1-1);    
    text = text(i1+1:length(text));
    [c_t2,n] = str_split(t,'|');
    if( n < 2 )
      error('factor und offset konnten nicht gelesen werden f,o ')
    end    
    % minval
    minval = str2num(c_t2{1});
    % maxval
    maxval = str2num(c_t2{2});
    % 2. Teil  4.Block: "einheit"
    i0 = str_find_f(text,'"','vs');
    if( i0 < 1 ) 
      error('einheit konnte nicht gefunden werden');
    else
      text = text(i0+1:length(text));
    end
    i0 = str_find_f(text,'"','vs');
    if( i0 < 1 ) 
      error('einheit konnte nicht gelesen werden');
    elseif( i0 == 1 )
      einheit = '';
    else
      einheit = text(1:i0-1);
    end
    % 2. Teil  4.-n.Block: empfaenger
    if( i0 < length(text) )
      text = text(i0+1:length(text));
      text = str_cut_ae_f(text,' ');
    else
      text = '';
    end
    [c_t2,n] = str_split(text,',');
    empfang = {};
    for i=1:n
        empfang{i} = str_cut_ae_f(c_t2{i},' ');
    end
    
    
%     %[c_t,n] = str_split(text,' ');
%     [c_t,n] = str_split_quot(text,' ','"','"');
% 
%     % 2. Teil 1.Block: startbit|bitlength@byteorderwertetyp
%     
%     % Startbit
%     text = str_cut_ae_f(c_t{1},' ');
%     [c_t1,n] = str_split(text,'|');
%     startbit = str2num(c_t1{1});
%     % bitlength
%     text = str_cut_ae_f(c_t1{2},' ');
%     [c_t2,n] = str_split(text,'@');
%     bitlength = str2num(c_t2{1});
%     
%     % byteorderwertetyp
%     try
%     text = str_cut_ae_f(c_t2{2},' ');
%     catch
%       a = 0;
%     end
%     
%     % 2. Teil  2.Block: (faktor,offset)
%     c_t2 = str_get_quot_f(c_t{2},'(',')');
%     [c_t2,n] = str_split(c_t2{1},',');
%     
%     % faktor
%     faktor = str2num(c_t2{1});
%     % offset
%     offset = str2num(c_t2{2});
%     
%     
%     % 2. Teil  3.Block: [minval|maxval]
%     c_t2 = str_get_quot_f(c_t{3},'[',']');
%     [c_t2,n] = str_split(c_t2{1},'|');
%     
%     % minval
%     minval = str2num(c_t2{1});
%     % maxval
%     maxval = str2num(c_t2{2});
%         
%     
%     if( ~isempty(findstr(name,'ffp_force_max')) )
%         a=0;
%     end
%     % 2. Teil  4.Block: "einheit"
%     c_t2 = str_get_quot_f(c_t{4},'"','"');
%     % einheit
%     if( ~isempty(c_t2) )
%       einheit = c_t2{1};
%     else
%       einheit = '';
%     end
%     
%     % 2. Teil  4.-n.Block: empfaenger
%     text = [];
%     for i=5:length(c_t)
%         text = [text,c_t{i}];
%     end
%     
%     [c_t2,n] = str_split(text,',');
%     empfang = {};
%     for i=1:n
%         empfang{i} = str_cut_ae_f(c_t2{i},' ');
%     end

    % Signalstruktur füllen
    
    % Signal hochzählen
    is = length(dbc(ib).sig)+1;
    
    dbc(ib).sig(is).name       = name;
    dbc(ib).sig(is).nr         = is;
    dbc(ib).sig(is).typ        = typ;
    dbc(ib).sig(is).mtyp       = mtyp;
    dbc(ib).sig(is).startbit   = startbit;
    dbc(ib).sig(is).bitlength  = bitlength;
    dbc(ib).sig(is).byteorder  = byteorder;
    dbc(ib).sig(is).wertetyp   = wertetyp;
    dbc(ib).sig(is).faktor     = faktor;
    dbc(ib).sig(is).offset     = offset;
    dbc(ib).sig(is).minval     = minval;
    dbc(ib).sig(is).maxval     = maxval;
    dbc(ib).sig(is).einheit    = einheit;
    dbc(ib).sig(is).empfang    = empfang;
    dbc(ib).sig(is).s_val      = struct([]);
    dbc(ib).sig(is).comment    = '';
    
    %MinMax nachbearbeiten, wenn nicht richtig eingetragen
    if( minval == 0 & maxval == 0 )
        [minval,maxval] = can_calc_minmax(dbc(ib).sig(is));
        dbc(ib).sig(is).minval     = minval;
        dbc(ib).sig(is).maxval     = maxval;
    end
end
function startbit = dbc_read_signal_motorola_startbit(endbit,bitlength)
%
% for motorola find start bit, because info is endbit
  val = endbit;
  
  for i=1:bitlength-1
    val = val-1;
    
    if( mod((val+1),8) == 0 )
      val = val + 16;
    end
    
  end
  startbit = val;
end
function  dbc   = dbc_calc_signal(dbc,idbc,s)
        
%         if( strcmp(dbc(idbc).name,'mMotor_Flexia_neu') )
%                 indexmz = 0;
%         end
        indexmz = -1;
        for is=1:length(dbc(idbc).sig)
            if( dbc(idbc).sig(is).typ == -1 ) % Multiplexzahler
                indexmz = is;
                break;
            end
        end
        
        %Index Multiplexzaehlersignal
        dbc(idbc).indexmz = indexmz;
end     
function [dbc,s] = dbc_read_comment(dbc,tline,s);

    % gesamter Kommentar einlesen
    read_flag = 1;
    while read_flag
        
      t = strfind(tline,'"'); % Quotzeichen
      try
        tt = strfind(tline(max(t(length(t))+1,length(tline)):length(tline)),';'); % Endzeichen
        if( length(t) < 2 || length(tt) == 0 )
        
            text = fgetl(s.fid);
            s.zeile = s.zeile + 1;
            % Abbrechnen wenn Ende
            if( ~ischar(tline) )
                read_flag = 0;
            end
            tline = [tline,text];
        else
            read_flag = 0;
        end
        catch
          tline = '';
          read_flag = 0;
        end

    end
    
    if( length(tline) )
    
    % Splitten nach ' '
    tline = str_change_f(tline,'  ',' ','a');
    [c_t,n] = str_split(tline,' ');
    
    if( strcmp(c_t{2},'BU_') ) %Buskommentar
        
        if( length(dbc) > 0 )
            dbc(1).s_bus(length(dbc(1).s_bus)+1).name = c_t{3};
            c_t = str_get_quot_f(tline,'"','"');
            dbc(1).s_bus(length(dbc(1).s_bus)).comment = str_change_f(c_t{1},'''','#','a');
        end
    elseif( strcmp(c_t{2},'BO_') ) %Botschaftskommentar
        
        ident = str2num(c_t{3});
        
        % Botschaft suchen
        ibotschaft = 0;
        for ib=1:length(dbc)
            
            if( dbc(ib).ident == ident ) %gefunden
                
                ibotschaft = ib;
                break
            end
        end
        
        if( ibotschaft > 0 )
            
            c_t = str_get_quot_f(tline,'"','"');
            
            %cycle_time ausfiltern, wenn vorhanden
            [comment,cycle_time] = dbc_make_comment(c_t{1});

            dbc(ibotschaft).comment = str_change_f(comment,'''','#','a');
            dbc(ibotschaft).cycle_time = cycle_time;
        end
        
    elseif( strcmp(c_t{2},'SG_') ) %Signalkommentar
        
         ident = str2num(c_t{3});

        % Botschaft suchen
        ibotschaft = 0;
        for ib=1:length(dbc)
            
            if( dbc(ib).ident == ident ) %gefunden
                
                ibotschaft = ib;
                break;
            end
        end
        
        if( ibotschaft > 0 )

            % Signal suchen
            name = c_t{4};
            isignal = 0;
            for is=1:length(dbc(ibotschaft).sig)
                
                if( strcmp(dbc(ibotschaft).sig(is).name,name) )
                    
                    isignal = is;
                    break;
                end
            end
            
            if( isignal > 0 )
                
                c_t = str_get_quot_f(tline,'"','"');
                dbc(ibotschaft).sig(isignal).comment = str_change_f(c_t{1},'''','#','a');
            end
        end
    end
    end
end
function [dbc,s] = dbc_read_value(dbc,tline,s);

    % gesamter Valuezuordnung einlesen
    read_flag = 1;
    while read_flag
        
        t = strfind(tline,';'); % Quotzeichen
        if( length(t) == 0 )
        
            text = fgetl(s.fid);
            s.zeile = s.zeile + 1;
            % Abbrechnen wenn Ende
            if( ~ischar(text) )
                read_flag = 0;
            else
              tline = [tline,text];
            end
        else
            read_flag = 0;
        end

    end
    
    % Splitten nach ' '
    tline = str_change_f(tline,'  ',' ','a');
    [c_t,n] = str_split_quot(tline,' ','"','"');
    
    % Identifier
    ident = str2num(c_t{2});

    % Botschaft suchen
    ibotschaft = 0;
    for ib=1:length(dbc)
            
        if( dbc(ib).ident == ident ) %gefunden
                
            ibotschaft = ib;
            break;
        end
    end
        
    if( ibotschaft > 0 )

        % Signal suchen
        name = c_t{3};
        isignal = 0;
        for is=1:length(dbc(ibotschaft).sig)

            if( strcmp(dbc(ibotschaft).sig(is).name,name) )

                isignal = is;
                break;
            end
        end

        if( isignal > 0 )
            
            i=4;
            icount = 0;
            while i < length(c_t) 
                icount = icount + 1;
                dbc(ibotschaft).sig(isignal).s_val(icount).val = str2num(c_t{i});
                
                i = i+1;
                if( i <= length(c_t) )
                    
                    c_t1 = str_get_quot_f(c_t{i},'"','"');
                    if( length(c_t1) > 0 )
                        text = str_cut_ae_f(c_t1{1},' ');
                    else
                        text = '';
                    end
                    
                    dbc(ibotschaft).sig(isignal).s_val(icount).comment = text;
                

                end
                i = i+1;
            end
        end
    end
end
function dbc = dbc_read_bot_sort(dbc)

    sort_flag = 1;
    icount = 0;
    bot0 = dbc;
    s_bus = dbc(1).s_bus;
    while sort_flag & icount < 100000
        icount = icount+1;
        sort_flag = 0;
        for idbc=1:length(bot0)-1
        
            if( bot0(idbc).ident > bot0(idbc+1).ident ) %tauschen
    
                sort_flag = 1;
                bot_d = bot0(idbc);
                bot0(idbc) = bot0(idbc+1);
                bot0(idbc+1) = bot_d;
            end
        end
    end

    dbc = bot0;
    dbc(1).s_bus = s_bus;
end
function dbc = dbc_read_sig_sort(dbc)

    sort_flag = 1;
    icount = 0;
    sig0 = dbc.sig;
    while sort_flag & icount < 1000
        icount = icount+1;
        sort_flag = 0;
        for isig=1:length(sig0)-1
        
            if( sig0(isig).startbit > sig0(isig+1).startbit ) %tauschen
    
                sort_flag = 1;
                sig_d = sig0(isig);
                sig0(isig) = sig0(isig+1);
                sig0(isig+1) = sig_d;
                
            end
        end
    end
    for isig=1:length(sig0)
        sig0(isig).nr = isig;
    end
    dbc.sig = sig0;
    dbc = dbc_calc_signal(dbc,1,0);
end
function [comment,cycle_time] = dbc_make_comment(text)

  cycle_time = '';
  comment = '';

  % Kommentar innerhalb der qutation für Steuerzeichen:
  %====================================================
  c_t = str_get_quot_f(text,'@','@','i');

  tdum = [];
  for i=1:length(c_t)
      tdum = [tdum,c_t{i},';'];
  end
  i0 = str_find_f(tdum,'cycle_time','vs');
  if( i0 > 0 )
      c_t = str_get_quot_f(tdum(min(i0+1,length(tdum)):length(tdum)),':',';','i');

      if( length(c_t) > 0 )
          cycle_time = c_t{1};
          cycle_time = str_cut_ae_f(cycle_time,',');
      end
  end

  % Kommentar innerhalb der qutation für Steuerzeichen:
  %====================================================
  c_t = str_get_quot_f(text,'@','@','a');

  comment = [];
  for i=1:length(c_t)
      comment = [comment,c_t{i}];
  end
end
    