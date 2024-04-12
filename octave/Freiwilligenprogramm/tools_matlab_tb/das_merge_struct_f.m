function [d,u] = das_merge_struct_f(d,u,d0,u0,index)
%
% [d,u] = das_merge_struct_f(d,u,d0,u0[,index])
% d(index) = d0;
% u(index) = u0;
%

if( ~exist('index','var') )
    index = 1;
end
if( isstruct(d) && isstruct(d0) )
    
    %%names  = fieldnames(d);
    names0 = fieldnames(d0);
    
    for i=1:length(names0)
        
        %fprintf('i = %i \n',i)
        
%         found_flag = 0;
%         for j=1:length(names)
%             
%             if( strcmp(names0{i},names{j}) )
%                 found_flag = 1;
%                 break;
%             end
%         end
%         
%         
%         if( ~found_flag && ~isempty(names0{i}) )
        
            d(index).(char(names0{i})) = d0.(char(names0{i}));
            if( isfield(u0,char(names0{i})) )
                
                u(index).(char(names0{i})) = u0.(char(names0{i}));
            end
%         end
    end
else
    d = d0;
    u = u0;
end
