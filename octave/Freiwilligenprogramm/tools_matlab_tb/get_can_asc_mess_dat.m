function datn = get_can_asc_mess_dat(asc_file)

  if(  ~exist(asc_file,'file') )
    error('%s: error CAN-asc-File <%s> not found',mfilename,asc_file);
  end
  
  [fileID,errmsg] = fopen(asc_file,'r');
  if( ~fileID )
    error('%s: error Open CAN-asc-File <%s>',mfilename,asc_file);
  end
  
  tt = fgetl(fileID);
  fclose(fileID);
  
  tt = tt(10:end); % 'date ddd ' weg nehmen
  
  if(  str_find_f(tt,' am ','vs') || str_find_f(tt,' pm ','vs') ...
    || str_find_f(tt,' AM ','vs') || str_find_f(tt,' PM ','vs') ...
    )
    datn = datenum(tt,'mmm dd HH:MM:SS PM YYYY');
  else
    datn = datenum(tt,'mmm dd HH:MM:SS YYYY');
  end