function mess = can_mess_read_asc_python(file)
%
% mess = can_mess_read_asc(file)
%
% Liest Botschaft aus ascii-Messung ein und legt Daten in Struktur ab:
%
% mess(i).zeit       double      Zeit
%       .kanal      double      Kanal 1,2
%       .ident      double      Identifier
%       .identhex   char        Identifier hex
%       .receive    double      1 -> receive
%                               0 -> transmit
%       .dlc        double      Anzahl Bytes
%       .val(j)     double      Werte pro byte
%       .valhex{j}  cell{char}  Werte hex pro byte
%       .tline      char        die eingelesene Zeile

mess  = struct([]);
nmess = 0;

% Datei prüfen
if( ~exist(file,'file') )
    text = sprintf('can_mess_read1: übergebene Datei: <%s> ist nicht vorhanden',file);
    error(text);
else
    s.mess_file = file;
end


% mess = mexReadCANBytes(s.mess_file);

s_file = str_get_pfe_f(s.mess_file);
s.mat_file = [s_file.dir,s_file.name,'.mat'];

command = ['d:\tools\python\can_mess_wand.py ',s.mess_file,' ',s.mat_file];
[status,result] = dos(command);

if( status )
    result
end

if( exist(s.mat_file,'file') )
    command = ['load ',s.mat_file];
    eval(command)
else
    text = sprintf('can_mess_read1: Von python wurde für Messdatei <%s> keine mat-Datei erstellt: <%s> ',s.mess_file,s.mat_file);
    error(text);
end

if( ~exist('can_data','var') )
    text = sprintf('can_mess_read1: Die von python erstellte Datei: <%s> konnte nicht eingelesen werden',s.mat_file);
    error(text);
end
icm = 0;
ncm = length(can_data);

while( icm+5 <= ncm )
    
    nmess = nmess + 1;
    
    mess(nmess).zeit     = can_data(icm+1) / 10000.0;
    mess(nmess).kanal    = can_data(icm+2);
    mess(nmess).ident    = can_data(icm+3);
    mess(nmess).identhex = dec2hex(can_data(icm+3));
    mess(nmess).receive  = can_data(icm+4);
    mess(nmess).dlc      = can_data(icm+5);
    
    icm = icm+5;

    if( icm+mess(nmess).dlc <= ncm )
        
        mess(nmess).val = [];
        mess(nmess).valhex = {};
        for i=1:mess(nmess).dlc
            mess(nmess).val(i) = can_data(icm+i);
            mess(nmess).valhex{i} = dec2hex(can_data(icm+i));
        end
        
%         if( mess(nmess).receive )
%             mess(nmess).tline = sprintf('%9.4f %i %-16s Rx    d %i ',mess(nmess).zeit ...
%                                                                     ,mess(nmess).kanal ...
%                                                                     ,mess(nmess).identhex ...
%                                                                     ,mess(nmess).dlc);
%         else
%             mess(nmess).tline = sprintf('%9.4f %i %-16s Tx    d %i',mess(nmess).zeit ...
%                                                                     ,mess(nmess).kanal ...
%                                                                     ,mess(nmess).identhex ...
%                                                                     ,mess(nmess).dlc);
%         end
%         for i=1:mess(nmess).dlc
%             
%             mess(nmess).tline = [mess(nmess).tline,' ',mess(nmess).valhex{i}];
%         end
        
        icm = icm + mess(nmess).dlc;
    end
end
                                                               