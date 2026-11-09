function [xlvec,ylvec,slvec] = vek_2d_build_lane_mark(xvec,yvec,b)
%
%
% [xlvec,ylvec,slvec] = vek_2d_build_lane(xvec,yvec,b);
%
%  build lane mark in distance b
%

% sin(x+90) = sin(x)*cos(90) + cos(x)*sin(90) = cos(x)
% cos(x+90) = cos(x)*cos(90) - sin(x)*sin(90) = -sin(x)

  [svec,dsvec,alphavec]=vek_2d_s_ds_alpha(xvec,yvec);
  
  n = length(svec);
  xlvec = zeros(n,1);
  ylvec = zeros(n,1);
  
  if( n > 1 )
    
  
    for i=1:n
      
      if( i <= 2 )
        x0 = xvec(1);
        y0 = yvec(1);
        alpha0 = alphavec(1);
        cbeta0 = -sin(alpha0);
        sbeta0 = cos(alpha0);
        x00Lane = x0 + b * cbeta0;
        y00Lane = y0 + b * sbeta0;
      else
        x0 = x1;
        y0 = y1;
        alpha0 = alpha1;
        cbeta0 = cbeta1;
        sbeta0 = sbeta1;
        x00Lane = xlvec(i-1);
        y00Lane = ylvec(i-1);
      end
    
      
      if( i == 1 )
      
        xlvec(i) = x00Lane;
        ylvec(i) = y00Lane;
      
      elseif( i < n )
        
        x1 = xvec(i);
        y1 = yvec(i);
        x2 = xvec(i+1);
        y2 = yvec(i+1);
        
        alpha1 = alphavec(i);
        cbeta1 = -sin(alpha1);
        sbeta1 = cos(alpha1);

        x01Lane = x1 + b * cbeta0;
        y01Lane = y1 + b * sbeta0;
        
        if( abs(alpha1-alpha0) > 1.e-6 )
       
          x10Lane = x1 + b * cbeta1;
          y10Lane = y1 + b * sbeta1;

          x11Lane = x2 + b * cbeta1;
          y11Lane = y2 + b * sbeta1;


          [flag_kreuz,xe,ye,s,u] = vek_2d_geraden_kreuzen(0 ...
                                                         ,[x00Lane;x01Lane] ...
                                                         ,[y00Lane;y01Lane] ...
                                                         ,[x10Lane;x11Lane] ...
                                                         ,[y10Lane;y11Lane] ...
                                                         );
        else
          flag_kreuz = 0;
        end
        
        if( flag_kreuz )
          xlvec(i) = xe;
          ylvec(i) = ye;
        else
           xlvec(i) = x01Lane;
           ylvec(i) = y01Lane;
        end
        
          
      else
        x1 = xvec(i);
        y1 = yvec(i);
        
        xlvec(i) = x1 + b * cbeta0;
        ylvec(i) = y1 + b * sbeta0;
        
      end
                                                   
    end
  end
  [slvec,~,~]=vek_2d_s_ds_alpha(xlvec,ylvec);
end
                                                   
                                                   
                                                   
                                                   
                                                   
      