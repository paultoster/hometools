function [c,errtext] = read_from_cancmd(cancmd_file,varargin)
%
% [c,errtext] = read_script_buttom_from cancmd(cancmd_file,'ScriptBtn',script_text_names)
%
  if( ~exist(cancmd_file,'file') )
    error('Error_%s: Datei <%s> nicht gefunden',mfilename,cancmd_file);
  end
  script_text_names  = {};
  i = 1;
  while( i+1 <= length(varargin) )

      switch lower(varargin{i})
          case 'scriptbtn'
              script_text_names = varargin{i+1};
          otherwise
              tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,varargin{i},type)
              error(tdum)

      end
      i = i+2;
  end
  c = {};
  errtext = '';
  
  if( ischar(script_text_names) )
    script_text_names = {script_text_names};
  end
  
  [ okay,c_lines ]  = read_ascii_file(cancmd_file);
  if( ~okay )
    errtext = sprintf('Cannot read <%s>',cancmd_file);
    return;
  end
  
  
  if( ~isempty(script_text_names) )
    for i=1:length(script_text_names)
      [cc,errtext] = read_from_cancmd_scriptbtn(c_lines,script_text_names{i});
      if( ~isempty(errtext) )
        error('Error_%s: %s',mfilename,errtext);
      end
      c = cell_add(c,cc);
    end
  end
  
  


end
function [cc,errtext] = read_from_cancmd_scriptbtn(c_lines,script_text_name)

  cc      = {};
  errtext = '';
  tt = '[ScriptBtn]';
  [ifound,ipos] = cell_find_f(c_lines,tt,'n');
  
  for i=1:length(ifound)
    [jcell,jpos] = cell_find_from_ipos(c_lines,ifound(i),ipos(i),'Text=','for');
    
    if( ~isempty(jcell) )
      ttt = c_lines{jcell(1)}(jpos(1)+length('Text='):end);
      if( strcmpi(script_text_name,ttt) )
        % suche script
        [jcell,jpos] = cell_find_from_ipos(c_lines,jcell(1),jpos(1),'Script=','for');
        if( ~isempty(jcell) )
          
          ttt = c_lines{jcell(1)}(jpos(1)+length('Script='):end);
          cc = str_split(ttt,'|');
          return
        end
      end
    end
  end
  errtext = sprintf('Der ScriptBtn <%s> konnte nicht gefunden werden !!!',script_text_name);
end
          
          
          
