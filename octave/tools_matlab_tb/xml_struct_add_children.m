function [S,okay,errText] = xml_struct_add_children(S,Children,tt)
%
% [S,okay,errText] = xml_struct_set_children(S,Children,add_children,sskrit,replaceFlag)
% S          xml-Struktur
% Children   struct Children, die hinzugefügt werden
% tt         char   Struktur-Verzweigung
%                   e.g. 'VisualStudioProject.Files.Filter'
% replaceFlag  0/1  Children sollen ersetzt werden oder anghängt (default:
%                   0)
  okay = 1;
  cnames = str_split(tt,'.');
  
  % Children prüfen
  if( ~isfield(Children,'Name') )
    error('%s_error: In der zu addierenden struktur Children fehlt Strukturelement: Name (=''abc'')',mfilename);
  end
  if( ~isfield(Children,'Attributes') )
    error('%s_error: In der zu addierenden struktur Children fehlt Strukturelement: Attributes (=[])',mfilename);
  end
  if( ~isfield(Children,'Data') )
    error('%s_error: In der zu addierenden struktur Children fehlt Strukturelement: Data (='')',mfilename);
  end
  if( ~isfield(Children,'Children') )
    error('%s_error: In der zu addierenden struktur Children fehlt Strukturelement: Children (=[])',mfilename);
  end
    
  [S,okay,errText] = xml_add_cildren_parse(S,Children,cnames,0,'');
end

function [S,okay,errtext] = xml_add_cildren_parse(S,Children,cnames,ebene,errtext)
  okay    = 1;
  n = length(S);
  for i = 1:n
    if( strcmpi(S(i).Name,cnames{1}) )
      
       if( length(cnames) == 1 )
         m = length(Children);
         for j=1:m
           k = length(S(i).Children);
           S(i).Children(k+1) = Children(j);
         end
         return;
       else
         ebene = ebene + 1;
         cnames = cell_delete(cnames,1);
         [S(i).Children,okay,errtext] = xml_add_cildren_parse(S(i).Children,Children,cnames,ebene,errtext);
         if( okay ),return; end
       end
    end
  end
  % nichtsgefunden
  okay = 0;
  if( isempty(errtext) )
    errtext = sprintf('In der Ebene <%i> kann Child mit Name:''%s'' nicht gefunden werden',ebene,cnames{1});
  end
end
 
 
