function find_in_pbot(pbot,search_name)
%
search_name = lower(search_name);

for ipbot=1:length(pbot)
    
    head_flag = 1;
    
    for isig=1:length(pbot(ipbot).sig)

        sig_name = lower(pbot(ipbot).sig(isig).name);
        if( length(strfind(sig_name,search_name)) > 0 )
            
            if( head_flag )
                fprintf('\npbot(%i).name: %s\n',ipbot,pbot(ipbot).name);
                head_flag = 0;
            end
            fprintf('pbot(%i).sig(%i).name: %s\n',ipbot,isig,pbot(ipbot).sig(isig).name);
        end
    end
end
    
