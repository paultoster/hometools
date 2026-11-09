function [varvaluelist] = m_file_get_variables_values(varargin)
%
%    varvaluelist = m_file_get_variables_values('file_name',file_name ...
%                                              ,'varnamelist',varnamelist);
%    varvaluelist = m_file_get_variables_values('cellarray',c ...
%                                              ,'varnamelist',varnamelist);
%
% search for variable value assignments of mfile file_name or with
%                       read_ascii raed cellarray
% varnamelist          List of variable to find value assign by '='
%
% varvaluelist         List with values but in char, if nofound value will
%                      be ''
  varnamelist = {};
  varvaluelist = {};
  
  file_name = '';
  pre_name  = '';
  c         = {};
  i = 1;
  while( i+1 <= length(varargin) )

      switch lower(varargin{i})
          case 'file_name'
              file_name = varargin{i+1};
          case 'varnamelist'
              varnamelist = varargin{i+1};
          case 'cellarray'
              c = varargin{i+1};
          otherwise
              tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,varargin{i},type);
              error(tdum)

      end
      i = i+2;
  end
    
  if( ~isempty(file_name) )
    % read file
    %----------
    [ okay,c,n ] = read_ascii_file(file_name);
  else
    if( isempty(c) )
      error(' No Filename and no cellarray from ascii-read in');
    end
    
    n = length(c);
    
    okay = 1;
  end
  if( okay )
    
    
    % take out comments
    [c,n] = m_file_elim_comment(c,n);
    
    % search for varnamelist
    %-----------------------
    for i=1:length(varnamelist)
      
      varname = varnamelist{i};
      
      varvalue = '';
      
      [jcell,jpos] = cell_find_from_ipos(c,1,1,varname,'for');
            
      while( jcell > 0 )
       
        strout = cell_concatenate_str_cells(c,' ',jcell);
        
        strout = strout(jpos+length(varname):end);
        
        strout = str_cut_a_f(strout,' ');
        
        if( (strout(1) == '=') && (length(strout) > 1))
          
          strout = strout(2:end);
          
          ifound = str_find_f(strout,';','vs');
          
          if( ifound && (ifound>1) )
            
            strout = strout(1:ifound-1);
            
            varvalue = str_cut_ae_f(strout,' ');
          end
        end
        jpos = jpos+length(varname);
        if( jpos > length(c{jcell})  )
          jcell = jcell + 1;
          jpos  = 1;
          
          if( jcell > length(c) )
            break;
          end
        end
        
        [jcell,jpos] = cell_find_from_ipos(c,jcell,jpos,varname,'for');
        
      end
        
      varvaluelist = cell_add(varvaluelist,varvalue);
      
    end
  end
                            
                            
end