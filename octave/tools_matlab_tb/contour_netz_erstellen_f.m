function [tri] = contour_netz_erstellen_f(istart1,x1,y1,istart2,x2,y2,plot_flag)

if( ~exist('plot_flag','var') )
    plot_flag = 0;
end
tri = [];
n1 = length(x1);
n2 = length(x2);
i1 = 1;
i2 = 1;
iold = 1;

offset1 = istart1-1;
offset2 = istart2-1;

goon = 1;

% x und y skalieren
l_x = max([x1;x2])-min([x1;x2]);
l_y = max([y1;y2])-min([y1;y2]);
if( l_y > 1e-8 & l_x > 1e-8 )
    if( l_x < l_y )

        y1 = y1/l_y*l_x;
        y2 = y2/l_y*l_x;
    elseif( l_y < l_x  )
        x1 = x1/l_x*l_y;
        x2 = x2/l_x*l_y;
    end
end
if( plot_flag )
    x = [x1;x2];
    y = [y1;y2];
    
    h = figure;
    plot(x1,y1,'k-o')
    hold on
    plot(x2,y2,'b-o')
    for j=1:length(x)
       text(x(j),y(j),[' ' int2str(j)],'era','back');
    end
    
    
end

while( goon )
    
    if( i1 == n1 & i2 == n2 )        
        % keinen weiteren Dreiecke da
        goon = 0;
    elseif( i1 == n1 )
        % von x1,y1 Endpunkt erreicht
        if( keine_kreuzung_vorhanden(i1,i2,x1,y1,x2,y2) ...
          & keine_kreuzung_vorhanden(i1,i2+1,x1,y1,x2,y2) ...
          )
            tri = [tri;i1+offset1,i2+offset2,i2+1+offset2];
            if( plot_flag )
                contour_triplot_filled_rand_f([i1,i2+n1,i2+1+n1],x,y);
            end
        end
        
        i2 = i2 + 1;
    elseif( i2 == n2 )
        
        % von x2,y2 Endpunkt erreicht
        if( keine_kreuzung_vorhanden(i1,i2,x1,y1,x2,y2) ...
          & keine_kreuzung_vorhanden(i1+1,i2,x1,y1,x2,y2) ...
          )
            tri = [tri;i2+offset2,i1+offset1,i1+1+offset1];
            if( plot_flag )
                contour_triplot_filled_rand_f([i2+n1,i1,i1+1],x,y);
            end
        end
        
        i1 = i1 + 1;
    else
        %noch jedemenge Dreiecke
        
        % Richtung der Höhenlinien bilden
        e1x = x1(i1+1) - x1(i1);
        e1y = y1(i1+1) - y1(i1);
        l1  = sqrt(e1x^2 + e1y^2);
        
        if( l1 < 1e-8 ) % Punkte i1 und i1+1 liegen aufeinander, einfach weiterzählen
            
            i1 = i1 + 1;
        else
            e1x = e1x / l1;
            e1y = e1y / l1;

            e2x = x2(i2+1) - x2(i2);
            e2y = y2(i2+1) - y2(i2);
            l2  = sqrt(e2x^2 + e2y^2);

            if( l2 < 1e-8 ) % Punkte i2 und i2+1 liegen aufeinander, einfach weiterzählen
            
                i2 = i2 + 1;
            else
                
                e2x = e2x / l2;
                e2y = e2y / l2;
        
                % Mittelwert der beiden einheitsvektoren
                bx = e1x + e2x;
                by = e1y + e2y;
                
                % Richtung zwischen den zwei Punkte
                
                dx = x2(i2) - x1(i1);
                dy = y2(i2) - y1(i1);
                ld =  sqrt(dx^2+dy^2);
                if( ld > 1e-8 )
                    dx = dx / ld;
                    dy = dy / ld;
                end
                
                % Punktprodukt
                p = bx * dx + by * dy;
                
                % Wenn p > 0, dann liegt i1 hinten weit hinten
                if( p >= 0.5 )
                    
                    if( keine_kreuzung_vorhanden(i1,i2,x1,y1,x2,y2) ...
                      & keine_kreuzung_vorhanden(i1+1,i2,x1,y1,x2,y2) ...
                      )
                        tri  = [tri;i2+offset2,i1+offset1,i1+1+offset1];
                        iold = 1; % Dreick eine Länge auf i1
                        if( plot_flag )
                            contour_triplot_filled_rand_f([i2+n1,i1,i1+1],x,y);
                        end
                    end
                    i1  = i1+1;
                elseif( p <= -0.5 ) % i2 liegt weit hinten
                    if( keine_kreuzung_vorhanden(i1,i2,x1,y1,x2,y2) ...
                      & keine_kreuzung_vorhanden(i1,i2+1,x1,y1,x2,y2) ...
                      )
                        tri  = [tri;i1+offset1,i2+offset2,i2+1+offset2];
                        iold = 2; % Dreick eine Länge auf i2
                        if( plot_flag )
                            contour_triplot_filled_rand_f([i1,i2+n1,i2+1+n1],x,y);
                        end
                    end
                    i2  = i2+1;
                elseif( iold == 1 ) % letztes Dreick mit einer Länge auf i1
                    if( keine_kreuzung_vorhanden(i1,i2,x1,y1,x2,y2) ...
                      & keine_kreuzung_vorhanden(i1,i2+1,x1,y1,x2,y2) ...
                      )
                        tri  = [tri;i1+offset1,i2+offset2,i2+1+offset2];
                        if( plot_flag )
                            contour_triplot_filled_rand_f([i1,i2+n1,i2+1+n1],x,y);
                        end
                        iold = 2; % Dreick eine Länge auf i2
                        i2  = i2+1;
                    else
                        if( keine_kreuzung_vorhanden(i1,i2,x1,y1,x2,y2) ...
                          & keine_kreuzung_vorhanden(i1+1,i2,x1,y1,x2,y2) ...
                          )
                            tri  = [tri;i2+offset2,i1+offset1,i1+1+offset1];
                            if( plot_flag )
                                contour_triplot_filled_rand_f([i2+n1,i1,i1+1],x,y);
                            end
                            iold = 1; % Dreick eine Länge auf i1
                            i1  = i1+1;
                        else
                            i2   = i2+1;
                            iold = 2; 
                        end
                        
                    end
                else                    
                    if( keine_kreuzung_vorhanden(i1,i2,x1,y1,x2,y2) ...
                      & keine_kreuzung_vorhanden(i1+1,i2,x1,y1,x2,y2) ...
                      )
                        tri  = [tri;i2+offset2,i1+offset1,i1+1+offset1];
                        if( plot_flag )
                            contour_triplot_filled_rand_f([i2+n1,i1,i1+1],x,y);
                        end
                        iold = 1; % Dreick eine Länge auf i1
                        i1  = i1+1;
                    else
                        if( keine_kreuzung_vorhanden(i1,i2,x1,y1,x2,y2) ...
                          & keine_kreuzung_vorhanden(i1,i2+1,x1,y1,x2,y2) ...
                          )
                            tri  = [tri;i1+offset1,i2+offset2,i2+1+offset2];
                            if( plot_flag )
                                contour_triplot_filled_rand_f([i1,i2+n1,i2+1+n1],x,y);
                            end
                            iold = 2; % Dreick eine Länge auf i2
                            i2  = i2+1;
                        else
                            i1   = i1+1;
                            iold = 1; 
                        end
                    end
                end
            end
        end
    end
     if( plot_flag )
         input('pause');
         figure(h);
     end
end
if( plot_flag )
    close(h);
end


function flag = keine_kreuzung_vorhanden(i1,i2,x1,y1,x2,y2)

    flag = 1; % keine Kruzungspunkt zwischen (xa/ya-xb/yb) und den Geradenstücke
    
    xa = x1(i1);
    ya = y1(i1);
    xb = x2(i2);
    yb = y2(i2);
    
    for i=1:2
        
        if( i == 1 )
            x  = x1;
            y  = y1;
            iz = i1;
        else
            x  = x2;
            y  = y2;
            iz = i2;
        end

        for j = 1:length(x)-1
             
            if( j ~= iz & (j+1) ~= iz )
                
                 if( geraden_kreuzen(xa,ya,xb,yb,x(j),y(j),x(j+1),y(j+1)) )
                     
                     flag = 0;
                     return
                 end
            end
        end
    end
    
function flag_kreuz = geraden_kreuzen(xa,ya,xb,yb,xc,yc,xd,yd)

    flag_kreuz = 0; %Kreuzungspunkt, wenn 1
    
    % Wenn zwei Punkte der unterschiedlichen Geraden übereinanderliegen,
    % dann gibt es keinen Schnittpunkt

    delta = sqrt( (xa-xc)^2 + (ya-yc)^2 );
    if( delta < 1e-16 )
        return
    end

    delta = sqrt( (xb-xc)^2 + (yb-yc)^2 );
    if( delta < 1e-16 )
        return
    end

    delta = sqrt( (xa-xd)^2 + (ya-yd)^2 );
    if( delta < 1e-16 )
        return
    end

    delta = sqrt( (xb-xd)^2 + (yb-yd)^2 );
    if( delta < 1e-16 )
        return
    end

    dxba = xb-xa;
    dyba = yb-ya;
    dxdc = xd-xc;
    dydc = yd-yc;
    
    % schnittpunkt
    nenn = dyba*dxdc-dydc*dxba;
    
    if( abs(nenn) < 1e-8 ) % kein schnittpunkt möglich
        return
    end
    xe = ((yc-ya)*dxba*dxdc+xa*dyba*dxdc-xc*dydc*dxba)/nenn;
    
    nenn = dxba*dydc-dxdc*dyba;
    
    if( abs(nenn) < 1e-8 ) % kein schnittpunkt möglich
        return
    end
    ye = ((xc-xa)*dyba*dydc+ya*dxba*dydc-yc*dxdc*dyba)/nenn;
    
    dxea = xe-xa;
    dyea = ye-ya;

    dxec = xe-xc;
    dyec = ye-yc;

    % Bedingung für Schnittpunkt
    
    paeb = dxba*dxea+dyba*dyea;
    lab  = sqrt(dxba^2+dyba^2);
    lae  = sqrt(dxea^2+dyea^2);
    pced = dxdc*dxec+dydc*dyec;
    lcd  = sqrt(dxdc^2+dydc^2);
    lce  = sqrt(dxec^2+dyec^2);
    
    if( paeb >= 0 & lae < lab & pced >= 0 & lce < lcd ) % Schnittpunkt gefunden
        flag_kreuz = 1;
        
    end

    
%     if( flag_kreuz )
%         % Plottet nur wenn Kreuzung da ist
%         h = figure
%         plot([xa,xb],[ya,yb],'r-')
%         hold on
%         plot([xc,xd],[yc,yd],'m-')
%         plot(xe,ye,'ro')
%         grid
%         input('pause')
%         close(h)
%     end


    % h = figure
%     
% plot(x,y,'ko')
% hold on 
% plot(x1,y1,'r-')
% plot(x2,y2,'g-')
% 
% 
% button = 1;
% count  = 0;
% tri = [];
% ivec  = [];
% while button == 1
%     [xs,ys,button] = ginput(1);
%     if( button == 1 )
%         count = count + 1;
%         [ifound,ds] = finde_naechsten_punkt(xs,ys,x,y,1);
%         ivec(count) = ifound;
%         
%         if( count == 3 )
%             
%             tri = [tri;ivec(1),ivec(2),ivec(3)];
%             plot([x(ivec(1)),x(ivec(2)),x(ivec(3)),x(ivec(1))],[y(ivec(1)),y(ivec(2)),y(ivec(3)),y(ivec(1))])
%             
%             count = 0;
%             ivec = [];
%             
%         end
%     end
% end
% 
% function    [ifound,dsmin] = finde_naechsten_punkt(x0,y0,x,y,isearch)
% 
% % Finde in x(),y() den den isearch-ten Punkt zu x0,y0
% % d.h. isearch = 1 nächster Punkt
% %              = 2 zweit nächster Punkt etc.
% 
% ifound = 0;
% n = length(x);
% if( isearch > n )
%     return
% end
% 
% ds = [];
% 
% for i=1:n    
%     ds(i) = sqrt( (x0-x(i))^2 + (y0-y(i))^2 );
% end
% 
% [X,I] = sort(ds);
% 
% ifound = I(max(isearch,1));
% dsmin  = X(max(isearch,1));
% return
