function okay = can_mess_write(file,mes)
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
  okay = 1;
  nmes = length(mes);

  fid = fopen(file,'w');
  if( fid <= 0 )
      error('can_mess_write: Probleme bei Öffnen der Datei: <%s>',file);
  end

  % Kopf
  zeile = ['date ',datestr(clock, 'ddd mmm dd HH:MM:SS yyyy')];
  fprintf(fid,'%s\n',zeile);
  zeile = 'base hex  timestamps absolute';
  fprintf(fid,'%s\n',zeile);
  zeile = ['Begin Triggerblock ',datestr(clock, 'ddd mmm dd HH:MM:SS yyyy')];
  fprintf(fid,'%s\n',zeile);

  % data
  for i=1:nmes
    zeile = sprintf('%11.6f%2i  %-16sRx   d %i' ...
                   ,mes(i).zeit ...
                   ,round(mes(i).kanal) ...
                   ,mes(i).identhex ...
                   ,round(mes(i).dlc));
    for j=1:round(mes(i).dlc)
      zeile = [zeile,sprintf('%3s',mes(i).valhex{j})];
    end
    fprintf(fid,'%s\n',zeile);
  end

  close(fid)
end