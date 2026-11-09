function cavec = cell_build_acc_from_x_y_v(cxvec,cyvec,cvvec)
%
% cavec = cell_build_acc_from_x_y_v(cxvec,cyvec,cvvec)
%
% build from cell vectors the acceleration
%
  [n1,m1] = size(cxvec);
  [n2,m2] = size(cyvec);
  [n3,m3] = size(cvvec);
  
  n = min([n1,n2,n3]);
  m = min([m1,m2,m3]);
  
  cavec = cell(n,m);
  
  for i= 1:n
    for j=1:m      
      if( ~isempty(cxvec{i,j}) && ~isempty(cyvec{i,j}) && ~isempty(cvvec{i,j}) )       
        cavec{i,j} = build_acc_from_x_y_v(cxvec{i,j},cyvec{i,j},cvvec{i,j});
      end
    end
  end

end