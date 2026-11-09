function tri = contour_netz_bearbeiten_f(s_c)

bearb_flag = 1;
x   = s_c.x;
y   = s_c.y;
tri = s_c.tri;
cont = s_c.cont;

h = contour_netz_bearbeiten_plotten_f(x,y,tri,cont);            


while( bearb_flag )

    choice = '';
    while( length(choice) == 0)
        disp(' 0: Ende')
        disp(' 1: Dreieck wegnehmen, bis Leertaste oder rechte Maustaste')
        disp(' 2: Dreieck hinzufügen, bis Leertaste')
        disp(' 3: neuzeichnen')
        
        choice = input('Aktion ? : ','s');
    end
    choice = floor(str2num(choice));
    choice = max(min(floor(choice),3),0);
    
    switch choice
        case 0
            bearb_flag = 0;
            figure(h)
            close(h)
        case 1
            
            button = 1;
            while( button == 1)
                disp('Wähle einen Punkt aus ')
            
                [xi,yi,button] = ginput(1);
            
                if( button == 1 )
                
                    [ifound,ds] = contour_finde_naechsten_punkt(xi,yi,x,y,1);
                
                    tri0 = finde_dreiecke(tri,ifound);
                    if( length(tri0) > 0 )
                        xs = [];
                        ys = [];
                        for i=1:length(tri0(:,1))
                            xs(i) = (x(tri0(i,1)) + x(tri0(i,2)) + x(tri0(i,3)) )/3; 
                            ys(i) = (y(tri0(i,1)) + y(tri0(i,2)) + y(tri0(i,3)) )/3; 
                            plot(xs(i),ys(i),'oc')                       
                        end
                   
                        disp('Wähle Dreieck (Schwerpunkt) aus')
                        [xi,yi,button] = ginput(1);
                   
                        if( button == 1 )
                            [ifound,ds] = contour_finde_naechsten_punkt(xi,yi,xs,ys,1);
                            index = finde_dreieck_index(tri,tri0(ifound,:));
                            if( index == 0 )
                                error('index == 0');
                            end
                            ntri = length(tri(:,1));
                            if( index == 1 )
                                tri = tri(2:ntri,:);
                            elseif( index == ntri )
                                tri = tri(1:ntri-1,:);
                            else
                                tri = [tri(1:index-1,:);tri(index+1:ntri,:)];
                            end
                            ntri = length(tri(:,1));
                            s_tri.tri = tri;
                        
                            plot(xs,ys,'ow')
                            plot([x(tri0(ifound,1)),x(tri0(ifound,2)),x(tri0(ifound,3)),x(tri0(ifound,1))], ...
                                 [y(tri0(ifound,1)),y(tri0(ifound,2)),y(tri0(ifound,3)),y(tri0(ifound,1))], ...
                                'w-');
                        end
                       
                    end                            
                
                end
            end
        case 2
            
            button = 1;
            while( button == 1 )
                disp('Wähle drei Punkte aus ')
            
                [xi,yi,button] = ginput(3);
            
                if( button == 1 )
             
                    ifound = [];
                    for i=1:3
                
                        [ifound(i),ds] = contour_finde_naechsten_punkt(xi(i),yi(i),x,y,1);
                    end
                
                    tri = [tri;[ifound(1),ifound(2),ifound(3)]];
                    s_tri.tri = tri;
                    plot([x(ifound(1)),x(ifound(2)),x(ifound(3)),x(ifound(1))], ...
                         [y(ifound(1)),y(ifound(2)),y(ifound(3)),y(ifound(1))], ...
                         'g-');
                    xs = (x(ifound(1)) + x(ifound(2)) + x(ifound(3)) )/3; 
                    ys = (y(ifound(1)) + y(ifound(2)) + y(ifound(3)) )/3; 

                    plot(xs,ys,'og')
                end
                contour_triplot_filled_rand_f([ifound(1),ifound(2),ifound(3)],x,y)
            end
        case 3
            close(h)
            h = contour_netz_bearbeiten_plotten_f(x,y,tri,cont);            

    end
    
end

function tri0 = finde_dreiecke(tri,ifound)

tri0 = [];
for i=1:length(tri(:,1))
    for j=1:3
        if( ifound == tri(i,j) )
            tri0 = [tri0;tri(i,:)];
            break;
        end
    end
end
function index = finde_dreieck_index(tri,tri0);

index = 0;
for i= 1:length(tri(:,1))
    found = 0;
    for j= 1:3
        for k=1:3
            if( i == 685 )
                fprintf('tri(%i,%i)= %i == tri0(%i)= %i\n',i,j,tri(i,j),k,tri0(k));
            end
            if( tri(i,j) == tri0(k) )
                found = found + 1;
                break
            end
        end
    end
    if( found >= 3 )
        index = i;
        break;
    end
end

function h = contour_netz_bearbeiten_plotten_f(x,y,tri,cont)         

h = figure;

plot(x,y,'bo'), hold on
title('Gesamtnetz')

contour_triplot_filled_rand_f(tri,x,y)

h = contour_plot_f(cont,h,0,1)
