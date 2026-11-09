function vec = str_get_vec(txt)
%
% vec = str_get_vec(txt)
%
% Erstellt aus einem text txt ienen Vektor oder Matrix zu erzeugen
%
% txt = '0,2,3,4,5,6,7,8'; => vec = [0,2,3,4,5,6,7,8]
%
% txt = '[0;2;3;4]' => vec = [0;2;3;4]
%
% txt = '0,1;2,3;4' => vec = [0,1;2,3;4,0]
%
% txt = '1;2;a;4' => vec = [1;2;NaN;4]
%
if( ~ischar(txt) )
    error('Paramtere txt in str_get_vec() ist kein String')
end

% Anfang/Ende wegnehmen
%======================
txt = str_cut_a_f(txt,'[');
txt = str_cut_e_f(txt,']');

% Spalten trennen
%================
[ctxtcol,ncol] = str_split(txt,';');

% Zeilen zählen
%==============
nrow = 0;
for i=1:ncol
    
    [ctxtrow,n] = str_split(ctxtcol{i},',');
    nrow = max(n,nrow);
end

vec = zeros(ncol,nrow);

for i=1:ncol
    
    [ctxtrow,n] = str_split(ctxtcol{i},',');
    
    for j = 1:n
        
        val = str2num(ctxtrow{j});
        if( length(val) > 0 )
            
            vec(i,j) = val;
        else
            vec(i,j) = NaN;
        end
    end
end
