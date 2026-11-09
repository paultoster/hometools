function s = struct_delete_item(sin,i0,i1)
%
% s = struct_delete_item(sin,i0)
% s = struct_delete_item(sin,ivec)
% s = struct_delete_item(sin,i1)
%
% löscht s(i0) bzw. s(ivec) bzw s(i0:i1)
%
%
  s = struct([]);
  if( exist('i1','var') )
    ivec = i0(1):1:i1;
  else
    ivec = i0;
  end
  n = length(sin);
  ii = 0;
  for i=1:n;
    
    if(  isempty(find_val_in_vec(ivec,i)) )
      ii = ii+1;
      if( ii == 1 )
        s = sin(i);
      else
        s(ii) = sin(i);
      end
    end
  end
end
    