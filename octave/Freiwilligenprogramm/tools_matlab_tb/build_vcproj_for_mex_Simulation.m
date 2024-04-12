function [okay,errtext] = build_vcproj_for_mex_Simulation(q)
%
% [okay,errtext] = build_vcproj_for_mex_Simulation(q)
%
% build mex-Project to Simulate with CAN-Ascii-data or Signal-based-data as Input
%
% input                   type    default   description                     example
% q.type                  char    no        type of Simulation:
%                                           'can_full'    Simulation with
%                                                         ascii-Can-Data, by one
%                                                         function-call
%                                           'modul'       Simulation with a
%                                                         modul Input is in
%                                                         a d-structure and
%                                                         Output in a
%                                                         e-structure
%                                           'emodul'      Simulation with a
%                                                         modul Input is in
%                                                         a e-structure and
%                                                         Output in a
%                                                         e-structure
%                                           'time_step'   Simulation for
%                                                         one time step
%
% q.proj_name             char    no        Project name                    example:'SIM_CAN_VPU_HAF1'
% q.proj_dir              char    no        project path                    example:'D:\VPU_HAF\SIM_CAN_VPU_HAF1'
%
% q.use_vpu_code          num     0         1: vpu-Code von q.vpu_dir wird verwendet
% q.vpu_dir               char    no        project path of VPU-Environment example:'D:\VPU_HAF\VPU_HAF1_RTAS'
%
% q.use_rtas_code         num     0         1: rtas-Code aus ssw-Anweisung von d.rtas_dir wird verwendet
%
% q.rtas_dir              char    no       rtas-directory                  example:'d:\APU_rtas\rtas'
%                                          wenn q.rtas_dir benutzt, dann
%                                          sin das Verzeichnis mod und app
%                                          im gleichen Verzeichnis
%
% q.rtas_mod_dir          char    no       Wenn das rtas-Verzeichnis mod
% q.rtas_app_dir          char    no       und app an verschiedenen Stellen liegen, 
%                                          sollten q.rtas_mod_dir und
%                                          q.rtas_app_dir benutzt werden 
%                                          (jeweils das directory über mod bzw. app)
% q.rtas_projconf_dir     char    no       project_cnfig-dir
%
%                                           RTAS Application type selction:
% q.rtas_ssw_platform     char    no       RTAS-SSW-Platform bisher nur vpu default: 'vpu-cg';
% q.rtas_ssw_type_name    char    no       RTAS-SSW-type name               default: 'default';
% q.rtas_ssw_config_name  char    no       RTAS-SSW-configuration-name      default: '' => no RTAS-include 
%                                                                            (example: 'had')
% q.rtas_project_name     char    no       RTAS PAM "Project name"
%                                          (project-Application-Manager)
% q.matlab_dir            char    no        Installation path of Matlab     example:'E:\Program Files (x86)\MATLAB\R2010b'
%
% q.source_files_to_copy  cell    yes       Diese Files werden in das
%                                           Projekt kopiert, es sind alle
%                                           notwendigen Files intern
%                                           aufgelistet. (in path muss ...\matlab\allg festgelegt sein. 
%                                           Die Sourcen liegen in ...\matlab\allg\src)
%                                           Die weiteren von aussen vrgegebenen werden
%                                           hinzugenommen
% q.source_files          cell    yes       source-Files mit Pffad, die verwendet werden (kein copy)
%                                           intern werden alle ausser notwendigen VPU-Files festgelegt
%                                           Von aussen kommen Noch fct-Files z.B. {'D:\VPU_HAF\VPU_HAF1\src\fct\fct_main.c',...}
%                                           inclusive Header-Files
% q.include_pathes        cell    yes       zusätzliche include
%                                           Verzeichnisse, intern wird aus den source_files die Pfad hinzugefügt
% q.preprocess_defs      cell    yes        preprecess definition, intern
%                                           wird z.B. SIM_CFG himzugefügt
% q.lib_files            cell    yes        Library-Files
%
% q.vc_version           char    yes        Visual C-Version
%                                           'VC9'(default)(VC2008),'VC11','VC14'
%                                            
% q.vc_sln_write         num     0          Schreibe sln-File (vcprojx/vcproj wird immer geschrieben)
%
% q.build_mex            num     0          Build mex-Solution
%                                           = 0 (default) don't build
%                                           = 1 build m-File ['buildVcMex',q.proj_name,'.m'] to use
%                                           = 2 build m-File ['buildVcMex',q.proj_name,'.m'] and execute
%==========================================================================
% Eingabedefinition:
%==========================================================================
% -------------------------------------------------------------------------
% q.type = 'can_full','modul','emodul'
%--------------------------------------------------------------------------
%
% q.sim_def_var_inp(i).name      Simulationsvariablename
% q.sim_def_var_inp(i).unit      Einheit in der Simulation
% q.sim_def_var_inp(i).type      'single'   Einzelwert Zuweisung
%                                'Buffer', 
% q.sim_def_var_inp(i).id        (nur can_full, can_step) CAN-ID, wenn gesetzt wird beim Einlesen der Botschaft der Wert
%                                gesetzt, ansonsten nach der Loop
% q.sim_def_var_inp(i).channel   (nur can_full, can_step) Channel zu id
% q.sim_def_var_inp(i).varname   vollständiger C-Name
% q.sim_def_var_inp(i).varinc    include-Datei für die Variable z.B. 'abc.h','abc.h|def.h','extern char var'
% q.sim_def_var_inp(i).vartype   'C' oder 'C++', default 'C' für include
% q.sim_def_var_inp(i).varformat C-Format von varname float, ...
% q.sim_def_var_inp(i).varunit   Einheit für varname
% q.sim_def_var_inp(i).comment   Kommentar
%
% -------------------------------------------------------------------------
% q.type = 'time_step'
%--------------------------------------------------------------------------
% q.time_step_index              Indexname in Simulationsvariablename
%                                (default iTime)
% q.sim_def_var_inp(i).name      Simulationsvariablename d.h. in der
%                                übergebenen Struktur ist dies Variable
%                                enthalten, kann Inices enthalten .z.B
%                                iTime für den aktuellen Zeit Index
%                                und andere in Reihenfolge i und j
%                                varname(iTime).namevalue ist ein Einzelwert
%                                varname(iTime).namevalue(i) ist ein Vektor
%                                (dann muss der varname entweder auch array[i]
%                                enthalten oder wird mit push_back vector
%                                oder liste gefüllt
%                                varname(iTime).namevalue(i).name2value(j) ist ein Vektor im Vektor
%
%                                varname                    type = 'single'
%                                varname(iTime)
%                                varname(iTime).namevalue
%                                varname{iTime}
%                                varname{iTime}.namevalue
%                                varname{iTime}.namevalue
%                                varname{iTime}.namevalue(i) type = 'vector','array' loop over i
%                                varname(iTime).namevalue(i)
%                                varname(i)
%
% q.sim_def_var_inp(i).unit      Einheit in der Simulation
% q.sim_def_var_inp(i).type      'single'   Einzelwert Zuweisung
%                                'vector'   Vektor Zuweisung
% q.sim_def_var_inp(i).varname   vollständiger C-Name
%                                varname                    type = 'single'
%                                varname.velname        
%                                varname[i]                   type = 'array'
%                                varname.velname[i]           array zuordnung      
%                                varname                      type = 'vector'
%                                varname.velname              zurdnung mit varname.velname.push_back()      
% q.sim_def_var_inp(i).varinc    include-Datei für die Variable z.B. 'abc.h','abc.h|def.h','extern char var'
% q.sim_def_var_inp(i).vartype   'C' oder 'C++', default 'C' für include
% q.sim_def_var_inp(i).varformat C-Format von varname float, ...
% q.sim_def_var_inp(i).varunit   Einheit für varname
% q.sim_def_var_inp(i).comment   Kommentar
%
%==========================================================================
% Ausgabedefinition:
%==========================================================================
%
% -------------------------------------------------------------------------
% q.type = 'can_full','modul','emodul'
%--------------------------------------------------------------------------
% q.sim_def_var_out(i).name      Simulationsname
% q.sim_def_var_out(i).unit      Einheit in der Simulation
% q.sim_def_var_out(i).type      'single', 'mBuffer','vector'
% q.sim_def_var_out(i).id        CAN-ID, wenn gesetzt wird beim Einlesen der Botschaft der Wert
%                                gesetzt, ansonsten nach der Loop
% q.sim_def_var_out(i).channel   Channel zu id
% q.sim_def_var_out(i).varname   vollständiger C-Name
% q.sim_def_var_out(i).varinc    include-Datei für die Variable z.B. 'abc.h','abc.h|def.h','extern char var'
% q.sim_def_var_out(i).vartype   'C' oder 'C++', default 'C' für include
% q.sim_def_var_out(i).varformat C-Format von varname float, ...
% q.sim_def_var_out(i).varunit   Einheit für varname
% q.sim_def_var_out(i).comment   Kommentar
%-----------------------------------------------------
% Beispiel 'Buffer'
%  q.sim_def_var_out(i).type       = 'Buffer'; z.B.
%  q.sim_def_var_out(i).name       = 'Path_TrajInp';
%  q.sim_def_var_out(i).varname    = ['AD2POutput.',name];
%  q.sim_def_var_out(i).varformat  = {'float','float'};
%  q.sim_def_var_out(i).varunit    = {'m','m'};
%  q.sim_def_var_out(i).type     = 'mBuffer';
%  q.sim_def_var_out(i).length   = 200;
%  q.sim_def_var_out(i).name     = ['SAD2P_',name];
%  q.sim_def_var_out(i).unit    = {'m','m'};
%  q.sim_def_var_out(i).vecnames = {'x','y'};
%  q.sim_def_var_out(i).comment  = 'Input Path Trajectory ';
%
%  Im Code wird die Variable 
%     float AD2POutput.Path_TrajInp_x[]; und
%     size_t AD2POutput.Path_TrajInp_mBufferCnt; 
%  benötigt zum einlesen.
%-----------------------------------------------------
% -------------------------------------------------------------------------
% q.type = 'time_step'
%--------------------------------------------------------------------------
% q.sim_def_var_out entspricht q.sim_def_var_in
%
%==========================================================================
% Parameter
%==========================================================================
% q.sim_def_var_par(i).type      'single'     Es werden loopweise Werte von
%                                             aussen zugewiesen
%                                             Dafür muss eine Struktur p
%                                             übergeben werden mit dem
%                                             Zeitvektor p.time und den
%                                             hier angegebenen Namen
%                                             q.sim_def_var_par(i).name
%                                'cperm'      Es wird ein konstnter Wert
%                                             Loopweise zugewiesen, d.h.
%                                             ein Konstantwert in Simulation
%                                'cinit0'      Es wird ein konstanter Wert
%                                             vor Ausführung Init zugewiesen, d.h.
%                                             von Simulation ein Wert
%                                'cinit1'     Es wird ein konstanter Wert
%                                             nach Ausführung Init zugewiesen, d.h.
%                                             von Simulation ein Wert
%                                'init0'      Es wird ein Parameterwert
%                                             vor Ausführung Init zugewiesen, d.h.
%                                             von Simulation Parameterwert
%                                'init1'      Es wird ein konstanter Wert
%                                             nach Ausführung Init zugewiesen, d.h.
%                                             von Simulation ein Wert
%
% Beispiel:
% =========
% cc  = ...
%      {{'name'                             ,'unit'      ,'type'     ,'varname'                                     ,'vartype'   ,'varinc'                           ,'varformat'          ,'varunit'     ,'comment'} ...
%      ,{'UseEgoPosFilt'                    ,'enum'      ,'perm'     ,'arbiDev2PathParData.UseEgoPosFilt'           ,'C++'       ,'defs.h|ArbiDev2PathParStruct.h'   ,'signed short int'   ,'enum'        ,'Filter EgoPose'} ...
%      ,{'UseEgoPosFilt'                    ,'enum'      ,'single'   ,'arbiDev2PathParData.UseEgoPosFilt'           ,'C++'       ,'ArbiDev2PathParStruct.h'          ,'signed short int'   ,'enum'        ,'Filter EgoPose'} ...
%      ,{'UseEgoPosFilt=0'                  ,'enum'      ,'cperm'    ,'arbiDev2PathParData.UseEgoPosFilt'           ,'C++'       ,'ArbiDev2PathParStruct.h'          ,'signed short int'   ,'enum'        ,'Filter EgoPose'} ...
%      ,{'UseEgoPosFilt'                    ,'enum'      ,'init0'   ,'arbiDev2PathParData.UseEgoPosFilt'           ,'C++'       ,'ArbiDev2PathParStruct.h'          ,'signed short int'   ,'enum'        ,'Filter EgoPose'} ...
%      ,{'UseEgoPosFilt'                    ,'enum'      ,'init1'   ,'arbiDev2PathParData.UseEgoPosFilt'           ,'C++'       ,'ArbiDev2PathParStruct.h'          ,'signed short int'   ,'enum'        ,'Filter EgoPose'} ...
%      ,{'UseEgoPosFilt=0'                  ,'enum'      ,'cinit0'    ,'arbiDev2PathParData.UseEgoPosFilt'           ,'C++'       ,'ArbiDev2PathParStruct.h'          ,'signed short int'   ,'enum'        ,'Filter EgoPose'} ...
%      ,{'UseEgoPosFilt=0'                  ,'enum'      ,'cinit1'    ,'arbiDev2PathParData.UseEgoPosFilt'           ,'C++'       ,'ArbiDev2PathParStruct.h'          ,'signed short int'   ,'enum'        ,'Filter EgoPose'} ...
%      };
% q.sim_def_var_par = cell_liste2struct(cc,'<','>');
%
% q.sim_def_var_par(i).name      Simulationsname
% q.sim_def_var_par(i).unit      Einheit in der Simulation
% q.sim_def_var_par(i).varname   vollständiger C-Name
% q.sim_def_var_par(i).varinc    include-Datei für die Variable z.B. 'abc.h','abc.h|def.h','extern char var'
% q.sim_def_var_par(i).vartype   'C' oder 'C++', default 'C' für include
% q.sim_def_var_par(i).varformat C-Format von varname float, ...
% q.sim_def_var_par(i).varunit   Einheit für varname
% q.sim_def_var_par(i).varval    'cperm','cinit0','cinit1'
%
%==========================================================================
% Code-Stücke, die in fkt_MODUL_SIM.cpp bzw. fkt_VPU_CAN_SIM.cpp eingefügt
% werden:
%
% q.sim_def_fkt_code.include     cell array mit Includezeilen z.B.
%                                           {'#include "abc.h"','float Dabd;','float InitDabd(void);'}
%                                oder text-Datei mit den Includezeilen
% q.sim_def_fkt_code.init        cell array mit Fkt-Aufruf in Init z.B.
%                                           {'Dabd = InitDabd();','runInit(&Dabd);'}
%                                oder text-Datei mit den Init-Fkt-Zeilen
% q.sim_def_fkt_code.loop        cell array mit Fkt-Aufruf in Loop z.B.
%                                           {'Dabd += 10.f;','runLoop(&Dabd);'}
%                                oder text-Datei mit den Loop-Fkt-Zeilen
% q.sim_def_fkt_code.end         cell array mit Fkt-Aufruf in End z.B.
%                                           {'runDone();'}
%                                oder text-Datei mit den End-Fkt-Zeilen
% q.sim_def_fkt_code.add         cell array mit zusätzlichem Coden z.B.
%                                           {'float InitDabd(void)','{','return 0.f;','}'}
%                                oder text-Datei mit den End-Fkt-Zeilen
% q.sim_def_fkt_code.h_file     cell array mit zusätzlichem Code für h-Filen z.B.
%                                           {'extern float Dabd;'}
%                                oder text-Datei mit den End-Fkt-Zeilen
%
%==========================================================================
% Das aus dem Compilieren mit VisualStudio 2008 entstandene mex-File
% kann in Matlab wie folgt aufgerufen werden
%
% q.type = 'time_step': ('mex_PROJ_NAME.mexw32','time_step_PROJ_NAME.m') PROJ_NAME ist q.proj_name
%
% Aufruf der mex-dlls:
% 
% out = run_mex_PROJ_NAME(type,in,p);
% type   value       0: make init, 1: make run, 2: done
% s      struct      enthält alle Input-Signale als Signal  oder Vektoren einer momentanen Zeit
% p      struct      Parameter
%
%--------------------------------------------------------------------------
%
% q.type = 'emodul': ('mex_PROJ_NAME.mexw32') PROJ_NAME ist q.proj_name
%
% Aufruf der mex-dlls:
% 
% e = mex_PROJ_NAME(e,p,qparam);
% e      struct      enthält Input-Signale als Vektoren mit eigener Zeitbasis
%                    siehe Hilfe e_data_read_mat()
% p      struct      enthält Parameter-Signale als Vektoren mit eigener Zeitbasis
%                    Die gleiche Beschreibung wie e
% qparam struct      Hier können weitere Steuerparameter übergeben werden
%                    Es muss übergeben werden
%                    qparam.dtloop   [s]     Loopzeit des Funktionsaufruf (default 0.01)
%                    qparam.dtout    [s]     Loopzeit der Ausgabe  (default 0.01)
%                    qparam.tend     [s]     Endzeit der Berechnung,  (default 10.)
%                                            (implizit tstart = 0.0)
%
%
%--------------------------------------------------------------------------
%
% q.type = 'modul': ('mex_PROJ_NAME.mexw32') PROJ_NAME ist q.proj_name
%
% Aufruf der mex-dlls:
% 
% e = mex_PROJ_NAME(d,p,qparam);
% d      struct      enthält Input-Signale als Vektoren mit einer Zeitbasis
%                    siehe Hilfe d_data_read_mat()
% p      struct      enthält Parameter-Signale als Vektoren mit einer Zeitbasis
%                    Die gleiche Beschreibung wie d
% qparam struct      Hier können weitere Steuerparameter übergeben werden
%                    Diese können in sim_MODUL_SIM.cpp mit deren Namen 
%                    ausgelesen werden
%
%
%--------------------------------------------------------------------------
%
% q.type = 'can_full':
%
% e = mex_PROJ_NAME(b,p,qparam);
% b      struct      enthält die CAN-Botschaften aus einer Messung
%                    siehe Hilfe b_data_read_asc()
% p      struct      enthält Parameter-Signale als Vektoren mit einer Zeitbasis
%                    Die gleiche Beschreibung wie d
% qparam struct      Hier können weitere Steuerparameter übergeben werden
%                    Diese können in sim_MODUL_SIM.cpp mit deren Namen 
%                    ausgelesen werden
% oder
% e = mex_PROJ_NAME('candatei.asc',ID,channels,p,qparam);
%
% 'candatei.asc'   char    Name der Ascii-Datei mit Pfadangabe
% ID               num     Vektorliste der einzulesenden ID Beispiel:
%                          IDs        = [hex2dec('300') ...  % G01
%                                       ;hex2dec('302') ...  % G02
%                                       ;hex2dec('304') ...  % G03
%                                       ;hex2dec('306') ...  % G04
%                                       ];
% channels         num     Vektorliste des dazugehörigen Kanals (1,2, ...)
%                          channels   = [1 ...  % G01
%                                       ;1 ...  % G02
%                                       ;1 ...  % G03
%                                       ;1 ...  % G04
%                                       ];
% p      struct      enthält Parameter-Signale als Vektoren mit einer Zeitbasis
%                    Die gleiche Beschreibung wie d
% qparam struct      Hier können weitere Steuerparameter übergeben werden
%                    Diese können in sim_MODUL_SIM.cpp mit deren Namen 
%                    ausgelesen werden
% 
%==========================================================================
% m-Files:
% alle benötigten m_files sind in einem Verzeichnis abzulegen und in dem
% path von matlab einzutragen. Das svn-Repository mit den notwendigen m-Files
% befindet sich unter: http://frd2ahjg/svn/tze/Tools/matlab/allg
% c-Files:
% Ausserdem ist in einem Unterverzeichnis
% http://frd2ahjg/svn/tze/Tools/matlab/allg/src alle c-Files enthalten
% Für die SModul-Simulation (q.type = 'smodul'):
% mex_SMODUL_SIM.cpp   Schnittstelle zu Matlab
% sim_SMODUL_SIM.cpp   Initialisierung, Input-, Output- und
%                      Parameterwerteübergabe
% fkt_SMODUL_SIM.cpp   Schnittstelle zur eigentlich eingebeteten Funktion
%                      mit init und run-Funktion. Hier muss in den
%                      Funktion der Aufruf für Applikation gemacht werden
%
% Für die EModul-Simulation (q.type = 'emodul'):
% mex_EMODUL_SIM.cpp   Schnittstelle zu Matlab
% sim_EMODUL_SIM.cpp   Initialisierung, Input-, Output- und
%                      Parameterwerteübergabe, Ablaufsteuerung
%                      Diese Datei wird mit Aufruf von build_vcproj_for_mex
%                      automatisch angepasst
% fkt_EMODUL_SIM.cpp   Schnittstelle zur eigentlich eingebeteten Funktion
%                      mit init- und loop-Funktion. Hier muss in den
%                      Funktion der Aufruf für Applikation gemacht werden
%
% Für die Modul-Simulation (q.type = 'modul'):
% mex_MODUL_SIM.cpp    Schnittstelle zu Matlab
% sim_MODUL_SIM.cpp    Initialisierung, Input-, Output- und
%                      Parameterwerteübergabe, Ablaufsteuerung
%                      Diese Datei wird mit Aufruf von build_vcproj_for_mex
%                      automatisch angepasst
% fkt_MODUL_SIM.cpp    Schnittstelle zur eigentlich eingebeteten Funktion
%                      mit init- und loop-Funktion. Hier muss in den
%                      Funktion der Aufruf für Applikation gemacht werden
%
% Für die CAN-Simulation (q.type = 'can_full')
% mex_VPU_CAN_SIM.cpp  Schnittstelle zu Matlab
% sim_VPU_CAN_SIM.cpp  Initialisierung, Input-, Output- und
%                      Parameterwerteübergabe, Ablaufsteuerung
%                      Diese Datei wird mit Aufruf von build_vcproj_for_mex
%                      automatisch angepasst
% fkt_VPU_CAN_SIM.cpp  Schnittstelle zur eigentlich eingebeteten Funktion
%                      mit init- und loop-Funktion. Über die mex-Schnittstelle
%                      wird mit einer CAN-Messung in ascii-Format simuliert.
%                      Hierfür wird in der Loop-Funktion die Berechnung der
%                      CAN-Botschaften mit der auf der VPU implemtierten Routine
%                      (CanHL_ReceivedRxHandle(channel,canRxInfoStruct[channel].Handle))
%                      behandelt. Gegebenenfalls  muss in Loop Funktion auch der 
%                      interne Funktions-Aufruf zur Funktion angepasst werden.
% Für die time-step-Simulation (q.type = 'time_step')
% mex_TIME_STEP_SIM.cpp  Schnittstelle zu Matlab
% fkt_TIME_STEP_SIM.cpp  Schnittstelle zur eigentlich eingebeteten Funktion
%                        mit init-, loop- done-Funktion. Über die mex-Schnittstelle
%==========================================================================
  okay    = 1;
  errtext = '';
  %==========================================================================
  % interne Felder
  % q.src_copy_dir                          Source-File-Verzeichnis aus matlab zum kopieren
  % q.source_files_to_copy_add                
  % q.source_files_add
  % q.inlude_dirs_add
  % q.preprocess_defs_add                   
  % q.lib_files_add
  % q.VAR_PROJ_NAME
  %==========================================================================
  q.VAR_PROJ_NAME           = '#PROJECT_NAME#';
  q.VC_FILTER_NAME          = 'source';

  %==========================================================================
  % check input
  %==========================================================================
  q = build_vcproj_for_mex_Simulation_check_input(q);
  %==========================================================================  
  
  %==========================================================================
  % collect source, include etc.
  % add mex_*.cpp, sim_*.cpp, fkt_*.cpp
  %==========================================================================
  q = build_vcproj_for_mex_Simulation_collect(q);
  %==========================================================================  
  
  %==========================================================================
  % RTAS-SSW und RTAS-Module vorbereiten und in source-liste eintragen
  %==========================================================================  
  % q.rtas_ssw_platform     char    yes       RTAS-SSW-Platform bisher nur vpu defaut:'vpu-cg';
  % q.rtas_ssw_type_name    char    yes       RTAS-SSW-type name               default:'default';
  % q.rtas_ssw_config_name  char    no        RTAS-SSW-configuration-name      example 'had'
  if( q.use_rtas_code )
    q.rtas_build_source_for_vcproj = 1;
    q = build_vcproj_for_mex_Simulation_rtas_ssw(q);
  end
  %==========================================================================  

  %==========================================================================
  % vcproj-File bilden/editieren
  %==========================================================================  
  if( strcmpi(q.vc_version,'VC9') )
    
    VC9_build_sln_vcproj(q.vc_sln_file,q.vc_proj_file,q.vc_sln_write,q.proj_name ...
                        ,q.source_files ...
                        ,q.include_dirs ...
                        ,q.preprocess_defs ...
                        ,q.lib_files ...
                        ,q.lib_dirs);
                      
    % Solution ausführen vorbereiten
    %-------------------------------
    if( q.build_mex )
      q.vc_mex_m_file = VC9_build_vc_mex(q.proj_name,q.vc_proj_file,pwd,'debug');
    end
    
  elseif( strcmpi(q.vc_version,'VC11') )
    
    VC11_build_sln_vcproj(q.vc_sln_file,q.vc_proj_file,q.vc_filters_file,0,q.vc_sln_write,q.proj_name ...
                        ,q.source_files ...
                        ,q.include_dirs ...
                        ,q.preprocess_defs ...
                        ,q.lib_files ...
                        ,q.lib_dirs);
                      
    % Solution ausführen vorbereiten
    %-------------------------------
    if( q.build_mex )
      q.vc_mex_m_file = VC11_build_vc_mex(q.proj_name,q.vc_proj_file,pwd,'debug');
    end
    
  elseif( strcmpi(q.vc_version,'VC14') )
    
    f = mfilename('fullpath');
    s_file = str_get_pfe_f(f);
    
    if( strcmp(q.type,'time_step') )
      sln_proto       = fullfile(s_file.dir,'src_modul','VC14_MEX_TIME_STEP_SIM.sln');
      vcxproj_proto   = fullfile(s_file.dir,'src_modul','VC14_MEX_TIME_STEP_SIM.vcxproj');
      vcfilters_proto = fullfile(s_file.dir,'src_modul','VC14_MEX_TIME_STEP_SIM.vcxproj.filters');
    else
      sln_proto       = fullfile(s_file.dir,'src_modul','VC14_MEX_VPU_CAN_SIM.sln');
      vcxproj_proto   = fullfile(s_file.dir,'src_modul','VC14_MEX_VPU_CAN_SIM.vcxproj');
      vcfilters_proto = fullfile(s_file.dir,'src_modul','VC14_MEX_VPU_CAN_SIM.vcxproj.filters');
    end
    
    VC14_build_sln_vcproj(q.vc_sln_file,q.vc_proj_file,q.vc_filters_file,0,q.vc_sln_write,q.proj_name ...
                        ,q.source_files ...
                        ,q.include_dirs ...
                        ,q.preprocess_defs ...
                        ,q.lib_files ...
                        ,q.lib_dirs,sln_proto,vcxproj_proto,vcfilters_proto);
                      
    % Solution ausführen vorbereiten
    %-------------------------------
    if( q.build_mex )
      q.vc_mex_m_file = VC14_build_vc_mex(q.proj_name,q.vc_proj_file,pwd,'debug');
    end
    
  else
    error('%s_error: VisualC-Version=<%s> ist nicht vorhanden',mfilename,q.vc_version);
  end
  %==========================================================================  
  
  %==========================================================================
  % Eingabe/Ausgabe im Code konfigurieren
  %------------------------------
  
  % 1) CAN-Simulation, d.h Funktionsaufrauf der des CAN-Inputs (VPU)
  %    und Funktionsaufruf aus VPU
  %    Rückgabe e-Struktur-Daten
  if( strcmp(q.type,'can_full') )
    q = build_vcproj_for_mex_sim_can_full_io(q);
  % 2) Modul-Simulation, Input über Übergabe von d-Struktur Vektoren
  %    Rückgabe wie CAN-Simulation mit e-Struktur-Daten
  elseif( strcmp(q.type,'modul') )
    q = build_vcproj_for_mex_sim_modul_io(q);
  % 3) EModul-Simulation, Input über Übergabe von e-Struktur Vektoren
  %    Rückgabe wie CAN-Simulation mit e-Struktur-Daten
  elseif( strcmp(q.type,'emodul') )
    q = build_vcproj_for_mex_sim_emodul_io(q);
  % 4) time_step-Simulation, Input über Übergabe von s-Struktur Vektoren
  %    Rückgabe s-strukturen
  elseif( strcmp(q.type,'time_step') )
    q = build_vcproj_for_mex_sim_time_step_io(q);
  else
    error('Der Typ <%s> ist noch nicht festgelegt !!!',q.type);
  end
  
  %==========================================================================
  % mex-File erstellen mit vcbuild erstellen
  %-----------------------------------------
%   clear s_frage
%   s_frage.comment   = sprintf('Soll %s mit vcbuild erstellt werden?',q.vc_proj_file);
%   s_frage.def_value = 'n';
%   flag = o_abfragen_jn_button_f(s_frage);
%   if( flag )
%     if( strcmpi(q.vc_version,'VC9') )
%       c = {'"%VS90COMNTOOLS%..\..\vc\bin\vcvars32.bat"' ...
%           ,sprintf('vcbuild %s',q.vc_proj_file) ...
%           };
% 
%       okay = write_ascii_file('abcdefghi.cmd',c);
%       if( ~okay )
%         error('%s_error: Fehler bei Schreiben von abcdefghi.cmd: ',mfilename);
%       end
%       
%       
%     else
%       error('%s_error: VisualC-Version=<%s> ist nicht vorhanden',mfilename,q.vc_version);
%     end
%   end

  
  %========================================================================
  % vcproj-Ende
  %-------------------------------
  if( strcmpi(q.vc_version,'VC9') )
    fprintf('VC2009 vcproj-File: <%s> gebildet !\n',q.vc_proj_file)
  elseif( strcmpi(q.vc_version,'VC11') )
    fprintf('VC2012 vcproj-File: <%s> gebildet !\n',q.vc_proj_file)
  elseif( strcmpi(q.vc_version,'VC14') )
    fprintf('VC2015 vcproj-File: <%s> gebildet !\n',q.vc_proj_file)
  end
  
  % Solution ausführen vorbereiten
  %-------------------------------
  if( q.build_mex == 2 )
      fprintf('m-File: <%s> ausführen !\n',q.vc_mex_m_file)
      command = sprintf('run %s',q.vc_mex_m_file);
      eval(command);
  elseif( q.build_mex == 1 )
      fprintf('m-File: <%s> gebildet !\n',q.vc_mex_m_file)
  end

  %========================================================================
  % Ende
  %-------------------------------
  
end
