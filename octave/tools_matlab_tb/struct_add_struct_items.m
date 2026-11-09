function s_0 = struct_add_struct_items(s_0,s_add)
%
% s_1 = struct_add_struct_items(s_0,s_add);
%
% Beispiel
% s_0.a = 10;
% s_0.b = 20;
%
% s_add.a = 1;
% s_add.b = 2;
% s_add.c = 3;
% => s_1 = struct_add_struct_items(s_0,s_add);
% s_1(1).a = 10;
% s_1(1).b = 20;
% s_1(1).c = 0;
%
% s_1(2).a = 1;
% s_1(2).b = 2;
% s_1(2).c = 3;

if( isempty(s_0) )
  s_0 = s_add;
else

  c_n0 = fieldnames(s_0);
  n0   = length(s_0);
  c_na = fieldnames(s_add);
  na   = length(s_add);


  for i = 1:length(c_n0)

      if( isempty(cell_find_f(c_na,c_n0{i},'v')) ) % nicht gefunden

          if( ischar(s_0(1).(c_n0{i})) )
              for j=1:na
                  s_add(j).(c_n0{i}) = '';
              end
          elseif( isnumeric(s_0(1).(c_n0{i})) )
              for j=1:na
                  s_add(j).(c_n0{i}) = 0;
              end
          elseif( isstruct(s_0(1).(c_n0{i})) )
              for j=1:na
                  s_add(j).(c_n0{i}) = struct([]);
              end
          elseif( iscell(s_0(1).(c_n0{i})) )
              for j=1:na
                  s_add(j).(c_n0{i}) = {};
              end
          end
      end
  end

  c_na = fieldnames(s_add);
  for i = 1:length(c_na)



      if( isempty(cell_find_f(c_n0,c_na{i},'v')) )

          if( ischar(s_add(1).(c_na{i})) )
              for j=1:n0
                  s_0(j).(c_na{i}) = '';
              end
          elseif( isnumeric(s_add(1).(c_na{i})) )
              for j=1:n0
                  s_0(j).(c_na{i}) = 0;
              end
          elseif( isstruct(s_add(1).(c_na{i})) )
              for j=1:n0
                  s_0(j).(c_na{i}) = struct([]);
              end
          elseif( iscell(s_add(1).(c_na{i})) )
              for j=1:n0
                  s_0(j).(c_na{i}) = 70;
              end
          end
      end
  end

  s_add = struct_sortiere_wie(s_add,s_0);
  for i=n0+1:n0+na

      s_0(i) = s_add(i-n0);
  end
end        