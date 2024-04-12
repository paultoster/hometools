function [flag_kreuz,xe,ye,s,u] = vek_2d_geraden_kreuzen(sw,Xg0,Yg0,Xg1,Yg1)
%
% [flag_kreuz,xe,ye,s,u] = vek_2d_geraden_kreuzen(sw,Xg0,Yg0,Xg1,Yg1)
%
% Schnittpunkt zweier Gereadenstücke  g0: Xg0 = [xg0_0;xg0_1] Yg0 = [yg0_0;yg0_1]
%                                     g1: Xg1 = [xg1_0;xg1_1] Yg1 = [yg1_0;yg1_1]
% sw = 0     gibt es überhaupt einen Schnittpunkt
% sw = 1     Das Geraden Stück g0 wird geschnitten 0.0 < s < 1.0
% sw = 2     Das Geraden Stück g1 wird geschnitten 0.0 < u < 1.0
%
% sw = 3     Das Geraden Stück g0 und g1 wird geschnitten 
%            0.0 < s < 1.0 und g1 0.0 < u <1.0
% xe,ye      Schnittpunkt
% flag_kreuz 0/1 -> Es gibt keinen/einen Kreuzungspunkt mit der Vorgabe sw
% s          xe = Xg0(1) + (Xg0(2)-Xg0(1))*s
%            ye = Yg0(1) + (Yg0(2)-Yg0(1))*s            
% u          xe = Xg1(1) + (Xg1(2)-Xg1(1))*u
%            ye = Yg1(1) + (Yg1(2)-Yg1(1))*u            
%
    flag_kreuz = 0; %Kreuzungspunkt, wenn 1
    xe         = [];
    ye         = [];
    s          = [];
    u          = [];
    
    nen  = (Yg0(2)-Yg0(1))*(Xg1(2)-Xg1(1))-(Xg0(2)-Xg0(1))*(Yg1(2)-Yg1(1));
    
    if( abs(nen) < eps ) % Keine Lösung parallel
      return;
    end
    
    s = ((Xg0(1)-Xg1(1))*(Yg1(2)-Yg1(1))-(Yg0(1)-Yg1(1))*(Xg1(2)-Xg1(1)))/nen;
    
    dx = (Xg1(2)-Xg1(1));
    if( abs(dx) > eps )
      u = ((Xg0(1)-Xg1(1)) + (Xg0(2)-Xg0(1)) * s )/dx;
    else
      dy = (Yg1(2)-Yg1(1));
      if( abs(dy) > eps )
        u = ((Yg0(1)-Yg1(1)) + (Yg0(2)-Yg0(1)) * s )/dy;
      end
    end
    
    if( ~isempty(u) )
      xe         = Xg0(1) + (Xg0(2)-Xg0(1))*s;
      ye         = Yg0(1) + (Yg0(2)-Yg0(1))*s;
      if( sw == 0 )      
        flag_kreuz = 1;
      elseif( (sw == 1) && (s > 0.0) && (s < 1.0) )
        flag_kreuz = 1;
      elseif( (sw == 2 && (u > 0.0) && (u < 1.0) ) )
        flag_kreuz = 1;
      elseif( (sw == 3) && (s > 0.0) && (s < 1.0) && (u > 0.0) && (u < 1.0) )
        flag_kreuz = 1;
      end        
          
    end
        
    
%     d01 = sqrt((y1-y0)^2+(x1-x0)^2);
%     dab = sqrt((yb-ya)^2+(xb-xa)^2);
%     
%     sin01  = (y1-y0)/not_zero(d01);
%     cos01  = (x1-x0)/not_zero(d01);
%    
%     sinab  = (yb-ya)/not_zero(dab);
%     cosab  = (xb-xa)/not_zero(dab);
%     
%     % schnittpunkt
%     nenn = cos01*sinab-cosab*sin01;
%     
%     if( abs(nenn) < 1e-8 ) % kein schnittpunkt möglich
%         return
%     end
%     xe = (xa*cos01*sinab-x0*cosab*sin01+(y0-ya)*cosab*cos01)/nenn;
%     
%     nenn = sin01*cosab-sinab*cos01;
%     
%     if( abs(nenn) < 1e-8 ) % kein schnittpunkt möglich
%         return
%     end
%     ye = (ya*sin01*cosab-y0*sinab*cos01+(x0-xa)*sinab*sin01)/nenn;
%     
%     % Überhaupt ein Kreuzungspunkt
%     if( sw == 0 )
%       
%       flag_kreuz = 1;
%     % Schneidet die unendliche Gerade aus x0,y0,x1,y1 das Geradenstück
%     % xa,ya,xb,yb
%     elseif( sw == 1 )
%     
%       dae = sqrt((ye-ya)^2+(xe-xa)^2);
%       dbe = sqrt((ye-yb)^2+(xe-xb)^2);
%       if( dae <= dab && dbe < dab )
%         flag_kreuz = 1;
%       end
%     % Schneidet die unendliche Gerade aus xa,ya,xb,yb das Geradenstück
%     % x0,y0,x1,y1
%     elseif( sw == 1 )
%       d0e = sqrt((ye-y0)^2+(xe-x0)^2);
%       d1e = sqrt((ye-y1)^2+(xe-x1)^2);
%       if( d0e <= d01 && d1e < d01 )
%         flag_kreuz = 1;
%       end
%     else
%        dae = sqrt((ye-ya)^2+(xe-xa)^2);
%       dbe = sqrt((ye-yb)^2+(xe-xb)^2);
%       d0e = sqrt((ye-y0)^2+(xe-x0)^2);
%       d1e = sqrt((ye-y1)^2+(xe-x1)^2);
%       if( d0e <= d01 && d1e < d01 && dae <= dab && dbe < dab )
%         flag_kreuz = 1;
%       end     
%     end
end