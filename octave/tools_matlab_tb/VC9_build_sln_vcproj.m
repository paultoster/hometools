function VC9_build_sln_vcproj(vcsln_file,vcproj_file,vc_sln_write,proj_name,csrc_files,incl_dirs,preproc_defs,lib_files,lib_dirs)
%
% [okay,errtext] = VC9_build_sln_vcproj(vcsln_file,vcproj_file,src_files,incl_dirs,preproc_defs,lib_files)
%
% Erstellt oder Editiert vcsln_file,vcproj_file mit dem proj_name und mit den cell-arrayListen
% aus:
% csrc_files        cell array mit source-Files und header-Files mit Filtername {src_files,filtername}
% incl_dirs         include-Dorectories
% preproc_defs      Preprocessor -Defines
% lib_files         library-Files
% lib_dirs          library-dirs
%
% Wenn vcsln_file,vcproj_file noch nicht vorhanden, werden diese aus
% all/src mit VC9_MEX_VPU_CAN_SIM.sln und VC9_MEX_VPU_CAN_SIM.vcproj
% gebildet
%
%
  VC_FILTER_NAME = 'source';
  %========================================================================
  % Files generieren, wenn nicht vorhanden
  f = mfilename('fullpath');
  s_file = str_get_pfe_f(f);
  sln_proto    = fullfile(s_file.dir,'src_modul','VC9_MEX_VPU_CAN_SIM.sln');
  vcproj_proto = fullfile(s_file.dir,'src_modul','VC9_MEX_VPU_CAN_SIM.vcproj');
  
  if( vc_sln_write )
    if( ~exist(vcsln_file,'file') )

      if( ~exist(sln_proto,'file') )
        error('%s_error: Das solution-Prototype-File %s ist nicht vorhanden !!!',mfilename,sln_proto);
      end
      [okay,c,nc] = read_ascii_file(sln_proto);
      if( ~okay )
        error('%s_error: Datei %s konnte nicht eingelsen werden',mfilename,sln_proto);
      end
      % Projekt-Namen einsetzen
      c = cell_change(c,'#PROJECT_NAME#',proj_name);
      write_ascii_file(vcsln_file,c);
    end
  end
  if( exist(vcproj_file,'file') )
    delete(vcproj_file);
  end
  % if( ~exist(vcproj_file,'file') )
    
    if( ~exist(vcproj_proto,'file') )
      error('%s_error: Das VC-project-Prototype-File %s ist nicht vorhanden !!!',mfilename,vcproj_proto);
    end
    [okay,c,nc] = read_ascii_file(vcproj_proto);
    if( ~okay )
      error('%s_error: Datei %s konnte nicht eingelsen werden',mfilename,vcproj_proto);
    end
    % Projekt-Namen einsetzen
    c = cell_change(c,'#PROJECT_NAME#',proj_name);
    write_ascii_file(vcproj_file,c);
  % end
  
  %========================================================================
  % proj_dir
  %---------
  s_file = str_get_pfe_f(vcproj_file);
  proj_dir = s_file.dir;
  
  %========================================================================
  % vcproj-xml einlesen
  %--------------------
  vcproj_root = xml_read_build_struct(vcproj_file);
  modifyflag = 0;
  
  %========================================================================
  % sourcen überprüfen und hinzufügen
  %----------------------------------
  
  % Aufteilen in Files und Filtername
  n = length(csrc_files);
  src_files  = cell(1,n);
  src_filter = cell(1,n);
  for i = 1:n
    if( ischar(csrc_files{i}) )
      src_files{i}  = q.csrc_files{i};
      src_filter{i} = VC_FILTER_NAME;
    elseif( iscell(csrc_files{i}) && (length(csrc_files{i}) == 1) )
      src_files{i}  = csrc_files{i}{1};
      src_filter{i} = VC_FILTER_NAME;
    else
      src_files{i}  = csrc_files{i}{1};
      src_filter{i} = csrc_files{i}{2};
    end
  end
   
  [vcproj_root,mm] = VC9_build_sln_vcproj_add_sources(vcproj_root,src_files,src_filter,proj_dir);
  if( mm ),modifyflag = 1;end
  
  %========================================================================
  % includes überprüfen und hinzufügen
  %----------------------------------
  [vcproj_root,mm] = VC9_build_sln_vcproj_add_includes(vcproj_root,incl_dirs,proj_dir);
  if( mm ),modifyflag = 1;end
  
  %========================================================================
  % preprocess_defs überprüfen und hinzufügen
  %----------------------------------
  [vcproj_root,mm] = VC9_build_sln_vcproj_add_preprocessdef(vcproj_root,preproc_defs);
  if( mm ),modifyflag = 1;end

  %========================================================================
  % lib_files überprüfen und hinzufügen
  %----------------------------------
  [vcproj_root,mm] = VC9_build_sln_vcproj_add_lib_files(vcproj_root,lib_files);
  if( mm ),modifyflag = 1;end

  %========================================================================
  % lib_dirs überprüfen und hinzufügen
  %----------------------------------
  [vcproj_root,mm] = VC9_build_sln_vcproj_add_lib_dirs(vcproj_root,lib_dirs,proj_dir);
  if( mm ),modifyflag = 1;end

  %==========================================================================
  % vcproj schreiben
  %-----------------
  if( modifyflag )
    okay = xml_struct_write_to_xml(vcproj_file,vcproj_root);
  end
  
end
function [vcproj_root,modifyflag] = VC9_build_sln_vcproj_add_sources(vcproj_root,source_files,source_filter,proj_dir)
  % Sucht die den Zweig (Children) in 'VisualStudioProject.Files.Filter'
  % mit Attribut Name='sources'
  %
  modifyflag = 0;
  n = length(source_files);
  s.filter = source_filter{1};
  s.liste  = {source_files{1}};
  for i = 2:n
    jj = 0;
    for j=1:length(s)
      if( strcmpi(source_filter{i},s(j).filter) )
        jj = j;
        break;
      end
    end
    if( jj == 0 )
      s(length(s)+1).filter = source_filter{i};
      s(length(s)).liste    = {source_files{i}};
    else
      s(jj).liste = cell_add(s(jj).liste,source_files{i});
    end
  end
  n = length(s);
      
  for i = 1:n
   src_file_liste = s(i).liste;
   src_filter     = s(i).filter;
   
   % Filter suchen
   [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcproj_root,'VisualStudioProject.Files.Filter',['a.Name.',src_filter]);
   if( ~okay )
     clear add_child
     add_child.Name             = 'Filter';
     add_child.Attributes(1).Name  = 'Filter';
     add_child.Attributes(1).Value = 'cpp;c;cc;cxx;def;odl;idl;hpj;bat;asm;asmx';
     add_child.Attributes(2).Name  = 'Name';
     add_child.Attributes(2).Value = src_filter;
     add_child.Data             = '';
     add_child.Children         = [];
     [vcproj_root,okay,errText] = xml_struct_add_children(vcproj_root,add_child,'VisualStudioProject.Files');
     % Nochmal um fchilds zu bekommen
     [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcproj_root,'VisualStudioProject.Files.Filter',['a.Name.',src_filter]);
   end
   
   % Hole davon alle mit attribut 'RelativePAth'
   source_list = xml_struct_get_list_childs_w_attribute(fchilds,'RelativePath');
   
   % Suche die hinzuzufügenden Sourcen
   ss_exist = VC9_build_sln_vcproj_get_path_struct(proj_dir,source_list);
   ss_new   = VC9_build_sln_vcproj_get_path_struct(proj_dir,src_file_liste);
   ss_add   = VC9_build_sln_vcproj_check_source_files(ss_exist,ss_new);

   if( ~isempty(ss_add) )
    fchilds        = VC9_build_sln_vcproj_set_children(fchilds,ss_add);
    [vcproj_root,okay,errText] = xml_struct_set_children(vcproj_root,fchilds,'VisualStudioProject.Files.Filter',['a.Name.',src_filter],1);
    if( ~okay )
      tt = sprintf('Fehler in Sourcen hinzufügen: \n%s',errText);
      error('%s_error: %s',mfilename,tt);
    end
    modifyflag = 1;
   end
  end
  
%   [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcproj_root,'VisualStudioProject.Files.Filter','a.Name.sources');
%   if( ~okay )
%     clear add_child
%     add_child.Name             = 'Filter';
%     add_child.Attributes(1).Name  = 'Filter';
%     add_child.Attributes(1).Value = 'cpp;c;cc;cxx;def;odl;idl;hpj;bat;asm;asmx';
%     add_child.Attributes(2).Name  = 'Name';
%     add_child.Attributes(2).Value = 'sources';
%     add_child.Data             = '';
%     add_child.Children         = [];
%     [vcproj_root,okay,errText] = xml_struct_add_children(vcproj_root,add_child,'VisualStudioProject.Files');
%     % Nochmal um fchilds zu bekommen
%     [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcproj_root,'VisualStudioProject.Files.Filter','a.Name.sources');
%   end
%   % Hole davon alle mit attribut 'RelativePAth'
%   source_list = xml_struct_get_list_childs_w_attribute(fchilds,'RelativePath');
%   
%   % Suche die hinzuzufügenden Sourcen
%   ss_exist = VC9_build_sln_vcproj_get_path_struct(proj_dir,source_list);
%   ss_new   = VC9_build_sln_vcproj_get_path_struct(proj_dir,source_files);
%   ss_add   = VC9_build_sln_vcproj_check_source_files(ss_exist,ss_new);
%   
%   if( ~isempty(ss_add) )
%     fchilds        = VC9_build_sln_vcproj_set_children(fchilds,ss_add);
%     [vcproj_root,okay,errText] = xml_struct_set_children(vcproj_root,fchilds,'VisualStudioProject.Files.Filter','a.Name.sources',1);
%     if( ~okay )
%       tt = sprintf('Fehler in Sourcen hinzufügen: \n%s',errText);
%       error('%s_error: %s',mfilename,tt);
%     end
%     modifyflag = 1;
%   end
end
function [vcproj_root,modifyflag] = VC9_build_sln_vcproj_add_includes(vcproj_root,include_list,proj_dir)
  % Sucht die den Zweig (Children) in 'VisualStudioProject.Configurations.Configuration'
  % mit Attribut Name='AdditionalIncludeDirectories'
  %
  modifyflag = 0;
  % Release
  %--------
  [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcproj_root,'VisualStudioProject.Configurations.Configuration','a.Name.Release.valnotexact');

  % Hole davon alle mit attribut 'RelativePAth'
  [ll,ivec] = xml_struct_get_list_childs_w_attribute(fchilds,'AdditionalIncludeDirectories');
  [include_str,newflag] = VC9_build_sln_vcproj_check_include_list(ll{1},include_list,proj_dir);
  if( newflag )
    fchilds = xml_struct_set_attribute_to_children(fchilds,ivec(1),'AdditionalIncludeDirectories',include_str);
    [vcproj_root,okay,errText] = xml_struct_set_children(vcproj_root,fchilds,'VisualStudioProject.Configurations.Configuration','a.Name.Release.valnotexact',1);
    if( ~okay )
      tt= sprintf('Fehler in Include directory hinzufügen: \n%s',errText);
      error('%s_error: %s',mfilename,tt);
    end
    modifyflag = 1;
  end
  % Debug
  %------
  [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcproj_root,'VisualStudioProject.Configurations.Configuration','a.Name.Debug.valnotexact');

  % Hole davon alle mit attribut 'RelativePAth'
  [ll,ivec] = xml_struct_get_list_childs_w_attribute(fchilds,'AdditionalIncludeDirectories');
  [include_str,newflag] = VC9_build_sln_vcproj_check_include_list(ll{1},include_list,proj_dir);
  if( newflag )
    fchilds = xml_struct_set_attribute_to_children(fchilds,ivec(1),'AdditionalIncludeDirectories',include_str);
    [vcproj_root,okay,errText] = xml_struct_set_children(vcproj_root,fchilds,'VisualStudioProject.Configurations.Configuration','a.Name.Debug.valnotexact',1);
    if( ~okay )
      tt= sprintf('Fehler in Include directory hinzufügen: \n%s',errText);
      error('%s_error: %s',mfilename,tt);
    end
    modifyflag = 1;
  end
end
function [vcproj_root,modifyflag] = VC9_build_sln_vcproj_add_preprocessdef(vcproj_root,ppd_list)
  % Sucht die den Zweig (Children) in 'VisualStudioProject.Configurations.Configuration'
  % mit Attribut Name='AdditionalIncludeDirectories'
  %
  modifyflag = 0;
  % Release
  %--------
  [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcproj_root,'VisualStudioProject.Configurations.Configuration','a.Name.Release.valnotexact');

  % Hole davon alle mit attribut 'RelativePAth'
  [ll,ivec] = xml_struct_get_list_childs_w_attribute(fchilds,'PreprocessorDefinitions');
  [ppd_str,newflag] = VC9_build_sln_vcproj_check_ppd_list(ll{1},ppd_list);
  if( newflag )
    fchilds = xml_struct_set_attribute_to_children(fchilds,ivec(1),'PreprocessorDefinitions',ppd_str);
    [vcproj_root,okay,errText] = xml_struct_set_children(vcproj_root,fchilds,'VisualStudioProject.Configurations.Configuration','a.Name.Release.valnotexact',1);
    if( ~okay )
      tt = sprintf('Fehler in Include directory hinzufügen: \n%s',errText);
      error('%s_error: %s',mfilename,tt);
    end
    modifyflag = 1;
  end
  % Debug
  %------
  [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcproj_root,'VisualStudioProject.Configurations.Configuration','a.Name.Debug.valnotexact');

  % Hole davon alle mit attribut 'RelativePAth'
  [ll,ivec] = xml_struct_get_list_childs_w_attribute(fchilds,'PreprocessorDefinitions');
  [ppd_str,newflag] = VC9_build_sln_vcproj_check_ppd_list(ll{1},ppd_list);
  if( newflag )
    fchilds = xml_struct_set_attribute_to_children(fchilds,ivec(1),'PreprocessorDefinitions',ppd_str);
    [vcproj_root,okay,errText] = xml_struct_set_children(vcproj_root,fchilds,'VisualStudioProject.Configurations.Configuration','a.Name.Debug.valnotexact',1);
    if( ~okay )
      tt = sprintf('Fehler in Include directory hinzufügen: \n%s',errText);
      error('%s_error: %s',mfilename,tt);
    end
    modifyflag = 1;
  end
end
function [vcproj_root,modifyflag] = VC9_build_sln_vcproj_add_lib_files(vcproj_root,lib_files)
  % Sucht die den Zweig (Children) in 'VisualStudioProject.Files.Filter'
  % mit Attribut Name='sources'
  %
  modifyflag = 0;
  % Release
  %--------
  [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcproj_root,'VisualStudioProject.Configurations.Configuration','a.Name.Release.valnotexact');

  % Hole davon alle mit attribut 'RelativePAth'
  [ll,ivec] = xml_struct_get_list_childs_w_attribute(fchilds,'AdditionalDependencies');
  [include_str,newflag] = VC9_build_sln_vcproj_check_lib_files_list(ll{1},lib_files);
  if( newflag )
    fchilds = xml_struct_set_attribute_to_children(fchilds,ivec(1),'AdditionalDependencies',include_str);
    [vcproj_root,okay,errText] = xml_struct_set_children(vcproj_root,fchilds,'VisualStudioProject.Configurations.Configuration','a.Name.Release.valnotexact',1);
    if( ~okay )
      tt= sprintf('Fehler in AdditionalDependencies hinzufügen: \n%s',errText);
      error('%s_error: %s',mfilename,tt);
    end
    modifyflag = 1;
  end
  % Debug
  %------
  [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcproj_root,'VisualStudioProject.Configurations.Configuration','a.Name.Debug.valnotexact');

  % Hole davon alle mit attribut 'RelativePAth'
  [ll,ivec] = xml_struct_get_list_childs_w_attribute(fchilds,'AdditionalDependencies');
  [include_str,newflag] = VC9_build_sln_vcproj_check_lib_files_list(ll{1},lib_files);
  if( newflag )
    fchilds = xml_struct_set_attribute_to_children(fchilds,ivec(1),'AdditionalDependencies',include_str);
    [vcproj_root,okay,errText] = xml_struct_set_children(vcproj_root,fchilds,'VisualStudioProject.Configurations.Configuration','a.Name.Debug.valnotexact',1);
    if( ~okay )
      tt= sprintf('Fehler in AdditionalDependencies hinzufügen: \n%s',errText);
      error('%s_error: %s',mfilename,tt);
    end
    modifyflag = 1;
  end
end
function [vcproj_root,modifyflag] = VC9_build_sln_vcproj_add_lib_dirs(vcproj_root,lib_dirs,proj_dir)
  % Sucht die den Zweig (Children) in 'VisualStudioProject.Configurations.Configuration'
  % mit Attribut Name='AdditionalIncludeDirectories'
  %
  modifyflag = 0;
  % Release
  %--------
  [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcproj_root,'VisualStudioProject.Configurations.Configuration','a.Name.Release.valnotexact');

  % Hole davon alle mit attribut 'RelativePAth'
  [ll,ivec] = xml_struct_get_list_childs_w_attribute(fchilds,'AdditionalLibraryDirectories');
  [include_str,newflag] = VC9_build_sln_vcproj_check_lib_dirs(ll{1},lib_dirs,proj_dir);
  if( newflag )
    fchilds = xml_struct_set_attribute_to_children(fchilds,ivec(1),'AdditionalLibraryDirectories',include_str);
    [vcproj_root,okay,errText] = xml_struct_set_children(vcproj_root,fchilds,'VisualStudioProject.Configurations.Configuration','a.Name.Release.valnotexact',1);
    if( ~okay )
      tt= sprintf('Fehler in Library directory hinzufügen: \n%s',errText);
      error('%s_error: %s',mfilename,tt);
    end
    modifyflag = 1;
  end
  % Debug
  %------
  [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcproj_root,'VisualStudioProject.Configurations.Configuration','a.Name.Debug.valnotexact');

  % Hole davon alle mit attribut 'RelativePAth'
  [ll,ivec] = xml_struct_get_list_childs_w_attribute(fchilds,'AdditionalLibraryDirectories');
  [include_str,newflag] = VC9_build_sln_vcproj_check_lib_dirs(ll{1},lib_dirs,proj_dir);
  if( newflag )
    fchilds = xml_struct_set_attribute_to_children(fchilds,ivec(1),'AdditionalLibraryDirectories',include_str);
    [vcproj_root,okay,errText] = xml_struct_set_children(vcproj_root,fchilds,'VisualStudioProject.Configurations.Configuration','a.Name.Debug.valnotexact',1);
    if( ~okay )
      tt= sprintf('Fehler in Lirary directory hinzufügen: \n%s',errText);
      error('%s_error: %s',mfilename,tt);
    end
    modifyflag = 1;
  end
end
%==========================================================================
%==========================================================================
function ss = VC9_build_sln_vcproj_get_path_struct(proj_dir,ll)
  ss = [];
  n = length(ll);
  for i=1:n
    s = str_get_pfe_f(ll{i});
     
    ss(i).file_name = [s.name,'.',s.ext];
     
    if( is_abs_dir(s.dir) )
      ss(i).abs_dir   = s.dir;
      ss(i).rel_dir   = get_rel_dir(s.dir,proj_dir);
    else
      ss(i).abs_dir   = get_abs_dir(s.dir,proj_dir);
      ss(i).rel_dir   = s.dir;
    end
  end
end
function ss_add   = VC9_build_sln_vcproj_check_source_files(ss_exist,ss_new)
  n_exist = length(ss_exist);
  n_new   = length(ss_new);
  n_add   = 0;
  
  % ss_add  = struct('file_name','','rel_dir','','abs_dir','');
  for i=1:n_new
    flag = 1;
    for j=1:n_exist
      if( strcmpi(ss_exist(j).file_name,ss_new(i).file_name) )
        flag = 0;
        break;
      end
    end
    if( flag )
      n_add         = n_add+1;
      ss_add(n_add) = ss_new(i);
    end
  end
  if( ~exist('ss_add','var') )
    ss_add = struct([]);
  end
end
function children = VC9_build_sln_vcproj_set_children(children,ss_add)

  n0        = length(children);
  n         = length(ss_add);
  if( n0 == 0 )
    allocCell = cell(1, n);

    children  = struct(             ...
                'Name', allocCell, 'Attributes', allocCell,    ...
                'Data', allocCell, 'Children', allocCell);
  end            
  for i = 1:n
    
    children(i+n0).Name = 'File';
    children(i+n0).Attributes(1).Name  = 'RelativePath';
    children(i+n0).Attributes(1).Value = fullfile(ss_add(i).rel_dir,ss_add(i).file_name);
  end
  
end
function [include_string,newflag] = VC9_build_sln_vcproj_check_include_list(include_string,include_list,proj_dir)
%
% ss(i).abs_dir
% ss(i).rel_dir
%
  n = length(include_list);
  for i=1:n     
    if( is_abs_dir(include_list{i}) )
      ss(i).abs_dir   = include_list{i};
      [ss(i).rel_dir,okay]   = get_rel_dir(include_list{i},proj_dir);
      if( ~okay ), ss(i).rel_dir = ss(i).abs_dir;end
    else
      ss(i).abs_dir   = get_abs_dir(include_list{i},proj_dir);
      ss(i).rel_dir   = include_list{i};
    end
  end

  newflag = 0;
  ll = str_split(include_string,';');
  ns = length(ss);
  n  = length(ll);
  add_list = {};
  for i = 1:ns
    flag = 1;
    for j=1:n
      if( is_abs_dir(ll{j}) )        
        if( dircmpi(ss(i).abs_dir,ll{j}) )
          flag = 0;
        end
      else
        if( dircmpi(ss(i).rel_dir,ll{j}) )
          flag = 0;
        end
      end
    end
    if( flag )
      add_list = cell_add(add_list,ss(i).rel_dir);
    end
  end
  if( ~isempty(add_list) )
    ll = cell_add(ll,add_list);
    include_string = str_compose(ll,';');
    newflag = 1;
  end
end
function [ppd_string,newflag] = VC9_build_sln_vcproj_check_ppd_list(ppd_string,ppd_list)
%
%
  newflag = 0;
  ll = str_split(ppd_string,';');
  np = length(ppd_list);
  n  = length(ll);
  add_list = {};
  for i = 1:np
    flag = 1;
    for j=1:n
      if( strcmp(ppd_list{i},ll{j}) )
        flag = 0;
        break;
      end
    end
    if( flag )
      add_list = cell_add(add_list,ppd_list{i});
    end
  end
  if( ~isempty(add_list) )
    ll = cell_add(ll,add_list);
    ppd_string = str_compose(ll,';');
    newflag = 1;
  end
end
function [lib_files_string,newflag] = VC9_build_sln_vcproj_check_lib_files_list(lib_files_string,lib_files)
%
% ss(i).abs_dir
% ss(i).rel_dir
%
  newflag = 0;
  ll = str_split(lib_files_string,' ');
  ns = length(lib_files);
  n  = length(ll);
  add_list = {};
  for i = 1:ns
    flag = 1;
    for j=1:n
      if( strcmpi(lib_files(i),ll{j}) )
        flag = 0;
        break;
      end
    end
    if( flag )
      add_list = cell_add(add_list,lib_files(i));
    end
  end
  if( ~isempty(add_list) )
    ll = cell_add(ll,add_list);
    lib_files_string = str_compose(ll,' ');
    newflag = 1;
  end
end
function [lib_dirs_string,newflag] = VC9_build_sln_vcproj_check_lib_dirs(lib_dirs_string,include_list,proj_dir)
%
% ss(i).abs_dir
% ss(i).rel_dir
%
  n = length(include_list);
  for i=1:n     
    if( is_abs_dir(include_list{i}) )
      ss(i).abs_dir   = include_list{i};
      [ss(i).rel_dir,okay]   = get_rel_dir(include_list{i},proj_dir);
      if( ~okay ), ss(i).rel_dir = ss(i).abs_dir;end
    else
      ss(i).abs_dir   = get_abs_dir(include_list{i},proj_dir);
      ss(i).rel_dir   = include_list{i};
    end
  end

  newflag = 0;
  ll = str_split(lib_dirs_string,',');
  ns = length(ss);
  n  = length(ll);
  add_list = {};
  for i = 1:ns
    flag = 1;
    for j=1:n
      if( is_abs_dir(ll{j}) )        
        if( dircmpi(ss(i).abs_dir,ll{j}) )
          flag = 0;
        end
      else
        if( dircmpi(ss(i).rel_dir,ll{j}) )
          flag = 0;
        end
      end
    end
    if( flag )
      add_list = cell_add(add_list,ss(i).rel_dir);
    end
  end
  if( ~isempty(add_list) )
    ll = cell_add(ll,add_list);
    lib_dirs_string = str_compose(ll,',');
    newflag = 1;
  end
end
