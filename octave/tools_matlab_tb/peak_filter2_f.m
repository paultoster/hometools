function    [d,c_comment] = peak_filter2_f(d,std_fac,all)

% Sucht 2 Peaks in Strukturliste von d hintereinander zu finden sind, wenn Betrag der Differenz eines
% Vektors ausserhalb des Wertes std_fac * Standardabweichung liegt.
% Wenn all gesetzt werden alle Vektoren an dieser Stelle gebügelt,
% ansonsten nur der Vektor
% 
% d         Struktur mit Datenvektor (double)
% std_fac   (def=3.0) Faktor zur Festlegung des Bands
% all       (def=1) Flag ob all an einer gefunden peak-stelle gefiltert
%            werden

if( nargin < 2 )
    std_fac = 3;
else
    std_fac = abs(std_fac);
end
if( nargin < 3 )
    all = 1;
end

if( all )
    c_comment{1} = 'alle Vektoren werden gefiltert';
else
    c_comment{1} = 'Nur die einzelnen Vektoren werden gefiltert';
end

if( isnumeric(d) )
  d.vec = d;
  is_vector = 1;
  all = 1;
else
  is_vector = 0;
end

names = fieldnames(d);

index_list = [];
name_list = [];
kindex = 0;
cindex = 1;

%fprintf('len=%g\n',length(names));
for i=1:length(names)
    
%            fprintf('%g....\n',i);
            vec = getfield(d,names{i});
            
            dvec = diff(vec);
            
            idvec = 0;
            for k=1:length(dvec)
                if( dvec(k) ~= 0 )
                    idvec = idvec+1;
                    dvec1(idvec) = dvec(k);
                end
            end
            if( idvec == 0 )
                dvec1(1) = 0;
            end
            
            
            thr  = std(dvec1) * std_fac;
            thr1 = std(dvec1);
            clear dvec1

            k = 1;
            while( k <= length(dvec)-2 )

                if( (dvec(k) > thr & abs(dvec(k+1)) < thr1  & dvec(k+2) < -thr) ...
                  | (dvec(k) < -thr & abs(dvec(k+1)) < thr1   & dvec(k+2) > thr) ...
                  )
  
                    kindex = kindex + 1;
                    cindex = cindex + 1;
                    index_list(kindex) = k+1;
                    name_list(kindex) = i;
                    c_comment{cindex} = sprintf('%s(%i)',names{i},k+1);
                    k = k + 3;
                else
                    k = k + 1;
                end
            end

%             if( (dvec(length(dvec)) > thr) | (dvec(length(dvec)) < -thr) )
%     
%                     kindex = kindex + 1;
%                     cindex = cindex + 1;
%                     index_list(kindex) = length(dvec)+1;
%                     name_list(kindex) = i;
%                     c_comment{cindex} = sprintf('%s(%i)',names{i},k+1);
%             end
end


if( all )

    if( length(index_list) > 0 )
        
        index_list = sortiere_aufsteigend_f(index_list);
        for i=1:length(index_list)
            cindex=cindex+1;
            c_comment{cindex} = sprintf('(%i)',index_list(i));
        end
    
        %Eliminiere peaks für alle vektoren:
        for i=1:length(names)
 
            vec = getfield(d,names{i});
    
                for j=1:length(index_list)
        
                    index = index_list(j);
        
                    if( index == 1 )
            
                        vec(index) = vec(index);
            
                    elseif( index == length(vec) )
            
                        vec(index) = vec(index);
            
                    elseif( index < length(vec) )    
            
                        vec(index)   = vec(index-1) + (vec(index+2)-vec(index-1))/3;
                        vec(index+1) = vec(index-1) + (vec(index+2)-vec(index-1))*2/3;
                    end
                end
    
                d = setfield(d,names{i},vec);
        end
    end
else
    for i=1:length(index_list)
        
        vec = getfield(d,names{name_list(i)});
        index = index_list(i);
        
        if( index == 1 )
            
            vec(index) = vec(index);
            
        elseif( index == length(vec) )
            
            vec(index) = vec(index);
            
        elseif( index < length(vec) )    
            
            vec(index)   = vec(index-1) + (vec(index+2)-vec(index-1))/3;
            vec(index+1) = vec(index-1) + (vec(index+2)-vec(index-1))*2/3;
        end
        d = setfield(d,names{name_list(i)},vec);
    end        
end

if( is_vector )
  d = d.vec;
end

        
if( length(c_comment) == 1 )
  
    c_comment = {};
end