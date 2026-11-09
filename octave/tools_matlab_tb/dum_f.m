function choice = o_listen_abfrage_f(liste,fid_proto,remote_struct)
%
% Abfrage einer Liste auf Matlabebene
% liste         enthält in einem cell-array die listeabfrage
%
% fid_proto     ist die Ausgabe fid für das Protokoll
%
% remote_struct Struktur mit den remote eingaben, wenn nicht vorhanden oder
%               keine Struktur dann ignorieren
%
%
proto_flag = 1;
remote_flag = 1;
if( nargin == 1 )
    
    proto_flag = 0;
    remote_flag = 0;
    
elseif( nargin == 2 )
    
    if( fid_proto < 0 )
        proto_flag = 0;
    end
    rmote_flag = 0;
elseif( nargin == 3 )
    
    if( fid_proto < 0 )
        proto_flag = 0;
    end
    if( ~strcmp(class(remote_struct),'struct') )
        remote_flag = 0;
    end
end

n = length(liste);
count = 0;
end_flag = 0;
while( ~end_flag )
    count = count + 1;
    if( proto_flag & (count == 1) )
        fprintf(fid_proto,'%%--------------------------------------------------------\n');
        for i=1:n
            fprintf(fid_proto,'%% %i %s\n',i-1,liste{i});
        end
    fprintf(fid_proto,'%%--------------------------------------------------------\n');
    end
    fprintf('\n--------------------------------------------------------\n');
    for i=1:n
        fprintf('%i %s\n',i-1,liste{i});
    end
    fprintf('\n--------------------------------------------------------\n\n');
    
    if( remote_flag )
        [choice,okay] = o_get_remote_command(remote_struct);
        if( ~okay )
            remote_flag = 0;
        end
    end
    if( ~remote_flag )
        choice = input('Auswahl ? : ','s');
    end
        

    
    if( length(choice) > 0 )
        end_flag = 1;
    end
    choice = floor(str2num(choice));
    choice = max(min(floor(choice),n-1),0);
end

if( proto_flag )
    fprintf(fid_proto,'%i\n',choice)
end
    