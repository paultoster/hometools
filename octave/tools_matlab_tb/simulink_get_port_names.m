function cinnames =  simulink_get_port_names(sim_block_name,type)
%
% cinnames =  simulink_get_inport_names(sim_block_name,type);
%
% cinnames =  simulink_get_inport_names('model_name/sub_model_name','in');
% cinnames = {'Input1','Input2', ... }
% coutnames =  simulink_get_inport_names('model_name/sub_model_name','out');
% coutnames = {'Output1','Output2', ... }

  cinnames ={};
  if( (type(1) == 'i') || (type(1) == 'I') )
    c = find_system(sim_block_name,'blocktype', 'Inport');
  else
    c = find_system(sim_block_name,'blocktype', 'Outport');
  end
  n = length(sim_block_name);
  for i=1:length(c)
    
    tt = c{i};
    nn = length(tt);
    if( nn > n )
      ttt = tt(n+1:end);
      if( ttt(1) == '/' )
        if( length(ttt) > 1 )
          ttt = ttt(2:end);
        else
          ttt = '';
        end
      end
      s = str_find_f(ttt,'/');
      if( length(ttt) > 0 && (s(1)==0))
        cinnames = cell_add(cinnames,ttt);
      end
    end
  end
    
    