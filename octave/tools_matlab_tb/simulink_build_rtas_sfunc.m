function simulink_build_rtas_sfunc(varargin)
%
% simulink_build_rtas_sfunc('build_name',build_name ...
%                          ,'inp_file',inp_file ...
%                          ,'out_file',out_file ...
%                          ,'sfunc_name',sfunc_name ...
%                          ,'mexw32_dir',pfad
%                          );
%
% build_name    Name des mdls
% inp_file      Input-File mit allen Inputs zu der sfunc (entsprechend rtas)
% out_file      Output-File mit allen Outputs zu der sfunc (entsprechend rtas)
% sfunc_name    Name der mexw32-dll
% mexw32_dir   Wenn definiert, wird mex-File in das aktuelle Verzeichnis 
%               kopiert, wenn neuer
% z.B.
% simulink_build_rtas_sfunc('build_name','test' ...
%                          ,'inp_file','funcemul.inp' ...
%                          ,'out_file','funcemul.out' ...
%                          ,'sfunc_name','sfunc_funcemul' ...
%                          );
% simulink_build_rtas_sfunc('build_name','hadx' ...
%                          ,'inp_file','D:\VPU_HAF\rtas\mod\HADX\bin\simulink\hadx.inp' ...
%                          ,'out_file','D:\VPU_HAF\rtas\mod\HADX\bin\simulink\hadx.out' ...
%                          ,'sfunc_name','sfunc_hadx' ...
%                          ,'mexw32_dir','D:\VPU_HAF\rtas\mod\HADX\bin\debug' ...
%                          );

build_name = 'dummy';
inp_file   = '';
out_file   = '';
sfunc_name = 'default';
mexw32_dir = '';
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
        case {'mexw32_dir'}
            mexw32_dir   = varargin{i+1};            
        otherwise
            error('%s: Attribut <%s> nicht in der Liste vorhanden',mfilename,varargin{i});
    end
    i = i+2;
end

%===============
% Get Inputnames
%===============
if( ~exist(inp_file,'file') )
  error('%s: No Inputfile: <%s>',mfilename,inp_file);
end
fid=fopen(inp_file,'rt');
i = 1;
while feof(fid) == 0
  tline = fgetl(fid);
  if (((strncmp(tline,' ',1) == 0)) && (~isempty(tline)))
    inp_name{i} = tline;
    i = i + 1;
  end
end;
fclose(fid);
n_inp=length(inp_name);
%===============
% Get Outputnames
%===============
if( ~exist(out_file,'file') )
  error('%s: No Outputfile: <%s>',mfilename,out_file);
end
fid=fopen(out_file,'rt');
i = 1;
while feof(fid) == 0
  tline = fgetl(fid);
  if (((strncmp(tline,' ',1) == 0)) && (~isempty(tline)))
    out_name{i} = tline;
    i = i + 1;
  end
end;
fclose(fid);
n_out=length(out_name);
n_max = max(n_out,n_inp);

%===============
% Copy Mexfile
%===============
if( ~isempty(mexw32_dir) )
  sfile = fullfile(mexw32_dir,[sfunc_name,'.mexw32']);
  tfile = fullfile(pwd,[sfunc_name,'.mexw32']);
  copy_file_if_newer(sfile,tfile)
end
mdl_file   = [build_name,'.mdl'];
%==============
% Open Simulink
%==============
simulink('open')
if( exist(mdl_file,'file') )
    delete(mdl_file);
end
new_system([build_name])
open_system(gcs)


XA  = 250;
YA  = 20;
DXB = 40;
DYB = 40;

DYABSTAND = 60;

%=======================
% frame  Subblock bilden
%=======================
X0 = XA+10*DXB;
Y0 = YA;
X1 = X0+10*DXB;
Y1 = Y0+n_inp*DYABSTAND;
subframe_name = [sfunc_name,'_frame'];
frame_name = [gcs,'/',subframe_name];
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
% Y0 = YA+n_max/2.*DYB;
% X1 = X0+DXB;
% Y1 = Y0+DYB;
% block_name = [frame_name,'/','In'];
% add_block('Simulink/Sources/In1', block_name)
% set_param(block_name,'Position',[X0 Y0 X1 Y1]);
% h_bl_in = get_param(block_name, 'PortHandles');


% s-function block
%=================
X0 = XA;
Y0 = YA+n_max/2.*DYB;
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
Y1 = YA+n_max*DYB;
demux_name = 'Out_Demux';
block_name = [frame_name,'/',demux_name];
add_block('Simulink/Signal Routing/Demux', block_name)
set_param(block_name,'Position',[X0 Y0 X1 Y1]);
set_param(block_name,'Outputs',num2str(n_out));
h_bl_demux = get_param(block_name, 'PortHandles');

% Verbindung Sfunc - Demux
%=========================
add_line(frame_name,[sfunc_name,'/1'],[demux_name,'/1']);

% Bus Creator 
%=============
X0 = XA+10*DXB;
Y0 = YA;
X1 = XA+11*DXB;
Y1 = YA+n_max*DYB;
buscreator_name = 'Out_BusCreator';
block_name = [frame_name,'/',buscreator_name];
add_block('Simulink/Signal Routing/Bus Creator', block_name)
set_param(block_name,'Position',[X0 Y0 X1 Y1]);
set_param(block_name,'Inputs',num2str(n_out));
h_bl_buscreate = get_param(block_name, 'PortHandles');

% Verbindung Demux - Bus Creator
%===============================
for i=1:n_out
  h = add_line(frame_name,h_bl_demux.Outport(i),h_bl_buscreate.Inport(i),'autorouting','on');
  set(h,'Name',out_name{i});
end

% Output
%=======
X0 = XA+13*DXB;
Y0 = YA+n_max/2.*DYB;
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
Y1 = Y0+n_inp*DYABSTAND;
muxinp_name = 'Inp_Mux';
block_name = [frame_name,'/',muxinp_name];
add_block('Simulink/Signal Routing/Mux', block_name)
set_param(block_name,'Position',[X0 Y0 X1 Y1]);
set_param(block_name,'Inputs',num2str(n_inp));
h_bl_muxinp = get_param(block_name, 'PortHandles');

% Verbindung Mux - sfunc
%=============================
add_line(frame_name,h_bl_muxinp.Outport(1),h_bl_sfunc.Inport(1),'autorouting','on');

% Input
%======
Y0 = YA+DYB*0.25-DYABSTAND;
for i=1:n_inp
  X0 = XA-40*DXB;
  Y0 = Y0+DYABSTAND;
  X1 = X0+DXB;
  Y1 = Y0+DYB;
  block_name = [frame_name,'/',inp_name{i}];
  add_block('Simulink/Sources/In1', block_name)
  set_param(block_name,'Position',[X0 Y0 X1 Y1]);
  
  %h_bl_const = get_param(block_name, 'DialogParameters');
  
  % Verbindung const - buscreator
  %==============================
  h = add_line(frame_name,[inp_name{i},'/1'],[muxinp_name,'/',num2str(i)]);
  set(h,'Name',inp_name{i});

end

%===========================
% frame  Subblock bearbeiten
%===========================

% Dummy Input
%============
Y0 = YA+DYABSTAND*0.9;
for i=1:n_inp
  X0 = XA+5*DXB;
  Y0 = Y0+DYABSTAND;
  X1 = X0+DXB;
  Y1 = Y0+DYB;
  block_name = [gcs,'/',inp_name{i},'_const'];
  add_block('Simulink/Sources/Constant', block_name)
  set_param(block_name,'Position',[X0 Y0 X1 Y1]);
  set_param(block_name,'Value',num2str(0.0));
  
  %h_bl_const = get_param(block_name, 'DialogParameters');
  
  % Verbindung const - buscreator
  %==============================
  h = add_line(gcs,[inp_name{i},'_const/1'],[subframe_name,'/',num2str(i)],'autorouting','on');
  set(h,'Name',inp_name{i});

end


% Terminator
%===========
X0 = XA+23*DXB;
Y0 = YA+n_inp/2.*DYABSTAND;
X1 = X0+DXB;
Y1 = Y0+DYB;
term_name = 'term';
block_name = [gcs,'/',term_name];
add_block('Simulink/Sinks/Terminator', block_name)
set_param(block_name,'Position',[X0 Y0 X1 Y1]);

% Verbindung sub frame block - Terminator
%========================================
add_line(gcs,[subframe_name,'/1'],[term_name,'/1'],'autorouting','on');


%===============
% Close Simulink
%===============
save_system(gcs,mdl_file)
close_system(gcs);
fprintf('System <%s> ist gebildet worden!\n',mdl_file);



