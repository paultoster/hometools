function out = struct_sortiere_nach_vorne(in,name)
% d = struct_sortiere_nach_vorne(d,name)
% Sortiert VAriable in Structur nach vorne

found = 0;

c_names = fieldnames(in);
n       = length(in);
for j=1:n
  for i=1:length(c_names)
    
    if( strcmp(c_names{i},name) )
        
        found = 1;
        out(j).(name) = in(j).(name);
        break
    end
  end
end

if( found )
  for j=1:n
    for i = 1:length(c_names)
        if( ~strcmp(c_names{i},name) )
            out(j).(c_names{i}) = in(j).(c_names{i});
        end
    end
  end
else
    out = in;
end