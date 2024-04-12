function path_upper = get_parent_path(act_path,nup)
%
% path_upper = get_parent_path(act_path,nup);
%
% get parent-path n-times up from act_path
%
% act_path       char     path  
% nup            num      int-number to go up
%
  if( ~exist('nup','var') )
    nup = 1;
  end
  act_path   = str_change_f(act_path,sprintf('\\'),'/');
  c_text     = str_split(act_path,'/');  
  n0         = length(c_text);  
  n1         = max(1,n0 - nup); 
  
  c          = {};
  for i=1:n1
    c        = cell_add(c,c_text{i});
  end
  
  path_upper = str_compose(c,sprintf('\\'));
end
  
  