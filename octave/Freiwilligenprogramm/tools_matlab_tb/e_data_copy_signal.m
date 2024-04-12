function [e,cnew,cold] = e_data_copy_signal(e,name_old,name_new)
%
% [e,cnew,cold] = e_data_copy_signal(e,name_old,name_new)
%
% 
%
  cnames = fieldnames(e);
  [cold,cnew] = cell_find_names(cnames,name_old,name_new);
  
  for i= 1:length(cold)
    e.(cnew{i}) = e.(cold{i});
  end

end