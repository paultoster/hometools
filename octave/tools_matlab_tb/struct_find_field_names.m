function fieldnames1 = struct_find_field_names(e,cname,type)
%
% fieldnames = struct_find_field_names(e,cname,type)
% fieldnames = struct_find_field_names(e,cname)
%
% % cname  char oder cell mit allen Namen
% type = 0 (default) muss nicht exakt der name sein
% type = 1 muss exakt sein
%
% 
  if( ischar(cname) )
    cname = {cname};
  end
  
  if( ~exist('type','var') )
    type = 0;
  end

  fieldnames1 = {};
  
  fnames = fieldnames(e);
  
  for i=1:length(cname)
        
    if( type == 1 )
      ifound = cell_find_f(fnames,cname{i},'f');
    else
      ifound = cell_find_f(fnames,cname{i},'n');
    end
    if( ~isempty(ifound) )
      for k=1:length(ifound)
        ii = ifound(k);
        
        fieldnames1 = cell_add(fieldnames1,fnames(ii));
      end
    end
  end
end
  
  
  
  
