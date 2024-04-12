function okay = can_mess_doublicate_asc(file_in,file_out)
%
% okay = can_mess_doublicate_asc(file_in,file_out)
%
% verdoppelt Messung indem der gleiche Inhalt nochmal mit Zeitshift
% angehängt wird
%
  okay = 1;

  if( ~exist('file_in','var') )
    error('okay = can_mess_doublicate_asc(file_in[,file_out])')
  end
  if( ~exist(file_in,'file') )
    error('Input-Asc-Datei <%s> existiert nicht!!!',file_in)
  end
  if( ~exist('file_out','var') )
    s = str_get_pfe_f(file_in);
    file_out = fullfile(s.dir,[s.name,'_dup.asc']);
  end

command = ['d:\tools\python\can_mess_doublicate_asc.py ',file_in,' ',file_out];
[status,result] = dos(command);

if( status )
    result
end

fprintf('Ausgabedatei. <%s>\n',file_out);
end
