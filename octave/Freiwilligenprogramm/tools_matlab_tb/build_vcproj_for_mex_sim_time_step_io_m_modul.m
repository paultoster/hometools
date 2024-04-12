function   q = build_vcproj_for_mex_sim_time_step_io_m_modul(q)
%
% q = build_vcproj_for_mex_sim_time_step_io_m_modul(q)
%
% Behandlung time_step_PROJ_NAME.m.m
%
% q.time_step_m_filename         mfilename ohne Pfad
% q.time_step_m_fullfilename     mfilename mit Pfad

  q.KENNUNG_TIME_STEP_M_INPUT_START  = '##TIME_STEP_M_INPUT_START##';
  q.KENNUNG_TIME_STEP_M_INPUT_END    = '##TIME_STEP_M_INPUT_END##';
  q.KENNUNG_TIME_STEP_M_OUTPUT_START = '##TIME_STEP_M_OUTPUT_START##';
  q.KENNUNG_TIME_STEP_M_OUTPUT_END   = '##TIME_STEP_M_OUTPUT_END##';


  % m-file 
  %------------------------------------------------------------------------
  q.time_step_func_name      = ['time_step_',q.proj_name];
  q.time_step_m_filename     = [q.time_step_func_name,'.m'];
  q.time_step_m_fullfilename = fullfile(q.run_path,q.time_step_m_filename);

  %
  % m-file Geruest
  c = m_modul_geruest(q);
  
  %========================================================================
  % Input 
  %========================================================================
  [c,i0] = Kennung_bereinigen(c,q.KENNUNG_TIME_STEP_M_INPUT_START,q.KENNUNG_TIME_STEP_M_INPUT_END,0);  
  q.time_step_input_names = {};
  cinsert                    = {};
  %
  % Input bearbeiten
  for i=1:length(q.sim_def_var_inp)
    [cc,signame]            = get_input_descript(q.sim_def_var_inp(i),q);
    cinsert                 = cell_add(cinsert,cc);
    q.time_step_input_names = cell_add(q.time_step_input_names,signame);
  end
  % Input Zellen einfügen
  c  = cell_insert(c,i0,cinsert);
  
  %========================================================================
  % Output 
  %========================================================================
  [c,i0] = Kennung_bereinigen(c,q.KENNUNG_TIME_STEP_M_OUTPUT_START,q.KENNUNG_TIME_STEP_M_OUTPUT_END,0);  
  q.time_step_output_names = {};
  cinsert                  = {};
  %
  % Input bearbeiten
  for i=1:length(q.sim_def_var_out)
    [cc,signame]             = get_output_descript(q.sim_def_var_out(i));
    cinsert                  = cell_add(cinsert,cc);
    q.time_step_output_names = cell_add(q.time_step_output_names,signame);
  end
  % Input Zellen einfügen
  c  = cell_insert(c,i0,cinsert);
  
  % m-file schreiben
  %------------------
  okay = write_ascii_file(q.time_step_m_fullfilename,c);
  if( ~okay )
    error('%s_error: Fehler bei Schreiben von mfile: <%s>',mfilename,q.time_step_m_fullfilename);
  end

end
function [cc,signame]            = get_input_descript(sim_def_var_inp,q)

  if( strcmp(sim_def_var_inp.type,'single') )
    signame = sim_def_var_inp.name;
    cc      = sprintf('    inmex.%s = in.%s(%s);',signame,signame,q.time_step_index);
  elseif( strcmp(sim_def_var_inp.type,'vector') )
    error('not programmed'); 
  else
    error('Variable: %s, type=% nicht vorhanden',sim_def_var_inp.name,sim_def_var_inp.type);
  end

end
function [cc,signame]            = get_output_descript(sim_def_var_out)

  if( strcmp(sim_def_var_out.type,'single') )
    signame = sim_def_var_out.name;
    cc      = sprintf('    out.%s = outmex.%s;',signame,signame);
  elseif( strcmp(sim_def_var_inp.type,'vector') )
    error('not programmed'); 
  else
    error('Variable: %s, type=% nicht vorhanden',sim_def_var_out.name,sim_def_var_out.type);
  end

end
function c = m_modul_geruest(q)

c = ...
  {sprintf('function out = %s(type,%s,in,p)',q.time_step_func_name,q.time_step_index) ...
  ,'%% type = 0/1/2           init,loop,done' ...
  ,sprintf('%% %s             index',q.time_step_index) ...
  ,'%% in                     input-structure, must be filled in type=loop' ...
  ,'%%                        e.g. in.vel = value' ...
  ,'%% p                      parameter structure' ...
  ,'%%                        p.dt (type=init,optional) filled to caluculate time' ...
  ,' ' ...
  ,sprintf('%%=============================================================') ...
  ,sprintf('%%   init') ...
  ,sprintf('%%=============================================================') ...
  ,'  if( type == 0 )' ...
  ,'  ' ...
  ,sprintf('    [okay,outmex] = run_mex_%s(type,0,p);',q.proj_name) ...
  ,sprintf('%%=============================================================') ...
  ,sprintf('%%   loop') ...
  ,sprintf('%%=============================================================') ...
  ,'  elseif( type == 1 )' ...
  ,sprintf('%%   %s',q.KENNUNG_TIME_STEP_M_INPUT_START) ...
  ,sprintf('%%   %s',q.KENNUNG_TIME_STEP_M_INPUT_END) ...
  ,sprintf('    [okay,outmex] = run_mex_%s(type,inmex,p);',q.proj_name) ...
  ,sprintf('%%   %s',q.KENNUNG_TIME_STEP_M_OUTPUT_START) ...
  ,sprintf('%%   %s',q.KENNUNG_TIME_STEP_M_OUTPUT_END) ...
  ,sprintf('%%=============================================================') ...
  ,sprintf('%%   done') ...
  ,sprintf('%%=============================================================') ...
  ,'  elseif( type == 2 )' ...
  ,sprintf('    [okay,outmex] = run_mex_%s(type,0,0);',q.proj_name) ...
  ,'  end' ...
  ,'  ' ...
  ,'  if( ~okay )' ...
  ,'    error(''not okay'')' ...
  ,'  end' ...
  ,'end' ...
  };

end
function [c,i0] = Kennung_bereinigen(c,KENN_START,KENN_END,errflag)

  iliste0 = cell_find_f(c,KENN_START,'n');
  iliste1 = cell_find_f(c,KENN_END,'n');
  
  if( errflag && isempty(iliste0) )
    error('%s_error: Die Kennung <%s> konnte nicht gefunden werden',mfilename,KENN_START);
  end
  if( errflag && isempty(iliste1) )
    error('%s_error: Die Kennung <%s> konnte nicht gefunden werden',mfilename,KENN_END);
  end
  
  if( ~isempty(iliste0) && ~isempty(iliste1) )
    i0 = iliste0(1)+1;
    i1 = iliste1(1)-1;
    if( i1 >= i0 )
      c  = cell_delete(c,i0,i1);
    end
  elseif( ~isempty(iliste0) && isempty(iliste1) )
    i0 = iliste0(1)+1;
    c  = cell_insert(c,i0,KENN_END);
  elseif( isempty(iliste0) && ~isempty(iliste1) )
    i0 = iliste1(1)-1;
    c  = cell_insert(c,i0,KENN_START);
    i0 = i0+1;
  else
    i0 = 1;
    c  = cell_insert(c,i0,KENN_START);
    c  = cell_insert(c,i0+1,KENN_END);
    i0 = 2;
  end
end
