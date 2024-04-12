% calc_bmittelwert_f() bedingter Mittelwert
%input:
% in        Input Vektor
% bvec      Bedingungs Vektor
% b_min    Minimum für positiv und negativ des bedingungsvektors
% wie       = 'pos' Mittelwert der positiven Werte d.h > in_min
%           = 'neg' Mittelwert der negativen Werte d.h < -in_min
            
function   mit   = calc_bmittelwert_f(in,bvec,b_min,wie)

n = length(in);

if( n ~= length(bvec) )
    error('in-Vektor und bvec nicht gleich groß')
end

if( b_min < 0.0 )
    b_min = b_min * -1.0;
end

if( wie(1) == 'n' )
   nmit = 0;
   smit = 0;
   
   for i=1:n
       if( bvec(i) <= -b_min )
           nmit = nmit + 1;
           smit = smit + in(i);
       end
   end
   if( nmit > 0 )
       mit = smit/nmit;
   else
       mit = [];
   end
else
        
   nmit = 0;
   smit = 0;
   
   for i=1:n
       if( bvec(i) >= b_min )
           nmit = nmit + 1;
           smit = smit + in(i);
       end
   end
   if( nmit > 0 )
       mit = smit/nmit;
   else
       mit = [];
   end
end
