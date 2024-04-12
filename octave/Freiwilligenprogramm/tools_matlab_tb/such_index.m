function index=such_index(t,t0)

% function index=such_index(t,t0)
% Sucht naechgsten index im Array t für deb Wert t0

index = suche_index(t,t0,'====');
   
% if( is_monoton_steigend(t) )
%     u=[1:1:length(t)];
%     [m,n]=size(t);
% 
%     if( m >= 1 && n == 1)
%        u=u';
%     end
%     if( t0 < t(1) )
% 
%         index = 1;
%     elseif( t0 > t(length(t)) )
%         index = length(t);
%     else
% 
%         index = interp1(t,u,t0,'nearest');
%     end
% else
%     index = [];
%     delta  = max(t)-min(t)+100;
%     for i = 1:length(t)
%         if( abs(t(i)-t0) < delta )
%             index = i;
%             delta  = abs(t(i)-t0);
%         end
%     end
% end
%     

