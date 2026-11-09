function [okay,index] = proof_names_of_struct(d,ctext)
% 
% [okay,index] = proof_names_of_struct(d,ctext)
%        proof if ctext (string or cellarray string)
%        are names of d-struct
%        okay = 1 and index = 0 if every name is found
%        okay = 0 and index = i i ist index of not found 

okay  = 1;
index = 0;

if( ischar(ctext) )
    ctext = {ctext};
end

cnames = fieldnames(d);


for i=1:length(ctext)    
    ifound = cell_find_f(cnames,ctext{i},'f');
    if( isempty(ifound) )
        okay  = 0;
        index = i;
        break;
    end
end
