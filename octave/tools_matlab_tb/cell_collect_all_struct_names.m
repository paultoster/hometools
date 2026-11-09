function cnames = cell_collect_all_struct_names(cdata)
%
% cnames = cell_collect_all_struct_names(cdata)
%
% collects all struct names
%
% f.e.
% data{1} = a.b
% data{2} = a.c
% data{3} = a.d
% data{4} = a.c
% data{5} = a.b  => cnames = {'a','b','c'}
%
  cnames = {};
  if( iscell(cdata) )
    n = length(cdata);
    for i=1:n
      if( isstruct(cdata{i}) )
        cn = fieldnames(cdata{i});
        cnames = cell_add_if_new(cnames,cn);
      end
    end
  else
    warning('cdata in %s is not a cellarray');
  end