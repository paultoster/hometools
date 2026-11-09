function simulink_create_can_dbc_frames(dbc_file,modelname,cliste_message)
%
% simulink_create_can_dbc_frames(dbc_file[,modelname,cliste_message])
%
% Erstellt aus dbc-file für jede Botschaft ein Subblock in Simulink
%

if( ~exist('modelname','var') )
  modelname = 'SimulinkCANFrames';
end
if( ~exist('cliste_message','var') )
  cliste_message = {};
end

ncliste = length(cliste_message);

sfile = str_get_pfe_f(dbc_file);

%==========================================================================
%==========================================================================

% DBC-File einlesen
%------------------
dbc = can_read_dbc(dbc_file,1);

% model aufmachen
%----------------
simulink('open')
new_system(modelname)
open_system(gcs)

X0 = 20;
Y0 = 20;
DX = 170;
DY = 170;
DX1 = 40;
DY1 = 40;

  if( ncliste == 0 ) 
    use_mes = 1;
  else
    use_mes = 0;
  end

for idbc=1:length(dbc)
  
  nsig = length(dbc(idbc).sig);
  
  ifound   = cell_find_f(cliste_message,dbc(idbc).name,'fl');
  if( ~isempty(ifound) )
    use_mes = 1;
  end
  
  
  if( nsig > 0 && use_mes )
    
    DY0 = 250;
    DX0 = 250;
    subblock_name = ['Frame_',dbc(idbc).name,'_0x',dbc(idbc).identhex];
    
    add_block('built-in/SubSystem', [gcs,'/',subblock_name])
    
    xx0 = X0+(idbc/2-floor(idbc/2))*2*DX0;
    yy0 = Y0+(idbc-1)*DY0;
    
    if( yy0 > 30000. )
      yy0 = yy0 - 30000.;
      xx0 = x00 + 1000.;
    end
    
    set_param([gcs,'/',subblock_name],'Position',[xx0 ...
                                                 ,yy0 ...
                                                 ,xx0+DX ...
                                                 ,yy0+DY]);
    
    open_system([gcs,'/',subblock_name]);

    DY0 = 75;
    L1 = 400;
    block_name = [gcs,'/bus_creator'];
    add_block('Simulink/Signal Routing/Bus Creator', block_name,'Inputs',num2str(length(dbc(idbc).sig)))
    set_param(block_name,'Position',[X0+L1 Y0 X0+L1+10 Y0+DY0*length(dbc(idbc).sig)]);
    h_blkc = get_param(block_name, 'PortHandles'); 

    L1 = 500;
    block_name = [gcs,'/out_',dbc(idbc).name];
    add_block('Simulink/Sinks/Out1', block_name,'Port','1')
    set_param(block_name,'Position',[X0+L1 Y0 X0+L1+DX1 Y0+DY1]);
    h_blko = get_param(block_name, 'PortHandles');

    h = add_line(gcs,h_blkc.Outport(1),h_blko.Inport(1),'autorouting','on');
    set(h,'Name',dbc(idbc).name)

    for isig=1:length(dbc(idbc).sig)
        
        sig = dbc(idbc).sig(isig);
 
        block = [gcs,'/',sig.name];
        add_block('Simulink/Sources/In1', block,'Port',num2str(sig.nr))
        set_param(block,'Position',[X0 Y0+(isig-0.70)*DY0 X0+DX1 Y0+(isig-0.70)*DY0+DY1]);
        h_blk1 = get_param(block, 'PortHandles'); 
        
        L1 = 100;
        block_name = [gcs,'/gain',num2str(sig.nr)];
        add_block('built-in/Gain',block_name,'Gain','1.0')
        set_param(block_name,'Position',[X0+L1 Y0+(isig-0.70)*DY0 X0+L1+DX1 Y0+(isig-0.70)*DY0+DY1]);
        h_blk2 = get_param(block_name, 'PortHandles'); 

        L1 = 200;
        block_name = [gcs,'/quant',num2str(sig.nr)];
        dis_name = [num2str(sig.nr),'.LSB ',num2str(sig.faktor),' ',sig.einheit];
        add_block('built-in/Quantizer', block_name,'QuantizationInterval',num2str(sig.faktor))
        set_param(block_name,'Position',[X0+L1 Y0+(isig-0.70)*DY0 X0+L1+DX1 Y0+(isig-0.70)*DY0+DY1]);
        h_blk3 = get_param(block_name, 'PortHandles'); 
        set_param(block_name,'Name',dis_name);

        add_line(gcs,h_blk1.Outport(1),h_blk2.Inport(1),'autorouting','on');
        add_line(gcs,h_blk2.Outport(1),h_blk3.Inport(1),'autorouting','on');
        h = add_line(gcs,h_blk3.Outport(1),h_blkc.Inport(isig),'autorouting','on');
        set(h,'Name',sig.name)

    end
    
    close_system(gcs);
  end
  if( ncliste ~= 0 ) 
    use_mes = 0;
  end
end

save_system(gcs,sfile.name)
