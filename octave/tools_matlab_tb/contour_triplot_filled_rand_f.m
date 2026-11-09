function	contour_triplot_filled_rand_f(tri,x,y)
%=====================================================================
%=====================================================================    
rand('state',sum(100*clock))
farb1 = rand(size( tri(:,1)));
rand('state',sum(100*clock))
farb2 = rand(size(tri(:,1)));
rand('state',sum(100*clock))
farb3 = rand(size(tri(:,1)));

color_m = [farb1,farb2,farb3];
for i=1:length(tri(:,1))
    x1=[ x(tri(i,1)),x(tri(i,2)),x(tri(i,3)),x(tri(i,1))];
    y1=[y(tri(i,1)),y(tri(i,2)),y(tri(i,3)),y(tri(i,1))];
    fill(x1, y1,color_m(i));
    hold on
end