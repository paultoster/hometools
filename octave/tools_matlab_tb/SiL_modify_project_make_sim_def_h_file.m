function okay = SiL_modify_project_make_sim_def_h_file(sim_def_h_file,sim_def_struct_inp_name,sim_def_struct_out_name ...
                   ,sim_def_variable_inp_name,sim_def_variable_out_name ...
                   ,sim_def_var_inp,sim_def_var_out,sim_def_n_var_inp,sim_def_n_var_out)
%   sim_def_h_file               vollständigger Simulations-h-Filename
%   sim_def_struct_inp_name      Name der Input Struktur (C)
%   sim_def_struct_out_name      Name der Output Struktur (C)
%   sim_def_variable_inp_name    Name der Inputstruktur Variable 
%   sim_def_variable_out_name    Name der Outputstruktur Variable
%   sim_def_var_inp              Variablendefinitiondstruktur Input (siehe SiL_modify_project.m)
%   sim_def_var_out              Variablendefinitiondstruktur Output (siehe SiL_modify_project.m)
%   sim_def_n_var_inp            jeweilige Länge
%   sim_def_n_var_out

  okay = 1;
  chead0 = ...
  {'#ifndef $$NAME$$_sim_type_h___' ...
  ,'#define $$NAME$$_sim_type_h___' ...
  ,'' ...
  };
  chead1 = ...
  {'' ...
  ,'#endif  /* $$NAME$$_sim_type_h___ */' ...
  };
  cstruct0 = ...
  {'struct $$STRUCTNAME$$' ...
  ,'{' ...
  };
  cstruct1 = ...
  {'};' ...
  ,'#ifdef __cplusplus' ...
  ,'extern "C" {' ...
  ,'#endif' ...
  ,'extern struct $$STRUCTNAME$$ $$VARNAME$$;' ...
  ,'#ifdef __cplusplus' ...
  ,'}' ...
  ,'#endif' ...
  };
  % Header ----------------------------------------------------------------
  s_file = str_get_pfe_f(sim_def_h_file);
  c = cell_change(chead0,'$$NAME$$',s_file.name);
  % Input -----------------------------------------------------------------
  if( sim_def_n_var_inp )
    c1 = cell_change(cstruct0,'$$STRUCTNAME$$',sim_def_struct_inp_name);
    c  = cell_add(c,c1);
    for i = 1:sim_def_n_var_inp
      c1 = SiL_modify_project_make_sim_def_h_file_var(sim_def_var_inp(i),2);
      c  = cell_add(c,c1);
    end
    c1 = cell_change(cstruct1,'$$STRUCTNAME$$',sim_def_struct_inp_name);
    c1 = cell_change(c1,'$$VARNAME$$',sim_def_variable_inp_name);
    c  = cell_add(c,c1);
  end
  % Output ----------------------------------------------------------------
  if( sim_def_n_var_out )
    c1 = cell_change(cstruct0,'$$STRUCTNAME$$',sim_def_struct_out_name);
    c  = cell_add(c,c1);
    for i = 1:sim_def_n_var_out
      c1 = SiL_modify_project_make_sim_def_h_file_var(sim_def_var_out(i),2);
      c  = cell_add(c,c1);
    end
    c1 = cell_change(cstruct1,'$$STRUCTNAME$$',sim_def_struct_out_name);
    c1 = cell_change(c1,'$$VARNAME$$',sim_def_variable_out_name);
    c  = cell_add(c,c1);
  end
  % Ende ------------------------------------------------------------------
  c1 = cell_change(chead1,'$$NAME$$',s_file.name);
  c  = cell_add(c,c1);
  okay = write_ascii_file(sim_def_h_file,c);
end
function c = SiL_modify_project_make_sim_def_h_file_var(s,nspace)
% s(i).cname    = 'b';           % Name in C
% s(i).cformat  = 'char';        % c-format
% s(i).cunit    = '-';           % Einheit in c gilt aber nur für float
%                                   % und double
% s(i).type     = 'single';      % 'single','mBuffer'
% s(i).name     = ['SOut_',Svar(i).cname]; % Name nach aussen
% s(i).unit     = '-';                      % Einheit ausserhalb (Macro
%                                              % wird erstellt)
% s(i).comment  = 'Test a';                 % Kommentar
  tt = sprintf('%-20s %-20s; /* %-5s %s */',s.varformat,s.name,s.unit,s.comment);
  for i=1:nspace
    tt = sprintf(' %s',tt);
  end
  c = {tt};
end
