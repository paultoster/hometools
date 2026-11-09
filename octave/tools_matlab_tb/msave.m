function okay = msave(f,d,u)

okay = 1;
nval = 10;

i0 = strfind(f,'.');
if( isempty(i0) )
    f = [f,'.m'];
end
fid = fopen(f,'w');
if( fid < 0 )
    okay = 0;
    return
end

c_names = fieldnames(d);

for i=1:length(c_names)
    
    v = d.(c_names{i});
    
    tdum = sprintf('%s = [',c_names{i});
    ndum = length(tdum);
    fprintf(fid,tdum);
    
    ival = 0;
    nv   = length(v);
    for iv = 1:nv
        
        fprintf(fid,' %g',v(iv));
        ival = ival + 1;
        if( iv == nv )
            fprintf(fid,'];\n')
        else

            if( ival == nval )
            
                ival = 0;
                fprintf(fid,' ...\n');
            
                for it=1:ndum-1
                    fprintf(fid,' ');
                end
            end
            fprintf(fid,',');
        end
    end
    
    fprintf(fid,'%% %s\n\n',u.(c_names{i}))
end

fclose(fid);

