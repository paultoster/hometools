clear opt P erg d 

% Parameter, die nicht variiert werden für die Funktion 
global p d
p.delta_t     = 0.001;
p.delta_t_out = 0.01;
p.plot_flag   = 1;
close all


% zu variierende Parameter anlegen
JzSteer = 0.01;
C0      = 10;
D0      = 6.67;
T0      = 0.01;
Sigma   = 16.673333;

% Messdaten zur Simulation
p.messfile_liste  = {'MomentenRampe4NmStand_1.mat' ...
                    ,'MomentenNPulse3NmStand_1.mat' ...
                    ,'MomentenSinus3Nm2sStand_1.mat' ...
                    ,'MomentenSinus3Nm25sStand_1.mat' ...
                    ,'MomentenSinus5Nm1sStand_1.mat' ...
                    ,'MomentenSinus5Nm2sStand_1.mat' ...
                    };
p.nmessfile_liste = length(p.messfile_liste);
% Gewichtung dazu
p.gewichtung = ones(p.nmessfile_liste,1);

[okay,d] = d_data_read_mat(p.messfile_liste{1});
ee = funcLenkmoment([JzSteer;C0;D0;T0;Sigma]);
figmen