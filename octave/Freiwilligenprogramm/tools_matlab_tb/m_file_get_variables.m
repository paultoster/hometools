function [varnamelist,varvaluelist] = m_file_get_variables(varargin)
%
%    varnamelist = m_file_get_variables('file_name',file_name ...
%                                  ,'pre_name',pre_name);
%
%  also pososible:
%    varnamelist = m_file_get_variables('cellarray',c);
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
          case 'pre_name'
              pre_name = varargin{i+1};
          case 'cellarray'
              c = varargin{i+1};
          otherwise
              tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,varargin{i},type);
              error(tdum)

      end
      i = i+2;
  end
  
  if( ~isempty(pre_name) )
    flag_pre_name = 1;
  else
    flag_pre_name = 0;
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
    
    % proof every line
    %-----------------
    for i=1:n
      
      t  = str_change_f(c{i},'\t',' ');
      % find lines with equal sign
      i0 = str_find_f(t,'=','vs');
      
      if( i0 > 1 )
        
        t = c{i}(1:i0-1);
        ct = str_split(t,' ');
        
        [nrow,ncol] = cell_last_not_empty(ct);
        t = ct{nrow,ncol};
        t = str_cut_ae_f(t,' ');
        
        % pre_name
        %---------
        if( flag_pre_name )
          
          if( str_find_f(t,pre_name,'vs') == 1 )
            
             varnamelist = cell_add(varnamelist,t);
          end
        else
          varnamelist = cell_add(varnamelist,t);
        end
      end
    end
    
    if( nargout > 1 )
      [varvaluelist] = m_file_get_variables_values('cellarray',c,'varnamelist',varnamelist);
    end
    
  end
                            
                            
end