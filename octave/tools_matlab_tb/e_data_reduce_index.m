function e = e_data_reduce_index(e,istart,iend,zero_flag,signame)
%
% e = e_data_reduce_time(e,istart,iend,zero_flag)
%
% e            e-Datenstruktur mit e.time,e.vec,e.lin
%             ...
% istart      Startindex für Eingrenzung, wenn nicht benutzt, dann istart = -1
% iend        Endindex für Eingrenzung, wenn nicht benutzt, dann iend = -1
% zero_flag   flag Zeitvektor geht aus null raus
% signame     Nur signame 'signame1' oder liste {'signame1',signame2', ...}
%             die behandelt werden
% 
  if( ~exist('signame','var') )
    signame = '';
  else
    if( ischar(signame) )
      signame = {signame};
    end
  end
      
  if( ~exist('zero_flag','var') )
    zero_flag = 0;
  end
  
  c_names = fieldnames(e);
  ne      = length(c_names);

  if( isempty(signame) )
    tmin = 1.e60;
    for ie=1:ne
      nt      = min(length(e.(c_names{ie}).time),length(e.(c_names{ie}).vec));

      if( istart > 0 )
        i0 = istart;
      else
        i0 = 1;
      end
      if( (iend > 0.) && (iend >= i0) )
        i1 = iend;
        if( i1 > nt )
          i1 = nt;
        end
      else
        i1 = nt;
      end
      if( i0 <= i1 )
        try 
          e.(c_names{ie}).time = e.(c_names{ie}).time(i0:i1);
          e.(c_names{ie}).vec  = e.(c_names{ie}).vec(i0:i1);
        catch
          a = 0;
          error('%s: Fehler',mfilename)
        end
      end
      if( zero_flag ) 
       e.(c_names{ie}).time = e.(c_names{ie}).time - e.(c_names{ie}).time(1);
      end
    end
  else % Signalliste durchgehen
    for ie=1:ne
      for jj = 1:length(signame)
        sname = signame{jj};
        if( strcmpi(c_names{ie},sname) )
          nt      = min(length(e.(c_names{ie}).time),length(e.(c_names{ie}).vec));
          if( istart > 0 )
            i0 = istart;
          else
            i0 = 1;
          end
          if( (iend > 0.) && (iend >= i0) )
            i1 = iend;
            if( i1 > nt )
              i1 = nt;
            end
          else
            i1 = nt;
          end
          if( i0 <= i1 )
            try 
              e.(c_names{ie}).time = e.(c_names{ie}).time(i0:i1);
              e.(c_names{ie}).vec  = e.(c_names{ie}).vec(i0:i1);
            catch
              a = 0;
              error('%s: Fehler',mfilename)
            end
          end
          break
        end 
      end
    end
  end

