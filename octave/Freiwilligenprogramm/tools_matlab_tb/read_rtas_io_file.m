function [okay,c_liste,errtext] = read_rtas_io_file(filename,itype)
%
% [okay,c_liste,errtext] = read_rtas_io_file(filename)
%
% Liest rtas inp oder out-File
%
% itype          = 0 (default) wird Liste in Liste zurückgegeben
%                = 1  wird nur liste mit den ErstNamen erstellt
%                = 2  wird nur Liste mit den ErsatzNamen erstellt, wenn
%                     nicht vorhanden, dann erst_name verwenden
% c_liste{i} = {erste_name,ersatz_name} itype = 0
% c_liste{i} = erste_name               itype = 1
% c_liste{i} = ersatz_name              itype = 2
%
%
%
 okay = 1;
 c_liste = {};
 errtext = '';
 
 if( ~exist('itype','var') )
   itype = 0;
 end
 if( ~exist(filename,'file') )
   error('Die Datei: <%s> ist nicht vorhanden',filename);
 end
 
 [okay,c_lines,nzeilen] = read_ascii_file(filename);
 if( ~okay )
   errtext = sprintf('Die Inputdatei: <%s> konnte nicht gelesen werden',filename);
   return;
 end
 c_liste = read_rtas_io_file_get_liste(c_lines,nzeilen);
 
 if( itype == 1 )
   for i=1:length(c_liste)
     c_liste{i} = c_liste{i}{1};
   end
 elseif( itype == 2 )
   for i=1:length(c_liste)
     if( length( c_liste{i} ) == 1 ) 
      c_liste{i} = c_liste{i}{1};
     else
      c_liste{i} = c_liste{i}{2};
     end
   end
 end
   
end
function  out_liste = read_rtas_io_file_get_liste(c_lines,nzeilen)
  out_liste = {};
  for i=1:nzeilen
    line = c_lines{i};
    if( (~isempty(line)) && (line(1) ~= ' ') && (line(1) ~= '%') && (line(1) ~= '!') && (line(1) ~= ';')  )
      if( str_find_f(line,',') > 0 )  % Komma getrennt
        liste = str_split(line,',');
      else
        liste = str_split(line,' ');
      end
      if( ~isempty(liste) )
        out_liste{length(out_liste)+1} = liste;
      end
    end
  end
end
