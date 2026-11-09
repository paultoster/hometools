function mes = can_mess_read(file)
%
% Liest Botschaft ein
% mes(i).zeit       double      Zeit
%       .kanal      double      Kanal 1,2
%       .ident      double      Identifier
%       .identhex   char        Identifier hex
%       .receive    double      1 -> receive
%                               0 -> transmit
%       .dlc        double      Anzahl Bytes
%       .val(j)     double      Werte pro byte
%       .valhex{j}  cell{char}  Werte hex pro byte
%       .tline      char        die eingelesene Zeile

mes  = struct([]);
nmes = 0;

% Datei prüfen
if( ~exist(file,'file') )
    text = sprintf('can_mess_read: übergebene Datei: <%s> ist nicht vorhanden',file);
    error(text);
else
    s.file = file;
end

s.fid = fopen(file,'r');
if( s.fid <= 0 )
    text = sprintf('can_mess_read: Probleme bei Öffnen der Datei: <%s>',file);
    error(text);
end

s.zeile  = 0;
while 1
    tline = fgetl(s.fid);
    s.zeile = s.zeile + 1;
    % Abbrechnen wenn Ende
    if( ~ischar(tline) )
        break
    end
    % Leerzeichen weg
    tline = str_cut_ae_f(tline,' ');
    % Leerzeichen reduzieren
    tline = str_change_f(tline,'  ',' ','a');
    % Aufteilen
    [c_t,n] = str_split(tline,' ');
    
    %Prüfen, ob eine empfangene Botschaft vorhanden
    % z.B.    5.7263 1  2A0             Rx   d 8 00 00 00 00 00 00 80 80
    % mindestens 6 Werte
    % 4. Wert Rx oder Tx
    % 1. wert numerisch Zeit
    % 2. Wert numersch Kanal
    % 3. wert hexadecimal
    if( n >= 6 &  ...
        (strcmp(c_t{4},'Rx') | strcmp(c_t{4},'Tx')) & ...
        length(str2num(c_t{1})) > 0 & ...
        length(str2num(c_t{2})) > 0 & ...
        is_hex(c_t{3}) ...
      ) 
    
        % neue Botschaft
        nmes = nmes+1;
        
        mes(nmes).zeit     = str2num(c_t{1});
        mes(nmes).kanal    = str2num(c_t{2});
        mes(nmes).identhex = c_t{3};
        mes(nmes).ident    = hex2dec(c_t{3});
        if( strcmp(c_t{4},'Rx') )
            mes(nmes).receive = 1;
        else
            mes(nmes).receive = 1;
        end
        
        mes(nmes).dlc      = str2num(c_t{6});
        
        for j=1:mes(nmes).dlc
            
            if( 6+j > length(c_t) )
                text = sprintf('can_mess_read: In Datei: <%s> Zeile <%i> Anzahl der bytes stimmt nicht mit dlc überein !!!',s.file,s.zeile);
                error(text);
            end
            mes(nmes).valhex{j} = c_t{6+j};
            mes(nmes).val(j)    = hex2dec(c_t{6+j});
        end
        
        mes(nmes).tline = tline;
    end
end

fclose(s.fid);