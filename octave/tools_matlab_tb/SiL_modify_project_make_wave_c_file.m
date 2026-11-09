function     okay = SiL_modify_project_make_wave_c_file(proj_name ...
                                              ,sim_def_var_inp ...
                                              ,sim_def_var_out ...
                                              ,sim_def_n_var_inp ...
                                              ,sim_def_n_var_out ...
                                              ,wave_c_file ...
                                              ,sim_def_h_file ...
                                              ,interface_h_files ...
                                              ,sim_def_var_h_files ...
                                              ,interface_init_call ...
                                              ,interface_loop_call ...
                                              ,code_kennung_start ...
                                              ,code_kennung_end)
%
%
%
  okay = 1;
  ck = ...
  {'/* $$KENNUNG$$ ---------------------------------------------------------------------------------*/' ...
  };
  cinc = ...
  {'#include "$$INCLUDEFILE$$"' ...
  };

  okay = 1;
  function_init = ['wave_',proj_name,'_init'];
  function_loop = ['wave_',proj_name,'_loop'];
  
  [ okay,c,nzeilen ] = read_ascii_file(wave_c_file);
  
  % Includes einfügen
  c = SiL_modify_project_make_wave_c_file_include(c ...
                                                 ,wave_c_file ...
                                                 ,ck ...
                                                 ,cinc ...
                                                 ,[code_kennung_start,'INC'] ...
                                                 ,[code_kennung_end,'INC'] ...
                                                 ,sim_def_h_file ...
                                                 ,interface_h_files ...
                                                 ,sim_def_var_h_files ...
                                                 );
  % init einfügen
  if( ~isempty(interface_init_call) )
    c = SiL_modify_project_make_wave_c_file_init(c ...
                                                ,wave_c_file ...
                                                ,ck ...
                                                ,function_init ...
                                                ,interface_init_call ...
                                                ,[code_kennung_start,'INIT'] ...
                                                ,[code_kennung_end,'INIT'] ...
                                                );
  else % Code rauslöschen, wenn einer drinnen war
    % Codekennung suchen und löschen
    [found_flag,ic0,c] = SiL_modify_project_make_wave_c_file_code_cut(c ...
                                                                     ,[code_kennung_start,'INIT'] ...
                                                                     ,[code_kennung_end,'INIT'] ...
                                                                     );
    
  end
  % loop einfügen
  c = SiL_modify_project_make_wave_c_file_loop(c ...
                                              ,wave_c_file ...
                                              ,ck ...
                                              ,function_loop ...
                                              ,interface_loop_call ...
                                              ,sim_def_var_inp ...
                                              ,sim_def_var_out ...
                                              ,sim_def_n_var_inp ...
                                              ,sim_def_n_var_out ...
                                              ,[code_kennung_start,'LOOP'] ...
                                              ,[code_kennung_end,'LOOP'] ...
                                              );
  okay = write_ascii_file(wave_c_file,c);
  
end
function c = SiL_modify_project_make_wave_c_file_include(c,wave_c_file,ck,cinc,cks,cke,sim_def_h_file,interface_h_files,sim_def_var_h_files)
%
% cks     code_kennung_start
% cke     code_kennung_end
%
  % Codekennung suchen und löschen
  [found_flag,ic0,c] = SiL_modify_project_make_wave_c_file_code_cut(c,cks,cke);
  
  if( ~found_flag ) % wenn keine Codekennung gefunden wird letztes iclude gesucht
    [ifound,ipos] = cell_find_f(c,'#include','n');  
    if( isempty(ifound) )
      error('%s_error: #include konnte in wave-Datei: %s nicht gefunden werden',mfilename,wave_c_file);
    else
      ic0 = max(ifound)+1;
    end
  end
  % neue includes erstellen
  c0     = cell_change(ck,'$$KENNUNG$$',cks);
  s_file = str_get_pfe_f(sim_def_h_file);
  c0     = cell_add(c0,cell_change(cinc,'$$INCLUDEFILE$$',[s_file.name,'.',s_file.ext]));
  
  for i = 1:length(interface_h_files)
    s_file = str_get_pfe_f(interface_h_files{i});
    c0     = cell_add(c0,cell_change(cinc,'$$INCLUDEFILE$$',[s_file.name,'.',s_file.ext]));
  end
  for i = 1:length(sim_def_var_h_files)
    s_file = str_get_pfe_f(sim_def_var_h_files{i});
    c0     = cell_add(c0,cell_change(cinc,'$$INCLUDEFILE$$',[s_file.name,'.',s_file.ext]));
  end
  c0     = cell_add(c0,cell_change(ck,'$$KENNUNG$$',cke));
  % neuen Code an ic0 einfügen
  c      = cell_insert(c,ic0,c0);
end  
function    c = SiL_modify_project_make_wave_c_file_init(c,wave_c_file,ck,func,iic,cks,cke)
%
% func    init_function
% iic     interface_init_call
% cks     code_kennung_start
% cke     code_kennung_end
%
  % Codekennung suchen und löschen
  [found_flag,ic0,c] = SiL_modify_project_make_wave_c_file_code_cut(c,cks,cke);
  
  if( ~found_flag ) % wenn keine Codekennung gefunden dann Stelle in Init-Fkt suchen
    ic0 = SiL_modify_project_make_wave_c_file_search_call_pos(c,func,wave_c_file);
  end
  % Code ertellen
  c0     = cell_change(ck,'$$KENNUNG$$',cks);
  c0     = cell_add(c0,['  ',iic]);
  c0     = cell_add(c0,cell_change(ck,'$$KENNUNG$$',cke));
  % Code einsetzen
  c  = cell_insert(c,ic0,c0);
end
function    c = SiL_modify_project_make_wave_c_file_loop(c,wave_c_file,ck,func,ilc,sinp,sout,nsinp,nsout,cks,cke)
%
% func    loop_function
% ilc     interface_loop_call
% sinp    input structure
% sout    output structure
% nsinp   Anzahl input
% nsout   Anzahl output
% cks     code_kennung_start
% cke     code_kennung_end
%
  % Codekennung suchen und löschen
  [found_flag,ic0,c] = SiL_modify_project_make_wave_c_file_code_cut(c,cks,cke);
  
  if( ~found_flag ) % wenn keine Codekennung gefunden dann Stelle in Init-Fkt suchen
    ic0 = SiL_modify_project_make_wave_c_file_search_call_pos(c,func,wave_c_file);
  end
  % Code ertellen
  c0     = cell_change(ck,'$$KENNUNG$$',cks);
  % Inputs
  c1     = SiL_modify_project_make_wave_c_file_loop_sinp(sinp,nsinp,2);
  c0     = cell_add(c0,c1);
  
  c0     = cell_add(c0,['  ',ilc]);
  % Outputs
  c1     = SiL_modify_project_make_wave_c_file_loop_sout(sout,nsout,2);
  c0     = cell_add(c0,c1);
  c0     = cell_add(c0,cell_change(ck,'$$KENNUNG$$',cke));
  % Code einsetzen
  c  = cell_insert(c,ic0,c0);
end
function c = SiL_modify_project_make_wave_c_file_loop_sinp(s,ns,nspace)

  c = {};

  l0 = 0;
  l1   = 0;
  for i=1:ns
    l0 = max(l0,length(s(i).variable));
    l1   = max(l1,length(s(i).cname));
  end
  
  for i = 1:ns
    
    [fac,offset,errtext] = get_unit_convert_fac_offset(s(i).unit,s(i).varunit);
    if( ~isempty(errtext) )
      error(errtext);
    end
    t0 = str_fill_right(s(i).variable,' ',l0);
    if( fac == 1.0 )
      t1 = str_fill_right([s(i).cname,';'],' ',l1+1);
    else
      t2 = [' * (',s(i).varformat,')',num2str(fac)];
      t1 = str_fill_right([s(i).cname,t2,';'],' ',l1+1+length(t2));
    end
    tt = [t0,' = ',t1,' /*',s(i).comment,'*/'];
    for j=1:nspace
      tt = [' ',tt];
    end
    c  = cell_add(c,tt);
  end

end
function c = SiL_modify_project_make_wave_c_file_loop_sout(s,ns,nspace)

  c = {};

  l0 = 0;
  l1   = 0;
  for i=1:ns
    l0 = max(l0,length(s(i).cname));
    l1   = max(l1,length(s(i).variable));
  end
  
  for i = 1:ns
    
    [fac,offset,errtext] = get_unit_convert_fac_offset(s(i).varunit,s(i).unit);
    if( ~isempty(errtext) )
      error(errtext);
    end
    t0 = str_fill_right(s(i).cname,' ',l0);
    if( fac == 1.0 )
      t1 = str_fill_right([s(i).variable,';'],' ',l1+1);
    else
      t2 = [' * (',s(i).varformat,')',num2str(fac)];
      t1 = str_fill_right([s(i).variable,t2,';'],' ',l1+1+length(t2));
    end
    tt = [t0,' = ',t1,' /*',s(i).comment,'*/'];
    for j=1:nspace
      tt = [' ',tt];
    end
    c  = cell_add(c,tt);
  end

end
function  [found_flag,ic0,c] = SiL_modify_project_make_wave_c_file_code_cut(c,cks,cke)
  found_flag = 0;
  ic0        = 0;
  [ifound,ipos] = cell_find_f(c,cks,'n');
  if( ~isempty(ifound) )
    found_flag = 1;
    ic0 = ifound(1);
    [ifound,ipos] = cell_find_f(c,cke,'n');
    if( ~isempty(ifound) )
      c = cell_delete(c,ic0,ifound(1));
    else
      c = cell_delete(c,ic0,ic0);
    end
  end
end
function ic0 = SiL_modify_project_make_wave_c_file_search_call_pos(c,func,filename)
  ic0        = 0;
  [ifound,ipos] = cell_find_f(c,func,'n');
  if( isempty(ifound) )
    error('%s_error, In Datei <%s>,Function %s() konnte nicht gefunden werden',mfilename,filename,func);
  else
    [icell,ipos] = cell_find_nearest_from_ipos(c,ifound(1),ipos(1)+length(func),'{','for');
    if( icell == 0 )
      error('%s_error, In Datei <%s>: Nach Funktionsaufruf %s() konnte kein { gefunden werden',mfilename,filename,func);
    else
      icell_s = icell;
      ipos_s  = ipos;
    end
    flag  = 1;
    count = 0;
    while(flag)
      [icell1,ipos1] = cell_find_nearest_from_ipos(c,icell,ipos+1,'{','for');
      [icell2,ipos2] = cell_find_nearest_from_ipos(c,icell,ipos+1,'}','for');
      if( icell2 == 0 )
        error('%s_error, In Datei <%s>: ''}'' kann nach Zeile %i mit Text: <%s> nicht gefunden werden',mfilename,filename,icell,c{icell});
      end
      if(  (icell1 == 0) ...
        || (icell2 < icell1) ...
        || ((icell2 == icell1) && (ipos2 < ipos1)) ...
        )
        if( count == 0 )
          flag = 0;
          icell_e = icell2;
          ipos_e  = ipos2;
        else
          count = count - 1;
          icell = icell2;
          ipos  = ipos2;
        end
      else
        count = count + 1;
        icell = icell1;
        ipos  = ipos1;
      end
    end
  end
  [ic,ip] = cell_find_nearest_from_ipos(c,icell_s,ipos_s,'return','for');
  if( (ic < icell_e) || ((ic == icell_e) && (ip < ipos_e)) )
    ic0 = ic;
  else
    error('%s_error, In Datei <%s>: ''return'' kann nach in Funktion %s()  nicht gefunden werden',mfilename,filename,func);
  end
end