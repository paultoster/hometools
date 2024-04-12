function Sim_def_build_c_var_def(s,outputfile)
%
% Sim_def_build_c_var_def(s)
% Sim_def_build_c_var_def(s,outputfile)
%
% outputfile            Name der Ausgabedatei
%
% Inputdefinition
%      s(i).type      = 'single';   'single'   'single','mBuffer'
%
%      s(i).type      = 'single'
%      s(i).varname   = 's.b';                                 Variablenname in C, kann auch Struktur sein
%      s(i).varformat = {'float','unsigned char'};  'float'    welcher C-Format-Typ paßt dazu
%      s(i).comment   = 'Test b';   ''         Kommentar
%
%
%      s(i).type      = 'mBuffer';   
%
%      s(i).varname   = 's.b';                                 Variablenname in C, kann auch Struktur sein
%      s(i).varformat  = {'float','unsigned char'};
%      s(i).varunit  = {'m','enum'};
%      s(i).length   = 200;
%      s(i).vecnames = {'length','dir'};
%                                               #define N_S_B_LENGTH 200
%                                               float s.b_length[N_S_B_LENGTH];
%                                               float s.b_dir[N_S_B_LENGTH];
%
% Wenn s(i).varname eine Stuktur ist, wird dafür eine Struktur angeleglt
%

  if( ~exist('outputfile','var') || isempty(outputfile) )
    outputfile = 'Ausgabe.dat';
  end

  n = length(s);
  variable_index_liste  = {};
  struct_name_liste   = {};
  struct_index_liste  = {};
  struct_var_liste    = {};
  for i = 1:n
    i0 = str_find_f(s(i).varname,'.','vs');
    
    if( i0 == 0 )
      variable_index_liste = cell_add(variable_index_liste,i);
    else
      structname = s(i).varname(1:max(1,i0-1));
      nn         = length(s(i).varname);
      varname    = s(i).varname(min(nn,i0+1):nn);
      ifound     = cell_find_f(struct_name_liste,structname,'f');
      if( ~isempty(ifound) ) % vorhanden
        index_liste = struct_index_liste{ifound(1)};
        index_liste = cell_add(index_liste,i);
        struct_index_liste{ifound(1)} = index_liste;
        
        var_liste = struct_var_liste{ifound(1)};
        var_liste = cell_add(var_liste,varname);
        struct_var_liste{ifound(1)} = var_liste;
      else
        struct_name_liste = cell_add(struct_name_liste,structname);
        struct_var_liste  = cell_add(struct_var_liste,{{varname}});
        struct_index_liste  = cell_add(struct_index_liste,{{i}});
      end
    end
  end  
  ctext = {};
  
  % Überschrift
  ctext = cell_add(ctext,'/*############################\n');
  ctext = cell_add(ctext,'  ## C-Var-Declaration       ##\n');
  ctext = cell_add(ctext,'############################*/\n');
  ntext = length(ctext);
  flag_ext = 1;
  for i=1:length(variable_index_liste)
    index = variable_index_liste{i};
    if( strcmp(s(index).type,'single') )
      [ctext,ntext] = Sim_def_build_c_var_def_variable_single(ctext,ntext,2,flag_ext,s(index).varname,s(index).varformat,s(index).comment);
    elseif( strcmp(s(index).type,'mBuffer') )
      [ctext,ntext] = Sim_def_build_c_var_def_variable_mBuffer(ctext,ntext,2,flag_ext,s(index).varname,s(index).varformat,s(index).vecnames,s(index).length,s(index).comment);
    end
  end
  for i=1:length(struct_name_liste)
    structname  = struct_name_liste{i};
    index_liste = struct_index_liste{i};
    var_liste = struct_var_liste{i};
    [ctext,ntext] = Sim_def_build_c_var_def_struct_start(ctext,ntext,2,flag_ext,structname);
    if( flag_ext )
      for j=1:length(index_liste)
        index         = index_liste{j};
        variable_name = var_liste{j};
        if( strcmp(s(index).type,'single') )
          [ctext,ntext] = Sim_def_build_c_var_def_variable_single(ctext,ntext,4,0,variable_name,s(index).varformat,s(index).comment);
        elseif( strcmp(s(index).type,'mBuffer') )
          [ctext,ntext] = Sim_def_build_c_var_def_variable_mBuffer(ctext,ntext,4,0,variable_name,s(index).varformat,s(index).vecnames,s(index).length,s(index).comment);
        end
      end
    end
    [ctext,ntext] = Sim_def_build_c_var_def_struct_end(ctext,ntext,2,flag_ext,structname);
  end
  
  % Überschrift
  ctext = cell_add(ctext,'/*############################\n');
  ctext = cell_add(ctext,'  ## C-Var-Definition       ##\n');
  ctext = cell_add(ctext,'############################*/\n');
  ntext = length(ctext);
  flag_ext = 0;
  for i=1:length(variable_index_liste)
    index = variable_index_liste{i};
    if( strcmp(s(index).type,'single') )
      [ctext,ntext] = Sim_def_build_c_var_def_variable_single(ctext,ntext,2,flag_ext,s(index).varname,s(index).varformat,s(index).comment);
    elseif( strcmp(s(index).type,'mBuffer') )
      [ctext,ntext] = Sim_def_build_c_var_def_variable_mBuffer(ctext,ntext,2,flag_ext,s(index).varname,s(index).varformat,s(index).vecnames,s(index).length,s(index).comment);
    end
  end
  for i=1:length(struct_name_liste)
    structname  = struct_name_liste{i};
    index_liste = struct_index_liste{i};
    var_liste = struct_var_liste{i};
    [ctext,ntext] = Sim_def_build_c_var_def_struct_start(ctext,ntext,2,flag_ext,structname);
    if( flag_ext )
      for j=1:length(index_liste)
        index         = index_liste{j};
        variable_name = var_liste{j};
        if( strcmp(s(index).type,'single') )
          [ctext,ntext] = Sim_def_build_c_var_def_variable_single(ctext,ntext,4,0,variable_name,s(index).varformat,s(index).comment);
        elseif( strcmp(s(index).type,'mBuffer') )
          [ctext,ntext] = Sim_def_build_c_var_def_variable_mBuffer(ctext,ntext,4,0,variable_name,s(index).varformat,s(index).vecnames,s(index).length,s(index).comment);
        end
      end
    end
    [ctext,ntext] = Sim_def_build_c_var_def_struct_end(ctext,ntext,2,flag_ext,structname);
  end
  
  write_ascii_file(outputfile,ctext);
  
  % Ende
  fprintf('Ausgabedatei: %s erstellt -------------------------\n',outputfile);
end
function [ctext,ntext] = Sim_def_build_c_var_def_variable_single(ctext,ntext,nleer,flag_ext,varname,varformat,comment)
 
  ctext{ntext+1} = '';
  
  tt = '';
  for i=1:nleer
    tt = [tt,' '];
  end
  if( flag_ext )
    ctext{ntext+2} = sprintf('%sextern %s %s; /* %s */' ...
                            , tt ...
                            , varformat ...
                            , varname ...
                            , comment ...
                            );
  else
    ctext{ntext+2} = sprintf('%s%s %s; /* %s */' ...
                            , tt ...
                            , varformat ...
                            , varname ...
                            , comment ...
                            );
  end
 ntext = ntext+2; 
end
function [ctext,ntext] = Sim_def_build_c_var_def_variable_mBuffer(ctext,ntext,nleer,flag_ext,varname,varformat,vecnames,ll,comment)

  tt = '';
  for i=1:nleer
    tt = [tt,' '];
  end
    
  ctext{ntext+1} = '';
  def_name = ['N_VEC_',upper(varname)];
  
  ctext{ntext+2} = sprintf('%s#define %s %i',tt,def_name,ll);
  ntext          = ntext+2;
  
  for i=1:length(vecnames)
      
    ctext{ntext+1} = '';
    
    variable_name = [varname,'_',vecnames{i}];
    if( flag_ext )
      ctext{ntext+2} = sprintf('%sextern %s %s[%s]; /* %s */' ...
                              , tt ...
                              , varformat{i} ...
                              , variable_name ...
                              , def_name ...
                              , comment ...
                              );
    else

      ctext{ntext+2} = sprintf('%s%s %s[%s]; /* %s */' ...
                              , tt ...
                              , varformat{i} ...
                              , variable_name ...
                              , def_name ...
                              , comment ...
                              );
    end
    ntext = ntext+2;
  end
  ctext{ntext+1} = '';

  variable_name = [varname,'_mBufferCnt'];
  if( flag_ext )
    ctext{ntext+2} = sprintf('%sextern %s %s; /* %s */' ...
                            , tt ...
                            , 'size_t' ...
                            , variable_name ...
                            , comment ...
                            );
  else

    ctext{ntext+2} = sprintf('%s%s %s; /* %s */' ...
                            , tt ...
                            , 'size_t' ...
                            , variable_name ...
                            , comment ...
                            );
  end
  ntext = ntext+2;
  
end
function [ctext,ntext] = Sim_def_build_c_var_def_struct_start(ctext,ntext,nleer,flag_ext,structname)
  tt = '';
  for i=1:nleer
    tt = [tt,' '];
  end
    
  if( flag_ext )
    ctext{ntext+1} = '';
    ctext{ntext+2} = sprintf('%stypedef struct tag_S%s' ...
                            , tt ...
                            , structname ...
                            );
    ctext{ntext+3} = sprintf('%s{',tt);
    ntext = ntext+3;
  end
end
function [ctext,ntext] = Sim_def_build_c_var_def_struct_end(ctext,ntext,nleer,flag_ext,structname)
  tt = '';
  for i=1:nleer
    tt = [tt,' '];
  end
    
  if( flag_ext )
    ctext{ntext+1} = '';
    ctext{ntext+2} = sprintf('%s} S%s;' ...
                            , tt ...
                            , structname ...
                            );
    ctext{ntext+3} = sprintf('%s extern S%s %s;' ...
                            , tt ...
                            , structname ...
                            , structname ...
                            );
    ntext = ntext+3;
  else
    ctext{ntext+1} = '';
    ctext{ntext+2} = sprintf('%s S%s %s;' ...
                            , tt ...
                            , structname ...
                            , structname ...
                            );
    ntext = ntext+2;
  end
end
