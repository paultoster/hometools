function vc_mex_m_file = VC9_build_vc_mex(proj_name,vc_proj_file,outdir,configname)
%
% vc_mex_m_file = VC9_buid_vc_mex(outdir,vc_proj_file,configname)
%
% Bildet batch-File und dazugehöriges m-File, umd Solution zu bilden
% (compile und link)
%
% proj_name           Projekt-Name
% vc_proj_file        Filename inklusive Verzeichnis von VC Projekt
% outdir              Output-Dir in der die beiden Files kopiert werden
% configname          Konfigurationsname meist 'debug' oder 'release'
%
% vc_mex_m_file       m-filename inklusive Verzeichnis um Bilden (compile und link) auszuführen
%                     ['buildVcMex',proj_name,'.m'] 
%
  vcvarsall_file = 'C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\vcvarsall.bat';
  % devenv_file    = 'C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\IDE\VCExpress.exe';
  devenv_file    = 'C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\IDE\devenv.exe';
  

  if( ~exist(outdir,'dir') )
    error('%s: outdir: <%s> not found',mfilename,outdir);
  end
  if( ~exist(vc_proj_file,'file') )
    error('%s: vc_proj_file: <%s> not found',mfilename,vc_proj_file);
  end
  if( ~exist(vcvarsall_file,'file') )
    error('%s: vcvarsall_file: <%s> not found, has to be defined in \n<%s>',mfilename,vcvarsall_file, mfilename('fullpath'));
  end
  if( ~exist(devenv_file,'file') )
    error('%s: devenv_file: <%s> not found, has to be defined in \n<%s>',mfilename,devenv_file, mfilename('fullpath'));
  end
  
  vc_mex_m_file   = fullfile(outdir,['buildVcMex',proj_name,'.m']);
  vc_mex_bat_file = fullfile(outdir,['buildVcMex',proj_name,'.bat']);
  vc_log_file     = change_file_ext(vc_proj_file,'log',1);
  
  
  % bat-File
  %=========
  c = {};
  c = cell_add(c,sprintf('call "%s" x86',vcvarsall_file));
  c = cell_add(c,sprintf('"%s" "%s" /build %s /out %s',devenv_file,vc_proj_file,configname,vc_log_file));
  okay = write_ascii_file(vc_mex_bat_file,c);
  if( ~okay )
    error('%s: Fehler bei Schreiben von vc_mex_bat_file: <%s>',mfilename,vc_mex_bat_file);
  end

  % m-File
  %=========
  c = {};
  c = cell_add(c,sprintf('if( exist(''%s'',''file'') )',vc_log_file));
  c = cell_add(c,sprintf('  delete ''%s''',vc_log_file));
  c = cell_add(c,sprintf('end'));
  c = cell_add(c,sprintf('command = ''"%s"'';',vc_mex_bat_file));
  c = cell_add(c,sprintf('fprintf(''[status,result] = dos(%%s);\\n'',command)'));
  c = cell_add(c,sprintf('[status,result] = dos(command);'));
  c = cell_add(c,sprintf('fprintf(''status = %%i \\n'',status)'));
  c = cell_add(c,sprintf('fprintf(''result = %%s \\n'',result)'));
  c = cell_add(c,sprintf('if( exist(''%s'',''file'') )',vc_log_file));
  c = cell_add(c,sprintf('  type ''%s''',vc_log_file));
  c = cell_add(c,sprintf('end'));
  okay = write_ascii_file(vc_mex_m_file,c);
  if( ~okay )
    error('%s: Fehler bei Schreiben von vc_mex_m_file: <%s>',mfilename,vc_mex_m_file);
  end
  

end