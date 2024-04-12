function q = iqf_plot_ergaenze_q(q,d)
%
% q = iqf_plot_ergaenze_q(q)
% Zu erg�nzen
% q.plot_in_one = 0     Soll in ein bild geplottet werden
% q.n_data          AAnzahl Datens�tze
% q.file_list       Cellarray mit Filename
% q.fig_num         letzte Plotfigurnummer
% q.dina4           Ausrichtung
% q.set_zaf         Zoomen erm�glichen    
% q.line_size       Linienst�rke
% q.line_size_1       Linienst�rke
% q.line_size_2       Linienst�rke
% q.x_sig_name      Name des x-Signals

if( ~isfield(q,'plot_in_one') )
  q.plot_in_one = 0;
end

if( ~isfield(q,'n_data') )
  q.n_data = length(d);
end

if( ~isfield(q,'file_list') )
  for i=1:q.n_data
    q.file_list{i} = '' ;
  end
end

if( ~isfield(q,'fig_num') )
  q.fig_num = 0;
end

if( ~isfield(q,'dina4') )
  q.dina4 = 1;
end

if( ~isfield(q,'set_zaf') )
  q.set_zaf = 1;
end

if( ~isfield(q,'line_size') )
  q.line_size = 1;
end

if( ~isfield(q,'line_size_1') )
  q.line_size_1 = 2;
end

if( ~isfield(q,'line_size_2') )
  q.line_size_2 = 3;
end

if( ~isfield(q,'x_sig_name') )
  q.x_sig_name  = 'time';
  q.x_unit_name = 's';
end
if( ~isfield(q,'x_unit_name') )
  error('q.x_unit_name ist nicht definiert Einheit zu q.x_sig_name')
end

if( ~isfield(q,'plot_move_pos') )
  q.plot_move_pos = 0;
end
if( ~isfield(q,'Pindex') )
  q.Pindex = [];
end


end

