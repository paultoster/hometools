function [okay,c] = struct2cell_liste(s,filename)
%
% okay     = struct_t0_cell_liste(S,filename)
% [okay,c] = struct_t0_cell_liste(S)
%
% Wandelt eine Strukt in eine cell-Liste in für ein m-File um
% damit man besser editieren kann und nachher mit cell_liste2struct
%

% type = 1 numeric
% type = 2 char
  okay = 1;
  if( ~exist('filename','var') )
    filename = 'struct2cell_liste.dat';
  end
  c_names = fieldnames(s);

  m = length(c_names);
  n = length(s);
  
  
  type = struct2cell_liste_type(s(1),c_names,m);
  struct2cell_liste_proof_length(s,n,c_names,m,type);
  ll = struct2cell_liste_var_length(s,n,c_names,m,type);
  
  c = {'  c = ...'};
  % erste Zeile mit Struct-Namen
  tt = '  {{';
  for j=1:m
    t = sprintf('''%s''',c_names{j});
    t = str_fill_left(t,' ',ll(j));
    if( j < m )
      tt = [tt,t,','];
    else
      tt = [tt,t,'} ...'];
    end      
  end      
  c = cell_add(c,tt);
  % Struct füllen
  for i=1:n
    tt = '  ,{';
    for j=1:m
      if( type(j) == 1 ) % numeric
        if( isempty(s(i).(c_names{j})) )
          t = '[]';
        else
          t = sprintf('%s',num2str(s(i).(c_names{j})));
        end
        t = str_fill_right(t,' ',ll(j));
        if( j < m )
          tt = [tt,t,','];
        else
          tt = [tt,t,'} ...'];
        end
      elseif( type(j) == 2 ) % char
        if( isempty(s(i).(c_names{j})) )
          t = '''''';
        else
          t = sprintf('''%s''',s(i).(c_names{j}));
        end
        t = str_fill_right(t,' ',ll(j));
        if( j < m )
          tt = [tt,t,','];
        else
          tt = [tt,t,'} ...'];
        end
      end
    end
    c = cell_add(c,tt);
  end      
  tt = '  };';
  c = cell_add(c,tt);
  if( nargout == 1 )
    s_file = str_get_pfe_f(filename);
    if( isempty(s_file.dir) )
      filename = fullfile(pwd,filename);
    end
    okay  = write_ascii_file(filename,c);
    fprintf('Datei mit Cellarray in: %s\n',filename);
  end
end

function type = struct2cell_liste_type(s,c_names,m)
  type = zeros(m,1);
  for j=1:m
    if( isnumeric(s.(c_names{j})) )
      type(j) = 1;
    elseif( ischar(s.(c_names{j})) )
      type(j) = 2;
    elseif( iscell(s.(c_names{j})) )
      error('Cell Type von s.%s nicht implementiert',c_names{j});
    elseif( isstruct(s.(c_names{j})) )
      error('Struct Type von s.%s nicht implementiert',c_names{j});
    elseif( ~isempty(s.(c_names{j})) )
      error('undefinierter Type von s.%s nicht implementiert',c_names{j});
    end
  end
end
function struct2cell_liste_proof_length(s,n,c_names,m,type)
  for i=1:n
    for j=1:m
      if( (type(j) == 1) && ~isempty(s(i).(c_names{j})) ) % numeric´sch und nicht leer
        if( length(s(i).(c_names{j})) > 1 )
          error('Array in einer Zelle s(i).%s nicht implemetiert',c_names{j});
        end
      end
    end
  end
end
function ll = struct2cell_liste_var_length(s,n,c_names,m,type)
  ll   = zeros(m,1); % Laenge
  for j = 1:m
   ll(j) = length(c_names{j})+2;  % 2 für Hochzeichen
   if( type(j) == 1 ) % numeric
     for i = 1:n
       tt = num2str(s(i).(c_names{j}));
       ll(j) = max(ll(j),length(tt));
     end
   elseif( type(j) == 2 ) % char
     for i = 1:n
       ll(j) = max(ll(j),length(s(i).(c_names{j}))+2); % 2 für Hochzeichen
     end
   end     
  end
end