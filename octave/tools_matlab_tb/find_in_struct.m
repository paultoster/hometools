function find_in_struct(d,text)
% Aufruf: find_in_struct(d_struct,such_text)
%        z.B. find_in_struct(d,''Vref'')
%        Namen werden nicht case-sensitive gesucht
if( nargin == 0 )
    
    fprintf('\nAufruf: find_in_struct(d_struct,such_text)')
    fprintf('\n        z.B. find_in_struct(d,''Vref'')')
    fprintf('\n        Namen werden nicht case-sensitive gesucht')
else
    

	text = lower(text);
	
	c_names = fieldnames(d);
	fprintf('\n');
	for i=1:length(c_names)
        
        text1 = lower(c_names{i});
        
        if( length(findstr(text1,text)) > 0 )
            
            fprintf('struct_name: %s\n',c_names{i});
        end
	end
    
end