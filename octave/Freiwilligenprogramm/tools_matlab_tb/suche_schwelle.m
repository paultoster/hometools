function index = suche_schwelle(signal,thr,rel,tol)
%
% index = suche_schwelle(signal,thr,rel,tol)
%
% Sucht die Schwelle thr im Signal signal nach der Vorschrift rel
%
% signal:       Vektor des Signals
% thr:          Schwellwert 
% rel:          Vorschrift '==',              Gleichheit innerhalb der Toleranz tol
%                          '~=','!=',         Ungleichheit ausserhalb der Toleranz tol
%                          '>','>=','<','<=', Größer,Gr.-gleich,Kleiner,Kl.-gleich (ohne Tolleranz),
%                          '->'               Durchtritt nach größer der Schwelle mit Toleranz
%                                             signal(i-1) < thr) && (signal(i-1) >= thr+tol)
%                          '<-'               Durchtritt nach kleiner der Schwelle  mit Toleranz
%                                             signal(i-1) > thr) && (signal(i-1) <= thr-tol)
% tol:          Toleranz (default:tol = 1.0e-8)
% index         = 0 , wenn nicht gefunden
%               ansosnten Ereignis aufgetreten bei signal(index)
%
index = 0;
thr = thr(1);
if( nargin < 4 )
    tol = 1.0e-8;
end
switch(rel)
    case '=='
        for i=1:length(signal)        
            if( abs(signal(i)-thr) < tol )
                index = i;
                break
            end
        end
    case {'~=','!='}
        for i=1:length(signal)        
            if( abs(signal(i)-thr) > tol )
                index = i;
                break
            end
        end
    case '>'
        for i=1:length(signal)        
            if( signal(i) > thr )
                index = i;
                break
            end
        end
    case '>='
        for i=1:length(signal)        
            if( signal(i) >= thr )
                index = i;
                break
            end
        end
    case '<'
        for i=1:length(signal)        
            if( signal(i) < thr )
                index = i;
                break
            end
        end
    case '<='
        for i=1:length(signal)        
            if( signal(i) <= thr )
                index = i;
                break
            end
        end
    case '->' % Durchtritt zu größer
        for i=2:length(signal)        
            if( (signal(i-1) < thr) && (signal(i) >= thr+tol) )
                index = i;
                break
            end
        end
    case '<-' % Durchtritt zu kleiner
        for i=2:length(signal)        
            if( (signal(i-1) > thr) && (signal(i) <= thr-tol) )
                index = i;
                break
            end
        end
    otherwise
       
        error('Vorschrift rel=%s ist nicht ==,~=,!=,>,>=,<,<=,->,<-',rel)
end

