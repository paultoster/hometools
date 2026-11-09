function y = poly_multiplaction(a,x,plot_flag)
%
% y = poly_multiplaction(a,x,plot_flag)
%
% Berechnet das Polynom mit x
%
% a = [a0,a1, ... ,an-1,an]
% y = an*x^n + an-1*x^(n-1) + ... + a0
%
% wenn plot_flag, dann einfaches Plot dazu
if( ~exist('plot_flag','var') )
    plot_flag = 0;
end

n = length(a);
y = x * 0.0;
if( n == 1 )
    y = y + a(1);
elseif( n > 1 )
    
    for i = 1:length(x)
        
        y(i) = a(n)*x(i)+a(n-1);
        for j=n-2:-1:1
            
            y(i) = y(i)*x(i)+ a(j);
        end
    end
end

if( plot_flag )
    
    figure
    plot(x,y)
    grid
    
    
    text1 = 'f(x) = a(1) + a(2) * x       + ... + a(n) * x**(n-1)';
    xPlot = [min(x):(max(x)-min(x))/100:max(x)]';
    pdim = size(xPlot);
    pdim = pdim(1);
    
    for i = 1:pdim
      yPlot(i) = a(1);
      for j = 2:length(a)
        
        yPlot(i) = yPlot(i)+a(j)*x^(j-1);
      end
    end
    
    xp_min = min(x);
    xp_min = min(xp_min,min(xPlot));
    xp_max = max(x);
    xp_max = max(xp_max,max(xPlot));
    yp_min = min(y);
    yp_min = min(yp_min,min(yPlot));
    yp_max = max(y);
    yp_max = max(yp_max,max(yPlot));
    
    text(xp_min+(xp_max-xp_min)*0.1,yp_max-(yp_max-yp_min)*0.1,text1)

    for j = 1:length(a)
    
      text2 = ['a(',num2str(j),') = ',num2str(a(j))];
      text(xp_min+(xp_max-xp_min)*0.1,yp_max-(yp_max-yp_min)*0.1*(j+1),text2)
%      plot({keep,text=text2,text_position=[-0.7,0.8-j*0.1],text_size=10})?
    end
    
end

    
    
