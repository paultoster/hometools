function e = e_data_rename_signal(e,name_old,name_new)
%
% e = e_data_rename_signal(e,name_old,name_new)
%
% 
%
  cnames = fieldnames(e);
  [cold,cnew] = cell_find_names(cnames,name_old,name_new);
  
  for i= 1:length(cold)
    ss = e.(cold{i});
    e  = rmfield(e,cold{i});
    e.(cnew{i}) = ss;
  end

end