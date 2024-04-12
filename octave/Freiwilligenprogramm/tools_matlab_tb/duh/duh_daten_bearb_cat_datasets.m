function  s_duh = duh_daten_bearb_cat_datasets(data_selection,s_duh)


% Auswerten
% 
% 
dnew = struct;
unew = struct;
hnew = {};
ndataset = length(data_selection);
if( ndataset < 2 )
  fprintf('Es müssen mindestens zwei Datensätze ausgewählt werden')
  return
end
% Zeitvektor
dt     = zeros(ndataset,1);
tend   = zeros(ndataset,1);
tstart = zeros(ndataset,1);
for i=1:ndataset
    
    % data index
    i_data = data_selection(i);
    
    % Namen des Datasets
    c_names = fieldnames(s_duh.s_data(i_data).d);

    dt(i)     = mean(diff(s_duh.s_data(i_data).d.(c_names{1})));
    ll        = length(s_duh.s_data(i_data).d.(c_names{1}));
    tstart(i) = s_duh.s_data(i_data).d.(c_names{1})(1);
    tend(i)   = s_duh.s_data(i_data).d.(c_names{1})(ll); 
end

tvec = [];
for i=1:ndataset
  
  % data index
  i_data = data_selection(i);
  % Namen des Datasets
  c_names = fieldnames(s_duh.s_data(i_data).d);
  % Zeitvektor
  time = s_duh.s_data(i_data).d.(c_names{1});
  [n,m] = size(time);
  if( m > n )
    time = time';
  end
  time = time(:,1);
  
  if( i == 1 )
    tvec = time;
    unit = s_duh.s_data(i_data).u.(c_names{1});
  else
    tvec = [tvec;time+tend(i-1)+dt(i-1)-tstart(i)];
  end
end

dnew.time = tvec;
unew.time = unit;

% data index
i_data = data_selection(1);
% Namen des 1. Datasets 
c_names = fieldnames(s_duh.s_data(i_data).d);

% Es werden nur Vektoren aus allen Datensätzen gemerged
for i=2:length(c_names)
  
  vec = s_duh.s_data(i_data).d.(c_names{i});
  ncount = 1;
  [n,m] = size(vec);
  if( m > n )
    vec = vec';
  end
  vec = vec(:,1);
  
  hnew = s_duh.s_data(1).h;
 
  for j = 2:ndataset
    
    % data index
    j_data = data_selection(j);
    cc_names = fieldnames(s_duh.s_data(j_data).d);

    ifound = cell_find_f(cc_names,c_names{i},'f');
    if( ~isempty(ifound) )
      ncount = ncount + 1;
      vec1 = s_duh.s_data(j_data).d.( cc_names{ifound(1)});
      [n,m] = size(vec1);
      if( m > n )
        vec1 = vec1';
      end
      vec1 = vec1(:,1);
      
      vec = [vec;vec1];
    end
  end
  if( ncount == ndataset )
    dnew.(c_names{i}) = vec;
    unew.(c_names{i}) = s_duh.s_data(i_data).u.(c_names{i});
  end
end

for i=1:ndataset

  % data index
  i_data = data_selection(i);
  for j = 1:length(s_duh.s_data(i_data).h)   
    hnew{length(hnew)+1} = s_duh.s_data(i_data).h{j};
  end
end
hnew{length(hnew)+1} = 'cat_datasets';

c_names = fieldnames(dnew);
if( length(c_names) > 1 )
  s_duh.n_data = s_duh.n_data + 1;
  s_duh.s_data(s_duh.n_data).d           = dnew;
  s_duh.s_data(s_duh.n_data).u           = unew;
  s_duh.s_data(s_duh.n_data).h           = hnew;
  s_duh.s_data(s_duh.n_data).file        = 'cat_datasets';
  s_duh.s_data(s_duh.n_data).name        = 'cat_datasets';
  s_duh.s_data(s_duh.n_data).c_prc_files = {};
end
