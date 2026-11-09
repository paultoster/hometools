function build_Ssig_File_from_dbc(dbc_file,Ssig_file_name)
%
% build_Ssig_File_from_dbc(dbc_file,Ssig_file_name)
%
% Erstellt aus dbc-file(s) (cell array) ein m-File, dass Ssig-Struktur
% erzeugt
%
  if(ischar(dbc_file))
    dbc_file = {dbc_file};
  end
  if( ~iscell(dbc_file) )
    errro('dbc_file muss Filename oder cellarray mit FileNamen sein');
  end
  n = length(dbc_file);
  
  [fid,message] = fopen(Ssig_file_name,'w');

  if( fid < 0 )
    error('%s\n',message);
  end

  build_Ssig_File_from_dbc_build_head(fid);
  
  
  % DBC-File einlesen
  %------------------
  for i=1:n
    dbc = can_read_dbc(dbc_file{i},1);
    build_Ssig_File_from_dbc_build_sig(fid,dbc);
  end
  fclose(fid);
end
function build_Ssig_File_from_dbc_build_head(fid)
  fprintf(fid,'function Ssig = HAF_CAN_01_SigList\n');
  fprintf(fid,'  %%\n');
  fprintf(fid,'  %% Design List of signals from Powertrain-Can VW do read from measurement\n');
  fprintf(fid,'  %%\n');
  fprintf(fid,'  %%   Ssig(i).name_in      = ''signal name'';\n');
  fprintf(fid,'  %%   Ssig(i).unit_in      = ''dbc unit'';              (default '''')\n');
  fprintf(fid,'  %%   Ssig(i).lin_in       = 0/1;                     (default 0)\n');
  fprintf(fid,'  %%   Ssig(i).name_sign_in = ''signal name for sign'';  (default '''')\n');
  fprintf(fid,'  %%   Ssig(i).name_out     = ''output signal name'';    (default name_in)\n');
  fprintf(fid,'  %%   Ssig(i).unit_out     = ''output unit'';           (default ''unit_in'')\n');
  fprintf(fid,'  %%   Ssig(i).comment      = ''description'';           (default '''')\n');
  fprintf(fid,'  %%\n');
  fprintf(fid,'  %% name_in      is name from dbc, could also be used with two and mor names\n');
  fprintf(fid,'  %%              in cell array {''nameold'',''namenew''}, if their was an change\n');
  fprintf(fid,'  %%              in dbc, use for old measurements\n');
  fprintf(fid,'  %% unit_in      will used if no unit is in dbc for that input signal\n');
  fprintf(fid,'  %% lin_in       =0/1 linearise if to interpolate to a commen time base\n');
  fprintf(fid,'  %% name_sign_in if in dbc-File is a particular signal for sign (how VW\n');
  fprintf(fid,'  %%              uses) exist\n');
  fprintf(fid,'  %% name_out     output name in Matlab\n');
  fprintf(fid,'  %% unit_out     output unit\n');
  fprintf(fid,'  %% comment      description\n');
  fprintf(fid,'\n');
  fprintf(fid,'    iSig = 0;\n');
  fprintf(fid,'\n');

end
function build_Ssig_File_from_dbc_build_sig(fid,dbc)

  n = length(dbc);
  for i=1:n

    bot = dbc(i);

    m = length(bot.sig);
    if( m > 0 )
      fprintf(fid,'  %%===============================================================================================\n');
      fprintf(fid,'  %% %s\n',bot.name);
      fprintf(fid,'  %%===============================================================================================\n');
    end
    for j=1:m

      fprintf(fid,'  iSig = iSig + 1;\n');
      fprintf(fid,'  Ssig(iSig).name_in      = ''%s'';\n',bot.sig(j).name);
      fprintf(fid,'  Ssig(iSig).unit_in      = ''%s'';\n',bot.sig(j).einheit);
      fprintf(fid,'  Ssig(iSig).lin_in       = 0;\n');
      fprintf(fid,'  Ssig(iSig).name_sign_in = '''';\n');
      fprintf(fid,'  Ssig(iSig).name_out     = ''%s'';\n',bot.sig(j).name);
      fprintf(fid,'  Ssig(iSig).unit_out     = ''%s'';\n',bot.sig(j).einheit);
      fprintf(fid,'  Ssig(iSig).comment      = ''%s'';\n',bot.sig(j).comment);
      fprintf(fid,'  %%-----------------------------------------------------------------------------------------------\n');
    end
  end
end