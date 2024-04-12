function  okay = cg_ecal_channel_write_sigliste(mdescriptfile,sigliste)
%
% okay = cg_ecal_channel_write_sigliste(mdescriptfile,sigliste)
%
% mdescriptfile                    fullfilename
%  sigliste                        stuct-vector with
%                                  sigliste(i).name              signalname
%                                                                type = single
%                                                                abc      
%                                                                abc.def        structured
%                                                                type = vector
%                                                                abc            => vector with abc(i)   
%                                                                abc.def        => vector with abc.def(i)
%                                                                abc:def        => vector with abc(i).def
%
%                                  sigliste(i).type              type: none,single,vector
%
%                                  sigliste(i).lin               0/1  could be linear interpolated or not
%                  
%                                  sigliste(i).comment           comment

  okay = 1;
  
  m = length(sigliste);
  if( m > 0 )
    % mscript schreiben
    %------------------
    c = {};
    c = cell_add(c,'% name                 unit       type       linear   coment');
    for i=1:m
      tname = sprintf('''%s''',sigliste(i).name);
      tunit = sprintf('''%s''',sigliste(i).unit);
      ttype = sprintf('''%s''',sigliste(i).type);
      tlin  = sprintf('%i',sigliste(i).lin);
      tcom = sprintf('''%s''',sigliste(i).comment);
      c = cell_add(c,sprintf('%-20s;%-10s;%-10s;%-7s;%s',tname,tunit,ttype,tlin,tcom));
    end
    
    % Datei schreiben
    write_ascii_file( mdescriptfile, c );
  end
end