function e = e_data_cut_index(e,istart,iend,signame)
%
% e = e_data_reduce_time(e,istart,iend,signame)
%
% e            e-Datenstruktur mit e.time,e.vec,e.lin
%             ...
% istart      Startindex Ausschneiden, -1 von i=1 
% iend        Endindex ausschneiden, -1 bis ende
% signame     Nur signame 'signame1' oder liste {'signame1',signame2', ...}
%             die behandelt werden sollen (leer bedeutet alle)
% 
  if( ~exist('signame','var') )
    signame = '';
  else
    if( ischar(signame) )
      signame = {signame};
    end
  end
  
  c_names = fieldnames(e);
  ne      = length(c_names);

  if( isempty(signame) )
    
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
          if( i0 == 1 )
            if( i1 == nt )
              e.(c_names{ie}).time = [];
              e.(c_names{ie}).vec  = [];
            else
              e.(c_names{ie}).time = e.(c_names{ie}).time(i1+1:end);
              e.(c_names{ie}).vec  = e.(c_names{ie}).vec(i1+1:end);
            end
          elseif( i1 == nt )
            e.(c_names{ie}).time = e.(c_names{ie}).time(1:i0-1);
            e.(c_names{ie}).vec  = e.(c_names{ie}).vec(1:i0-1);
          else
            e.(c_names{ie}).time = [e.(c_names{ie}).time(1:i0-1);e.(c_names{ie}).time(i1+1:end)];
            e.(c_names{ie}).vec  = [e.(c_names{ie}).vec(1:i0-1);e.(c_names{ie}).vec(i1+1:end)];
          end
        catch
          a = 0;
          error('%s: Fehler',mfilename)
        end
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
              if( i0 == 1 )
                if( i1 == nt )
                  e.(c_names{ie}).time = [];
                  e.(c_names{ie}).vec  = [];
                else
                  e.(c_names{ie}).time = e.(c_names{ie}).time(i1+1:end);
                  e.(c_names{ie}).vec  = e.(c_names{ie}).vec(i1+1:end);
                end
              elseif( i1 == nt )
                e.(c_names{ie}).time = e.(c_names{ie}).time(1:i0-1);
                e.(c_names{ie}).vec  = e.(c_names{ie}).vec(1:i0-1);
              else
                e.(c_names{ie}).time = [e.(c_names{ie}).time(1:i0-1);e.(c_names{ie}).time(i1+1:end)];
                e.(c_names{ie}).vec  = [e.(c_names{ie}).vec(1:i0-1);e.(c_names{ie}).vec(i1+1:end)];
              end
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

