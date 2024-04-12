function e1 = e_data_get_signals_with_name(e,channelnames,type)
%
% e1 = e_data_get_signals_with_name(e,channelnames,type)
% e1 = e_data_get_signals_with_name(e,channelnames)
%
% e  e_data-Struktur aus der gesucht wird
% channelnames  char oder cell mit allen Namen
% type = 0 (default) muss nicht exakt der name sein
% type = 1 muss exakt sein
%
  e1 = [];
  
  if( ischar(channelnames) )
    channelnames = {channelnames};
  end
  
  if( ~exist('type','var') )
    type = 0;
  end
  
  
  for i=1:length(channelnames)
    cname = channelnames{i};
    
    fnames = struct_find_field_names(e,cname,type);
    
    for j=1:length(fnames)
      
      e1.(fnames{j}) = e.(fnames{j});
    end
        
  end
end