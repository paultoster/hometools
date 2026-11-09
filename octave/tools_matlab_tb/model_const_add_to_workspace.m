function model_const_add_to_workspace(mdl_name,out_subblock_name,in_port_name,pre_name,sample_time);
%
% model_const_add_to_workspace(mdl_name,out_subblock_name,in_port_name, pre_name);
%
% Sucht in Modell mdl_name nach dem subblock out_subblock_name. Dort wird
% ein Inport in_port_name gesucht. Mit diesem Inport werden alle Signale
% als Vektoren in den Workspace gebracht. pre_name wird in den Namen vorne
% angefügt
%
% mdl_name          char        Modellname(nicht Filename)
% out_subblock_name char        Der Subblockname in dem die Outputs to Workspace 
%                               geschrieben werden sollen
% in_port_name      char        Name des In-Ports (Bus mit allen Output-Signalen)
% pre_name          char        ein Zusatzname, der vor den Signalnamen gesetzt wird
%                               so das im Workspace [pre_name,signal_name] zu sehen ist
% sample_time       double      Wenn ein Zero-Order Hold eingefügt werden soll muß der
%                               Wert > 0.0 sein. Wenn 0.0 oder nicht vorhanden, wird der 
%                               Wert weggelassen
%

% 'Position' = [left top right bottom] von der oberen linken Ecke gezählt

if( ~exist('sample_time','var') )
    
    sample_time = 0.0;
end

DX = 200;
DY = 100;

bus_selector_name = 'abc125634';

% model aufmachen
%----------------
simulink('open')
open_system(mdl_name)


% Suche benannten Subblock
%-------------------------
c_txt = find_system(mdl_name);

ic = cell_find_f(c_txt,[mdl_name,'/',out_subblock_name],'f');

if( length(ic) == 0 )

    error('In Modell <%s> wurde kein simulinkblock <%s> gefunden !!!!\n',mdl_name,out_subblock_name)
else
    sub_block = [mdl_name,'/',out_subblock_name];
    open_system(sub_block);
end

% suche genannten Inputport
%--------------------------
c_txt = find_system(sub_block,'blocktype', 'Inport');
ic = cell_find_f(c_txt,[mdl_name,'/',out_subblock_name,'/',in_port_name],'f');

if( length(ic) == 0 )
    error('In simulinkblock <%s/%s> wurde kein Inputport <%s> gefunden !!!!\n',mdl_name,out_subblock_name,in_port_name);
else
    in_port_block = c_txt{ic(1)};
end

% Suche nach Bus Selector
select_block = [sub_block,'/',bus_selector_name];
c_txt = find_system(sub_block,'blocktype', 'BusSelector');
ic = cell_find_f(c_txt,select_block,'f');

% Wenn gefunden löschen und neu erstellen
if( length(ic) > 0 )    
    model_const_del_block(select_block,'all_after')
end

pos_block_out = get_param(in_port_block, 'Position');
Pos = [pos_block_out(3),(pos_block_out(2)+pos_block_out(4))/2]; % right middle
liste_var_name = {};

verbinde_port(in_port_block,1,DX,DY,sub_block,bus_selector_name,'inp',1,Pos,pre_name,liste_var_name,sample_time);

function liste_var_name = verbinde_port(block_out,port_out_no,DX,DY,sub_block,next_block_name,in_bus_name,select_block_flag,Pos,pre_name,liste_var_name,sample_time)

if( ~exist('pre_name','var') | ~ischar(pre_name) )
    pre_name = '';
end

if( ~exist('liste_var_name','var' ) )
    liste_var_name = {};
end

if( ~exist('sample_time','var' ) )
    sample_time = 0.0;
end

% Infos vom übergeordneten Block
pos_block_out = get_param(block_out, 'Position');
h_block_out   = get_param(block_out, 'PortHandles'); 


if( select_block_flag ) % selectblock einfügen

    % Bus Selector
    select_block = [sub_block,'/',next_block_name];
    add_block('Simulink/Signal Routing/Bus Selector',select_block);
    h_select_block = get_param(select_block, 'PortHandles');

    % Verbindungslinie
    h_line = add_line(sub_block,h_block_out.Outport(port_out_no),h_select_block.Inport(1),'autorouting','on');

    %Eingänge bestimmen
    inp_sig = get_param(select_block, 'InputSignals');
    
    if( length(inp_sig) ==  0 )
        
        tt = sprintf('Der Sub-Block <%s> hat keine Eingangssignale',block_out);
        error(tt)
    end

    out_sig = {};
    bus_flag = {};
    % Ausgänge bestimmen
    for i=1:length(inp_sig)
    
        if( ischar(inp_sig{i}) )

            out_sig{length(out_sig)+1} = inp_sig{i};
            bus_flag{length(out_sig)} = 0;
        elseif( iscell(inp_sig{i}) )


            if( ischar(inp_sig{i}{1}) )
                out_sig{length(out_sig)+1} = inp_sig{i}{1};
                bus_flag{length(out_sig)}  = 1;            
            else
                tt = sprintf('Bei Ausgänge bestimmen: pp{i}{1} ist kein char i = %i',i);
                error(tt)
            end
        else
                tt = sprintf('Bei Ausgänge bestimmen: pp{i} ist kein char und kein cell i = %i',i);
                error(tt)
        end
    end

    out_sig_name = out_sig{1};
    for i=2:length(out_sig)        
        out_sig_name = [out_sig_name,',',out_sig{i}];
    end
    
    % Ausgangssignale und Größe festlegen
    set_param(select_block,'OutputSignals',out_sig_name)
    set_param(select_block,'Position',[Pos(1)+3*DX, Pos(2)-DY/2, ...
                                       Pos(1)+3*DX+5, Pos(2)+DY/2+DY*(length(out_sig)-1)]);

    delete_line(h_line);
    h_line = add_line(sub_block,h_block_out.Outport(port_out_no),h_select_block.Inport(1),'autorouting','on');
                                   
    for i=1:length(out_sig)
        
        Pos_new = [Pos(1)+3*DX+5,Pos(2)-DY/2+DY*(i-1)];
        if( bus_flag{i} ) % Ein weiterer Bus muß verzweigt werden
            new_name = [next_block_name,num2str(i)];
            liste_var_name = verbinde_port(select_block,i,DX,DY,sub_block,new_name,out_sig{i},1,Pos_new,pre_name,liste_var_name,sample_time);
        else % Einzelnes Signal mit To Workspace verbinden

           liste_var_name = verbinde_port(select_block,i,DX,DY,sub_block,out_sig{i},in_bus_name,0,Pos_new,pre_name,liste_var_name,sample_time);
        end
            
    end
        
else % T0 Workspace setezen
    
    % To Workspace
    % Name Prüfen
    if( str_find_f(next_block_name,'signal','vs') == 1 )
        var_name        = [pre_name,in_bus_name,'_',next_block_name];
        next_block_name = [in_bus_name,'_',next_block_name];
    else
        var_name = [pre_name,next_block_name];
    end
    
    var_name = str_change_f(var_name,{' ','(',')','{','}'},'_','a');

    % Variablen-Namen prüfen, ob schon vorhanden
    ic = 0;
    while( cell_find_f(liste_var_name,var_name,'f') > 0 )
        ic = ic+1;
        var_name = [var_name,num2str(ic)];
    end
    liste_var_name{length(liste_var_name)+1} = var_name;
    
    
    % Subsystem-Namen prüfen
    ic = 0;
    c_txt = find_system(sub_block);
    while( cell_find_f(c_txt,[sub_block,'/',next_block_name],'f') > 0 )
        
        ic = ic+1;
        next_block_name = [next_block_name,num2str(ic)];
    end
    
    if( sample_time > 0.0 )
        
        % Hold Block anlegen
        hold_block = [sub_block,'/',next_block_name,'_hold'];
        add_block('Simulink/Discrete/Zero-Order Hold',hold_block);
        h_hold_block = get_param(hold_block, 'PortHandles');

        % Sampletime
        set_param(hold_block,'SampleTime',num2str(sample_time));
        
        %Position
        set_param(hold_block,'Position',[Pos(1)+0.5*DX, Pos(2)+20, Pos(1)+1*DX, Pos(2)+40]);

        % Verbindungslinie
        h_line = add_line(sub_block,h_block_out.Outport(port_out_no),h_hold_block.Inport(1),'autorouting','on');

        % To workspace Block anlegen
        out_block = [sub_block,'/',next_block_name];
        add_block('Simulink/Sinks/To Workspace',out_block);
        h_out_block = get_param(out_block, 'PortHandles');

        % Variablen_name
        set_param(out_block,'VariableName',var_name);
        % Format
        set_param(out_block,'SaveFormat','Array');

        %Position
        set_param(out_block,'Position',[Pos(1)+1.5*DX, Pos(2)+20, Pos(1)+2*DX, Pos(2)+40]);

        % Verbindungslinie
        h_line = add_line(sub_block,h_hold_block.Outport(1),h_out_block.Inport(1),'autorouting','on');
        
    else
        
        % To workspace Block anlegen
        out_block = [sub_block,'/',next_block_name];
        add_block('Simulink/Sinks/To Workspace',out_block);
        h_out_block = get_param(out_block, 'PortHandles');

        % Variablen_name
        set_param(out_block,'VariableName',var_name);
        % Format
        set_param(out_block,'SaveFormat','Array');


        %Position
        set_param(out_block,'Position',[Pos(1)+DX, Pos(2)+20, Pos(1)+2*DX, Pos(2)+40]);

        % Verbindungslinie
        h_line = add_line(sub_block,h_block_out.Outport(port_out_no),h_out_block.Inport(1),'autorouting','on');
    
    end
end





