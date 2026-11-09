function okay = c_build_struct(h_file,struct_name,var)
%
% okay = c_build_struct(h_file,struct_name,var);
%
% erstellt und bearbeitet h_file mit dem Structnamen und der variablen
% Liste var
%
% h_file      char       h-File mit Pfad
% struct_name char       Strukturname
% var         struct     Liste mit Definition der Variablen
%
% var(i).cname    = 'b';           % Name in C
% var(i).cformat  = 'char';        % c-format
% var.cunit       = '-';           % Einheit in c gilt aber nur für float
%                                   % und double
% var.type        = 'single';      % 'single','mBuffer'
% var.name        = ['SOut_',Svar(i).cname]; % Name nach aussen
% var.unit        = '-';                      % Einheit ausserhalb (Macro
%                                              % wird erstellt)
% var.comment     = 'Test a';                 % Kommentar
%

  s_file = str_get_pfe_f(h_file);
  
  % Datei erstellen, wenn nicht vorhanden
  if( ~exist(h_file,'file') )
    okay = c_build_struct_create_file(h_file,s_file.name,struct_name);
  end
  
  [okay,c,n] = read_ascii_file(h_file);
  
  icell = 1;
  ipos  = 1;
  [found,icell,ipos,name] = c_build_struct_find_struct(c,n,icell,ipos);

end
function okay = c_build_struct_create_file(h_file,h_name,struct_name)
  c = ...
  {'#ifndef $$H_NAME$$_sim_type_h___' ...
  ,'#define $$H_NAME$$_sim_type_h___' ...
  ,'' ...
  ,'struct $$NAME$$_t' ...
  ,'{' ...
  ,'  char           dummy;' ...
  ,'};' ...
  ,'#ifdef __cplusplus' ...
  ,'extern "C" {' ...
  ,'#endif' ...
  ,'extern struct $$NAME$$_t $$NAME$$;' ...
  ,'#ifdef __cplusplus' ...
  ,'}' ...
  ,'#endif' ...
  ,'' ...
  ,'#endif' ...
  };
  c = cell_change(c,'$$NAME$$',struct_name);
  c = cell_change(c,'$$H_NAME$$',h_name);
  okay = write_ascii_file(h_file,c);
end
function [found,icell,ipos,name] = c_build_struct_find_struct(c,n,icell0,ipos0)

  found = 0;
  icell = 0;
  ipos  = 0;
  name  = '';
  % find structure beginn
  [icell1,ipos1] = cell_find_from_ipos(c,icell0,ipos0,'{');
  if( icell1 == 0 ),return;end
  [icell2,ipos2] = cell_find_from_ipos(c,icell1,ipos1,'{');
  if( icell2 == 0 ),return;end
  
  [c_words,n_words] = cell_find_next_words(c,icell1,ipos1,2,'back');
  
  
  
    
end