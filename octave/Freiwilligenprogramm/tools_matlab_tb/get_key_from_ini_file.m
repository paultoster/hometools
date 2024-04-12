function value = get_key_from_ini_file(varargin)
%
% value = get_key_from_ini_file(['file',file_name] ...
%                              ,['section','TEST'] ...
%                              ,['key','lV'] ... 
%                              ,['comment_line',';'] ...
%
%  Liest vom ini-File
%  [section]
%   key = value
%
%  comment_line = '%' nach dem Zeichen beginnt Kommentar
%
% Rückgabe value ist erstmal ein string
% Wenn mehrere Dateien eigegben werden, dann ist value ein cellarray
%
  value        = '';
  
  files        = {};
  section      = '';
  key          = '';
  comment_line = '';

  i = 1;
  while( i+1 <= length(varargin) )

      c = lower(varargin{i});
      switch c
          case 'file'
              files = cell_add(files,varargin{i+1});
          case 'section'
              section = varargin{i+1};
          case 'key'
              key = varargin{i+1};
          case 'comment_line'
              comment_line = varargin{i+1};
          otherwise

              error('%s: Attribut <%s> nicht okay',mfilename,varargin{i})

      end
      i = i+2;
  end

  if( isempty(key) )
    error('No key-Value set')
  end
  
  if( length(files) == 0 )
    error('no file name is set')
  end
  
  value = {};
  
  for i= 1:length(files) 
    
    filename = files{i};
    
    [ okay,c,n ] = read_ascii_file( filename );
    
    if( ~isempty(comment_line) )
      
      c = get_key_from_ini_file_elim_comment_line(c,n,comment_line);
    end
    
    [csection] = get_key_from_ini_file_find_section(c,n,section);
    
    v = get_key_from_ini_file_find_key(csection,length(csection),key);
    
    if( length(files) == 1 )
      value = v;
    else
      value = cell_add(value,v);
    end
  end

  end
  function c = get_key_from_ini_file_elim_comment_line(c,n,comment_line)
    
    for i=1:n
      
      line = c{i};
      
      [c_text,ivec] = str_get_quot_f(line,'"','"','a');
      
      for j=1:length(c_text)
        
        ifound = str_find_f( c_text{j}, comment_line,'vs');
        
        if( ifound )
          istart = ivec(j) + ifound-1;
          
          if( istart > 1 )
            line = line(1:istart-1);
          else
            line = '';
          end
          
          c{i} = line;
          break;
     
        end
      end
    end
  end
  function [csection] = get_key_from_ini_file_find_section(c,n,section)
    
     section = str_cut_ae_f(section,' ');
     
    [cname,iline] = get_key_from_ini_file_find_all_section(c,n);
    istart = 0;
    iend = 0;
    csection = {};
    for i=1:length(cname)
      
      if( strcmpi(str_cut_ae_f(cname{i},' '),section) )
        
        istart = iline(i);
        if( ~isempty(cname{i}) )
          istart = istart + 1;
        end
        
        if( i == length(cname) ) % ende
          iend = n;
        else
          iend = iline(i+1)-1;
        end
        
        break;
        
      end
    end
    
    if( istart > 0 && iend > 0 )
      
      for i = istart:iend
        csection = cell_add(csection,c{i});
      end
    end
    
  end

  function [cname,iline] = get_key_from_ini_file_find_all_section(c,n)
    
    cname = {};
    iline = [];
   
    
    for i=1:n
      
      line = c{i};
      
      [c_text,ivec] = str_get_quot_f(line,'[',']','i');
      
      if( ~isempty(c_text) && ~isempty(c_text{1}) )
        
        cname = cell_add(cname,c_text{1});
        iline = [iline,i];
        
      elseif( i == 1 ) % first line
         cname = cell_add(cname,'');
         iline = [iline,i];
      end
      
    end
    
  end
  
  function value = get_key_from_ini_file_find_key(c,n,key)
    
    value = '';
    key = lower(key);
    for i=1:n
      
      t = c{i};
      
      if( str_find_f(lower(t),key,'vs') )
        
        i0 = str_find_f(t,'=','vs');
        
        if( i0 > 0 )
                   
          t = t(i0+1:end);
          
          [value,~] = str_find_next_item_f(t,1,'v');
          
          if( ~isempty(value) && (value(1) == '"') && (length(t)>1) )
            
            i0 = str_find_f(t,'"','vs');
            n  = length(t);
            if( i0 > 0 && (i0<n) )
                          
              i1 = str_find_f(t(i0+1:end),'"','vs');
              if( i1+i0-1 >= i0+1 )
                value = t(i0+1:i1+i0-1);
              end
            end
          end
          break;
        end
          
      end
    end
    
  
  end