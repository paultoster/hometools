% convert_template
% Wandelet vorgegeben Signale aus CAN-Messungen, bestimmte Tacc-Messsignale 
% Canalyser und TACC-Messung aus Passat oder BMW in Mat-File 

% Pfad mit contiguard-m-files
addpath('d:\tools\matlab\contiguard');
addpath('d:\tools\matlab\allg');
  
% Basisvaribalen anlegen
clear global SCG
cg_base_variables;
cg_base_set_fzg('BMW545');   % 'BMW545','PASSAT','PASSAT_CC'
  
% Steuerstruktur q anglegen
clear q

q.read_type      = 3;         % = 1  Verzeichnisse müssen ausgewählt werden
                              %      q.start_dir angeben
                              % = 2  übergeordnetes Verzeichnis angeben
                              %      q.read_meas_path angeben
                              % = 3  Liste mit einzulesenden Messverzeichnissen 
                              %      q.read_list = {'dir1',dir2'}oder
                              %      explizite Canalyser-Ascii Dateien in
                              %      q.read_list = {'datei1.asc','datei2.asc'}
                              %      angeben
if( q.read_type == 1)
  q.start_dir        = 'D:\mess\tacc\Contiguard_BMW545_FTZ2222';
elseif( q.read_type == 2 )
  q.read_meas_path = 'W:\NevadaMeas\TACC\2012-02-15\measurment2386'; 
else
  q.read_list = {'D:\mess\tacc\Contiguard_Passat_440\130411_Ffm_Interactive_Fussgaengerdummy\meas103' ...
                ,'D:\mess\tacc\Contiguard_Passat_440\130411_Ffm_Interactive_Fussgaengerdummy\meas105' ...
                };
end

  

%-----------------------------------------------------
% CAN-Messung
%-----------------------------------------------------
q.CANread = 0;       %   0/1 CAN-log files verarbeiten (canlog*.asc bzw. beliebige Namen)

q.CANusePriv = 1;    % Liest VPU-CAN auf channel 1 ein
q.CANuseFzg  = 1;    % Liest FZG-CAN auf channel 2 ein


%-----------------------------------------------------
% TACC-Messung
%-----------------------------------------------------
q.TACCread = 1;      %   0/1 Tacc-Daten mit TacConv lesen aus Verzeichnis TaskData

q.TaccChannels = {'VehicleDynamics','LaneRecognition','RelevantObjectData' ...
                 ,'GpsRawData','GenericObjectList','TargetLane'};

%                       Channels = {'ESA2VehDsrdTraj' ...            % 1
%                                  ,'LaneRecognition' ...            % 2
%                                  ,'VehiclePose' ...                % 3
%                                  ,'VehicleDynamics' ...            % 4
%                                  ,'RelevantObjectData' ...         % 5
%                                  ,'GpsRawData' ...                 % 6
%                                  ,'MFCImage' ...                   % 7
%                                  ,'GenericObjectList' ...          % 8
%                                  ,'TargetLane' ...                 % 9
%                                  };

%-----------------------------------------------------
% Messung modifizieren
%-----------------------------------------------------
% q.mod_dDataFkt = '';


%-----------------------------------------------------
% Read measurement
%-----------------------------------------------------
[okay,d,u,h,e] = cg_convert_meas_data(q);

