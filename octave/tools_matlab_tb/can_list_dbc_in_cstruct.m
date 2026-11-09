function can_list_dbc_in_cstruct
%
% can_list_dbc_in_cstruct
%
% Writes dbc in a h-File

s_frage.file_spec='*.dbc';
s_frage.put_file=0;
s_frage.comment='Welche dbc-Datei soll als Tabelle dargestellt werden?';
s_frage.file_number = 1;

[okay,c_filename] = o_abfragen_files_f(s_frage);

if( okay )

	s_f      = str_get_pfe_f(c_filename{1});

  ctl.dbc_file     = c_filename{1};
	ctl.cheader_file = fullfile(s_f.dir,[str_change_f(s_f.name,{'-','+','.'},'_'),'.h']);
	ctl.cheader_flag = 1;

	dbc = can_read_dbc(c_filename{1},0);

	can_list_dbc(dbc,ctl);

end