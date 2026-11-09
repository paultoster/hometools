function d = binbin2dec(b,bitlength)
%
% d = binbin2dec(b)
%
% Berechnet binär in dezimale Zahl
% im Unterschied zu bin2dec() kann bin > 52 bit sein
%
% b     char        binäre Zahl z.b. '10101'
% bitlength double  Anzahl der maximalen Bits, um negative werte zu erkennen
%                   default = length(b)
% d     double      dezimale Zahl
%
neg_flag = 0;
if( ~strcmp(class(b),'char') )
    b
    class(b)
    error('binbin2dec_error: b ist nicht char')
end

if( ~exist('bitlength','var') )
    bitlength = length(b);
end

while length(b) < bitlength
    b = ['0',b];
end

if( b(1) ~= '0' ) % negativer Wert
    
    neg_flag = 1;
    % b- 1
    b = binbinminus(b,'1');
    % b invertieren
    for i=1:length(b)
        if( b(i) == '0' )
            b(i) = '1';
        else
            b(i) = '0';
        end
    end
end
    
        

exp = 0;
d   = 0;
for i=length(b):-1:1

    if( b(i) ~= '0' )
        d = d + 2^exp;
    end
    exp = exp + 1;
end

if( neg_flag )
    d = d*(-1);
end


function e = binbinminus(a,b)
%
%  binär a - b
%
l1 = max(length(a),length(b));

while length(a) < l1
    a = ['0',a];
end
while length(b) < l1
    b = ['0',b];
end
e = '';
while length(e) < l1
    e = ['0',e];
end

for i=l1:-1:1
    
    if( (a(i) ~= '0' && b(i) ~= '0') || (a(i) == '0' && b(i) == '0') )
        e(i) = '0';
    elseif( a(i) ~= '0' )
        e(i) = '1';
    else
        e(i) = '1';
        for j=i-1:-1:1
            if( b(j) == '0' )
                b(j) = '1';
                break;
            end
        end
    end
end
        
    
    