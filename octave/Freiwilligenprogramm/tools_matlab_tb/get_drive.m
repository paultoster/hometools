function drive = get_drive(fullpath)
%
% drive = get_drive(fullpath)
%
% extract drive:
%
% drive = get_drive('d:\abc\);
%
  i0 = str_find_f(fullpath,filesep,'vs');
  if( i0 > 0 )
   drive = fullpath(1:i0);
  else
   drive = ['c:',filesep];
  end

  if( str_find_f(drive,':','vs') == 0 )
   error('%s_error: drive=%s mit get_drive(%s) ist kein Laufwerk',mfilename,drive,fullpath)
  end
 
end