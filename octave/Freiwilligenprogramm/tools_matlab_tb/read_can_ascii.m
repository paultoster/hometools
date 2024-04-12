function [okay,e] = read_can_ascii(can_asc_file,dbc_file,channel,c_signale)
%
% [okay,e] = read_can_ascii(can_asc_file,dbc_file,channel,c_signale)
%
% can_asc_file    char   CAN-Ascii-File
% dbc_file        char   CAN-Ascii-File
% channel         double Kanal beginnend bei 1
%
% okay = 1        double  okay
% e.(c_signale{i}).time    double Vektor mit Zeit
% e.(c_signale{i}).vec     double Vektor mit Werten
% e.(c_signale{i}).unit    char   Einheit aus Dbc

  okay = 1;

  if( ~exist(dbc_file,'file') )
    warning('dbc-Datei <%s> existiert nicht',dbc_file);
    okay = 0;
    return
  end
  if( ~exist(can_asc_file,'file') )
    warning('CAN-Datei <%s> existiert nicht',can_asc_file);
    okay = 0;
    return
  end
  if( ~exist('c_signale','var') )
    c_signale = {};
  end
  
  
  
  fprintf('-> CAN-Ascii-lesen\n');
  % Über mex-File einlesen
  % a  = mexReadCanAscii2_Messages(can_asc_file,dbc_file,channel);
  e  = mexReadCanAscii2(can_asc_file,dbc_file,channel,c_signale);
  fprintf('<- CAN-Ascii-lesen\n');
  

%   %dbc-Struktur
%   %============
%   tic
%   fprintf('-> dbc-erstellen\n');
%   dbc = can_read_dbc(dbc_file);
%   fprintf('<- dbc-erstellen()\n');
%   toc
% 
%   ndbc  = length(dbc);
%   ndbc1 = 0;
%   % Signal-Liste durchgehen
%   %========================
%   if( isempty(c_signale) )
%    for idbc = 1:ndbc
%       for ids = 1:length(dbc(idbc).sig)
%         c_signale{length(c_signale)+1} = dbc(idbc).sig(ids).name;
%       end
%    end
%   else
%     for idbc = 1:ndbc
%       flag = 0;
%       for ids = 1:length(dbc(idbc).sig)
% 
%         for isig = 1:length(c_signale)
% 
%           if( strcmp(dbc(idbc).sig(ids).name,c_signale{isig}) )
% 
%             flag = 1;
%             break;
%           end
%         end
%         if( flag )
%           break;
%         end
%       end
%       if( flag )
%         ndbc1 = ndbc1+1;
%         dbc1(ndbc1) = dbc(idbc);
%       end
%     end
%     dbc  = dbc1;
%     ndbc = ndbc1;    
%   end
%   ident_vec = zeros(ndbc,1);
%   for idbc=1:ndbc
%     ident_vec(idbc) = dbc(idbc).ident;
%   end
% 
% 
%   % Jede BotschaftsID seperat verarbeiten
%   %======================================
%   e = struct;
%   tic
%   fprintf('-> CAN-Ascii-lesen\n');
%   runflag = 1;
%   istart  = 1;
%   count   = 0;
%   while( runflag )
%     count = count+1;
%     if( count > 1 )
%       fprintf('   %i. Einlesen\n',count);
%     end
%     %mess-Struktur
%     %============
%     [m,ntoget] = mexReadCanAscii(can_asc_file,channel,ident_vec,100000,istart); 
%     nget = length(m);
%     if( (nget+(istart-1)) >= ntoget )
%       runflag = 0;
%     else
%       istart = istart+nget;
%     end
%     e = read_can_ascii_wand_to_val(e,m,dbc,c_signale);
%   end
%   fprintf('<- CAN-Ascii-lesen\n');
%   toc
%   
end
% function e = read_can_ascii_wand_to_val(e,m,dbc,c_signale)
% 
%   nm    = length(m);
%   ndbc  = length(dbc);
%   ncsig = length(c_signale);
%   
%   % Jedes Mess-Item durchgehen
%   for im=1:nm
%     % dbc suchen
%     idd = 0;
%     for id = 1:ndbc
%       if( dbc(id).ident == m(im).ident )
%         idd = id;
%         break;
%       end
%     end
%     % item auswerten
%     if( idd > 0 )
%       nsig  = length(dbc(idd).sig);
%       % Indexliste mit gewünschten Signalen erstellen
%       index_liste = [];
%       for isig=1:nsig
%         for icsig=1:ncsig
%           if( strcmp(c_signale{icsig},dbc(idd).sig(isig).name) )
%             % Indexliste füllen
%             index_liste(length(index_liste)+1) = isig;
%             % Struct-Element erstellen, falls nicht vorhanden
%             if( ~isfield(e,dbc(idd).sig(isig).name) )
%               e.(dbc(idd).sig(isig).name).vec  = [];
%               e.(dbc(idd).sig(isig).name).time = [];
%               e.(dbc(idd).sig(isig).name).unit = dbc(idd).sig(isig).einheit;
%             end
%           end
%         end
%       end
%       % Werte aus Indexliste bestimmen
%       for iind=1:length(index_liste)
%         
%         isig = index_liste(iind);
%         % Rohwert
%         valdec = mexCalcCanByte(m(im).dlc ...
%                                ,m(im).bytes ...
%                                ,dbc(idd).sig(isig).startbit ...
%                                ,dbc(idd).sig(isig).bitlength ...
%                                ,dbc(idd).sig(isig).wertetyp ...
%                                ,dbc(idd).sig(isig).byteorder);
%         % Werte übergeben                
%         e.(dbc(idd).sig(isig).name).time = [e.(dbc(idd).sig(isig).name).time ...
%                                            ;m(im).time]; 
%         e.(dbc(idd).sig(isig).name).vec  = [e.(dbc(idd).sig(isig).name).vec ...
%                                            ;valdec*dbc(idd).sig(isig).faktor+dbc(idd).sig(isig).offset];
%       end
%     end
%   end
% end
