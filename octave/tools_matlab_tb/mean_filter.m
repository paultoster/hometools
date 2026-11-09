function xf = mean_filter(x,n1)
% xf = mean_filter(x,n)
%
% Mittelwertfilter üb n-Punkte
%
n = length(x);
xf = x;
for i=1:n

    xf(i) = mean(x(round(max(1,i-n1+1)):i));
end
    