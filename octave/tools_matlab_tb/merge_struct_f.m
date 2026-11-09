function [d] = merge_struct_f(d,d0,merge_all)
%
% [d] = merge_struct_f(d,d0)
% [d] = merge_struct_f(d,d0,merge_all)
%
% Merged d0 in d
% merge_all   :0   nur die Signale d0, die nicht in d enthaletne sind
%                  werden gmerged (defaulT)
%             :1   alle Signale aus d0 werden in d gemerged
if( ~exist('merge_all','var') )
  merge_all = 0;
end
if( ~isstruct(d0) || isempty(d0) ) % nix zu mergen
  return;
elseif( isstruct(d) && ~isempty(d) )
    
    names  = fieldnames(d);
    names0 = fieldnames(d0);
    
    for i=1:length(names0)
      if( merge_all && ~isempty(names0{i}) )
        
        command = ['d.',char(names0{i}),'=d0.',char(names0{i}),';'];
        eval(command);
      else
        found_flag = 0;
        for j=1:length(names)
            
            if( strcmp(names0{i},names{j}) )
                found_flag = 1;
                break;
            end
        end
        
        if( ~found_flag && ~isempty(names0{i}) )
            
          command = ['d.',char(names0{i}),'=d0.',char(names0{i}),';'];
          eval(command);
        end
      end
    end
else
    d = d0;
end
