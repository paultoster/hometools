function can_list_dbc_in_siglist
%
% can_list_dbc_in_xls
%
% DBC-Datei wird in excel-File geschrieben
% excel-File gleicher Name wie dbc-File
% dbc-File wird abgefragt

s_frage.file_spec='*.dbc';
s_frage.put_file=0;
s_frage.comment='Welche dbc-Datei soll als SigList dargestellt werden?';
s_frage.file_number = 1;

[okay,c_filename] = o_abfragen_files_f(s_frage);

if( okay )

	s_f      = str_get_pfe_f(c_filename{1});

  ctl.dbc_file     = c_filename{1};
  
	ctl.siglist_file = fullfile(s_f.dir,[str_change_f(s_f.name,{' ','-','+','.'},'_'),'.m']);
	ctl.siglist_flag = 1;
  
  
  s_frage.frage   = 'Soll Botschaftsname+Signalname in der ausgabe verwendet werden (0/1)';
  s_frage.type    = 'num';
  s_frage.default = 0;
  [okay,value] = o_abfragen_wert_f(s_frage);

  ctl.siglist_pre_message_name = value;

  s_frage.frage   = 'Pre-Namensteil, der bei jedem Signal vorangestellt wird';
  s_frage.type    = 'char';
  s_frage.default = '';
  [okay,value] = o_abfragen_wert_f(s_frage);
  
  ctl.siglist_pre_outname = value;

  dbc = can_read_dbc(c_filename{1},0);

	can_list_dbc(dbc,ctl);

end