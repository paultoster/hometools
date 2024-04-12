function okay = reduce_ascii_file_to_nlines(in_file,out_file,nlines)
%
% okay = reduce_ascii_file_to_nlines(in_file,out_file,nlines)
%
% reduziert eine Ascii-Datei auf nlines Ausgabe in ein anders File
  okay = 1;
  if( ~exist('in_file','var') || isempty(in_file))

    s_frage.comment      = 'Ascii-Datei';
    s_frage.file_spec    = '*.*';
     s_frage.file_number = 1;
    [okay,c_filenames] = o_abfragen_files_f(s_frage);
    if( okay )
      in_file = c_filenames{1};
    else
      return;
    end
  end
  if(~exist('out_file','var') || isempty(out_file))
      clear s_frage
      s_frage.comment       = 'Ausgabe Ascii-Datei';
      s_frage.file_spec     = '*.*';
      s_frage.put_file      = 1;
      S                     = str_get_pfe_f(in_file);
      s_frage.put_file_name = [S.name,['_nlines.',S.ext]];
      [okay,c_filenames]    = o_abfragen_files_f(s_frage);
      if( okay )
        out_file = c_filenames{1};
      else
        return;
      end
  end

  if( ~exist('nlines','var') )
    clear s_frage
    s_frage.frage = sprintf('Auf wieviele Zeilen kürzen');
    [okay,value] = o_abfragen_wert_f(s_frage);
    if( okay )
      nlines = value;
    else
      retun;
    end
  end
  
  c_lines = {};
  nzeilen = 0;
  [fid,message] = fopen(in_file,'r');

  if( fid < 0 )
    fprintf('%s\n',message);
    okay = 0;
    return
  end
  
  [fidout,message] = fopen(out_file,'w');

  if( fidout < 0 )
    fprintf('%s\n',message);
    okay = 0;
    return
  end
  
  while 1
      tline = fgetl(fid);
      % Abbrechnen wenn Ende
      if( ~ischar(tline) )
          break
      else
        nzeilen = nzeilen + 1;
      end
      
      if( nzeilen < nlines )
        fprintf(fidout,'%s\r\n',tline);
      else
        break;
      end
        

  end
  
  fclose(fid);
  fclose(fidout);

end