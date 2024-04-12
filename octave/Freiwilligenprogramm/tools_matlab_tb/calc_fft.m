function [f,amp,phas] = calc_fft(x,y,varargin)
%
% [f,amp,phas] = calc_fft(x,y,['sampletime',T,('T',T),'plot',plot_flag])
%
% x     Zeitvektor
% y     Signal
% T     minimale Samplezeit, die betrachtet wird (default: x(2)-x(1)


% Monotoie
if( ~is_monoton_steigend(x) )
    error('x-Vektor ist nicht monoton steigend')
end

T0 = x(2)-x(1);

T         = T0;
plot_flag = 0;

i = 1;
while( i+1 <= length(varargin) )

    switch lower(varargin{i})
        case {'sampletime','T'}
            T = varargin{i+1};
            if( ~isnumeric(T) )
                error('%s: Wert für Attribut <%s>  ist nicht numerich',mfilename,varargin{i})
            end        
        case 'plot'
            plot_flag   = varargin{i+1};
            if( ~isnumeric(plot_flag) )
                error('%s: Wert für Attribut <%s>  ist nicht numerich',mfilename,varargin{i})
            end        

    end
    i = i+2;
end


x1 = [x(1):T:x(length(x))]';
n  = length(x1);
y1 = interp1(x,y,x1,'linear','extrap');

Fs   = 1/T;
NFFT = 2^nextpow2(n); % Next power of 2 from length of y
yfft = fft(y,NFFT)/n;
f    = Fs/2*linspace(0,1,NFFT/2);

amp  = 2*abs(yfft(1:NFFT/2));
phas = atan2(real(yfft(1:NFFT/2)),imag(yfft(1:NFFT/2)));


if( plot_flag )
    
    figure
    subplot(3,1,1)
    if( T==T0 )
        plot(x,y)
        grid on
    else
        plot(x,y,'k-')
        plot(x1,y1,'r-')
        grid on
        legend('T0','T')
    end
    xlabel('x [s]')
    ylabel('y')
    
    subplot(3,1,2)
    
    plot(f,amp)
    grid on
    xlabel(' f [Hz]')
    ylabel('amp')
    
    subplot(3,1,3)

    plot(f,phas/pi*180)
    grid on
    xlabel(' f [Hz]')
    ylabel('phas [deg]')
end



