function [source_files,include_dirs] = VC9_get_vcproj(vcproj_file)
%
% [source_files,include_dirs] = VC9_get_vcproj(vcproj_file)
%
% Liest aus vcproj_file  aus:
% source_files      cell array mit source-Files und header-Files ohne Filtername
% incl_dirs         include-Dorectories
%
%
  %========================================================================
  
  if( ~exist(vcproj_file,'file') )
    
    error('%_err: Das vcproj_file: %s ist nicht vorhanden',vcproj_file);

  end
  
  %========================================================================
  % proj_dir
  %---------
  s_file = str_get_pfe_f(vcproj_file);
  proj_dir = s_file.dir;
  
  %========================================================================
  % vcproj-xml einlesen
  %--------------------
  vcproj_root = xml_read_build_struct(vcproj_file);
  
  %========================================================================
  % sourcen abfragen
  %----------------------------------
     
  [source_files] = VC9_get_vcproj_get_sources(vcproj_root,proj_dir);
  
  %========================================================================
  % includes abfragen
  %----------------------------------
  [include_dirs] = VC9_get_vcproj_get_includes(vcproj_root,proj_dir);
    
end
function [source_files] = VC9_get_vcproj_get_sources(vcproj_root,proj_dir)
  % Sucht die den Zweig (Children) in 'VisualStudioProject.Files.Filter'
  % 
  %
  source_files = {};
  % Sucht die Files-Liste
  [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcproj_root,'VisualStudioProject.Files');
  % Sucht daraus alle Files
  ffchilds = xml_struct_find_all_children_with_Name_in_childs(fchilds,'File');
  % Hole davon alle mit attribut 'RelativePath'
  source_list = xml_struct_get_list_childs_w_attribute(ffchilds,'RelativePath');
  % Bildet alle absolut-Pfade
  s = get_abs_rel_path(proj_dir,source_list);
  % Einsortieren in cellarray-Liste
  for i=1:length(s)
    source_files = cell_add(source_files,s(i).abs_fullfile);
  end
end
function [include_dirs] = VC9_get_vcproj_get_includes(vcproj_root,proj_dir)
 % Sucht die den Zweig (Children) in 'VisualStudioProject.Configurations.Configuration'
  % mit Attribut Name='AdditionalIncludeDirectories'
  %
  include_dirs = {};
  % Release
  %--------
  [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcproj_root,'VisualStudioProject.Configurations.Configuration','a.Name.Release.valnotexact');

  % Hole davon alle mit attribut 'RelativePAth'
  [ll,ivec] = xml_struct_get_list_childs_w_attribute(fchilds,'AdditionalIncludeDirectories');
  liste = str_split(ll,';');
  s = get_abs_rel_path(proj_dir,liste,1);
  for i=1:length(s)
    include_dirs = cell_add_if_new(include_dirs,s(i).abs_dir,1);
  end
  
  % Debug
  %------
  [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcproj_root,'VisualStudioProject.Configurations.Configuration','a.Name.Debug.valnotexact');

  % Hole davon alle mit attribut 'RelativePAth'
  [ll,ivec] = xml_struct_get_list_childs_w_attribute(fchilds,'AdditionalIncludeDirectories');
  liste = str_split(ll,';');
  s = get_abs_rel_path(proj_dir,liste,1);
  for i=1:length(s)
    include_dirs = cell_add_if_new(include_dirs,s(i).abs_dir,1);
  end
end
% function [vcproj_root,modifyflag] = VC9_build_sln_vcproj_add_preprocessdef(vcproj_root,ppd_list)
%   % Sucht die den Zweig (Children) in 'VisualStudioProject.Configurations.Configuration'
%   % mit Attribut Name='AdditionalIncludeDirectories'
%   %
%   modifyflag = 0;
%   % Release
%   %--------
%   [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcproj_root,'VisualStudioProject.Configurations.Configuration','a.Name.Release.valnotexact');
% 
%   % Hole davon alle mit attribut 'RelativePAth'
%   [ll,ivec] = xml_struct_get_list_childs_w_attribute(fchilds,'PreprocessorDefinitions');
%   [ppd_str,newflag] = VC9_build_sln_vcproj_check_ppd_list(ll{1},ppd_list);
%   if( newflag )
%     fchilds = xml_struct_set_attribute_to_children(fchilds,ivec(1),'PreprocessorDefinitions',ppd_str);
%     [vcproj_root,okay,errText] = xml_struct_set_children(vcproj_root,fchilds,'VisualStudioProject.Configurations.Configuration','a.Name.Release.valnotexact',1);
%     if( ~okay )
%       tt = sprintf('Fehler in Include directory hinzufügen: \n%s',errText);
%       error('%s_error: %s',mfilename,tt);
%     end
%     modifyflag = 1;
%   end
%   % Debug
%   %------
%   [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcproj_root,'VisualStudioProject.Configurations.Configuration','a.Name.Debug.valnotexact');
% 
%   % Hole davon alle mit attribut 'RelativePAth'
%   [ll,ivec] = xml_struct_get_list_childs_w_attribute(fchilds,'PreprocessorDefinitions');
%   [ppd_str,newflag] = VC9_build_sln_vcproj_check_ppd_list(ll{1},ppd_list);
%   if( newflag )
%     fchilds = xml_struct_set_attribute_to_children(fchilds,ivec(1),'PreprocessorDefinitions',ppd_str);
%     [vcproj_root,okay,errText] = xml_struct_set_children(vcproj_root,fchilds,'VisualStudioProject.Configurations.Configuration','a.Name.Debug.valnotexact',1);
%     if( ~okay )
%       tt = sprintf('Fehler in Include directory hinzufügen: \n%s',errText);
%       error('%s_error: %s',mfilename,tt);
%     end
%     modifyflag = 1;
%   end
% end
% function [vcproj_root,modifyflag] = VC9_build_sln_vcproj_add_lib_files(vcproj_root,lib_files)
%   % Sucht die den Zweig (Children) in 'VisualStudioProject.Files.Filter'
%   % mit Attribut Name='sources'
%   %
%   modifyflag = 0;
%   % Release
%   %--------
%   [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcproj_root,'VisualStudioProject.Configurations.Configuration','a.Name.Release.valnotexact');
% 
%   % Hole davon alle mit attribut 'RelativePAth'
%   [ll,ivec] = xml_struct_get_list_childs_w_attribute(fchilds,'AdditionalDependencies');
%   [include_str,newflag] = VC9_build_sln_vcproj_check_lib_files_list(ll{1},lib_files);
%   if( newflag )
%     fchilds = xml_struct_set_attribute_to_children(fchilds,ivec(1),'AdditionalDependencies',include_str);
%     [vcproj_root,okay,errText] = xml_struct_set_children(vcproj_root,fchilds,'VisualStudioProject.Configurations.Configuration','a.Name.Release.valnotexact',1);
%     if( ~okay )
%       tt= sprintf('Fehler in AdditionalDependencies hinzufügen: \n%s',errText);
%       error('%s_error: %s',mfilename,tt);
%     end
%     modifyflag = 1;
%   end
%   % Debug
%   %------
%   [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcproj_root,'VisualStudioProject.Configurations.Configuration','a.Name.Debug.valnotexact');
% 
%   % Hole davon alle mit attribut 'RelativePAth'
%   [ll,ivec] = xml_struct_get_list_childs_w_attribute(fchilds,'AdditionalDependencies');
%   [include_str,newflag] = VC9_build_sln_vcproj_check_lib_files_list(ll{1},lib_files);
%   if( newflag )
%     fchilds = xml_struct_set_attribute_to_children(fchilds,ivec(1),'AdditionalDependencies',include_str);
%     [vcproj_root,okay,errText] = xml_struct_set_children(vcproj_root,fchilds,'VisualStudioProject.Configurations.Configuration','a.Name.Debug.valnotexact',1);
%     if( ~okay )
%       tt= sprintf('Fehler in AdditionalDependencies hinzufügen: \n%s',errText);
%       error('%s_error: %s',mfilename,tt);
%     end
%     modifyflag = 1;
%   end
% end
% function [vcproj_root,modifyflag] = VC9_build_sln_vcproj_add_lib_dirs(vcproj_root,lib_dirs,proj_dir)
%   % Sucht die den Zweig (Children) in 'VisualStudioProject.Configurations.Configuration'
%   % mit Attribut Name='AdditionalIncludeDirectories'
%   %
%   modifyflag = 0;
%   % Release
%   %--------
%   [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcproj_root,'VisualStudioProject.Configurations.Configuration','a.Name.Release.valnotexact');
% 
%   % Hole davon alle mit attribut 'RelativePAth'
%   [ll,ivec] = xml_struct_get_list_childs_w_attribute(fchilds,'AdditionalLibraryDirectories');
%   [include_str,newflag] = VC9_build_sln_vcproj_check_lib_dirs(ll{1},lib_dirs,proj_dir);
%   if( newflag )
%     fchilds = xml_struct_set_attribute_to_children(fchilds,ivec(1),'AdditionalLibraryDirectories',include_str);
%     [vcproj_root,okay,errText] = xml_struct_set_children(vcproj_root,fchilds,'VisualStudioProject.Configurations.Configuration','a.Name.Release.valnotexact',1);
%     if( ~okay )
%       tt= sprintf('Fehler in Library directory hinzufügen: \n%s',errText);
%       error('%s_error: %s',mfilename,tt);
%     end
%     modifyflag = 1;
%   end
%   % Debug
%   %------
%   [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcproj_root,'VisualStudioProject.Configurations.Configuration','a.Name.Debug.valnotexact');
% 
%   % Hole davon alle mit attribut 'RelativePAth'
%   [ll,ivec] = xml_struct_get_list_childs_w_attribute(fchilds,'AdditionalLibraryDirectories');
%   [include_str,newflag] = VC9_build_sln_vcproj_check_lib_dirs(ll{1},lib_dirs,proj_dir);
%   if( newflag )
%     fchilds = xml_struct_set_attribute_to_children(fchilds,ivec(1),'AdditionalLibraryDirectories',include_str);
%     [vcproj_root,okay,errText] = xml_struct_set_children(vcproj_root,fchilds,'VisualStudioProject.Configurations.Configuration','a.Name.Debug.valnotexact',1);
%     if( ~okay )
%       tt= sprintf('Fehler in Lirary directory hinzufügen: \n%s',errText);
%       error('%s_error: %s',mfilename,tt);
%     end
%     modifyflag = 1;
%   end
% end
% %==========================================================================
% %==========================================================================
% function ss = VC9_build_sln_vcproj_get_path_struct(proj_dir,ll)
%   ss = [];
%   n = length(ll);
%   for i=1:n
%     s = str_get_pfe_f(ll{i});
%      
%     ss(i).file_name = [s.name,'.',s.ext];
%      
%     if( is_abs_dir(s.dir) )
%       ss(i).abs_dir   = s.dir;
%       ss(i).rel_dir   = get_rel_dir(s.dir,proj_dir);
%     else
%       ss(i).abs_dir   = get_abs_dir(s.dir,proj_dir);
%       ss(i).rel_dir   = s.dir;
%     end
%   end
% end
% function ss_add   = VC9_build_sln_vcproj_check_source_files(ss_exist,ss_new)
%   n_exist = length(ss_exist);
%   n_new   = length(ss_new);
%   n_add   = 0;
%   
%   % ss_add  = struct('file_name','','rel_dir','','abs_dir','');
%   for i=1:n_new
%     flag = 1;
%     for j=1:n_exist
%       if( strcmpi(ss_exist(j).file_name,ss_new(i).file_name) )
%         flag = 0;
%         break;
%       end
%     end
%     if( flag )
%       n_add         = n_add+1;
%       ss_add(n_add) = ss_new(i);
%     end
%   end
%   if( ~exist('ss_add','var') )
%     ss_add = struct([]);
%   end
% end
% function children = VC9_build_sln_vcproj_set_children(children,ss_add)
% 
%   n0        = length(children);
%   n         = length(ss_add);
%   if( n0 == 0 )
%     allocCell = cell(1, n);
% 
%     children  = struct(             ...
%                 'Name', allocCell, 'Attributes', allocCell,    ...
%                 'Data', allocCell, 'Children', allocCell);
%   end            
%   for i = 1:n
%     
%     children(i+n0).Name = 'File';
%     children(i+n0).Attributes(1).Name  = 'RelativePath';
%     children(i+n0).Attributes(1).Value = fullfile(ss_add(i).rel_dir,ss_add(i).file_name);
%   end
%   
% end
% function [include_string,newflag] = VC9_build_sln_vcproj_check_include_list(include_string,include_list,proj_dir)
% %
% % ss(i).abs_dir
% % ss(i).rel_dir
% %
%   n = length(include_list);
%   for i=1:n     
%     if( is_abs_dir(include_list{i}) )
%       ss(i).abs_dir   = include_list{i};
%       [ss(i).rel_dir,okay]   = get_rel_dir(include_list{i},proj_dir);
%       if( ~okay ), ss(i).rel_dir = ss(i).abs_dir;end
%     else
%       ss(i).abs_dir   = get_abs_dir(include_list{i},proj_dir);
%       ss(i).rel_dir   = include_list{i};
%     end
%   end
% 
%   newflag = 0;
%   ll = str_split(include_string,';');
%   ns = length(ss);
%   n  = length(ll);
%   add_list = {};
%   for i = 1:ns
%     flag = 1;
%     for j=1:n
%       if( is_abs_dir(ll{j}) )        
%         if( dircmpi(ss(i).abs_dir,ll{j}) )
%           flag = 0;
%         end
%       else
%         if( dircmpi(ss(i).rel_dir,ll{j}) )
%           flag = 0;
%         end
%       end
%     end
%     if( flag )
%       add_list = cell_add(add_list,ss(i).rel_dir);
%     end
%   end
%   if( ~isempty(add_list) )
%     ll = cell_add(ll,add_list);
%     include_string = str_compose(ll,';');
%     newflag = 1;
%   end
% end
% function [ppd_string,newflag] = VC9_build_sln_vcproj_check_ppd_list(ppd_string,ppd_list)
% %
% %
%   newflag = 0;
%   ll = str_split(ppd_string,';');
%   np = length(ppd_list);
%   n  = length(ll);
%   add_list = {};
%   for i = 1:np
%     flag = 1;
%     for j=1:n
%       if( strcmp(ppd_list{i},ll{j}) )
%         flag = 0;
%         break;
%       end
%     end
%     if( flag )
%       add_list = cell_add(add_list,ppd_list{i});
%     end
%   end
%   if( ~isempty(add_list) )
%     ll = cell_add(ll,add_list);
%     ppd_string = str_compose(ll,';');
%     newflag = 1;
%   end
% end
% function [lib_files_string,newflag] = VC9_build_sln_vcproj_check_lib_files_list(lib_files_string,lib_files)
% %
% % ss(i).abs_dir
% % ss(i).rel_dir
% %
%   newflag = 0;
%   ll = str_split(lib_files_string,' ');
%   ns = length(lib_files);
%   n  = length(ll);
%   add_list = {};
%   for i = 1:ns
%     flag = 1;
%     for j=1:n
%       if( strcmpi(lib_files(i),ll{j}) )
%         flag = 0;
%         break;
%       end
%     end
%     if( flag )
%       add_list = cell_add(add_list,lib_files(i));
%     end
%   end
%   if( ~isempty(add_list) )
%     ll = cell_add(ll,add_list);
%     lib_files_string = str_compose(ll,' ');
%     newflag = 1;
%   end
% end
% function [lib_dirs_string,newflag] = VC9_build_sln_vcproj_check_lib_dirs(lib_dirs_string,include_list,proj_dir)
% %
% % ss(i).abs_dir
% % ss(i).rel_dir
% %
%   n = length(include_list);
%   for i=1:n     
%     if( is_abs_dir(include_list{i}) )
%       ss(i).abs_dir   = include_list{i};
%       [ss(i).rel_dir,okay]   = get_rel_dir(include_list{i},proj_dir);
%       if( ~okay ), ss(i).rel_dir = ss(i).abs_dir;end
%     else
%       ss(i).abs_dir   = get_abs_dir(include_list{i},proj_dir);
%       ss(i).rel_dir   = include_list{i};
%     end
%   end
% 
%   newflag = 0;
%   ll = str_split(lib_dirs_string,',');
%   ns = length(ss);
%   n  = length(ll);
%   add_list = {};
%   for i = 1:ns
%     flag = 1;
%     for j=1:n
%       if( is_abs_dir(ll{j}) )        
%         if( dircmpi(ss(i).abs_dir,ll{j}) )
%           flag = 0;
%         end
%       else
%         if( dircmpi(ss(i).rel_dir,ll{j}) )
%           flag = 0;
%         end
%       end
%     end
%     if( flag )
%       add_list = cell_add(add_list,ss(i).rel_dir);
%     end
%   end
%   if( ~isempty(add_list) )
%     ll = cell_add(ll,add_list);
%     lib_dirs_string = str_compose(ll,',');
%     newflag = 1;
%   end
% end
