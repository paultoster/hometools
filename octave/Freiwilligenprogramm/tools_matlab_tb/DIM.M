
% dim.m  
% Grundeinheiten: in allen(!) Modellen gleich -> startup


disp('dim.m( UN 5.10.93) wird geladen ...' )

clear all
pack

global RAD U
global S MS MIN H
global M CM MM KM
global KG G N BAR
global WATT  LITER 
global V A TESLA OHM HENRY


RAD=1;                          % Radiant
V=1;                            % Volt
S=1;                            % Sekunden

if ~1
        % MKS-System:
        M=1;                            % Meter
        CM=10^(-2)*M;
        KG=1;                           % Kilogramm
        G=KG/1000;                      % Gramm
        N=KG*M/S^2;                     % Newton
        BAR=10^5*N/M^2;                 % Druck 
end;

if ~1 
        % CGS-System:
        CM = 1; 
        M  = 100*CM;
        G  = 1; 
        KG = 1000*G;
        N=KG*M/S^2;                     % Newton
        BAR=10^5*N/M^2;                 % Druck 
end;

if 1
        % CBS-System ( cm bar sec )
        CM  = 1;
        M   = 100*CM;   
        BAR = 1;
        N   = BAR*M^2/10^5;
        KG  = N*S^2/M;
        G   = KG/1000;
end;

WATT=N*M/S;


MM=10^(-3)*M;
KM=1000*M;
LITER=1000*CM^3;

MS = S/1000;
MIN=60*S;
H=60*MIN;


U=2*pi*RAD;                     % Umdrehung


TESLA = V*S/M^2;                % maqgnetische Induktion
A = N*M/V*S;                    % elektrischer Strom
OHM = V/A;                      % ohmscher Widerstand
HENRY = V*S/A;                  % Induktivität
