function simulink_build_rtas_sfunc_with_tables(varargin)
%
% simulink_build_rtas_sfunc_with_tables('build_name',build_name ...
%                          ,'inp_file',inp_file ...
%                          ,'out_file',out_file ...
%                          ,'sfunc_name',sfunc_name ...
%                          ,'table_file',table_file ...
%                          ,'struct_name_table',struct_name_table ...
%                          ,'x_vec_table_name',x_vec_table_name ...
%                          );
%
% build_name    Name des mdls
% inp_file      Input-File mit allen Inputs zu der sfunc (entsprechend rtas)
% out_file      Output-File mit allen Outputs zu der sfunc (entsprechend rtas)
% sfunc_name    Name der mexw32-dll
% table_file    Input-File mit allen Inputs zu sfunc, die mit 1-d-Tabelle
%               aus einer Struktur mit Vektoren bestimmt werden (entsprechend rtas)
% struct_name_table  Name der Struktur, aus der die Tabellenvektoren
%                    genommen werden z.B. 'd' (d.veca ist Vektor)
% x_vec_table_name   Name des x-Vektors für Tabelle z.B. 'time' (d.time ist
%                    Vektor)
% z.B.
% simulink_build_rtas_sfunc_with_tables('build_name','test' ...
%                          ,'inp_file','funcemul.inp' ...
%                          ,'out_file','funcemul.out' ...
%                          ,'sfunc_name','sfunc_funcemul' ...
%                          ,'table_file','funcemul_table.inp' ...
%                          ,'struct_name_table','d' ...
%                          ,'x_vec_table_name','time'
%                          );

  build_name = 'dummy';
  inp_file   = '';
  out_file   = '';
  sfunc_name = 'default';
  table_file = '';
  struct_name_table = 'd';
  x_vec_table_name  = 'time';
  i = 1;
  while( i+1 <= length(varargin) )

      switch lower(varargin{i})
          case {'build_name'}
              build_name = varargin{i+1};
          case {'inp_file'}
              inp_file   = varargin{i+1};
          case {'out_file'}
              out_file   = varargin{i+1};
          case {'sfunc_name'}
              sfunc_name   = varargin{i+1};
          case {'table_file'}
              table_file   = varargin{i+1};
          case {'struct_name_table'}
              struct_name_table   = varargin{i+1};
          case {'x_vec_table_name'}
              x_vec_table_name   = varargin{i+1};
          otherwise
              error('%s: Attribut <%s> nicht in der Liste vorhanden',mfilename,varargin{i});
      end
      i = i+2;
  end

  %===============
  % Get Inputnames
  %===============
  [okay,sfunc_inp_name,errtext] = read_rtas_io_file(inp_file,1);
  if( ~okay )
    error('%s: %s',mfilename,errtext);
  end
  n_sfunc_inp=length(sfunc_inp_name);
  %===============
  % Get Outputnames
  %===============
  [okay,sfunc_out_name,errtext] = read_rtas_io_file(out_file,1);
  if( ~okay )
    error('%s: %s',mfilename,errtext);
  end
  n_sfunc_out=length(sfunc_out_name);
  %=====================
  % Get Inputnames Table
  %=====================
  if( ~isempty(table_file) )
    [okay,table_inp_name,errtext] = read_rtas_io_file(table_file,1);
    if( ~okay )
      error('%s: %s',mfilename,errtext);
    end
    n_table_inp=length(table_inp_name);
    
    % Überprüfung 
    %------------
    cc = {};
    for i =1:n_table_inp
      if( ~isempty(cell_find_f(sfunc_inp_name,table_inp_name{i},'f')) )
        cc = cell_add(cc,table_inp_name{i});
      end
    end
    table_inp_name = cc;
    n_table_inp=length(table_inp_name);
    
  else
    n_table_inp    = 0;
    table_inp_name = {};
  end  



  mdl_file   = [build_name,'.mdl'];
  %==============
  % Open Simulink
  %==============
  simulink('open')
  close_system(build_name,0);
  if( exist(mdl_file,'file') )
      delete(mdl_file);
  end
  new_system([build_name])
  open_system(gcs)
  
  frame_base = gcs;

  XA  = 250;
  YA  = 20;
  DXB = 40;
  DYB = 40;
  DYABSTAND = 60;

  %==========================================================
  % Wenn Tabellen zu bilden sind, dann fram0 mit den Tabellen 
  % noch aussenrum bilden fram0 bilden
  %==========================================================
  if( n_table_inp )

    X0 = XA+10*DXB;
    Y0 = YA;
    X1 = X0+10*DXB;
    Y1 = Y0+n_table_inp*DYABSTAND;
    subframe_name0 = [sfunc_name,'_frame0'];
    frame_name0 = [gcs,'/',subframe_name0];
    add_block('Simulink/Ports & Subsystems/Subsystem', frame_name0)
    set_param(frame_name0,'Position',[X0 Y0 X1 Y1]);
    h_bl_frame0 = get_param(frame_name0, 'PortHandles');

    % delete Input/Output/line
    ll=find_system(frame_name0,'FindAll','on','type','line');
    delete_line(ll(1));
    delete_block([frame_name0,'/In1']);
    delete_block([frame_name0,'/Out1']);
  else
    frame_name0 = frame_base;
  end
  %=======================
  % frame  Subblock bilden
  %=======================
  [subframe_name,h_bl_frame] =simulink_build_rtas_sfunc_with_tables_frame_subblock(frame_name0 ...
                                                      ,sfunc_inp_name ...
                                                      ,n_sfunc_inp ...
                                                      ,sfunc_out_name ...
                                                      ,n_sfunc_out ...
                                                      ,sfunc_name ...
                                                      ,build_name ...
                                                      );

  %===========================
  % frame  Subblock bearbeiten
  %===========================
  if( n_table_inp )
    % Input oder Tabelle
    %===================
    table_pre_name = '1d-table_';
    Y0 = YA+DYABSTAND*0.9;
    for i=0:n_sfunc_inp
      X0 = XA+5*DXB;
      Y0 = Y0+DYABSTAND;
      X1 = X0+DXB;
      Y1 = Y0+DYB;
      
      if( i && ~isempty(cell_find_f(table_inp_name,sfunc_inp_name{i},'f')))
        % Tabelle anlegen
        %----------------
        DY0 = 75;
        L1 = 100;
        block_name = [frame_name0,'/',table_pre_name,sfunc_inp_name{i}];
        add_block('Simulink/Lookup Tables/Lookup Table', block_name)
        try
        set_param(block_name,'Position',[X0+L1,min(32000,Y0+(i-2)*100),X0+L1+200,min(32000,Y0+DY0+(i-2)*100)]);
        catch
          a=0;
        end
    %         name = [struct_name,'.',c_names{i}];
    %         name = get_param(block_name,'Table');
    %         set_param(block_name,'Table',name);
    %         name = [struct_name,'.',c_names{1}];
    %         set_param(block_name,'InputValues',name);
        h_bltb = get_param(block_name, 'PortHandles'); 

        % Clock Input - table
        add_line(frame_name0,h_clock.Outport(1),h_bltb.Inport(1),'autorouting','on');
        % table - frame
        h = add_line(frame_name0,h_bltb.Outport(1),h_bl_frame.Inport(i),'autorouting','on');
        % set(h,'Name',vec_liste{i})  
      else
        % Durchgang anlegen
        %------------------
        if( i == 0 )
          block_name = [frame_name0,'/','clock'];
          add_block('Simulink/Sources/In1', block_name)
          set_param(block_name,'Position',[X0 Y0 X1 Y1]);
          h_clock = get_param(block_name, 'PortHandles'); 
        else
          block_name = [frame_name0,'/',sfunc_inp_name{i}];
          add_block('Simulink/Sources/In1', block_name)
          set_param(block_name,'Position',[X0 Y0 X1 Y1]);
        end

        % Verbindung inp - inp
        %==============================
        if( i )
          h = add_line(frame_name0,[sfunc_inp_name{i},'/1'],[subframe_name,'/',num2str(i)],'autorouting','on');
          set(h,'Name',sfunc_inp_name{i});
        end
      end      
    end
    
    % Ausgang durchrouten
    %====================
    X0 = XA+23*DXB;
    Y0 = YA+n_sfunc_inp/2.*DYABSTAND;
    X1 = X0+DXB;
    Y1 = Y0+DYB;
    block_name = [frame_name0,'/','Out'];
    add_block('Simulink/Sinks/Out1', block_name)
    set_param(block_name,'Position',[X0 Y0 X1 Y1]);
    h_bl_out = get_param(block_name, 'PortHandles');

    % Verbindung Bus Creator - Out
    %=============================
    h = add_line(frame_name0,h_bl_frame.Outport(1),h_bl_out.Inport(1),'autorouting','on');
    %set(h,'Name',build_name);

    term_name = 'term';
    block_name = [frame_name0,'/',term_name];
    add_block('Simulink/Sinks/Terminator', block_name)
    set_param(block_name,'Position',[X0 Y0 X1 Y1]);

    % Verbindung sub frame block - Terminator
    %========================================
    add_line(frame_name0,[subframe_name,'/1'],[term_name,'/1'],'autorouting','on');
    
  end
  
  % Updaten
  %========
  h_bl_frame0 = get_param(frame_name0, 'PortHandles');

  if( n_table_inp )
    frame = frame_base;
  else
    frame = h_bl_frame;
  end
  % Dummy Input
  %============
  Y0 = YA+DYABSTAND*0.9;
  icount = 0;
  for i=0:n_sfunc_inp
    if( (i==0) || isempty(cell_find_f(table_inp_name,sfunc_inp_name{i},'f')) )
      X0 = XA+5*DXB;
      Y0 = Y0+DYABSTAND;
      X1 = X0+DXB;
      Y1 = Y0+DYB;
      if( i == 0 )
        block_name = [frame_base,'/','clock','_const'];
      else
        block_name = [frame_base,'/',sfunc_inp_name{i},'_const'];
      end
      add_block('Simulink/Sources/Constant', block_name)
      set_param(block_name,'Position',[X0 Y0 X1 Y1]);
      set_param(block_name,'Value',num2str(0.0));

      h_bl_const = get_param(block_name, 'DialogParameters');
  
      % Verbindung const - buscreator
      %==============================
      icount =icount+1;
       h = add_line(frame_base,h_bl_const.Outport(1),h_bl_frame0.Inport(icount),'autorouting','on');
       %set(h,'Name',sfunc_inp_name{i});
    end
  end


    % Terminator
    %===========
    X0 = XA+23*DXB;
    Y0 = YA+n_sfunc_inp/2.*DYABSTAND;
    X1 = X0+DXB;
    Y1 = Y0+DYB;
    term_name = 'term';
    block_name = [frame_name0,'/',term_name];
    add_block('Simulink/Sinks/Terminator', block_name)
    set_param(block_name,'Position',[X0 Y0 X1 Y1]);

    % Verbindung sub frame block - Terminator
    %========================================
    add_line(frame_name0,[subframe_name,'/1'],[term_name,'/1'],'autorouting','on');

  
  %===============
  % Close Simulink
  %===============
  save_system(build_name,mdl_file)
  close_system(build_name);
  fprintf('System <%s> ist gebildet worden!\n',mdl_file);



end
function [subframe_name,h_bl_frame] = simulink_build_rtas_sfunc_with_tables_frame_subblock(frame_name0 ...
                                                             ,sfunc_inp_name ...
                                                             ,n_sfunc_inp ...
                                                             ,sfunc_out_name ...
                                                             ,n_sfunc_out ...
                                                             ,sfunc_name ...
                                                             ,build_name ...
                                                             )                                                    
  h_bl_frame = [];
  XA  = 250;
  YA  = 20;
  DXB = 40;
  DYB = 40;
  DYABSTAND = 60;

  X0 = XA+10*DXB;
  Y0 = YA;
  X1 = X0+10*DXB;
  Y1 = Y0+max(n_sfunc_inp,n_sfunc_out)*DYABSTAND;
  subframe_name = [sfunc_name,'_frame'];
  frame_name = [frame_name0,'/',subframe_name];
  add_block('Simulink/Ports & Subsystems/Subsystem', frame_name)
  set_param(frame_name,'Position',[X0 Y0 X1 Y1]);
  h_bl_frame = get_param(frame_name, 'PortHandles');

  % delete Input/Output/line
  ll=find_system(frame_name,'FindAll','on','type','line');
  delete_line(ll(1));
  delete_block([frame_name,'/In1']);
  delete_block([frame_name,'/Out1']);

  %===========================
  % Innnerer Simulink Subblock
  %===========================

  % % In Block
  % %==================
  % X0 = XA-13*DXB;
  % Y0 = YA+max(n_sfunc_inp,n_sfunc_out)/2.*DYB;
  % X1 = X0+DXB;
  % Y1 = Y0+DYB;
  % block_name = [frame_name,'/','In'];
  % add_block('Simulink/Sources/In1', block_name)
  % set_param(block_name,'Position',[X0 Y0 X1 Y1]);
  % h_bl_in = get_param(block_name, 'PortHandles');


  % s-function block
  %=================
  X0 = XA;
  Y0 = YA+max(n_sfunc_inp,n_sfunc_out)/2.*DYB;
  X1 = X0+DXB;
  Y1 = Y0+DYB;
  block_name = [frame_name,'/',sfunc_name];
  add_block('Simulink/User-Defined Functions/S-Function', block_name)
  set_param(block_name,'Position',[X0 Y0 X1 Y1]);
  set_param(block_name,'FunctionName',sfunc_name);
  h_bl_sfunc = get_param(block_name, 'PortHandles');

  % % Verbindung In - sfunc
  % %=============================
  % add_line(frame_name,h_bl_in.Outport(1),h_bl_sfunc.Inport(1),'autorouting','on');

  % Output Demux
  %=============
  X0 = XA+3*DXB;
  Y0 = YA;
  X1 = XA+4*DXB;
  Y1 = YA+max(n_sfunc_inp,n_sfunc_out)*DYB;
  demux_name = 'Out_Demux';
  block_name = [frame_name,'/',demux_name];
  add_block('Simulink/Signal Routing/Demux', block_name)
  set_param(block_name,'Position',[X0 Y0 X1 Y1]);
  set_param(block_name,'Outputs',num2str(n_sfunc_out));
  h_bl_demux = get_param(block_name, 'PortHandles');

  % Verbindung Sfunc - Demux
  %=========================
  add_line(frame_name,[sfunc_name,'/1'],[demux_name,'/1']);

  % Bus Creator 
  %=============
  X0 = XA+10*DXB;
  Y0 = YA;
  X1 = XA+11*DXB;
  Y1 = YA+max(n_sfunc_inp,n_sfunc_out)*DYB;
  buscreator_name = 'Out_BusCreator';
  block_name = [frame_name,'/',buscreator_name];
  add_block('Simulink/Signal Routing/Bus Creator', block_name)
  set_param(block_name,'Position',[X0 Y0 X1 Y1]);
  set_param(block_name,'Inputs',num2str(n_sfunc_out));
  h_bl_buscreate = get_param(block_name, 'PortHandles');

  % Verbindung Demux - Bus Creator
  %===============================
  for i=1:n_sfunc_out
    h = add_line(frame_name,h_bl_demux.Outport(i),h_bl_buscreate.Inport(i),'autorouting','on');
    set(h,'Name',sfunc_out_name{i});
  end

  % Output
  %=======
  X0 = XA+13*DXB;
  Y0 = YA+max(n_sfunc_inp,n_sfunc_out)/2.*DYB;
  X1 = X0+DXB;
  Y1 = Y0+DYB;
  block_name = [frame_name,'/','Out'];
  add_block('Simulink/Sinks/Out1', block_name)
  set_param(block_name,'Position',[X0 Y0 X1 Y1]);
  h_bl_out = get_param(block_name, 'PortHandles');

  % Verbindung Bus Creator - Out
  %=============================
  h = add_line(frame_name,h_bl_buscreate.Outport(1),h_bl_out.Inport(1),'autorouting','on');
  set(h,'Name',build_name);

  % Mux 
  %====
  X0 = XA-5*DXB;
  Y0 = YA;
  X1 = X0+DXB;
  Y1 = Y0+n_sfunc_inp*DYABSTAND;
  muxinp_name = 'Inp_Mux';
  block_name = [frame_name,'/',muxinp_name];
  add_block('Simulink/Signal Routing/Mux', block_name)
  set_param(block_name,'Position',[X0 Y0 X1 Y1]);
  set_param(block_name,'Inputs',num2str(n_sfunc_inp));
  h_bl_muxinp = get_param(block_name, 'PortHandles');

  % Verbindung Mux - sfunc
  %=============================
  add_line(frame_name,h_bl_muxinp.Outport(1),h_bl_sfunc.Inport(1),'autorouting','on');

  % Input
  %======
  Y0 = YA+DYB*0.25-DYABSTAND;
  for i=1:n_sfunc_inp
    X0 = XA-40*DXB;
    Y0 = Y0+DYABSTAND;
    X1 = X0+DXB;
    Y1 = Y0+DYB;
    block_name = [frame_name,'/',sfunc_inp_name{i}];
    add_block('Simulink/Sources/In1', block_name)
    set_param(block_name,'Position',[X0 Y0 X1 Y1]);

    %h_bl_const = get_param(block_name, 'DialogParameters');

    % Verbindung const - buscreator
    %==============================
    h = add_line(frame_name,[sfunc_inp_name{i},'/1'],[muxinp_name,'/',num2str(i)]);
    set(h,'Name',sfunc_inp_name{i});

  end
  
  % Updaten
  %========
  h_bl_frame = get_param(frame_name, 'PortHandles');

end
