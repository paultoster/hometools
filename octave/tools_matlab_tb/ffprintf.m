function output = ffprintf(fid,varargin)
%
% count = ffprintf(fid,varargin)
%
% Damit können mehrere Output generiert werden
% count      Anzahl Zeichen in der Ausgabe
% fid = fopen('test.dat','w');
% ffprintf([fid,1],'Tesoutput = %f',10.2);
% fclose(fid)
%
  if( ischar(fid) )
    zerotext = fid;
    flag     = 1;
    fid      = 1;
  else
    zerotext = '';
    flag     = 0;
  end
  nv = length(varargin);
  if( flag && nv == 0 )
    tt = sprintf(zerotext);
  else
    if( nv > 0 )
      command = 'tt = sprintf(';
      for i=1:nv
        command = [command,sprintf('varargin{%i}',i)];
        if( i < nv )
          command = [command,','];
        else
          command = [command,');'];
        end
      end
      eval(command);
    else
     tt = '';
    end
  end
  n = length(fid);
  for i=1:n
    if( fid(i) > 0 ),out = fprintf(fid(i),tt);end
  end

  if( nargout == 1 )
    output = out;
  end
end