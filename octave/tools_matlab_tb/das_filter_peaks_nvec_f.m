function        d = das_filter_peaks_nvec_f(d,names_to_search_peak,ncount,anteil);

% Sucht Peaks in names_to_search_peak Liste und wertet sie für alle d.Vektoren aus
% Wenn ein peak gößer delta > |(max(vec)-min(vec))*anteil| dann wird rausgefilter
% ncount maximal ncount werte dürfen als peak erkannt werden.

names = fieldnames(d);

index_list = [];
kindex = 0;

for i=1:length(names)
    
    for j=1:length(names_to_search_peak)
        
        % Suche nach peaks aus names_to_search_peak-Liste
        if( strcmp( names{i},names_to_search_peak{j}) )
            
            vec = getfield(d,names{i});
            
            deltamax = abs((max(vec)-min(vec))*max(0.0,min(1.0,anteil)));

            dvec = diff(vec);

            for k=1:length(dvec)-1
    
                if( (dvec(k) > deltamax & dvec(k+1) < -deltamax) ...
                  | (dvec(k) < -deltamax & dvec(k+1) > deltamax) ...
                  )
  
                    kindex = kindex + 1;
                    index_list(kindex) = k+1;
                end
            end

            if( (dvec(length(dvec)) > deltamax) | (dvec(length(dvec)) < -deltamax) )
    
                    kindex = kindex + 1;
                    index_list(kindex) = length(dvec)+1;
            end
        end
    end
end

% Bereinige Liste
if( length(index_list) > 0 )
    
    index_list = sortiere_aufsteigend_f(index_list);
    
end

%Eliminiere peaks für alle vektoren:
for i=1:length(names)
 
    vec = getfield(d,names{i});
    
    for j=1:length(index_list)
        
        index = index_list(j);
        
        if( index == 1 )
            
            vec(index) = vec(index+1)*2-vec(index+2);
            
        elseif( index == length(vec) )
            
            vec(index) = vec(index-1)*2-vec(index-2);
            
        elseif( index < length(vec) )    
            
            vec(index) = (vec(index+1)+vec(index-1))*0.5;
        end
    end
    
    d = setfield(d,names{i},vec);
end
