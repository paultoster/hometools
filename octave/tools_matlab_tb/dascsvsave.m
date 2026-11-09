% $JustDate:: 31.03.05  $, $Revision:: 1 $ $Author:: Admin     $
% $JustDate:: 31 $, $Revision:: 1 $ $Author:: Admin     $
% test
function okay = dascsvsave(f,d,u)

delim = ';';
change_point = 1;

okay = 1;

i0 = strfind(f,'.');
if( length(i0) == 0 )
    f = [f,'.csv'];
end
fid = fopen(f,'w');
if( fid < 0 )
    okay = 0;
    return
end

c_names = fieldnames(d);

for i=1:length(c_names)
    
    fprintf(fid,'ch%i',i);
    if( i ~= length(c_names) )        
        fprintf(fid,delim);
    end
end
fprintf(fid,'\n');
for i=1:length(c_names)
    
    fprintf(fid,'%s',c_names{i});
    if( i ~= length(c_names) )        
        fprintf(fid,delim);
    end
end
fprintf(fid,'\n');
for i=1:length(c_names)
    
    fprintf(fid,'%s',u.(c_names{i}));
    if( i ~= length(c_names) )        
        fprintf(fid,delim);
    end
end

fprintf(fid,'\n');
for i=1:length(d.(c_names{1}))
    for j=1:length(c_names)
    
      if( length(d.(c_names{j})) >= i )
        s = num2str(d.(c_names{j})(i));
        if( change_point )
          fprintf(fid,'%s',str_change_f(s,'.',','));
        else
          fprintf(fid,'%s',s);
        end
      end
      if( j ~= length(c_names) )        
          fprintf(fid,delim);
      end
    end
    fprintf(fid,'\n');
    
end

fclose(fid);

