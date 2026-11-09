function [alpha,Gg,gg,gGg] = cauchy(g, G, Delta)

Gg = G*g;
gGg = g'*Gg;
gg = g'*g;
norm_g = sqrt(gg);
if gGg > 0
   alpha = min(gg/gGg, Delta/norm_g);
else
   if gGg == 0 
      warning('Curvature along g is zero');
   end
   alpha = Delta/norm_g;
end





