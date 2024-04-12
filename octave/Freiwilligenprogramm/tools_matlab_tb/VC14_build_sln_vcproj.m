function [okay,errtext] = VC14_build_sln_vcproj(vcsln_file,vcxproj_file,vcfilters_file ...
                                               ,use_vc_files,vc_sln_write,proj_name ...
                                               ,csrc_files,incl_dirs,preproc_defs,lib_files,lib_dirs ...
                                               ,sln_proto,vcxproj_proto,vcfilters_proto)
%
% [okay,errtext] = VC14_build_sln_vcproj(vcsln_file,vcxproj_file,vcfilters_file ...
%                                       ,use_vc_files,proj_name ...
%                                       ,csrc_files,incl_dirs,preproc_defs,lib_files,lib_dirs,vc_sln_write)
%
% Erstellt oder Editiert 
% vcsln_file
% vcxproj_file
% vcfilters_file
% use_vc_files      0: Namen mit dem proj_name und mit den cell-arrayListen
%                   1: übergebene Namen verwenden
% vc_sln_write      0: schreibe kein sln-File 
%                   1: schreibe ein sln-File
% aus:
% csrc_files        cell array mit source-Files und header-Files mit Filtername {src_files,filtername}
% incl_dirs         include-Dorectories
% preproc_defs      Preprocessor -Defines
% lib_files         library-Files
% lib_dirs          library-dirs
%
% Wenn vcsln_file,vcproj_file noch nicht vorhanden, werden diese aus
% all/src mit VC14_MEX_VPU_CAN_SIM.sln und VC14_MEX_VPU_CAN_SIM.vcproj
% gebildet
%
%
  okay           = 1;
  errtext        = '';
  VC_FILTER_NAME = 'source';
  %========================================================================
  if( ~use_vc_files )
    % Files generieren, wenn nicht vorhanden
%     f = mfilename('fullpath');
%     s_file = str_get_pfe_f(f);
%     sln_proto       = fullfile(s_file.dir,'src_modul','VC14_MEX_VPU_CAN_SIM.sln');
%     vcxproj_proto   = fullfile(s_file.dir,'src_modul','VC14_MEX_VPU_CAN_SIM.vcxproj');
%     vcfilters_proto = fullfile(s_file.dir,'src_modul','VC14_MEX_VPU_CAN_SIM.vcxproj.filters');

    if( exist(vcxproj_file,'file') )
      delete(vcxproj_file);
    end
    if( exist(vcfilters_file,'file') )
      delete(vcfilters_file);
    end
  else
    sln_proto       = vcsln_file;
    vcxproj_proto   = vcxproj_file;
    vcfilters_proto = vcfilters_file;
  end
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
  % if( ~exist(vcproj_file,'file') )
    
  if( ~exist(vcxproj_proto,'file') )
    error('%s_error: Das VC-project-Prototype-File %s ist nicht vorhanden !!!',mfilename,vcxproj_proto);
  end
  [okay,c,nc] = read_ascii_file(vcxproj_proto);
  if( ~okay )
    error('%s_error: Datei %s konnte nicht eingelsen werden',mfilename,vcxproj_proto);
  end
  % Projekt-Namen einsetzen
  c = cell_change(c,'#PROJECT_NAME#',proj_name);
  write_ascii_file(vcxproj_file,c);
  % end
  if( ~exist(vcfilters_proto,'file') )
    error('%s_error: Das VC-project-Prototype-File %s ist nicht vorhanden !!!',mfilename,vcfilters_proto);
  end
  [okay,c,nc] = read_ascii_file(vcfilters_proto);
  if( ~okay )
    error('%s_error: Datei %s konnte nicht eingelsen werden',mfilename,vcfilters_proto);
  end
  % Projekt-Namen einsetzen
  c = cell_change(c,'#PROJECT_NAME#',proj_name);
  write_ascii_file(vcfilters_file,c);
 
  %========================================================================
  % proj_dir
  %---------
  s_file = str_get_pfe_f(vcxproj_file);
  proj_dir = s_file.dir;
  
  %========================================================================
  % vcxproj-xml einlesen
  %--------------------
  vcfilters_root = xml_read_build_struct(vcfilters_file);
  vcx_root = xml_read_build_struct(vcxproj_file);
  
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
      src_files{i}  = csrc_files{i};
      src_filter{i} = VC_FILTER_NAME;
    elseif( iscell(csrc_files{i}) && (length(csrc_files{i}) == 1) )
      src_files{i}  = csrc_files{i}{1};
      src_filter{i} = VC_FILTER_NAME;
    else
      src_files{i}  = csrc_files{i}{1};
      src_filter{i} = csrc_files{i}{2};
    end
  end
  
  % structure sorted by filter
  n = length(src_files);
  s.filter = src_filter{1};
  s.liste  = {src_files{1}};
  for i = 2:n
    jj = 0;
    for j=1:length(s)
      if( strcmpi(src_filter{i},s(j).filter) )
        jj = j;
        break;
      end
    end
    if( jj == 0 )
      s(length(s)+1).filter = src_filter{i};
      s(length(s)).liste    = {src_files{i}};
    else
      s(jj).liste = cell_add(s(jj).liste,src_files{i});
    end
  end

  [vcfilters_root,mm] = VC14_build_sln_vcprojfilter_add_sources(vcfilters_root,s);
  if( mm ),modifyflag = 1;end
  
  [vcx_root,mm]       = VC14_build_sln_vcproj_add_sources(vcx_root,s);
  if( mm ),modifyflag = 1;end
  %========================================================================
  % includes überprüfen und hinzufügen
  %----------------------------------
  [vcx_root,mm] = VC14_build_sln_vcproj_add_includes(vcx_root,incl_dirs,proj_dir);
  if( mm ),modifyflag = 1;end
  
  %========================================================================
  % preprocess_defs überprüfen und hinzufügen
  %----------------------------------
  [vcx_root,mm] = VC14_build_sln_vcproj_add_preprocessdef(vcx_root,preproc_defs);
  if( mm ),modifyflag = 1;end

  %========================================================================
  % lib_files überprüfen und hinzufügen
  %----------------------------------
  [vcx_root,mm] = VC14_build_sln_vcproj_add_lib_files(vcx_root,lib_files);
  if( mm ),modifyflag = 1;end

  %========================================================================
  % lib_dirs überprüfen und hinzufügen
  %----------------------------------
  [vcx_root,mm] = VC14_build_sln_vcproj_add_lib_dirs(vcx_root,lib_dirs,proj_dir);
  if( mm ),modifyflag = 1;end

  %==========================================================================
  % vcproj schreiben
  %-----------------
  if( modifyflag )
    okay = xml_struct_write_to_xml(vcfilters_file,vcfilters_root);
    okay = xml_struct_write_to_xml(vcxproj_file,vcx_root);
  end
  
end
function [vcfilters_root,modifyflag] = VC14_build_sln_vcprojfilter_add_sources(vcfilters_root,s)
  % Sucht die den Zweig (Children) in 'VisualStudioProject.Files.Filter'
  % mit Attribut Name='sources'
  %
  modifyflag = 0;
  n = length(s);

  % Filterliste in vcfilter erweitern
  [vcfilters_root,okay,errtext,mm] = VC14_build_sln_vcprojfilter_add_filter_list(vcfilters_root,s);
  if( mm ),modifyflag = 1;end
  if( ~okay )
      tt = sprintf('Fehler in VC14_build_sln_vcproj_find_filter_list: \n%s',errtext);
      error('%s_error: %s',mfilename,tt);
  end
  [vcfilters_root,okay,errtext,mm] = VC14_build_sln_vcprojfilter_add_file_list(vcfilters_root,s);
  if( mm ),modifyflag = 1;end
  if( ~okay )
      tt = sprintf('Fehler in VC14_build_sln_vcproj_find_file_list: \n%s',errtext);
      error('%s_error: %s',mfilename,tt);
  end
%   for i = 1:n
%    src_file_liste = s(i).liste;
%    src_filter     = s(i).filter;
%    
%    % Filter suchen
%    [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcfilters_root,'Project.ItemGroup.Filter','');
%    if( ~okay )
%      clear add_child
%      add_child.Name             = 'Filter';
%      add_child.Attributes(1).Name  = 'Filter';
%      add_child.Attributes(1).Value = 'cpp;c;cc;cxx;def;odl;idl;hpj;bat;asm;asmx';
%      add_child.Attributes(2).Name  = 'Name';
%      add_child.Attributes(2).Value = src_filter;
%      add_child.Data             = '';
%      add_child.Children         = [];
%      [vcfilters_root,okay,errText] = xml_add_children(vcfilters_root,add_child,'VisualStudioProject.Files');
%      % Nochmal um fchilds zu bekommen
%      [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcfilters_root,'VisualStudioProject.Files.Filter',['a.Name.',src_filter]);
%    end
%    
%    % Hole davon alle mit attribut 'RelativePAth'
%    source_list = xml_struct_get_list_childs_w_attribute(fchilds,'RelativePath');
%    
%    % Suche die hinzuzufügenden Sourcen
%    ss_exist = VC14_build_sln_vcproj_get_path_struct(proj_dir,source_list);
%    ss_new   = VC14_build_sln_vcproj_get_path_struct(proj_dir,src_file_liste);
%    ss_add   = VC14_build_sln_vcproj_check_source_files(ss_exist,ss_new);
% 
%    if( ~isempty(ss_add) )
%     fchilds        = VC14_build_sln_vcproj_set_children(fchilds,ss_add);
%     [vcfilters_root,okay,errText] = xml_struct_set_children(vcfilters_root,fchilds,'VisualStudioProject.Files.Filter',['a.Name.',src_filter],1);
%     if( ~okay )
%       tt = sprintf('Fehler in Sourcen hinzufügen: \n%s',errText);
%       error('%s_error: %s',mfilename,tt);
%     end
%     modifyflag = 1;
%    end
%   end
%   
%   [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcfilters_root,'VisualStudioProject.Files.Filter','a.Name.sources');
%   if( ~okay )
%     clear add_child
%     add_child.Name             = 'Filter';
%     add_child.Attributes(1).Name  = 'Filter';
%     add_child.Attributes(1).Value = 'cpp;c;cc;cxx;def;odl;idl;hpj;bat;asm;asmx';
%     add_child.Attributes(2).Name  = 'Name';
%     add_child.Attributes(2).Value = 'sources';
%     add_child.Data             = '';
%     add_child.Children         = [];
%     [vcfilters_root,okay,errText] = xml_struct_add_children(vcfilters_root,add_child,'VisualStudioProject.Files');
%     % Nochmal um fchilds zu bekommen
%     [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcfilters_root,'VisualStudioProject.Files.Filter','a.Name.sources');
%   end
%   % Hole davon alle mit attribut 'RelativePAth'
%   source_list = xml_struct_get_list_childs_w_attribute(fchilds,'RelativePath');
%   
%   % Suche die hinzuzufügenden Sourcen
%   ss_exist = VC14_build_sln_vcproj_get_path_struct(proj_dir,source_list);
%   ss_new   = VC14_build_sln_vcproj_get_path_struct(proj_dir,source_files);
%   ss_add   = VC14_build_sln_vcproj_check_source_files(ss_exist,ss_new);
%   
%   if( ~isempty(ss_add) )
%     fchilds        = VC14_build_sln_vcproj_set_children(fchilds,ss_add);
%     [vcfilters_root,okay,errText] = xml_struct_set_children(vcfilters_root,fchilds,'VisualStudioProject.Files.Filter','a.Name.sources',1);
%     if( ~okay )
%       tt = sprintf('Fehler in Sourcen hinzufügen: \n%s',errText);
%       error('%s_error: %s',mfilename,tt);
%     end
%     modifyflag = 1;
%   end
end
function [vcfilters_root,okay,errtext,modifyflag] = VC14_build_sln_vcprojfilter_add_filter_list(vcfilters_root,s)
  
  modifyflag = 0;
  % übergeordnete Struktur mit den Filtern bekommen
  [S,Sindexvec,okay,errtext] = xml_struct_get_parent_from_children_with_Name(vcfilters_root,'Project.ItemGroup.Filter');
  if( ~okay )
    return;
  end
  cliste = {};
  data   = '';
  % find first 'UniqueIdentifier' to build new ones by addtion by 1
  if( ~isempty(S) )
    [fchilds,okay,errtext] = xml_struct_find_all_children_with_Name_in_childs(S,'Filter');
    if( ~okay )
      return;
    end
    [cliste,ivec]  = xml_struct_get_list_childs_w_attribute(fchilds,'Include');
    if( ~isempty(fchilds) )
      [data,index]   = xml_struct_get_data_list_from_child(fchilds(length(fchilds)),'UniqueIdentifier');
    end
  end
  
  % cliste mit s(i).filter vergleichen
  iadd = 0;
  for i=1:length(s)
    ifound  = cell_find_f(cliste,s(i).filter,'fl');
    % wenn dafür ist kein Filter angelegt
    if( isempty(ifound) )
      modifyflag = 1;
      % unique Idetifier
      iadd = iadd + 1;
      uniqued = VC14_build_sln_vcprojfilter_build_unique_ident(data,iadd);
      childs  = xml_struct_build_node('Name','UniqueIdentifier','Data',uniqued);      
      attrib = xml_struct_build_attributes('Name','Include','Value',s(i).filter);
      child = xml_struct_build_node('Name','Filter','Attributes',attrib,'Children',childs);
      [vcfilters_root,okay,errtext] = xml_struct_add_child_to_node_by_index(vcfilters_root,Sindexvec,child);
      if( ~okay )
        return;
      end
    end
  end
end
function uniqued = VC14_build_sln_vcprojfilter_build_unique_ident(data,iadd)

  if( isempty(data) )
    data = '{67DA6AB6-F800-4c08-8B7A-83BB121AAD00}';
  end
  cdata = str_get_quot_f(data,'{','}','i');
  cdata = str_split(cdata{1},'-');
  n     = length(cdata);
  data  = cdata{n};
  
  number = hex2dec(data)+iadd;
  
  data   = dec2hex(number);
  
  cdata{n} = data;
  
  uniqued = '{';
  for i=1:n
    uniqued = [uniqued,cdata{i}];
    if( i < n )
      uniqued = [uniqued,'-'];
    else
      uniqued = [uniqued,'}'];
    end
  end
  
end
function [vcfilters_root,okay,errtext,modifyflag] = VC14_build_sln_vcprojfilter_add_file_list(vcfilters_root,s)
  modifyflag = 1;
  % vorhandene Fileliste löschen
  found = 1;
  while(found)
    [S,Sindexvec,okay,errtext] = xml_struct_get_parent_from_children_with_Name(vcfilters_root,'Project.ItemGroup.ClCompile');
    if( ~isempty(Sindexvec) )
      [vcfilters_root,okay,errtext] = xml_struct_delete_node_by_index(vcfilters_root,Sindexvec);
    else
      found = 0;
    end
  end
  found = 1;
  while(found)
    [S,Sindexvec,okay,errtext] = xml_struct_get_parent_from_children_with_Name(vcfilters_root,'Project.ItemGroup.ClInclude');
    if( ~isempty(Sindexvec) )
      [vcfilters_root,okay,errtext] = xml_struct_delete_node_by_index(vcfilters_root,Sindexvec);
    else
      found = 0;
    end
  end
  
  % File aus der Liste einsortieren
% <Project ToolsVersion="4.0" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
%   <ItemGroup>
%     <ClCompile Include="src\fkt_EMODUL_SIM.cpp">
%       <Filter>appl</Filter>
%     </ClCompile>
%   </ItemGroup>
%   <ItemGroup>
%     <ClInclude Include="src\fkt_EMODUL_SIM.h">
%       <Filter>appl</Filter>
%     </ClInclude>
%   </ItemGroup>
% </Project>

  % übergeordnete Struktur von ItemGroup bekommen
  [S,Sindexvec,okay,errtext] = xml_struct_get_parent_from_children_with_Name(vcfilters_root,'Project.ItemGroup');
  if( ~okay )
    return;
  end
  % add files
  if( isempty(S) )
    okay = 0;
    errtext = sprintf('Project.ItemGroup not found in vcfilters_root');
    return
  else

    ItemGroupNode = xml_struct_build_node('Name','ItemGroup');
    for i=1:length(s)

      % build filter child-node
      FilterChild   = xml_struct_build_node('Name','Filter','Data',s(i).filter);  
        
      % ItemGroup with file
      for j=1:length(s(i).liste)
        
        s_file = str_get_pfe_f(s(i).liste{j});
        
        if( strcmpi(s_file.ext,'h') )
          nodeName = 'ClInclude';
        else
          nodeName = 'ClCompile';
        end
      
        attrib = xml_struct_build_attributes('Name','Include','Value',s(i).liste{j});
        child = xml_struct_build_node('Name',nodeName,'Attributes',attrib,'Children',FilterChild);
        
        [ItemGroupNode,okay,errtext] = xml_struct_add_child_to_node_by_index(ItemGroupNode,1,child);
      end
    end  
    [vcfilters_root,okay,errtext] = xml_struct_add_child_to_node_by_index(vcfilters_root,Sindexvec,ItemGroupNode);
  end
end     
function [vcx_root,modifyflag] = VC14_build_sln_vcproj_add_sources(vcx_root,s)
  % Sucht die den Zweig (Children) in 'VisualStudioProject.Files.Filter'
  % mit Attribut Name='sources'
  %
  modifyflag = 1;
  % vorhandene Fileliste löschen
  found = 1;
  while(found)
    [S,Sindexvec,okay,errtext] = xml_struct_get_parent_from_children_with_Name(vcx_root,'Project.ItemGroup.ClCompile');
    if( ~okay )
        tt = sprintf('Fehler in xml_struct_get_parent_from_children_with_Name: \n%s',errtext);
        error('%s_error: %s',mfilename,tt);
    end
    if( ~isempty(Sindexvec) )
      [vcx_root,okay,errtext] = xml_struct_delete_node_by_index(vcx_root,Sindexvec);
      if( ~okay )
          tt = sprintf('Fehler in xml_struct_delete_node_by_index: \n%s',errtext);
          error('%s_error: %s',mfilename,tt);
      end
    else
      found = 0;
    end
  end
  found = 1;
  while(found)
    [S,Sindexvec,okay,errtext] = xml_struct_get_parent_from_children_with_Name(vcx_root,'Project.ItemGroup.ClInclude');
    if( ~okay )
        tt = sprintf('Fehler in xml_struct_get_parent_from_children_with_Name: \n%s',errtext);
        error('%s_error: %s',mfilename,tt);
    end
    if( ~isempty(Sindexvec) )
      [vcx_root,okay,errtext] = xml_struct_delete_node_by_index(vcx_root,Sindexvec);
      if( ~okay )
          tt = sprintf('Fehler in xml_struct_delete_node_by_index: \n%s',errtext);
          error('%s_error: %s',mfilename,tt);
      end
    else
      found = 0;
    end
  end
  
  % File aus der Liste einsortieren
% <Project ToolsVersion="4.0" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
%   <ItemGroup>
%     <ClCompile Include="src\fkt_EMODUL_SIM.cpp">
%     </ClCompile>
%   </ItemGroup>
%   <ItemGroup>
%     <ClInclude Include="src\fkt_EMODUL_SIM.h">
%     </ClInclude>
%   </ItemGroup>
% </Project>

  % übergeordnete Struktur von ItemGroup bekommen
  [S,Sindexvec,okay,errtext] = xml_struct_get_parent_from_children_with_Name(vcx_root,'Project.ItemGroup');
  if( ~okay )
      tt = sprintf('Fehler in xml_struct_get_parent_from_children_with_Name: \n%s',errtext);
      error('%s_error: %s',mfilename,tt);
  end
  % add files
  if( isempty(S) )
    errtext = sprintf('Project.ItemGroup not found in vcfilters_root');
    tt = sprintf('Fehler: \n%s',errtext);
    error('%s_error: %s',mfilename,tt);   
  else

    for i=1:length(s)

      % ItemGroup with file
      for j=1:length(s(i).liste)
        
        s_file = str_get_pfe_f(s(i).liste{j});
        
        if( strcmpi(s_file.ext,'h') )
          nodeName = 'ClInclude';
        else
          nodeName = 'ClCompile';
        end
      
        attrib = xml_struct_build_attributes('Name','Include','Value',s(i).liste{j});
        child  = xml_struct_build_node('Name',nodeName,'Attributes',attrib);
        parent = xml_struct_build_node('Name','ItemGroup','Children',child);
        [vcx_root,okay,errtext] = xml_struct_add_child_to_node_by_index(vcx_root,Sindexvec,parent);
        if( ~okay )
            tt = sprintf('Fehler in xml_struct_add_child_to_node_by_index: \n%s',errtext);
            error('%s_error: %s',mfilename,tt);
        end
      end
    end  
  end
end
function [vcx_root,modifyflag] = VC14_build_sln_vcproj_add_includes(vcx_root,include_list,proj_dir)
  % Sucht die den Zweig (Children) in 'VisualStudioProject.Configurations.Configuration'
  % mit Attribut Name='AdditionalIncludeDirectories'
  %
  modifyflag = 0;
  % Release
  %--------
  [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcx_root,'Project.ItemDefinitionGroup','a.Condition.Release.valnotexact');

  % ClCompile suchen
  for i=1:length(fchilds)
    if( strcmpi(fchilds(i).Name,'ClCompile') )
      [data,index] = xml_struct_get_data_list_from_child(fchilds(i),'AdditionalIncludeDirectories');
      %[ll,ivec] = xml_struct_get_list_childs_w_attribute(fchilds,'AdditionalIncludeDirectories');
      [include_str,newflag] = VC14_build_sln_vcproj_check_include_list(data,include_list,proj_dir);
      if( newflag )
        fchilds                 = xml_struct_set_data_to_child(fchilds,i,'AdditionalIncludeDirectories',include_str);
        [vcx_root,okay,errText] = xml_struct_set_children(vcx_root,fchilds,'Project.ItemDefinitionGroup','a.Condition.Release.valnotexact',1);
        if( ~okay )
         tt= sprintf('Fehler in Include directory hinzufügen: \n%s',errText);
         error('%s_error: %s',mfilename,tt);
        end
        modifyflag = 1;
      end
      break;
    end
  end
  % Debug
  %------
  [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcx_root,'Project.ItemDefinitionGroup','a.Condition.Debug.valnotexact');

  % ClCompile suchen
  for i=1:length(fchilds)
    if( strcmpi(fchilds(i).Name,'ClCompile') )
      [data,index] = xml_struct_get_data_list_from_child(fchilds(i),'AdditionalIncludeDirectories');
      %[ll,ivec] = xml_struct_get_list_childs_w_attribute(fchilds,'AdditionalIncludeDirectories');
      [include_str,newflag] = VC14_build_sln_vcproj_check_include_list(data,include_list,proj_dir);
      if( newflag )
        fchilds                 = xml_struct_set_data_to_child(fchilds,i,'AdditionalIncludeDirectories',include_str);
        [vcx_root,okay,errText] = xml_struct_set_children(vcx_root,fchilds,'Project.ItemDefinitionGroup','a.Condition.Debug.valnotexact',1);
        if( ~okay )
         tt= sprintf('Fehler in Include directory hinzufügen: \n%s',errText);
         error('%s_error: %s',mfilename,tt);
        end
        modifyflag = 1;
      end
      break;
    end
  end
  
end
function [vcx_root,modifyflag] = VC14_build_sln_vcproj_add_preprocessdef(vcx_root,ppd_list)
  % Sucht die den Zweig (Children) in 'VisualStudioProject.Configurations.Configuration'
  % mit Attribut Name='AdditionalIncludeDirectories'
  %
  modifyflag = 0;
  % Release
  %--------
  [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcx_root,'Project.ItemDefinitionGroup','a.Condition.Release.valnotexact');

  for i=1:length(fchilds)
    if( strcmpi(fchilds(i).Name,'ClCompile') )
      [data,index] = xml_struct_get_data_list_from_child(fchilds(i),'PreprocessorDefinitions');
      %[ll,ivec] = xml_struct_get_list_childs_w_attribute(fchilds,'AdditionalIncludeDirectories');
      [ppd_str,newflag] = VC14_build_sln_vcproj_check_ppd_list(data,ppd_list);
      if( newflag )
        fchilds                 = xml_struct_set_data_to_child(fchilds,i,'PreprocessorDefinitions',ppd_str);
        [vcx_root,okay,errText] = xml_struct_set_children(vcx_root,fchilds,'Project.ItemDefinitionGroup','a.Condition.Release.valnotexact',1);
        if( ~okay )
         tt= sprintf('Fehler in preprocessdef hinzufügen: \n%s',errText);
         error('%s_error: %s',mfilename,tt);
        end
        modifyflag = 1;
      end
      break;
    end
  end
  % Debug
  %------
  [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcx_root,'Project.ItemDefinitionGroup','a.Condition.Debug.valnotexact');

  for i=1:length(fchilds)
    if( strcmpi(fchilds(i).Name,'ClCompile') )
      [data,index] = xml_struct_get_data_list_from_child(fchilds(i),'PreprocessorDefinitions');
      %[ll,ivec] = xml_struct_get_list_childs_w_attribute(fchilds,'AdditionalIncludeDirectories');
      [ppd_str,newflag] = VC14_build_sln_vcproj_check_ppd_list(data,ppd_list);
      if( newflag )
        fchilds                 = xml_struct_set_data_to_child(fchilds,i,'PreprocessorDefinitions',ppd_str);
        [vcx_root,okay,errText] = xml_struct_set_children(vcx_root,fchilds,'Project.ItemDefinitionGroup','a.Condition.Debug.valnotexact',1);
        if( ~okay )
         tt= sprintf('Fehler in preprocessdef hinzufügen: \n%s',errText);
         error('%s_error: %s',mfilename,tt);
        end
        modifyflag = 1;
      end
      break;
    end
  end
end
function [vcx_root,modifyflag] = VC14_build_sln_vcproj_add_lib_files(vcx_root,lib_files)
  % Sucht die den Zweig (Children) in 'VisualStudioProject.Files.Filter'
  % mit Attribut Name='sources'
  %
  modifyflag = 0;
  % Release
  %--------
  [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcx_root,'Project.ItemDefinitionGroup','a.Condition.Release.valnotexact');

  for i=1:length(fchilds)
    if( strcmpi(fchilds(i).Name,'Link') )
      [data,index] = xml_struct_get_data_list_from_child(fchilds(i),'AdditionalDependencies');
      %[ppd_str,newflag] = VC14_build_sln_vcproj_check_ppd_list(data,ppd_list);
      [include_str,newflag] = VC14_build_sln_vcproj_check_lib_files_list(data,lib_files);
      if( newflag )
        fchilds                 = xml_struct_set_data_to_child(fchilds,i,'AdditionalDependencies',include_str);
        [vcx_root,okay,errText] = xml_struct_set_children(vcx_root,fchilds,'Project.ItemDefinitionGroup','a.Condition.Release.valnotexact',1);
        if( ~okay )
         tt= sprintf('Fehler in AdditionalDependencies hinzufügen: \n%s',errText);
         error('%s_error: %s',mfilename,tt);
        end
        modifyflag = 1;
      end
      break;
    end
  end
  % Debug
  %------
  [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcx_root,'Project.ItemDefinitionGroup','a.Condition.Debug.valnotexact');

  for i=1:length(fchilds)
    if( strcmpi(fchilds(i).Name,'Link') )
      [data,index] = xml_struct_get_data_list_from_child(fchilds(i),'AdditionalDependencies');
      %[ppd_str,newflag] = VC14_build_sln_vcproj_check_ppd_list(data,ppd_list);
      [include_str,newflag] = VC14_build_sln_vcproj_check_lib_files_list(data,lib_files);
      if( newflag )
        fchilds                 = xml_struct_set_data_to_child(fchilds,i,'AdditionalDependencies',include_str);
        [vcx_root,okay,errText] = xml_struct_set_children(vcx_root,fchilds,'Project.ItemDefinitionGroup','a.Condition.Debug.valnotexact',1);
        if( ~okay )
         tt= sprintf('Fehler in AdditionalDependencies hinzufügen: \n%s',errText);
         error('%s_error: %s',mfilename,tt);
        end
        modifyflag = 1;
      end
      break;
    end
  end
end
function [vcx_root,modifyflag] = VC14_build_sln_vcproj_add_lib_dirs(vcx_root,lib_dirs,proj_dir)
  % Sucht die den Zweig (Children) in 'VisualStudioProject.Configurations.Configuration'
  % mit Attribut Name='AdditionalIncludeDirectories'
  %
  modifyflag = 0;
  % Release
  %--------
  [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcx_root,'Project.ItemDefinitionGroup','a.Condition.Release.valnotexact');

  for i=1:length(fchilds)
    if( strcmpi(fchilds(i).Name,'Link') )
      [data,index] = xml_struct_get_data_list_from_child(fchilds(i),'AdditionalLibraryDirectories');
      [include_str,newflag] = VC14_build_sln_vcproj_check_lib_dirs(data,lib_dirs,proj_dir);
      if( newflag )
        fchilds                 = xml_struct_set_data_to_child(fchilds,i,'AdditionalLibraryDirectories',include_str);
        [vcx_root,okay,errText] = xml_struct_set_children(vcx_root,fchilds,'Project.ItemDefinitionGroup','a.Condition.Release.valnotexact',1);
        if( ~okay )
         tt= sprintf('Fehler in AdditionalLibraryDirectories hinzufügen: \n%s',errText);
         error('%s_error: %s',mfilename,tt);
        end
        modifyflag = 1;
      end
      break;
    end
  end
  % Debug
  %------
  [fchilds,okay,errtext] = xml_struct_find_children_in_childs(vcx_root,'Project.ItemDefinitionGroup','a.Condition.Debug.valnotexact');

  for i=1:length(fchilds)
    if( strcmpi(fchilds(i).Name,'Link') )
      [data,index] = xml_struct_get_data_list_from_child(fchilds(i),'AdditionalLibraryDirectories');
      [include_str,newflag] = VC14_build_sln_vcproj_check_lib_dirs(data,lib_dirs,proj_dir);
      if( newflag )
        fchilds                 = xml_struct_set_data_to_child(fchilds,i,'AdditionalLibraryDirectories',include_str);
        [vcx_root,okay,errText] = xml_struct_set_children(vcx_root,fchilds,'Project.ItemDefinitionGroup','a.Condition.Debug.valnotexact',1);
        if( ~okay )
         tt= sprintf('Fehler in AdditionalLibraryDirectories hinzufügen: \n%s',errText);
         error('%s_error: %s',mfilename,tt);
        end
        modifyflag = 1;
      end
      break;
    end
  end
end
%==========================================================================
%==========================================================================
function ss = VC14_build_sln_vcproj_get_path_struct(proj_dir,ll)
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
function ss_add   = VC14_build_sln_vcproj_check_source_files(ss_exist,ss_new)
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
function children = VC14_build_sln_vcproj_set_children(children,ss_add)

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
function [include_string,newflag] = VC14_build_sln_vcproj_check_include_list(include_string,include_list,proj_dir)
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
  ll  = str_split(include_string,';');
  
  ns = length(ss);
  n  = length(ll);
  ill = cell_find_f(ll,'AdditionalIncludeDirectories','n');
  if( isempty(ill) )
    ill = n+1;
  end
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
    ll = cell_insert(ll,ill,add_list);
    include_string = str_compose(ll,';');
    newflag = 1;
  end
end
function [ppd_string,newflag] = VC14_build_sln_vcproj_check_ppd_list(ppd_string,ppd_list)
%
%
  newflag = 0;
  ll = str_split(ppd_string,';');
  np = length(ppd_list);
  n  = length(ll);
  ill = cell_find_f(ll,'PreprocessorDefinitions','n');
  if( isempty(ill) )
    ill = n+1;
  end
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
    ll = cell_insert(ll,ill,add_list);
    ppd_string = str_compose(ll,';');
    newflag = 1;
  end
end
function [lib_files_string,newflag] = VC14_build_sln_vcproj_check_lib_files_list(lib_files_string,lib_files)
%
% ss(i).abs_dir
% ss(i).rel_dir
%
  newflag = 0;
  ll = str_split(lib_files_string,';');
  ns = length(lib_files);
  n  = length(ll);
  ill = cell_find_f(ll,'AdditionalDependencies','n');
  if( isempty(ill) )
    ill = n+1;
  end
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
    ll = cell_insert(ll,ill,add_list);
    lib_files_string = str_compose(ll,';');
    newflag = 1;
  end
end
function [lib_dirs_string,newflag] = VC14_build_sln_vcproj_check_lib_dirs(lib_dirs_string,include_list,proj_dir)
%
% ss(i).abs_dir
% ss(i).rel_dir
%
  n = length(include_list);
  ss = [];
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
  ll = str_split(lib_dirs_string,';');
  ns = length(ss);
  n  = length(ll);
  ill = cell_find_f(ll,'AdditionalLibraryDirectories','n');
  if( isempty(ill) )
    ill = n+1;
  end
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
    ll = cell_insert(ll,ill,add_list);
    lib_dirs_string = str_compose(ll,';');
    newflag = 1;
  end
end
