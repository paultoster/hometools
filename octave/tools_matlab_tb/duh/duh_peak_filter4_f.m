% $JustDate:: 16.08.05  $, $Revision:: 1 $ $Author:: Tftbe1    $
function    [d,c_comment] = duh_peak_filter4(d,s_par)
% Sucht nach Fehlmessung anhand eines Zählers, der
% ausserhalb der Toleranz beim Inkrementieren liegt

sig_name = s_par.signal_name;
crit     = s_par.criterium;
inc      = s_par.increment;
tol0     = s_par.tolerance;
names    = fieldnames(d);


act_value = d.(sig_name)(1);
if( strcmp(crit,'<') )
    fact = -1;
else
    fact = 1;
end

false_flag = 0;
nstart = [];
nend   = [];
ic     = 0;
c_comment = {};
tol = tol0;
for i=2:length(d.(sig_name))
    
    new_value = act_value + inc * fact;
    
%     if( i > 710 )
%         
%         fprintf('i=%i clock=%g count=%g\n',i,d.(sig_name)(i),new_value);
%     end
    
    
    if( abs(d.(sig_name)(i)-new_value) > tol )
        
        if( ~false_flag )
            ic = ic + 1;
            nstart(ic) = i;
            false_flag = 1;
        end
        
        act_value = new_value;
    else
    
        if( false_flag )
            nend(ic)  = i-1;
            c_comment{length(c_comment)+1} = sprintf('%s(%i:%i)',sig_name,nstart(ic),nend(ic));
            false_flag = 0;
        end
        act_value = d.(sig_name)(i);
    end
    
    if( false_flag )
        tol = tol + tol0;
    else
        tol = tol0;
    end
end
if( false_flag )
    nend(ic) = length(d.(sig_name));
    c_comment{length(c_comment)+1} = sprintf('%s(%i:%i)',sig_name,nstart(ic),nend(ic));
end

for i=1:length(names)

    vec = d.(names{i});
    
    for j=1:ic
        
        if( nend(j) < length(vec) )
                        
            delta_v = (vec(nend(j)+1) - vec(nstart(j)-1))/(nend(j)-nstart(j)+2);
        else
            delta_v = (vec(nstart(j)-1) - vec(max(1,nstart(j)-2)));
        end
            
        for k=nstart(j):nend(j)
                
            vec(k) = vec(k-1)+delta_v;
        end
    end
    
    d.(names{i}) = vec;
end
    

