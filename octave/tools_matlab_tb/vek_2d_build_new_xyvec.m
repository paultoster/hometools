function [xnewvec,ynewvec,snewvec] = vek_2d_build_new_xyvec(xvec,yvec,svec,ds,type)
%
%
% [xnewvec,ynewvec,snewvec] =
% vek_2d_build_new_xyvec(xvec,yvec,svec,ds,type);
%
%  build new x-y-vector with distance ds
% 
%  type   = 0 :  build abetween svec(i+1) and svec(i) ds ds < svec(i+1) - svec(i)
%                and modify ds, that it fits between svec(i+1) and svec(i)
%
  snewvec = [];
  xnewvec = [];
  ynewvec = [];

  if(type == 0)
    n = length(svec);
    if( n > 1 )
      s0 = svec(1);
      
      for i=2:n
        s1 = svec(i);
        nnew = floor((s1-s0)/ds+0.5)+1;
        ds   = (s1-s0)/(nnew-1);
        ss   = zeros(nnew,1);
        ss(1) = svec(i-1);
        for i=2:nnew
          ss(i) = ss(i-1)+ds;
        end
        
        if( i == 2 )
          snewvec = ss;
        else
          snewvec = [snewvec;ss(2:end)];
        end
      end
      xnewvec = interp1(svec,xvec,snewvec,'linear');
      ynewvec = interp1(svec,yvec,snewvec,'linear');
    end
      
  else
    error('type = %f is not impelemnted',type);
  end
end  
      