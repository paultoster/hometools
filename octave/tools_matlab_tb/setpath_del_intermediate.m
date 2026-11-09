function setpath_del_intermediate(spath)
% Function-CALL:
%
% setpath_del_intermediate(spath)
%
% deletes intermediate newdir paths if set (spath.new_set=1)
% spath.c_list  = {path1,path2,...}
%                        all intermediate passes
%
% use spath = path_add_intermediate(spath,newdir) to add intermediate path
%
if(  ~isstruct(spath) ...
  || (isstruct(spath) && ~isfield(spath,'new_set')) ...
  || (isstruct(spath) && ~isfield(spath,'c_list')) ...
  )
  spath = [];
  spath.new_set = 0;
  spath.c_list  = {};
end


p = path;
c =  str_split(p,';');
for j=1:length(spath.c_list)
  for i=1:length(c)
    if( strcmp(c{i},spath.c_list{j}) )
      rmpath(c{i})
      break
    end
  end
end
    
