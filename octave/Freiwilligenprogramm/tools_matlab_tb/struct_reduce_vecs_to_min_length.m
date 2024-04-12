function d = struct_reduce_vecs_to_min_length(d)
%
% d = struct_reduce_vecs_to_min_length(d)
%

c_names = fieldnames(d);

startflag = 1;
for i=1:length(c_names)
    
    if( isnumeric(d.(c_names{i})) )
        
        if( startflag )
            [m1,n1] = size(d.(c_names{i}));
            startflag = 0;
        else
            [m,n]= size(d.(c_names{i}));
            
            m1 = min(m1,m);
            n1 = min(n1,n);
        end
    end
end

if( ~startflag )
   
    for i=1:length(c_names)
    
        if( isnumeric( d.(c_names{i})) )
            
            d.(c_names{i}) = d.(c_names{i})(1:m1,1:n1);
            
        end
    end
end
            