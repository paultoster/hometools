function e = struct_array_add(e,e0,index)
%
% e = struct_array_add(e,e0,index)
% e(index) = e0;
%

if( ~exist('index','var') )
    index = 1;
end
if( isstruct(e) && isstruct(e0) )
    
    names0 = fieldnames(e0);
    
    for i=1:length(names0)        
      e(index).(char(names0{i})) = e0.(char(names0{i}));
    end
else
    e = e0;
end
