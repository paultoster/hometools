function accvec = build_acc_from_x_y_v(xvec,yvec,vvec)
%
% accvec = build_ac_from_x_y_v(xvec,yvec,vvec)
%
% build acc-vector from x-,y-vector and v-vector 
% assuming havving constant acc between points
%
  svec = vek_2d_build_s(xvec,yvec);

  accvec = build_acc_from_s_v(svec,vvec);
end
