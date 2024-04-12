function figure_set_user_data_scr(fid,data,struct_name)
% figure_set_user_data_scr(fid,data)
% figure_get_user_data_scr(fid,data,struct_name)
%
% set user data to figure with id = fid
% if struct_name (char) is not used, struct_name = 'common'
%


  if( ~exist('struct_name','var') )
    struct_name = 'common';
  end
  FH = get(fid,'userdata');
  
  FH.(struct_name) = data;
  
  set(fid,'userdata',FH);
  return
end
