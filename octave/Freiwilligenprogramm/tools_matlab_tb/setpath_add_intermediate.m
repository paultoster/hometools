function spath = setpath_add_intermediate(spath,newdir)
%
% spath = setpath_add_intermediate(spath,newdir)
%
% adds intermediate path newdir if not in path
% start with spath = [];
% spath.new_set = 0      no path was set
%               = 1      intermediate path was set
% spath.c_list  = {path1,path2,...}
%                        all intermediate passes
%
% use setpath_del_intermediate(spath) to delete intermediate path
%
if(  ~isstruct(spath) ...
  || (isstruct(spath) && ~isfield(spath,'new_set')) ...
  )
  spath         = [];
  spath.new_set = 0;
  spath.c_list  = {};
end

if( ~exist(newdir,'dir') )
  error('newdir = <%s> is not existant',newdir);
end

p = path;
c =  str_split(p,';');
flag = 1;
for i=1:length(c)
  if( strcmp(c{i},newdir) )
    flag = 0;
    break;
  end
end

if( flag )
  addpath(newdir);
  spath.new_set = 1;
  spath.c_list{length(spath.c_list)+1} = newdir;
end
    
