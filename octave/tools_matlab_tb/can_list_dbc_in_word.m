function can_list_dbc_in_word
%
% can_list_dbc_in_word
%
% DBC-Datei wird in Word-File geschrieben
% Word-File gleicher Name wie dbc-File
% dbc-File wird abgefragt

s_frage.file_spec='*.dbc';
s_frage.put_file=0;
s_frage.comment='Welche dbc-Datei soll als Tabelle dargestellt werden?';
s_frage.file_number = 1;

[okay,c_filename] = o_abfragen_files_f(s_frage);

if( okay )

	s_f      = str_get_pfe_f(c_filename{1});

  ctl.dbc_file     = c_filename{1};
	ctl.CAN_name = '';
	ctl.sig_num  = 0;
	ctl.word_file = fullfile(s_f.dir,[s_f.name,'.doc']);
	ctl.word_flag = 1;

	dbc = can_read_dbc(c_filename{1},0);

	can_list_dbc(dbc,ctl);

end