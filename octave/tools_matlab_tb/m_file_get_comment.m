function commentlist = m_file_get_comment(varargin)
%
%  Get all comments started by % from m-file:
%    commentlist = m_file_get_comment('file_name',file_name)
%
%  Get all comments started by % cell-array list with all line of the m-file:
%    commentlist = m_file_get_comment('cellarray',c)
%
%  Get only header comments started by % , first block of comments:
%    commentlist = m_file_get_comment(...,'header',1);
%
% output:
%  commentlist            cellarray with comment lines
  commentlist = {};
  header    = 0;
  file_name = '';
  c         = {};
  i = 1;
  while( i+1 <= length(varargin) )

      switch lower(varargin{i})
          case 'file_name'
              file_name = varargin{i+1};
          case 'cellarray'
              c = varargin{i+1};
          case 'header'
              header = varargin{i+1};
          otherwise
              tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,varargin{i},type);
              error(tdum) %#ok<*SPERR>

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
    
    if( header )
      
      % search header
      % first commented section
      %-------------------------
      find_status = 0;
      flag_add    = 0;
      for iline=1:n
        tt = str_cut_ae_f(c{iline},' ');
        i0 = str_find_f(tt,'%','vs');
        
        switch(find_status)
          case 0 % find comment
            if( iline > 5 )
              find_status = 2;
              flag_add = 0;
            elseif( i0 == 1)
              flag_add = 1;
              find_status = 1;
            end
          case 1 %  collect comment
            if( i0 ~= 1)
              flag_add = 0;
              find_status = 3;
            end
          case 2
            break;
        end
        
        if( flag_add )
          commentlist = cell_add(commentlist,tt);
        end
      end
        
    else
        
      % search all comment
      %-------------------------
      for iline=1:n
        tt = str_cut_ae_f(c{iline},' ');
        i0 = str_find_f(tt,'%','vs');
        
        if( i0 > 0 )
          commentlist = cell_add(commentlist,tt(i0:end));
        end
      end
    end
    
    
                            
end