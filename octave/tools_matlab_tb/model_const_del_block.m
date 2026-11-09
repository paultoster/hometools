function  model_const_del_block(block,type)
%
% model_const_del_block(select_block,type)
% Löscht simulinkblock und Verbindung dahin, wenn type = 'all_after',
% wird alles gelöscht, was danach an Verbindung kommt
% 

h_l = get_param(block,'LineHandles');
s_p = get_param(block,'PortConnectivity');
    
% Verbindungen davor
for i=1:length(h_l.Inport)
    delete_line(h_l.Inport(i));
end

% Lösche Block
delete_block(block);

% Nachfolgende löschen:
if( type(1) == 'a' | type(1) == 'A' )
    
    
%     % Verbindungen davor
%     for i=1:length(h_l.Outport)
%         delete_line(h_l.Outport(i));
%     end
    
    for i=1:length(s_p)
        
        if( length(s_p(i).DstBlock) > 0 )
            
            model_const_del_block(s_p(i).DstBlock,type);
        end
    end
end
