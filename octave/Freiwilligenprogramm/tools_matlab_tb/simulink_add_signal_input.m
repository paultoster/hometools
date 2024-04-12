function okay = simulink_add_signal_input(sim_model,sim_block_name,s)
%
% okay = simulink_add_signal_input(sim_model,sim_block_name,sinput)
%
% sim_model                  model name z.B. 'sim_AD_Lateral_Controller'
% sim_block_name             block name for adding input z.B. 'AD_Lateral_Controller'
% s(i).signalname            name of e-struktur e.signalname.time und
%                            e.signalname.vec vorhanden
% s(i).portname              portname des Eingangs z.B. LatCntrlActive
%
  okay = 1;
  sim_block_full_name = [sim_model,'/',sim_block_name];
  % vector of coordinates, in pixels: [left top right bottom]
  pos_sim_block       = get_param(sim_block_full_name, 'Position');
    
  % Iput/Output-Names of ports
  cport  =  simulink_get_port_names(sim_block_full_name,'in');
  ncport = length(cport);
  hport  = get_param(sim_block_full_name, 'PortHandles');
  
  % Startpoint upper left
  X0 =  pos_sim_block(1);
  Y0 =  pos_sim_block(2);
  % Shift relative to start point
  DX1 = 100;
  DX = (pos_sim_block(3) - pos_sim_block(1))/2;
  DY = (pos_sim_block(4)-pos_sim_block(2))/ncport;
  % dimension of block
  dx = DX/4;
  dy = DY*0.7;
  
  for i=1:length(s)
    
    if( ~check_val_in_struct(s(i),'portname','char',1,0) )
      s(i).portname = signalname;
    end
    if( ~check_val_in_struct(s(i),'outdatatype','char',1,0) )
      s(i).outdatatype = '';
    end
    ifound = cell_find_f(cport,s(i).portname);
    
    if( ~isempty(ifound) )
      
      % From Workspace-Block
      full_signal_block_name = [sim_model,'/',s(i).portname]; 
      try
      add_block('Simulink/Sources/From Workspace',full_signal_block_name);
      catch
        a = 0;
      end
      set_param(full_signal_block_name,'Position',[ X0-DX1-DX ...
                                                 , Y0+(i-1)*DY ...
                                                 , X0-DX1-DX+dx ...
                                                 , Y0+(i-1)*DY+dy ...
                                                 ]);
      % Conversion-Block
      full_convert_block_name = [sim_model,'/convert_',s(i).portname]; 
      add_block('Simulink/Signal Attributes/Data Type Conversion',full_convert_block_name);
      set_param(full_convert_block_name,'Position',[ X0-DX ...
                                                 , Y0+(i-1)*DY ...
                                                 , X0-DX+dx ...
                                                 , Y0+(i-1)*DY+dy ...
                                                 ]);
      %  Lines
      hportsignalblock   = get_param(full_signal_block_name, 'PortHandles');
      hportconvertblock  = get_param(full_convert_block_name, 'PortHandles');
      
      add_line(sim_model,hportsignalblock.Outport(1),hportconvertblock.Inport(1),'autorouting','on');
      add_line(sim_model,hportconvertblock.Outport(1),hport.Inport(ifound(1)),'autorouting','on');

           
      % set Data
      tt = ['[e.',s(i).signalname,'.time,e.',s(i).signalname,'.vec]'];
      set_param(full_signal_block_name,'VariableName',tt);
      if( ~isempty(s(i).outdatatype) )
        set_param(full_convert_block_name,'OutDataTypeStr',s(i).outdatatype);
      end

    end
  end
end