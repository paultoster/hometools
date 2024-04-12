function okay = simulink_make_output(sim_model,sim_block_name,bus_creator_name,output_block_name)
%
% okay = simulink_make_output(sim_model,sim_block_name)
% okay = simulink_make_output(sim_model,sim_block_name,bus_creator_name)
% okay = simulink_make_output(sim_model,sim_block_name,bus_creator_name,output_block_name)
%
% sim_model                  model name z.B. 'sim_AD_Lateral_Controller'
% sim_block_name             block name for making output z.B. 'AD_Lateral_Controller'
% bus_creator_name           name of bus creator (default = 'bus_creator_block')
% output_block_name          name of output block (default = 'output_block')
%
% output will be collected to a bus-structure and send to block wich
% creates to workspace blocks
  if( ~exist('bus_creator_name','var') )
    bus_creator_name = 'bus_creator_block';
  end
  if( ~exist('output_block_name','var') )
    output_block_name = 'output_block';
  end
  okay = 1;
  sim_block_full_name = [sim_model,'/',sim_block_name];
  % vector of coordinates, in pixels: [left top right bottom]
  pos_sim_block       = get_param(sim_block_full_name, 'Position');
    
  % Iput/Output-Names of ports
  cport  =  simulink_get_port_names(sim_block_full_name,'out');
  ncport = length(cport);
  hport  = get_param(sim_block_full_name, 'PortHandles');
  
  % Startpoint upper right
  X0 =  pos_sim_block(3);
  Y0 =  pos_sim_block(2);
  % Shift relative to start point
  DX = (pos_sim_block(3) - pos_sim_block(1))/2;
  DY = 0;
  % dimension of block
  dx = 20;
  dy = pos_sim_block(4)-pos_sim_block(2);
  
  % Bus creator
  bus_creator_full_name = [sim_model,'/',bus_creator_name];
  add_block('Simulink/Signal Routing/Bus Creator',bus_creator_full_name);
  set_param(bus_creator_full_name,'Position',[ X0+DX ...
                                              , Y0+DY ...
                                              , X0+DX+dx ...
                                              , Y0+DY+dy ...
                                              ]);
  set_param(bus_creator_full_name,'Inputs',sprintf('%i',ncport));
  hbusport  = get_param(bus_creator_full_name, 'PortHandles');                                         
  
  for i=1:ncport       
    % Connect line
    add_line(sim_model,hport.Outport(i),hbusport.Inport(i),'autorouting','on');   
    % get port handle
    h_signal_line = get_param(hport.Outport(i),'Line');
    % set the name of the signal
    set_param(h_signal_line,'Name',cport{i});

  end
  
  % Bus Creator Position
  pos_creator_block   = get_param(bus_creator_full_name, 'Position');
  % Startpoint upper right
  X0 =  pos_creator_block(3);
  Y0 =  pos_creator_block(2);
  % Shift relative to start point
  DX = (pos_creator_block(3) - pos_creator_block(1));
  DY = (pos_creator_block(4) - pos_creator_block(2))/2;
  % dimension of block
  dx = 50;
  dy = 50;
  % Output-Block
  output_block_full_name = [sim_model,'/',output_block_name];
  add_block('Simulink/Ports & Subsystems/Subsystem',output_block_full_name);
  set_param(output_block_full_name,'Position',[ X0+DX ...
                                              , Y0+DY ...
                                              , X0+DX+dx ...
                                              , Y0+DY+dy ...
                                              ]);
  hblockport  = get_param(output_block_full_name, 'PortHandles');
  add_line(sim_model,hbusport.Outport(1),hblockport.Inport(1),'autorouting','on');   
  % get port handle
  h_signal_line = get_param(hbusport.Outport(1),'Line');
  % set the name of the signal
  set_param(h_signal_line,'Name',output_block_name);
  
  output_port_full_name = [sim_model,'/',output_block_name,'/Out1'];
  h_line = find_system([sim_model,'/',output_block_name], 'findall','on', 'type', 'line');

  delete_block(output_port_full_name);
  delete_line(h_line);
  % Outputs vgenerieren
  make_simulink_output('mdl',sim_model ...
                      ,'sub',output_block_name ...
                      ,'inp','In1' ...
                      ,'pre','res_' ...
                      ,'sample',0.01);


end