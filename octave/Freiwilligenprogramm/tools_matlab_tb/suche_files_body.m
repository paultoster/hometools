function s_files = suche_files_body(c_dir,body_name,full_name_flag,all_dir_flag)
%
% s_files = suche_files_body(c_dir,body_name,full_name_flag,all_dir_flag)
%
% c_dir             cellarray mit allen zu durchsuchenden Pfaden
% body_name         Bodyname, der zu suchen ist also abc für abc012.dat
%                   ('*' sind alle Dateien)
%                   cell_array:
%                   body_name als cell array kann mit and oder or -
%                   Verknüpfung suchen:
%                   z.B. {'abc','|def'}  Sucht nach bodynamen abc oder def
%                        {'abc','def'}  Sucht nach bodynamen abc oder def
%                        {'abc','&def'}  Sucht nach bodynamen abc und def
%
% full_name_flag    0/1 body Name muss exakt stimmen (default 0 )
%                   -1       nicht exakt, aber linksbündig
%                   -2       nicht exakt, aber rechtsbündig
% all_dir_flag      0/1 all subdirs (default 0)
%
% Ergebnis:
% file_list(i).name     char    Name mit extension
%             .full_name char   vollerName mit Pfad
%             .body     char    Name ohne extension
%             .dir     char    Pfad
%             .ext      char    Endung
%             .date     char    datum letzte Änderung
%             .bytes    double  Bytelänge
  s_files = struct([]);

  if( ischar(c_dir) )
      c_dir = {c_dir};
  end

  body_name_and = {};
  body_name_or  = {};
  if( iscell(body_name) )
      for i=2:length(body_name)
        tt = body_name{i};
        if( tt(1) == '&' )
          body_name_and = cell_add(body_name_and,str_cut_ae_f(tt(2:end),' '));
        elseif( tt(1) == '|' )
          body_name_or = cell_add(body_name_or,str_cut_ae_f(tt(2:end),' '));
        else
          body_name_or = cell_add(body_name_or,str_cut_ae_f(tt(1:end),' '));
        end
      end
      body_name = body_name{1};
  end
  body_name  = str_cut_ae_f(body_name,' ');
  
  if( strcmp(body_name,'*') )
    all_files = 1;
  else
    all_files = 0;
  end
  
  if( ~exist('full_name_flag','var') )
    full_name_flag = 0;
  end
  
  if( full_name_flag == -1 )
    left_side_flag  = 1;
    right_side_flag = 0;
    full_name_flag  = 0;
  elseif( full_name_flag < -1.5 )
    left_side_flag  = 0;
    right_side_flag = 1;
    full_name_flag  = 0;
  else
    left_side_flag  = 0;
    right_side_flag = 0;
  end
    
  
  if( ~exist('all_dir_flag','var') )
    all_dir_flag = 0;
  end
  
  

  for i=1:length(c_dir)
    
    if( ~exist(c_dir{i},'dir') )
      error('%s: Der Pfad <%s> kann nicht gefunden werden',mfilename,c_dir{i})
    end

    [file_list,file_list_len] = suche_files_f(c_dir{i},'*',all_dir_flag,0);
    
    for j=1:file_list_len
      
      if( all_files )
        s_files = struct_add_struct_items(s_files,file_list(j));
      elseif( full_name_flag )
        if( strcmpi(file_list(j).body,body_name) )
          s_files = struct_add_struct_items(s_files,file_list(j));
        end
      else
        i0 = str_find_f(file_list(j).body,body_name,'v');
        if( left_side_flag )
          if(i0 == 1)
            s_files = struct_add_struct_items(s_files,file_list(j));
          end
        elseif( right_side_flag )
          if( (length(file_list(j).body)-i0+1) == length(body_name) )
            s_files = struct_add_struct_items(s_files,file_list(j));
          end                     
        elseif( i0 > 0  )
          s_files = struct_add_struct_items(s_files,file_list(j));
        end
      end
    end
    
    % OR-Verknüpfung
    if( ~isempty(body_name_or) )
      for j=1:length(body_name_or)
        [file_list,file_list_len] = suche_files_f(c_dir{i},body_name_or{j},all_dir_flag,0);
        for k=1:file_list_len
          nss = length(s_files);
          for l=1:nss
            if( ~strcmpi(file_list(k).full_name,s_files(l).full_name) )
              s_files = struct_add_struct_items(s_files,file_list(j));
            end
          end
        end
      end
    end
    
    % AND-Verknüpfung
    if( ~isempty(body_name_and) )
      for j=1:length(body_name_and)
         s_files2 = struct([]);
         nss = length(s_files);
         for k=1:nss
           ii = str_find_f(s_files(k).body,body_name_and{j},'vs');
           if( ii > 0 )
             s_files2 = struct_add_struct_items(s_files2,s_files(k));
           end
         end
         s_files = s_files2;
      end
    end
    
    
  end
end

    
    

    

