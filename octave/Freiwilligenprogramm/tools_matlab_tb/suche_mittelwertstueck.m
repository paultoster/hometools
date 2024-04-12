function [i_start,i_end,ymit] = suche_mittelwertstueck(x_vec,y_vec,delta_x,delta_y,plot_flag)

if( ~exist('plot_flag','var') )
    plot_flag = 0;
end

i_start = [];
i_end = [];
ymit  = [];
n = length(x_vec);

% Anzahl der zu mittelnden Punkte
nmit = max(suche_index(x_vec-x_vec(1),delta_x)-1,1);

% unterabtasten
x1 = x_vec(1:nmit:length(x_vec));
y1 = y_vec(1:nmit:length(y_vec));
n1 = length(x1);

ydiff = differenziere(x1,y1,1);

yd = delta_y/2/(x1(2)-x1(1));

% ymit = calc_mittelwert(y_vec,'g',nmit);
% 
% y_vec_u = umsortieren(y_vec);
% x_vec_u = umsortieren(x_vec(n)-x_vec);
% ymit_u  = calc_mittelwert(y_vec_u,'g',nmit);
% ymit_u = umsortieren(ymit_u);

M      = 0;
ISTART = 0;
IEND   = 0;

for i=1:n1
    
    flag = 0;
    m    = 0;
    for j=i:n1
        
        if( ~flag && abs(ydiff(j)) < yd )
            
            flag = 1;
            m    = m + 1;
            istart = j;
        elseif(flag && abs(ydiff(j)) < yd )
            m    = m+1;
        elseif(flag)
            flag = 0;
            if( m > M )
                ISTART = istart;
                IEND   = j;
                M      = m;
            end
        end
    end
end

if( M > 0 && plot_flag)
    
    i_start = (ISTART-1)*nmit+1;
    i_end   = (IEND-1)*nmit+1;
    
    ymit    = mean(y_vec(i_start:i_end));
    
    figure

    subplot(2,1,1)
    
    plot(x1(ISTART:IEND),ydiff(ISTART:IEND),'k-')
    hold on
    plot(x1,ydiff,'k--')
    plot(x1(ISTART:IEND),ydiff(ISTART:IEND)*0.0+yd,'r--')
    plot(x1(ISTART:IEND),ydiff(ISTART:IEND)*0.0-yd,'r--')
    title('Unterabgetastete Ableitung')
    grid on
    subplot(2,1,2)
    
    plot(x_vec(i_start:i_end),y_vec(i_start:i_end),'k-')
    hold on
    plot(x_vec,y_vec,'k--')
    plot(x_vec(i_start:i_end),y_vec(i_start:i_end)*0.0+ymit,'r-')
    plot(x_vec(i_start:i_end),y_vec(i_start:i_end)*0.0+ymit+delta_y/2,'r--')
    plot(x_vec(i_start:i_end),y_vec(i_start:i_end)*0.0+ymit-delta_y/2,'r--')
    grid on
    title('Signal')

end