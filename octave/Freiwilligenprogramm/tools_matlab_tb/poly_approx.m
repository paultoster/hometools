%    funktion [polynom,Err] = poly_approx(xap,yap,Ftyp,g0,g1,PlotFlag,PlotTitle,wieMatlab)
% 
%      Polynomapproximation mit Ausgleichsrechnung
% 
%      xap	zu approximierenden x-Array
%      yap        dazugehörige Werte yap = f(xap)
%      
%      Ftyp	Funktionstyp
%      		= 1	    a(1) + a(2) * x       + ... + a(n) * x^(n-1)
%      		= 2     a(1) + a(2) * x       + ... + a(n) * x^(1/(n-1))
%      		= 3     a(1) + a(2) / x       + ... + a(n) / x^(n-1)
%      		= 4     a(1) + a(2) * exp(x)  + ... + a(n) * exp(x^(n-1)) 
%      		= 5     a(1) + a(2) * exp(-x) + ... + a(n) * exp(-x^(n-1))
%      		= 6     a(1) + a(2) * log(x)  + ... + a(n) * log(x^(n-1))
%      
%      g0         kleinstes Potenz (0,1,2, ...)
%      g1		höchste Potenz  => n
%      
%      PlotFlag   = 0 kein Plot
%                 = 1 Plot mit size(xap)*10 Punkten
%                 = 2 wie 1 ohne marker mit Legende
%      PlotTitle  wenn PlotFlag. dann wird dieser geplottet
%
%      wieMatlab  =1  Ausgabe wie Matlab, wird invertiert zu
%                     [an,an-1, ... a0]
%      wieMatlab  =0  Ausgabe wie bisher, (z.B. für poly_multiplaction)
%                     [a0,a1, ... an]
%
%      polynom    = Polynom mit
%      
%      z.B.       a = poly_approx(xmess,ymess,1,1,4)
% 
%                 =>  ergibt ein Polnom:
%                     y = a(1) + a(2)*x + a(3)*x^2 + a(4)*x^3 + a(5)*x^4
%                     
%                     wobei a(1) == 0 ist.
function [polynom,Res] = poly_approx(xap,yap,Ftyp,g0,g1,PlotFlag,PlotTitle,wieMatlab)

if( ~exist('PlotTitle','var') )
    PlotTitle = '';
end
if( ~exist('wieMatlab','var') )
    wieMatlab = 0;
end

  Res = 0.;
  polynom = [];
  ndim = size(xap);
  ndim = ndim(1);
  
  mdim = size(xap);
  mdim = mdim(2);
  
  ndimy = size(yap);
  ndimy = ndimy(1);
  
  mdimy = size(yap);
  mdimy = mdimy(2);

  if( mdim > 1 )
    disp 'Error_poly_approx:##########################################'
    disp ' '
    disp 'x-Array kein Spalten-Vektor '
    disp ' '
    disp '########################################################'
    return
  end

  if( mdimy > 1 )
    disp 'Error_poly_approx:##########################################'
    disp ' '
    disp 'y-Array kein Spalten-Vektor '
    disp ' '
    disp '########################################################'
    return
  end

  if( ndim ~= ndimy )
    disp 'Error_poly_approx:##########################################'
    disp ' '
    disp 'x-Array != y-Array '
    disp ' '
    disp '########################################################'
    return
  end


  Ftyp = floor(Ftyp);
  
  if Ftyp < 1 

     disp 'poly_approx_error: Ftyp ist kleiner 1'
     disp '               siehe help spolyap '
     Ftyp
     return
 elseif Ftyp > 6 Then

     disp 'poly_approx_error: Ftyp ist groesser 6'
     disp '               siehe help spolyap '
     Ftyp
     return
  end


  g0 = floor(g0);
  g1 = floor(g1); 

  if g0 < 0

     disp 'poly_approx_error: g0 ist kleiner 0'
     g0
     return
  elseif g1 < g0
  
     disp 'poly_approx_error: g1 ist kleinner als g0'
     [g0,g1]
     return
     
  end
  
  mdim = g1-g0+1;

  for j = 1:mdim
  
       pot = g0+j-1;
    
    for i = 1:ndim
    
      if pot == 0
        A(i,j) = 1;
      else
        A(i,j) = sfunktion(xap(i),Ftyp,pot);
      end
      
    end

  end

  X = ausgleichsrechnung(A,yap);
  
%   N = A'*A;
%   V = A'*yap;
%   
%   X = N^-1;
%   
%   for i=1:mdim
%     for j=1:mdim
%       if( X(i,j) == NaN  || X(i,j) == Inf )
%         disp 'spolynom_error: Matrix konnte nicht invertiert werden !!'
%         return
%       end
%     end
%   end
% 
%   X = X*V;

  for k = 1:g1+1
  
    if( g0 > k-1 )
    
      polynom(k)=0.0;
    else
      polynom(k)=X(k-g0);
    end
  end

  Res = 0;
  for i=1:ndim
  
     f = polynom(1);
     for j = 2:g1+1
        f = f+polynom(j)*sfunktion(xap(i),Ftyp,j-1);
     end
     
     Res = Res + (yap(i)-f)^2;
  end
  
  Res = sqrt(Res/(ndim-1));
  



  if( PlotFlag ~= 0 )
  
%    xPlot = [xap(1):(xap(ndim)-xap(1))/ndim/10:xap(ndim)]';
    xPlot = [min(xap):(max(xap)-min(xap))/100:max(xap)]';
    pdim = size(xPlot);
    pdim = pdim(1);
    
    for i = 1:pdim
      yPlot(i) = polynom(1);
      for j = 2:g1+1
        
        yPlot(i) = yPlot(i)+polynom(j)*sfunktion(xPlot(i),Ftyp,j-1);
      end
    end
    
    figure(find_free_ifig);
    if( PlotFlag == 2 )Then
       plot(xap,yap,'k-')
       hold on
       plot(xPlot,yPlot,'r-')
       legend('Eingabe','Poly')
    else
       plot(xap,yap,'k*')
       hold on
       plot(xPlot,yPlot)
    end
    grid on

    if Ftyp == 1    
      text1 = 'f(x) = a(1) + a(2) * x       + ... + a(n) * x**(n-1)';
    elseif Ftyp == 2 
      text1 = 'f(x) = a(1) + a(2) * x       + ... + a(n) * x**(1/(n-1))';
    elseif Ftyp == 3 
      text1 = 'f(x) = a(1) + a(2) / x       + ... + a(n) / x**(n-1)';
    elseif Ftyp == 4 
      text1 = 'f(x) = a(1) + a(2) * exp(x)  + ... + a(n) * exp(x**(n-1)) ';
    elseif Ftyp == 5 
      text1 = 'f(x) = a(1) + a(2) * exp(-x) + ... + a(n) * exp(-x**(n-1))';
    elseif Ftyp == 6 
      text1 = 'f(x) = a(1) + a(2) * log(x)  + ... + a(n) * log(x**(n-1))';
    end
    
    xp_min = min(xap);
    xp_min = min(xp_min,min(xPlot));
    xp_max = max(xap);
    xp_max = max(xp_max,max(xPlot));
    yp_min = min(yap);
    yp_min = min(yp_min,min(yPlot));
    yp_max = max(yap);
    yp_max = max(yp_max,max(yPlot));
    
    text(xp_min+(xp_max-xp_min)*0.1,yp_max-(yp_max-yp_min)*0.1,text1)
%    plot({keep,text=text1,text_position=[-0.7,0.8],text_size=10})

    for j = 1:g1+1
    
      text2 = ['a(',num2str(j),') = ',num2str(polynom(j))];
      text(xp_min+(xp_max-xp_min)*0.1,yp_max-(yp_max-yp_min)*0.1*(j+1),text2)
%      plot({keep,text=text2,text_position=[-0.7,0.8-j*0.1],text_size=10})?
    end

    text3 = ['Standardabweichung = ',num2str(Res)];
      text(xp_min+(xp_max-xp_min)*0.1,yp_max-(yp_max-yp_min)*0.1*(j+2),text3)
%    plot({keep,text=text3,text_position=[-0.7,0.8-(g1+2)*0.1],text_size=10})?

    title(str_change_f(PlotTitle,'_',' '))

  end

  polynom = polynom';
  
  if( wieMatlab )
    polynom=umsortieren(polynom);
  end
  
%    Funktion F = sfunktion(x,Ftyp,n)
% 
%      Polynomapproximation mit Ausgleichsrechnung
% 
%      x		x-Wert zu dem F(x) berechnet wird
%      
%      Ftyp	Funktionstyp
%      		= 1	x^n
%      		= 2     x^(1/n)
%      		= 3     1 / x^n
%      		= 4     exp(x^n)
%      		= 5     exp(-x^n)
%      		= 6     ln(x^n)
%      
%      n        Potenz
    
function F = sfunktion(x,Ftyp,n)


  if Ftyp <= 1 
   
      F = x^n;
   
  elseif Ftyp == 2
   
      if abs(n) < 1e-10
         F = 1;
      else
         F = x^(1/n);
      end

  elseif Ftyp == 3

      if abs(x) < 1e-10
        F  = 1e10^n;
      else
        F = 1./x^n;
      end

  elseif Ftyp == 4

      if abs(n) < 1e-10
         F = exp(1);
     else
         F = exp(x^(n));
     end
  elseif Ftyp == 5

      if abs(n) < 1e-10
         F = exp(1);
     else
         F = exp(-x^(n));
     end
 elseif Ftyp >= 6

      if x < 1e-10
        F  = log(1e-10^n);
      else
        F = log(x^n)
      end
  end
        
