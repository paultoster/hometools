function taccconv_dos_set(p)
%
% taccconv_dos_set(path)
% 
% set set TACCCONV=p in dos
%
  p = fullfile(p);
  if( ~exist(p,'dir') )
    error('%s: path=''%s'' is not found',p)
  end
  [status,result]=dos(sprintf('set TACCCONV=%s',p));
  if( status ~= 0 )
    error('dos-Befehl dos(''set TACCCONV=%s'') konnt nicht abgesetzt werden',p)
  end

end