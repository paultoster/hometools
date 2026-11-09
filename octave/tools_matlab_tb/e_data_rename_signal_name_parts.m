function e = e_data_rename_signal_name_parts(e,name_part_old,name_part_new)
%
% e = e_data_rename_signal_name_parts(e,name_part_old,name_part_new);
%
% e.g.
% e = e_data_rename_signal_name_parts(e,'Pb','');
%
  cnames = e_data_get_signal_names(e,name_part_old);
  for j=1:length(cnames)
    name_old = cnames{j};
    name_new = str_change_f(name_old,name_part_old,name_part_new);
    e = e_data_rename_signal(e,name_old,name_new);
  end

end