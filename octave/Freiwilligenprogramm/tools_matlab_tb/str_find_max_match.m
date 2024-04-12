function  [istart,iend,nlength] = str_find_max_match(text0,text1)
%
% [istart,iend,nlength] = str_find_max_match(text0,text1);
% [istart,iend,nlength] = str_find_max_match(carray);
%
% Vergleicht text0 und text1 oder alle cellarrays untereinander und sucht maximale übereinstimmung:
% text0     erster string
% text1     zweiter string
% carray    = {text0,text1,text2, ...}
%
% Ausgabe
% istart    Startindex
% iend      Endindex
% nlength   Anzahl Zeichen
  if( iscell(text0) )
    c = text0;
  elseif( ischar(text0) )
    c = {text0};
  else
    c = {};
  end
  if( exist('text1','var') )
    c = cell_add(c,text1);
  end  
  istart  = 0;
  iend    = 0;
  nlength = 0;
  n = length(c);
  if( n > 1 )
    nmin = length(c{1});
    nmax = 0;
    for i=1:n
      nn = length(c{i});
      if( nn > nmax )
        nmax = nn;
      end
      if( nn < nmin )
        nmin = nn;
      end
    end

    flagliste = zeros(nmax,1);
    t1 = c{1};
    n1 = length(t1);
    for i=1:nmax
      flagliste(i) = 1;
      for j = 2:n
        t2 = c{j};
        n2 = length(t2);
        flag = 0;
        if( (i <= n1) && (i <= n2) )
          if( t1(i) ~= t2(i) )
            flag = 1;
          end
        else
          flag = 1;
        end
        if( flag )
          flagliste(i) = 0;
          break;
        end
      end
     end

     % Auszählen
     s = [];
     ii = 0;
     status  = 0;
     for i=1:nmax
       if( status == 0 ) % start
         if( flagliste(i) > 0.5 )
           ii = ii+1;
           s(ii).istart  = i;
           s(ii).nlength = 1;
           status = 1;
         end
       elseif( status == 1 )
         if( flagliste(i) > 0.5 )
           s(ii).nlength = s(ii).nlength + 1;
         else
           s(ii).iend  = i-1;
           status = 0;
         end
       end
     end
     for i=1:ii
       if( s(i).nlength > nlength )
         istart  = s(i).istart;
         iend    = s(i).iend;
         nlength = s(i).nlength;
       end
     end
  end 
end
    