function  vec = filter_peaks_f(vec,ncount,anteil);

% Wenn ein peak gößer delta > |(max(vec)-min(vec))*anteil| dann wird rausgefilter
% ncount maximal ncount werte dürfen als peak erkannt werden.

deltamax = abs((max(vec)-min(vec))*max(0.0,min(1.0,anteil)));

dvec = diff(vec);

for i=1:length(dvec)-1
    
    if( (dvec(i) > deltamax & dvec(i+1) < -deltamax) ...
      | (dvec(i) < -deltamax & dvec(i+1) > deltamax) ...
      )
  
        vec(i+1) = (vec(i+2)+vec(i))*0.5;
    end
end

if( (dvec(length(dvec)) > deltamax) | (dvec(length(dvec)) < -deltamax) )
    
    vec(length(dvec)+1) = 2*vec(length(dvec))-vec(length(dvec)-1);
end
