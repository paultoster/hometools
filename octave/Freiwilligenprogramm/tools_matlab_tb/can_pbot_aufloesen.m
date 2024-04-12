function [okay,sig] = can_pbot_aufloesen(pbot,bot_name)
%
% [okay,sig] = can_pbot_aufloesen(pbot,bot_name)
% Eine Botschaft der pbot-Struktur wir aufgelöst
%Input:
% pbot          struct      pbot-Struktur
% bot_name      char        Name der Botschaft
%Output:
% sig.time      double      Zeitvektor
% sig.('name')  double      Vektor mit dem NAmen des Signals
%
okay = 1;
for ipbot=1:length(pbot)
    
    if( strcmp(pbot(ipbot).name,bot_name) )
        
        b = pbot(ipbot);
        sig.time = b.time;
        for isig=1:length(b.sig)
            
            sig.(b.sig(isig).name) = b.sig(isig).vec;
        end
    end
end

if( ~exist('sig','var') )
    okay = 0;
    sig  = 0;
end
            