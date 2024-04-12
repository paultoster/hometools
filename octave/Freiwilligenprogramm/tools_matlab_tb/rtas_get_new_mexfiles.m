function rtas_get_new_mexfiles(rtasname,modpath,tpath)
%
% rtas_get_new_mexfiles(rtasname,moddir,tdir)
%
% Schaut nach, ob neue Files generiert wurden
% rtasnamen       Funktionsname
% moddir          Modelverzeichnis 'D:\rtas\mod'
% tdir            Zielverzeichnis
%
  spath = fullfile(modpath,rtasname,'bin\mex\debug');

  filename{1} = [rtasname,'.inp'];
  filename{2} = [rtasname,'.out'];
  filename{3} = [rtasname,'.pdf'];
  filename{4}   = [rtasname,'.m'];
  filename{5} = ['mex_',rtasname,'.mexw32'];

  clear mex
  for i=1:5
    
    sfile = fullfile(spath,filename{i});
    tfile = fullfile(tpath,filename{i});
    [okay,message] = copy_file_if_newer(sfile,tfile,0);
    if( ~okay )
      fprintf('copy_file_if_newer(%s,%s,0);\n',sfile,tfile);
      error(message);
    else
      fprintf('%s\n',message);
    end
  end
end   