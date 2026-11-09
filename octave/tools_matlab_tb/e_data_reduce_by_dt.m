function e = e_data_reduce_by_dt(e,dt,signame)
%
% e = e_data_reduce_by_dt(e,dt,signame)
%
% e            e-Datenstruktur mit e.time,e.vec,e.lin
%             ...
% dt          delta t Zeit, um zu interpolieren oder Werte auszulassen
% signame     Sugnalname oder '': alle Signale 
  
  if( ~exist(signame,'var') )
    c_names = fieldnames(e);
  elseif( isempty(signame) )
    c_names = fieldnames(e);
  else
    c_names = {signame};
  end
  ne      = length(c_names);
  for ie=1:ne
                                                     
    tvec = vec_reduce_to_dx(e.(c_names{ie}).time,dt);
    
    if( iscell(e.(c_names{ie}).vec)  && isnumeric(e.(c_names{ie}).vec{1}) )
    
      vec = d_data_read_e_cell_array(e.(c_names{ie}).time,e.(c_names{ie}).vec,tvec);
    else
      
      vec = mex_interpolation(double(e.(c_names{ie}).time),double(e.(c_names{ie}).vec),tvec,1,1);
    end
    e.(c_names{ie}).time = tvec;
    e.(c_names{ie}).vec  = vec;
    if( isfield(e.(c_names{ie}),'leading_time_name') )
      e.(c_names{ie}).leading_time_name = '';
    end
  end
end
function scell1 = d_data_read_e_cell_array(time0,scell0,time1)

  n1 = length(time1);
  if( n1 <= 1 )
    scell1 = {};
    return;
  else
    scell1 = cell(n1,1);
  end
  i0 = 1;
  n0 = length(time0);
  if( n0 <= 1 )
    return;
  end    
  fflag = 1;
  for i1=1:n1-1
    
    while( fflag == 1 )
      if( time1(i1) < time0(i0) )
        if( i0 == 1 )
          fflag = 2;
        else
          i0 = i0 - 1;
        end
      elseif( (i0<n0-1) )
        if( (time1(i1) >= time0(i0)) && (time1(i1) < time0(i0+1)) )
          fflag = 0;
        else
          i0 = i0 + 1;
        end
      else
          if( time1(i1) >= time0(n0) )
            i0 = n0;
            fflag = 3;
          else
            i0 = n0 -1;
            fflag = 0;
          end
      end
    end
    
    if( fflag == 0 )
      scell1{i1} = scell0{i0};
    else
      scell1{i1} = [];
    end
    fflag = 1;
  end  
end
