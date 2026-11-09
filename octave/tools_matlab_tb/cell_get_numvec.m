function [vec,found] = cell_get_numvec(carray,type)
%
% [vec,found] = cell_get_numvec(carray)
%  [vec,found] = cell_get_numvec(carray,type)
%
% Sucht in einem cellarray carray nach numerischen Vektor
% type = 1;    (default) sucht nach dem ersten Vektor im array
%
% found         0/1 nicht gefunden/gefunden
% vec           Wenn found == 1 dann Vektor
%               ansosnten gleich null

  vec   = 0;
  found = 0;
  
  if( ~exist('type','var') )
    type = 1;
  end
  
  if( type == 1 )
    if( iscell(carray) )
      n = length(carray);
      for i = 1:n
        if( isnumeric(carray{i}) && ~isempty(carray{i}) )
          vec   = carray{i};
          found = 1;
          break;
        end
      end
    end
  else
    error('Error_%s: type = %i ist nicht ,programmiert!!!',mfilename,type);
  end
end