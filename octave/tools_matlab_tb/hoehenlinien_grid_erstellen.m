function zi =hoehenlinien_grid_erstellen(x_vec,y_vec,tri,x,y,z,plot_flag)

if( ~exist('plot_flag','var') )
    plot_flag = 0;
end

% Netz prüfen
tri = pruefe_netz(tri);

% Grid berechnen
%===============
[grid_con_xi,grid_con_yi] = meshgrid(x_vec,y_vec);

grid_con_zi = grid_con_xi*0;
[m,n]=size(grid_con_zi);

% Schwerpunkte berechnen
xs = tri(:,1);
ys = tri(:,1);
for i=1:length(tri)
    
    xs(i) = (x(tri(i,1))+x(tri(i,2))+x(tri(i,3)))/3;
    ys(i) = (y(tri(i,1))+y(tri(i,2))+y(tri(i,3)))/3;
end
    
% h1 = figure;
% plot3(x,y,z,'o')
% xlabel('x');
% ylabel('y');
% zlabel('z');
% hold on

for i=1:m
    for j=1:n
        
        grid_con_zi(i,j) = contour_berechne_z_aus_tri(x,y,z ...
                                                     ,tri ...
                                                     ,grid_con_xi(i,j),grid_con_yi(i,j) ...
                                                     ,xs,ys);
%        plot3(grid_con_xi(i,j),grid_con_yi(i,j),grid_con_zi(i,j),'*');
%          input('pause');
%          figure(h1);
       
%         if( grid_con_xi(i,j) >= 2000 && grid_con_yi(i,j) >= 0 ) 
%             a = 1;
%         end
% %        k = tsearch(x,y,tri,grid_con_xi(i,j),grid_con_yi(i,j));
%         k = contour_tsearch(x,y,tri,grid_con_xi(i,j),grid_con_yi(i,j));
%         
%         if( isnan(k) ) % Der Punkt liegt ausserhalb des Netzes:
%             grid_con_zi(i,j) = contour_dsearch_f(tri,xs,ys,x,y,z,grid_con_xi(i,j),grid_con_yi(i,j)) ;
%         else
% 
%             grid_con_zi(i,j) = contour_berechne_hoehe_aus_dreieck(tri,k ...
%                                                                  ,grid_con_xi(i,j) ...
%                                                                  ,grid_con_yi(i,j));
%             x1 = x(tri(k,1));
%             x2 = x(tri(k,2));
%             x3 = x(tri(k,3));
%             y1 = y(tri(k,1));
%             y2 = y(tri(k,2));
%             y3 = y(tri(k,3));
%             z1 = z(tri(k,1));
%             z2 = z(tri(k,2));
%             z3 = z(tri(k,3));            
% 
%             
%             nenner = (x3-x2)*y1+(x1-x3)*y2+(x2-x1)*y3;
%             
%             if( abs(nenner) < eps )                
%                 alpha = (z1+z2+z3)/3;
%                 beta = 0.;
%                 gamma = 0.;
%             else
%                 alpha = ((x2*y3-x3*y2)*z1 + (x3*y1-x1*y3)*z2 + (x1*y2-x2*y1)*z3) / nenner;
%                 beta  = ((z2-z1)*y3 + (z1-z3)*y2 + (z3-z2)*y1) / nenner;
%                 gamma = ((z1-z2)*x3 + (z3-z1)*x2 + (z2-z3)*x1) / nenner;
%             end
%             
%             grid_con_zi(i,j) = alpha+beta*grid_con_xi(i,j)+gamma*grid_con_yi(i,j);
%         end
                
       
    end
end
if( plot_flag)
    h=figure;
    mesh(grid_con_xi,grid_con_yi,grid_con_zi), hold on
    plot3(x,y,z,'o')
    xlabel('x');
    ylabel('y');
    zlabel('z');
    title('grid from s_contour');
end
zi = grid_con_zi;

clear grid_con_*

return

function tri = pruefe_netz(tri0)

tri = [];

for i=1:length(tri0(:,1))
    
    i1 = tri0(i,1);
    i2 = tri0(i,2);
    i3 = tri0(i,3);
    
    if( i1~=i2 & i1~=i3 & i2~=i3 )
        tri = [tri;tri0(i,:)];
    end
end
