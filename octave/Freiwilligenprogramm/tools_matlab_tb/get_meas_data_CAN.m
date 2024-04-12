function e = get_meas_data_CAN(ascii_file,CANstruct)
%
% ascii_file       Messdatei
% CANstruct        Zusätzliche Signalliste mit dbc-File 
%                    CANstruct(i).dbcFile     dbc-File mit vollständigem Pfad
%                    CANstruct(i).channel     channel in Messung(1,2,3,...=
%                    CANstruct(i).mFile       m-file um Ssig zu erzeugen
%                    CANstruct(i).Ssig        Signalliste mit anstatt
%                                             m-File

  e    = [];
  n_CANstruct = length(CANstruct);
  for i=1:n_CANstruct

    % Ssig erzeugen
    if( ~isfield(CANstruct(i),'Ssig') || isempty(CANstruct(i).Ssig) )
      s_file = str_get_pfe_f(CANstruct(i).mFile);
      if( ~isempty(s_file.dir) )
        org_dir = pwd;
        cd(s_file.dir);
      else
        org_dir = '';
      end
      if( ~exist([s_file.name,'.m'],'file') )
        error('M-File: %s konnte nicht gefunden werden',CANstruct(i).mFile);
      end
      try
        CANstruct(i).Ssig = eval(s_file.name);
        if( ~isempty(org_dir) ),cd(org_dir),end;
      catch exception
        if( ~isempty(org_dir) ),cd(org_dir),end;
        throw(exception)
      end
    end

    ee = can_asc_read_and_filter(ascii_file ...
                                ,CANstruct(i).dbcFile ...
                                ,CANstruct(i).channel ...
                                ,CANstruct(i).Ssig);
    e  = merge_struct_f(e,ee);
  end

end