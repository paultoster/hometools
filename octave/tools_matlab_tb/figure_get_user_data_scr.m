function data = figure_get_user_data_scr(fid,struct_name)
% data = figure_get_user_data_scr(fid)
% data = figure_get_user_data_scr(fid,struct_name)
%
% get user data from figure with id = fid
% if struct_name (char) is not used, struct_name = 'common'
%
  if( ~exist('struct_name','var') )
    struct_name = 'common';
  end
  FH = get(fid,'userdata');
  
  if(  ~isempty(FH) && isfield(FH,struct_name) )
    data = FH.(struct_name);
  else
    data = [];
  end
  return
end
