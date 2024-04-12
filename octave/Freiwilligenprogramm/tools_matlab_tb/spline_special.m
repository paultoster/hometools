function [x1,y1,z1] = spline_special(xvec,yvec,zvec,dx)
%
% vout = spline_special(xvec,yvec,zvec,tnew)
%
% xvec      double      x-Vektor
% yvec      double      y-Vektor, wenn ~= 0 wird Splinwe für zvec gebildet
% zvec      double      z-Vektor, wird mit tnew spline erstellt
% dx        double      Abtastrate neuer x-Vektor
%
% vout      doube       Ausgabe-Spline von zvec
%
n = length(yvec);
found_flag = 0;
s = struct([]);
ic = 0;
for(i=1:n)

    if( found_flag == 0 )

        if( abs(yvec(i)) > 1e-6 )
            ic = ic + 1;
            s(ic).xstart = xvec(max(1,i-1));
            s(ic).xend   = xvec(max(1,i-1));
            s(ic).istart = max(1,i-1);
            s(ic).iend   = max(1,i-1);
            s(ic).x      = [];
            s(ic).y    = [];
            s(ic).z    = [];

            found_flag = 1;
        end
        icc = 0;
    else

        if( abs(yvec(i)) < 1e-6 )
            if( icc == 0 )
                iend = i;
            end
            icc = icc+1;
        else
            icc = 0;
        end

        if( icc > 2 || i == n)

            iend = min(iend,n);

            s(ic).xend = xvec(iend);
            s(ic).iend = iend;

            for j=s(ic).istart:s(ic).iend
                x = xvec(j)-xvec(s(ic).istart);
                s(ic).z = [s(ic).z;zvec(j)];                    
                s(ic).y = [s(ic).y;yvec(j)];                    
                s(ic).x = [s(ic).x;x];                    
            end
            found_flag = 0;
        end
    end
end

m = length(s);
for j=1:m

    s(j).x1 = [0:dx:s(j).x(length(s(j).x))]';
    s(j).y1 = interp1(s(j).x,s(j).y,s(j).x1);
    s(j).z1 = spline(s(j).x,s(j).z,s(j).x1);
end    
nneu = 0;
x1   = [];
y1   = [];
z1   = [];

for j=1:m

    x0 = nneu*dx;

    while(x0 < s(j).xstart)
        x1 = [x1;x0];
        y1 = [y1;0.0]; 
        z1 = [z1;0.0]; 
        nneu = nneu + 1;
        x0 = nneu*dx;
    end

    nn = 0;
    while( x0 < s(j).xend )
        nn   = nn+1;
        x1 = [x1;x0];
        y1  = [y1;s(j).y1(nn)]; 
        z1  = [z1;s(j).z1(nn)]; 
        nneu = nneu + 1;
        x0 = nneu*dx;
   end                            
end

while( x0 < xvec(n) )
    x1 = [x1;x0];
    y1  = [y1;0.0]; 
    z1  = [z1;0.0]; 
    nneu = nneu + 1;
    x0 = nneu*dx;
end
