function    [d,c_comment] = peak_filter3_f(d,std_fac)
%
% Sucht Werte exakt null und am Rand muß ein hoher Gradient sein
% Diese Werte werden dann interpoliert, wenn er mindestens
% vorkommt. (Damit werden digitale Signale nicht fälschlicherweise geglättet)
%
% Parameter
% d         Struktur mit Datenvektor (double)
% std_fac   (def=3.0) Faktor zur Festlegung des Bands
ncount = 3;

if( nargin < 2 )
    std_fac = 3;
else
    std_fac = abs(std_fac);
end

c_comment = {};
names = fieldnames(d);

index_list = [];
name_list = [];
kindex = 0;
cindex = 1;

%fprintf('len=%g\n',length(names));
nn0 = [];
nn1   = [];
nnc = [];
for i=2:length(names)
    
    nstart = [];
    nend   = [];
    % Stellen mit null suchen
    
    % Vektorn und ableitung und threshold bilden
    vec  = getfield(d,names{i}); 
    
%     if( strcmp(names{i},'s_Pedal') )
%         plot(vec)
%     end
    
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
    
    flag = 0;
    ic = 0;
    for k =1:length(vec)
        
        if( flag == 0 ) % sucht Anfang
            
            if( abs(vec(k)) < 1e-10 )
                ic = ic + 1;
                nstart(ic) = k;
                flag = 1;
                
            end
        elseif( flag == 1 ) % such Ende
            
            if( abs(vec(k)) > 1e-10 )
                nend(ic) = k-1;
                flag = 0;
            end
        end
    end
    if( flag == 1 )
        nend(ic) = length(vec);
    end
    
    % gefundene Stellen bewerten
    ic = 0;
    n1start = [];
    n1end   = [];
    for k=1:length(nstart)
        
        if( nend(k) - nstart(k) < length(vec)/10 )
            ic = ic + 1;
            n1start(ic) = nstart(k);
            n1end(ic)   = nend(k);
        end
    end
    nstart = n1start;
    nend   = n1end;
    
    
    
    % Rand bewerten
    for k=1:length(nstart)
        [n0,n1,ok] = suche_rand(nstart(k),nend(k),vec,dvec,thr);
        
        if( ok & (n0 ~= n1) )
            
            i1 = suche_wert(n0,nn0);
            i2 = suche_wert(n1,nn1);
            
            if( i1 > 0 & (abs(i1 - i2)<1.0e-8) ) % gefunden
                                    
                nnc(i1) = nnc(i1)+1;
            else
                i1 = length(nn0)+1;
                nn0(i1) = n0;
                nn1(i1) = n1;
                nnc(i1) = 1;
            end
        end
    end
end

for i=2:length(names)

    for j=1:length(nn0)
    
        if( nnc(j) > ncount )
            
            c_comment{length(c_comment)+1} = sprintf('%s(%i:%i)',names{i},nn0(j),nn1(j));
%             fprintf(c_comment{length(c_comment)})
%             fprintf('\nn0: %i n1: % i k: %i',n0,n1,k)
            delta = (d.(names{i})(nn1(j)) - d.(names{i})(nn0(j)))/(nn1(j)-nn0(j));
            for k=nn0(j)+1:nn1(j)-1                        
                d.(names{i})(k) = d.(names{i})(nn0(j)) + delta * (k-nn0(j));
            end
        end
    end
end

function [n0,n1,ok_flag] = suche_rand(nstart,nend,vec,dvec,thr)
%
% sucht die Ränder zu den Null-Werten
ok_flag = 0;
status   = 0;
n0 = 0;
n1 = 0;
if( nstart == 1 )
    
    ok_flag = 1;
    n0      = 1;
else
    for i=nstart-1:-1:1
    
        switch(status) 
            case 0   % Prüfe ob Gradient am RAnd größer threshold
                if( abs(dvec(i)) > thr )
                    status = 1;
                else
                    status = 2;
                end
            case 1   % Prüfe wann gradient wieder kleiner threshold
                if( abs(dvec(i)) < thr ) 
                    status = 2;
                    ok_flag = 1;
                    n0 = i+1;
                end
            case 2
                break;
        end
    end
end

if( ~ok_flag )
    return
end
if( status == 1 ) % Hat Rand nicht gefunden
    n0      = 1;
end
            
% Ende suchen
ok_flag = 0;
status   = 0;

if( nend == length(vec) )
    n1 = nend;
    ok_flag = 1;
else
    for i=nend:length(vec)-1
        
        switch(status)
            case 0 %Prüfe ob Gradient am RAnd größer threshold
                if( abs(dvec(i)) > thr )
                    status = 1;
                else
                    status = 2;
                end
            case 1   % Prüfe wann gradient wieder kleiner threshold
                if( abs(dvec(i)) < thr ) 
                    status = 2;
                    ok_flag = 1;
                    n1 = i;
                end
            case 2
                if( ~ok_flag )
                    return 
                end
                break;
        end
    end
end

function k = suche_wert(n,n_liste)

k = 0;

for i=1:length(n_liste)
    
    if( abs(n-n_liste(i)) < 1.0e-8 )
        k = i;
        break
    end
end