function s = cell_liste2struct(c,text0,text1)
%
% s = cell_liste2struct(c)
% s = cell_liste2struct(c,text0,text1)
%
% Wandelt eine cell_liste in eine Struct um
% dabei enthält die erste Zelle des arrays die Structnamen
%
% Wenn text0,text1 angegeben z.B abc_<A,B,C,D>, dann werden
% die items des Inhalt, die durch Kommas getrennt sind, verwendet
% es wird geschaut, ob diese items dann auch in den anderen cell 
% vorhanden sind
%

  if( exist('text0','var') && exist('text1','var') )
      flag_multi_text = 1;
      ttrenn          = ',';
  else
      flag_multi_text = 0;
  end
  s = struct([]);
  n = length(c)-1;
  if( n > 0 )
    % Structnamen
    m = length(c{1});
    c_names = cell(1,m);
    for j=1:m
      c_names{j} = c{1}{j};
    end
    %struct-Elemente
    for i=1:n
      for j=1:m
        if( i == 137 && j == 6 )
          a = 0;
        end
        try
          cc = c{i+1};
          if( length(cc) >= j )
            val = cc{j};
          else
            val = [];
          end
          s(i).(c_names{j}) = val;
        catch exception
          fprintf(' i = %i\n',i);
          fprintf(' j = %i\n',j);
          fprintf(' length(s) = %i\n',length(s));
          fprintf(' length(c_names) = %i\n',length(c_names));
          [nn,mm] = size(c);
          fprintf(' [n,m]=size(c) n = %i\n',nn);
          fprintf(' [n,m]=size(c) m = %i\n',mm);
          throw(exception)
        end
      end
    end
    if( flag_multi_text )
        icount = 0;
        for i=1:n
            snew = cell_liste2struct_multi_text(s(i),c_names,m,text0,text1,ttrenn);
            for k=1:length(snew)
                icount = icount + 1;
                s1(icount) = snew(k);
            end
        end
        s = s1;
    end
  end
end
function snew = cell_liste2struct_multi_text(s,c_names,m,t0,t1,ttrenn)

    l0 = length(t0);
    l1 = length(t1);
    ca = cell(m,1);
    nsplit = 0;
    for j=1:m
        val = s.(c_names{j});
        
        flag = 1;
        if( ischar(val) )
            l   = length(val);
            i0 = str_find_f(val,t0,'vs');
            if( i0 > 0 )
                i1 = str_find_f(val,t1,'rs');
                if( i1 > 0 && i1 > i0 )
                    if( i0 <= 1 ),tstart = '';
                    else          tstart = val(1:i0-1);
                    end
                    tt = val(i0+l0:i1-1);
                    if( i1+l1 >= l ) tend = '';
                    else             tend = val(i1+l1:l);
                    end
                    [cb,ncb] =  str_split(tt,ttrenn);
                    if( ncb > nsplit ) nsplit = ncb;end
                    ca{j} = {tstart,cb,tend};
                    flag = 0;
                end
            end
        end
        if( flag ) ca{j} = {val,{},''};end
    end
    if( nsplit == 0 ) % keine Unterteilung
        snew = s;
    else
        for j=1:m
            for i=1:nsplit
                tstart = ca{j}{1};
                cb     = ca{j}{2};
                ncb    = length(cb);
                tend   = ca{j}{3};
                
                if( ncb == 0 )
                    snew(i).(c_names{j}) = tstart;
                else
                    k = min(i,ncb);
                    snew(i).(c_names{j}) = [tstart,cb{k},tend];
                end
            end
        end
    end
                    
end