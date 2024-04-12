function accvec = build_acc_from_s_v(svec,vvec)
%
% accvec = build_ac_from_s_v(svec,vvec)
%
% build acc-vector from s-vector and v-vector 
% assuming havving constant acc between points
%
  % in case of cell array with vektors
  if( iscell(svec) && iscell(vvec) )
    
    n = min(length(svec),length(vvec));
    accvec = cell(1,n);
    
    for i=1:n
      
      if( isempty(svec{i}) || isempty(vvec{i}) )
        acc =  [];
      else
        acc = build_acc_from_s_v_build(svec{i},vvec{i});
      end
      accvec{i} = acc;
    end
  % in case of vector
  else
    accvec = build_acc_from_s_v_build(svec,vvec);
  end
end
function accvec = build_acc_from_s_v_build(svec,vvec)
  
  n = min(length(svec),length(vvec));
  
  accvec = zeros(n,1);
  
  if( n > 1 )
    
    for i=2:n
      dv = vvec(i)-vvec(i-1);
      ds = svec(i)-svec(i-1);
      accvec(i-1) = dv/not_zero(ds)*(0.5*dv+vvec(i-1));
    end
    accvec(n)=accvec(n-1);
  end
end
