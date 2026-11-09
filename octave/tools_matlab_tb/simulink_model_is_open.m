function isopen = simulink_model_is_open(model_name)
%
% isopen = simulink_model_is_open(model_name)
%
  isopen = 0;
  openModels = find_system('SearchDepth', 0);
  
  ifound = cell_find_f(openModels,model_name);
  
  if( ifound )
    isopen = 1;
  end
end
