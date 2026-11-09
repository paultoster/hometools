function [d,u] = d_data_merge_mBuffer_vektor(d,u,mBuffer_name,erase_flag)
%
% [d,u] = d_data_merge_mBuffer_vektor(d,u,mBuffer_name,erase_falg)
%
% Sammelt Einzelwerte aus mBuffer zu Vektor zusammen
%
% d              Data-Struktur mit Signalen
% u              unit-Struktur, wenn nicht vorhanden, dann[] setzten
% mBuffer_name   Name zu dem mBuffer-Signal
% erase_flag     löscht alle einzelsignale (default 0)
%
% z.B.    mBuffer_name = 'Path_Traj'
%         dann sind Signale z.B
%         d.Path_Traj_mBuffer_0_x
%         d.Path_Traj_mBuffer_1_x
%         d.Path_Traj_mBuffer_2_x
%         ...
%         d.Path_Traj_mBufferCnt = 3
%         => zu d.time(i) wird
%         d.Path_Traj_x{i} =
%         {d.Path_Traj_mBuffer_0_x(i),d.Path_Traj_mBuffer_1_x(i),d.Path_Traj_mBuffer_2_x(i)};
%         u.Path_Traj_x = u.Path_Traj_mBuffer_0_x (wenn vorhanden)
%
  if( isempty(u) || ~isstruct(u) )
    uflag = 0;
  else
    uflag = 1;
  end
  
  if( ~exist('erase_flag','var') )
    erase_flag = 0;
  end

  c_names = fieldnames(d);
  n       = length(c_names);

  collect_names = {};
  nvec          = [];
  for i=1:n
    if( i == 104 )
      aa = 0;
    end
    if( str_find_f(c_names{i},[mBuffer_name,'_mBuffer'],'vs') == 1 )
      if( str_find_f(c_names{i},[mBuffer_name,'_mBufferCnt'],'vs') == 1 )
        nvec = d.([mBuffer_name,'_mBufferCnt']);
      else
        collect_names = cell_add(collect_names,c_names{i});
      end
    end
  end

  % BufferCnt
  %==========
  if( isempty(nvec) )
    warning('d-data hat kein Signal d.%s',[mBuffer_name,'_mBufferCnt']);
    return;
  end
  if( isempty(collect_names) )
    warning('d-data hat kein Signal d.%s',[mBuffer_name,'_mBuffer_xx_name']);
    return;
  end

  % Vektor indices sortieren
  %=========================
  nc       = length(collect_names);
  % c_number = cell(nc,1);
  ll       = length([mBuffer_name,'_mBuffer_']);
  civec     = {};
  veknames  = {};
  fullnames = {};
  for i = 1:nc
    name = collect_names{i};
    name = name(ll+1:length(name));
    cc   = str_split(name,'_');
    if( length(cc) >= 2 ) % z.B. 0_x = cc{1} = '0'; cc{2} = 'x'
      if( isempty(cell_find_f(veknames,cc{2})) )
        veknames = cell_add(veknames,cc{2});
      end
      iname = cell_find_f(veknames,cc{2});
      try
        i0 = str2num(cc{1});
        flag = 1;
      catch
        flag = 0;
      end
    else
      flag = 0;
    end
    if( flag )
      if( length(civec) < iname ) % neuer Vektor
        civec     = cell_add(civec,{i0});
        fullnames = cell_add(fullnames,{{collect_names{i}}});
      else
        ivec             = civec{iname};
        civec{iname}     = [ivec;i0];
        names            = fullnames{iname};
        fullnames{iname} = cell_add(names,collect_names{i});
      end
    end
  end

  % Signale zu Vektoren zusammenbringen
  if( ~isempty(civec) )
    n = length(civec);
    nt = length(d.time);
    for i=1:n
      ivec  = civec{i};
      vname = veknames{i};
      names = fullnames{i};
      [isort,ilist] = sort(ivec);
      sig_name = [mBuffer_name,'_',vname];
      d.(sig_name) = cell(nt,1);
      for j=1:nt
        if( nvec(j) <= 0 )
          d.(sig_name){j} = [];
        else
          nl = min(length(ilist),nvec(j));
          vec = zeros(nl,1);
          for k=1:nl
            vec(k) = d.(names{ilist(k)})(j);
          end
          d.(sig_name){j} = vec;
        end
        if( (j == 1) && uflag && isfield(u,names{ilist(1)}) )
          u.(sig_name) = u.(names{ilist(1)});
        end
      end
    end
  end
  if( erase_flag )
    if( uflag )
      [d,u] = d_data_elim_vector_w_name(collect_names,d,u,[]);
    else
      [d,u] = d_data_elim_vector_w_name(collect_names,d,[],[]);
    end
  end
end