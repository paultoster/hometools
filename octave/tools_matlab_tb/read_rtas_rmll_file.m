function [sstruct,okay,errtext] = read_rtas_rmll_file(filename)
%
% [s,okay,errtext] = read_rtas_rmll_file(filename)
%
% s                 struct     mit allen Infos
%
  okay    = 1;
  errtext = '';
  sstruct = [];
  if( ~exist(filename,'file') )
    errtext = sprintf('%s_error: Datei: <%s> \nkonnte nicht gefunden werden',mfilename,filename);
    okay    = 0;
    return;
  end

  [ okay,c,n ] = read_ascii_file(filename);
  if( ~okay )
    errtext = sprintf('%_error: File: <%s> konnte nicht eingelesen werden !!!',mfilename,filename);
    okay    = 0;
    return;
  end
  nsstruct = 0;
  icell    = 1;
  [c,n] = read_rtas_rmll_file_clean(c,n);
  for i=1:n
    [type,var,val,icell] = read_rtas_rmll_file_item(c,icell);
    if( type == 0 )
      break;
    elseif( type == 1 )
      nsstruct = nsstruct + 1;
    else
      if( nsstruct && ~isempty(var) )
        try
          sstruct(nsstruct).(var) = val;
        catch
          a = 0;
        end
        
      end
    end
  end
end
function [cout,nout] = read_rtas_rmll_file_clean(c,n)

  cout = {};
  nout = 0;
  i = 1;
  while( i<n )
    t = c{i};
   
    while( length(t) && strcmp(t(end),'\') )
      
      % take last \ away
      m = length(t);
      t = t(1:m-1);
      i = i+1;
      tt = c{i};
      i0=str_find_f(tt,'\');
      if( i0 )
        tt = tt(i0+1:end);
      end
      t = [t,tt];
    end
    
    cout = cell_add(cout,t);
    nout = nout+1;
    
    i = i+1;
  end
end
function [type,var,val,icell] = read_rtas_rmll_file_item(c,icell)

  % Ende type = 0;
  if( icell > length(c) )
    type = 0;
    var  = '';
    val  = '';
  % Start eines Objekts
  elseif( str_find_f(c{icell},'- !!python/object:') )
    type = 1;
    var  = '';
    val  = '';
    icell = icell+1;
  else
    type = 2;
    go_on = 1;
    while( go_on )
      % Suche Text-Kennung
      i0 = str_find_f(c{icell},'''');
      if( i0 > 0 ) 
        i1 = max(1,i0-1);
      else
        i1 = length(c{icell});
      end
      % Suche Trennzeichen :
      i2 = str_find_f(c{icell}(1:i1),':','vs');
      % nicht gefunden
      if( i2 == 0 )
        go_on = 1;
      else
        i21 = max(1,i2-1);
        var = c{icell}(1:i21);
        var = str_cut_ae_f(var,' ');
        
          
        % Value:
        if( i0 == 0 ) % kein Text gefunden
          n   = length(c{icell});
          i22 = min(n,i2+1);
          val = c{icell}(i22:n);
          val = str_cut_ae_f(val,' ');
          icell = icell+1;
        else
          [jcell,jpos] = cell_find_from_ipos(c,icell,i0+1,'''','for');
          if( jcell == 0 )
            val = '';
            icell = icell+1;
          else
            i1  = jpos-1;
            if( i1 <= 0 )
              jcell = jcell-1;
              i1    = length(c{jcell});
            end
            val = cell_get_with_ipos(c,icell,i0+1,jcell,i1,'text');
            val = str_cut_ae_f(val,' ');
            icell = jcell+1;
          end
        end
        
        go_on = 0;
      end
    end
  end
end