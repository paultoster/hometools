function okay = can_list_dbc(dbc,ctl)
% function okay = can_list_dbc(dbc,ctl)
%
% dbc-Struktur wird in excel oder ?? ausgegeben
%Input:
% dbc           struct      dbc-Struktur (siehe can_dbc_read)
% ctl.xls_file  string      Name des xls-Files
% ctl.xls_flag  double      Soll excel ausgegeben werden
% ctl.word_file string      Name der Word-Datei
% ctl.word_flag double      Soll word ausgegeben werden
% ctl.sig_num   double      =0 Signalnummer wird nicht angezeigt
%                           =1 Signalnummer wird in die erste Spalte
%                           geschrieben (Zählt über eine Botschaft)
%                           =2 Signalnummer wird in die erste Spalte
%                           geschrieben (Zählt über alle Botschaften)
%                           = -1 Es werden keine Signale angezeigt
% ctl.cheader_flag          Soll als Struktur für c-header ausgegeben
%                           werden
% ctl.cheader_file          Filename
% ctl.siglist_flag          Die dbc-Signale werden in eine Datei in der
%                           Struktur der Signamenliste geschrieben als Struktur Ssig
% ctl.siglist_file          Name der Datei, in  die die Signale
%                           geschhrieben werden (vorzugsweise m-File)
% ctl.siglist_pre_outname   Vorangestellter Name vor eigentlichen
%                           Signalname
% ctl.siglist_pre_message_name  0/1  Soll der Botschaftsname dem
%                                    Messagename mit '_' vorrangestellt werden
% ctl.english_flag          bisher nur bei xls
  if( ~isfield(ctl,'xls_flag') )
      ctl.xls_flag = 0;
  end
  if( ~isfield(ctl,'xls_file') )
      ctl.xls_file = 'dbc_excel_file.xls';
  end
  if( ~isfield(ctl,'word_flag') )
      ctl.word_flag = 0;
  end
  if( ~isfield(ctl,'word_file') )
      ctl.word_file = 'dbc_word_file.doc';
  end
  if( ~isfield(ctl,'sig_num') )
      ctl.sig_num = 0;
  end
  if( ~isfield(ctl,'cheader_flag') )
      ctl.cheader_flag = 0;
  end
  if( ~isfield(ctl,'cheader_file') )
      ctl.cheader_file = 'dbc_cheader_file.h';
  end
  if( ~isfield(ctl,'siglist_file') )
      ctl.siglist_file = 'sigList.m';
  end
  if( ~isfield(ctl,'siglist_flag') )
      ctl.siglist_flag = 0;
  end
  if( ~isfield(ctl,'siglist_pre_outname') )
      ctl.siglist_pre_outname = '';
  end
  if( ~isfield(ctl,'siglist_pre_message_name') )
      ctl.siglist_pre_outname = 0;
  end
  if( ~isfield(ctl,'siglist_build_extended_output') )
      ctl.siglist_with_name_out = 1;
  end
  if( ~isfield(ctl,'english_flag') )
      ctl.english_flag = 0;
  end
  

  if( ctl.xls_flag )

      % Datei initialisieren
      [okay,s_e] = ausgabe_excel('init','visible',1,'font_name','Arial','font_size',10);

      if( okay )        

          if( ctl.sig_num == -1)
              [okay,s_e] = can_list_dbc_bot(dbc,s_e,ctl);
          else
              [okay,s_e] = can_list_dbc_sig(dbc,s_e,ctl);
          end
      end

      % Datei speichern
      [okay,s_e] = ausgabe_excel('save',s_e,'name',ctl.xls_file);
  end
  if( ctl.word_flag )

      % Datei initialisieren
      [okay,s_a] = ausgabe_aw('init', ...
                              'ascii',0, ...
                              'word',1, ...
                              'name',ctl.word_file, ...
                              'font_name','Courier New', ...
                              'font_size',10, ...
                              'visible',1);

      if( okay )  
        [okay,s_a] = can_list_dbc_word(dbc,s_a,ctl);
        [okay,s_a] = ausgabe_aw('save',s_a);
      end
  end
  if( ctl.cheader_flag )

    fout = fopen(ctl.cheader_file,'w');

    s_f      = str_get_pfe_f(ctl.cheader_file);

    fprintf(fout,'/****************************************************/\n');
    fprintf(fout,'/* %s */\n',ctl.cheader_file);
    fprintf(fout,'/* Headerstruktur aus dbc-File: %s */\n',ctl.dbc_file);
    fprintf(fout,'/****************************************************/\n');
    fprintf(fout,'#ifndef %s_h\n#define %s_h\n',s_f.name,s_f.name);

    PreStructString = 'S';
    floattyp        = 'float';
    inttyp          = 'unsigned char';

    for i =1:length(dbc)
      can_list_dbc_bot_header(dbc(i),fout,PreStructString,floattyp,inttyp);
    end


    fprintf(fout,'#endif\n');


    fclose(fout);
    fprintf('Siehe: <%s>\n',ctl.cheader_file);
  end
  if( ctl.siglist_flag )

    fout = fopen(ctl.siglist_file,'w');

    s_f      = str_get_pfe_f(ctl.siglist_file);

    fprintf(fout,'function Ssig = %s\n',s_f.name);
    fprintf(fout,'%%****************************************************\n');
    fprintf(fout,'%% %s */\n',ctl.siglist_file);
    fprintf(fout,'%% aus dbc-File: %s */\n',ctl.dbc_file);
    fprintf(fout,'%%****************************************************\n');

    Ssig = struct([]);
    for i =1:length(dbc)
      Ssig = can_list_dbc_bot_siglist(Ssig,dbc(i),ctl.siglist_pre_outname,ctl.siglist_pre_message_name);
    end
    if( ctl.siglist_with_name_out )
      
      for i=1:length(Ssig)
        if( ~check_val_in_struct(Ssig(i),'name_out','char',1) )
            Ssig(i).name_out = Ssig(i).name_in;
        end
        if( ~check_val_in_struct(Ssig(i),'name_sign_in','char',1) )
            Ssig(i).name_sign_in = '';
        end
      end
      [Ssig, perm] = orderfields(Ssig, {'name_in', 'unit_in', 'lin_in','name_sign_in', 'name_out', 'unit_out', 'comment'});
    end
    [okay,c] = struct2cell_liste(Ssig);
    c = cell_add(c,'  Ssig = cell_liste2struct(c);');
    for i =1:length(c)
      fprintf(fout,'%s\n',c{i});
    end
    fclose(fout);
    fprintf('Siehe: <%s>\n',ctl.siglist_file);
  end
end
%================================================
%================================================
function can_list_dbc_bot_header(dbc,fout,PreStructString,floattyp,inttyp)


  fprintf(fout,'\nstruct %s%s\n{\n',PreStructString,dbc.name);

  for i=1:length(dbc.sig)

    if( strcmp(dbc.sig(i).mtyp,'N') )

      if( abs(abs(dbc.sig(i).faktor)-1.0) > 1e-6 )
        typ = floattyp;
      else 
        typ = inttyp;
      end
      fprintf(fout,'  %-20s %s; /* %s %s */\n',typ,dbc.sig(i).name,dbc.sig(i).einheit,dbc.sig(i).comment);
    end
  end
  fprintf(fout,'};\n');
end
%================================================
%================================================
function Ssig = can_list_dbc_bot_siglist(Ssig,dbc,siglist_pre_outname,siglist_pre_message_name)

  cout = {};
  iSig = length(Ssig);
  

  for i=1:length(dbc.sig)

    if( ~strcmp(dbc.sig(i).mtyp,'Z') )

      iSig = iSig + 1;

      Ssig(iSig).name_in  = dbc.sig(i).name;
      Ssig(iSig).unit_in  = dbc.sig(i).einheit;
      Ssig(iSig).lin_in   = 0;
      Ssig(iSig).name_out = dbc.sig(i).name;
      if( siglist_pre_message_name )
        Ssig(iSig).name_out = [dbc.name,'_',Ssig(iSig).name_out];
      end
      if( ~isempty(siglist_pre_outname) )
        Ssig(iSig).name_out = [siglist_pre_outname,Ssig(iSig).name_out];
      end
      Ssig(iSig).unit_out = dbc.sig(i).einheit;
      Ssig(iSig).comment  = dbc.sig(i).comment;

    end
  end
  
  
end
%================================================
%================================================
function [okay,s_e] = can_list_dbc_sig(dbc,s_e,ctl)

  okay = 1;

  % Splatenzuordnung
  %=================
  colstart   = 1;

  if( ctl.sig_num > 0 ) % Durchgehende Signalnummerierung
      colsignum    = 1;
      sugnum_index = 0;
      i = 1;
  else
      i = 0;
  end
  colsigname = i+1;
  coltyp     = i+2;
  collowhigh = i+3;
  colbit     = i+4;
  collsbmsb  = i+5;
  colbitl    = i+6;
  colcom     = i+7;
  colwbereich= i+8;
  colunit    = i+9;
  colfaktor  = i+10;
  coloffset  = i+11;
  colempf    = i+12;
  colend     = i+12;

  comwidth   = 50;    % Breite Kommentar

  % Überschriften
  %==============
  if( ctl.english_flag )
    textsignum   = 'signal number';
    textsigname  = 'signal name';
    texttyp      = 'multiplextype'; 
    texttypcom   = 'multiplextype: N: normal, Z: Multiplex-Zähler, Mi: Multiplexwert (i:index)';
    textlowhigh  = 'LowByte,HighByte'; %sprintf('%s\n%s','(Lo,Hi)','Byte Nr.');
    textbit      = 'bitLowByte,bitHighByte'; %sprintf('%s\n%s','(bitLo,bitHi)','Bit Nr.');
    textlsbmsb   = 'lsb,msb'; %sprintf('%s\n%s','(lsb,msb)','Bit Nr.');
    textbitl     = 'bitlength';
    textcom      = 'comment';
    textwbereich = sprintf('%s\n%s','Min ...','Max-Value');
    textunit     = 'unit';
    textfaktor   = 'factor';
    textoffset   = 'offset';
    textempf     = 'receiver';
    textsender   = 'transceiver';
  else
    textsignum   = 'Signalnummer';
    textsigname  = 'Signalname';
    texttyp      = 'multiplextyp'; 
    texttypcom   = 'multiplextyp: N: normal, Z: Multiplex-Zähler, Mi: Multiplexwert (i:index)';
    textlowhigh  = 'LowByte,HighByte'; %sprintf('%s\n%s','(Lo,Hi)','Byte Nr.');
    textbit      = 'bitLowByte,bitHighByte'; %sprintf('%s\n%s','(bitLo,bitHi)','Bit Nr.');
    textlsbmsb   = 'lsb,msb'; %sprintf('%s\n%s','(lsb,msb)','Bit Nr.');
    textbitl     = 'bitlength';
    textcom      = 'Kommentar';
    textwbereich = sprintf('%s\n%s','Min ...','Max-Wert');
    textunit     = 'Einheit';
    textfaktor   = 'Faktor';
    textoffset   = 'Offset';
    textempf     = 'Empfänger';
    textsender   = 'Sender';
  end

  if( ~isfield(ctl,'CAN_name') )
      ctl.CAN_name = 'CAN-Name';
  end

  % erste Zeile CAN-Name
  %======================================
  izeile = 1;
  [okay,s_e] = ausgabe_excel('cat',s_e,'col',[colstart,colend],'row',izeile,'val',ctl.CAN_name);
  [okay,s_e] = ausgabe_excel('format',s_e,'col',colstart,'row',izeile,'color','orange','font_form','bold');

  for i=1:length(dbc(1).s_bus)
      izeile = izeile+1;
      text = sprintf('%s: %s',dbc(1).s_bus(i).name,dbc(1).s_bus(i).comment);
      [okay,s_e] = ausgabe_excel('cat',s_e,'col',[1,colend],'row',izeile,'val',text);
      [okay,s_e] = ausgabe_excel('format',s_e,'col',1,'row',izeile,'color','orange','font_form','');
  end

  % Kommentar
  %==========
  izeile = izeile+1;
  [okay,s_e] = ausgabe_excel('cat',s_e,'col',[1,colend],'row',izeile);
  [okay,s_e] = ausgabe_excel('val',   s_e,'col',1,'row',izeile,'val',  texttypcom,'font_size',8);
  [okay,s_e] = ausgabe_excel('format',s_e,'col',1,'row',izeile,'color','grey');

  izeile = izeile+1;
  % Zweite Zeile Überschrift ausfüllen
  %===================================

  if( isfield(ctl,'sig_num') & ctl.sig_num > 0 ) % Durchgehende Signalnummerierung
      [okay,s_e] = ausgabe_excel('val',   s_e,'col',colsignum,'row',izeile,'val', textsignum,'font_size',8);
      [okay,s_e] = ausgabe_excel('format',s_e,'col',colsignum,'row',izeile,'orientation', 90);
  end
  [okay,s_e] = ausgabe_excel('val',   s_e,'col',colsigname,'row',izeile,'val',  textsigname);        

  [okay,s_e] = ausgabe_excel('val',   s_e,'col',coltyp,'row',izeile,'val',  texttyp,'font_size',8);
  [okay,s_e] = ausgabe_excel('format',s_e,'col',coltyp,'row',izeile,'orientation', 90);

  [okay,s_e] = ausgabe_excel('val',   s_e,'col',collowhigh,'row',izeile,'val',  textlowhigh,'font_size',8);
  [okay,s_e] = ausgabe_excel('format',s_e,'col',collowhigh,'row',izeile,'orientation', 90);

  [okay,s_e] = ausgabe_excel('val',   s_e,'col',colbit,'row',izeile,'val',  textbit,'font_size',8);
  [okay,s_e] = ausgabe_excel('format',s_e,'col',colbit,'row',izeile,'orientation', 90);

  [okay,s_e] = ausgabe_excel('val',   s_e,'col',collsbmsb,'row',izeile,'val',  textlsbmsb,'font_size',8);
  [okay,s_e] = ausgabe_excel('format',s_e,'col',collsbmsb,'row',izeile,'orientation', 90);

  [okay,s_e] = ausgabe_excel('val',   s_e,'col',colbitl,'row',izeile,'val',  textbitl,'font_size',8);
  [okay,s_e] = ausgabe_excel('format',s_e,'col',colbitl,'row',izeile,'orientation', 90);

  [okay,s_e] = ausgabe_excel('val',   s_e,'col',colcom,'row',izeile,'val',  textcom);

  [okay,s_e] = ausgabe_excel('val',   s_e,'col',colwbereich,'row',izeile,'val',  textwbereich,'font_size',8);

  [okay,s_e] = ausgabe_excel('val',   s_e,'col',colunit,'row',izeile,'val',  textunit);
  [okay,s_e] = ausgabe_excel('format',s_e,'col',colunit,'row',izeile,'orientation', 90);

  [okay,s_e] = ausgabe_excel('val',   s_e,'col',colfaktor,'row',izeile,'val',  textfaktor);
  [okay,s_e] = ausgabe_excel('format',s_e,'col',colfaktor,'row',izeile,'orientation', 90);

  [okay,s_e] = ausgabe_excel('val',   s_e,'col',coloffset,'row',izeile,'val',  textoffset);
  [okay,s_e] = ausgabe_excel('format',s_e,'col',coloffset,'row',izeile,'orientation', 90);

  [okay,s_e] = ausgabe_excel('val',   s_e,'col',colempf,'row',izeile,'val', textempf);

  [okay,s_e] = ausgabe_excel('format',s_e,'col',[colstart:colend],'row',izeile,'color','grey','row_height',60);


  for idbc = 1:length(dbc)

      izeile = izeile+1;

      % Botschaftsinfo generieren
      %==========================
      text = sprintf('Botschaftsname: %s, Ident: 0x%s, dlc:%i, cycle_time: %s %s: %s', ...
                     dbc(idbc).name, dbc(idbc).identhex, dbc(idbc).dlc, ...
                     textsender,dbc(idbc).cycle_time,dbc(idbc).sender);
      [okay,s_e] = ausgabe_excel('cat',s_e,'col',[1,colend],'row',izeile,'val',text);
      [okay,s_e] = ausgabe_excel('format',s_e,'col',1,'row',izeile,'color','yellow','font_form','bold');

      if( length(dbc(idbc).comment) > 0 )

          izeile = izeile+1;
          [okay,s_e] = ausgabe_excel('cat',s_e,'col',[1,colend],'row',izeile,'val',dbc(idbc).comment);
          [okay,s_e] = ausgabe_excel('format',s_e,'col',1,'row',izeile,'color','yellow');
      end

      % Signalinfos
      %============
      for isig = 1:length(dbc(idbc).sig)

          sig = dbc(idbc).sig(isig);
          izeile = izeile+1;

          % Signal Nummer
          if( isfield(ctl,'sig_num') & ctl.sig_num > 0 ) % Durchgehende Signalnummerierung
              if( ctl.sig_num == 1 & isig == 1 )
                  sugnum_index = 1;
              else
                  sugnum_index = sugnum_index + 1;
              end
              text = [num2str(sugnum_index),'.'];
              [okay,s_e] = ausgabe_excel('val',s_e,'col',colsignum,'row',izeile,'val',text);
          end

          %Signalname
          [okay,s_e] = ausgabe_excel('val',s_e,'col',colsigname,'row',izeile,'val',sig.name);        

          %Typ
          [okay,s_e] = ausgabe_excel('val',s_e,'col',coltyp,'row',izeile,'val',sig.mtyp);

          %Lowbyte,Highbyte
          [lowbyte,highbyte] = can_calc_lowhighbyte(sig);
          if( lowbyte == highbyte)
              text = [num2str(lowbyte)];
          else
              text = [num2str(lowbyte),', ',num2str(highbyte)];
          end
          [okay,s_e] = ausgabe_excel('val',s_e,'col',collowhigh,'row',izeile,'val',text);

          %bitLow,bitHigh
          [lsb,msb]          = can_calc_lsbmsb(sig,'b');
          if( lsb == msb )
              text = [num2str(lsb),' '];
          else
              text = [num2str(lsb),', ',num2str(msb)];
          end
          [okay,s_e] = ausgabe_excel('val',s_e,'col',colbit,'row',izeile,'val',text);
          %lsb,msb
          [lsb,msb] = can_calc_lsbmsb(sig,'a');
          if( lsb == msb )
              text = [num2str(lsb),' '];
          else
              text = [num2str(lsb),', ',num2str(msb)];
          end
          [okay,s_e] = ausgabe_excel('val',s_e,'col',collsbmsb,'row',izeile,'val',text);

          %bitlength
          [okay,s_e] = ausgabe_excel('val',s_e,'col',colbitl,'row',izeile,'val',sig.bitlength);


          % Kommentar
          ctext = str_split_format(sig.comment,comwidth,'v','left');
          text  = [];
          for i=1:length(ctext)
              if( i == length(ctext) )
                  text = [text,sprintf('%s',ctext{i})];
              else
                  text = [text,sprintf('%s\n',ctext{i})];
              end
          end
          for i=1:length(sig.s_val)
            try
              % extended message id are negativ, fix it
              text = [text,sprintf('\n0x%3s: ',dec2hex(abs(sig.s_val(i).val)))];
            catch
              
              a = 0;
            end
              ctext = str_split_format(sig.s_val(i).comment,comwidth-7,'v','left');
              for j=1:length(ctext)
                  if( j == 1 )
                      text = [text,ctext{j}];
                  else
                      text = [text,sprintf('\n0       %s',ctext{j})];
                  end
              end

          end
          [okay,s_e] = ausgabe_excel('val',s_e,'col',colcom,'row',izeile,'val',text);

          %Wertebereich
          text = sprintf('%s ...\n%s',num2str(sig.minval),num2str(sig.maxval));
          [okay,s_e] = ausgabe_excel('val',s_e,'col',colwbereich,'row',izeile,'val',text);

          % Einheit
          [okay,s_e] = ausgabe_excel('val',s_e,'col',colunit,'row',izeile,'val',sig.einheit);

          % Faktor
          [okay,s_e] = ausgabe_excel('val',s_e,'col',colfaktor,'row',izeile,'val',sig.faktor);

          % Offset
          [okay,s_e] = ausgabe_excel('val',s_e,'col',coloffset,'row',izeile,'val',sig.offset);

          % EMpfänger
          text = [];
          for i=1:length(sig.empfang)
              if( i == length(sig.empfang) )
                  text = [text,sprintf('%s',sig.empfang{i})];
              else
                  text = [text,sprintf('%s\n',sig.empfang{i})];
              end
          end
          [okay,s_e] = ausgabe_excel('val',s_e,'col',colempf,'row',izeile,'val',text);


      end
  end
  [okay,s_e] = ausgabe_excel('format',s_e,'col',[colstart:colend],'row',[1:izeile] ...
                            ,'col_width','auto','row_height','auto','border','all');
    
end
%================================================
%================================================
function [okay,s_e] = can_list_dbc_bot(dbc,s_e,ctl)

  okay = 1;

  % Splatenzuordnung
  %=================
  colstart   = 1;

  if( ctl.sig_num > 0 ) % Durchgehende Signalnummerierung
      colsignum    = 1;
      sugnum_index = 0;
      i = 1;
  else
      i = 0;
  end
  colsigname = i+1;
  coltyp     = i+2;
  collowhigh = i+3;
  colbit     = i+4;
  collsbmsb  = i+5;
  colbitl    = i+6;
  colcom     = i+7;
  colwbereich= i+8;
  colunit    = i+9;
  colfaktor  = i+10;
  coloffset  = i+11;
  colempf    = i+12;
  colend     = i+12;

  comwidth   = 50;    % Breite Kommentar

  % Überschriften
  %==============
  if( ctl.english_flag )
    textbotnr    = 'number';
    textbotname  = 'name';
    textidenthex = 'HexIdent';
    textdlc      = 'dlc';
    textcyclet   = 'cycletime';
    textsender   = 'transceiver';
    textcomm     = 'comment';
  else
    textbotnr    = 'Nummer';
    textbotname  = 'Name';
    textidenthex = 'HexIdent';
    textdlc      = 'dlc';
    textcyclet   = 'cycletime';
    textsender   = 'Sender';
    textcomm     = 'Kommentar';
  end
  colbotnr     = 1;
  colbotname   = 2;
  colidenthex  = 3;  
  coldlc       = 4;  
  colcyclet    = 5;  
  colsender    = 6;  
  colcomm    = 7;

  if( ~isfield(ctl,'CAN_name') )
      ctl.CAN_name = 'CAN-Name';
  end

  % erste Zeile CAN-Name
  %======================================
  izeile = 1;
  [okay,s_e] = ausgabe_excel('cat',s_e,'col',[colstart,colend],'row',izeile,'val',ctl.CAN_name);
  [okay,s_e] = ausgabe_excel('format',s_e,'col',colstart,'row',izeile,'color','orange','font_form','bold');

  % Kommentar
  %==========
  for i=1:length(dbc(1).s_bus)
      izeile = izeile+1;
      text = sprintf('%s: %s',dbc(1).s_bus(i).name,dbc(1).s_bus(i).comment);
      [okay,s_e] = ausgabe_excel('cat',s_e,'col',[1,colend],'row',izeile,'val',text);
      [okay,s_e] = ausgabe_excel('format',s_e,'col',1,'row',izeile,'color','orange','font_form','');
  end

  izeile = izeile+1;
  % Überschrift ausfüllen
  %===================================
  if(colbotnr>0)
      [okay,s_e] = ausgabe_excel('val',   s_e,'col',colbotnr,'row',izeile,'val', textbotnr);
  end
  if(colbotname>0)
      [okay,s_e] = ausgabe_excel('val',   s_e,'col',colbotname,'row',izeile,'val',  textbotname);        
  end
  if(colidenthex>0)
      [okay,s_e] = ausgabe_excel('val',   s_e,'col',colidenthex,'row',izeile,'val',  textidenthex);        
  end
  if(coldlc>0)
      [okay,s_e] = ausgabe_excel('val',   s_e,'col',coldlc,'row',izeile,'val',  textdlc);        
  end
  if(colcyclet>0)
      [okay,s_e] = ausgabe_excel('val',   s_e,'col',colcyclet,'row',izeile,'val',  textcyclet);        
  end
  if(colsender>0)
      [okay,s_e] = ausgabe_excel('val',   s_e,'col',colsender,'row',izeile,'val',  textsender);        
  end
  if(colcomm>0)
      [okay,s_e] = ausgabe_excel('val',   s_e,'col',colcomm,'row',izeile,'val',  textcomm);        
  end

  for idbc = 1:length(dbc)

      izeile = izeile+1;

      % Botschaftsinfo generieren
      %==========================
      if(colbotnr>0)
      [okay,s_e] = ausgabe_excel('val',   s_e,'col',colbotnr,'row',izeile,'val', idbc);
      end
      if(colbotname>0)
      [okay,s_e] = ausgabe_excel('val',   s_e,'col',colbotname,'row',izeile,'val', dbc(idbc).name);
      end
      if(colidenthex>0)
      [okay,s_e] = ausgabe_excel('val',   s_e,'col',colidenthex,'row',izeile,'val', ['0x',dbc(idbc).identhex]);
      end
      if(coldlc>0)
      [okay,s_e] = ausgabe_excel('val',   s_e,'col',coldlc,'row',izeile,'val', dbc(idbc).dlc);
      end
      if(colcyclet>0)
      [okay,s_e] = ausgabe_excel('val',   s_e,'col',colcyclet,'row',izeile,'val', dbc(idbc).cycle_time);
      end
      if(colsender>0)
          [okay,s_e] = ausgabe_excel('val',   s_e,'col',colsender,'row',izeile,'val', dbc(idbc).sender);
      end
      if(colcomm>0)
          [okay,s_e] = ausgabe_excel('val',   s_e,'col',colcomm,'row',izeile,'val', dbc(idbc).comment);
      end


  %     if( length(dbc(idbc).comment) > 0 )
  % 
  %         izeile = izeile+1;
  %         [okay,s_e] = ausgabe_excel('cat',s_e,'col',[1,colend],'row',izeile,'val',dbc(idbc).comment);
  %         [okay,s_e] = ausgabe_excel('format',s_e,'col',1,'row',izeile,'color','yellow');
  %     end

  end
  [okay,s_e] = ausgabe_excel('format',s_e,'col',[colstart:colend],'row',[1:izeile] ...
                            ,'col_width','auto','row_height','auto','border','all');
end
%================================================
%================================================
function [okay,s_a] = can_list_dbc_word(dbc,s_a,ctl)
  comwidth   = 50;    % Breite Kommentar
  if( ctl.sig_num > 0 ) % Durchgehende Signalnummerierung
      colsignum    = 1;
      sugnum_index = 0;
  end

  textarray = {};

  % Überschrift
  %============
  irow = 1;
  icol = 1;
  if( isfield(ctl,'sig_num') && ctl.sig_num > 0 ) % Durchgehende Signalnummerierung
    textarray{irow,icol} = 'sigNum';
    icol = icol+1;
  end

  textarray{irow,icol} = 'Name';
  icol = icol+1;

  textarray{irow,icol} = 'Comment';
  icol = icol+1;

  textarray{irow,icol} = 'Range';
  icol = icol+1;

  textarray{irow,icol} = 'Unit';
  icol = icol+1;

  textarray{irow,icol} = 'Res';
  icol = icol+1;

  for idbc = 1:length(dbc)

    % Botschaft
    %==========
    irow = irow+1;
    icol = 1;
    tt = sprintf('MESSAGE:%s ID:%s DLC:%i',dbc(idbc).name,['0x',dbc(idbc).identhex],dbc(idbc).dlc);

    textarray{irow,icol} = char(tt);

    % Signalinfos
    %============
    for isig = 1:length(dbc(idbc).sig)

      % Signal
      %=======

      sig = dbc(idbc).sig(isig);
      irow = irow+1;
      icol = 1;
      % Signal Nummer
      if( isfield(ctl,'sig_num') && ctl.sig_num > 0 ) % Durchgehende Signalnummerierung
        if( ctl.sig_num == 1 && isig == 1 )
           sugnum_index = 1;
        else
           sugnum_index = sugnum_index + 1;
        end
        tt = [num2str(sugnum_index),'.'];
        textarray{irow,icol} = char(tt);
        icol = icol+1;
      end

      textarray{irow,icol} = char(sig.name);
      icol = icol+1;

      % Kommentar
      ctext = str_split_format(sig.comment,comwidth,'v','left');
      tt  = [];
      for i=1:length(ctext)
          if( i == length(ctext) )
              tt = [tt,sprintf('%s',ctext{i})];
          else
              tt = [tt,sprintf('%s\n',ctext{i})];
          end
      end
      for i=1:length(sig.s_val)
          % negative ids!!!!
          tt = [tt,sprintf('\n0x%3s: ',dec2hex(abs(sig.s_val(i).val)))];
          ctext = str_split_format(sig.s_val(i).comment,comwidth-7,'v','left');
          for j=1:length(ctext)
              if( j == 1 )
                  tt = [tt,ctext{j}];
              else
                  tt = [tt,sprintf('\n0       %s',ctext{j})];
              end
          end
      end
      textarray{irow,icol} = char(tt);
      icol = icol+1;

      %Wertebereich
      tt = sprintf('%s ...\n%s',num2str(sig.minval),num2str(sig.maxval));
      textarray{irow,icol} = char(tt);
      icol = icol+1;

      % Einheit
      textarray{irow,icol} = char(sig.einheit);
      icol = icol+1;

      % Faktor
      textarray{irow,icol} = num2str(sig.faktor);
      icol = icol+1;
    end
  end

  [okay,s_a] = ausgabe_aw('table',s_a,'tablearray',textarray);

end
%================================================
%================================================
    
