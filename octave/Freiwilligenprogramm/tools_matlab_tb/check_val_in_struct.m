function okay = check_val_in_struct(s,name,type,proofempty,set_error)
%
% okay = check_val_in_struct(s,name,type[,proofempty,set_error])
%
% s          struct         Strukturvariable
% name       char           Name des Elements in s
% type       char           type: 'char','num','cell','struct','any'(default)
%                           'any' prüft beliebigen Typ ansonsten die Angabe
% proofempty 0/1            prüft ob leer (default 0)
% set_error  0/1            wenn die Daten nicht stimmen error setzen
%
% okay       = 0            Strukturvariable mit dem vorgegebenen Typ ist
%                           nicht vorhanden (proofempty=1: Strukturvariable
%                           kann leer sein)
%
%            = 1            Strukturvariable mit dem vorgegebenen Typ ist
%                           vorhanden (proofempty=1: Strukturvariable
%                           ist gefüllt)

  if( ~exist('proofempty','var') )
    proofempty = 0;
  end
  if( ~exist('set_error','var') )
    set_error = 0;
  end
  if( ~exist('type','var') )
    type = 'any';
  end

  if(  ~strcmpi(type,'char') ...
    && ~strcmpi(type,'num') ...
    && ~strcmpi(type,'numeric') ...
    && ~strcmpi(type,'cell') ...
    && ~strcmpi(type,'struct') ...
    && ~strcmpi(type,'any') ...
    )
    error('%s: der type: <%s> ist nicht bekannt (siehe help %s)',mfilename,type);
  end

  okay = 1;

  if( ~isstruct(s)     )
    if( set_error )
      error('%s: übergebene Struktur ist keine Struktur',mfilename);
    else
      okay = 0;
    end
    return;
  end
  if( ~isfield(s,name) )
    if( set_error )
      error('%s: der Strukturelementname <%s> ist keine nicht vorhanden',mfilename,name);
    else
      okay = 0;
    end
    return;
  end
    
  if( strcmpi(type,'char') )
    if( ~ischar(s.(name)) )
      if( set_error )
        error('%s: der Strukturelement s.%s> ist kein char',mfilename,name);
      else
        okay = 0;
      end
      return;
    end
  elseif( strcmpi(type,'num') || strcmpi(type,'numeric') )
    if( ~isnumeric(s.(name)) )
      if( set_error )
        error('%s: der Strukturelement s.%s> ist nicht numerisch',mfilename,name);
      else
        okay = 0;
      end
      return;
    end
  elseif( strcmpi(type,'cell') )
    if( ~iscell(s.(name)) )
      if( set_error )
        error('%s: der Strukturelement s.%s ist kein cellarray',mfilename,name);
      else
        okay = 0;
      end
      return;
    end
  elseif( strcmpi(type,'struct') )
    a = s(1).(name);
    if( ~isstruct(a) )
      if( set_error )
        error('%s: der Strukturelement s.%s ist keine struktur',mfilename,name);
      else
        okay = 0;
      end
      return;
    end
  end
  if( proofempty )
    a = s(1).(name);
    if( isempty(a) )
      if( set_error )
        error('%s: der Strukturelement s.%s ist leer',mfilename,name);
      else
        okay = 0;
      end
      return;
    end
  end
end