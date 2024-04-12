function simulink_create_lookup_table_from_input_structure(inp,struct_name,liste_of_vecs)
%
% simulink_create_lookup_table_from_input_structure(inp,struct_name[,liste_of_vecs])
%
% Erstellt inputstruktur Lookup-tables
% erster Vektor ist Zeit
% alleweiteren werden als 1d-table gebidlet
%
% inp           struct       structur mit den vektoren erster Vektor Zeit
% struct_name   char         Name der Struktur z.B. 'd'
% liste_of_vecs cell         cell-Liste mit Namen der Vektoren die gebildet
%                            werden, wenn nicht angegeben, dann alle
%

dummy_name = 'dummy_abcdef426341278';
mdl_name = 'dummy_table_input';

table_pre_name = '1d-table_';

if( ~exist('struct_name','var') )
    struct_name = 'inp';
end
if( ~isstruct(inp) )
    error('inp ist keine struktur')
end

c_names = fieldnames(inp);

[n,m] = size(inp.(c_names{1}));


if( exist('liste_of_vecs','var') && iscell(liste_of_vecs) )
  
  a_names = {c_names{1}};
  for i=1:length(liste_of_vecs)
    if( ~isempty(cell_find_f(c_names,liste_of_vecs{i})) )
      a_names = cell_add(a_names,liste_of_vecs{i});
    end
  end
  c_names = a_names;

end

ntable = 0;
for i=2:length(c_names)
    
    [n1,m1] =size(inp.(c_names{i}));
    if( n == n1 && m == m1 )
        ntable = ntable + 1;
    end
end

%==========================================================================
%==========================================================================

% model aufmachen
%----------------
simulink('open')
if( exist([dummy_name,'.mdl'],'file') )
    delete([dummy_name,'.mdl']);
end
new_system(dummy_name)
open_system(gcs)

DY0 = 250;
DX0 = 250;
X0 = 20;
Y0 = 20;
DX = 170;
DY = 170;
DX1 = 40;
DY1 = 40;

subblock_name = ['Input_table'];
i = 1;
add_block('built-in/SubSystem', [gcs,'/',subblock_name])
set_param([gcs,'/',subblock_name],'Position',[X0+(i/2-floor(i/2))*2*DX0 ...
                                             ,Y0+(i-1)*DY0 ...
                                             ,X0+(i/2-floor(i/2))*2*DX0+DX ...
                                             ,Y0+(i-1)*DY0+DY]);

open_system([gcs,'/',subblock_name]);

DY0 = 100;
L1 = 400;

% Clock
%======
block_name = [gcs,'/clock'];
add_block('Simulink/Sources/Clock', block_name)
set_param(block_name,'Position',[X0 Y0 X0+DX1 Y0+DY1]);
h_blcl = get_param(block_name, 'PortHandles');


% Bus Creator
%============
block_name = [gcs,'/bus_creator'];
add_block('Simulink/Signal Routing/Bus Creator', block_name,'Inputs',num2str(ntable+1))
set_param(block_name,'Position',[X0+L1 Y0 X0+L1+10 Y0+DY0*(ntable+1)]);
h_blkc = get_param(block_name, 'PortHandles'); 

% Output
%=======
L1 = 500;
block_name = [gcs,'/table_inp'];
add_block('Simulink/Sinks/Out1', block_name,'Port','1')
set_param(block_name,'Position',[X0+L1 Y0 X0+L1+DX1 Y0+DY1]);
h_blko = get_param(block_name, 'PortHandles');

% bus creator - Outport
%======================
h = add_line(gcs,h_blkc.Outport(1),h_blko.Inport(1),'autorouting','on');
set(h,'Name','table_inp')

% Clock - Bus creator
%====================
h = add_line(gcs,h_blcl.Outport(1),h_blkc.Inport(1),'autorouting','on');
set(h,'Name','time')

Y0 = Y0+DY0;

for i=2:length(c_names)
    
    [n1,m1] =size(inp.(c_names{i}));
    if( n == n1 && m == m1 )
        

        DY0 = 75;
        L1 = 100;
        block_name = [gcs,'/',table_pre_name,c_names{i}];
        add_block('Simulink/Lookup Tables/Lookup Table', block_name)
        set_param(block_name,'Position',[X0+L1 Y0+(i-2)*100 X0+L1+200 Y0+DY0+(i-2)*100]);
%         name = [struct_name,'.',c_names{i}];
%         name = get_param(block_name,'Table');
%         set_param(block_name,'Table',name);
%         name = [struct_name,'.',c_names{1}];
%         set_param(block_name,'InputValues',name);
        h_bltb = get_param(block_name, 'PortHandles'); 
        
        % Clock - table
        h = add_line(gcs,h_blcl.Outport(1),h_bltb.Inport(1),'autorouting','on');
        % table - bus creator
        h = add_line(gcs,h_bltb.Outport(1),h_blkc.Inport(i),'autorouting','on');
        set(h,'Name',c_names{i})

    end
end
close_system(gcs);
save_system(gcs,[dummy_name,'.mdl'])
close_system(gcs)

fid1 = fopen([dummy_name,'.mdl'],'r');
fid2 = fopen([mdl_name,'.mdl'],'w');

state = 'a';
while 1
    tline = fgetl(fid1);
    if ~ischar(tline), break, end
    
    switch(state)
        case 'a'
            if( (str_find_f(tline,'BlockType','vs')>0) && (str_find_f(tline,'Lookup','vs')>0) )

                state = 'b';
                icount = 0;
            end
        case 'b'
            icount = icount + 1;
            if( icount > 2 )
                state = 'a';
            end
            if( (str_find_f(tline,'Name','vs')>0) )
                
                i0 = str_find_f(tline,table_pre_name,'vs');
                name = tline(i0+length(table_pre_name):length(tline));
                
                i0 = str_find_f(name,'"','vs');
                name = name(1:i0-1);
                
                state = 'c';
            end
        case 'c'
            if( (str_find_f(tline,'InputValues','vs')>0) && (str_find_f(tline,'[-5:5]','vs')>0) )
                
                
                tline = str_change_f(tline,'[-5:5]',[struct_name,'.',c_names{1}],'v');
                state = 'd';
                
            end
        case 'd'
            if( (str_find_f(tline,'Table','vs')>0) && (str_find_f(tline,'tanh([-5:5])','vs')>0) )
                tline = str_change_f(tline,'tanh([-5:5])',[struct_name,'.',name],'v');
                state = 'a';
            end
    end
    
    fprintf(fid2,'%s\n',tline);

end
fclose(fid1);
fclose(fid2);

delete([dummy_name,'.mdl'])

simulink('open')
open_system(mdl_name)

