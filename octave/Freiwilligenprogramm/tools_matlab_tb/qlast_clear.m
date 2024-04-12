function qlast_clear
%
% cleares qlast.mat if exist with qlast.dint
  if( exist(qlast_filename,'file') )
    load(qlast_filename)
    if( exist('qlast','var') && isfield(qlast,'dint') )
      delete(qlast_filename);
    end
  end
end
    