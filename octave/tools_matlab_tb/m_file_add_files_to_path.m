function okay = m_file_add_files_to_path(varargin)
%
% okay = m_file_add_files_to_path('root_m_file',rootmfilename,
%                                ,'tools_path',tools_path
%                                ,'copy_path',copy_path
%
% okay = m_file_add_files_to_path('root_m_file',rootmfilename1
%                                ,'root_m_file',rootmfilename2
%                                ,'tools_path',{tools_path1,tools_path2}
%                                ,'copy_path',copy_path
%
%  root_m_file           mfilename which is checked for getting all tools m-file
%  tools_path            path where to find all m-files and mlapp-files

  okay = 1;
  c_root_m_file = {};
  c_tools_path    = {};
  copy_path     = '';
  i = 1;
  while( i+1 <= length(varargin) )

      switch lower(varargin{i})
          case 'root_m_file'
              c_root_m_file = cell_add(c_root_m_file,varargin{i+1});
          case 'tools_path'
              c_tools_path = cell_add(c_tools_path,varargin{i+1});
          case 'copy_path'
              copy_path = varargin{i+1};
          otherwise
              tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,varargin{i},type);
              error(tdum) %#ok<*SPERR>

      end
      i = i+2;
  end
  
  if( isempty(c_root_m_file) )
    error('root_m_file is empty')
  end
  
  for i=1:length(c_root_m_file)
    if( ~exist(c_root_m_file{i},'file') )
      error('root_m_file: <%s> does not exist',root_m_file);
    end
  end
  
  if( isempty(c_tools_path) )
    error('tools_path is empty')
  end
  
  if( ischar(c_tools_path) )
    c_tools_path = {c_tools_path};
  end
  
  for i=1:length(c_tools_path)
    if( ~exist(c_tools_path{i},'dir') )
      error('tools_path: <%s> does not exist',c_tools_path{i});
    end
  end
    
  if( isempty(copy_path) )
    error('copy_path is empty')
  end
  if( ~exist(copy_path,'dir') )
      mkdir(copy_path);
  end
  
  
  
  mstruct = struct([]);
  for i=1:length(c_tools_path)
    sstruct  = suche_files_ext(c_tools_path{i},'m');
    for j= 1:length(sstruct)
      if( isempty(mstruct) )
        mstruct = sstruct(j);
      else
        mstruct(length(mstruct)+1) = sstruct(j);
      end
    end
    sstruct  = suche_files_ext(c_tools_path{i},'mlapp');
    for j= 1:length(sstruct)    
      if( isempty(mstruct) )
        mstruct = sstruct(j);
      else
        mstruct(length(mstruct)+1) = sstruct(j);
      end      
    end
  end
  
  %
  % search all files in tools_path
  %
  copystruct = struct([]);
  for ir=1:length(c_root_m_file)
    
    root_m_file = c_root_m_file{ir};
  
    %
    % list of m_files to search for
    %
    s_file  = str_get_pfe_f(root_m_file);

    searchstruct.dir      = s_file.dir ;  
    searchstruct.name     = s_file.name ;  
    searchstruct.ext      = s_file.ext ;  
    searchstruct.fullname = s_file.fullfile ;  
  
    % search mliste in tt
    search_flag = 1;
    while(search_flag)
      [search_flag,searchstruct_add,copystruct] = add_m_files_update_files_search(mstruct,searchstruct,copystruct);
      if( search_flag )
        searchstruct = searchstruct_add;
      end
    end
  end
  
  % copy files:
  for i=1:length(copystruct)
    copy_file_if_newer(copystruct(i).fullname ...
                      ,fullfile(copy_path,[copystruct(i).name,'.',copystruct(i).ext]) ...
                      ,2);
  end

end
function [search_flag,searchstruct_add,copystruct] = add_m_files_update_files_search(mstruct,searchstruct,copystruct)

  search_flag = 0;
  
  % search over all collected searchstructs:
  %
  searchstruct_add = struct([]);
  for i=1:length(searchstruct)
    
    % read searchstruct(i)
    tt = add_m_files_update_files_get_tt(searchstruct(i));
    
    
    zwischen_struct = struct([]);
    for j = 1:length(mstruct)  
       fprintf('    mstruct(%i) for %s\n',j,mstruct(j).name);
      if( str_find_f(tt,mstruct(j).name,'vs') > 0 )
          if( isempty(zwischen_struct) )
            zwischen_struct =  mstruct(j);
          else
            zwischen_struct(length(zwischen_struct)+1) = mstruct(j);
          end
      end        
    end    
    % search all mfilenames in actual searchstruct
    for j = 1:length(zwischen_struct)  
    
      % search mfielname in searchstruct
      fprintf('    Search(%i) for %s\n',j,zwischen_struct(j).name);
      if( str_find_word_f(tt,1,zwischen_struct(j).name) > 0 )
        
        % proof if not in copystrauct
        %
        if(  ~add_m_files_update_files_is_in_struct(copystruct,zwischen_struct(j).name) )
          
          % add to copystruct and searchstruct_add
          % 
          if( isempty(copystruct) )
            copystruct =  zwischen_struct(j);
          else
            copystruct(length(copystruct)+1) = zwischen_struct(j);
          end
          if( isempty(searchstruct_add) )
            searchstruct_add = zwischen_struct(j);
          else
            searchstruct_add(length(searchstruct_add)+1) = zwischen_struct(j);
          end
          search_flag = 1;
        end
      end 
    end
  end 
end
function tt = add_m_files_update_files_get_tt(s_file)

  %
  % read search_file
  %
  [ okay,c,nc ] = read_ascii_file( s_file.fullname );
  
  % take out comments
  [c,~] = m_file_elim_comment(c,nc);
  
  if( ~okay )
    error('search_file: <%s> could not be read',s_file.fullname);
  else
    fprintf('-->Search in %s\n',s_file.fullname);
  end

  % build a textstring
  tt = cell_str_build_text(c,1); 
end
function flag = add_m_files_update_files_is_in_struct(copystruct,mname)  
  flag = 0;
  for i=1:length(copystruct)
    
    if( strcmp(copystruct(i).name,mname) )
      flag = 1;
      break;
    end
  end
end