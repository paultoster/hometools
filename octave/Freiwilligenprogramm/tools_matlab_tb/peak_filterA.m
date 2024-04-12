function    [d,found_flag] = peak_filterA(d,d_diff,npoints,maxpoints,type,all)
%
% [d,found_flag] = peak_filterA(d,d_diff [,npoints,maxpoints,type,all])
%
% Sucht Peaks in Strukturliste von d, wenn Betrag der Differenz eines
% Vektors ausserhalb des Wertes d_diff liegt. Diese Stellen werden
% mit npoints vor und nachher interpoliert (type=0 linear, 1:spline, 2:cubic)
% 
% d         Struktur mit Datenvektor 
% d_diff    Struktur mit Differenzschwellen
%    d.long       = in.long;
%    d_diff.long  = 100/60/180*pi;  % Schwelle zum ausfiltern
%    d.lat        = in.lat;
%    d_diff.lat   = 100/60/180*pi;  % Schwelle zum ausfiltern
%    d.head       = in.head;
%    d_diff.head  = 10000;          % auf utopischen Wert lassen
% npoints   Anzahl der Punkte, die noch davor oder danach zum interpolieren
%           verwendet werden (default: 10)
% maxpoints maximale Anzahl von Punkten die ausgefiltert werden (default:10)
% type      Interpolationstyp 0:linear, 1:spline, 2:cubic (default: 0)
% all       (def=1) Flag ob all an einer gefunden peak-stelle gefiltert
%            werden
%
% found_flag   = 1 , wenn peak gefiltert

  found_flag = 0;
  if( nargin < 2 )
      error('Zuwenige Parameter: 1. Parameter Vector, 2. Parameter d_diff übergeben')
  end

  if( ~isstruct(d) )
    error('Falscher Typ: erster Parameter muss eine struktur mit Vektoren sein')
  end
  
  names = fieldnames(d);
  n_names = length(names);

  if( isnumeric(d_diff) )
    tt = d_diff;
    for i=1:n_names
      d_diff.(names{i}) = tt;
    end
  end
  
  n = 1e100;
  for i=1:n_names
    n = min(length(d.(names{i})),n);
  end
  if( ~exist('npoints','var') )
    npoints = min(10,n/2);
  end
  if( ~exist('maxpoints','var') )
    maxpoints = min(10,n/2);
  end
  if( ~exist('type','var') )
    type = 0;
  end
  if( ~exist('all','var') )
    all = 1;
  end

  c_index_liste = {};
  for i=1:n_names
    fprintf('%s\n',names{i});
    [vec,cind_liste] = vec_peak_filter(d.(names{i}),d_diff.(names{i}),npoints,maxpoints,type);
    if( all )  
      if( ~isempty(cind_liste) )
        found_flag = 1;
        for j=1:length(cind_liste)
          vec_xx = cind_liste{j};
          j0    = min(vec_xx);
          j1    = max(vec_xx);
          found = 0;
          for i=1:length(c_index_liste)
            vec_x = c_index_liste{i};
            i0    = min(vec_x);
            i1    = max(vec_x);
            if( j1 < i0 || j0 > i1 )
              tt=1;
            else
              c_index_liste{i} = peak_filterA_merge(vec_x,vec_xx);
              found = 1;
            end
          end
          if( ~found )
            c_index_liste{length(c_index_liste)+1} = cind_liste{j};
          end
        end
      end
    else
      d.(names{i}) = vec;
    end
  end

  if( all && ~isempty(c_index_liste) )

    for i=1:length(c_index_liste)

      for j=1:n_names

        d.(names{j}) = peak_filterA_interp(d.(names{j}),c_index_liste{i},type);
      end
    end
  end
end
function vec = peak_filterA_interp(vec,vec_x,type)

    vec_y = vec_x*0;
    for i=1:length(vec_x)
      vec_y(i) = vec(vec_x(i));
    end
    xin = [min(vec_x):1:max(vec_x)]';
    [vec_x,vec_y] = elim_nicht_monoton(vec_x,vec_y);
    if( type < 1.5 )
        yout = interp1(vec_x,vec_y,xin,'linear','extrap');
    elseif( type < 2.5 )
      yout = interp1(vec_x,vec_y,xin,'spline','extrap');
    else
      yout = interp1(vec_x,vec_y,xin,'cubic','extrap');
    end
    for j=1:length(xin)
      vec(xin(j)) = yout(j);
    end
end  

function vec_out = peak_filterA_merge(vec_in,vec_m)

  i0 = min(vec_in);
  i1 = max(vec_in);
  j0 = min(vec_m);
  j1 = max(vec_m);
  if( i0 > j0 )

    v = vec_in;
    k0 = i0;
    k1 = i1;
    vec_in = vec_m;
    i0     = j0;
    i1     = j1;
    vec_m  = v;
    j0     = k0;
    j1     = k1;
  end

  vec_out = [];
  if( i1 > j0 )
    for k=i0:j0-1
      cin = find_val_in_vec(vec_in,k,0.1);
      if( ~isempty(cin) )
        vec_out = [vec_out;k];
      end
    end
    if( i1 < j1 )
      for k=j0:i1
        cin = find_val_in_vec(vec_in,k,0.1);
        cm  = find_val_in_vec(vec_m,k,0.1);
        if( ~isempty(cin) && ~isempty(cm) )
          vec_out = [vec_out;k];
        end
      end
      for k=i1+1:j1
        cin = find_val_in_vec(vec_m,k,0.1);
        if( ~isempty(cin) )
          vec_out = [vec_out;k];
        end
      end
    else
      for k=j0:j1
        cin = find_val_in_vec(vec_in,k,0.1);
        cm  = find_val_in_vec(vec_m,k,0.1);
        if( ~isempty(cin) && ~isempty(cm) )
          vec_out = [vec_out;k];
        end
      end
      for k=j1+1:i1
        cin = find_val_in_vec(vec_in,k,0.1);
        if( ~isempty(cin) )
          vec_out = [vec_out;k];
        end
      end      
    end
  else
    vec_out = [vec_in;vec_m];
  end

end