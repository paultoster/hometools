function [okay,message,copy_flag] = copy_file_if_newer(sfile,tfile,type,ask,add_to_bak)
%
% [okay,message,copy_flag] = copy_file_if_newer(sfile,tfile,type,ask,add_to_bak)
%
% sfile           source-file with path
% tfile           target-file with path
% type            0: copy only if sfile is found (default)
%                 1: error if sfile not their
%                 2: abort with error if sfile is not found
% ask             1: ask for copy if source_file is newer 
% add_to_bak     ''    keine Kopie anlegen
%                 'xyz' Kopie anlegen und Name anhängen
%
% copy_flag       = 1 wurde kopiert
  okay      = 1;
  message   = '';
  copy_flag = 0;
  
  if( ~exist('type','var') )
    type = 0;
  end
  if( ~exist('ask','var') )
    ask = 0;
  end
  if( ~exist('add_to_bak','var') )
    add_to_bak = '';
  end
  
  s_file = str_get_pfe_f(sfile);
  if( isempty(s_file.ext) )
    s_file.ext = '*';
  end
  [file_list,file_list_len] = suche_files_f(s_file.fullfile,s_file.ext,0,1);
  tflag = 0;
  for i=1:file_list_len
   sfile  = file_list(i).full_name;
   s_file = str_get_pfe_f(sfile);
   
   if( tflag || (str_find_f(tfile,'*','vs') > 0) )
     tflag = 1;
     t_file = str_get_pfe_f(tfile);
     tfile  = fullfile(t_file.dir,[s_file.body,'.',s_file.ext]);
   end
    if( strcmp(s_file.name,'*') )
       t_file = str_get_pfe_f(tfile);
       [okay,message,copy_flag] = copy_file_body_stern_if_newer(s_file,t_file,type,ask,add_to_bak);
       return
    elseif( strcmp(s_file.ext,'*') )
       t_file = str_get_pfe_f(tfile);
       [okay,message,copy_flag] = copy_file_ext_stern_if_newer(s_file,t_file,type,ask,add_to_bak);
       return;
    end
    if( ~exist(sfile,'file') )
      if( type == 1 )
        message = sprintf('%s: Source File <%s> was not found',mfilename,sfile);
        okay    = 0;
        return
      elseif( type == 2 )
        error('%s: Source File <%s> was not found',mfilename,sfile);
      else
        return
      end
    else
      if( ~exist(tfile,'file') )
        copy_flag = 1;
      else
        s = dir(sfile);
        t = dir(tfile);

        if( s.datenum > t.datenum )
          if( ask )
            s_file = str_get_pfe_f(sfile);
            clear s_frage
            s_frage.def_value = 'j';
            s_frage.comment   = sprintf('Soll Datei: %s kopiert werden ?',[s_file.name,'.',s_file.ext]);
            flag              = o_abfragen_jn_button_f(s_frage);
            if( flag )
              copy_flag = 1;
            else
              copy_file(tfile,tfile);
            end
          else
            copy_flag = 1;
          end
        end
      end
    end
    if( copy_flag )

      if( strcmpi(get_file_ext(sfile),'mexw32') || strcmpi(get_file_ext(tfile),'mexw32') )
        clear mex
      end
      s_file = str_get_pfe_f(tfile);
      if( ~isempty(s_file.dir) )
        if( ~exist(s_file.dir,'dir') )
          [status, message] = mkdir(s_file.dir);
          if( status <= 0 )
            okay = 0;
            return
          end
        end
      end
      if( exist(tfile,'file') && ~isempty(add_to_bak) )
        copy_file_if_newer_backup(tfile,add_to_bak);
      end
      [status, message] = copyfile(sfile,tfile);
      if( status <= 0 )
        okay = 0;
      else
        message = sprintf('copyfile(%s,%s)',sfile,tfile);
      end
    end
  end
end
function copy_file_if_newer_backup(tfile,add_to_bak)

  s_file = str_get_pfe_f(tfile);
  
  bfile  = fullfile(s_file.dir,[s_file.name,add_to_bak,'.',s_file.ext]);
  
  [status, message] = copyfile(tfile,bfile);
  
end
function [okay,message,copy_flag] = copy_file_ext_stern_if_newer(s_file,t_file,type,ask,add_to_bak)
%
%
  okay      = 1;
  message   = '';
  copy_flag = 0;
    
  sfilename = s_file.name;
  if( ~isempty(s_file.dir) )
    sdirname = s_file.dir;
  else
    sdirname = '';
  end
  tfilename = t_file.name;
  if( ~isempty(t_file.dir) )
    tdirname  = t_file.dir;
  else
    tdirname = '';
  end
  s = dir(s_file.fullfile );
  message = '';
  for i=1:length(s)
    s_file = str_get_pfe_f(s(i).name);
    srcfullfilename = fullfile(sdirname,[sfilename,'.',s_file.ext]);
    tarfullfilename = fullfile(tdirname,[tfilename,'.',s_file.ext]);
    [okay,mess,copy_flag] = copy_file_if_newer(srcfullfilename,tarfullfilename,type,ask,add_to_bak);
    if( ~isempty(mess) )
      if( isempty(message) )
        message = mess;
      else
        message = sprintf('%s\n%s',message,mess);
      end
    end
  end

end
function [okay,message,copy_flag] = copy_file_body_stern_if_newer(s_file,t_file,type,ask,add_to_bak)
%
%
  okay      = 1;
  message   = '';
  copy_flag = 0;
    
  s_files = suche_files_ext(s_file.dir,s_file.ext);
  for( j=1:length(s_files) )
    sfilename = s_files(j).name;
    if( ~isempty(s_files(j).dir) )
      sdirname = s_files(j).dir;
    else
      sdirname = '';
    end
    tfilename = t_file.name;
    if( ~isempty(t_file.dir) )
      tdirname  = t_file.dir;
    else
      tdirname = '';
    end
    s = dir(s_files(j).fullname );
    message = '';
    for i=1:length(s)
      s_file = str_get_pfe_f(s(i).name);
      srcfullfilename = fullfile(sdirname,[sfilename,'.',s_file.ext]);
      tarfullfilename = fullfile(tdirname,[sfilename,'.',s_file.ext]);
      [okay,mess,copy_flag] = copy_file_if_newer(srcfullfilename,tarfullfilename,type,ask,add_to_bak);
      if( ~isempty(mess) )
        if( isempty(message) )
          message = mess;
        else
          message = sprintf('%s\n%s',message,mess);
        end
      end
    end
  end

end