function sigliste = cg_get_ecal_channel_build_template(data)
%
%  sigliste = cg_read_ecal_channel_build_template(data)
%
% build template with data-structure
%
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

  % alle signalnamen sammeln
  %-------------------------
  sigliste = struct([]);  % sigliste(i).name, sigliste(i).type
  n = length(data);
  for i=1:n
    sigliste = cg_get_ecal_channel_build_template_collect(data{i},sigliste);
  end
  
end
function sigliste = cg_get_ecal_channel_build_template_collect(s,sigliste)

  cnames = fieldnames(s);
  n      = length(cnames);
  m      = length(sigliste);
  for i=1:n

    % sigliste durchsuchen, ob noch  nicht Signal vorhanden
    %-----------------------------------------------
    flag = 1;
    m      = length(sigliste);
    for j=1:m
      if( strcmp(cnames{i},sigliste(j).name) )          
        flag = 0;
        break;
      end
    end
    if( flag )
      j = m+1;
      sigliste(j).name    = cnames{i};
      sigliste(j).unit    = '';
      sigliste(j).lin     = 1;
      sigliste(j).comment = '';
      % nur wenn double und eine element oder mehrere elemente dann
      % vector eintragen, alle anderen mit none, muss editieret werden
      if( isa(s.(cnames{i}),'double') )
        if( length(s.(cnames{i})) == 1 )
          sigliste(j).type = 'single';
        elseif( length(s.(cnames{i})) > 1 )
          sigliste(j).type = 'vector';
        else
          sigliste(j).type = 'none';
        end
      else
        sigliste(j).type = 'none';
      end
    else
      % wenn bereits als single erkannt, dann nochmal prüfen
      if( strcmp(sigliste(j).type,'single') )
        if(  length(s.(cnames{i})) > 1 )
          sigliste(j).type = 'vector';
        end
      end
    end
  end
end