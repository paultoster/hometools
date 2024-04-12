% convert_template
% Wandelet vorgegeben Signale aus CAN-Messungen, bestimmte Tacc-Messsignale 
% Canalyser und TACC-Messung aus Passat oder BMW in Mat-File 

% Pfad mit contiguard-m-files
    
% Steuerstruktur q anglegen
clear q

q.read_type      = 1;         % = 1  Verzeichnisse m�ssen ausgew�hlt werden
                              %      q.start_dir angeben
                              % = 2  �bergeordnetes Verzeichnis angeben
                              %      q.read_meas_path angeben
                              % = 3  Liste mit einzulesenden Messverzeichnissen 
                              %      q.read_list = {'dir1',dir2'}oder
                              %      explizite Canalyser-Ascii Dateien in
                              %      q.read_list = {'datei1.asc','datei2.asc'}
                              %      angeben
if( q.read_type == 1)
  % q.start_dir        = 'D:\mess\tacc\Contiguard_BMW545_FTZ2222';
elseif( q.read_type == 2 )
  % q.read_meas_path = 'W:\NevadaMeas\TACC\2012-02-15\measurment2386'; 
else
  % q.read_list = {'D:\mess\tacc\Contiguard_Passat_440\130411_Ffm_Interactive_Fussgaengerdummy\meas103' ...
  %              ,'D:\mess\tacc\Contiguard_Passat_440\130411_Ffm_Interactive_Fussgaengerdummy\meas105' ...
  %              };
end

  %-----------------------------------------------------
  % ECAL-Messung
  %-----------------------------------------------------
  q.ECALread         = 1;
  q.ECALChannels     = {'VehicleDynamicsInPb' ...
                       ,'VehiclePosePb' ...        
                       ,'PowerTrainInPb' ...
					             ,'CarSwitchesInPb' ...
                       };					   
  


%-----------------------------------------------------
% Messung modifizieren
%-----------------------------------------------------
% q.mod_dDataFkt = '';

  %-----------------------------------------------------
  % Messung modifizieren
  %-----------------------------------------------------
  % q.mod_dDataFkt = fullfile(pwd,'modify_wand_meas_data_Passat990_d');
  q.mod_eDataFkt = {fullfile(pwd,'modify_convert_ecal_template_e')};

  %-----------------------------------------------------
  % Time_out f�r nicht st�ndig kommenede Signale
  %-----------------------------------------------------
  q.timeout = 0.1;
  %-----------------------------------------------------
  % time limts start and end
  %-----------------------------------------------------
  q.tstart  = -1;
  q.tend    = -1;

  %-----------------------------------------------------
  % find and cut limits in e-data
  %-----------------------------------------------------
  q.find_limit_by_plot = 0;
  q.find_limit_sig_name = {'AD2PDev2PthRequest_yawAngleDeviationPsi'};
  
  %-----------------------------------------------------
  % trigger d-data by a signal and cut
  %-----------------------------------------------------
  q.trigger_measure          = 0;         % Messung wird auf einen Wert getriggert und ge�ndert
  q.trigger_signal_name      = 'PrivCAN_Gear';    % z.B. d.TStWhlSens wird verwendet
  q.trigger_vorschrift       = '<';       % siehe suche_index()
	                                        % '>='          Wenn Signal gr��er gleich wird(default)
                                          % '>','<','<='  gr��er/kleiner/kleiner gleich
                                          % '=='          gleich innerhalb der Toleranz
                                          % '==='         n�chster Index, es wird der Index mit einem Rest bestimmt z.B index=10.3)
                                          % '===='        (Index mit dem n�chsten Wert)
                                          % '>>'          vektor wird von kleiner zu gr��er als Wert
                                          % '<<'          vektor wird gr��er zu kleiner als Wert
  q.trigger_schwelle         = 5.0;       % Schwelle
  q.trigger_vorlauf_zeit     = 0.0;       % Vorlaufzeit zum abschneiden

  q.cut_measurement_by_time = 0;          % Soll die Messung zeitlich zerlegt in Dateien abgelegt werden
  q.cut_measurement_time    = 50;        % delta_t dazu

  q.calc_offset_tacc_can  = 1;           % 1: merged can mit tacc mit Fahrzeuggeschw, insbesondere wenn 
                                         %    unterschiedliche L�ngen vorhanden sind
                                         % 2: merged can mit tacc mit Lenkradwinkel, insbesondere wenn 
                                         %    unterschiedliche L�ngen vorhanden sind
  q.save_type = 'no';                    % 'no':       keine duh-Daten wandeln    
                                         % 'mat_duh':  duh-Wandlung
                                         % durchf�hren
  q.write_signal_description = 0;        % write a signal description                                         
  %-----------------------------------------------------
  % Read measurement
  %-----------------------------------------------------
  [okay,d,u,h,e,meas_dir] = cg_convert_meas_data(q);

  if( ~isempty(meas_dir) )
    qlast_set(1,meas_dir);
  end


