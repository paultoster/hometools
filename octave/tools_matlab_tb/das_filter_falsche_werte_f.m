% $JustDate:: 31.03.05  $, $Revision:: 1 $ $Author:: Admin     $
% $JustDate:: 31 $, $Revision:: 1 $ $Author:: Admin     $
function        [dout,uout]       = das_filter_falsche_werte_f(d,u)

% Filtert no names un null-Vektoren raus

dnames  = fieldnames(d);
unames = fieldnames(u);

dout={};
uout={};

l_vec = 0;
for i=1:length(dnames)
    
    unit_found = 0;
    if( length(dnames{i}) > 0 )
        
        vec  = getfield(d,dnames{i});
        
        if( length(vec) > 0 )
            
            l_vec = length(vec);
            
            for j=1:length(unames)
                
                if( strcmp(dnames(i),unames(j)) )
                    
                    unit = getfield(u,unames{j});
                    unit_found = 1;
                    break;
                end
            end
            
            if( ~unit_found )
                unit = '-';
            end
            dout = setfield(dout,dnames{i},vec);
            uout = setfield(uout,dnames{i},unit);
        else
            for j=1:length(unames)
                
                if( strcmp(dnames(i),unames(j)))
                    
                    unit = getfield(u,unames{j});
                    unit_found = 1;
                    break;
                end
            end
            
            if( ~unit_found )
                unit = '-';
            end
            if( l_vec > 0 )
                dout = setfield(dout,dnames{i},zeros(l_vec,1));
                uout = setfield(uout,dnames{i},unit);
            end
        end
        
    end
end

