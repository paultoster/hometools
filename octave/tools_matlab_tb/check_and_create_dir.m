function [okay,message] = check_and_create_dir(dirname)
%
% [okay,message] = check_and_create_dir(dirname)
%
% check dir, if not exist then create
% if( ~okay ) error with message
%
  okay = 1;
  message = '';
  if( ~exist(dirname,'dir') )
      [SUCCESS,MESSAGE,MESSAGEID] = mkdir(dirname);
      if( ~SUCCESS )
        message = sprintf('%s: %s in dir(%s)',MESSAGEID,MESSAGE,dirname);
        okay = 0;
      end
  end
end