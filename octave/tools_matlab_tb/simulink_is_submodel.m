function isfound = simulink_is_submodel(simulink_model_name,sub_model)
%
% isfound = simulink_is_submodel(simulink_model_name,sub_model)
%
% isfound = simulink_is_submodel('modname','submod');
% isfound = simulink_is_submodel('modname','submod/subsubmod');
%
% isfound = 1: 'modname/submod' or 'modname/submod/subsubmod' is found
%         = 0: not found
  isfound = 1;
  a = find_system(simulink_model_name);
  ifound = cell_find_f(a,[simulink_model_name,'/',sub_model]);
  if( isempty(ifound) )
    isfound = 0;
  end

end