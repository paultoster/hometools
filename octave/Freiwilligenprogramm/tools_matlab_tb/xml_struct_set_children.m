function [S,okay,errText] = xml_struct_set_children(S,Children,tt,sskrit,replaceFlag)
%
% [S,okay,errText] = xml_struct_set_children(S,Children,tt,sskrit,replaceFlag)
% S          xml-Struktur
% Children   struct Children, das gesetzt wird
% tt         char   Struktur-Verzweigung
%                   e.g. 'VisualStudioProject.Files.Filter'
% sskrit     char   Suchkriterium entweder
%                   '' kein kriterium, das erste wird genommen
%                   'a.abc.def' sucht Childs mit Attributes.Name = 'abc' und
%                   Attributes.Value = 'def'
% replaceFlag  0/1  Children sollen ersetzt werden oder anghängt (default:
%                   0)
  okay = 1;
  cnames = str_split(tt,'.');
  if( ~exist('sskrit','var') )
    sskrit = '';
  end
  snames = str_split(sskrit,'.');
  n = length(snames);
  if( n == 0 )
    a = [];
  elseif( n < 3 )
    error('sskrit nicht richtig angegeben z.B. a.Name.Wert')
  else
    if( str_find_f(lower(snames{1}),'a') == 1 )
      a.Name  = snames{2};
      a.Value = snames{3};
      if( n >= 4 )
        if( strcmpi(snames{4},'notexact') )
          a.valexact  = 0;
          a.nameexact = 0;
        elseif( strcmpi(snames{4},'namenotexact') )
          a.valexact = 1;
          a.nameexact = 0;
        elseif( strcmpi(snames{4},'valnotexact') )
          a.valexact = 0;
          a.nameexact = 1;
        else
          error('sskrit = %s kann an vierter Position nicht bestimmt werden Möglichkeiten ''notexact'',''namenotexact'',''valnotexact''',sskrit)
        end
      else
        a.valexact = 1;
        a.nameexact = 1;
      end
    else
      error('Der type %s ist nicht programmiert (a für Attributes geht)',snames{1});
    end
  end  
  
  if( ~exist('replaceFlag','var') )
    replaceFlag =0;
  end
  
  [S,okay,errText] = xml_struct_set_children_parse(S,Children,cnames,a,0,replaceFlag,'');
end

function [S,okay,errtext] = xml_struct_set_children_parse(S,Children,cnames,a,ebene,replaceFlag,errtext)
  okay    = 1;
  n = length(S);
  for i = 1:n
    if( strcmpi(S(i).Name,cnames{1}) )
      
       if( length(cnames) == 1 )
         if( ~isempty(a) )
           m = length(S(i).Attributes);
           flag = 0;
           for j = 1:m
             if( a.nameexact )
               nflag = strcmpi(S(i).Attributes(j).Name,a.Name);
             else
               if( str_find_f(S(i).Attributes(j).Name,a.Name) > 0 )
                 nflag = 1;
               else
                 nflag = 0;
               end
             end
             if( nflag )
               if( a.valexact )
                 vflag = strcmpi(S(i).Attributes(j).Value,a.Value);
               else
                 if( str_find_f(S(i).Attributes(j).Value,a.Value) > 0 )
                   vflag = 1;
                 else
                   vflag = 0;
                 end
               end
               if( vflag )
                 flag = 1;
                 break;
               end
             end
           end
         else
           flag = 1;
         end
         if( flag )
          if( replaceFlag ) % Ersetzten
            S(i).Children = Children;
          else
            nc0 = length(S(i).Children);
            nc  = length(Children);
            for ic=1:nc
              S(i).Children(ic+nc0) = Children(ic);
            end
          end
          return;
         end
       else
         ebene = ebene + 1;
         cnames = cell_delete(cnames,1);
         [S(i).Children,okay,errtext] = xml_struct_set_children_parse(S(i).Children,Children,cnames,a,ebene,replaceFlag,errtext);
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
 
 
