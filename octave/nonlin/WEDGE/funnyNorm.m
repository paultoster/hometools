function funnyNorm_s = funnyNorm(s,norm_s)
% funnyNorm computes the quantity
% sqrt(norm_s^2 + 1/2*norm(s*s','fro')^2)

funnyNorm_s = sqrt(norm_s^2 + 1/2*norm(s*s','fro')^2);
